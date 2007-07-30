Return-Path: <linux-kernel-owner+w=401wt.eu-S965653AbXG3QWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965653AbXG3QWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938701AbXG3QO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932359AbXG3QOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:07 -0400
Message-Id: <20070730161323.417978744@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:26 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 03/26] VFS: Make lookup_hash() return a struct path
Content-Disposition: inline; filename=um/vfs-lookup_hash-returns-path.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes lookup_hash() into returning a struct path.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/namei.c |  113 ++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 57 insertions(+), 56 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1297,27 +1297,27 @@ out:
  * needs parent already locked. Doesn't follow mounts.
  * SMP-safe.
  */
-static inline struct dentry * __lookup_hash(struct qstr *name, struct dentry *base, struct nameidata *nd)
+static int lookup_hash(struct nameidata *nd, struct qstr *name,
+		       struct path *path)
 {
-	struct dentry *dentry;
 	struct inode *inode;
 	int err;
 
-	inode = base->d_inode;
+	inode = nd->dentry->d_inode;
 
 	err = permission(inode, MAY_EXEC, nd);
-	dentry = ERR_PTR(err);
 	if (err)
 		goto out;
 
-	dentry = __lookup_hash_kern(name, base, nd);
+	path->mnt =  nd->mnt;
+	path->dentry = __lookup_hash_kern(name, nd->dentry, nd);
+	if (IS_ERR(path->dentry)) {
+		err = PTR_ERR(path->dentry);
+		path->dentry = NULL;
+		path->mnt = NULL;
+	}
 out:
-	return dentry;
-}
-
-static struct dentry *lookup_hash(struct nameidata *nd)
-{
-	return __lookup_hash(&nd->last, nd->dentry, nd);
+	return err;
 }
 
 /* SMP-safe */
@@ -1351,7 +1351,10 @@ struct dentry *lookup_one_len_nd(const c
 	err = __lookup_one_len(name, &this, base, len);
 	if (err)
 		return ERR_PTR(err);
-	return __lookup_hash(&this, base, nd);
+	err = permission(base->d_inode, MAY_EXEC, nd);
+	if (err)
+		return ERR_PTR(err);
+	return __lookup_hash_kern(&this, base, nd);
 }
 
 struct dentry *lookup_one_len_kern(const char *name, struct dentry *base, int len)
@@ -1709,12 +1712,10 @@ int open_namei(int dfd, const char *path
 	dir = nd->dentry;
 	nd->flags &= ~LOOKUP_PARENT;
 	mutex_lock(&dir->d_inode->i_mutex);
-	path.dentry = lookup_hash(nd);
-	path.mnt = nd->mnt;
+	error = lookup_hash(nd, &nd->last, &path);
 
 do_last:
-	error = PTR_ERR(path.dentry);
-	if (IS_ERR(path.dentry)) {
+	if (error) {
 		mutex_unlock(&dir->d_inode->i_mutex);
 		goto exit;
 	}
@@ -1817,8 +1818,7 @@ do_link:
 	}
 	dir = nd->dentry;
 	mutex_lock(&dir->d_inode->i_mutex);
-	path.dentry = lookup_hash(nd);
-	path.mnt = nd->mnt;
+	error = lookup_hash(nd, &nd->last, &path);
 	__putname(nd->last.name);
 	goto do_last;
 }
