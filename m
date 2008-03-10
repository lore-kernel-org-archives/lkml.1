Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbYCJL0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbYCJL0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 07:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbYCJL0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 07:26:22 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:49927 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYCJL0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 07:26:21 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: dan.j.williams@intel.com, sfr@canb.auug.org.au
Cc: linux-kernel@vger.kernel.org, Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH] Fix fsldma.c warning messages when it's compiled under PPC64.
Date: Mon, 10 Mar 2008 18:47:25 +0800
Message-Id: <1205146045-17342-1-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
X-OriginalArrivalTime: 10 Mar 2008 10:49:15.0499 (UTC) FILETIME=[6240EBB0:01C8829C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are warning messages reported by Stephen Rothwell with
ARCH=powerpc allmodconfig build:

drivers/dma/fsldma.c: In function 'fsl_dma_prep_memcpy':
drivers/dma/fsldma.c:439: warning: comparison of distinct pointer types
lacks a cast
drivers/dma/fsldma.c: In function 'fsl_chan_xfer_ld_queue':
drivers/dma/fsldma.c:584: warning: format '%016llx' expects type 'long long
unsigned int', but argument 4 has type 'dma_addr_t'
drivers/dma/fsldma.c: In function 'fsl_dma_chan_do_interrupt':
drivers/dma/fsldma.c:668: warning: format '%x' expects type 'unsigned int',
but argument 5 has type 'dma_addr_t'
drivers/dma/fsldma.c:684: warning: format '%016llx' expects type 'long long
unsigned int', but argument 4 has type 'dma_addr_t'
drivers/dma/fsldma.c:684: warning: format '%016llx' expects type 'long long
unsigned int', but argument 5 has type 'dma_addr_t'
drivers/dma/fsldma.c:701: warning: format '%02x' expects type 'unsigned
int', but argument 4 has type 'dma_addr_t'
drivers/dma/fsldma.c: In function 'fsl_dma_self_test':
drivers/dma/fsldma.c:840: warning: format '%d' expects type 'int', but
argument 5 has type 'size_t'
drivers/dma/fsldma.c: In function 'of_fsl_dma_probe':
drivers/dma/fsldma.c:1010: warning: format '%08x' expects type 'unsigned
int', but argument 5 has type 'resource_size_t'

This patch fixed the above warning messages.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 drivers/dma/fsldma.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index cc9a681..5dfedf3 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -57,12 +57,12 @@ static void dma_init(struct fsl_dma_chan *fsl_chan)
 
 }
 
-static void set_sr(struct fsl_dma_chan *fsl_chan, dma_addr_t val)
+static void set_sr(struct fsl_dma_chan *fsl_chan, u32 val)
 {
 	DMA_OUT(fsl_chan, &fsl_chan->reg_base->sr, val, 32);
 }
 
-static dma_addr_t get_sr(struct fsl_dma_chan *fsl_chan)
+static u32 get_sr(struct fsl_dma_chan *fsl_chan)
 {
 	return DMA_IN(fsl_chan, &fsl_chan->reg_base->sr, 32);
 }
@@ -436,7 +436,7 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 		dev_dbg(fsl_chan->dev, "new link desc alloc %p\n", new);
 #endif
 
-		copy = min(len, FSL_DMA_BCR_MAX_CNT);
+		copy = min(len, (size_t)FSL_DMA_BCR_MAX_CNT);
 
 		set_desc_cnt(fsl_chan, &new->hw, copy);
 		set_desc_src(fsl_chan, &new->hw, dma_src);
@@ -581,8 +581,8 @@ static void fsl_chan_xfer_ld_queue(struct fsl_dma_chan *fsl_chan)
 	if (ld_node != &fsl_chan->ld_queue) {
 		/* Get the ld start address from ld_queue */
 		next_dest_addr = to_fsl_desc(ld_node)->async_tx.phys;
-		dev_dbg(fsl_chan->dev, "xfer LDs staring from 0x%016llx\n",
-				(u64)next_dest_addr);
+		dev_dbg(fsl_chan->dev, "xfer LDs staring from %p\n",
+				(void *)next_dest_addr);
 		set_cdar(fsl_chan, next_dest_addr);
 		dma_start(fsl_chan);
 	} else {
@@ -662,7 +662,7 @@ static enum dma_status fsl_dma_is_complete(struct dma_chan *chan,
 static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
 {
 	struct fsl_dma_chan *fsl_chan = (struct fsl_dma_chan *)data;
-	dma_addr_t stat;
+	u32 stat;
 
 	stat = get_sr(fsl_chan);
 	dev_dbg(fsl_chan->dev, "event: channel %d, stat = 0x%x\n",
@@ -681,9 +681,8 @@ static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
 	 */
 	if (stat & FSL_DMA_SR_EOSI) {
 		dev_dbg(fsl_chan->dev, "event: End-of-segments INT\n");
-		dev_dbg(fsl_chan->dev, "event: clndar 0x%016llx, "
-				"nlndar 0x%016llx\n", (u64)get_cdar(fsl_chan),
-				(u64)get_ndar(fsl_chan));
+		dev_dbg(fsl_chan->dev, "event: clndar %p, nlndar %p\n",
+			(void *)get_cdar(fsl_chan), (void *)get_ndar(fsl_chan));
 		stat &= ~FSL_DMA_SR_EOSI;
 	}
 
@@ -726,12 +725,15 @@ static void dma_do_tasklet(unsigned long data)
 	fsl_chan_ld_cleanup(fsl_chan);
 }
 
+#ifdef FSL_DMA_CALLBACKTEST
 static void fsl_dma_callback_test(struct fsl_dma_chan *fsl_chan)
 {
 	if (fsl_chan)
 		dev_info(fsl_chan->dev, "selftest: callback is ok!\n");
 }
+#endif
 
+#ifdef CONFIG_FSL_DMA_SELFTEST
 static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 {
 	struct dma_chan *chan;
@@ -837,9 +839,9 @@ static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 	if (err) {
 		for (i = 0; (*(src + i) == *(dest + i)) && (i < test_size);
 				i++);
-		dev_err(fsl_chan->dev, "selftest: Test failed, data %d/%d is "
+		dev_err(fsl_chan->dev, "selftest: Test failed, data %d/%ld is "
 				"error! src 0x%x, dest 0x%x\n",
-				i, test_size, *(src + i), *(dest + i));
+				i, (long)test_size, *(src + i), *(dest + i));
 	}
 
 free_resources:
@@ -848,6 +850,7 @@ out:
 	kfree(src);
 	return err;
 }
+#endif
 
 static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 			const struct of_device_id *match)
@@ -1008,8 +1011,8 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
 	}
 
 	dev_info(&dev->dev, "Probe the Freescale DMA driver for %s "
-			"controller at 0x%08x...\n",
-			match->compatible, fdev->reg.start);
+			"controller at %p...\n",
+			match->compatible, (void *)fdev->reg.start);
 	fdev->reg_base = ioremap(fdev->reg.start, fdev->reg.end
 						- fdev->reg.start + 1);
 
-- 
1.5.4

