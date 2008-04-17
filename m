Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYDQV3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYDQV3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 17:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbYDQV3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 17:29:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:15270 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbYDQV3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 17:29:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,673,1199692800"; 
   d="scan'208";a="234147957"
Subject: [git pull] async-tx update for 2.6.26
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Zhang Wei <wei.zhang@freescale.com>,
       Shannon Nelson <shannon.nelson@intel.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Apr 2008 14:29:12 -0700
Message-Id: <1208467753.10141.19.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

	master.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

to receive:

Dan Williams (4):
      async_tx: fix multiple dependency submission
      async_tx: kill ->device_dependency_added
      iop-adma: remove the workaround for missed interrupts on iop3xx
      dmaengine: ack to flags: make use of the unused bits in the 'ack' field

Zhang Wei (2):
      fsldma: Remove CONFIG_FSL_DMA_SELFTEST, keep fsl_dma_self_test() running always.
      fsldma: Split the MPC83xx event from MPC85xx and refine irq codes.

 crypto/async_tx/async_memcpy.c         |    2 +-
 crypto/async_tx/async_tx.c             |  202 ++++++++++++++++++++++++++------
 crypto/async_tx/async_xor.c            |    2 +-
 drivers/dma/Kconfig                    |    8 --
 drivers/dma/dmaengine.c                |   15 +--
 drivers/dma/fsldma.c                   |   57 +++++-----
 drivers/dma/ioat_dma.c                 |   36 ++----
 drivers/dma/iop-adma.c                 |   60 ++++------
 include/asm-arm/arch-iop13xx/adma.h    |    5 -
 include/asm-arm/hardware/iop3xx-adma.h |    8 --
 include/asm-arm/hardware/iop_adma.h    |    2 -
 include/linux/dmaengine.h              |   36 ++++---
 12 files changed, 261 insertions(+), 172 deletions(-)

These have been in -next and -mm for about 5 weeks.  The primary change
is fixing a thinko in the core dependency submission code.  It was being
hidden by a workaround in iop-adma, currently the only in-tree user.
The rest are general cleanups.

Regards,
Dan

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 84caa4e..a5eda80 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -77,7 +77,7 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 			/* if ack is already set then we cannot be sure
 			 * we are referring to the correct operation
 			 */
-			BUG_ON(depend_tx->ack);
+			BUG_ON(async_tx_test_ack(depend_tx));
 			if (dma_wait_for_async_tx(depend_tx) == DMA_ERROR)
 				panic("%s: DMA_ERROR waiting for depend_tx\n",
 					__func__);
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 2be3bae..c6e772f 100644
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
+		intr_tx = device->device_prep_dma_interrupt(chan, 0);
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
@@ -405,28 +506,55 @@ async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
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
+		BUG_ON(async_tx_test_ack(depend_tx) || depend_tx->next ||
+		       tx->parent);
 
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
@@ -467,7 +595,7 @@ async_trigger_callback(enum async_tx_flags flags,
 		if (device && !dma_has_cap(DMA_INTERRUPT, device->cap_mask))
 			device = NULL;
 
-		tx = device ? device->device_prep_dma_interrupt(chan) : NULL;
+		tx = device ? device->device_prep_dma_interrupt(chan, 0) : NULL;
 	} else
 		tx = NULL;
 
@@ -483,7 +611,7 @@ async_trigger_callback(enum async_tx_flags flags,
 			/* if ack is already set then we cannot be sure
 			 * we are referring to the correct operation
 			 */
-			BUG_ON(depend_tx->ack);
+			BUG_ON(async_tx_test_ack(depend_tx));
 			if (dma_wait_for_async_tx(depend_tx) == DMA_ERROR)
 				panic("%s: DMA_ERROR waiting for depend_tx\n",
 					__func__);
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 1c445c7..3a0dddc 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -191,7 +191,7 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 				/* if ack is already set then we cannot be sure
 				 * we are referring to the correct operation
 				 */
-				BUG_ON(depend_tx->ack);
+				BUG_ON(async_tx_test_ack(depend_tx));
 				if (dma_wait_for_async_tx(depend_tx) ==
 					DMA_ERROR)
 					panic("%s: DMA_ERROR waiting for "
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 27340a7..6239c3d 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -46,14 +46,6 @@ config FSL_DMA
 	  MPC8560/40, MPC8555, MPC8548 and MPC8641 processors.
 	  The MPC8349, MPC8360 is also supported.
 
-config FSL_DMA_SELFTEST
-	bool "Enable the self test for each DMA channel"
-	depends on FSL_DMA
-	default y
-	---help---
-	  Enable the self test for each DMA channel. A self test will be
-	  performed after the channel probed to ensure the DMA works well.
-
 config DMA_ENGINE
 	bool
 
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 8db0e7f..d6dc70f 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -362,7 +362,6 @@ int dma_async_device_register(struct dma_device *device)
 
 	BUG_ON(!device->device_alloc_chan_resources);
 	BUG_ON(!device->device_free_chan_resources);
-	BUG_ON(!device->device_dependency_added);
 	BUG_ON(!device->device_is_tx_complete);
 	BUG_ON(!device->device_issue_pending);
 	BUG_ON(!device->dev);
@@ -479,7 +478,8 @@ dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
 
 	dma_src = dma_map_single(dev->dev, src, len, DMA_TO_DEVICE);
 	dma_dest = dma_map_single(dev->dev, dest, len, DMA_FROM_DEVICE);
-	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, 0);
+	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len,
+					 DMA_CTRL_ACK);
 
 	if (!tx) {
 		dma_unmap_single(dev->dev, dma_src, len, DMA_TO_DEVICE);
@@ -487,7 +487,6 @@ dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
 		return -ENOMEM;
 	}
 
