Return-Path: <linux-kernel-owner+w=401wt.eu-S1765236AbXGaQBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765236AbXGaQBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbXGaQBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:01:24 -0400
Received: from fizeau.zen.co.uk ([212.23.8.67]:56797 "EHLO fizeau.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803AbXGaQBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:01:23 -0400
X-Greylist: delayed 1236 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 12:01:22 EDT
From: David Vrabel <david.vrabel@csr.com>
To: linux-kernel@vger.kernel.org
Cc: David Vrabel <david.vrabel@csr.com>, Pierre Ossman <drzeus-list@drzeus.cx>
Subject: sdio: set the functions' block size
Date: Tue, 31 Jul 2007 16:36:32 +0100
Message-Id: <1185896193612-git-send-email-david.vrabel@csr.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11858961933491-git-send-email-david.vrabel@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: david@pear.davidvrabel.org.uk
X-SA-Exim-Scanned: No (on pear.davidvrabel.org.uk); SAEximRunCond expanded to false
X-Originating-Pythagoras-IP: [82.70.146.41]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to calling the driver's probe(), set the functions' block size to the
largest that's supported by both the card and the driver.

Signed-off-by: David Vrabel <david.vrabel@csr.com>

---
commit 6d367fd822cbb2b8089ab7ef83f706f1984ab25b
tree 8c9cc84b4c8c1c8f959abe540aa02f14aa95c51d
parent 51755c3d59be1ba778bef45888f9f5e341dc4af4
author David Vrabel <david.vrabel@csr.com> Mon, 30 Jul 2007 19:58:54 +0100
committer David Vrabel <dvrabel@cantab.net> Mon, 30 Jul 2007 19:58:54 +0100

 drivers/mmc/core/sdio_bus.c   |   13 +++++++++++++
 drivers/mmc/core/sdio_cis.c   |    8 ++++----
 drivers/mmc/core/sdio_io.c    |   23 +++++++++++++++++++++++
 include/linux/mmc/sdio_func.h |    7 +++++++
 4 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index a3ac1aa..f4d40c1 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -127,11 +127,24 @@ static int sdio_bus_probe(struct device *dev)
 	struct sdio_driver *drv = to_sdio_driver(dev->driver);
 	struct sdio_func *func = dev_to_sdio_func(dev);
 	const struct sdio_device_id *id;
+	unsigned short block_size;
+	int ret;
 
 	id = sdio_match_device(func, drv);
 	if (!id)
 		return -ENODEV;
 
+	/*
+	 * Set the function's block size to the largest supported by
+	 * both the function and the driver.
+	 */
+	block_size = min(drv->max_block_size, func->max_block_size);
+	sdio_claim_host(func);
+	ret = sdio_set_block_size(func, block_size);
+	sdio_release_host(func);
+	if (ret)
+		return ret;
+
 	return drv->probe(func, id);
 }
 
diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index 8aa4666..c16c536 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -93,9 +93,9 @@ static int cistpl_funce(struct sdio_func *func, unsigned fn,
 		if (size < 0x04 || buf[0] != 0)
 			goto bad;
 		/* TPLFE_FN0_BLK_SIZE */
-		val = buf[1] | (buf[2] << 8);
+		func->max_block_size = buf[1] | (buf[2] << 8);
 		printk(KERN_DEBUG "%s: TPLFE_FN0_BLK_SIZE = %u\n",
-		       sdio_func_id(func), val);
+		       sdio_func_id(func), func->max_block_size);
 		/* TPLFE_MAX_TRAN_SPEED */
 		val = speed_val[(buf[3] >> 3) & 15] * speed_unit[buf[3] & 7];
 		printk(KERN_DEBUG "%s: max speed = %u kbps\n",
@@ -126,9 +126,9 @@ static int cistpl_funce(struct sdio_func *func, unsigned fn,
 		printk(KERN_DEBUG "%s: TPLFE_CSA_PROPERTY = 0x%02x\n",
 		       sdio_func_id(func), val);
 		/* TPLFE_MAX_BLK_SIZE */
-		val = buf[12] | (buf[13] << 8);
+		func->max_block_size = buf[12] | (buf[13] << 8);
 		printk(KERN_DEBUG "%s: TPLFE_MAX_BLK_SIZE = %u\n",
-		       sdio_func_id(func), val);
+		       sdio_func_id(func), func->max_block_size);
 		/* TPLFE_OCR */
 		val = buf[14] | (buf[15] << 8) | (buf[16] << 16) | (buf[17] << 24);
 		printk(KERN_DEBUG "%s: TPLFE_OCR = 0x%08x\n",
diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index cc62ff7..e74e605 100644
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -148,6 +148,29 @@ err:
 EXPORT_SYMBOL_GPL(sdio_disable_func);
 
 /**
+ *	sdio_set_block_size - set the block size of an SDIO function
+ *	@func: SDIO function to change
+ *	@blksz: new block size
+ */
+int sdio_set_block_size(struct sdio_func *func, unsigned short blksz)
+{
+	int ret;
+
+	ret = mmc_io_rw_direct(func->card, 1, 0, SDIO_FBR_BLKSIZE(func->num),
+			       blksz & 0xff, NULL);
+	if (ret)
+		return ret;
+	ret = mmc_io_rw_direct(func->card, 1, 0, SDIO_FBR_BLKSIZE(func->num) + 1,
+			       (blksz >> 8) & 0xff, NULL);
+	if (ret)
+		return ret;
+	func->block_size = blksz;
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(sdio_set_block_size);
+
+/**
  *	sdio_readb - read a single byte from a SDIO function
  *	@func: SDIO function to access
  *	@addr: address to read
diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
index e34bc96..bfb0432 100644
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -43,6 +43,9 @@ struct sdio_func {
 	unsigned short		vendor;		/* vendor id */
 	unsigned short		device;		/* device id */
 
+	unsigned short		max_block_size; /* max block size supported */
+	unsigned short		block_size;	/* current block size */
+
 	unsigned int		state;		/* function state */
 #define SDIO_STATE_PRESENT	(1<<0)		/* present in sysfs */
 
@@ -68,6 +71,8 @@ struct sdio_driver {
 	int (*probe)(struct sdio_func *, const struct sdio_device_id *);
 	void (*remove)(struct sdio_func *);
 
+	unsigned short max_block_size; /* max block size supported by driver */
+
 	struct device_driver drv;
 };
 
@@ -107,6 +112,8 @@ extern void sdio_release_host(struct sdio_func *func);
 extern int sdio_enable_func(struct sdio_func *func);
 extern int sdio_disable_func(struct sdio_func *func);
 
+extern int sdio_set_block_size(struct sdio_func *func, unsigned short blksz);
+
 extern int sdio_claim_irq(struct sdio_func *func, sdio_irq_handler_t *handler);
 extern int sdio_release_irq(struct sdio_func *func);
 
