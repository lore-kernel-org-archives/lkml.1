Return-Path: <linux-kernel-owner+w=401wt.eu-S1765362AbYBMHJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765362AbYBMHJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbYBMHJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:09:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:43071 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbYBMHJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:09:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,344,1199692800"; 
   d="scan'208";a="378397756"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/4] async_tx: fix multiple dependency submission
To: linux-kernel@vger.kernel.org
Cc: hskinnemoen@atmel.com, shannon.nelson@intel.com, olof@lixom.net,
       yur@emcraft.com
Date: Wed, 13 Feb 2008 00:03:03 -0700
Message-ID: <20080213070302.793.11306.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20080213065944.793.23537.stgit@dwillia2-linux.ch.intel.com>
References: <20080213065944.793.23537.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shrink struct dma_async_tx_descriptor and introduce
async_tx_channel_switch to properly inject a channel switch interrupt in
the descriptor stream.  This simplifies the locking model as drivers no
longer need to handle dma_async_tx_descriptor.lock.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 crypto/async_tx/async_tx.c |  197 ++++++++++++++++++++++++++++++++++++--------
 drivers/dma/dmaengine.c    |    2 
 drivers/dma/iop-adma.c     |    9 +-
 include/linux/dmaengine.h  |    9 +-
 4 files changed, 170 insertions(+), 47 deletions(-)


diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 2be3bae..6975616 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -89,13 +89,19 @@ dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 		iter = tx;
 
 		/* find the root of the unsubmitted dependency chain */
-		while (iter->cookie == -EBUSY) {
+		do {
 			parent = iter->parent;
-			if (parent && parent->cookie == -EBUSY)
-				iter = iter->parent;
-			else
+			if (!parent)
 				break;
-		}
+			else
+				iter = parent;
+		} while (parent);
+
+		/* there is a small window for ->parent == NULL and
+		 * ->cookie == -EBUSY
+		 */
+		while (iter->cookie == -EBUSY)
+			cpu_relax();
 
 		status = dma_sync_wait(iter->chan, iter->cookie);
 	} while (status == DMA_IN_PROGRESS || (iter != tx));
@@ -111,24 +117,33 @@ EXPORT_SYMBOL_GPL(dma_wait_for_async_tx);
 void
 async_tx_run_dependencies(struct dma_async_tx_descriptor *tx)
 {
-	struct dma_async_tx_descriptor *dep_tx, *_dep_tx;
-	struct dma_device *dev;
+	struct dma_async_tx_descriptor *next = tx->next;
 	struct dma_chan *chan;
 
-	list_for_each_entry_safe(dep_tx, _dep_tx, &tx->depend_list,
-		depend_node) {
-		chan = dep_tx->chan;
-		dev = chan->device;
-		/* we can't depend on ourselves */
-		BUG_ON(chan == tx->chan);
-		list_del(&dep_tx->depend_node);
-		tx->tx_submit(dep_tx);
-
-		/* we need to poke the engine as client code does not
-		 * know about dependency submission events
-		 */
-		dev->device_issue_pending(chan);
+	if (!next)
+		return;
+
+	tx->next = NULL;
+	chan = next->chan;
+
+	/* keep submitting up until a channel switch is detected
+	 * in that case we will be called again as a result of
+	 * processing the interrupt from async_tx_channel_switch
+	 */
+	while (next && next->chan == chan) {
+		struct dma_async_tx_descriptor *_next;
+
+		spin_lock_bh(&next->lock);
+		next->parent = NULL;
+		_next = next->next;
+		next->next = NULL;
+		spin_unlock_bh(&next->lock);
+
+		next->tx_submit(next);
+		next = _next;
 	}
+
+	chan->device->device_issue_pending(chan);
 }
 EXPORT_SYMBOL_GPL(async_tx_run_dependencies);
 
@@ -397,6 +412,92 @@ static void __exit async_tx_exit(void)
 }
 #endif
 
