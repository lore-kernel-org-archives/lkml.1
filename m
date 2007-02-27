Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbXB0XUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbXB0XUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXB0XSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:18:08 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:54941 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbXB0XSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:18:05 -0500
Message-Id: <20070227231721.680015005@szeredi.hu>
References: <20070227231442.627972152@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 28 Feb 2007 00:15:00 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 18/22] fuse: add fuse_writepages() function
Content-Disposition: inline; filename=fuse_writepages.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Implement the ->writepages address space operation.  This is very
similar to fuse_writepage(), but batches multiple pages into a single
request.

It reuses the fuse_fill_data structure currently used by
fuse_readpages().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-02-27 14:41:12.000000000 +0100
+++ linux/fs/fuse/file.c	2007-02-27 14:41:12.000000000 +0100
@@ -650,15 +650,17 @@ static ssize_t fuse_direct_write(struct 
 	return res;
 }
 
-static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
+static void fuse_writepages_end(struct fuse_conn *fc, struct fuse_req *req)
 {
+	int i;
 	struct address_space *mapping = req->pages[0]->mapping;
 	struct fuse_inode *fi = get_fuse_inode(mapping->host);
 	int err = req->out.h.error;
 	if (!err && req->misc.write.out.size != req->misc.write.in.size)
 		err = -EIO;
 	mapping_set_error(mapping, err);
-	end_page_writeback(req->pages[0]);
+	for (i = 0; i < req->num_pages; i++)
+		end_page_writeback(req->pages[i]);
 	up_read_non_owner(&fi->truncate_sem);
 	fuse_file_put(req->ff);
 	fuse_put_request(fc, req);
@@ -743,7 +745,7 @@ static int fuse_writepage_locked(struct 
 	req->num_pages = 1;
 	req->pages[0] = page;
 	req->page_offset = 0;
-	req->end = fuse_writepage_end;
+	req->end = fuse_writepages_end;
 	fuse_write_fill(req, req->ff, inode, page_offset(page), count, 1);
 	set_page_writeback(page);
 	request_send_background(fc, req);
@@ -784,6 +786,80 @@ static struct vm_operations_struct fuse_
 	.populate	= filemap_populate,
 };
 
+static void fuse_send_writepages(struct fuse_req *req, struct inode *inode)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	loff_t pos = page_offset(req->pages[0]);
+	loff_t size = i_size_read(inode);
+
+	/* File truncated from under us? */
+	if (size <= pos)
+		fuse_writepages_end(fc, req);
+	else {
+		size_t count = req->num_pages << PAGE_CACHE_SHIFT;
+		if (pos + count > size)
+			count = size - pos;
+		fuse_write_fill(req, req->ff, inode, pos, count, 1);
+		req->end = fuse_writepages_end;
+		request_send_background(fc, req);
+	}
+}
+
+static int fuse_writepages_fill(struct page *page,
+				struct writeback_control *wbc, void *_data)
+{
+	struct fuse_fill_data *data = _data;
+	struct fuse_req *req = data->req;
+	struct inode *inode = data->inode;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+
+	if (req &&
+	    (req->num_pages == FUSE_MAX_PAGES_PER_REQ ||
+	     (req->num_pages + 1) * PAGE_CACHE_SIZE > fc->max_write ||
+	     req->pages[req->num_pages - 1]->index + 1 != page->index)) {
+		fuse_send_writepages(req, inode);
+		req = NULL;
+	}
+	if (!req) {
+		int blocked;
+		data->req = req = fuse_get_req_wp(inode, wbc, &blocked);
+		if (!req) {
+			int err = 0;
+			if (blocked)
+				redirty_page_for_writepage(wbc, page);
+			else
+				err = -ENOMEM;
+			unlock_page(page);
+			return err;
+		}
+	}
+	req->pages[req->num_pages] = page;
+	req->num_pages ++;
+	set_page_writeback(page);
+	unlock_page(page);
+	return 0;
+}
+
+static int fuse_writepages(struct address_space *mapping,
+			   struct writeback_control *wbc)
+{
+	struct inode *inode = mapping->host;
+	struct fuse_fill_data data;
+	int err;
+
+	if (is_bad_inode(inode))
+		return -EIO;
+
+	data.inode = inode;
+	data.req = NULL;
+
+	err = write_cache_pages(mapping, wbc, fuse_writepages_fill, &data);
+	if (data.req)
+		fuse_send_writepages(data.req, inode);
+
+	return err;
+}
+
 static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE)) {
@@ -995,6 +1071,7 @@ static const struct address_space_operat
 	.prepare_write	= fuse_prepare_write,
 	.commit_write	= fuse_commit_write,
 	.readpages	= fuse_readpages,
+	.writepages	= fuse_writepages,
 	.set_page_dirty	= __set_page_dirty_nobuffers,
 	.bmap		= fuse_bmap,
 };

--
