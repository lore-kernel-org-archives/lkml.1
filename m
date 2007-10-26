Return-Path: <linux-kernel-owner+w=401wt.eu-S1764232AbXJZHGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764232AbXJZHGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760402AbXJZG6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:58:10 -0400
Received: from ns.suse.de ([195.135.220.2]:34861 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760382AbXJZG6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:58:08 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:50 2007
Message-Id: <20071026064050.136530717@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:47 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 23/45] Add a struct vfsmount parameter to vfs_getxattr()
Content-Disposition: inline; filename=vfs-getxattr.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/nfsd/nfs4xdr.c         |    2 +-
 fs/nfsd/vfs.c             |   21 ++++++++++++---------
 fs/xattr.c                |   14 ++++++++------
 include/linux/nfsd/nfsd.h |    3 ++-
 include/linux/xattr.h     |    3 ++-
 5 files changed, 25 insertions(+), 18 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1496,7 +1496,7 @@ nfsd4_encode_fattr(struct svc_fh *fhp, s
 	}
 	if (bmval0 & (FATTR4_WORD0_ACL | FATTR4_WORD0_ACLSUPPORT
 			| FATTR4_WORD0_SUPPORTED_ATTRS)) {
-		err = nfsd4_get_nfs4_acl(rqstp, dentry, &acl);
+		err = nfsd4_get_nfs4_acl(rqstp, dentry, exp->ex_mnt, &acl);
 		aclsupport = (err == 0);
 		if (bmval0 & FATTR4_WORD0_ACL) {
 			if (err == -EOPNOTSUPP)
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -408,11 +408,12 @@ out_nfserr:
 #if defined(CONFIG_NFSD_V2_ACL) || \
     defined(CONFIG_NFSD_V3_ACL) || \
     defined(CONFIG_NFSD_V4)
-static ssize_t nfsd_getxattr(struct dentry *dentry, char *key, void **buf)
+static ssize_t nfsd_getxattr(struct dentry *dentry, struct vfsmount *mnt,
+			     char *key, void **buf)
 {
 	ssize_t buflen;
 
-	buflen = vfs_getxattr(dentry, key, NULL, 0);
+	buflen = vfs_getxattr(dentry, mnt, key, NULL, 0);
 	if (buflen <= 0)
 		return buflen;
 
@@ -420,7 +421,7 @@ static ssize_t nfsd_getxattr(struct dent
 	if (!*buf)
 		return -ENOMEM;
 
-	return vfs_getxattr(dentry, key, *buf, buflen);
+	return vfs_getxattr(dentry, mnt, key, *buf, buflen);
 }
 #endif
 
@@ -501,13 +502,13 @@ out_nfserr:
 }
 
 static struct posix_acl *
-_get_posix_acl(struct dentry *dentry, char *key)
+_get_posix_acl(struct dentry *dentry, struct vfsmount *mnt, char *key)
 {
 	void *buf = NULL;
 	struct posix_acl *pacl = NULL;
 	int buflen;
 
-	buflen = nfsd_getxattr(dentry, key, &buf);
+	buflen = nfsd_getxattr(dentry, mnt, key, &buf);
 	if (!buflen)
 		buflen = -ENODATA;
 	if (buflen <= 0)
@@ -519,14 +520,15 @@ _get_posix_acl(struct dentry *dentry, ch
 }
 
 int
-nfsd4_get_nfs4_acl(struct svc_rqst *rqstp, struct dentry *dentry, struct nfs4_acl **acl)
+nfsd4_get_nfs4_acl(struct svc_rqst *rqstp, struct dentry *dentry,
+		   struct vfsmount *mnt, struct nfs4_acl **acl)
 {
 	struct inode *inode = dentry->d_inode;
 	int error = 0;
 	struct posix_acl *pacl = NULL, *dpacl = NULL;
 	unsigned int flags = 0;
 
-	pacl = _get_posix_acl(dentry, POSIX_ACL_XATTR_ACCESS);
+	pacl = _get_posix_acl(dentry, mnt, POSIX_ACL_XATTR_ACCESS);
 	if (IS_ERR(pacl) && PTR_ERR(pacl) == -ENODATA)
 		pacl = posix_acl_from_mode(inode->i_mode, GFP_KERNEL);
 	if (IS_ERR(pacl)) {
@@ -536,7 +538,7 @@ nfsd4_get_nfs4_acl(struct svc_rqst *rqst
 	}
 
 	if (S_ISDIR(inode->i_mode)) {
-		dpacl = _get_posix_acl(dentry, POSIX_ACL_XATTR_DEFAULT);
+		dpacl = _get_posix_acl(dentry, mnt, POSIX_ACL_XATTR_DEFAULT);
 		if (IS_ERR(dpacl) && PTR_ERR(dpacl) == -ENODATA)
 			dpacl = NULL;
 		else if (IS_ERR(dpacl)) {
@@ -2012,7 +2014,8 @@ nfsd_get_posix_acl(struct svc_fh *fhp, i
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
-	size = nfsd_getxattr(fhp->fh_dentry, name, &value);
+	size = nfsd_getxattr(fhp->fh_dentry, fhp->fh_export->ex_mnt, name,
+			     &value);
 	if (size < 0)
 		return ERR_PTR(size);
 
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -104,7 +104,8 @@ out:
 EXPORT_SYMBOL_GPL(vfs_setxattr);
 
 ssize_t
-vfs_getxattr(struct dentry *dentry, char *name, void *value, size_t size)
+vfs_getxattr(struct dentry *dentry, struct vfsmount *mnt, char *name,
+	     void *value, size_t size)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -289,7 +290,8 @@ out_fput:
  * Extended attribute GET operations
  */
 static ssize_t
-getxattr(struct dentry *d, char __user *name, void __user *value, size_t size)
+getxattr(struct dentry *dentry, struct vfsmount *mnt, char __user *name,
+	 void __user *value, size_t size)
 {
 	ssize_t error;
 	void *kvalue = NULL;
@@ -309,7 +311,7 @@ getxattr(struct dentry *d, char __user *
 			return -ENOMEM;
 	}
 
-	error = vfs_getxattr(d, kname, kvalue, size);
+	error = vfs_getxattr(dentry, mnt, kname, kvalue, size);
 	if (error > 0) {
 		if (size && copy_to_user(value, kvalue, error))
 			error = -EFAULT;
@@ -332,7 +334,7 @@ sys_getxattr(char __user *path, char __u
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = getxattr(nd.dentry, name, value, size);
+	error = getxattr(nd.dentry, nd.mnt, name, value, size);
 	path_release(&nd);
 	return error;
 }
@@ -347,7 +349,7 @@ sys_lgetxattr(char __user *path, char __
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = getxattr(nd.dentry, name, value, size);
+	error = getxattr(nd.dentry, nd.mnt, name, value, size);
 	path_release(&nd);
 	return error;
 }
@@ -362,7 +364,7 @@ sys_fgetxattr(int fd, char __user *name,
 	if (!f)
 		return error;
 	audit_inode(NULL, f->f_path.dentry);
-	error = getxattr(f->f_path.dentry, name, value, size);
+	error = getxattr(f->f_path.dentry, f->f_path.mnt, name, value, size);
 	fput(f);
 	return error;
 }
--- a/include/linux/nfsd/nfsd.h
+++ b/include/linux/nfsd/nfsd.h
@@ -79,7 +79,8 @@ __be32		nfsd_setattr(struct svc_rqst *, 
 #ifdef CONFIG_NFSD_V4
 __be32          nfsd4_set_nfs4_acl(struct svc_rqst *, struct svc_fh *,
                     struct nfs4_acl *);
-int             nfsd4_get_nfs4_acl(struct svc_rqst *, struct dentry *, struct nfs4_acl **);
+int             nfsd4_get_nfs4_acl(struct svc_rqst *, struct dentry *,
+				struct vfsmount *mnt, struct nfs4_acl **);
 #endif /* CONFIG_NFSD_V4 */
 __be32		nfsd_create(struct svc_rqst *, struct svc_fh *,
 				char *name, int len, struct iattr *attrs,
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -46,7 +46,8 @@ struct xattr_handler {
 		   size_t size, int flags);
 };
 
-ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
+ssize_t vfs_getxattr(struct dentry *, struct vfsmount *, char *, void *,
+		     size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
 int vfs_setxattr(struct dentry *, struct vfsmount *, char *, void *, size_t,
 		 int);

-- 