@@ -1835,7 +1835,8 @@ do_link:
  */
 struct dentry *lookup_create(struct nameidata *nd, int is_dir)
 {
-	struct dentry *dentry = ERR_PTR(-EEXIST);
+	struct path path = { .dentry = ERR_PTR(-EEXIST) } ;
+	int err;
 
 	mutex_lock_nested(&nd->dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	/*
@@ -1851,9 +1852,11 @@ struct dentry *lookup_create(struct name
 	/*
 	 * Do the final lookup.
 	 */
-	dentry = lookup_hash(nd);
-	if (IS_ERR(dentry))
+	err = lookup_hash(nd, &nd->last, &path);
+	if (err) {
+		path.dentry = ERR_PTR(err);
 		goto fail;
+	}
 
 	/*
 	 * Special case - lookup gave negative, but... we had foo/bar/
@@ -1861,14 +1864,16 @@ struct dentry *lookup_create(struct name
 	 * all is fine. Let's be bastards - you had / on the end, you've
 	 * been asking for (non-existent) directory. -ENOENT for you.
 	 */
-	if (!is_dir && nd->last.name[nd->last.len] && !dentry->d_inode)
+	if (!is_dir && nd->last.name[nd->last.len] && !path.dentry->d_inode)
 		goto enoent;
-	return dentry;
+	if (nd->mnt != path.mnt)
+		mntput(path.mnt);
+	return path.dentry;
 enoent:
-	dput(dentry);
-	dentry = ERR_PTR(-ENOENT);
+	dput_path(&path, nd);
+	path.dentry = ERR_PTR(-ENOENT);
 fail:
-	return dentry;
+	return path.dentry;
 }
 EXPORT_SYMBOL_GPL(lookup_create);
 
@@ -2075,7 +2080,7 @@ static long do_rmdir(int dfd, const char
 {
 	int error = 0;
 	char * name;
-	struct dentry *dentry;
+	struct path path;
 	struct nameidata nd;
 
 	name = getname(pathname);
@@ -2098,12 +2103,11 @@ static long do_rmdir(int dfd, const char
 			goto exit1;
 	}
 	mutex_lock_nested(&nd.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
-	dentry = lookup_hash(&nd);
-	error = PTR_ERR(dentry);
-	if (IS_ERR(dentry))
+	error = lookup_hash(&nd, &nd.last, &path);
+	if (error)
 		goto exit2;
-	error = vfs_rmdir(nd.dentry->d_inode, dentry);
-	dput(dentry);
+	error = vfs_rmdir(nd.dentry->d_inode, path.dentry);
+	dput_path(&path, &nd);
 exit2:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
 exit1:
@@ -2158,7 +2162,7 @@ static long do_unlinkat(int dfd, const c
 {
 	int error = 0;
 	char * name;
-	struct dentry *dentry;
+	struct path path;
 	struct nameidata nd;
 	struct inode *inode = NULL;
 
@@ -2173,18 +2177,17 @@ static long do_unlinkat(int dfd, const c
 	if (nd.last_type != LAST_NORM)
 		goto exit1;
 	mutex_lock_nested(&nd.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
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
-		error = vfs_unlink(nd.dentry->d_inode, dentry);
+		error = vfs_unlink(nd.dentry->d_inode, path.dentry);
 	exit2:
-		dput(dentry);
+		dput_path(&path, &nd);
 	}
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
 	if (inode)
@@ -2196,8 +2199,8 @@ exit:
 	return error;
 
 slashes:
-	error = !dentry->d_inode ? -ENOENT :
-		S_ISDIR(dentry->d_inode->i_mode) ? -EISDIR : -ENOTDIR;
+	error = !path.dentry->d_inode ? -ENOENT :
+		S_ISDIR(path.dentry->d_inode->i_mode) ? -EISDIR : -ENOTDIR;
 	goto exit2;
 }
 
@@ -2528,7 +2531,7 @@ static int do_rename(int olddfd, const c
 {
 	int error = 0;
 	struct dentry * old_dir, * new_dir;
-	struct dentry * old_dentry, *new_dentry;
+	struct path old, new;
 	struct dentry * trap;
 	struct nameidata oldnd, newnd;
 
@@ -2555,16 +2558,15 @@ static int do_rename(int olddfd, const c
 
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
@@ -2573,23 +2575,22 @@ static int do_rename(int olddfd, const c
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
 
-	error = vfs_rename(old_dir->d_inode, old_dentry,
-				   new_dir->d_inode, new_dentry);
+	error = vfs_rename(old_dir->d_inode, old.dentry,
+				   new_dir->d_inode, new.dentry);
 exit5:
-	dput(new_dentry);
+	dput_path(&new, &newnd);
 exit4:
-	dput(old_dentry);
+	dput_path(&old, &oldnd);
 exit3:
 	unlock_rename(new_dir, old_dir);
 exit2:

-- 

