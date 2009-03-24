Return-Path: <linux-kernel-owner+w=401wt.eu-S1759879AbZCXTOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879AbZCXTOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757596AbZCXTOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:14:16 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:57020 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901AbZCXTOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:14:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OEU4vhL/RyhnEJUV4DgAIUk0t0T/rNCfU1vbEcd7mvxbfRooCF82VSo0KUEHygYcjB
         +zuyfYFhFzaA9L4uuna0n4nUdl9+Hjbr5q3pajXNOY648bjJHVvoawhlIMKyQXPx7jp9
         1X4u4WoElfH4AARSdQo5IRMA/XbMrPPDoOohI=
Message-ID: <49C9307B.90009@vflare.org>
Date: Wed, 25 Mar 2009 00:41:55 +0530
From: Nitin Gupta <nitingupta910@gmail.com>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] xvmalloc memory allocator
References: <49C92E14.5060802@vflare.org>
In-Reply-To: <49C92E14.5060802@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  drivers/block/xvmalloc.c     |  564 ++++++++++++++++++++++++++++++++++++++++++
  drivers/block/xvmalloc.h     |   27 ++
  drivers/block/xvmalloc_int.h |   86 +++++++
  3 files changed, 677 insertions(+), 0 deletions(-)

xvmalloc is a memory allocator designed specifically for ramzswap project.

* Features:
  - Low metadata overhead (just 4 bytes per object)
  - O(1) Alloc/Free - except when we have to call system page allocator to
     get additional memory.
  - Very low fragmentation: In all tests, xvMalloc memory usage is within 12%
     of "Ideal".

One of the main highlights is that it maps pages only when required.
So, it does not hog vmalloc area which is very small on 32-bit systems.

SLUB allocator could not be used due to fragmentation issues:
http://code.google.com/p/compcache/wiki/AllocatorsComparison
Data here shows kmalloc using ~43% more memory than TLSF and xvMalloc
is showed ~2% more space efficiency than TLSF (due to smaller metadata).
Creating various kmem_caches can reduce space efficiency gap but still
problem of being limited to low memory exists. Also, it depends on
allocating higher order pages to reduce fragmentation - this is not
acceptable for ramzswap as it is used under memory crunch (its a swap
device!).

SLOB allocator could not be used do to reasons mentioned here:
http://lkml.org/lkml/2009/3/18/210

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

