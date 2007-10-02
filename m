Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbXJBPxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbXJBPxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbXJBPw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:52:28 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:56325 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbXJBPw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:52:27 -0400
Message-Id: <20071002155214.604280352@szeredi.hu>
References: <20071002155026.650555479@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 02 Oct 2007 17:50:29 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 03/12] fuse: add file handle to getattr operation
Content-Disposition: inline; filename=fuse_fgetattr.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add necessary protocol changes for supplying a file handle with the
getattr operation.  Step the API version to 7.9.

This patch doesn't actually supply the file handle, because that needs
some kind of VFS support, which we haven't yet been able to agree
upon.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/include/linux/fuse.h
===================================================================
--- linux.orig/include/linux/fuse.h	2007-09-25 21:19:00.000000000 +0200
+++ linux/include/linux/fuse.h	2007-09-25 21:19:13.000000000 +0200
@@ -6,7 +6,14 @@
     See the file COPYING.
 */
 
-/* This file defines the kernel interface of FUSE */
+/*
+ * This file defines the kernel interface of FUSE
+ *
+ * Protocol changelog:
+ *
+ * 7.9:
+ *  - new fuse_getattr_in input argument of GETATTR
+ */
 
 #include <asm/types.h>
 #include <linux/major.h>
@@ -15,7 +22,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 8
+#define FUSE_KERNEL_MINOR_VERSION 9
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -91,12 +98,18 @@ struct fuse_file_lock {
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
+#define FUSE_FILE_OPS		(1 << 2)
 
 /**
  * Release flags
  */
 #define FUSE_RELEASE_FLUSH	(1 << 0)
 
+/**
+ * Getattr flags
+ */
+#define FUSE_GETATTR_FH		(1 << 0)
+
 enum fuse_opcode {
 	FUSE_LOOKUP	   = 1,
 	FUSE_FORGET	   = 2,  /* no reply */
@@ -154,6 +167,12 @@ struct fuse_forget_in {
 	__u64	nlookup;
 };
 
+struct fuse_getattr_in {
+	__u32	getattr_flags;
+	__u32	dummy;
+	__u64	fh;
+};
+
 struct fuse_attr_out {
 	__u64	attr_valid;	/* Cache timeout for the attributes */
 	__u32	attr_valid_nsec;
Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-09-25 21:19:13.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-09-25 21:19:13.000000000 +0200
@@ -705,10 +705,12 @@ static void fuse_fillattr(struct inode *
 	stat->blksize = (1 << inode->i_blkbits);
 }
 
-static int fuse_do_getattr(struct inode *inode, struct kstat *stat)
+static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
+			   struct file *file)
 {
 	int err;
-	struct fuse_attr_out arg;
+	struct fuse_getattr_in inarg;
+	struct fuse_attr_out outarg;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_req *req;
 	u64 attr_version;
@@ -721,24 +723,35 @@ static int fuse_do_getattr(struct inode 
 	attr_version = fc->attr_version;
 	spin_unlock(&fc->lock);
 
+	memset(&inarg, 0, sizeof(inarg));
+	/* Directories have separate file-handle space */
+	if (file && S_ISREG(inode->i_mode)) {
+		struct fuse_file *ff = file->private_data;
+
+		inarg.getattr_flags |= FUSE_GETATTR_FH;
+		inarg.fh = ff->fh;
+	}
 	req->in.h.opcode = FUSE_GETATTR;
 	req->in.h.nodeid = get_node_id(inode);
+	req->in.numargs = 1;
+	req->in.args[0].size = sizeof(inarg);
+	req->in.args[0].value = &inarg;
 	req->out.numargs = 1;
-	req->out.args[0].size = sizeof(arg);
-	req->out.args[0].value = &arg;
+	req->out.args[0].size = sizeof(outarg);
+	req->out.args[0].value = &outarg;
 	request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err) {
-		if ((inode->i_mode ^ arg.attr.mode) & S_IFMT) {
+		if ((inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
 			make_bad_inode(inode);
 			err = -EIO;
 		} else {
-			fuse_change_attributes(inode, &arg.attr,
-					       attr_timeout(&arg),
+			fuse_change_attributes(inode, &outarg.attr,
+					       attr_timeout(&outarg),
 					       attr_version);
 			if (stat)
-				fuse_fillattr(inode, &arg.attr, stat);
+				fuse_fillattr(inode, &outarg.attr, stat);
 		}
 	}
 	return err;
@@ -833,7 +846,7 @@ static int fuse_permission(struct inode 
 	    ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))) {
 		struct fuse_inode *fi = get_fuse_inode(inode);
 		if (fi->i_time < get_jiffies_64()) {
-			err = fuse_do_getattr(inode, NULL);
+			err = fuse_do_getattr(inode, NULL, NULL);
 			if (err)
 				return err;
 
@@ -848,7 +861,7 @@ static int fuse_permission(struct inode 
 		   attributes.  This is also needed, because the root
 		   node will at first have no permissions */
 		if (err == -EACCES && !refreshed) {
-		 	err = fuse_do_getattr(inode, NULL);
+		 	err = fuse_do_getattr(inode, NULL, NULL);
 			if (!err)
 				err = generic_permission(inode, mask, NULL);
 		}
@@ -864,7 +877,7 @@ static int fuse_permission(struct inode 
 			if (refreshed)
 				return -EACCES;
 
-			err = fuse_do_getattr(inode, NULL);
+			err = fuse_do_getattr(inode, NULL, NULL);
 			if (!err && !(inode->i_mode & S_IXUGO))
 				return -EACCES;
 		}
@@ -1107,7 +1120,7 @@ static int fuse_getattr(struct vfsmount 
 		return -EACCES;
 
 	if (fi->i_time < get_jiffies_64())
-		err = fuse_do_getattr(inode, stat);
+		err = fuse_do_getattr(inode, stat, NULL);
 	else {
 		err = 0;
 		generic_fillattr(inode, stat);
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-09-25 21:19:13.000000000 +0200
+++ linux/fs/fuse/inode.c	2007-09-25 21:19:13.000000000 +0200
@@ -570,7 +570,7 @@ static void fuse_send_init(struct fuse_c
 	arg->major = FUSE_KERNEL_VERSION;
 	arg->minor = FUSE_KERNEL_MINOR_VERSION;
 	arg->max_readahead = fc->bdi.ra_pages * PAGE_CACHE_SIZE;
-	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS;
+	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_FILE_OPS;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);

--
