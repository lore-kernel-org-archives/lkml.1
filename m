Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbYCMSzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbYCMSzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 14:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbYCMSzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 14:55:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:3043 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbYCMSzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 14:55:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,495,1199692800"; 
   d="scan'208";a="218278080"
Subject: [git pull] async_tx/dmaengine fixes for 2.6.25-rc
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>, wei.zhang@freescale.com,
       Kumar Gala <galak@kernel.crashing.org>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 11:55:03 -0700
Message-Id: <1205434503.3114.11.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-8.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

to receive:

Dan Williams (1):
      async_tx: checkpatch says s/__FUNCTION__/__func__/g

Harvey Harrison (1):
      iop-adma.c: replace remaining __FUNCTION__ occurrences

Zhang Wei (4):
      fsldma: Fix fsldma.c warning messages when it's compiled under PPC64.
      dmaengine: Fix a bug about BUG_ON() on DMA engine capability DMA_INTERRUPT.
      fsldma: Add device_prep_dma_interrupt support to fsldma.c
      fsldma: Add a completed cookie updated action in DMA finish interrupt.

 crypto/async_tx/async_memcpy.c |    6 ++--
 crypto/async_tx/async_memset.c |    6 ++--
 crypto/async_tx/async_tx.c     |    6 ++--
 crypto/async_tx/async_xor.c    |   12 ++++----
 drivers/dma/dmaengine.c        |    2 +-
 drivers/dma/fsldma.c           |   58 ++++++++++++++++++++++++++++++---------
 drivers/dma/iop-adma.c         |   32 +++++++++++-----------
 7 files changed, 76 insertions(+), 46 deletions(-)

This addresses a few issues with the recently merged fsldma driver,
fixes a buglet in dmaengine, and the rest are simple cleanups.

