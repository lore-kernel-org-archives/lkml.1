Return-Path: <linux-kernel-owner+w=401wt.eu-S1946104AbXDLJuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946104AbXDLJuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946101AbXDLJtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:49:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:56730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945962AbXDLJkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:40:33 -0400
Message-Id: <20070412090845.969066000@suse.de>
References: <20070412090809.917795000@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 12 Apr 2007 02:08:38 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 29/41] Add a struct vfsmount parameter to vfs_removexattr()
Content-Disposition: inline; filename=vfs-removexattr.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/nfsd/vfs.c         |    3 ++-
 fs/xattr.c            |   12 ++++++------
 include/linux/xattr.h |    2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1992,7 +1992,8 @@ nfsd_set_posix_acl(struct svc_fh *fhp, i
 		if (!S_ISDIR(inode->i_mode) && type == ACL_TYPE_DEFAULT)
 			error = 0;
 		else {
-			error = vfs_removexattr(fhp->fh_dentry, name);
+			error = vfs_removexattr(fhp->fh_dentry,
+						fhp->fh_export->ex_mnt, name);
 			if (error == -ENODATA)
 				error = 0;
 		}
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -166,7 +166,7 @@ vfs_listxattr(struct dentry *dentry, str
 EXPORT_SYMBOL_GPL(vfs_listxattr);
 
 int
-vfs_removexattr(struct dentry *dentry, char *name)
+vfs_removexattr(struct dentry *dentry, struct vfsmount *mnt, char *name)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -437,7 +437,7 @@ sys_flistxattr(int fd, char __user *list
  * Extended attribute REMOVE operations
  */
 static long
-removexattr(struct dentry *d, char __user *name)
+removexattr(struct dentry *dentry, struct vfsmount *mnt, char __user *name)
 {
 	int error;
 	char kname[XATTR_NAME_MAX + 1];
@@ -448,7 +448,7 @@ removexattr(struct dentry *d, char __use
 	if (error < 0)
 		return error;
 
-	return vfs_removexattr(d, kname);
+	return vfs_removexattr(dentry, mnt, kname);
 }
 
 asmlinkage long
@@ -460,7 +460,7 @@ sys_removexattr(char __user *path, char 
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = removexattr(nd.dentry, name);
+	error = removexattr(nd.dentry, nd.mnt, name);
 	path_release(&nd);
 	return error;
 }
@@ -474,7 +474,7 @@ sys_lremovexattr(char __user *path, char
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = removexattr(nd.dentry, name);
+	error = removexattr(nd.dentry, nd.mnt, name);
 	path_release(&nd);
 	return error;
 }
@@ -491,7 +491,7 @@ sys_fremovexattr(int fd, char __user *na
 		return error;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry->d_inode);
-	error = removexattr(dentry, name);
+	error = removexattr(dentry, f->f_path.mnt, name);
 	fput(f);
 	return error;
 }
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -52,7 +52,7 @@ ssize_t vfs_listxattr(struct dentry *d, 
 		      size_t size);
 int vfs_setxattr(struct dentry *, struct vfsmount *, char *, void *, size_t,
 		 int);
-int vfs_removexattr(struct dentry *, char *);
+int vfs_removexattr(struct dentry *, struct vfsmount *, char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);

-- 
