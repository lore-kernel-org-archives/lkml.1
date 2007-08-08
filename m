Return-Path: <linux-kernel-owner+w=401wt.eu-S934812AbXHHQZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934812AbXHHQZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936136AbXHHQYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:24:18 -0400
Received: from lazybastard.de ([212.112.238.170]:42391 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936117AbXHHQYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:24:13 -0400
Date: Wed, 8 Aug 2007 18:20:17 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [Patch 11/18] fs/logfs/readwrite.c
Message-ID: <20070808162017.GM15319@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070808161234.GB15319@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2007-08-05 21:14:35.622844160 +0200
+++ linux-2.6.21logfs/fs/logfs/readwrite.c	2007-08-08 03:05:29.000000000 +0200
@@ -0,0 +1,1185 @@
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
+ * write	write blocks to a file
+ * valid	check whether a block still belongs to a file
+ * truncate	truncate a file
+ * rewrite	move existing blocks of a file to a new location (gc helper)
+ */
+#include "logfs.h"
+
+static int logfs_read_empty(void *buf, int read_zero)
+{
+	if (!read_zero)
+		return -ENODATA;
+
+	memset(buf, 0, PAGE_CACHE_SIZE);
+	return 0;
+}
+
+static int logfs_read_embedded(struct inode *inode, void *buf)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+
+	memcpy(buf, li->li_data, LOGFS_EMBEDDED_SIZE);
+	memset(buf + LOGFS_EMBEDDED_SIZE, 0,
+			PAGE_CACHE_SIZE - LOGFS_EMBEDDED_SIZE);
+	return 0;
+}
+
+static int logfs_read_direct(struct inode *inode, pgoff_t index, void *buf,
+		int read_zero)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	u64 block;
+
+	block = li->li_data[index];
+	if (!block)
+		return logfs_read_empty(buf, read_zero);
+
+	return logfs_segment_read(inode, buf, block, index, 0);
+}
+
+static __be64 *logfs_get_rblock(struct logfs_super *super)
+{
+	mutex_lock(&super->s_r_mutex);
+	return super->s_rblock;
+}
+
+static void logfs_put_rblock(struct logfs_super *super)
+{
+	mutex_unlock(&super->s_r_mutex);
+}
+
+static __be64 **logfs_get_wblocks(struct super_block *sb, int lock)
+{
+	if (lock) {
+		mutex_lock(&logfs_super(sb)->s_w_mutex);
+		logfs_gc_pass(sb);
+	}
+	return logfs_super(sb)->s_wblock;
+}
+
+static void logfs_put_wblocks(struct super_block *sb, int lock)
+{
+	if (lock)
+		mutex_unlock(&logfs_super(sb)->s_w_mutex);
+}
+
+static unsigned long get_bits(u64 val, int skip, int no)
+{
+	u64 ret = val;
+
+	ret >>= skip * no;
+	ret <<= 64 - no;
+	ret >>= 64 - no;
+	return ret;
+}
+
+static int logfs_read_loop(struct inode *inode, pgoff_t index, void *buf,
+		int read_zero, int count)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	struct logfs_super *super = logfs_super(inode->i_sb);
+	__be64 *rblock;
+	u64 bofs = li->li_data[I1_INDEX + count];
+	int bits = LOGFS_BLOCK_BITS;
+	int i, ret;
+
+	if (!bofs)
+		return logfs_read_empty(buf, read_zero);
+
+	rblock = logfs_get_rblock(super);
+
+	for (i=count; i>=0; i--) {
+		ret = logfs_segment_read(inode, rblock, bofs, index, i+1);
+		if (ret)
+			goto out;
+		bofs = be64_to_cpu(rblock[get_bits(index, i, bits)]);
+
+		if (!bofs) {
+			ret = logfs_read_empty(buf, read_zero);
+			goto out;
+		}
+	}
+
+	ret = logfs_segment_read(inode, buf, bofs, index, 1);
+out:
+	logfs_put_rblock(super);
+	return ret;
+}
+
+static int logfs_read_block(struct inode *inode, pgoff_t index, void *buf,
+		int read_zero)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+
+	if (li->li_flags & LOGFS_IF_EMBEDDED) {
+		if (index != 0)
+			return logfs_read_empty(buf, read_zero);
+		else
+			return logfs_read_embedded(inode, buf);
+	} else if (index < I0_BLOCKS)
+		return logfs_read_direct(inode, index, buf, read_zero);
+	else if (index < I1_BLOCKS)
+		return logfs_read_loop(inode, index, buf, read_zero, 0);
+	else if (index < I2_BLOCKS)
+		return logfs_read_loop(inode, index, buf, read_zero, 1);
+	else if (index < I3_BLOCKS)
+		return logfs_read_loop(inode, index, buf, read_zero, 2);
+
+	BUG();
+	return -EIO;
+}
+
+static u64 seek_data_direct(struct inode *inode, u64 pos)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+
+	for (; pos < I0_BLOCKS; pos++)
+		if (li->li_data[pos])
+			return pos;
+	return I0_BLOCKS;
+}
+
+static u64 seek_data_loop(struct inode *inode, u64 pos, int count)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	struct logfs_super *super = logfs_super(inode->i_sb);
+	__be64 *rblock;
+	u64 bofs = li->li_data[I1_INDEX + count];
+	int bits = LOGFS_BLOCK_BITS;
+	int i, ret, slot;
+
+	BUG_ON(!bofs);
+
+	rblock = logfs_get_rblock(super);
+
+	for (i=count; i>=0; i--) {
+		ret = logfs_segment_read(inode, rblock, bofs, pos, i+1);
+		if (ret)
+			break;
+		slot = get_bits(pos, i, bits);
+		while (slot < LOGFS_BLOCK_FACTOR && rblock[slot] == 0) {
+			slot++;
+			pos += 1 << (LOGFS_BLOCK_BITS * i);
+		}
+		if (slot >= LOGFS_BLOCK_FACTOR)
+			break;
+		bofs = be64_to_cpu(rblock[slot]);
+	}
+	logfs_put_rblock(super);
+	return pos;
+}
+
+static u64 __logfs_seek_data(struct inode *inode, u64 pos)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+
+	if (li->li_flags & LOGFS_IF_EMBEDDED)
+		return pos;
+	if (pos < I0_BLOCKS) {
+		pos = seek_data_direct(inode, pos);
+		if (pos < I0_BLOCKS)
+			return pos;
+	}
+	if (pos < I1_BLOCKS) {
+		if (!li->li_data[I1_INDEX])
+			pos = I1_BLOCKS;
+		else
+			return seek_data_loop(inode, pos, 0);
+	}
+	if (pos < I2_BLOCKS) {
+		if (!li->li_data[I2_INDEX])
+			pos = I2_BLOCKS;
+		else
+			return seek_data_loop(inode, pos, 1);
+	}
+	if (pos < I3_BLOCKS) {
+		if (!li->li_data[I3_INDEX])
+			pos = I3_BLOCKS;
+		else
+			return seek_data_loop(inode, pos, 2);
+	}
+	return pos;
+}
+
+u64 logfs_seek_data(struct inode *inode, u64 pos)
+{
+	struct super_block *sb = inode->i_sb;
+	u64 ret, end;
+
+	ret = __logfs_seek_data(inode, pos);
+	end = i_size_read(inode) >> sb->s_blocksize_bits;
+	if (ret >= end)
+		ret = max(pos, end);
+	return ret;
+}
+
+static int logfs_is_valid_direct(struct logfs_inode *li, pgoff_t index, u64 ofs)
+{
+	return li->li_data[index] == ofs;
+}
+
+static int __logfs_is_valid_loop(struct inode *inode, pgoff_t index,
+		int count, u64 ofs, u64 bofs, __be64 *rblock)
+{
+	int bits = LOGFS_BLOCK_BITS;
+	int i, ret;
+
+	for (i=count; i>=0; i--) {
+		ret = logfs_segment_read(inode, rblock, bofs, index, i+1);
+		if (ret)
+			return 0;
+
+		bofs = be64_to_cpu(rblock[get_bits(index, i, bits)]);
+		if (!bofs)
+			return 0;
+
+		if (bofs == ofs)
+			return 1;
+	}
+	return 0;
+}
+
+static int logfs_is_valid_loop(struct inode *inode, pgoff_t index,
+		int count, u64 ofs)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	struct logfs_super *super = logfs_super(inode->i_sb);
+	__be64 *rblock;
+	u64 bofs = li->li_data[I1_INDEX + count];
+	int ret;
+
+	if (!bofs)
+		return 0;
+
+	if (bofs == ofs)
+		return 1;
+
+	rblock = logfs_get_rblock(super);
+	ret = __logfs_is_valid_loop(inode, index, count, ofs, bofs, rblock);
+	logfs_put_rblock(super);
+	return ret;
+}
+
+static int __logfs_is_valid_block(struct inode *inode, pgoff_t index, u64 ofs)
+{
+	struct logfs_inode *li = logfs_inode(inode);
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
+ * @pos - file position of block
+ *
+ * Returns 0 if block is invalid, 1 if it is valid.
+ */
+int logfs_is_valid_block(struct super_block *sb, u64 ofs, u64 ino, u64 pos)
+{
+	struct inode *inode;
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
+	ret = __logfs_is_valid_block(inode, pos, ofs);
+	/*
+	 * If the inode is dirty, the on-medium inode and the in-core inode
+	 * differ.  Any object may be valid wrt. the on-medium inode even if
+	 * it is invalid wrt. the in-core inode.  Deleting such an object before
+	 * the in-core inode is written back can lead to data loss.
+	 *
+	 * Right now we unconditionally write the inode now.  In the future it
+	 * can make sense to have a metric whether the object in question can
+	 * possibly be valid wrt. on-medium inode and only write the inode if
+	 * valid objects are possible.
+	 */
+	if ((ret == 0) && (inode->i_state & I_DIRTY))
+		__logfs_write_inode(inode, 0);
+
+	logfs_iput(inode, cookie);
+	return ret;
+}
+
+int logfs_readpage_nolock(struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	void *buf;
+	int ret = -EIO;
+
+	buf = kmap(page);
+	ret = logfs_read_block(inode, page->index, buf, 1);
+	kunmap(page);
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
+/*
+ * logfs_file_read - generic_file_read for in-kernel buffers
+ */
+static ssize_t __logfs_inode_read(struct inode *inode, char *buf, size_t count,
+		loff_t *ppos, int read_zero)
+{
+	struct super_block *sb = inode->i_sb;
+	void *block_data = NULL;
+	loff_t size = i_size_read(inode);
+	int err = -ENOMEM;
+
+	if (*ppos >= size)
+		return 0;
+	if (count > size - *ppos)
+		count = size - *ppos;
+
+	BUG_ON(logfs_index(sb, *ppos) != logfs_index(sb, *ppos + count - 1));
+
+	block_data = kzalloc(LOGFS_BLOCKSIZE, GFP_KERNEL);
+	if (!block_data)
+		goto fail;
+
+	err = logfs_read_block(inode, logfs_index(sb, *ppos), block_data,
+			read_zero);
+	if (err)
+		goto fail;
+
+	memcpy(buf, block_data + (*ppos % LOGFS_BLOCKSIZE), count);
+	*ppos += count;
+	err = count;
+fail:
+	kfree(block_data);
+	return err;
+}
+
+static s64 logfs_segment_write_pos(struct inode *inode, void *buf, u64 pos,
+		int level, int alloc)
+{
+	return logfs_segment_write(inode, buf, logfs_index(inode->i_sb, pos),
+			level, alloc);
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
+static int logfs_dirty_inode(struct inode *inode)
+{
+	if (inode->i_ino == LOGFS_INO_MASTER)
+		return logfs_write_anchor(inode);
+
+	mark_inode_dirty_sync(inode);
+	return 0;
+}
+
+static int logfs_write_inode_now(struct inode *inode)
+{
+	if (inode->i_ino == LOGFS_INO_MASTER)
+		return logfs_write_anchor(inode);
+
+	return __logfs_write_inode(inode, 0);
+}
+
+/*
+ * File is too large for embedded data when called.  Move data to first
+ * block and clear embedded area
+ */
+static int logfs_move_embedded(struct inode *inode, __be64 **wblocks)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	void *buf;
+	s64 block;
+	int i;
+
+	if (! (li->li_flags & LOGFS_IF_EMBEDDED))
+		return 0;
+
+	if (logfs_reserve_blocks(inode, 1))
+		return -ENOSPC;
+
+	buf = wblocks[0];
+
+	memcpy(buf, li->li_data, LOGFS_EMBEDDED_SIZE);
+	block = logfs_segment_write(inode, buf, 0, 0, 1);
+	if (block < 0)
+		return block;
+
+	li->li_data[0] = block;
+
+	li->li_flags &= ~LOGFS_IF_EMBEDDED;
+	for (i=1; i<LOGFS_EMBEDDED_FIELDS; i++)
+		li->li_data[i] = 0;
+
+	return 0;
+}
+
+static int logfs_write_embedded(struct inode *inode, void *buf)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	void *dst = li->li_data;
+
+	memcpy(dst, buf, max((long long)LOGFS_EMBEDDED_SIZE, i_size_read(inode)));
+
+	li->li_flags |= LOGFS_IF_EMBEDDED;
+	logfs_set_blocks(inode, 0);
+
+	return 0;
+}
+
+static int logfs_write_direct(struct inode *inode, pgoff_t index, void *buf)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	s64 block;
+
+	if (li->li_data[index] == 0) {
+		if (logfs_reserve_blocks(inode, 1)) {
+			return -ENOSPC;
+		}
+	}
+	block = logfs_segment_write(inode, buf, index, 0, 1);
+	if (block < 0)
+		return block;
+
+	if (li->li_data[index])
+		logfs_segment_delete(inode, li->li_data[index], index, 0);
+	li->li_data[index] = block;
+
+	return 0;
+}
+
+static int logfs_write_loop(struct inode *inode, pgoff_t index, void *buf,
+		__be64 **wblocks, int count)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	u64 bofs = li->li_data[I1_INDEX + count];
+	s64 block;
+	int bits = LOGFS_BLOCK_BITS;
+	int allocs = 0;
+	int i, ret;
+
+	for (i=count; i>=0; i--) {
+		if (bofs) {
+			ret = logfs_segment_read(inode, wblocks[i], bofs, index,
+					i+1);
+			if (ret)
+				return ret;
+		} else {
+			allocs++;
+			memset(wblocks[i], 0, LOGFS_BLOCKSIZE);
+		}
+		bofs = be64_to_cpu(wblocks[i][get_bits(index, i, bits)]);
+	}
+
+	if (! wblocks[0][get_bits(index, 0, bits)])
+		allocs++;
+	if (logfs_reserve_blocks(inode, allocs))
+		return -ENOSPC;
+
+	block = logfs_segment_write(inode, buf, index, 0, allocs);
+	allocs = allocs ? allocs-1 : 0;
+	if (block < 0)
+		return block;
+
+	for (i=0; i<=count; i++) {
+		wblocks[i][get_bits(index, i, bits)] = cpu_to_be64(block);
+		block = logfs_segment_write(inode, wblocks[i], index, i+1,
+				allocs);
+		allocs = allocs ? allocs-1 : 0;
+		if (block < 0)
+			return block;
+	}
+
+	li->li_data[I1_INDEX + count] = block;
+
+	return 0;
+}
+
+/*
+ * We are protected by write lock.  Push victims up to superblock level
+ * and release transaction when appropriate.  logfs_dirty_inode(inode)
+ * will then finish the transaction when writing the master inode to the
+ * journal.
+ */
+static void logfs_handle_transaction(struct inode *inode, pgoff_t index,
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
+static int __logfs_write_buf(struct inode *inode, pgoff_t index, void *buf,
+		__be64 **wblocks, struct logfs_transaction *ta)
+{
+	u64 size = i_size_read(inode);
+	int err;
+
+	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
+	logfs_handle_transaction(inode, index, ta);
+
+	if (size <= LOGFS_EMBEDDED_SIZE)
+		return logfs_write_embedded(inode, buf);
+
+	err = logfs_move_embedded(inode, wblocks);
+	if (err)
+		return err;
+
+	if (index < I0_BLOCKS)
+		return logfs_write_direct(inode, index, buf);
+	if (index < I1_BLOCKS)
+		return logfs_write_loop(inode, index, buf, wblocks, 0);
+	if (index < I2_BLOCKS)
+		return logfs_write_loop(inode, index, buf, wblocks, 1);
+	if (index < I3_BLOCKS)
+		return logfs_write_loop(inode, index, buf, wblocks, 2);
+
+	BUG();
+	return -EIO;
+}
+
+int logfs_write_buf(struct inode *inode, pgoff_t index, void *buf, int lock,
+		struct logfs_transaction *ta)
+{
+	struct super_block *sb = inode->i_sb;
+	__be64 **wblocks;
+	int ret;
+
+	wblocks = logfs_get_wblocks(sb, lock);
+
+	ret = __logfs_write_buf(inode, index, buf, wblocks, ta);
+	if (!ret)
+		ret = logfs_dirty_inode(inode);
+
+	logfs_put_wblocks(sb, lock);
+	return ret;
+}
+
+static int logfs_delete_direct(struct inode *inode, pgoff_t index)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+
+	if (li->li_data[index])
+		logfs_segment_delete(inode, li->li_data[index], index, 0);
+	li->li_data[index] = 0;
+	return 0;
+}
+
+static int mem_zero(void *buf, size_t len)
+{
+	long *lmap;
+	char *cmap;
+
+	lmap = buf;
+	while (len >= sizeof(long)) {
+		if (*lmap)
+			return 0;
+		lmap++;
+		len -= sizeof(long);
+	}
+	cmap = (void*)lmap;
+	while (len) {
+		if (*cmap)
+			return 0;
+		cmap++;
+		len--;
+	}
+	return 1;
+}
+
+static int logfs_delete_loop(struct inode *inode, pgoff_t index,
+		__be64 **wblocks, int count)
+{
+	struct super_block *sb = inode->i_sb;
+	struct logfs_inode *li = logfs_inode(inode);
+	u64 bofs = li->li_data[I1_INDEX + count];
+	u64 ofs_array[LOGFS_MAX_LEVELS];
+	s64 block;
+	int bits = LOGFS_BLOCK_BITS;
+	int i, ret;
+
+	if (!bofs)
+		return 0;
+
+	for (i=count; i>=0; i--) {
+		ret = logfs_segment_read(inode, wblocks[i], bofs, index, i+1);
+		if (ret)
+			return ret;
+
+		bofs = be64_to_cpu(wblocks[i][get_bits(index, i, bits)]);
+		ofs_array[i+1] = bofs;
+		if (!bofs)
+			return 0;
+	}
+	logfs_segment_delete(inode, bofs, index, 0);
+	block = 0;
+
+	for (i=0; i<=count; i++) {
+		wblocks[i][get_bits(index, i, bits)] = cpu_to_be64(block);
+		if ((block == 0) && mem_zero(wblocks[i], sb->s_blocksize)) {
+			logfs_segment_delete(inode, ofs_array[i+1], index, i+1);
+			continue;
+		}
+		block = logfs_segment_write(inode, wblocks[i], index, i+1, 0);
+		if (block < 0)
+			return block;
+	}
+
+	li->li_data[I1_INDEX + count] = block;
+
+	return 0;
+}
+
+static int __logfs_delete(struct inode *inode, pgoff_t index, __be64 **wblocks)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+
+	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
+
+	if (li->li_flags & LOGFS_IF_EMBEDDED) {
+		i_size_write(inode, 0);
+		mark_inode_dirty_sync(inode);
+		return 0;
+	}
+
+	if (index < I0_BLOCKS)
+		return logfs_delete_direct(inode, index);
+	if (index < I1_BLOCKS)
+		return logfs_delete_loop(inode, index, wblocks, 0);
+	if (index < I2_BLOCKS)
+		return logfs_delete_loop(inode, index, wblocks, 1);
+	if (index < I3_BLOCKS)
+		return logfs_delete_loop(inode, index, wblocks, 2);
+	return 0;
+}
+
+int logfs_delete(struct inode *inode, pgoff_t index,
+		struct logfs_transaction *ta)
+{
+	struct super_block *sb = inode->i_sb;
+	__be64 **wblocks;
+	int ret;
+
+	wblocks = logfs_get_wblocks(sb, 1);
+	logfs_handle_transaction(inode, index, ta);
+	ret = __logfs_delete(inode, index, wblocks);
+	if (!ret)
+		ret = logfs_dirty_inode(inode);
+	logfs_put_wblocks(sb, 1);
+	return ret;
+}
+
+static int logfs_rewrite_direct(struct inode *inode, int index, pgoff_t pos,
+		void *buf, int level)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	s64 block;
+	int err;
+
+	block = li->li_data[index];
+	BUG_ON(block == 0);
+
+	err = logfs_segment_read(inode, buf, block, pos, 0);
+	if (err)
+		return err;
+
+	block = logfs_segment_write(inode, buf, pos, level, 0);
+	if (block < 0)
+		return block;
+
+	li->li_data[index] = block;
+
+	return 0;
+}
+
+static int logfs_rewrite_loop(struct inode *inode, pgoff_t index, void *buf,
+		__be64 **wblocks, int count, int level)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	u64 bofs = li->li_data[I1_INDEX + count];
+	s64 block;
+	int bits = LOGFS_BLOCK_BITS;
+	int i, err;
+
+	if (level > count)
+		return logfs_rewrite_direct(inode, I1_INDEX + count, index, buf,
+				level);
+
+	for (i=count; i>=level; i--) {
+		if (bofs) {
+			err = logfs_segment_read(inode, wblocks[i], bofs, index,
+					i+1);
+			if (err)
+				return err;
+		} else {
+			BUG();
+		}
+		bofs = be64_to_cpu(wblocks[i][get_bits(index, i, bits)]);
+	}
+
+	block = be64_to_cpu(wblocks[level][get_bits(index, level, bits)]);
+	LOGFS_BUG_ON(!block, inode->i_sb);
+
+	err = logfs_segment_read(inode, buf, block, index, level);
+	if (err)
+		return err;
+
+	block = logfs_segment_write(inode, buf, index, level, 0);
+	if (block < 0)
+		return block;
+
+	for (i=level; i<=count; i++) {
+		wblocks[i][get_bits(index, i, bits)] = cpu_to_be64(block);
+		block = logfs_segment_write(inode, wblocks[i], index, i+1, 0);
+		if (block < 0)
+			return block;
+	}
+
+	li->li_data[I1_INDEX + count] = block;
+
+	return 0;
+}
+
+static int __logfs_rewrite_block(struct inode *inode, pgoff_t index, void *buf,
+		__be64 **wblocks, int level)
+{
+	if (level >= LOGFS_MAX_LEVELS)
+		level -= LOGFS_MAX_LEVELS;
+	BUG_ON(level >= LOGFS_MAX_LEVELS);
+
+	if (index < I0_BLOCKS)
+		return logfs_rewrite_direct(inode, index, index, buf, level);
+	if (index < I1_BLOCKS)
+		return logfs_rewrite_loop(inode, index, buf, wblocks, 0, level);
+	if (index < I2_BLOCKS)
+		return logfs_rewrite_loop(inode, index, buf, wblocks, 1, level);
+	if (index < I3_BLOCKS)
+		return logfs_rewrite_loop(inode, index, buf, wblocks, 2, level);
+
+	BUG();
+	return -EIO;
+}
+
+/* Rewrite cannot mark the inode dirty but has to write it immediatly. */
+int logfs_rewrite_block(struct inode *inode, pgoff_t index, u64 ofs, int level)
+{
+	struct logfs_super *super = logfs_super(inode->i_sb);
+	__be64 **wblocks;
+	void *buf;
+	int ret;
+
+	wblocks = super->s_wblock;
+	buf = wblocks[LOGFS_MAX_INDIRECT];
+	ret = __logfs_rewrite_block(inode, index, buf, wblocks, level);
+	if (!ret)
+		ret = logfs_write_inode_now(inode);
+	return ret;
+}
+
+/*
+ * Three cases exist:
+ * size <= pos			- remove full block
+ * size >= pos + chunk		- do nothing
+ * pos < size < pos + chunk	- truncate, rewrite
+ */
+static s64 __logfs_truncate_i0(struct inode *inode, u64 size, u64 bofs,
+		u64 pos, __be64 **wblocks)
+{
+	size_t len = size - pos;
+	void *buf = wblocks[LOGFS_MAX_INDIRECT];
+	int err;
+
+	if (size <= pos) {
+		/* remove whole block */
+		logfs_segment_delete(inode, bofs,
+				pos >> inode->i_sb->s_blocksize_bits, 0);
+		return 0;
+	}
+
+	/* truncate this block, rewrite it */
+	err = logfs_segment_read(inode, buf, bofs, pos, 0);
+	if (err)
+		return err;
+
+	memset(buf + len, 0, LOGFS_BLOCKSIZE - len);
+	return logfs_segment_write_pos(inode, buf, pos, 0, 0);
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
+static u64 logfs_start[] = {
+	LOGFS_I0_SIZE,
+	LOGFS_I1_SIZE,
+	LOGFS_I2_SIZE,
+	LOGFS_I3_SIZE
+};
+
+/*
+ * One recursion per indirect block.  Logfs supports 5fold indirect blocks.
+ */
+static s64 __logfs_truncate_loop(struct inode *inode, u64 size, u64 old_bofs,
+		u64 pos, __be64 **wblocks, int i)
+{
+	struct super_block *sb = inode->i_sb;
+	struct logfs_super *super = logfs_super(sb);
+	s64 ofs;
+	int e, ret;
+
+	ret = logfs_segment_read(inode, wblocks[i], old_bofs, pos, i+1);
+	if (ret)
+		return ret;
+
+	for (e = LOGFS_BLOCK_FACTOR-1; e>=0; e--) {
+		u64 bofs;
+		u64 new_pos = pos + e*logfs_factor[i];
+
+		if (size >= new_pos + logfs_factor[i])
+			break;
+
+		bofs = be64_to_cpu(wblocks[i][e]);
+		if (!bofs)
+			continue;
+
+		LOGFS_BUG_ON(bofs > super->s_size, sb);
+
+		if (i)
+			ofs = __logfs_truncate_loop(inode, size, bofs, new_pos,
+					wblocks, i-1);
+		else
+			ofs = __logfs_truncate_i0(inode, size, bofs, new_pos,
+					wblocks);
+		if (ofs < 0)
+			return ofs;
+
+		wblocks[i][e] = cpu_to_be64(ofs);
+	}
+
+	if (size <= max(pos, logfs_start[i])) {
+		/* complete indirect block is removed */
+		logfs_segment_delete(inode, old_bofs, logfs_index(sb,pos), i+1);
+		return 0;
+	}
+
+	/* partially removed - write back */
+	return logfs_segment_write_pos(inode, wblocks[i], pos, i, 0);
+}
+
+static int logfs_truncate_direct(struct inode *inode, u64 size,
+		__be64 **wblocks)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	int e;
+	s64 bofs, ofs;
+
+	for (e = I1_INDEX-1; e>=0; e--) {
+		u64 new_pos = e*logfs_factor[0];
+
+		if (size > e*logfs_factor[0])
+			break;
+
+		bofs = li->li_data[e];
+		if (!bofs)
+			continue;
+
+		ofs = __logfs_truncate_i0(inode, size, bofs, new_pos, wblocks);
+		if (ofs < 0)
+			return ofs;
+
+		li->li_data[e] = ofs;
+	}
+	return 0;
+}
+
+static int logfs_truncate_loop(struct inode *inode, u64 size, __be64 **wblocks,
+		int i)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	u64 bofs = li->li_data[I1_INDEX + i];
+	s64 ofs;
+
+	if (!bofs)
+		return 0;
+
+	ofs = __logfs_truncate_loop(inode, size, bofs, 0, wblocks, i);
+	if (ofs < 0)
+		return ofs;
+
+	li->li_data[I1_INDEX + i] = ofs;
+	return 0;
+}
+
+static void logfs_truncate_embedded(struct inode *inode, u64 size)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	void *buf = (void*)li->li_data + size;
+	size_t len = LOGFS_EMBEDDED_SIZE - size;
+
+	if (size >= LOGFS_EMBEDDED_SIZE)
+		return;
+	memset(buf, 0, len);
+}
+
+static void __logfs_truncate(struct inode *inode, __be64 **wblocks)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	u64 size = i_size_read(inode);
+	int ret;
+
+	if (li->li_flags & LOGFS_IF_EMBEDDED)
+		return logfs_truncate_embedded(inode, size);
+
+	if (size >= logfs_factor[3])
+		return;
+	ret = logfs_truncate_loop(inode, size, wblocks, 2);
+	BUG_ON(ret);
+
+	if (size >= logfs_factor[2])
+		return;
+	ret = logfs_truncate_loop(inode, size, wblocks, 1);
+	BUG_ON(ret);
+
+	if (size >= logfs_factor[1])
+		return;
+	ret = logfs_truncate_loop(inode, size, wblocks, 0);
+	BUG_ON(ret);
+
+	ret = logfs_truncate_direct(inode, size, wblocks);
+	BUG_ON(ret);
+
+	if (size == 0)
+		li->li_flags |= LOGFS_IF_EMBEDDED;
+}
+
+void logfs_truncate(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	__be64 **wblocks;
+
+	wblocks = logfs_get_wblocks(sb, 1);
+	__logfs_truncate(inode, wblocks);
+	logfs_put_wblocks(sb, 1);
+	mark_inode_dirty_sync(inode);
+}
+
+static ssize_t __logfs_inode_write(struct inode *inode, const char *buf,
+		size_t count, loff_t *ppos, int lock,
+		struct logfs_transaction *ta)
+{
+	struct super_block *sb = inode->i_sb;
+	void *block_data = NULL;
+	pgoff_t index = logfs_index(sb, *ppos);
+	int err = -ENOMEM;
+
+	BUG_ON(index != logfs_index(sb, *ppos + count - 1));
+
+	/* TODO: push the (buf, count) tupel further down instead */
+	block_data = kzalloc(LOGFS_BLOCKSIZE, GFP_KERNEL);
+	if (!block_data)
+		goto fail;
+
+	memcpy(block_data + (*ppos % LOGFS_BLOCKSIZE), buf, count);
+
+	if (i_size_read(inode) < *ppos + count)
+		i_size_write(inode, *ppos + count);
+
+	err = logfs_write_buf(inode, index, block_data, lock, ta);
+	if (err)
+		goto fail;
+
+	*ppos += count;
+	err = count;
+fail:
+	kfree(block_data);
+	return err;
+}
+
+int logfs_inode_read(struct inode *inode, void *buf, size_t n, loff_t _pos)
+{
+	loff_t pos = _pos << inode->i_sb->s_blocksize_bits;
+	ssize_t ret;
+
+	if (pos >= i_size_read(inode))
+		return -EOF;
+	ret = __logfs_inode_read(inode, buf, n, &pos, 0);
+	if (ret < 0)
+		return ret;
+	ret = ret==n ? 0 : -EIO;
+	return ret;
+}
+
+/**
+ * logfs_inode_write - write inode or dentry objects
+ *
+ * @inode:		parent inode (ifile or directory)
+ * @buf:		object to write (inode or dentry)
+ * @n:			object size
+ * @_pos:		object number (file position in blocks/objects)
+ * @lock:		0 if write lock is already taken, 1 otherwise
+ * @ta:			transaction this write is part of or NULL
+ */
+int logfs_inode_write(struct inode *inode, const void *buf, size_t n,
+		loff_t _pos, int lock, struct logfs_transaction *ta)
+{
+	loff_t pos = _pos << inode->i_sb->s_blocksize_bits;
+	ssize_t ret;
+
+	ret = __logfs_inode_write(inode, buf, n, &pos, lock, ta);
+	if (ret < 0)
+		return ret;
+	return ret==n ? 0 : -EIO;
+}
+
+int logfs_init_rw(struct logfs_super *super)
+{
+	int i;
+
+	mutex_init(&super->s_r_mutex);
+	mutex_init(&super->s_w_mutex);
+	super->s_rblock = kmalloc(LOGFS_BLOCKSIZE, GFP_KERNEL);
+	if (!super->s_wblock)
+		return -ENOMEM;
+	for (i=0; i<=LOGFS_MAX_INDIRECT; i++) {
+		super->s_wblock[i] = kmalloc(LOGFS_BLOCKSIZE, GFP_KERNEL);
+		if (!super->s_wblock) {
+			logfs_cleanup_rw(super);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+void logfs_cleanup_rw(struct logfs_super *super)
+{
+	int i;
+
+	for (i=0; i<=LOGFS_MAX_INDIRECT; i++)
+		kfree(super->s_wblock[i]);
+	kfree(super->s_rblock);
+}
