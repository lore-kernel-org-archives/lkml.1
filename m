Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbXFTSmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbXFTSmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759563AbXFTSbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54795 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756889AbXFTSaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:11 -0400
Message-Id: <20070620183010.235108688@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:25 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [18/37] Use page_cache_xxx in fs/reiserfs
Content-Disposition: inline; filename=vps_fs_reiserfs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/reiserfs/bitmap.c          |    7 ++++++-
 fs/reiserfs/file.c            |    5 +++--
 fs/reiserfs/inode.c           |   37 ++++++++++++++++++++++---------------
 fs/reiserfs/ioctl.c           |    2 +-
 fs/reiserfs/stree.c           |    8 +++++---
 fs/reiserfs/tail_conversion.c |    5 +++--
 fs/reiserfs/xattr.c           |   19 ++++++++++---------
 7 files changed, 50 insertions(+), 33 deletions(-)

Index: linux-2.6.22-rc4-mm2/fs/reiserfs/ioctl.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/reiserfs/ioctl.c	2007-06-18 19:04:34.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/reiserfs/ioctl.c	2007-06-18 19:04:38.000000000 -0700
@@ -173,8 +173,8 @@ static int reiserfs_unpack(struct inode 
 	 ** reiserfs_prepare_write on that page.  This will force a 
 	 ** reiserfs_get_block to unpack the tail for us.
 	 */
-	index = inode->i_size >> PAGE_CACHE_SHIFT;
 	mapping = inode->i_mapping;
+	index = page_cache_index(mapping, inode->i_size);
 	page = grab_cache_page(mapping, index);
 	retval = -ENOMEM;
 	if (!page) {
Index: linux-2.6.22-rc4-mm2/fs/reiserfs/stree.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/reiserfs/stree.c	2007-06-18 19:04:34.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/reiserfs/stree.c	2007-06-18 19:04:38.000000000 -0700
@@ -1282,7 +1282,8 @@ int reiserfs_delete_item(struct reiserfs
 		 */
 
 		data = kmap_atomic(p_s_un_bh->b_page, KM_USER0);
-		off = ((le_ih_k_offset(&s_ih) - 1) & (PAGE_CACHE_SIZE - 1));
+		off = page_cache_offset(p_s_inode->i_mapping,
+					le_ih_k_offset(&s_ih) - 1);
 		memcpy(data + off,
 		       B_I_PITEM(PATH_PLAST_BUFFER(p_s_path), &s_ih),
 		       n_ret_value);
@@ -1438,7 +1439,7 @@ static void unmap_buffers(struct page *p
 
 	if (page) {
 		if (page_has_buffers(page)) {
-			tail_index = pos & (PAGE_CACHE_SIZE - 1);
+			tail_index = page_cache_offset(page_mapping(page), pos);
 			cur_index = 0;
 			head = page_buffers(page);
 			bh = head;
@@ -1458,7 +1459,8 @@ static void unmap_buffers(struct page *p
 				bh = next;
 			} while (bh != head);
 			if (PAGE_SIZE == bh->b_size) {
-				cancel_dirty_page(page, PAGE_CACHE_SIZE);
+				cancel_dirty_page(page,
+					page_cache_size(page_mapping(page)));
 			}
 		}
 	}
Index: linux-2.6.22-rc4-mm2/fs/reiserfs/tail_conversion.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/reiserfs/tail_conversion.c	2007-06-18 19:04:34.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/reiserfs/tail_conversion.c	2007-06-18 19:21:18.000000000 -0700
@@ -128,7 +128,8 @@ int direct2indirect(struct reiserfs_tran
 	 */
 	if (up_to_date_bh) {
 		unsigned pgoff =
-		    (tail_offset + total_tail - 1) & (PAGE_CACHE_SIZE - 1);
+		    	page_cache_offset(inode->i_mapping,
+		    			tail_offset + total_tail - 1);
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
 
Index: linux-2.6.22-rc4-mm2/fs/reiserfs/file.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/reiserfs/file.c	2007-06-18 19:04:34.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/reiserfs/file.c	2007-06-18 19:04:38.000000000 -0700
@@ -161,11 +161,12 @@ int reiserfs_commit_page(struct inode *i
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
 
Index: linux-2.6.22-rc4-mm2/fs/reiserfs/xattr.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/reiserfs/xattr.c	2007-06-18 19:04:34.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/reiserfs/xattr.c	2007-06-18 21:53:15.000000000 -0700
@@ -493,13 +493,13 @@ reiserfs_xattr_set(struct inode *inode, 
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
@@ -511,8 +511,8 @@ reiserfs_xattr_set(struct inode *inode, 
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
@@ -603,12 +603,13 @@ reiserfs_xattr_get(const struct inode *i
 		size_t chunk;
 		char *data;
 		size_t skip = 0;
-		if (isize - file_pos > PAGE_CACHE_SIZE)
-			chunk = PAGE_CACHE_SIZE;
+		if (isize - file_pos > page_cache_size(xinode->mapping))
+			chunk = page_cache_size(xinode->mapping);
 		else
 			chunk = isize - file_pos;
 
-		page = reiserfs_get_page(xinode, file_pos >> PAGE_CACHE_SHIFT);
+		page = reiserfs_get_page(xinode,
+				page_index(xinode->mapping, file_pos));
 		if (IS_ERR(page)) {
 			err = PTR_ERR(page);
 			goto out_dput;
Index: linux-2.6.22-rc4-mm2/fs/reiserfs/inode.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/reiserfs/inode.c	2007-06-18 19:04:34.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/reiserfs/inode.c	2007-06-18 19:20:38.000000000 -0700
@@ -337,7 +337,8 @@ static int _get_block_create_0(struct in
 		goto finished;
 	}
 	// read file tail into part of page
-	offset = (cpu_key_k_offset(&key) - 1) & (PAGE_CACHE_SIZE - 1);
+	offset = page_cache_offset(inode->i_mapping,
+				cpu_key_k_offset(&key) - 1);
 	fs_gen = get_generation(inode->i_sb);
 	copy_item_head(&tmp_ih, ih);
 
@@ -523,10 +524,10 @@ static int convert_tail_for_hole(struct 
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
@@ -2008,11 +2009,13 @@ static int grab_tail_page(struct inode *
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
@@ -2084,7 +2087,8 @@ int reiserfs_truncate_file(struct inode 
 {
 	struct reiserfs_transaction_handle th;
 	/* we want the offset for the first byte after the end of the file */
-	unsigned long offset = p_s_inode->i_size & (PAGE_CACHE_SIZE - 1);
+	unsigned long offset = page_cache_offset(p_s_inode->i_mapping,
+							p_s_inode->i_size);
 	unsigned blocksize = p_s_inode->i_sb->s_blocksize;
 	unsigned length;
 	struct page *page = NULL;
@@ -2233,7 +2237,7 @@ static int map_block_for_writepage(struc
 	} else if (is_direct_le_ih(ih)) {
 		char *p;
 		p = page_address(bh_result->b_page);
-		p += (byte_offset - 1) & (PAGE_CACHE_SIZE - 1);
+		p += page_cache_offset(inode->i_mapping, byte_offset - 1);
 		copy_size = ih_item_len(ih) - pos_in_item;
 
 		fs_gen = get_generation(inode->i_sb);
@@ -2332,7 +2336,8 @@ static int reiserfs_write_full_page(stru
 				    struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
-	unsigned long end_index = inode->i_size >> PAGE_CACHE_SHIFT;
+	unsigned long end_index = page_cache_index(inode->i_mapping,
+							inode->i_size);
 	int error = 0;
 	unsigned long block;
 	sector_t last_block;
@@ -2342,7 +2347,7 @@ static int reiserfs_write_full_page(stru
 	int checked = PageChecked(page);
 	struct reiserfs_transaction_handle th;
 	struct super_block *s = inode->i_sb;
-	int bh_per_page = PAGE_CACHE_SIZE / s->s_blocksize;
+	int bh_per_page = page_cache_size(inode->i_mapping) / s->s_blocksize;
 	th.t_trans_id = 0;
 
 	/* no logging allowed when nonblocking or from PF_MEMALLOC */
@@ -2369,16 +2374,18 @@ static int reiserfs_write_full_page(stru
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
@@ -2570,7 +2577,7 @@ static int reiserfs_write_begin(struct f
 		*fsdata = (void *)(unsigned long)flags;
 	}
 
-	index = pos >> PAGE_CACHE_SHIFT;
+	index = page_cache_index(mapping, pos);
 	page = __grab_cache_page(mapping, index);
 	if (!page)
 		return -ENOMEM;
@@ -2694,7 +2701,7 @@ static int reiserfs_write_end(struct fil
 	else
 		th = NULL;
 
-	start = pos & (PAGE_CACHE_SIZE - 1);
+	start = page_cache_offset(mapping, pos);
 	if (unlikely(copied < len)) {
 		if (!PageUptodate(page))
 			copied = 0;
@@ -2774,7 +2781,7 @@ int reiserfs_commit_write(struct file *f
 			  unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t) page->index << PAGE_CACHE_SHIFT) + to;
+	loff_t pos = page_cache_pos(inode->i_mapping, page->index, to);
 	int ret = 0;
 	int update_sd = 0;
 	struct reiserfs_transaction_handle *th = NULL;
Index: linux-2.6.22-rc4-mm2/fs/reiserfs/bitmap.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/reiserfs/bitmap.c	2007-06-18 19:04:34.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/reiserfs/bitmap.c	2007-06-18 19:04:38.000000000 -0700
@@ -1249,9 +1249,14 @@ int reiserfs_can_fit_pages(struct super_
 	int space;
 
 	spin_lock(&REISERFS_SB(sb)->bitmap_lock);
+
+	/*
+	 * Note the PAGE_SHIFT here. This means that the superblock
+	 * and metadata is restricted to page size.
+	 */
 	space =
 	    (SB_FREE_BLOCKS(sb) -
-	     REISERFS_SB(sb)->reserved_blocks) >> (PAGE_CACHE_SHIFT -
+	     REISERFS_SB(sb)->reserved_blocks) >> (PAGE_SHIFT -
 						   sb->s_blocksize_bits);
 	spin_unlock(&REISERFS_SB(sb)->bitmap_lock);
 

-- 
