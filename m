Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbYE2Nxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbYE2Nxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbYE2NvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:51:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46158 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083AbYE2NvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:51:07 -0400
Message-Id: <20080529135016.940896603@szeredi.hu>
References: <20080529134903.615127628@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 15:49:18 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 15/15] security: pass path to inode_permission
Content-Disposition: inline; filename=security_permission_path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In the inode_permission() security operation and related functions
pass the path (vfsmount + dentry) instead of the inode.  AppArmor will
need this.

Create a new security operation: inode_lookup() which will be called
for checking permission to lookup.  Unfortunately it is necessary to
distinguish between lookup and non-lookup permissions, because the
path is not available from lookup_one_len().  One day, when
lookup_one_len() is gone, this operation can go too.  AppArmor won't
need to check permission to lookup.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c                 |   30 +++++++++++++++++++++---------
 include/linux/security.h   |   19 +++++++++++++++----
 security/dummy.c           |    8 +++++++-
 security/security.c        |   11 +++++++++--
 security/selinux/hooks.c   |   18 ++++++++++++++++--
 security/smack/smack_lsm.c |   18 +++++++++++++++---
 6 files changed, 83 insertions(+), 21 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-29 12:20:56.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-29 12:20:59.000000000 +0200
@@ -280,11 +280,7 @@ static int dentry_permission(struct dent
 	if (retval)
 		return retval;
 
-	retval = devcgroup_inode_permission(inode, mask);
-	if (retval)
-		return retval;
-
-	return security_inode_permission(inode, mask);
+	return devcgroup_inode_permission(inode, mask);
 }
 
 /**
@@ -299,6 +295,7 @@ static int dentry_permission(struct dent
  */
 int path_permission(struct path *path, int mask)
 {
+	int err;
 	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
 
@@ -313,7 +310,14 @@ int path_permission(struct path *path, i
 			return -EACCES;
 	}
 
-	return dentry_permission(dentry, mask);
+	err = dentry_permission(dentry, mask);
+	if (err)
+		return err;
+
+	if (mask == MAY_LOOKUP)
+		return security_inode_lookup(inode);
+	else
+		return security_inode_permission(path, mask);
 }
 
 /**
@@ -492,7 +496,7 @@ static int exec_permission_lite(struct i
 
 	return -EACCES;
 ok:
-	return security_inode_permission(inode, MAY_LOOKUP);
+	return security_inode_lookup(inode);
 }
 
 /*
@@ -1393,12 +1397,20 @@ struct dentry *lookup_one_len(const char
 
 	err = __lookup_one_len(name, &this, base, len);
 	if (err)
-		return ERR_PTR(err);
+		goto error;
 
 	err = dentry_permission(base, MAY_LOOKUP);
 	if (err)
-		return ERR_PTR(err);
+		goto error;
+
+	err = security_inode_lookup(base->d_inode);
+	if (err)
+		goto error;
+
 	return __lookup_hash(&this, base, NULL);
+
+error:
+	return ERR_PTR(err);
 }
 
 /**
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-05-29 12:20:59.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-05-29 12:20:59.000000000 +0200
@@ -405,9 +405,13 @@ static inline void security_free_mnt_opt
  *	Notice that this hook is called when a file is opened (as well as many
  *	other operations), whereas the file_security_ops permission hook is
  *	called when the actual read/write operations are performed.
- *	@inode contains the inode structure to check.
+ *	@path contains the path to check.
  *	@mask contains the permission mask.
  *	Return 0 if permission is granted.
+ * @inode_lookup:
+ *	Check permissions for lookup.
+ *	@inode contains the inode structure to check.
+ *	Return 0 if permission is granted.
  * @inode_setattr:
  *	Check permission before setting file attributes.  Note that the kernel
  *	call to notify_change is performed from several locations, whenever
@@ -1367,7 +1371,8 @@ struct security_operations {
 			     struct path *new_dir, struct dentry *new_dentry);
 	int (*inode_readlink) (struct dentry *dentry);
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
-	int (*inode_permission) (struct inode *inode, int mask);
+	int (*inode_permission) (struct path *path, int mask);
+	int (*inode_lookup) (struct inode *inode);
 	int (*inode_setattr)	(struct path *path, struct iattr *attr);
 	int (*inode_getattr) (struct path *path);
 	void (*inode_delete) (struct inode *inode);
@@ -1639,7 +1644,8 @@ int security_inode_rename(struct path *o
 			  struct path *new_dir, struct dentry *new_dentry);
 int security_inode_readlink(struct dentry *dentry);
 int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd);
-int security_inode_permission(struct inode *inode, int mask);
+int security_inode_permission(struct path *path, int mask);
+int security_inode_lookup(struct inode *inode);
 int security_inode_setattr(struct path *path, struct iattr *attr);
 int security_inode_getattr(struct path *path);
 void security_inode_delete(struct inode *inode);
@@ -2030,7 +2036,12 @@ static inline int security_inode_follow_
 	return 0;
 }
 
-static inline int security_inode_permission(struct inode *inode, int mask)
+static inline int security_inode_permission(struct path *path, int mask)
+{
+	return 0;
+}
+
+static inline int security_inode_lookup(struct inode *inode)
 {
 	return 0;
 }
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-05-29 12:20:59.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-05-29 12:20:59.000000000 +0200
@@ -343,7 +343,12 @@ static int dummy_inode_follow_link (stru
 	return 0;
 }
 
-static int dummy_inode_permission (struct inode *inode, int mask)
+static int dummy_inode_permission(struct path *path, int mask)
+{
+	return 0;
+}
+
+static int dummy_inode_lookup(struct inode *inode)
 {
 	return 0;
 }
@@ -1091,6 +1096,7 @@ void security_fixup_ops (struct security
 	set_to_dummy_if_null(ops, inode_readlink);
 	set_to_dummy_if_null(ops, inode_follow_link);
 	set_to_dummy_if_null(ops, inode_permission);
+	set_to_dummy_if_null(ops, inode_lookup);
 	set_to_dummy_if_null(ops, inode_setattr);
 	set_to_dummy_if_null(ops, inode_getattr);
 	set_to_dummy_if_null(ops, inode_delete);
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-29 12:20:59.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-29 12:20:59.000000000 +0200
@@ -464,11 +464,18 @@ int security_inode_follow_link(struct de
 	return security_ops->inode_follow_link(dentry, nd);
 }
 
-int security_inode_permission(struct inode *inode, int mask)
+int security_inode_permission(struct path *path, int mask)
+{
+	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
+		return 0;
+	return security_ops->inode_permission(path, mask);
+}
+
+int security_inode_lookup(struct inode *inode)
 {
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
-	return security_ops->inode_permission(inode, mask);
+	return security_ops->inode_lookup(inode);
 }
 
 int security_inode_setattr(struct path *path, struct iattr *attr)
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-29 12:20:59.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-29 12:20:59.000000000 +0200
@@ -2561,11 +2561,12 @@ static int selinux_inode_follow_link(str
 	return dentry_has_perm(current, NULL, dentry, FILE__READ);
 }
 
-static int selinux_inode_permission(struct inode *inode, int mask)
+static int selinux_inode_permission(struct path *path, int mask)
 {
+	struct inode *inode = path->dentry->d_inode;
 	int rc;
 
-	rc = secondary_ops->inode_permission(inode, mask);
+	rc = secondary_ops->inode_permission(path, mask);
 	if (rc)
 		return rc;
 
@@ -2579,6 +2580,18 @@ static int selinux_inode_permission(stru
 			       open_file_mask_to_av(inode->i_mode, mask), NULL);
 }
 
+static int selinux_inode_lookup(struct inode *inode)
+{
+	int rc;
+
+	rc = secondary_ops->inode_lookup(inode);
+	if (rc)
+		return rc;
+
+	return inode_has_perm(current, inode,
+			open_file_mask_to_av(inode->i_mode, MAY_EXEC), NULL);
+}
+
 static int selinux_inode_setattr(struct path *path, struct iattr *iattr)
 {
 	struct dentry *dentry = path->dentry;
@@ -5350,6 +5363,7 @@ static struct security_operations selinu
 	.inode_readlink =		selinux_inode_readlink,
 	.inode_follow_link =		selinux_inode_follow_link,
 	.inode_permission =		selinux_inode_permission,
+	.inode_lookup =			selinux_inode_lookup,
 	.inode_setattr =		selinux_inode_setattr,
 	.inode_getattr =		selinux_inode_getattr,
 	.inode_setxattr =		selinux_inode_setxattr,
Index: linux-2.6/security/smack/smack_lsm.c
===================================================================
--- linux-2.6.orig/security/smack/smack_lsm.c	2008-05-29 12:20:59.000000000 +0200
+++ linux-2.6/security/smack/smack_lsm.c	2008-05-29 12:20:59.000000000 +0200
@@ -513,14 +513,14 @@ static int smack_inode_rename(struct pat
 
 /**
  * smack_inode_permission - Smack version of permission()
- * @inode: the inode in question
+ * @path: the object
  * @mask: the access requested
  *
  * This is the important Smack hook.
  *
  * Returns 0 if access is permitted, -EACCES otherwise
  */
