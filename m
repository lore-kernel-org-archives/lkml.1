Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbXLVBH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbXLVBH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbXLVBHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:07:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:31049 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbXLVBHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:07:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,197,1196668800"; 
   d="scan'208";a="244394880"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 4/4] async_tx: allow architecture specific
	async_tx_find_channel implementations
To: linux-kernel@vger.kernel.org
Cc: shannon.nelson@intel.com, yur@emcraft.com, hskinnemoen@atmel.com,
       olof@lixom.net, wei.zhang@freescale.com
Date: Fri, 21 Dec 2007 18:06:58 -0700
Message-ID: <20071222010658.15576.59469.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20071222010537.15576.31788.stgit@dwillia2-linux.ch.intel.com>
References: <20071222010537.15576.31788.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The source and destination addresses are included to allow channel
selection based on address alignment.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 crypto/async_tx/async_memcpy.c |    3 ++-
 crypto/async_tx/async_memset.c |    3 ++-
 crypto/async_tx/async_tx.c     |    6 +++---
 crypto/async_tx/async_xor.c    |    8 ++++++--
 include/linux/async_tx.h       |   11 +++++++++--
 5 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 25dcf33..0f62822 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -46,7 +46,8 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_param)
 {
-	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_MEMCPY);
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_MEMCPY,
+						      &dest, 1, &src, 1, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index 8e98ab0..09c0e83 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -46,7 +46,8 @@ async_memset(struct page *dest, int val, unsigned int offset,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_param)
 {
-	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_MEMSET);
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_MEMSET,
+						      &dest, 1, NULL, 0, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index f39777f..5628821 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -361,13 +361,13 @@ static void __exit async_tx_exit(void)
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
@@ -383,7 +383,7 @@ async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
 	} else
 		return NULL;
 }
-EXPORT_SYMBOL_GPL(async_tx_find_channel);
+EXPORT_SYMBOL_GPL(__async_tx_find_channel);
 #else
 static int __init async_tx_init(void)
 {
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 80f30bc..e6dfacc 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -125,7 +125,9 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
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
@@ -257,7 +259,9 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_param)
 {
-	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_ZERO_SUM);
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_ZERO_SUM,
+						      &dest, 1, src_list,
+						      src_cnt, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 3d59d37..eb640f0 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -62,9 +62,15 @@ enum async_tx_flags {
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
@@ -86,7 +92,8 @@ async_tx_run_dependencies(struct dma_async_tx_descriptor *tx,
 
 static inline struct dma_chan *
 async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
-	enum dma_transaction_type tx_type)
+	enum dma_transaction_type tx_type, struct page **dst, int dst_count,
+	struct page **src, int src_count, size_t len)
 {
 	return NULL;
 }

