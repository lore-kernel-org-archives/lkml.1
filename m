Return-Path: <linux-kernel-owner+w=401wt.eu-S1761134AbYDBUP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134AbYDBUP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760403AbYDBUO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:14:27 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34973 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760354AbYDBUOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:14:24 -0400
Message-Id: <20080402201333.725549286@szeredi.hu>
References: <20080402201247.358430231@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 02 Apr 2008 22:12:56 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 09/10] vfs: add path_setxattr()
Content-Disposition: inline; filename=path_setxattr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Introduce path_setxattr().  Make vfs_setxattr() static.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/nfsd/vfs.c         |   21 +++++++++++++--------
 fs/xattr.c            |   42 ++++++++++++++++++++----------------------
 include/linux/xattr.h |    2 +-
 3 files changed, 34 insertions(+), 31 deletions(-)

Index: vfs-2.6/fs/nfsd/vfs.c
===================================================================
--- vfs-2.6.orig/fs/nfsd/vfs.c	2008-04-02 21:41:21.000000000 +0200
+++ vfs-2.6/fs/nfsd/vfs.c	2008-04-02 21:44:44.000000000 +0200
@@ -431,7 +431,7 @@ static ssize_t nfsd_getxattr(struct dent
 
 #if defined(CONFIG_NFSD_V4)
 static int
-set_nfsv4_acl_one(struct dentry *dentry, struct posix_acl *pacl, char *key)
+set_nfsv4_acl_one(struct path *path, struct posix_acl *pacl, char *key)
 {
 	int len;
 	size_t buflen;
@@ -450,7 +450,7 @@ set_nfsv4_acl_one(struct dentry *dentry,
 		goto out;
 	}
 
-	error = vfs_setxattr(dentry, key, buf, len, 0);
+	error = path_setxattr(path, key, buf, len, 0);
 out:
 	kfree(buf);
 	return error;
@@ -462,7 +462,7 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqst
 {
 	__be32 error;
 	int host_error;
-	struct dentry *dentry;
+	struct path path;
 	struct inode *inode;
 	struct posix_acl *pacl = NULL, *dpacl = NULL;
 	unsigned int flags = 0;
@@ -472,8 +472,9 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqst
 	if (error)
 		return error;
 
-	dentry = fhp->fh_dentry;
-	inode = dentry->d_inode;
+	path.mnt = fhp->fh_export->ex_path.mnt;
+	path.dentry = fhp->fh_dentry;
+	inode = path.dentry->d_inode;
 	if (S_ISDIR(inode->i_mode))
 		flags = NFS4_ACL_DIR;
 
@@ -483,12 +484,12 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqst
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
@@ -2028,6 +2029,10 @@ nfsd_get_posix_acl(struct svc_fh *fhp, i
 int
 nfsd_set_posix_acl(struct svc_fh *fhp, int type, struct posix_acl *acl)
 {
+	struct path path = {
+		.mnt = fhp->fh_export->ex_path.mnt,
+		.dentry = fhp->fh_dentry,
+	};
 	struct inode *inode = fhp->fh_dentry->d_inode;
 	char *name;
 	void *value = NULL;
@@ -2061,7 +2066,7 @@ nfsd_set_posix_acl(struct svc_fh *fhp, i
 		size = 0;
 
 	if (size)
-		error = vfs_setxattr(fhp->fh_dentry, name, value, size, 0);
+		error = path_setxattr(&path, name, value, size, 0);
 	else {
 		if (!S_ISDIR(inode->i_mode) && type == ACL_TYPE_DEFAULT)
 			error = 0;
Index: vfs-2.6/fs/xattr.c
===================================================================
--- vfs-2.6.orig/fs/xattr.c	2008-04-02 21:10:16.000000000 +0200
+++ vfs-2.6/fs/xattr.c	2008-04-02 21:44:44.000000000 +0200
@@ -66,7 +66,7 @@ xattr_permission(struct inode *inode, co
 	return permission(inode, mask, NULL);
 }
 
-int
+static int
 vfs_setxattr(struct dentry *dentry, char *name, void *value,
 		size_t size, int flags)
 {
@@ -101,7 +101,20 @@ out:
 	mutex_unlock(&inode->i_mutex);
 	return error;
 }
-EXPORT_SYMBOL_GPL(vfs_setxattr);
+
+int path_setxattr(struct path *path, char *name, void *value, size_t size,
+		  int flags)
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
-setxattr(struct dentry *d, char __user *name, void __user *value,
+setxattr(struct path *path, char __user *name, void __user *value,
 	 size_t size, int flags)
 {
 	int error;
@@ -246,7 +259,7 @@ setxattr(struct dentry *d, char __user *
 		}
 	}
 
-	error = vfs_setxattr(d, kname, kvalue, size, flags);
+	error = path_setxattr(path, kname, kvalue, size, flags);
 	kfree(kvalue);
 	return error;
 }
@@ -261,12 +274,7 @@ sys_setxattr(char __user *path, char __u
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = mnt_want_write(nd.path.mnt);
-	if (error)
-		goto out_path_put;
-	error = setxattr(nd.path.dentry, name, value, size, flags);
-	mnt_drop_write(nd.path.mnt);
- out_path_put:
+	error = setxattr(&nd.path, name, value, size, flags);
 	path_put(&nd.path);
 	return error;
 }
@@ -281,12 +289,7 @@ sys_lsetxattr(char __user *path, char __
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = mnt_want_write(nd.path.mnt);
-	if (error)
-		goto out_path_put;
-	error = setxattr(nd.path.dentry, name, value, size, flags);
-	mnt_drop_write(nd.path.mnt);
- out_path_put:
+	error = setxattr(&nd.path, name, value, size, flags);
 	path_put(&nd.path);
 	return error;
 }
@@ -302,14 +305,9 @@ sys_fsetxattr(int fd, char __user *name,
 	f = fget(fd);
 	if (!f)
 		return error;
-	error = mnt_want_write(f->f_vfsmnt);
-	if (error)
-		goto out_fput;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = setxattr(dentry, name, value, size, flags);
-	mnt_drop_write(f->f_vfsmnt);
-out_fput:
+	error = setxattr(&f->f_path, name, value, size, flags);
 	fput(f);
 	return error;
 }
Index: vfs-2.6/include/linux/xattr.h
===================================================================
--- vfs-2.6.orig/include/linux/xattr.h	2008-04-02 21:10:13.000000000 +0200
+++ vfs-2.6/include/linux/xattr.h	2008-04-02 21:44:44.000000000 +0200
@@ -49,7 +49,7 @@ struct xattr_handler {
 ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
 ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
-int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
+int path_setxattr(struct path *, char *, void *, size_t, int);
 int vfs_removexattr(struct dentry *, char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);

--
