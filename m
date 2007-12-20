Return-Path: <linux-kernel-owner+w=401wt.eu-S934118AbXLTOX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118AbXLTOX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932895AbXLTOMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:12:20 -0500
Received: from ns2.suse.de ([195.135.220.15]:56753 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933045AbXLTOMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:12:17 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:45 2007
Message-Id: <20071220140945.181799430@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:35 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 25/47] Add a struct vfsmount parameter to vfs_listxattr()
Content-Disposition: inline; filename=vfs-listxattr.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/unionfs/copyup.c   |    5 +++--
 fs/unionfs/xattr.c    |    4 +++-
 fs/xattr.c            |   25 ++++++++++++++-----------
 include/linux/xattr.h |    2 +-
 4 files changed, 21 insertions(+), 15 deletions(-)

--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -37,7 +37,7 @@ static int copyup_xattrs(struct dentry *
 	char *name_list_buf = NULL;
 
 	/* query the actual size of the xattr list */
-	list_size = vfs_listxattr(old_lower_dentry, NULL, 0);
+	list_size = vfs_listxattr(old_lower_dentry, old_lower_mnt, NULL, 0);
 	if (list_size <= 0) {
 		err = list_size;
 		goto out;
@@ -53,7 +53,8 @@ static int copyup_xattrs(struct dentry *
 	name_list_buf = name_list; /* save for kfree at end */
 
 	/* now get the actual xattr list of the source file */
-	list_size = vfs_listxattr(old_lower_dentry, name_list, list_size);
+	list_size = vfs_listxattr(old_lower_dentry, old_lower_mnt, name_list,
+				  list_size);
 	if (list_size <= 0) {
 		err = list_size;
 		goto out;
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -134,6 +134,7 @@ out:
 ssize_t unionfs_listxattr(struct dentry *dentry, char *list, size_t size)
 {
 	struct dentry *lower_dentry = NULL;
+	struct vfsmount *lower_mnt;
 	int err = -EOPNOTSUPP;
 	char *encoded_list = NULL;
 
@@ -146,9 +147,10 @@ ssize_t unionfs_listxattr(struct dentry 
 	}
 
 	lower_dentry = unionfs_lower_dentry(dentry);
+	lower_mnt = unionfs_lower_mnt(dentry);
 
 	encoded_list = list;
-	err = vfs_listxattr(lower_dentry, encoded_list, size);
+	err = vfs_listxattr(lower_dentry, lower_mnt, encoded_list, size);
 
 out:
 	unionfs_check_dentry(dentry);
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -168,18 +168,20 @@ nolsm:
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
@@ -400,7 +402,8 @@ sys_fgetxattr(int fd, char __user *name,
  * Extended attribute LIST operations
  */
 static ssize_t
-listxattr(struct dentry *d, char __user *list, size_t size)
+listxattr(struct dentry *dentry, struct vfsmount *mnt, char __user *list,
+	  size_t size)
 {
 	ssize_t error;
 	char *klist = NULL;
@@ -413,7 +416,7 @@ listxattr(struct dentry *d, char __user 
 			return -ENOMEM;
 	}
 
-	error = vfs_listxattr(d, klist, size);
+	error = vfs_listxattr(dentry, mnt, klist, size);
 	if (error > 0) {
 		if (size && copy_to_user(list, klist, error))
 			error = -EFAULT;
@@ -435,7 +438,7 @@ sys_listxattr(char __user *path, char __
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = listxattr(nd.path.dentry, list, size);
+	error = listxattr(nd.path.dentry, nd.path.mnt, list, size);
 	path_put(&nd.path);
 	return error;
 }
@@ -449,7 +452,7 @@ sys_llistxattr(char __user *path, char _
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = listxattr(nd.path.dentry, list, size);
+	error = listxattr(nd.path.dentry, nd.path.mnt, list, size);
 	path_put(&nd.path);
 	return error;
 }
@@ -464,7 +467,7 @@ sys_flistxattr(int fd, char __user *list
 	if (!f)
 		return error;
 	audit_inode(NULL, f->f_path.dentry);
-	error = listxattr(f->f_path.dentry, list, size);
+	error = listxattr(f->f_path.dentry, f->f_path.mnt, list, size);
 	fput(f);
 	return error;
 }
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -48,7 +48,7 @@ struct xattr_handler {
 
 ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
 ssize_t vfs_getxattr(struct dentry *, struct vfsmount *, char *, void *, size_t);
-ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
+ssize_t vfs_listxattr(struct dentry *d, struct vfsmount *, char *list, size_t size);
 int vfs_setxattr(struct dentry *, struct vfsmount *, char *, void *, size_t,
 		 int);
 int vfs_removexattr(struct dentry *, char *);

-- 

