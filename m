Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbXLTOMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbXLTOMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbXLTOKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:10:53 -0500
Received: from ns.suse.de ([195.135.220.2]:40641 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833AbXLTOKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:10:51 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:42 2007
Message-Id: <20071220140942.003687115@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:14 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 04/47] Pass struct vfsmount to the inode_setattr LSM hook
Content-Disposition: inline; filename=security-setattr.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for computing pathnames in the AppArmor LSM.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/attr.c                |    4 ++--
 include/linux/security.h |    8 ++++++--
 security/dummy.c         |    3 ++-
 security/security.c      |    5 +++--
 security/selinux/hooks.c |    5 +++--
 5 files changed, 16 insertions(+), 9 deletions(-)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -159,13 +159,13 @@ int notify_change(struct dentry *dentry,
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
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -389,6 +389,7 @@ struct request_sock;
  *	file attributes change (such as when a file is truncated, chown/chmod
  *	operations, transferring disk quotas, etc).
  *	@dentry contains the dentry structure for the file.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	@attr is the iattr structure containing the new file attributes.
  *	Return 0 if permission is granted.
  * @inode_getattr:
@@ -1289,7 +1290,8 @@ struct security_operations {
 	int (*inode_readlink) (struct dentry *dentry);
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
 	int (*inode_permission) (struct inode *inode, int mask, struct nameidata *nd);
-	int (*inode_setattr)	(struct dentry *dentry, struct iattr *attr);
+	int (*inode_setattr) (struct dentry *dentry, struct vfsmount *mnt,
+			      struct iattr *attr);
 	int (*inode_getattr) (struct vfsmount *mnt, struct dentry *dentry);
         void (*inode_delete) (struct inode *inode);
 	int (*inode_setxattr) (struct dentry *dentry, char *name, void *value,
@@ -1552,7 +1554,8 @@ int security_inode_rename(struct inode *
 int security_inode_readlink(struct dentry *dentry);
 int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd);
 int security_inode_permission(struct inode *inode, int mask, struct nameidata *nd);
-int security_inode_setattr(struct dentry *dentry, struct iattr *attr);
+int security_inode_setattr(struct dentry *dentry, struct vfsmount *mnt,
+			   struct iattr *attr);
 int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry);
 void security_inode_delete(struct inode *inode);
 int security_inode_setxattr(struct dentry *dentry, char *name,
@@ -1921,6 +1924,7 @@ static inline int security_inode_permiss
 }
 
 static inline int security_inode_setattr (struct dentry *dentry,
+					  struct vfsmount *mnt,
 					  struct iattr *attr)
 {
 	return 0;
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -353,7 +353,8 @@ static int dummy_inode_permission (struc
 	return 0;
 }
 
-static int dummy_inode_setattr (struct dentry *dentry, struct iattr *iattr)
+static int dummy_inode_setattr (struct dentry *dentry, struct vfsmount *mnt,
+				struct iattr *iattr)
 {
 	return 0;
 }
--- a/security/security.c
+++ b/security/security.c
@@ -431,11 +431,12 @@ int security_inode_permission(struct ino
 	return security_ops->inode_permission(inode, mask, nd);
 }
 
-int security_inode_setattr(struct dentry *dentry, struct iattr *attr)
+int security_inode_setattr(struct dentry *dentry, struct vfsmount *mnt,
+			   struct iattr *attr)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_setattr(dentry, attr);
+	return security_ops->inode_setattr(dentry, mnt, attr);
 }
 
 int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2502,11 +2502,12 @@ static int selinux_inode_permission(stru
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
 

-- 

