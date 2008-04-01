Return-Path: <linux-kernel-owner+w=401wt.eu-S1761909AbYDCRN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761909AbYDCRN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760333AbYDCRLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:11:06 -0400
Received: from lazybastard.de ([212.112.238.170]:43613 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589AbYDCRKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:10:48 -0400
Message-Id: <20080401181332.853833011@logfs.org>
References: <20080401181308.512473173@logfs.org>
Date: Tue, 01 Apr 2008 20:13:08 +0200
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Cc: Nick Piggin <npiggin@suse.de>
Subject: [patch 11/15] fs/logfs/readwrite.c
From: joern@logfs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2008-04-02 16:29:12.813336657 +0200
+++ linux-2.6.24logfs/fs/logfs/readwrite.c	2008-04-02 00:01:54.545819992 +0200
@@ -0,0 +1,1618 @@
+/*
+ * fs/logfs/readwrite.c
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ *
+ *
+ * Actually contains five sets of very similar functions:
+ * read		read blocks from a file
+ * seek_hole	find next hole
+ * seek_data	find next data block
+ * valid	check whether a block still belongs to a file
+ * write	write blocks to a file
+ * delete	delete a block (for directories and ifile)
+ * rewrite	move existing blocks of a file to a new location (gc helper)
+ * truncate	truncate a file
+ */
+#include "logfs.h"
+
+static int adjust_level(int level)
+{
+	if (level >= LOGFS_MAX_LEVELS)
+		level -= LOGFS_MAX_LEVELS;
+	WARN_ON(level >= LOGFS_MAX_LEVELS);
+	return level;
+}
+
+static u64 adjust_bix(u64 bix, u8 level)
+{
+	switch (adjust_level(level)) {
+	case 0:
+		return bix;
+	case 1:
+		return max_t(u64, bix, I0_BLOCKS);
+	case 2:
+		return max_t(u64, bix, I1_BLOCKS);
+	case 3:
+		return max_t(u64, bix, I2_BLOCKS);
+	default:
+		WARN_ON(1);
+		return bix;
+	}
+}
+
+/**
+ * The inode address space is cut in two halves.  Lower half belongs to data
+ * pages, upper half to indirect blocks.  If the high bit (INDIRECT_BIT) is
+ * set, the actual block index (bix) and level can be derived from the page
+ * index.
+ *
+ * The lowest three bits of the block index are set to 0 after packing and
+ * unpacking.  Since the lowest n bits (9 for 4KiB blocksize) are ignored
+ * anyway this is harmless.
+ */
+#define ARCH_SHIFT	(BITS_PER_LONG - 32)
+#define INDIRECT_BIT	(0x80000000UL << ARCH_SHIFT)
+#define LEVEL_SHIFT	(28 + ARCH_SHIFT)
+static pgoff_t logfs_pack_index(u64 bix, u8 level)
+{
+	pgoff_t index;
+
+	BUG_ON(bix >= INDIRECT_BIT);
+	BUG_ON(level > 7);
+	if (level == 0)
+		return bix;
+
+	index  = INDIRECT_BIT;
+	index |= (long)level << LEVEL_SHIFT;
+	index |= bix >> (level*LOGFS_BLOCK_BITS);
+	return index;
+}
+
+void logfs_unpack_index(pgoff_t index, u64 *bix, u8 *level)
+{
+	if (!(index & INDIRECT_BIT)) {
+		*bix = index;
+		*level = 0;
+		return;
+	}
+
+	*level = (index & ~INDIRECT_BIT) >> LEVEL_SHIFT;
+	*bix = (index << (*level*LOGFS_BLOCK_BITS)) & ~INDIRECT_BIT;
+	*bix = adjust_bix(*bix, *level);
+	return;
+}
+#undef ARCH_SHIFT
+#undef INDIRECT_BIT
+#undef LEVEL_SHIFT
+
+/**
+ * logfs_flush_dirty - flush dirty blocks
+ * @sb:		filesystem superblock
+ * @sync:	if 0, only flush enough to continue writing,
+ * 		if 1, completely flush list
+ */
+void logfs_flush_dirty(struct super_block *sb, int sync)
+{
+	struct logfs_super *super = logfs_super(sb);
+	u64 bytes = LOGFS_MAX_LEVELS * LOGFS_MAX_OBJECTSIZE;
+	struct logfs_block *block;
+	struct page *page;
+	struct inode *inode;
+	int ret;
+
+	while (super->s_dirty_free_bytes || super->s_dirty_used_bytes) {
+		if (!sync && (super->s_free_bytes >= bytes + super->s_gc_reserve
+				+ super->s_dirty_free_bytes))
+			break;
+
+		BUG_ON(list_empty(&super->s_dirty_list));
+		block = list_entry(super->s_dirty_list.next, struct logfs_block,
+				dirty_list);
+		page = block->page;
+		inode = page->mapping->host;
+		ret = logfs_write_buf(inode, page, NULL, 0);
+		BUG_ON(ret);
+		/* We may need to GC some more after writing a page */
+		logfs_gc_pass(sb);
+	}
+}
+
+/*
+ * Logfs is prone to an AB-BA deadlock where one task tries to acquire
+ * s_w_mutex with a locked page and GC tries to get that page while holding
+ * s_w_mutex.
+ * To solve this issue logfs will ignore the page lock iff the page in question
+ * is waiting for s_w_mutex.  We annotate this fact by setting PG_pre_locked
+ * in addition to PG_locked.
+ *
+ * FIXME: Logfs already uses PG_owner_priv_1 for other purposes and there is
+ * no PG_owner_priv_2.  Currently we abuse the (hopefully) free flag 18.  But
+ * that flag may get reused any minute.  In fact, Christoph Lameter recently
+ * sent a patchset to reshuffle page flags.  Highly dangerous.
+ */
+#define PG_pre_locked		18
+#define PagePreLocked(page)	test_bit(PG_pre_locked, &(page)->flags)
+#define SetPagePreLocked(page)	set_bit(PG_pre_locked, &(page)->flags)
+#define ClearPagePreLocked(page) clear_bit(PG_pre_locked, &(page)->flags)
+static void logfs_get_wblocks(struct super_block *sb, struct page *page,
+		int lock)
+{
+	if (lock) {
+		struct logfs_super *super = logfs_super(sb);
+
+		if (page)
+			SetPagePreLocked(page);
+		mutex_lock(&super->s_w_mutex);
+		super->s_write_page = page;
+		logfs_gc_pass(sb);
+		/* FIXME: We also have to check for shadowed space
+		 * and mempool fill grade */
+		logfs_flush_dirty(sb, 0);
+	}
+}
+
+static void logfs_put_wblocks(struct super_block *sb, struct page *page,
+		int lock)
+{
+	if (lock) {
+		logfs_super(sb)->s_write_page = NULL;
+		/* Order matters - we must clear PG_pre_locked before releasing
+		 * s_w_mutex or we could race against another task. */
+		if (page)
+			ClearPagePreLocked(page);
+		mutex_unlock(&logfs_super(sb)->s_w_mutex);
+	}
+}
+
+static struct page *logfs_get_read_page(struct inode *inode, u64 bix, u8 level)
+{
+	return find_or_create_page(inode->i_mapping,
+			logfs_pack_index(bix, level), GFP_NOFS);
+}
+
+static void logfs_put_read_page(struct page *page)
+{
+	unlock_page(page);
+	page_cache_release(page);
+}
+
+static struct page *logfs_get_page(struct inode *inode, u64 bix, u8 level)
+{
+	struct address_space *mapping = inode->i_mapping;
+	pgoff_t index = logfs_pack_index(bix, level);
+	struct page *page;
+	int err;
+	int loop = 0;
+
+repeat:
+	page = find_get_page(mapping, index);
+	if (!page) {
+		page = __page_cache_alloc(GFP_NOFS);
+		if (!page)
+			return NULL;
+		err = add_to_page_cache_lru(page, mapping, index, GFP_NOFS);
+		if (unlikely(err)) {
+			page_cache_release(page);
+			if (err == -EEXIST)
+				goto repeat;
+			return NULL;
+		}
+	} else while (unlikely(TestSetPageLocked(page))) {
+		if (PagePreLocked(page)) {
+			/* Holder of page lock is waiting for us, it
+			 * is safe to use this page. */
+			return page;
+		}
+		if (loop++ > 0x1000) {
+			/* Has been observed once so far... */
+			printk(KERN_ERR "stack at %p\n", &loop);
+			BUG();
+		}
+		/* Some other process has this page locked and has
+		 * nothing to do with us.  Wait for it to finish.
+		 */
+		schedule();
+	}
+	return page;
+}
+
+static void logfs_put_page(struct inode *inode, struct page *page)
+{
+	if (likely(!PagePreLocked(page)))
+		unlock_page(page);
+	page_cache_release(page);
+}
+
+static struct page *logfs_get_write_page(struct inode *inode, u64 bix, u8 level)
+{
+	struct page *write_page = logfs_super(inode->i_sb)->s_write_page;
+	pgoff_t index = logfs_pack_index(bix, level);
+
+	if (write_page && (inode->i_mapping == write_page->mapping)
+			&& (index == write_page->index))
+		return write_page;
+	else
+		return logfs_get_page(inode, bix, level);
+}
+
+static void logfs_put_write_page(struct inode *inode, struct page *page)
+{
+	struct page *write_page = logfs_super(inode->i_sb)->s_write_page;
+
+	if (page != write_page)
+		logfs_put_page(inode, page);
+}
+
+static unsigned long __get_bits(u64 val, int skip, int no)
+{
+	u64 ret = val;
+
+	ret >>= skip * no;
+	ret <<= 64 - no;
+	ret >>= 64 - no;
+	return ret;
+}
+
+static unsigned long get_bits(u64 val, int skip)
+{
+	return __get_bits(val, skip, LOGFS_BLOCK_BITS);
+}
+
+/*
+ * Returns:
+ * 0 if all pointers are NUL
+ * -1 if all pointers have LOGFS_FULLY_POPULATED set
+ * 1 if at least one pointer is non-NUL and
+ *      at least one has LOGFS_FULLY_POPULATED cleared
+ */
+enum blockstate {
+	bs_fully_populated	= -1,
+	bs_all_zero		= 0,
+	bs_mixed		= 1,
+};
+
+static int block_state(__be64 *block)
+{
+	int i;
+
+	if (block[0]) {
+		for (i = 1; i < LOGFS_BLOCK_FACTOR; i++)
+			if (!(block[i] & cpu_to_be64(LOGFS_FULLY_POPULATED)))
+				return bs_mixed;
+		return bs_fully_populated;
+	} else {
+		for (i = 1; i < LOGFS_BLOCK_FACTOR; i++)
+			if (block[i])
+				return bs_mixed;
+		return bs_all_zero;
+	}
+}
+
+static int page_state(struct page *page)
+{
+	__be64 *block;
+	int ret;
+
+	block = kmap_atomic(page, KM_USER0);
+	ret = block_state(block);
+	kunmap_atomic(block, KM_USER0);
+	return ret;
+}
+
+static void alloc_block(struct page *page)
+{
+	struct logfs_super *super = logfs_super(page->mapping->host->i_sb);
+	struct logfs_block *block;
+
+	if (PagePrivate(page))
+		return;
+
+	block = mempool_alloc(super->s_block_pool, GFP_KERNEL);
+	INIT_LIST_HEAD(&block->dirty_list);
+	block->page = page;
+	SetPagePrivate(page);
+	page->private = (unsigned long)block;
+}
+
+static struct shadow_tree *logfs_page_to_tree(struct page *page)
+{
+	alloc_block(page);
+	return &logfs_block(page)->shadow_tree;
+}
+
+static void block_set_pointer(struct page *page, int index, u64 ptr)
+{
+	__be64 *block;
+
+	block = kmap_atomic(page, KM_USER0);
+	block[index] = cpu_to_be64(ptr);
+	flush_dcache_page(page);
+	kunmap_atomic(block, KM_USER0);
+	SetPageUptodate(page);
+}
+
+static u64 block_get_pointer(struct page *page, int index)
+{
+	__be64 *block;
+	u64 ptr;
+
+	block = kmap_atomic(page, KM_USER0);
+	ptr = be64_to_cpu(block[index]);
+	kunmap_atomic(block, KM_USER0);
+	return ptr;
+}
+
+static int logfs_read_empty(struct page *page)
+{
+	zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+	SetPageZero(page);
+	return 0;
+}
+
+static int logfs_read_embedded(struct page *page, struct inode *inode)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	void *buf;
+
+	buf = kmap_atomic(page, KM_USER0);
+	memcpy(buf, li->li_data, LOGFS_EMBEDDED_SIZE);
+	memset(buf + LOGFS_EMBEDDED_SIZE, 0,
+			PAGE_CACHE_SIZE - LOGFS_EMBEDDED_SIZE);
+	flush_dcache_page(page);
+	kunmap_atomic(buf, KM_USER0);
+	return 0;
+}
+
+static int logfs_read_direct(struct inode *inode, struct page *page)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	pgoff_t index = page->index;
+	u64 block;
+
+	block = li->li_data[index];
+	if (!block)
+		return logfs_read_empty(page);
+
+	return logfs_segment_read(inode, page, block, index, 0);
+}
+
+static int logfs_read_loop(struct inode *inode, struct page *page, int count)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	u64 bofs = li->li_data[I1_INDEX + count];
+	pgoff_t bix = page->index;
+	int level, ret;
+	struct page *ipage;
+
+	if (!bofs)
+		return logfs_read_empty(page);
+
+	for (level = count + 1; level > 0; level--) {
+		ipage = logfs_get_read_page(inode, bix, level);
+		if (!ipage)
+			return -ENOMEM;
+
+		ret = logfs_segment_read(inode, ipage, bofs, bix, level);
+		if (ret) {
+			logfs_put_read_page(ipage);
+			return ret;
+		}
+
+		bofs = block_get_pointer(ipage, get_bits(bix, level-1));
+		logfs_put_read_page(ipage);
+		if (!bofs)
+			return logfs_read_empty(page);
+	}
+
+	return logfs_segment_read(inode, page, bofs, bix, 0);
+}
+
+static int logfs_read_block(struct inode *inode, struct page *page)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	pgoff_t index = page->index;
+
+	if (li->li_flags & LOGFS_IF_EMBEDDED) {
+		if (index != 0)
+			return logfs_read_empty(page);
+		else
+			return logfs_read_embedded(page, inode);
+	} else if (index < I0_BLOCKS)
+		return logfs_read_direct(inode, page);
+	else if (index < I1_BLOCKS)
+		return logfs_read_loop(inode, page, 0);
+	else if (index < I2_BLOCKS)
+		return logfs_read_loop(inode, page, 1);
+	else if (index < I3_BLOCKS)
+		return logfs_read_loop(inode, page, 2);
+
+	BUG();
+	return -EIO;
+}
+
+static u64 seek_holedata_direct(struct inode *inode, u64 bix, int data)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+
+	for (; bix < I0_BLOCKS; bix++)
+		if (data ^ (li->li_data[bix] == 0))
+			return bix;
+	return I0_BLOCKS;
+}
+
+static u64 seek_holedata_loop(struct inode *inode, u64 bix, int count, int data)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	__be64 *rblock;
+	u64 bofs = li->li_data[I1_INDEX + count];
+	int level, ret, slot;
+	struct page *page;
+
+	BUG_ON(!bofs);
+
+	for (level = count + 1; level > 0; level--) {
+		page = logfs_get_read_page(inode, bix, level);
+		if (!page)
+			return bix;
+
+		ret = logfs_segment_read(inode, page, bofs, bix, level);
+		if (ret) {
+			logfs_put_read_page(page);
+			return bix;
+		}
+
+		slot = get_bits(bix, level-1);
+		rblock = kmap_atomic(page, KM_USER0);
+		while (slot < LOGFS_BLOCK_FACTOR) {
+			if (data && (rblock[slot] != 0))
+				break;
+			if (!data && !(be64_to_cpu(rblock[slot]) & LOGFS_FULLY_POPULATED))
+				break;
+			slot++;
+			bix += 1 << (LOGFS_BLOCK_BITS * (level-1));
+		}
+		if (slot >= LOGFS_BLOCK_FACTOR) {
+			kunmap_atomic(rblock, KM_USER0);
+			logfs_put_read_page(page);
+			return bix;
+		}
+		bofs = be64_to_cpu(rblock[slot]);
+		kunmap_atomic(rblock, KM_USER0);
+		logfs_put_read_page(page);
+		if (!bofs) {
+			BUG_ON(data);
+			return bix;
+		}
+	}
+	return bix;
+}
+
+/**
+ * logfs_seek_hole - find next hole starting at a given block index
+ * @inode:		inode to search in
+ * @bix:		block index to start searching
+ *
+ * Returns next hole.  If the file doesn't contain any further holes, the
+ * block address next to eof is returned instead.
+ */
+u64 logfs_seek_hole(struct inode *inode, u64 bix)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+
+	if (li->li_flags & LOGFS_IF_EMBEDDED)
+		return 1;
+
+	if (bix < I0_BLOCKS) {
+		bix = seek_holedata_direct(inode, bix, 0);
+		if (bix < I0_BLOCKS)
+			return bix;
+	}
+
+#define SEEK_HOLE_LOOP_WRAPPER(index, blocks, count) do {		\
+	if (bix < blocks) {						\
+		if (!li->li_data[index])				\
+			return bix;					\
+		else if (li->li_data[index] & LOGFS_FULLY_POPULATED)	\
+			bix = blocks;					\
+		else {							\
+			bix = seek_holedata_loop(inode, bix, count, 0);	\
+			if (bix < blocks)				\
+				return bix;				\
+			/* LOGFS_FULLY_POPULATED should have been set */\
+			WARN_ON_ONCE(bix == blocks);			\
+		}							\
+	}								\
+} while (0)
+	SEEK_HOLE_LOOP_WRAPPER(I1_INDEX, I1_BLOCKS, 0);
+	SEEK_HOLE_LOOP_WRAPPER(I2_INDEX, I2_BLOCKS, 1);
+	SEEK_HOLE_LOOP_WRAPPER(I3_INDEX, I3_BLOCKS, 2);
+#undef SEEK_HOLE_LOOP_WRAPPER
+
+	return bix;
+}
+
+static u64 __logfs_seek_data(struct inode *inode, u64 bix)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+
+	if (li->li_flags & LOGFS_IF_EMBEDDED)
+		return bix;
+
+	if (bix < I0_BLOCKS) {
+		bix = seek_holedata_direct(inode, bix, 1);
+		if (bix < I0_BLOCKS)
+			return bix;
+	}
+
+#define SEEK_DATA_LOOP_WRAPPER(index, blocks, count) do {		\
+	if (bix < blocks) {						\
+		if (!li->li_data[index])				\
+			bix = blocks;					\
+		else							\
+			return seek_holedata_loop(inode, bix, count, 1);\
+	}								\
+} while (0)
+	SEEK_DATA_LOOP_WRAPPER(I1_INDEX, I1_BLOCKS, 0);
+	SEEK_DATA_LOOP_WRAPPER(I2_INDEX, I2_BLOCKS, 1);
+	SEEK_DATA_LOOP_WRAPPER(I3_INDEX, I3_BLOCKS, 2);
+#undef SEEK_DATA_LOOP_WRAPPER
+
+	return bix;
+}
+
+/**
+ * logfs_seek_data - find next data block after a given block index
+ * @inode:		inode to search in
+ * @bix:		block index to start searching
+ *
+ * Returns next data block.  If the file doesn't contain any further data
+ * blocks, the last block in the file is returned instead.
+ */
+u64 logfs_seek_data(struct inode *inode, u64 bix)
+{
+	struct super_block *sb = inode->i_sb;
+	u64 ret, end;
+
+	ret = __logfs_seek_data(inode, bix);
+	end = i_size_read(inode) >> sb->s_blocksize_bits;
+	if (ret >= end)
+		ret = max(bix, end);
+	return ret;
+}
+
+static int logfs_is_valid_direct(struct logfs_inode *li, pgoff_t index, u64 ofs)
+{
+	return pure_ofs(li->li_data[index]) == ofs;
+}
+
+static int logfs_is_valid_shadow(struct page *page, u64 ofs)
+{
+	return PagePrivate(page) &&
+		btree_lookup(&logfs_page_to_tree(page)->old, ofs);
+}
+
+static int __logfs_is_valid_loop(struct inode *inode, u64 bix, int count,
+		u64 ofs, u64 bofs)
+{
+	int level, ret;
+	struct page *page;
+
+	for (level = count + 1; level > 0; level--) {
+		page = logfs_get_write_page(inode, bix, level);
+		BUG_ON(!page);
+
+		if (logfs_is_valid_shadow(page, ofs)) {
+			logfs_put_write_page(inode, page);
+			return 1;
+		}
+
+		ret = logfs_segment_read(inode, page, bofs, bix, level);
+		if (ret) {
+			logfs_put_write_page(inode, page);
+			return 0;
+		}
+
+		bofs = block_get_pointer(page, get_bits(bix, level-1));
+		logfs_put_write_page(inode, page);
+		if (!bofs)
+			return 0;
+
+		if (pure_ofs(bofs) == ofs)
+			return 1;
+	}
+	return 0;
+}
+
+static int logfs_is_valid_loop(struct inode *inode, pgoff_t index,
+		int count, u64 ofs)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	u64 bofs = li->li_data[I1_INDEX + count];
+
+	if (!bofs)
+		return 0;
+
+	if (pure_ofs(bofs) == ofs)
+		return 1;
+
+	return __logfs_is_valid_loop(inode, index, count, ofs, bofs);
+}
+
+static int __logfs_is_valid_block(struct inode *inode, pgoff_t index, u64 ofs)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+
+	if (btree_lookup(&li->li_shadow_tree.old, ofs)) {
+		/* block is still valid on medium */
+		return 1;
+	}
+
+	if ((inode->i_nlink == 0) && atomic_read(&inode->i_count) == 1)
+		return 0;
+
+	if (li->li_flags & LOGFS_IF_EMBEDDED)
+		return 0;
+
+	if (index < I0_BLOCKS)
+		return logfs_is_valid_direct(li, index, ofs);
+	else if (index < I1_BLOCKS)
+		return logfs_is_valid_loop(inode, index, 0, ofs);
+	else if (index < I2_BLOCKS)
+		return logfs_is_valid_loop(inode, index, 1, ofs);
+	else if (index < I3_BLOCKS)
+		return logfs_is_valid_loop(inode, index, 2, ofs);
+
+	BUG();
+	return 0;
+}
+
+/**
+ * logfs_is_valid_block - check whether this block is still valid
+ *
+ * @sb	- superblock
+ * @ofs	- block physical offset
+ * @ino	- block inode number
+ * @bix	- block index
+ * @level - block level
+ *
+ * Returns 0 if block is invalid, 1 if it is valid.
+ */
+int logfs_is_valid_block(struct super_block *sb, u64 ofs, u64 ino, u64 bix,
+		u8 level)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct inode *inode;
+	struct page *page;
+	int ret, cookie;
+
+	/* Umount closes a segment with free blocks remaining.  Those
+	 * blocks are by definition invalid. */
+	if (ino == -1)
+		return 0;
+
+	LOGFS_BUG_ON((u64)(u_long)ino != ino, sb);
+
+	inode = logfs_iget(sb, ino, &cookie);
+	if (!inode)
+		return 0;
+
+	ret = __logfs_is_valid_block(inode, bix, ofs);
+	logfs_iput(inode, cookie);
+	if (ret)
+		return ret;
+
+	/* Block may sit in the shadow of a dirty ifile block, so check again
+	 * in the ifile, with properly forged parameters */
+	ret = __logfs_is_valid_block(super->s_master_inode, ino, ofs);
+	if (ret)
+		return ret;
+
+	/* Another check - the leaf blocks are usually ignored */
+	page = logfs_get_write_page(super->s_master_inode, ino, 0);
+	if (!page)
+		return 0;
+	ret = logfs_is_valid_shadow(page, ofs);
+	logfs_put_write_page(inode, page);
+	return ret;
+}
+
+int logfs_readpage_nolock(struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	int ret = -EIO;
+
+	ret = logfs_read_block(inode, page);
+
+	if (ret) {
+		ClearPageUptodate(page);
+		SetPageError(page);
+	} else {
+		SetPageUptodate(page);
+		ClearPageError(page);
+	}
+	flush_dcache_page(page);
+
+	return ret;
+}
+
+static int logfs_reserve_bytes(struct inode *inode, int bytes)
+{
+	struct logfs_super *super = logfs_super(inode->i_sb);
+
+	if (!bytes)
+		return 0;
+
+	if (super->s_free_bytes < bytes + super->s_gc_reserve)
+		return -ENOSPC;
+
+	return 0;
+}
+
+/*
+ * Not strictly a reservation, but rather a check that we still have enough
+ * space to satisfy the write.
+ */
+static int logfs_reserve_blocks(struct inode *inode, int blocks)
+{
+	return logfs_reserve_bytes(inode, blocks * LOGFS_MAX_OBJECTSIZE);
+}
+
+static int logfs_write_inode_now(struct inode *inode, long flags)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+
+	if (!(li->li_flags & LOGFS_IF_DIRTY))
+		return 0;
+
+	li->li_flags &= ~LOGFS_IF_DIRTY;
+	if (inode->i_ino == LOGFS_INO_MASTER)
+		return logfs_write_anchor(inode);
+
+	return __logfs_write_inode(inode, flags);
+}
+
+static int logfs_write_embedded(struct page *page, struct inode *inode)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	void *buf, *dst = li->li_data;
+
+	buf = kmap_atomic(page, KM_USER0);
+	memcpy(dst, buf, i_size_read(inode));
+	flush_dcache_page(page);
+	kunmap_atomic(buf, KM_USER0);
+
+	li->li_flags |= LOGFS_IF_EMBEDDED | LOGFS_IF_DIRTY;
+
+	return 0;
+}
+
+struct write_control {
+	struct shadow_tree *shadow_tree;
+	u64 ofs;
+	long flags;
+};
+
+static int adj_level(u64 ino, int level)
+{
+	BUG_ON(level >= LOGFS_MAX_LEVELS);
+
+	if (ino == LOGFS_INO_MASTER) {
+		/* ifile has seperate areas */
+		level += LOGFS_MAX_LEVELS;
+	}
+	return level;
+}
+
+static struct logfs_shadow *alloc_shadow(struct inode *inode, u64 bix, u8 level,
+		u64 old_ofs)
+{
+	struct logfs_super *super = logfs_super(inode->i_sb);
+	struct logfs_shadow *shadow;
+
+	shadow = mempool_alloc(super->s_shadow_pool, GFP_KERNEL);
+	shadow->ino = inode->i_ino;
+	shadow->bix = bix;
+	shadow->level = adj_level(inode->i_ino, level);
+	shadow->old_ofs = old_ofs & ~LOGFS_FULLY_POPULATED;
+	return shadow;
+}
+
+static void free_shadow(struct inode *inode, struct logfs_shadow *shadow)
+{
+	struct logfs_super *super = logfs_super(inode->i_sb);
+
+	mempool_free(shadow, super->s_block_pool);
+}
+
+static void shadow_tree_merge(struct shadow_tree *target,
+		struct shadow_tree *victim)
+{
+	btree_merge(&target->new, &victim->new);
+	btree_merge(&target->old, &victim->old);
+}
+
+static void add_shadow_tree_to_page(struct page *page,
+		struct shadow_tree *shadow_tree)
+{
+	if (!shadow_tree)
+		return;
+	if ((shadow_tree->old.height == 0) && (shadow_tree->new.height == 0))
+		return;
+
+	shadow_tree_merge(logfs_page_to_tree(page), shadow_tree);
+}
+
+static void fill_shadow_tree(struct shadow_tree *tree, struct page *page,
+		struct logfs_shadow *shadow)
+{
+	struct logfs_super *super = logfs_super(page->mapping->host->i_sb);
+
+	if (PagePrivate(page)) {
+		shadow_tree_merge(tree, logfs_page_to_tree(page));
+		list_del(&logfs_block(page)->dirty_list);
+		ClearPagePrivate(page);
+		mempool_free(logfs_block(page), super->s_block_pool);
+		page->private = 0;
+	}
+	if (shadow->old_ofs)
+		btree_insert(&tree->old, shadow->old_ofs, shadow);
+	else
+		btree_insert(&tree->new, shadow->new_ofs, shadow);
+
+	super->s_dirty_used_bytes += shadow->new_len;
+	super->s_dirty_free_bytes += shadow->old_len;
+}
+
+/*
+ * File is too large for embedded data when called.  Move data to first
+ * block and clear embedded area.
+ */
+static int logfs_move_embedded(struct inode *inode, struct page *page)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	struct logfs_shadow *shadow;
+	void *buf;
+	int err;
+	int i;
+	pgoff_t index = page->index;
+
+	if (!(li->li_flags & LOGFS_IF_EMBEDDED))
+		return 0;
+
+	if (logfs_reserve_blocks(inode, 1))
+		return -ENOSPC;
+
+	if (index == 0) {
+		/* No need to write the page twice */
+		li->li_data[0] = 0;
+	} else {
+		page = logfs_get_read_page(inode, 0, 0);
+		if (!page)
+			return -ENOMEM;
+
+		buf = kmap_atomic(page, KM_USER0);
+		memcpy(buf, li->li_data, LOGFS_EMBEDDED_SIZE);
+		flush_dcache_page(page);
+		kunmap_atomic(buf, KM_USER0);
+
+		shadow = alloc_shadow(inode, 0, 0, 0);
+		err = logfs_segment_write(inode, page, shadow);
+		logfs_put_read_page(page);
+		if (err) {
+			free_shadow(inode, shadow);
+			return err;
+		}
+		fill_shadow_tree(&li->li_shadow_tree, page, shadow);
+
+		li->li_data[0] = shadow->new_ofs | LOGFS_FULLY_POPULATED;
+	}
+
+	li->li_flags &= ~LOGFS_IF_EMBEDDED;
+	li->li_flags |= LOGFS_IF_DIRTY;
+	for (i = 1; i < LOGFS_EMBEDDED_FIELDS; i++)
+		li->li_data[i] = 0;
+
+	return 0;
+}
+
+static int logfs_write_i0(struct inode *inode, struct page *page,
+		struct write_control *wc)
+{
+	struct logfs_shadow *shadow;
+	u64 bix;
+	u8 level;
+	int err = 0;
+
+	logfs_unpack_index(page->index, &bix, &level);
+	if (wc->ofs == 0)
+		if (logfs_reserve_blocks(inode, 1))
+			return -ENOSPC;
+
+	shadow = alloc_shadow(inode, bix, level, wc->ofs);
+	if (wc->flags & WF_WRITE)
+		err = logfs_segment_write(inode, page, shadow);
+	if (wc->flags & WF_DELETE)
+		logfs_segment_delete(inode, shadow);
+	if (err) {
+		free_shadow(inode, shadow);
+		return err;
+	}
+
+	fill_shadow_tree(wc->shadow_tree, page, shadow);
+	wc->ofs = shadow->new_ofs;
+	if (wc->ofs && ((level == 0) || (page_state(page) == bs_fully_populated)))
+		wc->ofs |= LOGFS_FULLY_POPULATED;
+	return 0;
+}
+
+static int logfs_write_direct(struct inode *inode, struct page *page,
+		long flags)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	struct write_control wc = {
+		.ofs = li->li_data[page->index],
+		.shadow_tree = &li->li_shadow_tree,
+		.flags = flags,
+	};
+	int err;
+
+	err = logfs_write_i0(inode, page, &wc);
+	if (err)
+		return err;
+
+	li->li_data[page->index] = wc.ofs;
+	li->li_flags |= LOGFS_IF_DIRTY;
+	return 0;
+}
+
+static void logfs_dirty_page(struct inode *inode, struct page *page, long flags)
+{
+	struct logfs_block *block;
+	struct logfs_super *super = logfs_super(inode->i_sb);
+
+	/* The assertion below is nicer to debug than random corruption due
+	 * to buggerhead being the default. */
+	BUG_ON(!page_mapping(page)->a_ops->set_page_dirty);
+
+	alloc_block(page);
+	block = logfs_block(page);
+	mark_inode_dirty(inode);
+	set_page_dirty(page);
+	if (flags & WF_GC)
+		logfs_dirty_for_gc(inode->i_sb, block);
+	else
+		list_move_tail(&block->dirty_list, &super->s_dirty_list);
+}
+
+static int __logfs_write_rec(struct inode *inode, struct page *page,
+		struct write_control *this_wc,
+		pgoff_t bix, int target_level, int level)
+{
+	int ret;
+	struct page *ipage;
+	struct write_control child_wc = {
+		.flags = this_wc->flags,
+	};
+
+	ipage = logfs_get_write_page(inode, bix, level);
+	if (!ipage)
+		return -ENOMEM;
+
+	if (this_wc->ofs) {
+		ret = logfs_segment_read(inode, ipage, this_wc->ofs, bix, level);
+		if (ret)
+			goto out;
+	} else {
+		if (PageZero(ipage))
+			ClearPageZero(ipage);
+		else if (!PageUptodate(ipage))
+			zero_user_page(ipage, 0, PAGE_SIZE, KM_USER0);
+	}
+	child_wc.shadow_tree = logfs_page_to_tree(ipage);
+	child_wc.ofs = block_get_pointer(ipage, get_bits(bix, level-1));
+
+	if (level-1 > target_level)
+		ret = __logfs_write_rec(inode, page, &child_wc, bix,
+				target_level, level-1);
+	else
+		ret = logfs_write_i0(inode, page, &child_wc);
+
+	if (ret)
+		goto out;
+
+	/* TODO: both operations use kmap_atomic, combine them */
+	block_set_pointer(ipage, get_bits(bix, level-1), child_wc.ofs);
+	if (child_wc.ofs || page_state(ipage) != bs_all_zero)
+		this_wc->flags |= WF_WRITE;
+	/* TODO: use write-back caching for ifile as well */
+	/* the condition on this_wc->ofs ensures that we won't consume extra
+	 * space for indirect blocks in the future, which we cannot reserve */
+	if ((this_wc->flags & WF_SYNC) || !this_wc->ofs)
+		ret = logfs_write_i0(inode, ipage, this_wc);
+	else
+		logfs_dirty_page(inode, ipage, this_wc->flags);
+out:
+	logfs_put_write_page(inode, ipage);
+	return ret;
+}
+
+static int logfs_write_rec(struct inode *inode, struct page *page,
+		pgoff_t bix, int count, int target_level, long flags)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	struct write_control wc = {
+		.ofs = li->li_data[I1_INDEX + count],
+		.shadow_tree = &li->li_shadow_tree,
+		.flags = flags,
+	};
+	int ret;
+
+	if (count+1 > target_level)
+		ret = __logfs_write_rec(inode, page, &wc, bix, target_level,
+				count+1);
+	else
+		ret = logfs_write_i0(inode, page, &wc);
+	if (!ret) {
+		if (li->li_data[I1_INDEX + count] != wc.ofs) {
+			li->li_flags |= LOGFS_IF_DIRTY;
+			li->li_data[I1_INDEX + count] = wc.ofs;
+		}
+	}
+	return ret;
+}
+
+/*
+ * We are protected by write lock.  Push victims up to superblock level
+ * and release transaction when appropriate.  logfs_write_inode_now(inode)
+ * will then finish the transaction when writing the master inode to the
+ * journal.
+ */
+static void logfs_handle_transaction(struct inode *inode,
+		struct logfs_transaction *ta)
+{
+	struct logfs_super *super = logfs_super(inode->i_sb);
+
+	if (!ta)
+		return;
+
+	if (inode->i_ino != LOGFS_INO_MASTER) {
+		/* just remember the transaction until inode is written */
+		BUG_ON(logfs_inode(inode)->li_transaction);
+		logfs_inode(inode)->li_transaction = ta;
+		logfs_inode(inode)->li_flags |= LOGFS_IF_DIRTY;
+		return;
+	}
+
+	switch (ta->state) {
+	case CREATE_1: /* fall through */
+	case UNLINK_1:
+		BUG_ON(super->s_victim_ino);
+		super->s_victim_ino = ta->ino;
+		break;
+	case CREATE_2: /* fall through */
+	case UNLINK_2:
+		BUG_ON(super->s_victim_ino != ta->ino);
+		super->s_victim_ino = 0;
+		/* transaction ends here - free it */
+		kfree(ta);
+		break;
+	case CROSS_RENAME_1:
+		BUG_ON(super->s_rename_dir);
+		BUG_ON(super->s_rename_pos);
+		super->s_rename_dir = ta->dir;
+		super->s_rename_pos = ta->pos;
+		break;
+	case CROSS_RENAME_2:
+		BUG_ON(super->s_rename_dir != ta->dir);
+		BUG_ON(super->s_rename_pos != ta->pos);
+		super->s_rename_dir = 0;
+		super->s_rename_pos = 0;
+		kfree(ta);
+		break;
+	case TARGET_RENAME_1:
+		BUG_ON(super->s_rename_dir);
+		BUG_ON(super->s_rename_pos);
+		BUG_ON(super->s_victim_ino);
+		super->s_rename_dir = ta->dir;
+		super->s_rename_pos = ta->pos;
+		super->s_victim_ino = ta->ino;
+		break;
+	case TARGET_RENAME_2:
+		BUG_ON(super->s_rename_dir != ta->dir);
+		BUG_ON(super->s_rename_pos != ta->pos);
+		BUG_ON(super->s_victim_ino != ta->ino);
+		super->s_rename_dir = 0;
+		super->s_rename_pos = 0;
+		break;
+	case TARGET_RENAME_3:
+		BUG_ON(super->s_rename_dir);
+		BUG_ON(super->s_rename_pos);
+		BUG_ON(super->s_victim_ino != ta->ino);
+		super->s_victim_ino = 0;
+		kfree(ta);
+		break;
+	default:
+		BUG();
+	}
+}
+
+static int __logfs_write_buf(struct inode *inode, struct page *page,
+		struct logfs_transaction *ta, long flags)
+{
+	u64 size = i_size_read(inode);
+	pgoff_t index = page->index;
+	int err;
+	u64 bix;
+	u8 level;
+
+	flags |= WF_WRITE | WF_DELETE;
+	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
+	logfs_handle_transaction(inode, ta);
+
+	if (size <= LOGFS_EMBEDDED_SIZE)
+		return logfs_write_embedded(page, inode);
+
+	err = logfs_move_embedded(inode, page);
+	if (err)
+		return err;
+
+	if (index < I0_BLOCKS)
+		return logfs_write_direct(inode, page, flags);
+
+	logfs_unpack_index(index, &bix, &level);
+	bix = adjust_bix(bix, level);
+	if (bix < I1_BLOCKS)
+		return logfs_write_rec(inode, page, bix, 0, level, flags);
+	if (bix < I2_BLOCKS)
+		return logfs_write_rec(inode, page, bix, 1, level, flags);
+	if (bix < I3_BLOCKS)
+		return logfs_write_rec(inode, page, bix, 2, level, flags);
+
+	BUG();
+	return -EIO;
+}
+
+int logfs_write_buf(struct inode *inode, struct page *page,
+		struct logfs_transaction *ta, long flags)
+{
+	struct super_block *sb = inode->i_sb;
+	int ret;
+
+	logfs_get_wblocks(sb, page, flags & WF_LOCK);
+
+	ret = __logfs_write_buf(inode, page, ta, flags);
+	BUG_ON(PagePrivate(page));
+	if (!ret)
+		ret = logfs_write_inode_now(inode, flags & ~WF_LOCK);
+	logfs_put_wblocks(sb, page, flags & WF_LOCK);
+	return ret;
+}
+
+static int __logfs_delete(struct inode *inode, struct page *page)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	long flags = WF_DELETE | WF_SYNC;
+
+	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
+
+	if (li->li_flags & LOGFS_IF_EMBEDDED) {
+		i_size_write(inode, 0);
+		li->li_flags |= LOGFS_IF_DIRTY;
+		return 0;
+	}
+
+	if (page->index < I0_BLOCKS)
+		return logfs_write_direct(inode, page, flags);
+	if (page->index < I1_BLOCKS)
+		return logfs_write_rec(inode, page, page->index, 0, 0, flags);
+	if (page->index < I2_BLOCKS)
+		return logfs_write_rec(inode, page, page->index, 1, 0, flags);
+	if (page->index < I3_BLOCKS)
+		return logfs_write_rec(inode, page, page->index, 2, 0, flags);
+	return 0;
+}
+
+int logfs_delete(struct inode *inode, pgoff_t index,
+		struct shadow_tree *shadow_tree, struct logfs_transaction *ta)
+{
+	struct super_block *sb = inode->i_sb;
+	struct page *page;
+	int ret;
+
+	page = logfs_get_read_page(inode, index, 0);
+	if (!page)
+		return -ENOMEM;
+
+	add_shadow_tree_to_page(page, shadow_tree);
+	logfs_get_wblocks(sb, page, 1);
+	logfs_handle_transaction(inode, ta);
+	ret = __logfs_delete(inode, page);
+	if (!ret)
+		ret = logfs_write_inode_now(inode, WF_SYNC);
+	logfs_put_wblocks(sb, page, 1);
+
+	SetPageZero(page);
+	logfs_put_read_page(page);
+
+	return ret;
+}
+
+/* Rewrite cannot mark the inode dirty but has to write it immediatly. */
+int logfs_rewrite_block(struct inode *inode, u64 bix, u64 ofs, int level,
+		long flags)
+{
+	struct page *page;
+	int err;
+
+	level = adjust_level(level);
+	page = logfs_get_write_page(inode, bix, level);
+	if (!page)
+		return -ENOMEM;
+
+	err = logfs_segment_read(inode, page, ofs, bix, level);
+	if (!err)
+		err = logfs_write_buf(inode, page, NULL, flags);
+	logfs_put_write_page(inode, page);
+	return err;
+}
+
+#define truncate_page(page, offset, km_type) \
+	zero_user_page(page, offset, PAGE_SIZE - offset, km_type);
+
+static int truncate_data_block(struct inode *inode, struct page *page,
+		u64 ofs, struct logfs_shadow *shadow)
+{
+	loff_t size = i_size_read(inode);
+	loff_t pageofs = page->index * LOGFS_BLOCKSIZE;
+	u64 bix;
+	u8 level;
+	int err;
+
+	logfs_unpack_index(page->index, &bix, &level);
+	BUG_ON(level > 0);
+	if (size <= pageofs)
+		return 0;
+
+	BUG_ON(size - pageofs >= PAGE_SIZE);
+	err = logfs_segment_read(inode, page, ofs, bix, level);
+	if (err)
+		return err;
+	truncate_page(page, size - pageofs, KM_USER0);
+	return logfs_segment_write(inode, page, shadow);
+}
+
+static int __logfs_truncate_i0(struct inode *inode, struct page *page,
+		struct write_control *wc)
+{
+	struct logfs_shadow *shadow;
+	u64 bix;
+	u8 level;
+	int err = 0;
+
+	logfs_unpack_index(page->index, &bix, &level);
+	shadow = alloc_shadow(inode, bix, level, wc->ofs);
+
+	if (level == 0)
+		err = truncate_data_block(inode, page, wc->ofs, shadow);
+	/* Indirect blocks can get removed completely */
+	if (err) {
+		free_shadow(inode, shadow);
+		return err;
+	}
+
+	logfs_segment_delete(inode, shadow);
+	fill_shadow_tree(wc->shadow_tree, page, shadow);
+	wc->ofs = shadow->new_ofs;
+	return 0;
+}
+
+static int logfs_truncate_direct(struct inode *inode, u64 size)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	struct write_control wc = {
+		.shadow_tree =  &li->li_shadow_tree,
+	};
+	struct page *page;
+	int e;
+	int err;
+
+	for (e = I1_INDEX - 1; e >= 0; e--) {
+		if (size > (e+1) * LOGFS_BLOCKSIZE)
+			break;
+
+		wc.ofs = li->li_data[e];
+		if (!wc.ofs)
+			continue;
+
+		page = logfs_get_write_page(inode, e, 0);
+		if (!page)
+			return -ENOMEM;
+#if 0 /* I believe this is unnecessary */
+		err = logfs_segment_read(inode, page, wc.ofs, e, 0);
+		if (err) {
+			logfs_put_write_page(page);
+			return err;
+		}
+#endif
+		err = __logfs_truncate_i0(inode, page, &wc);
+		logfs_put_write_page(inode, page);
+		if (err)
+			return err;
+
+		li->li_data[e] = wc.ofs;
+		li->li_flags |= LOGFS_IF_DIRTY;
+	}
+	return 0;
+}
+
+/* FIXME: these need to become per-sb once we support different blocksizes */
+static u64 logfs_factor[] = {
+	LOGFS_BLOCKSIZE,
+	LOGFS_I1_SIZE,
+	LOGFS_I2_SIZE,
+	LOGFS_I3_SIZE
+};
+
+static u64 logfs_foo[] = {
+	1,
+	I1_BLOCKS,
+	I2_BLOCKS,
+	I3_BLOCKS,
+};
+
+static u64 logfs_start_index[] = {
+	I0_BLOCKS,
+	I1_BLOCKS,
+	I2_BLOCKS,
+	I3_BLOCKS
+};
+
+static void logfs_unpack_raw_index(pgoff_t index, u64 *bix, u8 *level)
+{
+	logfs_unpack_index(index, bix, level);
+	if (*bix <= logfs_start_index[*level-1])
+		*bix = 0;
+}
+
+static int __logfs_truncate_rec(struct inode *inode, struct page *ipage,
+		struct write_control *this_wc, u64 size)
+{
+	int truncate_happened = 0;
+	int e;
+	int err = 0;
+	u64 bix, child_bix;
+	u8 level;
+	struct page *page;
+	struct write_control child_wc = {
+		.shadow_tree = logfs_page_to_tree(ipage),
+	};
+
+	logfs_unpack_raw_index(ipage->index, &bix, &level);
+	err = logfs_segment_read(inode, ipage, this_wc->ofs, bix, level);
+	if (err)
+		return err;
+
+	for (e = LOGFS_BLOCK_FACTOR - 1; e >= 0; e--) {
+		child_bix = bix + e*logfs_foo[level-1];
+		if (size > (e+1) * logfs_factor[level-1]) {
+			if (truncate_happened)
+				BUG(); /* FIXME: Write out truncated block */
+			return 0;
+		}
+
+		child_wc.ofs = pure_ofs(block_get_pointer(ipage, e));
+		if (!child_wc.ofs)
+			continue;
+
+		truncate_happened = 1;
+		page = logfs_get_write_page(inode, child_bix, level-1);
+		if (!page)
+			return -ENOMEM;
+
+		if (level > 1)
+			err = __logfs_truncate_rec(inode, page, &child_wc, size);
+		else
+			err = __logfs_truncate_i0(inode, page, &child_wc);
+		logfs_put_write_page(inode, page);
+		if (err)
+			return err;
+
+		block_set_pointer(ipage, e, child_wc.ofs);
+	}
+	/* Complete block can get removed if we get here */
+	return __logfs_truncate_i0(inode, ipage, this_wc);
+}
+
+static int logfs_truncate_rec(struct inode *inode, u64 size, int level)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	struct write_control wc = {
+		.ofs = li->li_data[I1_INDEX + level-1],
+		.shadow_tree = &li->li_shadow_tree,
+	};
+	struct page *page;
+	int err;
+
+	if (!wc.ofs)
+		return 0;
+
+	page = logfs_get_write_page(inode, 0, level);
+	if (!page)
+		return -ENOMEM;
+
+	err = __logfs_truncate_rec(inode, page, &wc, size);
+	logfs_put_write_page(inode, page);
+	if (err)
+		return err;
+
+	if (li->li_data[I1_INDEX + level-1] != wc.ofs) {
+		li->li_data[I1_INDEX + level-1] = wc.ofs;
+		li->li_flags |= LOGFS_IF_DIRTY;
+	}
+	return 0;
+}
+
+static int logfs_truncate_embedded(struct inode *inode, u64 size)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	void *buf = (void *)li->li_data + size;
+	size_t len = LOGFS_EMBEDDED_SIZE - size;
+
+	if (size < LOGFS_EMBEDDED_SIZE)
+		memset(buf, 0, len);
+	li->li_flags |= LOGFS_IF_DIRTY;
+	return 0;
+}
+
+static int __logfs_truncate(struct inode *inode, u64 size)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	int ret;
+
+	if (li->li_flags & LOGFS_IF_EMBEDDED)
+		return logfs_truncate_embedded(inode, size);
+
+	if (size >= logfs_factor[3])
+		return 0;
+	ret = logfs_truncate_rec(inode, size, 3);
+	if (ret)
+		return ret;
+
+	if (size >= logfs_factor[2])
+		return 0;
+	ret = logfs_truncate_rec(inode, size, 2);
+	if (ret)
+		return ret;
+
+	if (size >= logfs_factor[1])
+		return 0;
+	ret = logfs_truncate_rec(inode, size, 1);
+	if (ret)
+		return ret;
+
+	ret = logfs_truncate_direct(inode, size);
+	return ret;
+}
+
+int logfs_truncate(struct inode *inode, u64 size)
+{
+	struct super_block *sb = inode->i_sb;
+	int err;
+
+	logfs_get_wblocks(sb, NULL, 1);
+	err = __logfs_truncate(inode, size);
+	if (!err)
+		err = logfs_write_inode_now(inode, 0);
+	logfs_put_wblocks(sb, NULL, 1);
+
+	if (!err)
+		err = vmtruncate(inode, size);
+
+	if (!err && size == 0)
+		logfs_inode(inode)->li_flags |= LOGFS_IF_EMBEDDED;
+
+	return err;
+}
+
+int logfs_inode_read(struct inode *inode, void *buf, size_t n, loff_t bix)
+{
+	loff_t pos = bix << inode->i_sb->s_blocksize_bits;
+	struct page *page;
+	void *pagebuf;
+
+	if (pos >= i_size_read(inode))
+		return -EOF;
+
+	page = read_cache_page(inode->i_mapping, bix,
+			(filler_t *)logfs_readpage, NULL);
+	if (IS_ERR(page))
+		return PTR_ERR(page);
+
+	if (PageZero(page))
+		return -ENODATA;
+
+	pagebuf = kmap_atomic(page, KM_USER0);
+	memcpy(buf, pagebuf, n);
+	kunmap_atomic(pagebuf, KM_USER0);
+	return 0;
+}
+
+/**
+ * logfs_inode_write - write inode or dentry objects
+ *
+ * @inode:		parent inode (ifile or directory)
+ * @buf:		object to write (inode or dentry)
+ * @n:			object size
+ * @_pos:		object number (file position in blocks/objects)
+ * @flags:		write flags
+ * @lock:		0 if write lock is already taken, 1 otherwise
+ * @ta:			transaction this write is part of or NULL
+ * @shadow_tree:	shadow below this inode
+ */
+int logfs_inode_write(struct inode *inode, const void *buf, size_t count,
+		loff_t bix, long flags, struct logfs_transaction *ta,
+		struct shadow_tree *shadow_tree)
+{
+	loff_t pos = bix << inode->i_sb->s_blocksize_bits;
+	int err;
+	struct page *page;
+	void *pagebuf;
+
+	BUG_ON(pos & (LOGFS_BLOCKSIZE-1));
+	BUG_ON(count > LOGFS_BLOCKSIZE);
+	page = logfs_get_read_page(inode, bix, 0);
+	if (!page)
+		return -ENOMEM;
+
+	pagebuf = kmap_atomic(page, KM_USER0);
+	memcpy(pagebuf, buf, count);
+	memset(pagebuf+count, 0, LOGFS_BLOCKSIZE-count);
+	flush_dcache_page(page);
+	kunmap_atomic(pagebuf, KM_USER0);
+	ClearPageZero(page);
+	add_shadow_tree_to_page(page, shadow_tree);
+
+	if (!(flags & WF_SYNC)) {
+		logfs_dirty_page(inode, page, flags);
+		logfs_put_read_page(page);
+		return 0;
+	}
+	/*
+	 * Drop the page lock, but keep a reference on the page until
+	 * logfs_write_buf returns.  This allows GC to move this page while
+	 * ensuring the page doesn't get assigned elsewhere under memory
+	 * pressure.
+	 */
+	unlock_page(page);
+
+	if (i_size_read(inode) < pos + LOGFS_BLOCKSIZE)
+		i_size_write(inode, pos + LOGFS_BLOCKSIZE);
+
+	err = logfs_write_buf(inode, page, ta, flags);
+	page_cache_release(page);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+int logfs_init_rw(struct logfs_super *super)
+{
+	int min_fill = 3 * super->s_no_blocks;
+
+	mutex_init(&super->s_w_mutex);
+	super->s_block_pool = mempool_create_kzalloc_pool(min_fill,
+			sizeof(struct logfs_block));
+	super->s_shadow_pool = mempool_create_kzalloc_pool(min_fill,
+			sizeof(struct logfs_shadow));
+	return 0;
+}
+
+void logfs_cleanup_rw(struct logfs_super *super)
+{
+	mempool_destroy(super->s_block_pool);
+	mempool_destroy(super->s_shadow_pool);
+}

