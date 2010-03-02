Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab0CBUMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 15:12:50 -0500
Received: from mail.df.lth.se ([194.47.250.12]:59625 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753316Ab0CBUMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 15:12:45 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 3/5] DMAENGINE: COH 901 318 remove irq counting
Date: Tue,  2 Mar 2010 21:12:36 +0100
Message-Id: <1267560756-17552-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the pointless irq counting for the COH 901 318, as
it turns out the hardware will only ever fire one IRQ for a linked
list anyway. In the process also a missing spinlock was introduced.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/coh901318.c     |   76 +++++++++++++++++-------------------------
 drivers/dma/coh901318_lli.c |   13 ++------
 2 files changed, 34 insertions(+), 55 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 00398ca..544c462 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -39,7 +39,6 @@ struct coh901318_desc {
 	unsigned int sg_len;
 	struct coh901318_lli *data;
 	enum dma_data_direction dir;
-	int pending_irqs;
 	unsigned long flags;
 };
 
@@ -72,7 +71,6 @@ struct coh901318_chan {
 
 	unsigned long nbr_active_done;
 	unsigned long busy;
-	int pending_irqs;
 
 	struct coh901318_base *base;
 };
@@ -368,10 +366,6 @@ static void
 coh901318_desc_submit(struct coh901318_chan *cohc, struct coh901318_desc *desc)
 {
 	list_add_tail(&desc->node, &cohc->active);
-
-	BUG_ON(cohc->pending_irqs != 0);
-
-	cohc->pending_irqs = desc->pending_irqs;
 }
 
 static struct coh901318_desc *
@@ -617,38 +611,31 @@ static void dma_tasklet(unsigned long data)
 	/* get first active descriptor entry from list */
 	cohd_fin = coh901318_first_active_get(cohc);
 
-	BUG_ON(cohd_fin->pending_irqs == 0);
-
 	if (cohd_fin == NULL)
 		goto err;
 
-	cohd_fin->pending_irqs--;
-	cohc->completed = cohd_fin->desc.cookie;
+	/* locate callback to client */
+	callback = cohd_fin->desc.callback;
+	callback_param = cohd_fin->desc.callback_param;
 
-	if (cohc->nbr_active_done == 0)
-		return;
+	/* sign this job as completed on the channel */
+	cohc->completed = cohd_fin->desc.cookie;
 
-	if (!cohd_fin->pending_irqs) {
-		/* release the lli allocation*/
-		coh901318_lli_free(&cohc->base->pool, &cohd_fin->data);
-	}
+	/* release the lli allocation and remove the descriptor */
+	coh901318_lli_free(&cohc->base->pool, &cohd_fin->data);
 
-	dev_vdbg(COHC_2_DEV(cohc), "[%s] chan_id %d pending_irqs %d"
-		 " nbr_active_done %ld\n", __func__,
-		 cohc->id, cohc->pending_irqs, cohc->nbr_active_done);
+	/* return desc to free-list */
+	coh901318_desc_remove(cohd_fin);
+	coh901318_desc_free(cohc, cohd_fin);
 
-	/* callback to client */
-	callback = cohd_fin->desc.callback;
-	callback_param = cohd_fin->desc.callback_param;
+	spin_unlock_irqrestore(&cohc->lock, flags);
 
-	if (!cohd_fin->pending_irqs) {
-		coh901318_desc_remove(cohd_fin);
+	/* Call the callback when we're done */
+	if (callback)
+		callback(callback_param);
 
-		/* return desc to free-list */
-		coh901318_desc_free(cohc, cohd_fin);
-	}
+	spin_lock_irqsave(&cohc->lock, flags);
 
-	if (cohc->nbr_active_done)
 	/*
 	 * If another interrupt fired while the tasklet was scheduling,
 	 * we don't get called twice, so we have this number of active
@@ -656,8 +643,7 @@ static void dma_tasklet(unsigned long data)
 	 * be handled for this channel. If there happen to be more than
 	 * one IRQ to be ack:ed, we simply schedule this tasklet again.
 	 */
-		cohc->nbr_active_done--;
-
+	cohc->nbr_active_done--;
 	if (cohc->nbr_active_done) {
 		dev_dbg(COHC_2_DEV(cohc), "scheduling tasklet again, new IRQs "
 			"came in while we were scheduling this tasklet\n");
@@ -666,10 +652,8 @@ static void dma_tasklet(unsigned long data)
 		else
 			tasklet_schedule(&cohc->tasklet);
 	}
-	spin_unlock_irqrestore(&cohc->lock, flags);
 
-	if (callback)
-		callback(callback_param);
+	spin_unlock_irqrestore(&cohc->lock, flags);
 
 	return;
 
@@ -688,16 +672,17 @@ static void dma_tc_handle(struct coh901318_chan *cohc)
 	if (!cohc->allocated)
 		return;
 
