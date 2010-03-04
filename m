Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab0CDNcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 08:32:08 -0500
Received: from mail.df.lth.se ([194.47.250.12]:43917 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755960Ab0CDNcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 08:32:04 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 2/2] DMAENGINE: COH 901 318 fix bytesleft
Date: Thu,  4 Mar 2010 14:31:58 +0100
Message-Id: <1267709518-5015-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the function to get the number of bytes left in the
ongoing DMA transaction actually work: the old code did not take
neither lli:s nor queued jobs into account. Also fix a missing
spinlock while we're at it.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/coh901318.c |   97 +++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 89 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 20889c9..672517b 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -408,25 +408,101 @@ coh901318_first_queued(struct coh901318_chan *cohc)
 	return d;
 }
 
+static inline u32 coh901318_get_bytes_in_lli(struct coh901318_lli *in_lli)
+{
+	struct coh901318_lli *lli = in_lli;
+	u32 bytes = 0;
+
+	while (lli) {
+		bytes += lli->control & COH901318_CX_CTRL_TC_VALUE_MASK;
+		lli = lli->virt_link_addr;
+	}
+	return bytes;
+}
+
 /*
- * DMA start/stop controls
+ * Get the number of bytes left to transfer on this channel,
+ * it is unwise to call this before stopping the channel for
+ * absolute measures, but for a rough guess you can still call
+ * it.
  */
 u32 coh901318_get_bytes_left(struct dma_chan *chan)
 {
-	unsigned long flags;
-	u32 ret;
 	struct coh901318_chan *cohc = to_coh901318_chan(chan);
+	struct coh901318_desc *cohd;
+	struct list_head *pos;
+	unsigned long flags;
+	u32 left = 0;
+	int i = 0;
 
 	spin_lock_irqsave(&cohc->lock, flags);
 
-	/* Read transfer count value */
-	ret = readl(cohc->base->virtbase +
-		    COH901318_CX_CTRL+COH901318_CX_CTRL_SPACING *
-		    cohc->id) & COH901318_CX_CTRL_TC_VALUE_MASK;
+	/*
+	 * If there are many queued jobs, we iterate and add the
+	 * size of them all. We take a special look on the first
+	 * job though, since it is probably active.
+	 */
+	list_for_each(pos, &cohc->active) {
+		/*
+		 * The first job in the list will be working on the
+		 * hardware. The job can be stopped but still active,
+		 * so that the transfer counter is somewhere inside
+		 * the buffer.
+		 */
+		cohd = list_entry(pos, struct coh901318_desc, node);
+
+		if (i == 0) {
+			struct coh901318_lli *lli;
+			dma_addr_t ladd;
+
+			pr_err("DMA count first entry\n");
+			/* Read current transfer count value */
+			left = readl(cohc->base->virtbase +
+				     COH901318_CX_CTRL +
+				     COH901318_CX_CTRL_SPACING * cohc->id) &
+				COH901318_CX_CTRL_TC_VALUE_MASK;
+
+			/* See if the transfer is linked... */
+			ladd = readl(cohc->base->virtbase +
+				     COH901318_CX_LNK_ADDR +
+				     COH901318_CX_LNK_ADDR_SPACING *
+				     cohc->id) &
+				~COH901318_CX_LNK_LINK_IMMEDIATE;
+			/* Single transaction */
+			if (!ladd)
+				continue;
+
+			/*
+			 * Linked transaction, follow the lli, find the
+			 * currently processing lli, and proceed to the next
+			 */
+			lli = cohd->lli;
+			while (lli && lli->link_addr != ladd)
+				lli = lli->virt_link_addr;
+
+			if (lli)
+				lli = lli->virt_link_addr;
+
+			/*
+			 * Follow remaining lli links around to count the total
+			 * number of bytes left
+			 */
+			left += coh901318_get_bytes_in_lli(lli);
+		} else {
+			left += coh901318_get_bytes_in_lli(cohd->lli);
+		}
+		i++;
+	}
+
+	/* Also count bytes in the queued jobs */
+	list_for_each(pos, &cohc->queue) {
+		cohd = list_entry(pos, struct coh901318_desc, node);
+		left += coh901318_get_bytes_in_lli(cohd->lli);
+	}
 
 	spin_unlock_irqrestore(&cohc->lock, flags);
 
-	return ret;
+	return left;
 }
 EXPORT_SYMBOL(coh901318_get_bytes_left);
 
@@ -831,6 +907,7 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 static int coh901318_alloc_chan_resources(struct dma_chan *chan)
 {
 	struct coh901318_chan	*cohc = to_coh901318_chan(chan);
+	unsigned long flags;
 
 	dev_vdbg(COHC_2_DEV(cohc), "[%s] DMA channel %d\n",
 		 __func__, cohc->id);
@@ -838,11 +915,15 @@ static int coh901318_alloc_chan_resources(struct dma_chan *chan)
 	if (chan->client_count > 1)
 		return -EBUSY;
 
+	spin_lock_irqsave(&cohc->lock, flags);
+
 	coh901318_config(cohc, NULL);
 
 	cohc->allocated = 1;
 	cohc->completed = chan->cookie = 1;
 
+	spin_unlock_irqrestore(&cohc->lock, flags);
+
 	return 1;
 }
 
-- 
1.6.3.3

