Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYI3KYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYI3KYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 06:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYI3KXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 06:23:40 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:33873 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYI3KXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 06:23:38 -0400
Message-Id: <20080930102335.701629037@zoo.weinigel.se>
References: <20080930102313.418263345@zoo.weinigel.se>
User-Agent: quilt/0.46-1
Date: Tue, 30 Sep 2008 12:23:14 +0200
From: Christer Weinigel <christer@weinigel.se>
To: drzeus-list@drzeus.cx
Cc: Christer Weinigel <christer.weinigel@csr.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 1/3] RFC: Low-latency SDIO, add asynchronous SDIO operations
Content-Disposition: inline; filename=sdio-async-ops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To improve the latency of the SDIO operations, I've add asynchronous
versions of sdio operations that split a blocking sdio call into a
_start call which takes a callback and a _result function which gets
the result from the last operation.  The callback is called directly
from interrupt context so this avoids the scheduling overhead from
waking up the calling thread all the time.  This makes a noticeable
difference in latency and CPU load on slow embedded systems.

To begin with the patch extracts the guts of mmc_io_rw_direct into two
functions, mmc_io_rw_direct_start and mmc_io_rw_direct_result which
can be called separately.  mmc_io_rw_direct is still there but
delegates most of its work to the above functions, and becomes:

    mmc_io_rw_direct_start(..., mmc_io_done, &complete);
    wait_for_completion(&complete);
    return mmc_io_rw_direct_result(card, out);

To support the above mmc_start_request has to be exported and since
the function can be called directly I moved the host->claimed check
into that function.

A similar refactoring is done for most sdio_ops functions, e.g. for
sdio_readb I've added sdio_readb_start and sdio_readb_result while
keeping the original function unmodified.

A lot of state had to be moved from local variables into the mmc_card
structure.

With the above changes, a driver which used to run in a worker thread
and did a blocking call to sdio_readb:

    void foo() 
    {
        value = sdio_readb(func, addr, &err);
    }

can now be writen as:

    void foo_done(struct sdio_func *func);

    void foo()
    {
         sdio_readb_start(func, addr, foo_done);
    }

    void foo_done(struct sdio_func *func)
    {
        value = sdio_readb_result(func, &err);
    }

This is a lot more complex, but the advantage is that since it won't
sleep, all of this can be done directly from interrupt context which
can give much better latency and a bit lower CPU load by avoiding the
thread scheduling.  Non latency sensitive applications can still use
the blocking calls of course.

This work is done for my employer, CSR.

Signed-off-by: Christer Weinigel CSR <christer.weinigel@csr.com>

  /Christer

Index: linux-2.6.26.2/drivers/mmc/core/sdio_ops.c
===================================================================
--- linux-2.6.26.2.orig/drivers/mmc/core/sdio_ops.c
+++ linux-2.6.26.2/drivers/mmc/core/sdio_ops.c
@@ -67,110 +67,158 @@ int mmc_send_io_op_cond(struct mmc_host 
 	return err;
 }
 
-int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
-	unsigned addr, u8 in, u8* out)
+static void mmc_io_done(struct mmc_request *mrq)
 {
-	struct mmc_command cmd;
-	int err;
+	complete(mrq->done_data);
+}
 
+void mmc_io_rw_direct_start(struct mmc_card *card, int write, unsigned fn,
+			    unsigned addr, u8 in, bool want_out,
+			    void (*done)(struct mmc_request *),
+			    void *done_data)
+{
 	BUG_ON(!card);
 	BUG_ON(fn > 7);
 
-	memset(&cmd, 0, sizeof(struct mmc_command));
+	memset(&card->cmd, 0, sizeof(struct mmc_command));
+
+	card->cmd.opcode = SD_IO_RW_DIRECT;
+	card->cmd.arg = write ? 0x80000000 : 0x00000000;
+	card->cmd.arg |= fn << 28;
+	card->cmd.arg |= (write && want_out) ? 0x08000000 : 0x00000000;
+	card->cmd.arg |= addr << 9;
+	card->cmd.arg |= in;
+	card->cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_AC;
+
+	memset(card->cmd.resp, 0, sizeof(card->cmd.resp));
+	card->cmd.retries = 0;
+
+	memset(&card->mrq, 0, sizeof(struct mmc_request));
+	card->mrq.cmd = &card->cmd;
+	card->cmd.data = NULL;
+
+	card->mrq.done_data = done_data;
+	card->mrq.done = done;
+
+	mmc_start_request(card->host, &card->mrq);
+}
 
