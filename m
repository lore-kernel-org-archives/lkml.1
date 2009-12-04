Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbZLDSov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbZLDSov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757162AbZLDSot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:44:49 -0500
Received: from mail.gmx.net ([213.165.64.20]:36989 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757121AbZLDSop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:44:45 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18gWIwhacogpMQEMDjxJDTUGgBz5sWZAM9b+qw825
	SRr6ABe1ZVTA6T
Date: Fri, 4 Dec 2009 19:45:05 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: Dan Williams <dan.j.williams@intel.com>, linux-sh@vger.kernel.org
Subject: [PATCH 4/5] sh: stylistic improvements for the DMA driver
In-Reply-To: <Pine.LNX.4.64.0912041936541.3981@axis700.grange>
Message-ID: <Pine.LNX.4.64.0912041942040.3981@axis700.grange>
References: <Pine.LNX.4.64.0912041936541.3981@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/dma/shdma.c |   34 +++++++++++++++++-----------------
 drivers/dma/shdma.h |   14 +++++++-------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index aac8f78..0d21468 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -85,17 +85,17 @@ static int sh_dmae_rst(int id)
 	unsigned short dmaor;
 
 	sh_dmae_ctl_stop(id);
-	dmaor = (dmaor_read_reg(id)|DMAOR_INIT);
+	dmaor = dmaor_read_reg(id) | DMAOR_INIT;
 
 	dmaor_write_reg(id, dmaor);
-	if ((dmaor_read_reg(id) & (DMAOR_AE | DMAOR_NMIF))) {
+	if (dmaor_read_reg(id) & (DMAOR_AE | DMAOR_NMIF)) {
 		pr_warning(KERN_ERR "dma-sh: Can't initialize DMAOR.\n");
 		return -EINVAL;
 	}
 	return 0;
 }
 
-static int dmae_is_idle(struct sh_dmae_chan *sh_chan)
+static int dmae_is_busy(struct sh_dmae_chan *sh_chan)
 {
 	u32 chcr = sh_dmae_readl(sh_chan, CHCR);
 	if (chcr & CHCR_DE) {
@@ -115,15 +115,14 @@ static void dmae_set_reg(struct sh_dmae_chan *sh_chan, struct sh_dmae_regs hw)
 {
 	sh_dmae_writel(sh_chan, hw.sar, SAR);
 	sh_dmae_writel(sh_chan, hw.dar, DAR);
-	sh_dmae_writel(sh_chan,
-		(hw.tcr >> calc_xmit_shift(sh_chan)), TCR);
+	sh_dmae_writel(sh_chan, hw.tcr >> calc_xmit_shift(sh_chan), TCR);
 }
 
 static void dmae_start(struct sh_dmae_chan *sh_chan)
 {
 	u32 chcr = sh_dmae_readl(sh_chan, CHCR);
 
-	chcr |= (CHCR_DE|CHCR_IE);
+	chcr |= CHCR_DE | CHCR_IE;
 	sh_dmae_writel(sh_chan, chcr, CHCR);
 }
 
@@ -137,7 +136,7 @@ static void dmae_halt(struct sh_dmae_chan *sh_chan)
 
 static int dmae_set_chcr(struct sh_dmae_chan *sh_chan, u32 val)
 {
-	int ret = dmae_is_idle(sh_chan);
+	int ret = dmae_is_busy(sh_chan);
 	/* When DMA was working, can not set data to CHCR */
 	if (ret)
 		return ret;
@@ -154,7 +153,7 @@ static int dmae_set_dmars(struct sh_dmae_chan *sh_chan, u16 val)
 {
 	u32 addr;
 	int shift = 0;
-	int ret = dmae_is_idle(sh_chan);
+	int ret = dmae_is_busy(sh_chan);
 	if (ret)
 		return ret;
 
@@ -324,7 +323,7 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_memcpy(
 		new = sh_dmae_get_desc(sh_chan);
 		if (!new) {
 			dev_err(sh_chan->dev,
-					"No free memory for link descriptor\n");
+				"No free memory for link descriptor\n");
 			list_splice(&tx_list, &sh_chan->ld_free);
 			spin_unlock_bh(&sh_chan->desc_lock);
 			return NULL;
@@ -443,7 +442,7 @@ static void sh_chan_xfer_ld_queue(struct sh_dmae_chan *sh_chan)
 	struct sh_desc *sd;
 
 	/* DMA work check */
-	if (dmae_is_idle(sh_chan))
+	if (dmae_is_busy(sh_chan))
 		return;
 
 	spin_lock_bh(&sh_chan->desc_lock);
@@ -551,8 +550,9 @@ static void dmae_do_tasklet(unsigned long data)
 	struct sh_dmae_chan *sh_chan = (struct sh_dmae_chan *)data;
 	struct sh_desc *desc, *_desc, *cur_desc = NULL;
 	u32 sar_buf = sh_dmae_readl(sh_chan, SAR);
+
 	list_for_each_entry_safe(desc, _desc,
-					&sh_chan->ld_queue, node) {
+				 &sh_chan->ld_queue, node) {
 		if ((desc->hw.sar + desc->hw.tcr) == sar_buf &&
 		    desc->mark == DESC_SUBMITTED) {
 			cur_desc = desc;
@@ -603,8 +603,8 @@ static int __devinit sh_dmae_chan_probe(struct sh_dmae_device *shdev, int id)
 	/* alloc channel */
 	new_sh_chan = kzalloc(sizeof(struct sh_dmae_chan), GFP_KERNEL);
 	if (!new_sh_chan) {
-		dev_err(shdev->common.dev, "No free memory for allocating "
-				"dma channels!\n");
+		dev_err(shdev->common.dev,
+			"No free memory for allocating dma channels!\n");
 		return -ENOMEM;
 	}
 
@@ -646,8 +646,8 @@ static int __devinit sh_dmae_chan_probe(struct sh_dmae_device *shdev, int id)
 			"sh-dmae%d", new_sh_chan->id);
 
 	/* set up channel irq */
-	err = request_irq(irq, &sh_dmae_interrupt,
-		irqflags, new_sh_chan->dev_id, new_sh_chan);
+	err = request_irq(irq, &sh_dmae_interrupt, irqflags,
+			  new_sh_chan->dev_id, new_sh_chan);
 	if (err) {
 		dev_err(shdev->common.dev, "DMA channel %d request_irq error "
 			"with return %d\n", id, err);
@@ -751,8 +751,8 @@ static int __init sh_dmae_probe(struct platform_device *pdev)
 	}
 
 	for (ecnt = 0 ; ecnt < ARRAY_SIZE(eirq); ecnt++) {
-		err = request_irq(eirq[ecnt], sh_dmae_err,
-			irqflags, "DMAC Address Error", shdev);
+		err = request_irq(eirq[ecnt], sh_dmae_err, irqflags,
+				  "DMAC Address Error", shdev);
 		if (err) {
 			dev_err(&pdev->dev, "DMA device request_irq"
 				"error (irq %d) with return %d\n",
diff --git a/drivers/dma/shdma.h b/drivers/dma/shdma.h
index c93555c..f412bfa 100644
--- a/drivers/dma/shdma.h
+++ b/drivers/dma/shdma.h
@@ -34,15 +34,15 @@ struct sh_desc {
 
 struct sh_dmae_chan {
 	dma_cookie_t completed_cookie;	/* The maximum cookie completed */
-	spinlock_t desc_lock;			/* Descriptor operation lock */
-	struct list_head ld_queue;		/* Link descriptors queue */
-	struct list_head ld_free;		/* Link descriptors free */
-	struct dma_chan common;			/* DMA common channel */
-	struct device *dev;				/* Channel device */
+	spinlock_t desc_lock;		/* Descriptor operation lock */
+	struct list_head ld_queue;	/* Link descriptors queue */
+	struct list_head ld_free;	/* Link descriptors free */
+	struct dma_chan common;		/* DMA common channel */
+	struct device *dev;		/* Channel device */
 	struct tasklet_struct tasklet;	/* Tasklet */
-	int descs_allocated;			/* desc count */
+	int descs_allocated;		/* desc count */
 	int id;				/* Raw id of this channel */
-	char dev_id[16];	/* unique name per DMAC of channel */
+	char dev_id[16];		/* unique name per DMAC of channel */
 
 	/* Set chcr */
 	int (*set_chcr)(struct sh_dmae_chan *sh_chan, u32 regs);
-- 
1.6.2.4

