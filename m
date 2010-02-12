Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab0BLUul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 15:50:41 -0500
Received: from mail.df.lth.se ([194.47.250.12]:50080 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752437Ab0BLUuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 15:50:39 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>, Julia Lawall <julia@diku.dk>
Subject: [PATCH 1/2] [DMAENGINE] fix COH 901 318 memcpy and slave issues
Date: Fri, 12 Feb 2010 21:50:10 +0100
Message-Id: <1266007810-29121-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes several issues with the COH 901 318 DMA engine:

- A questionable mechanism for counting the number of interrupts
  was removed. There is never more than one interrupt fired for
  a transaction in this hardware.
- A debug print was broken to the point that it caused a bug
  when swithed on.
- Dynamically configure the slave controller for mem->dev
  or dev->mem transfers, this was previously hard-coded in
  the channel configurations, but we have a channel which
  is actually bidirectionals (MMC/SD) so this doesn't work
  out!
- Refactored a bit to get a clearer program flow especially in
  the dma_tasklet() and also remove some duplicated code, minor
  nitwits, spelling etc.
- Also removed the redundant BUG_ON() located by Julia Lawall
  using coccinelle.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: Julia Lawall <julia@diku.dk>
---
This replaces the earlier patches from me and also the patch
from Julia. The earlier patch had some hostconfig parts which
have to be sent separately to Russells patch tracker since
inclusion is pending in his tree.
---
 arch/arm/mach-u300/include/mach/coh901318.h |    2 +-
 drivers/dma/coh901318.c                     |  185 ++++++++++++++-------------
 drivers/dma/coh901318_lli.c                 |   19 +--
 3 files changed, 105 insertions(+), 101 deletions(-)

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
index b5f2ee0..372f314 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -39,7 +39,6 @@ struct coh901318_desc {
 	unsigned int sg_len;
 	struct coh901318_lli *data;
 	enum dma_data_direction dir;
-	int pending_irqs;
 	unsigned long flags;
 };
 
@@ -70,9 +69,8 @@ struct coh901318_chan {
 	struct list_head queue;
 	struct list_head free;
 
-	unsigned long nbr_active_done;
+	unsigned long nbr_active_done; /* nbr_pending is more appropriate */
 	unsigned long busy;
-	int pending_irqs;
 
 	struct coh901318_base *base;
 };
@@ -80,18 +78,16 @@ struct coh901318_chan {
 static void coh901318_list_print(struct coh901318_chan *cohc,
 				 struct coh901318_lli *lli)
 {
-	struct coh901318_lli *l;
-	dma_addr_t addr =  virt_to_phys(lli);
+	struct coh901318_lli *l = lli;
 	int i = 0;
 
-	while (addr) {
-		l = phys_to_virt(addr);
+	while (l) {
 		dev_vdbg(COHC_2_DEV(cohc), "i %d, lli %p, ctrl 0x%x, src 0x%x"
-			 ", dst 0x%x, link 0x%x link_virt 0x%p\n",
+			 ", dst 0x%x, link 0x%x virt_link_addr 0x%p\n",
 			 i, l, l->control, l->src_addr, l->dst_addr,
-			 l->link_addr, phys_to_virt(l->link_addr));
+			 l->link_addr, l->virt_link_addr);
 		i++;
-		addr = l->link_addr;
+		l = l->virt_link_addr;
 	}
 }
 
@@ -125,7 +121,7 @@ static int coh901318_debugfs_read(struct file *file, char __user *buf,
 		goto err_kmalloc;
 	tmp = dev_buf;
 
-	tmp += sprintf(tmp, "DMA -- enable dma channels\n");
+	tmp += sprintf(tmp, "DMA -- enabled dma channels\n");
 
 	for (i = 0; i < debugfs_dma_base->platform->max_channels; i++)
 		if (started_channels & (1 << i))
@@ -337,16 +333,22 @@ coh901318_desc_get(struct coh901318_chan *cohc)
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
@@ -364,10 +366,6 @@ static void
 coh901318_desc_submit(struct coh901318_chan *cohc, struct coh901318_desc *desc)
 {
 	list_add_tail(&desc->node, &cohc->active);
-
-	BUG_ON(cohc->pending_irqs != 0);
-
-	cohc->pending_irqs = desc->pending_irqs;
 }
 
 static struct coh901318_desc *
@@ -592,6 +590,10 @@ static struct coh901318_desc *coh901318_queue_start(struct coh901318_chan *cohc)
 	return cohd_que;
 }
 
+/*
+ * This tasklet is called from the interrupt handler to
+ * handle each descriptor (DMA job) that is sent to a channel.
+ */
 static void dma_tasklet(unsigned long data)
 {
 	struct coh901318_chan *cohc = (struct coh901318_chan *) data;
@@ -600,57 +602,58 @@ static void dma_tasklet(unsigned long data)
 	dma_async_tx_callback callback;
 	void *callback_param;
 
+	dev_vdbg(COHC_2_DEV(cohc), "[%s] chan_id %d"
+		 " nbr_active_done %ld\n", __func__,
+		 cohc->id, cohc->nbr_active_done);
+
 	spin_lock_irqsave(&cohc->lock, flags);
 
-	/* get first active entry from list */
+	/* get first active descriptor entry from list */
 	cohd_fin = coh901318_first_active_get(cohc);
 
-	BUG_ON(cohd_fin->pending_irqs == 0);
-
 	if (cohd_fin == NULL)
 		goto err;
 
-	cohd_fin->pending_irqs--;
-	cohc->completed = cohd_fin->desc.cookie;
-
-	BUG_ON(cohc->nbr_active_done && cohd_fin == NULL);
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
-
-	if (!cohd_fin->pending_irqs) {
-		coh901318_desc_remove(cohd_fin);
+	spin_unlock_irqrestore(&cohc->lock, flags);
 
-		/* return desc to free-list */
-		coh901318_desc_free(cohc, cohd_fin);
-	}
+	/* Call the callback when we're done */
+	if (callback)
+		callback(callback_param);
 
-	if (cohc->nbr_active_done)
-		cohc->nbr_active_done--;
+	spin_lock_irqsave(&cohc->lock, flags);
 
+	/*
+	 * If another interrupt fired while the tasklet was scheduling,
+	 * we don't get called twice, so we have this number of active
+	 * counter that keep track of the number of IRQs expected to
+	 * be handled for this channel. If there happen to be more than
+	 * one IRQ to be ack:ed, we simply schedule this tasklet again.
+	 */
+	cohc->nbr_active_done--;
 	if (cohc->nbr_active_done) {
+		dev_dbg(COHC_2_DEV(cohc), "scheduling tasklet again, new IRQs "
+			"came in while we were scheduling this tasklet\n");
 		if (cohc_chan_conf(cohc)->priority_high)
 			tasklet_hi_schedule(&cohc->tasklet);
 		else
 			tasklet_schedule(&cohc->tasklet);
 	}
-	spin_unlock_irqrestore(&cohc->lock, flags);
 
-	if (callback)
-		callback(callback_param);
+	spin_unlock_irqrestore(&cohc->lock, flags);
 
 	return;
 
@@ -669,16 +672,17 @@ static void dma_tc_handle(struct coh901318_chan *cohc)
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
@@ -872,6 +876,7 @@ coh901318_prep_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	struct coh901318_chan *cohc = to_coh901318_chan(chan);
 	int lli_len;
 	u32 ctrl_last = cohc_chan_param(cohc)->ctrl_lli_last;
+	int ret;
 
 	spin_lock_irqsave(&cohc->lock, flg);
 
@@ -892,22 +897,19 @@ coh901318_prep_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
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
@@ -926,6 +928,7 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	struct coh901318_chan *cohc = to_coh901318_chan(chan);
 	struct coh901318_lli *data;
 	struct coh901318_desc *cohd;
+	const struct coh901318_params *params;
 	struct scatterlist *sg;
 	int len = 0;
 	int size;
@@ -933,7 +936,9 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	u32 ctrl_chained = cohc_chan_param(cohc)->ctrl_lli_chained;
 	u32 ctrl = cohc_chan_param(cohc)->ctrl_lli;
 	u32 ctrl_last = cohc_chan_param(cohc)->ctrl_lli_last;
+	u32 config;
 	unsigned long flg;
+	int ret;
 
 	if (!sgl)
 		goto out;
@@ -949,15 +954,14 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		/* Trigger interrupt after last lli */
 		ctrl_last |= COH901318_CX_CTRL_TC_IRQ_ENABLE;
 
-	cohd = coh901318_desc_get(cohc);
-	cohd->sg = NULL;
-	cohd->sg_len = 0;
-	cohd->dir = direction;
+	params = cohc_chan_param(cohc);
+	config = params->config;
 
 	if (direction == DMA_TO_DEVICE) {
 		u32 tx_flags = COH901318_CX_CTRL_PRDD_SOURCE |
 			COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE;
 
+		config |= COH901318_CX_CFG_RM_MEMORY_TO_PRIMARY;
 		ctrl_chained |= tx_flags;
 		ctrl_last |= tx_flags;
 		ctrl |= tx_flags;
@@ -965,15 +969,14 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		u32 rx_flags = COH901318_CX_CTRL_PRDD_DEST |
 			COH901318_CX_CTRL_DST_ADDR_INC_ENABLE;
 
+		config |= COH901318_CX_CFG_RM_PRIMARY_TO_MEMORY;
 		ctrl_chained |= rx_flags;
 		ctrl_last |= rx_flags;
 		ctrl |= rx_flags;
 	} else
 		goto err_direction;
 
-	dma_async_tx_descriptor_init(&cohd->desc, chan);
-
-	cohd->desc.tx_submit = coh901318_tx_submit;
+	coh901318_set_conf(cohc, config);
 
 
 	/* The dma only supports transmitting packages up to
@@ -996,32 +999,37 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		len += factor;
 	}
 
+	pr_debug("Allocate %d lli:s for this transfer\n", len);
 	data = coh901318_lli_alloc(&cohc->base->pool, len);
 
 	if (data == NULL)
 		goto err_dma_alloc;
 
 	/* initiate allocated data list */
-	cohd->pending_irqs =
-		coh901318_lli_fill_sg(&cohc->base->pool, data, sgl, sg_len,
-				      cohc_dev_addr(cohc),
-				      ctrl_chained,
-				      ctrl,
-				      ctrl_last,
-				      direction, COH901318_CX_CTRL_TC_IRQ_ENABLE);
-	cohd->data = data;
-
-	cohd->flags = flags;
+	ret = coh901318_lli_fill_sg(&cohc->base->pool, data, sgl, sg_len,
+				    cohc_dev_addr(cohc),
+				    ctrl_chained,
+				    ctrl,
+				    ctrl_last,
+				    direction, COH901318_CX_CTRL_TC_IRQ_ENABLE);
+	if (ret)
+		goto err_lli_fill;
 
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
+ err_lli_fill:
  err_dma_alloc:
  err_direction:
-	coh901318_desc_remove(cohd);
-	coh901318_desc_free(cohc, cohd);
 	spin_unlock_irqrestore(&cohc->lock, flg);
  out:
 	return NULL;
@@ -1094,9 +1102,8 @@ coh901318_terminate_all(struct dma_chan *chan)
 		/* release the lli allocation*/
 		coh901318_lli_free(&cohc->base->pool, &cohd->data);
 
-		coh901318_desc_remove(cohd);
-
 		/* return desc to free-list */
+		coh901318_desc_remove(cohd);
 		coh901318_desc_free(cohc, cohd);
 	}
 
@@ -1104,16 +1111,14 @@ coh901318_terminate_all(struct dma_chan *chan)
 		/* release the lli allocation*/
 		coh901318_lli_free(&cohc->base->pool, &cohd->data);
 
-		coh901318_desc_remove(cohd);
-
 		/* return desc to free-list */
+		coh901318_desc_remove(cohd);
 		coh901318_desc_free(cohc, cohd);
 	}
 
 
 	cohc->nbr_active_done = 0;
 	cohc->busy = 0;
-	cohc->pending_irqs = 0;
 
 	spin_unlock_irqrestore(&cohc->lock, flags);
 }
