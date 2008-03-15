Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbYCOBcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbYCOBcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 21:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYCOBcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 21:32:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:27856 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbYCOBcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 21:32:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,504,1199692800"; 
   d="scan'208";a="534239502"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] dmaengine: ack to flags: make use of the unused bits in the
	'ack' field
To: linux-kernel@vger.kernel.org
Cc: maciej.sosnowski@intel.com, hskinnemoen@atmel.com, olof@lixom.net
Date: Fri, 14 Mar 2008 18:31:30 -0700
Message-ID: <20080315012910.18721.68743.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'ack' is currently a simple integer that flags whether or not a client is done
touching fields in the given descriptor.  It is effectively just a single bit
of information.  Converting this to a flags parameter allows the other bits to
be put to use to control completion actions, like dma-unmap, and capture
results, like xor-zero-sum == 0.

Changes are one of:
1/ convert all open-coded ->ack manipulations to use async_tx_ack
   and async_tx_test_ack.
2/ set the ack bit at prep time where possible
3/ make drivers store the flags at prep time
4/ add flags to the device_prep_dma_interrupt prototype

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Next step is to take advantage of these bits to let clients pass hints
to a dma-driver cleanup routine.  How and when to unmap is the first
candidate.

Compile tested this for x86_64, PPC32, and ARM.

 crypto/async_tx/async_memcpy.c |    2 +-
 crypto/async_tx/async_tx.c     |    9 +++++----
 crypto/async_tx/async_xor.c    |    2 +-
 drivers/dma/dmaengine.c        |   12 ++++++------
 drivers/dma/fsldma.c           |    8 ++++----
 drivers/dma/ioat_dma.c         |   24 ++++++++++++------------
 drivers/dma/iop-adma.c         |   39 +++++++++++++++++++++------------------
 include/linux/dmaengine.h      |   25 ++++++++++++++++++-------
 8 files changed, 68 insertions(+), 53 deletions(-)


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
index 6975616..c6e772f 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -446,7 +446,7 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 	 * otherwise poll for completion
 	 */
 	if (dma_has_cap(DMA_INTERRUPT, device->cap_mask))
-		intr_tx = device->device_prep_dma_interrupt(chan);
+		intr_tx = device->device_prep_dma_interrupt(chan, 0);
 	else
 		intr_tx = NULL;
 
@@ -515,7 +515,8 @@ async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
 		 * 2/ dependencies are 1:1 i.e. two transactions can
 		 * not depend on the same parent
 		 */
-		BUG_ON(depend_tx->ack || depend_tx->next || tx->parent);
+		BUG_ON(async_tx_test_ack(depend_tx) || depend_tx->next ||
+		       tx->parent);
 
 		/* the lock prevents async_tx_run_dependencies from missing
 		 * the setting of ->next when ->parent != NULL
@@ -594,7 +595,7 @@ async_trigger_callback(enum async_tx_flags flags,
 		if (device && !dma_has_cap(DMA_INTERRUPT, device->cap_mask))
 			device = NULL;
 
-		tx = device ? device->device_prep_dma_interrupt(chan) : NULL;
+		tx = device ? device->device_prep_dma_interrupt(chan, 0) : NULL;
 	} else
 		tx = NULL;
 
@@ -610,7 +611,7 @@ async_trigger_callback(enum async_tx_flags flags,
 			/* if ack is already set then we cannot be sure
 			 * we are referring to the correct operation
 			 */
-			BUG_ON(depend_tx->ack);
+			BUG_ON(async_tx_test_ack(depend_tx));
 			if (dma_wait_for_async_tx(depend_tx) == DMA_ERROR)
 				panic("%s: DMA_ERROR waiting for depend_tx\n",
 					__func__);
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 7a9db35..95e1b60 100644
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
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index af6911a..d6dc70f 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -478,7 +478,8 @@ dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
 
 	dma_src = dma_map_single(dev->dev, src, len, DMA_TO_DEVICE);
 	dma_dest = dma_map_single(dev->dev, dest, len, DMA_FROM_DEVICE);
-	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, 0);
+	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len,
+					 DMA_CTRL_ACK);
 
 	if (!tx) {
 		dma_unmap_single(dev->dev, dma_src, len, DMA_TO_DEVICE);
@@ -486,7 +487,6 @@ dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
 		return -ENOMEM;
 	}
 
-	tx->ack = 1;
 	tx->callback = NULL;
 	cookie = tx->tx_submit(tx);
 
