Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab0CDNb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 08:31:56 -0500
Received: from mail.df.lth.se ([194.47.250.12]:43902 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755109Ab0CDNbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 08:31:55 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 1/2] DMAENGINE: COH 901 318 rename confusing vars
Date: Thu,  4 Mar 2010 14:31:47 +0100
Message-Id: <1267709507-4717-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes up the code with a lot of comments that make it readable,
rename things with opaque names like "data" into something more
appropriate, and remove some very confusing BUG() statements.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/coh901318.c |  103 +++++++++++++++++++++++++++++-----------------
 1 files changed, 65 insertions(+), 38 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 1656fdc..20889c9 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -37,7 +37,7 @@ struct coh901318_desc {
 	struct list_head node;
 	struct scatterlist *sg;
 	unsigned int sg_len;
-	struct coh901318_lli *data;
+	struct coh901318_lli *lli;
 	enum dma_data_direction dir;
 	unsigned long flags;
 };
@@ -283,7 +283,7 @@ static int coh901318_start(struct coh901318_chan *cohc)
 }
 
 static int coh901318_prep_linked_list(struct coh901318_chan *cohc,
-				      struct coh901318_lli *data)
+				      struct coh901318_lli *lli)
 {
 	int channel = cohc->id;
 	void __iomem *virtbase = cohc->base->virtbase;
@@ -292,18 +292,18 @@ static int coh901318_prep_linked_list(struct coh901318_chan *cohc,
 		     COH901318_CX_STAT_SPACING*channel) &
 	       COH901318_CX_STAT_ACTIVE);
 
