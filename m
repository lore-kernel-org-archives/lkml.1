Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbYBFR4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbYBFR4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbYBFR4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:56:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:25404 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbYBFR4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:56:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,313,1199692800"; 
   d="scan'208";a="375935215"
Subject: [GIT PULL resend] async_tx update for 2.6.25
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Shannon Nelson <shannon.nelson@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 10:43:42 -0700
Message-Id: <1202319822.6116.8.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-7.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ last sent February 4th, full diff included ]

Linus, please pull from:

        git://lost.foo-projects.org/~dwillia2/git/iop async-tx-for-linus

to receive:

Dan Williams (5):
      async_tx: fix compile breakage, mark do_async_xor __always_inline
      async_tx: kill ASYNC_TX_ASSUME_COHERENT
      async_tx: kill tx_set_src and tx_set_dest methods
      async_tx: replace 'int_en' with operation preparation flags
      async_tx: allow architecture specific async_tx_find_channel implementations

Denis Cheng (2):
      async_tx: use LIST_HEAD instead of LIST_HEAD_INIT
      iop-adma: use LIST_HEAD instead of LIST_HEAD_INIT

 crypto/async_tx/async_memcpy.c         |   38 ++++-----
 crypto/async_tx/async_memset.c         |   28 +++---
 crypto/async_tx/async_tx.c             |    9 +-
 crypto/async_tx/async_xor.c            |  124 +++++++++++++++++-----------
 drivers/dma/Kconfig                    |    1 +
 drivers/dma/dmaengine.c                |   49 +++++++-----
 drivers/dma/ioat_dma.c                 |   43 ++++------
 drivers/dma/iop-adma.c                 |  138 ++++++++++++--------------------
 include/asm-arm/arch-iop13xx/adma.h    |   18 +++--
 include/asm-arm/hardware/iop3xx-adma.h |   30 ++++---
 include/linux/async_tx.h               |   13 ++-
 include/linux/dmaengine.h              |   29 ++++---
 12 files changed, 259 insertions(+), 261 deletions(-)

The series is a general cleanup to the async_tx-api for 2.6.25.  The
most significant change 'async_tx: kill tx_set_src and tx_set_dest
methods' removes the need to perform extra indirect calls when preparing
a descriptor.  However, in order to keep the same stack footprint,
async_xor now polls for engine resources rather than simply punting to
cpu-xor.

The code was sent out for review in December [1], and has received an
Acked-by from Shannon@Intel for the parts that touch ioat_dma.
Haavard@Atmel has supplied a Reviewed-by for the pieces he felt
comfortable judging the correctness.

Regards,
Dan

[1] http://lkml.org/lkml/2007/12/21/277

---
diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 047e533..0f62822 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -35,7 +35,7 @@
  * @src: src page
  * @offset: offset in pages to start transaction
  * @len: length in bytes
- * @flags: ASYNC_TX_ASSUME_COHERENT, ASYNC_TX_ACK, ASYNC_TX_DEP_ACK,
+ * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK,
  * @depend_tx: memcpy depends on the result of this transaction
  * @cb_fn: function to call when the memcpy completes
  * @cb_param: parameter to pass to the callback routine
@@ -46,33 +46,29 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_param)
 {
-	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_MEMCPY);
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_MEMCPY,
+						      &dest, 1, &src, 1, len);
 	struct dma_device *device = chan ? chan->device : NULL;
-	int int_en = cb_fn ? 1 : 0;
-	struct dma_async_tx_descriptor *tx = device ?
-		device->device_prep_dma_memcpy(chan, len,
-		int_en) : NULL;
+	struct dma_async_tx_descriptor *tx = NULL;
 
-	if (tx) { /* run the memcpy asynchronously */
-		dma_addr_t addr;
-		enum dma_data_direction dir;
+	if (device) {
+		dma_addr_t dma_dest, dma_src;
+		unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
 
-		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
-
-		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
-			DMA_NONE : DMA_FROM_DEVICE;
-
-		addr = dma_map_page(device->dev, dest, dest_offset, len, dir);
-		tx->tx_set_dest(addr, tx, 0);
+		dma_dest = dma_map_page(device->dev, dest, dest_offset, len,
+					DMA_FROM_DEVICE);
 
-		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
-			DMA_NONE : DMA_TO_DEVICE;
+		dma_src = dma_map_page(device->dev, src, src_offset, len,
+				       DMA_TO_DEVICE);
 
-		addr = dma_map_page(device->dev, src, src_offset, len, dir);
-		tx->tx_set_src(addr, tx, 0);
+		tx = device->device_prep_dma_memcpy(chan, dma_dest, dma_src,
+						    len, dma_prep_flags);
+	}
 
+	if (tx) {
+		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
 		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
-	} else { /* run the memcpy synchronously */
+	} else {
 		void *dest_buf, *src_buf;
 		pr_debug("%s: (sync) len: %zu\n", __FUNCTION__, len);
 
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index 66ef635..09c0e83 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -35,7 +35,7 @@
  * @val: fill value
  * @offset: offset in pages to start transaction
  * @len: length in bytes
- * @flags: ASYNC_TX_ASSUME_COHERENT, ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
  * @depend_tx: memset depends on the result of this transaction
  * @cb_fn: function to call when the memcpy completes
  * @cb_param: parameter to pass to the callback routine
@@ -46,24 +46,24 @@ async_memset(struct page *dest, int val, unsigned int offset,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_param)
 {
-	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_MEMSET);
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_MEMSET,
+						      &dest, 1, NULL, 0, len);
 	struct dma_device *device = chan ? chan->device : NULL;
-	int int_en = cb_fn ? 1 : 0;
-	struct dma_async_tx_descriptor *tx = device ?
-		device->device_prep_dma_memset(chan, val, len,
-			int_en) : NULL;
+	struct dma_async_tx_descriptor *tx = NULL;
 
-	if (tx) { /* run the memset asynchronously */
-		dma_addr_t dma_addr;
-		enum dma_data_direction dir;
+	if (device) {
+		dma_addr_t dma_dest;
+		unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
 
-		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
-		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
-			DMA_NONE : DMA_FROM_DEVICE;
+		dma_dest = dma_map_page(device->dev, dest, offset, len,
+					DMA_FROM_DEVICE);
 
-		dma_addr = dma_map_page(device->dev, dest, offset, len, dir);
-		tx->tx_set_dest(dma_addr, tx, 0);
+		tx = device->device_prep_dma_memset(chan, dma_dest, val, len,
+						    dma_prep_flags);
+	}
 
+	if (tx) {
+		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
 		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
 	} else { /* run the memset synchronously */
 		void *dest_buf;
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index bc18cbb..5628821 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -57,8 +57,7 @@ static struct chan_ref_percpu *channel_table[DMA_TX_TYPE_END];
  */
 static spinlock_t async_tx_lock;
 
-static struct list_head
-async_tx_master_list = LIST_HEAD_INIT(async_tx_master_list);
+static LIST_HEAD(async_tx_master_list);
 
 /* async_tx_issue_pending_all - start all transactions on all channels */
 void async_tx_issue_pending_all(void)
@@ -362,13 +361,13 @@ static void __exit async_tx_exit(void)
 }
 
 /**
- * async_tx_find_channel - find a channel to carry out the operation or let
+ * __async_tx_find_channel - find a channel to carry out the operation or let
  *	the transaction execute synchronously
  * @depend_tx: transaction dependency
  * @tx_type: transaction type
  */
 struct dma_chan *
-async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
+__async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
 	enum dma_transaction_type tx_type)
 {
 	/* see if we can keep the chain on one channel */
@@ -384,7 +383,7 @@ async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
 	} else
 		return NULL;
 }
