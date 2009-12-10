Return-Path: <linux-kernel-owner+w=401wt.eu-S1761339AbZLJRe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339AbZLJRe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761271AbZLJRex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:34:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:54969 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761324AbZLJRer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:34:47 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19ys0UMlkpyr3d/5kCzh+3TiVkLJwYANsdcY0oqgl
	xP+fXm6MsD6ZJc
Date: Thu, 10 Dec 2009 18:35:11 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: Dan Williams <dan.j.williams@intel.com>, linux-sh@vger.kernel.org
Subject: [PATCH 2/3 v2] sh: fix DMA driver's descriptor chaining and cookie
 assignment
In-Reply-To: <Pine.LNX.4.64.0912101826010.4487@axis700.grange>
Message-ID: <Pine.LNX.4.64.0912101833170.4487@axis700.grange>
References: <Pine.LNX.4.64.0912101826010.4487@axis700.grange>
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
used in chunk management, both these problems are fixed in one patch. As side
effects a possible memory leak, when descriptors are prepared, but not
submitted, and multiple races have also been fixed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/dma/shdma.c |  324 ++++++++++++++++++++++++++++++++------------------
 drivers/dma/shdma.h |    9 +-
 2 files changed, 213 insertions(+), 120 deletions(-)

diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index 8d9acd7..9546f5f 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -23,16 +23,19 @@
 #include <linux/dmaengine.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
-#include <linux/dmapool.h>
 #include <linux/platform_device.h>
 #include <cpu/dma.h>
 #include <asm/dma-sh.h>
 #include "shdma.h"
 
 /* DMA descriptor control */
-#define DESC_LAST	(-1)
-#define DESC_COMP	(1)
-#define DESC_NCOMP	(0)
+enum sh_dmae_desc_status {
+	DESC_IDLE,
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
@@ -106,11 +111,11 @@ static inline unsigned int calc_xmit_shift(struct sh_dmae_chan *sh_chan)
 	return ts_shift[(chcr & CHCR_TS_MASK) >> CHCR_TS_SHIFT];
 }
 
-static void dmae_set_reg(struct sh_dmae_chan *sh_chan, struct sh_dmae_regs hw)
+static void dmae_set_reg(struct sh_dmae_chan *sh_chan, struct sh_dmae_regs *hw)
 {
-	sh_dmae_writel(sh_chan, hw.sar, SAR);
-	sh_dmae_writel(sh_chan, hw.dar, DAR);
-	sh_dmae_writel(sh_chan, hw.tcr >> calc_xmit_shift(sh_chan), TCR);
+	sh_dmae_writel(sh_chan, hw->sar, SAR);
+	sh_dmae_writel(sh_chan, hw->dar, DAR);
+	sh_dmae_writel(sh_chan, hw->tcr >> calc_xmit_shift(sh_chan), TCR);
 }
 
 static void dmae_start(struct sh_dmae_chan *sh_chan)
@@ -184,8 +189,9 @@ static int dmae_set_dmars(struct sh_dmae_chan *sh_chan, u16 val)
 
 static dma_cookie_t sh_dmae_tx_submit(struct dma_async_tx_descriptor *tx)
 {
-	struct sh_desc *desc = tx_to_sh_desc(tx);
+	struct sh_desc *desc = tx_to_sh_desc(tx), *chunk, *last = desc, *c;
 	struct sh_dmae_chan *sh_chan = to_sh_chan(tx->chan);
+	dma_async_tx_callback callback = tx->callback;
 	dma_cookie_t cookie;
 
 	spin_lock_bh(&sh_chan->desc_lock);
@@ -195,45 +201,53 @@ static dma_cookie_t sh_dmae_tx_submit(struct dma_async_tx_descriptor *tx)
 	if (cookie < 0)
 		cookie = 1;
 
-	/* If desc only in the case of 1 */
-	if (desc->async_tx.cookie != -EBUSY)
-		desc->async_tx.cookie = cookie;
-	sh_chan->common.cookie = desc->async_tx.cookie;
+	sh_chan->common.cookie = cookie;
+	tx->cookie = cookie;
+
+	/* Mark all chunks of this descriptor as submitted, move to the queue */
+	list_for_each_entry_safe(chunk, c, desc->node.prev, node) {
+		/*
+		 * All chunks are on the global ld_free, so, we have to find
+		 * the end of the chain ourselves
+		 */
+		if (chunk != desc && (chunk->mark == DESC_IDLE ||
+				      chunk->async_tx.cookie > 0 ||
+				      chunk->async_tx.cookie == -EBUSY ||
+				      &chunk->node == &sh_chan->ld_free))
+			break;
+		chunk->mark = DESC_SUBMITTED;
+		/* Callback goes to the last chunk */
+		chunk->async_tx.callback = NULL;
+		chunk->cookie = cookie;
+		list_move_tail(&chunk->node, &sh_chan->ld_queue);
+		last = chunk;
+	}
+
+	last->async_tx.callback = callback;
+	last->async_tx.callback_param = tx->callback_param;
 
-	list_splice_init(&desc->tx_list, sh_chan->ld_queue.prev);
+	dev_dbg(sh_chan->dev, "submit #%d@%p on %d: %x[%d] -> %x\n",
+		tx->cookie, &last->async_tx, sh_chan->id,
+		desc->hw.sar, desc->hw.tcr, desc->hw.dar);
 
 	spin_unlock_bh(&sh_chan->desc_lock);
 
 	return cookie;
 }
 
