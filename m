Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbXJBP40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbXJBP40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbXJBPwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:52:41 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:48738 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbXJBPwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:52:37 -0400
Message-Id: <20071002155225.855733621@szeredi.hu>
References: <20071002155026.650555479@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 02 Oct 2007 17:50:38 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 12/12] fuse: add blksize field to fuse_attr
Content-Disposition: inline; filename=fuse_add_blksize_to_attributes.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Allow the userspace filesystem to supply a blksize value to be
returned by stat() and friends.  If the field is zero, it defaults to
the old PAGE_CACHE_SIZE value.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/include/linux/fuse.h
===================================================================
--- linux.orig/include/linux/fuse.h	2007-09-27 00:42:19.000000000 +0200
+++ linux/include/linux/fuse.h	2007-09-27 01:00:03.000000000 +0200
@@ -15,6 +15,7 @@
  *  - new fuse_getattr_in input argument of GETATTR
  *  - add lk_flags in fuse_lk_in
  *  - add lock_owner field to fuse_setattr_in, fuse_read_in and fuse_write_in
+ *  - add blksize field to fuse_attr
  */
 
 #include <asm/types.h>
@@ -53,6 +54,8 @@ struct fuse_attr {
 	__u32	uid;
 	__u32	gid;
 	__u32	rdev;
+	__u32	blksize;
+	__u32	padding;
 };
 
 struct fuse_kstatfs {
@@ -177,6 +180,8 @@ enum fuse_opcode {
 /* The read buffer is required to be at least 8k, but may be much larger */
 #define FUSE_MIN_READ_BUFFER 8192
 
+#define FUSE_COMPAT_ENTRY_OUT_SIZE 120
+
 struct fuse_entry_out {
 	__u64	nodeid;		/* Inode ID */
 	__u64	generation;	/* Inode generation: nodeid:gen must
@@ -198,6 +203,8 @@ struct fuse_getattr_in {
 	__u64	fh;
 };
 
+#define FUSE_COMPAT_ATTR_OUT_SIZE 96
+
 struct fuse_attr_out {
 	__u64	attr_valid;	/* Cache timeout for the attributes */
 	__u32	attr_valid_nsec;
Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-09-27 00:42:19.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-09-27 01:00:30.000000000 +0200
@@ -116,13 +116,19 @@ static void fuse_lookup_init(struct fuse
 			     struct dentry *entry,
 			     struct fuse_entry_out *outarg)
 {
+	struct fuse_conn *fc = get_fuse_conn(dir);
+
+	memset(outarg, 0, sizeof(struct fuse_entry_out));
 	req->in.h.opcode = FUSE_LOOKUP;
 	req->in.h.nodeid = get_node_id(dir);
 	req->in.numargs = 1;
 	req->in.args[0].size = entry->d_name.len + 1;
 	req->in.args[0].value = entry->d_name.name;
 	req->out.numargs = 1;
-	req->out.args[0].size = sizeof(struct fuse_entry_out);
+	if (fc->minor < 9)
+		req->out.args[0].size = FUSE_COMPAT_ENTRY_OUT_SIZE;
+	else
+		req->out.args[0].size = sizeof(struct fuse_entry_out);
 	req->out.args[0].value = outarg;
 }
 
@@ -356,6 +362,7 @@ static int fuse_create_open(struct inode
 
 	flags &= ~O_NOCTTY;
 	memset(&inarg, 0, sizeof(inarg));
+	memset(&outentry, 0, sizeof(outentry));
 	inarg.flags = flags;
 	inarg.mode = mode;
 	req->in.h.opcode = FUSE_CREATE;
@@ -366,7 +373,10 @@ static int fuse_create_open(struct inode
 	req->in.args[1].size = entry->d_name.len + 1;
 	req->in.args[1].value = entry->d_name.name;
 	req->out.numargs = 2;
-	req->out.args[0].size = sizeof(outentry);
+	if (fc->minor < 9)
+		req->out.args[0].size = FUSE_COMPAT_ENTRY_OUT_SIZE;
+	else
+		req->out.args[0].size = sizeof(outentry);
 	req->out.args[0].value = &outentry;
 	req->out.args[1].size = sizeof(outopen);
 	req->out.args[1].value = &outopen;
@@ -431,9 +441,13 @@ static int create_new_entry(struct fuse_
 		return PTR_ERR(forget_req);
 	}
 
+	memset(&outarg, 0, sizeof(outarg));
 	req->in.h.nodeid = get_node_id(dir);
 	req->out.numargs = 1;
-	req->out.args[0].size = sizeof(outarg);
+	if (fc->minor < 9)
+		req->out.args[0].size = FUSE_COMPAT_ENTRY_OUT_SIZE;
+	else
+		req->out.args[0].size = sizeof(outarg);
 	req->out.args[0].value = &outarg;
 	request_send(fc, req);
 	err = req->out.h.error;
@@ -724,6 +738,7 @@ static int fuse_do_getattr(struct inode 
 	spin_unlock(&fc->lock);
 
 	memset(&inarg, 0, sizeof(inarg));
+	memset(&outarg, 0, sizeof(outarg));
 	/* Directories have separate file-handle space */
 	if (file && S_ISREG(inode->i_mode)) {
 		struct fuse_file *ff = file->private_data;
@@ -737,7 +752,10 @@ static int fuse_do_getattr(struct inode 
 	req->in.args[0].size = sizeof(inarg);
 	req->in.args[0].value = &inarg;
 	req->out.numargs = 1;
-	req->out.args[0].size = sizeof(outarg);
+	if (fc->minor < 9)
+		req->out.args[0].size = FUSE_COMPAT_ATTR_OUT_SIZE;
+	else
+		req->out.args[0].size = sizeof(outarg);
 	req->out.args[0].value = &outarg;
 	request_send(fc, req);
 	err = req->out.h.error;
@@ -1102,6 +1120,7 @@ static int fuse_do_setattr(struct dentry
 		return PTR_ERR(req);
 
 	memset(&inarg, 0, sizeof(inarg));
+	memset(&outarg, 0, sizeof(outarg));
 	iattr_to_fattr(attr, &inarg);
 	if (file) {
 		struct fuse_file *ff = file->private_data;
@@ -1119,7 +1138,10 @@ static int fuse_do_setattr(struct dentry
 	req->in.args[0].size = sizeof(inarg);
 	req->in.args[0].value = &inarg;
 	req->out.numargs = 1;
-	req->out.args[0].size = sizeof(outarg);
+	if (fc->minor < 9)
+		req->out.args[0].size = FUSE_COMPAT_ATTR_OUT_SIZE;
+	else
+		req->out.args[0].size = sizeof(outarg);
 	req->out.args[0].value = &outarg;
 	request_send(fc, req);
 	err = req->out.h.error;
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-09-27 00:42:19.000000000 +0200
+++ linux/fs/fuse/inode.c	2007-09-27 00:42:19.000000000 +0200
@@ -148,6 +148,11 @@ void fuse_change_attributes(struct inode
 	inode->i_ctime.tv_sec   = attr->ctime;
 	inode->i_ctime.tv_nsec  = attr->ctimensec;
 
+	if (attr->blksize != 0)
+		inode->i_blkbits = ilog2(attr->blksize);
+	else
+		inode->i_blkbits = inode->i_sb->s_blocksize_bits;
+
 	/*
 	 * Don't set the sticky bit in i_mode, unless we want the VFS
 	 * to check permissions.  This prevents failures due to the

--
