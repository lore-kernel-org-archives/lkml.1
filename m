Return-Path: <linux-kernel-owner+w=401wt.eu-S965350AbXG3QVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965350AbXG3QVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938591AbXG3QOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:58733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933484AbXG3QOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:09 -0400
Message-Id: <20070730161323.507965230@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:27 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 04/26] VFS: Make lookup_create() return a struct path
Content-Disposition: inline; filename=um/vfs-lookup_create-returns-path.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes lookup_create() into returning a struct path.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 arch/powerpc/platforms/cell/spufs/inode.c |   15 ++----
 fs/namei.c                                |   75 +++++++++++++-----------------
 include/linux/dcache.h                    |    1 
 include/linux/namei.h                     |    1 
 net/unix/af_unix.c                        |   17 +++---
 5 files changed, 50 insertions(+), 59 deletions(-)

--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -456,7 +456,7 @@ static struct file_system_type spufs_typ
 
 long spufs_create(struct nameidata *nd, unsigned int flags, mode_t mode)
 {
-	struct dentry *dentry;
+	struct path path;
 	int ret;
 
 	ret = -EINVAL;
@@ -475,26 +475,25 @@ long spufs_create(struct nameidata *nd, 
 			goto out;
 	}
 
-	dentry = lookup_create(nd, 1);
-	ret = PTR_ERR(dentry);
-	if (IS_ERR(dentry))
+	ret = lookup_create(nd, 1, &path);
+	if (ret)
 		goto out_dir;
 
 	ret = -EEXIST;
-	if (dentry->d_inode)
+	if (path.dentry->d_inode)
 		goto out_dput;
 
 	mode &= ~current->fs->umask;
 
 	if (flags & SPU_CREATE_GANG)
 		return spufs_create_gang(nd->dentry->d_inode,
-					dentry, nd->mnt, mode);
+					 path.dentry, path.mnt, mode);
 	else
 		return spufs_create_context(nd->dentry->d_inode,
-					dentry, nd->mnt, flags, mode);
+					    path.dentry, path.mnt, flags, mode);
 
 out_dput:
-	dput(dentry);
+	dput_path(&path, nd);
 out_dir:
 	mutex_unlock(&nd->dentry->d_inode->i_mutex);
 out:
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1833,10 +1833,9 @@ do_link:
  *
  * Returns with nd->dentry->d_inode->i_mutex locked.
  */
