Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbXHGM4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbXHGM4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760770AbXHGMz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:55:57 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:59229 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933991AbXHGMzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:55:55 -0400
Message-ID: <46B86B88.5050009@csr.com>
Date: Tue, 07 Aug 2007 13:54:32 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: [patch 2/4] sdio: set the functions' block size
References: <11858961933491-git-send-email-david.vrabel@csr.com>	<20070804152304.65ed8f1b@poseidon.drzeus.cx>	<46B6F877.7060504@csr.com>	<20070806171207.59fafa18@poseidon.drzeus.cx>	<46B73F18.5030109@csr.com> <20070806220145.66b97559@poseidon.drzeus.cx> <46B86ADB.90000@csr.com>
In-Reply-To: <46B86ADB.90000@csr.com>
Content-Type: multipart/mixed;
 boundary="------------060605060408080904010905"
X-OriginalArrivalTime: 07 Aug 2007 12:54:38.0731 (UTC) FILETIME=[1D3905B0:01C7D8F2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060605060408080904010905
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.

--------------060605060408080904010905
Content-Type: text/x-patch;
 name="sdio-set-the-functions-block-size.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="sdio-set-the-functions-block-size.patch"

sdio: set the functions' block size

During function initialization, set the functions' block size to the
largest that's supported by both the card and the host.

Signed-off-by: David Vrabel <david.vrabel@csr.com>
---
Index: mmc/drivers/mmc/core/sdio_cis.c
===================================================================
--- mmc.orig/drivers/mmc/core/sdio_cis.c	2007-08-07 00:38:33.000000000 +0100
+++ mmc/drivers/mmc/core/sdio_cis.c	2007-08-07 00:38:33.000000000 +0100
@@ -145,9 +145,9 @@
 	printk(KERN_DEBUG "%s: TPLFE_CSA_PROPERTY = 0x%02x\n",
 	       sdio_func_id(func), val);
 	/* TPLFE_MAX_BLK_SIZE */
-	func->blksize = buf[12] | (buf[13] << 8);
+	func->max_blksize = buf[12] | (buf[13] << 8);
 	printk(KERN_DEBUG "%s: TPLFE_MAX_BLK_SIZE = %u\n",
-	       sdio_func_id(func), (unsigned)func->blksize);
+	       sdio_func_id(func), (unsigned)func->max_blksize);
 	/* TPLFE_OCR */
 	val = buf[14] | (buf[15] << 8) | (buf[16] << 16) | (buf[17] << 24);
 	printk(KERN_DEBUG "%s: TPLFE_OCR = 0x%08x\n",
Index: mmc/drivers/mmc/core/sdio_io.c
===================================================================
--- mmc.orig/drivers/mmc/core/sdio_io.c	2007-08-07 00:38:31.000000000 +0100
+++ mmc/drivers/mmc/core/sdio_io.c	2007-08-07 07:17:33.000000000 +0100
@@ -145,6 +145,31 @@
 EXPORT_SYMBOL_GPL(sdio_disable_func);
 
 /**
+ *	sdio_set_block_size - set the block size of an SDIO function
+ *	@func: SDIO function to change
+ *	@blksz: new block size
+ */
+int sdio_set_block_size(struct sdio_func *func, unsigned blksz)
+{
+	int ret;
+
+	ret = mmc_io_rw_direct(func->card, 1, 0,
+		SDIO_FBR_BASE(func->num) + SDIO_FBR_BLKSIZE,
+		blksz & 0xff, NULL);
+	if (ret)
+		return ret;
+	ret = mmc_io_rw_direct(func->card, 1, 0,
+		SDIO_FBR_BASE(func->num) + SDIO_FBR_BLKSIZE + 1,
+		(blksz >> 8) & 0xff, NULL);
+	if (ret)
+		return ret;
+	func->cur_blksize = blksz;
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(sdio_set_block_size);
+
+/**
  *	sdio_readb - read a single byte from a SDIO function
  *	@func: SDIO function to access
  *	@addr: address to read
Index: mmc/include/linux/mmc/sdio_func.h
===================================================================
--- mmc.orig/include/linux/mmc/sdio_func.h	2007-08-07 00:38:31.000000000 +0100
+++ mmc/include/linux/mmc/sdio_func.h	2007-08-07 07:18:10.000000000 +0100
@@ -43,7 +43,8 @@
 	unsigned short		vendor;		/* vendor id */
 	unsigned short		device;		/* device id */
 
-	unsigned short		blksize;	/* maximum block size */
+	unsigned		max_blksize;	/* maximum block size */
+	unsigned		cur_blksize;	/* current block size */
 
 	unsigned int		state;		/* function state */
 #define SDIO_STATE_PRESENT	(1<<0)		/* present in sysfs */
@@ -109,6 +110,8 @@
 extern int sdio_enable_func(struct sdio_func *func);
 extern int sdio_disable_func(struct sdio_func *func);
 
+extern int sdio_set_block_size(struct sdio_func *func, unsigned blksz);
+
 extern int sdio_claim_irq(struct sdio_func *func, sdio_irq_handler_t *handler);
 extern int sdio_release_irq(struct sdio_func *func);
 
Index: mmc/drivers/mmc/core/sdio.c
===================================================================
--- mmc.orig/drivers/mmc/core/sdio.c	2007-08-07 00:38:33.000000000 +0100
+++ mmc/drivers/mmc/core/sdio.c	2007-08-07 07:17:29.000000000 +0100
@@ -53,6 +53,7 @@
 {
 	int ret;
 	struct sdio_func *func;
+	unsigned block_size;
 
 	BUG_ON(fn > SDIO_MAX_FUNCS);
 
@@ -70,6 +71,15 @@
 	if (ret)
 		goto fail;
 
+	/*
+	 * Set the function's block size to the largest supported by
+	 * both the function and the host.
+	 */
+	block_size = min(func->max_blksize, func->card->host->max_blk_size);
+	ret = sdio_set_block_size(func, block_size);
+	if (ret)
+		goto fail;
+
 	card->sdio_func[fn - 1] = func;
 
 	return 0;

--------------060605060408080904010905--
