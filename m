Return-Path: <linux-kernel-owner+w=401wt.eu-S936449AbYEURVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936449AbYEURVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934082AbYEURQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:16:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33084 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935721AbYEURQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:16:09 -0400
Message-Id: <20080521171554.050962936@szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 21 May 2008 19:15:07 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@redhat.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: [patch 09/14] security: dont pass nameidata to security_inode_permission()
Content-Disposition: inline; filename=security_permission_flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Only pass nameidata->flags instead of the nameidata to
security_inode_permission(), synchronizing it with i_op->permission().

Currently no security module uses the nameidata parameter.

The other change in ->permission() is that a dentry is passed instead
of an inode.  Leave this till AppArmor integration, since that will
need a struct path instead of an inode.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: James Morris <jmorris@namei.org>
CC: Stephen Smalley <sds@tycho.nsa.gov>
CC: Eric Paris <eparis@redhat.com>
CC: Casey Schaufler <casey@schaufler-ca.com>
---
 fs/namei.c                 |    4 ++--
 include/linux/security.h   |    8 ++++----
 security/dummy.c           |    2 +-
 security/security.c        |    4 ++--
 security/selinux/hooks.c   |    5 ++---
 security/smack/smack_lsm.c |    5 ++---
 6 files changed, 13 insertions(+), 15 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-21 13:41:30.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-21 13:41:33.000000000 +0200
@@ -288,7 +288,7 @@ int dentry_permission(struct dentry *den
 	if (retval)
 		return retval;
 
-	return security_inode_permission(inode, mask, nd);
+	return security_inode_permission(inode, mask, nd ? nd->flags : 0);
 }
 
 /**
@@ -488,7 +488,7 @@ static int exec_permission_lite(struct i
 
 	return -EACCES;
 ok:
-	return security_inode_permission(inode, MAY_EXEC, nd);
+	return security_inode_permission(inode, MAY_EXEC, nd->flags);
 }
 
 /*
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-05-21 13:13:29.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-05-21 13:41:33.000000000 +0200
@@ -407,7 +407,7 @@ static inline void security_free_mnt_opt
  *	called when the actual read/write operations are performed.
  *	@inode contains the inode structure to check.
  *	@mask contains the permission mask.
- *	@nd contains the nameidata (may be NULL).
+ *	@flags contains the lookup flags
  *	Return 0 if permission is granted.
  * @inode_setattr:
  *	Check permission before setting file attributes.  Note that the kernel
@@ -1370,7 +1370,7 @@ struct security_operations {
 			     struct inode *new_dir, struct dentry *new_dentry);
 	int (*inode_readlink) (struct dentry *dentry);
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
-	int (*inode_permission) (struct inode *inode, int mask, struct nameidata *nd);
+	int (*inode_permission) (struct inode *inode, int mask, int flags);
 	int (*inode_setattr)	(struct dentry *dentry, struct iattr *attr);
 	int (*inode_getattr) (struct vfsmount *mnt, struct dentry *dentry);
 	void (*inode_delete) (struct inode *inode);
@@ -1641,7 +1641,7 @@ int security_inode_rename(struct inode *
 			  struct inode *new_dir, struct dentry *new_dentry);
 int security_inode_readlink(struct dentry *dentry);
 int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd);
-int security_inode_permission(struct inode *inode, int mask, struct nameidata *nd);
+int security_inode_permission(struct inode *inode, int mask, int flags);
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr);
 int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry);
 void security_inode_delete(struct inode *inode);
@@ -2033,7 +2033,7 @@ static inline int security_inode_follow_
 }
 
 static inline int security_inode_permission(struct inode *inode, int mask,
-					     struct nameidata *nd)
+					     int flags)
 {
 	return 0;
 }
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-05-21 13:13:29.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-05-21 13:41:33.000000000 +0200
@@ -345,7 +345,7 @@ static int dummy_inode_follow_link (stru
 	return 0;
 }
 
-static int dummy_inode_permission (struct inode *inode, int mask, struct nameidata *nd)
+static int dummy_inode_permission (struct inode *inode, int mask, int flags)
 {
 	return 0;
 }
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-21 13:13:29.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-21 13:41:33.000000000 +0200
@@ -463,11 +463,11 @@ int security_inode_follow_link(struct de
 	return security_ops->inode_follow_link(dentry, nd);
 }
 
-int security_inode_permission(struct inode *inode, int mask, struct nameidata *nd)
+int security_inode_permission(struct inode *inode, int mask, int flags)
 {
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
-	return security_ops->inode_permission(inode, mask, nd);
+	return security_ops->inode_permission(inode, mask, flags);
 }
 
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr)
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-21 13:13:29.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-21 13:41:33.000000000 +0200
@@ -2579,12 +2579,11 @@ static int selinux_inode_follow_link(str
 	return dentry_has_perm(current, NULL, dentry, FILE__READ);
 }
 
-static int selinux_inode_permission(struct inode *inode, int mask,
-				    struct nameidata *nd)
+static int selinux_inode_permission(struct inode *inode, int mask, int flags)
 {
 	int rc;
 
-	rc = secondary_ops->inode_permission(inode, mask, nd);
+	rc = secondary_ops->inode_permission(inode, mask, flags);
 	if (rc)
 		return rc;
 
Index: linux-2.6/security/smack/smack_lsm.c
===================================================================
--- linux-2.6.orig/security/smack/smack_lsm.c	2008-05-21 13:13:29.000000000 +0200
+++ linux-2.6/security/smack/smack_lsm.c	2008-05-21 13:41:33.000000000 +0200
@@ -515,14 +515,13 @@ static int smack_inode_rename(struct ino
  * smack_inode_permission - Smack version of permission()
  * @inode: the inode in question
  * @mask: the access requested
- * @nd: unused
+ * @flags: unused
  *
  * This is the important Smack hook.
  *
  * Returns 0 if access is permitted, -EACCES otherwise
  */
-static int smack_inode_permission(struct inode *inode, int mask,
-				  struct nameidata *nd)
+static int smack_inode_permission(struct inode *inode, int mask, int flags)
 {
 	/*
 	 * No permission to check. Existence test. Yup, it's there.

--