-	BUG_ON(cohc->pending_irqs == 0);
+	spin_lock(&cohc->lock);
 
-	cohc->pending_irqs--;
 	cohc->nbr_active_done++;
 
-	if (cohc->pending_irqs == 0 && coh901318_queue_start(cohc) == NULL)
+	if (coh901318_queue_start(cohc) == NULL)
 		cohc->busy = 0;
 
 	BUG_ON(list_empty(&cohc->active));
 
+	spin_unlock(&cohc->lock);
+
 	if (cohc_chan_conf(cohc)->priority_high)
 		tasklet_hi_schedule(&cohc->tasklet);
 	else
@@ -951,6 +936,7 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	u32 ctrl = cohc_chan_param(cohc)->ctrl_lli;
 	u32 ctrl_last = cohc_chan_param(cohc)->ctrl_lli_last;
 	unsigned long flg;
+	int ret;
 
 	if (!sgl)
 		goto out;
@@ -1010,13 +996,14 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		goto err_dma_alloc;
 
 	/* initiate allocated data list */
-	cohd->pending_irqs =
-		coh901318_lli_fill_sg(&cohc->base->pool, data, sgl, sg_len,
-				      cohc_dev_addr(cohc),
-				      ctrl_chained,
-				      ctrl,
-				      ctrl_last,
-				      direction, COH901318_CX_CTRL_TC_IRQ_ENABLE);
+	ret = coh901318_lli_fill_sg(&cohc->base->pool, data, sgl, sg_len,
+				    cohc_dev_addr(cohc),
+				    ctrl_chained,
+				    ctrl,
+				    ctrl_last,
+				    direction, COH901318_CX_CTRL_TC_IRQ_ENABLE);
+	if (ret)
+		goto err_lli_fill;
 
 	COH_DBG(coh901318_list_print(cohc, data));
 
@@ -1030,6 +1017,7 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	spin_unlock_irqrestore(&cohc->lock, flg);
 
 	return &cohd->desc;
+ err_lli_fill:
  err_dma_alloc:
  err_direction:
 	spin_unlock_irqrestore(&cohc->lock, flg);
@@ -1121,7 +1109,6 @@ coh901318_terminate_all(struct dma_chan *chan)
 
 	cohc->nbr_active_done = 0;
 	cohc->busy = 0;
-	cohc->pending_irqs = 0;
 
 	spin_unlock_irqrestore(&cohc->lock, flags);
 }
@@ -1148,7 +1135,6 @@ void coh901318_base_init(struct dma_device *dma, const int *pick_chans,
 
 			spin_lock_init(&cohc->lock);
 
-			cohc->pending_irqs = 0;
 			cohc->nbr_active_done = 0;
 			cohc->busy = 0;
 			INIT_LIST_HEAD(&cohc->free);
diff --git a/drivers/dma/coh901318_lli.c b/drivers/dma/coh901318_lli.c
index f5120f2..5f9af19 100644
--- a/drivers/dma/coh901318_lli.c
+++ b/drivers/dma/coh901318_lli.c
@@ -166,8 +166,7 @@ coh901318_lli_fill_memcpy(struct coh901318_pool *pool,
 	lli->src_addr = src;
 	lli->dst_addr = dst;
 
-	/* One irq per single transfer */
-	return 1;
+	return 0;
 }
 
 int
@@ -223,8 +222,7 @@ coh901318_lli_fill_single(struct coh901318_pool *pool,
 	lli->src_addr = src;
 	lli->dst_addr = dst;
 
-	/* One irq per single transfer */
-	return 1;
+	return 0;
 }
 
 int
@@ -240,7 +238,6 @@ coh901318_lli_fill_sg(struct coh901318_pool *pool,
 	u32 ctrl_sg;
 	dma_addr_t src = 0;
 	dma_addr_t dst = 0;
-	int nbr_of_irq = 0;
 	u32 bytes_to_transfer;
 	u32 elem_size;
 
@@ -269,9 +266,6 @@ coh901318_lli_fill_sg(struct coh901318_pool *pool,
 			ctrl_sg = ctrl ? ctrl : ctrl_last;
 
 
-		if ((ctrl_sg & ctrl_irq_mask))
-			nbr_of_irq++;
-
 		if (dir == DMA_TO_DEVICE)
 			/* increment source address */
 			src = sg_dma_address(sg);
@@ -310,8 +304,7 @@ coh901318_lli_fill_sg(struct coh901318_pool *pool,
 	}
 	spin_unlock(&pool->lock);
 
-	/* There can be many IRQs per sg transfer */
-	return nbr_of_irq;
+	return 0;
  err:
 	spin_unlock(&pool->lock);
 	return -EINVAL;
-- 
1.6.3.3

