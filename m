Return-Path: <linux-kernel-owner+w=401wt.eu-S1760534AbYDBUOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760534AbYDBUOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760012AbYDBUOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:14:06 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34957 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbYDBUOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:14:04 -0400
Message-Id: <20080402201335.068105076@szeredi.hu>
References: <20080402201247.358430231@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 02 Apr 2008 22:12:57 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 10/10] vfs: add path_removexattr()
Content-Disposition: inline; filename=path_removexattr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Introduce path_removexattr().  Make vfs_removexattr() static.

mnt_want_write()/mnt_drop_write() were completely missing for the
*removexattr() syscalls.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/nfsd/vfs.c         |    2 +-
 fs/xattr.c            |   25 ++++++++++++++++++-------
 include/linux/xattr.h |    2 +-
 3 files changed, 20 insertions(+), 9 deletions(-)

Index: vfs-2.6/fs/nfsd/vfs.c
===================================================================
--- vfs-2.6.orig/fs/nfsd/vfs.c	2008-04-02 21:44:44.000000000 +0200
+++ vfs-2.6/fs/nfsd/vfs.c	2008-04-02 21:45:56.000000000 +0200
@@ -2071,7 +2071,7 @@ nfsd_set_posix_acl(struct svc_fh *fhp, i
 		if (!S_ISDIR(inode->i_mode) && type == ACL_TYPE_DEFAULT)
 			error = 0;
 		else {
-			error = vfs_removexattr(fhp->fh_dentry, name);
+			error = path_removexattr(&path, name);
 			if (error == -ENODATA)
 				error = 0;
 		}
Index: vfs-2.6/fs/xattr.c
===================================================================
--- vfs-2.6.orig/fs/xattr.c	2008-04-02 21:44:44.000000000 +0200
+++ vfs-2.6/fs/xattr.c	2008-04-02 21:45:56.000000000 +0200
@@ -199,7 +199,7 @@ vfs_listxattr(struct dentry *d, char *li
 }
 EXPORT_SYMBOL_GPL(vfs_listxattr);
 
-int
+static int
 vfs_removexattr(struct dentry *dentry, char *name)
 {
 	struct inode *inode = dentry->d_inode;
@@ -224,8 +224,19 @@ vfs_removexattr(struct dentry *dentry, c
 		fsnotify_xattr(dentry);
 	return error;
 }
-EXPORT_SYMBOL_GPL(vfs_removexattr);
 
+int path_removexattr(struct path *path, char *name)
+{
+	int error = mnt_want_write(path->mnt);
+
+	if (!error) {
+		error = vfs_removexattr(path->dentry, name);
+		mnt_drop_write(path->mnt);
+	}
+
+	return error;
+}
+EXPORT_SYMBOL(path_removexattr);
 
 /*
  * Extended attribute SET operations
@@ -471,7 +482,7 @@ sys_flistxattr(int fd, char __user *list
  * Extended attribute REMOVE operations
  */
 static long
-removexattr(struct dentry *d, char __user *name)
+removexattr(struct path *path, char __user *name)
 {
 	int error;
 	char kname[XATTR_NAME_MAX + 1];
@@ -482,7 +493,7 @@ removexattr(struct dentry *d, char __use
 	if (error < 0)
 		return error;
 
-	return vfs_removexattr(d, kname);
+	return path_removexattr(path, kname);
 }
 
 asmlinkage long
@@ -494,7 +505,7 @@ sys_removexattr(char __user *path, char 
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = removexattr(nd.path.dentry, name);
+	error = removexattr(&nd.path, name);
 	path_put(&nd.path);
 	return error;
 }
@@ -508,7 +519,7 @@ sys_lremovexattr(char __user *path, char
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = removexattr(nd.path.dentry, name);
+	error = removexattr(&nd.path, name);
 	path_put(&nd.path);
 	return error;
 }
@@ -525,7 +536,7 @@ sys_fremovexattr(int fd, char __user *na
 		return error;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = removexattr(dentry, name);
+	error = removexattr(&f->f_path, name);
 	fput(f);
 	return error;
 }
Index: vfs-2.6/include/linux/xattr.h
===================================================================
--- vfs-2.6.orig/include/linux/xattr.h	2008-04-02 21:44:44.000000000 +0200
+++ vfs-2.6/include/linux/xattr.h	2008-04-02 21:45:56.000000000 +0200
@@ -50,7 +50,7 @@ ssize_t xattr_getsecurity(struct inode *
 ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
 int path_setxattr(struct path *, char *, void *, size_t, int);
-int vfs_removexattr(struct dentry *, char *);
+int path_removexattr(struct path *, char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);

--
