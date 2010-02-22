Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab0BVUjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:39:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab0BVUjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:39:22 -0500
Date: Mon, 22 Feb 2010 15:39:18 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>
Subject: [PATCH] VFS: Make lookup_hash() return a struct path
Message-ID: <20100222203917.GF972@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any chance we can get this into mainline sooner rather than later?
Seems like we are moving towards returning paths instead of dentries
in the VFS in general.

-VAL

>From 8e9c99f674ac220bd6266b92fdb75bcde78bb6c1 Mon Sep 17 00:00:00 2001
From: Jan Blunck <jblunck@suse.de>
Date: Fri, 20 Mar 2009 19:41:49 -0700

This patch changes lookup_hash() into returning a struct path.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c |  115 ++++++++++++++++++++++++++++++-----------------------------
 1 files changed, 58 insertions(+), 57 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a38801d..d92b185 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1163,7 +1163,7 @@ int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
 }
 
 static struct dentry *__lookup_hash(struct qstr *name,
-		struct dentry *base, struct nameidata *nd)
+				    struct dentry *base, struct nameidata *nd)
 {
 	struct dentry *dentry;
 	struct inode *inode;
@@ -1220,14 +1220,22 @@ out:
  * needs parent already locked. Doesn't follow mounts.
  * SMP-safe.
  */
-static struct dentry *lookup_hash(struct nameidata *nd)
+static int lookup_hash(struct nameidata *nd, struct qstr *name,
+		       struct path *path)
 {
 	int err;
 
 	err = exec_permission(nd->path.dentry->d_inode);
 	if (err)
-		return ERR_PTR(err);
-	return __lookup_hash(&nd->last, nd->path.dentry, nd);
+		return err;
+	path->mnt = nd->path.mnt;
+	path->dentry =  __lookup_hash(name, nd->path.dentry, nd);
+	if (IS_ERR(path->dentry)) {
+		err = PTR_ERR(path->dentry);
+		path->dentry = NULL;
+		path->mnt = NULL;
+	}
+	return err;
 }
 
 static int __lookup_one_len(const char *name, struct qstr *this,
@@ -1721,12 +1729,10 @@ reval:
 	if (flag & O_EXCL)
 		nd.flags |= LOOKUP_EXCL;
 	mutex_lock(&dir->d_inode->i_mutex);
-	path.dentry = lookup_hash(&nd);
-	path.mnt = nd.path.mnt;
+	error = lookup_hash(&nd, &nd.last, &path);
 
 do_last:
-	error = PTR_ERR(path.dentry);
-	if (IS_ERR(path.dentry)) {
+	if (error) {
 		mutex_unlock(&dir->d_inode->i_mutex);
 		goto exit;
 	}
@@ -1893,8 +1899,7 @@ do_link:
 	}
 	dir = nd.path.dentry;
 	mutex_lock(&dir->d_inode->i_mutex);
-	path.dentry = lookup_hash(&nd);
-	path.mnt = nd.path.mnt;
+	error = lookup_hash(&nd, &nd.last, &path);
 	__putname(nd.last.name);
 	goto do_last;
 }
@@ -1928,7 +1933,8 @@ EXPORT_SYMBOL(filp_open);
  */
 struct dentry *lookup_create(struct nameidata *nd, int is_dir)
 {
-	struct dentry *dentry = ERR_PTR(-EEXIST);
+	struct path path;
+	int err;
 
 	mutex_lock_nested(&nd->path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	/*
@@ -1936,7 +1942,7 @@ struct dentry *lookup_create(struct nameidata *nd, int is_dir)
 	 * (foo/., foo/.., /////)
 	 */
 	if (nd->last_type != LAST_NORM)
-		goto fail;
+		return ERR_PTR(-EEXIST);
 	nd->flags &= ~LOOKUP_PARENT;
 	nd->flags |= LOOKUP_CREATE | LOOKUP_EXCL;
 	nd->intent.open.flags = O_EXCL;
@@ -1944,11 +1950,11 @@ struct dentry *lookup_create(struct nameidata *nd, int is_dir)
 	/*
 	 * Do the final lookup.
 	 */
-	dentry = lookup_hash(nd);
-	if (IS_ERR(dentry))
-		goto fail;
+	err = lookup_hash(nd, &nd->last, &path);
+	if (err)
+		return ERR_PTR(err);
 
-	if (dentry->d_inode)
+	if (path.dentry->d_inode)
 		goto eexist;
 	/*
 	 * Special case - lookup gave negative, but... we had foo/bar/
@@ -1957,15 +1963,14 @@ struct dentry *lookup_create(struct nameidata *nd, int is_dir)
 	 * been asking for (non-existent) directory. -ENOENT for you.
 	 */
 	if (unlikely(!is_dir && nd->last.name[nd->last.len])) {
-		dput(dentry);
-		dentry = ERR_PTR(-ENOENT);
+		dput(path.dentry);
+		return ERR_PTR(-ENOENT);
 	}
-	return dentry;
+
+	return path.dentry;
 eexist:
-	dput(dentry);
-	dentry = ERR_PTR(-EEXIST);
-fail:
-	return dentry;
+	path_put_conditional(&path, nd);
+	return ERR_PTR(-EEXIST);
 }
 EXPORT_SYMBOL_GPL(lookup_create);
 
@@ -2202,7 +2207,7 @@ static long do_rmdir(int dfd, const char __user *pathname)
 {
 	int error = 0;
 	char * name;
-	struct dentry *dentry;
+	struct path path;
 	struct nameidata nd;
 
 	error = user_path_parent(dfd, pathname, &nd, &name);
@@ -2224,21 +2229,20 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	nd.flags &= ~LOOKUP_PARENT;
 
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
-	dentry = lookup_hash(&nd);
-	error = PTR_ERR(dentry);
-	if (IS_ERR(dentry))
+	error = lookup_hash(&nd, &nd.last, &path);
+	if (error)
 		goto exit2;
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto exit3;
-	error = security_path_rmdir(&nd.path, dentry);
+	error = security_path_rmdir(&nd.path, path.dentry);
 	if (error)
 		goto exit4;
-	error = vfs_rmdir(nd.path.dentry->d_inode, dentry);
+	error = vfs_rmdir(nd.path.dentry->d_inode, path.dentry);
 exit4:
 	mnt_drop_write(nd.path.mnt);
 exit3:
-	dput(dentry);
+	path_put_conditional(&path, &nd);
 exit2:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 exit1:
@@ -2293,7 +2297,7 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 {
 	int error;
 	char *name;
-	struct dentry *dentry;
+	struct path path;
 	struct nameidata nd;
 	struct inode *inode = NULL;
 
@@ -2308,26 +2312,25 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	nd.flags &= ~LOOKUP_PARENT;
 
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
-	dentry = lookup_hash(&nd);
-	error = PTR_ERR(dentry);
-	if (!IS_ERR(dentry)) {
+	error = lookup_hash(&nd, &nd.last, &path);
+	if (!error) {
 		/* Why not before? Because we want correct error value */
 		if (nd.last.name[nd.last.len])
 			goto slashes;
-		inode = dentry->d_inode;
+		inode = path.dentry->d_inode;
 		if (inode)
 			atomic_inc(&inode->i_count);
 		error = mnt_want_write(nd.path.mnt);
 		if (error)
 			goto exit2;
-		error = security_path_unlink(&nd.path, dentry);
+		error = security_path_unlink(&nd.path, path.dentry);
 		if (error)
 			goto exit3;
-		error = vfs_unlink(nd.path.dentry->d_inode, dentry);
+		error = vfs_unlink(nd.path.dentry->d_inode, path.dentry);
 exit3:
 		mnt_drop_write(nd.path.mnt);
 	exit2:
-		dput(dentry);
+		path_put_conditional(&path, &nd);
 	}
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 	if (inode)
@@ -2338,8 +2341,8 @@ exit1:
 	return error;
 
 slashes:
-	error = !dentry->d_inode ? -ENOENT :
-		S_ISDIR(dentry->d_inode->i_mode) ? -EISDIR : -ENOTDIR;
+	error = !path.dentry->d_inode ? -ENOENT :
+		S_ISDIR(path.dentry->d_inode->i_mode) ? -EISDIR : -ENOTDIR;
 	goto exit2;
 }
 
@@ -2677,7 +2680,7 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 		int, newdfd, const char __user *, newname)
 {
 	struct dentry *old_dir, *new_dir;
-	struct dentry *old_dentry, *new_dentry;
+	struct path old, new;
 	struct dentry *trap;
 	struct nameidata oldnd, newnd;
 	char *from;
@@ -2711,16 +2714,15 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 
 	trap = lock_rename(new_dir, old_dir);
 
-	old_dentry = lookup_hash(&oldnd);
-	error = PTR_ERR(old_dentry);
-	if (IS_ERR(old_dentry))
+	error = lookup_hash(&oldnd, &oldnd.last, &old);
+	if (error)
 		goto exit3;
 	/* source must exist */
 	error = -ENOENT;
-	if (!old_dentry->d_inode)
+	if (!old.dentry->d_inode)
 		goto exit4;
 	/* unless the source is a directory trailing slashes give -ENOTDIR */
-	if (!S_ISDIR(old_dentry->d_inode->i_mode)) {
+	if (!S_ISDIR(old.dentry->d_inode->i_mode)) {
 		error = -ENOTDIR;
 		if (oldnd.last.name[oldnd.last.len])
 			goto exit4;
@@ -2729,32 +2731,31 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	}
 	/* source should not be ancestor of target */
 	error = -EINVAL;
-	if (old_dentry == trap)
+	if (old.dentry == trap)
 		goto exit4;
-	new_dentry = lookup_hash(&newnd);
-	error = PTR_ERR(new_dentry);
-	if (IS_ERR(new_dentry))
+	error = lookup_hash(&newnd, &newnd.last, &new);
+	if (error)
 		goto exit4;
 	/* target should not be an ancestor of source */
 	error = -ENOTEMPTY;
-	if (new_dentry == trap)
+	if (new.dentry == trap)
 		goto exit5;
 
 	error = mnt_want_write(oldnd.path.mnt);
 	if (error)
 		goto exit5;
-	error = security_path_rename(&oldnd.path, old_dentry,
-				     &newnd.path, new_dentry);
+	error = security_path_rename(&oldnd.path, old.dentry,
+				     &newnd.path, new.dentry);
 	if (error)
 		goto exit6;
-	error = vfs_rename(old_dir->d_inode, old_dentry,
-				   new_dir->d_inode, new_dentry);
+	error = vfs_rename(old_dir->d_inode, old.dentry,
+				   new_dir->d_inode, new.dentry);
 exit6:
 	mnt_drop_write(oldnd.path.mnt);
 exit5:
-	dput(new_dentry);
+	path_put_conditional(&new, &newnd);
 exit4:
-	dput(old_dentry);
+	path_put_conditional(&old, &oldnd);
 exit3:
 	unlock_rename(new_dir, old_dir);
 exit2:
-- 
1.5.6.5