-	cmd.opcode = SD_IO_RW_DIRECT;
-	cmd.arg = write ? 0x80000000 : 0x00000000;
-	cmd.arg |= fn << 28;
-	cmd.arg |= (write && out) ? 0x08000000 : 0x00000000;
-	cmd.arg |= addr << 9;
-	cmd.arg |= in;
-	cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_AC;
-
-	err = mmc_wait_for_cmd(card->host, &cmd, 0);
-	if (err)
-		return err;
+int mmc_io_rw_direct_result(struct mmc_card *card, u8 *out)
+{
+	if (card->cmd.error)
+		return card->cmd.error;
 
 	if (mmc_host_is_spi(card->host)) {
 		/* host driver already reported errors */
 	} else {
-		if (cmd.resp[0] & R5_ERROR)
+		if (card->cmd.resp[0] & R5_ERROR)
 			return -EIO;
-		if (cmd.resp[0] & R5_FUNCTION_NUMBER)
+		if (card->cmd.resp[0] & R5_FUNCTION_NUMBER)
 			return -EINVAL;
-		if (cmd.resp[0] & R5_OUT_OF_RANGE)
+		if (card->cmd.resp[0] & R5_OUT_OF_RANGE)
 			return -ERANGE;
 	}
 
 	if (out) {
 		if (mmc_host_is_spi(card->host))
-			*out = (cmd.resp[0] >> 8) & 0xFF;
+			*out = (card->cmd.resp[0] >> 8) & 0xFF;
 		else
-			*out = cmd.resp[0] & 0xFF;
+			*out = card->cmd.resp[0] & 0xFF;
 	}
 
 	return 0;
 }
 
-int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
-	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz)
+int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
+	unsigned addr, u8 in, u8 *out)
 {
-	struct mmc_request mrq;
-	struct mmc_command cmd;
-	struct mmc_data data;
-	struct scatterlist sg;
+	DECLARE_COMPLETION_ONSTACK(complete);
 
+	mmc_io_rw_direct_start(card, write, fn, addr, in, out,
+			       mmc_io_done, &complete);
+
+	wait_for_completion(&complete);
+
+	return mmc_io_rw_direct_result(card, out);
+}
+
+void mmc_io_rw_extended_start(struct mmc_card *card, int write, unsigned fn,
+	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz,
+	void (*done)(struct mmc_request *), void *done_data)
+{
 	BUG_ON(!card);
 	BUG_ON(fn > 7);
 	BUG_ON(blocks == 1 && blksz > 512);
 	WARN_ON(blocks == 0);
 	WARN_ON(blksz == 0);
 
-	memset(&mrq, 0, sizeof(struct mmc_request));
-	memset(&cmd, 0, sizeof(struct mmc_command));
-	memset(&data, 0, sizeof(struct mmc_data));
-
-	mrq.cmd = &cmd;
-	mrq.data = &data;
-
-	cmd.opcode = SD_IO_RW_EXTENDED;
-	cmd.arg = write ? 0x80000000 : 0x00000000;
-	cmd.arg |= fn << 28;
-	cmd.arg |= incr_addr ? 0x04000000 : 0x00000000;
-	cmd.arg |= addr << 9;
+	memset(&card->mrq, 0, sizeof(struct mmc_request));
+	memset(&card->cmd, 0, sizeof(struct mmc_command));
+	memset(&card->data, 0, sizeof(struct mmc_data));
+
+	card->mrq.cmd = &card->cmd;
+	card->mrq.data = &card->data;
+
+	card->cmd.opcode = SD_IO_RW_EXTENDED;
+	card->cmd.arg = write ? 0x80000000 : 0x00000000;
+	card->cmd.arg |= fn << 28;
+	card->cmd.arg |= incr_addr ? 0x04000000 : 0x00000000;
+	card->cmd.arg |= addr << 9;
 	if (blocks == 1 && blksz <= 512)
-		cmd.arg |= (blksz == 512) ? 0 : blksz;	/* byte mode */
+		card->cmd.arg |= (blksz == 512) ? 0 : blksz;	/* byte mode */
 	else
-		cmd.arg |= 0x08000000 | blocks;		/* block mode */
-	cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_ADTC;
+		card->cmd.arg |= 0x08000000 | blocks;		/* block mode */
+	card->cmd.flags = MMC_RSP_SPI_R5 | MMC_RSP_R5 | MMC_CMD_ADTC;
 
-	data.blksz = blksz;
-	data.blocks = blocks;
-	data.flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
-	data.sg = &sg;
-	data.sg_len = 1;
+	card->data.blksz = blksz;
+	card->data.blocks = blocks;
+	card->data.flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
+	card->data.sg = &card->sg;
+	card->data.sg_len = 1;
 
-	sg_init_one(&sg, buf, blksz * blocks);
+	sg_init_one(&card->sg, buf, blksz * blocks);
 
-	mmc_set_data_timeout(&data, card);
+	mmc_set_data_timeout(&card->data, card);
 
-	mmc_wait_for_req(card->host, &mrq);
+	card->mrq.done_data = done_data;
+	card->mrq.done = done;
 
-	if (cmd.error)
-		return cmd.error;
-	if (data.error)
-		return data.error;
+	mmc_start_request(card->host, &card->mrq);
+}
+
+// TODO this can be merged with mmc_io_rw_direct_result
+int mmc_io_rw_extended_result(struct mmc_card *card)
+{
+	if (card->cmd.error)
+		return card->cmd.error;
+	if (card->data.error)
+		return card->data.error;
 
 	if (mmc_host_is_spi(card->host)) {
 		/* host driver already reported errors */
 	} else {
-		if (cmd.resp[0] & R5_ERROR)
+		if (card->cmd.resp[0] & R5_ERROR)
 			return -EIO;
-		if (cmd.resp[0] & R5_FUNCTION_NUMBER)
+		if (card->cmd.resp[0] & R5_FUNCTION_NUMBER)
 			return -EINVAL;
-		if (cmd.resp[0] & R5_OUT_OF_RANGE)
+		if (card->cmd.resp[0] & R5_OUT_OF_RANGE)
 			return -ERANGE;
 	}
 
 	return 0;
 }
 
