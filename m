Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbYE2NxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbYE2NxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbYE2NvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:51:10 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46146 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbYE2NvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:51:03 -0400
Message-Id: <20080529135000.143846766@szeredi.hu>
References: <20080529134903.615127628@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 15:49:05 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 02/15] security: pass path to inode_mknod
Content-Disposition: inline; filename=security_mknod_path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In the inode_mknod() security operation and related functions pass the
path (vfsmount + dentry) to the parent directory instead of the inode.
AppArmor will need this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c               |   10 +++++-----
 include/linux/security.h |    9 +++++----
 security/dummy.c         |    4 ++--
 security/security.c      |    5 +++--
 security/selinux/hooks.c |    6 ++++--
 5 files changed, 19 insertions(+), 15 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-29 12:20:51.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-29 12:20:52.000000000 +0200
@@ -2044,11 +2044,11 @@ fail:
 }
 EXPORT_SYMBOL_GPL(lookup_create);
 
-static int vfs_mknod(struct dentry *dir_dentry, struct dentry *dentry,
+static int vfs_mknod(struct path *dir_path, struct dentry *dentry,
 		     int mode, dev_t dev)
 {
-	struct inode *dir = dir_dentry->d_inode;
-	int error = may_create(dir_dentry, dentry);
+	struct inode *dir = dir_path->dentry->d_inode;
+	int error = may_create(dir_path->dentry, dentry);
 
 	if (error)
 		return error;
@@ -2063,7 +2063,7 @@ static int vfs_mknod(struct dentry *dir_
 	if (error)
 		return error;
 
-	error = security_inode_mknod(dir, dentry, mode, dev);
+	error = security_inode_mknod(dir_path, dentry, mode, dev);
 	if (error)
 		return error;
 
@@ -2080,7 +2080,7 @@ int path_mknod(struct path *dir_path, st
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_mknod(dir_path->dentry, dentry, mode, dev);
+		error = vfs_mknod(dir_path, dentry, mode, dev);
 		mnt_drop_write(dir_path->mnt);
 	}
 
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-05-29 12:20:51.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-05-29 12:20:52.000000000 +0200
@@ -377,7 +377,7 @@ static inline void security_free_mnt_opt
  *	file created via the mknod system call).  Note that if mknod operation
  *	is being done for a regular file, then the create hook will be called
  *	and not this hook.
- *	@dir contains the inode structure of parent of the new file.
+ *	@dir contains the path to the parent of the new file.
  *	@dentry contains the dentry structure of the new file.
  *	@mode contains the mode of the new file.
  *	@dev contains the device number.
@@ -1361,7 +1361,7 @@ struct security_operations {
 			      struct dentry *dentry, const char *old_name);
 	int (*inode_mkdir) (struct inode *dir, struct dentry *dentry, int mode);
 	int (*inode_rmdir) (struct inode *dir, struct dentry *dentry);
-	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
+	int (*inode_mknod) (struct path *dir, struct dentry *dentry,
 			    int mode, dev_t dev);
 	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
 			     struct inode *new_dir, struct dentry *new_dentry);
@@ -1633,7 +1633,8 @@ int security_inode_symlink(struct inode 
 			   const char *old_name);
 int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode);
 int security_inode_rmdir(struct inode *dir, struct dentry *dentry);
-int security_inode_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev);
+int security_inode_mknod(struct path *dir, struct dentry *dentry, int mode,
+			 dev_t dev);
 int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
 			  struct inode *new_dir, struct dentry *new_dentry);
 int security_inode_readlink(struct dentry *dentry);
@@ -2003,7 +2004,7 @@ static inline int security_inode_rmdir(s
 	return 0;
 }
 
-static inline int security_inode_mknod(struct inode *dir,
+static inline int security_inode_mknod(struct path *dir,
 					struct dentry *dentry,
 					int mode, dev_t dev)
 {
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-05-29 12:20:51.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-05-29 12:20:52.000000000 +0200
@@ -320,8 +320,8 @@ static int dummy_inode_rmdir (struct ino
 	return 0;
 }
 
-static int dummy_inode_mknod (struct inode *inode, struct dentry *dentry,
-			      int mode, dev_t dev)
+static int dummy_inode_mknod(struct path *dir, struct dentry *dentry,
+			     int mode, dev_t dev)
 {
 	return 0;
 }
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-29 12:20:51.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-29 12:20:52.000000000 +0200
@@ -432,9 +432,10 @@ int security_inode_rmdir(struct inode *d
 	return security_ops->inode_rmdir(dir, dentry);
 }
 
-int security_inode_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+int security_inode_mknod(struct path *dir, struct dentry *dentry, int mode,
+			 dev_t dev)
 {
-	if (unlikely(IS_PRIVATE(dir)))
+	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
 	return security_ops->inode_mknod(dir, dentry, mode, dev);
 }
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-29 12:20:51.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-29 12:20:52.000000000 +0200
@@ -2523,7 +2523,8 @@ static int selinux_inode_rmdir(struct in
 	return may_link(dir, dentry, MAY_RMDIR);
 }
 
-static int selinux_inode_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+static int selinux_inode_mknod(struct path *dir, struct dentry *dentry,
+			       int mode, dev_t dev)
 {
 	int rc;
 
@@ -2531,7 +2532,8 @@ static int selinux_inode_mknod(struct in
 	if (rc)
 		return rc;
 
-	return may_create(dir, dentry, inode_mode_to_security_class(mode));
+	return may_create(dir->dentry->d_inode, dentry,
+			  inode_mode_to_security_class(mode));
 }
 
 static int selinux_inode_rename(struct inode *old_inode, struct dentry *old_dentry,

--