+
+/**
+ * async_tx_channel_switch - queue an interrupt descriptor with a dependency
+ * 	pre-attached.
+ * @depend_tx: the operation that must finish before the new operation runs
+ * @tx: the new operation
+ */
+static void
+async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
+			struct dma_async_tx_descriptor *tx)
+{
+	struct dma_chan *chan;
+	struct dma_device *device;
+	struct dma_async_tx_descriptor *intr_tx = (void *) ~0;
+
+	/* first check to see if we can still append to depend_tx */
+	spin_lock_bh(&depend_tx->lock);
+	if (depend_tx->parent && depend_tx->chan == tx->chan) {
+		tx->parent = depend_tx;
+		depend_tx->next = tx;
+		intr_tx = NULL;
+	}
+	spin_unlock_bh(&depend_tx->lock);
+
+	if (!intr_tx)
+		return;
+
+	chan = depend_tx->chan;
+	device = chan->device;
+
+	/* see if we can schedule an interrupt
+	 * otherwise poll for completion
+	 */
+	if (dma_has_cap(DMA_INTERRUPT, device->cap_mask))
+		intr_tx = device->device_prep_dma_interrupt(chan);
+	else
+		intr_tx = NULL;
+
+	if (intr_tx) {
+		intr_tx->callback = NULL;
+		intr_tx->callback_param = NULL;
+		tx->parent = intr_tx;
+		/* safe to set ->next outside the lock since we know we are
+		 * not submitted yet
+		 */
+		intr_tx->next = tx;
+
+		/* check if we need to append */
+		spin_lock_bh(&depend_tx->lock);
+		if (depend_tx->parent) {
+			intr_tx->parent = depend_tx;
+			depend_tx->next = intr_tx;
+			async_tx_ack(intr_tx);
+			intr_tx = NULL;
+		}
+		spin_unlock_bh(&depend_tx->lock);
+
+		if (intr_tx) {
+			intr_tx->parent = NULL;
+			intr_tx->tx_submit(intr_tx);
+			async_tx_ack(intr_tx);
+		}
+	} else {
+		if (dma_wait_for_async_tx(depend_tx) == DMA_ERROR)
+			panic("%s: DMA_ERROR waiting for depend_tx\n",
+			      __func__);
+		tx->tx_submit(tx);
+	}
+}
+
+
+/**
+ * submit_disposition - while holding depend_tx->lock we must avoid submitting
+ * 	new operations to prevent a circular locking dependency with
+ * 	drivers that already hold a channel lock when calling
+ * 	async_tx_run_dependencies.
+ * @ASYNC_TX_SUBMITTED: we were able to append the new operation under the lock
+ * @ASYNC_TX_CHANNEL_SWITCH: when the lock is dropped schedule a channel switch
+ * @ASYNC_TX_DIRECT_SUBMIT: when the lock is dropped submit directly
+ */
+enum submit_disposition {
+	ASYNC_TX_SUBMITTED,
+	ASYNC_TX_CHANNEL_SWITCH,
+	ASYNC_TX_DIRECT_SUBMIT,
+};
+
 void
 async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
 	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
@@ -405,28 +506,54 @@ async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
 	tx->callback = cb_fn;
 	tx->callback_param = cb_param;
 