-struct dentry *lookup_create(struct nameidata *nd, int is_dir)
+int lookup_create(struct nameidata *nd, int is_dir, struct path *path)
 {
-	struct path path = { .dentry = ERR_PTR(-EEXIST) } ;
-	int err;
+	int err = -EEXIST;
 
 	mutex_lock_nested(&nd->dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	/*
@@ -1852,11 +1851,9 @@ struct dentry *lookup_create(struct name
 	/*
 	 * Do the final lookup.
 	 */
-	err = lookup_hash(nd, &nd->last, &path);
-	if (err) {
-		path.dentry = ERR_PTR(err);
+	err = lookup_hash(nd, &nd->last, path);
+	if (err)
 		goto fail;
-	}
 
 	/*
 	 * Special case - lookup gave negative, but... we had foo/bar/
@@ -1864,16 +1861,14 @@ struct dentry *lookup_create(struct name
 	 * all is fine. Let's be bastards - you had / on the end, you've
 	 * been asking for (non-existent) directory. -ENOENT for you.
 	 */
-	if (!is_dir && nd->last.name[nd->last.len] && !path.dentry->d_inode)
+	if (!is_dir && nd->last.name[nd->last.len] && !path->dentry->d_inode)
 		goto enoent;
-	if (nd->mnt != path.mnt)
-		mntput(path.mnt);
-	return path.dentry;
+	return 0;
 enoent:
-	dput_path(&path, nd);
-	path.dentry = ERR_PTR(-ENOENT);
+	dput_path(path, nd);
+	err = -ENOENT;
 fail:
-	return path.dentry;
+	return err;
 }
 EXPORT_SYMBOL_GPL(lookup_create);
 
@@ -1906,7 +1901,7 @@ asmlinkage long sys_mknodat(int dfd, con
 {
 	int error = 0;
 	char * tmp;
-	struct dentry * dentry;
+	struct path path;
 	struct nameidata nd;
 
 	if (S_ISDIR(mode))
@@ -1918,22 +1913,23 @@ asmlinkage long sys_mknodat(int dfd, con
 	error = do_path_lookup(dfd, tmp, LOOKUP_PARENT, &nd);
 	if (error)
 		goto out;
-	dentry = lookup_create(&nd, 0);
-	error = PTR_ERR(dentry);
+	error = lookup_create(&nd, 0, &path);
 
 	if (!IS_POSIXACL(nd.dentry->d_inode))
 		mode &= ~current->fs->umask;
-	if (!IS_ERR(dentry)) {
+	if (!error) {
 		switch (mode & S_IFMT) {
 		case 0: case S_IFREG:
-			error = vfs_create(nd.dentry->d_inode,dentry,mode,&nd);
+			error = vfs_create(nd.dentry->d_inode, path.dentry,
+					   mode, &nd);
 			break;
 		case S_IFCHR: case S_IFBLK:
-			error = vfs_mknod(nd.dentry->d_inode,dentry,mode,
-					new_decode_dev(dev));
+			error = vfs_mknod(nd.dentry->d_inode, path.dentry,
+					  mode, new_decode_dev(dev));
 			break;
 		case S_IFIFO: case S_IFSOCK:
-			error = vfs_mknod(nd.dentry->d_inode,dentry,mode,0);
+			error = vfs_mknod(nd.dentry->d_inode, path.dentry,
+					  mode, 0);
 			break;
 		case S_IFDIR:
 			error = -EPERM;
@@ -1941,7 +1937,7 @@ asmlinkage long sys_mknodat(int dfd, con
 		default:
 			error = -EINVAL;
 		}
-		dput(dentry);
+		dput_path(&path, &nd);
 	}
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
 	path_release(&nd);
@@ -1982,7 +1978,7 @@ asmlinkage long sys_mkdirat(int dfd, con
 {
 	int error = 0;
 	char * tmp;
-	struct dentry *dentry;
+	struct path path;
 	struct nameidata nd;
 
 	tmp = getname(pathname);
@@ -1993,15 +1989,14 @@ asmlinkage long sys_mkdirat(int dfd, con
 	error = do_path_lookup(dfd, tmp, LOOKUP_PARENT, &nd);
 	if (error)
 		goto out;
-	dentry = lookup_create(&nd, 1);
-	error = PTR_ERR(dentry);
-	if (IS_ERR(dentry))
+	error = lookup_create(&nd, 1, &path);
+	if (error)
 		goto out_unlock;
 
 	if (!IS_POSIXACL(nd.dentry->d_inode))
 		mode &= ~current->fs->umask;
-	error = vfs_mkdir(nd.dentry->d_inode, dentry, mode);
-	dput(dentry);
+	error = vfs_mkdir(nd.dentry->d_inode, path.dentry, mode);
+	dput_path(&path, &nd);
 out_unlock:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
 	path_release(&nd);
@@ -2247,7 +2242,7 @@ asmlinkage long sys_symlinkat(const char
 	int error = 0;
 	char * from;
 	char * to;
-	struct dentry *dentry;
+	struct path path;
 	struct nameidata nd;
 
 	from = getname(oldname);
@@ -2261,13 +2256,12 @@ asmlinkage long sys_symlinkat(const char
 	error = do_path_lookup(newdfd, to, LOOKUP_PARENT, &nd);
 	if (error)
 		goto out;
-	dentry = lookup_create(&nd, 0);
-	error = PTR_ERR(dentry);
-	if (IS_ERR(dentry))
+	error = lookup_create(&nd, 0, &path);
+	if (error)
 		goto out_unlock;
 
-	error = vfs_symlink(nd.dentry->d_inode, dentry, from, S_IALLUGO);
-	dput(dentry);
+	error = vfs_symlink(nd.dentry->d_inode, path.dentry, from, S_IALLUGO);
+	dput_path(&path, &nd);
 out_unlock:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
 	path_release(&nd);
@@ -2334,7 +2328,7 @@ asmlinkage long sys_linkat(int olddfd, c
 			   int newdfd, const char __user *newname,
 			   int flags)
 {
-	struct dentry *new_dentry;
+	struct path path;
 	struct nameidata nd, old_nd;
 	int error;
 	char * to;
@@ -2357,12 +2351,11 @@ asmlinkage long sys_linkat(int olddfd, c
 	error = -EXDEV;
 	if (old_nd.mnt != nd.mnt)
 		goto out_release;
-	new_dentry = lookup_create(&nd, 0);
-	error = PTR_ERR(new_dentry);
-	if (IS_ERR(new_dentry))
+	error = lookup_create(&nd, 0, &path);
+	if (error)
 		goto out_unlock;
-	error = vfs_link(old_nd.dentry, nd.dentry->d_inode, new_dentry);
-	dput(new_dentry);
+	error = vfs_link(old_nd.dentry, nd.dentry->d_inode, path.dentry);
+	dput_path(&path, &nd);
 out_unlock:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
 out_release:
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -358,7 +358,6 @@ static inline int d_mountpoint(struct de
 
 extern struct vfsmount *lookup_mnt(struct vfsmount *, struct dentry *);
 extern struct vfsmount *__lookup_mnt(struct vfsmount *, struct dentry *, int);
-extern struct dentry *lookup_create(struct nameidata *nd, int is_dir);
 
 extern int sysctl_vfs_cache_pressure;
 
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -91,6 +91,7 @@ static inline struct dentry *lookup_one_
 {
 	return lookup_one_len_nd(name, dir, len, NULL);
 }
+extern int lookup_create(struct nameidata *, int, struct path *);
 
 extern int follow_down(struct vfsmount **, struct dentry **);
 extern int follow_up(struct vfsmount **, struct dentry **);
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -749,8 +749,8 @@ static int unix_bind(struct socket *sock
 	struct sock *sk = sock->sk;
 	struct unix_sock *u = unix_sk(sk);
 	struct sockaddr_un *sunaddr=(struct sockaddr_un *)uaddr;
-	struct dentry * dentry = NULL;
 	struct nameidata nd;
+	struct path path;
 	int err;
 	unsigned hash;
 	struct unix_address *addr;
@@ -797,9 +797,8 @@ static int unix_bind(struct socket *sock
 		if (err)
 			goto out_mknod_parent;
 
-		dentry = lookup_create(&nd, 0);
-		err = PTR_ERR(dentry);
-		if (IS_ERR(dentry))
+		err = lookup_create(&nd, 0, &path);
+		if (err)
 			goto out_mknod_unlock;
 
 		/*
@@ -807,12 +806,11 @@ static int unix_bind(struct socket *sock
 		 */
 		mode = S_IFSOCK |
 		       (SOCK_INODE(sock)->i_mode & ~current->fs->umask);
-		err = vfs_mknod(nd.dentry->d_inode, dentry, mode, 0);
+		err = vfs_mknod(nd.dentry->d_inode, path.dentry, mode, 0);
 		if (err)
 			goto out_mknod_dput;
 		mutex_unlock(&nd.dentry->d_inode->i_mutex);
-		dput(nd.dentry);
-		nd.dentry = dentry;
+		path_to_nameidata(&path, &nd);
 
 		addr->hash = UNIX_HASH_SIZE;
 	}
@@ -829,7 +827,8 @@ static int unix_bind(struct socket *sock
 
 		list = &unix_socket_table[addr->hash];
 	} else {
-		list = &unix_socket_table[dentry->d_inode->i_ino & (UNIX_HASH_SIZE-1)];
+		list = &unix_socket_table[nd.dentry->d_inode->i_ino &
+					  (UNIX_HASH_SIZE-1)];
 		u->dentry = nd.dentry;
 		u->mnt    = nd.mnt;
 	}
@@ -847,7 +846,7 @@ out:
 	return err;
 
 out_mknod_dput:
-	dput(dentry);
+	dput_path(&path, &nd);
 out_mknod_unlock:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
 	path_release(&nd);

-- 

