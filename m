Return-Path: <linux-kernel-owner+w=401wt.eu-S1761910AbYEPQkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910AbYEPQkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbYEPQdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:33:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33782 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484AbYEPQdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:33:06 -0400
Message-Id: <20080516163243.606771777@szeredi.hu>
References: <20080516163136.560107038@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 16 May 2008 18:31:57 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 21/22] vfs: add path_setxattr()
Content-Disposition: inline; filename=path_setxattr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Introduce path_setxattr().  Make vfs_setxattr() static.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/nfsd/vfs.c         |   18 ++++++++++--------
 fs/xattr.c            |   44 ++++++++++++++++++++++----------------------
 include/linux/xattr.h |    3 ++-
 3 files changed, 34 insertions(+), 31 deletions(-)

Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-05-16 17:50:52.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-05-16 17:50:52.000000000 +0200
@@ -434,7 +434,7 @@ static ssize_t nfsd_getxattr(struct dent
 
 #if defined(CONFIG_NFSD_V4)
 static int
-set_nfsv4_acl_one(struct dentry *dentry, struct posix_acl *pacl, char *key)
+set_nfsv4_acl_one(struct path *path, struct posix_acl *pacl, char *key)
 {
 	int len;
 	size_t buflen;
@@ -453,7 +453,7 @@ set_nfsv4_acl_one(struct dentry *dentry,
 		goto out;
 	}
 
-	error = vfs_setxattr(dentry, key, buf, len, 0);
+	error = path_setxattr(path, key, buf, len, 0);
 out:
 	kfree(buf);
 	return error;
@@ -465,7 +465,7 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqst
 {
 	__be32 error;
 	int host_error;
-	struct dentry *dentry;
+	struct path path;
 	struct inode *inode;
 	struct posix_acl *pacl = NULL, *dpacl = NULL;
 	unsigned int flags = 0;
@@ -475,8 +475,8 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqst
 	if (error)
 		return error;
 
-	dentry = fhp->fh_dentry;
-	inode = dentry->d_inode;
+	fh_to_path(fhp, &path);
+	inode = path.dentry->d_inode;
 	if (S_ISDIR(inode->i_mode))
 		flags = NFS4_ACL_DIR;
 
@@ -486,12 +486,12 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqst
 	} else if (host_error < 0)
 		goto out_nfserr;
 
-	host_error = set_nfsv4_acl_one(dentry, pacl, POSIX_ACL_XATTR_ACCESS);
+	host_error = set_nfsv4_acl_one(&path, pacl, POSIX_ACL_XATTR_ACCESS);
 	if (host_error < 0)
 		goto out_release;
 
 	if (S_ISDIR(inode->i_mode))
-		host_error = set_nfsv4_acl_one(dentry, dpacl, POSIX_ACL_XATTR_DEFAULT);
+		host_error = set_nfsv4_acl_one(&path, dpacl, POSIX_ACL_XATTR_DEFAULT);
 
 out_release:
 	posix_acl_release(pacl);
@@ -2038,6 +2038,7 @@ nfsd_get_posix_acl(struct svc_fh *fhp, i
 int
 nfsd_set_posix_acl(struct svc_fh *fhp, int type, struct posix_acl *acl)
 {
+	struct path path;
 	struct inode *inode = fhp->fh_dentry->d_inode;
 	char *name;
 	void *value = NULL;
@@ -2073,8 +2074,9 @@ nfsd_set_posix_acl(struct svc_fh *fhp, i
 	error = mnt_want_write(fhp->fh_export->ex_path.mnt);
 	if (error)
 		goto getout;
+	fh_to_path(fhp, &path);
 	if (size)
-		error = vfs_setxattr(fhp->fh_dentry, name, value, size, 0);
+		error = path_setxattr(&path, name, value, size, 0);
 	else {
 		if (!S_ISDIR(inode->i_mode) && type == ACL_TYPE_DEFAULT)
 			error = 0;
Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c	2008-05-16 17:50:34.000000000 +0200
+++ linux-2.6/fs/xattr.c	2008-05-16 17:50:52.000000000 +0200
@@ -66,7 +66,7 @@ xattr_permission(struct inode *inode, co
 	return permission(inode, mask, NULL);
 }
 
-int
+static int
 vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		size_t size, int flags)
 {
@@ -101,7 +101,20 @@ out:
 	mutex_unlock(&inode->i_mutex);
 	return error;
 }
-EXPORT_SYMBOL_GPL(vfs_setxattr);
+
+int path_setxattr(struct path *path, const char *name, const void *value,
+		   size_t size, int flags)
+{
+	int error = mnt_want_write(path->mnt);
+
+	if (!error) {
+		error = vfs_setxattr(path->dentry, name, value, size, flags);
+		mnt_drop_write(path->mnt);
+	}
+
+	return error;
+}
+EXPORT_SYMBOL(path_setxattr);
 
 ssize_t
 xattr_getsecurity(struct inode *inode, const char *name, void *value,
@@ -218,7 +231,7 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
  * Extended attribute SET operations
  */
 static long
-setxattr(struct dentry *d, const char __user *name, const void __user *value,
+setxattr(struct path *path, const char __user *name, const void __user *value,
 	 size_t size, int flags)
 {
 	int error;
@@ -246,7 +259,7 @@ setxattr(struct dentry *d, const char __
 		}
 	}
 
-	error = vfs_setxattr(d, kname, kvalue, size, flags);
+	error = path_setxattr(path, kname, kvalue, size, flags);
 	kfree(kvalue);
 	return error;
 }
@@ -261,11 +274,8 @@ sys_setxattr(const char __user *path, co
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = mnt_want_write(nd.path.mnt);
-	if (!error) {
-		error = setxattr(nd.path.dentry, name, value, size, flags);
-		mnt_drop_write(nd.path.mnt);
-	}
+
+	error = setxattr(&nd.path, name, value, size, flags);
 	path_put(&nd.path);
 	return error;
 }
@@ -280,11 +290,7 @@ sys_lsetxattr(const char __user *path, c
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = mnt_want_write(nd.path.mnt);
-	if (!error) {
-		error = setxattr(nd.path.dentry, name, value, size, flags);
-		mnt_drop_write(nd.path.mnt);
-	}
+	error = setxattr(&nd.path, name, value, size, flags);
 	path_put(&nd.path);
 	return error;
 }
@@ -294,19 +300,13 @@ sys_fsetxattr(int fd, const char __user 
 	      size_t size, int flags)
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
-		error = setxattr(dentry, name, value, size, flags);
-		mnt_drop_write(f->f_path.mnt);
-	}
+	audit_inode(NULL, f->f_path.dentry);
+	error = setxattr(&f->f_path, name, value, size, flags);
 	fput(f);
 	return error;
 }
Index: linux-2.6/include/linux/xattr.h
===================================================================
--- linux-2.6.orig/include/linux/xattr.h	2008-05-16 17:50:34.000000000 +0200
+++ linux-2.6/include/linux/xattr.h	2008-05-16 17:50:52.000000000 +0200
@@ -35,6 +35,7 @@
 
 struct inode;
 struct dentry;
+struct path;
 
 struct xattr_handler {
 	char *prefix;
@@ -49,7 +50,7 @@ struct xattr_handler {
 ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
 ssize_t vfs_getxattr(struct dentry *, const char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
-int vfs_setxattr(struct dentry *, const char *, const void *, size_t, int);
+int path_setxattr(struct path *, const char *, const void *, size_t, int);
 int vfs_removexattr(struct dentry *, const char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);

--
