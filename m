Return-Path: <linux-kernel-owner+w=401wt.eu-S1760993AbXFTSfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760993AbXFTSfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759269AbXFTSaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:30:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54784 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756726AbXFTSaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:10 -0400
Message-Id: <20070620183009.659545915@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:23 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [16/37] Use page_cache_xxx in fs/ext3
Content-Disposition: inline; filename=vps_fs_ext3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/ext3/dir.c   |    3 ++-
 fs/ext3/inode.c |   36 ++++++++++++++++++------------------
 2 files changed, 20 insertions(+), 19 deletions(-)

Index: linux-2.6.22-rc4-mm2/fs/ext3/dir.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/ext3/dir.c	2007-06-15 17:35:33.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/ext3/dir.c	2007-06-18 18:59:38.000000000 -0700
@@ -137,7 +137,8 @@ static int ext3_readdir(struct file * fi
 						&map_bh, 0, 0);
 		if (err > 0) {
 			pgoff_t index = map_bh.b_blocknr >>
-					(PAGE_CACHE_SHIFT - inode->i_blkbits);
+				(page_cache_shift(inode->i_mapping)
+					- inode->i_blkbits);
 			if (!ra_has_index(&filp->f_ra, index))
 				page_cache_readahead_ondemand(
 					sb->s_bdev->bd_inode->i_mapping,
Index: linux-2.6.22-rc4-mm2/fs/ext3/inode.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/ext3/inode.c	2007-06-18 18:42:45.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/ext3/inode.c	2007-06-18 18:59:38.000000000 -0700
@@ -1159,8 +1159,8 @@ static int ext3_write_begin(struct file 
 	pgoff_t index;
 	unsigned from, to;
 
-	index = pos >> PAGE_CACHE_SHIFT;
-	from = pos & (PAGE_CACHE_SIZE - 1);
+	index = page_cache_index(mapping, pos);
+	from = page_cache_offset(mapping, pos);
 	to = from + len;
 
 retry:
@@ -1233,7 +1233,7 @@ static int ext3_ordered_write_end(struct
 	unsigned from, to;
 	int ret = 0, ret2;
 
-	from = pos & (PAGE_CACHE_SIZE - 1);
+	from = page_cache_offset(mapping, pos);
 	to = from + len;
 
 	ret = walk_page_buffers(handle, page_buffers(page),
@@ -1300,7 +1300,7 @@ static int ext3_journalled_write_end(str
 	int partial = 0;
 	unsigned from, to;
 
-	from = pos & (PAGE_CACHE_SIZE - 1);
+	from = page_cache_offset(mapping, pos);
 	to = from + len;
 
 	if (copied < len) {
@@ -1462,6 +1462,7 @@ static int ext3_ordered_writepage(struct
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
+	int pagesize = page_cache_size(inode->i_mapping);
 
 	J_ASSERT(PageLocked(page));
 
@@ -1484,8 +1485,7 @@ static int ext3_ordered_writepage(struct
 				(1 << BH_Dirty)|(1 << BH_Uptodate));
 	}
 	page_bufs = page_buffers(page);
-	walk_page_buffers(handle, page_bufs, 0,
-			PAGE_CACHE_SIZE, NULL, bget_one);
+	walk_page_buffers(handle, page_bufs, 0, pagesize, NULL, bget_one);
 
 	ret = block_write_full_page(page, ext3_get_block, wbc);
 
@@ -1502,13 +1502,12 @@ static int ext3_ordered_writepage(struct
 	 * and generally junk.
 	 */
 	if (ret == 0) {
-		err = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
-					NULL, journal_dirty_data_fn);
+		err = walk_page_buffers(handle, page_bufs, 0, pagesize,
+			NULL, journal_dirty_data_fn);
 		if (!ret)
 			ret = err;
 	}
-	walk_page_buffers(handle, page_bufs, 0,
-			PAGE_CACHE_SIZE, NULL, bput_one);
+	walk_page_buffers(handle, page_bufs, 0, pagesize, NULL, bput_one);
 	err = ext3_journal_stop(handle);
 	if (!ret)
 		ret = err;
@@ -1560,6 +1559,7 @@ static int ext3_journalled_writepage(str
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
+	int pagesize = page_cache_size(inode->i_mapping);
 
 	if (ext3_journal_current_handle())
 		goto no_write;
@@ -1576,17 +1576,16 @@ static int ext3_journalled_writepage(str
 		 * doesn't seem much point in redirtying the page here.
 		 */
 		ClearPageChecked(page);
-		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
-					ext3_get_block);
+		ret = block_prepare_write(page, 0, pagesize, ext3_get_block);
 		if (ret != 0) {
 			ext3_journal_stop(handle);
 			goto out_unlock;
 		}
 		ret = walk_page_buffers(handle, page_buffers(page), 0,
-			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
+			pagesize, NULL, do_journal_get_write_access);
 
 		err = walk_page_buffers(handle, page_buffers(page), 0,
-				PAGE_CACHE_SIZE, NULL, write_end_fn);
+				pagesize, NULL, write_end_fn);
 		if (ret == 0)
 			ret = err;
 		EXT3_I(inode)->i_state |= EXT3_STATE_JDATA;
@@ -1801,8 +1800,8 @@ void ext3_set_aops(struct inode *inode)
 static int ext3_block_truncate_page(handle_t *handle, struct page *page,
 		struct address_space *mapping, loff_t from)
 {
-	ext3_fsblk_t index = from >> PAGE_CACHE_SHIFT;
-	unsigned offset = from & (PAGE_CACHE_SIZE-1);
+	ext3_fsblk_t index = page_cache_index(mapping, from);
+	unsigned offset = page_cache_offset(mapping, from);
 	unsigned blocksize, iblock, length, pos;
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
@@ -1810,7 +1809,8 @@ static int ext3_block_truncate_page(hand
 
 	blocksize = inode->i_sb->s_blocksize;
 	length = blocksize - (offset & (blocksize - 1));
-	iblock = index << (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
+	iblock = index <<
+		(page_cache_shift(mapping) - inode->i_sb->s_blocksize_bits);
 
 	/*
 	 * For "nobh" option,  we can only work if we don't need to
@@ -2289,7 +2289,7 @@ void ext3_truncate(struct inode *inode)
 		page = NULL;
 	} else {
 		page = grab_cache_page(mapping,
-				inode->i_size >> PAGE_CACHE_SHIFT);
+				page_cache_index(mapping, inode->i_size));
 		if (!page)
 			return;
 	}

-- 
