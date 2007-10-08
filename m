Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbXJHGwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbXJHGwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 02:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbXJHGwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 02:52:33 -0400
Received: from mail.suse.de ([195.135.220.2]:36859 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbXJHGwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 02:52:30 -0400
Date: Mon, 8 Oct 2007 08:52:27 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] fs: restore nobh
Message-ID: <20071008065227.GB14949@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is overdue, sorry. Got a little complicated, and I've been away from
my filesystem test setup so I didn't want ot send it (lucky, coz I found
a bug after more substantial testing).

Anyway, RFC?

---
Implement nobh in new aops. This is a bit tricky.
FWIW, nobh_truncate is now implemented in a way that does not
create blocks in sparse regions, which is a silly thing for it
to have been doing (isn't it?)

ext2 survives fsx and fsstress. jfs is converted as well... ext3
should be easy to do (but not done yet).

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c	2007-10-08 14:09:35.000000000 +1000
+++ linux-2.6/fs/buffer.c	2007-10-08 16:45:28.000000000 +1000
@@ -2378,7 +2378,7 @@
 }
 
 /*
- * nobh_prepare_write()'s prereads are special: the buffer_heads are freed
+ * nobh_write_begin()'s prereads are special: the buffer_heads are freed
  * immediately, while under the page lock.  So it needs a special end_io
  * handler which does not touch the bh after unlocking it.
  */
@@ -2388,16 +2388,45 @@
 }
 
 /*
+ * Attach the singly-linked list of buffers created by nobh_write_begin, to
+ * the page (converting it to circular linked list and taking care of page
+ * dirty races).
+ */
+static void attach_nobh_buffers(struct page *page, struct buffer_head *head)
+{
+	struct buffer_head *bh;
+
+	BUG_ON(!PageLocked(page));
+
+	spin_lock(&page->mapping->private_lock);
+	bh = head;
+	do {
+		if (PageDirty(page))
+			set_buffer_dirty(bh);
+		if (!bh->b_this_page)
+			bh->b_this_page = head;
+		bh = bh->b_this_page;
+	} while (bh != head);
+	attach_page_buffers(page, head);
+	spin_unlock(&page->mapping->private_lock);
+}
+
+/*
  * On entry, the page is fully not uptodate.
  * On exit the page is fully uptodate in the areas outside (from,to)
  */
-int nobh_prepare_write(struct page *page, unsigned from, unsigned to,
+int nobh_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata,
 			get_block_t *get_block)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
 	const unsigned blocksize = 1 << blkbits;
 	struct buffer_head *head, *bh;
+	struct page *page;
+	pgoff_t index;
+	unsigned from, to;
 	unsigned block_in_page;
 	unsigned block_start, block_end;
 	sector_t block_in_file;
@@ -2406,8 +2435,22 @@
 	int ret = 0;
 	int is_mapped_to_disk = 1;
 
-	if (page_has_buffers(page))
-		return block_prepare_write(page, from, to, get_block);
+	index = pos >> PAGE_CACHE_SHIFT;
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + len;
+
+	page = __grab_cache_page(mapping, index);
+	if (!page)
+		return -ENOMEM;
+	*pagep = page;
+	*fsdata = NULL;
+
+	if (page_has_buffers(page)) {
+		unlock_page(page);
+		page_cache_release(page);
+		*pagep = NULL;
+		return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata, get_block);
+	}
 
 	if (PageMappedToDisk(page))
 		return 0;
@@ -2422,8 +2465,10 @@
 	 * than the circular one we're used to.
 	 */
 	head = alloc_page_buffers(page, blocksize, 0);
-	if (!head)
-		return -ENOMEM;
+	if (!head) {
+		ret = -ENOMEM;
+		goto out_release;
+	}
 
 	block_in_file = (sector_t)page->index << (PAGE_CACHE_SHIFT - blkbits);
 
@@ -2492,15 +2537,12 @@
 	if (is_mapped_to_disk)
 		SetPageMappedToDisk(page);
 
-	do {
-		bh = head;
-		head = head->b_this_page;
-		free_buffer_head(bh);
-	} while (head);
+	*fsdata = head; /* to be released by nobh_write_end */
 
 	return 0;
 
 failed:
+	BUG_ON(!ret);
 	/*
 	 * Error recovery is a bit difficult. We need to zero out blocks that
 	 * were newly allocated, and dirty them to ensure they get written out.
@@ -2508,64 +2550,56 @@
 	 * the handling of potential IO errors during writeout would be hard
 	 * (could try doing synchronous writeout, but what if that fails too?)
 	 */
