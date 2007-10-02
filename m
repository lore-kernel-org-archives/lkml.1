Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbXJBPyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbXJBPyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbXJBPwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:52:36 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:56357 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbXJBPwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:52:34 -0400
Message-Id: <20071002155221.239680121@szeredi.hu>
References: <20071002155026.650555479@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 02 Oct 2007 17:50:34 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 08/12] fuse: support BSD locking semantics
Content-Disposition: inline; filename=fuse_flock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

It is trivial to add support for flock(2) semantics to the existing
protocol, by setting the lock owner field to the file pointer, and
passing a new FUSE_LK_FLOCK flag with the locking request.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-09-25 21:19:14.000000000 +0200
+++ linux/fs/fuse/file.c	2007-09-25 21:19:14.000000000 +0200
@@ -699,7 +699,8 @@ static int convert_fuse_file_lock(const 
 }
 
 static void fuse_lk_fill(struct fuse_req *req, struct file *file,
-			 const struct file_lock *fl, int opcode, pid_t pid)
+			 const struct file_lock *fl, int opcode, pid_t pid,
+			 int flock)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -712,6 +713,8 @@ static void fuse_lk_fill(struct fuse_req
 	arg->lk.end = fl->fl_end;
 	arg->lk.type = fl->fl_type;
 	arg->lk.pid = pid;
+	if (flock)
+		arg->lk_flags |= FUSE_LK_FLOCK;
 	req->in.h.opcode = opcode;
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.numargs = 1;
@@ -731,7 +734,7 @@ static int fuse_getlk(struct file *file,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	fuse_lk_fill(req, file, fl, FUSE_GETLK, 0);
+	fuse_lk_fill(req, file, fl, FUSE_GETLK, 0, 0);
 	req->out.numargs = 1;
 	req->out.args[0].size = sizeof(outarg);
 	req->out.args[0].value = &outarg;
@@ -744,7 +747,7 @@ static int fuse_getlk(struct file *file,
 	return err;
 }
 
-static int fuse_setlk(struct file *file, struct file_lock *fl)
+static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -761,7 +764,7 @@ static int fuse_setlk(struct file *file,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	fuse_lk_fill(req, file, fl, opcode, pid);
+	fuse_lk_fill(req, file, fl, opcode, pid, flock);
 	request_send(fc, req);
 	err = req->out.h.error;
 	/* locking is restartable */
@@ -787,11 +790,28 @@ static int fuse_file_lock(struct file *f
 		if (fc->no_lock)
 			err = posix_lock_file_wait(file, fl);
 		else
-			err = fuse_setlk(file, fl);
+			err = fuse_setlk(file, fl, 0);
 	}
 	return err;
 }
 
+static int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	int err;
+
+	if (fc->no_lock) {
+		err = flock_lock_file_wait(file, fl);
+	} else {
+		/* emulate flock with POSIX locks */
+		fl->fl_owner = (fl_owner_t) file;
+		err = fuse_setlk(file, fl, 1);
+	}
+
+	return err;
+}
+
 static sector_t fuse_bmap(struct address_space *mapping, sector_t block)
 {
 	struct inode *inode = mapping->host;
@@ -840,6 +860,7 @@ static const struct file_operations fuse
 	.release	= fuse_release,
 	.fsync		= fuse_fsync,
 	.lock		= fuse_file_lock,
+	.flock		= fuse_file_flock,
 	.splice_read	= generic_file_splice_read,
 };
 
@@ -852,6 +873,7 @@ static const struct file_operations fuse
 	.release	= fuse_release,
 	.fsync		= fuse_fsync,
 	.lock		= fuse_file_lock,
+	.flock		= fuse_file_flock,
 	/* no mmap and splice_read */
 };
 
Index: linux/include/linux/fuse.h
===================================================================
--- linux.orig/include/linux/fuse.h	2007-09-25 21:19:14.000000000 +0200
+++ linux/include/linux/fuse.h	2007-09-25 21:19:14.000000000 +0200
@@ -13,6 +13,7 @@
  *
  * 7.9:
  *  - new fuse_getattr_in input argument of GETATTR
+ *  - add lk_flags in fuse_lk_in
  */
 
 #include <asm/types.h>
@@ -113,6 +114,11 @@ struct fuse_file_lock {
  */
 #define FUSE_GETATTR_FH		(1 << 0)
 
+/**
+ * Lock flags
+ */
+#define FUSE_LK_FLOCK		(1 << 0)
+
 enum fuse_opcode {
 	FUSE_LOOKUP	   = 1,
 	FUSE_FORGET	   = 2,  /* no reply */
@@ -295,6 +301,8 @@ struct fuse_lk_in {
 	__u64	fh;
 	__u64	owner;
 	struct fuse_file_lock lk;
+	__u32	lk_flags;
+	__u32	padding;
 };
 
 struct fuse_lk_out {

--
