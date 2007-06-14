Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbXFNWRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbXFNWRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757778AbXFNWPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:15:43 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35389 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757749AbXFNWPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:15:42 -0400
Date: Fri, 15 Jun 2007 00:15:55 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] remove nobh_{prepare,commit}_write()
Message-ID: <20070614221555.GY3588@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nobh_{prepare,commit}_write() are no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/buffer.c                 |  175 ------------------------------------
 include/linux/buffer_head.h |    2 
 2 files changed, 177 deletions(-)

--- linux-2.6.22-rc4-mm2/include/linux/buffer_head.h.old	2007-06-14 01:54:54.000000000 +0200
+++ linux-2.6.22-rc4-mm2/include/linux/buffer_head.h	2007-06-14 01:55:08.000000000 +0200
@@ -224,8 +224,6 @@
 int generic_commit_write(struct file *, struct page *, unsigned, unsigned);
 int block_truncate_page(struct address_space *, loff_t, get_block_t *);
 int file_fsync(struct file *, struct dentry *, int);
-int nobh_prepare_write(struct page*, unsigned, unsigned, get_block_t*);
-int nobh_commit_write(struct file *, struct page *, unsigned, unsigned);
 int nobh_truncate_page(struct address_space *, loff_t);
 int nobh_writepage(struct page *page, get_block_t *get_block,
                         struct writeback_control *wbc);
--- linux-2.6.22-rc4-mm2/fs/buffer.c.old	2007-06-14 01:55:22.000000000 +0200
+++ linux-2.6.22-rc4-mm2/fs/buffer.c	2007-06-14 01:56:12.000000000 +0200
@@ -2315,181 +2315,6 @@
 
 
 /*
- * nobh_prepare_write()'s prereads are special: the buffer_heads are freed
- * immediately, while under the page lock.  So it needs a special end_io
- * handler which does not touch the bh after unlocking it.
- *
- * Note: unlock_buffer() sort-of does touch the bh after unlocking it, but
- * a race there is benign: unlock_buffer() only use the bh's address for
- * hashing after unlocking the buffer, so it doesn't actually touch the bh
- * itself.
- */
-static void end_buffer_read_nobh(struct buffer_head *bh, int uptodate)
-{
-	if (uptodate) {
-		set_buffer_uptodate(bh);
-	} else {
-		/* This happens, due to failed READA attempts. */
-		clear_buffer_uptodate(bh);
-	}
-	unlock_buffer(bh);
-}
-
-/*
- * On entry, the page is fully not uptodate.
- * On exit the page is fully uptodate in the areas outside (from,to)
- */
-int nobh_prepare_write(struct page *page, unsigned from, unsigned to,
-			get_block_t *get_block)
-{
-	struct inode *inode = page->mapping->host;
-	const unsigned blkbits = inode->i_blkbits;
-	const unsigned blocksize = 1 << blkbits;
-	struct buffer_head map_bh;
-	struct buffer_head *read_bh[MAX_BUF_PER_PAGE];
-	unsigned block_in_page;
-	unsigned block_start;
-	sector_t block_in_file;
-	char *kaddr;
-	int nr_reads = 0;
-	int i;
-	int ret = 0;
-	int is_mapped_to_disk = 1;
-
-	if (PageMappedToDisk(page))
-		return 0;
-
-	block_in_file = (sector_t)page->index << (PAGE_CACHE_SHIFT - blkbits);
-	map_bh.b_page = page;
-
-	/*
-	 * We loop across all blocks in the page, whether or not they are
-	 * part of the affected region.  This is so we can discover if the
-	 * page is fully mapped-to-disk.
-	 */
-	for (block_start = 0, block_in_page = 0;
-		  block_start < PAGE_CACHE_SIZE;
-		  block_in_page++, block_start += blocksize) {
-		unsigned block_end = block_start + blocksize;
-		int create;
-
-		map_bh.b_state = 0;
-		create = 1;
-		if (block_start >= to)
-			create = 0;
-		map_bh.b_size = blocksize;
-		ret = get_block(inode, block_in_file + block_in_page,
-					&map_bh, create);
-		if (ret)
-			goto failed;
-		if (!buffer_mapped(&map_bh))
-			is_mapped_to_disk = 0;
-		if (buffer_new(&map_bh))
-			unmap_underlying_metadata(map_bh.b_bdev,
-							map_bh.b_blocknr);
-		if (PageUptodate(page))
-			continue;
-		if (buffer_new(&map_bh) || !buffer_mapped(&map_bh)) {
-			kaddr = kmap_atomic(page, KM_USER0);
-			if (block_start < from)
-				memset(kaddr+block_start, 0, from-block_start);
-			if (block_end > to)
-				memset(kaddr + to, 0, block_end - to);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
-			continue;
-		}
-		if (buffer_uptodate(&map_bh))
-			continue;	/* reiserfs does this */
-		if (block_start < from || block_end > to) {
-			struct buffer_head *bh = alloc_buffer_head(GFP_NOFS);
-
-			if (!bh) {
-				ret = -ENOMEM;
-				goto failed;
-			}
-			bh->b_state = map_bh.b_state;
-			atomic_set(&bh->b_count, 0);
-			bh->b_this_page = NULL;
-			bh->b_page = page;
-			bh->b_blocknr = map_bh.b_blocknr;
-			bh->b_size = blocksize;
-			bh->b_data = (char *)(long)block_start;
-			bh->b_bdev = map_bh.b_bdev;
-			bh->b_private = NULL;
-			read_bh[nr_reads++] = bh;
-		}
-	}
-
-	if (nr_reads) {
-		struct buffer_head *bh;
-
-		/*
-		 * The page is locked, so these buffers are protected from
-		 * any VM or truncate activity.  Hence we don't need to care
-		 * for the buffer_head refcounts.
-		 */
-		for (i = 0; i < nr_reads; i++) {
-			bh = read_bh[i];
-			lock_buffer(bh);
-			bh->b_end_io = end_buffer_read_nobh;
-			submit_bh(READ, bh);
-		}
-		for (i = 0; i < nr_reads; i++) {
-			bh = read_bh[i];
-			wait_on_buffer(bh);
-			if (!buffer_uptodate(bh))
-				ret = -EIO;
-			free_buffer_head(bh);
-			read_bh[i] = NULL;
-		}
-		if (ret)
-			goto failed;
-	}
-
-	if (is_mapped_to_disk)
-		SetPageMappedToDisk(page);
-
-	return 0;
-
-failed:
-	for (i = 0; i < nr_reads; i++) {
-		if (read_bh[i])
-			free_buffer_head(read_bh[i]);
-	}
-
-	/*
-	 * Error recovery is pretty slack.  Clear the page and mark it dirty
-	 * so we'll later zero out any blocks which _were_ allocated.
-	 */
-	zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
-	SetPageUptodate(page);
-	set_page_dirty(page);
-	return ret;
-}
-EXPORT_SYMBOL(nobh_prepare_write);
-
-/*
- * Make sure any changes to nobh_commit_write() are reflected in
- * nobh_truncate_page(), since it doesn't call commit_write().
- */
-int nobh_commit_write(struct file *file, struct page *page,
-		unsigned from, unsigned to)
-{
-	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
-
-	SetPageUptodate(page);
-	set_page_dirty(page);
-	if (pos > inode->i_size) {
-		i_size_write(inode, pos);
-		mark_inode_dirty(inode);
-	}
-	return 0;
-}
-EXPORT_SYMBOL(nobh_commit_write);
-
-/*
  * nobh_writepage() - based on block_full_write_page() except
  * that it tries to operate without attaching bufferheads to
  * the page.