-static int smack_inode_permission(struct inode *inode, int mask)
+static int smack_inode_permission(struct path *path, int mask)
 {
 	/*
 	 * No permission to check. Existence test. Yup, it's there.
@@ -529,7 +529,18 @@ static int smack_inode_permission(struct
 	if (mask == 0)
 		return 0;
 
-	return smk_curacc(smk_of_inode(inode), mask);
+	return smk_curacc(smk_of_inode(path->dentry->d_inode), mask);
+}
+
+/**
+ * smack_inode_lookup - Permission to lookup
+ * @inode: the inode in question
+ *
+ * Returns 0 if access is permitted, -EACCES otherwise
+ */
+static int smack_inode_lookup(struct inode *inode)
+{
+	return smk_curacc(smk_of_inode(inode), MAY_EXEC);
 }
 
 /**
@@ -2589,6 +2600,7 @@ struct security_operations smack_ops = {
 	.inode_rmdir = 			smack_inode_rmdir,
 	.inode_rename = 		smack_inode_rename,
 	.inode_permission = 		smack_inode_permission,
+	.inode_lookup = 		smack_inode_lookup,
 	.inode_setattr = 		smack_inode_setattr,
 	.inode_getattr = 		smack_inode_getattr,
 	.inode_setxattr = 		smack_inode_setxattr,

--