-EXPORT_SYMBOL_GPL(async_tx_find_channel);
+EXPORT_SYMBOL_GPL(__async_tx_find_channel);
 #else
 static int __init async_tx_init(void)
 {
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 2575f67..2259a4f 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -30,35 +30,51 @@
 #include <linux/raid/xor.h>
 #include <linux/async_tx.h>
 
-static void
-do_async_xor(struct dma_async_tx_descriptor *tx, struct dma_device *device,
+/* do_async_xor - dma map the pages and perform the xor with an engine.
+ * 	This routine is marked __always_inline so it can be compiled away
+ * 	when CONFIG_DMA_ENGINE=n
+ */
+static __always_inline struct dma_async_tx_descriptor *
+do_async_xor(struct dma_device *device,
 	struct dma_chan *chan, struct page *dest, struct page **src_list,
 	unsigned int offset, unsigned int src_cnt, size_t len,
 	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_param)
 {
-	dma_addr_t dma_addr;
-	enum dma_data_direction dir;
+	dma_addr_t dma_dest;
+	dma_addr_t *dma_src = (dma_addr_t *) src_list;
+	struct dma_async_tx_descriptor *tx;
 	int i;
+	unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
 
 	pr_debug("%s: len: %zu\n", __FUNCTION__, len);
 
-	dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
-		DMA_NONE : DMA_FROM_DEVICE;
-
-	dma_addr = dma_map_page(device->dev, dest, offset, len, dir);
-	tx->tx_set_dest(dma_addr, tx, 0);
-
-	dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
-		DMA_NONE : DMA_TO_DEVICE;
+	dma_dest = dma_map_page(device->dev, dest, offset, len,
+				DMA_FROM_DEVICE);
 
-	for (i = 0; i < src_cnt; i++) {
-		dma_addr = dma_map_page(device->dev, src_list[i],
-			offset, len, dir);
-		tx->tx_set_src(dma_addr, tx, i);
+	for (i = 0; i < src_cnt; i++)
+		dma_src[i] = dma_map_page(device->dev, src_list[i], offset,
+					  len, DMA_TO_DEVICE);
+
+	/* Since we have clobbered the src_list we are committed
+	 * to doing this asynchronously.  Drivers force forward progress
+	 * in case they can not provide a descriptor
+	 */
+	tx = device->device_prep_dma_xor(chan, dma_dest, dma_src, src_cnt, len,
+					 dma_prep_flags);
+	if (!tx) {
+		if (depend_tx)
+			dma_wait_for_async_tx(depend_tx);
+
+		while (!tx)
+			tx = device->device_prep_dma_xor(chan, dma_dest,
+							 dma_src, src_cnt, len,
+							 dma_prep_flags);
 	}
 
 	async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
+
+	return tx;
 }
 
 static void
@@ -102,7 +118,7 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
  * @src_cnt: number of source pages
  * @len: length in bytes
  * @flags: ASYNC_TX_XOR_ZERO_DST, ASYNC_TX_XOR_DROP_DEST,
- *	ASYNC_TX_ASSUME_COHERENT, ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ *	ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
  * @depend_tx: xor depends on the result of this transaction.
  * @cb_fn: function to call when the xor completes
  * @cb_param: parameter to pass to the callback routine
@@ -113,14 +129,16 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_param)
 {
-	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_XOR);
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_XOR,
+						      &dest, 1, src_list,
+						      src_cnt, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 	dma_async_tx_callback _cb_fn;
 	void *_cb_param;
 	unsigned long local_flags;
 	int xor_src_cnt;
-	int i = 0, src_off = 0, int_en;
+	int i = 0, src_off = 0;
 
 	BUG_ON(src_cnt <= 1);
 
@@ -140,20 +158,11 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 				_cb_param = cb_param;
 			}
 
-			int_en = _cb_fn ? 1 : 0;
-
-			tx = device->device_prep_dma_xor(
-				chan, xor_src_cnt, len, int_en);
-
-			if (tx) {
-				do_async_xor(tx, device, chan, dest,
-				&src_list[src_off], offset, xor_src_cnt, len,
-				local_flags, depend_tx, _cb_fn,
-				_cb_param);
-			} else /* fall through */
-				goto xor_sync;
+			tx = do_async_xor(device, chan, dest,
+					  &src_list[src_off], offset,
+					  xor_src_cnt, len, local_flags,
+					  depend_tx, _cb_fn, _cb_param);
 		} else { /* run the xor synchronously */
-xor_sync:
 			/* in the sync case the dest is an implied source
 			 * (assumes the dest is at the src_off index)
 			 */
@@ -242,7 +251,7 @@ static int page_is_zero(struct page *p, unsigned int offset, size_t len)
  * @src_cnt: number of source pages
  * @len: length in bytes
  * @result: 0 if sum == 0 else non-zero
- * @flags: ASYNC_TX_ASSUME_COHERENT, ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
  * @depend_tx: xor depends on the result of this transaction.
  * @cb_fn: function to call when the xor completes
  * @cb_param: parameter to pass to the callback routine
@@ -254,29 +263,36 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_param)
 {
-	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_ZERO_SUM);
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_ZERO_SUM,
+						      &dest, 1, src_list,
+						      src_cnt, len);
 	struct dma_device *device = chan ? chan->device : NULL;
-	int int_en = cb_fn ? 1 : 0;
-	struct dma_async_tx_descriptor *tx = device ?
-		device->device_prep_dma_zero_sum(chan, src_cnt, len, result,
-			int_en) : NULL;
-	int i;
+	struct dma_async_tx_descriptor *tx = NULL;
 
 	BUG_ON(src_cnt <= 1);
 