-	tx->ack = 1;
 	tx->callback = NULL;
 	cookie = tx->tx_submit(tx);
 
@@ -525,7 +524,8 @@ dma_async_memcpy_buf_to_pg(struct dma_chan *chan, struct page *page,
 
 	dma_src = dma_map_single(dev->dev, kdata, len, DMA_TO_DEVICE);
 	dma_dest = dma_map_page(dev->dev, page, offset, len, DMA_FROM_DEVICE);
-	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, 0);
+	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len,
+					 DMA_CTRL_ACK);
 
 	if (!tx) {
 		dma_unmap_single(dev->dev, dma_src, len, DMA_TO_DEVICE);
@@ -533,7 +533,6 @@ dma_async_memcpy_buf_to_pg(struct dma_chan *chan, struct page *page,
 		return -ENOMEM;
 	}
 
-	tx->ack = 1;
 	tx->callback = NULL;
 	cookie = tx->tx_submit(tx);
 
@@ -574,7 +573,8 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
 	dma_src = dma_map_page(dev->dev, src_pg, src_off, len, DMA_TO_DEVICE);
 	dma_dest = dma_map_page(dev->dev, dest_pg, dest_off, len,
 				DMA_FROM_DEVICE);
-	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, 0);
+	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len,
+					 DMA_CTRL_ACK);
 
 	if (!tx) {
 		dma_unmap_page(dev->dev, dma_src, len, DMA_TO_DEVICE);
@@ -582,7 +582,6 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
 		return -ENOMEM;
 	}
 
-	tx->ack = 1;
 	tx->callback = NULL;
 	cookie = tx->tx_submit(tx);
 
@@ -600,8 +599,6 @@ void dma_async_tx_descriptor_init(struct dma_async_tx_descriptor *tx,
 {
 	tx->chan = chan;
 	spin_lock_init(&tx->lock);
-	INIT_LIST_HEAD(&tx->depend_node);
-	INIT_LIST_HEAD(&tx->depend_list);
 }
 EXPORT_SYMBOL(dma_async_tx_descriptor_init);
 
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index df16368..054eabf 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -412,7 +412,7 @@ static void fsl_dma_free_chan_resources(struct dma_chan *chan)
 }
 
 static struct dma_async_tx_descriptor *
-fsl_dma_prep_interrupt(struct dma_chan *chan)
+fsl_dma_prep_interrupt(struct dma_chan *chan, unsigned long flags)
 {
 	struct fsl_dma_chan *fsl_chan;
 	struct fsl_desc_sw *new;
@@ -429,7 +429,7 @@ fsl_dma_prep_interrupt(struct dma_chan *chan)
 	}
 
 	new->async_tx.cookie = -EBUSY;
-	new->async_tx.ack = 0;
+	new->async_tx.flags = flags;
 
 	/* Insert the link descriptor to the LD ring */
 	list_add_tail(&new->node, &new->async_tx.tx_list);
@@ -482,7 +482,7 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 			set_desc_next(fsl_chan, &prev->hw, new->async_tx.phys);
 
 		new->async_tx.cookie = 0;
-		new->async_tx.ack = 1;
+		async_tx_ack(&new->async_tx);
 
 		prev = new;
 		len -= copy;
@@ -493,7 +493,7 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 		list_add_tail(&new->node, &first->async_tx.tx_list);
 	} while (len);
 
-	new->async_tx.ack = 0; /* client is in control of this ack */
+	new->async_tx.flags = flags; /* client is in control of this ack */
 	new->async_tx.cookie = -EBUSY;
 
 	/* Set End-of-link to the last link descriptor of new list*/
