Return-Path: <linux-kernel-owner+w=401wt.eu-S1764020AbXJZHE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764020AbXJZHE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759768AbXJZG6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:58:01 -0400
Received: from ns1.suse.de ([195.135.220.2]:34838 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759759AbXJZG54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:57:56 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:49 2007
Message-Id: <20071026064049.681410838@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:44 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 20/45] Pass struct vfsmount to the inode_rename LSM hook
Content-Disposition: inline; filename=security-rename.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/namei.c               |    6 ++++--
 include/linux/security.h |   13 ++++++++++---
 security/dummy.c         |    4 +++-
 security/security.c      |    7 ++++---
 security/selinux/hooks.c |    8 ++++++--
 5 files changed, 27 insertions(+), 11 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2529,7 +2529,8 @@ static int vfs_rename_dir(struct inode *
 			return error;
 	}
 
-	error = security_inode_rename(old_dir, old_dentry, new_dir, new_dentry);
+	error = security_inode_rename(old_dir, old_dentry, old_mnt,
+				      new_dir, new_dentry, new_mnt);
 	if (error)
 		return error;
 
@@ -2563,7 +2564,8 @@ static int vfs_rename_other(struct inode
 	struct inode *target;
 	int error;
 
-	error = security_inode_rename(old_dir, old_dentry, new_dir, new_dentry);
+	error = security_inode_rename(old_dir, old_dentry, old_mnt,
+				      new_dir, new_dentry, new_mnt);
 	if (error)
 		return error;
 
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -350,8 +350,10 @@ struct request_sock;
  *	Check for permission to rename a file or directory.
  *	@old_dir contains the inode structure for parent of the old link.
  *	@old_dentry contains the dentry structure of the old link.
+ *	@old_mnt is the vfsmount corresponding to @old_dentry (may be NULL).
  *	@new_dir contains the inode structure for parent of the new link.
  *	@new_dentry contains the dentry structure of the new link.
+ *	@new_mnt is the vfsmount corresponding to @new_dentry (may be NULL).
  *	Return 0 if permission is granted.
  * @inode_readlink:
  *	Check the permission to read the symbolic link.
@@ -1260,7 +1262,9 @@ struct security_operations {
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
 			    struct vfsmount *mnt, int mode, dev_t dev);
 	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
-	                     struct inode *new_dir, struct dentry *new_dentry);
+			     struct vfsmount *old_mnt,
+	                     struct inode *new_dir, struct dentry *new_dentry,
+			     struct vfsmount *new_mnt);
 	int (*inode_readlink) (struct dentry *dentry, struct vfsmount *mnt);
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
 	int (*inode_permission) (struct inode *inode, int mask, struct nameidata *nd);
@@ -1521,7 +1525,8 @@ int security_inode_rmdir(struct inode *d
 int security_inode_mknod(struct inode *dir, struct dentry *dentry,
 			 struct vfsmount *mnt, int mode, dev_t dev);
 int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
-			   struct inode *new_dir, struct dentry *new_dentry);
+			  struct vfsmount *old_mnt, struct inode *new_dir,
+			  struct dentry *new_dentry, struct vfsmount *new_mnt);
 int security_inode_readlink(struct dentry *dentry, struct vfsmount *mnt);
 int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd);
 int security_inode_permission(struct inode *inode, int mask, struct nameidata *nd);
@@ -1877,8 +1882,10 @@ static inline int security_inode_mknod (
 
 static inline int security_inode_rename (struct inode *old_dir,
 					 struct dentry *old_dentry,
+					 struct vfsmount *old_mnt,
 					 struct inode *new_dir,
-					 struct dentry *new_dentry)
+					 struct dentry *new_dentry,
+					 struct vfsmount *new_mnt)
 {
 	return 0;
 }
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -307,8 +307,10 @@ static int dummy_inode_mknod (struct ino
 
 static int dummy_inode_rename (struct inode *old_inode,
 			       struct dentry *old_dentry,
+			       struct vfsmount *old_mnt,
 			       struct inode *new_inode,
-			       struct dentry *new_dentry)
+			       struct dentry *new_dentry,
+			       struct vfsmount *new_mnt)
 {
 	return 0;
 }
--- a/security/security.c
+++ b/security/security.c
@@ -387,13 +387,14 @@ int security_inode_mknod(struct inode *d
 }
 
 int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
-			   struct inode *new_dir, struct dentry *new_dentry)
+			  struct vfsmount *old_mnt, struct inode *new_dir,
+			  struct dentry *new_dentry, struct vfsmount *new_mnt)
 {
         if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
             (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
 		return 0;
-	return security_ops->inode_rename(old_dir, old_dentry,
-					   new_dir, new_dentry);
+	return security_ops->inode_rename(old_dir, old_dentry, old_mnt,
+					   new_dir, new_dentry, new_mnt);
 }
 
 int security_inode_readlink(struct dentry *dentry, struct vfsmount *mnt)
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2246,8 +2246,12 @@ static int selinux_inode_mknod(struct in
 	return may_create(dir, dentry, inode_mode_to_security_class(mode));
 }
 
-static int selinux_inode_rename(struct inode *old_inode, struct dentry *old_dentry,
-                                struct inode *new_inode, struct dentry *new_dentry)
+static int selinux_inode_rename(struct inode *old_inode,
+				struct dentry *old_dentry,
+				struct vfsmount *old_mnt,
+                                struct inode *new_inode,
+				struct dentry *new_dentry,
+				struct vfsmount *new_mnt)
 {
 	return may_rename(old_inode, old_dentry, new_inode, new_dentry);
 }

-- 

