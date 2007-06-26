Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbXFZXPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbXFZXPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759592AbXFZXKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:10:34 -0400
Received: from ns2.suse.de ([195.135.220.15]:53708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758221AbXFZXKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:10:24 -0400
Message-Id: <20070626230937.338605468@suse.de>
References: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:08:07 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 11/44] Pass struct vfsmount to the inode_readlink LSM hook
Content-Disposition: inline; filename=security-readlink.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/stat.c                |    2 +-
 include/linux/security.h |   11 +++++++----
 security/dummy.c         |    2 +-
 security/selinux/hooks.c |    2 +-
 4 files changed, 10 insertions(+), 7 deletions(-)

--- a/fs/stat.c
+++ b/fs/stat.c
@@ -306,7 +306,7 @@ asmlinkage long sys_readlinkat(int dfd, 
 
 		error = -EINVAL;
 		if (inode->i_op && inode->i_op->readlink) {
-			error = security_inode_readlink(nd.dentry);
+			error = security_inode_readlink(nd.dentry, nd.mnt);
 			if (!error) {
 				touch_atime(nd.mnt, nd.dentry);
 				error = inode->i_op->readlink(nd.dentry, buf, bufsiz);
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -338,6 +338,7 @@ struct request_sock;
  * @inode_readlink:
  *	Check the permission to read the symbolic link.
  *	@dentry contains the dentry structure for the file link.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	Return 0 if permission is granted.
  * @inode_follow_link:
  *	Check permission to follow a symbolic link when looking up a pathname.
@@ -1223,7 +1224,7 @@ struct security_operations {
 			    struct vfsmount *mnt, int mode, dev_t dev);
 	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
 	                     struct inode *new_dir, struct dentry *new_dentry);
-	int (*inode_readlink) (struct dentry *dentry);
+	int (*inode_readlink) (struct dentry *dentry, struct vfsmount *mnt);
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
 	int (*inode_permission) (struct inode *inode, int mask, struct nameidata *nd);
 	int (*inode_setattr) (struct dentry *dentry, struct vfsmount *mnt,
@@ -1693,11 +1694,12 @@ static inline int security_inode_rename 
 					   new_dir, new_dentry);
 }
 
-static inline int security_inode_readlink (struct dentry *dentry)
+static inline int security_inode_readlink (struct dentry *dentry,
+					   struct vfsmount *mnt)
 {
 	if (unlikely (IS_PRIVATE (dentry->d_inode)))
 		return 0;
-	return security_ops->inode_readlink (dentry);
+	return security_ops->inode_readlink (dentry, mnt);
 }
 
 static inline int security_inode_follow_link (struct dentry *dentry,
@@ -2407,7 +2409,8 @@ static inline int security_inode_rename 
 	return 0;
 }
 
-static inline int security_inode_readlink (struct dentry *dentry)
+static inline int security_inode_readlink (struct dentry *dentry,
+					   struct vfsmount *mnt)
 {
 	return 0;
 }
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -312,7 +312,7 @@ static int dummy_inode_rename (struct in
 	return 0;
 }
 
-static int dummy_inode_readlink (struct dentry *dentry)
+static int dummy_inode_readlink (struct dentry *dentry, struct vfsmount *mnt)
 {
 	return 0;
 }
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2237,7 +2237,7 @@ static int selinux_inode_rename(struct i
 	return may_rename(old_inode, old_dentry, new_inode, new_dentry);
 }
 
-static int selinux_inode_readlink(struct dentry *dentry)
+static int selinux_inode_readlink(struct dentry *dentry, struct vfsmount *mnt)
 {
 	return dentry_has_perm(current, NULL, dentry, FILE__READ);
 }

-- 
