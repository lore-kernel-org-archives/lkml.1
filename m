Return-Path: <linux-kernel-owner+w=401wt.eu-S933015AbXBESYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015AbXBESYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933029AbXBESYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:24:20 -0500
Received: from ns.suse.de ([195.135.220.2]:43198 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933031AbXBESYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:24:05 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:23:06 -0800
Message-Id: <20070205182306.12164.22623.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 5/28] Pass struct vfsmount to the inode_setattr LSM hook
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass struct vfsmount to the inode_setattr LSM hook

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/attr.c
===================================================================
--- linux-2.6.orig/fs/attr.c
+++ linux-2.6/fs/attr.c
@@ -145,13 +145,13 @@ int notify_change(struct dentry *dentry,
 		down_write(&dentry->d_inode->i_alloc_sem);
 
 	if (inode->i_op && inode->i_op->setattr) {
-		error = security_inode_setattr(dentry, attr);
+		error = security_inode_setattr(dentry, mnt, attr);
 		if (!error)
 			error = inode->i_op->setattr(dentry, attr);
 	} else {
 		error = inode_change_ok(inode, attr);
 		if (!error)
-			error = security_inode_setattr(dentry, attr);
+			error = security_inode_setattr(dentry, mnt, attr);
 		if (!error) {
 			if ((ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
 			    (ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid))
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h
+++ linux-2.6/include/linux/security.h
@@ -358,6 +358,7 @@ struct request_sock;
  *	file attributes change (such as when a file is truncated, chown/chmod
  *	operations, transferring disk quotas, etc).
  *	@dentry contains the dentry structure for the file.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	@attr is the iattr structure containing the new file attributes.
  *	Return 0 if permission is granted.
  * @inode_getattr:
@@ -1221,7 +1222,8 @@ struct security_operations {
 	int (*inode_readlink) (struct dentry *dentry);
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
 	int (*inode_permission) (struct inode *inode, int mask, struct nameidata *nd);
-	int (*inode_setattr)	(struct dentry *dentry, struct iattr *attr);
+	int (*inode_setattr) (struct dentry *dentry, struct vfsmount *mnt,
+			      struct iattr *attr);
 	int (*inode_getattr) (struct vfsmount *mnt, struct dentry *dentry);
         void (*inode_delete) (struct inode *inode);
 	int (*inode_setxattr) (struct dentry *dentry, char *name, void *value,
@@ -1708,11 +1710,12 @@ static inline int security_inode_permiss
 }
 
 static inline int security_inode_setattr (struct dentry *dentry,
+					  struct vfsmount *mnt,
 					  struct iattr *attr)
 {
 	if (unlikely (IS_PRIVATE (dentry->d_inode)))
 		return 0;
-	return security_ops->inode_setattr (dentry, attr);
+	return security_ops->inode_setattr (dentry, mnt, attr);
 }
 
 static inline int security_inode_getattr (struct vfsmount *mnt,
@@ -2412,6 +2415,7 @@ static inline int security_inode_permiss
 }
 
 static inline int security_inode_setattr (struct dentry *dentry,
+					  struct vfsmount *mnt,
 					  struct iattr *attr)
 {
 	return 0;
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c
+++ linux-2.6/security/dummy.c
@@ -328,7 +328,8 @@ static int dummy_inode_permission (struc
 	return 0;
 }
 
-static int dummy_inode_setattr (struct dentry *dentry, struct iattr *iattr)
+static int dummy_inode_setattr (struct dentry *dentry, struct vfsmount *mnt,
+				struct iattr *iattr)
 {
 	return 0;
 }
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c
+++ linux-2.6/security/selinux/hooks.c
@@ -2226,11 +2226,12 @@ static int selinux_inode_permission(stru
 			       file_mask_to_av(inode->i_mode, mask), NULL);
 }
 
-static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
+static int selinux_inode_setattr(struct dentry *dentry, struct vfsmount *mnt,
+				 struct iattr *iattr)
 {
 	int rc;
 
-	rc = secondary_ops->inode_setattr(dentry, iattr);
+	rc = secondary_ops->inode_setattr(dentry, mnt, iattr);
 	if (rc)
 		return rc;
 