+/* Called with desc_lock held */
 static struct sh_desc *sh_dmae_get_desc(struct sh_dmae_chan *sh_chan)
 {
-	struct sh_desc *desc, *_desc, *ret = NULL;
+	struct sh_desc *desc;
 
-	spin_lock_bh(&sh_chan->desc_lock);
-	list_for_each_entry_safe(desc, _desc, &sh_chan->ld_free, node) {
-		if (async_tx_test_ack(&desc->async_tx)) {
+	list_for_each_entry(desc, &sh_chan->ld_free, node)
+		if (desc->mark != DESC_PREPARED) {
+			BUG_ON(desc->mark != DESC_IDLE);
 			list_del(&desc->node);
-			ret = desc;
-			break;
+			return desc;
 		}
-	}
-	spin_unlock_bh(&sh_chan->desc_lock);
-
-	return ret;
-}
-
-static void sh_dmae_put_desc(struct sh_dmae_chan *sh_chan, struct sh_desc *desc)
-{
-	if (desc) {
-		spin_lock_bh(&sh_chan->desc_lock);
-
-		list_splice_init(&desc->tx_list, &sh_chan->ld_free);
-		list_add(&desc->node, &sh_chan->ld_free);
 
-		spin_unlock_bh(&sh_chan->desc_lock);
-	}
+	return NULL;
 }
 
 static int sh_dmae_alloc_chan_resources(struct dma_chan *chan)
@@ -252,11 +266,10 @@ static int sh_dmae_alloc_chan_resources(struct dma_chan *chan)
 		dma_async_tx_descriptor_init(&desc->async_tx,
 					&sh_chan->common);
 		desc->async_tx.tx_submit = sh_dmae_tx_submit;
-		desc->async_tx.flags = DMA_CTRL_ACK;
-		INIT_LIST_HEAD(&desc->tx_list);
-		sh_dmae_put_desc(sh_chan, desc);
+		desc->mark = DESC_IDLE;
 
 		spin_lock_bh(&sh_chan->desc_lock);
+		list_add(&desc->node, &sh_chan->ld_free);
 		sh_chan->descs_allocated++;
 	}
 	spin_unlock_bh(&sh_chan->desc_lock);
@@ -273,7 +286,10 @@ static void sh_dmae_free_chan_resources(struct dma_chan *chan)
 	struct sh_desc *desc, *_desc;
 	LIST_HEAD(list);
 
-	BUG_ON(!list_empty(&sh_chan->ld_queue));
+	/* Prepared and not submitted descriptors can still be on the queue */
+	if (!list_empty(&sh_chan->ld_queue))
+		sh_dmae_chan_ld_cleanup(sh_chan, true);
+
 	spin_lock_bh(&sh_chan->desc_lock);
 
 	list_splice_init(&sh_chan->ld_free, &list);
