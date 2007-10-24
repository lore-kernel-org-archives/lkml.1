Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbXJXLPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbXJXLPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbXJXLOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:14:40 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:39003 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbXJXLOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:14:38 -0400
Message-Id: <20071024111429.379670237@szeredi.hu>
References: <20071024111333.530227696@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 24 Oct 2007 13:13:37 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 4/5] fuse: pass open flags to read and write
Content-Disposition: inline; filename=fuse_file_flags.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Some open flags (O_APPEND, O_DIRECT) can be changed with
fcntl(F_SETFL, ...) after open, but fuse currently only sends the
flags to userspace in open.

To make it possible to correcly handle changing flags, send the
current value to userspace in each read and write.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-10-19 19:58:08.000000000 +0200
+++ linux/fs/fuse/file.c	2007-10-19 20:20:59.000000000 +0200
@@ -289,14 +289,16 @@ static int fuse_fsync(struct file *file,
 	return fuse_fsync_common(file, de, datasync, 0);
 }
 
-void fuse_read_fill(struct fuse_req *req, struct fuse_file *ff,
+void fuse_read_fill(struct fuse_req *req, struct file *file,
 		    struct inode *inode, loff_t pos, size_t count, int opcode)
 {
 	struct fuse_read_in *inarg = &req->misc.read_in;
+	struct fuse_file *ff = file->private_data;
 
 	inarg->fh = ff->fh;
 	inarg->offset = pos;
 	inarg->size = count;
+	inarg->flags = file->f_flags;
 	req->in.h.opcode = opcode;
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.numargs = 1;
@@ -313,9 +315,8 @@ static size_t fuse_send_read(struct fuse
 			     fl_owner_t owner)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_file *ff = file->private_data;
 
-	fuse_read_fill(req, ff, inode, pos, count, FUSE_READ);
+	fuse_read_fill(req, file, inode, pos, count, FUSE_READ);
 	if (owner != NULL) {
 		struct fuse_read_in *inarg = &req->misc.read_in;
 
@@ -376,15 +377,16 @@ static void fuse_readpages_end(struct fu
 	fuse_put_request(fc, req);
 }
 
-static void fuse_send_readpages(struct fuse_req *req, struct fuse_file *ff,
+static void fuse_send_readpages(struct fuse_req *req, struct file *file,
 				struct inode *inode)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	loff_t pos = page_offset(req->pages[0]);
 	size_t count = req->num_pages << PAGE_CACHE_SHIFT;
 	req->out.page_zeroing = 1;
-	fuse_read_fill(req, ff, inode, pos, count, FUSE_READ);
+	fuse_read_fill(req, file, inode, pos, count, FUSE_READ);
 	if (fc->async_read) {
+		struct fuse_file *ff = file->private_data;
 		req->ff = fuse_file_get(ff);
 		req->end = fuse_readpages_end;
 		request_send_background(fc, req);
@@ -396,7 +398,7 @@ static void fuse_send_readpages(struct f
 
 struct fuse_fill_data {
 	struct fuse_req *req;
-	struct fuse_file *ff;
+	struct file *file;
 	struct inode *inode;
 };
 
@@ -411,7 +413,7 @@ static int fuse_readpages_fill(void *_da
 	    (req->num_pages == FUSE_MAX_PAGES_PER_REQ ||
 	     (req->num_pages + 1) * PAGE_CACHE_SIZE > fc->max_read ||
 	     req->pages[req->num_pages - 1]->index + 1 != page->index)) {
-		fuse_send_readpages(req, data->ff, inode);
+		fuse_send_readpages(req, data->file, inode);
 		data->req = req = fuse_get_req(fc);
 		if (IS_ERR(req)) {
 			unlock_page(page);
@@ -435,7 +437,7 @@ static int fuse_readpages(struct file *f
 	if (is_bad_inode(inode))
 		goto out;
 
-	data.ff = file->private_data;
+	data.file = file;
 	data.inode = inode;
 	data.req = fuse_get_req(fc);
 	err = PTR_ERR(data.req);
@@ -445,7 +447,7 @@ static int fuse_readpages(struct file *f
 	err = read_cache_pages(mapping, pages, fuse_readpages_fill, &data);
 	if (!err) {
 		if (data.req->num_pages)
-			fuse_send_readpages(data.req, data.ff, inode);
+			fuse_send_readpages(data.req, file, inode);
 		else
 			fuse_put_request(fc, data.req);
 	}
@@ -472,11 +474,12 @@ static ssize_t fuse_file_aio_read(struct
 	return generic_file_aio_read(iocb, iov, nr_segs, pos);
 }
 
-static void fuse_write_fill(struct fuse_req *req, struct fuse_file *ff,
+static void fuse_write_fill(struct fuse_req *req, struct file *file,
 			    struct inode *inode, loff_t pos, size_t count,
 			    int writepage)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_file *ff = file->private_data;
 	struct fuse_write_in *inarg = &req->misc.write.in;
 	struct fuse_write_out *outarg = &req->misc.write.out;
 
@@ -485,6 +488,7 @@ static void fuse_write_fill(struct fuse_
 	inarg->offset = pos;
 	inarg->size = count;
 	inarg->write_flags = writepage ? FUSE_WRITE_CACHE : 0;
+	inarg->flags = file->f_flags;
 	req->in.h.opcode = FUSE_WRITE;
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.argpages = 1;
@@ -505,7 +509,7 @@ static size_t fuse_send_write(struct fus
 			      fl_owner_t owner)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	fuse_write_fill(req, file->private_data, inode, pos, count, 0);
+	fuse_write_fill(req, file, inode, pos, count, 0);
 	if (owner != NULL) {
 		struct fuse_write_in *inarg = &req->misc.write.in;
 		inarg->write_flags |= FUSE_WRITE_LOCKOWNER;
Index: linux/include/linux/fuse.h
===================================================================
--- linux.orig/include/linux/fuse.h	2007-10-15 13:48:52.000000000 +0200
+++ linux/include/linux/fuse.h	2007-10-19 20:22:41.000000000 +0200
@@ -16,6 +16,7 @@
  *  - add lk_flags in fuse_lk_in
  *  - add lock_owner field to fuse_setattr_in, fuse_read_in and fuse_write_in
  *  - add blksize field to fuse_attr
+ *  - add file flags field to fuse_read_in and fuse_write_in
  */
 
 #include <asm/types.h>
@@ -280,6 +281,8 @@ struct fuse_read_in {
 	__u32	size;
 	__u32	read_flags;
 	__u64	lock_owner;
+	__u32	flags;
+	__u32	padding;
 };
 
 #define FUSE_COMPAT_WRITE_IN_SIZE 24
@@ -290,6 +293,8 @@ struct fuse_write_in {
 	__u32	size;
 	__u32	write_flags;
 	__u64	lock_owner;
+	__u32	flags;
+	__u32	padding;
 };
 
 struct fuse_write_out {
Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-10-19 20:02:53.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-10-19 20:27:51.000000000 +0200
@@ -964,7 +964,6 @@ static int fuse_readdir(struct file *fil
 	struct page *page;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_file *ff = file->private_data;
 	struct fuse_req *req;
 
 	if (is_bad_inode(inode))
@@ -981,7 +980,7 @@ static int fuse_readdir(struct file *fil
 	}
 	req->num_pages = 1;
 	req->pages[0] = page;
-	fuse_read_fill(req, ff, inode, file->f_pos, PAGE_SIZE, FUSE_READDIR);
+	fuse_read_fill(req, file, inode, file->f_pos, PAGE_SIZE, FUSE_READDIR);
 	request_send(fc, req);
 	nbytes = req->out.args[0].size;
 	err = req->out.h.error;
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-10-19 20:02:53.000000000 +0200
+++ linux/fs/fuse/fuse_i.h	2007-10-19 20:27:04.000000000 +0200
@@ -447,7 +447,7 @@ void fuse_send_forget(struct fuse_conn *
 /**
  * Initialize READ or READDIR request
  */
-void fuse_read_fill(struct fuse_req *req, struct fuse_file *ff,
+void fuse_read_fill(struct fuse_req *req, struct file *file,
 		    struct inode *inode, loff_t pos, size_t count, int opcode);
 
 /**

--
