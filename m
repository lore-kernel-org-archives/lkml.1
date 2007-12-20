Return-Path: <linux-kernel-owner+w=401wt.eu-S933416AbXLTOOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416AbXLTOOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932818AbXLTOLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:11:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:56540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197AbXLTOLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:11:07 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:42 2007
Message-Id: <20071220140942.617423691@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:18 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 08/47] Pass struct vfsmount to the inode_mknod LSM hook
Content-Disposition: inline; filename=security-mknod.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
@@ -2019,7 +2019,7 @@ int vfs_mknod(struct inode *dir, struct 
 	if (!dir->i_op || !dir->i_op->mknod)
 		return -EPERM;
 
-	error = security_inode_mknod(dir, dentry, mode, dev);
+	error = security_inode_mknod(dir, dentry, mnt, mode, dev);
 	if (error)
 		return error;
 
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -354,6 +354,7 @@ struct request_sock;
  *	and not this hook.
  *	@dir contains the inode structure of parent of the new file.
  *	@dentry contains the dentry structure of the new file.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	@mode contains the mode of the new file.
  *	@dev contains the device number.
  *	Return 0 if permission is granted.
@@ -1286,7 +1287,7 @@ struct security_operations {
 			    struct vfsmount *mnt, int mode);
 	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
-	                    int mode, dev_t dev);
+			    struct vfsmount *mnt, int mode, dev_t dev);
 	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
 	                     struct inode *new_dir, struct dentry *new_dentry);
 	int (*inode_readlink) (struct dentry *dentry);
@@ -1551,7 +1552,8 @@ int security_inode_symlink(struct inode 
 int security_inode_mkdir(struct inode *dir, struct dentry *dentry,
 			 struct vfsmount *mnt, int mode);
 int security_inode_rmdir(struct inode *dir, struct dentry *dentry);
-int security_inode_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev);
+int security_inode_mknod(struct inode *dir, struct dentry *dentry,
+			 struct vfsmount *mnt, int mode, dev_t dev);
 int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
 			   struct inode *new_dir, struct dentry *new_dentry);
 int security_inode_readlink(struct dentry *dentry);
@@ -1897,6 +1899,7 @@ static inline int security_inode_rmdir (
 
 static inline int security_inode_mknod (struct inode *dir,
 					struct dentry *dentry,
+					struct vfsmount *mnt,
 					int mode, dev_t dev)
 {
 	return 0;
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -324,7 +324,7 @@ static int dummy_inode_rmdir (struct ino
 }
 
 static int dummy_inode_mknod (struct inode *inode, struct dentry *dentry,
-			      int mode, dev_t dev)
+			      struct vfsmount *mnt, int mode, dev_t dev)
 {
 	return 0;
 }
--- a/security/security.c
+++ b/security/security.c
@@ -394,11 +394,12 @@ int security_inode_rmdir(struct inode *d
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
@@ -2453,11 +2453,12 @@ static int selinux_inode_rmdir(struct in
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