@@ -292,6 +308,8 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_memcpy(
 	struct sh_dmae_chan *sh_chan;
 	struct sh_desc *first = NULL, *prev = NULL, *new;
 	size_t copy_size;
+	LIST_HEAD(tx_list);
+	int chunks = (len + SH_DMA_TCR_MAX) / (SH_DMA_TCR_MAX + 1);
 
 	if (!chan)
 		return NULL;
@@ -301,108 +319,189 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_memcpy(
 
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
+	 *	back onto the free list in form of a chain
+	 */
 	do {
-		/* Allocate the link descriptor from DMA pool */
+		/* Allocate the link descriptor from the free list */
 		new = sh_dmae_get_desc(sh_chan);
 		if (!new) {
 			dev_err(sh_chan->dev,
 				"No free memory for link descriptor\n");
-			goto err_get_desc;
+			list_for_each_entry(new, &tx_list, node)
+				new->mark = DESC_IDLE;
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
 
-		new->mark = DESC_NCOMP;
-		async_tx_ack(&new->async_tx);
+		dev_dbg(sh_chan->dev,
+			"chaining %u of %u with %p, dst %x, cookie %d\n",
+			copy_size, len, &new->async_tx, dma_dest,
+			new->async_tx.cookie);
+
+		new->mark = DESC_PREPARED;
+		new->async_tx.flags = flags;
+		new->chunks = chunks--;
 
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
+	/* Put them back on the free list, so, they don't get lost */
+	list_splice_tail(&tx_list, &sh_chan->ld_free);
 
-err_get_desc:
-	sh_dmae_put_desc(sh_chan, first);
-	return NULL;
+	spin_unlock_bh(&sh_chan->desc_lock);
 
+	return &first->async_tx;
 }
 
-/*
- * sh_chan_ld_cleanup - Clean up link descriptors
- *
- * This function clean up the ld_queue of DMA channel.
- */
-static void sh_dmae_chan_ld_cleanup(struct sh_dmae_chan *sh_chan)
+static dma_async_tx_callback __ld_cleanup(struct sh_dmae_chan *sh_chan, bool all)
 {
 	struct sh_desc *desc, *_desc;
+	/* Is the "exposed" head of a chain acked? */
+	bool head_acked = false;
+	dma_cookie_t cookie = 0;
+	dma_async_tx_callback callback = NULL;
+	void *param = NULL;
 
 	spin_lock_bh(&sh_chan->desc_lock);
 	list_for_each_entry_safe(desc, _desc, &sh_chan->ld_queue, node) {
-		dma_async_tx_callback callback;
-		void *callback_param;
-
-		/* non send data */
-		if (desc->mark == DESC_NCOMP)
+		struct dma_async_tx_descriptor *tx = &desc->async_tx;
+
+		BUG_ON(tx->cookie > 0 && tx->cookie != desc->cookie);
+		BUG_ON(desc->mark != DESC_SUBMITTED &&
+		       desc->mark != DESC_COMPLETED &&
+		       desc->mark != DESC_WAITING);
+
+		/*
+		 * queue is ordered, and we use this loop to (1) clean up all
+		 * completed descriptors, and to (2) update descriptor flags of
+		 * any chunks in a (partially) completed chain
+		 */
+		if (!all && desc->mark == DESC_SUBMITTED &&
+		    desc->cookie != cookie)
 			break;
 
-		/* send data sesc */
-		callback = desc->async_tx.callback;
-		callback_param = desc->async_tx.callback_param;
+		if (tx->cookie > 0)
+			cookie = tx->cookie;
 
-		/* Remove from ld_queue list */
-		list_splice_init(&desc->tx_list, &sh_chan->ld_free);
+		if (desc->mark == DESC_COMPLETED && desc->chunks == 1) {
+			BUG_ON(sh_chan->completed_cookie != desc->cookie - 1);
+			sh_chan->completed_cookie = desc->cookie;
+		}
 
-		dev_dbg(sh_chan->dev, "link descriptor %p will be recycle.\n",
-				desc);
+		/* Call callback on the last chunk */
+		if (desc->mark == DESC_COMPLETED && tx->callback) {
+			desc->mark = DESC_WAITING;
+			callback = tx->callback;
+			param = tx->callback_param;
+			dev_dbg(sh_chan->dev, "descriptor #%d@%p on %d callback\n",
+				tx->cookie, tx, sh_chan->id);
+			BUG_ON(desc->chunks != 1);
+			break;
+		}
 
-		list_move(&desc->node, &sh_chan->ld_free);
-		/* Run the link descriptor callback function */
-		if (callback) {
-			spin_unlock_bh(&sh_chan->desc_lock);
-			dev_dbg(sh_chan->dev, "link descriptor %p callback\n",
-					desc);
-			callback(callback_param);
-			spin_lock_bh(&sh_chan->desc_lock);
+		if (tx->cookie > 0 || tx->cookie == -EBUSY) {
+			if (desc->mark == DESC_COMPLETED) {
+				BUG_ON(tx->cookie < 0);
+				desc->mark = DESC_WAITING;
+			}
+			head_acked = async_tx_test_ack(tx);
+		} else {
+			switch (desc->mark) {
+			case DESC_COMPLETED:
+				desc->mark = DESC_WAITING;
+				/* Fall through */
+			case DESC_WAITING:
+				if (head_acked)
+					async_tx_ack(&desc->async_tx);
+			}
+		}
+
+		dev_dbg(sh_chan->dev, "descriptor %p #%d completed.\n",
+			tx, tx->cookie);
+
+		if (((desc->mark == DESC_COMPLETED ||
+		      desc->mark == DESC_WAITING) &&
+		     async_tx_test_ack(&desc->async_tx)) || all) {
+			/* Remove from ld_queue list */
+			desc->mark = DESC_IDLE;
+			list_move(&desc->node, &sh_chan->ld_free);
 		}
 	}
 	spin_unlock_bh(&sh_chan->desc_lock);
+
+	if (callback)
+		callback(param);
+
+	return callback;
+}
+
+/*
+ * sh_chan_ld_cleanup - Clean up link descriptors
+ *
+ * This function cleans up the ld_queue of DMA channel.
+ */
+static void sh_dmae_chan_ld_cleanup(struct sh_dmae_chan *sh_chan, bool all)
+{
+	while (__ld_cleanup(sh_chan, all))
+		;
 }
 
 static void sh_chan_xfer_ld_queue(struct sh_dmae_chan *sh_chan)
 {
-	struct list_head *ld_node;
-	struct sh_dmae_regs hw;
+	struct sh_desc *sd;
 
+	spin_lock_bh(&sh_chan->desc_lock);
 	/* DMA work check */
-	if (dmae_is_busy(sh_chan))
+	if (dmae_is_busy(sh_chan)) {
+		spin_unlock_bh(&sh_chan->desc_lock);
 		return;
+	}
 
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
+			dmae_set_reg(sh_chan, &sd->hw);
+			dmae_start(sh_chan);
+			break;
+		}
+
+	spin_unlock_bh(&sh_chan->desc_lock);
 }
 
 static void sh_dmae_memcpy_issue_pending(struct dma_chan *chan)
@@ -420,12 +519,11 @@ static enum dma_status sh_dmae_is_complete(struct dma_chan *chan,
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
@@ -480,11 +578,13 @@ static irqreturn_t sh_dmae_err(int irq, void *data)
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
@@ -494,35 +594,25 @@ static irqreturn_t sh_dmae_err(int irq, void *data)
 static void dmae_do_tasklet(unsigned long data)
 {
 	struct sh_dmae_chan *sh_chan = (struct sh_dmae_chan *)data;
-	struct sh_desc *desc, *_desc, *cur_desc = NULL;
+	struct sh_desc *desc;
 	u32 sar_buf = sh_dmae_readl(sh_chan, SAR);
 
-	list_for_each_entry_safe(desc, _desc,
-				 &sh_chan->ld_queue, node) {
-		if ((desc->hw.sar + desc->hw.tcr) == sar_buf) {
-			cur_desc = desc;
+	spin_lock(&sh_chan->desc_lock);
+	list_for_each_entry(desc, &sh_chan->ld_queue, node) {
+		if ((desc->hw.sar + desc->hw.tcr) == sar_buf &&
+		    desc->mark == DESC_SUBMITTED) {
+			dev_dbg(sh_chan->dev, "done #%d@%p dst %u\n",
+				desc->async_tx.cookie, &desc->async_tx,
+				desc->hw.dar);
+			desc->mark = DESC_COMPLETED;
 			break;
 		}
 	}
+	spin_unlock(&sh_chan->desc_lock);
 
-	if (cur_desc) {
-		switch (cur_desc->async_tx.cookie) {
-		case 0: /* other desc data */
-			break;
-		case -EBUSY: /* last desc */
-		sh_chan->completed_cookie =
-				cur_desc->async_tx.cookie;
-			break;
-		default: /* first desc ( 0 < )*/
-			sh_chan->completed_cookie =
-				cur_desc->async_tx.cookie - 1;
-			break;
-		}
-		cur_desc->mark = DESC_COMP;
-	}
 	/* Next desc */
 	sh_chan_xfer_ld_queue(sh_chan);
-	sh_dmae_chan_ld_cleanup(sh_chan);
+	sh_dmae_chan_ld_cleanup(sh_chan, false);
 }
 
 static unsigned int get_dmae_irq(unsigned int id)
diff --git a/drivers/dma/shdma.h b/drivers/dma/shdma.h
index 60b81e5..108f1cf 100644
--- a/drivers/dma/shdma.h
+++ b/drivers/dma/shdma.h
@@ -13,9 +13,9 @@
 #ifndef __DMA_SHDMA_H
 #define __DMA_SHDMA_H
 
-#include <linux/device.h>
-#include <linux/dmapool.h>
 #include <linux/dmaengine.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
 
 #define SH_DMA_TCR_MAX 0x00FFFFFF	/* 16MB */
 
@@ -26,13 +26,16 @@ struct sh_dmae_regs {
 };
 
 struct sh_desc {
-	struct list_head tx_list;
 	struct sh_dmae_regs hw;
 	struct list_head node;
 	struct dma_async_tx_descriptor async_tx;
+	dma_cookie_t cookie;
+	int chunks;
 	int mark;
 };
 
+struct device;
+
 struct sh_dmae_chan {
 	dma_cookie_t completed_cookie;	/* The maximum cookie completed */
 	spinlock_t desc_lock;		/* Descriptor operation lock */
-- 
1.6.2.4