Regards,
Dan

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 0f62822..84caa4e 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -66,11 +66,11 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 	}
 
 	if (tx) {
-		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
+		pr_debug("%s: (async) len: %zu\n", __func__, len);
 		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
 	} else {
 		void *dest_buf, *src_buf;
-		pr_debug("%s: (sync) len: %zu\n", __FUNCTION__, len);
+		pr_debug("%s: (sync) len: %zu\n", __func__, len);
 
 		/* wait for any prerequisite operations */
 		if (depend_tx) {
@@ -80,7 +80,7 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 			BUG_ON(depend_tx->ack);
 			if (dma_wait_for_async_tx(depend_tx) == DMA_ERROR)
 				panic("%s: DMA_ERROR waiting for depend_tx\n",
-					__FUNCTION__);
+					__func__);
 		}
 
 		dest_buf = kmap_atomic(dest, KM_USER0) + dest_offset;
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index 09c0e83..f5ff390 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -63,11 +63,11 @@ async_memset(struct page *dest, int val, unsigned int offset,
 	}
 
 	if (tx) {
-		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
+		pr_debug("%s: (async) len: %zu\n", __func__, len);
 		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
 	} else { /* run the memset synchronously */
 		void *dest_buf;
-		pr_debug("%s: (sync) len: %zu\n", __FUNCTION__, len);
+		pr_debug("%s: (sync) len: %zu\n", __func__, len);
 
 		dest_buf = (void *) (((char *) page_address(dest)) + offset);
 
@@ -79,7 +79,7 @@ async_memset(struct page *dest, int val, unsigned int offset,
 			BUG_ON(depend_tx->ack);
 			if (dma_wait_for_async_tx(depend_tx) == DMA_ERROR)
 				panic("%s: DMA_ERROR waiting for depend_tx\n",
-					__FUNCTION__);
+					__func__);
 		}
 
 		memset(dest_buf, val, len);
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 5628821..2be3bae 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -472,11 +472,11 @@ async_trigger_callback(enum async_tx_flags flags,
 		tx = NULL;
 
 	if (tx) {
-		pr_debug("%s: (async)\n", __FUNCTION__);
+		pr_debug("%s: (async)\n", __func__);
 
 		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
 	} else {
-		pr_debug("%s: (sync)\n", __FUNCTION__);
+		pr_debug("%s: (sync)\n", __func__);
 
 		/* wait for any prerequisite operations */
 		if (depend_tx) {
@@ -486,7 +486,7 @@ async_trigger_callback(enum async_tx_flags flags,
 			BUG_ON(depend_tx->ack);
 			if (dma_wait_for_async_tx(depend_tx) == DMA_ERROR)
 				panic("%s: DMA_ERROR waiting for depend_tx\n",
-					__FUNCTION__);
+					__func__);
 		}
 
 		async_tx_sync_epilog(flags, depend_tx, cb_fn, cb_param);
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 2259a4f..7a9db35 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -47,7 +47,7 @@ do_async_xor(struct dma_device *device,
 	int i;
 	unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
 
-	pr_debug("%s: len: %zu\n", __FUNCTION__, len);
+	pr_debug("%s: len: %zu\n", __func__, len);
 
 	dma_dest = dma_map_page(device->dev, dest, offset, len,
 				DMA_FROM_DEVICE);
@@ -86,7 +86,7 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	void *_dest;
 	int i;
 
-	pr_debug("%s: len: %zu\n", __FUNCTION__, len);
+	pr_debug("%s: len: %zu\n", __func__, len);
 
 	/* reuse the 'src_list' array to convert to buffer pointers */
 	for (i = 0; i < src_cnt; i++)
@@ -196,7 +196,7 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 					DMA_ERROR)
 					panic("%s: DMA_ERROR waiting for "
 						"depend_tx\n",
-						__FUNCTION__);
+						__func__);
 			}
 
 			do_sync_xor(dest, &src_list[src_off], offset,
@@ -276,7 +276,7 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 		unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
 		int i;
 
-		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
+		pr_debug("%s: (async) len: %zu\n", __func__, len);
 
 		for (i = 0; i < src_cnt; i++)
 			dma_src[i] = dma_map_page(device->dev, src_list[i],
@@ -299,7 +299,7 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 	} else {
 		unsigned long xor_flags = flags;
 
-		pr_debug("%s: (sync) len: %zu\n", __FUNCTION__, len);
+		pr_debug("%s: (sync) len: %zu\n", __func__, len);
 
 		xor_flags |= ASYNC_TX_XOR_DROP_DST;
 		xor_flags &= ~ASYNC_TX_ACK;
@@ -310,7 +310,7 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 		if (tx) {
 			if (dma_wait_for_async_tx(tx) == DMA_ERROR)
 				panic("%s: DMA_ERROR waiting for tx\n",
-					__FUNCTION__);
+					__func__);
 			async_tx_ack(tx);
 		}
 
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 2996523..8db0e7f 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -357,7 +357,7 @@ int dma_async_device_register(struct dma_device *device)
 		!device->device_prep_dma_zero_sum);
 	BUG_ON(dma_has_cap(DMA_MEMSET, device->cap_mask) &&
 		!device->device_prep_dma_memset);
-	BUG_ON(dma_has_cap(DMA_ZERO_SUM, device->cap_mask) &&
+	BUG_ON(dma_has_cap(DMA_INTERRUPT, device->cap_mask) &&
 		!device->device_prep_dma_interrupt);
 
 	BUG_ON(!device->device_alloc_chan_resources);
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index cc9a681..ad2f938 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -57,12 +57,12 @@ static void dma_init(struct fsl_dma_chan *fsl_chan)
 
 }
 
-static void set_sr(struct fsl_dma_chan *fsl_chan, dma_addr_t val)
+static void set_sr(struct fsl_dma_chan *fsl_chan, u32 val)
 {
 	DMA_OUT(fsl_chan, &fsl_chan->reg_base->sr, val, 32);
 }
 
-static dma_addr_t get_sr(struct fsl_dma_chan *fsl_chan)
+static u32 get_sr(struct fsl_dma_chan *fsl_chan)
 {
 	return DMA_IN(fsl_chan, &fsl_chan->reg_base->sr, 32);
 }
@@ -406,6 +406,32 @@ static void fsl_dma_free_chan_resources(struct dma_chan *chan)
 	dma_pool_destroy(fsl_chan->desc_pool);
 }
 
