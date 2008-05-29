Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbYE2NvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbYE2NvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbYE2Nuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:50:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46097 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555AbYE2Nuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:50:37 -0400
Message-Id: <20080529135002.377576275@szeredi.hu>
References: <20080529134903.615127628@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 15:49:07 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 04/15] security: pass path to inode_rmdir
Content-Disposition: inline; filename=security_rmdir_path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In the inode_rmdir() security operation and related functions pass the
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
--- linux-2.6.orig/fs/namei.c	2008-05-29 12:20:52.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-29 12:20:53.000000000 +0200
@@ -2244,10 +2244,10 @@ void dentry_unhash(struct dentry *dentry
 	spin_unlock(&dcache_lock);
 }
 
-static int vfs_rmdir(struct dentry *dir_dentry, struct dentry *dentry)
+static int vfs_rmdir(struct path *dir_path, struct dentry *dentry)
 {
-	struct inode *dir = dir_dentry->d_inode;
-	int error = may_delete(dir_dentry, dentry, 1);
+	struct inode *dir = dir_path->dentry->d_inode;
+	int error = may_delete(dir_path->dentry, dentry, 1);
 
 	if (error)
 		return error;
@@ -2262,7 +2262,7 @@ static int vfs_rmdir(struct dentry *dir_
 	if (d_mountpoint(dentry))
 		error = -EBUSY;
 	else {
-		error = security_inode_rmdir(dir, dentry);
+		error = security_inode_rmdir(dir_path, dentry);
 		if (!error) {
 			error = dir->i_op->rmdir(dir, dentry);
 			if (!error)
@@ -2283,7 +2283,7 @@ int path_rmdir(struct path *dir_path, st
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_rmdir(dir_path->dentry, dentry);
+		error = vfs_rmdir(dir_path, dentry);
 		mnt_drop_write(dir_path->mnt);
 	}
 
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-05-29 12:20:52.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-05-29 12:20:53.000000000 +0200
@@ -369,7 +369,7 @@ static inline void security_free_mnt_opt
  *	Return 0 if permission is granted.
  * @inode_rmdir:
  *	Check the permission to remove a directory.
- *	@dir contains the inode structure of parent of the directory to be removed.
+ *	@dir contains the path to the parent of the directory to be removed.
  *	@dentry contains the dentry structure of directory to be removed.
  *	Return 0 if permission is granted.
  * @inode_mknod:
@@ -1360,7 +1360,7 @@ struct security_operations {
 	int (*inode_symlink) (struct inode *dir,
 			      struct dentry *dentry, const char *old_name);
 	int (*inode_mkdir) (struct path *dir, struct dentry *dentry, int mode);
-	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
+	int (*inode_rmdir) (struct path *dir, struct dentry *dentry);
 	int (*inode_mknod) (struct path *dir, struct dentry *dentry,
 			    int mode, dev_t dev);
 	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
@@ -1632,7 +1632,7 @@ int security_inode_unlink(struct inode *
 int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 			   const char *old_name);
 int security_inode_mkdir(struct path *dir, struct dentry *dentry, int mode);
-int security_inode_rmdir(struct inode *dir, struct dentry *dentry);
+int security_inode_rmdir(struct path *dir, struct dentry *dentry);
 int security_inode_mknod(struct path *dir, struct dentry *dentry, int mode,
 			 dev_t dev);
 int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
@@ -1998,7 +1998,7 @@ static inline int security_inode_mkdir(s
 	return 0;
 }
 
-static inline int security_inode_rmdir(struct inode *dir,
+static inline int security_inode_rmdir(struct path *dir,
 					struct dentry *dentry)
 {
 	return 0;
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-05-29 12:20:52.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-05-29 12:20:53.000000000 +0200
@@ -315,7 +315,7 @@ static int dummy_inode_mkdir(struct path
 	return 0;
 }
 
-static int dummy_inode_rmdir (struct inode *inode, struct dentry *dentry)
+static int dummy_inode_rmdir(struct path *dir, struct dentry *dentry)
 {
 	return 0;
 }
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-29 12:20:52.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-29 12:20:53.000000000 +0200
@@ -425,7 +425,7 @@ int security_inode_mkdir(struct path *di
 	return security_ops->inode_mkdir(dir, dentry, mode);
 }
 
-int security_inode_rmdir(struct inode *dir, struct dentry *dentry)
+int security_inode_rmdir(struct path *dir, struct dentry *dentry)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-29 12:20:52.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-29 12:20:53.000000000 +0200
@@ -2519,9 +2519,9 @@ static int selinux_inode_mkdir(struct pa
 	return may_create(dir->dentry->d_inode, dentry, SECCLASS_DIR);
 }
 
-static int selinux_inode_rmdir(struct inode *dir, struct dentry *dentry)
+static int selinux_inode_rmdir(struct path *dir, struct dentry *dentry)
 {
-	return may_link(dir, dentry, MAY_RMDIR);
+	return may_link(dir->dentry->d_inode, dentry, MAY_RMDIR);
 }
 
 static int selinux_inode_mknod(struct path *dir, struct dentry *dentry,
Index: linux-2.6/security/smack/smack_lsm.c
===================================================================
--- linux-2.6.orig/security/smack/smack_lsm.c	2008-05-29 12:20:48.000000000 +0200
+++ linux-2.6/security/smack/smack_lsm.c	2008-05-29 12:20:53.000000000 +0200
@@ -463,7 +463,7 @@ static int smack_inode_unlink(struct ino
  * Returns 0 if current can write the containing directory
  * and the directory, error code otherwise
  */
-static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
+static int smack_inode_rmdir(struct path *dir, struct dentry *dentry)
 {
 	int rc;
 
@@ -475,7 +475,7 @@ static int smack_inode_rmdir(struct inod
 		/*
 		 * You also need write access to the containing directory
 		 */
-		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+		rc = smk_curacc(smk_of_inode(dir->dentry->d_inode), MAY_WRITE);
 
 	return rc;
 }

--
