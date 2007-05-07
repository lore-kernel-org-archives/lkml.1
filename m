Return-Path: <linux-kernel-owner+w=401wt.eu-S967082AbXEGWPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967082AbXEGWPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966976AbXEGWPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:15:34 -0400
Received: from lazybastard.de ([212.112.238.170]:46486 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966778AbXEGWP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:15:29 -0400
Date: Tue, 8 May 2007 00:11:14 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] LogFS proper
Message-ID: <20070507221113.GE15054@lazybastard.org>
References: <20070507215913.GA15054@lazybastard.org> <20070507220036.GB15054@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070507220036.GB15054@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 00:00:36 +0200, Jörn Engel wrote:
> 
> Signed-off-by: Jörn Engel <joern@wohnheim.fh-wedel.de>
> ---
> 
>  fs/Kconfig            |   15 
>  fs/Makefile           |    1 
>  fs/logfs/Locking      |   45 ++
>  fs/logfs/Makefile     |   14 
>  fs/logfs/NAMES        |   32 +
>  fs/logfs/compr.c      |  198 ++++++++
>  fs/logfs/dir.c        |  705 +++++++++++++++++++++++++++++++
>  fs/logfs/file.c       |   82 +++
>  fs/logfs/gc.c         |  350 +++++++++++++++
>  fs/logfs/inode.c      |  468 ++++++++++++++++++++
>  fs/logfs/journal.c    |  696 ++++++++++++++++++++++++++++++
>  fs/logfs/logfs.h      |  626 +++++++++++++++++++++++++++
>  fs/logfs/memtree.c    |  199 ++++++++
>  fs/logfs/progs/fsck.c |  323 ++++++++++++++
>  fs/logfs/progs/mkfs.c |  319 ++++++++++++++
>  fs/logfs/readwrite.c  | 1125 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/logfs/segment.c    |  533 +++++++++++++++++++++++
>  fs/logfs/super.c      |  490 +++++++++++++++++++++
>  19 files changed, 6237 insertions(+)

...and the second half.

