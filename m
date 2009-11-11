Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZKKM2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZKKM2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 07:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbZKKM2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 07:28:25 -0500
Received: from mail.free-electrons.com ([88.191.76.200]:49178 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZKKM2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 07:28:09 -0500
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: akpm@linux-foundation.org
Cc: hpa@zytor.com, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: [PATCH v3 4/4] Add LZO compression support for initramfs and old-style initrd
Date: Wed, 11 Nov 2009 13:27:58 +0100
Message-Id: <1257942478-18719-5-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1257942478-18719-4-git-send-email-albin.tonnerre@free-electrons.com>
References: <1257942478-18719-1-git-send-email-albin.tonnerre@free-electrons.com>
 <1257942478-18719-2-git-send-email-albin.tonnerre@free-electrons.com>
 <1257942478-18719-3-git-send-email-albin.tonnerre@free-electrons.com>
 <1257942478-18719-4-git-send-email-albin.tonnerre@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
---
 lib/Kconfig      |    4 ++++
 lib/Makefile     |    1 +
 lib/decompress.c |    5 +++++
 usr/Kconfig      |   26 +++++++++++++++++++++-----
 4 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index bb1326d..8639349 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -117,6 +117,10 @@ config DECOMPRESS_BZIP2
 config DECOMPRESS_LZMA
 	tristate
 
+config DECOMPRESS_LZO
+	select LZO_DECOMPRESS
+	tristate
+
 #
 # Generic allocator support is selected if needed
 #
diff --git a/lib/Makefile b/lib/Makefile
index 2e78277..cfa4041 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_LZO_DECOMPRESS) += lzo/
 lib-$(CONFIG_DECOMPRESS_GZIP) += decompress_inflate.o
 lib-$(CONFIG_DECOMPRESS_BZIP2) += decompress_bunzip2.o
 lib-$(CONFIG_DECOMPRESS_LZMA) += decompress_unlzma.o
+lib-$(CONFIG_DECOMPRESS_LZO) += decompress_unlzo.o
 
 obj-$(CONFIG_TEXTSEARCH) += textsearch.o
 obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o
diff --git a/lib/decompress.c b/lib/decompress.c
index d2842f5..a760681 100644
--- a/lib/decompress.c
+++ b/lib/decompress.c
@@ -9,6 +9,7 @@
 #include <linux/decompress/bunzip2.h>
 #include <linux/decompress/unlzma.h>
 #include <linux/decompress/inflate.h>
+#include <linux/decompress/unlzo.h>
 
 #include <linux/types.h>
 #include <linux/string.h>
@@ -22,6 +23,9 @@
 #ifndef CONFIG_DECOMPRESS_LZMA
 # define unlzma NULL
 #endif
+#ifndef CONFIG_DECOMPRESS_LZO
+# define unlzo NULL
+#endif
 
 static const struct compress_format {
 	unsigned char magic[2];
@@ -32,6 +36,7 @@ static const struct compress_format {
 	{ {037, 0236}, "gzip", gunzip },
 	{ {0x42, 0x5a}, "bzip2", bunzip2 },
 	{ {0x5d, 0x00}, "lzma", unlzma },
+	{ {0x89, 0x4c}, "lzo", unlzo },
 	{ {0, 0}, NULL, NULL }
 };
 
diff --git a/usr/Kconfig b/usr/Kconfig
index 1c3039f..e2721f5 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -72,6 +72,15 @@ config RD_LZMA
 	  Support loading of a LZMA encoded initial ramdisk or cpio buffer
 	  If unsure, say N.
 
+config RD_LZO
+	bool "Support initial ramdisks compressed using LZO" if EMBEDDED
+	default !EMBEDDED
+	depends on BLK_DEV_INITRD
+	select DECOMPRESS_LZO
+	help
+	  Support loading of a LZO encoded initial ramdisk or cpio buffer
+	  If unsure, say N.
+
 choice
 	prompt "Built-in initramfs compression mode" if INITRAMFS_SOURCE!=""
 	help
@@ -108,16 +117,15 @@ config INITRAMFS_COMPRESSION_GZIP
 	bool "Gzip"
 	depends on RD_GZIP
 	help
-	  The old and tried gzip compression. Its compression ratio is
-	  the poorest among the 3 choices; however its speed (both
-	  compression and decompression) is the fastest.
+	  The old and tried gzip compression. It provides a good balance
+	  between compression ratio and decompression speed.
 
 config INITRAMFS_COMPRESSION_BZIP2
 	bool "Bzip2"
 	depends on RD_BZIP2
 	help
 	  Its compression ratio and speed is intermediate.
-	  Decompression speed is slowest among the three.  The initramfs
+	  Decompression speed is slowest among the four.  The initramfs
 	  size is about 10% smaller with bzip2, in comparison to gzip.
 	  Bzip2 uses a large amount of memory. For modern kernels you
 	  will need at least 8MB RAM or more for booting.
@@ -128,7 +136,15 @@ config INITRAMFS_COMPRESSION_LZMA
 	help
 	  The most recent compression algorithm.
 	  Its ratio is best, decompression speed is between the other
-	  two. Compression is slowest.	The initramfs size is about 33%
+	  three. Compression is slowest. The initramfs size is about 33%
 	  smaller with LZMA in comparison to gzip.
 
+config INITRAMFS_COMPRESSION_LZO
+	bool "LZO"
+	depends on RD_LZO
+	help
+	  Its compression ratio is the poorest among the four. The kernel
+	  size is about about 10% bigger than gzip; however its speed
+	  (both compression and decompression) is the fastest.
+
 endchoice
-- 
1.6.3.3

