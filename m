Return-Path: <linux-kernel-owner+w=401wt.eu-S1762242AbZAHXag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762242AbZAHXag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 18:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbZAHX3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 18:29:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33037 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbZAHX3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 18:29:13 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: Alain Knaff <alain@knaff.lu>, Sam Ravnborg <sam@ravnborg.org>,
       x86@kernel.org
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] bzip2/lzma: centralize format detection
Date: Thu,  8 Jan 2009 15:29:00 -0800
Message-Id: <1231457340-18045-4-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1231457340-18045-3-git-send-email-hpa@zytor.com>
References: <1231457340-18045-1-git-send-email-hpa@zytor.com>
 <1231457340-18045-2-git-send-email-hpa@zytor.com>
 <1231457340-18045-3-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centralize the compression format detection to a common routine in the
lib directory, and use it for both initramfs and initrd.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/linux/decompress/generic.h |    3 ++
 init/do_mounts_rd.c                |   38 +++++----------------------
 init/initramfs.c                   |   39 +++++-----------------------
 lib/Makefile                       |    9 +++---
 lib/decompress.c                   |   50 ++++++++++++++++++++++++++++++++++++
 5 files changed, 72 insertions(+), 67 deletions(-)
 create mode 100644 lib/decompress.c

diff --git a/include/linux/decompress/generic.h b/include/linux/decompress/generic.h
index f847f51..6dfb856 100644
--- a/include/linux/decompress/generic.h
+++ b/include/linux/decompress/generic.h
@@ -26,5 +26,8 @@ typedef int (*decompress_fn) (unsigned char *inbuf, int len,
  *fill should be called (repeatedly...) to read data, at most IOBUF_SIZE
  */
 
+/* Utility routine to detect the decompression method */
+decompress_fn decompress_method(const unsigned char *inbuf, int len,
+				const char **name);
 
 #endif
diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index 9c9d7db..a06ed4f 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -12,9 +12,6 @@
 
 #include <linux/decompress/generic.h>
 
-#include <linux/decompress/bunzip2.h>
-#include <linux/decompress/unlzma.h>
-#include <linux/decompress/inflate.h>
 
 int __initdata rd_prompt = 1;/* 1 = prompt for RAM disk, 0 = don't prompt */
 
@@ -49,24 +46,6 @@ static int __init crd_load(int in_fd, int out_fd, decompress_fn deco);
  *	cramfs
  *	gzip
  */
-static const struct compress_format {
-	unsigned char magic[2];
-	const char *name;
-	decompress_fn decompressor;
-} compressed_formats[] = {
-#ifdef CONFIG_RD_GZIP
-	{ {037, 0213}, "gzip", gunzip },
-	{ {037, 0236}, "gzip", gunzip },
-#endif
-#ifdef CONFIG_RD_BZIP2
-	{ {0x42, 0x5a}, "bzip2", bunzip2 },
-#endif
-#ifdef CONFIG_RD_LZMA
-	{ {0x5d, 0x00}, "lzma", unlzma },
-#endif
-	{ {0, 0}, NULL, NULL }
-};
-
 static int __init
 identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
 {
@@ -77,7 +56,7 @@ identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
 	struct cramfs_super *cramfsb;
 	int nblocks = -1;
 	unsigned char *buf;
-	const struct compress_format *cf;
+	const char *compress_name;
 
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf)
@@ -95,15 +74,12 @@ identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
 	sys_lseek(fd, start_block * BLOCK_SIZE, 0);
 	sys_read(fd, buf, size);
 
-	for (cf = compressed_formats; cf->decompressor; cf++) {
-		if (buf[0] == cf->magic[0] && buf[1] == cf->magic[1]) {
-			printk(KERN_NOTICE
-			       "RAMDISK: %s image found at block %d\n",
-			       cf->name, start_block);
-			*decompressor = cf->decompressor;
-			nblocks = 0;
-			goto done;
-		}
+	*decompressor = decompress_method(buf, size, &compress_name);
+	if (*decompressor) {
+		printk(KERN_NOTICE "RAMDISK: %s image found at block %d\n",
+		       compress_name, start_block);
+		nblocks = 0;
+		goto done;
 	}
 
 	/* romfs is at block zero too */
diff --git a/init/initramfs.c b/init/initramfs.c
index a3ba91c..2f42984 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -416,13 +416,13 @@ static int __init flush_buffer(void *bufv, unsigned len)
 
 static unsigned my_inptr;   /* index of next byte to be processed in inbuf */
 
-#include <linux/decompress/bunzip2.h>
-#include <linux/decompress/unlzma.h>
-#include <linux/decompress/inflate.h>
+#include <linux/decompress/generic.h>
 
 static char * __init unpack_to_rootfs(char *buf, unsigned len, int check_only)
 {
 	int written;
+	decompress_fn decompress;
+
 	dry_run = check_only;
 	header_buf = kmalloc(110, GFP_KERNEL);
 	symlink_buf = kmalloc(PATH_MAX + N_ALIGN(PATH_MAX) + 1, GFP_KERNEL);
@@ -450,35 +450,10 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len, int check_only)
 			continue;
 		}
 		this_header = 0;
-#ifdef CONFIG_RD_GZIP
-		if (!gunzip(buf, len, NULL, flush_buffer, NULL,
-			    &my_inptr, error) &&
-		    message == NULL)
-			goto ok;
-#endif
-
-#ifdef CONFIG_RD_BZIP2
-		message = NULL; /* Zero out message, or else cpio will
-				   think an error has already occured */
-		if (!bunzip2(buf, len, NULL, flush_buffer, NULL,
-			     &my_inptr, error) &&
-		    message == NULL) {
-			goto ok;
-		}
-#endif
-
-#ifdef CONFIG_RD_LZMA
-		message = NULL; /* Zero out message, or else cpio will
-				   think an error has already occured */
-		if (!unlzma(buf, len, NULL, flush_buffer, NULL,
-			    &my_inptr, error) &&
-		    message == NULL) {
-			goto ok;
-		}
-#endif
-#if defined CONFIG_RD_GZIP || defined CONFIG_RD_BZIP2 || defined CONFIG_RD_LZMA
-ok:
-#endif
+		decompress = decompress_method(buf, len, NULL);
+		if (decompress)
+			decompress(buf, len, NULL, flush_buffer, NULL,
+				   &my_inptr, error);
 		if (state != Reset)
 			error("junk in compressed archive");
 		this_header = saved_offset + my_inptr;
diff --git a/lib/Makefile b/lib/Makefile
index d9ac5a4..790de7c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -11,7 +11,8 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o prio_heap.o ratelimit.o show_mem.o is_single_threaded.o
+	 proportions.o prio_heap.o ratelimit.o show_mem.o \
+	 is_single_threaded.o decompress.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -65,9 +66,9 @@ obj-$(CONFIG_REED_SOLOMON) += reed_solomon/
 obj-$(CONFIG_LZO_COMPRESS) += lzo/
 obj-$(CONFIG_LZO_DECOMPRESS) += lzo/
 
-obj-$(CONFIG_DECOMPRESS_GZIP) += decompress_inflate.o
-obj-$(CONFIG_DECOMPRESS_BZIP2) += decompress_bunzip2.o
-obj-$(CONFIG_DECOMPRESS_LZMA) += decompress_unlzma.o
+lib-$(CONFIG_DECOMPRESS_GZIP) += decompress_inflate.o
+lib-$(CONFIG_DECOMPRESS_BZIP2) += decompress_bunzip2.o
+lib-$(CONFIG_DECOMPRESS_LZMA) += decompress_unlzma.o
 
 obj-$(CONFIG_TEXTSEARCH) += textsearch.o
 obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o
diff --git a/lib/decompress.c b/lib/decompress.c
new file mode 100644
index 0000000..edac55c
--- /dev/null
+++ b/lib/decompress.c
@@ -0,0 +1,50 @@
+/*
+ * decompress.c
+ *
+ * Detect the decompression method based on magic number
+ */
+
+#include <linux/decompress/generic.h>
+
+#include <linux/decompress/bunzip2.h>
+#include <linux/decompress/unlzma.h>
+#include <linux/decompress/inflate.h>
+
+#include <linux/types.h>
+#include <linux/string.h>
+
+static const struct compress_format {
+	unsigned char magic[2];
+	const char *name;
+	decompress_fn decompressor;
+} compressed_formats[] = {
+#ifdef CONFIG_DECOMPRESS_GZIP
+	{ {037, 0213}, "gzip", gunzip },
+	{ {037, 0236}, "gzip", gunzip },
+#endif
+#ifdef CONFIG_DECOMPRESS_BZIP2
+	{ {0x42, 0x5a}, "bzip2", bunzip2 },
+#endif
+#ifdef CONFIG_DECOMPRESS_LZMA
+	{ {0x5d, 0x00}, "lzma", unlzma },
+#endif
+	{ {0, 0}, NULL, NULL }
+};
+
+decompress_fn decompress_method(const unsigned char *inbuf, int len,
+				const char **name)
+{
+	const struct compress_format *cf;
+
+	if (len < 2)
+		return NULL;	/* Need at least this much... */
+
+	for (cf = compressed_formats; cf->decompressor; cf++) {
+		if (!memcmp(inbuf, cf->magic, 2))
+			break;
+
+	}
+	if (name)
+		*name = cf->name;
+	return cf->decompressor;
+}
-- 
1.5.6.6

