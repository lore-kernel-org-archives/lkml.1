Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbYIWU3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbYIWU3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYIWU3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:29:34 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:60081 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbYIWU3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:29:33 -0400
From: Timur Tabi <timur@freescale.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       dan.j.williams@intel.com, scottwood@freescale.com,
       galak@kernel.crashing.org, leoli@freescale.com
Subject: [PATCH] fsldma: remove internal self-test from Freescale Elo DMA driver
Date: Tue, 23 Sep 2008 15:29:16 -0500
Message-Id: <1222201756-21374-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Freescale Elo DMA driver runs an internal self-test before registering
the channels with the DMA engine.  This self-test has a fundemental flaw in
that it calls the DMA engine's callback functions directly before the
registration.  However, the registration initializes some variables that the
callback functions uses, namely the device struct.

The code works today because there are two device structs: the one created
by the DMA engine, and one created by the Open Firmware (OF) subsystem.  The
self-test currently uses the device struct created by OF.  However, in the
future, some of the device structs created by OF will be eliminated.
This means that the self-test will only have access to the device struct
created by the DMA engine.  But this device struct isn't initialized when
the self-test runs, and this causes a kernel panic.

Since there is already a DMA test module (dmatest), the internal self-test
code is not useful anyway.  It is extremely unlikely that the test will fail
in normal usage.  It may have been helpful during development, but not any more.

Signed-off-by: Timur Tabi <timur@freescale.com>
---

This patch is for 2.6.28.

 drivers/dma/fsldma.c |  132 --------------------------------------------------
 1 files changed, 0 insertions(+), 132 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index c0059ca..e9b2638 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -786,132 +786,6 @@ static void dma_do_tasklet(unsigned long data)
 	fsl_chan_ld_cleanup(fsl_chan);
 }
 
-static void fsl_dma_callback_test(void *param)
-{
-	struct fsl_dma_chan *fsl_chan = param;
-	if (fsl_chan)
-		dev_dbg(fsl_chan->dev, "selftest: callback is ok!\n");
-}
-
-static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
-{
-	struct dma_chan *chan;
-	int err = 0;
-	dma_addr_t dma_dest, dma_src;
-	dma_cookie_t cookie;
-	u8 *src, *dest;
-	int i;
-	size_t test_size;
-	struct dma_async_tx_descriptor *tx1, *tx2, *tx3;
-
-	test_size = 4096;
-
-	src = kmalloc(test_size * 2, GFP_KERNEL);
-	if (!src) {
-		dev_err(fsl_chan->dev,
-				"selftest: Cannot alloc memory for test!\n");
-		return -ENOMEM;
-	}
-
-	dest = src + test_size;
-
-	for (i = 0; i < test_size; i++)
-		src[i] = (u8) i;
-
-	chan = &fsl_chan->common;
-
-	if (fsl_dma_alloc_chan_resources(chan, NULL) < 1) {
-		dev_err(fsl_chan->dev,
-				"selftest: Cannot alloc resources for DMA\n");
-		err = -ENODEV;
-		goto out;
-	}
-
-	/* TX 1 */
-	dma_src = dma_map_single(fsl_chan->dev, src, test_size / 2,
-				 DMA_TO_DEVICE);
-	dma_dest = dma_map_single(fsl_chan->dev, dest, test_size / 2,
-				  DMA_FROM_DEVICE);
-	tx1 = fsl_dma_prep_memcpy(chan, dma_dest, dma_src, test_size / 2, 0);
-	async_tx_ack(tx1);
-
-	cookie = fsl_dma_tx_submit(tx1);
-	fsl_dma_memcpy_issue_pending(chan);
-	msleep(2);
-
-	if (fsl_dma_is_complete(chan, cookie, NULL, NULL) != DMA_SUCCESS) {
-		dev_err(fsl_chan->dev, "selftest: Time out!\n");
-		err = -ENODEV;
-		goto free_resources;
-	}
-
-	/* Test free and re-alloc channel resources */
-	fsl_dma_free_chan_resources(chan);
-
-	if (fsl_dma_alloc_chan_resources(chan, NULL) < 1) {
-		dev_err(fsl_chan->dev,
-				"selftest: Cannot alloc resources for DMA\n");
-		err = -ENODEV;
-		goto free_resources;
-	}
-
-	/* Continue to test
-	 * TX 2
-	 */
-	dma_src = dma_map_single(fsl_chan->dev, src + test_size / 2,
-					test_size / 4, DMA_TO_DEVICE);
-	dma_dest = dma_map_single(fsl_chan->dev, dest + test_size / 2,
-					test_size / 4, DMA_FROM_DEVICE);
-	tx2 = fsl_dma_prep_memcpy(chan, dma_dest, dma_src, test_size / 4, 0);
-	async_tx_ack(tx2);
-
-	/* TX 3 */
-	dma_src = dma_map_single(fsl_chan->dev, src + test_size * 3 / 4,
-					test_size / 4, DMA_TO_DEVICE);
-	dma_dest = dma_map_single(fsl_chan->dev, dest + test_size * 3 / 4,
-					test_size / 4, DMA_FROM_DEVICE);
-	tx3 = fsl_dma_prep_memcpy(chan, dma_dest, dma_src, test_size / 4, 0);
-	async_tx_ack(tx3);
-
-	/* Interrupt tx test */
-	tx1 = fsl_dma_prep_interrupt(chan, 0);
-	async_tx_ack(tx1);
-	cookie = fsl_dma_tx_submit(tx1);
-
-	/* Test exchanging the prepared tx sort */
-	cookie = fsl_dma_tx_submit(tx3);
-	cookie = fsl_dma_tx_submit(tx2);
-
-	if (dma_has_cap(DMA_INTERRUPT, ((struct fsl_dma_device *)
-	    dev_get_drvdata(fsl_chan->dev->parent))->common.cap_mask)) {
-		tx3->callback = fsl_dma_callback_test;
-		tx3->callback_param = fsl_chan;
-	}
-	fsl_dma_memcpy_issue_pending(chan);
-	msleep(2);
-
-	if (fsl_dma_is_complete(chan, cookie, NULL, NULL) != DMA_SUCCESS) {
-		dev_err(fsl_chan->dev, "selftest: Time out!\n");
-		err = -ENODEV;
-		goto free_resources;
-	}
-
-	err = memcmp(src, dest, test_size);
-	if (err) {
-		for (i = 0; (*(src + i) == *(dest + i)) && (i < test_size);
-				i++);
-		dev_err(fsl_chan->dev, "selftest: Test failed, data %d/%ld is "
-				"error! src 0x%x, dest 0x%x\n",
-				i, (long)test_size, *(src + i), *(dest + i));
-	}
-
-free_resources:
-	fsl_dma_free_chan_resources(chan);
-out:
-	kfree(src);
-	return err;
-}
-
 static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 			const struct of_device_id *match)
 {
@@ -1000,17 +874,11 @@ static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 		}
 	}
 
-	err = fsl_dma_self_test(new_fsl_chan);
-	if (err)
-		goto err_self_test;
-
 	dev_info(&dev->dev, "#%d (%s), irq %d\n", new_fsl_chan->id,
 				match->compatible, new_fsl_chan->irq);
 
 	return 0;
 
-err_self_test:
-	free_irq(new_fsl_chan->irq, new_fsl_chan);
 err_no_irq:
 	list_del(&new_fsl_chan->common.device_node);
 err_no_chan:
-- 
1.5.5

