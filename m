Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbYDXLnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbYDXLnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 07:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYDXLlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 07:41:20 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57209 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756828AbYDXLki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 07:40:38 -0400
Message-Id: <20080424114025.706442666@szeredi.hu>
References: <20080424113950.818688067@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Apr 2008 13:40:03 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 13/13] vfs: add path_removexattr()
Content-Disposition: inline; filename=path_removexattr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Introduce path_removexattr().  Make vfs_removexattr() static.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/nfsd/vfs.c         |    6 +-----
 fs/xattr.c            |   41 +++++++++++++++++++----------------------
 include/linux/xattr.h |    2 +-
 3 files changed, 21 insertions(+), 28 deletions(-)

Index: vfs-2.6/fs/nfsd/vfs.c
===================================================================
--- vfs-2.6.orig/fs/nfsd/vfs.c	2008-04-23 21:33:44.000000000 +0200
+++ vfs-2.6/fs/nfsd/vfs.c	2008-04-23 21:37:57.000000000 +0200
@@ -2072,9 +2072,6 @@ nfsd_set_posix_acl(struct svc_fh *fhp, i
 	} else
 		size = 0;
 
-	error = mnt_want_write(fhp->fh_export->ex_path.mnt);
-	if (error)
-		goto getout;
 	fh_to_path(fhp, &path);
 	if (size)
 		error = path_setxattr(&path, name, value, size, 0);
@@ -2082,12 +2079,11 @@ nfsd_set_posix_acl(struct svc_fh *fhp, i
 		if (!S_ISDIR(inode->i_mode) && type == ACL_TYPE_DEFAULT)
 			error = 0;
 		else {
-			error = vfs_removexattr(fhp->fh_dentry, name);
+			error = path_removexattr(&path, name);
 			if (error == -ENODATA)
 				error = 0;
 		}
 	}
-	mnt_drop_write(fhp->fh_export->ex_path.mnt);
 
 getout:
 	kfree(value);
Index: vfs-2.6/fs/xattr.c
===================================================================
--- vfs-2.6.orig/fs/xattr.c	2008-04-23 21:33:44.000000000 +0200
+++ vfs-2.6/fs/xattr.c	2008-04-23 21:37:20.000000000 +0200
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
@@ -470,7 +481,7 @@ sys_flistxattr(int fd, char __user *list
  * Extended attribute REMOVE operations
  */
 static long
-removexattr(struct dentry *d, char __user *name)
+removexattr(struct path *path, char __user *name)
 {
 	int error;
 	char kname[XATTR_NAME_MAX + 1];
@@ -481,7 +492,7 @@ removexattr(struct dentry *d, char __use
 	if (error < 0)
 		return error;
 
-	return vfs_removexattr(d, kname);
+	return path_removexattr(path, kname);
 }
 
 asmlinkage long
@@ -493,11 +504,7 @@ sys_removexattr(char __user *path, char 
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = mnt_want_write(nd.path.mnt);
-	if (!error) {
-		error = removexattr(nd.path.dentry, name);
-		mnt_drop_write(nd.path.mnt);
-	}
+	error = removexattr(&nd.path, name);
 	path_put(&nd.path);
 	return error;
 }
@@ -511,11 +518,7 @@ sys_lremovexattr(char __user *path, char
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = mnt_want_write(nd.path.mnt);
-	if (!error) {
-		error = removexattr(nd.path.dentry, name);
-		mnt_drop_write(nd.path.mnt);
-	}
+	error = removexattr(&nd.path, name);
 	path_put(&nd.path);
 	return error;
 }
@@ -524,19 +527,13 @@ asmlinkage long
 sys_fremovexattr(int fd, char __user *name)
 {
 	struct file *f;
-	struct dentry *dentry;
 	int error = -EBADF;
 
 	f = fget(fd);
 	if (!f)
 		return error;
-	dentry = f->f_path.dentry;
-	audit_inode(NULL, dentry);
-	error = mnt_want_write(f->f_path.mnt);
-	if (!error) {
-		error = removexattr(dentry, name);
-		mnt_drop_write(f->f_path.mnt);
-	}
+	audit_inode(NULL, f->f_path.dentry);
+	error = removexattr(&f->f_path, name);
 	fput(f);
 	return error;
 }
Index: vfs-2.6/include/linux/xattr.h
===================================================================
--- vfs-2.6.orig/include/linux/xattr.h	2008-04-23 21:33:44.000000000 +0200
+++ vfs-2.6/include/linux/xattr.h	2008-04-23 21:36:07.000000000 +0200
@@ -50,7 +50,7 @@ ssize_t xattr_getsecurity(struct inode *
 ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
 int path_setxattr(struct path *, char *, void *, size_t, int);
-int vfs_removexattr(struct dentry *, char *);
+int path_removexattr(struct path *, char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);

--
