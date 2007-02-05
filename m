Return-Path: <linux-kernel-owner+w=401wt.eu-S932955AbXBESX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955AbXBESX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932993AbXBESX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:23:26 -0500
Received: from mail.suse.de ([195.135.220.2]:43139 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932955AbXBESXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:23:24 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:22:21 -0800
Message-Id: <20070205182221.12164.57485.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 1/28] Pass struct vfsmount to the inode_create LSM hook.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass struct vfsmount to the inode_create LSM hook.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -1503,7 +1503,7 @@ int vfs_create(struct inode *dir, struct
 		return -EACCES;	/* shouldn't it be ENOSYS? */
 	mode &= S_IALLUGO;
 	mode |= S_IFREG;
-	error = security_inode_create(dir, dentry, mode);
+	error = security_inode_create(dir, dentry, nd ? nd->mnt : NULL, mode);
 	if (error)
 		return error;
 	DQUOT_INIT(dir);
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h
+++ linux-2.6/include/linux/security.h
@@ -283,6 +283,7 @@ struct request_sock;
  *	Check permission to create a regular file.
  *	@dir contains inode structure of the parent of the new file.
  *	@dentry contains the dentry structure for the file to be created.
+ *	@mnt is the vfsmount corresponding to @dentry (may be NULL).
  *	@mode contains the file mode of the file to be created.
  *	Return 0 if permission is granted.
  * @inode_link:
@@ -1204,8 +1205,8 @@ struct security_operations {
 	void (*inode_free_security) (struct inode *inode);
 	int (*inode_init_security) (struct inode *inode, struct inode *dir,
 				    char **name, void **value, size_t *len);
-	int (*inode_create) (struct inode *dir,
-	                     struct dentry *dentry, int mode);
+	int (*inode_create) (struct inode *dir, struct dentry *dentry,
+			     struct vfsmount *mnt, int mode);
 	int (*inode_link) (struct dentry *old_dentry,
 	                   struct inode *dir, struct dentry *new_dentry);
 	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
@@ -1611,11 +1612,12 @@ static inline int security_inode_init_se
 	
 static inline int security_inode_create (struct inode *dir,
 					 struct dentry *dentry,
+					 struct vfsmount *mnt,
 					 int mode)
 {
 	if (unlikely (IS_PRIVATE (dir)))
 		return 0;
-	return security_ops->inode_create (dir, dentry, mode);
+	return security_ops->inode_create (dir, dentry, mnt, mode);
 }
 
 static inline int security_inode_link (struct dentry *old_dentry,
@@ -2338,6 +2340,7 @@ static inline int security_inode_init_se
 	
 static inline int security_inode_create (struct inode *dir,
 					 struct dentry *dentry,
+					 struct vfsmount *mnt,
 					 int mode)
 {
 	return 0;
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c
+++ linux-2.6/security/dummy.c
@@ -265,7 +265,7 @@ static int dummy_inode_init_security (st
 }
 
 static int dummy_inode_create (struct inode *inode, struct dentry *dentry,
-			       int mask)
+			       struct vfsmount *mnt, int mask)
 {
 	return 0;
 }
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c
+++ linux-2.6/security/selinux/hooks.c
@@ -2135,7 +2135,8 @@ static int selinux_inode_init_security(s
 	return 0;
 }
 
-static int selinux_inode_create(struct inode *dir, struct dentry *dentry, int mask)
+static int selinux_inode_create(struct inode *dir, struct dentry *dentry,
+				 struct vfsmount *mnt, int mask)
 {
 	return may_create(dir, dentry, SECCLASS_FILE);
 }
