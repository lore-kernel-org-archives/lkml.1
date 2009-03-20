Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbZCTONb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbZCTONb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 10:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZCTONW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 10:13:22 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:59428 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531AbZCTONV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 10:13:21 -0400
Message-ID: <49C3A435.7060703@vflare.org>
Date: Fri, 20 Mar 2009 19:42:05 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: ngupta@vflare.org
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] xvmalloc memory allocator
References: <49C3A31D.6070208@vflare.org>
In-Reply-To: <49C3A31D.6070208@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 090319-0, 19-03-2009), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  init/Kconfig      |    6 +
  mm/Makefile       |    1 +
  mm/xvmalloc.c     |  572 +++++++++++++++++++++++++++++++++++++++++++++++++++++
  mm/xvmalloc_int.h |   95 +++++++++
  4 files changed, 674 insertions(+), 0 deletions(-)

xvmalloc is a memory allocator designed specifically for compcache project.

* Features:
  - Low metadata overhead (just 4 bytes per object)
  - O(1) Alloc/Free - except when we have to call system page allocator to
     get additional memory.
  - Very low fragmentation: In all tests, xvMalloc memory usage is within 12%
     of "Ideal".

One of the main highlights is that it maps pages only when required.
So, it does not hog vmalloc area which is very small on 32-bit systems.

Slub allocator could not be used due to fragmentation issues:
http://code.google.com/p/compcache/wiki/AllocatorsComparison
Data here shows kmalloc using ~43% more memory than TLSF and xvMalloc
is showed ~2% more space efficiency than TLSF (due to smaller metadata).

* Implementation:
It uses two-level bitmap search to find free list containing block of
correct size. This idea is taken from TLSF (Two-Level Segregate Fit)
allocator and is well explained in its paper (see [Links] below).
Highlights:
  - Pool based allocator: each pool can grow/shrink.
  - Immediate coalescing of free blocks.
  - Maps/Unmaps memory pages only when required.

* Limitations:
  - Poor scalability: No per-cpu data structures (work in progress).

[Links]
1. Details and Performance data:
http://code.google.com/p/compcache/wiki/xvMalloc
http://code.google.com/p/compcache/wiki/xvMallocPerformance

2. TLSF memory allocator:
home: http://rtportal.upv.es/rtmalloc/
paper: http://rtportal.upv.es/rtmalloc/files/MRBC_2008.pdf

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---

diff --git a/init/Kconfig b/init/Kconfig
index 6a5c5fe..fa41598 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -930,6 +930,12 @@ config SLOB

  endchoice

+config XVMALLOC
+	tristate "xvMalloc memory allocator"
+	help
+	   This is a simple, low fragmentation, O(1) allocator.
+	   Details: http://code.google.com/p/compcache/wiki/xvMalloc
+
  config PROFILING
  	bool "Profiling support (EXPERIMENTAL)"
  	help
diff --git a/mm/Makefile b/mm/Makefile
index 72255be..b6b705f 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_SLOB) += slob.o
  obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
  obj-$(CONFIG_SLAB) += slab.o
  obj-$(CONFIG_SLUB) += slub.o
+obj-$(CONFIG_XVMALLOC) += xvmalloc.o
  obj-$(CONFIG_FAILSLAB) += failslab.o
  obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
  obj-$(CONFIG_FS_XIP) += filemap_xip.o
