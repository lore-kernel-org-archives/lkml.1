Return-Path: <linux-kernel-owner+w=401wt.eu-S1760726AbXLTOQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726AbXLTOQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760635AbXLTOLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:11:22 -0500
Received: from ns2.suse.de ([195.135.220.15]:56584 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760402AbXLTOLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:11:19 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:43 2007
Message-Id: <20071220140943.001395767@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:21 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 11/47] Pass struct vfsmount to the inode_readlink LSM hook
Content-Disposition: inline; filename=security-readlink.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/stat.c                |    3 ++-
 include/linux/security.h |    8 +++++---
 security/dummy.c         |    2 +-
 security/security.c      |    4 ++--
 security/selinux/hooks.c |    2 +-
 5 files changed, 11 insertions(+), 8 deletions(-)

--- a/fs/stat.c
+++ b/fs/stat.c
@@ -306,7 +306,8 @@ asmlinkage long sys_readlinkat(int dfd, 
 
 		error = -EINVAL;
 		if (inode->i_op && inode->i_op->readlink) {
-			error = security_inode_readlink(nd.path.dentry);
+			error = security_inode_readlink(nd.path.dentry,
+							nd.path.mnt);
 			if (!error) {
 				touch_atime(nd.path.mnt, nd.path.dentry);
 				error = inode->i_op->readlink(nd.path.dentry,
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -369,6 +369,7 @@ struct request_sock;
  * @inode_readlink:
  *	Check the permission to read the symbolic link.
  *	@dentry contains the dentry structure for the file link.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	Return 0 if permission is granted.
  * @inode_follow_link:
  *	Check permission to follow a symbolic link when looking up a pathname.
@@ -1291,7 +1292,7 @@ struct security_operations {
 			    struct vfsmount *mnt, int mode, dev_t dev);
 	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
 	                     struct inode *new_dir, struct dentry *new_dentry);
-	int (*inode_readlink) (struct dentry *dentry);
+	int (*inode_readlink) (struct dentry *dentry, struct vfsmount *mnt);
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
 	int (*inode_permission) (struct inode *inode, int mask, struct nameidata *nd);
 	int (*inode_setattr) (struct dentry *dentry, struct vfsmount *mnt,
@@ -1557,7 +1558,7 @@ int security_inode_mknod(struct inode *d
 			 struct vfsmount *mnt, int mode, dev_t dev);
 int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
 			   struct inode *new_dir, struct dentry *new_dentry);
-int security_inode_readlink(struct dentry *dentry);
+int security_inode_readlink(struct dentry *dentry, struct vfsmount *mnt);
 int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd);
 int security_inode_permission(struct inode *inode, int mask, struct nameidata *nd);
 int security_inode_setattr(struct dentry *dentry, struct vfsmount *mnt,
@@ -1915,7 +1916,8 @@ static inline int security_inode_rename 
 	return 0;
 }
 
-static inline int security_inode_readlink (struct dentry *dentry)
+static inline int security_inode_readlink(struct dentry *dentry,
+					   struct vfsmount *mnt)
 {
 	return 0;
 }
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -337,7 +337,7 @@ static int dummy_inode_rename (struct in
 	return 0;
 }
 
-static int dummy_inode_readlink (struct dentry *dentry)
+static int dummy_inode_readlink (struct dentry *dentry, struct vfsmount *mnt)
 {
 	return 0;
 }
--- a/security/security.c
+++ b/security/security.c
@@ -412,11 +412,11 @@ int security_inode_rename(struct inode *
 					   new_dir, new_dentry);
 }
 
-int security_inode_readlink(struct dentry *dentry)
+int security_inode_readlink(struct dentry *dentry, struct vfsmount *mnt)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_readlink(dentry);
+	return security_ops->inode_readlink(dentry, mnt);
 }
 
 int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd)
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2472,7 +2472,7 @@ static int selinux_inode_rename(struct i
 	return may_rename(old_inode, old_dentry, new_inode, new_dentry);
 }
 
-static int selinux_inode_readlink(struct dentry *dentry)
+static int selinux_inode_readlink(struct dentry *dentry, struct vfsmount *mnt)
 {
 	return dentry_has_perm(current, NULL, dentry, FILE__READ);
 }

-- 

