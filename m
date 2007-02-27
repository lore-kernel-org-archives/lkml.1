Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbXB0XUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbXB0XUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbXB0XSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:18:12 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:51120 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbXB0XSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:18:05 -0500
Message-Id: <20070227231705.094358171@szeredi.hu>
References: <20070227231442.627972152@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 28 Feb 2007 00:14:58 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 16/22] fuse: add fuse_writepage() function
Content-Disposition: inline; filename=fuse_writepage.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Implement the ->writepage address space operation.  Be careful not to
block if the wbc->nonblocking flag is set.

Acquire the read-write truncation semaphore for read when allocating
the request.  Use the _non_owner variants, since the semaphore is held
until the asynchronous request is completed.

When allocating the request, use GFP_NOFS, since there's a danger of
recursion via direct page reclaim.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dev.c
===================================================================
--- linux.orig/fs/fuse/dev.c	2007-02-27 14:41:10.000000000 +0100
+++ linux/fs/fuse/dev.c	2007-02-27 14:41:12.000000000 +0100
@@ -41,7 +41,7 @@ static void fuse_request_init(struct fus
 
 struct fuse_req *fuse_request_alloc(void)
 {
-	struct fuse_req *req = kmem_cache_alloc(fuse_req_cachep, GFP_KERNEL);
+	struct fuse_req *req = kmem_cache_alloc(fuse_req_cachep, GFP_NOFS);
 	if (req)
 		fuse_request_init(req);
 	return req;
Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-02-27 14:41:11.000000000 +0100
+++ linux/fs/fuse/file.c	2007-02-27 14:41:12.000000000 +0100
@@ -11,6 +11,7 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
+#include <linux/writeback.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
@@ -644,6 +645,125 @@ static ssize_t fuse_direct_write(struct 
 	return res;
 }
 
+static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
+{
+	struct address_space *mapping = req->pages[0]->mapping;
+	struct fuse_inode *fi = get_fuse_inode(mapping->host);
+	int err = req->out.h.error;
+	if (!err && req->misc.write.out.size != req->misc.write.in.size)
+		err = -EIO;
+	mapping_set_error(mapping, err);
+	end_page_writeback(req->pages[0]);
+	up_read_non_owner(&fi->truncate_sem);
+	fuse_file_put(req->ff);
+	fuse_put_request(fc, req);
+}
+
+static struct fuse_req *fuse_get_req_wp(struct inode *inode,
+					struct writeback_control *wbc,
+					int *blocked)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_req *req;
+
+	*blocked = 0;
+	if (wbc->nonblocking && fc->blocked)
+		goto blocked;
+
+	atomic_inc(&fc->num_waiting);
+	if (!wbc->nonblocking)
+		wait_event(fc->blocked_waitq, !fc->blocked);
+
+	req = fuse_request_alloc();
+	if (!req) {
+		atomic_dec(&fc->num_waiting);
+		return NULL;
+	}
+	req->waiting = 1;
+
+	if (!wbc->nonblocking)
+		down_read_non_owner(&fi->truncate_sem);
+	else if (!down_read_trylock_non_owner(&fi->truncate_sem)) {
+		fuse_put_request(fc, req);
+		goto blocked;
+	}
+	spin_lock(&fc->lock);
+	BUG_ON(list_empty(&fi->write_files));
+	req->ff = fuse_file_get(list_entry(fi->write_files.next,
+					   struct fuse_file, write_entry));
+	spin_unlock(&fc->lock);
+	return req;
+
+ blocked:
+	*blocked = 1;
+	return NULL;
+}
+
+static int fuse_writepage_locked(struct page *page,
+				 struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_req *req;
+	size_t count;
+	loff_t size;
+	unsigned long end_index;
+	int blocked;
+
+	req = fuse_get_req_wp(inode, wbc, &blocked);
+	if (!req) {
+		if (!blocked)
+			return -ENOMEM;
+		redirty_page_for_writepage(wbc, page);
+		return 0;
+	}
+
+	size = i_size_read(inode);
+	end_index = size >> PAGE_CACHE_SHIFT;
+
+	if (page->index < end_index)
+		count = PAGE_CACHE_SIZE;
+	else if (page->index == end_index)
+		count = size & (PAGE_CACHE_SIZE - 1);
+	else {
+		/*
+		 * It is possible that while waiting for the
+		 * truncation semaphore, the file was truncated.
+		 */
+		fuse_put_request(fc, req);
+		return 0;
+	}
+
+	req->num_pages = 1;
+	req->pages[0] = page;
+	req->page_offset = 0;
+	req->end = fuse_writepage_end;
+	fuse_write_fill(req, req->ff, inode, page_offset(page), count, 1);
+	set_page_writeback(page);
+	request_send_background(fc, req);
+	return 0;
+}
+
+static int fuse_writepage(struct page *page, struct writeback_control *wbc)
+{
+	int err = fuse_writepage_locked(page, wbc);
+	unlock_page(page);
+	return err;
+}
+
+static int fuse_launder_page(struct page *page)
+{
+	int err = 0;
+	if (clear_page_dirty_for_io(page)) {
+		struct writeback_control wbc = { .nonblocking = 0 };
+		err = fuse_writepage_locked(page, &wbc);
+		if (!err)
+			wait_on_page_writeback(page);
+	}
+	return err;
+}
+
 static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	if ((vma->vm_flags & VM_SHARED)) {
@@ -847,6 +967,8 @@ static const struct file_operations fuse
 
 static const struct address_space_operations fuse_file_aops  = {
 	.readpage	= fuse_readpage,
+	.writepage	= fuse_writepage,
+	.launder_page	= fuse_launder_page,
 	.prepare_write	= fuse_prepare_write,
 	.commit_write	= fuse_commit_write,
 	.readpages	= fuse_readpages,

--
