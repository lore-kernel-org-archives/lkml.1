Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbXLDUi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbXLDUi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbXLDUiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:38:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:44562 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbXLDUiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:38:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,250,1194249600"; 
   d="scan'208";a="223801807"
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 6/7] Change dmapool free block management
Date: Tue,  4 Dec 2007 13:26:07 -0800
Message-Id: <11968035691789-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <1196803569117-git-send-email-matthew@wil.cx>
References: <20071204170915.GE9405@parisc-linux.org> <11968035682899-git-send-email-matthew@wil.cx> <11968035681680-git-send-email-matthew@wil.cx> <11968035684180-git-send-email-matthew@wil.cx> <11968035682211-git-send-email-matthew@wil.cx> <1196803569117-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a list of free blocks within a page instead of using a bitmap.
Update documentation to reflect this.  As well as being a slight
reduction in memory allocation, locked ops and lines of code, it speeds
up a transaction processing benchmark by 0.4%.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 mm/dmapool.c |  119 ++++++++++++++++++++++++++++-----------------------------
 1 files changed, 58 insertions(+), 61 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index e2ea454..72e7ece 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -17,7 +17,9 @@
  * The current design of this allocator is fairly simple.  The pool is
  * represented by the 'struct dma_pool' which keeps a doubly-linked list of
  * allocated pages.  Each page in the page_list is split into blocks of at
- * least 'size' bytes.
+ * least 'size' bytes.  Free blocks are tracked in an unsorted singly-linked
+ * list of free blocks within the page.  Used blocks aren't tracked, but we
+ * keep a count of how many are currently allocated from each page.
  */
 
 #include <linux/device.h>
@@ -38,7 +40,6 @@
 struct dma_pool {		/* the pool */
 	struct list_head page_list;
 	spinlock_t lock;
-	size_t blocks_per_page;
 	size_t size;
 	struct device *dev;
 	size_t allocation;
@@ -51,8 +52,8 @@ struct dma_page {		/* cacheable header for 'allocation' bytes */
 	struct list_head page_list;
 	void *vaddr;
 	dma_addr_t dma;
-	unsigned in_use;
-	unsigned long bitmap[0];
+	unsigned int in_use;
+	unsigned int offset;
 };
 
 #define	POOL_TIMEOUT_JIFFIES	((100 /* msec */ * HZ) / 1000)
@@ -87,8 +88,8 @@ show_pools(struct device *dev, struct device_attribute *attr, char *buf)
 
 		/* per-pool info, no real statistics yet */
 		temp = scnprintf(next, size, "%-16s %4u %4Zu %4Zu %2u\n",
-				 pool->name,
-				 blocks, pages * pool->blocks_per_page,
+				 pool->name, blocks,
+				 pages * (pool->allocation / pool->size),
 				 pool->size, pages);
 		size -= temp;
 		next += temp;
@@ -132,8 +133,11 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 		return NULL;
 	}
 
-	if (size == 0)
+	if (size == 0) {
 		return NULL;
+	} else if (size < 4) {
+		size = 4;
+	}
 
 	if ((size % align) != 0)
 		size = ALIGN(size, align);
@@ -160,7 +164,6 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 	spin_lock_init(&retval->lock);
 	retval->size = size;
 	retval->allocation = allocation;
-	retval->blocks_per_page = allocation / size;
 	init_waitqueue_head(&retval->waitq);
 
 	if (dev) {
@@ -186,28 +189,36 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 }
 EXPORT_SYMBOL(dma_pool_create);
 
