Return-Path: <linux-kernel-owner+w=401wt.eu-S932616AbXKPW5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbXKPW5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 17:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757161AbXKPW5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 17:57:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:58454 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbXKPW5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 17:57:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,428,1188802800"; 
   d="scan'208";a="387841937"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH] I/OAT: fixups from code comments
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: shannon.nelson@intel.com
Date: Fri, 16 Nov 2007 22:56:54 -0800
Message-ID: <20071117065654.11127.70054.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A few fixups from Andrew's code comments.
  - removed "static inline" forward-declares
  - changed use of min() to min_t()
  - removed some unnecessary NULL initializations
  - removed a couple of BUG() calls


Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
---

 drivers/dma/ioat_dma.c |  142 ++++++++++++++++++++++++++----------------------
 drivers/dma/ioatdma.h  |    2 -
 2 files changed, 78 insertions(+), 66 deletions(-)

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index c1c2dcc..c17ec32 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -173,10 +173,47 @@ static void ioat_set_dest(dma_addr_t addr,
 	tx_to_ioat_desc(tx)->dst = addr;
 }
 
+/**
+ * ioat_dma_memcpy_issue_pending - push potentially unrecognized appended
+ *                                 descriptors to hw
+ * @chan: DMA channel handle
+ */
 static inline void __ioat1_dma_memcpy_issue_pending(
-					       struct ioat_dma_chan *ioat_chan);
+						struct ioat_dma_chan *ioat_chan)
+{
+	ioat_chan->pending = 0;
+	writeb(IOAT_CHANCMD_APPEND, ioat_chan->reg_base + IOAT1_CHANCMD_OFFSET);
+}
+
+static void ioat1_dma_memcpy_issue_pending(struct dma_chan *chan)
+{
+	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
+
+	if (ioat_chan->pending != 0) {
+		spin_lock_bh(&ioat_chan->desc_lock);
+		__ioat1_dma_memcpy_issue_pending(ioat_chan);
+		spin_unlock_bh(&ioat_chan->desc_lock);
+	}
+}
+
 static inline void __ioat2_dma_memcpy_issue_pending(
-					       struct ioat_dma_chan *ioat_chan);
+						struct ioat_dma_chan *ioat_chan)
+{
+	ioat_chan->pending = 0;
+	writew(ioat_chan->dmacount,
+	       ioat_chan->reg_base + IOAT_CHAN_DMACOUNT_OFFSET);
+}
+
+static void ioat2_dma_memcpy_issue_pending(struct dma_chan *chan)
+{
+	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
+
+	if (ioat_chan->pending != 0) {
+		spin_lock_bh(&ioat_chan->desc_lock);
+		__ioat2_dma_memcpy_issue_pending(ioat_chan);
+		spin_unlock_bh(&ioat_chan->desc_lock);
+	}
+}
 
 static dma_cookie_t ioat1_tx_submit(struct dma_async_tx_descriptor *tx)
 {
@@ -203,7 +240,7 @@ static dma_cookie_t ioat1_tx_submit(struct dma_async_tx_descriptor *tx)
 	prev = to_ioat_desc(ioat_chan->used_desc.prev);
 	prefetch(prev->hw);
 	do {
-		copy = min((u32) len, ioat_chan->xfercap);
+		copy = min_t(size_t, len, ioat_chan->xfercap);
 
 		new->async_tx.ack = 1;
 
@@ -291,10 +328,12 @@ static dma_cookie_t ioat2_tx_submit(struct dma_async_tx_descriptor *tx)
 	orig_ack = first->async_tx.ack;
 	new = first;
 
-	/* ioat_chan->desc_lock is still in force in version 2 path */
-
+	/*
+	 * ioat_chan->desc_lock is still in force in version 2 path
+	 * it gets unlocked at end of this function
+	 */
 	do {
-		copy = min((u32) len, ioat_chan->xfercap);
+		copy = min_t(size_t, len, ioat_chan->xfercap);
 
 		new->async_tx.ack = 1;
 
@@ -432,7 +471,7 @@ static void ioat2_dma_massage_chan_desc(struct ioat_dma_chan *ioat_chan)
 static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
-	struct ioat_desc_sw *desc = NULL;
+	struct ioat_desc_sw *desc;
 	u16 chanctrl;
 	u32 chanerr;
 	int i;
@@ -575,7 +614,7 @@ static void ioat_dma_free_chan_resources(struct dma_chan *chan)
 static struct ioat_desc_sw *
 ioat1_dma_get_next_descriptor(struct ioat_dma_chan *ioat_chan)
 {
-	struct ioat_desc_sw *new = NULL;
+	struct ioat_desc_sw *new;
 
 	if (!list_empty(&ioat_chan->free_desc)) {
 		new = to_ioat_desc(ioat_chan->free_desc.next);
@@ -583,9 +622,11 @@ ioat1_dma_get_next_descriptor(struct ioat_dma_chan *ioat_chan)
 	} else {
 		/* try to get another desc */
 		new = ioat_dma_alloc_descriptor(ioat_chan, GFP_ATOMIC);
-		/* will this ever happen? */
-		/* TODO add upper limit on these */
-		BUG_ON(!new);
+		if (!new) {
+			dev_err(&ioat_chan->device->pdev->dev,
+				"alloc failed\n");
+			return NULL;
+		}
 	}
 
 	prefetch(new->hw);
@@ -595,7 +636,7 @@ ioat1_dma_get_next_descriptor(struct ioat_dma_chan *ioat_chan)
 static struct ioat_desc_sw *
 ioat2_dma_get_next_descriptor(struct ioat_dma_chan *ioat_chan)
 {
-	struct ioat_desc_sw *new = NULL;
+	struct ioat_desc_sw *new;
 
 	/*
 	 * used.prev points to where to start processing
@@ -609,8 +650,8 @@ ioat2_dma_get_next_descriptor(struct ioat_dma_chan *ioat_chan)
 	if (ioat_chan->used_desc.prev &&
 	    ioat_chan->used_desc.next == ioat_chan->used_desc.prev->prev) {
 
-		struct ioat_desc_sw *desc = NULL;
-		struct ioat_desc_sw *noop_desc = NULL;
+		struct ioat_desc_sw *desc;
+		struct ioat_desc_sw *noop_desc;
 		int i;
 
 		/* set up the noop descriptor */
@@ -624,10 +665,14 @@ ioat2_dma_get_next_descriptor(struct ioat_dma_chan *ioat_chan)
 		ioat_chan->pending++;
 		ioat_chan->dmacount++;
 
-		/* get a few more descriptors */
+		/* try to get a few more descriptors */
 		for (i = 16; i; i--) {
 			desc = ioat_dma_alloc_descriptor(ioat_chan, GFP_ATOMIC);
-			BUG_ON(!desc);
+			if (!desc) {
+				dev_err(&ioat_chan->device->pdev->dev,
+					"alloc failed\n");
+				break;
+			}
 			list_add_tail(&desc->node, ioat_chan->used_desc.next);
 
 			desc->hw->next
@@ -677,10 +722,13 @@ static struct dma_async_tx_descriptor *ioat1_dma_prep_memcpy(
 
 	spin_lock_bh(&ioat_chan->desc_lock);
 	new = ioat_dma_get_next_descriptor(ioat_chan);
-	new->len = len;
 	spin_unlock_bh(&ioat_chan->desc_lock);
 
-	return new ? &new->async_tx : NULL;
+	if (new) {
+		new->len = len;
+		return &new->async_tx;
+	} else
+		return NULL;
 }
 
 static struct dma_async_tx_descriptor *ioat2_dma_prep_memcpy(
@@ -693,53 +741,17 @@ static struct dma_async_tx_descriptor *ioat2_dma_prep_memcpy(
 
 	spin_lock_bh(&ioat_chan->desc_lock);
 	new = ioat2_dma_get_next_descriptor(ioat_chan);
-	new->len = len;
-
-	/* leave ioat_chan->desc_lock set in version 2 path */
-	return new ? &new->async_tx : NULL;
-}
-
-
-/**
- * ioat_dma_memcpy_issue_pending - push potentially unrecognized appended
- *                                 descriptors to hw
- * @chan: DMA channel handle
- */
-static inline void __ioat1_dma_memcpy_issue_pending(
-						struct ioat_dma_chan *ioat_chan)
-{
-	ioat_chan->pending = 0;
-	writeb(IOAT_CHANCMD_APPEND, ioat_chan->reg_base + IOAT1_CHANCMD_OFFSET);
-}
-
-static void ioat1_dma_memcpy_issue_pending(struct dma_chan *chan)
-{
-	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
-
-	if (ioat_chan->pending != 0) {
-		spin_lock_bh(&ioat_chan->desc_lock);
-		__ioat1_dma_memcpy_issue_pending(ioat_chan);
-		spin_unlock_bh(&ioat_chan->desc_lock);
-	}
-}
-
-static inline void __ioat2_dma_memcpy_issue_pending(
-						struct ioat_dma_chan *ioat_chan)
-{
-	ioat_chan->pending = 0;
-	writew(ioat_chan->dmacount,
-	       ioat_chan->reg_base + IOAT_CHAN_DMACOUNT_OFFSET);
-}
 
-static void ioat2_dma_memcpy_issue_pending(struct dma_chan *chan)
-{
-	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
+	/*
+	 * leave ioat_chan->desc_lock set in ioat 2 path
+	 * it will get unlocked at end of tx_submit
+	 */
 
-	if (ioat_chan->pending != 0) {
-		spin_lock_bh(&ioat_chan->desc_lock);
-		__ioat2_dma_memcpy_issue_pending(ioat_chan);
-		spin_unlock_bh(&ioat_chan->desc_lock);
-	}
+	if (new) {
+		new->len = len;
+		return &new->async_tx;
+	} else
+		return NULL;
 }
 
 static void ioat_dma_cleanup_tasklet(unsigned long data)
@@ -1019,7 +1031,7 @@ static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan)
 static void ioat_dma_test_callback(void *dma_async_param)
 {
 	printk(KERN_ERR "ioatdma: ioat_dma_test_callback(%p)\n",
-			dma_async_param);
+		dma_async_param);
 }
 
 /**
@@ -1032,7 +1044,7 @@ static int ioat_dma_self_test(struct ioatdma_device *device)
 	u8 *src;
 	u8 *dest;
 	struct dma_chan *dma_chan;
-	struct dma_async_tx_descriptor *tx = NULL;
+	struct dma_async_tx_descriptor *tx;
 	dma_addr_t addr;
 	dma_cookie_t cookie;
 	int err = 0;
diff --git a/drivers/dma/ioatdma.h b/drivers/dma/ioatdma.h
index b668234..f2c7fed 100644
--- a/drivers/dma/ioatdma.h
+++ b/drivers/dma/ioatdma.h
@@ -76,7 +76,7 @@ struct ioat_dma_chan {
 	dma_cookie_t completed_cookie;
 	unsigned long last_completion;
 
-	u32 xfercap;	/* XFERCAP register value expanded out */
+	size_t xfercap;	/* XFERCAP register value expanded out */
 
 	spinlock_t cleanup_lock;
 	spinlock_t desc_lock;
