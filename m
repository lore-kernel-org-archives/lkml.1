Return-Path: <linux-kernel-owner+w=401wt.eu-S1763621AbXJZHB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763621AbXJZHB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758865AbXJZG5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:57:17 -0400
Received: from mx1.suse.de ([195.135.220.2]:34777 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759972AbXJZG5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:57:15 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:48 2007
Message-Id: <20071026064048.265163549@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:34 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 10/45] Pass struct vfsmount to the inode_symlink LSM hook
Content-Disposition: inline; filename=security-symlink.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/namei.c               |    2 +-
 include/linux/security.h |    8 +++++---
 security/dummy.c         |    2 +-
 security/security.c      |    4 ++--
 security/selinux/hooks.c |    3 ++-
 5 files changed, 11 insertions(+), 8 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2314,7 +2314,7 @@ int vfs_symlink(struct inode *dir, struc
 	if (!dir->i_op || !dir->i_op->symlink)
 		return -EPERM;
 
-	error = security_inode_symlink(dir, dentry, oldname);
+	error = security_inode_symlink(dir, dentry, mnt, oldname);
 	if (error)
 		return error;
 
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -315,6 +315,7 @@ struct request_sock;
  *	Check the permission to create a symbolic link to a file.
  *	@dir contains the inode structure of parent directory of the symbolic link.
  *	@dentry contains the dentry structure of the symbolic link.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	@old_name contains the pathname of file.
  *	Return 0 if permission is granted.
  * @inode_mkdir:
@@ -1243,8 +1244,8 @@ struct security_operations {
 	int (*inode_link) (struct dentry *old_dentry,
 	                   struct inode *dir, struct dentry *new_dentry);
 	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
-	int (*inode_symlink) (struct inode *dir,
-	                      struct dentry *dentry, const char *old_name);
+	int (*inode_symlink) (struct inode *dir, struct dentry *dentry,
+			      struct vfsmount *mnt, const char *old_name);
 	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry,
 			    struct vfsmount *mnt, int mode);
 	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
@@ -1502,7 +1503,7 @@ int security_inode_link(struct dentry *o
 			 struct dentry *new_dentry);
 int security_inode_unlink(struct inode *dir, struct dentry *dentry);
 int security_inode_symlink(struct inode *dir, struct dentry *dentry,
-			    const char *old_name);
+			   struct vfsmount *mnt, const char *old_name);
 int security_inode_mkdir(struct inode *dir, struct dentry *dentry,
 			 struct vfsmount *mnt, int mode);
 int security_inode_rmdir(struct inode *dir, struct dentry *dentry);
@@ -1831,6 +1832,7 @@ static inline int security_inode_unlink 
 
 static inline int security_inode_symlink (struct inode *dir,
 					  struct dentry *dentry,
+					  struct vfsmount *mnt,
 					  const char *old_name)
 {
 	return 0;
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -279,7 +279,7 @@ static int dummy_inode_unlink (struct in
 }
 
 static int dummy_inode_symlink (struct inode *inode, struct dentry *dentry,
-				const char *name)
+				struct vfsmount *mnt, const char *name)
 {
 	return 0;
 }
--- a/security/security.c
+++ b/security/security.c
@@ -352,11 +352,11 @@ int security_inode_unlink(struct inode *
 }
 
 int security_inode_symlink(struct inode *dir, struct dentry *dentry,
-			    const char *old_name)
+			   struct vfsmount *mnt, const char *old_name)
 {
 	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_symlink(dir, dentry, old_name);
+	return security_ops->inode_symlink(dir, dentry, mnt, old_name);
 }
 
 int security_inode_mkdir(struct inode *dir, struct dentry *dentry,
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2210,7 +2210,8 @@ static int selinux_inode_unlink(struct i
 	return may_link(dir, dentry, MAY_UNLINK);
 }
 
-static int selinux_inode_symlink(struct inode *dir, struct dentry *dentry, const char *name)
+static int selinux_inode_symlink(struct inode *dir, struct dentry *dentry,
+				 struct vfsmount *mnt, const char *name)
 {
 	return may_create(dir, dentry, SECCLASS_LNK_FILE);
 }

-- 

