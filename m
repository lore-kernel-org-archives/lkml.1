Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbXHHNZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbXHHNZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759776AbXHHNZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:25:24 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:34992 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbXHHNZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:25:22 -0400
Message-ID: <46B9C405.2070003@csr.com>
Date: Wed, 08 Aug 2007 14:24:21 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: [patch 3/3] sdio: extend sdio_readsb() and friends to handle any
 length of buffer
References: <11858961933491-git-send-email-david.vrabel@csr.com>	<20070804152304.65ed8f1b@poseidon.drzeus.cx>	<46B6F877.7060504@csr.com>	<20070806171207.59fafa18@poseidon.drzeus.cx>	<46B73F18.5030109@csr.com>	<20070806220145.66b97559@poseidon.drzeus.cx>	<46B86ADB.90000@csr.com>	<46B86BB0.4000100@csr.com>	<20070807221719.7c89e5b6@poseidon.drzeus.cx>	<46B998B5.9040203@csr.com> <20070808123759.26a74b2a@poseidon.drzeus.cx> <46B9C38C.1030708@csr.com>
In-Reply-To: <46B9C38C.1030708@csr.com>
Content-Type: multipart/mixed;
 boundary="------------050501050100050905000000"
X-OriginalArrivalTime: 08 Aug 2007 13:24:21.0964 (UTC) FILETIME=[6E8688C0:01C7D9BF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050501050100050905000000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.

--------------050501050100050905000000
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
remainder but we also handle lack of block mode support and the block size
being greater than 512 (the maximum byte mode transfer size).

host->max_seg_size <= host->max_req_size so there's no need to check both
when determining the maximum data size for a single command.

Signed-off-by: David Vrabel <david.vrabel@csr.com>
---
Index: mmc/drivers/mmc/core/sdio_io.c
===================================================================
--- mmc.orig/drivers/mmc/core/sdio_io.c	2007-08-08 13:34:09.000000000 +0100
+++ mmc/drivers/mmc/core/sdio_io.c	2007-08-08 13:34:17.000000000 +0100
@@ -193,6 +193,69 @@
 
 EXPORT_SYMBOL_GPL(sdio_set_block_size);
 
+/* Split an arbitrarily sized data transfer into several
+ * IO_RW_EXTENDED commands. */
+static int sdio_io_rw_ext_helper(struct sdio_func *func, int write,
+	unsigned addr, int incr_addr, u8 *buf, unsigned size)
+{
+	unsigned remainder = size;
+	unsigned max_blocks;
+	int ret;
+
+	/* Do the bulk of the transfer using block mode (if supported). */
+	if (func->card->cccr.multi_block) {
+		unsigned max_blocks;
+
+		/* Blocks per command is limited by host count, host transfer
+		 * size (we only use a single sg entry) and the maximum for
+		 * IO_RW_EXTENDED of 511 blocks. */
+		max_blocks = min(min(
+			func->card->host->max_blk_count,
+			func->card->host->max_seg_size / func->cur_blksize),
+			511u);
+
+		while (remainder > func->cur_blksize) {
+			unsigned blocks;
+
+			blocks = remainder % func->cur_blksize;
+			if (blocks > max_blocks)
+				blocks = max_blocks;
+			size = blocks * func->cur_blksize;
+
+			ret = mmc_io_rw_extended(func->card, write,
+				func->num, addr, incr_addr, buf,
+				blocks, func->cur_blksize);
+			if (ret)
+				return ret;
+
+			remainder -= size;
+			buf += size;
+			if (incr_addr)
+				addr += size;
+		}
+	}
+
+	/* Write the remainder using byte mode. */
+	while (remainder > 0) {
+		size = remainder;
+		if (size > func->cur_blksize)
+			size = func->cur_blksize;
+		if (size > 512)
+			size = 512; /* maximum size for byte mode */
+
+		ret = mmc_io_rw_extended(func->card, write, func->num, addr,
+			 incr_addr, buf, 1, size);
+		if (ret)
+			return ret;
+
+		remainder -= size;
+		buf += size;
+		if (incr_addr)
+			addr += size;
+	}
+	return 0;
+}
+
 /**
  *	sdio_readb - read a single byte from a SDIO function
  *	@func: SDIO function to access
@@ -258,15 +321,13 @@
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
-		count);
+	return sdio_io_rw_ext_helper(func, 0, addr, 1, dst, count);
 }
 
 EXPORT_SYMBOL_GPL(sdio_memcpy_fromio);
@@ -278,15 +339,13 @@
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
-		count);
+	return sdio_io_rw_ext_helper(func, 1, addr, 1, src, count);
 }
 
 /**
@@ -296,15 +355,13 @@
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
-		count);
+	return sdio_io_rw_ext_helper(func, 0, addr, 0, dst, count);
 }
 
 EXPORT_SYMBOL_GPL(sdio_readsb);
@@ -323,8 +380,7 @@
 int sdio_writesb(struct sdio_func *func, unsigned int addr, void *src,
 	int count)
 {
-	return mmc_io_rw_extended(func->card, 1, func->num, addr, 1, src,
-		count);
+	return sdio_io_rw_ext_helper(func, 1, addr, 0, src, count);
 }
 
 EXPORT_SYMBOL_GPL(sdio_writesb);
Index: mmc/drivers/mmc/core/sdio_ops.c
===================================================================
--- mmc.orig/drivers/mmc/core/sdio_ops.c	2007-08-08 13:29:47.000000000 +0100
+++ mmc/drivers/mmc/core/sdio_ops.c	2007-08-08 13:34:17.000000000 +0100
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
@@ -109,18 +109,21 @@
 	cmd.opcode = SD_IO_RW_EXTENDED;
 	cmd.arg = write ? 0x80000000 : 0x00000000;
 	cmd.arg |= fn << 28;
-	cmd.arg |= bang ? 0x00000000 : 0x04000000;
+	cmd.arg |= incr_addr ? 0x04000000 : 0x00000000;
 	cmd.arg |= addr << 9;
-	cmd.arg |= (size == 512) ? 0 : size;
+	if (blocks == 1 && blksz <= 512)
+		cmd.arg |= (blksz == 512) ? 0 : blksz;	/* byte mode */
+	else
+		cmd.arg |= 0x08000000 | blocks;		/* block mode */
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
--- mmc.orig/drivers/mmc/core/sdio_ops.h	2007-08-08 13:29:47.000000000 +0100
+++ mmc/drivers/mmc/core/sdio_ops.h	2007-08-08 13:34:17.000000000 +0100
@@ -16,7 +16,7 @@
 int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
 	unsigned addr, u8 in, u8* out);
 int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
-	unsigned addr, int bang, u8 *data, unsigned size);
+	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz);
 
 #endif
 

--------------050501050100050905000000--