+int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
+	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz)
+{
+	DECLARE_COMPLETION_ONSTACK(complete);
+
+	mmc_io_rw_extended_start(card, write, fn, addr, incr_addr,
+				 buf, blocks, blksz,
+				 mmc_io_done, &complete);
+
+	wait_for_completion(&complete);
+
+	return mmc_io_rw_extended_result(card);
+}
+
Index: linux-2.6.26.2/drivers/mmc/core/core.c
===================================================================
--- linux-2.6.26.2.orig/drivers/mmc/core/core.c
+++ linux-2.6.26.2/drivers/mmc/core/core.c
@@ -113,16 +113,16 @@ void mmc_request_done(struct mmc_host *h
 			mrq->done(mrq);
 	}
 }
-
 EXPORT_SYMBOL(mmc_request_done);
 
-static void
-mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
+void mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 {
 #ifdef CONFIG_MMC_DEBUG
 	unsigned int i, sz;
 #endif
 
+	WARN_ON(!host->claimed);
+
 	pr_debug("%s: starting CMD%u arg %08x flags %08x\n",
 		 mmc_hostname(host), mrq->cmd->opcode,
 		 mrq->cmd->arg, mrq->cmd->flags);
@@ -172,6 +172,7 @@ mmc_start_request(struct mmc_host *host,
 	}
 	host->ops->request(host, mrq);
 }
