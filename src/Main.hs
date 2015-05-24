{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString.Char8 as B8
import           Data.Monoid ((<>))
import           Foreign.C.String as CString
import           Foreign.C.Types
import qualified Language.C.Inline as C
import qualified Language.C.Inline.Unsafe as CU

C.context (C.baseCtx <> C.bsCtx)

C.include "<stdlib.h>"
C.include "v8wrapper.h"

run :: B8.ByteString -> IO CString
run js = [C.block|
    char * {
      return runv8($bs-ptr:js);
    }
  |]

main :: IO ()
main = do
  js  <- getContents
  putStrLn js
  cs  <- run $ B8.pack js
  res <- CString.peekCString cs
  putStrLn res