@@ -658,13 +658,6 @@ static void fsl_dma_memcpy_issue_pending(struct dma_chan *chan)
 	fsl_chan_xfer_ld_queue(fsl_chan);
 }
 
-static void fsl_dma_dependency_added(struct dma_chan *chan)
-{
-	struct fsl_dma_chan *fsl_chan = to_fsl_chan(chan);
-
-	fsl_chan_ld_cleanup(fsl_chan);
-}
-
 /**
  * fsl_dma_is_complete - Determine the DMA status
  * @fsl_chan : Freescale DMA channel
@@ -696,6 +689,8 @@ static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
 {
 	struct fsl_dma_chan *fsl_chan = (struct fsl_dma_chan *)data;
 	u32 stat;
+	int update_cookie = 0;
+	int xfer_ld_q = 0;
 
 	stat = get_sr(fsl_chan);
 	dev_dbg(fsl_chan->dev, "event: channel %d, stat = 0x%x\n",
@@ -720,8 +715,8 @@ static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
 			 * Now, update the completed cookie, and continue the
 			 * next uncompleted transfer.
 			 */
-			fsl_dma_update_completed_cookie(fsl_chan);
-			fsl_chan_xfer_ld_queue(fsl_chan);
+			update_cookie = 1;
+			xfer_ld_q = 1;
 		}
 		stat &= ~FSL_DMA_SR_PE;
 	}
@@ -734,19 +729,33 @@ static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
 		dev_dbg(fsl_chan->dev, "event: clndar %p, nlndar %p\n",
 			(void *)get_cdar(fsl_chan), (void *)get_ndar(fsl_chan));
 		stat &= ~FSL_DMA_SR_EOSI;
-		fsl_dma_update_completed_cookie(fsl_chan);
+		update_cookie = 1;
+	}
+
+	/* For MPC8349, EOCDI event need to update cookie
+	 * and start the next transfer if it exist.
+	 */
+	if (stat & FSL_DMA_SR_EOCDI) {
+		dev_dbg(fsl_chan->dev, "event: End-of-Chain link INT\n");
+		stat &= ~FSL_DMA_SR_EOCDI;
+		update_cookie = 1;
+		xfer_ld_q = 1;
 	}
 
 	/* If it current transfer is the end-of-transfer,
 	 * we should clear the Channel Start bit for
 	 * prepare next transfer.
 	 */
-	if (stat & (FSL_DMA_SR_EOLNI | FSL_DMA_SR_EOCDI)) {
+	if (stat & FSL_DMA_SR_EOLNI) {
 		dev_dbg(fsl_chan->dev, "event: End-of-link INT\n");
 		stat &= ~FSL_DMA_SR_EOLNI;
-		fsl_chan_xfer_ld_queue(fsl_chan);
+		xfer_ld_q = 1;
 	}
 
+	if (update_cookie)
+		fsl_dma_update_completed_cookie(fsl_chan);
+	if (xfer_ld_q)
+		fsl_chan_xfer_ld_queue(fsl_chan);
 	if (stat)
 		dev_dbg(fsl_chan->dev, "event: unhandled sr 0x%02x\n",
 					stat);
@@ -776,15 +785,13 @@ static void dma_do_tasklet(unsigned long data)
 	fsl_chan_ld_cleanup(fsl_chan);
 }
 
-#ifdef FSL_DMA_CALLBACKTEST
-static void fsl_dma_callback_test(struct fsl_dma_chan *fsl_chan)
+static void fsl_dma_callback_test(void *param)
 {
+	struct fsl_dma_chan *fsl_chan = param;
 	if (fsl_chan)
-		dev_info(fsl_chan->dev, "selftest: callback is ok!\n");
+		dev_dbg(fsl_chan->dev, "selftest: callback is ok!\n");
 }
-#endif
 
-#ifdef CONFIG_FSL_DMA_SELFTEST
 static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 {
 	struct dma_chan *chan;
@@ -867,7 +874,7 @@ static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 	async_tx_ack(tx3);
 
 	/* Interrupt tx test */
-	tx1 = fsl_dma_prep_interrupt(chan);
+	tx1 = fsl_dma_prep_interrupt(chan, 0);
 	async_tx_ack(tx1);
 	cookie = fsl_dma_tx_submit(tx1);
 
@@ -875,13 +882,11 @@ static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 	cookie = fsl_dma_tx_submit(tx3);
 	cookie = fsl_dma_tx_submit(tx2);
 
-#ifdef FSL_DMA_CALLBACKTEST
 	if (dma_has_cap(DMA_INTERRUPT, ((struct fsl_dma_device *)
 	    dev_get_drvdata(fsl_chan->dev->parent))->common.cap_mask)) {
 		tx3->callback = fsl_dma_callback_test;
 		tx3->callback_param = fsl_chan;
 	}
-#endif
 	fsl_dma_memcpy_issue_pending(chan);
 	msleep(2);
 
@@ -906,7 +911,6 @@ out:
 	kfree(src);
 	return err;
 }
