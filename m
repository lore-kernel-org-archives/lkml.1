Return-Path: <linux-kernel-owner+w=401wt.eu-S1762248AbXIZTB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762248AbXIZTB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758003AbXIZTBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:01:23 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:58038 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519AbXIZTBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:01:21 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 3/4] Change dmapool free block management
Date: Wed, 26 Sep 2007 15:01:18 -0400
Message-Id: <1190833279354-git-send-email-willy@linux.intel.com>
X-Mailer: git-send-email 1.5.3.1
In-Reply-To: <20070926185757.GM3899@parisc-linux.org>
References: <20070926185757.GM3899@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also add documentation for how dma pools work, move the header above the
includes, add my copyright, add the original author's copyright, add a
GPL v2 licence to the file and fix the includes.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 mm/dmapool.c |  161 +++++++++++++++++++++++++++++++--------------------------
 1 files changed, 88 insertions(+), 73 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index f5d12a7..4418e4d 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -1,25 +1,45 @@
+/*
+ * DMA Pool allocator
+ *
+ * Copyright 2001 David Brownell
+ * Copyright 2007 Intel Corporation
+ *   Author: Matthew Wilcox <willy@linux.intel.com>
+ *
+ * This software may be redistributed and/or modified under the terms of
+ * the GNU General Public License ("GPL") version 2 as published by the
+ * Free Software Foundation.
+ *
+ * This allocator returns small blocks of a given size which are DMA-able by
+ * the given device.  It uses the dma_alloc_coherent page allocator to get
+ * new pages, then splits them up into blocks of the required size.
+ * Many older drivers still have their own code to do this.
+ *
+ * The current design of this allocator is fairly simple.  The pool is
+ * represented by the 'struct dma_pool' which keeps a doubly-linked list of
+ * allocated pages.  Each page in the page_list is split into blocks of at
+ * least 'size' bytes.  Free blocks are tracked in an unsorted singly-linked
+ * list of free blocks within the page.  Used blocks aren't tracked, but we
+ * keep a count of how many are currently allocated from each page.
+ */
 
 #include <linux/device.h>
-#include <linux/mm.h>
-#include <asm/io.h>		/* Needed for i386 to build */
-#include <asm/scatterlist.h>	/* Needed for i386 to build */
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
-#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/poison.h>
 #include <linux/sched.h>
-
-/*
- * Pool allocator ... wraps the dma_alloc_coherent page allocator, so
- * small blocks are easily used by drivers for bus mastering controllers.
- * This should probably be sharing the guts of the slab allocator.
- */
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/wait.h>
 
 struct dma_pool {		/* the pool */
 	struct list_head page_list;
 	spinlock_t lock;
-	size_t blocks_per_page;
 	size_t size;
 	struct device *dev;
 	size_t allocation;
@@ -32,8 +52,8 @@ struct dma_page {		/* cacheable header for 'allocation' bytes */
 	struct list_head page_list;
 	void *vaddr;
 	dma_addr_t dma;
-	unsigned in_use;
-	unsigned long bitmap[0];
+	unsigned int in_use;
+	unsigned int offset;
 };
 
 #define	POOL_TIMEOUT_JIFFIES	((100 /* msec */ * HZ) / 1000)
@@ -68,8 +88,8 @@ show_pools(struct device *dev, struct device_attribute *attr, char *buf)
 
 		/* per-pool info, no real statistics yet */
 		temp = scnprintf(next, size, "%-16s %4u %4Zu %4Zu %2u\n",
-				 pool->name,
-				 blocks, pages * pool->blocks_per_page,
+				 pool->name, blocks,
+				 pages * (pool->allocation / pool->size),
 				 pool->size, pages);
 		size -= temp;
 		next += temp;
@@ -113,9 +133,12 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 		return NULL;
 	}
 
-	if (size == 0)
+	if (size == 0) {
 		return NULL;
-
+	} else if (size < 4) {
+		size = 4;
+	}
+	
 	if ((size % align) != 0)
 		size = ALIGN(size, align);
 
@@ -140,7 +163,6 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 	spin_lock_init(&retval->lock);
 	retval->size = size;
 	retval->allocation = allocation;
-	retval->blocks_per_page = allocation / size;
 	init_waitqueue_head(&retval->waitq);
 
 	if (dev) {
@@ -165,28 +187,36 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 	return retval;
 }
 
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
-		memset(page->bitmap, 0xff, mapsize);	// bit set == free
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
@@ -194,14 +224,9 @@ static struct dma_page *pool_alloc_page(struct dma_pool *pool, gfp_t mem_flags)
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
@@ -236,7 +261,7 @@ void dma_pool_destroy(struct dma_pool *pool)
 		struct dma_page *page;
 		page = list_entry(pool->page_list.next,
 				  struct dma_page, page_list);
-		if (is_page_busy(pool->blocks_per_page, page->bitmap)) {
+		if (is_page_busy(page)) {
 			if (pool->dev)
 				dev_err(pool->dev,
 					"dma_pool_destroy %s, %p busy\n",
@@ -263,34 +288,21 @@ void dma_pool_destroy(struct dma_pool *pool)
  *
  * This returns the kernel virtual address of a currently unused block,
  * and reports its dma address through the handle.
- * If such a memory block can't be allocated, null is returned.
+ * If such a memory block can't be allocated, %NULL is returned.
  */
 void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 		     dma_addr_t * handle)
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
 	if (!(page = pool_alloc_page(pool, GFP_ATOMIC))) {
 		if (mem_flags & __GFP_WAIT) {
@@ -309,11 +321,10 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 		retval = NULL;
 		goto done;
 	}
-
-	clear_bit(0, &page->bitmap[0]);
-	offset = 0;
  ready:
 	page->in_use++;
+	offset = page->offset;
+	page->offset = *(int *)(page->vaddr + offset);
 	retval = offset + page->vaddr;
 	*handle = offset + page->dma;
 #ifdef	CONFIG_DEBUG_SLAB
@@ -355,7 +366,7 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 {
 	struct dma_page *page;
 	unsigned long flags;
-	int map, block;
+	unsigned int offset;
 
 	if ((page = pool_find_page(pool, dma)) == 0) {
 		if (pool->dev)
@@ -368,13 +379,9 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
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
@@ -385,28 +392,36 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
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
1.5.3.1

