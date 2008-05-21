Return-Path: <linux-kernel-owner+w=401wt.eu-S936105AbYEURQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936105AbYEURQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765451AbYEURPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:15:50 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33047 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbYEURPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:15:48 -0400
Message-Id: <20080521171542.572263215@szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 21 May 2008 19:14:59 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 01/14] vfs: add path_getxattr()
Content-Disposition: inline; filename=path_getxattr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Introduce path_getxattr().  Make vfs_getxattr() static.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/nfsd/nfs4xdr.c         |    2 +-
 fs/nfsd/vfs.c             |   25 ++++++++++++++++---------
 fs/xattr.c                |   15 ++++++++-------
 include/linux/nfsd/nfsd.h |    3 ++-
 include/linux/xattr.h     |    2 +-
 5 files changed, 28 insertions(+), 19 deletions(-)

Index: linux-2.6/fs/nfsd/nfs4xdr.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfs4xdr.c	2008-05-14 12:49:18.000000000 +0200
+++ linux-2.6/fs/nfsd/nfs4xdr.c	2008-05-21 13:21:28.000000000 +0200
@@ -1487,7 +1487,7 @@ nfsd4_encode_fattr(struct svc_fh *fhp, s
 	}
 	if (bmval0 & (FATTR4_WORD0_ACL | FATTR4_WORD0_ACLSUPPORT
 			| FATTR4_WORD0_SUPPORTED_ATTRS)) {
-		err = nfsd4_get_nfs4_acl(rqstp, dentry, &acl);
+		err = nfsd4_get_nfs4_acl(rqstp, exp, dentry, &acl);
 		aclsupport = (err == 0);
 		if (bmval0 & FATTR4_WORD0_ACL) {
 			if (err == -EOPNOTSUPP)
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-05-21 13:13:29.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-05-21 13:34:27.000000000 +0200
@@ -416,11 +416,11 @@ out_nfserr:
 #if defined(CONFIG_NFSD_V2_ACL) || \
     defined(CONFIG_NFSD_V3_ACL) || \
     defined(CONFIG_NFSD_V4)
-static ssize_t nfsd_getxattr(struct dentry *dentry, char *key, void **buf)
+static ssize_t nfsd_getxattr(struct path *path, char *key, void **buf)
 {
 	ssize_t buflen;
 
-	buflen = vfs_getxattr(dentry, key, NULL, 0);
+	buflen = path_getxattr(path, key, NULL, 0);
 	if (buflen <= 0)
 		return buflen;
 
@@ -428,7 +428,7 @@ static ssize_t nfsd_getxattr(struct dent
 	if (!*buf)
 		return -ENOMEM;
 
-	return vfs_getxattr(dentry, key, *buf, buflen);
+	return path_getxattr(path, key, *buf, buflen);
 }
 #endif
 
@@ -504,13 +504,13 @@ out_nfserr:
 }
 
 static struct posix_acl *
-_get_posix_acl(struct dentry *dentry, char *key)
+_get_posix_acl(struct path *path, char *key)
 {
 	void *buf = NULL;
 	struct posix_acl *pacl = NULL;
 	int buflen;
 
-	buflen = nfsd_getxattr(dentry, key, &buf);
+	buflen = nfsd_getxattr(path, key, &buf);
 	if (!buflen)
 		buflen = -ENODATA;
 	if (buflen <= 0)
@@ -522,14 +522,19 @@ _get_posix_acl(struct dentry *dentry, ch
 }
 
 int
-nfsd4_get_nfs4_acl(struct svc_rqst *rqstp, struct dentry *dentry, struct nfs4_acl **acl)
+nfsd4_get_nfs4_acl(struct svc_rqst *rqstp, struct svc_export *exp,
+		   struct dentry *dentry, struct nfs4_acl **acl)
 {
+	struct path path = {
+		.mnt = exp->ex_path.mnt,
+		.dentry = dentry,
+	};
 	struct inode *inode = dentry->d_inode;
 	int error = 0;
 	struct posix_acl *pacl = NULL, *dpacl = NULL;
 	unsigned int flags = 0;
 
-	pacl = _get_posix_acl(dentry, POSIX_ACL_XATTR_ACCESS);
+	pacl = _get_posix_acl(&path, POSIX_ACL_XATTR_ACCESS);
 	if (IS_ERR(pacl) && PTR_ERR(pacl) == -ENODATA)
 		pacl = posix_acl_from_mode(inode->i_mode, GFP_KERNEL);
 	if (IS_ERR(pacl)) {
@@ -539,7 +544,7 @@ nfsd4_get_nfs4_acl(struct svc_rqst *rqst
 	}
 
 	if (S_ISDIR(inode->i_mode)) {
-		dpacl = _get_posix_acl(dentry, POSIX_ACL_XATTR_DEFAULT);
+		dpacl = _get_posix_acl(&path, POSIX_ACL_XATTR_DEFAULT);
 		if (IS_ERR(dpacl) && PTR_ERR(dpacl) == -ENODATA)
 			dpacl = NULL;
 		else if (IS_ERR(dpacl)) {
@@ -2000,6 +2005,7 @@ nfsd_racache_init(int cache_size)
 struct posix_acl *
 nfsd_get_posix_acl(struct svc_fh *fhp, int type)
 {
+	struct path path;
 	struct inode *inode = fhp->fh_dentry->d_inode;
 	char *name;
 	void *value = NULL;
@@ -2020,7 +2026,8 @@ nfsd_get_posix_acl(struct svc_fh *fhp, i
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
-	size = nfsd_getxattr(fhp->fh_dentry, name, &value);
+	fh_to_path(fhp, &path);
+	size = nfsd_getxattr(&path, name, &value);
 	if (size < 0)
 		return ERR_PTR(size);
 
Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c	2008-05-21 13:13:29.000000000 +0200
+++ linux-2.6/fs/xattr.c	2008-05-21 13:30:33.000000000 +0200
@@ -144,8 +144,9 @@ out_noalloc:
 EXPORT_SYMBOL_GPL(xattr_getsecurity);
 
 ssize_t
-vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
+path_getxattr(struct path *path, const char *name, void *value, size_t size)
 {
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
 	int error;
 
@@ -177,7 +178,7 @@ nolsm:
 
 	return error;
 }
-EXPORT_SYMBOL_GPL(vfs_getxattr);
+EXPORT_SYMBOL_GPL(path_getxattr);
 
 ssize_t
 vfs_listxattr(struct dentry *d, char *list, size_t size)
@@ -326,7 +327,7 @@ sys_fsetxattr(int fd, const char __user 
  * Extended attribute GET operations
  */
 static ssize_t
-getxattr(struct dentry *d, const char __user *name, void __user *value,
+getxattr(struct path *path, const char __user *name, void __user *value,
 	 size_t size)
 {
 	ssize_t error;
@@ -347,7 +348,7 @@ getxattr(struct dentry *d, const char __
 			return -ENOMEM;
 	}
 
-	error = vfs_getxattr(d, kname, kvalue, size);
+	error = path_getxattr(path, kname, kvalue, size);
 	if (error > 0) {
 		if (size && copy_to_user(value, kvalue, error))
 			error = -EFAULT;
@@ -370,7 +371,7 @@ sys_getxattr(const char __user *path, co
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = getxattr(nd.path.dentry, name, value, size);
+	error = getxattr(&nd.path, name, value, size);
 	path_put(&nd.path);
 	return error;
 }
@@ -385,7 +386,7 @@ sys_lgetxattr(const char __user *path, c
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = getxattr(nd.path.dentry, name, value, size);
+	error = getxattr(&nd.path, name, value, size);
 	path_put(&nd.path);
 	return error;
 }
@@ -400,7 +401,7 @@ sys_fgetxattr(int fd, const char __user 
 	if (!f)
 		return error;
 	audit_inode(NULL, f->f_path.dentry);
-	error = getxattr(f->f_path.dentry, name, value, size);
+	error = getxattr(&f->f_path, name, value, size);
 	fput(f);
 	return error;
 }
Index: linux-2.6/include/linux/xattr.h
===================================================================
--- linux-2.6.orig/include/linux/xattr.h	2008-05-19 21:48:17.000000000 +0200
+++ linux-2.6/include/linux/xattr.h	2008-05-21 13:15:13.000000000 +0200
@@ -48,7 +48,7 @@ struct xattr_handler {
 };
 
 ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
-ssize_t vfs_getxattr(struct dentry *, const char *, void *, size_t);
+ssize_t path_getxattr(struct path *, const char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
 int path_setxattr(struct path *, const char *, const void *, size_t, int);
 int path_removexattr(struct path *, const char *);
Index: linux-2.6/include/linux/nfsd/nfsd.h
===================================================================
--- linux-2.6.orig/include/linux/nfsd/nfsd.h	2008-05-14 12:49:30.000000000 +0200
+++ linux-2.6/include/linux/nfsd/nfsd.h	2008-05-21 13:34:42.000000000 +0200
@@ -85,7 +85,8 @@ __be32		nfsd_setattr(struct svc_rqst *, 
 #ifdef CONFIG_NFSD_V4
 __be32          nfsd4_set_nfs4_acl(struct svc_rqst *, struct svc_fh *,
                     struct nfs4_acl *);
-int             nfsd4_get_nfs4_acl(struct svc_rqst *, struct dentry *, struct nfs4_acl **);
+int             nfsd4_get_nfs4_acl(struct svc_rqst *, struct svc_export *,
+				struct dentry *, struct nfs4_acl **);
 #endif /* CONFIG_NFSD_V4 */
 __be32		nfsd_create(struct svc_rqst *, struct svc_fh *,
 				char *name, int len, struct iattr *attrs,

--