-#endif
 
 static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 			const struct of_device_id *match)
@@ -997,11 +1001,9 @@ static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 		}
 	}
 
-#ifdef CONFIG_FSL_DMA_SELFTEST
 	err = fsl_dma_self_test(new_fsl_chan);
 	if (err)
 		goto err;
-#endif
 
 	dev_info(&dev->dev, "#%d (%s), irq %d\n", new_fsl_chan->id,
 				match->compatible, new_fsl_chan->irq);
@@ -1080,7 +1082,6 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
 	fdev->common.device_prep_dma_memcpy = fsl_dma_prep_memcpy;
 	fdev->common.device_is_tx_complete = fsl_dma_is_complete;
 	fdev->common.device_issue_pending = fsl_dma_memcpy_issue_pending;
-	fdev->common.device_dependency_added = fsl_dma_dependency_added;
 	fdev->common.dev = &dev->dev;
 
 	irq = irq_of_parse_and_map(dev->node, 0);
diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 4017d9e..318e8a2 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -212,14 +212,14 @@ static dma_cookie_t ioat1_tx_submit(struct dma_async_tx_descriptor *tx)
 	u32 copy;
 	size_t len;
 	dma_addr_t src, dst;
-	int orig_ack;
+	unsigned long orig_flags;
 	unsigned int desc_count = 0;
 
 	/* src and dest and len are stored in the initial descriptor */
 	len = first->len;
 	src = first->src;
 	dst = first->dst;
-	orig_ack = first->async_tx.ack;
+	orig_flags = first->async_tx.flags;
 	new = first;
 
 	spin_lock_bh(&ioat_chan->desc_lock);
@@ -228,7 +228,7 @@ static dma_cookie_t ioat1_tx_submit(struct dma_async_tx_descriptor *tx)
 	do {
 		copy = min_t(size_t, len, ioat_chan->xfercap);
 
-		new->async_tx.ack = 1;
+		async_tx_ack(&new->async_tx);
 
 		hw = new->hw;
 		hw->size = copy;
@@ -264,7 +264,7 @@ static dma_cookie_t ioat1_tx_submit(struct dma_async_tx_descriptor *tx)
 	}
 
 	new->tx_cnt = desc_count;