-	spin_lock(&page->mapping->private_lock);
-	bh = head;
-	block_start = 0;
-	do {
-		if (PageUptodate(page))
-			set_buffer_uptodate(bh);
-		if (PageDirty(page))
-			set_buffer_dirty(bh);
+	attach_nobh_buffers(page, head);
+	page_zero_new_buffers(page, from, to);
 
-		block_end = block_start+blocksize;
-		if (block_end <= from)
-			goto next;
-		if (block_start >= to)
-			goto next;
+out_release:
+	unlock_page(page);
+	page_cache_release(page);
+	*pagep = NULL;
 
-		if (buffer_new(bh)) {
-			clear_buffer_new(bh);
-			if (!buffer_uptodate(bh)) {
-				zero_user_page(page, block_start, bh->b_size, KM_USER0);
-				set_buffer_uptodate(bh);
-			}
-			mark_buffer_dirty(bh);
-		}
-next:
-		block_start = block_end;
-		if (!bh->b_this_page)
-			bh->b_this_page = head;
-		bh = bh->b_this_page;
-	} while (bh != head);
-	attach_page_buffers(page, head);
-	spin_unlock(&page->mapping->private_lock);
+	if (pos + len > inode->i_size)
+		vmtruncate(inode, inode->i_size);
 
 	return ret;
 }
-EXPORT_SYMBOL(nobh_prepare_write);
+EXPORT_SYMBOL(nobh_write_begin);
 
-/*
- * Make sure any changes to nobh_commit_write() are reflected in
- * nobh_truncate_page(), since it doesn't call commit_write().
- */
-int nobh_commit_write(struct file *file, struct page *page,
-		unsigned from, unsigned to)
+int nobh_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
 {
 	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	struct buffer_head *head = NULL;
+	struct buffer_head *bh;
 
-	if (page_has_buffers(page))
-		return generic_commit_write(file, page, from, to);
+	if (!PageMappedToDisk(page)) {
+		if (unlikely(copied < len) && !page_has_buffers(page))
+			attach_nobh_buffers(page, head);
+		if (page_has_buffers(page))
+			return generic_write_end(file, mapping, pos, len, copied, page, fsdata);
+	}
 
 	SetPageUptodate(page);
 	set_page_dirty(page);
-	if (pos > inode->i_size) {
-		i_size_write(inode, pos);
+	if (pos+copied > inode->i_size) {
+		i_size_write(inode, pos+copied);
 		mark_inode_dirty(inode);
 	}
-	return 0;
+
+	unlock_page(page);
+	page_cache_release(page);
+
+	head = fsdata;
+	while (head) {
+		bh = head;
+		head = head->b_this_page;
+		free_buffer_head(bh);
+	}
+
+	return copied;
 }
-EXPORT_SYMBOL(nobh_commit_write);
+EXPORT_SYMBOL(nobh_write_end);
 
 /*
  * nobh_writepage() - based on block_full_write_page() except
@@ -2618,44 +2652,79 @@
 }
 EXPORT_SYMBOL(nobh_writepage);
 
-/*
- * This function assumes that ->prepare_write() uses nobh_prepare_write().
- */
-int nobh_truncate_page(struct address_space *mapping, loff_t from)
+int nobh_truncate_page(struct address_space *mapping,
+			loff_t from, get_block_t *get_block)
 {
-	struct inode *inode = mapping->host;
-	unsigned blocksize = 1 << inode->i_blkbits;
 	pgoff_t index = from >> PAGE_CACHE_SHIFT;
 	unsigned offset = from & (PAGE_CACHE_SIZE-1);
-	unsigned to;
+	unsigned blocksize;
+	sector_t iblock;
+	unsigned length, pos;
+	struct inode *inode = mapping->host;
 	struct page *page;
-	const struct address_space_operations *a_ops = mapping->a_ops;
-	int ret = 0;
+	struct buffer_head map_bh;
+	int err;
 
-	if ((offset & (blocksize - 1)) == 0)
-		goto out;
+	blocksize = 1 << inode->i_blkbits;
+	length = offset & (blocksize - 1);
+
+	/* Block boundary? Nothing to do */
+	if (!length)
+		return 0;
+
+	length = blocksize - length;
+	iblock = (sector_t)index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
 
-	ret = -ENOMEM;
 	page = grab_cache_page(mapping, index);
+	err = -ENOMEM;
 	if (!page)
 		goto out;
 
-	to = (offset + blocksize) & ~(blocksize - 1);
-	ret = a_ops->prepare_write(NULL, page, offset, to);
-	if (ret == 0) {
-		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset,
-				KM_USER0);
-		/*
-		 * It would be more correct to call aops->commit_write()
-		 * here, but this is more efficient.
-		 */
-		SetPageUptodate(page);
-		set_page_dirty(page);
+	if (page_has_buffers(page)) {
+has_buffers:
+		unlock_page(page);
+		page_cache_release(page);
+		return block_truncate_page(mapping, from, get_block);
+	}
+
+	/* Find the buffer that contains "offset" */
+	pos = blocksize;
+	while (offset >= pos) {
+		iblock++;
+		pos += blocksize;
 	}
+
+	err = get_block(inode, iblock, &map_bh, 0);
+	if (err)
+		goto unlock;
+	/* unmapped? It's a hole - nothing to do */
+	if (!buffer_mapped(&map_bh))
+		goto unlock;
+
+	/* Ok, it's mapped. Make sure it's up-to-date */
+	if (!PageUptodate(page)) {
+		err = mapping->a_ops->readpage(NULL, page);
+		if (err) {
+			page_cache_release(page);
+			goto out;
+		}
+		lock_page(page);
+		if (!PageUptodate(page)) {
+			err = -EIO;
+			goto unlock;
+		}
+		if (page_has_buffers(page))
+			goto has_buffers;
+	}
+	zero_user_page(page, offset, length, KM_USER0);
+	set_page_dirty(page);
+	err = 0;
+
+unlock:
 	unlock_page(page);
 	page_cache_release(page);
 out:
-	return ret;
+	return err;
 }
 EXPORT_SYMBOL(nobh_truncate_page);
 
Index: linux-2.6/fs/ext2/inode.c
===================================================================
--- linux-2.6.orig/fs/ext2/inode.c	2007-10-08 14:14:13.000000000 +1000
+++ linux-2.6/fs/ext2/inode.c	2007-10-08 15:00:37.000000000 +1000
@@ -743,6 +743,20 @@
 	return __ext2_write_begin(file, mapping, pos, len, flags, pagep,fsdata);
 }
 
