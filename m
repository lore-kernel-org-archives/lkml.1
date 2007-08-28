Return-Path: <linux-kernel-owner+w=401wt.eu-S932358AbXH1TMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbXH1TMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761132AbXH1TH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:07:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58796 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756396AbXH1THh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:37 -0400
Message-Id: <20070828190732.222180518@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:09 -0700
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
Subject: [18/36] Use page_cache_xxx in fs/reiserfs
Content-Disposition: inline; filename=0018-Use-page_cache_xxx-in-fs-reiserfs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use page_cache_xxx in fs/reiserfs

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/reiserfs/file.c            |   83 ++++++++++++++++++++++-------------------
 fs/reiserfs/inode.c           |   33 ++++++++++------
 fs/reiserfs/ioctl.c           |    2 +-
 fs/reiserfs/stree.c           |    8 ++-
 fs/reiserfs/tail_conversion.c |    5 +-
 fs/reiserfs/xattr.c           |   19 +++++----
 6 files changed, 84 insertions(+), 66 deletions(-)

Index: linux-2.6/fs/reiserfs/file.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/file.c	2007-08-27 21:22:40.000000000 -0700
+++ linux-2.6/fs/reiserfs/file.c	2007-08-27 21:50:01.000000000 -0700
@@ -187,9 +187,11 @@ static int reiserfs_allocate_blocks_for_
 	int curr_block;		// current block used to keep track of unmapped blocks.
 	int i;			// loop counter
 	int itempos;		// position in item
-	unsigned int from = (pos & (PAGE_CACHE_SIZE - 1));	// writing position in
+	struct address_space *mapping = prepared_pages[0]->mapping;
+	unsigned int from = page_cache_offset(mapping, pos);	// writing position in
 	// first page
-	unsigned int to = ((pos + write_bytes - 1) & (PAGE_CACHE_SIZE - 1)) + 1;	/* last modified byte offset in last page */
+	unsigned int to = page_cache_offset(mapping, pos + write_bytes - 1)  + 1;
+					/* last modified byte offset in last page */
 	__u64 hole_size;	// amount of blocks for a file hole, if it needed to be created.
 	int modifying_this_item = 0;	// Flag for items traversal code to keep track
 	// of the fact that we already prepared
@@ -731,19 +733,22 @@ static int reiserfs_copy_from_user_to_fi
 	long page_fault = 0;	// status of copy_from_user.
 	int i;			// loop counter.
 	int offset;		// offset in page
+	struct address_space *mapping = prepared_pages[0]->mapping;
 
