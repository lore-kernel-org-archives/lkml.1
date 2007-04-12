Return-Path: <linux-kernel-owner+w=401wt.eu-S965526AbXDLJ4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965526AbXDLJ4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161583AbXDLJyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:54:31 -0400
Received: from mx1.suse.de ([195.135.220.2]:57876 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945974AbXDLJkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:40:32 -0400
Message-Id: <20070412090841.747306000@suse.de>
References: <20070412090809.917795000@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 12 Apr 2007 02:08:26 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 17/41] Pass struct vfsmount to the inode_rmdir LSM hook
Content-Disposition: inline; filename=security-rmdir.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/namei.c               |    2 +-
 include/linux/security.h |   12 ++++++++----
 security/dummy.c         |    3 ++-
 security/selinux/hooks.c |    3 ++-
 4 files changed, 13 insertions(+), 7 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2023,7 +2023,7 @@ int vfs_rmdir(struct inode *dir, struct 
 	if (d_mountpoint(dentry))
 		error = -EBUSY;
 	else {
-		error = security_inode_rmdir(dir, dentry);
+		error = security_inode_rmdir(dir, dentry, mnt);
 		if (!error) {
 			error = dir->i_op->rmdir(dir, dentry);
 			if (!error)
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -318,6 +318,7 @@ struct request_sock;
  *	Check the permission to remove a directory.
  *	@dir contains the inode structure of parent of the directory to be removed.
  *	@dentry contains the dentry structure of directory to be removed.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	Return 0 if permission is granted.
  * @inode_mknod:
  *	Check permissions when creating a special file (or a socket or a fifo
@@ -1222,7 +1223,8 @@ struct security_operations {
 			      struct vfsmount *mnt, const char *old_name);
 	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry,
 			    struct vfsmount *mnt, int mode);
-	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
+	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry,
+			    struct vfsmount *mnt);
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
 			    struct vfsmount *mnt, int mode, dev_t dev);
 	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
@@ -1671,11 +1673,12 @@ static inline int security_inode_mkdir (
 }
 
 static inline int security_inode_rmdir (struct inode *dir,
-					struct dentry *dentry)
+					struct dentry *dentry,
+					struct vfsmount *mnt)
 {
 	if (unlikely (IS_PRIVATE (dentry->d_inode)))
 		return 0;
-	return security_ops->inode_rmdir (dir, dentry);
+	return security_ops->inode_rmdir (dir, dentry, mnt);
 }
 
 static inline int security_inode_mknod (struct inode *dir,
@@ -2396,7 +2399,8 @@ static inline int security_inode_mkdir (
 }
 
 static inline int security_inode_rmdir (struct inode *dir,
-					struct dentry *dentry)
+					struct dentry *dentry,
+					struct vfsmount *mnt)
 {
 	return 0;
 }
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -295,7 +295,8 @@ static int dummy_inode_mkdir (struct ino
 	return 0;
 }
 
-static int dummy_inode_rmdir (struct inode *inode, struct dentry *dentry)
+static int dummy_inode_rmdir (struct inode *inode, struct dentry *dentry,
+			      struct vfsmount *mnt)
 {
 	return 0;
 }
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2221,7 +2221,8 @@ static int selinux_inode_mkdir(struct in
 	return may_create(dir, dentry, SECCLASS_DIR);
 }
 
-static int selinux_inode_rmdir(struct inode *dir, struct dentry *dentry)
+static int selinux_inode_rmdir(struct inode *dir, struct dentry *dentry,
+			       struct vfsmount *mnt)
 {
 	return may_link(dir, dentry, MAY_RMDIR);
 }

-- 