diff --git a/mm/xvmalloc.c b/mm/xvmalloc.c
new file mode 100755
index 0000000..e272487
--- /dev/null
+++ b/mm/xvmalloc.c
@@ -0,0 +1,572 @@
+/*
+ * xvmalloc.c
+ *
+ * Copyright (C) 2008, 2009  Nitin Gupta
+ *
+ * This code is released using a dual license strategy: GPL/LGPL
+ * You can choose the licence that better fits your requirements.
+ *
+ * Released under the terms of the GNU General Public License Version 2.0
+ * Released under the terms of the GNU Lesser General Public License Version 2.1
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/highmem.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/xvmalloc.h>
+
+#include "xvmalloc_int.h"
+
+static void stat_inc(u64 *value)
+{
+	*value = *value + 1;
+}
+
+static void stat_dec(u64 *value)
+{
+	*value = *value - 1;
+}
+
+static void bitmap_set(u32 *map, u32 idx)
+{
+	*map |= (u32)(1 << idx);
+}
+
+static void bitmap_clear(u32 *map, u32 idx)
+{
+	*map &= (u32)(~(1 << idx));
+}
+
+static u32 test_flag(struct block_header *block, enum blockflags flag)
+{
+	return block->prev & (1 << flag);
+}
+
+static void set_flag(struct block_header *block, enum blockflags flag)
+{
+	block->prev |= (1 << flag);
+}
+
+static void clear_flag(struct block_header *block, enum blockflags flag)
+{
+	block->prev &= ~(1 << flag);
+}
+
+static u32 get_blockprev(struct block_header *block)
+{
+	return block->prev & PREV_MASK;
+}
+
+static void set_blockprev(struct block_header *block, u16 new_offset)
+{
+	block->prev = new_offset | (block->prev & FLAGS_MASK);
+}
+
+static struct block_header *BLOCK_NEXT(struct block_header *block)
+{
+	return (struct block_header *)((char *)block + block->size + XV_ALIGN);
+}
+
+/*
+ * Get index of free list containing blocks of maximum size
+ * which is less than or equal to given size.
+ */
+static u32 get_index_for_insert(u32 size)
+{
+	size = size > XV_MAX_ALLOC_SIZE ? XV_MAX_ALLOC_SIZE : size;
+	size &= ~FL_DELTA_MASK;
+	return (size - XV_MIN_ALLOC_SIZE) >> FL_DELTA_SHIFT;
+}
+
+/*
+ * Get index of free list having blocks of size greater than
+ * or equal to requested size.
+ */
+static u32 get_index(u32 size)
+{
+	size = (size + FL_DELTA_MASK) & ~FL_DELTA_MASK;
+	return (size - XV_MIN_ALLOC_SIZE) >> FL_DELTA_SHIFT;
+}
+
+/*
+ * Given <pagenum, offset> pair, provide a derefrencable pointer.
+ * This is called from xv_malloc/xv_free path, so it needs to be fast.
+ */
+static void *get_ptr_atomic(u32 pagenum, u16 offset, enum km_type type)
+{
+	unsigned char *base;
+
+	base = kmap_atomic(pfn_to_page(pagenum), type);
+	return base + offset;
+}
+
+static void put_ptr_atomic(void *ptr, enum km_type type)
+{
+	kunmap_atomic(ptr, type);
+}
+
+/*
+ * Allocate a memory page. Called when a pool needs to grow.
+ */
+static u32 xv_alloc_page(void)
+{
+	struct page *page;
+
+	page = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
+
+	if (unlikely(!page))
+		return INVALID_PGNUM;
+
+	return page_to_pfn(page);
+}
+
+/*
+ * Called when all objects in a page are freed.
+ */
+static void xv_free_page(u32 pagenum)
+{
+	__free_page(pfn_to_page(pagenum));
+}
+
+/**
+ * find_block - find block of at least given size
+ * @pool: memory pool to search from
+ * @size: size of block required
+ * @pagenum: page no. containing required block
+ * @offset: offset within the page where block is located.
+ *
+ * Searches two level bitmap to locate block of at least
+ * the given size. If such a block is found, it provides
+ * <pagenum, offset> to identify this block and returns index
+ * in freelist where we found this block.
+ * Otherwise, returns 0 and <pagenum, offset> params are not touched.
+ */
+static u32 find_block(struct xv_pool *pool, u32 size,
+			u32 *pagenum, u32 *offset)
+{
+	u32 flbitmap, slbitmap;
+	u32 flindex, slindex, slbitstart;
+
+	/* There are no free blocks in this pool */
+	if (!pool->flbitmap)
+		return 0;
+
+	if (unlikely(size < XV_MIN_ALLOC_SIZE))
+		size = XV_MIN_ALLOC_SIZE;
+
+	/* Get freelist index correspoding to this size */
+	slindex = get_index(size);
+	slbitmap = pool->slbitmap[slindex >> BITMAP_SHIFT];
+	slbitstart = slindex & BITMAP_MASK;
+
+	/*
+	 * If freelist is not empty at this index, we found the
+	 * block - head of this list. This is approximate best-fit match.
+	 */
+	if (slbitmap & (1 << slbitstart)) {
+		*pagenum = pool->freelist[slindex].pagenum;
+		*offset = pool->freelist[slindex].offset;
+		return slindex;
+	}
+
+	/*
+	 * No best-fit found. Search a bit further in bitmap for a free block.
+	 * Second level bitmap consists of series of 32-bit chunks. Search
+	 * further in the chunk where we expected a best-fit, starting from
+	 * index location found above.
+	 */
+	slbitstart++;
+	slbitmap >>= slbitstart;
+
+	/* Skip this search if we were already at end of this bitmap chunk */
+	if ((slbitstart != BITMAP_BITS) && slbitmap) {
+		slindex += ffs(slbitmap);
+		*pagenum = pool->freelist[slindex].pagenum;
+		*offset = pool->freelist[slindex].offset;
+		return slindex;
+	}
+
+	/* Now do a full two-level bitmap search to find next nearest fit */
+	flindex = slindex >> BITMAP_SHIFT;
+
+	flbitmap = (pool->flbitmap) >> (flindex + 1);
+	if (!flbitmap)
+		return 0;
+
+	flindex += ffs(flbitmap);
+	slbitmap = pool->slbitmap[flindex];
+	slindex = (flindex << BITMAP_SHIFT) + ffs(slbitmap) - 1;
+	*pagenum = pool->freelist[slindex].pagenum;
+	*offset = pool->freelist[slindex].offset;
+
+	return slindex;
+}
+
+/*
+ * Insert block at <pagenum, offset> in freelist of given pool.
+ * freelist used depends on block size.
+ */
+static void insert_block(struct xv_pool *pool, u32 pagenum, u32 offset,
+			struct block_header *block)
+{
+	u32 flindex, slindex;
+	struct block_header *nextblock;
+
+	slindex = get_index_for_insert(block->size);
+	flindex = slindex >> BITMAP_SHIFT;
+
+	block->link.prev_pagenum = INVALID_PGNUM;
+	block->link.prev_offset = 0;
+	block->link.next_pagenum = pool->freelist[slindex].pagenum;
+	block->link.next_offset = pool->freelist[slindex].offset;
+	pool->freelist[slindex].pagenum = pagenum;
+	pool->freelist[slindex].offset = offset;
+
+	if (block->link.next_pagenum != INVALID_PGNUM) {
+		nextblock = get_ptr_atomic(block->link.next_pagenum,
+					block->link.next_offset, KM_USER1);
+		nextblock->link.prev_pagenum = pagenum;
+		nextblock->link.prev_offset = offset;
+		put_ptr_atomic(nextblock, KM_USER1);
+	}
+
+	bitmap_set(&pool->slbitmap[flindex], slindex & BITMAP_MASK);
+	bitmap_set(&pool->flbitmap, flindex);
+}
+
+/*
+ * Remove block from head of freelist. Index 'slindex' identifies the freelist.
+ */
+static void remove_block_head(struct xv_pool *pool,
+			struct block_header *block, u32 slindex)
+{
+	struct block_header *tmpblock;
+	u32 flindex = slindex >> BITMAP_SHIFT;
+
+	pool->freelist[slindex].pagenum = block->link.next_pagenum;
+	pool->freelist[slindex].offset = block->link.next_offset;
+	block->link.prev_pagenum = INVALID_PGNUM;
+	block->link.prev_offset = 0;
+
+	if (pool->freelist[slindex].pagenum == INVALID_PGNUM) {
+		bitmap_clear(&pool->slbitmap[flindex], slindex & BITMAP_MASK);
+		if (!pool->slbitmap[flindex])
+			bitmap_clear(&pool->flbitmap, flindex);
+	} else {
+		/*
+		 * DEBUG ONLY: We need not reinitialize freelist head previous
+		 * pointer to INVALID_PGNUM - we never depend on its value.
+		 * But just for sanity, lets keep it.
+		 */
+		tmpblock = get_ptr_atomic(pool->freelist[slindex].pagenum,
+				pool->freelist[slindex].offset, KM_USER1);
+		tmpblock->link.prev_pagenum = INVALID_PGNUM;
+		tmpblock->link.prev_offset = 0;
+		put_ptr_atomic(tmpblock, KM_USER1);
+	}
+}
+
+/*
+ * Remove block from freelist. Index 'slindex' identifies the freelist.
+ */
+static void remove_block(struct xv_pool *pool, u32 pagenum, u32 offset,
+			struct block_header *block, u32 slindex)
+{
+	u32 flindex;
+	struct block_header *tmpblock;
+
+	if (pool->freelist[slindex].pagenum == pagenum
+	   && pool->freelist[slindex].offset == offset) {
+		remove_block_head(pool, block, slindex);
+		return;
+	}
+
+	flindex = slindex >> BITMAP_SHIFT;
+
+	if (block->link.prev_pagenum != INVALID_PGNUM) {
+		tmpblock = get_ptr_atomic(block->link.prev_pagenum,
+				block->link.prev_offset, KM_USER1);
+		tmpblock->link.next_pagenum = block->link.next_pagenum;
+		tmpblock->link.next_offset = block->link.next_offset;
+		put_ptr_atomic(tmpblock, KM_USER1);
+	}
+
+	if (block->link.next_pagenum != INVALID_PGNUM) {
+		tmpblock = get_ptr_atomic(block->link.next_pagenum,
+				block->link.next_offset, KM_USER1);
+		tmpblock->link.prev_pagenum = block->link.prev_pagenum;
+		tmpblock->link.prev_offset = block->link.prev_offset;
+		put_ptr_atomic(tmpblock, KM_USER1);
+	}
+
+	return;
+}
+
+/*
+ * Allocate a page and add it freelist of given pool.
+ */
+static int grow_pool(struct xv_pool *pool)
+{
+	u32 pagenum;
+	struct block_header *block;
+
+	pagenum = xv_alloc_page();
+	if (unlikely(pagenum == INVALID_PGNUM))
+		return -ENOMEM;
+
+	stat_inc(&pool->total_pages);
+
+	spin_lock(&pool->lock);
+	block = get_ptr_atomic(pagenum, 0, KM_USER0);
+
+	block->size = PAGE_SIZE - XV_ALIGN;
+	set_flag(block, BLOCK_FREE);
+	clear_flag(block, PREV_FREE);
+	set_blockprev(block, 0);
+
+	insert_block(pool, pagenum, 0, block);
+
+	put_ptr_atomic(block, KM_USER0);
+	spin_unlock(&pool->lock);
+
+	return 0;
+}
+
+/*
+ * Create a memory pool. Allocates freelist, bitmaps and other
+ * per-pool metadata.
+ */
+struct xv_pool *xv_create_pool(void)
+{
+	int i;
+	u32 ovhd_size;
+	struct xv_pool *pool;
+
+	ovhd_size = ROUNDUP(sizeof(*pool), PAGE_SIZE);
+	pool = kmalloc(ovhd_size, GFP_KERNEL);
+	if (!pool)
+		return NULL;
+
+	memset(pool, 0, ovhd_size);
+
+	for (i = 0; i < NUM_FREE_LISTS; i++)
+		pool->freelist[i].pagenum = INVALID_PGNUM;
+
+	spin_lock_init(&pool->lock);
+
+	return pool;
+}
+EXPORT_SYMBOL_GPL(xv_create_pool);
+
+void xv_destroy_pool(struct xv_pool *pool)
+{
+	kfree(pool);
+}
+EXPORT_SYMBOL_GPL(xv_destroy_pool);
+
+/**
+ * xvMalloc - Allocate block of given size from pool.
+ * @pool: pool to allocate from
+ * @size: size of block to allocate
+ * @pagenum: page no. that holds the object
+ * @offset: location of object within pagenum
+ *
+ * On success, <pagenum, offset> identifies block allocated
+ * and 0 is returned. On failure, <pagenum, offset> is not touched
+ * and -ENOMEM is returned.
+ *
+ * Allocation requests with size > XV_MAX_ALLOC_SIZE will fail.
+ */
+int xv_malloc(struct xv_pool *pool, u32 size, u32 *pagenum, u32 *offset)
+{
+	int error;
+	u32 index, tmpsize, origsize, tmpoffset;
+	struct block_header *block, *tmpblock = NULL;
+
+	*pagenum = INVALID_PGNUM;
+	*offset = 0;
+	origsize = size;
+
+	if (unlikely(!size || size > XV_MAX_ALLOC_SIZE))
+		return -ENOMEM;
+
+	if (unlikely(size < XV_MIN_ALLOC_SIZE))
+		size = XV_MIN_ALLOC_SIZE;
+	else
+		size = ROUNDUP_ALIGN(size);
+
+	spin_lock(&pool->lock);
+
+	index = find_block(pool, size, pagenum, offset);
+
+	if (*pagenum == INVALID_PGNUM) {
+		spin_unlock(&pool->lock);
+		error = grow_pool(pool);
+		if (unlikely(error))
+			return -ENOMEM;
+
+		spin_lock(&pool->lock);
+		index = find_block(pool, size, pagenum, offset);
+	}
+
+	if (*pagenum == INVALID_PGNUM) {
+		spin_unlock(&pool->lock);
+		return -ENOMEM;
+	}
+
+	block = get_ptr_atomic(*pagenum, *offset, KM_USER0);
+
+	remove_block_head(pool, block, index);
+
+	/* Split the block if required */
+	tmpoffset = *offset + size + XV_ALIGN;
+	tmpsize = block->size - size;
+	tmpblock = (struct block_header *)((char *)block + size + XV_ALIGN);
+	if (tmpsize) {
+		tmpblock->size = tmpsize - XV_ALIGN;
+		set_flag(tmpblock, BLOCK_FREE);
+		clear_flag(tmpblock, PREV_FREE);
+
+		set_blockprev(tmpblock, *offset);
+		if (tmpblock->size >= XV_MIN_ALLOC_SIZE)
+			insert_block(pool, *pagenum, tmpoffset, tmpblock);
+
+		if (tmpoffset + XV_ALIGN + tmpblock->size < PAGE_SIZE) {
+			tmpblock = BLOCK_NEXT(tmpblock);
+			set_blockprev(tmpblock, tmpoffset);
+		}
+	} else {
+		/* This block is exact fit */
+		if (tmpoffset < PAGE_SIZE)
+			clear_flag(tmpblock, PREV_FREE);
+	}
+
+	block->size = origsize;
+	clear_flag(block, BLOCK_FREE);
+
+	put_ptr_atomic(block, KM_USER0);
+	spin_unlock(&pool->lock);
+
+	*offset += XV_ALIGN;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xv_malloc);
+
+/*
+ * Free block identified with <pagenum, offset>
+ */
+void xv_free(struct xv_pool *pool, u32 pagenum, u32 offset)
+{
+	void *page;
+	struct block_header *block, *tmpblock;
+
+	offset -= XV_ALIGN;
+
+	spin_lock(&pool->lock);
+
+	page = get_ptr_atomic(pagenum, 0, KM_USER0);
+	block = (struct block_header *)((char *)page + offset);
+
+	if (unlikely(block->size < XV_MIN_ALLOC_SIZE))
+		block->size = XV_MIN_ALLOC_SIZE;
+	else
+		block->size = ROUNDUP_ALIGN(block->size);
+
+	tmpblock = BLOCK_NEXT(block);
+	if (offset + block->size + XV_ALIGN == PAGE_SIZE)
+		tmpblock = NULL;
+
+	/* Merge next block if its free */
+	if (tmpblock && test_flag(tmpblock, BLOCK_FREE)) {
+		/*
+		 * Blocks smaller than XV_MIN_ALLOC_SIZE
+		 * are not inserted in any free list.
+		 */
+		if (tmpblock->size >= XV_MIN_ALLOC_SIZE) {
+			remove_block(pool, pagenum,
+				    offset + block->size + XV_ALIGN, tmpblock,
+				    get_index_for_insert(tmpblock->size));
+		}
+		block->size += tmpblock->size + XV_ALIGN;
+	}
+
+	/* Merge previous block if its free */
+	if (test_flag(block, PREV_FREE)) {
+		tmpblock = (struct block_header *)((char *)(page) +
+						get_blockprev(block));
+		offset = offset - tmpblock->size - XV_ALIGN;
+
+		if (tmpblock->size >= XV_MIN_ALLOC_SIZE)
+			remove_block(pool, pagenum, offset, tmpblock,
+				    get_index_for_insert(tmpblock->size));
+
+		tmpblock->size += block->size + XV_ALIGN;
+		block = tmpblock;
+	}
+
+	/* No used objects in this page. Free it. */
+	if (block->size == PAGE_SIZE - XV_ALIGN) {
+		put_ptr_atomic(page, KM_USER0);
+		spin_unlock(&pool->lock);
+
+		xv_free_page(pagenum);
+		stat_dec(&pool->total_pages);
+		return;
+	}
+
+	set_flag(block, BLOCK_FREE);
+	insert_block(pool, pagenum, offset, block);
+
+	if (offset + block->size < PAGE_SIZE - XV_ALIGN) {
+		tmpblock = BLOCK_NEXT(block);
+		set_flag(tmpblock, PREV_FREE);
+		set_blockprev(tmpblock, offset);
+	}
+
+	put_ptr_atomic(page, KM_USER0);
+	spin_unlock(&pool->lock);
+
+	return;
+}
+EXPORT_SYMBOL_GPL(xv_free);
+
+u32 xv_get_object_size(void *obj)
+{
+	struct block_header *blk;
+
+	blk = (struct block_header *)((char *)(obj) - XV_ALIGN);
+	return blk->size;
+}
+EXPORT_SYMBOL_GPL(xv_get_object_size);
+
+/*
+ * Returns total memory used by allocator (userdata + metadata)
+ */
+u64 xv_get_total_size_bytes(struct xv_pool *pool)
+{
+	return pool->total_pages << PAGE_SHIFT;
+}
+EXPORT_SYMBOL_GPL(xv_get_total_size_bytes);
+
+static int __init xv_malloc_init(void)
+{
+	return 0;
+}
+
+static void __exit xv_malloc_exit(void)
+{
+	return;
+}
+
+module_init(xv_malloc_init);
+module_exit(xv_malloc_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Nitin Gupta <ngupta@vflare.org>");
+MODULE_DESCRIPTION("xvmalloc memory allocator");
diff --git a/mm/xvmalloc_int.h b/mm/xvmalloc_int.h
new file mode 100755
index 0000000..b7ece98
--- /dev/null
+++ b/mm/xvmalloc_int.h
@@ -0,0 +1,95 @@
+/*
+ * xvmalloc_int.c
+ *
+ * Copyright (C) 2008, 2009  Nitin Gupta
+ *
+ * This code is released using a dual license strategy: GPL/LGPL
+ * You can choose the licence that better fits your requirements.
+ *
+ * Released under the terms of the GNU General Public License Version 2.0
+ * Released under the terms of the GNU Lesser General Public License Version 2.1
+ */
+
+#ifndef _XVMALLOC_INT_H_
+#define _XVMALLOC_INT_H_
+
+#include <linux/types.h>
+
+#define INVALID_PGNUM	((u32)(-1))
+
+#define ROUNDUP(x, y)	(((x) + (y) - 1) / (y) * (y))
+/* Each individual bitmap is 32-bit */
+#define BITMAP_BITS	32
+#define BITMAP_SHIFT	5
+#define BITMAP_MASK	(BITMAP_BITS - 1)
+
+/* User configurable params */
+
+/* This must be greater than sizeof(LinkFree) */
+#define XV_MIN_ALLOC_SIZE       32
+#define XV_MAX_ALLOC_SIZE       (PAGE_SIZE - XV_ALIGN)
+
+/* Must be power of two */
+#define XV_ALIGN_SHIFT	2
+#define XV_ALIGN	(1 << XV_ALIGN_SHIFT)
+#define XV_ALIGN_MASK	(XV_ALIGN - 1)
+
+/* Free lists are separated by FL_DELTA bytes */
+#define FL_DELTA_SHIFT	3
+#define FL_DELTA	(1 << FL_DELTA_SHIFT)
+#define FL_DELTA_MASK	(FL_DELTA - 1)
+#define NUM_FREE_LISTS	((XV_MAX_ALLOC_SIZE - XV_MIN_ALLOC_SIZE) \
+				/ FL_DELTA + 1)
+
+#define MAX_FLI		(ROUNDUP(NUM_FREE_LISTS, 32) / 32)
+
+/* End of user params */
+
+#define ROUNDUP_ALIGN(x)	(((x) + XV_ALIGN_MASK) & ~XV_ALIGN_MASK)
+
+enum blockflags {
+	BLOCK_FREE,
+	PREV_FREE,
+	__NR_BLOCKFLAGS,
+};
+
+#define FLAGS_MASK	XV_ALIGN_MASK
+#define PREV_MASK	(~FLAGS_MASK)
+
+struct freelist_entry {
+	u32 pagenum;
+	u16 offset;
+	u16 pad;
+};
+
+struct link_free {
+	u32 prev_pagenum;
+	u32 next_pagenum;
+	u16 prev_offset;
+	u16 next_offset;
+};
+
+struct block_header {
+	union {
+		/* This common header must be ALIGN bytes */
+		u8 common[XV_ALIGN];
+		struct {
+			u16 size;
+			u16 prev;
+		};
+	};
+	struct link_free link;
+};
+
+struct xv_pool {
+	u32 flbitmap;
+	u32 slbitmap[MAX_FLI];
+	spinlock_t lock;
+
+	struct freelist_entry freelist[NUM_FREE_LISTS];
+
+	/* stats */
+	u64 total_pages;
+};
+
+#endif

