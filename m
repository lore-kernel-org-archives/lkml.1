Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbYGVWR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYGVWR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbYGVWNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:13:42 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59108 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508AbYGVWNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:13:41 -0400
Message-Id: <20080722221337.925427387@szeredi.hu>
References: <20080722221259.866628660@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 23 Jul 2008 00:13:13 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [patch 14/14] vfs: add path_removexattr()
Content-Disposition: inline; filename=vfs-add-path_removexattr.patch
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

Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-07-23 00:10:26.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-07-23 00:10:27.000000000 +0200
@@ -2068,9 +2068,6 @@ nfsd_set_posix_acl(struct svc_fh *fhp, i
 	} else
 		size = 0;
 
-	error = mnt_want_write(fhp->fh_export->ex_path.mnt);
-	if (error)
-		goto getout;
 	fh_to_path(fhp, &path);
 	if (size)
 		error = path_setxattr(&path, name, value, size, 0);
@@ -2078,12 +2075,11 @@ nfsd_set_posix_acl(struct svc_fh *fhp, i
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
Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c	2008-07-23 00:10:27.000000000 +0200
+++ linux-2.6/fs/xattr.c	2008-07-23 00:10:27.000000000 +0200
@@ -199,7 +199,7 @@ vfs_listxattr(struct dentry *d, char *li
 }
 EXPORT_SYMBOL_GPL(vfs_listxattr);
 
-int
+static int
 vfs_removexattr(struct dentry *dentry, const char *name)
 {
 	struct inode *inode = dentry->d_inode;
@@ -224,8 +224,19 @@ vfs_removexattr(struct dentry *dentry, c
 		fsnotify_xattr(dentry);
 	return error;
 }
-EXPORT_SYMBOL_GPL(vfs_removexattr);
 
+int path_removexattr(struct path *path, const char *name)
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
-removexattr(struct dentry *d, const char __user *name)
+removexattr(struct path *path, const char __user *name)
 {
 	int error;
 	char kname[XATTR_NAME_MAX + 1];
@@ -482,7 +493,7 @@ removexattr(struct dentry *d, const char
 	if (error < 0)
 		return error;
 
-	return vfs_removexattr(d, kname);
+	return path_removexattr(path, kname);
 }
 
 asmlinkage long
@@ -494,11 +505,7 @@ sys_removexattr(const char __user *pathn
 	error = user_path(pathname, &path);
 	if (error)
 		return error;
-	error = mnt_want_write(path.mnt);
-	if (!error) {
-		error = removexattr(path.dentry, name);
-		mnt_drop_write(path.mnt);
-	}
+	error = removexattr(&path, name);
 	path_put(&path);
 	return error;
 }
@@ -512,11 +519,7 @@ sys_lremovexattr(const char __user *path
 	error = user_lpath(pathname, &path);
 	if (error)
 		return error;
-	error = mnt_want_write(path.mnt);
-	if (!error) {
-		error = removexattr(path.dentry, name);
-		mnt_drop_write(path.mnt);
-	}
+	error = removexattr(&path, name);
 	path_put(&path);
 	return error;
 }
@@ -525,19 +528,13 @@ asmlinkage long
 sys_fremovexattr(int fd, const char __user *name)
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
Index: linux-2.6/include/linux/xattr.h
===================================================================
--- linux-2.6.orig/include/linux/xattr.h	2008-07-23 00:10:27.000000000 +0200
+++ linux-2.6/include/linux/xattr.h	2008-07-23 00:10:27.000000000 +0200
@@ -51,7 +51,7 @@ ssize_t xattr_getsecurity(struct inode *
 ssize_t vfs_getxattr(struct dentry *, const char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
 int path_setxattr(struct path *, const char *, const void *, size_t, int);
-int vfs_removexattr(struct dentry *, const char *);
+int path_removexattr(struct path *, const char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);

--
