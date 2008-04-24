Return-Path: <linux-kernel-owner+w=401wt.eu-S1758405AbYDXLl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405AbYDXLl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 07:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757642AbYDXLk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 07:40:58 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57184 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbYDXLk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 07:40:27 -0400
Message-Id: <20080424114012.358931047@szeredi.hu>
References: <20080424113950.818688067@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Apr 2008 13:39:54 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 04/13] vfs: add path_create() and path_mknod()
Content-Disposition: inline; filename=path_create.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

R/O bind mounts require operations which modify the filesystem to be
wrapped in mnt_want_write()/mnt_drop_write().  Create helpers which do
this, so callers won't need to bother, and more importantly, cannot
forget!  Call these path_*, analogous to vfs_*.  Where there are no
callers of vfs_* left, make them static.

Overall this patchset is just 15 lines in the red, but at the same
time it fixes several places in nfsd and the whole of ecryptfs, where
the mnt_want_write/drop_write() calls were mssing.  So it's definitely
a cleanup.

It will also help with merging certain security modules, which need to
know the path within the namespace, and not just within the
filesystem.  These helpers will allow the security hooks to be in a
common place, and need not be repeated in all callers.

As I understood Al Viro's main objection is that this is not a good
interface, because callers should not be forced to have a vfsmount
available.  This is bogus for two reasons:

 1) The dentry_open() interface already requires a vfsmount, so any
 callers operating on the filesystem and wanting to do file I/O would
 necessarily have the vfsmount available.  Theoretically it would be
 possible that the caller doesn't want to do file I/O only
 create/remove/*attr, but this is unlikely.

 2) Many benefits of the R/O bind mounts would disappear if we'd allow
 callers to bypass the per-mount R/O checks.  Which means, that
 callers do have to have the vfsmount available to do these checks
 anyway.

Note, that callers might want to do mnt_want_write/drop_write() around
multiple operation to make them atomic wrt. remounting read-only.  In
that case checking within the VFS is superfluous, but it should not
have any noticable performance impact.


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

Index: vfs-2.6/fs/namei.c
===================================================================
--- vfs-2.6.orig/fs/namei.c	2008-04-23 21:30:25.000000000 +0200
+++ vfs-2.6/fs/namei.c	2008-04-24 12:00:28.000000000 +0200
@@ -1574,7 +1574,7 @@ void unlock_rename(struct dentry *p1, st
 	}
 }
 
-int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
+static int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 		struct nameidata *nd)
 {
 	int error = may_create(dir, dentry, nd);
@@ -1596,6 +1596,20 @@ int vfs_create(struct inode *dir, struct
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
@@ -2015,7 +2029,7 @@ fail:
 }
 EXPORT_SYMBOL_GPL(lookup_create);
 
-int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+static int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 {
 	int error = may_create(dir, dentry, NULL);
 
@@ -2039,22 +2053,19 @@ int vfs_mknod(struct inode *dir, struct 
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
@@ -2080,26 +2091,22 @@ asmlinkage long sys_mknodat(int dfd, con
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
@@ -2966,11 +2973,9 @@ EXPORT_SYMBOL(permission);
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
Index: vfs-2.6/include/linux/fs.h
===================================================================
--- vfs-2.6.orig/include/linux/fs.h	2008-04-23 21:30:25.000000000 +0200
+++ vfs-2.6/include/linux/fs.h	2008-04-24 12:00:28.000000000 +0200
@@ -1123,9 +1123,9 @@ extern void unlock_super(struct super_bl
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
Index: vfs-2.6/fs/ecryptfs/inode.c
===================================================================
--- vfs-2.6.orig/fs/ecryptfs/inode.c	2008-04-23 21:30:28.000000000 +0200
+++ vfs-2.6/fs/ecryptfs/inode.c	2008-04-24 12:00:28.000000000 +0200
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
Index: vfs-2.6/ipc/mqueue.c
===================================================================
--- vfs-2.6.orig/ipc/mqueue.c	2008-04-23 21:30:25.000000000 +0200
+++ vfs-2.6/ipc/mqueue.c	2008-04-24 12:00:28.000000000 +0200
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
Index: vfs-2.6/net/unix/af_unix.c
===================================================================
--- vfs-2.6.orig/net/unix/af_unix.c	2008-04-23 21:30:25.000000000 +0200
+++ vfs-2.6/net/unix/af_unix.c	2008-04-23 21:30:34.000000000 +0200
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
Index: vfs-2.6/fs/nfsd/vfs.c
===================================================================
--- vfs-2.6.orig/fs/nfsd/vfs.c	2008-04-23 21:30:28.000000000 +0200
+++ vfs-2.6/fs/nfsd/vfs.c	2008-04-24 12:00:28.000000000 +0200
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
@@ -1185,6 +1191,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
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
