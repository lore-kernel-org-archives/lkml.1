Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbYE2NyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbYE2NyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757158AbYE2NvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:51:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46164 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111AbYE2NvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:51:09 -0400
Message-Id: <20080529134958.655985182@szeredi.hu>
References: <20080529134903.615127628@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 15:49:04 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 01/15] security: pass path to inode_create
Content-Disposition: inline; filename=security_create_path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In the inode_create() security operation and related functions pass
the path (vfsmount + dentry) to the parent directory instead of the
inode.  AppArmor will need this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c               |   12 ++++++------
 include/linux/security.h |    9 ++++-----
 security/dummy.c         |    4 ++--
 security/security.c      |    4 ++--
 security/selinux/hooks.c |    5 +++--
 5 files changed, 17 insertions(+), 17 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-29 12:20:49.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-29 12:20:51.000000000 +0200
@@ -1586,11 +1586,11 @@ void unlock_rename(struct dentry *p1, st
 	}
 }
 
-static int vfs_create(struct dentry *dir_dentry, struct dentry *dentry,
+static int vfs_create(struct path *dir_path, struct dentry *dentry,
 		      int mode,	struct nameidata *nd)
 {
-	struct inode *dir = dir_dentry->d_inode;
-	int error = may_create(dir_dentry, dentry);
+	struct inode *dir = dir_path->dentry->d_inode;
+	int error = may_create(dir_path->dentry, dentry);
 
 	if (error)
 		return error;
@@ -1599,7 +1599,7 @@ static int vfs_create(struct dentry *dir
 		return -EACCES;	/* shouldn't it be ENOSYS? */
 	mode &= S_IALLUGO;
 	mode |= S_IFREG;
-	error = security_inode_create(dir, dentry, mode);
+	error = security_inode_create(dir_path, dentry, mode);
 	if (error)
 		return error;
 	DQUOT_INIT(dir);
@@ -1615,7 +1615,7 @@ int path_create(struct path *dir_path, s
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_create(dir_path->dentry, dentry, mode, nd);
+		error = vfs_create(dir_path, dentry, mode, nd);
 		mnt_drop_write(dir_path->mnt);
 	}
 
@@ -1718,7 +1718,7 @@ static int __open_namei_create(struct na
 
 	if (!IS_POSIXACL(dir->d_inode))
 		mode &= ~current->fs->umask;
-	error = vfs_create(dir, path->dentry, mode, nd);
+	error = vfs_create(&nd->path, path->dentry, mode, nd);
 	mutex_unlock(&dir->d_inode->i_mutex);
 	dput(nd->path.dentry);
 	nd->path.dentry = path->dentry;
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-05-29 12:20:48.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-05-29 12:20:51.000000000 +0200
@@ -339,7 +339,7 @@ static inline void security_free_mnt_opt
  *		-ENOMEM on memory allocation failure.
  * @inode_create:
  *	Check permission to create a regular file.
- *	@dir contains inode structure of the parent of the new file.
+ *	@dir contains the path to the parent of the new file.
  *	@dentry contains the dentry structure for the file to be created.
  *	@mode contains the file mode of the file to be created.
  *	Return 0 if permission is granted.
@@ -1353,8 +1353,7 @@ struct security_operations {
 	void (*inode_free_security) (struct inode *inode);
 	int (*inode_init_security) (struct inode *inode, struct inode *dir,
 				    char **name, void **value, size_t *len);
-	int (*inode_create) (struct inode *dir,
-			     struct dentry *dentry, int mode);
+	int (*inode_create) (struct path *dir, struct dentry *dentry, int mode);
 	int (*inode_link) (struct dentry *old_dentry,
 			   struct inode *dir, struct dentry *new_dentry);
 	int (*inode_unlink) (struct inode *dir, struct dentry *dentry);
@@ -1626,7 +1625,7 @@ int security_inode_alloc(struct inode *i
 void security_inode_free(struct inode *inode);
 int security_inode_init_security(struct inode *inode, struct inode *dir,
 				  char **name, void **value, size_t *len);
-int security_inode_create(struct inode *dir, struct dentry *dentry, int mode);
+int security_inode_create(struct path *dir, struct dentry *dentry, int mode);
 int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 			 struct dentry *new_dentry);
 int security_inode_unlink(struct inode *dir, struct dentry *dentry);
@@ -1964,7 +1963,7 @@ static inline int security_inode_init_se
 	return -EOPNOTSUPP;
 }
 
-static inline int security_inode_create(struct inode *dir,
+static inline int security_inode_create(struct path *dir,
 					 struct dentry *dentry,
 					 int mode)
 {
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-05-29 12:20:48.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-05-29 12:20:51.000000000 +0200
@@ -286,8 +286,8 @@ static int dummy_inode_init_security (st
 	return -EOPNOTSUPP;
 }
 
-static int dummy_inode_create (struct inode *inode, struct dentry *dentry,
-			       int mask)
+static int dummy_inode_create(struct path *dir, struct dentry *dentry,
+			      int mask)
 {
 	return 0;
 }
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-29 12:20:48.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-29 12:20:51.000000000 +0200
@@ -2482,9 +2482,10 @@ static int selinux_inode_init_security(s
 	return 0;
 }
 
-static int selinux_inode_create(struct inode *dir, struct dentry *dentry, int mask)
+static int selinux_inode_create(struct path *dir, struct dentry *dentry,
+				int mask)
 {
-	return may_create(dir, dentry, SECCLASS_FILE);
+	return may_create(dir->dentry->d_inode, dentry, SECCLASS_FILE);
 }
 
 static int selinux_inode_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry)
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-29 12:20:48.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-29 12:20:51.000000000 +0200
@@ -388,9 +388,9 @@ int security_inode_init_security(struct 
 }
 EXPORT_SYMBOL(security_inode_init_security);
 
-int security_inode_create(struct inode *dir, struct dentry *dentry, int mode)
+int security_inode_create(struct path *dir, struct dentry *dentry, int mode)
 {
-	if (unlikely(IS_PRIVATE(dir)))
+	if (unlikely(IS_PRIVATE(dir->dentry->d_inode)))
 		return 0;
 	return security_ops->inode_create(dir, dentry, mode);
 }

--
