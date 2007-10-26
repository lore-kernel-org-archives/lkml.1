Return-Path: <linux-kernel-owner+w=401wt.eu-S1761373AbXJZG7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761373AbXJZG7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 02:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759478AbXJZG5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:57:04 -0400
Received: from ns2.suse.de ([195.135.220.15]:36778 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbXJZG5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:57:01 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:47 2007
Message-Id: <20071026064047.684378149@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:30 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
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
 security/security.c      |    5 +++--
 security/selinux/hooks.c |    3 ++-
 5 files changed, 13 insertions(+), 7 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2032,7 +2032,7 @@ int vfs_mkdir(struct inode *dir, struct 
 		return -EPERM;
 
 	mode &= (S_IRWXUGO|S_ISVTX);
-	error = security_inode_mkdir(dir, dentry, mode);
+	error = security_inode_mkdir(dir, dentry, mnt, mode);
 	if (error)
 		return error;
 
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -322,6 +322,7 @@ struct request_sock;
  *	associated with inode strcture @dir. 
  *	@dir containst the inode structure of parent of the directory to be created.
  *	@dentry contains the dentry structure of new directory.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	@mode contains the mode of new directory.
  *	Return 0 if permission is granted.
  * @inode_rmdir:
@@ -1243,7 +1244,8 @@ struct security_operations {
 	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
 	int (*inode_symlink) (struct inode *dir,
 	                      struct dentry *dentry, const char *old_name);
-	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry, int mode);
+	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry,
+			    struct vfsmount *mnt, int mode);
 	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
 	                    int mode, dev_t dev);
@@ -1500,7 +1502,8 @@ int security_inode_link(struct dentry *o
 int security_inode_unlink(struct inode *dir, struct dentry *dentry);
 int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 			    const char *old_name);
-int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode);
+int security_inode_mkdir(struct inode *dir, struct dentry *dentry,
+			 struct vfsmount *mnt, int mode);
 int security_inode_rmdir(struct inode *dir, struct dentry *dentry);
 int security_inode_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev);
 int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
@@ -1833,6 +1836,7 @@ static inline int security_inode_symlink
 
 static inline int security_inode_mkdir (struct inode *dir,
 					struct dentry *dentry,
+					struct vfsmount *mnt,
 					int mode)
 {
 	return 0;
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -285,7 +285,7 @@ static int dummy_inode_symlink (struct i
 }
 
 static int dummy_inode_mkdir (struct inode *inode, struct dentry *dentry,
-			      int mask)
+			      struct vfsmount *mnt, int mask)
 {
 	return 0;
 }
--- a/security/security.c
+++ b/security/security.c
@@ -359,11 +359,12 @@ int security_inode_symlink(struct inode 
 	return security_ops->inode_symlink(dir, dentry, old_name);
 }
 
-int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+int security_inode_mkdir(struct inode *dir, struct dentry *dentry,
+			 struct vfsmount *mnt, int mode)
 {
 	if (unlikely(IS_PRIVATE(dir)))
 		return 0;
-	return security_ops->inode_mkdir(dir, dentry, mode);
+	return security_ops->inode_mkdir(dir, dentry, mnt, mode);
 }
 
 int security_inode_rmdir(struct inode *dir, struct dentry *dentry)
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2215,7 +2215,8 @@ static int selinux_inode_symlink(struct 
 	return may_create(dir, dentry, SECCLASS_LNK_FILE);
 }
 
-static int selinux_inode_mkdir(struct inode *dir, struct dentry *dentry, int mask)
+static int selinux_inode_mkdir(struct inode *dir, struct dentry *dentry,
+			       struct vfsmount *mnt, int mask)
 {
 	return may_create(dir, dentry, SECCLASS_DIR);
 }

-- 