-	/* set this new tx to run after depend_tx if:
-	 * 1/ a dependency exists (depend_tx is !NULL)
-	 * 2/ the tx can not be submitted to the current channel
-	 */
-	if (depend_tx && depend_tx->chan != chan) {
-		/* if ack is already set then we cannot be sure
+	if (depend_tx) {
+		enum submit_disposition s;
+
+		/* sanity check the dependency chain:
+		 * 1/ if ack is already set then we cannot be sure
 		 * we are referring to the correct operation
+		 * 2/ dependencies are 1:1 i.e. two transactions can
+		 * not depend on the same parent
 		 */
-		BUG_ON(depend_tx->ack);
+		BUG_ON(depend_tx->ack || depend_tx->next || tx->parent);
 
-		tx->parent = depend_tx;
+		/* the lock prevents async_tx_run_dependencies from missing
+		 * the setting of ->next when ->parent != NULL
+		 */
 		spin_lock_bh(&depend_tx->lock);
-		list_add_tail(&tx->depend_node, &depend_tx->depend_list);
-		if (depend_tx->cookie == 0) {
-			struct dma_chan *dep_chan = depend_tx->chan;
-			struct dma_device *dep_dev = dep_chan->device;
-			dep_dev->device_dependency_added(dep_chan);
+		if (depend_tx->parent) {
+			/* we have a parent so we can not submit directly
+			 * if we are staying on the same channel: append
+			 * else: channel switch
+			 */
+			if (depend_tx->chan == chan) {
+				tx->parent = depend_tx;
+				depend_tx->next = tx;
+				s = ASYNC_TX_SUBMITTED;
+			} else
+				s = ASYNC_TX_CHANNEL_SWITCH;
+		} else {
+			/* we do not have a parent so we may be able to submit
+			 * directly if we are staying on the same channel
+			 */
+			if (depend_tx->chan == chan)
+				s = ASYNC_TX_DIRECT_SUBMIT;
+			else
+				s = ASYNC_TX_CHANNEL_SWITCH;
 		}
 		spin_unlock_bh(&depend_tx->lock);
 
-		/* schedule an interrupt to trigger the channel switch */
-		async_trigger_callback(ASYNC_TX_ACK, depend_tx, NULL, NULL);
+		switch (s) {
+		case ASYNC_TX_SUBMITTED:
+			break;
+		case ASYNC_TX_CHANNEL_SWITCH:
+			async_tx_channel_switch(depend_tx, tx);
+			break;
+		case ASYNC_TX_DIRECT_SUBMIT:
+			tx->parent = NULL;
+			tx->tx_submit(tx);
+			break;
+		}
 	} else {
 		tx->parent = NULL;
 		tx->tx_submit(tx);
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 2996523..9369781 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -600,8 +600,6 @@ void dma_async_tx_descriptor_init(struct dma_async_tx_descriptor *tx,
 {
 	tx->chan = chan;
 	spin_lock_init(&tx->lock);
-	INIT_LIST_HEAD(&tx->depend_node);
-	INIT_LIST_HEAD(&tx->depend_list);
 }
 EXPORT_SYMBOL(dma_async_tx_descriptor_init);
 
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 3986d54..a6171da 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -63,7 +63,6 @@ iop_adma_run_tx_complete_actions(struct iop_adma_desc_slot *desc,
 	struct iop_adma_chan *iop_chan, dma_cookie_t cookie)
 {
 	BUG_ON(desc->async_tx.cookie < 0);
-	spin_lock_bh(&desc->async_tx.lock);
 	if (desc->async_tx.cookie > 0) {
 		cookie = desc->async_tx.cookie;
 		desc->async_tx.cookie = 0;
@@ -101,7 +100,6 @@ iop_adma_run_tx_complete_actions(struct iop_adma_desc_slot *desc,
 
 	/* run dependent operations */
 	async_tx_run_dependencies(&desc->async_tx);
-	spin_unlock_bh(&desc->async_tx.lock);
 
 	return cookie;
 }
@@ -275,8 +273,11 @@ iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
 
 static void iop_adma_tasklet(unsigned long data)
 {
-	struct iop_adma_chan *chan = (struct iop_adma_chan *) data;
-	__iop_adma_slot_cleanup(chan);
+	struct iop_adma_chan *iop_chan = (struct iop_adma_chan *) data;
+
+	spin_lock(&iop_chan->lock);
+	__iop_adma_slot_cleanup(iop_chan);
+	spin_unlock(&iop_chan->lock);
 }
 
 static struct iop_adma_desc_slot *
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index acbb364..d04b169 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -221,11 +221,9 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
  * @callback: routine to call after this operation is complete
  * @callback_param: general parameter to pass to the callback routine
  * ---async_tx api specific fields---
- * @depend_list: at completion this list of transactions are submitted
- * @depend_node: allow this transaction to be executed after another
- *	transaction has completed, possibly on another channel
+ * @next: at completion submit this descriptor
  * @parent: pointer to the next level up in the dependency chain
- * @lock: protect the dependency list
+ * @lock: protect the parent and next pointers
  */
 struct dma_async_tx_descriptor {
 	dma_cookie_t cookie;
@@ -236,8 +234,7 @@ struct dma_async_tx_descriptor {
 	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
 	dma_async_tx_callback callback;
 	void *callback_param;
-	struct list_head depend_list;
-	struct list_head depend_node;
+	struct dma_async_tx_descriptor *next;
 	struct dma_async_tx_descriptor *parent;
 	spinlock_t lock;
 };

