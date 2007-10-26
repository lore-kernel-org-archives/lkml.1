Return-Path: <linux-kernel-owner+w=401wt.eu-S1764172AbXJZHFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764172AbXJZHFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759841AbXJZG6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:58:04 -0400
Received: from mx1.suse.de ([195.135.220.2]:34846 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761281AbXJZG6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:58:00 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:49 2007
Message-Id: <20071026064049.827188580@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:45 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 21/45] Add a struct vfsmount parameter to vfs_setxattr()
Content-Disposition: inline; filename=vfs-setxattr.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/nfsd/vfs.c         |   16 +++++++++++-----
 fs/xattr.c            |   16 ++++++++--------
 include/linux/xattr.h |    3 ++-
 3 files changed, 21 insertions(+), 14 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -426,7 +426,8 @@ static ssize_t nfsd_getxattr(struct dent
 
 #if defined(CONFIG_NFSD_V4)
 static int
-set_nfsv4_acl_one(struct dentry *dentry, struct posix_acl *pacl, char *key)
+set_nfsv4_acl_one(struct dentry *dentry, struct vfsmount *mnt,
+		  struct posix_acl *pacl, char *key)
 {
 	int len;
 	size_t buflen;
@@ -445,7 +446,7 @@ set_nfsv4_acl_one(struct dentry *dentry,
 		goto out;
 	}
 
-	error = vfs_setxattr(dentry, key, buf, len, 0);
+	error = vfs_setxattr(dentry, mnt, key, buf, len, 0);
 out:
 	kfree(buf);
 	return error;
@@ -458,6 +459,7 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqst
 	__be32 error;
 	int host_error;
 	struct dentry *dentry;
+	struct vfsmount *mnt;
 	struct inode *inode;
 	struct posix_acl *pacl = NULL, *dpacl = NULL;
 	unsigned int flags = 0;
@@ -468,6 +470,7 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqst
 		return error;
 
 	dentry = fhp->fh_dentry;
+	mnt = fhp->fh_export->ex_mnt;
 	inode = dentry->d_inode;
 	if (S_ISDIR(inode->i_mode))
 		flags = NFS4_ACL_DIR;
@@ -478,12 +481,14 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqst
 	} else if (host_error < 0)
 		goto out_nfserr;
 
-	host_error = set_nfsv4_acl_one(dentry, pacl, POSIX_ACL_XATTR_ACCESS);
+	host_error = set_nfsv4_acl_one(dentry, mnt, pacl,
+				       POSIX_ACL_XATTR_ACCESS);
 	if (host_error < 0)
 		goto out_release;
 
 	if (S_ISDIR(inode->i_mode))
-		host_error = set_nfsv4_acl_one(dentry, dpacl, POSIX_ACL_XATTR_DEFAULT);
+		host_error = set_nfsv4_acl_one(dentry, mnt, dpacl,
+					       POSIX_ACL_XATTR_DEFAULT);
 
 out_release:
 	posix_acl_release(pacl);
@@ -2052,7 +2057,8 @@ nfsd_set_posix_acl(struct svc_fh *fhp, i
 		size = 0;
 
 	if (size)
-		error = vfs_setxattr(fhp->fh_dentry, name, value, size, 0);
+		error = vfs_setxattr(fhp->fh_dentry, fhp->fh_export->ex_mnt,
+				     name, value, size,0);
 	else {
 		if (!S_ISDIR(inode->i_mode) && type == ACL_TYPE_DEFAULT)
 			error = 0;
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -67,8 +67,8 @@ xattr_permission(struct inode *inode, co
 }
 
 int
-vfs_setxattr(struct dentry *dentry, char *name, void *value,
-		size_t size, int flags)
+vfs_setxattr(struct dentry *dentry, struct vfsmount *mnt, char *name,
+	     void *value, size_t size, int flags)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -191,8 +191,8 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
  * Extended attribute SET operations
  */
 static long
-setxattr(struct dentry *d, char __user *name, void __user *value,
-	 size_t size, int flags)
+setxattr(struct dentry *dentry, struct vfsmount *mnt, char __user *name,
+	 void __user *value, size_t size, int flags)
 {
 	int error;
 	void *kvalue = NULL;
@@ -219,7 +219,7 @@ setxattr(struct dentry *d, char __user *
 		}
 	}
 
-	error = vfs_setxattr(d, kname, kvalue, size, flags);
+	error = vfs_setxattr(dentry, mnt, kname, kvalue, size, flags);
 	kfree(kvalue);
 	return error;
 }
@@ -237,7 +237,7 @@ sys_setxattr(char __user *path, char __u
 	error = mnt_want_write(nd.mnt);
 	if (error)
 		return error;
-	error = setxattr(nd.dentry, name, value, size, flags);
+	error = setxattr(nd.dentry, nd.mnt, name, value, size, flags);
 	mnt_drop_write(nd.mnt);
 	path_release(&nd);
 	return error;
@@ -256,7 +256,7 @@ sys_lsetxattr(char __user *path, char __
 	error = mnt_want_write(nd.mnt);
 	if (error)
 		return error;
-	error = setxattr(nd.dentry, name, value, size, flags);
+	error = setxattr(nd.dentry, nd.mnt, name, value, size, flags);
 	mnt_drop_write(nd.mnt);
 	path_release(&nd);
 	return error;
@@ -278,7 +278,7 @@ sys_fsetxattr(int fd, char __user *name,
 		goto out_fput;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = setxattr(dentry, name, value, size, flags);
+	error = setxattr(dentry, f->f_vfsmnt, name, value, size, flags);
 	mnt_drop_write(f->f_vfsmnt);
 out_fput:
 	fput(f);
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -48,7 +48,8 @@ struct xattr_handler {
 
 ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
-int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
+int vfs_setxattr(struct dentry *, struct vfsmount *, char *, void *, size_t,
+		 int);
 int vfs_removexattr(struct dentry *, char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);

-- 

