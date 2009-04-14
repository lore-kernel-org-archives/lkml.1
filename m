Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbZDNB44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbZDNB44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 21:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZDNB4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 21:56:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:56156 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbZDNB4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 21:56:43 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] FUSE: make ff->fi optional
Date: Tue, 14 Apr 2009 10:54:51 +0900
Message-Id: <1239674094-30894-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239674094-30894-1-git-send-email-tj@kernel.org>
References: <1239674094-30894-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 01:55:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow ff->fi to be NULL.  fi related operations are skipped if ff->fi
is unavailable and nodeid is assumed to be zero.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/file.c   |   58 +++++++++++++++++++++++++++++++++++++----------------
 fs/fuse/fuse_i.h |    2 +-
 2 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index f32d2c8..54ad406 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -339,7 +339,8 @@ int fuse_fsync_common(struct fuse_file *ff, int datasync, int isdir)
 	if (err)
 		return err;
 
-	fuse_sync_writes(ff->fi);
+	if (ff->fi)
+		fuse_sync_writes(ff->fi);
 
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
@@ -413,6 +414,9 @@ static void fuse_read_update_size(struct fuse_file *ff, loff_t size,
 	struct fuse_conn *fc = ff->fc;
 	struct fuse_inode *fi = ff->fi;
 
+	if (!fi)
+		return;
+
 	spin_lock(&fc->lock);
 	if (attr_ver == fi->attr_version && size < fi->inode.i_size) {
 		fi->attr_version = ++fc->attr_version;
@@ -441,7 +445,8 @@ static int fuse_readpage(struct file *file, struct page *page)
 	 * page-cache page, so make sure we read a properly synced
 	 * page.
 	 */
-	fuse_wait_on_page_writeback(ff->fi, page->index);
+	if (ff->fi)
+		fuse_wait_on_page_writeback(ff->fi, page->index);
 
 	req = fuse_get_req(fc);
 	err = PTR_ERR(req);
@@ -468,7 +473,8 @@ static int fuse_readpage(struct file *file, struct page *page)
 		SetPageUptodate(page);
 	}
 
-	fuse_invalidate_attr(ff->fi); /* atime changed */
+	if (ff->fi)
+		fuse_invalidate_attr(ff->fi); /* atime changed */
  out:
 	unlock_page(page);
 	return err;
@@ -489,7 +495,8 @@ static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
 		fuse_read_update_size(ff, pos, req->misc.read.attr_ver);
 	}
 
-	fuse_invalidate_attr(ff->fi); /* atime changed */
+	if (ff->fi)
+		fuse_invalidate_attr(ff->fi); /* atime changed */
 
 	for (i = 0; i < req->num_pages; i++) {
 		struct page *page = req->pages[i];
@@ -534,7 +541,8 @@ static int fuse_readpages_fill(void *data, struct page *page)
 	struct fuse_file *ff = req->ff;
 	struct fuse_conn *fc = ff->fc;
 
-	fuse_wait_on_page_writeback(ff->fi, page->index);
+	if (ff->fi)
+		fuse_wait_on_page_writeback(ff->fi, page->index);
 
 	if (req->num_pages &&
 	    (req->num_pages == FUSE_MAX_PAGES_PER_REQ ||
@@ -587,7 +595,7 @@ static ssize_t fuse_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	struct fuse_file *ff = iocb->ki_filp->private_data;
 	struct fuse_inode *fi = ff->fi;
 
-	if (pos + iov_length(iov, nr_segs) > i_size_read(&fi->inode)) {
+	if (fi && pos + iov_length(iov, nr_segs) > i_size_read(&fi->inode)) {
 		int err;
 		/*
 		 * If trying to read past EOF, make sure the i_size
@@ -661,6 +669,9 @@ static void fuse_write_update_size(struct fuse_file *ff, loff_t pos)
 	struct fuse_conn *fc = ff->fc;
 	struct fuse_inode *fi = ff->fi;
 
+	if (!fi)
+		return;
+
 	spin_lock(&fc->lock);
 	fi->attr_version = ++fc->attr_version;
 	if (pos > fi->inode.i_size)
@@ -684,7 +695,8 @@ static int fuse_buffered_write(struct fuse_file *ff, loff_t pos, unsigned count,
 	 * Make sure writepages on the same page are not mixed up with
 	 * plain writes.
 	 */
-	fuse_wait_on_page_writeback(ff->fi, page->index);
+	if (ff->fi)
+		fuse_wait_on_page_writeback(ff->fi, page->index);
 
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
@@ -705,7 +717,8 @@ static int fuse_buffered_write(struct fuse_file *ff, loff_t pos, unsigned count,
 		if (count == PAGE_CACHE_SIZE)
 			SetPageUptodate(page);
 	}
-	fuse_invalidate_attr(ff->fi);
+	if (ff->fi)
+		fuse_invalidate_attr(ff->fi);
 	return err ? err : nres;
 }
 
@@ -731,8 +744,10 @@ static size_t fuse_send_write_pages(struct fuse_req *req, struct fuse_file *ff,
 	unsigned offset;
 	unsigned i;
 
-	for (i = 0; i < req->num_pages; i++)
-		fuse_wait_on_page_writeback(ff->fi, req->pages[i]->index);
+	if (ff->fi)
+		for (i = 0; i < req->num_pages; i++)
+			fuse_wait_on_page_writeback(ff->fi,
+						    req->pages[i]->index);
 
 	res = fuse_send_write(req, ff, pos, count, NULL);
 
@@ -863,7 +878,8 @@ static ssize_t fuse_perform_write(struct fuse_file *ff, struct iov_iter *ii,
 	if (res > 0)
 		fuse_write_update_size(ff, pos);
 
-	fuse_invalidate_attr(ff->fi);
+	if (ff->fi)
+		fuse_invalidate_attr(ff->fi);
 
 	return res > 0 ? res : err;
 }
@@ -1030,7 +1046,8 @@ static ssize_t fuse_direct_io(struct fuse_file *ff, const char __user *buf,
 			fuse_write_update_size(ff, pos);
 		*ppos = pos;
 	}
-	fuse_invalidate_attr(ff->fi);
+	if (ff->fi)
+		fuse_invalidate_attr(ff->fi);
 
 	return res;
 }
@@ -1266,9 +1283,11 @@ static struct vm_operations_struct fuse_file_vm_ops = {
 
 static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE)) {
-		struct fuse_file *ff = file->private_data;
-		struct fuse_conn *fc = ff->fc;
+	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = ff->fc;
+
+	if (ff->fi &&
+	    (vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE)) {
 		/*
 		 * file may be written through mmap, so chain it onto the
 		 * inodes's write_file list
@@ -1479,9 +1498,12 @@ static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
 	mutex_lock(&vfs_inode->i_mutex);
 	switch (origin) {
 	case SEEK_END:
-		retval = fuse_update_attributes(ff->fi, NULL, file, NULL);
-		if (retval)
-			goto exit;
+		if (ff->fi) {
+			retval = fuse_update_attributes(ff->fi, NULL, file,
+							NULL);
+			if (retval)
+				goto exit;
+		}
 		offset += i_size_read(vfs_inode);
 		break;
 	case SEEK_CUR:
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index c9ffaa0..016a745 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -501,7 +501,7 @@ static inline u64 get_node_id(struct inode *inode)
 
 static inline u64 fuse_file_nodeid(struct fuse_file *ff)
 {
-	return ff->fi->nodeid;
+	return ff->fi ? ff->fi->nodeid : 0;
 }
 
 static inline struct inode *fuse_file_vfs_inode(struct fuse_file *ff)
-- 
1.6.0.2

