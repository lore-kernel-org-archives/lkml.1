Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab0CBUMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 15:12:41 -0500
Received: from mail.df.lth.se ([194.47.250.12]:59615 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756195Ab0CBUMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 15:12:38 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 1/5] DMAENGINE: COH 901 318 cleanups
Date: Tue,  2 Mar 2010 21:12:14 +0100
Message-Id: <1267560734-17001-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up the some debug code that was not working in the
COH 901 318 driver, adds some helpful comments and rearrange the
code a bit.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/coh901318.c |   42 ++++++++++++++++++++++++++++--------------
 1 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 64a9372..b962cf1 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -80,18 +80,16 @@ struct coh901318_chan {
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
 
@@ -125,7 +123,7 @@ static int coh901318_debugfs_read(struct file *file, char __user *buf,
 		goto err_kmalloc;
 	tmp = dev_buf;
 
-	tmp += sprintf(tmp, "DMA -- enable dma channels\n");
+	tmp += sprintf(tmp, "DMA -- enabled dma channels\n");
 
 	for (i = 0; i < debugfs_dma_base->platform->max_channels; i++)
 		if (started_channels & (1 << i))
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
@@ -600,9 +602,13 @@ static void dma_tasklet(unsigned long data)
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
 
 	BUG_ON(cohd_fin->pending_irqs == 0);
@@ -637,9 +643,18 @@ static void dma_tasklet(unsigned long data)
 	}
 
 	if (cohc->nbr_active_done)
+	/*
+	 * If another interrupt fired while the tasklet was scheduling,
+	 * we don't get called twice, so we have this number of active
+	 * counter that keep track of the number of IRQs expected to
+	 * be handled for this channel. If there happen to be more than
+	 * one IRQ to be ack:ed, we simply schedule this tasklet again.
+	 */
 		cohc->nbr_active_done--;
 
 	if (cohc->nbr_active_done) {
+		dev_dbg(COHC_2_DEV(cohc), "scheduling tasklet again, new IRQs "
+			"came in while we were scheduling this tasklet\n");
 		if (cohc_chan_conf(cohc)->priority_high)
 			tasklet_hi_schedule(&cohc->tasklet);
 		else
@@ -994,6 +1009,7 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		len += factor;
 	}
 
+	pr_debug("Allocate %d lli:s for this transfer\n", len);
 	data = coh901318_lli_alloc(&cohc->base->pool, len);
 
 	if (data == NULL)
@@ -1092,9 +1108,8 @@ coh901318_terminate_all(struct dma_chan *chan)
 		/* release the lli allocation*/
 		coh901318_lli_free(&cohc->base->pool, &cohd->data);
 
-		coh901318_desc_remove(cohd);
-
 		/* return desc to free-list */
+		coh901318_desc_remove(cohd);
 		coh901318_desc_free(cohc, cohd);
 	}
 
@@ -1102,9 +1117,8 @@ coh901318_terminate_all(struct dma_chan *chan)
 		/* release the lli allocation*/
 		coh901318_lli_free(&cohc->base->pool, &cohd->data);
 
-		coh901318_desc_remove(cohd);
-
 		/* return desc to free-list */
+		coh901318_desc_remove(cohd);
 		coh901318_desc_free(cohc, cohd);
 	}
 
@@ -1259,7 +1273,7 @@ static int __init coh901318_probe(struct platform_device *pdev)
 	if (err)
 		goto err_register_memcpy;
 
-	dev_dbg(&pdev->dev, "Initialized COH901318 DMA on virtual base 0x%08x\n",
+	dev_info(&pdev->dev, "Initialized COH901318 DMA on virtual base 0x%08x\n",
 		(u32) base->virtbase);
 
 	return err;
-- 
1.6.3.3

