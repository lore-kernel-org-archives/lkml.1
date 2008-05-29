Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYE2NwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYE2NwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbYE2Nu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:50:56 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46117 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539AbYE2Nuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:50:50 -0400
Message-Id: <20080529135007.516269298@szeredi.hu>
References: <20080529134903.615127628@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 15:49:11 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 08/15] security: pass path to inode_rename
Content-Disposition: inline; filename=security_rename_path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In the inode_rename() security operation and related functions pass the
path (vfsmount + dentry) to the parent directory instead of the inode.
AppArmor will need this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c                 |   51 +++++++++++++++++++++------------------------
 include/linux/security.h   |   16 +++++++-------
 security/dummy.c           |    6 +----
 security/security.c        |    4 +--
 security/selinux/hooks.c   |    7 +++---
 security/smack/smack_lsm.c |    8 +++----
 6 files changed, 44 insertions(+), 48 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-29 12:20:55.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-29 12:20:55.000000000 +0200
@@ -2682,20 +2682,6 @@ static int vfs_rename_dir(struct inode *
 	int error = 0;
 	struct inode *target;
 
-	/*
-	 * If we are going to change the parent - check write permissions,
-	 * we'll need to flip '..'.
-	 */
-	if (new_dir != old_dir) {
-		error = dentry_permission(old_dentry, MAY_MOVE_DIR);
-		if (error)
-			return error;
-	}
-
-	error = security_inode_rename(old_dir, old_dentry, new_dir, new_dentry);
-	if (error)
-		return error;
-
 	target = new_dentry->d_inode;
 	if (target) {
 		mutex_lock(&target->i_mutex);
@@ -2725,10 +2711,6 @@ static int vfs_rename_other(struct inode
 	struct inode *target;
 	int error;
 
-	error = security_inode_rename(old_dir, old_dentry, new_dir, new_dentry);
-	if (error)
-		return error;
-
 	dget(new_dentry);
 	target = new_dentry->d_inode;
 	if (target)
@@ -2747,11 +2729,11 @@ static int vfs_rename_other(struct inode
 	return error;
 }
 
-static int vfs_rename(struct dentry *old_dir_dentry, struct dentry *old_dentry,
-		      struct dentry *new_dir_dentry, struct dentry *new_dentry)
+static int vfs_rename(struct path *old_dir_path, struct dentry *old_dentry,
+		      struct path *new_dir_path, struct dentry *new_dentry)
 {
-	struct inode *old_dir = old_dir_dentry->d_inode;
-	struct inode *new_dir = new_dir_dentry->d_inode;
+	struct inode *old_dir = old_dir_path->dentry->d_inode;
+	struct inode *new_dir = new_dir_path->dentry->d_inode;
 	int error;
 	int is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
 	const char *old_name;
@@ -2759,20 +2741,35 @@ static int vfs_rename(struct dentry *old
 	if (old_dentry->d_inode == new_dentry->d_inode)
  		return 0;
  
-	error = may_delete(old_dir_dentry, old_dentry, is_dir);
+	error = may_delete(old_dir_path->dentry, old_dentry, is_dir);
 	if (error)
 		return error;
 
 	if (!new_dentry->d_inode)
-		error = may_create(new_dir_dentry, new_dentry);
+		error = may_create(new_dir_path->dentry, new_dentry);
 	else
-		error = may_delete(new_dir_dentry, new_dentry, is_dir);
+		error = may_delete(new_dir_path->dentry, new_dentry, is_dir);
 	if (error)
 		return error;
 
 	if (!old_dir->i_op || !old_dir->i_op->rename)
 		return -EPERM;
 
+	/*
+	 * If we are going to change the parent - check write permissions,
+	 * we'll need to flip '..'.
+	 */
+	if (is_dir && new_dir != old_dir) {
+		error = dentry_permission(old_dentry, MAY_MOVE_DIR);
+		if (error)
+			return error;
+	}
+
+	error = security_inode_rename(old_dir_path, old_dentry,
+				      new_dir_path, new_dentry);
+	if (error)
+		return error;
+
 	DQUOT_INIT(old_dir);
 	DQUOT_INIT(new_dir);
 
@@ -2802,8 +2799,8 @@ int path_rename(struct path *old_dir_pat
 
 	error = mnt_want_write(mnt);
 	if (!error) {
-		error = vfs_rename(old_dir_path->dentry, old_dentry,
-				   new_dir_path->dentry, new_dentry);
+		error = vfs_rename(old_dir_path, old_dentry,
+				   new_dir_path, new_dentry);
 		mnt_drop_write(mnt);
 	}
 
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-05-29 12:20:55.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-05-29 12:20:55.000000000 +0200
@@ -384,9 +384,9 @@ static inline void security_free_mnt_opt
  *	Return 0 if permission is granted.
  * @inode_rename:
  *	Check for permission to rename a file or directory.
- *	@old_dir contains the inode structure for parent of the old link.
+ *	@old_dir contains the path to the parent of the old link.
  *	@old_dentry contains the dentry structure of the old link.
- *	@new_dir contains the inode structure for parent of the new link.
+ *	@new_dir contains the path to the parent of the new link.
  *	@new_dentry contains the dentry structure of the new link.
  *	Return 0 if permission is granted.
  * @inode_readlink:
@@ -1363,8 +1363,8 @@ struct security_operations {
 	int (*inode_rmdir) (struct path *dir, struct dentry *dentry);
 	int (*inode_mknod) (struct path *dir, struct dentry *dentry,
 			    int mode, dev_t dev);
-	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
-			     struct inode *new_dir, struct dentry *new_dentry);
+	int (*inode_rename) (struct path *old_dir, struct dentry *old_dentry,
+			     struct path *new_dir, struct dentry *new_dentry);
 	int (*inode_readlink) (struct dentry *dentry);
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
 	int (*inode_permission) (struct inode *inode, int mask);
@@ -1635,8 +1635,8 @@ int security_inode_mkdir(struct path *di
 int security_inode_rmdir(struct path *dir, struct dentry *dentry);
 int security_inode_mknod(struct path *dir, struct dentry *dentry, int mode,
 			 dev_t dev);
-int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
-			  struct inode *new_dir, struct dentry *new_dentry);
+int security_inode_rename(struct path *old_dir, struct dentry *old_dentry,
+			  struct path *new_dir, struct dentry *new_dentry);
 int security_inode_readlink(struct dentry *dentry);
 int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd);
 int security_inode_permission(struct inode *inode, int mask);
@@ -2011,9 +2011,9 @@ static inline int security_inode_mknod(s
 	return 0;
 }
 
-static inline int security_inode_rename(struct inode *old_dir,
+static inline int security_inode_rename(struct path *old_dir,
 					 struct dentry *old_dentry,
-					 struct inode *new_dir,
+					 struct path *new_dir,
 					 struct dentry *new_dentry)
 {
 	return 0;
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-05-29 12:20:55.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-05-29 12:20:55.000000000 +0200
@@ -326,10 +326,8 @@ static int dummy_inode_mknod(struct path
 	return 0;
 }
 
-static int dummy_inode_rename (struct inode *old_inode,
-			       struct dentry *old_dentry,
-			       struct inode *new_inode,
-			       struct dentry *new_dentry)
+static int dummy_inode_rename(struct path *old_dir, struct dentry *old_dentry,
+			      struct path *new_dir, struct dentry *new_dentry)
 {
 	return 0;
 }
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-29 12:20:55.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-29 12:20:55.000000000 +0200
@@ -440,8 +440,8 @@ int security_inode_mknod(struct path *di
 	return security_ops->inode_mknod(dir, dentry, mode, dev);
 }
 
-int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
-			   struct inode *new_dir, struct dentry *new_dentry)
+int security_inode_rename(struct path *old_dir, struct dentry *old_dentry,
+			   struct path *new_dir, struct dentry *new_dentry)
 {
         if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
             (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-29 12:20:55.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-29 12:20:55.000000000 +0200
@@ -2539,10 +2539,11 @@ static int selinux_inode_mknod(struct pa
 			  inode_mode_to_security_class(mode));
 }
 
-static int selinux_inode_rename(struct inode *old_inode, struct dentry *old_dentry,
-				struct inode *new_inode, struct dentry *new_dentry)
+static int selinux_inode_rename(struct path *old_dir, struct dentry *old_dentry,
+				struct path *new_dir, struct dentry *new_dentry)
 {
-	return may_rename(old_inode, old_dentry, new_inode, new_dentry);
+	return may_rename(old_dir->dentry->d_inode, old_dentry,
+			  new_dir->dentry->d_inode, new_dentry);
 }
 
 static int selinux_inode_readlink(struct dentry *dentry)
Index: linux-2.6/security/smack/smack_lsm.c
===================================================================
--- linux-2.6.orig/security/smack/smack_lsm.c	2008-05-29 12:20:55.000000000 +0200
+++ linux-2.6/security/smack/smack_lsm.c	2008-05-29 12:20:55.000000000 +0200
@@ -482,9 +482,9 @@ static int smack_inode_rmdir(struct path
 
 /**
  * smack_inode_rename - Smack check on rename
- * @old_inode: the old directory
+ * @old_dir: the old directory
  * @old_dentry: unused
- * @new_inode: the new directory
+ * @new_dir: the new directory
  * @new_dentry: unused
  *
  * Read and write access is required on both the old and
@@ -492,9 +492,9 @@ static int smack_inode_rmdir(struct path
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_rename(struct inode *old_inode,
+static int smack_inode_rename(struct path *old_dir,
 			      struct dentry *old_dentry,
-			      struct inode *new_inode,
+			      struct path *new_dir,
 			      struct dentry *new_dentry)
 {
 	int rc;

--