-	if (tx) {
-		dma_addr_t dma_addr;
-		enum dma_data_direction dir;
+	if (device) {
+		dma_addr_t *dma_src = (dma_addr_t *) src_list;
+		unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
+		int i;
 
 		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
 
-		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
-			DMA_NONE : DMA_TO_DEVICE;
-
-		for (i = 0; i < src_cnt; i++) {
-			dma_addr = dma_map_page(device->dev, src_list[i],
-				offset, len, dir);
-			tx->tx_set_src(dma_addr, tx, i);
+		for (i = 0; i < src_cnt; i++)
+			dma_src[i] = dma_map_page(device->dev, src_list[i],
+						  offset, len, DMA_TO_DEVICE);
+
+		tx = device->device_prep_dma_zero_sum(chan, dma_src, src_cnt,
+						      len, result,
+						      dma_prep_flags);
+		if (!tx) {
+			if (depend_tx)
+				dma_wait_for_async_tx(depend_tx);
+
+			while (!tx)
+				tx = device->device_prep_dma_zero_sum(chan,
+					dma_src, src_cnt, len, result,
+					dma_prep_flags);
 		}
 
 		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
@@ -311,6 +327,16 @@ EXPORT_SYMBOL_GPL(async_xor_zero_sum);
 
 static int __init async_xor_init(void)
 {
+	#ifdef CONFIG_DMA_ENGINE
+	/* To conserve stack space the input src_list (array of page pointers)
+	 * is reused to hold the array of dma addresses passed to the driver.
+	 * This conversion is only possible when dma_addr_t is less than the
+	 * the size of a pointer.  HIGHMEM64G is known to violate this
+	 * assumption.
+	 */
+	BUILD_BUG_ON(sizeof(dma_addr_t) > sizeof(struct page *));
+	#endif
+
 	return 0;
 }
 
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index c46b7c2..a703def 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -5,6 +5,7 @@
 menuconfig DMADEVICES
 	bool "DMA Engine support"
 	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
+	depends on !HIGHMEM64G
 	help
 	  DMA engines can do asynchronous data transfers without
 	  involving the host CPU.  Currently, this framework can be
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index bcf52df..2996523 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -473,20 +473,22 @@ dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
 {
 	struct dma_device *dev = chan->device;
 	struct dma_async_tx_descriptor *tx;
-	dma_addr_t addr;
+	dma_addr_t dma_dest, dma_src;
 	dma_cookie_t cookie;
 	int cpu;
 
-	tx = dev->device_prep_dma_memcpy(chan, len, 0);
-	if (!tx)
+	dma_src = dma_map_single(dev->dev, src, len, DMA_TO_DEVICE);
+	dma_dest = dma_map_single(dev->dev, dest, len, DMA_FROM_DEVICE);
+	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, 0);
+
+	if (!tx) {
+		dma_unmap_single(dev->dev, dma_src, len, DMA_TO_DEVICE);
+		dma_unmap_single(dev->dev, dma_dest, len, DMA_FROM_DEVICE);
 		return -ENOMEM;
+	}
 
 	tx->ack = 1;
 	tx->callback = NULL;
-	addr = dma_map_single(dev->dev, src, len, DMA_TO_DEVICE);
-	tx->tx_set_src(addr, tx, 0);
-	addr = dma_map_single(dev->dev, dest, len, DMA_FROM_DEVICE);
-	tx->tx_set_dest(addr, tx, 0);
 	cookie = tx->tx_submit(tx);
 
 	cpu = get_cpu();
@@ -517,20 +519,22 @@ dma_async_memcpy_buf_to_pg(struct dma_chan *chan, struct page *page,
 {
 	struct dma_device *dev = chan->device;
 	struct dma_async_tx_descriptor *tx;
-	dma_addr_t addr;
+	dma_addr_t dma_dest, dma_src;
 	dma_cookie_t cookie;
 	int cpu;
 
-	tx = dev->device_prep_dma_memcpy(chan, len, 0);
-	if (!tx)
+	dma_src = dma_map_single(dev->dev, kdata, len, DMA_TO_DEVICE);
+	dma_dest = dma_map_page(dev->dev, page, offset, len, DMA_FROM_DEVICE);
+	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, 0);
+
+	if (!tx) {
+		dma_unmap_single(dev->dev, dma_src, len, DMA_TO_DEVICE);
+		dma_unmap_page(dev->dev, dma_dest, len, DMA_FROM_DEVICE);
 		return -ENOMEM;
+	}
 
 	tx->ack = 1;
 	tx->callback = NULL;
-	addr = dma_map_single(dev->dev, kdata, len, DMA_TO_DEVICE);
-	tx->tx_set_src(addr, tx, 0);
-	addr = dma_map_page(dev->dev, page, offset, len, DMA_FROM_DEVICE);
-	tx->tx_set_dest(addr, tx, 0);
 	cookie = tx->tx_submit(tx);
 
 	cpu = get_cpu();
@@ -563,20 +567,23 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
 {
 	struct dma_device *dev = chan->device;
 	struct dma_async_tx_descriptor *tx;
-	dma_addr_t addr;
+	dma_addr_t dma_dest, dma_src;
 	dma_cookie_t cookie;
 	int cpu;
 
-	tx = dev->device_prep_dma_memcpy(chan, len, 0);
-	if (!tx)
+	dma_src = dma_map_page(dev->dev, src_pg, src_off, len, DMA_TO_DEVICE);
+	dma_dest = dma_map_page(dev->dev, dest_pg, dest_off, len,
+				DMA_FROM_DEVICE);
+	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, 0);
+
+	if (!tx) {
+		dma_unmap_page(dev->dev, dma_src, len, DMA_TO_DEVICE);
+		dma_unmap_page(dev->dev, dma_dest, len, DMA_FROM_DEVICE);
 		return -ENOMEM;
+	}
 
 	tx->ack = 1;
 	tx->callback = NULL;
-	addr = dma_map_page(dev->dev, src_pg, src_off, len, DMA_TO_DEVICE);
-	tx->tx_set_src(addr, tx, 0);
-	addr = dma_map_page(dev->dev, dest_pg, dest_off, len, DMA_FROM_DEVICE);
-	tx->tx_set_dest(addr, tx, 0);
 	cookie = tx->tx_submit(tx);
 
 	cpu = get_cpu();
diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 45e7b46..dff38ac 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -159,20 +159,6 @@ static int ioat_dma_enumerate_channels(struct ioatdma_device *device)
 	return device->common.chancnt;
 }
 
-static void ioat_set_src(dma_addr_t addr,
-			 struct dma_async_tx_descriptor *tx,
-			 int index)
-{
-	tx_to_ioat_desc(tx)->src = addr;
-}
-
-static void ioat_set_dest(dma_addr_t addr,
-			  struct dma_async_tx_descriptor *tx,
-			  int index)
-{
-	tx_to_ioat_desc(tx)->dst = addr;
-}
-
 /**
  * ioat_dma_memcpy_issue_pending - push potentially unrecognized appended
  *                                 descriptors to hw
@@ -415,8 +401,6 @@ static struct ioat_desc_sw *ioat_dma_alloc_descriptor(
 
 	memset(desc, 0, sizeof(*desc));
 	dma_async_tx_descriptor_init(&desc_sw->async_tx, &ioat_chan->common);
-	desc_sw->async_tx.tx_set_src = ioat_set_src;
-	desc_sw->async_tx.tx_set_dest = ioat_set_dest;
 	switch (ioat_chan->device->version) {
 	case IOAT_VER_1_2:
 		desc_sw->async_tx.tx_submit = ioat1_tx_submit;
@@ -714,8 +698,10 @@ static struct ioat_desc_sw *ioat_dma_get_next_descriptor(
 
 static struct dma_async_tx_descriptor *ioat1_dma_prep_memcpy(
 						struct dma_chan *chan,
+						dma_addr_t dma_dest,
+						dma_addr_t dma_src,
 						size_t len,
-						int int_en)
+						unsigned long flags)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
 	struct ioat_desc_sw *new;
@@ -726,6 +712,8 @@ static struct dma_async_tx_descriptor *ioat1_dma_prep_memcpy(
 
 	if (new) {
 		new->len = len;
+		new->dst = dma_dest;
+		new->src = dma_src;
 		return &new->async_tx;
 	} else
 		return NULL;
@@ -733,8 +721,10 @@ static struct dma_async_tx_descriptor *ioat1_dma_prep_memcpy(
 
 static struct dma_async_tx_descriptor *ioat2_dma_prep_memcpy(
 						struct dma_chan *chan,
+						dma_addr_t dma_dest,
+						dma_addr_t dma_src,
 						size_t len,
-						int int_en)
+						unsigned long flags)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
 	struct ioat_desc_sw *new;
@@ -749,6 +739,8 @@ static struct dma_async_tx_descriptor *ioat2_dma_prep_memcpy(
 
 	if (new) {
 		new->len = len;
+		new->dst = dma_dest;
+		new->src = dma_src;
 		return &new->async_tx;
 	} else
 		return NULL;
@@ -1045,7 +1037,7 @@ static int ioat_dma_self_test(struct ioatdma_device *device)
 	u8 *dest;
 	struct dma_chan *dma_chan;
 	struct dma_async_tx_descriptor *tx;
-	dma_addr_t addr;
+	dma_addr_t dma_dest, dma_src;
 	dma_cookie_t cookie;
 	int err = 0;
 
@@ -1073,7 +1065,12 @@ static int ioat_dma_self_test(struct ioatdma_device *device)
 		goto out;
 	}
 
-	tx = device->common.device_prep_dma_memcpy(dma_chan, IOAT_TEST_SIZE, 0);
+	dma_src = dma_map_single(dma_chan->device->dev, src, IOAT_TEST_SIZE,
+				 DMA_TO_DEVICE);
+	dma_dest = dma_map_single(dma_chan->device->dev, dest, IOAT_TEST_SIZE,
+				  DMA_FROM_DEVICE);
+	tx = device->common.device_prep_dma_memcpy(dma_chan, dma_dest, dma_src,
+						   IOAT_TEST_SIZE, 0);
 	if (!tx) {
 		dev_err(&device->pdev->dev,
 			"Self-test prep failed, disabling\n");
@@ -1082,12 +1079,6 @@ static int ioat_dma_self_test(struct ioatdma_device *device)
 	}
 
 	async_tx_ack(tx);
-	addr = dma_map_single(dma_chan->device->dev, src, IOAT_TEST_SIZE,
-			      DMA_TO_DEVICE);
-	tx->tx_set_src(addr, tx, 0);
-	addr = dma_map_single(dma_chan->device->dev, dest, IOAT_TEST_SIZE,
-			      DMA_FROM_DEVICE);
-	tx->tx_set_dest(addr, tx, 0);
 	tx->callback = ioat_dma_test_callback;
 	tx->callback_param = (void *)0x8086;
 	cookie = tx->tx_submit(tx);
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index e5c62b7..3986d54 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -284,7 +284,7 @@ iop_adma_alloc_slots(struct iop_adma_chan *iop_chan, int num_slots,
 			int slots_per_op)
 {
 	struct iop_adma_desc_slot *iter, *_iter, *alloc_start = NULL;
-	struct list_head chain = LIST_HEAD_INIT(chain);
+	LIST_HEAD(chain);
 	int slots_found, retry = 0;
 
 	/* start search from the last allocated descrtiptor
@@ -443,17 +443,6 @@ iop_adma_tx_submit(struct dma_async_tx_descriptor *tx)
 	return cookie;
 }
 
-static void
-iop_adma_set_dest(dma_addr_t addr, struct dma_async_tx_descriptor *tx,
-	int index)
-{
-	struct iop_adma_desc_slot *sw_desc = tx_to_iop_adma_slot(tx);
-	struct iop_adma_chan *iop_chan = to_iop_adma_chan(tx->chan);
-
-	/* to do: support transfers lengths > IOP_ADMA_MAX_BYTE_COUNT */
-	iop_desc_set_dest_addr(sw_desc->group_head, iop_chan, addr);
-}
-
 static void iop_chan_start_null_memcpy(struct iop_adma_chan *iop_chan);
 static void iop_chan_start_null_xor(struct iop_adma_chan *iop_chan);
 
@@ -486,7 +475,6 @@ static int iop_adma_alloc_chan_resources(struct dma_chan *chan)
 
 		dma_async_tx_descriptor_init(&slot->async_tx, chan);
 		slot->async_tx.tx_submit = iop_adma_tx_submit;
-		slot->async_tx.tx_set_dest = iop_adma_set_dest;
 		INIT_LIST_HEAD(&slot->chain_node);
 		INIT_LIST_HEAD(&slot->slot_node);
 		INIT_LIST_HEAD(&slot->async_tx.tx_list);
@@ -547,18 +535,9 @@ iop_adma_prep_dma_interrupt(struct dma_chan *chan)
 	return sw_desc ? &sw_desc->async_tx : NULL;
 }
 
-static void
-iop_adma_memcpy_set_src(dma_addr_t addr, struct dma_async_tx_descriptor *tx,
-	int index)
-{
-	struct iop_adma_desc_slot *sw_desc = tx_to_iop_adma_slot(tx);
-	struct iop_adma_desc_slot *grp_start = sw_desc->group_head;
-
-	iop_desc_set_memcpy_src_addr(grp_start, addr);
-}
-
 static struct dma_async_tx_descriptor *
-iop_adma_prep_dma_memcpy(struct dma_chan *chan, size_t len, int int_en)
+iop_adma_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dma_dest,
+			 dma_addr_t dma_src, size_t len, unsigned long flags)
 {
 	struct iop_adma_chan *iop_chan = to_iop_adma_chan(chan);
 	struct iop_adma_desc_slot *sw_desc, *grp_start;
@@ -576,11 +555,12 @@ iop_adma_prep_dma_memcpy(struct dma_chan *chan, size_t len, int int_en)
 	sw_desc = iop_adma_alloc_slots(iop_chan, slot_cnt, slots_per_op);
 	if (sw_desc) {
 		grp_start = sw_desc->group_head;
-		iop_desc_init_memcpy(grp_start, int_en);
+		iop_desc_init_memcpy(grp_start, flags);
 		iop_desc_set_byte_count(grp_start, iop_chan, len);
+		iop_desc_set_dest_addr(grp_start, iop_chan, dma_dest);
+		iop_desc_set_memcpy_src_addr(grp_start, dma_src);
 		sw_desc->unmap_src_cnt = 1;
 		sw_desc->unmap_len = len;
-		sw_desc->async_tx.tx_set_src = iop_adma_memcpy_set_src;
 	}
 	spin_unlock_bh(&iop_chan->lock);
 
@@ -588,8 +568,8 @@ iop_adma_prep_dma_memcpy(struct dma_chan *chan, size_t len, int int_en)
 }
 
 static struct dma_async_tx_descriptor *
