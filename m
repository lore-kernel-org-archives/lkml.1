Return-Path: <linux-kernel-owner+w=401wt.eu-S1763326AbXLTOSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763326AbXLTOSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932880AbXLTOLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:11:37 -0500
Received: from ns2.suse.de ([195.135.220.15]:56628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932894AbXLTOLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:11:36 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:43 2007
Message-Id: <20071220140943.649037329@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:25 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 15/47] Pass struct vfsmount to the inode_rmdir LSM hook
Content-Disposition: inline; filename=security-rmdir.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/namei.c               |    2 +-
 include/linux/security.h |   10 +++++++---
 security/dummy.c         |    3 ++-
 security/security.c      |    5 +++--
 security/selinux/hooks.c |    3 ++-
 5 files changed, 15 insertions(+), 8 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2219,7 +2219,7 @@ int vfs_rmdir(struct inode *dir, struct 
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
@@ -349,6 +349,7 @@ struct request_sock;
  *	Check the permission to remove a directory.
  *	@dir contains the inode structure of parent of the directory to be removed.
  *	@dentry contains the dentry structure of directory to be removed.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	Return 0 if permission is granted.
  * @inode_mknod:
  *	Check permissions when creating a special file (or a socket or a fifo
@@ -1290,7 +1291,8 @@ struct security_operations {
 			      struct vfsmount *mnt, const char *old_name);
 	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry,
 			    struct vfsmount *mnt, int mode);
-	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
+	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry,
+			    struct vfsmount *mnt);
 	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
 			    struct vfsmount *mnt, int mode, dev_t dev);
 	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
@@ -1557,7 +1559,8 @@ int security_inode_symlink(struct inode 
 			   struct vfsmount *mnt, const char *old_name);
 int security_inode_mkdir(struct inode *dir, struct dentry *dentry,
 			 struct vfsmount *mnt, int mode);
-int security_inode_rmdir(struct inode *dir, struct dentry *dentry);
+int security_inode_rmdir(struct inode *dir, struct dentry *dentry,
+			 struct vfsmount *mnt);
 int security_inode_mknod(struct inode *dir, struct dentry *dentry,
 			 struct vfsmount *mnt, int mode, dev_t dev);
 int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
@@ -1901,7 +1904,8 @@ static inline int security_inode_mkdir (
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
@@ -320,7 +320,8 @@ static int dummy_inode_mkdir (struct ino
 	return 0;
 }
 
-static int dummy_inode_rmdir (struct inode *inode, struct dentry *dentry)
+static int dummy_inode_rmdir (struct inode *inode, struct dentry *dentry,
+			      struct vfsmount *mnt)
 {
 	return 0;
 }
--- a/security/security.c
+++ b/security/security.c
@@ -389,11 +389,12 @@ int security_inode_mkdir(struct inode *d
 	return security_ops->inode_mkdir(dir, dentry, mnt, mode);
 }
 
-int security_inode_rmdir(struct inode *dir, struct dentry *dentry)
+int security_inode_rmdir(struct inode *dir, struct dentry *dentry,
+			 struct vfsmount *mnt)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_rmdir(dir, dentry);
+	return security_ops->inode_rmdir(dir, dentry, mnt);
 }
 
 int security_inode_mknod(struct inode *dir, struct dentry *dentry,
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2454,7 +2454,8 @@ static int selinux_inode_mkdir(struct in
 	return may_create(dir, dentry, SECCLASS_DIR);
 }
 
-static int selinux_inode_rmdir(struct inode *dir, struct dentry *dentry)
+static int selinux_inode_rmdir(struct inode *dir, struct dentry *dentry,
+			       struct vfsmount *mnt)
 {
 	return may_link(dir, dentry, MAY_RMDIR);
 }

-- 

