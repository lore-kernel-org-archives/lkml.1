Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZCQLin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZCQLin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 07:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbZCQLid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 07:38:33 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:44718 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618AbZCQLib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 07:38:31 -0400
Message-ID: <49BF8B8B.40408@vflare.org>
Date: Tue, 17 Mar 2009 17:07:47 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3]: xvmalloc memory allocator
References: <49BF8ABC.6040805@vflare.org>
In-Reply-To: <49BF8ABC.6040805@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 090316-0, 16-03-2009), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  include/linux/xvmalloc.h |   30 +++
  init/Kconfig             |   14 +
  mm/Makefile              |    1 +
  mm/xvmalloc.c            |  605 ++++++++++++++++++++++++++++++++++++++++++++++
  mm/xvmalloc_int.h        |   91 +++++++
  5 files changed, 741 insertions(+), 0 deletions(-)

xvMalloc is a memory allocator designed specifically for compcache project.

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

diff --git a/include/linux/xvmalloc.h b/include/linux/xvmalloc.h
new file mode 100755
index 0000000..92366bd
--- /dev/null
+++ b/include/linux/xvmalloc.h
@@ -0,0 +1,30 @@
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
+#define INVALID_POOL_ID	NULL
+#define INVALID_PGNUM	((u32)(-1))
+
+struct Pool;
+
+struct Pool *xvCreateMemPool(void);
+void xvDestroyMemPool(struct Pool *pool);
+
+int xvMalloc(struct Pool *pool, u32 size, u32 *pageNum, u32 *offset);
+void xvFree(struct Pool *pool, u32 pageNum, u32 offset);
+
+u32 xvGetObjectSize(void *obj);
+u64 xvGetTotalSizeBytes(struct Pool *pool);
+
+#endif
diff --git a/init/Kconfig b/init/Kconfig
index 6a5c5fe..5e722cc 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -930,6 +930,20 @@ config SLOB

  endchoice

