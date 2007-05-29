Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbXE2Occ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbXE2Occ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXE2OcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:32:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:38413 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbXE2OcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:32:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=sAU65Abzt1l7bpCHJ0XppWtCfznuxBIa89pfrbIBNhwiv1GZ3lB0S3167y0KJ9tY6dL8ISdPlE7D8C/VBr/5Syoj/gAJvELw2rP472lkXHl6Yeu4wUKTmQMh9J3XskXRK/cgHRZNdrkVJO1fye9oEa8IveNRAXoc7e0hRbhLIO8=
Message-ID: <465C3973.3090303@gmail.com>
Date: Tue, 29 May 2007 15:32:19 +0100
From: Michael-Luke Jones <mike.luke.jones@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dwmw2@infradead.org
Subject: [-mm] Move zlib compression library to common directory
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the zlib compression and decompression code
to a common directory. The zutil.h header, which is not meant
to be public, is moved from include/linux/ to lib/zlib/.

In addition, the PRESET_DICT definition from zutil.h, used by 
fs/jffs2/compr_zlib.c is moved to the 'true' public zlib header
include/linux/zlib.h. This move is documented in comments.

Conditional compile of only inflate or deflate code is
preserved by this patch.

Signed-off-by: Michael-Luke Jones <mike.luke.jones@gmail.com>

diff --git a/fs/jffs2/compr_zlib.c b/fs/jffs2/compr_zlib.c
index 2b87fcc..e2cc6c7 100644
--- a/fs/jffs2/compr_zlib.c
+++ b/fs/jffs2/compr_zlib.c
@@ -16,7 +16,6 @@
  #include <linux/kernel.h>
  #include <linux/slab.h>
  #include <linux/zlib.h>
-#include <linux/zutil.h>
  #include "nodelist.h"
  #include "compr.h"

diff --git a/include/linux/zlib.h b/include/linux/zlib.h
index 9e3192a..e9d32c5 100644
--- a/include/linux/zlib.h
+++ b/include/linux/zlib.h
@@ -177,6 +177,9 @@ typedef z_stream *z_streamp;
  #define Z_DEFLATED   8
  /* The deflate compression method (the only one supported in this 
version) */

+#define PRESET_DICT 0x20 /* preset dictionary flag in zlib header */
+/* Required by fs/jffs2/compr_zlib.c */
+
                          /* basic functions */

  extern int zlib_deflate_workspacesize (void);
diff --git a/lib/Makefile b/lib/Makefile
index c8c8e20..42c3903 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -46,8 +46,8 @@ obj-$(CONFIG_CRC32)	+= crc32.o
  obj-$(CONFIG_LIBCRC32C)	+= libcrc32c.o
  obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o

-obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate/
-obj-$(CONFIG_ZLIB_DEFLATE) += zlib_deflate/
+obj-$(CONFIG_ZLIB_INFLATE) += zlib/
+obj-$(CONFIG_ZLIB_DEFLATE) += zlib/
  obj-$(CONFIG_REED_SOLOMON) += reed_solomon/

  obj-$(CONFIG_TEXTSEARCH) += textsearch.o
diff --git a/lib/zlib_inflate/Makefile b/lib/zlib/Makefile
similarity index 71%
rename from lib/zlib_inflate/Makefile
rename to lib/zlib/Makefile
index bf06548..528d903 100644
--- a/lib/zlib_inflate/Makefile
+++ b/lib/zlib/Makefile
@@ -2,8 +2,8 @@
  # This is a modified version of zlib, which does all memory
  # allocation ahead of time.
  #
-# This is only the decompression, see zlib_deflate for the
-# the compression
+# The compression (deflate) and decompression (inflate) code
+# is present in this folder.
  #
  # Decompression needs to be serialized for each memory
  # allocation.
@@ -17,3 +17,7 @@ obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate.o

  zlib_inflate-objs := inffast.o inflate.o \
  		     inftrees.o inflate_syms.o
+
+obj-$(CONFIG_ZLIB_DEFLATE) += zlib_deflate.o
+
+zlib_deflate-objs := deflate.o deftree.o deflate_syms.o
diff --git a/lib/zlib_deflate/deflate.c b/lib/zlib/deflate.c
similarity index 100%
rename from lib/zlib_deflate/deflate.c
rename to lib/zlib/deflate.c
index c3e4a2b..1137780 100644
--- a/lib/zlib_deflate/deflate.c
+++ b/lib/zlib/deflate.c
@@ -49,10 +49,9 @@
   */

  #include <linux/module.h>
-#include <linux/zutil.h>
+#include "zutil.h"
  #include "defutil.h"

-
  /* 
===========================================================================
   *  Function prototypes.
   */
diff --git a/lib/zlib_deflate/deflate_syms.c b/lib/zlib/deflate_syms.c
similarity index 100%
rename from lib/zlib_deflate/deflate_syms.c
rename to lib/zlib/deflate_syms.c
diff --git a/lib/zlib_deflate/deftree.c b/lib/zlib/deftree.c
similarity index 100%
rename from lib/zlib_deflate/deftree.c
rename to lib/zlib/deftree.c
index ddf3482..d5ce87d 100644
--- a/lib/zlib_deflate/deftree.c
+++ b/lib/zlib/deftree.c
@@ -34,7 +34,7 @@

  /* #include "deflate.h" */

