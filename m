Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbYE2Nws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbYE2Nws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757086AbYE2NvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:51:05 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46133 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920AbYE2Nuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:50:55 -0400
Message-Id: <20080529135003.574344415@szeredi.hu>
References: <20080529134903.615127628@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 15:49:08 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 05/15] security: pass path to inode_unlink
Content-Disposition: inline; filename=security_unlink_path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In the inode_unlink() security operation and related functions pass the
path (vfsmount + dentry) to the parent directory instead of the inode.
AppArmor will need this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c                 |   10 +++++-----
 include/linux/security.h   |    8 ++++----
 security/dummy.c           |    2 +-
 security/security.c        |    2 +-
 security/selinux/hooks.c   |    4 ++--
 security/smack/smack_lsm.c |    4 ++--
 6 files changed, 15 insertions(+), 15 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-29 12:20:53.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-29 12:20:53.000000000 +0200
@@ -2338,10 +2338,10 @@ asmlinkage long sys_rmdir(const char __u
 	return do_rmdir(AT_FDCWD, pathname);
 }
 
-static int vfs_unlink(struct dentry *dir_dentry, struct dentry *dentry)
+static int vfs_unlink(struct path *dir_path, struct dentry *dentry)
 {
-	struct inode *dir = dir_dentry->d_inode;
-	int error = may_delete(dir_dentry, dentry, 0);
+	struct inode *dir = dir_path->dentry->d_inode;
+	int error = may_delete(dir_path->dentry, dentry, 0);
 
 	if (error)
 		return error;
@@ -2355,7 +2355,7 @@ static int vfs_unlink(struct dentry *dir
 	if (d_mountpoint(dentry))
 		error = -EBUSY;
 	else {
-		error = security_inode_unlink(dir, dentry);
+		error = security_inode_unlink(dir_path, dentry);
 		if (!error)
 			error = dir->i_op->unlink(dir, dentry);
 	}
@@ -2375,7 +2375,7 @@ int path_unlink(struct path *dir_path, s
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_unlink(dir_path->dentry, dentry);
+		error = vfs_unlink(dir_path, dentry);
 		mnt_drop_write(dir_path->mnt);
 	}
 
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-05-29 12:20:53.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-05-29 12:20:53.000000000 +0200
@@ -351,7 +351,7 @@ static inline void security_free_mnt_opt
  *	Return 0 if permission is granted.
  * @inode_unlink:
  *	Check the permission to remove a hard link to a file.
- *	@dir contains the inode structure of parent directory of the file.
+ *	@dir contains the path to the parent of the file to be removed.
  *	@dentry contains the dentry structure for file to be unlinked.
  *	Return 0 if permission is granted.
  * @inode_symlink:
@@ -1356,7 +1356,7 @@ struct security_operations {
 	int (*inode_create) (struct path *dir, struct dentry *dentry, int mode);
 	int (*inode_link) (struct dentry *old_dentry,
 			   struct inode *dir, struct dentry *new_dentry);
-	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
+	int (*inode_unlink) (struct path *dir, struct dentry *dentry);
 	int (*inode_symlink) (struct inode *dir,
 			      struct dentry *dentry, const char *old_name);
 	int (*inode_mkdir) (struct path *dir, struct dentry *dentry, int mode);
@@ -1628,7 +1628,7 @@ int security_inode_init_security(struct 
 int security_inode_create(struct path *dir, struct dentry *dentry, int mode);
 int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 			 struct dentry *new_dentry);
-int security_inode_unlink(struct inode *dir, struct dentry *dentry);
+int security_inode_unlink(struct path *dir, struct dentry *dentry);
 int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 			   const char *old_name);
 int security_inode_mkdir(struct path *dir, struct dentry *dentry, int mode);
@@ -1978,7 +1978,7 @@ static inline int security_inode_link(st
 	return 0;
 }
 
-static inline int security_inode_unlink(struct inode *dir,
+static inline int security_inode_unlink(struct path *dir,
 					 struct dentry *dentry)
 {
 	return 0;
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-05-29 12:20:53.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-05-29 12:20:53.000000000 +0200
@@ -298,7 +298,7 @@ static int dummy_inode_link (struct dent
 	return 0;
 }
 
-static int dummy_inode_unlink (struct inode *inode, struct dentry *dentry)
+static int dummy_inode_unlink(struct path *dir, struct dentry *dentry)
 {
 	return 0;
 }
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-29 12:20:53.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-29 12:20:53.000000000 +0200
@@ -403,7 +403,7 @@ int security_inode_link(struct dentry *o
 	return security_ops->inode_link(old_dentry, dir, new_dentry);
 }
 
-int security_inode_unlink(struct inode *dir, struct dentry *dentry)
+int security_inode_unlink(struct path *dir, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-29 12:20:53.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-29 12:20:53.000000000 +0200
@@ -2498,14 +2498,14 @@ static int selinux_inode_link(struct den
 	return may_link(dir, old_dentry, MAY_LINK);
 }
 
-static int selinux_inode_unlink(struct inode *dir, struct dentry *dentry)
+static int selinux_inode_unlink(struct path *dir, struct dentry *dentry)
 {
 	int rc;
 
 	rc = secondary_ops->inode_unlink(dir, dentry);
 	if (rc)
 		return rc;
-	return may_link(dir, dentry, MAY_UNLINK);
+	return may_link(dir->dentry->d_inode, dentry, MAY_UNLINK);
 }
 
 static int selinux_inode_symlink(struct inode *dir, struct dentry *dentry, const char *name)
Index: linux-2.6/security/smack/smack_lsm.c
===================================================================
--- linux-2.6.orig/security/smack/smack_lsm.c	2008-05-29 12:20:53.000000000 +0200
+++ linux-2.6/security/smack/smack_lsm.c	2008-05-29 12:20:53.000000000 +0200
@@ -437,7 +437,7 @@ static int smack_inode_link(struct dentr
  * Returns 0 if current can write the containing directory
  * and the object, error code otherwise
  */
-static int smack_inode_unlink(struct inode *dir, struct dentry *dentry)
+static int smack_inode_unlink(struct path *dir, struct dentry *dentry)
 {
 	struct inode *ip = dentry->d_inode;
 	int rc;
@@ -450,7 +450,7 @@ static int smack_inode_unlink(struct ino
 		/*
 		 * You also need write access to the containing directory
 		 */
-		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+		rc = smk_curacc(smk_of_inode(dir->dentry->d_inode), MAY_WRITE);
 
 	return rc;
 }

--