+config XVMALLOC
+	tristate "xvMalloc memory allocator"
+	help
+	   This is a simple, low fragmentation, O(1) allocator.
+	   Details: http://code.google.com/p/compcache/wiki/xvMalloc
+
+config XVMALLOC_STATS
+	depends on XVMALLOC
+	bool "Collect statistics"
+	default y
+	help
+	  Collect basic allocator statistics with minimal overhead.
+	  In unsure, say Y.
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
index 0000000..3fcc012
--- /dev/null
+++ b/mm/xvmalloc.c
@@ -0,0 +1,605 @@
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
+#ifdef CONFIG_XVMALLOC_STATS
+static void statInc(u64 *value)
+{
+	*value = *value + 1;
+}
+
+static void statDec(u64 *value)
+{
+	*value = *value - 1;
+}
+#else
+#define statInc(x) do { } while (0)
+#define statDec(x) do { } while (0)
+#endif
+
+static void SetBit(u32 *value, u32 bitIdx)
+{
+	*value |= (u32)(1 << bitIdx);
+}
+
+static void ClearBit(u32 *value, u32 bitIdx)
+{
+	*value &= (u32)(~(1 << bitIdx));
+}
+
+static u32 IsBlockFree(struct BlockHeader *block)
+{
+	return block->prev & BLOCK_FREE;
+}
+
+static u32 IsPrevBlockFree(struct BlockHeader *block)
+{
+	return block->prev & PREV_FREE;
+}
+
+static void SetBlockFree(struct BlockHeader *block)
+{
+	block->prev |= BLOCK_FREE;
+}
+
+static void SetBlockPrevFree(struct BlockHeader *block)
+{
+	block->prev |= PREV_FREE;
+}
+
+static void SetBlockUsed(struct BlockHeader *block)
+{
+	block->prev &= ~BLOCK_FREE;
+}
+
+static void SetBlockPrevUsed(struct BlockHeader *block)
+{
+	block->prev &= ~PREV_FREE;
+}
+
+static u16 GetBlockPrev(struct BlockHeader *block)
+{
+	return block->prev & PREV_MASK;
+}
+
+static void SetBlockPrev(struct BlockHeader *block, u16 newOffset)
+{
+	block->prev = newOffset | (block->prev & FLAGS_MASK);
+}
+
+/*
+ * Get index of free list containing blocks of maximum size
+ * which is less than or equal to given size.
+ */
+static u32 GetIndexForInsert(u32 size)
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
+static u32 GetIndex(u32 size)
+{
+	size = (size + FL_DELTA_MASK) & ~FL_DELTA_MASK;
+	return (size - XV_MIN_ALLOC_SIZE) >> FL_DELTA_SHIFT;
+}
+
+/*
+ * Given <pageNum, offset> pair, provide a derefrencable pointer.
+ * This is called from xvMalloc/xvFree path, so it needs to be fast.
+ */
+static void *GetPtrAtomic(u32 pageNum, u16 offset, enum km_type type)
+{
+	unsigned char *pagePtr;
+
+	pagePtr = kmap_atomic(pfn_to_page(pageNum), type);
+	return pagePtr + offset;
+}
+
+static void PutPtrAtomic(void *ptr, enum km_type type)
+{
+	kunmap_atomic(ptr, type);
+}
+
+/*
+ * Allocate a memory page. Called when a pool needs to grow.
+ */
+static u32 AllocPage(void)
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
+static void FreePage(u32 pageNum)
+{
+	__free_page(pfn_to_page(pageNum));
+}
+
+/**
+ * FindBlock - find block of at least given size
+ * @pool: memory pool to search from
+ * @size: size of block required
+ * @pageNum: page no. containing required block
+ * @offset: offset within the page where block is located.
+ *
+ * Searches two level bitmap to locate block of at least
+ * the given size. If such a block is found, it provides
+ * <pageNum, offset> to identify this block and returns index
+ * in FreeList where we found this block.
+ * Otherwise, returns 0 and <pageNum, offset> params are not touched.
+ */
+static u32 FindBlock(struct Pool *pool, u32 size, u32 *pageNum, u32 *offset)
+{
+	u32 flBitmap, slBitmap;
+	u32 flIndex, slIndex, slBitStart;
+
+	/* There are no free blocks in this pool */
+	if (!pool->flBitmap)
+		return 0;
+
+	if (unlikely(size < XV_MIN_ALLOC_SIZE))
+		size = XV_MIN_ALLOC_SIZE;
+
+	/* Get FreeList index correspoding to this size */
+	slIndex = GetIndex(size);
+	slBitmap = pool->slBitmap[slIndex >> BITMAP_SHIFT];
+	slBitStart = slIndex & BITMAP_MASK;
+
+	/*
+	 * If FreeList is not empty at this index, we found the
+	 * block - head of this list. This is approximate best-fit match.
+	 */
+	if (slBitmap & (1 << slBitStart)) {
+		*pageNum = pool->FreeList[slIndex].pageNum;
+		*offset = pool->FreeList[slIndex].offset;
+		return slIndex;
+	}
+
+	/*
+	 * No best-fit found. Search a bit further in bitmap for a free block.
+	 * Second level bitmap consists of series of 32-bit chunks. Search
+	 * further in the chunk where we expected a best-fit, starting from
+	 * index location found above.
+	 */
+	slBitStart++;
+	slBitmap >>= slBitStart;
+
+	/* Skip this search if we were already at end of this bitmap chunk */
+	if ((slBitStart != BITMAP_BITS) && slBitmap) {
+		slIndex += ffs(slBitmap);
+		*pageNum = pool->FreeList[slIndex].pageNum;
+		*offset = pool->FreeList[slIndex].offset;
+		return slIndex;
+	}
+
+	/* Now do a full two-level bitmap search to find next nearest fit */
+	flIndex = slIndex >> BITMAP_SHIFT;
+
+	flBitmap = (pool->flBitmap) >> (flIndex + 1);
+	if (!flBitmap)
+		return 0;
+
+	flIndex += ffs(flBitmap);
+	slBitmap = pool->slBitmap[flIndex];
+	slIndex = (flIndex << BITMAP_SHIFT) + ffs(slBitmap) - 1;
+	*pageNum = pool->FreeList[slIndex].pageNum;
+	*offset = pool->FreeList[slIndex].offset;
+
+	return slIndex;
+}
+
+/*
+ * Insert block at <pageNum, offset> in freelist of given pool.
+ * FreeList used depends on block size.
+ */
+static void InsertBlock(struct Pool *pool, u32 pageNum, u32 offset,
+			struct BlockHeader *block)
+{
+	u32 flIndex, slIndex;
+	struct BlockHeader *nextBlock;
+
+	slIndex = GetIndexForInsert(block->size);
+	flIndex = slIndex >> BITMAP_SHIFT;
+
+	block->link.prevPageNum = INVALID_PGNUM;
+	block->link.prevOffset = 0;
+	block->link.nextPageNum = pool->FreeList[slIndex].pageNum;
+	block->link.nextOffset = pool->FreeList[slIndex].offset;
+	pool->FreeList[slIndex].pageNum = pageNum;
+	pool->FreeList[slIndex].offset = offset;
+
+	if (block->link.nextPageNum != INVALID_PGNUM) {
+		nextBlock = (struct BlockHeader *)GetPtrAtomic(
+				block->link.nextPageNum,
+				block->link.nextOffset, KM_USER1
+			);
+		nextBlock->link.prevPageNum = pageNum;
+		nextBlock->link.prevOffset = offset;
+		PutPtrAtomic(nextBlock, KM_USER1);
+	}
+
+	SetBit(&pool->slBitmap[flIndex], slIndex & BITMAP_MASK);
+	SetBit(&pool->flBitmap, flIndex);
+}
+
+/*
+ * Remove block from head of freelist. Index 'slIndex' identifies the FreeList.
+ */
+static void RemoveBlockHead(struct Pool *pool, struct BlockHeader *block,
+			    u32 slIndex)
+{
+	struct BlockHeader *tmpBlock;
+	u32 flIndex = slIndex >> BITMAP_SHIFT;
+
+	pool->FreeList[slIndex].pageNum = block->link.nextPageNum;
+	pool->FreeList[slIndex].offset = block->link.nextOffset;
+	block->link.prevPageNum = INVALID_PGNUM;
+	block->link.prevOffset = 0;
+
+	if (pool->FreeList[slIndex].pageNum == INVALID_PGNUM) {
+		ClearBit(&pool->slBitmap[flIndex], slIndex & BITMAP_MASK);
+		if (!pool->slBitmap[flIndex])
+			ClearBit(&pool->flBitmap, flIndex);
+	} else {
+		/*
+		 * DEBUG ONLY: We need not reinitialize freelist head previous
+		 * pointer to INVALID_PGNUM - we never depend on its value.
+		 * But just for sanity, lets keep it.
+		 */
+		tmpBlock = (struct BlockHeader *)GetPtrAtomic(
+				pool->FreeList[slIndex].pageNum,
+				pool->FreeList[slIndex].offset, KM_USER1
+			);
+		tmpBlock->link.prevPageNum = INVALID_PGNUM;
+		tmpBlock->link.prevOffset = 0;
+		PutPtrAtomic(tmpBlock, KM_USER1);
+	}
+}
+
+/*
+ * Remove block from freelist. Index 'slIndex' identifies the FreeList.
+ */
+static void RemoveBlock(struct Pool *pool, u32 pageNum, u32 offset,
+			struct BlockHeader *block, u32 slIndex)
+{
+	u32 flIndex;
+	struct BlockHeader *tmpBlock;
+
+	if (pool->FreeList[slIndex].pageNum == pageNum
+	   && pool->FreeList[slIndex].offset == offset) {
+		RemoveBlockHead(pool, block, slIndex);
+		return;
+	}
+
+	flIndex = slIndex >> BITMAP_SHIFT;
+
+	if (block->link.prevPageNum != INVALID_PGNUM) {
+		tmpBlock = (struct BlockHeader *)GetPtrAtomic(
+				block->link.prevPageNum,
+				block->link.prevOffset, KM_USER1
+			);
+		tmpBlock->link.nextPageNum = block->link.nextPageNum;
+		tmpBlock->link.nextOffset = block->link.nextOffset;
+		PutPtrAtomic(tmpBlock, KM_USER1);
+	}
+
+	if (block->link.nextPageNum != INVALID_PGNUM) {
+		tmpBlock = (struct BlockHeader *)GetPtrAtomic(
+				block->link.nextPageNum,
+				block->link.nextOffset, KM_USER1
+			);
+		tmpBlock->link.prevPageNum = block->link.prevPageNum;
+		tmpBlock->link.prevOffset = block->link.prevOffset;
+		PutPtrAtomic(tmpBlock, KM_USER1);
+	}
+
+	return;
+}
+
+/*
+ * Allocate a page and add it FreeList of given pool.
+ */
+static int GrowPool(struct Pool *pool)
+{
+	u32 pageNum;
+	struct BlockHeader *block;
+
+	pageNum = AllocPage();
+	if (unlikely(pageNum == INVALID_PGNUM))
+		return -ENOMEM;
+
+	statInc(&pool->totalPages);
+
+	spin_lock(&pool->lock);
+	block = GetPtrAtomic(pageNum, 0, KM_USER0);
+
+	block->size = PAGE_SIZE - XV_ALIGN;
+	SetBlockFree(block);
+	SetBlockPrevUsed(block);
+	SetBlockPrev(block, 0);
+
+	InsertBlock(pool, pageNum, 0, block);
+
+	PutPtrAtomic(block, KM_USER0);
+	spin_unlock(&pool->lock);
+
+	return 0;
+}
+
+/*
+ * Create a memory pool. Allocates FreeList, bitmaps and other
+ * per-pool metadata.
+ */
+struct Pool *xvCreateMemPool(void)
+{
+	int i;
+	void *ovhdMem;
+	struct Pool *pool;
+	u32 poolOvhd;
+
+	poolOvhd = ROUNDUP(sizeof(*pool), PAGE_SIZE);
+	ovhdMem = kmalloc(poolOvhd, GFP_KERNEL);
+	if (!ovhdMem)
+		return INVALID_POOL_ID;
+
+	pool = ovhdMem;
+	memset(pool, 0, poolOvhd);
+
+	for (i = 0; i < NUM_FREE_LISTS; i++)
+		pool->FreeList[i].pageNum = INVALID_PGNUM;
+
+	spin_lock_init(&pool->lock);
+
+	return pool;
+}
+EXPORT_SYMBOL_GPL(xvCreateMemPool);
+
+void xvDestroyMemPool(struct Pool *pool)
+{
+	kfree(pool);
+}
+EXPORT_SYMBOL_GPL(xvDestroyMemPool);
+
+/**
+ * xvMalloc - Allocate block of given size from pool.
+ * @pool: pool to allocate from
+ * @size: size of block to allocate
+ * @pageNum: page no. that holds the object
+ * @offset: location of object within pageNum
+ *
+ * On success, <pageNum, offset> identifies block allocated
+ * and 0 is returned. On failure, <pageNum, offset> is not touched
+ * and -ENOMEM is returned.
+ *
+ * Allocation requests with size > XV_MAX_ALLOC_SIZE will fail.
+ */
+int xvMalloc(struct Pool *pool, u32 size, u32 *pageNum, u32 *offset)
+{
+	int error;
+	u32 index, tmpSize, origSize, tmpOffset;
+	struct BlockHeader *block, *tmpBlock = NULL;
+
+	*pageNum = INVALID_PGNUM;
+	*offset = 0;
+	origSize = size;
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
+	index = FindBlock(pool, size, pageNum, offset);
+
+	if (*pageNum == INVALID_PGNUM) {
+		spin_unlock(&pool->lock);
+		error = GrowPool(pool);
+		if (unlikely(error))
+			return -ENOMEM;
+
+		spin_lock(&pool->lock);
+		index = FindBlock(pool, size, pageNum, offset);
+	}
+
+	if (*pageNum == INVALID_PGNUM) {
+		spin_unlock(&pool->lock);
+		return -ENOMEM;
+	}
+
+	block = (struct BlockHeader *)GetPtrAtomic(
+				*pageNum, *offset, KM_USER0);
+
+	RemoveBlockHead(pool, block, index);
+
+	/* Split the block if required */
+	tmpOffset = *offset + size + XV_ALIGN;
+	tmpSize = block->size - size;
+	tmpBlock = (struct BlockHeader *)((char *)block + size + XV_ALIGN);
+	if (tmpSize) {
+		tmpBlock->size = tmpSize - XV_ALIGN;
+		SetBlockFree(tmpBlock);
+		SetBlockPrevUsed(tmpBlock);
+
+		SetBlockPrev(tmpBlock, *offset);
+		if (tmpBlock->size >= XV_MIN_ALLOC_SIZE)
+			InsertBlock(pool, *pageNum, tmpOffset, tmpBlock);
+
+		if (tmpOffset + XV_ALIGN + tmpBlock->size < PAGE_SIZE) {
+			tmpBlock = (struct BlockHeader *)((char *)tmpBlock
+						+ tmpBlock->size + XV_ALIGN);
+
+			SetBlockPrev(tmpBlock, tmpOffset);
+		}
+	} else {
+		/* This block is exact fit */
+		if (tmpOffset < PAGE_SIZE)
+			SetBlockPrevUsed(tmpBlock);
+	}
+
+	block->size = origSize;
+	SetBlockUsed(block);
+
+	PutPtrAtomic(block, KM_USER0);
+	spin_unlock(&pool->lock);
+
+	*offset += XV_ALIGN;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xvMalloc);
+
+/*
+ * Free block identified with <pageNum, offset>
+ */
+void xvFree(struct Pool *pool, u32 pageNum, u32 offset)
+{
+	void *page;
+	struct BlockHeader *block, *tmpBlock;
+
+	offset -= XV_ALIGN;
+
+	spin_lock(&pool->lock);
+
+	page = GetPtrAtomic(pageNum, 0, KM_USER0);
+	block = (struct BlockHeader *)((char *)page + offset);
+
+	if (unlikely(block->size < XV_MIN_ALLOC_SIZE))
+		block->size = XV_MIN_ALLOC_SIZE;
+	else
+		block->size = ROUNDUP_ALIGN(block->size);
+
+	tmpBlock = (struct BlockHeader *)((char *)block +
+					block->size + XV_ALIGN);
+	if (offset + block->size + XV_ALIGN == PAGE_SIZE)
+		tmpBlock = NULL;
+
+	/* Merge next block if its free */
+	if (tmpBlock && IsBlockFree(tmpBlock)) {
+		/*
+		 * Blocks smaller than XV_MIN_ALLOC_SIZE
+		 * are not inserted in any free list.
+		 */
+		if (tmpBlock->size >= XV_MIN_ALLOC_SIZE) {
+			RemoveBlock(pool, pageNum,
+				    offset + block->size + XV_ALIGN, tmpBlock,
+				    GetIndexForInsert(tmpBlock->size));
+		}
+		block->size += tmpBlock->size + XV_ALIGN;
+	}
+
+	/* Merge previous block if its free */
+	if (IsPrevBlockFree(block)) {
+		tmpBlock = (struct BlockHeader *)((char *)(page) +
+						GetBlockPrev(block));
+		offset = offset - tmpBlock->size - XV_ALIGN;
+
+		if (tmpBlock->size >= XV_MIN_ALLOC_SIZE)
+			RemoveBlock(pool, pageNum, offset, tmpBlock,
+				    GetIndexForInsert(tmpBlock->size));
+
+		tmpBlock->size += block->size + XV_ALIGN;
+		block = tmpBlock;
+	}
+
+	/* No used objects in this page. Free it. */
+	if (block->size == PAGE_SIZE - XV_ALIGN) {
+		PutPtrAtomic(page, KM_USER0);
+		spin_unlock(&pool->lock);
+
+		FreePage(pageNum);
+		statDec(&pool->totalPages);
+		return;
+	}
+
+	SetBlockFree(block);
+	InsertBlock(pool, pageNum, offset, block);
+
+	if (offset + block->size < PAGE_SIZE - XV_ALIGN) {
+		tmpBlock = (struct BlockHeader *)((char *)(block) +
+						block->size + XV_ALIGN);
+		SetBlockPrevFree(tmpBlock);
+		SetBlockPrev(tmpBlock, offset);
+	}
+
+	PutPtrAtomic(page, KM_USER0);
+	spin_unlock(&pool->lock);
+
+	return;
+}
+EXPORT_SYMBOL_GPL(xvFree);
+
+u32 xvGetObjectSize(void *obj)
+{
+	struct BlockHeader *blk;
+
+	blk = (struct BlockHeader *)((char *)(obj) - XV_ALIGN);
+	return blk->size;
+}
+EXPORT_SYMBOL_GPL(xvGetObjectSize);
+
+/*
+ * Returns total memory used by allocator (userdata + metadata)
+ */
+u64 xvGetTotalSizeBytes(struct Pool *pool)
+{
+#ifdef CONFIG_XVMALLOC_STATS
+	return pool->totalPages << PAGE_SHIFT;
+#else
+	return 0;
+#endif
+}
+EXPORT_SYMBOL_GPL(xvGetTotalSizeBytes);
+
+static int __init xvMallocInit(void)
+{
+	return 0;
+}
+
+static void __exit xvMallocExit(void)
+{
+	return;
+}
+
+module_init(xvMallocInit);
+module_exit(xvMallocExit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Nitin Gupta <ngupta@vflare.org>");
+MODULE_DESCRIPTION("xvMalloc Memory Allocator");
diff --git a/mm/xvmalloc_int.h b/mm/xvmalloc_int.h
new file mode 100755
index 0000000..5c648ee
--- /dev/null
+++ b/mm/xvmalloc_int.h
@@ -0,0 +1,91 @@
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
+#define XV_MAX_ALLOC_SIZE       (4096 - XV_MIN_ALLOC_SIZE)
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
+#define BLOCK_FREE	0x1
+#define PREV_FREE	0x2
+#define FLAGS_MASK	XV_ALIGN_MASK
+#define PREV_MASK	(~FLAGS_MASK)
+
+struct FreeListEntry {
+	u32 pageNum;
+	u16 offset;
+	u16 pad;
+};
+
+struct LinkFree {
+	u32 prevPageNum;
+	u32 nextPageNum;
+	u16 prevOffset;
+	u16 nextOffset;
+};
+
+struct BlockHeader {
+	union {
+		/* This common header must be ALIGN bytes */
+		u8 common[XV_ALIGN];
+		struct {
+			u16 size;
+			u16 prev;
+		};
+	};
+	struct LinkFree link;
+};
+
+struct Pool {
+	u32 flBitmap;
+	u32 slBitmap[MAX_FLI];
+	spinlock_t lock;
+
+	struct FreeListEntry FreeList[NUM_FREE_LISTS];
+
+	/* stats */
+#ifdef CONFIG_XVMALLOC_STATS
+	u64 totalPages;
+#endif
+};
+
+#endif

