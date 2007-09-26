Return-Path: <linux-kernel-owner+w=401wt.eu-S1762305AbXIZTC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762305AbXIZTC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758162AbXIZTBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:01:24 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:56819 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588AbXIZTBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:01:21 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 4/4] dmapool: Improve memory usage for devices which can't cross boundaries
Date: Wed, 26 Sep 2007 15:01:19 -0400
Message-Id: <11908332791548-git-send-email-willy@linux.intel.com>
X-Mailer: git-send-email 1.5.3.1
In-Reply-To: <20070926185757.GM3899@parisc-linux.org>
References: <20070926185757.GM3899@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The previous implementation simply refused to allocate more than a
boundary's worth of data from an entire page.  Some users didn't know
this, so specified things like SMP_CACHE_BYTES, not realising the
horrible waste of memory that this was.  It's fairly easy to correct
this problem, just by ensuring we don't cross a boundary within a page.
This even helps drivers like EHCI (which can't cross a 4k boundary)
on machines with larger page sizes.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 mm/dmapool.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index 4418e4d..cc43d20 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -43,6 +43,7 @@ struct dma_pool {		/* the pool */
 	size_t size;
 	struct device *dev;
 	size_t allocation;
+	size_t boundary;
 	char name[32];
 	wait_queue_head_t waitq;
 	struct list_head pools;
@@ -107,7 +108,7 @@ static DEVICE_ATTR(pools, S_IRUGO, show_pools, NULL);
  * @dev: device that will be doing the DMA
  * @size: size of the blocks in this pool.
  * @align: alignment requirement for blocks; must be a power of two
- * @allocation: returned blocks won't cross this boundary (or zero)
+ * @boundary: returned blocks won't cross this power of two boundary
  * Context: !in_interrupt()
  *
  * Returns a dma allocation pool with the requested characteristics, or
@@ -117,15 +118,16 @@ static DEVICE_ATTR(pools, S_IRUGO, show_pools, NULL);
  * cache flushing primitives.  The actual size of blocks allocated may be
  * larger than requested because of alignment.
  *
- * If allocation is nonzero, objects returned from dma_pool_alloc() won't
+ * If @boundary is nonzero, objects returned from dma_pool_alloc() won't
  * cross that size boundary.  This is useful for devices which have
  * addressing restrictions on individual DMA transfers, such as not crossing
  * boundaries of 4KBytes.
  */
 struct dma_pool *dma_pool_create(const char *name, struct device *dev,
-				 size_t size, size_t align, size_t allocation)
+				 size_t size, size_t align, size_t boundary)
 {
 	struct dma_pool *retval;
+	size_t allocation;
 
 	if (align == 0) {
 		align = 1;
@@ -142,14 +144,13 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 	if ((size % align) != 0)
 		size = ALIGN(size, align);
 
-	if (allocation == 0) {
-		if (PAGE_SIZE < size)
-			allocation = size;
-		else
-			allocation = PAGE_SIZE;
-		// FIXME: round up for less fragmentation
-	} else if (allocation < size)
+	allocation = max_t(size_t, size, PAGE_SIZE);
+
+	if (!boundary) {
+		boundary = allocation;
+	} else if ((boundary < size) || (boundary & (boundary - 1))) {
 		return NULL;
+	}
 
 	retval = kmalloc_node(sizeof *retval, GFP_KERNEL, dev_to_node(dev));
 	if (!retval)
@@ -162,6 +163,7 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 	INIT_LIST_HEAD(&retval->page_list);
 	spin_lock_init(&retval->lock);
 	retval->size = size;
+	retval->boundary = boundary;
 	retval->allocation = allocation;
 	init_waitqueue_head(&retval->waitq);
 
@@ -190,11 +192,14 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 static void pool_initialise_page(struct dma_pool *pool, struct dma_page *page)
 {
 	unsigned int offset = 0;
+	unsigned int next_boundary = pool->boundary;
 
 	do {
 		unsigned int next = offset + pool->size;
-		if (unlikely((next + pool->size) >= pool->allocation))
-			next = pool->allocation;
+		if (unlikely((next + pool->size) >= next_boundary)) {
+			next = next_boundary;
+			next_boundary += pool->boundary;
+		}
 		*(int *)(page->vaddr + offset) = next;
 		offset = next;
 	} while (offset < pool->allocation);
-- 
1.5.3.1

