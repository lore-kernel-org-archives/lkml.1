Return-Path: <linux-kernel-owner+w=401wt.eu-S1763454AbXHGM4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763454AbXHGM4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933824AbXHGM4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:56:16 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:52709 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560AbXHGM4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:56:13 -0400
Message-ID: <46B86BB0.4000100@csr.com>
Date: Tue, 07 Aug 2007 13:55:12 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: [patch 3/4] sdio: extend sdio_readsb() and friends to handle any
 length of buffer
References: <11858961933491-git-send-email-david.vrabel@csr.com>	<20070804152304.65ed8f1b@poseidon.drzeus.cx>	<46B6F877.7060504@csr.com>	<20070806171207.59fafa18@poseidon.drzeus.cx>	<46B73F18.5030109@csr.com> <20070806220145.66b97559@poseidon.drzeus.cx> <46B86ADB.90000@csr.com>
In-Reply-To: <46B86ADB.90000@csr.com>
Content-Type: multipart/mixed;
 boundary="------------000800010003030208070208"
X-OriginalArrivalTime: 07 Aug 2007 12:55:18.0543 (UTC) FILETIME=[34F3D9F0:01C7D8F2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000800010003030208070208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.

--------------000800010003030208070208
Content-Type: text/x-patch;
 name*0="sdio-extend-sdio-readsb-and-friends-to-handle-any-length-of-buff";
 name*1="er.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="sdio-extend-sdio-readsb-and-friends-to-handle-any-length-of-buffer.patch"

sdio: extend sdio_readsb() and friends to handle any length of buffer

Extend sdio_readsb(), sdio_writesb(), sdio_memcpy_fromio(), and
sdio_memcpy_toio() to handle any length of buffer by splitting the transfer
into several IO_RW_EXTENDED commands. Typically, a transfer would be split
into a single block mode transfer followed by a byte mode transfer for the
remainder.

For this to work the block size must be limited to the maximum size of a
byte mode transfer (512 bytes).  This limitation could be revisited if
there are any cards out there that require a block size > 512.

host->max_seg_size <= host->max_req_size so there's no need to check both
when determining the maximum data size for a single command.

Signed-off-by: David Vrabel <david.vrabel@csr.com>
---
Index: mmc/drivers/mmc/core/sdio_io.c
===================================================================
--- mmc.orig/drivers/mmc/core/sdio_io.c	2007-08-07 07:27:31.000000000 +0100
+++ mmc/drivers/mmc/core/sdio_io.c	2007-08-07 07:35:02.000000000 +0100
@@ -153,6 +153,13 @@
 {
 	int ret;
 
+	/* The standard permits block sizes up to 2048 bytes, but
+	 * sdio_readsb() etc. can only work with block size <= 512. */
+	if (blksz > 512) {
+		blksz = 512;
+		dev_warn(&func->dev, "block size limited to 512 bytes\n");
+	}
+
 	ret = mmc_io_rw_direct(func->card, 1, 0,
 		SDIO_FBR_BASE(func->num) + SDIO_FBR_BLKSIZE,
 		blksz & 0xff, NULL);
@@ -227,6 +234,48 @@
 
 EXPORT_SYMBOL_GPL(sdio_writeb);
 
+/* Split an arbitrarily sized data transfer into several
+ * IO_RW_EXTENDED commands. */
+static int sdio_io_rw_ext_helper(struct sdio_func *func, int write,
+	unsigned fn, unsigned addr, int incr_addr, u8 *buf, unsigned size)
+{
+	unsigned remainder = size;
+	unsigned max_blocks;
+	int ret;
+
+	/* Blocks per command is limited by host count, host transfer size
+	   (we only use a single sg entry) and the maximum for IO_RW_EXTENDED
+	   of 511 blocks. */
+	max_blocks = min(min(
+		func->card->host->max_blk_count,
+		func->card->host->max_seg_size / func->cur_blksize),
+		511u);
+
+	while (remainder > func->cur_blksize) {
+		unsigned blocks;
+
+		blocks = remainder % func->cur_blksize;
+		if (blocks > max_blocks)
+			blocks = max_blocks;
+		size = blocks * func->cur_blksize;
+
+		ret = mmc_io_rw_extended(func->card, write, fn, addr,
+			incr_addr, buf, blocks, func->cur_blksize);
+		if (ret)
+			return ret;
+
+		remainder -= size;
+		buf += size;
+		if (incr_addr)
+			addr += size;
+	}
+
+	if (remainder)
+		ret = mmc_io_rw_extended(func->card, write, fn, addr,
+			 incr_addr, buf, 1, remainder);
+	return ret;
+}
+
 /**
  *	sdio_memcpy_fromio - read a chunk of memory from a SDIO function
  *	@func: SDIO function to access
@@ -234,14 +283,13 @@
  *	@addr: address to begin reading from
  *	@count: number of bytes to read
  *
- *	Reads up to 512 bytes from the address space of a given SDIO
- *	function. Return value indicates if the transfer succeeded or
- *	not.
+ *	Reads from the address space of a given SDIO function. Return
+ *	value indicates if the transfer succeeded or not.
  */
 int sdio_memcpy_fromio(struct sdio_func *func, void *dst,
 	unsigned int addr, int count)
 {
-	return mmc_io_rw_extended(func->card, 0, func->num, addr, 0, dst,
+	return sdio_io_rw_ext_helper(func, 0, func->num, addr, 1, dst,
 		count);
 }
 
@@ -254,14 +302,13 @@
  *	@src: buffer that contains the data to write
  *	@count: number of bytes to write
  *
- *	Writes up to 512 bytes to the address space of a given SDIO
- *	function. Return value indicates if the transfer succeeded or
- *	not.
+ *	Writes to the address space of a given SDIO function. Return
+ *	value indicates if the transfer succeeded or not.
  */
 int sdio_memcpy_toio(struct sdio_func *func, unsigned int addr,
 	void *src, int count)
 {
-	return mmc_io_rw_extended(func->card, 1, func->num, addr, 0, src,
+	return sdio_io_rw_ext_helper(func, 1, func->num, addr, 1, src,
 		count);
 }
 
@@ -272,14 +319,13 @@
  *	@addr: address of (single byte) FIFO
  *	@count: number of bytes to read
  *
- *	Reads up to 512 bytes from the specified FIFO of a given SDIO
- *	function. Return value indicates if the transfer succeeded or
- *	not.
+ *	Reads from the specified FIFO of a given SDIO function. Return
+ *	value indicates if the transfer succeeded or not.
  */
 int sdio_readsb(struct sdio_func *func, void *dst, unsigned int addr,
 	int count)
 {
-	return mmc_io_rw_extended(func->card, 0, func->num, addr, 1, dst,
+	return sdio_io_rw_ext_helper(func, 0, func->num, addr, 0, dst,
 		count);
 }
 
@@ -299,7 +345,7 @@
 int sdio_writesb(struct sdio_func *func, unsigned int addr, void *src,
 	int count)
 {
-	return mmc_io_rw_extended(func->card, 1, func->num, addr, 1, src,
+	return sdio_io_rw_ext_helper(func, 1, func->num, addr, 0, src,
 		count);
 }
 
Index: mmc/drivers/mmc/core/sdio_ops.c
===================================================================
--- mmc.orig/drivers/mmc/core/sdio_ops.c	2007-08-07 07:27:27.000000000 +0100
+++ mmc/drivers/mmc/core/sdio_ops.c	2007-08-07 07:27:31.000000000 +0100
@@ -88,7 +88,7 @@
 }
 
 int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
-	unsigned addr, int bang, u8 *buf, unsigned size)
+	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz)
 {
 	struct mmc_request mrq;
 	struct mmc_command cmd;
@@ -97,7 +97,7 @@
 
 	BUG_ON(!card);
 	BUG_ON(fn > 7);
-	BUG_ON(size > 512);
+	BUG_ON(blocks == 1 && blksz > 512);
 
 	memset(&mrq, 0, sizeof(struct mmc_request));
 	memset(&cmd, 0, sizeof(struct mmc_command));
@@ -109,18 +109,22 @@
 	cmd.opcode = SD_IO_RW_EXTENDED;
 	cmd.arg = write ? 0x80000000 : 0x00000000;
 	cmd.arg |= fn << 28;
-	cmd.arg |= bang ? 0x00000000 : 0x04000000;
+	cmd.arg |= incr_addr ? 0x04000000 : 0x00000000;
 	cmd.arg |= addr << 9;
-	cmd.arg |= (size == 512) ? 0 : size;
+	if (blocks > 1) {
+		cmd.arg |= 0x08000000;
+		cmd.arg |= blocks;
+	} else
+		cmd.arg |= (blksz == 512) ? 0 : blksz;
 	cmd.flags = MMC_RSP_R5 | MMC_CMD_ADTC;
 
-	data.blksz = size;
-	data.blocks = 1;
+	data.blksz = blksz;
+	data.blocks = blocks;
 	data.flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
 	data.sg = &sg;
 	data.sg_len = 1;
 
-	sg_init_one(&sg, buf, size);
+	sg_init_one(&sg, buf, blksz * blocks);
 
 	mmc_set_data_timeout(&data, card, 0);
 
Index: mmc/drivers/mmc/core/sdio_ops.h
===================================================================
--- mmc.orig/drivers/mmc/core/sdio_ops.h	2007-08-07 07:27:27.000000000 +0100
+++ mmc/drivers/mmc/core/sdio_ops.h	2007-08-07 07:27:31.000000000 +0100
@@ -16,7 +16,7 @@
 int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
 	unsigned addr, u8 in, u8* out);
 int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
-	unsigned addr, int bang, u8 *data, unsigned size);
+	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz);
 
 #endif
 

--------------000800010003030208070208--