--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/readwrite.c	2007-05-07 20:37:05.000000000 +0200
@@ -0,0 +1,1125 @@
+/**
+ * fs/logfs/readwrite.c
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
+
+static int logfs_read_embedded(struct inode *inode, void *buf)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	memcpy(buf, li->li_data, LOGFS_EMBEDDED_SIZE);
+	return 0;
+}
+
+
+static int logfs_read_direct(struct inode *inode, pgoff_t index, void *buf,
+		int read_zero)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	u64 block;
+
+	block = li->li_data[index];
+	if (!block)
+		return logfs_read_empty(buf, read_zero);
+
+	//printk("ino=%lx, index=%lx, blocks=%llx\n", inode->i_ino, index, block);
+	return logfs_segment_read(inode->i_sb, buf, block);
+}
+
+
+static be64 *logfs_get_rblock(struct logfs_super *super)
+{
+	mutex_lock(&super->s_r_mutex);
+	return super->s_rblock;
+}
+
+
+static void logfs_put_rblock(struct logfs_super *super)
+{
+	mutex_unlock(&super->s_r_mutex);
+}
+
+
+static be64 **logfs_get_wblocks(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+
+	mutex_lock(&super->s_w_mutex);
+	logfs_gc_pass(sb);
+	return super->s_wblock;
+}
+
+
+static void logfs_put_wblocks(struct super_block *sb)
+{
+	mutex_unlock(&LOGFS_SUPER(sb)->s_w_mutex);
+}
+
+
+static unsigned long get_bits(u64 val, int skip, int no)
+{
+	u64 ret = val;
+
+	ret >>= skip * no;
+	ret <<= 64 - no;
+	ret >>= 64 - no;
+	BUG_ON((unsigned long)ret != ret);
+	return ret;
+}
+
+
+static int logfs_read_loop(struct inode *inode, pgoff_t index, void *buf,
+		int read_zero, int count)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+	be64 *rblock;
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
+		ret = logfs_segment_read(inode->i_sb, rblock, bofs);
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
+	ret = logfs_segment_read(inode->i_sb, buf, bofs);
+out:
+	logfs_put_rblock(super);
+	return ret;
+}
+
+
+static int logfs_read_block(struct inode *inode, pgoff_t index, void *buf,
+		int read_zero)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
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
+
+static u64 seek_data_direct(struct inode *inode, u64 pos)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	for (; pos < I0_BLOCKS; pos++)
+		if (li->li_data[pos])
+			return pos;
+	return I0_BLOCKS;
+}
+
+
+static u64 seek_data_loop(struct inode *inode, u64 pos, int count)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+	be64 *rblock;
+	u64 bofs = li->li_data[I1_INDEX + count];
+	int bits = LOGFS_BLOCK_BITS;
+	int i, ret, slot;
+
+	BUG_ON(!bofs);
+
+	rblock = logfs_get_rblock(super);
+
+	for (i=count; i>=0; i--) {
+		ret = logfs_segment_read(inode->i_sb, rblock, bofs);
+		if (ret)
+			goto out;
+		slot = get_bits(pos, i, bits);
+		while (slot < LOGFS_BLOCK_FACTOR && rblock[slot] == 0) {
+			slot++;
+			pos += 1 << (LOGFS_BLOCK_BITS * i);
+		}
+		if (slot >= LOGFS_BLOCK_FACTOR)
+			goto out;
+		bofs = be64_to_cpu(rblock[slot]);
+	}
+out:
+	logfs_put_rblock(super);
+	return pos;
+}
+
+
+static u64 __logfs_seek_data(struct inode *inode, u64 pos)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
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
+
+static int logfs_is_valid_direct(struct logfs_inode *li, pgoff_t index, u64 ofs)
+{
+	return li->li_data[index] == ofs;
+}
+
+
+static int logfs_is_valid_loop(struct inode *inode, pgoff_t index,
+		int count, u64 ofs)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+	be64 *rblock;
+	u64 bofs = li->li_data[I1_INDEX + count];
+	int bits = LOGFS_BLOCK_BITS;
+	int i, ret;
+
+	if (!bofs)
+		return 0;
+
+	if (bofs == ofs)
+		return 1;
+
+	rblock = logfs_get_rblock(super);
+
+	for (i=count; i>=0; i--) {
+		ret = logfs_segment_read(inode->i_sb, rblock, bofs);
+		if (ret)
+			goto fail;
+
+		bofs = be64_to_cpu(rblock[get_bits(index, i, bits)]);
+		if (!bofs)
+			goto fail;
+
+		if (bofs == ofs) {
+			ret = 1;
+			goto out;
+		}
+	}
+
+fail:
+	ret = 0;
+out:
+	logfs_put_rblock(super);
+	return ret;
+}
+
+
+static int __logfs_is_valid_block(struct inode *inode, pgoff_t index, u64 ofs)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	//printk("%lx, %x, %x\n", inode->i_ino, inode->i_nlink, atomic_read(&inode->i_count));
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
+
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
+	if ((u64)(u_long)ino != ino) {
+		printk("%llx, %llx, %llx\n", ofs, ino, pos);
+		LOGFS_BUG(sb);
+	}
+	inode = logfs_iget(sb, ino, &cookie);
+	if (!inode)
+		return 0;
+
+#if 0
+	/* Any data belonging to dirty inodes must be considered valid until
+	 * the inode is written back.  If we prematurely deleted old blocks
+	 * and crashed before the inode is written, the filesystem goes boom.
+	 */
+	if (inode->i_state & I_DIRTY)
+		ret = 2;
+	else
+#endif
+		ret = __logfs_is_valid_block(inode, pos, ofs);
+
+	logfs_iput(inode, cookie);
+	return ret;
+}
+
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
+
+/**
+ * logfs_file_read - generic_file_read for in-kernel buffers
+ */
+static ssize_t __logfs_inode_read(struct inode *inode, char *buf, size_t count,
+		loff_t *ppos, int read_zero)
+{
+	void *block_data = NULL;
+	loff_t size = i_size_read(inode);
+	int err = -ENOMEM;
+
+	pr_debug("read from %lld, count %zd\n", *ppos, count);
+
+	if (*ppos >= size)
+		return 0;
+	if (count > size - *ppos)
+		count = size - *ppos;
+
+	BUG_ON(logfs_index(*ppos) != logfs_index(*ppos + count - 1));
+
+	block_data = kzalloc(LOGFS_BLOCKSIZE, GFP_KERNEL);
+	if (!block_data)
+		goto fail;
+
+	err = logfs_read_block(inode, logfs_index(*ppos), block_data,
+			read_zero);
+	if (err)
+		goto fail;
+
+	memcpy(buf, block_data + (*ppos % LOGFS_BLOCKSIZE), count);
+	*ppos += count;
+	kfree(block_data);
+	return count;
+fail:
+	kfree(block_data);
+	return err;
+}
+
+
+static s64 logfs_segment_write_pos(struct inode *inode, void *buf, u64 pos,
+		int level, int alloc)
+{
+	return logfs_segment_write(inode, buf, logfs_index(pos), level, alloc);
+}
+
+
+static int logfs_alloc_bytes(struct inode *inode, int bytes)
+{
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+
+	if (!bytes)
+		return 0;
+
+	if (super->s_free_bytes < bytes + super->s_gc_reserve) {
+		//TRACE();
+		return -ENOSPC;
+	}
+
+	/* Actual allocation happens later.  Make sure we don't drop the
+	 * lock before then! */
+
+	return 0;
+}
+
+
+static int logfs_alloc_blocks(struct inode *inode, int blocks)
+{
+	return logfs_alloc_bytes(inode, blocks <<inode->i_sb->s_blocksize_bits);
+}
+
+
+static int logfs_dirty_inode(struct inode *inode)
+{
+	if (inode->i_ino == LOGFS_INO_MASTER)
+		return logfs_write_anchor(inode);
+
+	mark_inode_dirty(inode);
+	return 0;
+}
+
+
+/*
+ * File is too large for embedded data when called.  Move data to first
+ * block and clear embedded area
+ */
+static int logfs_move_embedded(struct inode *inode, be64 **wblocks)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	void *buf;
+	s64 block;
+	int i;
+
+	if (! (li->li_flags & LOGFS_IF_EMBEDDED))
+		return 0;
+
+	if (logfs_alloc_blocks(inode, 1)) {
+		//TRACE();
+		return -ENOSPC;
+	}
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
+	return logfs_dirty_inode(inode);
+}
+
+
+static int logfs_write_embedded(struct inode *inode, void *buf)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	void *dst = li->li_data;
+
+	memcpy(dst, buf, max((long long)LOGFS_EMBEDDED_SIZE, i_size_read(inode)));
+
+	li->li_flags |= LOGFS_IF_EMBEDDED;
+	logfs_set_blocks(inode, 0);
+
+	return logfs_dirty_inode(inode);
+}
+
+
+static int logfs_write_direct(struct inode *inode, pgoff_t index, void *buf)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	s64 block;
+
+	if (li->li_data[index] == 0) {
+		if (logfs_alloc_blocks(inode, 1)) {
+			//TRACE();
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
+	return logfs_dirty_inode(inode);
+}
+
+
+static int logfs_write_loop(struct inode *inode, pgoff_t index, void *buf,
+		be64 **wblocks, int count)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	u64 bofs = li->li_data[I1_INDEX + count];
+	s64 block;
+	int bits = LOGFS_BLOCK_BITS;
+	int allocs = 0;
+	int i, ret;
+
+	for (i=count; i>=0; i--) {
+		if (bofs) {
+			ret = logfs_segment_read(inode->i_sb, wblocks[i], bofs);
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
+	if (logfs_alloc_blocks(inode, allocs)) {
+		//TRACE();
+		return -ENOSPC;
+	}
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
+	return logfs_dirty_inode(inode);
+}
+
+
+static int __logfs_write_buf(struct inode *inode, pgoff_t index, void *buf,
+		be64 **wblocks)
+{
+	u64 size = i_size_read(inode);
+	int err;
+
+	inode->i_ctime.tv_sec = inode->i_mtime.tv_sec = get_seconds();
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
+
+int logfs_write_buf(struct inode *inode, pgoff_t index, void *buf)
+{
+	struct super_block *sb = inode->i_sb;
+	be64 **wblocks;
+	int ret;
+
+	wblocks = logfs_get_wblocks(sb);
+	ret = __logfs_write_buf(inode, index, buf, wblocks);
+	logfs_put_wblocks(sb);
+	return ret;
+}
+
+
+static int logfs_delete_direct(struct inode *inode, pgoff_t index)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	if (li->li_data[index])
+		logfs_segment_delete(inode, li->li_data[index], index, 0);
+	li->li_data[index] = 0;
+	return logfs_dirty_inode(inode);
+}
+
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
+
+static int logfs_delete_loop(struct inode *inode, pgoff_t index, be64 **wblocks,
+		int count)
+{
+	struct super_block *sb = inode->i_sb;
+	struct logfs_inode *li = LOGFS_INODE(inode);
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
+		ret = logfs_segment_read(sb, wblocks[i], bofs);
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
+	return logfs_dirty_inode(inode);
+}
+
+
+static int __logfs_delete(struct inode *inode, pgoff_t index, be64 **wblocks)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	inode->i_ctime.tv_sec = inode->i_mtime.tv_sec = get_seconds();
+
+	if (li->li_flags & LOGFS_IF_EMBEDDED) {
+		i_size_write(inode, 0);
+		mark_inode_dirty(inode);
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
+
+int logfs_delete(struct inode *inode, pgoff_t index)
+{
+	struct super_block *sb = inode->i_sb;
+	be64 **wblocks;
+	int ret;
+
+	wblocks = logfs_get_wblocks(sb);
+	ret = __logfs_delete(inode, index, wblocks);
+	logfs_put_wblocks(sb);
+	return ret;
+}
+
+
+static int logfs_rewrite_direct(struct inode *inode, int index, pgoff_t pos,
+		void *buf, int level)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	s64 block;
+	int err;
+
+	block = li->li_data[index];
+	BUG_ON(block == 0);
+
+	err = logfs_segment_read(inode->i_sb, buf, block);
+	if (err)
+		return err;
+
+	block = logfs_segment_write(inode, buf, pos, level, 0);
+	if (block < 0)
+		return block;
+
+	li->li_data[index] = block;
+
+	return logfs_dirty_inode(inode);
+}
+
+
+static int logfs_rewrite_loop(struct inode *inode, pgoff_t index, void *buf,
+		be64 **wblocks, int count, int level)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
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
+			err = logfs_segment_read(inode->i_sb, wblocks[i], bofs);
+			if (err)
+				return err;
+		} else {
+			BUG();
+		}
+		bofs = be64_to_cpu(wblocks[i][get_bits(index, i, bits)]);
+	}
+
+	block = be64_to_cpu(wblocks[level][get_bits(index, level, bits)]);
+	if (!block) {
+		printk("(%lx, %lx, %x, %x, %lx)\n",
+				inode->i_ino, index, count, level,
+				get_bits(index, level, bits));
+		LOGFS_BUG(inode->i_sb);
+	}
+
+	err = logfs_segment_read(inode->i_sb, buf, block);
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
+	return logfs_dirty_inode(inode);
+}
+
+
+static int __logfs_rewrite_block(struct inode *inode, pgoff_t index, void *buf,
+		be64 **wblocks, int level)
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
+
+int logfs_rewrite_block(struct inode *inode, pgoff_t index, u64 ofs, int level)
+{
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+	be64 **wblocks;
+	void *buf;
+	int ret;
+
+	//printk("(%lx, %lx, %llx, %x)\n", inode->i_ino, index, ofs, level);
+	wblocks = super->s_wblock;
+	buf = wblocks[LOGFS_MAX_INDIRECT];
+	ret = __logfs_rewrite_block(inode, index, buf, wblocks, level);
+	return ret;
+}
+
+
+/**
+ * Three cases exist:
+ * size <= pos			- remove full block
+ * size >= pos + chunk		- do nothing
+ * pos < size < pos + chunk	- truncate, rewrite
+ */
+static s64 __logfs_truncate_i0(struct inode *inode, u64 size, u64 bofs,
+		u64 pos, be64 **wblocks)
+{
+	size_t len = size - pos;
+	void *buf = wblocks[LOGFS_MAX_INDIRECT];
+	int err;
+
+	if (size <= pos) {	/* remove whole block */
+		logfs_segment_delete(inode, bofs,
+				pos >> inode->i_sb->s_blocksize_bits, 0);
+		return 0;
+	}
+
+	/* truncate this block, rewrite it */
+	err = logfs_segment_read(inode->i_sb, buf, bofs);
+	if (err)
+		return err;
+
+	memset(buf + len, 0, LOGFS_BLOCKSIZE - len);
+	return logfs_segment_write_pos(inode, buf, pos, 0, 0);
+}
+
+
+/* FIXME: move to super */
+static u64 logfs_factor[] = {
+	LOGFS_BLOCKSIZE,
+	LOGFS_I1_SIZE,
+	LOGFS_I2_SIZE,
+	LOGFS_I3_SIZE
+};
+
+
+static u64 logfs_start[] = {
+	LOGFS_I0_SIZE,
+	LOGFS_I1_SIZE,
+	LOGFS_I2_SIZE,
+	LOGFS_I3_SIZE
+};
+
+
+/*
+ * One recursion per indirect block.  Logfs supports 5fold indirect blocks.
+ */
+static s64 __logfs_truncate_loop(struct inode *inode, u64 size, u64 old_bofs,
+		u64 pos, be64 **wblocks, int i)
+{
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+	s64 ofs;
+	int e, ret;
+
+	ret = logfs_segment_read(inode->i_sb, wblocks[i], old_bofs);
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
+		LOGFS_BUG_ON(bofs > super->s_size, inode->i_sb);
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
+		logfs_segment_delete(inode, old_bofs, logfs_index(pos), i+1);
+		return 0;
+	}
+
+	/* partially removed - write back */
+	return logfs_segment_write_pos(inode, wblocks[i], pos, i, 0);
+}
+
+
+static int logfs_truncate_direct(struct inode *inode, u64 size, be64 **wblocks)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
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
+
+static int logfs_truncate_loop(struct inode *inode, u64 size, be64 **wblocks,
+		int i)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
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
+
+static void logfs_truncate_embedded(struct inode *inode, u64 size)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	void *buf = (void*)li->li_data + size;
+	size_t len = LOGFS_EMBEDDED_SIZE - size;
+
+	if (size >= LOGFS_EMBEDDED_SIZE)
+		return;
+	memset(buf, 0, len);
+}
+
+
+/* TODO: might make sense to turn inode into embedded again */
+static void __logfs_truncate(struct inode *inode, be64 **wblocks)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
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
+}
+
+
+void logfs_truncate(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	be64 **wblocks;
+
+	wblocks = logfs_get_wblocks(sb);
+	__logfs_truncate(inode, wblocks);
+	logfs_put_wblocks(sb);
+	mark_inode_dirty(inode);
+}
+
+
+static ssize_t __logfs_inode_write(struct inode *inode, const char *buf,
+		size_t count, loff_t *ppos)
+{
+	void *block_data = NULL;
+	int err = -ENOMEM;
+
+	pr_debug("write to 0x%llx, count %zd\n", *ppos, count);
+
+	BUG_ON(logfs_index(*ppos) != logfs_index(*ppos + count - 1));
+
+	block_data = kzalloc(LOGFS_BLOCKSIZE, GFP_KERNEL);
+	if (!block_data)
+		goto fail;
+
+	err = logfs_read_block(inode, logfs_index(*ppos), block_data, 1);
+	if (err)
+		goto fail;
+
+	memcpy(block_data + (*ppos % LOGFS_BLOCKSIZE), buf, count);
+
+	if (i_size_read(inode) < *ppos + count)
+		i_size_write(inode, *ppos + count);
+
+	err = logfs_write_buf(inode, logfs_index(*ppos), block_data);
+	if (err)
+		goto fail;
+
+	*ppos += count;
+	pr_debug("write to %lld, count %zd\n", *ppos, count);
+	kfree(block_data);
+	return count;
+fail:
+	kfree(block_data);
+	return err;
+}
+
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
+
+int logfs_inode_write(struct inode *inode, const void *buf, size_t n,
+		loff_t _pos)
+{
+	loff_t pos = _pos << inode->i_sb->s_blocksize_bits;
+	ssize_t ret;
+
+	ret = __logfs_inode_write(inode, buf, n, &pos);
+	if (ret < 0)
+		return ret;
+	return ret==n ? 0 : -EIO;
+}
+
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
+
+void logfs_cleanup_rw(struct logfs_super *super)
+{
+	int i;
+
+	for (i=0; i<=LOGFS_MAX_INDIRECT; i++)
+		kfree(super->s_wblock[i]);
+	kfree(super->s_rblock);
+}
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/super.c	2007-05-07 13:32:12.000000000 +0200
@@ -0,0 +1,490 @@
+#include "logfs.h"
+
+
+#define FAIL_ON(cond) do { if (unlikely((cond))) return -EINVAL; } while(0)
+
+int mtdread(struct super_block *sb, loff_t ofs, size_t len, void *buf)
+{
+	struct mtd_info *mtd = LOGFS_SUPER(sb)->s_mtd;
+	size_t retlen;
+	int ret;
+
+	ret = mtd->read(mtd, ofs, len, &retlen, buf);
+	if (ret || (retlen != len)) {
+		printk("ret: %x\n", ret);
+		printk("retlen: %x, len: %x\n", retlen, len);
+		printk("ofs: %llx, mtd->size: %x\n", ofs, mtd->size);
+		dump_stack();
+		return -EIO;
+	}
+
+	return 0;
+}
+
+
+static void check(void *buf, size_t len)
+{
+	char value[8] = {0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a};
+	void *poison = buf, *end = buf + len;
+
+	while (poison) {
+		poison = memchr(poison, value[0], end-poison);
+		if (!poison || poison + 8 > end)
+			return;
+		if (! memcmp(poison, value, 8)) {
+			printk("%p %p %p\n", buf, poison, end);
+			BUG();
+		}
+		poison++;
+	}
+}
+
+
+int mtdwrite(struct super_block *sb, loff_t ofs, size_t len, void *buf)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct mtd_info *mtd = super->s_mtd;
+	struct inode *inode = super->s_dev_inode;
+	size_t retlen;
+	loff_t page_start, page_end;
+	int ret;
+
+	if (0) /* FIXME: this should be a debugging option */
+		check(buf, len);
+
+	//printk("write ofs=%llx, len=%x\n", ofs, len);
+	BUG_ON((ofs >= mtd->size) || (len > mtd->size - ofs));
+	BUG_ON(ofs != (ofs >> super->s_writeshift) << super->s_writeshift);
+	//BUG_ON(len != (len >> super->s_blockshift) << super->s_blockshift);
+	/* FIXME: fix all callers to write PAGE_CACHE_SIZE'd chunks */
+	BUG_ON(len > PAGE_CACHE_SIZE);
+	page_start = ofs & PAGE_CACHE_MASK;
+	page_end = PAGE_CACHE_ALIGN(ofs + len) - 1;
+	truncate_inode_pages_range(&inode->i_data, page_start, page_end);
+	ret = mtd->write(mtd, ofs, len, &retlen, buf);
+	if (ret || (retlen != len))
+		return -EIO;
+
+	return 0;
+}
+
+
+static DECLARE_COMPLETION(logfs_erase_complete);
+static void logfs_erase_callback(struct erase_info *ei)
+{
+	complete(&logfs_erase_complete);
+}
+int mtderase(struct super_block *sb, loff_t ofs, size_t len)
+{
+	struct mtd_info *mtd = LOGFS_SUPER(sb)->s_mtd;
+	struct inode *inode = LOGFS_SUPER(sb)->s_dev_inode;
+	struct erase_info ei;
+	int ret;
+
+	BUG_ON(len % mtd->erasesize);
+
+	truncate_inode_pages_range(&inode->i_data, ofs, ofs+len-1);
+	if (mtd->block_isbad(mtd, ofs))
+		return -EIO;
+
+	memset(&ei, 0, sizeof(ei));
+	ei.mtd = mtd;
+	ei.addr = ofs;
+	ei.len = len;
+	ei.callback = logfs_erase_callback;
+	ret = mtd->erase(mtd, &ei);
+	if (ret)
+		return -EIO;
+
+	wait_for_completion(&logfs_erase_complete);
+	if (ei.state != MTD_ERASE_DONE)
+		return -EIO;
+	return 0;
+}
+
+
+static void dump_write(struct super_block *sb, int ofs, void *buf)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+
+	if (ofs << sb->s_blocksize_bits >= super->s_segsize)
+		return;
+	mtdwrite(sb, ofs << sb->s_blocksize_bits, sb->s_blocksize, buf);
+}
+
+
+/**
+ * logfs_crash_dump - dump debug information to device
+ *
+ * The LogFS superblock only occupies part of a segment.  This function will
+ * write as much debug information as it can gather into the spare space.
+ */
+void logfs_crash_dump(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int i, ofs = 2, bs = sb->s_blocksize;
+	void *scratch = super->s_wblock[0];
+	void *stack = (void *) ((ulong)current & ~0x1fffUL);
+
+	/* all wbufs */
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		void *wbuf = super->s_area[i]->a_wbuf;
+		u64 ofs = sb->s_blocksize + i*super->s_writesize;
+		mtdwrite(sb, ofs, super->s_writesize, wbuf);
+	}
+	/* both superblocks */
+	memset(scratch, 0, bs);
+	memcpy(scratch, super, sizeof(*super));
+	memcpy(scratch + sizeof(*super) + 32, sb, sizeof(*sb));
+	dump_write(sb, ofs++, scratch);
+	/* process stack */
+	dump_write(sb, ofs++, stack);
+	dump_write(sb, ofs++, stack + 0x1000);
+	/* wblocks are interesting whenever readwrite.c causes problems */
+	for (i=0; i<LOGFS_MAX_LEVELS; i++)
+		dump_write(sb, ofs++, super->s_wblock[i]);
+}
+
+
+static int logfs_readdevice(void *unused, struct page *page)
+{
+	struct super_block *sb = page->mapping->host->i_sb;
+	loff_t ofs = page->index << PAGE_CACHE_SHIFT;
+	void *buf;
+	int ret;
+
+	buf = kmap(page);
+	ret = mtdread(sb, ofs, PAGE_CACHE_SIZE, buf);
+	kunmap(page);
+	unlock_page(page);
+	return ret;
+}
+
+
+void *logfs_device_getpage(struct super_block *sb, u64 offset,
+		struct page **page)
+{
+	struct inode *inode = LOGFS_SUPER(sb)->s_dev_inode;
+
+	*page = read_cache_page(inode->i_mapping, offset >> PAGE_CACHE_SHIFT,
+			logfs_readdevice, NULL);
+	BUG_ON(IS_ERR(*page));	/* TODO: use mempool here */
+	return kmap(*page);
+}
+
+
+void logfs_device_putpage(void *buf, struct page *page)
+{
+	kunmap(page);
+	page_cache_release(page);
+}
+
+
+int logfs_cached_read(struct super_block *sb, u64 ofs, size_t len, void *buf)
+{
+	struct page *page;
+	void *map;
+	u64 pageaddr = ofs & PAGE_CACHE_MASK;
+	int pageofs = ofs & ~PAGE_CACHE_MASK;
+	size_t pagelen = PAGE_CACHE_SIZE - pageofs;
+
+	pagelen = max(pagelen, len);
+	if (pageofs) {
+		map = logfs_device_getpage(sb, pageaddr, &page);
+		memcpy(buf, map + pageofs, pagelen);
+		logfs_device_putpage(map, page);
+		buf += pagelen;
+		ofs += pagelen;
+		len -= pagelen;
+	}
+	while (len) {
+		pagelen = max_t(size_t, PAGE_CACHE_SIZE, len);
+		map = logfs_device_getpage(sb, ofs, &page);
+		memcpy(buf, map, pagelen);
+		logfs_device_putpage(map, page);
+		buf += pagelen;
+		ofs += pagelen;
+		len -= pagelen;
+	}
+	return 0;
+}
+
+
+int all_ff(void *buf, size_t len)
+{
+	unsigned char *c = buf;
+	int i;
+
+	for (i=0; i<len; i++)
+		if (c[i] != 0xff)
+			return 0;
+	return 1;
+}
+
+
+int logfs_statfs(struct dentry *dentry, struct kstatfs *stats)
+{
+	struct super_block *sb = dentry->d_sb;
+	struct logfs_super *super = LOGFS_SUPER(sb);
+
+	stats->f_type	= LOGFS_MAGIC_U32;
+	stats->f_bsize	= sb->s_blocksize;
+	stats->f_blocks	= super->s_size >> LOGFS_BLOCK_BITS >> 3;
+	stats->f_bfree	= super->s_free_bytes >> sb->s_blocksize_bits;
+	stats->f_bavail	= super->s_free_bytes >> sb->s_blocksize_bits; /* FIXME: leave some for root */
+	stats->f_files	= 0;
+	stats->f_ffree	= 0;
+	stats->f_namelen= LOGFS_MAX_NAMELEN;
+	return 0;
+}
+
+
+static int logfs_sb_set(struct super_block *sb, void *_super)
+{
+	struct logfs_super *super = _super;
+
+	sb->s_fs_info = super;
+	sb->s_dev = MKDEV(MTD_BLOCK_MAJOR, super->s_mtd->index);
+
+	return 0;
+}
+
+
+static int logfs_get_sb_final(struct super_block *sb, struct vfsmount *mnt)
+{
+	struct inode *rootdir;
+	int err;
+
+	/* root dir */
+	rootdir = iget(sb, LOGFS_INO_ROOT);
+	if (!rootdir)
+		goto fail;
+
+	sb->s_root = d_alloc_root(rootdir);
+	if (!sb->s_root)
+		goto fail;
+
+#if 1
+	err = logfs_fsck(sb);
+#else
+	err = 0;
+#endif
+	if (err) {
+		printk(KERN_ERR "LOGFS: fsck failed, refusing to mount\n");
+		goto fail;
+	}
+
+	return simple_set_mnt(mnt, sb);
+
+fail:
+	iput(LOGFS_SUPER(sb)->s_master_inode);
+	return -EIO;
+}
+
+
+static int logfs_read_sb(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_disk_super ds;
+	int i, ret;
+
+	ret = mtdread(sb, 0, sizeof(ds), &ds);
+	if (ret)
+		return ret;
+
+	super->s_dev_inode = logfs_new_meta_inode(sb, 0);
+	if (IS_ERR(super->s_dev_inode))
+		return PTR_ERR(super->s_dev_inode);
+
+	if (be64_to_cpu(ds.ds_magic) != LOGFS_MAGIC) {
+		ret = logfs_mkfs(sb, &ds);
+		if (ret)
+			goto out0;
+	}
+	super->s_size = be64_to_cpu(ds.ds_filesystem_size);
+	super->s_root_reserve = be64_to_cpu(ds.ds_root_reserve);
+	super->s_segsize = 1 << ds.ds_segment_shift;
+	super->s_segshift = ds.ds_segment_shift;
+	sb->s_blocksize = 1 << ds.ds_block_shift;
+	sb->s_blocksize_bits = ds.ds_block_shift;
+	super->s_writesize = 1 << ds.ds_write_shift;
+	super->s_writeshift = ds.ds_write_shift;
+	super->s_no_segs = super->s_size >> super->s_segshift;
+	super->s_no_blocks = super->s_segsize >> sb->s_blocksize_bits;
+
+	journal_for_each(i)
+		super->s_journal_seg[i] = be64_to_cpu(ds.ds_journal_seg[i]);
+
+	super->s_ifile_levels = ds.ds_ifile_levels;
+	super->s_iblock_levels = ds.ds_iblock_levels;
+	super->s_data_levels = ds.ds_data_levels;
+	super->s_total_levels = super->s_ifile_levels + super->s_iblock_levels
+		+ super->s_data_levels;
+	super->s_gc_reserve = super->s_total_levels * (2*super->s_no_blocks -1);
+	super->s_gc_reserve <<= sb->s_blocksize_bits;
+
+	mutex_init(&super->s_victim_mutex);
+	mutex_init(&super->s_rename_mutex);
+	spin_lock_init(&super->s_ino_lock);
+	INIT_LIST_HEAD(&super->s_freeing_list);
+
+	ret = logfs_init_rw(super);
+	if (ret)
+		goto out0;
+
+	ret = logfs_init_areas(sb);
+	if (ret)
+		goto out1;
+
+	ret = logfs_init_journal(sb);
+	if (ret)
+		goto out2;
+
+	ret = logfs_init_gc(super);
+	if (ret)
+		goto out3;
+
+	/* after all initializations are done, replay the journal
+	 * for rw-mounts, if necessary */
+	ret = logfs_replay_journal(sb);
+	if (ret)
+		goto out4;
+	return 0;
+
+out4:
+	logfs_cleanup_gc(super);
+out3:
+	logfs_cleanup_journal(sb);
+out2:
+	logfs_cleanup_areas(super);
+out1:
+	logfs_cleanup_rw(super);
+out0:
+	__logfs_destroy_inode(super->s_dev_inode);
+	return ret;
+}
+
+
+static void logfs_kill_sb(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+
+	generic_shutdown_super(sb);
+	logfs_cleanup_gc(super);
+	logfs_cleanup_journal(sb);
+	logfs_cleanup_areas(super);
+	logfs_cleanup_rw(super);
+	__logfs_destroy_inode(super->s_dev_inode);
+	put_mtd_device(super->s_mtd);
+	kfree(super);
+}
+
+
+static int logfs_get_sb_mtd(struct file_system_type *type, int flags,
+		struct mtd_info *mtd, struct vfsmount *mnt)
+{
+	struct logfs_super *super = NULL;
+	struct super_block *sb;
+	int err = -ENOMEM;
+
+	super = kzalloc(sizeof*super, GFP_KERNEL);
+	if (!super)
+		goto err0;
+
+	super->s_mtd = mtd;
+	err = -EINVAL;
+	sb = sget(type, NULL, logfs_sb_set, super);
+	if (IS_ERR(sb))
+		goto err0;
+
+	sb->s_maxbytes	= LOGFS_I3_SIZE;
+	sb->s_op	= &logfs_super_operations;
+	sb->s_flags	= flags | MS_NOATIME;
+
+	err = logfs_read_sb(sb);
+	if (err)
+		goto err1;
+
+	sb->s_flags |= MS_ACTIVE;
+	err = logfs_get_sb_final(sb, mnt);
+	if (err)
+		goto err1;
+	return 0;
+
+err1:
+	up_write(&sb->s_umount);
+	deactivate_super(sb);
+	return err;
+err0:
+	kfree(super);
+	put_mtd_device(mtd);
+	return err;
+}
+
+
+static int logfs_get_sb(struct file_system_type *type, int flags,
+		const char *devname, void *data, struct vfsmount *mnt)
+{
+	ulong mtdnr;
+	struct mtd_info *mtd;
+
+#if 0
+	if (!devname)
+		return ERR_PTR(-EINVAL);
+	if (strncmp(devname, "mtd", 3))
+		return ERR_PTR(-EINVAL);
+
+	{
+		char *garbage;
+		mtdnr = simple_strtoul(devname+3, &garbage, 0);
+		if (*garbage)
+			return ERR_PTR(-EINVAL);
+	}
+#else
+	mtdnr = 0;
+#endif
+
+	mtd = get_mtd_device(NULL, mtdnr);
+	if (!mtd)
+		return -EINVAL;
+
+	return logfs_get_sb_mtd(type, flags, mtd, mnt);
+}
+
+
+static struct file_system_type logfs_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "logfs",
+	.get_sb		= logfs_get_sb,
+	.kill_sb	= logfs_kill_sb,
+};
+
+
+static int __init logfs_init(void)
+{
+	int ret;
+
+	ret = logfs_compr_init();
+	if (ret)
+		return ret;
+
+	ret = logfs_init_inode_cache();
+	if (ret) {
+		logfs_compr_exit();
+		return ret;
+	}
+
+	return register_filesystem(&logfs_fs_type);
+}
+
+
+static void __exit logfs_exit(void)
+{
+	unregister_filesystem(&logfs_fs_type);
+	logfs_destroy_inode_cache();
+	logfs_compr_exit();
+}
+
+
+module_init(logfs_init);
+module_exit(logfs_exit);
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/progs/mkfs.c	2007-05-07 13:32:12.000000000 +0200
@@ -0,0 +1,319 @@
+#include "../logfs.h"
+
+#define OFS_SB		0
+#define OFS_JOURNAL	1
+#define OFS_ROOTDIR	3
+#define OFS_IFILE	4
+#define OFS_COUNT	5
+
+static u64 segment_offset[OFS_COUNT];
+
+static u64 fssize;
+static u64 no_segs;
+static u64 free_blocks;
+
+static u32 segsize;
+static u32 blocksize;
+static int segshift;
+static int blockshift;
+static int writeshift;
+
+static u32 blocks_per_seg;
+static u16 version;
+
+static be32 bb_array[1024];
+static int bb_count;
+
+
+#if 0
+/* rootdir */
+static int make_rootdir(struct super_block *sb)
+{
+	struct logfs_disk_inode *di;
+	int ret;
+
+	di = kzalloc(blocksize, GFP_KERNEL);
+	if (!di)
+		return -ENOMEM;
+
+	di->di_flags	= cpu_to_be32(LOGFS_IF_VALID);
+	di->di_mode	= cpu_to_be16(S_IFDIR | 0755);
+	di->di_refcount	= cpu_to_be32(2);
+	ret = mtdwrite(sb, segment_offset[OFS_ROOTDIR], blocksize, di);
+	kfree(di);
+	return ret;
+}
+
+
+/* summary */
+static int make_summary(struct super_block *sb)
+{
+	struct logfs_disk_sum *sum;
+	u64 sum_ofs;
+	int ret;
+
+	sum = kzalloc(LOGFS_BLOCKSIZE, GFP_KERNEL);
+	if (!sum)
+		return -ENOMEM;
+	memset(sum, 0xff, LOGFS_BLOCKSIZE);
+
+	sum->oids[0].ino = cpu_to_be64(LOGFS_INO_MASTER);
+	sum->oids[0].pos = cpu_to_be64(LOGFS_INO_ROOT);
+	sum_ofs = segment_offset[OFS_ROOTDIR];
+	sum_ofs += segsize - blocksize;
+	sum->level = LOGFS_MAX_LEVELS;
+	ret = mtdwrite(sb, sum_ofs, LOGFS_BLOCKSIZE, sum);
+	kfree(sum);
+	return ret;
+}
+#endif
+
+
+/* journal */
+static size_t __write_header(struct logfs_journal_header *h, size_t len,
+		size_t datalen, u16 type, u8 compr)
+{
+	h->h_len	= cpu_to_be16(len);
+	h->h_type	= cpu_to_be16(type);
+	h->h_version	= cpu_to_be16(++version);
+	h->h_datalen	= cpu_to_be16(datalen);
+	h->h_compr	= compr;
+	h->h_pad[0]	= 'h';
+	h->h_pad[1]	= 'a';
+	h->h_pad[2]	= 't';
+	h->h_crc	= logfs_crc32(h, len, 4);
+	return len;
+}
+static size_t write_header(struct logfs_journal_header *h, size_t datalen,
+		u16 type)
+{
+	size_t len = datalen + sizeof(*h);
+	return __write_header(h, len, datalen, type, COMPR_NONE);
+}
+static size_t je_badsegments(void *data, u16 *type)
+{
+	memcpy(data, bb_array, blocksize);
+	*type = JE_BADSEGMENTS;
+	return blocksize;
+}
+static size_t je_anchor(void *_da, u16 *type)
+{
+	struct logfs_anchor *da = _da;
+
+	memset(da, 0, sizeof(*da));
+	da->da_last_ino	= cpu_to_be64(LOGFS_RESERVED_INOS);
+	da->da_size	= cpu_to_be64((LOGFS_INO_ROOT+1) * blocksize);
+#if 0
+	da->da_used_bytes = cpu_to_be64(blocksize);
+	da->da_data[LOGFS_INO_ROOT] = cpu_to_be64(3*segsize);
+#else
+	da->da_data[LOGFS_INO_ROOT] = 0;
+#endif
+	*type = JE_ANCHOR;
+	return sizeof(*da);
+}
+static size_t je_dynsb(void *_dynsb, u16 *type)
+{
+	struct logfs_dynsb *dynsb = _dynsb;
+
+	memset(dynsb, 0, sizeof(*dynsb));
+	dynsb->ds_used_bytes	= cpu_to_be64(blocksize);
+	*type = JE_DYNSB;
+	return sizeof(*dynsb);
+}
+static size_t je_commit(void *h, u16 *type)
+{
+	*type = JE_COMMIT;
+	return 0;
+}
+static size_t write_je(size_t jpos, void *scratch, void *header,
+		size_t (*write)(void *scratch, u16 *type))
+{
+	void *data;
+	ssize_t len, max, compr_len, pad_len, full_len;
+	u16 type;
+	u8 compr = COMPR_ZLIB;
+
+	header += jpos;
+	data = header + sizeof(struct logfs_journal_header);
+
+	len = write(scratch, &type);
+	if (len == 0)
+		return write_header(header, 0, type);
+
+	max = blocksize - jpos;
+	compr_len = logfs_compress(scratch, data, len, max);
+	if ((compr_len < 0) || (type == JE_ANCHOR)) {
+		compr_len = logfs_memcpy(scratch, data, len, max);
+		compr = COMPR_NONE;
+	}
+	BUG_ON(compr_len < 0);
+
+	pad_len = ALIGN(compr_len, 16);
+	memset(data + compr_len, 0, pad_len - compr_len);
+	full_len = pad_len + sizeof(struct logfs_journal_header);
+
+	return __write_header(header, full_len, len, type, compr);
+}
+static int make_journal(struct super_block *sb)
+{
+	void *journal, *scratch;
+	size_t jpos;
+	int ret;
+
+	journal = kzalloc(2*blocksize, GFP_KERNEL);
+	if (!journal)
+		return -ENOMEM;
+
+	scratch = journal + blocksize;
+
+	jpos = 0;
+	/* erasecount is not written - implicitly set to 0 */
+	/* neither are summary, index, wbuf */
+	jpos += write_je(jpos, scratch, journal, je_badsegments);
+	jpos += write_je(jpos, scratch, journal, je_anchor);
+	jpos += write_je(jpos, scratch, journal, je_dynsb);
+	jpos += write_je(jpos, scratch, journal, je_commit);
+	ret = mtdwrite(sb, segment_offset[OFS_JOURNAL], blocksize, journal);
+	kfree(journal);
+	return ret;
+}
+
+
+/* superblock */
+static int make_super(struct super_block *sb, struct logfs_disk_super *ds)
+{
+	void *sector;
+	int ret;
+
+	sector = kzalloc(4096, GFP_KERNEL);
+	if (!sector)
+		return -ENOMEM;
+
+	memset(ds, 0, sizeof(*ds));
+
+	ds->ds_magic		= cpu_to_be64(LOGFS_MAGIC);
+#if 0	/* sane defaults */
+	ds->ds_ifile_levels	= 3; /* 2+1, 1GiB */
+	ds->ds_iblock_levels	= 4; /* 3+1, 512GiB */
+	ds->ds_data_levels	= 3; /* old, young, unknown */
+#else
+	ds->ds_ifile_levels	= 1; /* 0+1, 80kiB */
+	ds->ds_iblock_levels	= 4; /* 3+1, 512GiB */
+	ds->ds_data_levels	= 1; /* unknown */
+#endif
+
+	ds->ds_feature_incompat	= 0;
+	ds->ds_feature_ro_compat= 0;
+
+	ds->ds_feature_compat	= 0;
+	ds->ds_flags		= 0;
+
+	ds->ds_filesystem_size	= cpu_to_be64(fssize);
+	ds->ds_segment_shift	= segshift;
+	ds->ds_block_shift	= blockshift;
+	ds->ds_write_shift	= writeshift;
+
+	ds->ds_journal_seg[0]	= cpu_to_be64(1);
+	ds->ds_journal_seg[1]	= cpu_to_be64(2);
+	ds->ds_journal_seg[2]	= 0;
+	ds->ds_journal_seg[3]	= 0;
+
+	ds->ds_root_reserve	= 0;
+
+	ds->ds_crc = logfs_crc32(ds, sizeof(*ds), 12);
+
+	memcpy(sector, ds, sizeof(*ds));
+	ret = mtdwrite(sb, segment_offset[OFS_SB], 4096, sector);
+	kfree(sector);
+	return ret;
+}
+
+
+/* main */
+static void getsize(struct super_block *sb, u64 *size,
+		u64 *no_segs)
+{
+	*no_segs = LOGFS_SUPER(sb)->s_mtd->size >> segshift;
+	*size = *no_segs << segshift;
+}
+
+
+static int bad_block_scan(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct mtd_info *mtd = super->s_mtd;
+	int k, seg=0;
+	u64 ofs;
+
+	bb_count = 0;
+	for (ofs=0; ofs<fssize; ofs+=segsize) {
+		int bad = 0;
+
+		for (k=0; k<segsize; k+=mtd->erasesize) /* iterate subblocks */
+			bad = bad?:mtd->block_isbad(mtd, ofs+k);
+		if (!bad) {
+			if (seg < OFS_COUNT)
+				segment_offset[seg++] = ofs;
+			continue;
+		}
+
+		if (bb_count > 512)
+			return -EIO;
+		bb_array[bb_count++] = cpu_to_be32(ofs >> segshift);
+	}
+	return 0;
+}
+
+
+int logfs_mkfs(struct super_block *sb, struct logfs_disk_super *ds)
+{
+	int ret = 0;
+
+	segshift = 17;
+	blockshift = 12;
+	writeshift = 8;
+
+	segsize = 1 << segshift;
+	blocksize = 1 << blockshift;
+	version = 0;
+
+	getsize(sb, &fssize, &no_segs);
+
+	/* 3 segs for sb and journal,
+	 * 1 block per seg extra,
+	 * 1 block for rootdir
+	 */
+	blocks_per_seg = 1 << (segshift - blockshift);
+	free_blocks = (no_segs - 3) * (blocks_per_seg - 1) - 1;
+
+	ret = bad_block_scan(sb);
+	if (ret)
+		return ret;
+
+	{
+		int i;
+		for (i=0; i<OFS_COUNT; i++)
+			printk("%x->%llx\n", i, segment_offset[i]);
+	}
+
+#if 0
+	ret = make_rootdir(sb);
+	if (ret)
+		return ret;
+
+	ret = make_summary(sb);
+	if (ret)
+		return ret;
+#endif
+
+	ret = make_journal(sb);
+	if (ret)
+		return ret;
+
+	ret = make_super(sb, ds);
+	if (ret)
+		return ret;
+
+	return 0;
+}
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/progs/fsck.c	2007-05-07 13:32:12.000000000 +0200
@@ -0,0 +1,323 @@
+#include "../logfs.h"
+
+static u64 used_bytes;
+static u64 free_bytes;
+static u64 last_ino;
+static u64 *inode_bytes;
+static u64 *inode_links;
+
+
+/**
+ * Pass 1: blocks
+ */
+
+
+static void safe_read(struct super_block *sb, u32 segno, u32 ofs,
+		size_t len, void *buf)
+{
+	BUG_ON(wbuf_read(sb, dev_ofs(sb, segno, ofs), len, buf));
+}
+static u32 logfs_free_bytes(struct super_block *sb, u32 segno)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_segment_header sh;
+	struct logfs_object_header h;
+	u64 ofs, ino, pos;
+	u32 seg_ofs, free, size;
+	u16 len;
+	void *reserved;
+
+	/* Some segments are reserved.  Just pretend they were all valid */
+	reserved = btree_lookup(&super->s_reserved_segments, segno);
+	if (reserved)
+		return 0;
+
+	safe_read(sb, segno, 0, sizeof(sh), &sh);
+	if (all_ff(&sh, sizeof(sh)))
+		return super->s_segsize;
+
+	free = super->s_segsize;
+	for (seg_ofs = sizeof(h); seg_ofs + sizeof(h) < super->s_segsize; ) {
+		safe_read(sb, segno, seg_ofs, sizeof(h), &h);
+		if (all_ff(&h, sizeof(h)))
+			break;
+
+		ofs = dev_ofs(sb, segno, seg_ofs);
+		ino = be64_to_cpu(h.ino);
+		pos = be64_to_cpu(h.pos);
+		len = be16_to_cpu(h.len);
+		size = (u32)be16_to_cpu(h.len) + sizeof(h);
+		if (logfs_is_valid_block(sb, ofs, ino, pos)) {
+			if (sh.level != 0)
+				len = sb->s_blocksize;
+			inode_bytes[ino] += len + sizeof(h);
+			free -= len + sizeof(h);
+		}
+		seg_ofs += size;
+	}
+	return free;
+}
+
+
+static void logfsck_blocks(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int i;
+	int free;
+
+	for (i=0; i<super->s_no_segs; i++) {
+		free = logfs_free_bytes(sb, i);
+		free_bytes += free;
+		printk(" %3x", free);
+		if (i % 8 == 7)
+			printk(" : ");
+		if (i % 16 == 15)
+			printk("\n");
+	}
+	printk("\n");
+}
+
+
+/**
+ * Pass 2: directories
+ */
+
+
+static noinline int read_one_dd(struct inode *dir, loff_t pos, u64 *ino,
+		u8 *type)
+{
+	struct logfs_disk_dentry dd;
+	int err;
+
+	err = logfs_inode_read(dir, &dd, sizeof(dd), pos);
+	if (err)
+		return err;
+	*ino = be64_to_cpu(dd.ino);
+	*type = dd.type;
+	return 0;
+}
+
+
+static s64 dir_seek_data(struct inode *inode, s64 pos)
+{
+	s64 new_pos = logfs_seek_data(inode, pos);
+	return max((s64)pos, new_pos - 1);
+}
+
+
+static int __logfsck_dirs(struct inode *dir)
+{
+	struct inode *inode;
+	loff_t pos;
+	u64 ino;
+	u8 type;
+	int cookie, err, ret = 0;
+
+	for (pos=0; ; pos++) {
+		err = read_one_dd(dir, pos, &ino, &type);
+		//yield();
+		if (err == -ENODATA) { /* dentry was deleted */
+			pos = dir_seek_data(dir, pos);
+			continue;
+		}
+		if (err == -EOF)
+			break;
+		if (err)
+			goto error0;
+
+		err = -EIO;
+		if (ino > last_ino) {
+			printk("ino %llx > last_ino %llx\n", ino, last_ino);
+			goto error0;
+		}
+		inode = logfs_iget(dir->i_sb, ino, &cookie);
+		if (!inode) {
+			printk("Could not find inode #%llx\n", ino);
+			goto error0;
+		}
+		if (type != logfs_type(inode)) {
+			printk("dd type %x != inode type %x\n", type,
+					logfs_type(inode));
+			goto error1;
+		}
+		inode_links[ino]++;
+		err = 0;
+		if (type == DT_DIR) {
+			inode_links[dir->i_ino]++;
+			inode_links[ino]++;
+			err = __logfsck_dirs(inode);
+		}
+error1:
+		logfs_iput(inode, cookie);
+error0:
+		if (!ret)
+			ret = err;
+		continue;
+	}
+	return 1;
+}
+
+
+static int logfsck_dirs(struct super_block *sb)
+{
+	struct inode *dir;
+	int cookie;
+
+	dir = logfs_iget(sb, LOGFS_INO_ROOT, &cookie);
+	if (!dir)
+		return 0;
+
+	inode_links[LOGFS_INO_MASTER] += 1;
+	inode_links[LOGFS_INO_ROOT] += 2;
+	__logfsck_dirs(dir);
+
+	logfs_iput(dir, cookie);
+	return 1;
+}
+
+
+/**
+ * Pass 3: inodes
+ */
+
+
+static int logfs_check_inode(struct inode *inode)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+	u64 bytes0 = li->li_used_bytes;
+	u64 bytes1 = inode_bytes[inode->i_ino];
+	u64 links0 = inode->i_nlink;
+	u64 links1 = inode_links[inode->i_ino];
+
+	if (bytes0 || bytes1 || links0 || links1
+			|| inode->i_ino == LOGFS_SUPER(inode->i_sb)->s_last_ino)
+		printk("%lx: %llx(%llx) bytes, %llx(%llx) links\n",
+				inode->i_ino, bytes0, bytes1, links0, links1);
+	used_bytes += bytes0;
+	return (bytes0 == bytes1) && (links0 == links1);
+}
+
+
+static int logfs_check_ino(struct super_block *sb, u64 ino)
+{
+	struct inode *inode;
+	int ret, cookie;
+
+	//yield();
+	inode = logfs_iget(sb, ino, &cookie);
+	if (!inode)
+		return 1;
+	ret = logfs_check_inode(inode);
+	logfs_iput(inode, cookie);
+	return ret;
+}
+
+
+static int logfsck_inodes(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	s64 i;
+	int ret = 1;
+
+	if (!logfs_check_ino(sb, LOGFS_INO_MASTER))
+		ret = 0;;
+	if (!logfs_check_ino(sb, LOGFS_INO_ROOT))
+		ret = 0;
+	for (i=16; i<super->s_last_ino; i++) {
+		i = dir_seek_data(super->s_master_inode, i);
+		if (!logfs_check_ino(sb, i))
+			ret = 0;;
+	}
+	return ret;
+}
+
+
+/**
+ * Pass 4: Total blocks
+ */
+
+
+static int logfsck_stats(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	u64 ostore_segs, total, expected;
+	int i, reserved_segs;
+
+	reserved_segs = 1; /* super_block */
+	journal_for_each(i)
+		if (super->s_journal_seg[i])
+			reserved_segs++;
+	reserved_segs += super->s_bad_segments;
+
+	ostore_segs = super->s_no_segs - reserved_segs;
+	expected = ostore_segs << super->s_segshift;
+	total = free_bytes + used_bytes;
+
+	printk("free:%8llx, used:%8llx, total:%8llx",
+			free_bytes, used_bytes, expected);
+	if (total > expected)
+		printk(" + %llx\n", total - expected);
+	else if (total < expected)
+		printk(" - %llx\n", expected - total);
+	else
+		printk("\n");
+
+	return total == expected;
+}
+
+
+static int __logfs_fsck(struct super_block *sb)
+{
+	int ret;
+	int err = 0;
+
+	/* pass 1: check blocks */
+	logfsck_blocks(sb);
+	/* pass 2: check directories */
+	ret = logfsck_dirs(sb);
+	if (!ret) {
+		printk("Pass 2: directory check failed\n");
+		err = -EIO;
+	}
+	/* pass 3: check inodes */
+	ret = logfsck_inodes(sb);
+	if (!ret) {
+		printk("Pass 3: inode check failed\n");
+		err = -EIO;
+	}
+	/* Pass 4: Total blocks */
+	ret = logfsck_stats(sb);
+	if (!ret) {
+		printk("Pass 4: statistic check failed\n");
+		err = -EIO;
+	}
+
+	return err;
+}
+
+
+int logfs_fsck(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int ret = -ENOMEM;
+
+	used_bytes = 0;
+	free_bytes = 0;
+	last_ino = super->s_last_ino;
+	inode_bytes = kzalloc(last_ino * sizeof(be64), GFP_KERNEL);
+	if (!inode_bytes)
+		goto out0;
+	inode_links = kzalloc(last_ino * sizeof(be64), GFP_KERNEL);
+	if (!inode_links)
+		goto out1;
+
+	ret = __logfs_fsck(sb);
+
+	kfree(inode_links);
+	inode_links = NULL;
+out1:
+	kfree(inode_bytes);
+	inode_bytes = NULL;
+out0:
+	return ret;
+}
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/Locking	2007-05-07 13:32:12.000000000 +0200
@@ -0,0 +1,45 @@
+Locks:
+
+s_victim_mutex
+Protects victim inode for create, unlink, mkdir, rmdir, mknod, link,
+symlink and one variant of rename.  Only one victim inode may exist at
+a time.  In case of unclean unmount, victim inode has to be deleted
+before next read-writable mount.
+
+s_rename_mutex
+Protects victim dd for rename.  Only one victim dd may exist at a
+time.  In case of unclean unmount, victim dd has to be deleted before
+next read-writable mount.
+
+s_write_inode_mutex
+Taken when writing an inode.  Deleted inodes can be locked, preventing
+further iget operations during writeout.  Logfs may need to iget the
+inode for garbage collection, so the inode in question needs to be
+stored in the superblock and used directly without calling iget.
+
+s_log_sem
+Used for allocating space in journal.
+
+s_r_sem
+Protects the memory required for reads from the filesystem.
+
+s_w_sem
+Protects the memory required for writes to the filesystem.
+
+s_ino_lock
+Protects s_last_ino.
+
+
+Lock order:
+s_rename_mutex --> s_victim_mutex
+s_rename_mutex --> s_write_inode_mutex
+s_rename_mutex --> s_w_sem
+
+s_victim_mutex --> s_write_inode_mutex
+s_victim_mutex --> s_w_sem
+s_victim_mutex --> s_ino_lock
+
+s_write_inode_mutex --> s_w_sem
+
+s_w_sem --> s_log_sem
+s_w_sem --> s_r_sem
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/compr.c	2007-05-07 13:32:12.000000000 +0200
@@ -0,0 +1,198 @@
+#include "logfs.h"
+#include <linux/vmalloc.h>
+#include <linux/zlib.h>
+
+#define COMPR_LEVEL 3
+
+static DEFINE_MUTEX(compr_mutex);
+static struct z_stream_s stream;
+
+
+int logfs_memcpy(void *in, void *out, size_t inlen, size_t outlen)
+{
+	if (outlen < inlen)
+		return -EIO;
+	memcpy(out, in, inlen);
+	return inlen;
+}
+
+
+int logfs_compress_vec(struct kvec *vec, int count, void *out, size_t outlen)
+{
+	int i, ret;
+
+	mutex_lock(&compr_mutex);
+	ret = zlib_deflateInit(&stream, COMPR_LEVEL);
+	if (ret != Z_OK)
+		goto error;
+
+	stream.total_in = 0;
+	stream.total_out = 0;
+
+	for (i=0; i<count-1; i++) {
+		stream.next_in = vec[i].iov_base;
+		stream.avail_in = vec[i].iov_len;
+		stream.next_out = out + stream.total_out;
+		stream.avail_out = outlen - stream.total_out;
+
+		ret = zlib_deflate(&stream, Z_NO_FLUSH);
+		if (ret != Z_OK)
+			goto error;
+		/* if (stream.total_out >= outlen)
+			goto error; */
+	}
+
+	stream.next_in = vec[count-1].iov_base;
+	stream.avail_in = vec[count-1].iov_len;
+	stream.next_out = out + stream.total_out;
+	stream.avail_out = outlen - stream.total_out;
+
+	ret = zlib_deflate(&stream, Z_FINISH);
+	if (ret != Z_STREAM_END)
+		goto error;
+	/* if (stream.total_out >= outlen)
+		goto error; */
+
+	ret = zlib_deflateEnd(&stream);
+	if (ret != Z_OK)
+		goto error;
+
+	if (stream.total_out >= stream.total_in)
+		goto error;
+
+	ret = stream.total_out;
+	mutex_unlock(&compr_mutex);
+	return ret;
+error:
+	mutex_unlock(&compr_mutex);
+	return -EIO;
+}
+
+
+int logfs_compress(void *in, void *out, size_t inlen, size_t outlen)
+{
+	int ret;
+
+	mutex_lock(&compr_mutex);
+	ret = zlib_deflateInit(&stream, COMPR_LEVEL);
+	if (ret != Z_OK)
+		goto error;
+
+	stream.next_in = in;
+	stream.avail_in = inlen;
+	stream.total_in = 0;
+	stream.next_out = out;
+	stream.avail_out = outlen;
+	stream.total_out = 0;
+
+	ret = zlib_deflate(&stream, Z_FINISH);
+	if (ret != Z_STREAM_END)
+		goto error;
+
+	ret = zlib_deflateEnd(&stream);
+	if (ret != Z_OK)
+		goto error;
+
+	if (stream.total_out >= stream.total_in)
+		goto error;
+
+	ret = stream.total_out;
+	mutex_unlock(&compr_mutex);
+	return ret;
+error:
+	mutex_unlock(&compr_mutex);
+	return -EIO;
+}
+
+
+int logfs_uncompress_vec(void *in, size_t inlen, struct kvec *vec, int count)
+{
+	int i, ret;
+
+	mutex_lock(&compr_mutex);
+	ret = zlib_inflateInit(&stream);
+	if (ret != Z_OK)
+		goto error;
+
+	stream.total_in = 0;
+	stream.total_out = 0;
+
+	for (i=0; i<count-1; i++) {
+		stream.next_in = in + stream.total_in;
+		stream.avail_in = inlen - stream.total_in;
+		stream.next_out = vec[i].iov_base;
+		stream.avail_out = vec[i].iov_len;
+
+		ret = zlib_inflate(&stream, Z_NO_FLUSH);
+		if (ret != Z_OK)
+			goto error;
+	}
+	stream.next_in = in + stream.total_in;
+	stream.avail_in = inlen - stream.total_in;
+	stream.next_out = vec[count-1].iov_base;
+	stream.avail_out = vec[count-1].iov_len;
+
+	ret = zlib_inflate(&stream, Z_FINISH);
+	if (ret != Z_STREAM_END)
+		goto error;
+
+	ret = zlib_inflateEnd(&stream);
+	if (ret != Z_OK)
+		goto error;
+
+	mutex_unlock(&compr_mutex);
+	return ret;
+error:
+	mutex_unlock(&compr_mutex);
+	return -EIO;
+}
+
+
+int logfs_uncompress(void *in, void *out, size_t inlen, size_t outlen)
+{
+	int ret;
+
+	mutex_lock(&compr_mutex);
+	ret = zlib_inflateInit(&stream);
+	if (ret != Z_OK)
+		goto error;
+
+	stream.next_in = in;
+	stream.avail_in = inlen;
+	stream.total_in = 0;
+	stream.next_out = out;
+	stream.avail_out = outlen;
+	stream.total_out = 0;
+
+	ret = zlib_inflate(&stream, Z_FINISH);
+	if (ret != Z_STREAM_END)
+		goto error;
+
+	ret = zlib_inflateEnd(&stream);
+	if (ret != Z_OK)
+		goto error;
+
+	mutex_unlock(&compr_mutex);
+	return ret;
+error:
+	mutex_unlock(&compr_mutex);
+	return -EIO;
+}
+
+
+int __init logfs_compr_init(void)
+{
+	size_t size = max(zlib_deflate_workspacesize(),
+			zlib_inflate_workspacesize());
+	printk("deflate size: %x\n", zlib_deflate_workspacesize());
+	printk("inflate size: %x\n", zlib_inflate_workspacesize());
+	stream.workspace = vmalloc(size);
+	if (!stream.workspace)
+		return -ENOMEM;
+	return 0;
+}
+
+void __exit logfs_compr_exit(void)
+{
+	vfree(stream.workspace);
+}
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/segment.c	2007-05-07 20:41:17.000000000 +0200
@@ -0,0 +1,533 @@
+#include "logfs.h"
+
+/* FIXME: combine with per-sb journal variant */
+static unsigned char compressor_buf[4096 + 24];
+static DEFINE_MUTEX(compr_mutex);
+
+
+int logfs_erase_segment(struct super_block *sb, u32 index)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+
+	super->s_gec++;
+
+	return mtderase(sb, index << super->s_segshift, super->s_segsize);
+}
+
+
+static s32 __logfs_get_free_bytes(struct logfs_area *area, u64 ino, u64 pos,
+		size_t bytes)
+{
+	s32 ofs;
+	int ret;
+
+	ret = logfs_open_area(area);
+	BUG_ON(ret>0);
+	if (ret)
+		return ret;
+
+	ofs = area->a_used_bytes;
+	area->a_used_bytes += bytes;
+	BUG_ON(area->a_used_bytes >= LOGFS_SUPER(area->a_sb)->s_segsize);
+
+	return dev_ofs(area->a_sb, area->a_segno, ofs);
+}
+
+
+void __logfs_set_blocks(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	inode->i_blocks = ULONG_MAX;
+	if (li->li_used_bytes >> sb->s_blocksize_bits < ULONG_MAX)
+		inode->i_blocks = li->li_used_bytes >> sb->s_blocksize_bits;
+}
+
+
+void logfs_set_blocks(struct inode *inode, u64 bytes)
+{
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	li->li_used_bytes = bytes;
+	__logfs_set_blocks(inode);
+}
+
+
+static void logfs_consume_bytes(struct inode *inode, int bytes)
+{
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	BUG_ON(li->li_used_bytes + bytes < bytes); /* wraps are bad, mkay */
+	super->s_free_bytes	-= bytes;
+	super->s_used_bytes	+= bytes;
+	li->li_used_bytes	+= bytes;
+	__logfs_set_blocks(inode);
+}
+
+
+static void logfs_remove_bytes(struct inode *inode, int bytes)
+{
+	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
+	struct logfs_inode *li = LOGFS_INODE(inode);
+
+	BUG_ON(li->li_used_bytes < bytes);
+	super->s_free_bytes	+= bytes;
+	super->s_used_bytes	-= bytes;
+	li->li_used_bytes	-= bytes;
+	__logfs_set_blocks(inode);
+}
+
+
+static int buf_write(struct logfs_area *area, u64 ofs, void *data, size_t len)
+{
+	struct super_block *sb = area->a_sb;
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	long write_mask = super->s_writesize - 1;
+	u64 buf_start;
+	size_t space, buf_ofs;
+	int err;
+
+	buf_ofs = (long)ofs & write_mask;
+	if (buf_ofs) {	/* buf already used - fill it */
+		space = super->s_writesize - buf_ofs;
+		if (len < space) {	/* not enough to fill it - just copy */
+			memcpy(area->a_wbuf + buf_ofs, data, len);
+			return 0;
+		}
+		/* enough data to fill and flush the buffer */
+		memcpy(area->a_wbuf + buf_ofs, data, space);
+		buf_start = ofs & ~write_mask;
+		err = mtdwrite(sb, buf_start, super->s_writesize, area->a_wbuf);
+		if (err)
+			return err;
+		ofs += space;
+		data += space;
+		len -= space;
+	}
+
+	/* write complete hunks */
+	space = len & ~write_mask;
+	if (space) {
+		err = mtdwrite(sb, ofs, space, data);
+		if (err)
+			return err;
+		ofs += space;
+		data += space;
+		len -= space;
+	}
+
+	/* store anything remaining in wbuf */
+	if (len)
+		memcpy(area->a_wbuf, data, len);
+	return 0;
+}
+
+
+static int adj_level(u64 ino, int level)
+{
+	BUG_ON(level >= LOGFS_MAX_LEVELS);
+
+	if (ino == LOGFS_INO_MASTER)	/* ifile has seperate areas */
+		level += LOGFS_MAX_LEVELS;
+	return level;
+}
+
+
+static struct logfs_area *get_area(struct super_block *sb, int level)
+{
+	return LOGFS_SUPER(sb)->s_area[level];
+}
+
+
+#define HEADER_SIZE sizeof(struct logfs_object_header)
+s64 __logfs_segment_write(struct inode *inode, void *buf, u64 pos, int level,
+		int alloc, int len, int compr)
+{
+	struct logfs_area *area;
+	struct super_block *sb = inode->i_sb;
+	u64 ofs;
+	u64 ino = inode->i_ino;
+	int err;
+	struct logfs_object_header h;
+
+	h.crc	= cpu_to_be32(0xcccccccc);
+	h.len	= cpu_to_be16(len);
+	h.type	= OBJ_BLOCK;
+	h.compr	= compr;
+	h.ino	= cpu_to_be64(inode->i_ino);
+	h.pos	= cpu_to_be64(pos);
+
+	level = adj_level(ino, level);
+	area = get_area(sb, level);
+	ofs = __logfs_get_free_bytes(area, ino, pos, len + HEADER_SIZE);
+	LOGFS_BUG_ON(ofs <= 0, sb);
+	//printk("alloc: (%llx, %llx, %llx, %x)\n", ino, pos, ret, level);
+
+	err = buf_write(area, ofs, &h, sizeof(h));
+	if (!err)
+		err = buf_write(area, ofs + HEADER_SIZE, buf, len);
+	BUG_ON(err);
+	if (err)
+		return err;
+	if (alloc) {
+		int acc_len = (level==0) ? len : sb->s_blocksize;
+		logfs_consume_bytes(inode, acc_len + HEADER_SIZE);
+	}
+
+	logfs_close_area(area); /* FIXME merge with open_area */
+
+	//printk("    (%llx, %llx, %llx)\n", ofs, ino, pos);
+
+	return ofs;
+}
+
+
+s64 logfs_segment_write(struct inode *inode, void *buf, u64 pos, int level,
+		int alloc)
+{
+	int bs = inode->i_sb->s_blocksize;
+	int compr_len;
+	s64 ofs;
+
+	if (level != 0) /* temporary disable compression for indirect blocks */
+		return __logfs_segment_write(inode, buf, pos, level, alloc, bs,
+				COMPR_NONE);
+
+	mutex_lock(&compr_mutex);
+	compr_len = logfs_compress(buf, compressor_buf, bs, bs);
+
+	if (compr_len >= 0) {
+		ofs = __logfs_segment_write(inode, compressor_buf, pos, level,
+				alloc, compr_len, COMPR_ZLIB);
+	} else {
+		ofs = __logfs_segment_write(inode, buf, pos, level, alloc, bs,
+				COMPR_NONE);
+	}
+	mutex_unlock(&compr_mutex);
+	return ofs;
+}
+
+
+/* FIXME: all this mess should get replaced by using the page cache */
+static void fixup_from_wbuf(struct super_block *sb, struct logfs_area *area,
+		void *read, u64 ofs, size_t readlen)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	u32 read_start = ofs & (super->s_segsize - 1);
+	u32 read_end = read_start + readlen;
+	u32 writemask = super->s_writesize - 1;
+	u32 buf_start = area->a_used_bytes & ~writemask;
+	u32 buf_end = area->a_used_bytes;
+	void *buf = area->a_wbuf;
+	size_t buflen = buf_end - buf_start;
+
+	if (read_end < buf_start)
+		return;
+	if ((ofs & (super->s_segsize - 1)) >= area->a_used_bytes) {
+		memset(read, 0xff, readlen);
+		return;
+	}
+
+	if (buf_start > read_start) {
+		read += buf_start - read_start;
+		readlen -= buf_start - read_start;
+	} else {
+		buf += read_start - buf_start;
+		buflen -= read_start - buf_start;
+	}
+	memcpy(read, buf, min(readlen, buflen));
+	if (buflen < readlen)
+		memset(read + buflen, 0xff, readlen - buflen);
+}
+
+
+int wbuf_read(struct super_block *sb, u64 ofs, size_t len, void *buf)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	struct logfs_area *area;
+	u32 segno = ofs >> super->s_segshift;
+	int i, err;
+
+	err = mtdread(sb, ofs, len, buf);
+	if (err)
+		return err;
+
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		area = super->s_area[i];
+		if (area->a_segno == segno) {
+			fixup_from_wbuf(sb, area, buf, ofs, len);
+			break;
+		}
+	}
+	return 0;
+}
+
+
+int logfs_segment_read(struct super_block *sb, void *buf, u64 ofs)
+{
+	struct logfs_object_header *h;
+	u16 len;
+	int err, bs = sb->s_blocksize;
+
+	mutex_lock(&compr_mutex);
+	err = wbuf_read(sb, ofs, bs+24, compressor_buf);
+	if (err)
+		goto out;
+	h = (void*)compressor_buf;
+	len = be16_to_cpu(h->len);
+
+	switch (h->compr) {
+	case COMPR_NONE:
+		logfs_memcpy(compressor_buf+24, buf, bs, bs);
+		break;
+	case COMPR_ZLIB:
+		err = logfs_uncompress(compressor_buf+24, buf, len, bs);
+		BUG_ON(err);
+		break;
+	default:
+		LOGFS_BUG(sb);
+	}
+out:
+	mutex_unlock(&compr_mutex);
+	return err;
+}
+
+
+static u64 logfs_block_mask[] = {
+	~0,
+	~(I1_BLOCKS-1),
+	~(I2_BLOCKS-1),
+	~(I3_BLOCKS-1)
+};
+static int check_pos(struct super_block *sb, u64 pos1, u64 pos2, int level)
+{
+	LOGFS_BUG_ON(	(pos1 & logfs_block_mask[level]) !=
+			(pos2 & logfs_block_mask[level]), sb);
+}
+int logfs_segment_delete(struct inode *inode, u64 ofs, u64 pos, int level)
+{
+	struct super_block *sb = inode->i_sb;
+	struct logfs_object_header *h;
+	u16 len;
+	int err;
+
+
+	mutex_lock(&compr_mutex);
+	err = wbuf_read(sb, ofs, 4096+24, compressor_buf);
+	LOGFS_BUG_ON(err, sb);
+	h = (void*)compressor_buf;
+	len = be16_to_cpu(h->len);
+	check_pos(sb, pos, be64_to_cpu(h->pos), level);
+	mutex_unlock(&compr_mutex);
+
+	level = adj_level(inode->i_ino, level);
+	len = (level==0) ? len : sb->s_blocksize;
+	logfs_remove_bytes(inode, len + sizeof(*h));
+	return 0;
+}
+
+
+int logfs_open_area(struct logfs_area *area)
+{
+	if (area->a_is_open)
+		return 0; /* nothing to do */
+
+	area->a_ops->get_free_segment(area);
+	area->a_used_objects = 0;
+	area->a_used_bytes = 0;
+	area->a_ops->get_erase_count(area);
+
+	area->a_ops->clear_blocks(area);
+	area->a_is_open = 1;
+
+	return area->a_ops->erase_segment(area);
+}
+
+
+void logfs_close_area(struct logfs_area *area)
+{
+	if (!area->a_is_open)
+		return;
+
+	area->a_ops->finish_area(area);
+}
+
+
+static void ostore_get_free_segment(struct logfs_area *area)
+{
+	struct logfs_super *super = LOGFS_SUPER(area->a_sb);
+	struct logfs_segment *seg;
+
+	BUG_ON(list_empty(&super->s_free_list));
+
+	seg = list_entry(super->s_free_list.prev, struct logfs_segment, list);
+	list_del(&seg->list);
+	area->a_segno = seg->segno;
+	kfree(seg);
+	super->s_free_count -= 1;
+}
+
+
+static void ostore_get_erase_count(struct logfs_area *area)
+{
+	struct logfs_segment_header h;
+
+	device_read(area->a_sb, area->a_segno, 0, sizeof(h), &h);
+	area->a_erase_count = be32_to_cpu(h.ec) + 1;
+}
+
+
+static void ostore_clear_blocks(struct logfs_area *area)
+{
+	size_t writesize = LOGFS_SUPER(area->a_sb)->s_writesize;
+
+	if (area->a_wbuf)
+		memset(area->a_wbuf, 0, writesize);
+}
+
+
+static int ostore_erase_segment(struct logfs_area *area)
+{
+	struct logfs_segment_header h;
+	u64 ofs;
+	int err;
+
+	err = logfs_erase_segment(area->a_sb, area->a_segno);
+	if (err)
+		return err;
+
+	h.len = 0;
+	h.type = OBJ_OSTORE;
+	h.level = area->a_level;
+	h.segno = cpu_to_be32(area->a_segno);
+	h.ec = cpu_to_be32(area->a_erase_count);
+	h.gec = cpu_to_be64(LOGFS_SUPER(area->a_sb)->s_gec);
+	h.crc = logfs_crc32(&h, sizeof(h), 4);
+	/* FIXME: write it out */
+
+	ofs = dev_ofs(area->a_sb, area->a_segno, 0);
+	area->a_used_bytes = sizeof(h);
+	return buf_write(area, ofs, &h, sizeof(h));
+}
+
+
+static void flush_buf(struct logfs_area *area)
+{
+	struct super_block *sb = area->a_sb;
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	u32 used, free;
+	u64 ofs;
+	u32 writemask = super->s_writesize - 1;
+	int err;
+
+	ofs = dev_ofs(sb, area->a_segno, area->a_used_bytes);
+	ofs &= ~writemask;
+	used = area->a_used_bytes & writemask;
+	free = super->s_writesize - area->a_used_bytes;
+	free &= writemask;
+	//printk("flush(%llx, %x, %x)\n", ofs, used, free);
+	if (used == 0)
+		return;
+
+	TRACE();
+	memset(area->a_wbuf + used, 0xff, free);
+	err = mtdwrite(sb, ofs, super->s_writesize, area->a_wbuf);
+	LOGFS_BUG_ON(err, sb);
+}
+
+
+static void ostore_finish_area(struct logfs_area *area)
+{
+	struct super_block *sb = area->a_sb;
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	u32 remaining = super->s_segsize - area->a_used_bytes;
+	u32 needed = sb->s_blocksize + sizeof(struct logfs_segment_header);
+
+	if (remaining > needed)
+		return;
+
+	flush_buf(area);
+
+	area->a_segno = 0;
+	area->a_is_open = 0;
+}
+
+
+static struct logfs_area_ops ostore_area_ops = {
+	.get_free_segment	= ostore_get_free_segment,
+	.get_erase_count	= ostore_get_erase_count,
+	.clear_blocks		= ostore_clear_blocks,
+	.erase_segment		= ostore_erase_segment,
+	.finish_area		= ostore_finish_area,
+};
+
+
+static void cleanup_ostore_area(struct logfs_area *area)
+{
+	kfree(area->a_wbuf);
+	kfree(area);
+}
+
+
+static void *init_ostore_area(struct super_block *sb, int level)
+{
+	struct logfs_area *area;
+	size_t writesize;
+
+	writesize = LOGFS_SUPER(sb)->s_writesize;
+
+	area = kzalloc(sizeof(*area), GFP_KERNEL);
+	if (!area)
+		return NULL;
+	if (writesize > 1) {
+		area->a_wbuf = kmalloc(writesize, GFP_KERNEL);
+		if (!area->a_wbuf)
+			goto err;
+	}
+
+	area->a_sb = sb;
+	area->a_level = level;
+	area->a_ops = &ostore_area_ops;
+	return area;
+
+err:
+	cleanup_ostore_area(area);
+	return NULL;
+}
+
+
+int logfs_init_areas(struct super_block *sb)
+{
+	struct logfs_super *super = LOGFS_SUPER(sb);
+	int i;
+
+	super->s_journal_area = kzalloc(sizeof(struct logfs_area), GFP_KERNEL);
+	if (!super->s_journal_area)
+		return -ENOMEM;
+	super->s_journal_area->a_sb = sb;
+
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		super->s_area[i] = init_ostore_area(sb, i);
+		if (!super->s_area[i])
+			goto err;
+	}
+	return 0;
+
+err:
+	for (i--; i>=0; i--)
+		cleanup_ostore_area(super->s_area[i]);
+	kfree(super->s_journal_area);
+	return -ENOMEM;
+}
+
+
+void logfs_cleanup_areas(struct logfs_super *super)
+{
+	int i;
+
+	for (i=0; i<LOGFS_NO_AREAS; i++)
+		cleanup_ostore_area(super->s_area[i]);
+	kfree(super->s_journal_area);
+}
--- /dev/null	2007-04-18 05:32:26.652341749 +0200
+++ linux-2.6.21logfs/fs/logfs/memtree.c	2007-05-07 13:32:12.000000000 +0200
@@ -0,0 +1,199 @@
+/* In-memory B+Tree. */
+#include "logfs.h"
+
+#define BTREE_NODES 16	/* 32bit, 128 byte cacheline */
+//#define BTREE_NODES 8	/* 32bit,  64 byte cacheline */
+
+struct btree_node {
+	long val;
+	struct btree_node *node;
+};
+
+
+void btree_init(struct btree_head *head)
+{
+	head->node = NULL;
+	head->height = 0;
+	head->null_ptr = NULL;
+}
+
+
+void *btree_lookup(struct btree_head *head, long val)
+{
+	int i, height = head->height;
+	struct btree_node *node = head->node;
+
+	if (val == 0)
+		return head->null_ptr;
+
+	if (height == 0)
+		return NULL;
+
+	for ( ; height > 1; height--) {
+		for (i=0; i<BTREE_NODES; i++)
+			if (node[i].val <= val)
+				break;
+		node = node[i].node;
+	}
+
+	for (i=0; i<BTREE_NODES; i++)
+		if (node[i].val == val)
+			return node[i].node;
+
+	return NULL;
+}
+
+
+static void find_pos(struct btree_node *node, long val, int *pos, int *fill)
+{
+	int i;
+
+	for (i=0; i<BTREE_NODES; i++)
+		if (node[i].val <= val)
+			break;
+	*pos = i;
+	for (i=*pos; i<BTREE_NODES; i++)
+		if (node[i].val == 0)
+			break;
+	*fill = i;
+}
+
+
+static struct btree_node *find_level(struct btree_head *head, long val,
+		int level)
+{
+	struct btree_node *node = head->node;
+	int i, height = head->height;
+
+	for ( ; height > level; height--) {
+		for (i=0; i<BTREE_NODES; i++)
+			if (node[i].val <= val)
+				break;
+		node = node[i].node;
+	}
+	return node;
+}
+
+
+static int btree_grow(struct btree_head *head)
+{
+	struct btree_node *node;
+
+	node = kcalloc(BTREE_NODES, sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+	if (head->node) {
+		node->val = head->node[BTREE_NODES-1].val;
+		node->node = head->node;
+	}
+	head->node = node;
+	head->height++;
+	return 0;
+}
+
+
+static int btree_insert_level(struct btree_head *head, long val, void *ptr,
+		int level)
+{
+	struct btree_node *node;
+	int i, pos, fill, err;
+
+	if (val == 0) { /* 0 identifies empty slots, so special-case this */
+		BUG_ON(level != 1);
+		head->null_ptr = ptr;
+		return 0;
+	}
+
+	if (head->height < level) {
+		err = btree_grow(head);
+		if (err)
+			return err;
+	}
+
+retry:
+	node = find_level(head, val, level);
+	find_pos(node, val, &pos, &fill);
+	BUG_ON(node[pos].val == val);
+
+	if (fill == BTREE_NODES) { /* need to split node */
+		struct btree_node *new;
+
+		new = kcalloc(BTREE_NODES, sizeof(*node), GFP_KERNEL);
+		if (!new)
+			return -ENOMEM;
+		err = btree_insert_level(head, node[BTREE_NODES/2 - 1].val, new,
+				level+1);
+		if (err) {
+			kfree(new);
+			return err;
+		}
+		for (i=0; i<BTREE_NODES/2; i++) {
+			new[i].val = node[i].val;
+			new[i].node = node[i].node;
+			node[i].val = node[i + BTREE_NODES/2].val;
+			node[i].node = node[i + BTREE_NODES/2].node;
+			node[i + BTREE_NODES/2].val = 0;
+			node[i + BTREE_NODES/2].node = NULL;
+		}
+		goto retry;
+	}
+	BUG_ON(fill >= BTREE_NODES);
+
+	/* shift and insert */
+	for (i=fill; i>pos; i--) {
+		node[i].val = node[i-1].val;
+		node[i].node = node[i-1].node;
+	}
+	node[pos].val = val;
+	node[pos].node = ptr;
+
+	return 0;
+}
+
+
+int btree_insert(struct btree_head *head, long val, void *ptr)
+{
+	return btree_insert_level(head, val, ptr, 1);
+}
+
+
+static int btree_remove_level(struct btree_head *head, long val, int level)
+{
+	struct btree_node *node;
+	int i, pos, fill;
+
+	if (val == 0) { /* 0 identifies empty slots, so special-case this */
+		head->null_ptr = NULL;
+		return 0;
+	}
+
+	node = find_level(head, val, level);
+	find_pos(node, val, &pos, &fill);
+	if (level == 1)
+		BUG_ON(node[pos].val != val);
+
+	/* remove and shift */
+	for (i=pos; i<fill-1; i++) {
+		node[i].val = node[i+1].val;
+		node[i].node = node[i+1].node;
+	}
+	node[fill-1].val = 0;
+	node[fill-1].node = NULL;
+
+	if (fill-1 < BTREE_NODES/2) {
+		/* XXX */
+	}
+	if (fill-1 == 0) {
+		btree_remove_level(head, val, level+1);
+		kfree(node);
+		return 0;
+	}
+
+	return 0;
+}
+
+
+int btree_remove(struct btree_head *head, long val)
+{
+	return btree_remove_level(head, val, 1);
+}

Jörn

-- 
"Translations are and will always be problematic. They inflict violence
upon two languages." (translation from German)
