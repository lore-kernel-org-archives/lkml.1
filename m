Return-Path: <linux-kernel-owner+w=401wt.eu-S1946096AbXDLJqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946096AbXDLJqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946072AbXDLJqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:46:01 -0400
Received: from mail.suse.de ([195.135.220.2]:57882 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946002AbXDLJkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:40:35 -0400
Message-Id: <20070412090839.382888000@suse.de>
References: <20070412090809.917795000@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 12 Apr 2007 02:08:19 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 10/41] Pass struct vfsmount to the inode_mknod LSM hook
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
 security/selinux/hooks.c |    5 +++--
 4 files changed, 10 insertions(+), 6 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1851,7 +1851,7 @@ int vfs_mknod(struct inode *dir, struct 
 	if (!dir->i_op || !dir->i_op->mknod)
 		return -EPERM;
 
-	error = security_inode_mknod(dir, dentry, mode, dev);
+	error = security_inode_mknod(dir, dentry, mnt, mode, dev);
 	if (error)
 		return error;
 
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -323,6 +323,7 @@ struct request_sock;
  *	and not this hook.
  *	@dir contains the inode structure of parent of the new file.
  *	@dentry contains the dentry structure of the new file.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	@mode contains the mode of the new file.
  *	@dev contains the the device number.
  *	Return 0 if permission is granted.
@@ -1218,7 +1219,7 @@ struct security_operations {
 			    struct vfsmount *mnt, int mode);
 	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
-	                    int mode, dev_t dev);
+			    struct vfsmount *mnt, int mode, dev_t dev);
 	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
 	                     struct inode *new_dir, struct dentry *new_dentry);
 	int (*inode_readlink) (struct dentry *dentry);
@@ -1670,11 +1671,12 @@ static inline int security_inode_rmdir (
 
 static inline int security_inode_mknod (struct inode *dir,
 					struct dentry *dentry,
+					struct vfsmount *mnt,
 					int mode, dev_t dev)
 {
 	if (unlikely (IS_PRIVATE (dir)))
 		return 0;
-	return security_ops->inode_mknod (dir, dentry, mode, dev);
+	return security_ops->inode_mknod (dir, dentry, mnt, mode, dev);
 }
 
 static inline int security_inode_rename (struct inode *old_dir,
@@ -2388,6 +2390,7 @@ static inline int security_inode_rmdir (
 
 static inline int security_inode_mknod (struct inode *dir,
 					struct dentry *dentry,
+					struct vfsmount *mnt,
 					int mode, dev_t dev)
 {
 	return 0;
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -299,7 +299,7 @@ static int dummy_inode_rmdir (struct ino
 }
 
 static int dummy_inode_mknod (struct inode *inode, struct dentry *dentry,
-			      int mode, dev_t dev)
+			      struct vfsmount *mnt, int mode, dev_t dev)
 {
 	return 0;
 }
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2220,11 +2220,12 @@ static int selinux_inode_rmdir(struct in
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
