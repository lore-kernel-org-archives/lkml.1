Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbZADXIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbZADXIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZADXI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:08:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60210 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZADXI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:08:27 -0500
Message-ID: <4961415C.1050708@zytor.com>
Date: Sun, 04 Jan 2009 15:08:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: linux-kernel@vger.kernel.org
Subject: Re: update8 [PATCH 2/5] init: bzip2 or lzma -compressed kernels and
 initrds
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu>
In-Reply-To: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu>
Content-Type: multipart/mixed;
 boundary="------------030803040108020205090102"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030803040108020205090102
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alain,

Looking pretty good now.  The only issues that I see so far are:

- Putting the kernel compression selection in init/Kconfig isn't going
  to work too well, since it affects all architectures, and not all
  architectures even do their own decompression (for quite a few
  architectures it's the boot loader's responsibility.)

  I see two options here: either have this be parameterized by the arch
  Kconfig files, or simply move this chunk into arch/*/Kconfig as part
  of the arch-enablement patches.  The latter is probably the simplest,
  even if it means some replicated code.

  Let me know what you think -- I can do this pretty easily while
  importing, so you don't need to submit a full new patchset.

- I did a followon patch (attached) to change the ramdisk compression
  search to table driven.  Since I already did the followon patch, don't
  worry about it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------030803040108020205090102
Content-Type: text/x-patch;
 name="0003-init-use-a-table-to-search-for-initramfs-compressio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0003-init-use-a-table-to-search-for-initramfs-compressio.pat";
 filename*1="ch"

>From 832edddc59b5f8d8243aca91a20fb55ed64d00fb Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Sun, 4 Jan 2009 14:42:52 -0800
Subject: [PATCH] init: use a table to search for initramfs compression formats

Impact: Code simplification

Instead of open-coding testing for initramfs compression formats, use
a table.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 init/do_mounts_rd.c |   82 +++++++++++++++++++++-----------------------------
 1 files changed, 35 insertions(+), 47 deletions(-)

diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index dcaeb1f..9c9d7db 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -43,13 +43,31 @@ static int __init crd_load(int in_fd, int out_fd, decompress_fn deco);
  * numbers could not be found.
  *
  * We currently check for the following magic numbers:
- * 	minix
- * 	ext2
+ *	minix
+ *	ext2
  *	romfs
  *	cramfs
- * 	gzip
+ *	gzip
  */
-static int __init 
+static const struct compress_format {
+	unsigned char magic[2];
+	const char *name;
+	decompress_fn decompressor;
+} compressed_formats[] = {
+#ifdef CONFIG_RD_GZIP
+	{ {037, 0213}, "gzip", gunzip },
+	{ {037, 0236}, "gzip", gunzip },
+#endif
+#ifdef CONFIG_RD_BZIP2
+	{ {0x42, 0x5a}, "bzip2", bunzip2 },
+#endif
+#ifdef CONFIG_RD_LZMA
+	{ {0x5d, 0x00}, "lzma", unlzma },
+#endif
+	{ {0, 0}, NULL, NULL }
+};
+
+static int __init
 identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
 {
 	const int size = 512;
@@ -59,6 +77,7 @@ identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
 	struct cramfs_super *cramfsb;
 	int nblocks = -1;
 	unsigned char *buf;
+	const struct compress_format *cf;
 
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf)
@@ -71,52 +90,21 @@ identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
 	memset(buf, 0xe5, size);
 
 	/*
-	 * Read block 0 to test for gzipped kernel
+	 * Read block 0 to test for compressed kernel
 	 */
 	sys_lseek(fd, start_block * BLOCK_SIZE, 0);
 	sys_read(fd, buf, size);
 
-#ifdef CONFIG_RD_GZIP
-	/*
-	 * If it matches the gzip magic numbers, return 0
-	 */
-	if (buf[0] == 037 && ((buf[1] == 0213) || (buf[1] == 0236))) {
-		printk(KERN_NOTICE
-		       "RAMDISK: Compressed image found at block %d\n",
-		       start_block);
-		*decompressor = gunzip;
-		nblocks = 0;
-		goto done;
-	}
-#endif
-
-#ifdef CONFIG_RD_BZIP2
-	/*
-	 * If it matches the bzip2 magic numbers, return -1
-	 */
-	if (buf[0] == 0x42 && (buf[1] == 0x5a)) {
-		printk(KERN_NOTICE
-		       "RAMDISK: Bzipped image found at block %d\n",
-		       start_block);
-		*decompressor = bunzip2;
-		nblocks = 0;
-		goto done;
-	}
-#endif
-
-#ifdef CONFIG_RD_LZMA
-	/*
-	 * If it matches the lzma magic numbers, return -1
-	 */
-	if (buf[0] == 0x5d && (buf[1] == 0x00)) {
-		printk(KERN_NOTICE
-		       "RAMDISK: Lzma image found at block %d\n",
-		       start_block);
-		*decompressor = unlzma;
-		nblocks = 0;
-		goto done;
+	for (cf = compressed_formats; cf->decompressor; cf++) {
+		if (buf[0] == cf->magic[0] && buf[1] == cf->magic[1]) {
+			printk(KERN_NOTICE
+			       "RAMDISK: %s image found at block %d\n",
+			       cf->name, start_block);
+			*decompressor = cf->decompressor;
+			nblocks = 0;
+			goto done;
+		}
 	}
-#endif
 
 	/* romfs is at block zero too */
 	if (romfsb->word0 == ROMSB_WORD0 &&
@@ -165,7 +153,7 @@ identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
 	printk(KERN_NOTICE
 	       "RAMDISK: Couldn't find valid RAM disk image starting at %d.\n",
 	       start_block);
-	
+
 done:
 	sys_lseek(fd, start_block * BLOCK_SIZE, 0);
 	kfree(buf);
@@ -224,7 +212,7 @@ int __init rd_load_image(char *from)
 		       nblocks, rd_blocks);
 		goto done;
 	}
-		
+
 	/*
 	 * OK, time to copy in the data
 	 */
-- 
1.5.6.6


--------------030803040108020205090102--