+static struct dma_async_tx_descriptor *
+fsl_dma_prep_interrupt(struct dma_chan *chan)
+{
+	struct fsl_dma_chan *fsl_chan;
+	struct fsl_desc_sw *new;
+
+	if (!chan)
+		return NULL;
+
+	fsl_chan = to_fsl_chan(chan);
+
+	new = fsl_dma_alloc_descriptor(fsl_chan);
+	if (!new) {
+		dev_err(fsl_chan->dev, "No free memory for link descriptor\n");
+		return NULL;
+	}
+
+	new->async_tx.cookie = -EBUSY;
+	new->async_tx.ack = 0;
+
+	/* Set End-of-link to the last link descriptor of new list*/
+	set_ld_eol(fsl_chan, new);
+
+	return &new->async_tx;
+}
+
 static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 	struct dma_chan *chan, dma_addr_t dma_dest, dma_addr_t dma_src,
 	size_t len, unsigned long flags)
@@ -436,7 +462,7 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 		dev_dbg(fsl_chan->dev, "new link desc alloc %p\n", new);
 #endif
 
-		copy = min(len, FSL_DMA_BCR_MAX_CNT);
+		copy = min(len, (size_t)FSL_DMA_BCR_MAX_CNT);
 
 		set_desc_cnt(fsl_chan, &new->hw, copy);
 		set_desc_src(fsl_chan, &new->hw, dma_src);
@@ -513,7 +539,6 @@ static void fsl_chan_ld_cleanup(struct fsl_dma_chan *fsl_chan)
 
 	spin_lock_irqsave(&fsl_chan->desc_lock, flags);
 
