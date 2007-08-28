Return-Path: <linux-kernel-owner+w=401wt.eu-S1762203AbXH1TP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203AbXH1TP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761317AbXH1TIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:08:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58792 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760888AbXH1THo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:44 -0400
Message-Id: <20070828190730.220393749@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:02 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [11/36] Use page_cache_xxx in fs/buffer.c
Content-Disposition: inline; filename=0011-Use-page_cache_xxx-in-fs-buffer.c.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use page_cache_xxx in fs/buffer.c.

We have a special situation in set_bh_page() since reiserfs calls that
function before setting up the mapping. So retrieve the page size
from the page struct rather than the mapping.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/buffer.c |  110 +++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 62 insertions(+), 48 deletions(-)

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c	2007-08-28 11:37:13.000000000 -0700
+++ linux-2.6/fs/buffer.c	2007-08-28 11:37:58.000000000 -0700
@@ -257,7 +257,7 @@ __find_get_block_slow(struct block_devic
 	struct page *page;
 	int all_mapped = 1;
 
-	index = block >> (PAGE_CACHE_SHIFT - bd_inode->i_blkbits);
+	index = block >> (page_cache_shift(bd_mapping) - bd_inode->i_blkbits);
 	page = find_get_page(bd_mapping, index);
 	if (!page)
 		goto out;
@@ -697,7 +697,7 @@ static int __set_page_dirty(struct page 
 
 		if (mapping_cap_account_dirty(mapping)) {
 			__inc_zone_page_state(page, NR_FILE_DIRTY);
-			task_io_account_write(PAGE_CACHE_SIZE);
+			task_io_account_write(page_cache_size(mapping));
 		}
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
@@ -891,10 +891,11 @@ struct buffer_head *alloc_page_buffers(s
 {
 	struct buffer_head *bh, *head;
 	long offset;
+	unsigned int page_size = page_cache_size(page->mapping);
 
 try_again:
 	head = NULL;
-	offset = PAGE_SIZE;
+	offset = page_size;
 	while ((offset -= size) >= 0) {
 		bh = alloc_buffer_head(GFP_NOFS);
 		if (!bh)
@@ -1426,7 +1427,7 @@ void set_bh_page(struct buffer_head *bh,
 		struct page *page, unsigned long offset)
 {
 	bh->b_page = page;
-	BUG_ON(offset >= PAGE_SIZE);
+	BUG_ON(offset >= compound_size(page));
 	if (PageHighMem(page))
 		/*
 		 * This catches illegal uses and preserves the offset:
@@ -1605,6 +1606,7 @@ static int __block_write_full_page(struc
 	struct buffer_head *bh, *head;
 	const unsigned blocksize = 1 << inode->i_blkbits;
 	int nr_underway = 0;
+	struct address_space *mapping = inode->i_mapping;
 
 	BUG_ON(!PageLocked(page));
 
@@ -1625,7 +1627,8 @@ static int __block_write_full_page(struc
 	 * handle that here by just cleaning them.
 	 */
 
-	block = (sector_t)page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	block = (sector_t)page->index <<
+		(page_cache_shift(mapping) - inode->i_blkbits);
 	head = page_buffers(page);
 	bh = head;
 
@@ -1742,7 +1745,7 @@ recover:
 	} while ((bh = bh->b_this_page) != head);
 	SetPageError(page);
 	BUG_ON(PageWriteback(page));
-	mapping_set_error(page->mapping, err);
+	mapping_set_error(mapping, err);
 	set_page_writeback(page);
 	do {
 		struct buffer_head *next = bh->b_this_page;
@@ -1767,8 +1770,8 @@ static int __block_prepare_write(struct 
 	struct buffer_head *bh, *head, *wait[2], **wait_bh=wait;
 
 	BUG_ON(!PageLocked(page));
-	BUG_ON(from > PAGE_CACHE_SIZE);
-	BUG_ON(to > PAGE_CACHE_SIZE);
+	BUG_ON(from > page_cache_size(inode->i_mapping));
+	BUG_ON(to > page_cache_size(inode->i_mapping));
 	BUG_ON(from > to);
 
 	blocksize = 1 << inode->i_blkbits;
@@ -1777,7 +1780,8 @@ static int __block_prepare_write(struct 
 	head = page_buffers(page);
 
 	bbits = inode->i_blkbits;
-	block = (sector_t)page->index << (PAGE_CACHE_SHIFT - bbits);
+	block = (sector_t)page->index <<
+		(page_cache_shift(inode->i_mapping) - bbits);
 
 	for(bh = head, block_start = 0; bh != head || !block_start;
 	    block++, block_start=block_end, bh = bh->b_this_page) {
@@ -1921,7 +1925,8 @@ int block_read_full_page(struct page *pa
 		create_empty_buffers(page, blocksize, 0);
 	head = page_buffers(page);
 
-	iblock = (sector_t)page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	iblock = (sector_t)page->index <<
+		(page_cache_shift(page->mapping) - inode->i_blkbits);
 	lblock = (i_size_read(inode)+blocksize-1) >> inode->i_blkbits;
 	bh = head;
 	nr = 0;
@@ -2045,7 +2050,7 @@ int generic_cont_expand(struct inode *in
 	pgoff_t index;
 	unsigned int offset;
 
-	offset = (size & (PAGE_CACHE_SIZE - 1)); /* Within page */
+	offset = page_cache_offset(inode->i_mapping, size); /* Within page */
 
 	/* ugh.  in prepare/commit_write, if from==to==start of block, we
 	** skip the prepare.  make sure we never send an offset for the start
@@ -2055,7 +2060,7 @@ int generic_cont_expand(struct inode *in
 		/* caller must handle this extra byte. */
 		offset++;
 	}
-	index = size >> PAGE_CACHE_SHIFT;
+	index = page_cache_index(inode->i_mapping, size);
 
 	return __generic_cont_expand(inode, size, index, offset);
 }
@@ -2063,8 +2068,8 @@ int generic_cont_expand(struct inode *in
 int generic_cont_expand_simple(struct inode *inode, loff_t size)
 {
 	loff_t pos = size - 1;
-	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
-	unsigned int offset = (pos & (PAGE_CACHE_SIZE - 1)) + 1;
+	pgoff_t index = page_cache_index(inode->i_mapping, pos);
+	unsigned int offset = page_cache_offset(inode->i_mapping, pos) + 1;
 
 	/* prepare/commit_write can handle even if from==to==start of block. */
 	return __generic_cont_expand(inode, size, index, offset);
@@ -2086,28 +2091,28 @@ int cont_prepare_write(struct page *page
 	unsigned zerofrom;
 	unsigned blocksize = 1 << inode->i_blkbits;
 
-	while(page->index > (pgpos = *bytes>>PAGE_CACHE_SHIFT)) {
+	while (page->index > (pgpos = page_cache_index(mapping, *bytes))) {
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
+					page_cache_size(mapping), get_block);
 		if (status)
 			goto out_unmap;
-		zero_user_segment(new_page, zerofrom, PAGE_CACHE_SIZE);
-		generic_commit_write(NULL, new_page, zerofrom, PAGE_CACHE_SIZE);
+		zero_user_segment(new_page, zerofrom, page_cache_size(mapping));
+		generic_commit_write(NULL, new_page, zerofrom, page_cache_size(mapping));
 		unlock_page(new_page);
 		page_cache_release(new_page);
 	}
@@ -2117,7 +2122,7 @@ int cont_prepare_write(struct page *page
 		zerofrom = offset;
 	} else {
 		/* page covers the boundary, find the boundary offset */
-		zerofrom = *bytes & ~PAGE_CACHE_MASK;
+		zerofrom = page_cache_offset(mapping, *bytes);
 
 		/* if we will expand the thing last block will be filled */
 		if (to > zerofrom && (zerofrom & (blocksize-1))) {
@@ -2169,8 +2174,9 @@ int block_commit_write(struct page *page
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
@@ -2206,20 +2212,22 @@ block_page_mkwrite(struct vm_area_struct
 	unsigned long end;
 	loff_t size;
 	int ret = -EINVAL;
+	struct address_space *mapping;
 
 	lock_page(page);
+	mapping = page->mapping;
 	size = i_size_read(inode);
-	if ((page->mapping != inode->i_mapping) ||
+	if ((mapping != inode->i_mapping) ||
 	    (page_offset(page) > size)) {
 		/* page got truncated out from underneath us */
 		goto out_unlock;
 	}
 
 	/* page is wholly or partially inside EOF */
-	if (((page->index + 1) << PAGE_CACHE_SHIFT) > size)
-		end = size & ~PAGE_CACHE_MASK;
+	if (page_cache_pos(mapping, page->index + 1, 0) > size)
+		end = page_cache_offset(mapping, size);
 	else
-		end = PAGE_CACHE_SIZE;
+		end = page_cache_size(mapping);
 
 	ret = block_prepare_write(page, 0, end, get_block);
 	if (!ret)
@@ -2258,6 +2266,7 @@ static void end_buffer_read_nobh(struct 
 int nobh_prepare_write(struct page *page, unsigned from, unsigned to,
 			get_block_t *get_block)
 {
+	struct address_space *mapping = page->mapping;
 	struct inode *inode = page->mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
 	const unsigned blocksize = 1 << blkbits;
@@ -2265,6 +2274,7 @@ int nobh_prepare_write(struct page *page
 	struct buffer_head *read_bh[MAX_BUF_PER_PAGE];
 	unsigned block_in_page;
 	unsigned block_start;
+	unsigned page_size = page_cache_size(mapping);
 	sector_t block_in_file;
 	int nr_reads = 0;
 	int i;
@@ -2274,7 +2284,8 @@ int nobh_prepare_write(struct page *page
 	if (PageMappedToDisk(page))
 		return 0;
 
-	block_in_file = (sector_t)page->index << (PAGE_CACHE_SHIFT - blkbits);
+	block_in_file = (sector_t)page->index <<
+			(page_cache_shift(mapping) - blkbits);
 	map_bh.b_page = page;
 
 	/*
@@ -2283,7 +2294,7 @@ int nobh_prepare_write(struct page *page
 	 * page is fully mapped-to-disk.
 	 */
 	for (block_start = 0, block_in_page = 0;
-		  block_start < PAGE_CACHE_SIZE;
+		  block_start < page_size;
 		  block_in_page++, block_start += blocksize) {
 		unsigned block_end = block_start + blocksize;
 		int create;
@@ -2372,7 +2383,7 @@ failed:
 	 * Error recovery is pretty slack.  Clear the page and mark it dirty
 	 * so we'll later zero out any blocks which _were_ allocated.
 	 */
-	zero_user(page, 0, PAGE_CACHE_SIZE);
+	zero_user(page, 0, page_size);
 	SetPageUptodate(page);
 	set_page_dirty(page);
 	return ret;
@@ -2386,8 +2397,9 @@ EXPORT_SYMBOL(nobh_prepare_write);
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
@@ -2407,9 +2419,10 @@ EXPORT_SYMBOL(nobh_commit_write);
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
 
@@ -2418,7 +2431,7 @@ int nobh_writepage(struct page *page, ge
 		goto out;
 
 	/* Is the page fully outside i_size? (truncate in progress) */
-	offset = i_size & (PAGE_CACHE_SIZE-1);
+	offset = page_cache_offset(mapping, i_size);
 	if (page->index >= end_index+1 || !offset) {
 		/*
 		 * The page may have dirty, unmapped buffers.  For example,
@@ -2441,7 +2454,7 @@ int nobh_writepage(struct page *page, ge
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
+	zero_user_segment(page, offset, page_cache_size(mapping));
 out:
 	ret = mpage_writepage(page, get_block, wbc);
 	if (ret == -EAGAIN)
@@ -2457,8 +2470,8 @@ int nobh_truncate_page(struct address_sp
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
@@ -2475,7 +2488,7 @@ int nobh_truncate_page(struct address_sp
 	to = (offset + blocksize) & ~(blocksize - 1);
 	ret = a_ops->prepare_write(NULL, page, offset, to);
 	if (ret == 0) {
-		zero_user_segment(page, offset, PAGE_CACHE_SIZE);
+		zero_user_segment(page, offset, page_cache_size(mapping));
 		/*
 		 * It would be more correct to call aops->commit_write()
 		 * here, but this is more efficient.
@@ -2493,8 +2506,8 @@ EXPORT_SYMBOL(nobh_truncate_page);
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
@@ -2511,8 +2524,8 @@ int block_truncate_page(struct address_s
 		return 0;
 
 	length = blocksize - length;
-	iblock = (sector_t)index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
-	
+	iblock = (sector_t)index <<
+			(page_cache_shift(mapping) - inode->i_blkbits);
 	page = grab_cache_page(mapping, index);
 	err = -ENOMEM;
 	if (!page)
@@ -2571,9 +2584,10 @@ out:
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
@@ -2581,7 +2595,7 @@ int block_write_full_page(struct page *p
 		return __block_write_full_page(inode, page, get_block, wbc);
 
 	/* Is the page fully outside i_size? (truncate in progress) */
-	offset = i_size & (PAGE_CACHE_SIZE-1);
+	offset = page_cache_offset(mapping, i_size);
 	if (page->index >= end_index+1 || !offset) {
 		/*
 		 * The page may have dirty, unmapped buffers.  For example,
@@ -2600,7 +2614,7 @@ int block_write_full_page(struct page *p
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
+	zero_user_segment(page, offset, page_cache_size(mapping));
 	return __block_write_full_page(inode, page, get_block, wbc);
 }
 
@@ -2854,7 +2868,7 @@ int try_to_free_buffers(struct page *pag
 	 * dirty bit from being lost.
 	 */
 	if (ret)
-		cancel_dirty_page(page, PAGE_CACHE_SIZE);
+		cancel_dirty_page(page, page_cache_size(mapping));
 	spin_unlock(&mapping->private_lock);
 out:
 	if (buffers_to_free) {

-- 
