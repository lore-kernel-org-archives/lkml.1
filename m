Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbYE2Nwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbYE2Nwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbYE2Nu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:50:58 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46130 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904AbYE2Nuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:50:52 -0400
Message-Id: <20080529135005.097661767@szeredi.hu>
References: <20080529134903.615127628@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 15:49:09 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 06/15] security: pass path to inode_symlink
Content-Disposition: inline; filename=security_symlink_path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In the inode_symlink() security operation and related functions pass the
path (vfsmount + dentry) to the parent directory instead of the inode.
AppArmor will need this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c               |   10 +++++-----
 include/linux/security.h |    6 +++---
 security/dummy.c         |    4 ++--
 security/security.c      |    4 ++--
 security/selinux/hooks.c |    5 +++--
 5 files changed, 15 insertions(+), 14 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-29 12:20:53.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-29 12:20:54.000000000 +0200
@@ -2452,11 +2452,11 @@ asmlinkage long sys_unlink(const char __
 	return do_unlinkat(AT_FDCWD, pathname);
 }
 
-static int vfs_symlink(struct dentry *dir_dentry, struct dentry *dentry,
+static int vfs_symlink(struct path *dir_path, struct dentry *dentry,
 		       const char *oldname)
 {
-	struct inode *dir = dir_dentry->d_inode;
-	int error = may_create(dir_dentry, dentry);
+	struct inode *dir = dir_path->dentry->d_inode;
+	int error = may_create(dir_path->dentry, dentry);
 
 	if (error)
 		return error;
@@ -2464,7 +2464,7 @@ static int vfs_symlink(struct dentry *di
 	if (!dir->i_op || !dir->i_op->symlink)
 		return -EPERM;
 
-	error = security_inode_symlink(dir, dentry, oldname);
+	error = security_inode_symlink(dir_path, dentry, oldname);
 	if (error)
 		return error;
 
@@ -2481,7 +2481,7 @@ int path_symlink(struct path *dir_path, 
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_symlink(dir_path->dentry, dentry, oldname);
+		error = vfs_symlink(dir_path, dentry, oldname);
 		mnt_drop_write(dir_path->mnt);
 	}
 
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-05-29 12:20:53.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-05-29 12:20:54.000000000 +0200
@@ -1357,7 +1357,7 @@ struct security_operations {
 	int (*inode_link) (struct dentry *old_dentry,
 			   struct inode *dir, struct dentry *new_dentry);
 	int (*inode_unlink) (struct path *dir, struct dentry *dentry);
-	int (*inode_symlink) (struct inode *dir,
+	int (*inode_symlink) (struct path *dir,
 			      struct dentry *dentry, const char *old_name);
 	int (*inode_mkdir) (struct path *dir, struct dentry *dentry, int mode);
 	int (*inode_rmdir) (struct path *dir, struct dentry *dentry);
@@ -1629,7 +1629,7 @@ int security_inode_create(struct path *d
 int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 			 struct dentry *new_dentry);
 int security_inode_unlink(struct path *dir, struct dentry *dentry);
-int security_inode_symlink(struct inode *dir, struct dentry *dentry,
+int security_inode_symlink(struct path *dir, struct dentry *dentry,
 			   const char *old_name);
 int security_inode_mkdir(struct path *dir, struct dentry *dentry, int mode);
 int security_inode_rmdir(struct path *dir, struct dentry *dentry);
@@ -1984,7 +1984,7 @@ static inline int security_inode_unlink(
 	return 0;
 }
 
-static inline int security_inode_symlink(struct inode *dir,
+static inline int security_inode_symlink(struct path *dir,
 					  struct dentry *dentry,
 					  const char *old_name)
 {
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-05-29 12:20:53.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-05-29 12:20:54.000000000 +0200
@@ -303,8 +303,8 @@ static int dummy_inode_unlink(struct pat
 	return 0;
 }
 
-static int dummy_inode_symlink (struct inode *inode, struct dentry *dentry,
-				const char *name)
+static int dummy_inode_symlink(struct path *dir, struct dentry *dentry,
+			       const char *name)
 {
 	return 0;
 }
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-29 12:20:53.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-29 12:20:54.000000000 +0200
@@ -410,10 +410,10 @@ int security_inode_unlink(struct path *d
 	return security_ops->inode_unlink(dir, dentry);
 }
 
-int security_inode_symlink(struct inode *dir, struct dentry *dentry,
+int security_inode_symlink(struct path *dir, struct dentry *dentry,
 			    const char *old_name)
 {
-	if (unlikely(IS_PRIVATE(dir)))
+	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
 	return security_ops->inode_symlink(dir, dentry, old_name);
 }
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-29 12:20:53.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-29 12:20:54.000000000 +0200
@@ -2508,9 +2508,10 @@ static int selinux_inode_unlink(struct p
 	return may_link(dir->dentry->d_inode, dentry, MAY_UNLINK);
 }
 
-static int selinux_inode_symlink(struct inode *dir, struct dentry *dentry, const char *name)
+static int selinux_inode_symlink(struct path *dir, struct dentry *dentry,
+				 const char *name)
 {
-	return may_create(dir, dentry, SECCLASS_LNK_FILE);
+	return may_create(dir->dentry->d_inode, dentry, SECCLASS_LNK_FILE);
 }
 
 static int selinux_inode_mkdir(struct path *dir, struct dentry *dentry,

--
