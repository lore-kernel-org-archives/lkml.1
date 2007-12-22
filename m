Return-Path: <linux-kernel-owner+w=401wt.eu-S1751043AbXLVBHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043AbXLVBHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbXLVBHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:07:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:31049 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbXLVBHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:07:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,197,1196668800"; 
   d="scan'208";a="244394873"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/4] async_tx: kill ASYNC_TX_ASSUME_COHERENT
To: linux-kernel@vger.kernel.org
Cc: shannon.nelson@intel.com, yur@emcraft.com, hskinnemoen@atmel.com,
       olof@lixom.net, wei.zhang@freescale.com
Date: Fri, 21 Dec 2007 18:06:43 -0700
Message-ID: <20071222010643.15576.82689.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20071222010537.15576.31788.stgit@dwillia2-linux.ch.intel.com>
References: <20071222010537.15576.31788.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unused ASYNC_TX_ASSUME_COHERENT flag.  Async_tx is
meant to hide the difference between asynchronous hardware and synchronous
software operations, this flag requires clients to understand cache
coherency consequences of the async path.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 crypto/async_tx/async_memcpy.c |   15 +++++----------
 crypto/async_tx/async_memset.c |    8 +++-----
 crypto/async_tx/async_xor.c    |   22 ++++++----------------
 include/linux/async_tx.h       |    2 --
 4 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 047e533..e8c8956 100644
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
@@ -55,20 +55,15 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 
 	if (tx) { /* run the memcpy asynchronously */
 		dma_addr_t addr;
-		enum dma_data_direction dir;
 
 		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
 
-		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
-			DMA_NONE : DMA_FROM_DEVICE;
-
-		addr = dma_map_page(device->dev, dest, dest_offset, len, dir);
+		addr = dma_map_page(device->dev, dest, dest_offset, len,
+				    DMA_FROM_DEVICE);
 		tx->tx_set_dest(addr, tx, 0);
 
-		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
-			DMA_NONE : DMA_TO_DEVICE;
-
-		addr = dma_map_page(device->dev, src, src_offset, len, dir);
+		addr = dma_map_page(device->dev, src, src_offset, len,
+				    DMA_TO_DEVICE);
 		tx->tx_set_src(addr, tx, 0);
 
 		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index 66ef635..7609728 100644
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
@@ -55,13 +55,11 @@ async_memset(struct page *dest, int val, unsigned int offset,
 
 	if (tx) { /* run the memset asynchronously */
 		dma_addr_t dma_addr;
-		enum dma_data_direction dir;
 
 		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
-		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
-			DMA_NONE : DMA_FROM_DEVICE;
 
-		dma_addr = dma_map_page(device->dev, dest, offset, len, dir);
+		dma_addr = dma_map_page(device->dev, dest, offset, len,
+					DMA_FROM_DEVICE);
 		tx->tx_set_dest(dma_addr, tx, 0);
 
 		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 2575f67..f332ddc 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -38,23 +38,17 @@ do_async_xor(struct dma_async_tx_descriptor *tx, struct dma_device *device,
 	dma_async_tx_callback cb_fn, void *cb_param)
 {
 	dma_addr_t dma_addr;
-	enum dma_data_direction dir;
 	int i;
 
 	pr_debug("%s: len: %zu\n", __FUNCTION__, len);
 
-	dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
-		DMA_NONE : DMA_FROM_DEVICE;
-
-	dma_addr = dma_map_page(device->dev, dest, offset, len, dir);
+	dma_addr = dma_map_page(device->dev, dest, offset, len,
+				DMA_FROM_DEVICE);
 	tx->tx_set_dest(dma_addr, tx, 0);
 
-	dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
-		DMA_NONE : DMA_TO_DEVICE;
-
 	for (i = 0; i < src_cnt; i++) {
 		dma_addr = dma_map_page(device->dev, src_list[i],
-			offset, len, dir);
+			offset, len, DMA_TO_DEVICE);
 		tx->tx_set_src(dma_addr, tx, i);
 	}
 
@@ -102,7 +96,7 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
  * @src_cnt: number of source pages
  * @len: length in bytes
  * @flags: ASYNC_TX_XOR_ZERO_DST, ASYNC_TX_XOR_DROP_DEST,
- *	ASYNC_TX_ASSUME_COHERENT, ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ *	ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
  * @depend_tx: xor depends on the result of this transaction.
  * @cb_fn: function to call when the xor completes
  * @cb_param: parameter to pass to the callback routine
@@ -242,7 +236,7 @@ static int page_is_zero(struct page *p, unsigned int offset, size_t len)
  * @src_cnt: number of source pages
  * @len: length in bytes
  * @result: 0 if sum == 0 else non-zero
- * @flags: ASYNC_TX_ASSUME_COHERENT, ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
  * @depend_tx: xor depends on the result of this transaction.
  * @cb_fn: function to call when the xor completes
  * @cb_param: parameter to pass to the callback routine
@@ -266,16 +260,12 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 
 	if (tx) {
 		dma_addr_t dma_addr;
-		enum dma_data_direction dir;
 
 		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
 
-		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
-			DMA_NONE : DMA_TO_DEVICE;
-
 		for (i = 0; i < src_cnt; i++) {
 			dma_addr = dma_map_page(device->dev, src_list[i],
-				offset, len, dir);
+				offset, len, DMA_TO_DEVICE);
 			tx->tx_set_src(dma_addr, tx, i);
 		}
 
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index bdca3f1..3d59d37 100644
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