-	new->async_tx.ack = orig_ack; /* client is in control of this ack */
+	new->async_tx.flags = orig_flags; /* client is in control of this ack */
 
 	/* store the original values for use in later cleanup */
 	if (new != first) {
@@ -304,14 +304,14 @@ static dma_cookie_t ioat2_tx_submit(struct dma_async_tx_descriptor *tx)
 	u32 copy;
 	size_t len;
 	dma_addr_t src, dst;
-	int orig_ack;
+	unsigned long orig_flags;
 	unsigned int desc_count = 0;
 
 	/* src and dest and len are stored in the initial descriptor */
 	len = first->len;
 	src = first->src;
 	dst = first->dst;
-	orig_ack = first->async_tx.ack;
+	orig_flags = first->async_tx.flags;
 	new = first;
 
 	/*
@@ -321,7 +321,7 @@ static dma_cookie_t ioat2_tx_submit(struct dma_async_tx_descriptor *tx)
 	do {
 		copy = min_t(size_t, len, ioat_chan->xfercap);
 
-		new->async_tx.ack = 1;
+		async_tx_ack(&new->async_tx);
 
 		hw = new->hw;
 		hw->size = copy;
@@ -349,7 +349,7 @@ static dma_cookie_t ioat2_tx_submit(struct dma_async_tx_descriptor *tx)
 	}
 
 	new->tx_cnt = desc_count;
-	new->async_tx.ack = orig_ack; /* client is in control of this ack */
+	new->async_tx.flags = orig_flags; /* client is in control of this ack */
 
 	/* store the original values for use in later cleanup */
 	if (new != first) {
@@ -714,7 +714,7 @@ static struct dma_async_tx_descriptor *ioat1_dma_prep_memcpy(
 		new->len = len;
 		new->dst = dma_dest;
 		new->src = dma_src;
-		new->async_tx.ack = 0;
+		new->async_tx.flags = flags;
 		return &new->async_tx;
 	} else
 		return NULL;
@@ -742,7 +742,7 @@ static struct dma_async_tx_descriptor *ioat2_dma_prep_memcpy(
 		new->len = len;
 		new->dst = dma_dest;
 		new->src = dma_src;
-		new->async_tx.ack = 0;
+		new->async_tx.flags = flags;
 		return &new->async_tx;
 	} else
 		return NULL;
@@ -842,7 +842,7 @@ static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan)
 				 * a completed entry, but not the last, so clean
 				 * up if the client is done with the descriptor
 				 */
-				if (desc->async_tx.ack) {
+				if (async_tx_test_ack(&desc->async_tx)) {
 					list_del(&desc->node);
 					list_add_tail(&desc->node,
 						      &ioat_chan->free_desc);
@@ -924,17 +924,6 @@ static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan)
 	spin_unlock_bh(&ioat_chan->cleanup_lock);
 }
 
-static void ioat_dma_dependency_added(struct dma_chan *chan)
-{
-	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
-	spin_lock_bh(&ioat_chan->desc_lock);
-	if (ioat_chan->pending == 0) {
-		spin_unlock_bh(&ioat_chan->desc_lock);
-		ioat_dma_memcpy_cleanup(ioat_chan);
-	} else
-		spin_unlock_bh(&ioat_chan->desc_lock);
-}
-
 /**
  * ioat_dma_is_complete - poll the status of a IOAT DMA transaction
  * @chan: IOAT DMA channel handle
@@ -990,7 +979,7 @@ static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan)
 	desc->hw->size = 0;
 	desc->hw->src_addr = 0;
 	desc->hw->dst_addr = 0;
-	desc->async_tx.ack = 1;
+	async_tx_ack(&desc->async_tx);
 	switch (ioat_chan->device->version) {
 	case IOAT_VER_1_2:
 		desc->hw->next = 0;
@@ -1316,7 +1305,6 @@ struct ioatdma_device *ioat_dma_probe(struct pci_dev *pdev,
 
 	dma_cap_set(DMA_MEMCPY, device->common.cap_mask);
 	device->common.device_is_tx_complete = ioat_dma_is_complete;
-	device->common.device_dependency_added = ioat_dma_dependency_added;
 	switch (device->version) {
 	case IOAT_VER_1_2:
 		device->common.device_prep_dma_memcpy = ioat1_dma_prep_memcpy;
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index f82b090..762b729 100644
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
@@ -113,7 +111,7 @@ iop_adma_clean_slot(struct iop_adma_desc_slot *desc,
 	/* the client is allowed to attach dependent operations
 	 * until 'ack' is set
 	 */
-	if (!desc->async_tx.ack)
+	if (!async_tx_test_ack(&desc->async_tx))
 		return 0;
 
 	/* leave the last descriptor in the chain
@@ -150,7 +148,7 @@ static void __iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
 			"this_desc: %#x next_desc: %#x ack: %d\n",
 			iter->async_tx.cookie, iter->idx, busy,
 			iter->async_tx.phys, iop_desc_get_next_desc(iter),
-			iter->async_tx.ack);
+			async_tx_test_ack(&iter->async_tx));
 		prefetch(_iter);
 		prefetch(&_iter->async_tx);
 
@@ -257,8 +255,6 @@ static void __iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
 
 	BUG_ON(!seen_current);
 
-	iop_chan_idle(busy, iop_chan);
-
 	if (cookie > 0) {
 		iop_chan->completed_cookie = cookie;
 		pr_debug("\tcompleted cookie %d\n", cookie);
@@ -275,8 +271,11 @@ iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
 
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
@@ -339,9 +338,7 @@ retry:
 
 				/* pre-ack all but the last descriptor */
 				if (num_slots != slots_per_op)
-					iter->async_tx.ack = 1;
-				else
-					iter->async_tx.ack = 0;
+					async_tx_ack(&iter->async_tx);
 
 				list_add_tail(&iter->chain_node, &chain);
 				alloc_tail = iter;
@@ -514,7 +511,7 @@ static int iop_adma_alloc_chan_resources(struct dma_chan *chan)
 }
 
 static struct dma_async_tx_descriptor *
-iop_adma_prep_dma_interrupt(struct dma_chan *chan)
+iop_adma_prep_dma_interrupt(struct dma_chan *chan, unsigned long flags)
 {
 	struct iop_adma_chan *iop_chan = to_iop_adma_chan(chan);
 	struct iop_adma_desc_slot *sw_desc, *grp_start;
@@ -529,6 +526,7 @@ iop_adma_prep_dma_interrupt(struct dma_chan *chan)
 		grp_start = sw_desc->group_head;
 		iop_desc_init_interrupt(grp_start, iop_chan);
 		grp_start->unmap_len = 0;
+		sw_desc->async_tx.flags = flags;
 	}
 	spin_unlock_bh(&iop_chan->lock);
 
@@ -561,6 +559,7 @@ iop_adma_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dma_dest,
 		iop_desc_set_memcpy_src_addr(grp_start, dma_src);
 		sw_desc->unmap_src_cnt = 1;
 		sw_desc->unmap_len = len;
