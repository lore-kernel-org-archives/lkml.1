Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbXFTSfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbXFTSfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759155AbXFTSaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:30:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54794 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756891AbXFTSaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:11 -0400
Message-Id: <20070620183009.909068099@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:24 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [17/37] Use page_cache_xxx in fs/ext4
Content-Disposition: inline; filename=vps_fs_ext4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/ext4/dir.c       |    3 ++-
 fs/ext4/inode.c     |   34 +++++++++++++++++-----------------
 fs/ext4/writeback.c |   35 +++++++++++++++++++----------------
 3 files changed, 38 insertions(+), 34 deletions(-)

Index: linux-2.6.22-rc4-mm2/fs/ext4/dir.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/ext4/dir.c	2007-06-18 19:01:00.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/ext4/dir.c	2007-06-18 19:01:06.000000000 -0700
@@ -136,7 +136,8 @@ static int ext4_readdir(struct file * fi
 		err = ext4_get_blocks_wrap(NULL, inode, blk, 1, &map_bh, 0, 0);
 		if (err > 0) {
 			pgoff_t index = map_bh.b_blocknr >>
-					(PAGE_CACHE_SHIFT - inode->i_blkbits);
+				(page_cache_size(node->i_mapping)
+					- inode->i_blkbits);
 			if (!ra_has_index(&filp->f_ra, index))
 				page_cache_readahead_ondemand(
 					sb->s_bdev->bd_inode->i_mapping,
Index: linux-2.6.22-rc4-mm2/fs/ext4/inode.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/ext4/inode.c	2007-06-18 19:01:00.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/ext4/inode.c	2007-06-18 19:01:06.000000000 -0700
@@ -1158,8 +1158,8 @@ static int ext4_write_begin(struct file 
  	pgoff_t index;
  	unsigned from, to;
 
- 	index = pos >> PAGE_CACHE_SHIFT;
- 	from = pos & (PAGE_CACHE_SIZE - 1);
+ 	index = page_cache_index(mapping, pos);
+ 	from = page_cache_offset(mapping, pos);
  	to = from + len;
 
 retry:
@@ -1231,7 +1231,7 @@ static int ext4_ordered_write_end(struct
 	unsigned from, to;
 	int ret = 0, ret2;
 
-	from = pos & (PAGE_CACHE_SIZE - 1);
+	from = page_cache_offset(mapping, pos);
 	to = from + len;
 
 	ret = walk_page_buffers(handle, page_buffers(page),
@@ -1298,7 +1298,7 @@ static int ext4_journalled_write_end(str
 	int partial = 0;
 	unsigned from, to;
 
-	from = pos & (PAGE_CACHE_SIZE - 1);
+	from = page_cache_offset(mapping, pos);
 	to = from + len;
 
 	if (copied < len) {
@@ -1460,6 +1460,7 @@ static int ext4_ordered_writepage(struct
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
+	int pagesize = page_cache_size(inode->i_mapping);
 
 	J_ASSERT(PageLocked(page));
 
@@ -1482,8 +1483,7 @@ static int ext4_ordered_writepage(struct
 				(1 << BH_Dirty)|(1 << BH_Uptodate));
 	}
 	page_bufs = page_buffers(page);
-	walk_page_buffers(handle, page_bufs, 0,
-			PAGE_CACHE_SIZE, NULL, bget_one);
+	walk_page_buffers(handle, page_bufs, 0, pagesize, NULL, bget_one);
 
 	ret = block_write_full_page(page, ext4_get_block, wbc);
 
@@ -1500,13 +1500,12 @@ static int ext4_ordered_writepage(struct
 	 * and generally junk.
 	 */
 	if (ret == 0) {
-		err = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
+		err = walk_page_buffers(handle, page_bufs, 0, pagesize,
 					NULL, jbd2_journal_dirty_data_fn);
 		if (!ret)
 			ret = err;
 	}
-	walk_page_buffers(handle, page_bufs, 0,
-			PAGE_CACHE_SIZE, NULL, bput_one);
+	walk_page_buffers(handle, page_bufs, 0, pagesize, NULL, bput_one);
 	err = ext4_journal_stop(handle);
 	if (!ret)
 		ret = err;
@@ -1558,6 +1557,7 @@ static int ext4_journalled_writepage(str
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
+	int pagesize = page_cache_size(inode->i_mapping);
 
 	if (ext4_journal_current_handle())
 		goto no_write;
@@ -1574,17 +1574,16 @@ static int ext4_journalled_writepage(str
 		 * doesn't seem much point in redirtying the page here.
 		 */
 		ClearPageChecked(page);
-		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
-					ext4_get_block);
+		ret = block_prepare_write(page, 0, pagesize, ext4_get_block);
 		if (ret != 0) {
 			ext4_journal_stop(handle);
 			goto out_unlock;
 		}
 		ret = walk_page_buffers(handle, page_buffers(page), 0,
-			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
+			pagesize, NULL, do_journal_get_write_access);
 
 		err = walk_page_buffers(handle, page_buffers(page), 0,
-				PAGE_CACHE_SIZE, NULL, write_end_fn);
+			pagesize, NULL, write_end_fn);
 		if (ret == 0)
 			ret = err;
 		EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
@@ -1824,8 +1823,8 @@ void ext4_set_aops(struct inode *inode)
 int ext4_block_truncate_page(handle_t *handle, struct page *page,
 		struct address_space *mapping, loff_t from)
 {
-	ext4_fsblk_t index = from >> PAGE_CACHE_SHIFT;
-	unsigned offset = from & (PAGE_CACHE_SIZE-1);
+	ext4_fsblk_t index = page_cache_index(mapping, from);
+	unsigned offset = page_cache_offset(mapping, from);
 	unsigned blocksize, iblock, length, pos;
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
@@ -1839,7 +1838,8 @@ int ext4_block_truncate_page(handle_t *h
 
 	blocksize = inode->i_sb->s_blocksize;
 	length = blocksize - (offset & (blocksize - 1));
-	iblock = index << (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
+	iblock = index <<
+		(page_cache_shift(mapping) - inode->i_sb->s_blocksize_bits);
 
 	/*
 	 * For "nobh" option,  we can only work if we don't need to
@@ -2325,7 +2325,7 @@ void ext4_truncate(struct inode *inode)
 		page = NULL;
 	} else {
 		page = grab_cache_page(mapping,
-				inode->i_size >> PAGE_CACHE_SHIFT);
+				page_cache_index(mapping, inode->i_size));
 		if (!page)
 			return;
 	}
Index: linux-2.6.22-rc4-mm2/fs/ext4/writeback.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/ext4/writeback.c	2007-06-18 19:01:00.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/ext4/writeback.c	2007-06-18 19:01:06.000000000 -0700
@@ -21,7 +21,7 @@
  *   MUST:
  *     - flush dirty pages in -ENOSPC case in order to free reserved blocks
  *     - direct I/O support
- *     - blocksize != PAGE_CACHE_SIZE support
+ *     - blocksize != PAGE_SIZE support
  *     - store last unwritten page in ext4_wb_writepages() and
  *       continue from it in a next run
  *   WISH:
@@ -285,7 +285,7 @@ static int ext4_wb_submit_extent(struct 
 	 * let's cook bios from them and start real I/O
 	 */
 
-	BUG_ON(PAGE_CACHE_SHIFT < blkbits);
+	BUG_ON(page_cache_shift(inode->i_mapping) < blkbits);
 	BUG_ON(list_empty(&wc->list));
 
 	wb_debug("cook and submit bios for %u/%u/%u for %lu/%u\n",
@@ -301,8 +301,9 @@ static int ext4_wb_submit_extent(struct 
 		if (page == NULL)
 			break;
 
-		pstart = page->index << (PAGE_CACHE_SHIFT - blkbits);
-		plen = PAGE_SIZE >> blkbits;
+		pstart = page->index <<
+				(page_cache_shift(node->i_mapping) - blkbits);
+		plen = page_cache_size(inode->i_mapping) >> blkbits;
 		if (pstart > blk) {
 			/* probably extent covers long space and page
 			 * to be written in the middle of it */
@@ -333,7 +334,8 @@ alloc_new_bio:
 			/* +2 because head/tail may belong to different pages */
 			nr_pages = (le16_to_cpu(ex->ee_len) -
 				    (blk - le32_to_cpu(ex->ee_block)));
-			nr_pages = (nr_pages >> (PAGE_CACHE_SHIFT - blkbits));
+			nr_pages = nr_pages >>
+					(page_cache_shift(inode->mapping) - blkbits);
 			off = le32_to_cpu(ex->ee_start) +
 			      (blk - le32_to_cpu(ex->ee_block));
 			off |= (ext4_fsblk_t)
@@ -832,11 +834,12 @@ int ext4_wb_writepages(struct address_sp
 static void ext4_wb_clear_page(struct page *page, int from, int to)
 {
 	void *kaddr;
+	struct address_space *mapping = page_mapping(page);
 
-	if (to < PAGE_CACHE_SIZE || from > 0) {
+	if (to < page_cache_size(mapping) || from > 0) {
 		kaddr = kmap_atomic(page, KM_USER0);
-		if (PAGE_CACHE_SIZE > to)
-			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
+		if (page_cache_size(mapping) > to)
+			memset(kaddr + to, 0, page_cache_size(mapping) - to);
 		if (0 < from)
 			memset(kaddr, 0, from);
 		flush_dcache_page(page);
@@ -878,7 +881,7 @@ int ext4_wb_prepare_write(struct file *f
 		} else {
 			/* block is already mapped, so no need to reserve */
 			BUG_ON(PagePrivate(page));
-			if (to - from < PAGE_CACHE_SIZE) {
+			if (to - from < page_cache_size(inode->i_mapping)) {
 				wb_debug("read block %u\n",
 						(unsigned) bhw->b_blocknr);
 				set_bh_page(bhw, page, 0);
@@ -905,7 +908,7 @@ int ext4_wb_prepare_write(struct file *f
 int ext4_wb_commit_write(struct file *file, struct page *page,
 			     unsigned from, unsigned to)
 {
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	loff_t pos = page_cache_pos(file->f_mapping, page->index, to);
 	struct inode *inode = page->mapping->host;
 	int err = 0;
 
@@ -984,7 +987,7 @@ int ext4_wb_writepage(struct page *page,
 {
 	struct inode *inode = page->mapping->host;
 	loff_t i_size = i_size_read(inode);
-	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
+	pgoff_t end_index = page_cache_index(inode->i_mapping, i_size);
 	unsigned offset;
 	void *kaddr;
 
@@ -1017,7 +1020,7 @@ int ext4_wb_writepage(struct page *page,
 		return ext4_wb_write_single_page(page, wbc);
 
 	/* Is the page fully outside i_size? (truncate in progress) */
-	offset = i_size & (PAGE_CACHE_SIZE-1);
+	offset = page_cache_offset(inode->i_mapping, i_size);
 	if (page->index >= end_index + 1 || !offset) {
 		/*
 		 * The page may have dirty, unmapped buffers.  For example,
@@ -1037,7 +1040,7 @@ int ext4_wb_writepage(struct page *page,
 	 * writes to that region are not written out to the file."
 	 */
 	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
+	memset(kaddr + offset, 0, page_cache_size(inode->i_mapping) - offset);
 	flush_dcache_page(page);
 	kunmap_atomic(kaddr, KM_USER0);
 	return ext4_wb_write_single_page(page, wbc);
@@ -1086,7 +1089,7 @@ void ext4_wb_invalidatepage(struct page 
 int ext4_wb_block_truncate_page(handle_t *handle, struct page *page,
 				struct address_space *mapping, loff_t from)
 {
-	unsigned offset = from & (PAGE_CACHE_SIZE-1);
+	unsigned offset = page_cache_offset(mapping, from);
 	struct inode *inode = mapping->host;
 	struct buffer_head bh, *bhw = &bh;
 	unsigned blocksize, length;
@@ -1147,9 +1150,9 @@ void ext4_wb_init(struct super_block *sb
 	if (!test_opt(sb, DELAYED_ALLOC))
 		return;
 
-	if (PAGE_CACHE_SHIFT != sb->s_blocksize_bits) {
+	if (PAGE_SHIFT != sb->s_blocksize_bits) {
 		printk(KERN_ERR "EXT4-fs: delayed allocation isn't"
-			"supported for PAGE_CACHE_SIZE != blocksize yet\n");
+			"supported for PAGE_SIZE != blocksize yet\n");
 		clear_opt (EXT4_SB(sb)->s_mount_opt, DELAYED_ALLOC);
 		return;
 	}

-- 
