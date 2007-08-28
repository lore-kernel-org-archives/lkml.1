Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbXH1TTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbXH1TTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761364AbXH1TIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:08:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58794 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756663AbXH1THh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:37 -0400
Message-Id: <20070828190731.843688953@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:08 -0700
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
Subject: [17/36] Use page_cache_xxx in fs/ext4
Content-Disposition: inline; filename=0017-Use-page_cache_xxx-in-fs-ext4.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use page_cache_xxx in fs/ext4

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/ext4/dir.c   |    3 ++-
 fs/ext4/inode.c |   31 ++++++++++++++++---------------
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 3ab01c0..9d6cd51 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -136,7 +136,8 @@ static int ext4_readdir(struct file * filp,
 		err = ext4_get_blocks_wrap(NULL, inode, blk, 1, &map_bh, 0, 0);
 		if (err > 0) {
 			pgoff_t index = map_bh.b_blocknr >>
-					(PAGE_CACHE_SHIFT - inode->i_blkbits);
+				(page_cache_size(node->i_mapping)
+					- inode->i_blkbits);
 			if (!ra_has_index(&filp->f_ra, index))
 				page_cache_sync_readahead(
 					sb->s_bdev->bd_inode->i_mapping,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3fe1e40..0be5bf8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1223,7 +1223,7 @@ static int ext4_ordered_commit_write(struct file *file, struct page *page,
 		 */
 		loff_t new_i_size;
 
-		new_i_size = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+		new_i_size = page_cache_pos(page->mapping, page->index, to);
 		if (new_i_size > EXT4_I(inode)->i_disksize)
 			EXT4_I(inode)->i_disksize = new_i_size;
 		ret = generic_commit_write(file, page, from, to);
@@ -1242,7 +1242,7 @@ static int ext4_writeback_commit_write(struct file *file, struct page *page,
 	int ret = 0, ret2;
 	loff_t new_i_size;
 
-	new_i_size = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	new_i_size = page_cache_pos(page->mapping, page->index, to);
 	if (new_i_size > EXT4_I(inode)->i_disksize)
 		EXT4_I(inode)->i_disksize = new_i_size;
 
@@ -1269,7 +1269,7 @@ static int ext4_journalled_commit_write(struct file *file,
 	/*
 	 * Here we duplicate the generic_commit_write() functionality
 	 */
-	pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	pos = page_cache_pos(page->mapping, page->index, to);
 
 	ret = walk_page_buffers(handle, page_buffers(page), from,
 				to, &partial, commit_write_fn);
@@ -1421,6 +1421,7 @@ static int ext4_ordered_writepage(struct page *page,
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
+	int pagesize = page_cache_size(inode->i_mapping);
 
 	J_ASSERT(PageLocked(page));
 
@@ -1443,8 +1444,7 @@ static int ext4_ordered_writepage(struct page *page,
 				(1 << BH_Dirty)|(1 << BH_Uptodate));
 	}
 	page_bufs = page_buffers(page);
-	walk_page_buffers(handle, page_bufs, 0,
-			PAGE_CACHE_SIZE, NULL, bget_one);
+	walk_page_buffers(handle, page_bufs, 0, pagesize, NULL, bget_one);
 
 	ret = block_write_full_page(page, ext4_get_block, wbc);
 
@@ -1461,13 +1461,12 @@ static int ext4_ordered_writepage(struct page *page,
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
@@ -1519,6 +1518,7 @@ static int ext4_journalled_writepage(struct page *page,
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
+	int pagesize = page_cache_size(inode->i_mapping);
 
 	if (ext4_journal_current_handle())
 		goto no_write;
@@ -1535,17 +1535,17 @@ static int ext4_journalled_writepage(struct page *page,
 		 * doesn't seem much point in redirtying the page here.
 		 */
 		ClearPageChecked(page);
-		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
+		ret = block_prepare_write(page, 0, pagesize,
 					ext4_get_block);
 		if (ret != 0) {
 			ext4_journal_stop(handle);
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
 		EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
@@ -1760,8 +1760,8 @@ void ext4_set_aops(struct inode *inode)
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
@@ -1769,7 +1769,8 @@ int ext4_block_truncate_page(handle_t *handle, struct page *page,
 
 	blocksize = inode->i_sb->s_blocksize;
 	length = blocksize - (offset & (blocksize - 1));
-	iblock = index << (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
+	iblock = index <<
+		(page_cache_shift(mapping) - inode->i_sb->s_blocksize_bits);
 
 	/*
 	 * For "nobh" option,  we can only work if we don't need to
@@ -2249,7 +2250,7 @@ void ext4_truncate(struct inode *inode)
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
