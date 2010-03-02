Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab0CBUMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 15:12:36 -0500
Received: from mail.df.lth.se ([194.47.250.12]:59606 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756350Ab0CBUMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 15:12:30 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 2/5] DMAENGINE: COH 901 318 descriptor pool refactoring
Date: Tue,  2 Mar 2010 21:12:26 +0100
Message-Id: <1267560746-17277-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This centralize some spread-out initialization of descriptors into
one function and cleans up the error paths.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-u300/include/mach/coh901318.h |    2 +-
 drivers/dma/coh901318.c                     |   54 ++++++++++++--------------
 2 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/arch/arm/mach-u300/include/mach/coh901318.h b/arch/arm/mach-u300/include/mach/coh901318.h
index f4cfee9..b8155b4 100644
--- a/arch/arm/mach-u300/include/mach/coh901318.h
+++ b/arch/arm/mach-u300/include/mach/coh901318.h
@@ -53,7 +53,7 @@ struct coh901318_params {
  * struct coh_dma_channel - dma channel base
  * @name: ascii name of dma channel
  * @number: channel id number
- * @desc_nbr_max: number of preallocated descriptortors
+ * @desc_nbr_max: number of preallocated descriptors
  * @priority_high: prio of channel, 0 low otherwise high.
  * @param: configuration parameters
  * @dev_addr: physical address of periphal connected to channel
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index b962cf1..00398ca 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -335,16 +335,22 @@ coh901318_desc_get(struct coh901318_chan *cohc)
 		 * TODO: alloc a pile of descs instead of just one,
 		 * avoid many small allocations.
 		 */
-		desc = kmalloc(sizeof(struct coh901318_desc), GFP_NOWAIT);
+		desc = kzalloc(sizeof(struct coh901318_desc), GFP_NOWAIT);
 		if (desc == NULL)
 			goto out;
 		INIT_LIST_HEAD(&desc->node);
+		dma_async_tx_descriptor_init(&desc->desc, &cohc->chan);
 	} else {
 		/* Reuse an old desc. */
 		desc = list_first_entry(&cohc->free,
 					struct coh901318_desc,
 					node);
 		list_del(&desc->node);
+		/* Initialize it a bit so it's not insane */
+		desc->sg = NULL;
+		desc->sg_len = 0;
+		desc->desc.callback = NULL;
+		desc->desc.callback_param = NULL;
 	}
 
  out:
@@ -885,6 +891,7 @@ coh901318_prep_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	struct coh901318_chan *cohc = to_coh901318_chan(chan);
 	int lli_len;
 	u32 ctrl_last = cohc_chan_param(cohc)->ctrl_lli_last;
+	int ret;
 
 	spin_lock_irqsave(&cohc->lock, flg);
 
@@ -905,22 +912,19 @@ coh901318_prep_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	if (data == NULL)
 		goto err;
 
-	cohd = coh901318_desc_get(cohc);
-	cohd->sg = NULL;
-	cohd->sg_len = 0;
-	cohd->data = data;
-
-	cohd->pending_irqs =
-		coh901318_lli_fill_memcpy(
-				&cohc->base->pool, data, src, size, dest,
-				cohc_chan_param(cohc)->ctrl_lli_chained,
-				ctrl_last);
-	cohd->flags = flags;
+	ret = coh901318_lli_fill_memcpy(
+		&cohc->base->pool, data, src, size, dest,
+		cohc_chan_param(cohc)->ctrl_lli_chained,
+		ctrl_last);
+	if (ret)
+		goto err;
 
 	COH_DBG(coh901318_list_print(cohc, data));
 
-	dma_async_tx_descriptor_init(&cohd->desc, chan);
-
+	/* Pick a descriptor to handle this transfer */
+	cohd = coh901318_desc_get(cohc);
+	cohd->data = data;
+	cohd->flags = flags;
 	cohd->desc.tx_submit = coh901318_tx_submit;
 
 	spin_unlock_irqrestore(&cohc->lock, flg);
@@ -962,11 +966,6 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		/* Trigger interrupt after last lli */
 		ctrl_last |= COH901318_CX_CTRL_TC_IRQ_ENABLE;
 
-	cohd = coh901318_desc_get(cohc);
-	cohd->sg = NULL;
-	cohd->sg_len = 0;
-	cohd->dir = direction;
-
 	if (direction == DMA_TO_DEVICE) {
 		u32 tx_flags = COH901318_CX_CTRL_PRDD_SOURCE |
 			COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE;
@@ -984,11 +983,6 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	} else
 		goto err_direction;
 
-	dma_async_tx_descriptor_init(&cohd->desc, chan);
-
-	cohd->desc.tx_submit = coh901318_tx_submit;
-
-
 	/* The dma only supports transmitting packages up to
 	 * MAX_DMA_PACKET_SIZE. Calculate to total number of
 	 * dma elemts required to send the entire sg list
@@ -1023,19 +1017,21 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 				      ctrl,
 				      ctrl_last,
 				      direction, COH901318_CX_CTRL_TC_IRQ_ENABLE);
-	cohd->data = data;
-
-	cohd->flags = flags;
 
 	COH_DBG(coh901318_list_print(cohc, data));
 
+	/* Pick a descriptor to handle this transfer */
+	cohd = coh901318_desc_get(cohc);
+	cohd->dir = direction;
+	cohd->flags = flags;
+	cohd->desc.tx_submit = coh901318_tx_submit;
+	cohd->data = data;
+
 	spin_unlock_irqrestore(&cohc->lock, flg);
 
 	return &cohd->desc;
  err_dma_alloc:
  err_direction:
-	coh901318_desc_remove(cohd);
-	coh901318_desc_free(cohc, cohd);
 	spin_unlock_irqrestore(&cohc->lock, flg);
  out:
 	return NULL;
-- 
1.6.3.3

