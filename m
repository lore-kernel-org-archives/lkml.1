Return-Path: <linux-kernel-owner+w=401wt.eu-S1762662AbXJZHAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662AbXJZHAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759903AbXJZG5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:57:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759496AbXJZG5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:57:07 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:48 2007
Message-Id: <20071026064047.972701404@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:32 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 08/45] Pass struct vfsmount to the inode_mknod LSM hook
Content-Disposition: inline; filename=security-mknod.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/namei.c               |    2 +-
 include/linux/security.h |    7 +++++--
 security/dummy.c         |    2 +-
 security/security.c      |    5 +++--
 security/selinux/hooks.c |    5 +++--
 5 files changed, 13 insertions(+), 8 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1945,7 +1945,7 @@ int vfs_mknod(struct inode *dir, struct 
 	if (!dir->i_op || !dir->i_op->mknod)
 		return -EPERM;
 
-	error = security_inode_mknod(dir, dentry, mode, dev);
+	error = security_inode_mknod(dir, dentry, mnt, mode, dev);
 	if (error)
 		return error;
 
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -337,6 +337,7 @@ struct request_sock;
  *	and not this hook.
  *	@dir contains the inode structure of parent of the new file.
  *	@dentry contains the dentry structure of the new file.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	@mode contains the mode of the new file.
  *	@dev contains the device number.
  *	Return 0 if permission is granted.
@@ -1248,7 +1249,7 @@ struct security_operations {
 			    struct vfsmount *mnt, int mode);
 	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
-	                    int mode, dev_t dev);
+			    struct vfsmount *mnt, int mode, dev_t dev);
 	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
 	                     struct inode *new_dir, struct dentry *new_dentry);
 	int (*inode_readlink) (struct dentry *dentry);
@@ -1505,7 +1506,8 @@ int security_inode_symlink(struct inode 
 int security_inode_mkdir(struct inode *dir, struct dentry *dentry,
 			 struct vfsmount *mnt, int mode);
 int security_inode_rmdir(struct inode *dir, struct dentry *dentry);
-int security_inode_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev);
+int security_inode_mknod(struct inode *dir, struct dentry *dentry,
+			 struct vfsmount *mnt, int mode, dev_t dev);
 int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
 			   struct inode *new_dir, struct dentry *new_dentry);
 int security_inode_readlink(struct dentry *dentry);
@@ -1850,6 +1852,7 @@ static inline int security_inode_rmdir (
 
 static inline int security_inode_mknod (struct inode *dir,
 					struct dentry *dentry,
+					struct vfsmount *mnt,
 					int mode, dev_t dev)
 {
 	return 0;
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -296,7 +296,7 @@ static int dummy_inode_rmdir (struct ino
 }
 
 static int dummy_inode_mknod (struct inode *inode, struct dentry *dentry,
-			      int mode, dev_t dev)
+			      struct vfsmount *mnt, int mode, dev_t dev)
 {
 	return 0;
 }
--- a/security/security.c
+++ b/security/security.c
@@ -374,11 +374,12 @@ int security_inode_rmdir(struct inode *d
 	return security_ops->inode_rmdir(dir, dentry);
 }
 
-int security_inode_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+int security_inode_mknod(struct inode *dir, struct dentry *dentry,
+			 struct vfsmount *mnt, int mode, dev_t dev)
 {
 	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_mknod(dir, dentry, mode, dev);
+	return security_ops->inode_mknod(dir, dentry, mnt, mode, dev);
 }
 
 int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2226,11 +2226,12 @@ static int selinux_inode_rmdir(struct in
 	return may_link(dir, dentry, MAY_RMDIR);
 }
 
-static int selinux_inode_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+static int selinux_inode_mknod(struct inode *dir, struct dentry *dentry,
+			       struct vfsmount *mnt, int mode, dev_t dev)
 {
 	int rc;
 
-	rc = secondary_ops->inode_mknod(dir, dentry, mode, dev);
+	rc = secondary_ops->inode_mknod(dir, dentry, mnt, mode, dev);
 	if (rc)
 		return rc;
 

-- 

