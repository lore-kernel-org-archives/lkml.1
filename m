Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYE2Nym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYE2Nym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbYE2Nv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:51:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46157 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074AbYE2NvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:51:06 -0400
Message-Id: <20080529135001.046147422@szeredi.hu>
References: <20080529134903.615127628@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 15:49:06 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 03/15] security: pass path to inode_mkdir
Content-Disposition: inline; filename=security_mkdir_path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In the inode_mkdir() security operation and related functions pass the
path (vfsmount + dentry) to the parent directory instead of the inode.
AppArmor will need this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c               |   10 +++++-----
 include/linux/security.h |    8 ++++----
 security/dummy.c         |    4 ++--
 security/security.c      |    4 ++--
 security/selinux/hooks.c |    5 +++--
 5 files changed, 16 insertions(+), 15 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-29 12:20:52.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-29 12:20:52.000000000 +0200
@@ -2143,10 +2143,10 @@ asmlinkage long sys_mknod(const char __u
 	return sys_mknodat(AT_FDCWD, filename, mode, dev);
 }
 
-static int vfs_mkdir(struct dentry *dir_dentry, struct dentry *dentry, int mode)
+static int vfs_mkdir(struct path *dir_path, struct dentry *dentry, int mode)
 {
-	struct inode *dir = dir_dentry->d_inode;
-	int error = may_create(dir_dentry, dentry);
+	struct inode *dir = dir_path->dentry->d_inode;
+	int error = may_create(dir_path->dentry, dentry);
 
 	if (error)
 		return error;
@@ -2155,7 +2155,7 @@ static int vfs_mkdir(struct dentry *dir_
 		return -EPERM;
 
 	mode &= (S_IRWXUGO|S_ISVTX);
-	error = security_inode_mkdir(dir, dentry, mode);
+	error = security_inode_mkdir(dir_path, dentry, mode);
 	if (error)
 		return error;
 
@@ -2171,7 +2171,7 @@ int path_mkdir(struct path *dir_path, st
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_mkdir(dir_path->dentry, dentry, mode);
+		error = vfs_mkdir(dir_path, dentry, mode);
 		mnt_drop_write(dir_path->mnt);
 	}
 
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-05-29 12:20:52.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-05-29 12:20:52.000000000 +0200
@@ -363,7 +363,7 @@ static inline void security_free_mnt_opt
  * @inode_mkdir:
  *	Check permissions to create a new directory in the existing directory
  *	associated with inode strcture @dir.
- *	@dir containst the inode structure of parent of the directory to be created.
+ *	@dir contains the path to the parent of the new directory.
  *	@dentry contains the dentry structure of new directory.
  *	@mode contains the mode of new directory.
  *	Return 0 if permission is granted.
@@ -1359,7 +1359,7 @@ struct security_operations {
 	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
 	int (*inode_symlink) (struct inode *dir,
 			      struct dentry *dentry, const char *old_name);
-	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry, int mode);
+	int (*inode_mkdir) (struct path *dir, struct dentry *dentry, int mode);
 	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
 	int (*inode_mknod) (struct path *dir, struct dentry *dentry,
 			    int mode, dev_t dev);
@@ -1631,7 +1631,7 @@ int security_inode_link(struct dentry *o
 int security_inode_unlink(struct inode *dir, struct dentry *dentry);
 int security_inode_symlink(struct inode *dir, struct dentry *dentry,
 			   const char *old_name);
-int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode);
+int security_inode_mkdir(struct path *dir, struct dentry *dentry, int mode);
 int security_inode_rmdir(struct inode *dir, struct dentry *dentry);
 int security_inode_mknod(struct path *dir, struct dentry *dentry, int mode,
 			 dev_t dev);
@@ -1991,7 +1991,7 @@ static inline int security_inode_symlink
 	return 0;
 }
 
-static inline int security_inode_mkdir(struct inode *dir,
+static inline int security_inode_mkdir(struct path *dir,
 					struct dentry *dentry,
 					int mode)
 {
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-05-29 12:20:52.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-05-29 12:20:52.000000000 +0200
@@ -309,8 +309,8 @@ static int dummy_inode_symlink (struct i
 	return 0;
 }
 
-static int dummy_inode_mkdir (struct inode *inode, struct dentry *dentry,
-			      int mask)
+static int dummy_inode_mkdir(struct path *dir, struct dentry *dentry,
+			     int mask)
 {
 	return 0;
 }
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-29 12:20:52.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-29 12:20:52.000000000 +0200
@@ -418,9 +418,9 @@ int security_inode_symlink(struct inode 
 	return security_ops->inode_symlink(dir, dentry, old_name);
 }
 
-int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+int security_inode_mkdir(struct path *dir, struct dentry *dentry, int mode)
 {
-	if (unlikely(IS_PRIVATE(dir)))
+	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
 	return security_ops->inode_mkdir(dir, dentry, mode);
 }
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-29 12:20:52.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-29 12:20:52.000000000 +0200
@@ -2513,9 +2513,10 @@ static int selinux_inode_symlink(struct 
 	return may_create(dir, dentry, SECCLASS_LNK_FILE);
 }
 
-static int selinux_inode_mkdir(struct inode *dir, struct dentry *dentry, int mask)
+static int selinux_inode_mkdir(struct path *dir, struct dentry *dentry,
+			       int mask)
 {
-	return may_create(dir, dentry, SECCLASS_DIR);
+	return may_create(dir->dentry->d_inode, dentry, SECCLASS_DIR);
 }
 
 static int selinux_inode_rmdir(struct inode *dir, struct dentry *dentry)

--
