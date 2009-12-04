Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbZLDSon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbZLDSon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757121AbZLDSol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:44:41 -0500
Received: from mail.gmx.net ([213.165.64.20]:53784 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757103AbZLDSog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:44:36 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18385IFV2s3n9izYSxIE0BXMq+Y/wSUgyv9nLDvUf
	SJb1P9txBMVp8l
Date: Fri, 4 Dec 2009 19:44:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: Dan Williams <dan.j.williams@intel.com>, linux-sh@vger.kernel.org
Subject: [PATCH 3/5] sh: fix DMA driver's descriptor chaining and cookie
 assignment
In-Reply-To: <Pine.LNX.4.64.0912041936541.3981@axis700.grange>
Message-ID: <Pine.LNX.4.64.0912041941290.3981@axis700.grange>
References: <Pine.LNX.4.64.0912041936541.3981@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SH DMA driver wrongly assigns negative cookies to transfer descriptors,
also, its chaining of partial descriptors is broken. The latter problem is
usually invisible, because maximum transfer size per chunk is 16M, but if you
artificially set this limit lower, the driver fails. Since cookies are also
used in chunk management, both these problems are fixed in one patch.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/dma/shdma.c |  246 ++++++++++++++++++++++++++++++++-------------------
 drivers/dma/shdma.h |    1 -
 2 files changed, 153 insertions(+), 94 deletions(-)

diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index f5fae12..aac8f78 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -30,9 +30,12 @@
 #include "shdma.h"
 
 /* DMA descriptor control */
-#define DESC_LAST	(-1)
-#define DESC_COMP	(1)
-#define DESC_NCOMP	(0)
+enum sh_dmae_desc_status {
+	DESC_PREPARED,
+	DESC_SUBMITTED,
+	DESC_COMPLETED,	/* completed, have to call callback */
+	DESC_WAITING,	/* callback called, waiting for ack / re-submit */
+};
 
 #define NR_DESCS_PER_CHANNEL 32
 /*
@@ -45,6 +48,8 @@
  */
 #define RS_DEFAULT  (RS_DUAL)
 
+static void sh_dmae_chan_ld_cleanup(struct sh_dmae_chan *sh_chan, bool all);
+
 #define SH_DMAC_CHAN_BASE(id) (dma_base_addr[id])
 static void sh_dmae_writel(struct sh_dmae_chan *sh_dc, u32 data, u32 reg)
 {
@@ -185,7 +190,7 @@ static int dmae_set_dmars(struct sh_dmae_chan *sh_chan, u16 val)
 
 static dma_cookie_t sh_dmae_tx_submit(struct dma_async_tx_descriptor *tx)
 {
-	struct sh_desc *desc = tx_to_sh_desc(tx);
+	struct sh_desc *desc = tx_to_sh_desc(tx), *chunk;
 	struct sh_dmae_chan *sh_chan = to_sh_chan(tx->chan);
 	dma_cookie_t cookie;
 
@@ -196,45 +201,40 @@ static dma_cookie_t sh_dmae_tx_submit(struct dma_async_tx_descriptor *tx)
 	if (cookie < 0)
 		cookie = 1;
 
-	/* If desc only in the case of 1 */
-	if (desc->async_tx.cookie != -EBUSY)
-		desc->async_tx.cookie = cookie;
-	sh_chan->common.cookie = desc->async_tx.cookie;
-
-	list_splice_init(&desc->tx_list, sh_chan->ld_queue.prev);
+	tx->cookie = cookie;
+	dev_dbg(sh_chan->dev, "submit %p #%d start %u\n",
+		tx, tx->cookie, desc->hw.sar);
+	sh_chan->common.cookie = tx->cookie;
+
+	/* Mark all chunks of this descriptor as submitted */
+	list_for_each_entry(chunk, desc->node.prev, node) {
+		/*
+		 * All chunks are on the global ld_queue, so, we have to find
+		 * the end of the chain ourselves
+		 */
+		if (chunk != desc && (chunk->async_tx.cookie > 0 ||
+				      chunk->async_tx.cookie == -EBUSY))
+			break;
+		chunk->mark = DESC_SUBMITTED;
+	}
 
 	spin_unlock_bh(&sh_chan->desc_lock);
 
 	return cookie;
 }
 
+/* Called with desc_lock held */
 static struct sh_desc *sh_dmae_get_desc(struct sh_dmae_chan *sh_chan)
 {
-	struct sh_desc *desc, *_desc, *ret = NULL;
-
-	spin_lock_bh(&sh_chan->desc_lock);
-	list_for_each_entry_safe(desc, _desc, &sh_chan->ld_free, node) {
-		if (async_tx_test_ack(&desc->async_tx)) {
-			list_del(&desc->node);
-			ret = desc;
-			break;
-		}
-	}
-	spin_unlock_bh(&sh_chan->desc_lock);
-
-	return ret;
-}
+	struct sh_desc *desc;
 
-static void sh_dmae_put_desc(struct sh_dmae_chan *sh_chan, struct sh_desc *desc)
-{
-	if (desc) {
-		spin_lock_bh(&sh_chan->desc_lock);
+	if (list_empty(&sh_chan->ld_free))
+		return NULL;
 
-		list_splice_init(&desc->tx_list, &sh_chan->ld_free);
-		list_add(&desc->node, &sh_chan->ld_free);
+	desc = list_entry(sh_chan->ld_free.next, struct sh_desc, node);
+	list_del(&desc->node);
 
-		spin_unlock_bh(&sh_chan->desc_lock);
-	}
+	return desc;
 }
 
 static int sh_dmae_alloc_chan_resources(struct dma_chan *chan)
@@ -254,10 +254,9 @@ static int sh_dmae_alloc_chan_resources(struct dma_chan *chan)
 					&sh_chan->common);
 		desc->async_tx.tx_submit = sh_dmae_tx_submit;
 		desc->async_tx.flags = DMA_CTRL_ACK;
-		INIT_LIST_HEAD(&desc->tx_list);
-		sh_dmae_put_desc(sh_chan, desc);
 
 		spin_lock_bh(&sh_chan->desc_lock);
+		list_add(&desc->node, &sh_chan->ld_free);
 		sh_chan->descs_allocated++;
 	}
 	spin_unlock_bh(&sh_chan->desc_lock);