-	for (i = 0, offset = (pos & (PAGE_CACHE_SIZE - 1)); i < num_pages;
+	for (i = 0, offset = page_cache_offset(mapping, pos); i < num_pages;
 	     i++, offset = 0) {
-		size_t count = min_t(size_t, PAGE_CACHE_SIZE - offset, write_bytes);	// How much of bytes to write to this page
+		size_t count = min_t(size_t, page_cache_size(mapping) - offset,
+			write_bytes);	// How much of bytes to write to this page
 		struct page *page = prepared_pages[i];	// Current page we process.
 
 		fault_in_pages_readable(buf, count);
 
 		/* Copy data from userspace to the current page */
 		kmap(page);
-		page_fault = __copy_from_user(page_address(page) + offset, buf, count);	// Copy the data.
+		page_fault = __copy_from_user(page_address(page) + offset, buf, count);
+					// Copy the data.
 		/* Flush processor's dcache for this page */
-		flush_dcache_page(page);
+		flush_mapping_page(page);
 		kunmap(page);
 		buf += count;
 		write_bytes -= count;
@@ -763,11 +768,12 @@ int reiserfs_commit_page(struct inode *i
 	int partial = 0;
 	unsigned blocksize;
 	struct buffer_head *bh, *head;
-	unsigned long i_size_index = inode->i_size >> PAGE_CACHE_SHIFT;
+	unsigned long i_size_index =
+		page_cache_offset(inode->i_mapping, inode->i_size);
 	int new;
 	int logit = reiserfs_file_data_log(inode);
 	struct super_block *s = inode->i_sb;
-	int bh_per_page = PAGE_CACHE_SIZE / s->s_blocksize;
+	int bh_per_page = page_cache_size(inode->i_mapping) / s->s_blocksize;
 	struct reiserfs_transaction_handle th;
 	int ret = 0;
 
@@ -839,10 +845,11 @@ static int reiserfs_submit_file_region_f
 	int offset;		// Writing offset in page.
 	int orig_write_bytes = write_bytes;
 	int sd_update = 0;
+	struct address_space *mapping = inode->i_mapping;
 
-	for (i = 0, offset = (pos & (PAGE_CACHE_SIZE - 1)); i < num_pages;
+	for (i = 0, offset = page_cache_offset(mapping, pos); i < num_pages;
 	     i++, offset = 0) {
-		int count = min_t(int, PAGE_CACHE_SIZE - offset, write_bytes);	// How much of bytes to write to this page
+		int count = min_t(int, page_cache_size(mapping) - offset, write_bytes);	// How much of bytes to write to this page
 		struct page *page = prepared_pages[i];	// Current page we process.
 
 		status =
@@ -985,12 +992,12 @@ static int reiserfs_prepare_file_region_
     )
 {
 	int res = 0;		// Return values of different functions we call.
-	unsigned long index = pos >> PAGE_CACHE_SHIFT;	// Offset in file in pages.
-	int from = (pos & (PAGE_CACHE_SIZE - 1));	// Writing offset in first page
-	int to = ((pos + write_bytes - 1) & (PAGE_CACHE_SIZE - 1)) + 1;
+	struct address_space *mapping = inode->i_mapping;	// Pages are mapped here.
+	unsigned long index = page_cache_index(mapping, pos);	// Offset in file in pages.
+	int from = page_cache_offset(mapping, pos);	// Writing offset in first page
+	int to = page_cache_offset(mapping, pos + write_bytes - 1) + 1;
 	/* offset of last modified byte in last
 	   page */
-	struct address_space *mapping = inode->i_mapping;	// Pages are mapped here.
 	int i;			// Simple counter
 	int blocks = 0;		/* Return value (blocks that should be allocated) */
 	struct buffer_head *bh, *head;	// Current bufferhead and first bufferhead
@@ -1041,30 +1048,31 @@ static int reiserfs_prepare_file_region_
 		/* These are full-overwritten pages so we count all the blocks in
 		   these pages are counted as needed to be allocated */
 		blocks =
-		    (num_pages - 2) << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+		    (num_pages - 2) << (page_cache_shift(mapping) - inode->i_blkbits);
 
 	/* count blocks needed for first page (possibly partially written) */
-	blocks += ((PAGE_CACHE_SIZE - from) >> inode->i_blkbits) + !!(from & (inode->i_sb->s_blocksize - 1));	/* roundup */
+	blocks += ((page_cache_size(mapping) - from) >> inode->i_blkbits)
+		+ !!(from & (inode->i_sb->s_blocksize - 1));	/* roundup */
 
 	/* Now we account for last page. If last page == first page (we
 	   overwrite only one page), we substract all the blocks past the
 	   last writing position in a page out of already calculated number
 	   of blocks */
-	blocks += ((num_pages > 1) << (PAGE_CACHE_SHIFT - inode->i_blkbits)) -
-	    ((PAGE_CACHE_SIZE - to) >> inode->i_blkbits);
+	blocks += ((num_pages > 1) << (page_cache_shift(mapping) - inode->i_blkbits)) -
+	    ((page_cache_size(mapping) - to) >> inode->i_blkbits);
 	/* Note how we do not roundup here since partial blocks still
 	   should be allocated */
 
 	/* Now if all the write area lies past the file end, no point in
 	   maping blocks, since there is none, so we just zero out remaining
 	   parts of first and last pages in write area (if needed) */
-	if ((pos & ~((loff_t) PAGE_CACHE_SIZE - 1)) > inode->i_size) {
+	if (page_cache_offset(mapping, pos) > inode->i_size) {
 		if (from != 0)		/* First page needs to be partially zeroed */
 			zero_user(prepared_pages[0], 0, from);
 
-		if (to != PAGE_CACHE_SIZE)	/* Last page needs to be partially zeroed */
+		if (to != page_cache_size(mapping))	/* Last page needs to be partially zeroed */
 			zero_user_segment(prepared_pages[num_pages-1], to,
-					PAGE_CACHE_SIZE);
+					page_cache_size(mapping));
 
 		/* Since all blocks are new - use already calculated value */
 		return blocks;
@@ -1201,8 +1209,8 @@ static int reiserfs_prepare_file_region_
 
 	/* Last page, see if it is not uptodate, or if the last page is past the end of the file. */
 	if (!PageUptodate(prepared_pages[num_pages - 1]) ||
-	    ((pos + write_bytes) >> PAGE_CACHE_SHIFT) >
-	    (inode->i_size >> PAGE_CACHE_SHIFT)) {
+	    page_cache_index(mapping, pos + write_bytes) >
+	    page_cache_index(mapping, inode->i_size)) {
 		head = page_buffers(prepared_pages[num_pages - 1]);
 
 		/* for each buffer in page */
@@ -1292,6 +1300,7 @@ static ssize_t reiserfs_file_write(struc
 	   locked pages in array for now */
 	struct page *prepared_pages[REISERFS_WRITE_PAGES_AT_A_TIME];
 	struct reiserfs_transaction_handle th;
+	struct address_space *mapping = inode->i_mapping;
 	th.t_trans_id = 0;
 
 	/* If a filesystem is converted from 3.5 to 3.6, we'll have v3.5 items
@@ -1358,10 +1367,10 @@ static ssize_t reiserfs_file_write(struc
 		size_t blocks_to_allocate;	/* how much blocks we need to allocate for this iteration */
 
 		/*  (pos & (PAGE_CACHE_SIZE-1)) is an idiom for offset into a page of pos */
-		num_pages = !!((pos + count) & (PAGE_CACHE_SIZE - 1)) +	/* round up partial
+		num_pages = !!(page_cache_offset(mapping, pos + count)) +	/* round up partial
 									   pages */
 		    ((count +
-		      (pos & (PAGE_CACHE_SIZE - 1))) >> PAGE_CACHE_SHIFT);
+		      (pos & (page_cache_size(mapping) - 1))) >> page_cache_shift(mapping));
 		/* convert size to amount of
 		   pages */
 		reiserfs_write_lock(inode->i_sb);
@@ -1374,8 +1383,8 @@ static ssize_t reiserfs_file_write(struc
 			    min_t(size_t, REISERFS_WRITE_PAGES_AT_A_TIME,
 				  reiserfs_can_fit_pages(inode->i_sb));
 			/* Also we should not forget to set size in bytes accordingly */
-			write_bytes = (num_pages << PAGE_CACHE_SHIFT) -
-			    (pos & (PAGE_CACHE_SIZE - 1));
+			write_bytes = (num_pages << page_cache_shift(mapping)) -
+			page_cache_offset(mapping, pos);
 			/* If position is not on the
 			   start of the page, we need
 			   to substract the offset
@@ -1387,7 +1396,7 @@ static ssize_t reiserfs_file_write(struc
 		   we still have the space to write the blocks to */
 		reiserfs_claim_blocks_to_be_allocated(inode->i_sb,
 						      num_pages <<
-						      (PAGE_CACHE_SHIFT -
+						      (page_cache_shift(mapping) -
 						       inode->i_blkbits));
 		reiserfs_write_unlock(inode->i_sb);
 
@@ -1412,7 +1421,7 @@ static ssize_t reiserfs_file_write(struc
 			// No blocks were claimed before, so do it now.
 			reiserfs_claim_blocks_to_be_allocated(inode->i_sb,
 							      1 <<
-							      (PAGE_CACHE_SHIFT
+							      (page_cache_shift(mapping)
 							       -
 							       inode->
 							       i_blkbits));
@@ -1429,7 +1438,7 @@ static ssize_t reiserfs_file_write(struc
 		if (res < 0) {
 			reiserfs_release_claimed_blocks(inode->i_sb,
 							num_pages <<
-							(PAGE_CACHE_SHIFT -
+							(page_cache_shift(mapping) -
 							 inode->i_blkbits));
 			break;
 		}
@@ -1439,7 +1448,7 @@ static ssize_t reiserfs_file_write(struc
 		/* First we correct our estimate of how many blocks we need */
 		reiserfs_release_claimed_blocks(inode->i_sb,
 						(num_pages <<
-						 (PAGE_CACHE_SHIFT -
+						 (page_cache_shift(mapping) -
 						  inode->i_sb->
 						  s_blocksize_bits)) -
 						blocks_to_allocate);
Index: linux-2.6/fs/reiserfs/inode.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/inode.c	2007-08-27 21:22:40.000000000 -0700
+++ linux-2.6/fs/reiserfs/inode.c	2007-08-27 21:22:40.000000000 -0700
@@ -336,7 +336,8 @@ static int _get_block_create_0(struct in
 		goto finished;
 	}
 	// read file tail into part of page
-	offset = (cpu_key_k_offset(&key) - 1) & (PAGE_CACHE_SIZE - 1);
+	offset = page_cache_offset(inode->i_mapping,
+				cpu_key_k_offset(&key) - 1);
 	fs_gen = get_generation(inode->i_sb);
 	copy_item_head(&tmp_ih, ih);
 
@@ -522,10 +523,10 @@ static int convert_tail_for_hole(struct 
 		return -EIO;
 
 	/* always try to read until the end of the block */
-	tail_start = tail_offset & (PAGE_CACHE_SIZE - 1);
+	tail_start = page_cache_offset(inode->i_mapping, tail_offset);
 	tail_end = (tail_start | (bh_result->b_size - 1)) + 1;
 
-	index = tail_offset >> PAGE_CACHE_SHIFT;
+	index = page_cache_index(inode->i_mapping, tail_offset);
 	/* hole_page can be zero in case of direct_io, we are sure
 	   that we cannot get here if we write with O_DIRECT into
 	   tail page */
@@ -2007,11 +2008,13 @@ static int grab_tail_page(struct inode *
 	/* we want the page with the last byte in the file,
 	 ** not the page that will hold the next byte for appending
 	 */
-	unsigned long index = (p_s_inode->i_size - 1) >> PAGE_CACHE_SHIFT;
+	unsigned long index = page_cache_index(p_s_inode->i_mapping,
+						p_s_inode->i_size - 1);
 	unsigned long pos = 0;
 	unsigned long start = 0;
 	unsigned long blocksize = p_s_inode->i_sb->s_blocksize;
-	unsigned long offset = (p_s_inode->i_size) & (PAGE_CACHE_SIZE - 1);
+	unsigned long offset = page_cache_index(p_s_inode->i_mapping,
+							p_s_inode->i_size);
 	struct buffer_head *bh;
 	struct buffer_head *head;
 	struct page *page;
@@ -2083,7 +2086,8 @@ int reiserfs_truncate_file(struct inode 
 {
 	struct reiserfs_transaction_handle th;
 	/* we want the offset for the first byte after the end of the file */
-	unsigned long offset = p_s_inode->i_size & (PAGE_CACHE_SIZE - 1);
+	unsigned long offset = page_cache_offset(p_s_inode->i_mapping,
+							p_s_inode->i_size);
 	unsigned blocksize = p_s_inode->i_sb->s_blocksize;
 	unsigned length;
 	struct page *page = NULL;
@@ -2232,7 +2236,7 @@ static int map_block_for_writepage(struc
 	} else if (is_direct_le_ih(ih)) {
 		char *p;
 		p = page_address(bh_result->b_page);
-		p += (byte_offset - 1) & (PAGE_CACHE_SIZE - 1);
+		p += page_cache_offset(inode->i_mapping, byte_offset - 1);
 		copy_size = ih_item_len(ih) - pos_in_item;
 
 		fs_gen = get_generation(inode->i_sb);
@@ -2331,7 +2335,8 @@ static int reiserfs_write_full_page(stru
 				    struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
-	unsigned long end_index = inode->i_size >> PAGE_CACHE_SHIFT;
+	unsigned long end_index = page_cache_index(inode->i_mapping,
+							inode->i_size);
 	int error = 0;
 	unsigned long block;
 	sector_t last_block;
@@ -2341,7 +2346,7 @@ static int reiserfs_write_full_page(stru
 	int checked = PageChecked(page);
 	struct reiserfs_transaction_handle th;
 	struct super_block *s = inode->i_sb;
-	int bh_per_page = PAGE_CACHE_SIZE / s->s_blocksize;
+	int bh_per_page = page_cache_size(inode->i_mapping) / s->s_blocksize;
 	th.t_trans_id = 0;
 
 	/* no logging allowed when nonblocking or from PF_MEMALLOC */
@@ -2368,16 +2373,18 @@ static int reiserfs_write_full_page(stru
 	if (page->index >= end_index) {
 		unsigned last_offset;
 
-		last_offset = inode->i_size & (PAGE_CACHE_SIZE - 1);
+		last_offset = page_cache_offset(inode->i_mapping, inode->i_size);
 		/* no file contents in this page */
 		if (page->index >= end_index + 1 || !last_offset) {
 			unlock_page(page);
 			return 0;
 		}
-		zero_user_segment(page, last_offset, PAGE_CACHE_SIZE);
+		zero_user_segment(page, last_offset,
+				page_cache_size(inode->i_mapping));
 	}
 	bh = head;
-	block = page->index << (PAGE_CACHE_SHIFT - s->s_blocksize_bits);
+	block = page->index << (page_cache_shift(inode->i_mapping)
+						- s->s_blocksize_bits);
 	last_block = (i_size_read(inode) - 1) >> inode->i_blkbits;
 	/* first map all the buffers, logging any direct items we find */
 	do {
@@ -2608,7 +2615,7 @@ static int reiserfs_commit_write(struct 
 				 unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t) page->index << PAGE_CACHE_SHIFT) + to;
+	loff_t pos = page_cache_pos(page->mapping, page->index, to);
 	int ret = 0;
 	int update_sd = 0;
 	struct reiserfs_transaction_handle *th = NULL;
Index: linux-2.6/fs/reiserfs/ioctl.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/ioctl.c	2007-08-27 21:22:36.000000000 -0700
+++ linux-2.6/fs/reiserfs/ioctl.c	2007-08-27 21:22:40.000000000 -0700
@@ -168,8 +168,8 @@ static int reiserfs_unpack(struct inode 
 	 ** reiserfs_prepare_write on that page.  This will force a 
 	 ** reiserfs_get_block to unpack the tail for us.
 	 */
-	index = inode->i_size >> PAGE_CACHE_SHIFT;
 	mapping = inode->i_mapping;
+	index = page_cache_index(mapping, inode->i_size);
 	page = grab_cache_page(mapping, index);
 	retval = -ENOMEM;
 	if (!page) {
Index: linux-2.6/fs/reiserfs/stree.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/stree.c	2007-08-27 21:22:36.000000000 -0700
+++ linux-2.6/fs/reiserfs/stree.c	2007-08-27 21:22:40.000000000 -0700
@@ -1283,7 +1283,8 @@ int reiserfs_delete_item(struct reiserfs
 		 */
 
 		data = kmap_atomic(p_s_un_bh->b_page, KM_USER0);
-		off = ((le_ih_k_offset(&s_ih) - 1) & (PAGE_CACHE_SIZE - 1));
+		off = page_cache_offset(p_s_inode->i_mapping,
+					le_ih_k_offset(&s_ih) - 1);
 		memcpy(data + off,
 		       B_I_PITEM(PATH_PLAST_BUFFER(p_s_path), &s_ih),
 		       n_ret_value);
@@ -1439,7 +1440,7 @@ static void unmap_buffers(struct page *p
 
 	if (page) {
 		if (page_has_buffers(page)) {
-			tail_index = pos & (PAGE_CACHE_SIZE - 1);
+			tail_index = page_cache_offset(page_mapping(page), pos);
 			cur_index = 0;
 			head = page_buffers(page);
 			bh = head;
@@ -1459,7 +1460,8 @@ static void unmap_buffers(struct page *p
 				bh = next;
 			} while (bh != head);
 			if (PAGE_SIZE == bh->b_size) {
-				cancel_dirty_page(page, PAGE_CACHE_SIZE);
+				cancel_dirty_page(page,
+					page_cache_size(page_mapping(page)));
 			}
 		}
 	}
Index: linux-2.6/fs/reiserfs/tail_conversion.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/tail_conversion.c	2007-08-27 21:22:36.000000000 -0700
+++ linux-2.6/fs/reiserfs/tail_conversion.c	2007-08-27 21:22:40.000000000 -0700
@@ -128,7 +128,8 @@ int direct2indirect(struct reiserfs_tran
 	 */
 	if (up_to_date_bh) {
 		unsigned pgoff =
-		    (tail_offset + total_tail - 1) & (PAGE_CACHE_SIZE - 1);
+			page_cache_offset(inode->i_mapping,
+			tail_offset + total_tail - 1);
 		char *kaddr = kmap_atomic(up_to_date_bh->b_page, KM_USER0);
 		memset(kaddr + pgoff, 0, n_blk_size - total_tail);
 		kunmap_atomic(kaddr, KM_USER0);
@@ -238,7 +239,7 @@ int indirect2direct(struct reiserfs_tran
 	 ** the page was locked and this part of the page was up to date when
 	 ** indirect2direct was called, so we know the bytes are still valid
 	 */
-	tail = tail + (pos & (PAGE_CACHE_SIZE - 1));
+	tail = tail + page_cache_offset(p_s_inode->i_mapping, pos);
 
 	PATH_LAST_POSITION(p_s_path)++;
 
Index: linux-2.6/fs/reiserfs/xattr.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/xattr.c	2007-08-27 21:22:36.000000000 -0700
+++ linux-2.6/fs/reiserfs/xattr.c	2007-08-27 21:56:54.000000000 -0700
@@ -487,13 +487,13 @@ reiserfs_xattr_set(struct inode *inode, 
 	while (buffer_pos < buffer_size || buffer_pos == 0) {
 		size_t chunk;
 		size_t skip = 0;
-		size_t page_offset = (file_pos & (PAGE_CACHE_SIZE - 1));
-		if (buffer_size - buffer_pos > PAGE_CACHE_SIZE)
-			chunk = PAGE_CACHE_SIZE;
+		size_t page_offset = page_cache_offset(mapping, file_pos);
+		if (buffer_size - buffer_pos > page_cache_size(mapping))
+			chunk = page_cache_size(mapping);
 		else
 			chunk = buffer_size - buffer_pos;
 
-		page = reiserfs_get_page(xinode, file_pos >> PAGE_CACHE_SHIFT);
+		page = reiserfs_get_page(xinode, page_cache_index(mapping, file_pos));
 		if (IS_ERR(page)) {
 			err = PTR_ERR(page);
 			goto out_filp;
@@ -505,8 +505,8 @@ reiserfs_xattr_set(struct inode *inode, 
 		if (file_pos == 0) {
 			struct reiserfs_xattr_header *rxh;
 			skip = file_pos = sizeof(struct reiserfs_xattr_header);
-			if (chunk + skip > PAGE_CACHE_SIZE)
-				chunk = PAGE_CACHE_SIZE - skip;
+			if (chunk + skip > page_cache_size(mapping))
+				chunk = page_cache_size(mapping) - skip;
 			rxh = (struct reiserfs_xattr_header *)data;
 			rxh->h_magic = cpu_to_le32(REISERFS_XATTR_MAGIC);
 			rxh->h_hash = cpu_to_le32(xahash);
@@ -597,12 +597,13 @@ reiserfs_xattr_get(const struct inode *i
 		size_t chunk;
 		char *data;
 		size_t skip = 0;
-		if (isize - file_pos > PAGE_CACHE_SIZE)
-			chunk = PAGE_CACHE_SIZE;
+		if (isize - file_pos > page_cache_size(xinode->i_mapping))
+			chunk = page_cache_size(xinode->i_mapping);
 		else
 			chunk = isize - file_pos;
 
-		page = reiserfs_get_page(xinode, file_pos >> PAGE_CACHE_SHIFT);
+		page = reiserfs_get_page(xinode,
+				page_cache_index(xinode->i_mapping, file_pos));
 		if (IS_ERR(page)) {
 			err = PTR_ERR(page);
 			goto out_dput;

-- 
