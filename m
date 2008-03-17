Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYCQTWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYCQTWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbYCQTUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:20:06 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34060 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544AbYCQTTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:19:54 -0400
Message-Id: <20080317191950.770786911@szeredi.hu>
References: <20080317191908.123631326@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 17 Mar 2008 20:19:16 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [patch 8/8] fuse: update file size on short read
Content-Disposition: inline; filename=fuse_truncate_file_on_short_read.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If the READ request returned a short count, then either

  - cached size is incorrect
  - filesystem is buggy, as short reads are only allowed on EOF

So assume, that the size is wrong and refresh it, so that cached
read() doesn't zero fill the missing chunk.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/file.c |   42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2008-03-17 18:26:43.000000000 +0100
+++ linux/fs/fuse/file.c	2008-03-17 18:27:11.000000000 +0100
@@ -398,11 +398,26 @@ static size_t fuse_send_read(struct fuse
 	return req->out.args[0].size;
 }
 
+static void fuse_read_update_size(struct inode *inode, loff_t size)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+
+	spin_lock(&fc->lock);
+	fi->attr_version = ++fc->attr_version;
+	if (size < inode->i_size)
+		i_size_write(inode, size);
+	spin_unlock(&fc->lock);
+}
+
 static int fuse_readpage(struct file *file, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_req *req;
+	size_t num_read;
+	loff_t pos = page_offset(page);
+	size_t count = PAGE_CACHE_SIZE;
 	int err;
 
 	err = -EIO;
@@ -424,12 +439,20 @@ static int fuse_readpage(struct file *fi
 	req->out.page_zeroing = 1;
 	req->num_pages = 1;
 	req->pages[0] = page;
-	fuse_send_read(req, file, inode, page_offset(page), PAGE_CACHE_SIZE,
-		       NULL);
+	num_read = fuse_send_read(req, file, inode, pos, count, NULL);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
-	if (!err)
+
+	if (!err) {
+		/*
+		 * Short read means EOF.  If file size is larger, truncate it
+		 */
+		if (num_read < count)
+			fuse_read_update_size(inode, pos + num_read);
+
 		SetPageUptodate(page);
+	}
+
 	fuse_invalidate_attr(inode); /* atime changed */
  out:
 	unlock_page(page);
@@ -439,8 +462,19 @@ static int fuse_readpage(struct file *fi
 static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
 {
 	int i;
+	size_t count = req->misc.read_in.size;
+	size_t num_read = req->out.args[0].size;
+	struct inode *inode = req->pages[0]->mapping->host;
 
-	fuse_invalidate_attr(req->pages[0]->mapping->host); /* atime changed */
+	/*
+	 * Short read means EOF.  If file size is larger, truncate it
+	 */
+	if (!req->out.h.error && num_read < count) {
+		loff_t pos = page_offset(req->pages[0]) + num_read;
+		fuse_read_update_size(inode, pos);
+	}
+
+	fuse_invalidate_attr(inode); /* atime changed */
 
 	for (i = 0; i < req->num_pages; i++) {
 		struct page *page = req->pages[i];

--
