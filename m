Return-Path: <linux-kernel-owner+w=401wt.eu-S1030319AbXENLhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030319AbXENLhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966051AbXENLc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:32:56 -0400
Received: from 213.210.179.104.adsl.nextra.cz ([213.210.179.104]:27933 "EHLO
	duck8.pdx.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758353AbXENLc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:32:29 -0400
Message-Id: <20070514110609.924651217@suse.de>
References: <20070514110607.549397248@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 14 May 2007 04:06:13 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 06/45] Pass struct vfsmount to the inode_mkdir LSM hook
Content-Disposition: inline; filename=security-mkdir.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/namei.c               |    2 +-
 include/linux/security.h |    8 ++++++--
 security/dummy.c         |    2 +-
 security/selinux/hooks.c |    3 ++-
 4 files changed, 10 insertions(+), 5 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1946,7 +1946,7 @@ int vfs_mkdir(struct inode *dir, struct 
 		return -EPERM;
 
 	mode &= (S_IRWXUGO|S_ISVTX);
-	error = security_inode_mkdir(dir, dentry, mode);
+	error = security_inode_mkdir(dir, dentry, mnt, mode);
 	if (error)
 		return error;
 
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -308,6 +308,7 @@ struct request_sock;
  *	associated with inode strcture @dir. 
  *	@dir containst the inode structure of parent of the directory to be created.
  *	@dentry contains the dentry structure of new directory.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	@mode contains the mode of new directory.
  *	Return 0 if permission is granted.
  * @inode_rmdir:
@@ -1213,7 +1214,8 @@ struct security_operations {
 	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
 	int (*inode_symlink) (struct inode *dir,
 	                      struct dentry *dentry, const char *old_name);
-	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry, int mode);
+	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry,
+			    struct vfsmount *mnt, int mode);
 	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
 	                    int mode, dev_t dev);
@@ -1650,11 +1652,12 @@ static inline int security_inode_symlink
 
 static inline int security_inode_mkdir (struct inode *dir,
 					struct dentry *dentry,
+					struct vfsmount *mnt,
 					int mode)
 {
 	if (unlikely (IS_PRIVATE (dir)))
 		return 0;
-	return security_ops->inode_mkdir (dir, dentry, mode);
+	return security_ops->inode_mkdir (dir, dentry, mnt, mode);
 }
 
 static inline int security_inode_rmdir (struct inode *dir,
@@ -2371,6 +2374,7 @@ static inline int security_inode_symlink
 
 static inline int security_inode_mkdir (struct inode *dir,
 					struct dentry *dentry,
+					struct vfsmount *mnt,
 					int mode)
 {
 	return 0;
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -288,7 +288,7 @@ static int dummy_inode_symlink (struct i
 }
 
 static int dummy_inode_mkdir (struct inode *inode, struct dentry *dentry,
-			      int mask)
+			      struct vfsmount *mnt, int mask)
 {
 	return 0;
 }
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2207,7 +2207,8 @@ static int selinux_inode_symlink(struct 
 	return may_create(dir, dentry, SECCLASS_LNK_FILE);
 }
 
-static int selinux_inode_mkdir(struct inode *dir, struct dentry *dentry, int mask)
+static int selinux_inode_mkdir(struct inode *dir, struct dentry *dentry,
+			       struct vfsmount *mnt, int mask)
 {
 	return may_create(dir, dentry, SECCLASS_DIR);
 }

-- 