-	writel(data->src_addr,
+	writel(lli->src_addr,
 	       virtbase + COH901318_CX_SRC_ADDR +
 	       COH901318_CX_SRC_ADDR_SPACING * channel);
 
-	writel(data->dst_addr, virtbase +
+	writel(lli->dst_addr, virtbase +
 	       COH901318_CX_DST_ADDR +
 	       COH901318_CX_DST_ADDR_SPACING * channel);
 
-	writel(data->link_addr, virtbase + COH901318_CX_LNK_ADDR +
+	writel(lli->link_addr, virtbase + COH901318_CX_LNK_ADDR +
 	       COH901318_CX_LNK_ADDR_SPACING * channel);
 
-	writel(data->control, virtbase + COH901318_CX_CTRL +
+	writel(lli->control, virtbase + COH901318_CX_CTRL +
 	       COH901318_CX_CTRL_SPACING * channel);
 
 	return 0;
@@ -565,29 +565,30 @@ static int coh901318_config(struct coh901318_chan *cohc,
  */
 static struct coh901318_desc *coh901318_queue_start(struct coh901318_chan *cohc)
 {
-	struct coh901318_desc *cohd_que;
+	struct coh901318_desc *cohd;
 
-	/* start queued jobs, if any
+	/*
+	 * start queued jobs, if any
 	 * TODO: transmit all queued jobs in one go
 	 */
-	cohd_que = coh901318_first_queued(cohc);
+	cohd = coh901318_first_queued(cohc);
 
-	if (cohd_que != NULL) {
+	if (cohd != NULL) {
 		/* Remove from queue */
-		coh901318_desc_remove(cohd_que);
+		coh901318_desc_remove(cohd);
 		/* initiate DMA job */
 		cohc->busy = 1;
 
-		coh901318_desc_submit(cohc, cohd_que);
+		coh901318_desc_submit(cohc, cohd);
 
-		coh901318_prep_linked_list(cohc, cohd_que->data);
+		coh901318_prep_linked_list(cohc, cohd->lli);
 
-		/* start dma job */
+		/* start dma job on this channel */
 		coh901318_start(cohc);
 
 	}
 
-	return cohd_que;
+	return cohd;
 }
 
 /*
@@ -622,7 +623,7 @@ static void dma_tasklet(unsigned long data)
 	cohc->completed = cohd_fin->desc.cookie;
 
 	/* release the lli allocation and remove the descriptor */
-	coh901318_lli_free(&cohc->base->pool, &cohd_fin->data);
+	coh901318_lli_free(&cohc->base->pool, &cohd_fin->lli);
 
 	/* return desc to free-list */
 	coh901318_desc_remove(cohd_fin);
@@ -666,23 +667,44 @@ static void dma_tasklet(unsigned long data)
 /* called from interrupt context */
 static void dma_tc_handle(struct coh901318_chan *cohc)
 {
-	BUG_ON(!cohc->allocated && (list_empty(&cohc->active) ||
-				    list_empty(&cohc->queue)));
-
-	if (!cohc->allocated)
+	/*
+	 * If the channel is not allocated, then we shouldn't have
+	 * any TC interrupts on it.
+	 */
+	if (!cohc->allocated) {
+		dev_err(COHC_2_DEV(cohc), "spurious interrupt from "
+			"unallocated channel\n");
 		return;
+	}
 
 	spin_lock(&cohc->lock);
 
+	/*
+	 * When we reach this point, at least one queue item
+	 * should have been moved over from cohc->queue to
+	 * cohc->active and run to completion, that is why we're
+	 * getting a terminal count interrupt is it not?
+	 * If you get this BUG() the most probable cause is that
+	 * the individual nodes in the lli chain have IRQ enabled,
+	 * so check your platform config for lli chain ctrl.
+	 */
+	BUG_ON(list_empty(&cohc->active));
+
 	cohc->nbr_active_done++;
 
+	/*
+	 * This attempt to take a job from cohc->queue, put it
+	 * into cohc->active and start it.
+	 */
 	if (coh901318_queue_start(cohc) == NULL)
 		cohc->busy = 0;
 
-	BUG_ON(list_empty(&cohc->active));
-
 	spin_unlock(&cohc->lock);
 
+	/*
+	 * This tasklet will remove items from cohc->active
+	 * and thus terminates them.
+	 */
 	if (cohc_chan_conf(cohc)->priority_high)
 		tasklet_hi_schedule(&cohc->tasklet);
 	else
@@ -870,7 +892,7 @@ static struct dma_async_tx_descriptor *
 coh901318_prep_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		      size_t size, unsigned long flags)
 {
-	struct coh901318_lli *data;
+	struct coh901318_lli *lli;
 	struct coh901318_desc *cohd;
 	unsigned long flg;
 	struct coh901318_chan *cohc = to_coh901318_chan(chan);
@@ -892,23 +914,23 @@ coh901318_prep_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	if ((lli_len << MAX_DMA_PACKET_SIZE_SHIFT) < size)
 		lli_len++;
 
-	data = coh901318_lli_alloc(&cohc->base->pool, lli_len);
+	lli = coh901318_lli_alloc(&cohc->base->pool, lli_len);
 
-	if (data == NULL)
+	if (lli == NULL)
 		goto err;
 
 	ret = coh901318_lli_fill_memcpy(
-		&cohc->base->pool, data, src, size, dest,
+		&cohc->base->pool, lli, src, size, dest,
 		cohc_chan_param(cohc)->ctrl_lli_chained,
 		ctrl_last);
 	if (ret)
 		goto err;
 
-	COH_DBG(coh901318_list_print(cohc, data));
+	COH_DBG(coh901318_list_print(cohc, lli));
 
 	/* Pick a descriptor to handle this transfer */
 	cohd = coh901318_desc_get(cohc);
-	cohd->data = data;
+	cohd->lli = lli;
 	cohd->flags = flags;
 	cohd->desc.tx_submit = coh901318_tx_submit;
 
@@ -926,7 +948,7 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			unsigned long flags)
 {
 	struct coh901318_chan *cohc = to_coh901318_chan(chan);
-	struct coh901318_lli *data;
+	struct coh901318_lli *lli;
 	struct coh901318_desc *cohd;
 	const struct coh901318_params *params;
 	struct scatterlist *sg;
@@ -999,13 +1021,13 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	}
 
 	pr_debug("Allocate %d lli:s for this transfer\n", len);
-	data = coh901318_lli_alloc(&cohc->base->pool, len);
+	lli = coh901318_lli_alloc(&cohc->base->pool, len);
 
-	if (data == NULL)
+	if (lli == NULL)
 		goto err_dma_alloc;
 
-	/* initiate allocated data list */
-	ret = coh901318_lli_fill_sg(&cohc->base->pool, data, sgl, sg_len,
+	/* initiate allocated lli list */
+	ret = coh901318_lli_fill_sg(&cohc->base->pool, lli, sgl, sg_len,
 				    cohc_dev_addr(cohc),
 				    ctrl_chained,
 				    ctrl,
@@ -1014,14 +1036,14 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	if (ret)
 		goto err_lli_fill;
 
-	COH_DBG(coh901318_list_print(cohc, data));
+	COH_DBG(coh901318_list_print(cohc, lli));
 
 	/* Pick a descriptor to handle this transfer */
 	cohd = coh901318_desc_get(cohc);
 	cohd->dir = direction;
 	cohd->flags = flags;
 	cohd->desc.tx_submit = coh901318_tx_submit;
-	cohd->data = data;
+	cohd->lli = lli;
 
 	spin_unlock_irqrestore(&cohc->lock, flg);
 
@@ -1065,7 +1087,12 @@ coh901318_issue_pending(struct dma_chan *chan)
 
 	spin_lock_irqsave(&cohc->lock, flags);
 
-	/* Busy means that pending jobs are already being processed */
+	/*
+	 * Busy means that pending jobs are already being processed,
+	 * and then there is no point in starting the queue: the
+	 * terminal count interrupt on the channel will take the next
+	 * job on the queue and execute it anyway.
+	 */
 	if (!cohc->busy)
 		coh901318_queue_start(cohc);
 
@@ -1099,7 +1126,7 @@ coh901318_terminate_all(struct dma_chan *chan)
 
 	while ((cohd = coh901318_first_active_get(cohc))) {
 		/* release the lli allocation*/
-		coh901318_lli_free(&cohc->base->pool, &cohd->data);
+		coh901318_lli_free(&cohc->base->pool, &cohd->lli);
 
 		/* return desc to free-list */
 		coh901318_desc_remove(cohd);
@@ -1108,7 +1135,7 @@ coh901318_terminate_all(struct dma_chan *chan)
 
 	while ((cohd = coh901318_first_queued(cohc))) {
 		/* release the lli allocation*/
-		coh901318_lli_free(&cohc->base->pool, &cohd->data);
+		coh901318_lli_free(&cohc->base->pool, &cohd->lli);
 
 		/* return desc to free-list */
 		coh901318_desc_remove(cohd);
-- 
1.6.3.3

