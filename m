Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbYEPQg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbYEPQg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbYEPQc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:32:57 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33757 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314AbYEPQcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:32:52 -0400
Message-Id: <20080516163231.826716085@szeredi.hu>
References: <20080516163136.560107038@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 16 May 2008 18:31:49 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 13/22] vfs: add path_create() and path_mknod()
Content-Disposition: inline; filename=path_create.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

R/O bind mounts require operations which modify the filesystem to be
wrapped in mnt_want_write()/mnt_drop_write().  Create helpers which do
this, so callers won't need to bother, and more importantly, cannot
forget!  Call these path_*, analogous to vfs_*.  Since there are no
callers of vfs_* left, make them static.

Overall this patchset is just 23 lines in the red, but at the same
time it fixes several places in nfsd and the whole of ecryptfs, where
the mnt_want_write/drop_write() calls were missing.

It will also help with merging certain security modules, which need to
know the path within the namespace, and not just within the
filesystem.  These helpers will allow the security hooks to be in a
common place, and need not be repeated in all callers.

Note, that the mnt_want_write/drop_write() bracketing provided by the
path_* functions is not strictly necessary in all cases, since the
caller may do it's own bracketing to span multiple VFS calls.
However, this does not make the checks in path_* incorrect, just
unnecessary.

The advantages of the path_* API are:

  - it's consistent

  - it provides some (not all) guarantees, i.e. it's easier to prove
    that all callers play by the rules

  - for the syscall case it has zero cost

  - for all the other cases it has either zero, or minimal cost

It does require the caller to have a vfsmount available, but it's hard
to imagine that the caller does not have it:

  - most userspace calls do have it, as they are either operating on a
    path or a file descriptor.  There are some exceptions like sync(2)
    and ustat(2), the latter not being a very exemplary interface, and
    neither of them being relevant to this discussion.

  - all kernel callers (nfs export, stacking) should have it, as they
    need it for open() anyway

And even if some theoretical caller didn't have the vfsmount, it still
should be easy to allocate one, providing a clean way to do the r/o
bracketing, and not requiring another mechanism to be exported that
provides the same functionality on the superblock.


This patch:

Introduce path_create() and path_mknod().  Make vfs_create() and
vfs_mknod() static.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/inode.c |   33 ++++++++++------------
 fs/namei.c          |   75 +++++++++++++++++++++++++++-------------------------
 fs/nfsd/vfs.c       |   19 +++++++++----
 include/linux/fs.h  |    4 +-
 ipc/mqueue.c        |    6 +++-
 net/unix/af_unix.c  |    6 ----
 6 files changed, 76 insertions(+), 67 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-16 17:50:35.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-16 17:50:48.000000000 +0200
@@ -1579,7 +1579,7 @@ void unlock_rename(struct dentry *p1, st
 	}
 }
 
