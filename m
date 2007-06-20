Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbXFTSed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbXFTSed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759237AbXFTSaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:30:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46755 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756600AbXFTSaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:10 -0400
Message-Id: <20070620183008.320021511@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:18 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [11/37] Use page_cache_xxx in fs/buffer.c
Content-Disposition: inline; filename=vps_fs_buffer
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/buffer.c |   99 +++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 56 insertions(+), 43 deletions(-)

Index: vps/fs/buffer.c
===================================================================
--- vps.orig/fs/buffer.c	2007-06-11 22:33:07.000000000 -0700
+++ vps/fs/buffer.c	2007-06-11 22:34:34.000000000 -0700
@@ -265,7 +265,7 @@ __find_get_block_slow(struct block_devic
 	struct page *page;
 	int all_mapped = 1;
 
-	index = block >> (PAGE_CACHE_SHIFT - bd_inode->i_blkbits);
+	index = block >> (page_cache_shift(bd_mapping) - bd_inode->i_blkbits);
 	page = find_get_page(bd_mapping, index);
 	if (!page)
 		goto out;
@@ -705,7 +705,7 @@ static int __set_page_dirty(struct page 
 
 		if (mapping_cap_account_dirty(mapping)) {
 			__inc_zone_page_state(page, NR_FILE_DIRTY);
-			task_io_account_write(PAGE_CACHE_SIZE);
+			task_io_account_write(page_cache_size(mapping));
 		}
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
@@ -899,10 +899,11 @@ struct buffer_head *alloc_page_buffers(s
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
@@ -1434,7 +1435,7 @@ void set_bh_page(struct buffer_head *bh,
 		struct page *page, unsigned long offset)
 {
 	bh->b_page = page;
-	BUG_ON(offset >= PAGE_SIZE);
+	BUG_ON(offset >= page_cache_size(page->mapping));
 	if (PageHighMem(page))
 		/*
 		 * This catches illegal uses and preserves the offset:
@@ -1613,6 +1614,7 @@ static int __block_write_full_page(struc
 	struct buffer_head *bh, *head;
 	const unsigned blocksize = 1 << inode->i_blkbits;
 	int nr_underway = 0;
+	struct address_space *mapping = inode->i_mapping;
 
 	BUG_ON(!PageLocked(page));
 
@@ -1633,7 +1635,8 @@ static int __block_write_full_page(struc
 	 * handle that here by just cleaning them.
 	 */
 
-	block = (sector_t)page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	block = (sector_t)page->index <<
+		(page_cache_shift(mapping) - inode->i_blkbits);
 	head = page_buffers(page);
 	bh = head;
 
@@ -1750,7 +1753,7 @@ recover:
 	} while ((bh = bh->b_this_page) != head);
 	SetPageError(page);
 	BUG_ON(PageWriteback(page));
-	mapping_set_error(page->mapping, err);
+	mapping_set_error(mapping, err);
 	set_page_writeback(page);
 	do {
 		struct buffer_head *next = bh->b_this_page;
@@ -1817,8 +1820,8 @@ static int __block_prepare_write(struct 
 	struct buffer_head *bh, *head, *wait[2], **wait_bh=wait;
 
 	BUG_ON(!PageLocked(page));
-	BUG_ON(from > PAGE_CACHE_SIZE);
-	BUG_ON(to > PAGE_CACHE_SIZE);
+	BUG_ON(from > page_cache_size(inode->i_mapping));
+	BUG_ON(to > page_cache_size(inode->i_mapping));
 	BUG_ON(from > to);
 
 	blocksize = 1 << inode->i_blkbits;
@@ -1827,7 +1830,8 @@ static int __block_prepare_write(struct 
 	head = page_buffers(page);
 
 	bbits = inode->i_blkbits;
-	block = (sector_t)page->index << (PAGE_CACHE_SHIFT - bbits);
+	block = (sector_t)page->index <<
+		(page_cache_shift(inode->i_mapping) - bbits);
 
 	for(bh = head, block_start = 0; bh != head || !block_start;
 	    block++, block_start=block_end, bh = bh->b_this_page) {
@@ -1942,8 +1946,8 @@ int block_write_begin(struct file *file,
 	unsigned start, end;
 	int ownpage = 0;
 
-	index = pos >> PAGE_CACHE_SHIFT;
-	start = pos & (PAGE_CACHE_SIZE - 1);
+	index = page_cache_index(mapping, pos);
+	start = page_cache_offset(mapping, pos);
 	end = start + len;
 
 	page = *pagep;
@@ -1989,7 +1993,7 @@ int block_write_end(struct file *file, s
 	struct inode *inode = mapping->host;
 	unsigned start;
 
-	start = pos & (PAGE_CACHE_SIZE - 1);
+	start = page_cache_offset(mapping, pos);
 
 	if (unlikely(copied < len)) {
 		/*
@@ -2065,7 +2069,8 @@ int block_read_full_page(struct page *pa
 		create_empty_buffers(page, blocksize, 0);
 	head = page_buffers(page);
 
-	iblock = (sector_t)page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	iblock = (sector_t)page->index <<
+		(page_cache_shift(page->mapping) - inode->i_blkbits);
 	lblock = (i_size_read(inode)+blocksize-1) >> inode->i_blkbits;
 	bh = head;
 	nr = 0;
@@ -2183,16 +2188,17 @@ int cont_expand_zero(struct file *file, 
 	unsigned zerofrom, offset, len;
 	int err = 0;
 
-	index = pos >> PAGE_CACHE_SHIFT;
-	offset = pos & ~PAGE_CACHE_MASK;
+	index = page_cache_index(mapping, pos);
+	offset = page_cache_offset(mapping, pos);
 
-	while (index > (curidx = (curpos = *bytes)>>PAGE_CACHE_SHIFT)) {
-		zerofrom = curpos & ~PAGE_CACHE_MASK;
+	while (index > (curidx = page_cache_index(mapping,
+					(curpos = *bytes)))) {
+		zerofrom = page_cache_offset(mapping, curpos);
 		if (zerofrom & (blocksize-1)) {
 			*bytes |= (blocksize-1);
 			(*bytes)++;
 		}
-		len = PAGE_CACHE_SIZE - zerofrom;
+		len = page_cache_size(mapping) - zerofrom;
 
 		err = pagecache_write_begin(file, mapping, curpos, len,
 						AOP_FLAG_UNINTERRUPTIBLE,
@@ -2210,7 +2216,7 @@ int cont_expand_zero(struct file *file, 
 
 	/* page covers the boundary, find the boundary offset */
 	if (index == curidx) {
-		zerofrom = curpos & ~PAGE_CACHE_MASK;
+		zerofrom = page_cache_offset(mapping, curpos);
 		/* if we will expand the thing last block will be filled */
 		if (offset <= zerofrom) {
 			goto out;
@@ -2256,7 +2262,7 @@ int cont_write_begin(struct file *file, 
 	if (err)
 		goto out;
 
-	zerofrom = *bytes & ~PAGE_CACHE_MASK;
+	zerofrom = page_cache_offset(mapping, *bytes);
 	if (pos+len > *bytes && zerofrom & (blocksize-1)) {
 		*bytes |= (blocksize-1);
 		(*bytes)++;
@@ -2289,8 +2295,9 @@ int block_commit_write(struct page *page
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
@@ -2332,6 +2339,7 @@ static void end_buffer_read_nobh(struct 
 int nobh_prepare_write(struct page *page, unsigned from, unsigned to,
 			get_block_t *get_block)
 {
+	struct address_space *mapping = page->mapping;
 	struct inode *inode = page->mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
 	const unsigned blocksize = 1 << blkbits;
@@ -2339,6 +2347,7 @@ int nobh_prepare_write(struct page *page
 	struct buffer_head *read_bh[MAX_BUF_PER_PAGE];
 	unsigned block_in_page;
 	unsigned block_start;
+	unsigned page_size = page_cache_size(mapping);
 	sector_t block_in_file;
 	int nr_reads = 0;
 	int i;
@@ -2348,7 +2357,8 @@ int nobh_prepare_write(struct page *page
 	if (PageMappedToDisk(page))
 		return 0;
 
-	block_in_file = (sector_t)page->index << (PAGE_CACHE_SHIFT - blkbits);
+	block_in_file = (sector_t)page->index <<
+			(page_cache_shift(mapping) - blkbits);
 	map_bh.b_page = page;
 
 	/*
@@ -2357,7 +2367,7 @@ int nobh_prepare_write(struct page *page
 	 * page is fully mapped-to-disk.
 	 */
 	for (block_start = 0, block_in_page = 0;
-		  block_start < PAGE_CACHE_SIZE;
+		  block_start < page_size;
 		  block_in_page++, block_start += blocksize) {
 		unsigned block_end = block_start + blocksize;
 		int create;
@@ -2446,7 +2456,7 @@ failed:
 	 * Error recovery is pretty slack.  Clear the page and mark it dirty
 	 * so we'll later zero out any blocks which _were_ allocated.
 	 */
-	zero_user(page, 0, PAGE_CACHE_SIZE);
+	zero_user(page, 0, page_size);
 	SetPageUptodate(page);
 	set_page_dirty(page);
 	return ret;
@@ -2460,8 +2470,9 @@ EXPORT_SYMBOL(nobh_prepare_write);
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
@@ -2481,9 +2492,10 @@ EXPORT_SYMBOL(nobh_commit_write);
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
 
@@ -2492,7 +2504,7 @@ int nobh_writepage(struct page *page, ge
 		goto out;
 
 	/* Is the page fully outside i_size? (truncate in progress) */
-	offset = i_size & (PAGE_CACHE_SIZE-1);
+	offset = page_cache_offset(mapping, i_size);
 	if (page->index >= end_index+1 || !offset) {
 		/*
 		 * The page may have dirty, unmapped buffers.  For example,
@@ -2515,7 +2527,7 @@ int nobh_writepage(struct page *page, ge
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
+	zero_user_segment(page, offset, page_cache_size(mapping));
 out:
 	ret = mpage_writepage(page, get_block, wbc);
 	if (ret == -EAGAIN)
@@ -2531,8 +2543,8 @@ int nobh_truncate_page(struct address_sp
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
@@ -2549,7 +2561,7 @@ int nobh_truncate_page(struct address_sp
 	to = (offset + blocksize) & ~(blocksize - 1);
 	ret = a_ops->prepare_write(NULL, page, offset, to);
 	if (ret == 0) {
-		zero_user_segment(page, offset, PAGE_CACHE_SIZE);
+		zero_user_segment(page, offset, page_cache_size(mapping));
 		/*
 		 * It would be more correct to call aops->commit_write()
 		 * here, but this is more efficient.
@@ -2567,8 +2579,8 @@ EXPORT_SYMBOL(nobh_truncate_page);
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
@@ -2585,8 +2597,8 @@ int block_truncate_page(struct address_s
 		return 0;
 
 	length = blocksize - length;
-	iblock = (sector_t)index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
-	
+	iblock = (sector_t)index <<
+			(page_cache_shift(mapping) - inode->i_blkbits);
 	page = grab_cache_page(mapping, index);
 	err = -ENOMEM;
 	if (!page)
@@ -2645,9 +2657,10 @@ out:
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
@@ -2655,7 +2668,7 @@ int block_write_full_page(struct page *p
 		return __block_write_full_page(inode, page, get_block, wbc);
 
 	/* Is the page fully outside i_size? (truncate in progress) */
-	offset = i_size & (PAGE_CACHE_SIZE-1);
+	offset = page_cache_offset(mapping, i_size);
 	if (page->index >= end_index+1 || !offset) {
 		/*
 		 * The page may have dirty, unmapped buffers.  For example,
@@ -2674,7 +2687,7 @@ int block_write_full_page(struct page *p
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
+	zero_user_segment(page, offset, page_cache_size(mapping));
 	return __block_write_full_page(inode, page, get_block, wbc);
 }
 
@@ -2928,7 +2941,7 @@ int try_to_free_buffers(struct page *pag
 	 * dirty bit from being lost.
 	 */
 	if (ret)
-		cancel_dirty_page(page, PAGE_CACHE_SIZE);
+		cancel_dirty_page(page, page_cache_size(mapping));
 	spin_unlock(&mapping->private_lock);
 out:
 	if (buffers_to_free) {

-- 
