Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbYDYR7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbYDYR7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 13:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932090AbYDYR5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:08 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55836 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764465AbYDYR5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:57:02 -0400
Message-Id: <20080425175658.985145221@szeredi.hu>
References: <20080425175520.735386844@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 25 Apr 2008 19:55:24 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 4/5] fuse: fix truncation on short read
Content-Disposition: inline; filename=fuse_truncate_file_on_short_read_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

fuse-update-file-size-on-short-read.patch introduced a bug, where a
read could truncate off the part recently extended by a parallel
write.

Fix by using the attribute versioning already used by getattr().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/dir.c    |    2 +-
 fs/fuse/file.c   |   22 ++++++++++++++--------
 fs/fuse/fuse_i.h |    7 ++++++-
 3 files changed, 21 insertions(+), 10 deletions(-)

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2008-04-25 17:10:02.000000000 +0200
+++ linux/fs/fuse/dir.c	2008-04-25 17:11:02.000000000 +0200
@@ -132,7 +132,7 @@ static void fuse_lookup_init(struct fuse
 	req->out.args[0].value = outarg;
 }
 
-static u64 fuse_get_attr_version(struct fuse_conn *fc)
+u64 fuse_get_attr_version(struct fuse_conn *fc)
 {
 	u64 curr_version;
 
Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2008-04-25 17:10:47.000000000 +0200
+++ linux/fs/fuse/file.c	2008-04-25 17:11:02.000000000 +0200
@@ -363,7 +363,7 @@ static int fuse_fsync(struct file *file,
 void fuse_read_fill(struct fuse_req *req, struct file *file,
 		    struct inode *inode, loff_t pos, size_t count, int opcode)
 {
-	struct fuse_read_in *inarg = &req->misc.read_in;
+	struct fuse_read_in *inarg = &req->misc.read.in;
 	struct fuse_file *ff = file->private_data;
 
 	inarg->fh = ff->fh;
@@ -389,7 +389,7 @@ static size_t fuse_send_read(struct fuse
 
 	fuse_read_fill(req, file, inode, pos, count, FUSE_READ);
 	if (owner != NULL) {
-		struct fuse_read_in *inarg = &req->misc.read_in;
+		struct fuse_read_in *inarg = &req->misc.read.in;
 
 		inarg->read_flags |= FUSE_READ_LOCKOWNER;
 		inarg->lock_owner = fuse_lock_owner_id(fc, owner);
@@ -398,15 +398,17 @@ static size_t fuse_send_read(struct fuse
 	return req->out.args[0].size;
 }
 
-static void fuse_read_update_size(struct inode *inode, loff_t size)
+static void fuse_read_update_size(struct inode *inode, loff_t size,
+				  u64 attr_ver)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	spin_lock(&fc->lock);
-	fi->attr_version = ++fc->attr_version;
-	if (size < inode->i_size)
+	if (attr_ver == fi->attr_version && size < inode->i_size) {
+		fi->attr_version = ++fc->attr_version;
 		i_size_write(inode, size);
+	}
 	spin_unlock(&fc->lock);
 }
 
@@ -418,6 +420,7 @@ static int fuse_readpage(struct file *fi
 	size_t num_read;
 	loff_t pos = page_offset(page);
 	size_t count = PAGE_CACHE_SIZE;
+	u64 attr_ver;
 	int err;
 
 	err = -EIO;
@@ -436,6 +439,8 @@ static int fuse_readpage(struct file *fi
 	if (IS_ERR(req))
 		goto out;
 
+	attr_ver = fuse_get_attr_version(fc);
+
 	req->out.page_zeroing = 1;
 	req->num_pages = 1;
 	req->pages[0] = page;
@@ -448,7 +453,7 @@ static int fuse_readpage(struct file *fi
 		 * Short read means EOF.  If file size is larger, truncate it
 		 */
 		if (num_read < count)
-			fuse_read_update_size(inode, pos + num_read);
+			fuse_read_update_size(inode, pos + num_read, attr_ver);
 
 		SetPageUptodate(page);
 	}
@@ -462,7 +467,7 @@ static int fuse_readpage(struct file *fi
 static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
 {
 	int i;
-	size_t count = req->misc.read_in.size;
+	size_t count = req->misc.read.in.size;
 	size_t num_read = req->out.args[0].size;
 	struct inode *inode = req->pages[0]->mapping->host;
 
@@ -471,7 +476,7 @@ static void fuse_readpages_end(struct fu
 	 */
 	if (!req->out.h.error && num_read < count) {
 		loff_t pos = page_offset(req->pages[0]) + num_read;
-		fuse_read_update_size(inode, pos);
+		fuse_read_update_size(inode, pos, req->misc.read.attr_ver);
 	}
 
 	fuse_invalidate_attr(inode); /* atime changed */
@@ -497,6 +502,7 @@ static void fuse_send_readpages(struct f
 	size_t count = req->num_pages << PAGE_CACHE_SHIFT;
 	req->out.page_zeroing = 1;
 	fuse_read_fill(req, file, inode, pos, count, FUSE_READ);
+	req->misc.read.attr_ver = fuse_get_attr_version(fc);
 	if (fc->async_read) {
 		struct fuse_file *ff = file->private_data;
 		req->ff = fuse_file_get(ff);
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2008-04-25 17:09:29.000000000 +0200
+++ linux/fs/fuse/fuse_i.h	2008-04-25 17:11:02.000000000 +0200
@@ -239,7 +239,10 @@ struct fuse_req {
 		} release;
 		struct fuse_init_in init_in;
 		struct fuse_init_out init_out;
-		struct fuse_read_in read_in;
+		struct {
+			struct fuse_read_in in;
+			u64 attr_ver;
+		} read;
 		struct {
 			struct fuse_write_in in;
 			struct fuse_write_out out;
@@ -637,3 +640,5 @@ void fuse_flush_writepages(struct inode 
 
 void fuse_set_nowrite(struct inode *inode);
 void fuse_release_nowrite(struct inode *inode);
+
+u64 fuse_get_attr_version(struct fuse_conn *fc);

--