+		sw_desc->async_tx.flags = flags;
 	}
 	spin_unlock_bh(&iop_chan->lock);
 
@@ -593,6 +592,7 @@ iop_adma_prep_dma_memset(struct dma_chan *chan, dma_addr_t dma_dest,
 		iop_desc_set_dest_addr(grp_start, iop_chan, dma_dest);
 		sw_desc->unmap_src_cnt = 1;
 		sw_desc->unmap_len = len;
+		sw_desc->async_tx.flags = flags;
 	}
 	spin_unlock_bh(&iop_chan->lock);
 
@@ -626,6 +626,7 @@ iop_adma_prep_dma_xor(struct dma_chan *chan, dma_addr_t dma_dest,
 		iop_desc_set_dest_addr(grp_start, iop_chan, dma_dest);
 		sw_desc->unmap_src_cnt = src_cnt;
 		sw_desc->unmap_len = len;
+		sw_desc->async_tx.flags = flags;
 		while (src_cnt--)
 			iop_desc_set_xor_src_addr(grp_start, src_cnt,
 						  dma_src[src_cnt]);
@@ -662,6 +663,7 @@ iop_adma_prep_dma_zero_sum(struct dma_chan *chan, dma_addr_t *dma_src,
 			__func__, grp_start->xor_check_result);
 		sw_desc->unmap_src_cnt = src_cnt;
 		sw_desc->unmap_len = len;
+		sw_desc->async_tx.flags = flags;
 		while (src_cnt--)
 			iop_desc_set_zero_sum_src_addr(grp_start, src_cnt,
 						       dma_src[src_cnt]);
@@ -671,12 +673,6 @@ iop_adma_prep_dma_zero_sum(struct dma_chan *chan, dma_addr_t *dma_src,
 	return sw_desc ? &sw_desc->async_tx : NULL;
 }
 
-static void iop_adma_dependency_added(struct dma_chan *chan)
-{
-	struct iop_adma_chan *iop_chan = to_iop_adma_chan(chan);
-	tasklet_schedule(&iop_chan->irq_tasklet);
-}
-
 static void iop_adma_free_chan_resources(struct dma_chan *chan)
 {
 	struct iop_adma_chan *iop_chan = to_iop_adma_chan(chan);
@@ -854,11 +850,11 @@ static int __devinit iop_adma_memcpy_self_test(struct iop_adma_device *device)
 	src_dma = dma_map_single(dma_chan->device->dev, src,
 				IOP_ADMA_TEST_SIZE, DMA_TO_DEVICE);
 	tx = iop_adma_prep_dma_memcpy(dma_chan, dest_dma, src_dma,
-				      IOP_ADMA_TEST_SIZE, 1);
+				      IOP_ADMA_TEST_SIZE,
+				      DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 
 	cookie = iop_adma_tx_submit(tx);
 	iop_adma_issue_pending(dma_chan);
-	async_tx_ack(tx);
 	msleep(1);
 
 	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) !=
@@ -954,11 +950,11 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 		dma_srcs[i] = dma_map_page(dma_chan->device->dev, xor_srcs[i],
 					   0, PAGE_SIZE, DMA_TO_DEVICE);
 	tx = iop_adma_prep_dma_xor(dma_chan, dest_dma, dma_srcs,
-				   IOP_ADMA_NUM_SRC_TEST, PAGE_SIZE, 1);
+				   IOP_ADMA_NUM_SRC_TEST, PAGE_SIZE,
+				   DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 
 	cookie = iop_adma_tx_submit(tx);
 	iop_adma_issue_pending(dma_chan);
-	async_tx_ack(tx);
 	msleep(8);
 
 	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) !=
@@ -1001,11 +997,11 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 					   DMA_TO_DEVICE);
 	tx = iop_adma_prep_dma_zero_sum(dma_chan, dma_srcs,
 					IOP_ADMA_NUM_SRC_TEST + 1, PAGE_SIZE,
-					&zero_sum_result, 1);
+					&zero_sum_result,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 
 	cookie = iop_adma_tx_submit(tx);
 	iop_adma_issue_pending(dma_chan);
