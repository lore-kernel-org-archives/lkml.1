Return-Path: <linux-kernel-owner+w=401wt.eu-S1758423AbYDLXAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423AbYDLXAA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 19:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757517AbYDLW6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 18:58:54 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:35383 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbYDLW6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 18:58:49 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 4/7] omfs: add file routines
Date: Sat, 12 Apr 2008 18:58:38 -0400
Message-Id: <1208041121-26787-5-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Add functions for reading and manipulating the storage of file data in
    the extent-based OMFS.

    Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 fs/omfs/file.c |  342 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 342 insertions(+), 0 deletions(-)
 create mode 100644 fs/omfs/file.c

diff --git a/fs/omfs/file.c b/fs/omfs/file.c
new file mode 100644
index 0000000..2f14b82
--- /dev/null
+++ b/fs/omfs/file.c
@@ -0,0 +1,342 @@
+/*
+ * OMFS (as used by RIO Karma) file operations.
+ * Copyright (C) 2005 Bob Copeland <me@bobcopeland.com>
+ * Released under GPL v2.
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/mpage.h>
+#include "omfs.h"
+
+static int omfs_sync_file(struct file *file, struct dentry *dentry,
+		int datasync)
+{
+	struct inode *inode = dentry->d_inode;
+	int err;
+
+	err = sync_mapping_buffers(inode->i_mapping);
+	if (!(inode->i_state & I_DIRTY))
+		return err;
+	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
+		return err;
+	err |= omfs_sync_inode(inode);
+	return err ? -EIO : 0;
+}
+
+void omfs_make_empty_table(struct buffer_head *bh, int offset)
+{
+	struct omfs_extent *oe = (struct omfs_extent *) &bh->b_data[offset];
+
+	oe->e_next = ~0ULL;
+	oe->e_extent_count = cpu_to_be32(1),
+	oe->e_fill = cpu_to_be32(0x22),
+	oe->e_entry.e_cluster = ~0ULL;
+	oe->e_entry.e_blocks = ~0ULL;
+}
+
+int omfs_shrink_inode(struct inode *inode)
+{
+	struct omfs_sb_info *sbi = OMFS_SB(inode->i_sb);
+	struct omfs_extent *oe;
+	struct omfs_extent_entry *entry;
+	struct buffer_head *bh;
+	u64 next, last;
+	u32 extent_count;
+
+	/* traverse extent table, freeing each entry that is greater
+	 * than inode->i_size;
+	 */
+	next = inode->i_ino;
+
+	/* only support truncate -> 0 for now */
+	if (inode->i_size != 0)
+		return -EIO;
+
+	bh = sb_bread(inode->i_sb, clus_to_blk(sbi, next));
+	if (!bh)
+		goto err;
+
+	oe = (struct omfs_extent *)(&bh->b_data[OMFS_EXTENT_START]);
+
+	for (;;) {
+
+		if (omfs_is_bad(sbi, (struct omfs_header *) bh->b_data, next)) {
+			brelse(bh);
+			break;
+		}
+
+		extent_count = be32_to_cpu(oe->e_extent_count);
+		last = next;
+		next = be64_to_cpu(oe->e_next);
+		entry = &oe->e_entry;
+
+		/* ignore last entry as it is the terminator */
+		for (; extent_count > 1; extent_count--) {
+			u64 start, count;
+			start = be64_to_cpu(entry->e_cluster);
+			count = be64_to_cpu(entry->e_blocks);
+
+			omfs_clear_range(inode->i_sb, start, (int) count);
+			entry++;
+		}
+		omfs_make_empty_table(bh, (char *) oe - bh->b_data);
+		mark_buffer_dirty(bh);
+		brelse(bh);
+
+		if (last != inode->i_ino)
+			omfs_clear_range(inode->i_sb, last, sbi->s_mirrors);
+
+		if (next == ~0)
+			break;
+
+		bh = sb_bread(inode->i_sb, clus_to_blk(sbi, next));
+		if (!bh)
+			goto err;
+		oe = (struct omfs_extent *) (&bh->b_data[OMFS_EXTENT_CONT]);
+	}
+	return 0;
+err:
+	return -ENOMEM;
+}
+
+static void omfs_truncate(struct inode *inode)
+{
+	omfs_shrink_inode(inode);
+	mark_inode_dirty(inode);
+}
+
+/*
+ * Add new blocks to the current extent, or create new entries/continuations
+ * as necessary.
+ */
+static int omfs_grow_extent(struct inode *inode, struct omfs_extent *oe,
+			u64 *ret_block)
+{
+	struct omfs_extent_entry *terminator;
+	struct omfs_extent_entry *entry = &oe->e_entry;
+	struct omfs_sb_info *sbi = OMFS_SB(inode->i_sb);
+	u32 extent_count = be32_to_cpu(oe->e_extent_count);
+	u64 new_block = 0;
+	u32 max_count;
+	int new_count;
+	int ret = 0;
+
+	/* reached the end of the extent table with no blocks mapped.
+	 * there are three possibilities for adding: grow last extent,
+	 * add a new extent to the current extent table, and add a
+	 * continuation inode.  in last two cases need an allocator for
+	 * sbi->s_cluster_size
+	 */
+
+	/* TODO: handle holes */
+
+	/* should always have a terminator */
+	if (extent_count < 1)
+		return -EIO;
+
+	/* trivially grow current extent, if next block is not taken */
+	terminator = entry + extent_count - 1;
+	if (extent_count > 1) {
+		entry = terminator-1;
+		new_block = be64_to_cpu(entry->e_cluster) +
+			be64_to_cpu(entry->e_blocks);
+
+		if (omfs_allocate_block(inode->i_sb, new_block)) {
+			entry->e_blocks =
+				cpu_to_be64(be64_to_cpu(entry->e_blocks) + 1);
+			terminator->e_blocks = ~(cpu_to_be64(
+				be64_to_cpu(~terminator->e_blocks) + 1));
+			goto out;
+		}
+	}
+	max_count = (sbi->s_sys_blocksize - OMFS_EXTENT_START -
+		sizeof(struct omfs_extent)) /
+		sizeof(struct omfs_extent_entry) + 1;
+
+	/* TODO: add a continuation block here */
+	if (be32_to_cpu(oe->e_extent_count) > max_count-1)
+		return -EIO;
+
+	/* try to allocate a new cluster */
+	ret = omfs_allocate_range(inode->i_sb, 1, sbi->s_clustersize,
+		&new_block, &new_count);
+	if (ret)
+		goto out_fail;
+
+	/* copy terminator down an entry */
+	entry = terminator;
+	terminator++;
+	memcpy(terminator, entry, sizeof(struct omfs_extent_entry));
+
+	entry->e_cluster = cpu_to_be64(new_block);
+	entry->e_blocks = cpu_to_be64((u64) new_count);
+
+	terminator->e_blocks = ~(cpu_to_be64(
+		be64_to_cpu(~terminator->e_blocks) + (u64) new_count));
+
+	/* write in new entry */
+	oe->e_extent_count = cpu_to_be32(1 + be32_to_cpu(oe->e_extent_count));
+
+out:
+	*ret_block = new_block;
+out_fail:
+	return ret;
+}
+
+/*
+ * Scans across the directory table for a given file block number.
+ * If block not found, return 0.
+ */
+static sector_t find_block(struct inode *inode, struct omfs_extent_entry *ent,
+			sector_t block, int count, int *left)
+{
+	/* count > 1 because of terminator */
+	sector_t searched = 0;
+	for (; count > 1; count--) {
+		int numblocks = clus_to_blk(OMFS_SB(inode->i_sb),
+			be64_to_cpu(ent->e_blocks));
+
+		if (block >= searched  &&
+		    block < searched + numblocks) {
+			/*
+			 * found it at cluster + (block - searched)
+			 * numblocks - (block - searched) is remainder
+			 */
+			*left = numblocks - (block - searched);
+			return clus_to_blk(OMFS_SB(inode->i_sb),
+				be64_to_cpu(ent->e_cluster)) +
+				block - searched;
+		}
+		searched += numblocks;
+		ent++;
+	}
+	return 0;
+}
+
+static int omfs_get_block(struct inode *inode, sector_t block,
+			  struct buffer_head *bh_result, int create)
+{
+	struct buffer_head *bh;
+	sector_t next, offset;
+	int ret = 0;
+	u64 new_block;
+	int extent_count;
+	struct omfs_extent *oe;
+	struct omfs_extent_entry *entry;
+	struct omfs_sb_info *sbi = OMFS_SB(inode->i_sb);
+	int max_blocks = bh_result->b_size >> inode->i_blkbits;
+	int remain;
+
+	bh = sb_bread(inode->i_sb, clus_to_blk(sbi, inode->i_ino));
+	if (!bh)
+		goto err;
+
+	oe = (struct omfs_extent *)(&bh->b_data[OMFS_EXTENT_START]);
+	next = inode->i_ino;
+
+	for (;;) {
+
+		if (omfs_is_bad(sbi, (struct omfs_header *) bh->b_data, next)) {
+			brelse(bh);
+			goto err;
+		}
+		extent_count = be32_to_cpu(oe->e_extent_count);
+		next = be64_to_cpu(oe->e_next);
+		entry = &oe->e_entry;
+
+		offset = find_block(inode, entry, block, extent_count, &remain);
+		if (offset > 0) {
+			brelse(bh);
+
+			map_bh(bh_result, inode->i_sb, offset);
+			if (remain > max_blocks)
+				remain = max_blocks;
+			bh_result->b_size = (remain << inode->i_blkbits);
+			return 0;
+		}
+		if (next == ~0)
+			break;
+
+		brelse(bh);
+		bh = sb_bread(inode->i_sb, clus_to_blk(sbi, next));
+		if (!bh)
+			goto err;
+		oe = (struct omfs_extent *) (&bh->b_data[OMFS_EXTENT_CONT]);
+	}
+	if (create) {
+		ret = omfs_grow_extent(inode, oe, &new_block);
+		if (ret == 0) {
+			mark_buffer_dirty(bh);
+			mark_inode_dirty(inode);
+			map_bh(bh_result, inode->i_sb,
+					clus_to_blk(sbi, new_block));
+		}
+	}
+	brelse(bh);
+	return ret;
+err:
+	return -EIO;
+}
+
+static int omfs_readpage(struct file *file, struct page *page)
+{
+	return block_read_full_page(page, omfs_get_block);
+}
+
+static int omfs_readpages(struct file *file, struct address_space *mapping,
+		struct list_head *pages, unsigned nr_pages)
+{
+	return mpage_readpages(mapping, pages, nr_pages, omfs_get_block);
+}
+
+static int omfs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	return block_write_full_page(page, omfs_get_block, wbc);
+}
+
+static int
+omfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
+{
+	return mpage_writepages(mapping, wbc, omfs_get_block);
+}
+
+static int omfs_prepare_write(struct file *file, struct page *page,
+	unsigned from, unsigned to)
+{
+	return block_prepare_write(page, from, to, omfs_get_block);
+}
+
+static sector_t omfs_bmap(struct address_space *mapping, sector_t block)
+{
+	return generic_block_bmap(mapping, block, omfs_get_block);
+}
+
+struct file_operations omfs_file_operations = {
+	.llseek = generic_file_llseek,
+	.read = do_sync_read,
+	.write = do_sync_write,
+	.aio_read = generic_file_aio_read,
+	.aio_write = generic_file_aio_write,
+	.mmap = generic_file_mmap,
+	.fsync = omfs_sync_file,
+	.splice_read = generic_file_splice_read,
+};
+
+struct inode_operations omfs_file_inops = {
+	.truncate = omfs_truncate
+};
+
+struct address_space_operations omfs_aops = {
+	.readpage = omfs_readpage,
+	.readpages = omfs_readpages,
+	.writepage = omfs_writepage,
+	.writepages = omfs_writepages,
+	.sync_page = block_sync_page,
+	.prepare_write = omfs_prepare_write,
+	.commit_write = generic_commit_write,
+	.bmap = omfs_bmap,
+};
+
-- 
1.5.4.2


