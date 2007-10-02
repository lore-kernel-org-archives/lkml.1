Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbXJBPws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbXJBPws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbXJBPw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:52:27 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:58933 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbXJBPwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:52:25 -0400
Message-Id: <20071002155211.878852520@szeredi.hu>
References: <20071002155026.650555479@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 02 Oct 2007 17:50:27 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 01/12] fuse: fix allowing operations
Content-Disposition: inline; filename=fuse_allow_fixes.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

The following operation didn't check if sending the request was
allowed:

  setattr
  listxattr
  statfs

Some other operations don't explicitly do the check, but VFS calls
->permission() which checks this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-09-25 21:19:00.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-09-25 21:19:13.000000000 +0200
@@ -721,7 +721,7 @@ static int fuse_refresh_attributes(struc
  * for which the owner of the mount has ptrace privilege.  This
  * excludes processes started by other users, suid or sgid processes.
  */
-static int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task)
+int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task)
 {
 	if (fc->flags & FUSE_ALLOW_OTHER)
 		return 1;
@@ -1005,6 +1005,9 @@ static int fuse_setattr(struct dentry *e
 	struct fuse_attr_out outarg;
 	int err;
 
+	if (!fuse_allow_task(fc, current))
+		return -EACCES;
+
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
 		err = inode_change_ok(inode, attr);
 		if (err)
@@ -1172,6 +1175,9 @@ static ssize_t fuse_listxattr(struct den
 	struct fuse_getxattr_out outarg;
 	ssize_t ret;
 
+	if (!fuse_allow_task(fc, current))
+		return -EACCES;
+
 	if (fc->no_listxattr)
 		return -EOPNOTSUPP;
 
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-09-25 21:19:00.000000000 +0200
+++ linux/fs/fuse/fuse_i.h	2007-09-25 21:19:13.000000000 +0200
@@ -565,3 +565,8 @@ void fuse_ctl_remove_conn(struct fuse_co
  * Is file type valid?
  */
 int fuse_valid_type(int m);
+
+/**
+ * Is task allowed to perform filesystem operation?
+ */
+int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task);
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-09-25 21:19:00.000000000 +0200
+++ linux/fs/fuse/inode.c	2007-09-25 21:19:13.000000000 +0200
@@ -287,6 +287,11 @@ static int fuse_statfs(struct dentry *de
 	struct fuse_statfs_out outarg;
 	int err;
 
+	if (!fuse_allow_task(fc, current)) {
+		buf->f_type = FUSE_SUPER_MAGIC;
+		return 0;
+	}
+
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);

--
