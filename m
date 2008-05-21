Return-Path: <linux-kernel-owner+w=401wt.eu-S936522AbYEURWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936522AbYEURWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935980AbYEURQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:16:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33083 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935630AbYEURQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:16:09 -0400
Message-Id: <20080521171558.595584843@szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 21 May 2008 19:15:10 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 12/14] vfs: create path_permission()
Content-Disposition: inline; filename=path_permission.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Push nameidata further up the call chain, completely removing it from
the permission API.

Switch calls of vfs_permission() to path_permission().  Instead of
nameidata, pass the path and nameidata->flags to this function.

This is a trivially equivalent transformation.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/exec.c          |    4 ++--
 fs/inotify_user.c  |    2 +-
 fs/namei.c         |   23 ++++++++++++-----------
 fs/open.c          |    8 ++++----
 fs/utimes.c        |    2 +-
 include/linux/fs.h |    2 +-
 net/unix/af_unix.c |    2 +-
 7 files changed, 22 insertions(+), 21 deletions(-)

Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c	2008-05-21 18:14:45.000000000 +0200
+++ linux-2.6/fs/exec.c	2008-05-21 18:15:02.000000000 +0200
@@ -116,7 +116,7 @@ asmlinkage long sys_uselib(const char __
 	if (!S_ISREG(nd.path.dentry->d_inode->i_mode))
 		goto exit;
 
-	error = vfs_permission(&nd, MAY_READ | MAY_EXEC);
+	error = path_permission(&nd.path, MAY_READ | MAY_EXEC, nd.flags);
 	if (error)
 		goto exit;
 
@@ -664,7 +664,7 @@ struct file *open_exec(const char *name)
 		struct inode *inode = nd.path.dentry->d_inode;
 		file = ERR_PTR(-EACCES);
 		if (S_ISREG(inode->i_mode)) {
-			int err = vfs_permission(&nd, MAY_EXEC);
+			int err = path_permission(&nd.path, MAY_EXEC, nd.flags);
 			file = ERR_PTR(err);
 			if (!err) {
 				file = nameidata_to_filp(&nd,
Index: linux-2.6/fs/inotify_user.c
===================================================================
--- linux-2.6.orig/fs/inotify_user.c	2008-05-21 18:14:45.000000000 +0200
+++ linux-2.6/fs/inotify_user.c	2008-05-21 18:15:02.000000000 +0200
@@ -365,7 +365,7 @@ static int find_inode(const char __user 
 	if (error)
 		return error;
 	/* you can only watch an inode if you have read permissions on it */
-	error = vfs_permission(nd, MAY_READ);
+	error = path_permission(&nd->path, MAY_READ, nd->flags);
 	if (error)
 		path_put(&nd->path);
 	return error;
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-21 18:14:45.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-21 18:15:02.000000000 +0200
@@ -286,22 +286,23 @@ int dentry_permission(struct dentry *den
 }
 
 /**
- * vfs_permission  -  check for access rights to a given path
- * @nd:		lookup result that describes the path
+ * path_permission  -  check for access rights to a given path
+ * @path:	lookup result that describes the path
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ * @flags:	lookup flags
  *
  * Used to check for read/write/execute permissions on a path.
  * We use "fsuid" for this, letting us set arbitrary permissions
  * for filesystem access without changing the "normal" uids which
  * are used for other things.
  */
-int vfs_permission(struct nameidata *nd, int mask)
+int path_permission(struct path *path, int mask, int flags)
 {
-	struct dentry *dentry = nd->path.dentry;
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
 
 	if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode)) {
-		struct vfsmount *mnt = nd->path.mnt;
+		struct vfsmount *mnt = path->mnt;
 
 		/*
 		 * MAY_EXEC on regular files is denied if the fs is mounted
@@ -311,7 +312,7 @@ int vfs_permission(struct nameidata *nd,
 			return -EACCES;
 	}
 
-	return dentry_permission(dentry, mask, nd->flags);
+	return dentry_permission(dentry, mask, flags);
 }
 
 /**
@@ -324,7 +325,7 @@ int vfs_permission(struct nameidata *nd,
  *
  * Note:
  *	Do not use this function in new code.  All access checks should
- *	be done using vfs_permission().
+ *	be done using path_permission().
  */
 int file_permission(struct file *file, int mask)
 {
@@ -903,7 +904,7 @@ static int __link_path_walk(const char *
 		nd->flags |= LOOKUP_CONTINUE;
 		err = exec_permission_lite(inode, nd);
 		if (err == -EAGAIN)
-			err = vfs_permission(nd, MAY_EXEC);
+			err = path_permission(&nd->path, MAY_EXEC, nd->flags);
  		if (err)
 			break;
 
@@ -1351,7 +1352,7 @@ static struct dentry *lookup_hash(struct
 {
 	int err;
 
-	err = vfs_permission(nd, MAY_EXEC);
+	err = path_permission(&nd->path, MAY_EXEC, nd->flags);
 	if (err)
 		return ERR_PTR(err);
 	return __lookup_hash(&nd->last, nd->path.dentry, nd);
@@ -1658,7 +1659,7 @@ int may_open(struct nameidata *nd, int a
 		flag &= ~O_TRUNC;
 	}
 
-	error = vfs_permission(nd, acc_mode);
+	error = path_permission(&nd->path, acc_mode, nd->flags);
 	if (error)
 		return error;
 	/*
@@ -3061,7 +3062,7 @@ EXPORT_SYMBOL(page_symlink_inode_operati
 EXPORT_SYMBOL(path_lookup);
 EXPORT_SYMBOL(vfs_path_lookup);
 EXPORT_SYMBOL(dentry_permission);
-EXPORT_SYMBOL(vfs_permission);
+EXPORT_SYMBOL(path_permission);
 EXPORT_SYMBOL(file_permission);
 EXPORT_SYMBOL(unlock_rename);
 EXPORT_SYMBOL(vfs_follow_link);
Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2008-05-21 18:14:45.000000000 +0200
+++ linux-2.6/fs/open.c	2008-05-21 18:15:02.000000000 +0200
@@ -267,7 +267,7 @@ static long do_sys_truncate(const char _
 	if (error)
 		goto dput_and_out;
 
-	error = vfs_permission(&nd, MAY_WRITE);
+	error = path_permission(&nd.path, MAY_WRITE, nd.flags);
 	if (error)
 		goto mnt_drop_write_and_out;
 
@@ -471,7 +471,7 @@ asmlinkage long sys_faccessat(int dfd, c
 	if (res)
 		goto out;
 
-	res = vfs_permission(&nd, mode);
+	res = path_permission(&nd.path, mode, nd.flags);
 	/* SuS v2 requires we report a read only fs too */
 	if(res || !(mode & S_IWOTH) ||
 	   special_file(nd.path.dentry->d_inode->i_mode))
@@ -514,7 +514,7 @@ asmlinkage long sys_chdir(const char __u
 	if (error)
 		goto out;
 
-	error = vfs_permission(&nd, MAY_EXEC);
+	error = path_permission(&nd.path, MAY_EXEC, nd.flags);
 	if (error)
 		goto dput_and_out;
 
@@ -561,7 +561,7 @@ asmlinkage long sys_chroot(const char __
 	if (error)
 		goto out;
 
-	error = vfs_permission(&nd, MAY_EXEC);
+	error = path_permission(&nd.path, MAY_EXEC, nd.flags);
 	if (error)
 		goto dput_and_out;
 
Index: linux-2.6/fs/utimes.c
===================================================================
--- linux-2.6.orig/fs/utimes.c	2008-05-21 18:14:45.000000000 +0200
+++ linux-2.6/fs/utimes.c	2008-05-21 18:15:02.000000000 +0200
@@ -141,7 +141,7 @@ static int do_utimes_name(int dfd, char 
 			goto out_path_put;
 
 		if (!is_owner_or_cap(inode)) {
-			error = vfs_permission(&nd, MAY_WRITE);
+			error = path_permission(&nd.path, MAY_WRITE, nd.flags);
 			if (error)
 				goto out_path_put;
 		}
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-21 18:14:45.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-21 18:15:02.000000000 +0200
@@ -1123,7 +1123,7 @@ extern void unlock_super(struct super_bl
 /*
  * VFS helper functions..
  */
-extern int vfs_permission(struct nameidata *, int);
+extern int path_permission(struct path *, int, int);
 extern int path_create(struct path *, struct dentry *, int, struct nameidata *);
 extern int path_mkdir(struct path *, struct dentry *, int);
 extern int path_mknod(struct path *, struct dentry *, int, dev_t);
Index: linux-2.6/net/unix/af_unix.c
===================================================================
--- linux-2.6.orig/net/unix/af_unix.c	2008-05-21 18:14:45.000000000 +0200
+++ linux-2.6/net/unix/af_unix.c	2008-05-21 18:15:02.000000000 +0200
@@ -713,7 +713,7 @@ static struct sock *unix_find_other(stru
 		err = path_lookup(sunname->sun_path, LOOKUP_FOLLOW, &nd);
 		if (err)
 			goto fail;
-		err = vfs_permission(&nd, MAY_WRITE);
+		err = path_permission(&nd.path, MAY_WRITE, nd.flags);
 		if (err)
 			goto put_fail;
 

--
