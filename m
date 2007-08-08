Return-Path: <linux-kernel-owner+w=401wt.eu-S1765888AbXHHNZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765888AbXHHNZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbXHHNZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:25:22 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:53193 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbXHHNZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:25:20 -0400
Message-ID: <46B9C3E4.6050104@csr.com>
Date: Wed, 08 Aug 2007 14:23:48 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: [patch 2/3] sdio: set the functions' block size
References: <11858961933491-git-send-email-david.vrabel@csr.com>	<20070804152304.65ed8f1b@poseidon.drzeus.cx>	<46B6F877.7060504@csr.com>	<20070806171207.59fafa18@poseidon.drzeus.cx>	<46B73F18.5030109@csr.com>	<20070806220145.66b97559@poseidon.drzeus.cx>	<46B86ADB.90000@csr.com>	<46B86BB0.4000100@csr.com>	<20070807221719.7c89e5b6@poseidon.drzeus.cx>	<46B998B5.9040203@csr.com> <20070808123759.26a74b2a@poseidon.drzeus.cx> <46B9C38C.1030708@csr.com>
In-Reply-To: <46B9C38C.1030708@csr.com>
Content-Type: multipart/mixed;
 boundary="------------020507000704010609040908"
X-OriginalArrivalTime: 08 Aug 2007 13:23:48.0808 (UTC) FILETIME=[5AC35480:01C7D9BF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020507000704010609040908
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.

--------------020507000704010609040908
Content-Type: text/x-patch;
 name="sdio-set-the-functions-block-size.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="sdio-set-the-functions-block-size.patch"

sdio: set the functions' block size

Before a driver is probed, set the function's block size to the default so the
driver is sure the block size is something sensible and it needn't explicitly
set it.

The default block size is the largest that's supported by both the card and
the host, with a maximum of 512 to ensure aribitrarily sized transfer use the
optimal (least) number of commands.

See http://lkml.org/lkml/2007/8/7/150 for reasons for the block size choice.

Signed-off-by: David Vrabel <david.vrabel@csr.com>
---
Index: mmc/drivers/mmc/core/sdio_cis.c
===================================================================
--- mmc.orig/drivers/mmc/core/sdio_cis.c	2007-08-08 13:29:56.000000000 +0100
+++ mmc/drivers/mmc/core/sdio_cis.c	2007-08-08 13:30:21.000000000 +0100
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
--- mmc.orig/drivers/mmc/core/sdio_io.c	2007-08-08 13:29:47.000000000 +0100
+++ mmc/drivers/mmc/core/sdio_io.c	2007-08-08 13:34:09.000000000 +0100
@@ -145,6 +145,55 @@
 EXPORT_SYMBOL_GPL(sdio_disable_func);
 
 /**
+ *	sdio_set_block_size - set the block size of an SDIO function
+ *	@func: SDIO function to change
+ *	@blksz: new block size or 0 to use the default.
+ *
+ *	The default block size is the largest supported by both the function
+ *	and the host, with a maximum of 512 to ensure that arbitrarily sized
+ *	data transfer use the optimal (least) number of commands.
+ *
+ *	A driver may call this to override the default block size set by the
+ *	core. This can be used to set a block size greater than the maximum
+ *	that reported by the card; it is the driver's responsibility to ensure
+ *	it uses a value that the card supports.
+ *
+ *	Returns 0 on success, -EINVAL if the host does not support the
+ *	requested block size, or -EIO (etc.) if one of the resultant FBR block
+ *	size register writes failed.
+ *
+ */
+int sdio_set_block_size(struct sdio_func *func, unsigned blksz)
+{
+	int ret;
+
+	if (blksz > func->card->host->max_blk_size)
+		return -EINVAL;
+
+	if (blksz == 0) {
+		blksz = min(min(
+			func->max_blksize,
+			func->card->host->max_blk_size),
+			512u);
+	}
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
--- mmc.orig/include/linux/mmc/sdio_func.h	2007-08-08 13:29:47.000000000 +0100
+++ mmc/include/linux/mmc/sdio_func.h	2007-08-08 13:30:21.000000000 +0100
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
 
Index: mmc/drivers/mmc/core/sdio_bus.c
===================================================================
--- mmc.orig/drivers/mmc/core/sdio_bus.c	2007-08-08 13:29:47.000000000 +0100
+++ mmc/drivers/mmc/core/sdio_bus.c	2007-08-08 13:30:21.000000000 +0100
@@ -128,11 +128,18 @@
 	struct sdio_driver *drv = to_sdio_driver(dev->driver);
 	struct sdio_func *func = dev_to_sdio_func(dev);
 	const struct sdio_device_id *id;
+	int ret;
 
 	id = sdio_match_device(func, drv);
 	if (!id)
 		return -ENODEV;
 
+	/* Set the default block size so the driver is sure it's something
+	 * sensible. */
+	ret = sdio_set_block_size(func, 0);
+	if (ret)
+		return ret;
+
 	return drv->probe(func, id);
 }
 

--------------020507000704010609040908--
