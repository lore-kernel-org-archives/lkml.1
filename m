Return-Path: <linux-kernel-owner+w=401wt.eu-S1764390AbXLTOWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764390AbXLTOWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932771AbXLTOMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:12:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:40804 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933024AbXLTOMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:12:09 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:45 2007
Message-Id: <20071220140944.904350453@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:33 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 23/47] Add a struct vfsmount parameter to vfs_getxattr()
Content-Disposition: inline; filename=vfs-getxattr.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/nfsd/nfs4xdr.c         |    2 +-
 fs/nfsd/vfs.c             |   21 ++++++++++++---------
 fs/unionfs/copyup.c       |    2 +-
 fs/unionfs/xattr.c        |    4 +++-
 fs/xattr.c                |   14 ++++++++------
 include/linux/nfsd/nfsd.h |    3 ++-
 include/linux/xattr.h     |    2 +-
 7 files changed, 28 insertions(+), 20 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1501,7 +1501,7 @@ nfsd4_encode_fattr(struct svc_fh *fhp, s
 	}
 	if (bmval0 & (FATTR4_WORD0_ACL | FATTR4_WORD0_ACLSUPPORT
 			| FATTR4_WORD0_SUPPORTED_ATTRS)) {
-		err = nfsd4_get_nfs4_acl(rqstp, dentry, &acl);
+		err = nfsd4_get_nfs4_acl(rqstp, dentry, exp->ex_path.mnt, &acl);
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
@@ -2017,7 +2019,8 @@ nfsd_get_posix_acl(struct svc_fh *fhp, i
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
-	size = nfsd_getxattr(fhp->fh_dentry, name, &value);
+	size = nfsd_getxattr(fhp->fh_dentry, fhp->fh_export->ex_path.mnt, name,
+			     &value);
 	if (size < 0)
 		return ERR_PTR(size);
 
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -72,7 +72,7 @@ static int copyup_xattrs(struct dentry *
 
 		/* Lock here since vfs_getxattr doesn't lock for us */
 		mutex_lock(&old_lower_dentry->d_inode->i_mutex);
-		size = vfs_getxattr(old_lower_dentry, name_list,
+		size = vfs_getxattr(old_lower_dentry, old_lower_mnt, name_list,
 				    attr_value, XATTR_SIZE_MAX);
 		mutex_unlock(&old_lower_dentry->d_inode->i_mutex);
 		if (size < 0) {
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -43,6 +43,7 @@ ssize_t unionfs_getxattr(struct dentry *
 			 size_t size)
 {
 	struct dentry *lower_dentry = NULL;
+	struct vfsmount *lower_mnt;
 	int err = -EOPNOTSUPP;
 
 	unionfs_read_lock(dentry->d_sb);
@@ -54,8 +55,9 @@ ssize_t unionfs_getxattr(struct dentry *
 	}
 
 	lower_dentry = unionfs_lower_dentry(dentry);
+	lower_mnt = unionfs_lower_mnt(dentry);
 
-	err = vfs_getxattr(lower_dentry, (char *) name, value, size);
+	err = vfs_getxattr(lower_dentry, lower_mnt, (char *) name, value, size);
 
 out:
 	unionfs_check_dentry(dentry);
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -131,7 +131,8 @@ out_noalloc:
 EXPORT_SYMBOL_GPL(xattr_getsecurity);
 
 ssize_t
-vfs_getxattr(struct dentry *dentry, char *name, void *value, size_t size)
+vfs_getxattr(struct dentry *dentry, struct vfsmount *mnt, char *name,
+	     void *value, size_t size)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -316,7 +317,8 @@ out_fput:
  * Extended attribute GET operations
  */
 static ssize_t
-getxattr(struct dentry *d, char __user *name, void __user *value, size_t size)
+getxattr(struct dentry *dentry, struct vfsmount *mnt, char __user *name,
+	 void __user *value, size_t size)
 {
 	ssize_t error;
 	void *kvalue = NULL;
@@ -336,7 +338,7 @@ getxattr(struct dentry *d, char __user *
 			return -ENOMEM;
 	}
 
-	error = vfs_getxattr(d, kname, kvalue, size);
+	error = vfs_getxattr(dentry, mnt, kname, kvalue, size);
 	if (error > 0) {
 		if (size && copy_to_user(value, kvalue, error))
 			error = -EFAULT;
@@ -359,7 +361,7 @@ sys_getxattr(char __user *path, char __u
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = getxattr(nd.path.dentry, name, value, size);
+	error = getxattr(nd.path.dentry, nd.path.mnt, name, value, size);
 	path_put(&nd.path);
 	return error;
 }
@@ -374,7 +376,7 @@ sys_lgetxattr(char __user *path, char __
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = getxattr(nd.path.dentry, name, value, size);
+	error = getxattr(nd.path.dentry, nd.path.mnt, name, value, size);
 	path_put(&nd.path);
 	return error;
 }
@@ -389,7 +391,7 @@ sys_fgetxattr(int fd, char __user *name,
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
@@ -78,7 +78,8 @@ __be32		nfsd_setattr(struct svc_rqst *, 
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
@@ -47,7 +47,7 @@ struct xattr_handler {
 };
 
 ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
-ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
+ssize_t vfs_getxattr(struct dentry *, struct vfsmount *, char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
 int vfs_setxattr(struct dentry *, struct vfsmount *, char *, void *, size_t,
 		 int);

-- 