@@ -1140,7 +1145,6 @@ void coh901318_base_init(struct dma_device *dma, const int *pick_chans,
 
 			spin_lock_init(&cohc->lock);
 
-			cohc->pending_irqs = 0;
 			cohc->nbr_active_done = 0;
 			cohc->busy = 0;
 			INIT_LIST_HEAD(&cohc->free);
@@ -1256,12 +1260,17 @@ static int __init coh901318_probe(struct platform_device *pdev)
 	base->dma_memcpy.device_issue_pending = coh901318_issue_pending;
 	base->dma_memcpy.device_terminate_all = coh901318_terminate_all;
 	base->dma_memcpy.dev = &pdev->dev;
+	/*
+	 * This controller can only access address at even 32bit boundaries,
+	 * i.e. 2^2
+	 */
+	base->dma_memcpy.copy_align = 2;
 	err = dma_async_device_register(&base->dma_memcpy);
 
 	if (err)
 		goto err_register_memcpy;
 
-	dev_dbg(&pdev->dev, "Initialized COH901318 DMA on virtual base 0x%08x\n",
+	dev_info(&pdev->dev, "Initialized COH901318 DMA on virtual base 0x%08x\n",
 		(u32) base->virtbase);
 
 	return err;
diff --git a/drivers/dma/coh901318_lli.c b/drivers/dma/coh901318_lli.c
index f5120f2..3679624 100644
--- a/drivers/dma/coh901318_lli.c
+++ b/drivers/dma/coh901318_lli.c
@@ -74,6 +74,8 @@ coh901318_lli_alloc(struct coh901318_pool *pool, unsigned int len)
 
 	lli = head;
 	lli->phy_this = phy;
+	lli->link_addr = 0x00000000;
+	lli->virt_link_addr = 0x00000000U;
 
 	for (i = 1; i < len; i++) {
 		lli_prev = lli;
@@ -85,13 +87,13 @@ coh901318_lli_alloc(struct coh901318_pool *pool, unsigned int len)
 
 		DEBUGFS_POOL_COUNTER_ADD(pool, 1);
 		lli->phy_this = phy;
+		lli->link_addr = 0x00000000;
+		lli->virt_link_addr = 0x00000000U;
 
 		lli_prev->link_addr = phy;
 		lli_prev->virt_link_addr = lli;
 	}
 
-	lli->link_addr = 0x00000000U;
-
 	spin_unlock(&pool->lock);
 
 	return head;
@@ -166,8 +168,7 @@ coh901318_lli_fill_memcpy(struct coh901318_pool *pool,
 	lli->src_addr = src;
 	lli->dst_addr = dst;
 
-	/* One irq per single transfer */
-	return 1;
+	return 0;
 }
 
 int
@@ -223,8 +224,7 @@ coh901318_lli_fill_single(struct coh901318_pool *pool,
 	lli->src_addr = src;
 	lli->dst_addr = dst;
 
-	/* One irq per single transfer */
-	return 1;
+	return 0;
 }
 
 int
@@ -240,7 +240,6 @@ coh901318_lli_fill_sg(struct coh901318_pool *pool,
 	u32 ctrl_sg;
 	dma_addr_t src = 0;
 	dma_addr_t dst = 0;
-	int nbr_of_irq = 0;
 	u32 bytes_to_transfer;
 	u32 elem_size;
 
@@ -269,9 +268,6 @@ coh901318_lli_fill_sg(struct coh901318_pool *pool,
 			ctrl_sg = ctrl ? ctrl : ctrl_last;
 
 
-		if ((ctrl_sg & ctrl_irq_mask))
-			nbr_of_irq++;
-
 		if (dir == DMA_TO_DEVICE)
 			/* increment source address */
 			src = sg_dma_address(sg);
@@ -310,8 +306,7 @@ coh901318_lli_fill_sg(struct coh901318_pool *pool,
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

