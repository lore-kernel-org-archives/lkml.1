Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbZERQM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbZERQM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbZERQJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:09:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbZERQJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:29 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 04/32] VFS: Make lookup_hash() return a struct path
Date: Mon, 18 May 2009 18:09:00 +0200
Message-Id: <1242662968-11684-5-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes lookup_hash() into returning a struct path.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/namei.c |  114 +++++++++++++++++++++++++++++++----------------------------
 1 files changed, 60 insertions(+), 54 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index bbc15c2..081aef1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1149,7 +1149,7 @@ int path_lookup_open(int dfd, const char *name, unsigned int lookup_flags,
 }
 
 static struct dentry *__lookup_hash(struct qstr *name,
-		struct dentry *base, struct nameidata *nd)
+				    struct dentry *base, struct nameidata *nd)
 {
 	struct dentry *dentry;
 	struct inode *inode;
@@ -1196,14 +1196,22 @@ out:
  * needs parent already locked. Doesn't follow mounts.
  * SMP-safe.
  */
-static struct dentry *lookup_hash(struct nameidata *nd)
+static int lookup_hash(struct nameidata *nd, struct qstr *name,
+		       struct path *path)
 {
 	int err;
 
 	err = inode_permission(nd->path.dentry->d_inode, MAY_EXEC);
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
@@ -1690,12 +1698,10 @@ struct file *do_filp_open(int dfd, const char *pathname,
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
@@ -1841,8 +1847,7 @@ do_link:
 	}
 	dir = nd.path.dentry;
 	mutex_lock(&dir->d_inode->i_mutex);
-	path.dentry = lookup_hash(&nd);
-	path.mnt = nd.path.mnt;
+	error = lookup_hash(&nd, &nd.last, &path);
 	__putname(nd.last.name);
 	goto do_last;
 }
@@ -1876,7 +1881,8 @@ EXPORT_SYMBOL(filp_open);
  */
 struct dentry *lookup_create(struct nameidata *nd, int is_dir)
 {
-	struct dentry *dentry = ERR_PTR(-EEXIST);
+	struct path path = { .dentry = ERR_PTR(-EEXIST) } ;
+	int err;
 
 	mutex_lock_nested(&nd->path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	/*
@@ -1892,11 +1898,13 @@ struct dentry *lookup_create(struct nameidata *nd, int is_dir)
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
 
-	if (dentry->d_inode)
+	if (path.dentry->d_inode)
 		goto eexist;
 	/*
 	 * Special case - lookup gave negative, but... we had foo/bar/
@@ -1905,15 +1913,17 @@ struct dentry *lookup_create(struct nameidata *nd, int is_dir)
 	 * been asking for (non-existent) directory. -ENOENT for you.
 	 */
 	if (unlikely(!is_dir && nd->last.name[nd->last.len])) {
-		dput(dentry);
-		dentry = ERR_PTR(-ENOENT);
+		path_put_conditional(&path, nd);
+		path.dentry = ERR_PTR(-ENOENT);
 	}
-	return dentry;
+	if (nd->path.mnt != path.mnt)
+		mntput(path.mnt);
+	return path.dentry;
 eexist:
-	dput(dentry);
-	dentry = ERR_PTR(-EEXIST);
+	path_put_conditional(&path, nd);
+	path.dentry = ERR_PTR(-EEXIST);
 fail:
-	return dentry;
+	return path.dentry;
 }
 EXPORT_SYMBOL_GPL(lookup_create);
 
@@ -2150,7 +2160,7 @@ static long do_rmdir(int dfd, const char __user *pathname)
 {
 	int error = 0;
 	char * name;
-	struct dentry *dentry;
+	struct path path;
 	struct nameidata nd;
 
 	error = user_path_parent(dfd, pathname, &nd, &name);
@@ -2172,21 +2182,20 @@ static long do_rmdir(int dfd, const char __user *pathname)
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
@@ -2241,7 +2250,7 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 {
 	int error;
 	char *name;
-	struct dentry *dentry;
+	struct path path;
 	struct nameidata nd;
 	struct inode *inode = NULL;
 
@@ -2256,26 +2265,25 @@ static long do_unlinkat(int dfd, const char __user *pathname)
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
@@ -2286,8 +2294,8 @@ exit1:
 	return error;
 
 slashes:
-	error = !dentry->d_inode ? -ENOENT :
-		S_ISDIR(dentry->d_inode->i_mode) ? -EISDIR : -ENOTDIR;
+	error = !path.dentry->d_inode ? -ENOENT :
+		S_ISDIR(path.dentry->d_inode->i_mode) ? -EISDIR : -ENOTDIR;
 	goto exit2;
 }
 
@@ -2627,7 +2635,7 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 		int, newdfd, const char __user *, newname)
 {
 	struct dentry *old_dir, *new_dir;
-	struct dentry *old_dentry, *new_dentry;
+	struct path old, new;
 	struct dentry *trap;
 	struct nameidata oldnd, newnd;
 	char *from;
@@ -2661,16 +2669,15 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 
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
@@ -2679,32 +2686,31 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
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
1.6.1.3

