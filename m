Return-Path: <linux-kernel-owner+w=401wt.eu-S933178AbXBES0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178AbXBES0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933168AbXBES0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:26:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:47724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933093AbXBES0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:26:00 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:25:03 -0800
Message-Id: <20070205182503.12164.74690.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 18/28] Pass struct vfsmount to the inode_unlink LSM hook
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass struct vfsmount to the inode_unlink LSM hook

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -2102,7 +2102,7 @@ int vfs_unlink(struct inode *dir, struct
 	if (d_mountpoint(dentry))
 		error = -EBUSY;
 	else {
-		error = security_inode_unlink(dir, dentry);
+		error = security_inode_unlink(dir, dentry, mnt);
 		if (!error)
 			error = dir->i_op->unlink(dir, dentry);
 	}
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h
+++ linux-2.6/include/linux/security.h
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
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c
+++ linux-2.6/security/dummy.c
@@ -278,7 +278,8 @@ static int dummy_inode_link (struct dent
 	return 0;
 }
 
-static int dummy_inode_unlink (struct inode *inode, struct dentry *dentry)
+static int dummy_inode_unlink (struct inode *inode, struct dentry *dentry,
+			       struct vfsmount *mnt)
 {
 	return 0;
 }
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c
+++ linux-2.6/security/selinux/hooks.c
@@ -2156,11 +2156,12 @@ static int selinux_inode_link(struct den
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
