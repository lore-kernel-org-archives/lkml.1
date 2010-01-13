Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324Ab0AMUWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab0AMUWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 15:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035Ab0AMUWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 15:22:50 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:52176 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755152Ab0AMUWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 15:22:49 -0500
Date: Wed, 13 Jan 2010 20:21:28 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: phillip.lougher@gmail.com
Subject: [PATCH V3 1/2] lzma: Make lzma available to non initramfs/initrd
 code
Message-ID: <4b4e2b48.p+NmGLvHpBsRAjTU%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a config option DECOMPRESS_LZMA_NEEDED which allows subsystems to
specify they need the unlzma code.  Normally decompress_unlzma.c is
compiled with __init and unlzma is not exported to modules.

Move INIT definition into separate header files for bzip2/lzma/inflate/lzo
so it can be defined differently for each decompressor.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 include/linux/decompress/bunzip2_mm.h |   12 ++++++++++++
 include/linux/decompress/inflate_mm.h |   12 ++++++++++++
 include/linux/decompress/mm.h         |    3 ---
 include/linux/decompress/unlzma_mm.h  |   20 ++++++++++++++++++++
 include/linux/decompress/unlzo_mm.h   |   12 ++++++++++++
 lib/Kconfig                           |    3 +++
 lib/decompress_bunzip2.c              |    1 +
 lib/decompress_inflate.c              |    1 +
 lib/decompress_unlzma.c               |    6 +++++-
 lib/decompress_unlzo.c                |    1 +
 10 files changed, 67 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/decompress/bunzip2_mm.h
 create mode 100644 include/linux/decompress/inflate_mm.h
 create mode 100644 include/linux/decompress/unlzma_mm.h
 create mode 100644 include/linux/decompress/unlzo_mm.h

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
index 5032b9a..93dd574 100644
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
diff --git a/include/linux/decompress/unlzo_mm.h b/include/linux/decompress/unlzo_mm.h
new file mode 100644
index 0000000..e3f1573
--- /dev/null
+++ b/include/linux/decompress/unlzo_mm.h
@@ -0,0 +1,12 @@
+#ifndef UNLZO_MM_H
+#define UNLZO_MM_H
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
diff --git a/lib/Kconfig b/lib/Kconfig
index 97b136f..40e92e2 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -121,6 +121,9 @@ config DECOMPRESS_LZO
 	select LZO_DECOMPRESS
 	tristate
 
+config DECOMPRESS_LZMA_NEEDED
+	 boolean
+
 #
 # Generic allocator support is selected if needed
 #
diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index a4e971d..04386b3 100644
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
diff --git a/lib/decompress_unlzo.c b/lib/decompress_unlzo.c
index db521f4..96543db 100644
--- a/lib/decompress_unlzo.c
+++ b/lib/decompress_unlzo.c
@@ -34,6 +34,7 @@
 #include "lzo/lzo1x_decompress.c"
 #else
 #include <linux/slab.h>
+#include <linux/decompress/unlzo_mm.h>
 #include <linux/decompress/unlzo.h>
 #endif
 
-- 
1.6.3.3