-#include <linux/zutil.h>
+#include "zutil.h"
  #include "defutil.h"

  #ifdef DEBUG_ZLIB
diff --git a/lib/zlib_deflate/defutil.h b/lib/zlib/defutil.h
similarity index 100%
rename from lib/zlib_deflate/defutil.h
rename to lib/zlib/defutil.h
diff --git a/lib/zlib_inflate/inffast.c b/lib/zlib/inffast.c
similarity index 100%
rename from lib/zlib_inflate/inffast.c
rename to lib/zlib/inffast.c
index d84560c..50d3de1 100644
--- a/lib/zlib_inflate/inffast.c
+++ b/lib/zlib/inffast.c
@@ -3,7 +3,7 @@
   * For conditions of distribution and use, see copyright notice in zlib.h
   */

-#include <linux/zutil.h>
+#include "zutil.h"
  #include "inftrees.h"
  #include "inflate.h"
  #include "inffast.h"
diff --git a/lib/zlib_inflate/inffast.h b/lib/zlib/inffast.h
similarity index 100%
rename from lib/zlib_inflate/inffast.h
rename to lib/zlib/inffast.h
diff --git a/lib/zlib_inflate/inffixed.h b/lib/zlib/inffixed.h
similarity index 100%
rename from lib/zlib_inflate/inffixed.h
rename to lib/zlib/inffixed.h
diff --git a/lib/zlib_inflate/inflate.c b/lib/zlib/inflate.c
similarity index 100%
rename from lib/zlib_inflate/inflate.c
rename to lib/zlib/inflate.c
index 7e1e311..ba58871 100644
--- a/lib/zlib_inflate/inflate.c
+++ b/lib/zlib/inflate.c
@@ -9,7 +9,7 @@
   *
   */

-#include <linux/zutil.h>
+#include "zutil.h"
  #include "inftrees.h"
  #include "inflate.h"
  #include "inffast.h"
diff --git a/lib/zlib_inflate/inflate.h b/lib/zlib/inflate.h
similarity index 100%
rename from lib/zlib_inflate/inflate.h
rename to lib/zlib/inflate.h
diff --git a/lib/zlib_inflate/inflate_syms.c b/lib/zlib/inflate_syms.c
similarity index 100%
rename from lib/zlib_inflate/inflate_syms.c
rename to lib/zlib/inflate_syms.c
diff --git a/lib/zlib_inflate/inftrees.c b/lib/zlib/inftrees.c
similarity index 100%
rename from lib/zlib_inflate/inftrees.c
rename to lib/zlib/inftrees.c
index 3fe6ce5..faf6f75 100644
--- a/lib/zlib_inflate/inftrees.c
+++ b/lib/zlib/inftrees.c
@@ -3,7 +3,7 @@
   * For conditions of distribution and use, see copyright notice in zlib.h
   */

-#include <linux/zutil.h>
+#include "zutil.h"
  #include "inftrees.h"

  #define MAXBITS 15
diff --git a/lib/zlib_inflate/inftrees.h b/lib/zlib/inftrees.h
similarity index 100%
rename from lib/zlib_inflate/inftrees.h
rename to lib/zlib/inftrees.h
diff --git a/lib/zlib_inflate/infutil.h b/lib/zlib/infutil.h
similarity index 100%
rename from lib/zlib_inflate/infutil.h
rename to lib/zlib/infutil.h
diff --git a/lib/zlib/patch-zlib b/lib/zlib/patch-zlib
new file mode 100644
index 0000000..d4a011b
Binary files /dev/null and b/lib/zlib/patch-zlib differ
diff --git a/include/linux/zutil.h b/lib/zlib/zutil.h
similarity index 98%
rename from include/linux/zutil.h
rename to lib/zlib/zutil.h
index 6adfa9a..0467c8c 100644
--- a/include/linux/zutil.h
+++ b/lib/zlib/zutil.h
@@ -32,7 +32,7 @@ typedef unsigned long  ulg;
  #define MAX_MATCH  258
  /* The minimum and maximum match lengths */

-#define PRESET_DICT 0x20 /* preset dictionary flag in zlib header */
+/* PRESET_DICT #define moved to <linux/zlib.h> for JFFS2 */

          /* target dependencies */

diff --git a/lib/zlib_deflate/Makefile b/lib/zlib_deflate/Makefile
deleted file mode 100644
index 86275e3..0000000
--- a/lib/zlib_deflate/Makefile
+++ /dev/null
@@ -1,11 +0,0 @@
-#
-# This is a modified version of zlib, which does all memory
-# allocation ahead of time.
-#
-# This is the compression code, see zlib_inflate for the
-# decompression code.
-#
-
-obj-$(CONFIG_ZLIB_DEFLATE) += zlib_deflate.o
-
-zlib_deflate-objs := deflate.o deftree.o deflate_syms.o

