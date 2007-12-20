Return-Path: <linux-kernel-owner+w=401wt.eu-S934321AbXLTOYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934321AbXLTOYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932866AbXLTOM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:12:27 -0500
Received: from ns1.suse.de ([195.135.220.2]:40824 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012AbXLTOMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:12:25 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:45 2007
Message-Id: <20071220140945.488810901@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:37 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 27/47] Add a struct vfsmount parameter to vfs_removexattr()
Content-Disposition: inline; filename=vfs-removexattr.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/nfsd/vfs.c         |    7 ++++---
 fs/unionfs/xattr.c    |    4 +++-
 fs/xattr.c            |   12 ++++++------
 include/linux/xattr.h |    2 +-
 4 files changed, 14 insertions(+), 11 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -2032,6 +2032,7 @@ nfsd_get_posix_acl(struct svc_fh *fhp, i
 int
 nfsd_set_posix_acl(struct svc_fh *fhp, int type, struct posix_acl *acl)
 {
+	struct vfsmount *mnt;
 	struct inode *inode = fhp->fh_dentry->d_inode;
 	char *name;
 	void *value = NULL;
@@ -2064,14 +2065,14 @@ nfsd_set_posix_acl(struct svc_fh *fhp, i
 	} else
 		size = 0;
 
+	mnt = fhp->fh_export->ex_path.mnt;
 	if (size)
-		error = vfs_setxattr(fhp->fh_dentry, fhp->fh_export->ex_path.mnt,
-				     name, value, size,0);
+		error = vfs_setxattr(fhp->fh_dentry, mnt, name, value, size, 0);
 	else {
 		if (!S_ISDIR(inode->i_mode) && type == ACL_TYPE_DEFAULT)
 			error = 0;
 		else {
-			error = vfs_removexattr(fhp->fh_dentry, name);
+			error = vfs_removexattr(fhp->fh_dentry, mnt, name);
 			if (error == -ENODATA)
 				error = 0;
 		}
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -106,6 +106,7 @@ out:
 int unionfs_removexattr(struct dentry *dentry, const char *name)
 {
 	struct dentry *lower_dentry = NULL;
+	struct vfsmount *lower_mnt;
 	int err = -EOPNOTSUPP;
 
 	unionfs_read_lock(dentry->d_sb);
@@ -117,8 +118,9 @@ int unionfs_removexattr(struct dentry *d
 	}
 
 	lower_dentry = unionfs_lower_dentry(dentry);
+	lower_mnt = unionfs_lower_mnt(dentry);
 
-	err = vfs_removexattr(lower_dentry, (char *) name);
+	err = vfs_removexattr(lower_dentry, lower_mnt, (char *) name);
 
 out:
 	unionfs_check_dentry(dentry);
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -190,7 +190,7 @@ vfs_listxattr(struct dentry *dentry, str
 EXPORT_SYMBOL_GPL(vfs_listxattr);
 
 int
-vfs_removexattr(struct dentry *dentry, char *name)
+vfs_removexattr(struct dentry *dentry, struct vfsmount *mnt, char *name)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -476,7 +476,7 @@ sys_flistxattr(int fd, char __user *list
  * Extended attribute REMOVE operations
  */
 static long
-removexattr(struct dentry *d, char __user *name)
+removexattr(struct dentry *dentry, struct vfsmount *mnt, char __user *name)
 {
 	int error;
 	char kname[XATTR_NAME_MAX + 1];
@@ -487,7 +487,7 @@ removexattr(struct dentry *d, char __use
 	if (error < 0)
 		return error;
 
-	return vfs_removexattr(d, kname);
+	return vfs_removexattr(dentry, mnt, kname);
 }
 
 asmlinkage long
@@ -499,7 +499,7 @@ sys_removexattr(char __user *path, char 
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = removexattr(nd.path.dentry, name);
+	error = removexattr(nd.path.dentry, nd.path.mnt, name);
 	path_put(&nd.path);
 	return error;
 }
@@ -513,7 +513,7 @@ sys_lremovexattr(char __user *path, char
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = removexattr(nd.path.dentry, name);
+	error = removexattr(nd.path.dentry, nd.path.mnt, name);
 	path_put(&nd.path);
 	return error;
 }
@@ -530,7 +530,7 @@ sys_fremovexattr(int fd, char __user *na
 		return error;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = removexattr(dentry, name);
+	error = removexattr(dentry, f->f_path.mnt, name);
 	fput(f);
 	return error;
 }
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -51,7 +51,7 @@ ssize_t vfs_getxattr(struct dentry *, st
 ssize_t vfs_listxattr(struct dentry *d, struct vfsmount *, char *list, size_t size);
 int vfs_setxattr(struct dentry *, struct vfsmount *, char *, void *, size_t,
 		 int);
-int vfs_removexattr(struct dentry *, char *);
+int vfs_removexattr(struct dentry *, struct vfsmount *, char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);

-- 