+EXPORT_SYMBOL(mmc_start_request);
 
 static void mmc_wait_done(struct mmc_request *mrq)
 {
@@ -215,8 +216,6 @@ int mmc_wait_for_cmd(struct mmc_host *ho
 {
 	struct mmc_request mrq;
 
-	WARN_ON(!host->claimed);
-
 	memset(&mrq, 0, sizeof(struct mmc_request));
 
 	memset(cmd->resp, 0, sizeof(cmd->resp));
Index: linux-2.6.26.2/drivers/mmc/core/sdio_io.c
===================================================================
--- linux-2.6.26.2.orig/drivers/mmc/core/sdio_io.c
+++ linux-2.6.26.2/drivers/mmc/core/sdio_io.c
@@ -189,6 +189,92 @@ int sdio_set_block_size(struct sdio_func
 
 EXPORT_SYMBOL_GPL(sdio_set_block_size);
 
+static void sdio_async_done(struct mmc_request *mrq)
+{
+	struct sdio_func *func = mrq->done_data;
+	func->card->done(func);
+}
+
+static void sdio_io_rw_async_ext_start(struct sdio_func *func);
+
+static void sdio_io_rw_async_ext_done(struct mmc_request *mrq)
+{
+	struct sdio_func *func = mrq->done_data;
+	struct mmc_card *card = func->card;
+
+	card->remainder -= card->size;
+	card->buf += card->size;
+	if (card->incr_addr)
+		card->addr += card->size;
+
+	if (card->remainder)
+		sdio_io_rw_async_ext_start(func);
+	else
+		sdio_async_done(mrq);
+}
+
+static void sdio_io_rw_async_ext_start(struct sdio_func *func)
+{
+	struct mmc_card *card = func->card;
+	unsigned max_blocks;
+
+	/* Do the bulk of the transfer using block mode (if supported). */
+	if (card->cccr.multi_block) {
+		/* Blocks per command is limited by host count, host transfer
+		 * size (we only use a single sg entry) and the maximum for
+		 * IO_RW_EXTENDED of 511 blocks. */
+		max_blocks = min(min(
+			card->host->max_blk_count,
+			card->host->max_seg_size / func->cur_blksize),
+			511u);
+
+		if (card->remainder > func->cur_blksize) {
+			unsigned blocks;
+
+			blocks = card->remainder / func->cur_blksize;
+			if (blocks > max_blocks)
+				blocks = max_blocks;
+			card->size = blocks * func->cur_blksize;
+
+			mmc_io_rw_extended_start(
+				card, card->write, func->num,
+				card->addr, card->incr_addr,
+				card->buf, blocks, func->cur_blksize,
+				sdio_io_rw_async_ext_done, func);
+			return;
+		}
+	}
+
+	/* Write the remainder using byte mode. */
+	card->size = card->remainder;
+	if (card->size > func->cur_blksize)
+		card->size = func->cur_blksize;
+	if (card->size > 512)
+		card->size = 512; /* maximum size for byte mode */
+
+	mmc_io_rw_extended_start(card, card->write, func->num,
+				 card->addr, card->incr_addr,
+				 card->buf, 1, card->size,
+				 sdio_io_rw_async_ext_done, func);
+}
+
+static void sdio_io_rw_async_ext_helper(struct sdio_func *func, int write,
+	unsigned addr, int incr_addr, u8 *buf, unsigned size,
+	void (*done)(struct sdio_func *func))
+{
+	struct mmc_card *card = func->card;
+
+	card->done = done;
+	card->size = 0;
+	card->write = write;
+	card->addr = addr;
+	card->incr_addr = incr_addr;
+	card->buf = buf;
+	card->remainder = size;
+
+	sdio_io_rw_async_ext_start(func);
+}
+
 /* Split an arbitrarily sized data transfer into several
  * IO_RW_EXTENDED commands. */
 static int sdio_io_rw_ext_helper(struct sdio_func *func, int write,
@@ -283,6 +369,58 @@ unsigned char sdio_readb(struct sdio_fun
 EXPORT_SYMBOL_GPL(sdio_readb);
 
 /**
+ *	sdio_readb_start - start a single byte read from a SDIO function
+ *	@func: SDIO function to access
+ *	@addr: address to read
+ *	@done: callback function to call when the read is done
+ *      @done_done: data passed to the callback function
+ *
+ *	Reads a single byte from the address space of a given SDIO
+ *	function. If there is a problem reading the address, 0xff is
+ *	returned and the err parameter of the callback will contain
+ *	the error code.
+ */
+void sdio_readb_start(struct sdio_func *func, unsigned int addr,
+		      void (*done)(struct sdio_func *func))
+{
+	BUG_ON(!func);
+
+	func->card->done = done;
+	mmc_io_rw_direct_start(func->card, 0, func->num, addr, 0, 1,
+			       sdio_async_done, func);
+}
+EXPORT_SYMBOL_GPL(sdio_readb_start);
+
+/**
+ *	sdio_readb_result - get the result from a single byte read
+ *	@func: SDIO function to access
+ *	@addr: address to read
+ *	@err_ret: optional status value from transfer
+ *
+ *	Reads a single byte from the address space of a given SDIO
+ *	function. If there is a problem reading the address, 0xff
+ *	is returned and @err_ret will contain the error code.
+ */
+unsigned char sdio_readb_result(struct sdio_func *func, int *err_ret)
+{
+	int ret;
+	unsigned char val;
+
+	if (err_ret)
+		*err_ret = 0;
+
+	ret = mmc_io_rw_direct_result(func->card, &val);
+	if (ret) {
+		if (err_ret)
+			*err_ret = ret;
+		return 0xFF;
+	}
+
+	return val;
+}
+EXPORT_SYMBOL_GPL(sdio_readb_result);
+
+/**
  *	sdio_writeb - write a single byte to a SDIO function
  *	@func: SDIO function to access
  *	@b: byte to write
@@ -307,6 +445,75 @@ void sdio_writeb(struct sdio_func *func,
 EXPORT_SYMBOL_GPL(sdio_writeb);
 
 /**
+ *	sdio_writeb_start - start a single byte write to a SDIO function
+ *	@func: SDIO function to access
+ *	@b: byte to write
+ *	@addr: address to write to
+ *	@done: callback function to call when the read is done
+ *
+ *	Writes a single byte to the address space of a given SDIO
+ *	function.  If there is a problem writing the address err
+ *	parameter of the callback will contain the error code. */
+void sdio_writeb_start(struct sdio_func *func,
+		       unsigned char b, unsigned int addr,
+		       void (*done)(struct sdio_func *func))
+{
+	BUG_ON(!func);
+
+	func->card->done = done;
+	mmc_io_rw_direct_start(func->card, 1, func->num, addr, b, 0,
+			       sdio_async_done, func);
+}
+EXPORT_SYMBOL_GPL(sdio_writeb_start);
+
+/**
+ *	sdio_writeb_result - get the result from a single byte write
+ *	to a SDIO function
+ *	@func: SDIO function to access
+ *	@err_ret: optional status value from transfer
+ *
+ *	@err_ret will contain the status of the actual
+ *	transfer.
+ */
+void sdio_writeb_result(struct sdio_func *func, int *err_ret)
+{
+	int ret;
+
+	if (err_ret)
+		*err_ret = 0;
+
+	ret = mmc_io_rw_direct_result(func->card, NULL);
+	if (ret) {
+		if (err_ret)
+			*err_ret = ret;
+	}
+}
+EXPORT_SYMBOL_GPL(sdio_writeb_result);
+
+/**
+ *	sdio_block_io_result - get the result from a SDIO operation
+ *	@func: SDIO function to access
+ *	@err_ret: optional status value from transfer
+ *
+ *	@err_ret will contain the status of the actual
+ *	transfer.
+ */
+void sdio_block_io_result(struct sdio_func *func, int *err_ret)
+{
+	int ret;
+
+	if (err_ret)
+		*err_ret = 0;
+
+	ret = mmc_io_rw_extended_result(func->card);
+	if (ret) {
+		if (err_ret)
+			*err_ret = ret;
+	}
+}
+EXPORT_SYMBOL_GPL(sdio_block_io_result);
+
+/**
  *	sdio_memcpy_fromio - read a chunk of memory from a SDIO function
  *	@func: SDIO function to access
  *	@dst: buffer to store the data
@@ -359,6 +566,23 @@ int sdio_readsb(struct sdio_func *func, 
 EXPORT_SYMBOL_GPL(sdio_readsb);
 
 /**
+ *	sdio_readsb_start - start read from a FIFO on a SDIO function
+ *	@func: SDIO function to access
+ *	@dst: buffer to store the data
+ *	@addr: address of (single byte) FIFO
+ *	@count: number of bytes to read
+ *	@done: callback function to call when the read is done
+ *
+ *	Reads from the specified FIFO of a given SDIO function.
+ */
+void sdio_readsb_start(struct sdio_func *func, void *dst, unsigned int addr,
+		       int count, void (*done)(struct sdio_func *func))
+{
+	sdio_io_rw_async_ext_helper(func, 0, addr, 0, dst, count, done);
+}
+EXPORT_SYMBOL_GPL(sdio_readsb_start);
+
+/**
  *	sdio_writesb - write to a FIFO of a SDIO function
  *	@func: SDIO function to access
  *	@addr: address of (single byte) FIFO
Index: linux-2.6.26.2/drivers/mmc/core/sdio_ops.h
===================================================================
--- linux-2.6.26.2.orig/drivers/mmc/core/sdio_ops.h
+++ linux-2.6.26.2/drivers/mmc/core/sdio_ops.h
@@ -15,8 +15,17 @@
 int mmc_send_io_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr);
 int mmc_io_rw_direct(struct mmc_card *card, int write, unsigned fn,
 	unsigned addr, u8 in, u8* out);
+void mmc_io_rw_direct_start(struct mmc_card *card, int write, unsigned fn,
+			    unsigned addr, u8 in, bool want_out,
+			    void (*done)(struct mmc_request *),
+			    void *done_data);
+int mmc_io_rw_direct_result(struct mmc_card *card, u8 *out);
 int mmc_io_rw_extended(struct mmc_card *card, int write, unsigned fn,
 	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz);
+void mmc_io_rw_extended_start(struct mmc_card *card, int write, unsigned fn,
+	unsigned addr, int incr_addr, u8 *buf, unsigned blocks, unsigned blksz,
+	void (*done)(struct mmc_request *), void *done_data);
+int mmc_io_rw_extended_result(struct mmc_card *card);
 
 #endif
 
Index: linux-2.6.26.2/include/linux/mmc/core.h
===================================================================
--- linux-2.6.26.2.orig/include/linux/mmc/core.h
+++ linux-2.6.26.2/include/linux/mmc/core.h
@@ -129,6 +129,7 @@ struct mmc_request {
 struct mmc_host;
 struct mmc_card;
 
+extern void mmc_start_request(struct mmc_host *host, struct mmc_request *mrq);
 extern void mmc_wait_for_req(struct mmc_host *, struct mmc_request *);
 extern int mmc_wait_for_cmd(struct mmc_host *, struct mmc_command *, int);
 extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
Index: linux-2.6.26.2/include/linux/mmc/sdio_func.h
===================================================================
--- linux-2.6.26.2.orig/include/linux/mmc/sdio_func.h
+++ linux-2.6.26.2/include/linux/mmc/sdio_func.h
@@ -122,18 +122,30 @@ extern int sdio_release_irq(struct sdio_
 
 extern unsigned char sdio_readb(struct sdio_func *func,
 	unsigned int addr, int *err_ret);
+extern void sdio_readb_start(struct sdio_func *func, unsigned int addr,
+	void (*done)(struct sdio_func *func));
+extern unsigned char sdio_readb_result(struct sdio_func *func, int *err_ret);
 extern unsigned short sdio_readw(struct sdio_func *func,
 	unsigned int addr, int *err_ret);
 extern unsigned long sdio_readl(struct sdio_func *func,
 	unsigned int addr, int *err_ret);
 
+extern void sdio_block_io_result(struct sdio_func *func, int *err_ret);
+
 extern int sdio_memcpy_fromio(struct sdio_func *func, void *dst,
 	unsigned int addr, int count);
 extern int sdio_readsb(struct sdio_func *func, void *dst,
 	unsigned int addr, int count);
+extern void sdio_readsb_start(struct sdio_func *func, void *dst,
+	unsigned int addr, int count,
+	void (*done)(struct sdio_func *func));
 
 extern void sdio_writeb(struct sdio_func *func, unsigned char b,
 	unsigned int addr, int *err_ret);
+extern void sdio_writeb_start(struct sdio_func *func,
+	unsigned char b, unsigned int addr,
+	void (*done)(struct sdio_func *func));
+void sdio_writeb_result(struct sdio_func *func, int *err_ret);
 extern void sdio_writew(struct sdio_func *func, unsigned short b,
 	unsigned int addr, int *err_ret);
 extern void sdio_writel(struct sdio_func *func, unsigned long b,
Index: linux-2.6.26.2/include/linux/mmc/card.h
===================================================================
--- linux-2.6.26.2.orig/include/linux/mmc/card.h
+++ linux-2.6.26.2/include/linux/mmc/card.h
@@ -10,6 +10,8 @@
 #ifndef LINUX_MMC_CARD_H
 #define LINUX_MMC_CARD_H
 
+#include <linux/scatterlist.h>
+
 #include <linux/mmc/core.h>
 
 struct mmc_cid {
@@ -111,6 +113,20 @@ struct mmc_card {
 	unsigned		num_info;	/* number of info strings */
 	const char		**info;		/* info strings */
 	struct sdio_func_tuple	*tuples;	/* unknown common tuples */
+
+	/* state used internally by asynchronous operations */
+	struct mmc_command	cmd;		/* current command */
+	struct mmc_request	mrq;		/* current request */
+	struct mmc_data		data;		/* data for current
+						 * request */
+	struct scatterlist	sg;		/*  */
+	void			(*done)(struct sdio_func *func); /* called when request done */
+	unsigned		remainder;	/* amount of data left for block operation */
+	int			write;		/* true if this is a write operation */
+	unsigned		addr;		/* address for operation */
+	int			incr_addr;	/* true if a block operation should increment the address */
+	u8			*buf;		/* the buffer for a block operation */
+	unsigned		size;		/* the size of a block operation */
 };
 
 #define mmc_card_mmc(c)		((c)->type == MMC_TYPE_MMC)

-- 
"Just how much can I get away with and still go to heaven?"

Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