@@ -524,7 +524,8 @@ dma_async_memcpy_buf_to_pg(struct dma_chan *chan, struct page *page,
 
 	dma_src = dma_map_single(dev->dev, kdata, len, DMA_TO_DEVICE);
 	dma_dest = dma_map_page(dev->dev, page, offset, len, DMA_FROM_DEVICE);
-	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, 0);
+	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len,
+					 DMA_CTRL_ACK);
 
 	if (!tx) {
 		dma_unmap_single(dev->dev, dma_src, len, DMA_TO_DEVICE);
@@ -532,7 +533,6 @@ dma_async_memcpy_buf_to_pg(struct dma_chan *chan, struct page *page,
 		return -ENOMEM;
 	}
 
-	tx->ack = 1;
 	tx->callback = NULL;
 	cookie = tx->tx_submit(tx);
 
@@ -573,7 +573,8 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
 	dma_src = dma_map_page(dev->dev, src_pg, src_off, len, DMA_TO_DEVICE);
 	dma_dest = dma_map_page(dev->dev, dest_pg, dest_off, len,
 				DMA_FROM_DEVICE);
-	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, 0);
+	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len,
+					 DMA_CTRL_ACK);
 
 	if (!tx) {
 		dma_unmap_page(dev->dev, dma_src, len, DMA_TO_DEVICE);
@@ -581,7 +582,6 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
 		return -ENOMEM;
 	}
 
-	tx->ack = 1;
 	tx->callback = NULL;
 	cookie = tx->tx_submit(tx);
 
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index ecc1728..4c9b46b 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -407,7 +407,7 @@ static void fsl_dma_free_chan_resources(struct dma_chan *chan)
 }
 
 static struct dma_async_tx_descriptor *
-fsl_dma_prep_interrupt(struct dma_chan *chan)
+fsl_dma_prep_interrupt(struct dma_chan *chan, unsigned long flags)
 {
 	struct fsl_dma_chan *fsl_chan;
 	struct fsl_desc_sw *new;
@@ -424,7 +424,7 @@ fsl_dma_prep_interrupt(struct dma_chan *chan)
 	}
 
 	new->async_tx.cookie = -EBUSY;
-	new->async_tx.ack = 0;
+	new->async_tx.flags = flags;
 
 	/* Set End-of-link to the last link descriptor of new list*/
 	set_ld_eol(fsl_chan, new);
@@ -474,7 +474,7 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 			set_desc_next(fsl_chan, &prev->hw, new->async_tx.phys);
 
 		new->async_tx.cookie = 0;
-		new->async_tx.ack = 1;
+		async_tx_ack(&new->async_tx);
 
 		prev = new;
 		len -= copy;
@@ -485,7 +485,7 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 		list_add_tail(&new->node, &first->async_tx.tx_list);
 	} while (len);
 
-	new->async_tx.ack = 0; /* client is in control of this ack */
+	new->async_tx.flags = flags; /* client is in control of this ack */
 	new->async_tx.cookie = -EBUSY;
 
 	/* Set End-of-link to the last link descriptor of new list*/
diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 1517fe4..318e8a2 100644
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
@@ -979,7 +979,7 @@ static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan)
 	desc->hw->size = 0;
 	desc->hw->src_addr = 0;
 	desc->hw->dst_addr = 0;
-	desc->async_tx.ack = 1;
+	async_tx_ack(&desc->async_tx);
 	switch (ioat_chan->device->version) {
 	case IOAT_VER_1_2:
 		desc->hw->next = 0;
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 9325229..762b729 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -111,7 +111,7 @@ iop_adma_clean_slot(struct iop_adma_desc_slot *desc,
 	/* the client is allowed to attach dependent operations
 	 * until 'ack' is set
 	 */
-	if (!desc->async_tx.ack)
+	if (!async_tx_test_ack(&desc->async_tx))
 		return 0;
 
 	/* leave the last descriptor in the chain
@@ -148,7 +148,7 @@ static void __iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
 			"this_desc: %#x next_desc: %#x ack: %d\n",
 			iter->async_tx.cookie, iter->idx, busy,
 			iter->async_tx.phys, iop_desc_get_next_desc(iter),
-			iter->async_tx.ack);
+			async_tx_test_ack(&iter->async_tx));
 		prefetch(_iter);
 		prefetch(&_iter->async_tx);
 
@@ -338,9 +338,7 @@ retry:
 
 				/* pre-ack all but the last descriptor */
 				if (num_slots != slots_per_op)
-					iter->async_tx.ack = 1;
-				else
-					iter->async_tx.ack = 0;
+					async_tx_ack(&iter->async_tx);
 
 				list_add_tail(&iter->chain_node, &chain);
 				alloc_tail = iter;
@@ -513,7 +511,7 @@ static int iop_adma_alloc_chan_resources(struct dma_chan *chan)
 }
 
 static struct dma_async_tx_descriptor *
-iop_adma_prep_dma_interrupt(struct dma_chan *chan)
+iop_adma_prep_dma_interrupt(struct dma_chan *chan, unsigned long flags)
 {
 	struct iop_adma_chan *iop_chan = to_iop_adma_chan(chan);
 	struct iop_adma_desc_slot *sw_desc, *grp_start;
@@ -528,6 +526,7 @@ iop_adma_prep_dma_interrupt(struct dma_chan *chan)
 		grp_start = sw_desc->group_head;
 		iop_desc_init_interrupt(grp_start, iop_chan);
 		grp_start->unmap_len = 0;
+		sw_desc->async_tx.flags = flags;
 	}
 	spin_unlock_bh(&iop_chan->lock);
 
@@ -560,6 +559,7 @@ iop_adma_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dma_dest,
 		iop_desc_set_memcpy_src_addr(grp_start, dma_src);
 		sw_desc->unmap_src_cnt = 1;
 		sw_desc->unmap_len = len;
+		sw_desc->async_tx.flags = flags;
 	}
 	spin_unlock_bh(&iop_chan->lock);
 
