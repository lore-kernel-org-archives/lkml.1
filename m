Return-Path: <linux-kernel-owner+w=401wt.eu-S1030855AbXCNNjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030855AbXCNNjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 09:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030853AbXCNNjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 09:39:06 -0400
Received: from mail.suse.de ([195.135.220.2]:59584 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030849AbXCNNjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 09:39:01 -0400
From: Nick Piggin <npiggin@suse.de>
To: Linux Filesystems <linux-fsdevel@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Message-Id: <20070314112613.13798.44558.sendpatchset@linux.site>
In-Reply-To: <20070314112529.13798.35417.sendpatchset@linux.site>
References: <20070314112529.13798.35417.sendpatchset@linux.site>
Subject: [patch 5/5] ext3: convert to new aops
Date: Wed, 14 Mar 2007 14:38:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement new aops for ext3. Probably has some bugs in interaction with
journalling, and corner cases aren't tested/thought out fully, but it
boots and runs. I don't see a fundamental reason why it can't work...

 fs/ext3/inode.c |  137 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 88 insertions(+), 49 deletions(-)

Index: linux-2.6/fs/ext3/inode.c
===================================================================
--- linux-2.6.orig/fs/ext3/inode.c
+++ linux-2.6/fs/ext3/inode.c
@@ -1155,7 +1155,7 @@ static int do_journal_get_write_access(h
  * This content is expected to be set to zeroes by block_prepare_write().
  * 2006/10/14  SAW
  */
-static int ext3_prepare_failure(struct file *file, struct page *page,
+static int ext3_write_failure(struct file *file, struct page *page,
 				unsigned from, unsigned to)
 {
 	struct address_space *mapping;
@@ -1208,29 +1208,40 @@ skip:
 	return mapping->a_ops->commit_write(file, page, from, block_start);
 }
 
-static int ext3_prepare_write(struct file *file, struct page *page,
-			      unsigned from, unsigned to)
+static int ext3_write_begin(struct file *file, struct address_space *mapping,
+				loff_t pos, unsigned len, int intr,
+				struct page **pagep, void **fsdata)
 {
-	struct inode *inode = page->mapping->host;
-	int ret, ret2;
+	struct inode *inode = mapping->host;
 	int needed_blocks = ext3_writepage_trans_blocks(inode);
+	int ret, ret2;
 	handle_t *handle;
 	int retries = 0;
+	struct page *page;
+	pgoff_t index;
+	unsigned start, end;
+
+	index = pos >> PAGE_CACHE_SHIFT;
+	start = pos * (PAGE_CACHE_SIZE - 1);
+	end = start + len;
+
+	page = __grab_cache_page(mapping, index);
+	if (!page)
+		return -ENOMEM;
+	*pagep = page;
 
 retry:
 	handle = ext3_journal_start(inode, needed_blocks);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
-	if (test_opt(inode->i_sb, NOBH) && ext3_should_writeback_data(inode))
-		ret = nobh_prepare_write(page, from, to, ext3_get_block);
-	else
-		ret = block_prepare_write(page, from, to, ext3_get_block);
+	ret = block_write_begin(file, mapping, pos, len, intr, pagep, fsdata,
+							ext3_get_block);
 	if (ret)
 		goto failure;
 
 	if (ext3_should_journal_data(inode)) {
 		ret = walk_page_buffers(handle, page_buffers(page),
-				from, to, NULL, do_journal_get_write_access);
+				start, end, NULL, do_journal_get_write_access);
 		if (ret)
 			/* fatal error, just put the handle and return */
 			journal_stop(handle);
@@ -1238,7 +1249,7 @@ retry:
 	return ret;
 
 failure:
-	ret2 = ext3_prepare_failure(file, page, from, to);
+	ret2 = ext3_write_failure(file, page, start, end);
 	if (ret2 < 0)
 		return ret2;
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
@@ -1247,17 +1258,18 @@ failure:
 	return ret;
 }
 
+
 int ext3_journal_dirty_data(handle_t *handle, struct buffer_head *bh)
 {
 	int err = journal_dirty_data(handle, bh);
 	if (err)
 		ext3_journal_abort_handle(__FUNCTION__, __FUNCTION__,
-						bh, handle,err);
+						bh, handle, err);
 	return err;
 }
 
-/* For commit_write() in data=journal mode */
-static int commit_write_fn(handle_t *handle, struct buffer_head *bh)
+/* For write_end() in data=journal mode */
+static int write_end_fn(handle_t *handle, struct buffer_head *bh)
 {
 	if (!buffer_mapped(bh) || buffer_freed(bh))
 		return 0;
@@ -1272,78 +1284,103 @@ static int commit_write_fn(handle_t *han
  * ext3 never places buffers on inode->i_mapping->private_list.  metadata
  * buffers are managed internally.
  */
-static int ext3_ordered_commit_write(struct file *file, struct page *page,
-			     unsigned from, unsigned to)
+static int ext3_ordered_write_end(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = file->f_mapping->host;
+	unsigned from, to;
 	int ret = 0, ret2;
 
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + len;
+
 	ret = walk_page_buffers(handle, page_buffers(page),
 		from, to, NULL, ext3_journal_dirty_data);
 
 	if (ret == 0) {
 		/*
-		 * generic_commit_write() will run mark_inode_dirty() if i_size
+		 * block_write_end() will run mark_inode_dirty() if i_size
 		 * changes.  So let's piggyback the i_disksize mark_inode_dirty
 		 * into that.
 		 */
 		loff_t new_i_size;
 
-		new_i_size = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+		new_i_size = pos + copied;
 		if (new_i_size > EXT3_I(inode)->i_disksize)
 			EXT3_I(inode)->i_disksize = new_i_size;
-		ret = generic_commit_write(file, page, from, to);
+		copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
+		if (copied < 0)
+			ret = copied;
 	}
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	return ret;
+	return ret ? ret : copied;
 }
 
-static int ext3_writeback_commit_write(struct file *file, struct page *page,
-			     unsigned from, unsigned to)
+static int ext3_writeback_write_end(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = file->f_mapping->host;
 	int ret = 0, ret2;
 	loff_t new_i_size;
 
-	new_i_size = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	new_i_size = pos + copied;
 	if (new_i_size > EXT3_I(inode)->i_disksize)
 		EXT3_I(inode)->i_disksize = new_i_size;
 
-	if (test_opt(inode->i_sb, NOBH) && ext3_should_writeback_data(inode))
-		ret = nobh_commit_write(file, page, from, to);
-	else
-		ret = generic_commit_write(file, page, from, to);
+	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
+	if (copied < 0)
+		ret = copied;
 
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	return ret;
+	return ret ? ret : copied;
 }
 
-static int ext3_journalled_commit_write(struct file *file,
-			struct page *page, unsigned from, unsigned to)
+static int ext3_journalled_write_end(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = mapping->host;
 	int ret = 0, ret2;
 	int partial = 0;
-	loff_t pos;
+	unsigned from, to;
 
-	/*
-	 * Here we duplicate the generic_commit_write() functionality
-	 */
-	pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + len;
+
+	if (copied < len) {
+		if (PageUptodate(page))
+			copied = len;
+		else {
+			/* XXX: don't need to zero new buffers because we abort? */
+			copied = 0;
+			if (!is_handle_aborted(handle))
+				journal_abort_handle(handle);
+			unlock_page(page);
+			page_cache_release(page);
+			goto out;
+		}
+	}
 
 	ret = walk_page_buffers(handle, page_buffers(page), from,
-				to, &partial, commit_write_fn);
+				to, &partial, write_end_fn);
 	if (!partial)
 		SetPageUptodate(page);
-	if (pos > inode->i_size)
-		i_size_write(inode, pos);
+	unlock_page(page);
+	page_cache_release(page);
+	if (pos+copied > inode->i_size)
+		i_size_write(inode, pos+copied);
 	EXT3_I(inode)->i_state |= EXT3_STATE_JDATA;
 	if (inode->i_size > EXT3_I(inode)->i_disksize) {
 		EXT3_I(inode)->i_disksize = inode->i_size;
@@ -1351,10 +1388,12 @@ static int ext3_journalled_commit_write(
 		if (!ret)
 			ret = ret2;
 	}
+
+out:
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	return ret;
+	return ret ? ret : copied;
 }
 
 /*
@@ -1612,7 +1651,7 @@ static int ext3_journalled_writepage(str
 			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
 
 		err = walk_page_buffers(handle, page_buffers(page), 0,
-				PAGE_CACHE_SIZE, NULL, commit_write_fn);
+				PAGE_CACHE_SIZE, NULL, write_end_fn);
 		if (ret == 0)
 			ret = err;
 		EXT3_I(inode)->i_state |= EXT3_STATE_JDATA;
@@ -1772,8 +1811,8 @@ static const struct address_space_operat
 	.readpages	= ext3_readpages,
 	.writepage	= ext3_ordered_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= ext3_prepare_write,
-	.commit_write	= ext3_ordered_commit_write,
+	.write_begin	= ext3_write_begin,
+	.write_end	= ext3_ordered_write_end,
 	.bmap		= ext3_bmap,
 	.invalidatepage	= ext3_invalidatepage,
 	.releasepage	= ext3_releasepage,
@@ -1786,8 +1825,8 @@ static const struct address_space_operat
 	.readpages	= ext3_readpages,
 	.writepage	= ext3_writeback_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= ext3_prepare_write,
-	.commit_write	= ext3_writeback_commit_write,
+	.write_begin	= ext3_write_begin,
+	.write_end	= ext3_writeback_write_end,
 	.bmap		= ext3_bmap,
 	.invalidatepage	= ext3_invalidatepage,
 	.releasepage	= ext3_releasepage,
@@ -1800,8 +1839,8 @@ static const struct address_space_operat
 	.readpages	= ext3_readpages,
 	.writepage	= ext3_journalled_writepage,
 	.sync_page	= block_sync_page,
-	.prepare_write	= ext3_prepare_write,
-	.commit_write	= ext3_journalled_commit_write,
+	.write_begin	= ext3_write_begin,
+	.write_end	= ext3_journalled_write_end,
 	.set_page_dirty	= ext3_journalled_set_page_dirty,
 	.bmap		= ext3_bmap,
 	.invalidatepage	= ext3_invalidatepage,