-iop_adma_prep_dma_memset(struct dma_chan *chan, int value, size_t len,
-	int int_en)
+iop_adma_prep_dma_memset(struct dma_chan *chan, dma_addr_t dma_dest,
+			 int value, size_t len, unsigned long flags)
 {
 	struct iop_adma_chan *iop_chan = to_iop_adma_chan(chan);
 	struct iop_adma_desc_slot *sw_desc, *grp_start;
@@ -607,9 +587,10 @@ iop_adma_prep_dma_memset(struct dma_chan *chan, int value, size_t len,
 	sw_desc = iop_adma_alloc_slots(iop_chan, slot_cnt, slots_per_op);
 	if (sw_desc) {
 		grp_start = sw_desc->group_head;
-		iop_desc_init_memset(grp_start, int_en);
+		iop_desc_init_memset(grp_start, flags);
 		iop_desc_set_byte_count(grp_start, iop_chan, len);
 		iop_desc_set_block_fill_val(grp_start, value);
+		iop_desc_set_dest_addr(grp_start, iop_chan, dma_dest);
 		sw_desc->unmap_src_cnt = 1;
 		sw_desc->unmap_len = len;
 	}
@@ -618,19 +599,10 @@ iop_adma_prep_dma_memset(struct dma_chan *chan, int value, size_t len,
 	return sw_desc ? &sw_desc->async_tx : NULL;
 }
 
-static void
-iop_adma_xor_set_src(dma_addr_t addr, struct dma_async_tx_descriptor *tx,
-	int index)
-{
-	struct iop_adma_desc_slot *sw_desc = tx_to_iop_adma_slot(tx);
-	struct iop_adma_desc_slot *grp_start = sw_desc->group_head;
-
-	iop_desc_set_xor_src_addr(grp_start, index, addr);
-}
-
 static struct dma_async_tx_descriptor *
-iop_adma_prep_dma_xor(struct dma_chan *chan, unsigned int src_cnt, size_t len,
-	int int_en)
+iop_adma_prep_dma_xor(struct dma_chan *chan, dma_addr_t dma_dest,
+		      dma_addr_t *dma_src, unsigned int src_cnt, size_t len,
+		      unsigned long flags)
 {
 	struct iop_adma_chan *iop_chan = to_iop_adma_chan(chan);
 	struct iop_adma_desc_slot *sw_desc, *grp_start;
@@ -641,39 +613,32 @@ iop_adma_prep_dma_xor(struct dma_chan *chan, unsigned int src_cnt, size_t len,
 	BUG_ON(unlikely(len > IOP_ADMA_XOR_MAX_BYTE_COUNT));
 
 	dev_dbg(iop_chan->device->common.dev,
-		"%s src_cnt: %d len: %u int_en: %d\n",
-		__FUNCTION__, src_cnt, len, int_en);
+		"%s src_cnt: %d len: %u flags: %lx\n",
+		__FUNCTION__, src_cnt, len, flags);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_xor_slot_count(len, src_cnt, &slots_per_op);
 	sw_desc = iop_adma_alloc_slots(iop_chan, slot_cnt, slots_per_op);
 	if (sw_desc) {
 		grp_start = sw_desc->group_head;
-		iop_desc_init_xor(grp_start, src_cnt, int_en);
+		iop_desc_init_xor(grp_start, src_cnt, flags);
 		iop_desc_set_byte_count(grp_start, iop_chan, len);
+		iop_desc_set_dest_addr(grp_start, iop_chan, dma_dest);
 		sw_desc->unmap_src_cnt = src_cnt;
 		sw_desc->unmap_len = len;
-		sw_desc->async_tx.tx_set_src = iop_adma_xor_set_src;
+		while (src_cnt--)
+			iop_desc_set_xor_src_addr(grp_start, src_cnt,
+						  dma_src[src_cnt]);
 	}
 	spin_unlock_bh(&iop_chan->lock);
 
 	return sw_desc ? &sw_desc->async_tx : NULL;
 }
 
-static void
-iop_adma_xor_zero_sum_set_src(dma_addr_t addr,
-				struct dma_async_tx_descriptor *tx,
-				int index)
-{
-	struct iop_adma_desc_slot *sw_desc = tx_to_iop_adma_slot(tx);
-	struct iop_adma_desc_slot *grp_start = sw_desc->group_head;
-
-	iop_desc_set_zero_sum_src_addr(grp_start, index, addr);
-}
-
 static struct dma_async_tx_descriptor *
-iop_adma_prep_dma_zero_sum(struct dma_chan *chan, unsigned int src_cnt,
-	size_t len, u32 *result, int int_en)
+iop_adma_prep_dma_zero_sum(struct dma_chan *chan, dma_addr_t *dma_src,
+			   unsigned int src_cnt, size_t len, u32 *result,
+			   unsigned long flags)
 {
 	struct iop_adma_chan *iop_chan = to_iop_adma_chan(chan);
 	struct iop_adma_desc_slot *sw_desc, *grp_start;
@@ -690,14 +655,16 @@ iop_adma_prep_dma_zero_sum(struct dma_chan *chan, unsigned int src_cnt,
 	sw_desc = iop_adma_alloc_slots(iop_chan, slot_cnt, slots_per_op);
 	if (sw_desc) {
 		grp_start = sw_desc->group_head;
-		iop_desc_init_zero_sum(grp_start, src_cnt, int_en);
+		iop_desc_init_zero_sum(grp_start, src_cnt, flags);
 		iop_desc_set_zero_sum_byte_count(grp_start, len);
 		grp_start->xor_check_result = result;
 		pr_debug("\t%s: grp_start->xor_check_result: %p\n",
 			__FUNCTION__, grp_start->xor_check_result);
 		sw_desc->unmap_src_cnt = src_cnt;
 		sw_desc->unmap_len = len;
-		sw_desc->async_tx.tx_set_src = iop_adma_xor_zero_sum_set_src;
+		while (src_cnt--)
+			iop_desc_set_zero_sum_src_addr(grp_start, src_cnt,
+						       dma_src[src_cnt]);
 	}
 	spin_unlock_bh(&iop_chan->lock);
 
@@ -882,13 +849,12 @@ static int __devinit iop_adma_memcpy_self_test(struct iop_adma_device *device)
 		goto out;
 	}
 
-	tx = iop_adma_prep_dma_memcpy(dma_chan, IOP_ADMA_TEST_SIZE, 1);
 	dest_dma = dma_map_single(dma_chan->device->dev, dest,
 				IOP_ADMA_TEST_SIZE, DMA_FROM_DEVICE);
-	iop_adma_set_dest(dest_dma, tx, 0);
 	src_dma = dma_map_single(dma_chan->device->dev, src,
 				IOP_ADMA_TEST_SIZE, DMA_TO_DEVICE);
-	iop_adma_memcpy_set_src(src_dma, tx, 0);
+	tx = iop_adma_prep_dma_memcpy(dma_chan, dest_dma, src_dma,
+				      IOP_ADMA_TEST_SIZE, 1);
 
 	cookie = iop_adma_tx_submit(tx);
 	iop_adma_issue_pending(dma_chan);
@@ -929,6 +895,7 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 	struct page *dest;
 	struct page *xor_srcs[IOP_ADMA_NUM_SRC_TEST];
 	struct page *zero_sum_srcs[IOP_ADMA_NUM_SRC_TEST + 1];
+	dma_addr_t dma_srcs[IOP_ADMA_NUM_SRC_TEST + 1];
 	dma_addr_t dma_addr, dest_dma;
 	struct dma_async_tx_descriptor *tx;
 	struct dma_chan *dma_chan;
@@ -981,17 +948,13 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 	}
 
 	/* test xor */
-	tx = iop_adma_prep_dma_xor(dma_chan, IOP_ADMA_NUM_SRC_TEST,
-				PAGE_SIZE, 1);
 	dest_dma = dma_map_page(dma_chan->device->dev, dest, 0,
 				PAGE_SIZE, DMA_FROM_DEVICE);
-	iop_adma_set_dest(dest_dma, tx, 0);
-
-	for (i = 0; i < IOP_ADMA_NUM_SRC_TEST; i++) {
-		dma_addr = dma_map_page(dma_chan->device->dev, xor_srcs[i], 0,
-			PAGE_SIZE, DMA_TO_DEVICE);
-		iop_adma_xor_set_src(dma_addr, tx, i);
-	}
+	for (i = 0; i < IOP_ADMA_NUM_SRC_TEST; i++)
+		dma_srcs[i] = dma_map_page(dma_chan->device->dev, xor_srcs[i],
+					   0, PAGE_SIZE, DMA_TO_DEVICE);
+	tx = iop_adma_prep_dma_xor(dma_chan, dest_dma, dma_srcs,
+				   IOP_ADMA_NUM_SRC_TEST, PAGE_SIZE, 1);
 
 	cookie = iop_adma_tx_submit(tx);
 	iop_adma_issue_pending(dma_chan);
@@ -1032,13 +995,13 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 
 	zero_sum_result = 1;
 
-	tx = iop_adma_prep_dma_zero_sum(dma_chan, IOP_ADMA_NUM_SRC_TEST + 1,
-		PAGE_SIZE, &zero_sum_result, 1);
-	for (i = 0; i < IOP_ADMA_NUM_SRC_TEST + 1; i++) {
-		dma_addr = dma_map_page(dma_chan->device->dev, zero_sum_srcs[i],
-			0, PAGE_SIZE, DMA_TO_DEVICE);
-		iop_adma_xor_zero_sum_set_src(dma_addr, tx, i);
-	}
+	for (i = 0; i < IOP_ADMA_NUM_SRC_TEST + 1; i++)
+		dma_srcs[i] = dma_map_page(dma_chan->device->dev,
+					   zero_sum_srcs[i], 0, PAGE_SIZE,
+					   DMA_TO_DEVICE);
+	tx = iop_adma_prep_dma_zero_sum(dma_chan, dma_srcs,
+					IOP_ADMA_NUM_SRC_TEST + 1, PAGE_SIZE,
+					&zero_sum_result, 1);
 
 	cookie = iop_adma_tx_submit(tx);
 	iop_adma_issue_pending(dma_chan);
@@ -1060,10 +1023,9 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 	}
 
 	/* test memset */
-	tx = iop_adma_prep_dma_memset(dma_chan, 0, PAGE_SIZE, 1);
 	dma_addr = dma_map_page(dma_chan->device->dev, dest, 0,
 			PAGE_SIZE, DMA_FROM_DEVICE);
-	iop_adma_set_dest(dma_addr, tx, 0);
+	tx = iop_adma_prep_dma_memset(dma_chan, dma_addr, 0, PAGE_SIZE, 1);
 
 	cookie = iop_adma_tx_submit(tx);
 	iop_adma_issue_pending(dma_chan);
@@ -1089,13 +1051,13 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 
 	/* test for non-zero parity sum */
 	zero_sum_result = 0;
-	tx = iop_adma_prep_dma_zero_sum(dma_chan, IOP_ADMA_NUM_SRC_TEST + 1,
-		PAGE_SIZE, &zero_sum_result, 1);
-	for (i = 0; i < IOP_ADMA_NUM_SRC_TEST + 1; i++) {
-		dma_addr = dma_map_page(dma_chan->device->dev, zero_sum_srcs[i],
-			0, PAGE_SIZE, DMA_TO_DEVICE);
-		iop_adma_xor_zero_sum_set_src(dma_addr, tx, i);
-	}
+	for (i = 0; i < IOP_ADMA_NUM_SRC_TEST + 1; i++)
+		dma_srcs[i] = dma_map_page(dma_chan->device->dev,
+					   zero_sum_srcs[i], 0, PAGE_SIZE,
+					   DMA_TO_DEVICE);
+	tx = iop_adma_prep_dma_zero_sum(dma_chan, dma_srcs,
+					IOP_ADMA_NUM_SRC_TEST + 1, PAGE_SIZE,
+					&zero_sum_result, 1);
 
 	cookie = iop_adma_tx_submit(tx);
 	iop_adma_issue_pending(dma_chan);
diff --git a/include/asm-arm/arch-iop13xx/adma.h b/include/asm-arm/arch-iop13xx/adma.h
index 04006c1..efd9a5e 100644
--- a/include/asm-arm/arch-iop13xx/adma.h
+++ b/include/asm-arm/arch-iop13xx/adma.h
@@ -247,7 +247,7 @@ static inline u32 iop_desc_get_src_count(struct iop_adma_desc_slot *desc,
 }
 
 static inline void
-iop_desc_init_memcpy(struct iop_adma_desc_slot *desc, int int_en)
+iop_desc_init_memcpy(struct iop_adma_desc_slot *desc, unsigned long flags)
 {
 	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
 	union {
@@ -257,13 +257,13 @@ iop_desc_init_memcpy(struct iop_adma_desc_slot *desc, int int_en)
 
 	u_desc_ctrl.value = 0;
 	u_desc_ctrl.field.xfer_dir = 3; /* local to internal bus */
-	u_desc_ctrl.field.int_en = int_en;
+	u_desc_ctrl.field.int_en = flags & DMA_PREP_INTERRUPT;
 	hw_desc->desc_ctrl = u_desc_ctrl.value;
 	hw_desc->crc_addr = 0;
 }
 
 static inline void
-iop_desc_init_memset(struct iop_adma_desc_slot *desc, int int_en)
+iop_desc_init_memset(struct iop_adma_desc_slot *desc, unsigned long flags)
 {
 	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
 	union {
@@ -274,14 +274,15 @@ iop_desc_init_memset(struct iop_adma_desc_slot *desc, int int_en)
 	u_desc_ctrl.value = 0;
 	u_desc_ctrl.field.xfer_dir = 3; /* local to internal bus */
 	u_desc_ctrl.field.block_fill_en = 1;
-	u_desc_ctrl.field.int_en = int_en;
+	u_desc_ctrl.field.int_en = flags & DMA_PREP_INTERRUPT;
 	hw_desc->desc_ctrl = u_desc_ctrl.value;
 	hw_desc->crc_addr = 0;
 }
 
 /* to do: support buffers larger than ADMA_MAX_BYTE_COUNT */
 static inline void
-iop_desc_init_xor(struct iop_adma_desc_slot *desc, int src_cnt, int int_en)
+iop_desc_init_xor(struct iop_adma_desc_slot *desc, int src_cnt,
+		  unsigned long flags)
 {
 	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
 	union {
@@ -292,7 +293,7 @@ iop_desc_init_xor(struct iop_adma_desc_slot *desc, int src_cnt, int int_en)
 	u_desc_ctrl.value = 0;
 	u_desc_ctrl.field.src_select = src_cnt - 1;
 	u_desc_ctrl.field.xfer_dir = 3; /* local to internal bus */
-	u_desc_ctrl.field.int_en = int_en;
+	u_desc_ctrl.field.int_en = flags & DMA_PREP_INTERRUPT;
 	hw_desc->desc_ctrl = u_desc_ctrl.value;
 	hw_desc->crc_addr = 0;
 
@@ -301,7 +302,8 @@ iop_desc_init_xor(struct iop_adma_desc_slot *desc, int src_cnt, int int_en)
 
 /* to do: support buffers larger than ADMA_MAX_BYTE_COUNT */
 static inline int
-iop_desc_init_zero_sum(struct iop_adma_desc_slot *desc, int src_cnt, int int_en)
+iop_desc_init_zero_sum(struct iop_adma_desc_slot *desc, int src_cnt,
+		       unsigned long flags)
 {
 	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
 	union {
@@ -314,7 +316,7 @@ iop_desc_init_zero_sum(struct iop_adma_desc_slot *desc, int src_cnt, int int_en)
 	u_desc_ctrl.field.xfer_dir = 3; /* local to internal bus */
 	u_desc_ctrl.field.zero_result = 1;
 	u_desc_ctrl.field.status_write_back_en = 1;
-	u_desc_ctrl.field.int_en = int_en;
+	u_desc_ctrl.field.int_en = flags & DMA_PREP_INTERRUPT;
 	hw_desc->desc_ctrl = u_desc_ctrl.value;
 	hw_desc->crc_addr = 0;
 
diff --git a/include/asm-arm/hardware/iop3xx-adma.h b/include/asm-arm/hardware/iop3xx-adma.h
index 10834b5..5c529e6 100644
--- a/include/asm-arm/hardware/iop3xx-adma.h
+++ b/include/asm-arm/hardware/iop3xx-adma.h
@@ -414,7 +414,7 @@ static inline void iop3xx_aau_desc_set_src_addr(struct iop3xx_desc_aau *hw_desc,
 }
 
 static inline void
-iop_desc_init_memcpy(struct iop_adma_desc_slot *desc, int int_en)
+iop_desc_init_memcpy(struct iop_adma_desc_slot *desc, unsigned long flags)
 {
 	struct iop3xx_desc_dma *hw_desc = desc->hw_desc;
 	union {
@@ -425,14 +425,14 @@ iop_desc_init_memcpy(struct iop_adma_desc_slot *desc, int int_en)
 	u_desc_ctrl.value = 0;
 	u_desc_ctrl.field.mem_to_mem_en = 1;
 	u_desc_ctrl.field.pci_transaction = 0xe; /* memory read block */
-	u_desc_ctrl.field.int_en = int_en;
+	u_desc_ctrl.field.int_en = flags & DMA_PREP_INTERRUPT;
 	hw_desc->desc_ctrl = u_desc_ctrl.value;
 	hw_desc->upper_pci_src_addr = 0;
 	hw_desc->crc_addr = 0;
 }
 
 static inline void
-iop_desc_init_memset(struct iop_adma_desc_slot *desc, int int_en)
+iop_desc_init_memset(struct iop_adma_desc_slot *desc, unsigned long flags)
 {
 	struct iop3xx_desc_aau *hw_desc = desc->hw_desc;
 	union {
@@ -443,12 +443,13 @@ iop_desc_init_memset(struct iop_adma_desc_slot *desc, int int_en)
 	u_desc_ctrl.value = 0;
 	u_desc_ctrl.field.blk1_cmd_ctrl = 0x2; /* memory block fill */
 	u_desc_ctrl.field.dest_write_en = 1;
-	u_desc_ctrl.field.int_en = int_en;
+	u_desc_ctrl.field.int_en = flags & DMA_PREP_INTERRUPT;
 	hw_desc->desc_ctrl = u_desc_ctrl.value;
 }
 
 static inline u32
-iop3xx_desc_init_xor(struct iop3xx_desc_aau *hw_desc, int src_cnt, int int_en)
+iop3xx_desc_init_xor(struct iop3xx_desc_aau *hw_desc, int src_cnt,
+		     unsigned long flags)
 {
 	int i, shift;
 	u32 edcr;
@@ -509,21 +510,23 @@ iop3xx_desc_init_xor(struct iop3xx_desc_aau *hw_desc, int src_cnt, int int_en)
 
 	u_desc_ctrl.field.dest_write_en = 1;
 	u_desc_ctrl.field.blk1_cmd_ctrl = 0x7; /* direct fill */
-	u_desc_ctrl.field.int_en = int_en;
+	u_desc_ctrl.field.int_en = flags & DMA_PREP_INTERRUPT;
 	hw_desc->desc_ctrl = u_desc_ctrl.value;
 
 	return u_desc_ctrl.value;
 }
 
 static inline void
-iop_desc_init_xor(struct iop_adma_desc_slot *desc, int src_cnt, int int_en)
+iop_desc_init_xor(struct iop_adma_desc_slot *desc, int src_cnt,
+		  unsigned long flags)
 {
-	iop3xx_desc_init_xor(desc->hw_desc, src_cnt, int_en);
+	iop3xx_desc_init_xor(desc->hw_desc, src_cnt, flags);
 }
 
 /* return the number of operations */
 static inline int
-iop_desc_init_zero_sum(struct iop_adma_desc_slot *desc, int src_cnt, int int_en)
+iop_desc_init_zero_sum(struct iop_adma_desc_slot *desc, int src_cnt,
+		       unsigned long flags)
 {
 	int slot_cnt = desc->slot_cnt, slots_per_op = desc->slots_per_op;
 	struct iop3xx_desc_aau *hw_desc, *prev_hw_desc, *iter;
@@ -538,10 +541,10 @@ iop_desc_init_zero_sum(struct iop_adma_desc_slot *desc, int src_cnt, int int_en)
 	for (i = 0, j = 0; (slot_cnt -= slots_per_op) >= 0;
 		i += slots_per_op, j++) {
 		iter = iop_hw_desc_slot_idx(hw_desc, i);
-		u_desc_ctrl.value = iop3xx_desc_init_xor(iter, src_cnt, int_en);
+		u_desc_ctrl.value = iop3xx_desc_init_xor(iter, src_cnt, flags);
 		u_desc_ctrl.field.dest_write_en = 0;
 		u_desc_ctrl.field.zero_result_en = 1;
-		u_desc_ctrl.field.int_en = int_en;
+		u_desc_ctrl.field.int_en = flags & DMA_PREP_INTERRUPT;
 		iter->desc_ctrl = u_desc_ctrl.value;
 
 		/* for the subsequent descriptors preserve the store queue
@@ -559,7 +562,8 @@ iop_desc_init_zero_sum(struct iop_adma_desc_slot *desc, int src_cnt, int int_en)
 }
 
 static inline void
-iop_desc_init_null_xor(struct iop_adma_desc_slot *desc, int src_cnt, int int_en)
+iop_desc_init_null_xor(struct iop_adma_desc_slot *desc, int src_cnt,
+		       unsigned long flags)
 {
 	struct iop3xx_desc_aau *hw_desc = desc->hw_desc;
 	union {
@@ -591,7 +595,7 @@ iop_desc_init_null_xor(struct iop_adma_desc_slot *desc, int src_cnt, int int_en)
 	}
 
 	u_desc_ctrl.field.dest_write_en = 0;
-	u_desc_ctrl.field.int_en = int_en;
+	u_desc_ctrl.field.int_en = flags & DMA_PREP_INTERRUPT;
 	hw_desc->desc_ctrl = u_desc_ctrl.value;
 }
 
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index bdca3f1..eb640f0 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -47,7 +47,6 @@ struct dma_chan_ref {
  * address is an implied source, whereas the asynchronous case it must be listed
  * as a source.  The destination address must be the first address in the source
  * array.
- * @ASYNC_TX_ASSUME_COHERENT: skip cache maintenance operations
  * @ASYNC_TX_ACK: immediately ack the descriptor, precludes setting up a
  * dependency chain
  * @ASYNC_TX_DEP_ACK: ack the dependency descriptor.  Useful for chaining.
@@ -55,7 +54,6 @@ struct dma_chan_ref {
 enum async_tx_flags {
 	ASYNC_TX_XOR_ZERO_DST	 = (1 << 0),
 	ASYNC_TX_XOR_DROP_DST	 = (1 << 1),
-	ASYNC_TX_ASSUME_COHERENT = (1 << 2),
 	ASYNC_TX_ACK		 = (1 << 3),
 	ASYNC_TX_DEP_ACK	 = (1 << 4),
 };
@@ -64,9 +62,15 @@ enum async_tx_flags {
 void async_tx_issue_pending_all(void);
 enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
 void async_tx_run_dependencies(struct dma_async_tx_descriptor *tx);
+#ifdef CONFIG_ARCH_HAS_ASYNC_TX_FIND_CHANNEL
+#include <asm/async_tx.h>
+#else
+#define async_tx_find_channel(dep, type, dst, dst_count, src, src_count, len) \
+	 __async_tx_find_channel(dep, type)
 struct dma_chan *
-async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
+__async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
 	enum dma_transaction_type tx_type);
+#endif /* CONFIG_ARCH_HAS_ASYNC_TX_FIND_CHANNEL */
 #else
 static inline void async_tx_issue_pending_all(void)
 {
@@ -88,7 +92,8 @@ async_tx_run_dependencies(struct dma_async_tx_descriptor *tx,
 
 static inline struct dma_chan *
 async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
-	enum dma_transaction_type tx_type)
+	enum dma_transaction_type tx_type, struct page **dst, int dst_count,
+	struct page **src, int src_count, size_t len)
 {
 	return NULL;
 }
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 5c84bf8..acbb364 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -95,6 +95,15 @@ enum dma_transaction_type {
 #define DMA_TX_TYPE_END (DMA_INTERRUPT + 1)
 
 /**
+ * enum dma_prep_flags - DMA flags to augment operation preparation
+ * @DMA_PREP_INTERRUPT - trigger an interrupt (callback) upon completion of
+ * 	this transaction
+ */
+enum dma_prep_flags {
+	DMA_PREP_INTERRUPT = (1 << 0),
+};
+
+/**
  * dma_cap_mask_t - capabilities bitmap modeled after cpumask_t.
  * See linux/cpumask.h
  */
@@ -209,8 +218,6 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
  *	descriptors
  * @chan: target channel for this operation
  * @tx_submit: set the prepared descriptor(s) to be executed by the engine
- * @tx_set_dest: set a destination address in a hardware descriptor
- * @tx_set_src: set a source address in a hardware descriptor
  * @callback: routine to call after this operation is complete
  * @callback_param: general parameter to pass to the callback routine
  * ---async_tx api specific fields---
@@ -227,10 +234,6 @@ struct dma_async_tx_descriptor {
 	struct list_head tx_list;
 	struct dma_chan *chan;
 	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
-	void (*tx_set_dest)(dma_addr_t addr,
-		struct dma_async_tx_descriptor *tx, int index);
-	void (*tx_set_src)(dma_addr_t addr,
-		struct dma_async_tx_descriptor *tx, int index);
 	dma_async_tx_callback callback;
 	void *callback_param;
 	struct list_head depend_list;
@@ -279,15 +282,17 @@ struct dma_device {
 	void (*device_free_chan_resources)(struct dma_chan *chan);
 
 	struct dma_async_tx_descriptor *(*device_prep_dma_memcpy)(
-		struct dma_chan *chan, size_t len, int int_en);
+		struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
+		size_t len, unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_xor)(
-		struct dma_chan *chan, unsigned int src_cnt, size_t len,
-		int int_en);
+		struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
+		unsigned int src_cnt, size_t len, unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_zero_sum)(
-		struct dma_chan *chan, unsigned int src_cnt, size_t len,
-		u32 *result, int int_en);
+		struct dma_chan *chan, dma_addr_t *src,	unsigned int src_cnt,
+		size_t len, u32 *result, unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_memset)(
-		struct dma_chan *chan, int value, size_t len, int int_en);
+		struct dma_chan *chan, dma_addr_t dest, int value, size_t len,
+		unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
 		struct dma_chan *chan);
 


