Return-Path: <linux-kernel-owner+w=401wt.eu-S1423189AbXDXWXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423189AbXDXWXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423178AbXDXWXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:23:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56805 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423176AbXDXWXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:23:07 -0400
Message-Id: <20070424222306.547574664@sgi.com>
References: <20070424222105.883597089@sgi.com>
User-Agent: quilt/0.45-1
Date: Tue, 24 Apr 2007 15:21:14 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [09/17] Convert PAGE_CACHE_xxx -> page_cache_xxx function calls
Content-Disposition: inline; filename=var_pc_conversion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This transforms the page cache code to use page_cache_xxx calls.
Patch could be more complete.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/buffer.c                 |   99 +++++++++++++++++++++++++-------------------
 fs/libfs.c                  |   13 +++--
 fs/mpage.c                  |   30 +++++++------
 fs/sync.c                   |    8 +--
 include/linux/buffer_head.h |    9 +++-
 mm/fadvise.c                |    8 +--
 mm/filemap.c                |   58 ++++++++++++-------------
 mm/page-writeback.c         |    4 -
 mm/truncate.c               |   23 +++++-----
 9 files changed, 140 insertions(+), 112 deletions(-)

Index: linux-2.6.21-rc7/fs/libfs.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/libfs.c	2007-04-23 22:10:03.000000000 -0700
+++ linux-2.6.21-rc7/fs/libfs.c	2007-04-23 22:22:37.000000000 -0700
@@ -330,13 +330,15 @@ int simple_readpage(struct file *file, s
 int simple_prepare_write(struct file *file, struct page *page,
 			unsigned from, unsigned to)
 {
+	unsigned int page_size = page_cache_size(file->f_mapping);
+
 	if (!PageUptodate(page)) {
-		if (to - from != PAGE_CACHE_SIZE) {
+		if (to - from != page_size) {
 			if (from)
 				memclear_highpage_flush(page, 0, from);
-			if (to < PAGE_CACHE_SIZE)
+			if (to < page_size)
 				memclear_highpage_flush(page, to,
-					PAGE_CACHE_SIZE - to);
+					page_size - to);
 		}
 	}
 	return 0;
@@ -345,8 +347,9 @@ int simple_prepare_write(struct file *fi
 int simple_commit_write(struct file *file, struct page *page,
 			unsigned from, unsigned to)
 {
-	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+	loff_t pos = page_cache_pos(mapping, page->index, to);
 
 	if (!PageUptodate(page))
 		SetPageUptodate(page);
Index: linux-2.6.21-rc7/mm/filemap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/filemap.c	2007-04-23 22:10:08.000000000 -0700
+++ linux-2.6.21-rc7/mm/filemap.c	2007-04-23 22:22:41.000000000 -0700
@@ -302,8 +302,8 @@ int wait_on_page_writeback_range(struct 
 int sync_page_range(struct inode *inode, struct address_space *mapping,
 			loff_t pos, loff_t count)
 {
-	pgoff_t start = pos >> PAGE_CACHE_SHIFT;
-	pgoff_t end = (pos + count - 1) >> PAGE_CACHE_SHIFT;
+	pgoff_t start = page_cache_index(mapping, pos);
+	pgoff_t end = page_cache_index(mapping, pos + count - 1);
 	int ret;
 
 	if (!mapping_cap_writeback_dirty(mapping) || !count)
@@ -334,8 +334,8 @@ EXPORT_SYMBOL(sync_page_range);
 int sync_page_range_nolock(struct inode *inode, struct address_space *mapping,
 			   loff_t pos, loff_t count)
 {
-	pgoff_t start = pos >> PAGE_CACHE_SHIFT;
-	pgoff_t end = (pos + count - 1) >> PAGE_CACHE_SHIFT;
+	pgoff_t start = page_cache_index(mapping, pos);
+	pgoff_t end = page_cache_index(mapping, pos + count - 1);
 	int ret;
 
 	if (!mapping_cap_writeback_dirty(mapping) || !count)
@@ -364,7 +364,7 @@ int filemap_fdatawait(struct address_spa
 		return 0;
 
 	return wait_on_page_writeback_range(mapping, 0,
-				(i_size - 1) >> PAGE_CACHE_SHIFT);
+				page_cache_index(mapping, i_size - 1));
 }
 EXPORT_SYMBOL(filemap_fdatawait);
 
@@ -412,8 +412,8 @@ int filemap_write_and_wait_range(struct 
 		/* See comment of filemap_write_and_wait() */
 		if (err != -EIO) {
 			int err2 = wait_on_page_writeback_range(mapping,
-						lstart >> PAGE_CACHE_SHIFT,
-						lend >> PAGE_CACHE_SHIFT);
+					page_cache_index(mapping, lstart),
+					page_cache_index(mapping, lend));
 			if (!err)
 				err = err2;
 		}
@@ -878,27 +878,27 @@ void do_generic_mapping_read(struct addr
 	struct file_ra_state ra = *_ra;
 
 	cached_page = NULL;
-	index = *ppos >> PAGE_CACHE_SHIFT;
+	index = page_cache_index(mapping, *ppos);
 	next_index = index;
 	prev_index = ra.prev_page;
-	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
-	offset = *ppos & ~PAGE_CACHE_MASK;
+	last_index = page_cache_next(mapping, *ppos + desc->count);
+	offset = page_cache_offset(mapping, *ppos);
 
 	isize = i_size_read(inode);
 	if (!isize)
 		goto out;
 
-	end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+	end_index = page_cache_index(mapping, isize - 1);
 	for (;;) {
 		struct page *page;
 		unsigned long nr, ret;
 
 		/* nr is the maximum number of bytes to copy from this page */
-		nr = PAGE_CACHE_SIZE;
+		nr = page_cache_size(mapping);
 		if (index >= end_index) {
 			if (index > end_index)
 				goto out;
-			nr = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
+			nr = page_cache_offset(mapping, isize - 1) + 1;
 			if (nr <= offset) {
 				goto out;
 			}
@@ -947,8 +947,8 @@ page_ok:
 		 */
 		ret = actor(desc, page, offset, nr);
 		offset += ret;
-		index += offset >> PAGE_CACHE_SHIFT;
-		offset &= ~PAGE_CACHE_MASK;
+		index += page_cache_index(mapping, offset);
+		offset = page_cache_offset(mapping, offset);
 
 		page_cache_release(page);
 		if (ret == nr && desc->count)
@@ -1012,16 +1012,16 @@ readpage:
 		 * another truncate extends the file - this is desired though).
 		 */
 		isize = i_size_read(inode);
-		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+		end_index = page_cache_index(mapping, isize - 1);
 		if (unlikely(!isize || index > end_index)) {
 			page_cache_release(page);
 			goto out;
 		}
 
 		/* nr is the maximum number of bytes to copy from this page */
-		nr = PAGE_CACHE_SIZE;
+		nr = page_cache_size(mapping);
 		if (index == end_index) {
-			nr = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
+			nr = page_cache_offset(mapping, isize - 1) + 1;
 			if (nr <= offset) {
 				page_cache_release(page);
 				goto out;
@@ -1064,7 +1064,7 @@ no_cached_page:
 out:
 	*_ra = ra;
 
-	*ppos = ((loff_t) index << PAGE_CACHE_SHIFT) + offset;
+	*ppos = page_cache_pos(mapping, index, offset);
 	if (cached_page)
 		page_cache_release(cached_page);
 	if (filp)
@@ -1260,8 +1260,8 @@ asmlinkage ssize_t sys_readahead(int fd,
 	if (file) {
 		if (file->f_mode & FMODE_READ) {
 			struct address_space *mapping = file->f_mapping;
-			unsigned long start = offset >> PAGE_CACHE_SHIFT;
-			unsigned long end = (offset + count - 1) >> PAGE_CACHE_SHIFT;
+			unsigned long start = page_cache_index(mapping, offset);
+			unsigned long end = page_cache_index(mapping, offset + count - 1);
 			unsigned long len = end - start + 1;
 			ret = do_readahead(mapping, file, start, len);
 		}
@@ -2076,9 +2076,9 @@ generic_file_buffered_write(struct kiocb
 		unsigned long offset;
 		size_t copied;
 
-		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
-		index = pos >> PAGE_CACHE_SHIFT;
-		bytes = PAGE_CACHE_SIZE - offset;
+		offset = page_cache_offset(mapping, pos);
+		index = page_cache_index(mapping, pos);
+		bytes = page_cache_size(mapping) - offset;
 
 		/* Limit the size of the copy to the caller's write size */
 		bytes = min(bytes, count);
@@ -2305,8 +2305,8 @@ __generic_file_aio_write_nolock(struct k
 		if (err == 0) {
 			written = written_buffered;
 			invalidate_mapping_pages(mapping,
-						 pos >> PAGE_CACHE_SHIFT,
-						 endbyte >> PAGE_CACHE_SHIFT);
+						 page_cache_index(mapping, pos),
+						 page_cache_index(mapping, endbyte));
 		} else {
 			/*
 			 * We don't know how much we wrote, so just return
@@ -2393,7 +2393,7 @@ generic_file_direct_IO(int rw, struct ki
 	 */
 	if (rw == WRITE) {
 		write_len = iov_length(iov, nr_segs);
-		end = (offset + write_len - 1) >> PAGE_CACHE_SHIFT;
+		end = page_cache_index(mapping, offset + write_len - 1);
 	       	if (mapping_mapped(mapping))
 			unmap_mapping_range(mapping, offset, write_len, 0);
 	}
@@ -2410,7 +2410,7 @@ generic_file_direct_IO(int rw, struct ki
 	 */
 	if (rw == WRITE && mapping->nrpages) {
 		retval = invalidate_inode_pages2_range(mapping,
-					offset >> PAGE_CACHE_SHIFT, end);
+					page_cache_index(mapping, offset), end);
 		if (retval)
 			goto out;
 	}
@@ -2428,7 +2428,7 @@ generic_file_direct_IO(int rw, struct ki
 	 */
 	if (rw == WRITE && mapping->nrpages) {
 		int err = invalidate_inode_pages2_range(mapping,
-					      offset >> PAGE_CACHE_SHIFT, end);
+					      page_cache_index(mapping, offset), end);
 		if (err && retval >= 0)
 			retval = err;
 	}
Index: linux-2.6.21-rc7/fs/sync.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/sync.c	2007-04-23 22:10:03.000000000 -0700
+++ linux-2.6.21-rc7/fs/sync.c	2007-04-23 22:14:27.000000000 -0700
@@ -254,8 +254,8 @@ int do_sync_file_range(struct file *file
 	ret = 0;
 	if (flags & SYNC_FILE_RANGE_WAIT_BEFORE) {
 		ret = wait_on_page_writeback_range(mapping,
-					offset >> PAGE_CACHE_SHIFT,
-					endbyte >> PAGE_CACHE_SHIFT);
+					page_cache_index(mapping, offset),
+					page_cache_index(mapping, endbyte));
 		if (ret < 0)
 			goto out;
 	}
@@ -269,8 +269,8 @@ int do_sync_file_range(struct file *file
 
 	if (flags & SYNC_FILE_RANGE_WAIT_AFTER) {
 		ret = wait_on_page_writeback_range(mapping,
-					offset >> PAGE_CACHE_SHIFT,
-					endbyte >> PAGE_CACHE_SHIFT);
+					page_cache_index(mapping, offset),
+					page_cache_index(mapping, endbyte));
 	}
 out:
 	return ret;
Index: linux-2.6.21-rc7/mm/fadvise.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/fadvise.c	2007-04-23 22:10:03.000000000 -0700
+++ linux-2.6.21-rc7/mm/fadvise.c	2007-04-23 22:22:36.000000000 -0700
@@ -79,8 +79,8 @@ asmlinkage long sys_fadvise64_64(int fd,
 		}
 
 		/* First and last PARTIAL page! */
-		start_index = offset >> PAGE_CACHE_SHIFT;
-		end_index = endbyte >> PAGE_CACHE_SHIFT;
+		start_index = page_cache_index(mapping, offset);
+		end_index = page_cache_index(mapping, endbyte);
 
 		/* Careful about overflow on the "+1" */
 		nrpages = end_index - start_index + 1;
@@ -100,8 +100,8 @@ asmlinkage long sys_fadvise64_64(int fd,
 			filemap_flush(mapping);
 
 		/* First and last FULL page! */
-		start_index = (offset+(PAGE_CACHE_SIZE-1)) >> PAGE_CACHE_SHIFT;
-		end_index = (endbyte >> PAGE_CACHE_SHIFT);
+		start_index = page_cache_next(mapping, offset);
+		end_index = page_cache_index(mapping, endbyte);
 
 		if (end_index >= start_index)
 			invalidate_mapping_pages(mapping, start_index,
Index: linux-2.6.21-rc7/mm/page-writeback.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/page-writeback.c	2007-04-23 22:10:03.000000000 -0700
+++ linux-2.6.21-rc7/mm/page-writeback.c	2007-04-23 22:14:27.000000000 -0700
@@ -606,8 +606,8 @@ int generic_writepages(struct address_sp
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
 	} else {
-		index = wbc->range_start >> PAGE_CACHE_SHIFT;
-		end = wbc->range_end >> PAGE_CACHE_SHIFT;
+		index = page_cache_index(mapping, wbc->range_start);
+		end = page_cache_index(mapping, wbc->range_end);
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
 		scanned = 1;
Index: linux-2.6.21-rc7/mm/truncate.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/truncate.c	2007-04-23 22:10:03.000000000 -0700
+++ linux-2.6.21-rc7/mm/truncate.c	2007-04-23 22:14:27.000000000 -0700
@@ -46,7 +46,8 @@ void do_invalidatepage(struct page *page
 
 static inline void truncate_partial_page(struct page *page, unsigned partial)
 {
-	memclear_highpage_flush(page, partial, PAGE_CACHE_SIZE-partial);
+	memclear_highpage_flush(page, partial,
+		compound_size(page) - partial);
 	if (PagePrivate(page))
 		do_invalidatepage(page, partial);
 }
@@ -94,7 +95,7 @@ truncate_complete_page(struct address_sp
 	if (page->mapping != mapping)
 		return;
 
-	cancel_dirty_page(page, PAGE_CACHE_SIZE);
+	cancel_dirty_page(page, page_cache_size(mapping));
 
 	if (PagePrivate(page))
 		do_invalidatepage(page, 0);
@@ -156,9 +157,9 @@ invalidate_complete_page(struct address_
 void truncate_inode_pages_range(struct address_space *mapping,
 				loff_t lstart, loff_t lend)
 {
-	const pgoff_t start = (lstart + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
+	const pgoff_t start = page_cache_next(mapping, lstart);
 	pgoff_t end;
-	const unsigned partial = lstart & (PAGE_CACHE_SIZE - 1);
+	const unsigned partial = page_cache_offset(mapping, lstart);
 	struct pagevec pvec;
 	pgoff_t next;
 	int i;
@@ -166,8 +167,9 @@ void truncate_inode_pages_range(struct a
 	if (mapping->nrpages == 0)
 		return;
 
-	BUG_ON((lend & (PAGE_CACHE_SIZE - 1)) != (PAGE_CACHE_SIZE - 1));
-	end = (lend >> PAGE_CACHE_SHIFT);
+	BUG_ON(page_cache_offset(mapping, lend) !=
+				page_cache_size(mapping) - 1);
+	end = page_cache_index(mapping, lend);
 
 	pagevec_init(&pvec, 0);
 	next = start;
@@ -402,9 +404,8 @@ int invalidate_inode_pages2_range(struct
 					 * Zap the rest of the file in one hit.
 					 */
 					unmap_mapping_range(mapping,
-					   (loff_t)page_index<<PAGE_CACHE_SHIFT,
-					   (loff_t)(end - page_index + 1)
-							<< PAGE_CACHE_SHIFT,
+					   page_cache_pos(mapping, page_index, 0),
+					   page_cache_pos(mapping, end - page_index + 1, 0),
 					    0);
 					did_range_unmap = 1;
 				} else {
@@ -412,8 +413,8 @@ int invalidate_inode_pages2_range(struct
 					 * Just zap this page
 					 */
 					unmap_mapping_range(mapping,
-					  (loff_t)page_index<<PAGE_CACHE_SHIFT,
-					  PAGE_CACHE_SIZE, 0);
+					  page_cache_pos(mapping, page_index, 0),
+					  page_cache_size(mapping), 0);
 				}
 			}
 			ret = do_launder_page(mapping, page);
Index: linux-2.6.21-rc7/fs/buffer.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/buffer.c	2007-04-23 22:10:03.000000000 -0700
+++ linux-2.6.21-rc7/fs/buffer.c	2007-04-23 22:22:35.000000000 -0700
@@ -259,7 +259,7 @@ __find_get_block_slow(struct block_devic
 	struct page *page;
 	int all_mapped = 1;
 
-	index = block >> (PAGE_CACHE_SHIFT - bd_inode->i_blkbits);
+	index = block >> (page_cache_shift(bd_mapping) - bd_inode->i_blkbits);
 	page = find_get_page(bd_mapping, index);
 	if (!page)
 		goto out;
@@ -733,7 +733,7 @@ int __set_page_dirty_buffers(struct page
 	if (page->mapping) {	/* Race with truncate? */
 		if (mapping_cap_account_dirty(mapping)) {
 			__inc_zone_page_state(page, NR_FILE_DIRTY);
-			task_io_account_write(PAGE_CACHE_SIZE);
+			task_io_account_write(page_cache_size(mapping));
 		}
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
@@ -879,10 +879,13 @@ struct buffer_head *alloc_page_buffers(s
 {
 	struct buffer_head *bh, *head;
 	long offset;
+	unsigned page_size = page_cache_size(page->mapping);
+
+	BUG_ON(size > page_size);
 
 try_again:
 	head = NULL;
-	offset = PAGE_SIZE;
+	offset = page_size;
 	while ((offset -= size) >= 0) {
 		bh = alloc_buffer_head(GFP_NOFS);
 		if (!bh)
@@ -1418,7 +1421,7 @@ void set_bh_page(struct buffer_head *bh,
 		struct page *page, unsigned long offset)
 {
 	bh->b_page = page;
-	BUG_ON(offset >= PAGE_SIZE);
+	VM_BUG_ON(offset >= page_cache_size(page->mapping));
 	if (PageHighMem(page))
 		/*
 		 * This catches illegal uses and preserves the offset:
@@ -1617,7 +1620,8 @@ static int __block_write_full_page(struc
 	 * handle that here by just cleaning them.
 	 */
 
-	block = (sector_t)page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	block = (sector_t)page->index <<
+		(compound_shift(page) - inode->i_blkbits);
 	head = page_buffers(page);
 	bh = head;
 
@@ -1767,8 +1771,8 @@ static int __block_prepare_write(struct 
 	struct buffer_head *bh, *head, *wait[2], **wait_bh=wait;
 
 	BUG_ON(!PageLocked(page));
-	BUG_ON(from > PAGE_CACHE_SIZE);
-	BUG_ON(to > PAGE_CACHE_SIZE);
+	BUG_ON(from > page_cache_size(inode->i_mapping));
+	BUG_ON(to > page_cache_size(inode->i_mapping));
 	BUG_ON(from > to);
 
 	blocksize = 1 << inode->i_blkbits;
@@ -1777,7 +1781,7 @@ static int __block_prepare_write(struct 
 	head = page_buffers(page);
 
 	bbits = inode->i_blkbits;
-	block = (sector_t)page->index << (PAGE_CACHE_SHIFT - bbits);
+	block = (sector_t)page->index << (page_cache_shift(inode->i_mapping) - bbits);
 
 	for(bh = head, block_start = 0; bh != head || !block_start;
 	    block++, block_start=block_end, bh = bh->b_this_page) {
@@ -1925,7 +1929,7 @@ int block_read_full_page(struct page *pa
 		create_empty_buffers(page, blocksize, 0);
 	head = page_buffers(page);
 
-	iblock = (sector_t)page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	iblock = (sector_t)page->index << (page_cache_shift(page->mapping) - inode->i_blkbits);
 	lblock = (i_size_read(inode)+blocksize-1) >> inode->i_blkbits;
 	bh = head;
 	nr = 0;
@@ -2046,10 +2050,11 @@ out:
 
 int generic_cont_expand(struct inode *inode, loff_t size)
 {
+	struct address_space *mapping = inode->i_mapping;
 	pgoff_t index;
 	unsigned int offset;
 
-	offset = (size & (PAGE_CACHE_SIZE - 1)); /* Within page */
+	offset = page_cache_offset(mapping, size);
 
 	/* ugh.  in prepare/commit_write, if from==to==start of block, we
 	** skip the prepare.  make sure we never send an offset for the start
@@ -2059,7 +2064,7 @@ int generic_cont_expand(struct inode *in
 		/* caller must handle this extra byte. */
 		offset++;
 	}
-	index = size >> PAGE_CACHE_SHIFT;
+	index = page_cache_index(mapping, size);
 
 	return __generic_cont_expand(inode, size, index, offset);
 }
@@ -2067,8 +2072,8 @@ int generic_cont_expand(struct inode *in
 int generic_cont_expand_simple(struct inode *inode, loff_t size)
 {
 	loff_t pos = size - 1;
-	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
-	unsigned int offset = (pos & (PAGE_CACHE_SIZE - 1)) + 1;
+	pgoff_t index = page_cache_index(inode->i_mapping, pos);
+	unsigned int offset = page_cache_offset(inode->i_mapping, pos) + 1;
 
 	/* prepare/commit_write can handle even if from==to==start of block. */
 	return __generic_cont_expand(inode, size, index, offset);
@@ -2089,30 +2094,31 @@ int cont_prepare_write(struct page *page
 	long status;
 	unsigned zerofrom;
 	unsigned blocksize = 1 << inode->i_blkbits;
+	unsigned page_size = page_cache_size(mapping);
 
-	while(page->index > (pgpos = *bytes>>PAGE_CACHE_SHIFT)) {
+	while(page->index > (pgpos = page_cache_index(mapping, *bytes))) {
 		status = -ENOMEM;
 		new_page = grab_cache_page(mapping, pgpos);
 		if (!new_page)
 			goto out;
 		/* we might sleep */
-		if (*bytes>>PAGE_CACHE_SHIFT != pgpos) {
+		if (page_cache_index(mapping, *bytes) != pgpos) {
 			unlock_page(new_page);
 			page_cache_release(new_page);
 			continue;
 		}
-		zerofrom = *bytes & ~PAGE_CACHE_MASK;
+		zerofrom = page_cache_offset(mapping, *bytes);
 		if (zerofrom & (blocksize-1)) {
 			*bytes |= (blocksize-1);
 			(*bytes)++;
 		}
 		status = __block_prepare_write(inode, new_page, zerofrom,
-						PAGE_CACHE_SIZE, get_block);
+							page_size, get_block);
 		if (status)
 			goto out_unmap;
 		memclear_highpage_flush(new_page, zerofrom,
-					PAGE_CACHE_SIZE - zerofrom);
-		generic_commit_write(NULL, new_page, zerofrom, PAGE_CACHE_SIZE);
+					page_size - zerofrom);
+		generic_commit_write(NULL, new_page, zerofrom, page_size);
 		unlock_page(new_page);
 		page_cache_release(new_page);
 	}
@@ -2122,7 +2128,7 @@ int cont_prepare_write(struct page *page
 		zerofrom = offset;
 	} else {
 		/* page covers the boundary, find the boundary offset */
-		zerofrom = *bytes & ~PAGE_CACHE_MASK;
+		zerofrom = page_cache_offset(mapping, *bytes);
 
 		/* if we will expand the thing last block will be filled */
 		if (to > zerofrom && (zerofrom & (blocksize-1))) {
@@ -2174,8 +2180,9 @@ int block_commit_write(struct page *page
 int generic_commit_write(struct file *file, struct page *page,
 		unsigned from, unsigned to)
 {
-	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+	loff_t pos = page_cache_pos(mapping, page->index, to);
 	__block_commit_write(inode,page,from,to);
 	/*
 	 * No need to use i_size_read() here, the i_size
@@ -2217,6 +2224,7 @@ static void end_buffer_read_nobh(struct 
 int nobh_prepare_write(struct page *page, unsigned from, unsigned to,
 			get_block_t *get_block)
 {
+	struct address_space *mapping = page->mapping;
 	struct inode *inode = page->mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
 	const unsigned blocksize = 1 << blkbits;
@@ -2224,6 +2232,7 @@ int nobh_prepare_write(struct page *page
 	struct buffer_head *read_bh[MAX_BUF_PER_PAGE];
 	unsigned block_in_page;
 	unsigned block_start;
+	unsigned page_size = page_cache_size(mapping);
 	sector_t block_in_file;
 	int nr_reads = 0;
 	int i;
@@ -2233,7 +2242,7 @@ int nobh_prepare_write(struct page *page
 	if (PageMappedToDisk(page))
 		return 0;
 
-	block_in_file = (sector_t)page->index << (PAGE_CACHE_SHIFT - blkbits);
+	block_in_file = (sector_t)page->index << (page_cache_shift(mapping) - blkbits);
 	map_bh.b_page = page;
 
 	/*
@@ -2242,7 +2251,7 @@ int nobh_prepare_write(struct page *page
 	 * page is fully mapped-to-disk.
 	 */
 	for (block_start = 0, block_in_page = 0;
-		  block_start < PAGE_CACHE_SIZE;
+		  block_start < page_size;
 		  block_in_page++, block_start += blocksize) {
 		unsigned block_end = block_start + blocksize;
 		int create;
@@ -2335,7 +2344,7 @@ failed:
 	 * Error recovery is pretty slack.  Clear the page and mark it dirty
 	 * so we'll later zero out any blocks which _were_ allocated.
 	 */
-	memclear_highpage_flush(page, 0, PAGE_SIZE);
+	memclear_highpage_flush(page, 0, page_cache_size(mapping));
 	SetPageUptodate(page);
 	set_page_dirty(page);
 	return ret;
@@ -2349,8 +2358,9 @@ EXPORT_SYMBOL(nobh_prepare_write);
 int nobh_commit_write(struct file *file, struct page *page,
 		unsigned from, unsigned to)
 {
-	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+	loff_t pos = page_cache_pos(mapping, page->index, to);
 
 	SetPageUptodate(page);
 	set_page_dirty(page);
@@ -2370,9 +2380,10 @@ EXPORT_SYMBOL(nobh_commit_write);
 int nobh_writepage(struct page *page, get_block_t *get_block,
 			struct writeback_control *wbc)
 {
-	struct inode * const inode = page->mapping->host;
+	struct address_space *mapping = page->mapping;
+	struct inode * const inode = mapping->host;
 	loff_t i_size = i_size_read(inode);
-	const pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
+	const pgoff_t end_index = page_cache_offset(mapping, i_size);
 	unsigned offset;
 	int ret;
 
@@ -2381,7 +2392,7 @@ int nobh_writepage(struct page *page, ge
 		goto out;
 
 	/* Is the page fully outside i_size? (truncate in progress) */
-	offset = i_size & (PAGE_CACHE_SIZE-1);
+	offset = page_cache_offset(mapping, i_size);
 	if (page->index >= end_index+1 || !offset) {
 		/*
 		 * The page may have dirty, unmapped buffers.  For example,
@@ -2404,7 +2415,8 @@ int nobh_writepage(struct page *page, ge
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	memclear_highpage_flush(page, offset, PAGE_CACHE_SIZE - offset);
+	memclear_highpage_flush(page, offset,
+			page_cache_size(mapping) - offset);
 out:
 	ret = mpage_writepage(page, get_block, wbc);
 	if (ret == -EAGAIN)
@@ -2420,8 +2432,8 @@ int nobh_truncate_page(struct address_sp
 {
 	struct inode *inode = mapping->host;
 	unsigned blocksize = 1 << inode->i_blkbits;
-	pgoff_t index = from >> PAGE_CACHE_SHIFT;
-	unsigned offset = from & (PAGE_CACHE_SIZE-1);
+	pgoff_t index = page_cache_index(mapping, from);
+	unsigned offset = page_cache_offset(mapping, from);
 	unsigned to;
 	struct page *page;
 	const struct address_space_operations *a_ops = mapping->a_ops;
@@ -2438,7 +2450,8 @@ int nobh_truncate_page(struct address_sp
 	to = (offset + blocksize) & ~(blocksize - 1);
 	ret = a_ops->prepare_write(NULL, page, offset, to);
 	if (ret == 0) {
-		memclear_highpage_flush(page, offset, PAGE_CACHE_SIZE - offset);
+		memclear_highpage_flush(page, offset,
+				page_cache_size(mapping) - offset);
 		/*
 		 * It would be more correct to call aops->commit_write()
 		 * here, but this is more efficient.
@@ -2456,8 +2469,8 @@ EXPORT_SYMBOL(nobh_truncate_page);
 int block_truncate_page(struct address_space *mapping,
 			loff_t from, get_block_t *get_block)
 {
-	pgoff_t index = from >> PAGE_CACHE_SHIFT;
-	unsigned offset = from & (PAGE_CACHE_SIZE-1);
+	pgoff_t index = page_cache_index(mapping, from);
+	unsigned offset = page_cache_offset(mapping, from);
 	unsigned blocksize;
 	sector_t iblock;
 	unsigned length, pos;
@@ -2474,7 +2487,7 @@ int block_truncate_page(struct address_s
 		return 0;
 
 	length = blocksize - length;
-	iblock = (sector_t)index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	iblock = (sector_t)index << (page_cache_shift(mapping) - inode->i_blkbits);
 	
 	page = grab_cache_page(mapping, index);
 	err = -ENOMEM;
@@ -2534,9 +2547,10 @@ out:
 int block_write_full_page(struct page *page, get_block_t *get_block,
 			struct writeback_control *wbc)
 {
-	struct inode * const inode = page->mapping->host;
+	struct address_space *mapping = page->mapping;
+	struct inode * const inode = mapping->host;
 	loff_t i_size = i_size_read(inode);
-	const pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
+	const pgoff_t end_index = page_cache_index(mapping, i_size);
 	unsigned offset;
 
 	/* Is the page fully inside i_size? */
@@ -2544,7 +2558,7 @@ int block_write_full_page(struct page *p
 		return __block_write_full_page(inode, page, get_block, wbc);
 
 	/* Is the page fully outside i_size? (truncate in progress) */
-	offset = i_size & (PAGE_CACHE_SIZE-1);
+	offset = page_cache_offset(mapping, i_size);
 	if (page->index >= end_index+1 || !offset) {
 		/*
 		 * The page may have dirty, unmapped buffers.  For example,
@@ -2563,7 +2577,8 @@ int block_write_full_page(struct page *p
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	memclear_highpage_flush(page, offset, PAGE_CACHE_SIZE - offset);
+	memclear_highpage_flush(page, offset,
+			page_cache_size(mapping) - offset);
 	return __block_write_full_page(inode, page, get_block, wbc);
 }
 
@@ -2817,7 +2832,7 @@ int try_to_free_buffers(struct page *pag
 	 * dirty bit from being lost.
 	 */
 	if (ret)
-		cancel_dirty_page(page, PAGE_CACHE_SIZE);
+		cancel_dirty_page(page, page_cache_size(mapping));
 	spin_unlock(&mapping->private_lock);
 out:
 	if (buffers_to_free) {
Index: linux-2.6.21-rc7/fs/mpage.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/mpage.c	2007-04-23 22:10:03.000000000 -0700
+++ linux-2.6.21-rc7/fs/mpage.c	2007-04-23 22:15:29.000000000 -0700
@@ -133,7 +133,8 @@ mpage_alloc(struct block_device *bdev,
 static void 
 map_buffer_to_page(struct page *page, struct buffer_head *bh, int page_block) 
 {
-	struct inode *inode = page->mapping->host;
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
 	struct buffer_head *page_bh, *head;
 	int block = 0;
 
@@ -142,9 +143,9 @@ map_buffer_to_page(struct page *page, st
 		 * don't make any buffers if there is only one buffer on
 		 * the page and the page just needs to be set up to date
 		 */
-		if (inode->i_blkbits == PAGE_CACHE_SHIFT && 
+		if (inode->i_blkbits == page_cache_shift(mapping) &&
 		    buffer_uptodate(bh)) {
-			SetPageUptodate(page);    
+			SetPageUptodate(page);
 			return;
 		}
 		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
@@ -177,9 +178,10 @@ do_mpage_readpage(struct bio *bio, struc
 		sector_t *last_block_in_bio, struct buffer_head *map_bh,
 		unsigned long *first_logical_block, get_block_t get_block)
 {
-	struct inode *inode = page->mapping->host;
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
-	const unsigned blocks_per_page = PAGE_CACHE_SIZE >> blkbits;
+	const unsigned blocks_per_page = page_cache_size(mapping) >> blkbits;
 	const unsigned blocksize = 1 << blkbits;
 	sector_t block_in_file;
 	sector_t last_block;
@@ -196,7 +198,7 @@ do_mpage_readpage(struct bio *bio, struc
 	if (page_has_buffers(page))
 		goto confused;
 
-	block_in_file = (sector_t)page->index << (PAGE_CACHE_SHIFT - blkbits);
+	block_in_file = (sector_t)page->index << (page_cache_shift(mapping) - blkbits);
 	last_block = block_in_file + nr_pages * blocks_per_page;
 	last_block_in_file = (i_size_read(inode) + blocksize - 1) >> blkbits;
 	if (last_block > last_block_in_file)
@@ -285,7 +287,7 @@ do_mpage_readpage(struct bio *bio, struc
 
 	if (first_hole != blocks_per_page) {
 		memclear_highpage_flush(page, first_hole << blkbits,
-				PAGE_CACHE_SIZE - (first_hole << blkbits));
+			page_cache_size(mapping) - (first_hole << blkbits));
 		if (first_hole == 0) {
 			SetPageUptodate(page);
 			unlock_page(page);
@@ -462,7 +464,7 @@ __mpage_writepage(struct bio *bio, struc
 	struct inode *inode = page->mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
 	unsigned long end_index;
-	const unsigned blocks_per_page = PAGE_CACHE_SIZE >> blkbits;
+	const unsigned blocks_per_page = page_cache_size(mapping) >> blkbits;
 	sector_t last_block;
 	sector_t block_in_file;
 	sector_t blocks[MAX_BUF_PER_PAGE];
@@ -530,7 +532,7 @@ __mpage_writepage(struct bio *bio, struc
 	 * The page has no buffers: map it to disk
 	 */
 	BUG_ON(!PageUptodate(page));
-	block_in_file = (sector_t)page->index << (PAGE_CACHE_SHIFT - blkbits);
+	block_in_file = (sector_t)page->index << (page_cache_shift(mapping) - blkbits);
 	last_block = (i_size - 1) >> blkbits;
 	map_bh.b_page = page;
 	for (page_block = 0; page_block < blocks_per_page; ) {
@@ -562,7 +564,7 @@ __mpage_writepage(struct bio *bio, struc
 	first_unmapped = page_block;
 
 page_is_mapped:
-	end_index = i_size >> PAGE_CACHE_SHIFT;
+	end_index = page_cache_index(mapping, i_size);
 	if (page->index >= end_index) {
 		/*
 		 * The page straddles i_size.  It must be zeroed out on each
@@ -572,12 +574,12 @@ page_is_mapped:
 		 * is zeroed when mapped, and writes to that region are not
 		 * written out to the file."
 		 */
-		unsigned offset = i_size & (PAGE_CACHE_SIZE - 1);
+		unsigned offset = page_cache_offset(mapping, i_size);
 
 		if (page->index > end_index || !offset)
 			goto confused;
 		memclear_highpage_flush(page, offset,
-			PAGE_CACHE_SIZE - offset);
+			page_cache_size(mapping) - offset);
 	}
 
 	/*
@@ -721,8 +723,8 @@ mpage_writepages(struct address_space *m
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
 	} else {
-		index = wbc->range_start >> PAGE_CACHE_SHIFT;
-		end = wbc->range_end >> PAGE_CACHE_SHIFT;
+		index = page_cache_index(mapping, wbc->range_start);
+		end = page_cache_index(mapping, wbc->range_end);
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
 		scanned = 1;
Index: linux-2.6.21-rc7/include/linux/buffer_head.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/buffer_head.h	2007-04-23 22:10:03.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/buffer_head.h	2007-04-23 22:15:29.000000000 -0700
@@ -129,7 +129,14 @@ BUFFER_FNS(Ordered, ordered)
 BUFFER_FNS(Eopnotsupp, eopnotsupp)
 BUFFER_FNS(Unwritten, unwritten)
 
-#define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
+static inline unsigned long bh_offset(struct buffer_head *bh)
+{
+	/* Cannot use the mapping since it may be set to NULL. */
+	unsigned long mask = compound_size(bh->b_page) - 1;
+
+	return (unsigned long)bh->b_data & mask;
+}
+
 #define touch_buffer(bh)	mark_page_accessed(bh->b_page)
 
 /* If we *know* page->private refers to buffer_heads */

--
