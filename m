Return-Path: <linux-kernel-owner+w=401wt.eu-S1760694AbXFZXTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694AbXFZXTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760135AbXFZXL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:11:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760106AbXFZXLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:11:19 -0400
Message-Id: <20070626231035.645550632@suse.de>
References: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:08:21 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 25/44] Add a struct vfsmount parameter to vfs_listxattr()
Content-Disposition: inline; filename=vfs-listxattr.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/xattr.c            |   25 ++++++++++++++-----------
 include/linux/xattr.h |    3 ++-
 2 files changed, 16 insertions(+), 12 deletions(-)

--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -143,18 +143,20 @@ vfs_getxattr(struct dentry *dentry, stru
 EXPORT_SYMBOL_GPL(vfs_getxattr);
 
 ssize_t
-vfs_listxattr(struct dentry *d, char *list, size_t size)
+vfs_listxattr(struct dentry *dentry, struct vfsmount *mnt, char *list,
+	      size_t size)
 {
+	struct inode *inode = dentry->d_inode;
 	ssize_t error;
 
-	error = security_inode_listxattr(d);
+	error = security_inode_listxattr(dentry);
 	if (error)
 		return error;
 	error = -EOPNOTSUPP;
-	if (d->d_inode->i_op && d->d_inode->i_op->listxattr) {
-		error = d->d_inode->i_op->listxattr(d, list, size);
-	} else {
-		error = security_inode_listsecurity(d->d_inode, list, size);
+	if (inode->i_op && inode->i_op->listxattr)
+		error = inode->i_op->listxattr(dentry, list, size);
+	else {
+		error = security_inode_listsecurity(inode, list, size);
 		if (size && error > size)
 			error = -ERANGE;
 	}
@@ -362,7 +364,8 @@ sys_fgetxattr(int fd, char __user *name,
  * Extended attribute LIST operations
  */
 static ssize_t
-listxattr(struct dentry *d, char __user *list, size_t size)
+listxattr(struct dentry *dentry, struct vfsmount *mnt, char __user *list,
+	  size_t size)
 {
 	ssize_t error;
 	char *klist = NULL;
@@ -375,7 +378,7 @@ listxattr(struct dentry *d, char __user 
 			return -ENOMEM;
 	}
 
-	error = vfs_listxattr(d, klist, size);
+	error = vfs_listxattr(dentry, mnt, klist, size);
 	if (error > 0) {
 		if (size && copy_to_user(list, klist, error))
 			error = -EFAULT;
@@ -397,7 +400,7 @@ sys_listxattr(char __user *path, char __
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = listxattr(nd.dentry, list, size);
+	error = listxattr(nd.dentry, nd.mnt, list, size);
 	path_release(&nd);
 	return error;
 }
@@ -411,7 +414,7 @@ sys_llistxattr(char __user *path, char _
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = listxattr(nd.dentry, list, size);
+	error = listxattr(nd.dentry, nd.mnt, list, size);
 	path_release(&nd);
 	return error;
 }
@@ -426,7 +429,7 @@ sys_flistxattr(int fd, char __user *list
 	if (!f)
 		return error;
 	audit_inode(NULL, f->f_path.dentry->d_inode);
-	error = listxattr(f->f_path.dentry, list, size);
+	error = listxattr(f->f_path.dentry, f->f_path.mnt, list, size);
 	fput(f);
 	return error;
 }
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -48,7 +48,8 @@ struct xattr_handler {
 
 ssize_t vfs_getxattr(struct dentry *, struct vfsmount *, char *, void *,
 		     size_t);
-ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
+ssize_t vfs_listxattr(struct dentry *d, struct vfsmount *, char *list,
+		      size_t size);
 int vfs_setxattr(struct dentry *, struct vfsmount *, char *, void *, size_t,
 		 int);
 int vfs_removexattr(struct dentry *, char *);

-- 
