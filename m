Return-Path: <linux-kernel-owner+w=401wt.eu-S932496AbXH1TMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbXH1TMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761152AbXH1TIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:08:01 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58793 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756677AbXH1THh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:37 -0400
Message-Id: <20070828190731.389365554@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:07 -0700
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
Subject: [16/36] Use page_cache_xxx in fs/ext3
Content-Disposition: inline; filename=0016-Use-page_cache_xxx-in-fs-ext3.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use page_cache_xxx in fs/ext3

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/ext3/dir.c   |    3 ++-
 fs/ext3/inode.c |   34 +++++++++++++++++-----------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index c00723a..a65b5a7 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -137,7 +137,8 @@ static int ext3_readdir(struct file * filp,
 						&map_bh, 0, 0);
 		if (err > 0) {
 			pgoff_t index = map_bh.b_blocknr >>
-					(PAGE_CACHE_SHIFT - inode->i_blkbits);
+				(page_cache_shift(inode->i_mapping)
+					- inode->i_blkbits);
 			if (!ra_has_index(&filp->f_ra, index))
 				page_cache_sync_readahead(
 					sb->s_bdev->bd_inode->i_mapping,
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index eb3c264..986519b 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1224,7 +1224,7 @@ static int ext3_ordered_commit_write(struct file *file, struct page *page,
 		 */
 		loff_t new_i_size;
 
-		new_i_size = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+		new_i_size = page_cache_pos(page->mapping, page->index, to);
 		if (new_i_size > EXT3_I(inode)->i_disksize)
 			EXT3_I(inode)->i_disksize = new_i_size;
 		ret = generic_commit_write(file, page, from, to);
@@ -1243,7 +1243,7 @@ static int ext3_writeback_commit_write(struct file *file, struct page *page,
 	int ret = 0, ret2;
 	loff_t new_i_size;
 
-	new_i_size = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	new_i_size = page_cache_pos(inode->i_mapping, page->index, to);
 	if (new_i_size > EXT3_I(inode)->i_disksize)
 		EXT3_I(inode)->i_disksize = new_i_size;
 
@@ -1270,7 +1270,7 @@ static int ext3_journalled_commit_write(struct file *file,
 	/*
 	 * Here we duplicate the generic_commit_write() functionality
 	 */
-	pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	pos = page_cache_pos(page->mapping, page->index, to);
 
 	ret = walk_page_buffers(handle, page_buffers(page), from,
 				to, &partial, commit_write_fn);
@@ -1422,6 +1422,7 @@ static int ext3_ordered_writepage(struct page *page,
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
+	int pagesize = page_cache_size(inode->i_mapping);
 
 	J_ASSERT(PageLocked(page));
 
@@ -1444,8 +1445,7 @@ static int ext3_ordered_writepage(struct page *page,
 				(1 << BH_Dirty)|(1 << BH_Uptodate));
 	}
 	page_bufs = page_buffers(page);
-	walk_page_buffers(handle, page_bufs, 0,
-			PAGE_CACHE_SIZE, NULL, bget_one);
+	walk_page_buffers(handle, page_bufs, 0, pagesize, NULL, bget_one);
 
 	ret = block_write_full_page(page, ext3_get_block, wbc);
 
@@ -1462,13 +1462,12 @@ static int ext3_ordered_writepage(struct page *page,
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
@@ -1520,6 +1519,7 @@ static int ext3_journalled_writepage(struct page *page,
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
+	int pagesize = page_cache_size(inode->i_mapping);
 
 	if (ext3_journal_current_handle())
 		goto no_write;
@@ -1536,17 +1536,16 @@ static int ext3_journalled_writepage(struct page *page,
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
-				PAGE_CACHE_SIZE, NULL, commit_write_fn);
+				pagesize, NULL, commit_write_fn);
 		if (ret == 0)
 			ret = err;
 		EXT3_I(inode)->i_state |= EXT3_STATE_JDATA;
@@ -1761,8 +1760,8 @@ void ext3_set_aops(struct inode *inode)
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
@@ -1770,7 +1769,8 @@ static int ext3_block_truncate_page(handle_t *handle, struct page *page,
 
 	blocksize = inode->i_sb->s_blocksize;
 	length = blocksize - (offset & (blocksize - 1));
-	iblock = index << (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
+	iblock = index <<
+		(page_cache_shift(mapping) - inode->i_sb->s_blocksize_bits);
 
 	/*
 	 * For "nobh" option,  we can only work if we don't need to
@@ -2249,7 +2249,7 @@ void ext3_truncate(struct inode *inode)
 		page = NULL;
 	} else {
 		page = grab_cache_page(mapping,
-				inode->i_size >> PAGE_CACHE_SHIFT);
+				page_cache_index(mapping, inode->i_size));
 		if (!page)
 			return;
 	}
-- 
1.5.2.4

-- 
