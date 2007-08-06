Return-Path: <linux-kernel-owner+w=401wt.eu-S1763048AbXHFUCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763048AbXHFUCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757962AbXHFUBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:01:51 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:43276 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758396AbXHFUBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:01:50 -0400
Date: Mon, 6 Aug 2007 22:01:45 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sdio: enhance IO_RW_EXTENDED support
Message-ID: <20070806220145.66b97559@poseidon.drzeus.cx>
In-Reply-To: <46B73F18.5030109@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
	<20070804152304.65ed8f1b@poseidon.drzeus.cx>
	<46B6F877.7060504@csr.com>
	<20070806171207.59fafa18@poseidon.drzeus.cx>
	<46B73F18.5030109@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_hera.drzeus.cx-21164-1186430505-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-21164-1186430505-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This is essentially what I mean.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

--=_hera.drzeus.cx-21164-1186430505-0001-2
Content-Type: text/x-patch; name="sdio-block.patch"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=sdio-block.patch

commit 8f9fca61fbacd15d1be4215584ed00aa1119d87f
Author: David Vrabel <david.vrabel@csr.com>
Date:   Mon Aug 6 22:00:47 2007 +0200

    sdio: extend sdio_readsb() and friends to handle any length of buffer
    
    Extend sdio_readsb(), sdio_writesb(), sdio_memcpy_fromio(), and
    sdio_memcpy_toio() to handle any length of buffer by splitting the transfer
    into several IO_RW_EXTENDED commands. Typically, a transfer would be split
    into a single block mode transfer followed by a byte mode transfer for the
    remainder.
    
    [ Automatic block size selection logic by Pierre Ossman ]
    
    Signed-off-by: David Vrabel <david.vrabel@csr.com>
    Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index 7f08ba5..e49b381 100644
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -95,6 +95,9 @@ int sdio_enable_func(struct sdio_func *func)
 			goto err;
 	}
 
+	func->cur_blksz = 0;
+	func->forced_blksz = 0;
+
 	pr_debug("SDIO: Enabled device %s\n", sdio_func_id(func));
 
 	return 0;
