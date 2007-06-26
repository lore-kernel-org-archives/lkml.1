Return-Path: <linux-kernel-owner+w=401wt.eu-S1761089AbXFZXRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761089AbXFZXRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759593AbXFZXLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:11:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:42918 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759971AbXFZXKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:10:52 -0400
Message-Id: <20070626231006.690725774@suse.de>
References: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:08:14 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 18/44] Pass struct vfsmount to the inode_unlink LSM hook
Content-Disposition: inline; filename=security-unlink.diff
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
 security/selinux/hooks.c |    5 +++--
 4 files changed, 14 insertions(+), 8 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2121,7 +2121,7 @@ int vfs_unlink(struct inode *dir, struct
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
@@ -298,6 +298,7 @@ struct request_sock;
  *	Check the permission to remove a hard link to a file. 
  *	@dir contains the inode structure of parent directory of the file.
  *	@dentry contains the dentry structure for file to be unlinked.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	Return 0 if permission is granted.
  * @inode_symlink:
  *	Check the permission to create a symbolic link to a file.
@@ -1218,7 +1219,8 @@ struct security_operations {
 	int (*inode_link) (struct dentry *old_dentry, struct vfsmount *old_mnt,
 	                   struct inode *dir, struct dentry *new_dentry,
 			   struct vfsmount *new_mnt);
-	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
+	int (*inode_unlink) (struct inode *dir, struct dentry *dentry,
+			     struct vfsmount *mnt);
 	int (*inode_symlink) (struct inode *dir, struct dentry *dentry,
 			      struct vfsmount *mnt, const char *old_name);
 	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry,
@@ -1645,11 +1647,12 @@ static inline int security_inode_link (s
 }
 
 static inline int security_inode_unlink (struct inode *dir,
-					 struct dentry *dentry)
+					 struct dentry *dentry,
+					 struct vfsmount *mnt)
 {
 	if (unlikely (IS_PRIVATE (dentry->d_inode)))
 		return 0;
-	return security_ops->inode_unlink (dir, dentry);
+	return security_ops->inode_unlink (dir, dentry, mnt);
 }
 
 static inline int security_inode_symlink (struct inode *dir,
@@ -2377,7 +2380,8 @@ static inline int security_inode_link (s
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
@@ -278,7 +278,8 @@ static int dummy_inode_link (struct dent
 	return 0;
 }
 
-static int dummy_inode_unlink (struct inode *inode, struct dentry *dentry)
+static int dummy_inode_unlink (struct inode *inode, struct dentry *dentry,
+			       struct vfsmount *mnt)
 {
 	return 0;
 }
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2197,11 +2197,12 @@ static int selinux_inode_link(struct den
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
