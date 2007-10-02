Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbXJBP4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbXJBP4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbXJBPwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:52:40 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:58998 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798AbXJBPwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:52:37 -0400
Message-Id: <20071002155224.704779821@szeredi.hu>
References: <20071002155026.650555479@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 02 Oct 2007 17:50:37 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 11/12] fuse: add support for mandatory locking
Content-Disposition: inline; filename=fuse_mandlock_support.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

For mandatory locking the userspace filesystem needs to know the lock
ownership for read, write and truncate operations.

This patch adds the necessary fields to the protocol.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-09-25 21:19:14.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-09-25 21:19:15.000000000 +0200
@@ -1108,6 +1108,11 @@ static int fuse_do_setattr(struct dentry
 		inarg.valid |= FATTR_FH;
 		inarg.fh = ff->fh;
 	}
+	if (attr->ia_valid & ATTR_SIZE) {
+		/* For mandatory locking in truncate */
+		inarg.valid |= FATTR_LOCKOWNER;
+		inarg.lock_owner = fuse_lock_owner_id(fc, current->files);
+	}
 	req->in.h.opcode = FUSE_SETATTR;
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.numargs = 1;
Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-09-25 21:19:15.000000000 +0200
+++ linux/fs/fuse/file.c	2007-09-25 21:19:15.000000000 +0200
@@ -189,7 +189,7 @@ static int fuse_release(struct inode *in
  * Scramble the ID space with XTEA, so that the value of the files_struct
  * pointer is not exposed to userspace.
  */
-static u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id)
+u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id)
 {
 	u32 *k = fc->scramble_key;
 	u64 v = (unsigned long) id;
@@ -308,11 +308,19 @@ void fuse_read_fill(struct fuse_req *req
 }
 
 static size_t fuse_send_read(struct fuse_req *req, struct file *file,
-			     struct inode *inode, loff_t pos, size_t count)
+			     struct inode *inode, loff_t pos, size_t count,
+			     fl_owner_t owner)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_file *ff = file->private_data;
+
 	fuse_read_fill(req, ff, inode, pos, count, FUSE_READ);
+	if (owner != NULL) {
+		struct fuse_read_in *inarg = &req->misc.read_in;
+
+		inarg->read_flags |= FUSE_READ_LOCKOWNER;
+		inarg->lock_owner = fuse_lock_owner_id(fc, owner);
+	}
 	request_send(fc, req);
 	return req->out.args[0].size;
 }
@@ -336,7 +344,8 @@ static int fuse_readpage(struct file *fi
 	req->out.page_zeroing = 1;
 	req->num_pages = 1;
 	req->pages[0] = page;
-	fuse_send_read(req, file, inode, page_offset(page), PAGE_CACHE_SIZE);
+	fuse_send_read(req, file, inode, page_offset(page), PAGE_CACHE_SIZE,
+		       NULL);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err)
@@ -447,6 +456,7 @@ static void fuse_write_fill(struct fuse_
 			    struct inode *inode, loff_t pos, size_t count,
 			    int writepage)
 {
+	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_write_in *inarg = &req->misc.write.in;
 	struct fuse_write_out *outarg = &req->misc.write.out;
 
@@ -459,7 +469,10 @@ static void fuse_write_fill(struct fuse_
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.argpages = 1;
 	req->in.numargs = 2;
-	req->in.args[0].size = sizeof(struct fuse_write_in);
+	if (fc->minor < 9)
+		req->in.args[0].size = FUSE_COMPAT_WRITE_IN_SIZE;
+	else
+		req->in.args[0].size = sizeof(struct fuse_write_in);
 	req->in.args[0].value = inarg;
 	req->in.args[1].size = count;
 	req->out.numargs = 1;
@@ -468,10 +481,16 @@ static void fuse_write_fill(struct fuse_
 }
 
 static size_t fuse_send_write(struct fuse_req *req, struct file *file,
-			      struct inode *inode, loff_t pos, size_t count)
+			      struct inode *inode, loff_t pos, size_t count,
+			      fl_owner_t owner)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	fuse_write_fill(req, file->private_data, inode, pos, count, 0);
+	if (owner != NULL) {
+		struct fuse_write_in *inarg = &req->misc.write.in;
+		inarg->write_flags |= FUSE_WRITE_LOCKOWNER;
+		inarg->lock_owner = fuse_lock_owner_id(fc, owner);
+	}
 	request_send(fc, req);
 	return req->misc.write.out.size;
 }
