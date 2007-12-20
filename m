Return-Path: <linux-kernel-owner+w=401wt.eu-S1764191AbXLTOVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764191AbXLTOVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933014AbXLTOMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:12:05 -0500
Received: from ns1.suse.de ([195.135.220.2]:40794 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007AbXLTOMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:12:01 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:44 2007
Message-Id: <20071220140944.629036786@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:31 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 21/47] Add a struct vfsmount parameter to vfs_setxattr()
Content-Disposition: inline; filename=vfs-setxattr.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/nfsd/vfs.c         |   16 +++++++++++-----
 fs/unionfs/copyup.c   |   18 ++++++++++++------
 fs/unionfs/xattr.c    |    7 +++++--
 fs/xattr.c            |   16 ++++++++--------
 include/linux/xattr.h |    3 ++-
 5 files changed, 38 insertions(+), 22 deletions(-)

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
+	mnt = fhp->fh_export->ex_path.mnt;
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
@@ -2057,7 +2062,8 @@ nfsd_set_posix_acl(struct svc_fh *fhp, i
 		size = 0;
 
 	if (size)
-		error = vfs_setxattr(fhp->fh_dentry, name, value, size, 0);
+		error = vfs_setxattr(fhp->fh_dentry, fhp->fh_export->ex_path.mnt,
+				     name, value, size,0);
 	else {
 		if (!S_ISDIR(inode->i_mode) && type == ACL_TYPE_DEFAULT)
 			error = 0;
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -26,7 +26,9 @@
 #ifdef CONFIG_UNION_FS_XATTR
 /* copyup all extended attrs for a given dentry */
 static int copyup_xattrs(struct dentry *old_lower_dentry,
-			 struct dentry *new_lower_dentry)
+			 struct vfsmount *old_lower_mnt,
+			 struct dentry *new_lower_dentry,
+			 struct vfsmount *new_lower_mnt)
 {
 	int err = 0;
 	ssize_t list_size = -1;
@@ -82,8 +84,8 @@ static int copyup_xattrs(struct dentry *
 			goto out;
 		}
 		/* Don't lock here since vfs_setxattr does it for us. */
-		err = vfs_setxattr(new_lower_dentry, name_list, attr_value,
-				   size, 0);
+		err = vfs_setxattr(new_lower_dentry, new_lower_mnt, name_list,
+				   attr_value, size, 0);
 		/*
 		 * Selinux depends on "security.*" xattrs, so to maintain
 		 * the security of copied-up files, if Selinux is active,
@@ -93,8 +95,8 @@ static int copyup_xattrs(struct dentry *
 		 */
 		if (err == -EPERM && !capable(CAP_FOWNER)) {
 			cap_raise(current->cap_effective, CAP_FOWNER);
-			err = vfs_setxattr(new_lower_dentry, name_list,
-					   attr_value, size, 0);
+			err = vfs_setxattr(new_lower_dentry, new_lower_mnt,
+					   name_list, attr_value, size, 0);
 			cap_lower(current->cap_effective, CAP_FOWNER);
 		}
 		if (err < 0)
@@ -380,6 +382,7 @@ int copyup_dentry(struct inode *dir, str
 	struct dentry *new_lower_dentry;
 	struct vfsmount *new_lower_mnt;
 	struct dentry *old_lower_dentry = NULL;
+	struct vfsmount *old_lower_mnt;
 	struct super_block *sb;
 	int err = 0;
 	int old_bindex;
@@ -413,6 +416,8 @@ int copyup_dentry(struct inode *dir, str
 	}
 
 	old_lower_dentry = unionfs_lower_dentry_idx(dentry, old_bindex);
+	old_lower_mnt = unionfs_lower_mnt_idx(dentry, old_bindex);
+
 	/* we conditionally dput this old_lower_dentry at end of function */
 	dget(old_lower_dentry);
 
@@ -474,7 +479,8 @@ int copyup_dentry(struct inode *dir, str
 
 #ifdef CONFIG_UNION_FS_XATTR
 	/* Selinux uses extended attributes for permissions. */
-	err = copyup_xattrs(old_lower_dentry, new_lower_dentry);
+	err = copyup_xattrs(old_lower_dentry, old_lower_mnt, 
+			    new_lower_dentry, new_lower_mnt);
 	if (err)
 		goto out_unlink;
 #endif /* CONFIG_UNION_FS_XATTR */
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -72,6 +72,8 @@ int unionfs_setxattr(struct dentry *dent
 		     const void *value, size_t size, int flags)
 {
 	struct dentry *lower_dentry = NULL;
+	struct vfsmount *lower_mnt;
+
 	int err = -EOPNOTSUPP;
 
 	unionfs_read_lock(dentry->d_sb);
@@ -83,9 +85,10 @@ int unionfs_setxattr(struct dentry *dent
 	}
 
 	lower_dentry = unionfs_lower_dentry(dentry);
+	lower_mnt = unionfs_lower_mnt(dentry);
 
-	err = vfs_setxattr(lower_dentry, (char *) name, (void *) value,
-			   size, flags);
+	err = vfs_setxattr(lower_dentry, lower_mnt, (char *) name,
+			   (void *) value, size, flags);
 
 out:
 	unionfs_check_dentry(dentry);
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
@@ -218,8 +218,8 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
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
@@ -246,7 +246,7 @@ setxattr(struct dentry *d, char __user *
 		}
 	}
 
-	error = vfs_setxattr(d, kname, kvalue, size, flags);
+	error = vfs_setxattr(dentry, mnt, kname, kvalue, size, flags);
 	kfree(kvalue);
 	return error;
 }
@@ -264,7 +264,7 @@ sys_setxattr(char __user *path, char __u
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		return error;
-	error = setxattr(nd.path.dentry, name, value, size, flags);
+	error = setxattr(nd.path.dentry, nd.path.mnt, name, value, size, flags);
 	mnt_drop_write(nd.path.mnt);
 	path_put(&nd.path);
 	return error;
@@ -283,7 +283,7 @@ sys_lsetxattr(char __user *path, char __
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		return error;
-	error = setxattr(nd.path.dentry, name, value, size, flags);
+	error = setxattr(nd.path.dentry, nd.path.mnt, name, value, size, flags);
 	mnt_drop_write(nd.path.mnt);
 	path_put(&nd.path);
 	return error;
@@ -305,7 +305,7 @@ sys_fsetxattr(int fd, char __user *name,
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
@@ -49,7 +49,8 @@ struct xattr_handler {
 ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
 ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
-int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
+int vfs_setxattr(struct dentry *, struct vfsmount *, char *, void *, size_t,
+		 int);
 int vfs_removexattr(struct dentry *, char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);

-- 

