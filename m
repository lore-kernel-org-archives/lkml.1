Return-Path: <linux-kernel-owner+w=401wt.eu-S1763970AbXLTOTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763970AbXLTOTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932948AbXLTOLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:11:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:56672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922AbXLTOLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:11:48 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:44 2007
Message-Id: <20071220140944.212975493@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:28 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 18/47] Pass struct vfsmount to the inode_unlink LSM hook
Content-Disposition: inline; filename=security-unlink.diff
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
 security/selinux/hooks.c |    5 +++--
 5 files changed, 16 insertions(+), 9 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2304,7 +2304,7 @@ int vfs_unlink(struct inode *dir, struct
 	if (d_mountpoint(dentry))
 		error = -EBUSY;
 	else {
-		error = security_inode_unlink(dir, dentry);
+		error = security_inode_unlink(dir, dentry, mnt);
 		if (!error)
 			error = dir->i_op->unlink(dir, dentry);
 	}
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -329,6 +329,7 @@ struct request_sock;
  *	Check the permission to remove a hard link to a file. 
  *	@dir contains the inode structure of parent directory of the file.
  *	@dentry contains the dentry structure for file to be unlinked.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	Return 0 if permission is granted.
  * @inode_symlink:
  *	Check the permission to create a symbolic link to a file.
@@ -1286,7 +1287,8 @@ struct security_operations {
 	int (*inode_link) (struct dentry *old_dentry, struct vfsmount *old_mnt,
 	                   struct inode *dir, struct dentry *new_dentry,
 			   struct vfsmount *new_mnt);
-	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
+	int (*inode_unlink) (struct inode *dir, struct dentry *dentry,
+			     struct vfsmount *mnt);
 	int (*inode_symlink) (struct inode *dir, struct dentry *dentry,
 			      struct vfsmount *mnt, const char *old_name);
 	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry,
@@ -1554,7 +1556,8 @@ int security_inode_create(struct inode *
 int security_inode_link(struct dentry *old_dentry, struct vfsmount *old_mnt,
 			struct inode *dir, struct dentry *new_dentry,
 			struct vfsmount *new_mnt);
-int security_inode_unlink(struct inode *dir, struct dentry *dentry);
+int security_inode_unlink(struct inode *dir, struct dentry *dentry,
+			  struct vfsmount *mnt);
 int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 			   struct vfsmount *mnt, const char *old_name);
 int security_inode_mkdir(struct inode *dir, struct dentry *dentry,
@@ -1882,7 +1885,8 @@ static inline int security_inode_link (s
 }
 
 static inline int security_inode_unlink (struct inode *dir,
-					 struct dentry *dentry)
+					 struct dentry *dentry,
+					 struct vfsmount *mnt)
 {
 	return 0;
 }
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -303,7 +303,8 @@ static int dummy_inode_link (struct dent
 	return 0;
 }
 
-static int dummy_inode_unlink (struct inode *inode, struct dentry *dentry)
+static int dummy_inode_unlink (struct inode *inode, struct dentry *dentry,
+			       struct vfsmount *mnt)
 {
 	return 0;
 }
--- a/security/security.c
+++ b/security/security.c
@@ -366,11 +366,12 @@ int security_inode_link(struct dentry *o
 					 new_dentry, new_mnt);
 }
 
-int security_inode_unlink(struct inode *dir, struct dentry *dentry)
+int security_inode_unlink(struct inode *dir, struct dentry *dentry,
+			  struct vfsmount *mnt)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_unlink(dir, dentry);
+	return security_ops->inode_unlink(dir, dentry, mnt);
 }
 
 int security_inode_symlink(struct inode *dir, struct dentry *dentry,
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2432,11 +2432,12 @@ static int selinux_inode_link(struct den
 	return may_link(dir, old_dentry, MAY_LINK);
 }
 
-static int selinux_inode_unlink(struct inode *dir, struct dentry *dentry)
+static int selinux_inode_unlink(struct inode *dir, struct dentry *dentry,
+			        struct vfsmount *mnt)
 {
 	int rc;
 
-	rc = secondary_ops->inode_unlink(dir, dentry);
+	rc = secondary_ops->inode_unlink(dir, dentry, mnt);
 	if (rc)
 		return rc;
 	return may_link(dir, dentry, MAY_UNLINK);

-- 