+static void pool_initialise_page(struct dma_pool *pool, struct dma_page *page)
+{
+	unsigned int offset = 0;
+
+	do {
+		unsigned int next = offset + pool->size;
+		if (unlikely((next + pool->size) >= pool->allocation))
+			next = pool->allocation;
+		*(int *)(page->vaddr + offset) = next;
+		offset = next;
+	} while (offset < pool->allocation);
+}
+
 static struct dma_page *pool_alloc_page(struct dma_pool *pool, gfp_t mem_flags)
 {
 	struct dma_page *page;
-	int mapsize;
-
-	mapsize = pool->blocks_per_page;
-	mapsize = (mapsize + BITS_PER_LONG - 1) / BITS_PER_LONG;
-	mapsize *= sizeof(long);
 
-	page = kmalloc(mapsize + sizeof *page, mem_flags);
+	page = kmalloc(sizeof(*page), mem_flags);
 	if (!page)
 		return NULL;
-	page->vaddr = dma_alloc_coherent(pool->dev,
-					 pool->allocation,
+	page->vaddr = dma_alloc_coherent(pool->dev, pool->allocation,
 					 &page->dma, mem_flags);
 	if (page->vaddr) {
-		memset(page->bitmap, 0xff, mapsize);	/* bit set == free */
 #ifdef	CONFIG_DEBUG_SLAB
 		memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
+		pool_initialise_page(pool, page);
 		list_add(&page->page_list, &pool->page_list);
 		page->in_use = 0;
+		page->offset = 0;
 	} else {
 		kfree(page);
 		page = NULL;
@@ -215,14 +226,9 @@ static struct dma_page *pool_alloc_page(struct dma_pool *pool, gfp_t mem_flags)
 	return page;
 }
 
-static inline int is_page_busy(int blocks, unsigned long *bitmap)
+static inline int is_page_busy(struct dma_page *page)
 {
-	while (blocks > 0) {
-		if (*bitmap++ != ~0UL)
-			return 1;
-		blocks -= BITS_PER_LONG;
-	}
-	return 0;
+	return page->in_use != 0;
 }
 
 static void pool_free_page(struct dma_pool *pool, struct dma_page *page)
@@ -257,7 +263,7 @@ void dma_pool_destroy(struct dma_pool *pool)
 		struct dma_page *page;
 		page = list_entry(pool->page_list.next,
 				  struct dma_page, page_list);
-		if (is_page_busy(pool->blocks_per_page, page->bitmap)) {
+		if (is_page_busy(page)) {
 			if (pool->dev)
 				dev_err(pool->dev,
 					"dma_pool_destroy %s, %p busy\n",
@@ -292,27 +298,14 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 {
 	unsigned long flags;
 	struct dma_page *page;
-	int map, block;
 	size_t offset;
 	void *retval;
 
 	spin_lock_irqsave(&pool->lock, flags);
  restart:
 	list_for_each_entry(page, &pool->page_list, page_list) {
-		int i;
-		/* only cachable accesses here ... */
-		for (map = 0, i = 0;
-		     i < pool->blocks_per_page; i += BITS_PER_LONG, map++) {
-			if (page->bitmap[map] == 0)
-				continue;
-			block = ffz(~page->bitmap[map]);
-			if ((i + block) < pool->blocks_per_page) {
-				clear_bit(block, &page->bitmap[map]);
-				offset = (BITS_PER_LONG * map) + block;
-				offset *= pool->size;
-				goto ready;
-			}
-		}
+		if (page->offset < pool->allocation)
+			goto ready;
 	}
 	page = pool_alloc_page(pool, GFP_ATOMIC);
 	if (!page) {
@@ -333,10 +326,10 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 		goto done;
 	}
 
-	clear_bit(0, &page->bitmap[0]);
-	offset = 0;
  ready:
 	page->in_use++;
+	offset = page->offset;
+	page->offset = *(int *)(page->vaddr + offset);
 	retval = offset + page->vaddr;
 	*handle = offset + page->dma;
 #ifdef	CONFIG_DEBUG_SLAB
@@ -379,7 +372,7 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 {
 	struct dma_page *page;
 	unsigned long flags;
-	int map, block;
+	unsigned int offset;
 
 	page = pool_find_page(pool, dma);
 	if (!page) {
@@ -393,13 +386,9 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 		return;
 	}
 
-	block = dma - page->dma;
-	block /= pool->size;
-	map = block / BITS_PER_LONG;
-	block %= BITS_PER_LONG;
-
+	offset = vaddr - page->vaddr;
 #ifdef	CONFIG_DEBUG_SLAB
-	if (((dma - page->dma) + (void *)page->vaddr) != vaddr) {
+	if ((dma - page->dma) != offset) {
 		if (pool->dev)
 			dev_err(pool->dev,
 				"dma_pool_free %s, %p (bad vaddr)/%Lx\n",
@@ -410,28 +399,36 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 			       pool->name, vaddr, (unsigned long long)dma);
 		return;
 	}
-	if (page->bitmap[map] & (1UL << block)) {
-		if (pool->dev)
-			dev_err(pool->dev,
-				"dma_pool_free %s, dma %Lx already free\n",
-				pool->name, (unsigned long long)dma);
-		else
-			printk(KERN_ERR
-			       "dma_pool_free %s, dma %Lx already free\n",
-			       pool->name, (unsigned long long)dma);
-		return;
+	{
+		unsigned int chain = page->offset;
+		while (chain < pool->allocation) {
+			if (chain != offset) {
+				chain = *(int *)(page->vaddr + chain);
+				continue;
+			}
+			if (pool->dev)
+				dev_err(pool->dev, "dma_pool_free %s, dma %Lx "
+					"already free\n", pool->name,
+					(unsigned long long)dma);
+			else
+				printk(KERN_ERR "dma_pool_free %s, dma %Lx "
+					"already free\n", pool->name,
+					(unsigned long long)dma);
+			return;
+		}
 	}
 	memset(vaddr, POOL_POISON_FREED, pool->size);
 #endif
 
 	spin_lock_irqsave(&pool->lock, flags);
 	page->in_use--;
-	set_bit(block, &page->bitmap[map]);
+	*(int *)vaddr = page->offset;
+	page->offset = offset;
 	if (waitqueue_active(&pool->waitq))
 		wake_up_locked(&pool->waitq);
 	/*
 	 * Resist a temptation to do
-	 *    if (!is_page_busy(bpp, page->bitmap)) pool_free_page(pool, page);
+	 *    if (!is_page_busy(page)) pool_free_page(pool, page);
 	 * Better have a few empty pages hang around.
 	 */
 	spin_unlock_irqrestore(&pool->lock, flags);
-- 
1.4.4.4