@@ -508,7 +527,7 @@ static int fuse_buffered_write(struct fi
 	req->num_pages = 1;
 	req->pages[0] = page;
 	req->page_offset = offset;
-	nres = fuse_send_write(req, file, inode, pos, count);
+	nres = fuse_send_write(req, file, inode, pos, count, NULL);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err && !nres)
@@ -609,9 +628,11 @@ static ssize_t fuse_direct_io(struct fil
 		nbytes = (req->num_pages << PAGE_SHIFT) - req->page_offset;
 		nbytes = min(count, nbytes);
 		if (write)
-			nres = fuse_send_write(req, file, inode, pos, nbytes);
+			nres = fuse_send_write(req, file, inode, pos, nbytes,
+					       current->files);
 		else
-			nres = fuse_send_read(req, file, inode, pos, nbytes);
+			nres = fuse_send_read(req, file, inode, pos, nbytes,
+					      current->files);
 		fuse_release_user_pages(req, !write);
 		if (req->out.h.error) {
 			if (!res)
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-09-25 21:19:15.000000000 +0200
+++ linux/fs/fuse/fuse_i.h	2007-09-25 21:19:15.000000000 +0200
@@ -591,3 +591,5 @@ int fuse_valid_type(int m);
  * Is task allowed to perform filesystem operation?
  */
 int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task);
+
+u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id);
Index: linux/include/linux/fuse.h
===================================================================
--- linux.orig/include/linux/fuse.h	2007-09-25 21:19:15.000000000 +0200
+++ linux/include/linux/fuse.h	2007-09-25 21:19:15.000000000 +0200
@@ -14,6 +14,7 @@
  * 7.9:
  *  - new fuse_getattr_in input argument of GETATTR
  *  - add lk_flags in fuse_lk_in
+ *  - add lock_owner field to fuse_setattr_in, fuse_read_in and fuse_write_in
  */
 
 #include <asm/types.h>
@@ -86,6 +87,7 @@ struct fuse_file_lock {
 #define FATTR_FH	(1 << 6)
 #define FATTR_ATIME_NOW	(1 << 7)
 #define FATTR_MTIME_NOW	(1 << 8)
+#define FATTR_LOCKOWNER	(1 << 9)
 
 /**
  * Flags returned by the OPEN request
@@ -123,8 +125,15 @@ struct fuse_file_lock {
  * WRITE flags
  *
  * FUSE_WRITE_CACHE: delayed write from page cache, file handle is guessed
+ * FUSE_WRITE_LOCKOWNER: lock_owner field is valid
  */
 #define FUSE_WRITE_CACHE	(1 << 0)
+#define FUSE_WRITE_LOCKOWNER	(1 << 1)
+
+/**
+ * Read flags
+ */
+#define FUSE_READ_LOCKOWNER	(1 << 1)
 
 enum fuse_opcode {
 	FUSE_LOOKUP	   = 1,
@@ -219,7 +228,7 @@ struct fuse_setattr_in {
 	__u32	padding;
 	__u64	fh;
 	__u64	size;
-	__u64	unused1;
+	__u64	lock_owner;
 	__u64	atime;
 	__u64	mtime;
 	__u64	unused2;
@@ -262,14 +271,18 @@ struct fuse_read_in {
 	__u64	fh;
 	__u64	offset;
 	__u32	size;
-	__u32	padding;
+	__u32	read_flags;
+	__u64	lock_owner;
 };
 
+#define FUSE_COMPAT_WRITE_IN_SIZE 24
+
 struct fuse_write_in {
 	__u64	fh;
 	__u64	offset;
 	__u32	size;
 	__u32	write_flags;
+	__u64	lock_owner;
 };
 
 struct fuse_write_out {

--
