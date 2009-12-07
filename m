Return-Path: <linux-kernel-owner+w=401wt.eu-S934798AbZLGItk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934798AbZLGItk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934789AbZLGItg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:49:36 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:56835 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934756AbZLGItd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:49:33 -0500
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       phillip.lougher@gmail.com, tim.bird@am.sony.com
Subject: [PATCH 07/9] lzma: Make lzma available to non initramfs/initrd code
Message-Id: <E1NHYuo-00028i-Ex@dylan.lougher.demon.co.uk>
From: root <root@lougher.demon.co.uk>
Date: Mon, 07 Dec 2009 08:25:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a config option DECOMPRESS_LZMA_NEEDED which allows subsystems to
specify they need the unlzma code.  Normally decompress_unlzma.c is
compiled with __init and unlzma is not exported to modules.

Move INIT definition into separate header files for bzip2/lzma/inflate
so it can be defined differently for each decompressor.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 include/linux/decompress/bunzip2_mm.h |   12 ++++++++++++
 include/linux/decompress/inflate_mm.h |   12 ++++++++++++
 include/linux/decompress/mm.h         |    3 ---
 include/linux/decompress/unlzma_mm.h  |   20 ++++++++++++++++++++
 lib/Kconfig                           |    3 +++
 lib/decompress_bunzip2.c              |    1 +
 lib/decompress_inflate.c              |    1 +
 lib/decompress_unlzma.c               |    6 +++++-
 8 files changed, 54 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/decompress/bunzip2_mm.h
 create mode 100644 include/linux/decompress/inflate_mm.h
 create mode 100644 include/linux/decompress/unlzma_mm.h

diff --git a/include/linux/decompress/bunzip2_mm.h b/include/linux/decompress/bunzip2_mm.h
new file mode 100644
index 0000000..cac6fef
--- /dev/null
+++ b/include/linux/decompress/bunzip2_mm.h
@@ -0,0 +1,12 @@
+#ifndef BUNZIP2_MM_H
+#define BUNZIP2_MM_H
+
+#ifdef STATIC
+/* Code active when included from pre-boot environment: */
+#define INIT
+#else
+/* Compile for initramfs/initrd code only */
+#define INIT __init
+#endif
+
+#endif
diff --git a/include/linux/decompress/inflate_mm.h b/include/linux/decompress/inflate_mm.h
new file mode 100644
index 0000000..ca4a2ae
--- /dev/null
+++ b/include/linux/decompress/inflate_mm.h
@@ -0,0 +1,12 @@
+#ifndef INFLATE_MM_H
+#define INFLATE_MM_H
+
+#ifdef STATIC
+/* Code active when included from pre-boot environment: */
+#define INIT
+#else
+/* Compile for initramfs/initrd code only */
+#define INIT __init
+#endif
+
+#endif
diff --git a/include/linux/decompress/mm.h b/include/linux/decompress/mm.h
index 12ff8c3..80f5ba4 100644
--- a/include/linux/decompress/mm.h
+++ b/include/linux/decompress/mm.h
@@ -53,8 +53,6 @@ static void free(void *where)
 
 #define set_error_fn(x)
 
-#define INIT
-
 #else /* STATIC */
 
 /* Code active when compiled standalone for use when loading ramdisk: */
@@ -77,7 +75,6 @@ static void free(void *where)
 static void(*error)(char *m);
 #define set_error_fn(x) error = x;
 
-#define INIT __init
 #define STATIC
 
 #include <linux/init.h>
diff --git a/include/linux/decompress/unlzma_mm.h b/include/linux/decompress/unlzma_mm.h
new file mode 100644
index 0000000..859287e
--- /dev/null
+++ b/include/linux/decompress/unlzma_mm.h
@@ -0,0 +1,20 @@
+#ifndef UNLZMA_MM_H
+#define UNLZMA_MM_H
+
+#ifdef STATIC
+
+/* Code active when included from pre-boot environment: */
+#define INIT
+
+#elif defined(CONFIG_DECOMPRESS_LZMA_NEEDED)
+
+/* Make it available to non initramfs/initrd code */
+#define INIT
+#include <linux/module.h>
+#else
+
+/* Compile for initramfs/initrd code only */
+#define INIT __init
+#endif
+
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index bb1326d..25e7f28 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -117,6 +117,9 @@ config DECOMPRESS_BZIP2
 config DECOMPRESS_LZMA
 	tristate
 
+config DECOMPRESS_LZMA_NEEDED
+	 boolean
+
 #
 # Generic allocator support is selected if needed
 #
diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 600f473..6eb6433 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -52,6 +52,7 @@
 #include <linux/slab.h>
 #endif /* STATIC */
 
+#include <linux/decompress/bunzip2_mm.h>
 #include <linux/decompress/mm.h>
 
 #ifndef INT_MAX
diff --git a/lib/decompress_inflate.c b/lib/decompress_inflate.c
index fc686c7..cb6bcab 100644
--- a/lib/decompress_inflate.c
+++ b/lib/decompress_inflate.c
@@ -23,6 +23,7 @@
 
 #endif /* STATIC */
 
+#include <linux/decompress/inflate_mm.h>
 #include <linux/decompress/mm.h>
 
 #define GZIP_IOBUF_SIZE (16*1024)
diff --git a/lib/decompress_unlzma.c b/lib/decompress_unlzma.c
index ca82fde..a614b26 100644
--- a/lib/decompress_unlzma.c
+++ b/lib/decompress_unlzma.c
@@ -36,6 +36,7 @@
 #include <linux/slab.h>
 #endif /* STATIC */
 
+#include <linux/decompress/unlzma_mm.h>
 #include <linux/decompress/mm.h>
 
 #define	MIN(a, b) (((a) < (b)) ? (a) : (b))
@@ -531,7 +532,7 @@ static inline void INIT process_bit1(struct writer *wr, struct rc *rc,
 
 
 
-STATIC inline int INIT unlzma(unsigned char *buf, int in_len,
+STATIC int INIT unlzma(unsigned char *buf, int in_len,
 			      int(*fill)(void*, unsigned int),
 			      int(*flush)(void*, unsigned int),
 			      unsigned char *output,
@@ -652,6 +653,9 @@ exit_1:
 exit_0:
 	return ret;
 }
+#if defined(CONFIG_DECOMPRESS_LZMA_NEEDED) && !defined(PREBOOT)
+EXPORT_SYMBOL(unlzma);
+#endif
 
 #ifdef PREBOOT
 STATIC int INIT decompress(unsigned char *buf, int in_len,
-- 
1.6.3.3

