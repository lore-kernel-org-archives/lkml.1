Return-Path: <linux-kernel-owner+w=401wt.eu-S936251AbXGTBNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936251AbXGTBNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760213AbXGTBMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:12:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:45850 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758206AbXGTBMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:12:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,559,1175497200"; 
   d="scan'208";a="252613626"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] async_tx: fix kmap_atomic usage in async_memcpy
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru
Date: Thu, 19 Jul 2007 18:12:52 -0700
Message-ID: <20070720011252.6443.34295.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton:
	[async_memcpy] is very wrong if both ASYNC_TX_KMAP_DST and
	ASYNC_TX_KMAP_SRC can ever be set.  We'll end up using the same kmap
	slot for both src add dest and we get either corrupted data or a BUG.

Evgeniy Polyakov:
	Btw, shouldn't it always be kmap_atomic() even if flag is not set.
	That pages are usual one returned by alloc_page().

So fix the usage of kmap_atomic and kill the ASYNC_TX_KMAP_DST and
ASYNC_TX_KMAP_SRC flags.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 crypto/async_tx/async_memcpy.c |   19 ++++---------------
 drivers/md/raid5.c             |    4 ++--
 include/linux/async_tx.h       |    6 ------
 3 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index a973f4e..047e533 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -36,7 +36,6 @@
  * @offset: offset in pages to start transaction
  * @len: length in bytes
  * @flags: ASYNC_TX_ASSUME_COHERENT, ASYNC_TX_ACK, ASYNC_TX_DEP_ACK,
- *	ASYNC_TX_KMAP_SRC, ASYNC_TX_KMAP_DST
  * @depend_tx: memcpy depends on the result of this transaction
  * @cb_fn: function to call when the memcpy completes
  * @cb_param: parameter to pass to the callback routine
@@ -88,23 +87,13 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 					__FUNCTION__);
 		}
 
-		if (flags & ASYNC_TX_KMAP_DST)
-			dest_buf = kmap_atomic(dest, KM_USER0) + dest_offset;
-		else
-			dest_buf = page_address(dest) + dest_offset;
-
-		if (flags & ASYNC_TX_KMAP_SRC)
-			src_buf = kmap_atomic(src, KM_USER0) + src_offset;
-		else
-			src_buf = page_address(src) + src_offset;
+		dest_buf = kmap_atomic(dest, KM_USER0) + dest_offset;
+		src_buf = kmap_atomic(src, KM_USER1) + src_offset;
 
 		memcpy(dest_buf, src_buf, len);
 
-		if (flags & ASYNC_TX_KMAP_DST)
-			kunmap_atomic(dest_buf, KM_USER0);
-
-		if (flags & ASYNC_TX_KMAP_SRC)
-			kunmap_atomic(src_buf, KM_USER0);
+		kunmap_atomic(dest_buf, KM_USER0);
+		kunmap_atomic(src_buf, KM_USER1);
 
 		async_tx_sync_epilog(flags, depend_tx, cb_fn, cb_param);
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0b66afe..ad3b573 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -493,12 +493,12 @@ async_copy_data(int frombio, struct bio *bio, struct page *page,
 			if (frombio)
 				tx = async_memcpy(page, bio_page, page_offset,
 					b_offset, clen,
-					ASYNC_TX_DEP_ACK | ASYNC_TX_KMAP_SRC,
+					ASYNC_TX_DEP_ACK,
 					tx, NULL, NULL);
 			else
 				tx = async_memcpy(bio_page, page, b_offset,
 					page_offset, clen,
-					ASYNC_TX_DEP_ACK | ASYNC_TX_KMAP_DST,
+					ASYNC_TX_DEP_ACK,
 					tx, NULL, NULL);
 		}
 		if (clen < len) /* hit end of page */
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index ff12550..bdca3f1 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -51,10 +51,6 @@ struct dma_chan_ref {
  * @ASYNC_TX_ACK: immediately ack the descriptor, precludes setting up a
  * dependency chain
  * @ASYNC_TX_DEP_ACK: ack the dependency descriptor.  Useful for chaining.
- * @ASYNC_TX_KMAP_SRC: if the transaction is to be performed synchronously
- * take an atomic mapping (KM_USER0) on the source page(s)
- * @ASYNC_TX_KMAP_DST: if the transaction is to be performed synchronously
- * take an atomic mapping (KM_USER0) on the dest page(s)
  */
 enum async_tx_flags {
 	ASYNC_TX_XOR_ZERO_DST	 = (1 << 0),
@@ -62,8 +58,6 @@ enum async_tx_flags {
 	ASYNC_TX_ASSUME_COHERENT = (1 << 2),
 	ASYNC_TX_ACK		 = (1 << 3),
 	ASYNC_TX_DEP_ACK	 = (1 << 4),
-	ASYNC_TX_KMAP_SRC	 = (1 << 5),
-	ASYNC_TX_KMAP_DST	 = (1 << 6),
 };
 
 #ifdef CONFIG_DMA_ENGINE
