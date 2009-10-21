Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbZJUTae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbZJUTae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbZJUTaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:30:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890AbZJUTUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:20:16 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>
Subject: [PATCH 03/41] VFS: Make lookup_hash() return a struct path
Date: Wed, 21 Oct 2009 12:19:01 -0700
Message-Id: <1256152779-10054-4-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-3-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

This patch changes lookup_hash() into returning a struct path.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |  114 +++++++++++++++++++++++++++++++----------------------------
 1 files changed, 60 insertions(+), 54 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 1f13751..e334f25 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1172,7 +1172,7 @@ static int path_lookup_open(int dfd, const char *name,
 }
 
 static struct dentry *__lookup_hash(struct qstr *name,
-		struct dentry *base, struct nameidata *nd)
+				    struct dentry *base, struct nameidata *nd)
 {
 	struct dentry *dentry;
 	struct inode *inode;
@@ -1219,14 +1219,22 @@ out:
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
@@ -1736,12 +1744,10 @@ struct file *do_filp_open(int dfd, const char *pathname,
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
@@ -1902,8 +1908,7 @@ do_link:
 	}
 	dir = nd.path.dentry;
 	mutex_lock(&dir->d_inode->i_mutex);
-	path.dentry = lookup_hash(&nd);
-	path.mnt = nd.path.mnt;
+	error = lookup_hash(&nd, &nd.last, &path);
 	__putname(nd.last.name);
 	goto do_last;
 }
@@ -1937,7 +1942,8 @@ EXPORT_SYMBOL(filp_open);
  */
 struct dentry *lookup_create(struct nameidata *nd, int is_dir)
 {
-	struct dentry *dentry = ERR_PTR(-EEXIST);
+	struct path path = { .dentry = ERR_PTR(-EEXIST) } ;
+	int err;
 
 	mutex_lock_nested(&nd->path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	/*
@@ -1953,11 +1959,13 @@ struct dentry *lookup_create(struct nameidata *nd, int is_dir)
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
@@ -1966,15 +1974,17 @@ struct dentry *lookup_create(struct nameidata *nd, int is_dir)
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
 
@@ -2211,7 +2221,7 @@ static long do_rmdir(int dfd, const char __user *pathname)
 {
 	int error = 0;
 	char * name;
-	struct dentry *dentry;
+	struct path path;
 	struct nameidata nd;
 
 	error = user_path_parent(dfd, pathname, &nd, &name);
@@ -2233,21 +2243,20 @@ static long do_rmdir(int dfd, const char __user *pathname)
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
@@ -2302,7 +2311,7 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 {
 	int error;
 	char *name;
-	struct dentry *dentry;
+	struct path path;
 	struct nameidata nd;
 	struct inode *inode = NULL;
 
@@ -2317,26 +2326,25 @@ static long do_unlinkat(int dfd, const char __user *pathname)
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
@@ -2347,8 +2355,8 @@ exit1:
 	return error;
 
 slashes:
-	error = !dentry->d_inode ? -ENOENT :
-		S_ISDIR(dentry->d_inode->i_mode) ? -EISDIR : -ENOTDIR;
+	error = !path.dentry->d_inode ? -ENOENT :
+		S_ISDIR(path.dentry->d_inode->i_mode) ? -EISDIR : -ENOTDIR;
 	goto exit2;
 }
 
@@ -2688,7 +2696,7 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 		int, newdfd, const char __user *, newname)
 {
 	struct dentry *old_dir, *new_dir;
-	struct dentry *old_dentry, *new_dentry;
+	struct path old, new;
 	struct dentry *trap;
 	struct nameidata oldnd, newnd;
 	char *from;
@@ -2722,16 +2730,15 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 
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
@@ -2740,32 +2747,31 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
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
1.6.3.3