-	fsl_dma_update_completed_cookie(fsl_chan);
 	dev_dbg(fsl_chan->dev, "chan completed_cookie = %d\n",
 			fsl_chan->completed_cookie);
 	list_for_each_entry_safe(desc, _desc, &fsl_chan->ld_queue, node) {
@@ -581,8 +606,8 @@ static void fsl_chan_xfer_ld_queue(struct fsl_dma_chan *fsl_chan)
 	if (ld_node != &fsl_chan->ld_queue) {
 		/* Get the ld start address from ld_queue */
 		next_dest_addr = to_fsl_desc(ld_node)->async_tx.phys;
-		dev_dbg(fsl_chan->dev, "xfer LDs staring from 0x%016llx\n",
-				(u64)next_dest_addr);
+		dev_dbg(fsl_chan->dev, "xfer LDs staring from %p\n",
+				(void *)next_dest_addr);
 		set_cdar(fsl_chan, next_dest_addr);
 		dma_start(fsl_chan);
 	} else {
@@ -662,7 +687,7 @@ static enum dma_status fsl_dma_is_complete(struct dma_chan *chan,
 static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
 {
 	struct fsl_dma_chan *fsl_chan = (struct fsl_dma_chan *)data;
-	dma_addr_t stat;
+	u32 stat;
 
 	stat = get_sr(fsl_chan);
 	dev_dbg(fsl_chan->dev, "event: channel %d, stat = 0x%x\n",
@@ -681,10 +706,10 @@ static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
 	 */
 	if (stat & FSL_DMA_SR_EOSI) {
 		dev_dbg(fsl_chan->dev, "event: End-of-segments INT\n");
-		dev_dbg(fsl_chan->dev, "event: clndar 0x%016llx, "
-				"nlndar 0x%016llx\n", (u64)get_cdar(fsl_chan),
-				(u64)get_ndar(fsl_chan));
+		dev_dbg(fsl_chan->dev, "event: clndar %p, nlndar %p\n",
+			(void *)get_cdar(fsl_chan), (void *)get_ndar(fsl_chan));
 		stat &= ~FSL_DMA_SR_EOSI;
+		fsl_dma_update_completed_cookie(fsl_chan);
 	}
 
 	/* If it current transfer is the end-of-transfer,
@@ -726,12 +751,15 @@ static void dma_do_tasklet(unsigned long data)
 	fsl_chan_ld_cleanup(fsl_chan);
 }
 
+#ifdef FSL_DMA_CALLBACKTEST
 static void fsl_dma_callback_test(struct fsl_dma_chan *fsl_chan)
 {
 	if (fsl_chan)
 		dev_info(fsl_chan->dev, "selftest: callback is ok!\n");
 }
+#endif
 
+#ifdef CONFIG_FSL_DMA_SELFTEST
 static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 {
 	struct dma_chan *chan;
@@ -837,9 +865,9 @@ static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 	if (err) {
 		for (i = 0; (*(src + i) == *(dest + i)) && (i < test_size);
 				i++);
-		dev_err(fsl_chan->dev, "selftest: Test failed, data %d/%d is "
+		dev_err(fsl_chan->dev, "selftest: Test failed, data %d/%ld is "
 				"error! src 0x%x, dest 0x%x\n",
-				i, test_size, *(src + i), *(dest + i));
+				i, (long)test_size, *(src + i), *(dest + i));
 	}
 
 free_resources:
@@ -848,6 +876,7 @@ out:
 	kfree(src);
 	return err;
 }
+#endif
 
 static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
 			const struct of_device_id *match)
@@ -1008,8 +1037,8 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
 	}
 
 	dev_info(&dev->dev, "Probe the Freescale DMA driver for %s "
-			"controller at 0x%08x...\n",
-			match->compatible, fdev->reg.start);
+			"controller at %p...\n",
+			match->compatible, (void *)fdev->reg.start);
 	fdev->reg_base = ioremap(fdev->reg.start, fdev->reg.end
 						- fdev->reg.start + 1);
 
@@ -1017,6 +1046,7 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
 	dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
 	fdev->common.device_alloc_chan_resources = fsl_dma_alloc_chan_resources;
 	fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;
+	fdev->common.device_prep_dma_interrupt = fsl_dma_prep_interrupt;
 	fdev->common.device_prep_dma_memcpy = fsl_dma_prep_memcpy;
 	fdev->common.device_is_tx_complete = fsl_dma_is_complete;
 	fdev->common.device_issue_pending = fsl_dma_memcpy_issue_pending;
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 3986d54..f82b090 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -140,7 +140,7 @@ static void __iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
 	int busy = iop_chan_is_busy(iop_chan);
 	int seen_current = 0, slot_cnt = 0, slots_per_op = 0;
 
-	dev_dbg(iop_chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(iop_chan->device->common.dev, "%s\n", __func__);
 	/* free completed slots from the chain starting with
 	 * the oldest descriptor
 	 */
@@ -438,7 +438,7 @@ iop_adma_tx_submit(struct dma_async_tx_descriptor *tx)
 	spin_unlock_bh(&iop_chan->lock);
 
 	dev_dbg(iop_chan->device->common.dev, "%s cookie: %d slot: %d\n",
-		__FUNCTION__, sw_desc->async_tx.cookie, sw_desc->idx);
+		__func__, sw_desc->async_tx.cookie, sw_desc->idx);
 
 	return cookie;
 }
@@ -520,7 +520,7 @@ iop_adma_prep_dma_interrupt(struct dma_chan *chan)
 	struct iop_adma_desc_slot *sw_desc, *grp_start;
 	int slot_cnt, slots_per_op;
 
-	dev_dbg(iop_chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(iop_chan->device->common.dev, "%s\n", __func__);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_interrupt_slot_count(&slots_per_op, iop_chan);
@@ -548,7 +548,7 @@ iop_adma_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dma_dest,
 	BUG_ON(unlikely(len > IOP_ADMA_MAX_BYTE_COUNT));
 
 	dev_dbg(iop_chan->device->common.dev, "%s len: %u\n",
-		__FUNCTION__, len);
+		__func__, len);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_memcpy_slot_count(len, &slots_per_op);
@@ -580,7 +580,7 @@ iop_adma_prep_dma_memset(struct dma_chan *chan, dma_addr_t dma_dest,
 	BUG_ON(unlikely(len > IOP_ADMA_MAX_BYTE_COUNT));
 
 	dev_dbg(iop_chan->device->common.dev, "%s len: %u\n",
-		__FUNCTION__, len);
+		__func__, len);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_memset_slot_count(len, &slots_per_op);
@@ -614,7 +614,7 @@ iop_adma_prep_dma_xor(struct dma_chan *chan, dma_addr_t dma_dest,
 
 	dev_dbg(iop_chan->device->common.dev,
 		"%s src_cnt: %d len: %u flags: %lx\n",
-		__FUNCTION__, src_cnt, len, flags);
+		__func__, src_cnt, len, flags);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_xor_slot_count(len, src_cnt, &slots_per_op);
@@ -648,7 +648,7 @@ iop_adma_prep_dma_zero_sum(struct dma_chan *chan, dma_addr_t *dma_src,
 		return NULL;
 
 	dev_dbg(iop_chan->device->common.dev, "%s src_cnt: %d len: %u\n",
-		__FUNCTION__, src_cnt, len);
+		__func__, src_cnt, len);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_zero_sum_slot_count(len, src_cnt, &slots_per_op);
@@ -659,7 +659,7 @@ iop_adma_prep_dma_zero_sum(struct dma_chan *chan, dma_addr_t *dma_src,
 		iop_desc_set_zero_sum_byte_count(grp_start, len);
 		grp_start->xor_check_result = result;
 		pr_debug("\t%s: grp_start->xor_check_result: %p\n",
-			__FUNCTION__, grp_start->xor_check_result);
+			__func__, grp_start->xor_check_result);
 		sw_desc->unmap_src_cnt = src_cnt;
 		sw_desc->unmap_len = len;
 		while (src_cnt--)
@@ -700,7 +700,7 @@ static void iop_adma_free_chan_resources(struct dma_chan *chan)
 	iop_chan->last_used = NULL;
 
 	dev_dbg(iop_chan->device->common.dev, "%s slots_allocated %d\n",
-		__FUNCTION__, iop_chan->slots_allocated);
+		__func__, iop_chan->slots_allocated);
 	spin_unlock_bh(&iop_chan->lock);
 
 	/* one is ok since we left it on there on purpose */
@@ -753,7 +753,7 @@ static irqreturn_t iop_adma_eot_handler(int irq, void *data)
 {
 	struct iop_adma_chan *chan = data;
 
-	dev_dbg(chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(chan->device->common.dev, "%s\n", __func__);
 
 	tasklet_schedule(&chan->irq_tasklet);
 
@@ -766,7 +766,7 @@ static irqreturn_t iop_adma_eoc_handler(int irq, void *data)
 {
 	struct iop_adma_chan *chan = data;
 
-	dev_dbg(chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(chan->device->common.dev, "%s\n", __func__);
 
 	tasklet_schedule(&chan->irq_tasklet);
 
@@ -823,7 +823,7 @@ static int __devinit iop_adma_memcpy_self_test(struct iop_adma_device *device)
 	int err = 0;
 	struct iop_adma_chan *iop_chan;
 
-	dev_dbg(device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(device->common.dev, "%s\n", __func__);
 
 	src = kzalloc(sizeof(u8) * IOP_ADMA_TEST_SIZE, GFP_KERNEL);
 	if (!src)
@@ -906,7 +906,7 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 	int err = 0;
 	struct iop_adma_chan *iop_chan;
 
-	dev_dbg(device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(device->common.dev, "%s\n", __func__);
 
 	for (src_idx = 0; src_idx < IOP_ADMA_NUM_SRC_TEST; src_idx++) {
 		xor_srcs[src_idx] = alloc_page(GFP_KERNEL);
@@ -1159,7 +1159,7 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 	}
 
 	dev_dbg(&pdev->dev, "%s: allocted descriptor pool virt %p phys %p\n",
-		__FUNCTION__, adev->dma_desc_pool_virt,
+		__func__, adev->dma_desc_pool_virt,
 		(void *) adev->dma_desc_pool);
 
 	adev->id = plat_data->hw_id;
@@ -1289,7 +1289,7 @@ static void iop_chan_start_null_memcpy(struct iop_adma_chan *iop_chan)
 	dma_cookie_t cookie;
 	int slot_cnt, slots_per_op;
 
-	dev_dbg(iop_chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(iop_chan->device->common.dev, "%s\n", __func__);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_memcpy_slot_count(0, &slots_per_op);
@@ -1346,7 +1346,7 @@ static void iop_chan_start_null_xor(struct iop_adma_chan *iop_chan)
 	dma_cookie_t cookie;
 	int slot_cnt, slots_per_op;
 
-	dev_dbg(iop_chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(iop_chan->device->common.dev, "%s\n", __func__);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_xor_slot_count(0, 2, &slots_per_op);