diff --git a/drivers/block/xvmalloc.c b/drivers/block/xvmalloc.c
new file mode 100755
index 0000000..15ecce4
--- /dev/null
+++ b/drivers/block/xvmalloc.c
@@ -0,0 +1,564 @@
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
+
+#include "xvmalloc.h"
+#include "xvmalloc_int.h"
+
+static void stat_inc(u64 *value)
+{
+	(*value)++;
+}
+
+static void stat_dec(u64 *value)
+{
+	(*value)--;
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
+		return 0;
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
+	slbitmap = pool->slbitmap[slindex / BITS_PER_LONG];
+	slbitstart = slindex % BITS_PER_LONG;
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
+	if ((slbitstart != BITS_PER_LONG) && slbitmap) {
+		slindex += ffs(slbitmap);
+		*pagenum = pool->freelist[slindex].pagenum;
+		*offset = pool->freelist[slindex].offset;
+		return slindex;
+	}
+
+	/* Now do a full two-level bitmap search to find next nearest fit */
+	flindex = slindex / BITS_PER_LONG;
+
+	flbitmap = (pool->flbitmap) >> (flindex + 1);
+	if (!flbitmap)
+		return 0;
+
+	flindex += ffs(flbitmap);
+	slbitmap = pool->slbitmap[flindex];
+	slindex = (flindex * BITS_PER_LONG) + ffs(slbitmap) - 1;
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
+	flindex = slindex / BITS_PER_LONG;
+
+	block->link.prev_pagenum = 0;
+	block->link.prev_offset = 0;
+	block->link.next_pagenum = pool->freelist[slindex].pagenum;
+	block->link.next_offset = pool->freelist[slindex].offset;
+	pool->freelist[slindex].pagenum = pagenum;
+	pool->freelist[slindex].offset = offset;
+
+	if (block->link.next_pagenum) {
+		nextblock = get_ptr_atomic(block->link.next_pagenum,
+					block->link.next_offset, KM_USER1);
+		nextblock->link.prev_pagenum = pagenum;
+		nextblock->link.prev_offset = offset;
+		put_ptr_atomic(nextblock, KM_USER1);
+	}
+
+	__set_bit(slindex % BITS_PER_LONG, &pool->slbitmap[flindex]);
+	__set_bit(flindex, &pool->flbitmap);
+}
+
+/*
+ * Remove block from head of freelist. Index 'slindex' identifies the freelist.
+ */
+static void remove_block_head(struct xv_pool *pool,
+			struct block_header *block, u32 slindex)
+{
+	struct block_header *tmpblock;
+	u32 flindex = slindex / BITS_PER_LONG;
+
+	pool->freelist[slindex].pagenum = block->link.next_pagenum;
+	pool->freelist[slindex].offset = block->link.next_offset;
+	block->link.prev_pagenum = 0;
+	block->link.prev_offset = 0;
+
+	if (!pool->freelist[slindex].pagenum) {
+		__clear_bit(slindex % BITS_PER_LONG, &pool->slbitmap[flindex]);
+		if (!pool->slbitmap[flindex])
+			__clear_bit(flindex, &pool->flbitmap);
+	} else {
+		/*
+		 * DEBUG ONLY: We need not reinitialize freelist head previous
+		 * pointer to 0 - we never depend on its value. But just for
+		 * sanity, lets do it.
+		 */
+		tmpblock = get_ptr_atomic(pool->freelist[slindex].pagenum,
+				pool->freelist[slindex].offset, KM_USER1);
+		tmpblock->link.prev_pagenum = 0;
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
+	flindex = slindex / BITS_PER_LONG;
+
+	if (block->link.prev_pagenum) {
+		tmpblock = get_ptr_atomic(block->link.prev_pagenum,
+				block->link.prev_offset, KM_USER1);
+		tmpblock->link.next_pagenum = block->link.next_pagenum;
+		tmpblock->link.next_offset = block->link.next_offset;
+		put_ptr_atomic(tmpblock, KM_USER1);
+	}
+
+	if (block->link.next_pagenum) {
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
+	if (unlikely(!pagenum))
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
+	ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);
+	pool = kmalloc(ovhd_size, GFP_KERNEL);
+	if (!pool)
+		return NULL;
+
+	memset(pool, 0, ovhd_size);
+
+	for (i = 0; i < NUM_FREE_LISTS; i++) {
+		pool->freelist[i].pagenum = 0;
+		pool->freelist[i].offset = 0;
+	}
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
+	*pagenum = 0;
+	*offset = 0;
+	origsize = size;
+
+	if (unlikely(!size || size > XV_MAX_ALLOC_SIZE))
+		return -ENOMEM;
+
+	if (unlikely(size < XV_MIN_ALLOC_SIZE))
+		size = XV_MIN_ALLOC_SIZE;
+	else
+		size = ALIGN(size, XV_ALIGN);
+
+	spin_lock(&pool->lock);
+
+	index = find_block(pool, size, pagenum, offset);
+
+	if (!*pagenum) {
+		spin_unlock(&pool->lock);
+		error = grow_pool(pool);
+		if (unlikely(error))
+			return -ENOMEM;
+
+		spin_lock(&pool->lock);
+		index = find_block(pool, size, pagenum, offset);
+	}
+
+	if (!*pagenum) {
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
+		block->size = ALIGN(block->size, XV_ALIGN);
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
diff --git a/drivers/block/xvmalloc.h b/drivers/block/xvmalloc.h
new file mode 100755
index 0000000..27aeecb
--- /dev/null
+++ b/drivers/block/xvmalloc.h
@@ -0,0 +1,27 @@
+/*
+ * xvmalloc.h
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
+#ifndef _XVMALLOC_H_
+#define _XVMALLOC_H_
+
+struct xv_pool;
+
+struct xv_pool *xv_create_pool(void);
+void xv_destroy_pool(struct xv_pool *pool);
+
+int xv_malloc(struct xv_pool *pool, u32 size, u32 *pagenum, u32 *offset);
+void xv_free(struct xv_pool *pool, u32 pagenum, u32 offset);
+
+u32 xv_get_object_size(void *obj);
+u64 xv_get_total_size_bytes(struct xv_pool *pool);
+
+#endif
diff --git a/drivers/block/xvmalloc_int.h b/drivers/block/xvmalloc_int.h
new file mode 100755
index 0000000..5d68fba
--- /dev/null
+++ b/drivers/block/xvmalloc_int.h
@@ -0,0 +1,86 @@
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
+#include <linux/kernel.h>
+#include <linux/types.h>
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
+#define MAX_FLI		DIV_ROUND_UP(NUM_FREE_LISTS, BITS_PER_LONG)
+
+/* End of user params */
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
+	ulong flbitmap;
+	ulong slbitmap[MAX_FLI];
+	spinlock_t lock;
+
+	struct freelist_entry freelist[NUM_FREE_LISTS];
+
+	/* stats */
+	u64 total_pages;
+};
+
+#endif

