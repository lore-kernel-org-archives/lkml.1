Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbYCNIul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbYCNIul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 04:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYCNIuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 04:50:32 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:51909 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYCNIub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 04:50:31 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH] fsldma: Fix the DMA halt when using DMA_INTERRUPT async_tx transfer.
Date: Fri, 14 Mar 2008 16:47:36 +0800
Message-Id: <1205484456-28605-1-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
X-OriginalArrivalTime: 14 Mar 2008 08:50:20.0356 (UTC) FILETIME=[6F078040:01C885B0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA_INTERRUPT async_tx is a NULL transfer, thus the BCR(count register)
is 0. When the transfer started with a byte count of zero, the DMA
controller will triger a PE(programming error) event and halt, not a normal
interrupt. I add special codes for PE event and DMA_INTERRUPT
async_tx testing.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 drivers/dma/fsldma.c |   30 ++++++++++++++++++++++++++++++
 drivers/dma/fsldma.h |    1 +
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 7c957c3..fb6be31 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -123,6 +123,11 @@ static dma_addr_t get_ndar(struct fsl_dma_chan *fsl_chan)
 	return DMA_IN(fsl_chan, &fsl_chan->reg_base->ndar, 64);
 }
 
+static u32 get_bcr(struct fsl_dma_chan *fsl_chan)
+{
+	return DMA_IN(fsl_chan, &fsl_chan->reg_base->bcr, 32);
+}
+
 static int dma_is_idle(struct fsl_dma_chan *fsl_chan)
 {
 	u32 sr = get_sr(fsl_chan);
@@ -426,6 +431,9 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_interrupt(
 	new->async_tx.cookie = -EBUSY;
 	new->async_tx.ack = 0;
 
+	/* Insert the link descriptor to the LD ring */
+	list_add_tail(&new->node, &new->async_tx.tx_list);
+
 	/* Set End-of-link to the last link descriptor of new list*/
 	set_ld_eol(fsl_chan, new);
 
@@ -701,6 +709,23 @@ static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
 	if (stat & FSL_DMA_SR_TE)
 		dev_err(fsl_chan->dev, "Transfer Error!\n");
 
+	/* Programming Error
+	 * The DMA_INTERRUPT async_tx is a NULL transfer, which will
+	 * triger a PE interrupt.
+	 */
+	if (stat & FSL_DMA_SR_PE) {
+		dev_dbg(fsl_chan->dev, "event: Programming Error INT\n");
+		if (get_bcr(fsl_chan) == 0) {
+			/* BCR register is 0, this is a DMA_INTERRUPT async_tx.
+			 * Now, update the completed cookie, and continue the
+			 * next uncompleted transfer.
+			 */
+			fsl_dma_update_completed_cookie(fsl_chan);
+			fsl_chan_xfer_ld_queue(fsl_chan);
+		}
+		stat &= ~FSL_DMA_SR_PE;
+	}
+
 	/* If the link descriptor segment transfer finishes,
 	 * we will recycle the used descriptor.
 	 */
@@ -841,6 +866,11 @@ static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 	tx3 = fsl_dma_prep_memcpy(chan, dma_dest, dma_src, test_size / 4, 0);
 	async_tx_ack(tx3);
 
+	/* Interrupt tx test */
+	tx1 = fsl_dma_prep_interrupt(chan);
+	async_tx_ack(tx1);
+	cookie = fsl_dma_tx_submit(tx1);
+
 	/* Test exchanging the prepared tx sort */
 	cookie = fsl_dma_tx_submit(tx3);
 	cookie = fsl_dma_tx_submit(tx2);
diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
index ba78c42..fddd6ae 100644
--- a/drivers/dma/fsldma.h
+++ b/drivers/dma/fsldma.h
@@ -40,6 +40,7 @@
 #define FSL_DMA_MR_EOTIE	0x00000080
 
 #define FSL_DMA_SR_CH		0x00000020
+#define FSL_DMA_SR_PE		0x00000010
 #define FSL_DMA_SR_CB		0x00000004
 #define FSL_DMA_SR_TE		0x00000080
 #define FSL_DMA_SR_EOSI		0x00000002
-- 
1.5.4