@@ -592,6 +592,7 @@ iop_adma_prep_dma_memset(struct dma_chan *chan, dma_addr_t dma_dest,
 		iop_desc_set_dest_addr(grp_start, iop_chan, dma_dest);
 		sw_desc->unmap_src_cnt = 1;
 		sw_desc->unmap_len = len;
+		sw_desc->async_tx.flags = flags;
 	}
 	spin_unlock_bh(&iop_chan->lock);
 
@@ -625,6 +626,7 @@ iop_adma_prep_dma_xor(struct dma_chan *chan, dma_addr_t dma_dest,
 		iop_desc_set_dest_addr(grp_start, iop_chan, dma_dest);
 		sw_desc->unmap_src_cnt = src_cnt;
 		sw_desc->unmap_len = len;
+		sw_desc->async_tx.flags = flags;
 		while (src_cnt--)
 			iop_desc_set_xor_src_addr(grp_start, src_cnt,
 						  dma_src[src_cnt]);
@@ -661,6 +663,7 @@ iop_adma_prep_dma_zero_sum(struct dma_chan *chan, dma_addr_t *dma_src,
 			__func__, grp_start->xor_check_result);
 		sw_desc->unmap_src_cnt = src_cnt;
 		sw_desc->unmap_len = len;
+		sw_desc->async_tx.flags = flags;
 		while (src_cnt--)
 			iop_desc_set_zero_sum_src_addr(grp_start, src_cnt,
 						       dma_src[src_cnt]);
@@ -847,11 +850,11 @@ static int __devinit iop_adma_memcpy_self_test(struct iop_adma_device *device)
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
@@ -947,11 +950,11 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
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
@@ -994,11 +997,11 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
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
@@ -1018,11 +1021,11 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
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
@@ -1050,11 +1053,11 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
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
@@ -1287,7 +1290,7 @@ static void iop_chan_start_null_memcpy(struct iop_adma_chan *iop_chan)
 		grp_start = sw_desc->group_head;
 
 		list_splice_init(&sw_desc->async_tx.tx_list, &iop_chan->chain);
-		sw_desc->async_tx.ack = 1;
+		async_tx_ack(&sw_desc->async_tx);
 		iop_desc_init_memcpy(grp_start, 0);
 		iop_desc_set_byte_count(grp_start, iop_chan, 0);
 		iop_desc_set_dest_addr(grp_start, iop_chan, 0);
@@ -1343,7 +1346,7 @@ static void iop_chan_start_null_xor(struct iop_adma_chan *iop_chan)
 	if (sw_desc) {
 		grp_start = sw_desc->group_head;
 		list_splice_init(&sw_desc->async_tx.tx_list, &iop_chan->chain);
-		sw_desc->async_tx.ack = 1;
+		async_tx_ack(&sw_desc->async_tx);
 		iop_desc_init_null_xor(grp_start, 2, 0);
 		iop_desc_set_byte_count(grp_start, iop_chan, 0);
 		iop_desc_set_dest_addr(grp_start, iop_chan, 0);
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 4e413c7..11c9da1 100644
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
@@ -227,7 +232,7 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
  */
 struct dma_async_tx_descriptor {
 	dma_cookie_t cookie;
-	int ack;
+	enum dma_ctrl_flags flags; /* not a 'long' to pack with cookie */
 	dma_addr_t phys;
 	struct list_head tx_list;
 	struct dma_chan *chan;
@@ -290,7 +295,7 @@ struct dma_device {
 		struct dma_chan *chan, dma_addr_t dest, int value, size_t len,
 		unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
-		struct dma_chan *chan);
+		struct dma_chan *chan, unsigned long flags);
 
 	enum dma_status (*device_is_tx_complete)(struct dma_chan *chan,
 			dma_cookie_t cookie, dma_cookie_t *last,
@@ -316,7 +321,13 @@ void dma_async_tx_descriptor_init(struct dma_async_tx_descriptor *tx,
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