-	async_tx_ack(tx);
 	msleep(8);
 
 	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) != DMA_SUCCESS) {
@@ -1025,11 +1021,11 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 	/* test memset */
 	dma_addr = dma_map_page(dma_chan->device->dev, dest, 0,
 			PAGE_SIZE, DMA_FROM_DEVICE);
-	tx = iop_adma_prep_dma_memset(dma_chan, dma_addr, 0, PAGE_SIZE, 1);
+	tx = iop_adma_prep_dma_memset(dma_chan, dma_addr, 0, PAGE_SIZE,
+				      DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 
 	cookie = iop_adma_tx_submit(tx);
 	iop_adma_issue_pending(dma_chan);
-	async_tx_ack(tx);
 	msleep(8);
 
 	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) != DMA_SUCCESS) {
@@ -1057,11 +1053,11 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 					   DMA_TO_DEVICE);
 	tx = iop_adma_prep_dma_zero_sum(dma_chan, dma_srcs,
 					IOP_ADMA_NUM_SRC_TEST + 1, PAGE_SIZE,
-					&zero_sum_result, 1);
+					&zero_sum_result,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 
 	cookie = iop_adma_tx_submit(tx);
 	iop_adma_issue_pending(dma_chan);
-	async_tx_ack(tx);
 	msleep(8);
 
 	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) != DMA_SUCCESS) {
@@ -1177,7 +1173,6 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 	dma_dev->device_free_chan_resources = iop_adma_free_chan_resources;
 	dma_dev->device_is_tx_complete = iop_adma_is_complete;
 	dma_dev->device_issue_pending = iop_adma_issue_pending;
-	dma_dev->device_dependency_added = iop_adma_dependency_added;
 	dma_dev->dev = &pdev->dev;
 
 	/* set prep routines based on capability */
@@ -1232,9 +1227,6 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 	}
 
 	spin_lock_init(&iop_chan->lock);
-	init_timer(&iop_chan->cleanup_watchdog);
-	iop_chan->cleanup_watchdog.data = (unsigned long) iop_chan;
-	iop_chan->cleanup_watchdog.function = iop_adma_tasklet;
 	INIT_LIST_HEAD(&iop_chan->chain);
 	INIT_LIST_HEAD(&iop_chan->all_slots);
 	INIT_RCU_HEAD(&iop_chan->common.rcu);
@@ -1298,7 +1290,7 @@ static void iop_chan_start_null_memcpy(struct iop_adma_chan *iop_chan)
 		grp_start = sw_desc->group_head;
 
 		list_splice_init(&sw_desc->async_tx.tx_list, &iop_chan->chain);
-		sw_desc->async_tx.ack = 1;
+		async_tx_ack(&sw_desc->async_tx);
 		iop_desc_init_memcpy(grp_start, 0);
 		iop_desc_set_byte_count(grp_start, iop_chan, 0);
 		iop_desc_set_dest_addr(grp_start, iop_chan, 0);
@@ -1354,7 +1346,7 @@ static void iop_chan_start_null_xor(struct iop_adma_chan *iop_chan)
 	if (sw_desc) {
 		grp_start = sw_desc->group_head;
 		list_splice_init(&sw_desc->async_tx.tx_list, &iop_chan->chain);
-		sw_desc->async_tx.ack = 1;
+		async_tx_ack(&sw_desc->async_tx);
 		iop_desc_init_null_xor(grp_start, 2, 0);
 		iop_desc_set_byte_count(grp_start, iop_chan, 0);
 		iop_desc_set_dest_addr(grp_start, iop_chan, 0);
diff --git a/include/asm-arm/arch-iop13xx/adma.h b/include/asm-arm/arch-iop13xx/adma.h
index efd9a5e..90d14ee 100644
--- a/include/asm-arm/arch-iop13xx/adma.h
+++ b/include/asm-arm/arch-iop13xx/adma.h
@@ -454,11 +454,6 @@ static inline void iop_chan_append(struct iop_adma_chan *chan)
 	__raw_writel(adma_accr, ADMA_ACCR(chan));
 }
 