-int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
+static int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 		struct nameidata *nd)
 {
 	int error = may_create(dir, dentry, nd);
@@ -1601,6 +1601,20 @@ int vfs_create(struct inode *dir, struct
 	return error;
 }
 
+int path_create(struct path *dir_path, struct dentry *dentry, int mode,
+		struct nameidata *nd)
+{
+	int error = mnt_want_write(dir_path->mnt);
+
+	if (!error) {
+		error = vfs_create(dir_path->dentry->d_inode, dentry, mode, nd);
+		mnt_drop_write(dir_path->mnt);
+	}
+
+	return error;
+}
+EXPORT_SYMBOL(path_create);
+
 int may_open(struct nameidata *nd, int acc_mode, int flag)
 {
 	struct dentry *dentry = nd->path.dentry;
@@ -2020,7 +2034,7 @@ fail:
 }
 EXPORT_SYMBOL_GPL(lookup_create);
 
-int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+static int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 {
 	int error = may_create(dir, dentry, NULL);
 
@@ -2048,22 +2062,19 @@ int vfs_mknod(struct inode *dir, struct 
 	return error;
 }
 
-static int may_mknod(mode_t mode)
+int path_mknod(struct path *dir_path, struct dentry *dentry, int mode,
+	       dev_t dev)
 {
-	switch (mode & S_IFMT) {
-	case S_IFREG:
-	case S_IFCHR:
-	case S_IFBLK:
-	case S_IFIFO:
-	case S_IFSOCK:
-	case 0: /* zero mode translates to S_IFREG */
-		return 0;
-	case S_IFDIR:
-		return -EPERM;
-	default:
-		return -EINVAL;
+	int error = mnt_want_write(dir_path->mnt);
+
+	if (!error) {
+		error = vfs_mknod(dir_path->dentry->d_inode, dentry, mode, dev);
+		mnt_drop_write(dir_path->mnt);
 	}
+
+	return error;
 }
+EXPORT_SYMBOL(path_mknod);
 
 asmlinkage long sys_mknodat(int dfd, const char __user *filename, int mode,
 				unsigned dev)
@@ -2089,26 +2100,22 @@ asmlinkage long sys_mknodat(int dfd, con
 	}
 	if (!IS_POSIXACL(nd.path.dentry->d_inode))
 		mode &= ~current->fs->umask;
-	error = may_mknod(mode);
-	if (error)
-		goto out_dput;
-	error = mnt_want_write(nd.path.mnt);
-	if (error)
-		goto out_dput;
 	switch (mode & S_IFMT) {
-		case 0: case S_IFREG:
-			error = vfs_create(nd.path.dentry->d_inode,dentry,mode,&nd);
-			break;
-		case S_IFCHR: case S_IFBLK:
-			error = vfs_mknod(nd.path.dentry->d_inode,dentry,mode,
-					new_decode_dev(dev));
-			break;
-		case S_IFIFO: case S_IFSOCK:
-			error = vfs_mknod(nd.path.dentry->d_inode,dentry,mode,0);
-			break;
+	case 0: case S_IFREG:
+		error = path_create(&nd.path, dentry, mode, &nd);
+		break;
+	case S_IFCHR: case S_IFBLK:
+		error = path_mknod(&nd.path, dentry, mode, new_decode_dev(dev));
+		break;
+	case S_IFIFO: case S_IFSOCK:
+		error = path_mknod(&nd.path, dentry, mode, 0);
+		break;
+	case S_IFDIR:
+		error = -EPERM;
+		break;
+	default:
+		error = -EINVAL;
 	}
-	mnt_drop_write(nd.path.mnt);
-out_dput:
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
@@ -2975,11 +2982,9 @@ EXPORT_SYMBOL(permission);
 EXPORT_SYMBOL(vfs_permission);
 EXPORT_SYMBOL(file_permission);
 EXPORT_SYMBOL(unlock_rename);
-EXPORT_SYMBOL(vfs_create);
 EXPORT_SYMBOL(vfs_follow_link);
 EXPORT_SYMBOL(vfs_link);
 EXPORT_SYMBOL(vfs_mkdir);
-EXPORT_SYMBOL(vfs_mknod);
 EXPORT_SYMBOL(generic_permission);
 EXPORT_SYMBOL(vfs_readlink);
 EXPORT_SYMBOL(vfs_rename);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-16 17:50:46.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-16 17:50:48.000000000 +0200
@@ -1124,9 +1124,9 @@ extern void unlock_super(struct super_bl
  * VFS helper functions..
  */
 extern int vfs_permission(struct nameidata *, int);
-extern int vfs_create(struct inode *, struct dentry *, int, struct nameidata *);
+extern int path_create(struct path *, struct dentry *, int, struct nameidata *);
 extern int vfs_mkdir(struct inode *, struct dentry *, int);
-extern int vfs_mknod(struct inode *, struct dentry *, int, dev_t);
+extern int path_mknod(struct path *, struct dentry *, int, dev_t);
 extern int vfs_symlink(struct inode *, struct dentry *, const char *, int);
 extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c	2008-05-16 17:50:35.000000000 +0200
+++ linux-2.6/fs/ecryptfs/inode.c	2008-05-16 17:50:48.000000000 +0200
@@ -61,23 +61,19 @@ static void unlock_dir(struct dentry *di
  * Returns zero on success; non-zero on error condition
  */
 static int
-ecryptfs_create_underlying_file(struct inode *lower_dir_inode,
+ecryptfs_create_underlying_file(struct dentry *lower_dir_dentry,
 				struct dentry *dentry, int mode,
 				struct nameidata *nd)
 {
 	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	struct vfsmount *lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
-	struct dentry *dentry_save;
-	struct vfsmount *vfsmount_save;
+	struct path save;
 	int rc;
 
-	dentry_save = nd->path.dentry;
-	vfsmount_save = nd->path.mnt;
-	nd->path.dentry = lower_dentry;
-	nd->path.mnt = lower_mnt;
-	rc = vfs_create(lower_dir_inode, lower_dentry, mode, nd);
-	nd->path.dentry = dentry_save;
-	nd->path.mnt = vfsmount_save;
+	save = nd->path;
+	nd->path.mnt = ecryptfs_dentry_to_lower_mnt(dentry);
+	nd->path.dentry = lower_dir_dentry;
+	rc = path_create(&nd->path, lower_dentry, mode, nd);
+	nd->path = save;
 	return rc;
 }
 
@@ -111,7 +107,7 @@ ecryptfs_do_create(struct inode *directo
 		rc = PTR_ERR(lower_dir_dentry);
 		goto out;
 	}
-	rc = ecryptfs_create_underlying_file(lower_dir_dentry->d_inode,
+	rc = ecryptfs_create_underlying_file(lower_dir_dentry,
 					     ecryptfs_dentry, mode, nd);
 	if (rc) {
 		printk(KERN_ERR "%s: Failure to create dentry in lower fs; "
@@ -530,20 +526,21 @@ ecryptfs_mknod(struct inode *dir, struct
 {
 	int rc;
 	struct dentry *lower_dentry;
-	struct dentry *lower_dir_dentry;
+	struct path lower_dir;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	lower_dir_dentry = lock_parent(lower_dentry);
-	rc = vfs_mknod(lower_dir_dentry->d_inode, lower_dentry, mode, dev);
+	lower_dir.mnt = ecryptfs_dentry_to_lower_mnt(dentry);
+	lower_dir.dentry = lock_parent(lower_dentry);
+	rc = path_mknod(&lower_dir, lower_dentry, mode, dev);
 	if (rc || !lower_dentry->d_inode)
 		goto out;
 	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb, 0);
 	if (rc)
 		goto out;
-	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
-	fsstack_copy_inode_size(dir, lower_dir_dentry->d_inode);
+	fsstack_copy_attr_times(dir, lower_dir.dentry->d_inode);
+	fsstack_copy_inode_size(dir, lower_dir.dentry->d_inode);
 out:
-	unlock_dir(lower_dir_dentry);
+	unlock_dir(lower_dir.dentry);
 	if (!dentry->d_inode)
 		d_drop(dentry);
 	return rc;
Index: linux-2.6/ipc/mqueue.c
===================================================================
--- linux-2.6.orig/ipc/mqueue.c	2008-05-16 17:50:35.000000000 +0200
+++ linux-2.6/ipc/mqueue.c	2008-05-16 17:50:48.000000000 +0200
@@ -599,6 +599,7 @@ static struct file *do_create(struct den
 {
 	struct mq_attr attr;
 	struct file *result;
+	struct path dir_path;
 	int ret;
 
 	if (u_attr) {
@@ -616,7 +617,10 @@ static struct file *do_create(struct den
 	ret = mnt_want_write(mqueue_mnt);
 	if (ret)
 		goto out;
-	ret = vfs_create(dir->d_inode, dentry, mode, NULL);
+
+	dir_path.mnt = mqueue_mnt;
+	dir_path.dentry = dir;
+	ret = path_create(&dir_path, dentry, mode, NULL);
 	dentry->d_fsdata = NULL;
 	if (ret)
 		goto out_drop_write;
Index: linux-2.6/net/unix/af_unix.c
===================================================================
--- linux-2.6.orig/net/unix/af_unix.c	2008-05-16 17:50:35.000000000 +0200
+++ linux-2.6/net/unix/af_unix.c	2008-05-16 17:50:48.000000000 +0200
@@ -819,11 +819,7 @@ static int unix_bind(struct socket *sock
 		 */
 		mode = S_IFSOCK |
 		       (SOCK_INODE(sock)->i_mode & ~current->fs->umask);
-		err = mnt_want_write(nd.path.mnt);
-		if (err)
-			goto out_mknod_dput;
-		err = vfs_mknod(nd.path.dentry->d_inode, dentry, mode, 0);
-		mnt_drop_write(nd.path.mnt);
+		err = path_mknod(&nd.path, dentry, mode, 0);
 		if (err)
 			goto out_mknod_dput;
 		mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-05-16 17:50:42.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-05-16 17:50:48.000000000 +0200
@@ -130,6 +130,12 @@ out:
 	return err;
 }
 
+static void fh_to_path(struct svc_fh *fhp, struct path *path)
+{
+	path->dentry = fhp->fh_dentry;
+	path->mnt = fhp->fh_export->ex_path.mnt;
+}
+
 __be32
 nfsd_lookup_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		   const char *name, unsigned int len,
@@ -1184,6 +1190,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		char *fname, int flen, struct iattr *iap,
 		int type, dev_t rdev, struct svc_fh *resfhp)
 {
+	struct path	dir_path;
 	struct dentry	*dentry, *dchild = NULL;
 	struct inode	*dirp;
 	__be32		err;
@@ -1259,13 +1266,11 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	if (host_err)
 		goto out_nfserr;
 
-	/*
-	 * Get the dir op function pointer.
-	 */
+	fh_to_path(fhp, &dir_path);
 	err = 0;
 	switch (type) {
 	case S_IFREG:
-		host_err = vfs_create(dirp, dchild, iap->ia_mode, NULL);
+		host_err = path_create(&dir_path, dchild, iap->ia_mode, NULL);
 		break;
 	case S_IFDIR:
 		host_err = vfs_mkdir(dirp, dchild, iap->ia_mode);
@@ -1274,7 +1279,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	case S_IFBLK:
 	case S_IFIFO:
 	case S_IFSOCK:
-		host_err = vfs_mknod(dirp, dchild, iap->ia_mode, rdev);
+		host_err = path_mknod(&dir_path, dchild, iap->ia_mode, rdev);
 		break;
 	}
 	if (host_err < 0) {
@@ -1316,6 +1321,7 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 		struct svc_fh *resfhp, int createmode, u32 *verifier,
 	        int *truncp, int *created)
 {
+	struct path 	dir_path;
 	struct dentry	*dentry, *dchild = NULL;
 	struct inode	*dirp;
 	__be32		err;
@@ -1406,7 +1412,8 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 		goto out;
 	}
 
-	host_err = vfs_create(dirp, dchild, iap->ia_mode, NULL);
+	fh_to_path(fhp, &dir_path);
+	host_err = path_create(&dir_path, dchild, iap->ia_mode, NULL);
 	if (host_err < 0) {
 		mnt_drop_write(fhp->fh_export->ex_path.mnt);
 		goto out_nfserr;

--
