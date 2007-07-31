Return-Path: <linux-kernel-owner+w=401wt.eu-S1762359AbXGaQFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762359AbXGaQFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbXGaQFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:05:41 -0400
Received: from fizeau.zen.co.uk ([212.23.8.67]:57691 "EHLO fizeau.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686AbXGaQFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:05:40 -0400
From: David Vrabel <david.vrabel@csr.com>
To: linux-kernel@vger.kernel.org
Cc: David Vrabel <david.vrabel@csr.com>, Pierre Ossman <drzeus-list@drzeus.cx>
Subject: sdio: extend sdio_readsb() and friends to handle any length of buffer
Date: Tue, 31 Jul 2007 16:36:33 +0100
Message-Id: <1185896193650-git-send-email-david.vrabel@csr.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11858961933491-git-send-email-david.vrabel@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: david@pear.davidvrabel.org.uk
X-SA-Exim-Scanned: No (on pear.davidvrabel.org.uk); SAEximRunCond expanded to false
X-Originating-Rutherford-IP: [82.70.146.41]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Extend sdio_readsb(), sdio_writesb(), sdio_memcpy_fromio(), and
sdio_memcpy_toio() to handle any length of buffer by splitting the transfer
into several IO_RW_EXTENDED commands. Typically, a transfer would be split
into a single block mode transfer followed by a byte mode transfer for the
remainder.

For this to work the block size must be limited to the maximum size of a
byte mode transfer (512 bytes).  This limitation could be revisited if
there are any cards out there that require a block size > 512.

Signed-off-by: David Vrabel <david.vrabel@csr.com>

---
commit 1c701a6566f373ede250b51c99216227fd881535
tree 2bbc5005de65bbdc497c8603e8a68486465065dc
parent 6d367fd822cbb2b8089ab7ef83f706f1984ab25b
author David Vrabel <david.vrabel@csr.com> Tue, 31 Jul 2007 11:08:49 +0100
committer David Vrabel <dvrabel@cantab.net> Tue, 31 Jul 2007 11:44:44 +0100

 drivers/mmc/core/sdio_io.c  |   63 ++++++++++++++++++++++++++++++++++---------
 drivers/mmc/core/sdio_ops.c |   17 +++++++-----
 drivers/mmc/core/sdio_ops.h |    2 +
 3 files changed, 61 insertions(+), 21 deletions(-)

diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index e74e605..8fb1880 100644
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -156,6 +156,13 @@ int sdio_set_block_size(struct sdio_func *func, unsigned short blksz)
 {
 	int ret;
 
+	/* The standard permits block sizes up to 2048 bytes, but
+	 * sdio_readsb() etc. can only work with block size <= 512. */
+	if (blksz > 512) {
+		blksz = 512;
+		dev_warn(&func->dev, "block size limited to 512 bytes\n");
+	}
+
 	ret = mmc_io_rw_direct(func->card, 1, 0, SDIO_FBR_BLKSIZE(func->num),
 			       blksz & 0xff, NULL);
 	if (ret)
@@ -228,6 +235,39 @@ void sdio_writeb(struct sdio_func *func, unsigned char b, unsigned int addr,
 
 EXPORT_SYMBOL_GPL(sdio_writeb);
 
+/* Split an arbitrarily sized data transfer into several
+ * IO_RW_EXTENDED commands. */
+static int sdio_io_rw_ext_helper(struct sdio_func *func, int write,
+	unsigned fn, unsigned addr, int incr_addr, u8 *buf, unsigned size)
+{
+	unsigned remainder = size;
+	int ret;
+
+	while (remainder > func->block_size) {
+		unsigned blocks;
+
+		blocks = remainder % func->block_size;
+		if (blocks > 511)
+			blocks = 511;
+		size = blocks * func->block_size;
+
+		ret = mmc_io_rw_extended(func->card, write, fn, addr,
+			 incr_addr, buf, blocks, func->block_size);
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
@@ -235,14 +275,13 @@ EXPORT_SYMBOL_GPL(sdio_writeb);
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
 
@@ -255,14 +294,13 @@ EXPORT_SYMBOL_GPL(sdio_memcpy_fromio);
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
 
@@ -273,14 +311,13 @@ int sdio_memcpy_toio(struct sdio_func *func, unsigned int addr,
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
 
@@ -300,7 +337,7 @@ EXPORT_SYMBOL_GPL(sdio_readsb);
 int sdio_writesb(struct sdio_func *func, unsigned int addr, void *src,
 	int count)
 {
-	return mmc_io_rw_extended(func->card, 1, func->num, addr, 1, src,
+	return sdio_io_rw_ext_helper(func, 1, func->num, addr, 0, src,
 		count);
 }
 
diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
index a91fe41..72590c4 100644
--- a/drivers/mmc/core/sdio_ops.c
+++ b/drivers/mmc/core/sdio_ops.c
@@ -92,7 +92,7 @@ int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
 }
 
 int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
-	unsigned addr, int bang, u8 *buf, unsigned size)
+	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz)
 {
 	struct mmc_request mrq;
 	struct mmc_command cmd;
@@ -101,7 +101,6 @@ int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
 
 	BUG_ON(!card);
 	BUG_ON(fn > 7);
-	BUG_ON(size > 512);
 
 	memset(&mrq, 0, sizeof(struct mmc_request));
 	memset(&cmd, 0, sizeof(struct mmc_command));
@@ -113,18 +112,22 @@ int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
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
 