-static inline void iop_chan_idle(int busy, struct iop_adma_chan *chan)
-{
-	do { } while (0);
-}
-
 static inline u32 iop_chan_get_status(struct iop_adma_chan *chan)
 {
 	return __raw_readl(ADMA_ACSR(chan));
diff --git a/include/asm-arm/hardware/iop3xx-adma.h b/include/asm-arm/hardware/iop3xx-adma.h
index 5c529e6..84d635b 100644
--- a/include/asm-arm/hardware/iop3xx-adma.h
+++ b/include/asm-arm/hardware/iop3xx-adma.h
@@ -767,20 +767,12 @@ static inline int iop_desc_get_zero_result(struct iop_adma_desc_slot *desc)
 static inline void iop_chan_append(struct iop_adma_chan *chan)
 {
 	u32 dma_chan_ctrl;
-	/* workaround dropped interrupts on 3xx */
-	mod_timer(&chan->cleanup_watchdog, jiffies + msecs_to_jiffies(3));
 
 	dma_chan_ctrl = __raw_readl(DMA_CCR(chan));
 	dma_chan_ctrl |= 0x2;
 	__raw_writel(dma_chan_ctrl, DMA_CCR(chan));
 }
 
-static inline void iop_chan_idle(int busy, struct iop_adma_chan *chan)
-{
-	if (!busy)
-		del_timer(&chan->cleanup_watchdog);
-}
-
 static inline u32 iop_chan_get_status(struct iop_adma_chan *chan)
 {
 	return __raw_readl(DMA_CSR(chan));
diff --git a/include/asm-arm/hardware/iop_adma.h b/include/asm-arm/hardware/iop_adma.h
index ca8e71f..cb7e361 100644
--- a/include/asm-arm/hardware/iop_adma.h
+++ b/include/asm-arm/hardware/iop_adma.h
@@ -51,7 +51,6 @@ struct iop_adma_device {
  * @common: common dmaengine channel object members
  * @last_used: place holder for allocation to continue from where it left off
  * @all_slots: complete domain of slots usable by the channel
- * @cleanup_watchdog: workaround missed interrupts on iop3xx
  * @slots_allocated: records the actual size of the descriptor slot pool
  * @irq_tasklet: bottom half where iop_adma_slot_cleanup runs
  */
@@ -65,7 +64,6 @@ struct iop_adma_chan {
 	struct dma_chan common;
 	struct iop_adma_desc_slot *last_used;
 	struct list_head all_slots;
-	struct timer_list cleanup_watchdog;
 	int slots_allocated;
 	struct tasklet_struct irq_tasklet;
 };
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 34d4406..b4d84ed 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -95,12 +95,17 @@ enum dma_transaction_type {
 #define DMA_TX_TYPE_END (DMA_INTERRUPT + 1)
 
 /**
- * enum dma_prep_flags - DMA flags to augment operation preparation
+ * enum dma_ctrl_flags - DMA flags to augment operation preparation,
+ * 	control completion, and communicate status.
  * @DMA_PREP_INTERRUPT - trigger an interrupt (callback) upon completion of
  * 	this transaction
+ * @DMA_CTRL_ACK - the descriptor cannot be reused until the client
+ * 	acknowledges receipt, i.e. has has a chance to establish any
+ * 	dependency chains
  */
-enum dma_prep_flags {
+enum dma_ctrl_flags {
 	DMA_PREP_INTERRUPT = (1 << 0),
+	DMA_CTRL_ACK = (1 << 1),
 };
 
 /**
@@ -211,8 +216,8 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
  * ---dma generic offload fields---
  * @cookie: tracking cookie for this transaction, set to -EBUSY if
  *	this tx is sitting on a dependency list
- * @ack: the descriptor can not be reused until the client acknowledges
- *	receipt, i.e. has has a chance to establish any dependency chains
+ * @flags: flags to augment operation preparation, control completion, and
+ * 	communicate status
  * @phys: physical address of the descriptor
  * @tx_list: driver common field for operations that require multiple
  *	descriptors
@@ -221,23 +226,20 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
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
-	int ack;
+	enum dma_ctrl_flags flags; /* not a 'long' to pack with cookie */
 	dma_addr_t phys;
 	struct list_head tx_list;
 	struct dma_chan *chan;
 	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
 	dma_async_tx_callback callback;
 	void *callback_param;
-	struct list_head depend_list;
-	struct list_head depend_node;
+	struct dma_async_tx_descriptor *next;
 	struct dma_async_tx_descriptor *parent;
 	spinlock_t lock;
 };
@@ -261,7 +263,6 @@ struct dma_async_tx_descriptor {
  * @device_prep_dma_zero_sum: prepares a zero_sum operation
  * @device_prep_dma_memset: prepares a memset operation
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
- * @device_dependency_added: async_tx notifies the channel about new deps
  * @device_issue_pending: push pending transactions to hardware
  */
 struct dma_device {
@@ -294,9 +295,8 @@ struct dma_device {
 		struct dma_chan *chan, dma_addr_t dest, int value, size_t len,
 		unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
-		struct dma_chan *chan);
+		struct dma_chan *chan, unsigned long flags);
 
-	void (*device_dependency_added)(struct dma_chan *chan);
 	enum dma_status (*device_is_tx_complete)(struct dma_chan *chan,
 			dma_cookie_t cookie, dma_cookie_t *last,
 			dma_cookie_t *used);
@@ -321,7 +321,13 @@ void dma_async_tx_descriptor_init(struct dma_async_tx_descriptor *tx,
 static inline void
 async_tx_ack(struct dma_async_tx_descriptor *tx)
 {
-	tx->ack = 1;
+	tx->flags |= DMA_CTRL_ACK;
+}
+
+static inline int
+async_tx_test_ack(struct dma_async_tx_descriptor *tx)
+{
+	return tx->flags & DMA_CTRL_ACK;
 }
 
 #define first_dma_cap(mask) __first_dma_cap(&(mask))


