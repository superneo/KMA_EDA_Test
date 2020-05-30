# get_kma_data.R
#
# Purpose: to retrieve the KMA raw data
#
# Author: superneo (superneo77@gmail.com)
# License: TBD
#
# Date: 2020-05
#
# Version: 1.0
# Version history:
#   1.0  initial version
#
# ==============================================================================

if ("here" %in% rownames(installed.packages()) == FALSE) {
  install.packages("here")
}

library(here)

KMA_read <- FALSE
df_KMA <- NULL

get_whole_KMA <- function() {
  if (KMA_read && !is.null(df_KMA)) {
    print("KMA dataframe is ready already!")
    return(df_KMA)
  }

  file_path <- paste0(here(),
                      '/data/SEOUL_2011_2020_OBS_ASOS_DD_20200519161355.csv')
  df <- read.csv(file_path)
  #str(df)
  assign("df_KMA", df, envir = .GlobalEnv)
  assign("KMA_read", TRUE, envir = .GlobalEnv)

  return(df_KMA)
}

get_partial_KMA <- function(year_start, year_end) {
  if (!KMA_read || is.null(df_KMA)) {
    #print("KMA dataframe must be ready in advance!")
    #return(NULL)
    get_whole_KMA()
  }

  if (year_start > year_end) {
    print(paste0("[ERROR] year_start(", year_start,
                 ") exceeds year_end(", year_end, ")"))
    return(NULL)
  }

  if (year_start < 2011 || year_end > 2020) {
    print("[ERROR] 2011 <= yeart_start and year_end <= 2020")
    return(NULL)
  }

  years <- unlist(lapply(year_start:year_end, as.character))
  idcs <- lapply(df_KMA[,3],
                 function(x) { sum(startsWith(x, years)) > 0 })
  subframe <- df_KMA[unlist(idcs),]
  rownames(subframe) <- NULL

  return(subframe)
}

# ====  TESTS  =================================================================

if (FALSE) {
  print(paste('Project root:', here()))
  get_whole_KMA()
  get_partial_KMA(2019, 2018)
}