+static int
+ext2_nobh_write_begin(struct file *file, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned flags,
+		struct page **pagep, void **fsdata)
+{
+	/*
+	 * Dir-in-pagecache still uses ext2_write_begin. Would have to rework
+	 * directory handling code to pass around offsets rather than struct
+	 * pages in order to make this work easily.
+	 */
+	return nobh_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+							ext2_get_block);
+}
+
 static int ext2_nobh_writepage(struct page *page,
 			struct writeback_control *wbc)
 {
@@ -794,7 +808,8 @@
 	.readpages		= ext2_readpages,
 	.writepage		= ext2_nobh_writepage,
 	.sync_page		= block_sync_page,
-	/* XXX: todo */
+	.write_begin		= ext2_nobh_write_begin,
+	.write_end		= nobh_write_end,
 	.bmap			= ext2_bmap,
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
@@ -1010,7 +1025,8 @@
 	if (mapping_is_xip(inode->i_mapping))
 		xip_truncate_page(inode->i_mapping, inode->i_size);
 	else if (test_opt(inode->i_sb, NOBH))
-		nobh_truncate_page(inode->i_mapping, inode->i_size);
+		nobh_truncate_page(inode->i_mapping,
+				inode->i_size, ext2_get_block);
 	else
 		block_truncate_page(inode->i_mapping,
 				inode->i_size, ext2_get_block);
Index: linux-2.6/fs/jfs/inode.c
===================================================================
--- linux-2.6.orig/fs/jfs/inode.c	2007-10-08 14:09:35.000000000 +1000
+++ linux-2.6/fs/jfs/inode.c	2007-10-08 15:01:37.000000000 +1000
@@ -279,8 +279,7 @@
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)
 {
-	*pagep = NULL;
-	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+	return nobh_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 				jfs_get_block);
 }
 
@@ -306,7 +305,7 @@
 	.writepages	= jfs_writepages,
 	.sync_page	= block_sync_page,
 	.write_begin	= jfs_write_begin,
-	.write_end	= generic_write_end,
+	.write_end	= nobh_write_end,
 	.bmap		= jfs_bmap,
 	.direct_IO	= jfs_direct_IO,
 };
@@ -359,7 +358,7 @@
 {
 	jfs_info("jfs_truncate: size = 0x%lx", (ulong) ip->i_size);
 
-	block_truncate_page(ip->i_mapping, ip->i_size, jfs_get_block);
+	nobh_truncate_page(ip->i_mapping, ip->i_size, jfs_get_block);
 
 	IWRITE_LOCK(ip, RDWRLOCK_NORMAL);
 	jfs_truncate_nolock(ip, ip->i_size);
Index: linux-2.6/include/linux/buffer_head.h
===================================================================
--- linux-2.6.orig/include/linux/buffer_head.h	2007-10-08 14:09:35.000000000 +1000
+++ linux-2.6/include/linux/buffer_head.h	2007-10-08 15:00:00.000000000 +1000
@@ -226,9 +226,13 @@
 int generic_commit_write(struct file *, struct page *, unsigned, unsigned);
 int block_truncate_page(struct address_space *, loff_t, get_block_t *);
 int file_fsync(struct file *, struct dentry *, int);
-int nobh_prepare_write(struct page*, unsigned, unsigned, get_block_t*);
-int nobh_commit_write(struct file *, struct page *, unsigned, unsigned);
-int nobh_truncate_page(struct address_space *, loff_t);
+int nobh_write_begin(struct file *, struct address_space *,
+				loff_t, unsigned, unsigned,
+				struct page **, void **, get_block_t*);
+int nobh_write_end(struct file *, struct address_space *,
+				loff_t, unsigned, unsigned,
+				struct page *, void *);
+int nobh_truncate_page(struct address_space *, loff_t, get_block_t *);
 int nobh_writepage(struct page *page, get_block_t *get_block,
                         struct writeback_control *wbc);
 