@@ -202,6 +205,129 @@ void sdio_writeb(struct sdio_func *func, unsigned char b, unsigned int addr,
 
 EXPORT_SYMBOL_GPL(sdio_writeb);
 
+/*
+ * Internal function. Sets the block size of the card.
+ */
+static int sdio_set_block_size(struct sdio_func *func, unsigned short blksz)
+{
+	int ret;
+
+	if (blksz == func->cur_blksz)
+		return 0;
+
+	/*
+	 * We start by clearing the current block size as a failure
+	 * will leave the size on the card in an unknown state.
+	 */
+	func->cur_blksz = 0;
+
+	ret = mmc_io_rw_direct(func->card, 1, 0,
+			func->num * 0x100 + SDIO_FBR_BLKSIZE,
+			blksz & 0xff, NULL);
+	if (ret)
+		return ret;
+
+	ret = mmc_io_rw_direct(func->card, 1, 0,
+			func->num * 0x100 + SDIO_FBR_BLKSIZE + 1,
+			(blksz >> 8) & 0xff, NULL);
+	if (ret)
+		return ret;
+
+	func->cur_blksz = blksz;
+
+	return 0;
+}
+
+/*
+ * Internal function. Splits an arbitrarily sized data transfer 
+ * into several IO_RW_EXTENDED commands.
+ */
+static int sdio_io_rw_ext_helper(struct sdio_func *func, int write,
+	unsigned addr, int incr_addr, u8 *buf, unsigned size)
+{
+	unsigned remainder = size;
+	int ret;
+	unsigned short blksz;
+	struct mmc_host *host = func->card->host;
+
+	if (func->forced_blksz)
+		blksz = func->forced_blksz;
+	else {
+		if (size <= 512)
+			goto byte_remainder;
+
+		blksz = size;
+		if (size > 0xffff)
+			blksz = 0xffff;
+
+		if (blksz > func->blksize)
+			blksz = func->blksize;
+		if (blksz > host->max_blk_size)
+			blksz = host->max_blk_size;
+
+		/* avoid changing blksize needlessly */
+		if (func->cur_blksz && ((blksz % func->cur_blksz) == 0))
+			blksz = func->cur_blksz;
+	}
+
+	ret = sdio_set_block_size(func, blksz);
+	if (ret)
+		return ret;
+
+	while (remainder >= blksz) {
+		unsigned blocks;
+
+		blocks = remainder / blksz;
+
+		if (blocks > 512)
+			blocks = 512;
+		if (blocks > host->max_blk_count)
+			blocks = host->max_blk_count;
+		if (blocks * blksz > host->max_req_size)
+			blocks = host->max_req_size / blksz;
+		if (blocks * blksz > host->max_seg_size)
+			blocks = host->max_seg_size / blksz;
+
+		size = blocks * blksz;
+
+		ret = mmc_io_rw_extended(func->card, write, func->num,
+				addr, incr_addr, buf, blocks, blksz);
+		if (ret)
+			return ret;
+
+		remainder -= size;
+		buf += size;
+		if (incr_addr)
+			addr += size;
+	}
+
+byte_remainder:
+	while (remainder) {
+		size = remainder;
+
+		if (size > 512)
+			size = 512;
+
+		/*
+		 * We don't check host requirements as a block of 512
+		 * bytes is the bare minimum support a host must
+		 * provide.
+		 */
+
+		ret = mmc_io_rw_extended(func->card, write, func->num,
+				addr, incr_addr, buf, 1, size);
+		if (ret)
+			return ret;
+
+		remainder -= size;
+		buf += size;
+		if (incr_addr)
+			addr += size;
+	}
+
+	return 0;
+}
+
 /**
  *	sdio_memcpy_fromio - read a chunk of memory from a SDIO function
  *	@func: SDIO function to access
@@ -209,14 +335,13 @@ EXPORT_SYMBOL_GPL(sdio_writeb);
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
+	return sdio_io_rw_ext_helper(func, 0, addr, 1, dst,
 		count);
 }
 
@@ -229,14 +354,13 @@ EXPORT_SYMBOL_GPL(sdio_memcpy_fromio);
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
+	return sdio_io_rw_ext_helper(func, 1, addr, 1, src,
 		count);
 }
 
@@ -247,14 +371,13 @@ int sdio_memcpy_toio(struct sdio_func *func, unsigned int addr,
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
+	return sdio_io_rw_ext_helper(func, 0, addr, 0, dst,
 		count);
 }
 
@@ -267,14 +390,13 @@ EXPORT_SYMBOL_GPL(sdio_readsb);
  *	@src: buffer that contains the data to write
  *	@count: number of bytes to write
  *
- *	Writes up to 512 bytes to the specified FIFO of a given SDIO
- *	function. Return value indicates if the transfer succeeded or
- *	not.
+ *	Writes to the specified FIFO of a given SDIO function. Return
+ *	value indicates if the transfer succeeded or not.
  */
 int sdio_writesb(struct sdio_func *func, unsigned int addr, void *src,
 	int count)
 {
-	return mmc_io_rw_extended(func->card, 1, func->num, addr, 1, src,
+	return sdio_io_rw_ext_helper(func, 1, addr, 0, src,
 		count);
 }
 
@@ -393,3 +515,28 @@ void sdio_writel(struct sdio_func *func, unsigned long b, unsigned int addr,
 
 EXPORT_SYMBOL_GPL(sdio_writel);
 
+/**
+ *	sdio_force_block_size - lock a certain block size
+ *	@func: SDIO function to set block size for
+ *	@size: block size in bytes, or 0 to remove any lock
+ *
+ *	Locks the used block size for all multi-block sdio functions
+ *	in order to satisfy transactions with precise requirements.
+ *	This lock can be removed by specifying 0 (zero) as the block
+ *	size. Returns failure if the selected block size isn't
+ *	supported.
+ */
+int sdio_force_block_size(struct sdio_func *func, unsigned short size)
+{
+	if (size > func->blksize)
+		return -EINVAL;
+	if (size > func->card->host->max_blk_size)
+		return -EINVAL;
+
+	func->forced_blksz = size;
+
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(sdio_force_block_size);
+
diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
index 277870c..14bd244 100644
--- a/drivers/mmc/core/sdio_ops.c
+++ b/drivers/mmc/core/sdio_ops.c
@@ -88,7 +88,7 @@ int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
 }
 
 int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
-	unsigned addr, int bang, u8 *buf, unsigned size)
+	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz)
 {
 	struct mmc_request mrq;
 	struct mmc_command cmd;
@@ -97,7 +97,7 @@ int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
 
 	BUG_ON(!card);
 	BUG_ON(fn > 7);
-	BUG_ON(size > 512);
+	BUG_ON(blocks > 512);
 
 	memset(&mrq, 0, sizeof(struct mmc_request));
 	memset(&cmd, 0, sizeof(struct mmc_command));
@@ -107,20 +107,27 @@ int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
 	mrq.data = &data;
 
 	cmd.opcode = SD_IO_RW_EXTENDED;
+
 	cmd.arg = write ? 0x80000000 : 0x00000000;
 	cmd.arg |= fn << 28;
-	cmd.arg |= bang ? 0x00000000 : 0x04000000;
+	cmd.arg |= incr_addr ? 0x04000000 : 0x00000000;
 	cmd.arg |= addr << 9;
-	cmd.arg |= (size == 512) ? 0 : size;
+
+	if ((blocks > 1) || (blksz > 512)) {
+		cmd.arg |= 0x08000000;
+		cmd.arg |= (blocks == 512) ? 0 : blocks;
+	} else
+		cmd.arg |= (blksz == 512) ? 0 : blksz;
+
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
 
diff --git a/drivers/mmc/core/sdio_ops.h b/drivers/mmc/core/sdio_ops.h
index 1d42e4f..e2e74b0 100644
--- a/drivers/mmc/core/sdio_ops.h
+++ b/drivers/mmc/core/sdio_ops.h
@@ -16,7 +16,7 @@ int mmc_send_io_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr);
 int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
 	unsigned addr, u8 in, u8* out);
 int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
-	unsigned addr, int bang, u8 *data, unsigned size);
+	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz);
 
 #endif
 
diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
index 14d9147..fded343 100644
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -44,6 +44,8 @@ struct sdio_func {
 	unsigned short		device;		/* device id */
 
 	unsigned short		blksize;	/* maximum block size */
+	unsigned short		cur_blksz;	/* current block size */
+	unsigned short		forced_blksz;	/* driver forced block size */
 
 	unsigned int		state;		/* function state */
 #define SDIO_STATE_PRESENT	(1<<0)		/* present in sysfs */
@@ -136,5 +138,7 @@ extern int sdio_memcpy_toio(struct sdio_func *func, unsigned int addr,
 extern int sdio_writesb(struct sdio_func *func, unsigned int addr,
 	void *src, int count);
 
+extern int sdio_force_block_size(struct sdio_func *func, unsigned short size);
+
 #endif
 

--=_hera.drzeus.cx-21164-1186430505-0001-2--
