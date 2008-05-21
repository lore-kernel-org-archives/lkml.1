Return-Path: <linux-kernel-owner+w=401wt.eu-S936111AbYEURWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936111AbYEURWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933165AbYEURQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:16:24 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33085 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828AbYEURQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:16:12 -0400
Message-Id: <20080521171601.846463380@szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 21 May 2008 19:15:12 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 14/14] vfs: path_permission() clean up flags
Content-Disposition: inline; filename=permission_flags_fixes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Currently callers of path_permission() either pass zero or
nameidata->flags as the flags argument.  Passing lookup flags to
filesystems is completely unecessary, only the "intent" flags are
interesting.

More specifically nfs uses LOOKUP_ACCESS and LOOKUP_OPEN flags, while
fuse uses LOOKUP_ACCESS and LOOKUP_CHDIR flags.

So clean up path_permission() calls to just pass these flags.

In case of LOOKUP_CHDIR and LOOKUP_ACCESS the lookup routines need not
be passed these flags at all, they are only needed for the permission
checks.

Also remove the nameidata argument of may_create().  NFS doesn't need
LOOKUP_OPEN in this case, since it handles the creation checks on the
parent directory specially anyway.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/exec.c          |    4 ++--
 fs/inotify_user.c  |    2 +-
 fs/namei.c         |   25 +++++++++++--------------
 fs/open.c          |   15 +++++++--------
 fs/utimes.c        |    2 +-
 net/unix/af_unix.c |    2 +-
 6 files changed, 23 insertions(+), 27 deletions(-)

Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c	2008-05-21 18:15:02.000000000 +0200
+++ linux-2.6/fs/exec.c	2008-05-21 18:30:34.000000000 +0200
@@ -116,7 +116,7 @@ asmlinkage long sys_uselib(const char __
 	if (!S_ISREG(nd.path.dentry->d_inode->i_mode))
 		goto exit;
 
-	error = path_permission(&nd.path, MAY_READ | MAY_EXEC, nd.flags);
+	error = path_permission(&nd.path, MAY_READ | MAY_EXEC, 0);
 	if (error)
 		goto exit;
 
@@ -664,7 +664,7 @@ struct file *open_exec(const char *name)
 		struct inode *inode = nd.path.dentry->d_inode;
 		file = ERR_PTR(-EACCES);
 		if (S_ISREG(inode->i_mode)) {
-			int err = path_permission(&nd.path, MAY_EXEC, nd.flags);
+			int err = path_permission(&nd.path, MAY_EXEC, 0);
 			file = ERR_PTR(err);
 			if (!err) {
 				file = nameidata_to_filp(&nd,
Index: linux-2.6/fs/inotify_user.c
===================================================================
--- linux-2.6.orig/fs/inotify_user.c	2008-05-21 18:15:02.000000000 +0200
+++ linux-2.6/fs/inotify_user.c	2008-05-21 18:30:34.000000000 +0200
@@ -365,7 +365,7 @@ static int find_inode(const char __user 
 	if (error)
 		return error;
 	/* you can only watch an inode if you have read permissions on it */
-	error = path_permission(&nd->path, MAY_READ, nd->flags);
+	error = path_permission(&nd->path, MAY_READ, 0);
 	if (error)
 		path_put(&nd->path);
 	return error;
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-21 18:17:08.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-21 18:36:27.000000000 +0200
@@ -899,7 +899,7 @@ static int __link_path_walk(const char *
 		nd->flags |= LOOKUP_CONTINUE;
 		err = exec_permission_lite(inode, nd);
 		if (err == -EAGAIN)
-			err = path_permission(&nd->path, MAY_EXEC, nd->flags);
+			err = path_permission(&nd->path, MAY_EXEC, 0);
  		if (err)
 			break;
 
@@ -1180,7 +1180,6 @@ static int do_path_lookup(int dfd, const
 
 		nd->path = file->f_path;
 		path_get(&file->f_path);
-
 		fput_light(file, fput_needed);
 	}
 
@@ -1347,7 +1346,7 @@ static struct dentry *lookup_hash(struct
 {
 	int err;
 
-	err = path_permission(&nd->path, MAY_EXEC, nd->flags);
+	err = path_permission(&nd->path, MAY_EXEC, 0);
 	if (err)
 		return ERR_PTR(err);
 	return __lookup_hash(&nd->last, nd->path.dentry, nd);
@@ -1517,15 +1516,13 @@ static int may_delete(struct dentry *dir
  *  3. We should have write and exec permissions on dir
  *  4. We can't do it if dir is immutable (done in permission())
  */
-static inline int may_create(struct dentry *dir_dentry, struct dentry *child,
-			     struct nameidata *nd)
+static inline int may_create(struct dentry *dir_dentry, struct dentry *child)
 {
 	if (child->d_inode)
 		return -EEXIST;
 	if (IS_DEADDIR(dir_dentry->d_inode))
 		return -ENOENT;
-	return dentry_permission(dir_dentry, MAY_WRITE | MAY_EXEC,
-				 nd ? nd->flags : 0);
+	return dentry_permission(dir_dentry, MAY_WRITE | MAY_EXEC, 0);
 }
 
 /* 
@@ -1592,7 +1589,7 @@ static int vfs_create(struct dentry *dir
 		      int mode,	struct nameidata *nd)
 {
 	struct inode *dir = dir_dentry->d_inode;
-	int error = may_create(dir_dentry, dentry, nd);
+	int error = may_create(dir_dentry, dentry);
 
 	if (error)
 		return error;
@@ -1654,7 +1651,7 @@ int may_open(struct nameidata *nd, int a
 		flag &= ~O_TRUNC;
 	}
 
-	error = path_permission(&nd->path, acc_mode, nd->flags);
+	error = path_permission(&nd->path, acc_mode, nd->flags & LOOKUP_OPEN);
 	if (error)
 		return error;
 	/*
@@ -2048,7 +2045,7 @@ static int vfs_mknod(struct dentry *dir_
 		     int mode, dev_t dev)
 {
 	struct inode *dir = dir_dentry->d_inode;
-	int error = may_create(dir_dentry, dentry, NULL);
+	int error = may_create(dir_dentry, dentry);
 
 	if (error)
 		return error;
@@ -2146,7 +2143,7 @@ asmlinkage long sys_mknod(const char __u
 static int vfs_mkdir(struct dentry *dir_dentry, struct dentry *dentry, int mode)
 {
 	struct inode *dir = dir_dentry->d_inode;
-	int error = may_create(dir_dentry, dentry, NULL);
+	int error = may_create(dir_dentry, dentry);
 
 	if (error)
 		return error;
@@ -2456,7 +2453,7 @@ static int vfs_symlink(struct dentry *di
 		       const char *oldname)
 {
 	struct inode *dir = dir_dentry->d_inode;
-	int error = may_create(dir_dentry, dentry, NULL);
+	int error = may_create(dir_dentry, dentry);
 
 	if (error)
 		return error;
@@ -2541,7 +2538,7 @@ static int vfs_link(struct dentry *old_d
 	if (!inode)
 		return -ENOENT;
 
-	error = may_create(new_dir_dentry, new_dentry, NULL);
+	error = may_create(new_dir_dentry, new_dentry);
 	if (error)
 		return error;
 
@@ -2764,7 +2761,7 @@ static int vfs_rename(struct dentry *old
 		return error;
 
 	if (!new_dentry->d_inode)
-		error = may_create(new_dir_dentry, new_dentry, NULL);
+		error = may_create(new_dir_dentry, new_dentry);
 	else
 		error = may_delete(new_dir_dentry, new_dentry, is_dir);
 	if (error)
Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2008-05-21 18:15:02.000000000 +0200
+++ linux-2.6/fs/open.c	2008-05-21 18:30:34.000000000 +0200
@@ -267,7 +267,7 @@ static long do_sys_truncate(const char _
 	if (error)
 		goto dput_and_out;
 
-	error = path_permission(&nd.path, MAY_WRITE, nd.flags);
+	error = path_permission(&nd.path, MAY_WRITE, 0);
 	if (error)
 		goto mnt_drop_write_and_out;
 
@@ -467,11 +467,11 @@ asmlinkage long sys_faccessat(int dfd, c
 	else
 		current->cap_effective = current->cap_permitted;
 
-	res = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW|LOOKUP_ACCESS, &nd);
+	res = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW, &nd);
 	if (res)
 		goto out;
 
-	res = path_permission(&nd.path, mode, nd.flags);
+	res = path_permission(&nd.path, mode, LOOKUP_ACCESS);
 	/* SuS v2 requires we report a read only fs too */
 	if(res || !(mode & S_IWOTH) ||
 	   special_file(nd.path.dentry->d_inode->i_mode))
@@ -509,12 +509,11 @@ asmlinkage long sys_chdir(const char __u
 	struct nameidata nd;
 	int error;
 
-	error = __user_walk(filename,
-			    LOOKUP_FOLLOW|LOOKUP_DIRECTORY|LOOKUP_CHDIR, &nd);
+	error = __user_walk(filename, LOOKUP_FOLLOW|LOOKUP_DIRECTORY, &nd);
 	if (error)
 		goto out;
 
-	error = path_permission(&nd.path, MAY_EXEC, nd.flags);
+	error = path_permission(&nd.path, MAY_EXEC, LOOKUP_CHDIR);
 	if (error)
 		goto dput_and_out;
 
@@ -543,7 +542,7 @@ asmlinkage long sys_fchdir(unsigned int 
 	if (!S_ISDIR(inode->i_mode))
 		goto out_putf;
 
-	error = file_permission(file, MAY_EXEC);
+	error = path_permission(&file->f_path, MAY_EXEC, LOOKUP_CHDIR);
 	if (!error)
 		set_fs_pwd(current->fs, &file->f_path);
 out_putf:
@@ -561,7 +560,7 @@ asmlinkage long sys_chroot(const char __
 	if (error)
 		goto out;
 
-	error = path_permission(&nd.path, MAY_EXEC, nd.flags);
+	error = path_permission(&nd.path, MAY_EXEC, 0);
 	if (error)
 		goto dput_and_out;
 
Index: linux-2.6/net/unix/af_unix.c
===================================================================
--- linux-2.6.orig/net/unix/af_unix.c	2008-05-21 18:15:02.000000000 +0200
+++ linux-2.6/net/unix/af_unix.c	2008-05-21 18:30:34.000000000 +0200
@@ -713,7 +713,7 @@ static struct sock *unix_find_other(stru
 		err = path_lookup(sunname->sun_path, LOOKUP_FOLLOW, &nd);
 		if (err)
 			goto fail;
-		err = path_permission(&nd.path, MAY_WRITE, nd.flags);
+		err = path_permission(&nd.path, MAY_WRITE, 0);
 		if (err)
 			goto put_fail;
 
Index: linux-2.6/fs/utimes.c
===================================================================
--- linux-2.6.orig/fs/utimes.c	2008-05-21 18:15:02.000000000 +0200
+++ linux-2.6/fs/utimes.c	2008-05-21 18:30:34.000000000 +0200
@@ -141,7 +141,7 @@ static int do_utimes_name(int dfd, char 
 			goto out_path_put;
 
 		if (!is_owner_or_cap(inode)) {
-			error = path_permission(&nd.path, MAY_WRITE, nd.flags);
+			error = path_permission(&nd.path, MAY_WRITE, 0);
 			if (error)
 				goto out_path_put;
 		}

--