@@ -274,7 +273,10 @@ static void sh_dmae_free_chan_resources(struct dma_chan *chan)
 	struct sh_desc *desc, *_desc;
 	LIST_HEAD(list);
 
-	BUG_ON(!list_empty(&sh_chan->ld_queue));
+	/* Prepared and not submitted descriptors can still be on the queue */
+	if (!list_empty(&sh_chan->ld_queue))
+		sh_dmae_chan_ld_cleanup(sh_chan, true);
+
 	spin_lock_bh(&sh_chan->desc_lock);
 
 	list_splice_init(&sh_chan->ld_free, &list);
@@ -293,6 +295,7 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_memcpy(
 	struct sh_dmae_chan *sh_chan;
 	struct sh_desc *first = NULL, *prev = NULL, *new;
 	size_t copy_size;
+	LIST_HEAD(tx_list);
 
 	if (!chan)
 		return NULL;
@@ -302,43 +305,70 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_memcpy(
 
 	sh_chan = to_sh_chan(chan);
 
+	/* Have to lock the whole loop to protect against concurrent release */
+	spin_lock_bh(&sh_chan->desc_lock);
+
+	/*
+	 * Chaining:
+	 * first descriptor is what user is dealing with in all API calls, its
+	 *	cookie is at first set to -EBUSY, at tx-submit to a positive
+	 *	number
+	 * if more than one chunk is needed further chunks have cookie = -EINVAL
+	 * the last chunk, if not equal to the first, has cookie = -ENOSPC
+	 * all chunks are linked onto the tx_list head with their .node heads
+	 *	only during this function, then they are immediately spliced
+	 *	onto the queue
+	 */
 	do {
 		/* Allocate the link descriptor from DMA pool */
 		new = sh_dmae_get_desc(sh_chan);
 		if (!new) {
 			dev_err(sh_chan->dev,
 					"No free memory for link descriptor\n");
-			goto err_get_desc;
+			list_splice(&tx_list, &sh_chan->ld_free);
+			spin_unlock_bh(&sh_chan->desc_lock);
+			return NULL;
 		}
 
-		copy_size = min(len, (size_t)SH_DMA_TCR_MAX);
+		copy_size = min(len, (size_t)SH_DMA_TCR_MAX + 1);
 
 		new->hw.sar = dma_src;
 		new->hw.dar = dma_dest;
 		new->hw.tcr = copy_size;
-		if (!first)
+		if (!first) {
+			/* First desc */
+			new->async_tx.cookie = -EBUSY;
 			first = new;
+		} else {
+			/* Other desc - invisible to the user */
+			new->async_tx.cookie = -EINVAL;
+		}
+
+		dev_dbg(sh_chan->dev,
+			"chaining %u of %u with %p, start %u, cookie %d\n",
+			copy_size, len, &new->async_tx, dma_src,
+			new->async_tx.cookie);
 
-		new->mark = DESC_NCOMP;
-		async_tx_ack(&new->async_tx);
+		new->mark = DESC_PREPARED;
+		new->async_tx.flags = flags;
 
 		prev = new;
 		len -= copy_size;
 		dma_src += copy_size;
 		dma_dest += copy_size;
 		/* Insert the link descriptor to the LD ring */
-		list_add_tail(&new->node, &first->tx_list);
+		list_add_tail(&new->node, &tx_list);
 	} while (len);
 
-	new->async_tx.flags = flags; /* client is in control of this ack */
-	new->async_tx.cookie = -EBUSY; /* Last desc */
+	if (new != first)
+		new->async_tx.cookie = -ENOSPC;
 
-	return &first->async_tx;
+	/* Put them immediately on the queue, so, they don't get lost */
+	list_splice_tail(&tx_list, sh_chan->ld_queue.prev);
 
-err_get_desc:
-	sh_dmae_put_desc(sh_chan, first);
-	return NULL;
+	spin_unlock_bh(&sh_chan->desc_lock);
 
+	return &first->async_tx;
 }
 
 /*
@@ -346,64 +376,87 @@ err_get_desc:
  *
  * This function clean up the ld_queue of DMA channel.
  */
-static void sh_dmae_chan_ld_cleanup(struct sh_dmae_chan *sh_chan)
+static void sh_dmae_chan_ld_cleanup(struct sh_dmae_chan *sh_chan, bool all)
 {
 	struct sh_desc *desc, *_desc;
 
 	spin_lock_bh(&sh_chan->desc_lock);
 	list_for_each_entry_safe(desc, _desc, &sh_chan->ld_queue, node) {
-		dma_async_tx_callback callback;
-		void *callback_param;
+		struct dma_async_tx_descriptor *tx = &desc->async_tx;
 
-		/* non send data */
-		if (desc->mark == DESC_NCOMP)
+		/* unsent data */
+		if (desc->mark == DESC_SUBMITTED && !all)
 			break;
 
-		/* send data sesc */
-		callback = desc->async_tx.callback;
-		callback_param = desc->async_tx.callback_param;
+		if (desc->mark == DESC_PREPARED && !all)
+			continue;
+
+		/* Call callback on the "exposed" descriptor (cookie > 0) */
+		if (tx->cookie > 0 && (desc->mark == DESC_COMPLETED ||
+				       desc->mark == DESC_WAITING)) {
+			struct sh_desc *chunk;
+			bool head_acked = async_tx_test_ack(tx);
+			/* sent data desc */
+			dma_async_tx_callback callback = tx->callback;
+
+			/* Run the link descriptor callback function */
+			if (callback && desc->mark == DESC_COMPLETED) {
+				spin_unlock_bh(&sh_chan->desc_lock);
+				dev_dbg(sh_chan->dev,
+					"descriptor %p callback\n", tx);
+				callback(tx->callback_param);
+				spin_lock_bh(&sh_chan->desc_lock);
+			}
 
-		/* Remove from ld_queue list */
-		list_splice_init(&desc->tx_list, &sh_chan->ld_free);
+			list_for_each_entry(chunk, desc->node.prev, node) {
+				/*
+				 * All chunks are on the global ld_queue, so, we
+				 * have to find the end of the chain ourselves
+				 */
+				if (chunk != desc &&
+				    (chunk->async_tx.cookie > 0 ||
+				     chunk->async_tx.cookie == -EBUSY))
+					break;
+
+				if (head_acked)
+					async_tx_ack(&chunk->async_tx);
+				else
+					chunk->mark = DESC_WAITING;
+			}
+		}
 
-		dev_dbg(sh_chan->dev, "link descriptor %p will be recycle.\n",
-				desc);
+		dev_dbg(sh_chan->dev, "descriptor %p #%d completed.\n",
+			tx, tx->cookie);
 
-		list_move(&desc->node, &sh_chan->ld_free);
-		/* Run the link descriptor callback function */
-		if (callback) {
-			spin_unlock_bh(&sh_chan->desc_lock);
-			dev_dbg(sh_chan->dev, "link descriptor %p callback\n",
-					desc);
-			callback(callback_param);
-			spin_lock_bh(&sh_chan->desc_lock);
-		}
+		if (((desc->mark == DESC_COMPLETED ||
+		      desc->mark == DESC_WAITING) &&
+		     async_tx_test_ack(&desc->async_tx)) || all)
+			/* Remove from ld_queue list */
+			list_move(&desc->node, &sh_chan->ld_free);
 	}
 	spin_unlock_bh(&sh_chan->desc_lock);
 }
 
 static void sh_chan_xfer_ld_queue(struct sh_dmae_chan *sh_chan)
 {
-	struct list_head *ld_node;
 	struct sh_dmae_regs hw;
+	struct sh_desc *sd;
 
 	/* DMA work check */
 	if (dmae_is_idle(sh_chan))
 		return;
 
+	spin_lock_bh(&sh_chan->desc_lock);
 	/* Find the first un-transfer desciptor */
-	for (ld_node = sh_chan->ld_queue.next;
-		(ld_node != &sh_chan->ld_queue)
-			&& (to_sh_desc(ld_node)->mark == DESC_COMP);
-		ld_node = ld_node->next)
-		cpu_relax();
-
-	if (ld_node != &sh_chan->ld_queue) {
-		/* Get the ld start address from ld_queue */
-		hw = to_sh_desc(ld_node)->hw;
-		dmae_set_reg(sh_chan, hw);
-		dmae_start(sh_chan);
-	}
+	list_for_each_entry(sd, &sh_chan->ld_queue, node)
+		if (sd->mark == DESC_SUBMITTED) {
+			/* Get the ld start address from ld_queue */
+			hw = sd->hw;
+			dmae_set_reg(sh_chan, hw);
+			dmae_start(sh_chan);
+			break;
+		}
+	spin_unlock_bh(&sh_chan->desc_lock);
 }
 
 static void sh_dmae_memcpy_issue_pending(struct dma_chan *chan)
@@ -421,12 +474,11 @@ static enum dma_status sh_dmae_is_complete(struct dma_chan *chan,
 	dma_cookie_t last_used;
 	dma_cookie_t last_complete;
 
-	sh_dmae_chan_ld_cleanup(sh_chan);
+	sh_dmae_chan_ld_cleanup(sh_chan, false);
 
 	last_used = chan->cookie;
 	last_complete = sh_chan->completed_cookie;
-	if (last_complete == -EBUSY)
-		last_complete = last_used;
+	BUG_ON(last_complete < 0);
 
 	if (done)
 		*done = last_complete;
@@ -481,11 +533,13 @@ static irqreturn_t sh_dmae_err(int irq, void *data)
 		err = sh_dmae_rst(0);
 		if (err)
 			return err;
+#ifdef SH_DMAC_BASE1
 		if (shdev->pdata.mode & SHDMA_DMAOR1) {
 			err = sh_dmae_rst(1);
 			if (err)
 				return err;
 		}
+#endif
 		disable_irq(irq);
 		return IRQ_HANDLED;
 	}
@@ -499,30 +553,36 @@ static void dmae_do_tasklet(unsigned long data)
 	u32 sar_buf = sh_dmae_readl(sh_chan, SAR);
 	list_for_each_entry_safe(desc, _desc,
 					&sh_chan->ld_queue, node) {
-		if ((desc->hw.sar + desc->hw.tcr) == sar_buf) {
+		if ((desc->hw.sar + desc->hw.tcr) == sar_buf &&
+		    desc->mark == DESC_SUBMITTED) {
 			cur_desc = desc;
 			break;
 		}
 	}
 
 	if (cur_desc) {
+		dev_dbg(sh_chan->dev, "done %p #%d start %u\n",
+			&cur_desc->async_tx, cur_desc->async_tx.cookie,
+			cur_desc->hw.sar);
+
 		switch (cur_desc->async_tx.cookie) {
-		case 0: /* other desc data */
+		case -EINVAL:
+		case -ENOSPC:
+			/* other desc data */
 			break;
-		case -EBUSY: /* last desc */
-		sh_chan->completed_cookie =
-				cur_desc->async_tx.cookie;
+		case -EBUSY: /* Cannot be */
+			BUG_ON(1);
 			break;
-		default: /* first desc ( 0 < )*/
+		default: /* first desc: cookie > 0 */
 			sh_chan->completed_cookie =
-				cur_desc->async_tx.cookie - 1;
+				cur_desc->async_tx.cookie;
 			break;
 		}
-		cur_desc->mark = DESC_COMP;
+		cur_desc->mark = DESC_COMPLETED;
 	}
 	/* Next desc */
 	sh_chan_xfer_ld_queue(sh_chan);
-	sh_dmae_chan_ld_cleanup(sh_chan);
+	sh_dmae_chan_ld_cleanup(sh_chan, false);
 }
 
 static unsigned int get_dmae_irq(unsigned int id)
diff --git a/drivers/dma/shdma.h b/drivers/dma/shdma.h
index 2b4bc15..c93555c 100644
--- a/drivers/dma/shdma.h
+++ b/drivers/dma/shdma.h
@@ -26,7 +26,6 @@ struct sh_dmae_regs {
 };
 
 struct sh_desc {
-	struct list_head tx_list;
 	struct sh_dmae_regs hw;
 	struct list_head node;
 	struct dma_async_tx_descriptor async_tx;
-- 
1.6.2.4

