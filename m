Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbYLFFZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbYLFFZf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 00:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYLFFZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 00:25:14 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:56019 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbYLFFZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 00:25:09 -0500
To: sds@tycho.nsa.gov, viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: serue@us.ibm.com, jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, takedakn@nttdata.co.jp,
       haradats@nttdata.co.jp, penguin-kernel@I-love.SAKURA.ne.jp
Subject: [RFC] Add "reason" parameter to mnt_want_write().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <493649C5.2060402@nttdata.co.jp>
	<1228313605.32059.23.camel@moss-spartans.epoch.ncsc.mil>
	<200812042100.HFE00081.tFFOHMQVOLFOSJ@I-love.SAKURA.ne.jp>
	<1228513998.21715.75.camel@localhost.localdomain>
	<200812060827.ECD30776.FLOOHVFMtSOFJQ@I-love.SAKURA.ne.jp>
In-Reply-To: <200812060827.ECD30776.FLOOHVFMtSOFJQ@I-love.SAKURA.ne.jp>
Message-Id: <200812061425.GIH12430.FMOFOVFSJtHQLO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 6 Dec 2008 14:25:01 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to allow LSM modules to perform MAC which takes an absolute pathname of
a requested file into account. Since we can't pass "struct vfsmount" to VFS
helper functions, we are trying to somehow pass "struct vfsmount"'s pathnames
instead of "struct vfsmount" itself.

The mnt_want_write() and mnt_drop_write() hooks are inserted around VFS helper
functions call. Thus, I think we can insert security_path_set() into
mnt_want_write() and secuity_path_clear() into mnt_drop_write() rather than
scattering security_path_set() and security_path_clear() all around the places.

But, mnt_want_write() and mnt_drop_write() are used for not only VFS helper
functions call but also various places. Thus, honestly calculating vfsmount's
pathnames for touch_atime()/file_update_time() operations triggers measurable
performance regression.

We want to skip calculating vfsmount's pathnames when the mnt_want_write()
call is not interested for the LSM modules.
This patch adds "reason" parameter to mnt_want_write() so that LSM modules can
calculate vfsmount's pathnames only when needed. The "reason" parameter is one
of constants listed below.

  /* For subsequent VFS helper functions call.                     */
  MNT_WANT_FOR_VFS_REQUEST,    /* vfs_create()/vfs_mkdir() etc.    */
  /* For implicit write of inode's timestamps.                     */
  MNT_WANT_FOR_UPDATE_ACMTIME, /* touch_atime()/file_update_time() */
  /* For explicit write of inode's attributes and timestamps.      */
  MNT_WANT_FOR_UPDATE_ATTR,    /* chmod()/chown()/utimes() etc.    */
  /* For filesystem's ioctl.                                       */
  MNT_WANT_FOR_FS_IOCTL,       /* ext3_ioctl() etc.                */
  /* For opening a file for writing.                               */
  MNT_WANT_FOR_OPEN_WRITE,     /* __get_file_write_access()        */
  /* Needs to be granted since the caller doesn't check errors.    */
  MNT_WANT_ANYWAY              /* init_file()                      */

Please review.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/ext2/ioctl.c              |    6 +++---
 fs/ext3/ioctl.c              |   10 +++++-----
 fs/ext4/ioctl.c              |   10 +++++-----
 fs/fat/file.c                |    2 +-
 fs/file_table.c              |    2 +-
 fs/gfs2/ops_file.c           |    2 +-
 fs/hfsplus/ioctl.c           |    2 +-
 fs/inode.c                   |    4 ++--
 fs/jfs/ioctl.c               |    2 +-
 fs/namei.c                   |   18 +++++++++---------
 fs/namespace.c               |   15 ++++++++++++++-
 fs/ncpfs/ioctl.c             |    2 +-
 fs/nfsd/nfs4proc.c           |    3 ++-
 fs/nfsd/nfs4recover.c        |    6 +++---
 fs/nfsd/nfs4state.c          |    3 ++-
 fs/nfsd/vfs.c                |   21 ++++++++++++++-------
 fs/ocfs2/ioctl.c             |    3 ++-
 fs/open.c                    |   16 ++++++++--------
 fs/reiserfs/ioctl.c          |    5 +++--
 fs/ubifs/ioctl.c             |    2 +-
 fs/utimes.c                  |    2 +-
 fs/xattr.c                   |   12 ++++++------
 fs/xfs/linux-2.6/xfs_ioctl.c |    6 ++++--
 fs/xfs/linux-2.6/xfs_lrw.c   |    3 ++-
 include/linux/mount.h        |   17 ++++++++++++++++-
 ipc/mqueue.c                 |    4 ++--
 net/unix/af_unix.c           |    2 +-
 27 files changed, 111 insertions(+), 69 deletions(-)

--- linux-2.6.28-rc7-mm1.orig/fs/ext2/ioctl.c
+++ linux-2.6.28-rc7-mm1/fs/ext2/ioctl.c
@@ -36,7 +36,7 @@ long ext2_ioctl(struct file *filp, unsig
 	case EXT2_IOC_SETFLAGS: {
 		unsigned int oldflags;
 
-		ret = mnt_want_write(filp->f_path.mnt);
+		ret = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (ret)
 			return ret;
 
@@ -93,7 +93,7 @@ setflags_out:
 	case EXT2_IOC_SETVERSION:
 		if (!is_owner_or_cap(inode))
 			return -EPERM;
-		ret = mnt_want_write(filp->f_path.mnt);
+		ret = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (ret)
 			return ret;
 		if (get_user(inode->i_generation, (int __user *) arg)) {
@@ -123,7 +123,7 @@ setflags_out:
 		if (get_user(rsv_window_size, (int __user *)arg))
 			return -EFAULT;
 
-		ret = mnt_want_write(filp->f_path.mnt);
+		ret = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (ret)
 			return ret;
 
--- linux-2.6.28-rc7-mm1.orig/fs/ext3/ioctl.c
+++ linux-2.6.28-rc7-mm1/fs/ext3/ioctl.c
@@ -39,7 +39,7 @@ int ext3_ioctl (struct inode * inode, st
 		unsigned int oldflags;
 		unsigned int jflag;
 
-		err = mnt_want_write(filp->f_path.mnt);
+		err = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (err)
 			return err;
 
@@ -141,7 +141,7 @@ flags_out:
 
 		if (!is_owner_or_cap(inode))
 			return -EPERM;
-		err = mnt_want_write(filp->f_path.mnt);
+		err = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (err)
 			return err;
 		if (get_user(generation, (int __user *) arg)) {
@@ -202,7 +202,7 @@ setversion_out:
 		if (!test_opt(inode->i_sb, RESERVATION) ||!S_ISREG(inode->i_mode))
 			return -ENOTTY;
 
-		err = mnt_want_write(filp->f_path.mnt);
+		err = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (err)
 			return err;
 
@@ -244,7 +244,7 @@ setrsvsz_out:
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
 
-		err = mnt_want_write(filp->f_path.mnt);
+		err = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (err)
 			return err;
 
@@ -270,7 +270,7 @@ group_extend_out:
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
 
-		err = mnt_want_write(filp->f_path.mnt);
+		err = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (err)
 			return err;
 
--- linux-2.6.28-rc7-mm1.orig/fs/ext4/ioctl.c
+++ linux-2.6.28-rc7-mm1/fs/ext4/ioctl.c
@@ -44,7 +44,7 @@ long ext4_ioctl(struct file *filp, unsig
 		if (get_user(flags, (int __user *) arg))
 			return -EFAULT;
 
-		err = mnt_want_write(filp->f_path.mnt);
+		err = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (err)
 			return err;
 
@@ -141,7 +141,7 @@ flags_out:
 		if (!is_owner_or_cap(inode))
 			return -EPERM;
 
-		err = mnt_want_write(filp->f_path.mnt);
+		err = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (err)
 			return err;
 		if (get_user(generation, (int __user *) arg)) {
@@ -200,7 +200,7 @@ setversion_out:
 		if (get_user(n_blocks_count, (__u32 __user *)arg))
 			return -EFAULT;
 
-		err = mnt_want_write(filp->f_path.mnt);
+		err = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (err)
 			return err;
 
@@ -226,7 +226,7 @@ setversion_out:
 				sizeof(input)))
 			return -EFAULT;
 
-		err = mnt_want_write(filp->f_path.mnt);
+		err = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (err)
 			return err;
 
@@ -247,7 +247,7 @@ setversion_out:
 		if (!is_owner_or_cap(inode))
 			return -EACCES;
 
-		err = mnt_want_write(filp->f_path.mnt);
+		err = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (err)
 			return err;
 		/*
--- linux-2.6.28-rc7-mm1.orig/fs/fat/file.c
+++ linux-2.6.28-rc7-mm1/fs/fat/file.c
@@ -47,7 +47,7 @@ int fat_generic_ioctl(struct inode *inod
 
 		mutex_lock(&inode->i_mutex);
 
-		err = mnt_want_write(filp->f_path.mnt);
+		err = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (err)
 			goto up_no_drop_write;
 
--- linux-2.6.28-rc7-mm1.orig/fs/file_table.c
+++ linux-2.6.28-rc7-mm1/fs/file_table.c
@@ -210,7 +210,7 @@ int init_file(struct file *file, struct 
 	 */
 	if ((mode & FMODE_WRITE) && !special_file(dentry->d_inode->i_mode)) {
 		file_take_write(file);
-		error = mnt_want_write(mnt);
+		error = mnt_want_write(mnt, MNT_WANT_ANYWAY);
 		WARN_ON(error);
 	}
 	return error;
--- linux-2.6.28-rc7-mm1.orig/fs/gfs2/ops_file.c
+++ linux-2.6.28-rc7-mm1/fs/gfs2/ops_file.c
@@ -211,7 +211,7 @@ static int do_gfs2_set_flags(struct file
 	int error;
 	u32 new_flags, flags;
 
-	error = mnt_want_write(filp->f_path.mnt);
+	error = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 	if (error)
 		return error;
 
--- linux-2.6.28-rc7-mm1.orig/fs/hfsplus/ioctl.c
+++ linux-2.6.28-rc7-mm1/fs/hfsplus/ioctl.c
@@ -37,7 +37,7 @@ int hfsplus_ioctl(struct inode *inode, s
 		return put_user(flags, (int __user *)arg);
 	case HFSPLUS_IOC_EXT2_SETFLAGS: {
 		int err = 0;
-		err = mnt_want_write(filp->f_path.mnt);
+		err = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (err)
 			return err;
 
--- linux-2.6.28-rc7-mm1.orig/fs/inode.c
+++ linux-2.6.28-rc7-mm1/fs/inode.c
@@ -1235,7 +1235,7 @@ void touch_atime(struct vfsmount *mnt, s
 	struct inode *inode = dentry->d_inode;
 	struct timespec now;
 
-	if (mnt_want_write(mnt))
+	if (mnt_want_write(mnt, MNT_WANT_FOR_UPDATE_ACMTIME))
 		return;
 	if (inode->i_flags & S_NOATIME)
 		goto out;
@@ -1291,7 +1291,7 @@ void file_update_time(struct file *file)
 	if (IS_NOCMTIME(inode))
 		return;
 
-	err = mnt_want_write(file->f_path.mnt);
+	err = mnt_want_write(file->f_path.mnt, MNT_WANT_FOR_UPDATE_ACMTIME);
 	if (err)
 		return;
 
--- linux-2.6.28-rc7-mm1.orig/fs/jfs/ioctl.c
+++ linux-2.6.28-rc7-mm1/fs/jfs/ioctl.c
@@ -68,7 +68,7 @@ long jfs_ioctl(struct file *filp, unsign
 		unsigned int oldflags;
 		int err;
 
-		err = mnt_want_write(filp->f_path.mnt);
+		err = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (err)
 			return err;
 
--- linux-2.6.28-rc7-mm1.orig/fs/namei.c
+++ linux-2.6.28-rc7-mm1/fs/namei.c
@@ -1723,7 +1723,7 @@ do_last:
 		 * a permanent write count is taken through
 		 * the 'struct file' in nameidata_to_filp().
 		 */
-		error = mnt_want_write(nd.path.mnt);
+		error = mnt_want_write(nd.path.mnt, MNT_WANT_FOR_VFS_REQUEST);
 		if (error)
 			goto exit_mutex_unlock;
 		error = __open_namei_create(&nd, &path, flag, mode);
@@ -1775,7 +1775,7 @@ ok:
 	 */
 	will_write = open_will_write_to_fs(flag, nd.path.dentry->d_inode);
 	if (will_write) {
-		error = mnt_want_write(nd.path.mnt);
+		error = mnt_want_write(nd.path.mnt, MNT_WANT_FOR_VFS_REQUEST);
 		if (error)
 			goto exit;
 	}
@@ -1996,7 +1996,7 @@ asmlinkage long sys_mknodat(int dfd, con
 	error = may_mknod(mode);
 	if (error)
 		goto out_dput;
-	error = mnt_want_write(nd.path.mnt);
+	error = mnt_want_write(nd.path.mnt, MNT_WANT_FOR_VFS_REQUEST);
 	if (error)
 		goto out_dput;
 	switch (mode & S_IFMT) {
@@ -2067,7 +2067,7 @@ asmlinkage long sys_mkdirat(int dfd, con
 
 	if (!IS_POSIXACL(nd.path.dentry->d_inode))
 		mode &= ~current->fs->umask;
-	error = mnt_want_write(nd.path.mnt);
+	error = mnt_want_write(nd.path.mnt, MNT_WANT_FOR_VFS_REQUEST);
 	if (error)
 		goto out_dput;
 	error = vfs_mkdir(nd.path.dentry->d_inode, dentry, mode);
@@ -2177,7 +2177,7 @@ static long do_rmdir(int dfd, const char
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto exit2;
-	error = mnt_want_write(nd.path.mnt);
+	error = mnt_want_write(nd.path.mnt, MNT_WANT_FOR_VFS_REQUEST);
 	if (error)
 		goto exit3;
 	error = vfs_rmdir(nd.path.dentry->d_inode, dentry);
@@ -2262,7 +2262,7 @@ static long do_unlinkat(int dfd, const c
 		inode = dentry->d_inode;
 		if (inode)
 			atomic_inc(&inode->i_count);
-		error = mnt_want_write(nd.path.mnt);
+		error = mnt_want_write(nd.path.mnt, MNT_WANT_FOR_VFS_REQUEST);
 		if (error)
 			goto exit2;
 		error = vfs_unlink(nd.path.dentry->d_inode, dentry);
@@ -2343,7 +2343,7 @@ asmlinkage long sys_symlinkat(const char
 	if (IS_ERR(dentry))
 		goto out_unlock;
 
-	error = mnt_want_write(nd.path.mnt);
+	error = mnt_want_write(nd.path.mnt, MNT_WANT_FOR_VFS_REQUEST);
 	if (error)
 		goto out_dput;
 	error = vfs_symlink(nd.path.dentry->d_inode, dentry, from);
@@ -2440,7 +2440,7 @@ asmlinkage long sys_linkat(int olddfd, c
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
 		goto out_unlock;
-	error = mnt_want_write(nd.path.mnt);
+	error = mnt_want_write(nd.path.mnt, MNT_WANT_FOR_VFS_REQUEST);
 	if (error)
 		goto out_dput;
 	error = vfs_link(old_path.dentry, nd.path.dentry->d_inode, new_dentry);
@@ -2674,7 +2674,7 @@ asmlinkage long sys_renameat(int olddfd,
 	if (new_dentry == trap)
 		goto exit5;
 
-	error = mnt_want_write(oldnd.path.mnt);
+	error = mnt_want_write(oldnd.path.mnt, MNT_WANT_FOR_VFS_REQUEST);
 	if (error)
 		goto exit5;
 	error = vfs_rename(old_dir->d_inode, old_dentry,
--- linux-2.6.28-rc7-mm1.orig/fs/namespace.c
+++ linux-2.6.28-rc7-mm1/fs/namespace.c
@@ -242,6 +242,7 @@ static inline void use_cpu_writer_for_mo
 /**
  * mnt_want_write - get write access to a mount
  * @mnt: the mount on which to take a write
+ * @reason: reason for this call
  *
  * This tells the low-level filesystem that a write is
  * about to be performed to it, and makes sure that
@@ -249,11 +250,16 @@ static inline void use_cpu_writer_for_mo
  * the write operation is finished, mnt_drop_write()
  * must be called.  This is effectively a refcount.
  */
-int mnt_want_write(struct vfsmount *mnt)
+int mnt_want_write(struct vfsmount *mnt, const int reason)
 {
 	int ret = 0;
 	struct mnt_writer *cpu_writer;
 
+	/*
+	ret = security_path_set(mnt, reason);
+	if (ret)
+		return ret;
+	*/
 	cpu_writer = &get_cpu_var(mnt_writers);
 	spin_lock(&cpu_writer->lock);
 	if (__mnt_is_readonly(mnt)) {
@@ -265,6 +271,10 @@ int mnt_want_write(struct vfsmount *mnt)
 out:
 	spin_unlock(&cpu_writer->lock);
 	put_cpu_var(mnt_writers);
+	/*
+	if (ret)
+		security_path_clear();
+	*/
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mnt_want_write);
@@ -362,6 +372,9 @@ void mnt_drop_write(struct vfsmount *mnt
 	 * we could theoretically wrap __mnt_writers.
 	 */
 	put_cpu_var(mnt_writers);
+	/*
+	security_path_clear();
+	*/
 }
 EXPORT_SYMBOL_GPL(mnt_drop_write);
 
--- linux-2.6.28-rc7-mm1.orig/fs/ncpfs/ioctl.c
+++ linux-2.6.28-rc7-mm1/fs/ncpfs/ioctl.c
@@ -861,7 +861,7 @@ int ncp_ioctl(struct inode *inode, struc
 		 * -EACCESS, so it seems consistent to keep
 		 *  that here.
 		 */
-		if (mnt_want_write(filp->f_path.mnt))
+		if (mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL))
 			return -EACCES;
 	}
 	ret = __ncp_ioctl(inode, filp, cmd, arg);
--- linux-2.6.28-rc7-mm1.orig/fs/nfsd/nfs4proc.c
+++ linux-2.6.28-rc7-mm1/fs/nfsd/nfs4proc.c
@@ -661,7 +661,8 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 			return status;
 		}
 	}
-	status = mnt_want_write(cstate->current_fh.fh_export->ex_path.mnt);
+	status = mnt_want_write(cstate->current_fh.fh_export->ex_path.mnt,
+				MNT_WANT_FOR_VFS_REQUEST);
 	if (status)
 		return status;
 	status = nfs_ok;
--- linux-2.6.28-rc7-mm1.orig/fs/nfsd/nfs4recover.c
+++ linux-2.6.28-rc7-mm1/fs/nfsd/nfs4recover.c
@@ -162,7 +162,7 @@ nfsd4_create_clid_dir(struct nfs4_client
 		dprintk("NFSD: nfsd4_create_clid_dir: DIRECTORY EXISTS\n");
 		goto out_put;
 	}
-	status = mnt_want_write(rec_dir.mnt);
+	status = mnt_want_write(rec_dir.mnt, MNT_WANT_FOR_VFS_REQUEST);
 	if (status)
 		goto out_put;
 	status = vfs_mkdir(rec_dir.dentry->d_inode, dentry, S_IRWXU);
@@ -326,7 +326,7 @@ nfsd4_remove_clid_dir(struct nfs4_client
 	if (!rec_dir_init || !clp->cl_firststate)
 		return;
 
-	status = mnt_want_write(rec_dir.mnt);
+	status = mnt_want_write(rec_dir.mnt, MNT_WANT_FOR_VFS_REQUEST);
 	if (status)
 		goto out;
 	clp->cl_firststate = 0;
@@ -369,7 +369,7 @@ nfsd4_recdir_purge_old(void) {
 
 	if (!rec_dir_init)
 		return;
-	status = mnt_want_write(rec_dir.mnt);
+	status = mnt_want_write(rec_dir.mnt, MNT_WANT_FOR_VFS_REQUEST);
 	if (status)
 		goto out;
 	status = nfsd4_list_rec_dir(rec_dir.dentry, purge_old);
--- linux-2.6.28-rc7-mm1.orig/fs/nfsd/nfs4state.c
+++ linux-2.6.28-rc7-mm1/fs/nfsd/nfs4state.c
@@ -1587,7 +1587,8 @@ nfs4_upgrade_open(struct svc_rqst *rqstp
 		int err = get_write_access(inode);
 		if (err)
 			return nfserrno(err);
-		err = mnt_want_write(cur_fh->fh_export->ex_path.mnt);
+		err = mnt_want_write(cur_fh->fh_export->ex_path.mnt,
+				     MNT_WANT_FOR_VFS_REQUEST);
 		if (err)
 			return nfserrno(err);
 		file_take_write(filp);
--- linux-2.6.28-rc7-mm1.orig/fs/nfsd/vfs.c
+++ linux-2.6.28-rc7-mm1/fs/nfsd/vfs.c
@@ -1261,7 +1261,8 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		goto out;
 	}
 
-	host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
+	host_err = mnt_want_write(fhp->fh_export->ex_path.mnt,
+				  MNT_WANT_FOR_VFS_REQUEST);
 	if (host_err)
 		goto out_nfserr;
 
@@ -1374,7 +1375,8 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 		v_atime = verifier[1]&0x7fffffff;
 	}
 	
-	host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
+	host_err = mnt_want_write(fhp->fh_export->ex_path.mnt,
+				  MNT_WANT_FOR_VFS_REQUEST);
 	if (host_err)
 		goto out_nfserr;
 	if (dchild->d_inode) {
@@ -1538,7 +1540,8 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 	if (IS_ERR(dnew))
 		goto out_nfserr;
 
-	host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
+	host_err = mnt_want_write(fhp->fh_export->ex_path.mnt,
+				  MNT_WANT_FOR_VFS_REQUEST);
 	if (host_err)
 		goto out_nfserr;
 
@@ -1614,7 +1617,8 @@ nfsd_link(struct svc_rqst *rqstp, struct
 	dold = tfhp->fh_dentry;
 	dest = dold->d_inode;
 
-	host_err = mnt_want_write(tfhp->fh_export->ex_path.mnt);
+	host_err = mnt_want_write(tfhp->fh_export->ex_path.mnt,
+				  MNT_WANT_FOR_VFS_REQUEST);
 	if (host_err) {
 		err = nfserrno(host_err);
 		goto out_dput;
@@ -1716,7 +1720,8 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 	host_err = -EXDEV;
 	if (ffhp->fh_export->ex_path.mnt != tfhp->fh_export->ex_path.mnt)
 		goto out_dput_new;
-	host_err = mnt_want_write(ffhp->fh_export->ex_path.mnt);
+	host_err = mnt_want_write(ffhp->fh_export->ex_path.mnt,
+				  MNT_WANT_FOR_VFS_REQUEST);
 	if (host_err)
 		goto out_dput_new;
 
@@ -1787,7 +1792,8 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 	if (!type)
 		type = rdentry->d_inode->i_mode & S_IFMT;
 
-	host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
+	host_err = mnt_want_write(fhp->fh_export->ex_path.mnt,
+				  MNT_WANT_FOR_VFS_REQUEST);
 	if (host_err)
 		goto out_nfserr;
 
@@ -2188,7 +2194,8 @@ nfsd_set_posix_acl(struct svc_fh *fhp, i
 	} else
 		size = 0;
 
-	error = mnt_want_write(fhp->fh_export->ex_path.mnt);
+	error = mnt_want_write(fhp->fh_export->ex_path.mnt,
+			       MNT_WANT_FOR_VFS_REQUEST);
 	if (error)
 		goto getout;
 	if (size)
--- linux-2.6.28-rc7-mm1.orig/fs/ocfs2/ioctl.c
+++ linux-2.6.28-rc7-mm1/fs/ocfs2/ioctl.c
@@ -129,7 +129,8 @@ long ocfs2_ioctl(struct file *filp, unsi
 		if (get_user(flags, (int __user *) arg))
 			return -EFAULT;
 
-		status = mnt_want_write(filp->f_path.mnt);
+		status = mnt_want_write(filp->f_path.mnt,
+					MNT_WANT_FOR_FS_IOCTL);
 		if (status)
 			return status;
 		status = ocfs2_set_inode_attr(inode, flags,
--- linux-2.6.28-rc7-mm1.orig/fs/open.c
+++ linux-2.6.28-rc7-mm1/fs/open.c
@@ -247,7 +247,7 @@ static long do_sys_truncate(const char _
 	if (!S_ISREG(inode->i_mode))
 		goto dput_and_out;
 
-	error = mnt_want_write(path.mnt);
+	error = mnt_want_write(path.mnt, MNT_WANT_FOR_VFS_REQUEST);
 	if (error)
 		goto dput_and_out;
 
@@ -587,7 +587,7 @@ asmlinkage long sys_fchmod(unsigned int 
 
 	audit_inode(NULL, dentry);
 
-	err = mnt_want_write(file->f_path.mnt);
+	err = mnt_want_write(file->f_path.mnt, MNT_WANT_FOR_UPDATE_ATTR);
 	if (err)
 		goto out_putf;
 	mutex_lock(&inode->i_mutex);
@@ -617,7 +617,7 @@ asmlinkage long sys_fchmodat(int dfd, co
 		goto out;
 	inode = path.dentry->d_inode;
 
-	error = mnt_want_write(path.mnt);
+	error = mnt_want_write(path.mnt, MNT_WANT_FOR_UPDATE_ATTR);
 	if (error)
 		goto dput_and_out;
 	mutex_lock(&inode->i_mutex);
@@ -672,7 +672,7 @@ asmlinkage long sys_chown(const char __u
 	error = user_path(filename, &path);
 	if (error)
 		goto out;
-	error = mnt_want_write(path.mnt);
+	error = mnt_want_write(path.mnt, MNT_WANT_FOR_UPDATE_ATTR);
 	if (error)
 		goto out_release;
 	error = chown_common(path.dentry, user, group);
@@ -697,7 +697,7 @@ asmlinkage long sys_fchownat(int dfd, co
 	error = user_path_at(dfd, filename, follow, &path);
 	if (error)
 		goto out;
-	error = mnt_want_write(path.mnt);
+	error = mnt_want_write(path.mnt, MNT_WANT_FOR_UPDATE_ATTR);
 	if (error)
 		goto out_release;
 	error = chown_common(path.dentry, user, group);
@@ -716,7 +716,7 @@ asmlinkage long sys_lchown(const char __
 	error = user_lpath(filename, &path);
 	if (error)
 		goto out;
-	error = mnt_want_write(path.mnt);
+	error = mnt_want_write(path.mnt, MNT_WANT_FOR_UPDATE_ATTR);
 	if (error)
 		goto out_release;
 	error = chown_common(path.dentry, user, group);
@@ -738,7 +738,7 @@ asmlinkage long sys_fchown(unsigned int 
 	if (!file)
 		goto out;
 
-	error = mnt_want_write(file->f_path.mnt);
+	error = mnt_want_write(file->f_path.mnt, MNT_WANT_FOR_UPDATE_ATTR);
 	if (error)
 		goto out_fput;
 	dentry = file->f_path.dentry;
@@ -773,7 +773,7 @@ static inline int __get_file_write_acces
 		/*
 		 * Balanced in __fput()
 		 */
-		error = mnt_want_write(mnt);
+		error = mnt_want_write(mnt, MNT_WANT_FOR_OPEN_WRITE);
 		if (error)
 			put_write_access(inode);
 	}
--- linux-2.6.28-rc7-mm1.orig/fs/reiserfs/ioctl.c
+++ linux-2.6.28-rc7-mm1/fs/reiserfs/ioctl.c
@@ -48,7 +48,8 @@ int reiserfs_ioctl(struct inode *inode, 
 			if (!reiserfs_attrs(inode->i_sb))
 				return -ENOTTY;
 
-			err = mnt_want_write(filp->f_path.mnt);
+			err = mnt_want_write(filp->f_path.mnt,
+					     MNT_WANT_FOR_FS_IOCTL);
 			if (err)
 				return err;
 
@@ -97,7 +98,7 @@ setflags_out:
 	case REISERFS_IOC_SETVERSION:
 		if (!is_owner_or_cap(inode))
 			return -EPERM;
-		err = mnt_want_write(filp->f_path.mnt);
+		err = mnt_want_write(filp->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (err)
 			return err;
 		if (get_user(inode->i_generation, (int __user *)arg)) {
--- linux-2.6.28-rc7-mm1.orig/fs/ubifs/ioctl.c
+++ linux-2.6.28-rc7-mm1/fs/ubifs/ioctl.c
@@ -173,7 +173,7 @@ long ubifs_ioctl(struct file *file, unsi
 		 * Make sure the file-system is read-write and make sure it
 		 * will not become read-only while we are changing the flags.
 		 */
-		err = mnt_want_write(file->f_path.mnt);
+		err = mnt_want_write(file->f_path.mnt, MNT_WANT_FOR_FS_IOCTL);
 		if (err)
 			return err;
 		err = setflags(inode, flags);
--- linux-2.6.28-rc7-mm1.orig/fs/utimes.c
+++ linux-2.6.28-rc7-mm1/fs/utimes.c
@@ -54,7 +54,7 @@ static int utimes_common(struct path *pa
 	struct iattr newattrs;
 	struct inode *inode = path->dentry->d_inode;
 
-	error = mnt_want_write(path->mnt);
+	error = mnt_want_write(path->mnt, MNT_WANT_FOR_UPDATE_ATTR);
 	if (error)
 		goto out;
 
--- linux-2.6.28-rc7-mm1.orig/fs/xattr.c
+++ linux-2.6.28-rc7-mm1/fs/xattr.c
@@ -261,7 +261,7 @@ sys_setxattr(const char __user *pathname
 	error = user_path(pathname, &path);
 	if (error)
 		return error;
-	error = mnt_want_write(path.mnt);
+	error = mnt_want_write(path.mnt, MNT_WANT_FOR_UPDATE_ATTR);
 	if (!error) {
 		error = setxattr(path.dentry, name, value, size, flags);
 		mnt_drop_write(path.mnt);
@@ -280,7 +280,7 @@ sys_lsetxattr(const char __user *pathnam
 	error = user_lpath(pathname, &path);
 	if (error)
 		return error;
-	error = mnt_want_write(path.mnt);
+	error = mnt_want_write(path.mnt, MNT_WANT_FOR_UPDATE_ATTR);
 	if (!error) {
 		error = setxattr(path.dentry, name, value, size, flags);
 		mnt_drop_write(path.mnt);
@@ -302,7 +302,7 @@ sys_fsetxattr(int fd, const char __user 
 		return error;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = mnt_want_write(f->f_path.mnt);
+	error = mnt_want_write(f->f_path.mnt, MNT_WANT_FOR_UPDATE_ATTR);
 	if (!error) {
 		error = setxattr(dentry, name, value, size, flags);
 		mnt_drop_write(f->f_path.mnt);
@@ -494,7 +494,7 @@ sys_removexattr(const char __user *pathn
 	error = user_path(pathname, &path);
 	if (error)
 		return error;
-	error = mnt_want_write(path.mnt);
+	error = mnt_want_write(path.mnt, MNT_WANT_FOR_UPDATE_ATTR);
 	if (!error) {
 		error = removexattr(path.dentry, name);
 		mnt_drop_write(path.mnt);
@@ -512,7 +512,7 @@ sys_lremovexattr(const char __user *path
 	error = user_lpath(pathname, &path);
 	if (error)
 		return error;
-	error = mnt_want_write(path.mnt);
+	error = mnt_want_write(path.mnt, MNT_WANT_FOR_UPDATE_ATTR);
 	if (!error) {
 		error = removexattr(path.dentry, name);
 		mnt_drop_write(path.mnt);
@@ -533,7 +533,7 @@ sys_fremovexattr(int fd, const char __us
 		return error;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = mnt_want_write(f->f_path.mnt);
+	error = mnt_want_write(f->f_path.mnt, MNT_WANT_FOR_UPDATE_ATTR);
 	if (!error) {
 		error = removexattr(dentry, name);
 		mnt_drop_write(f->f_path.mnt);
--- linux-2.6.28-rc7-mm1.orig/fs/xfs/linux-2.6/xfs_ioctl.c
+++ linux-2.6.28-rc7-mm1/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -629,7 +629,8 @@ xfs_attrmulti_by_handle(
 					&ops[i].am_length, ops[i].am_flags);
 			break;
 		case ATTR_OP_SET:
-			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt);
+			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt,
+							 MNT_WANT_FOR_FS_IOCTL);
 			if (ops[i].am_error)
 				break;
 			ops[i].am_error = xfs_attrmulti_attr_set(inode,
@@ -638,7 +639,8 @@ xfs_attrmulti_by_handle(
 			mnt_drop_write(parfilp->f_path.mnt);
 			break;
 		case ATTR_OP_REMOVE:
-			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt);
+			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt,
+							 MNT_WANT_FOR_FS_IOCTL);
 			if (ops[i].am_error)
 				break;
 			ops[i].am_error = xfs_attrmulti_attr_remove(inode,
--- linux-2.6.28-rc7-mm1.orig/fs/xfs/linux-2.6/xfs_lrw.c
+++ linux-2.6.28-rc7-mm1/fs/xfs/linux-2.6/xfs_lrw.c
@@ -673,7 +673,8 @@ start:
 	 * filesystems.  Throw it away if anyone asks us.
 	 */
 	if (likely(!(ioflags & IO_INVIS) &&
-		   !mnt_want_write(file->f_path.mnt))) {
+		   !mnt_want_write(file->f_path.mnt,
+				   MNT_WANT_FOR_UPDATE_ACMTIME))) {
 		xfs_ichgtime(xip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 		mnt_drop_write(file->f_path.mnt);
 	}
--- linux-2.6.28-rc7-mm1.orig/include/linux/mount.h
+++ linux-2.6.28-rc7-mm1/include/linux/mount.h
@@ -78,7 +78,22 @@ static inline struct vfsmount *mntget(st
 	return mnt;
 }
 
-extern int mnt_want_write(struct vfsmount *mnt);
+enum mnt_want_reasons {
+	/* For subsequent VFS helper functions call.                     */
+	MNT_WANT_FOR_VFS_REQUEST,    /* vfs_create()/vfs_mkdir() etc.    */
+	/* For implicit write of inode's timestamps.                     */
+	MNT_WANT_FOR_UPDATE_ACMTIME, /* touch_atime()/file_update_time() */
+	/* For explicit write of inode's attributes and timestamps.      */
+	MNT_WANT_FOR_UPDATE_ATTR,    /* chmod()/chown()/utimes() etc.    */
+	/* For filesystem's ioctl.                                       */
+	MNT_WANT_FOR_FS_IOCTL,       /* ext3_ioctl() etc.                */
+	/* For opening a file for writing.                               */
+	MNT_WANT_FOR_OPEN_WRITE,     /* __get_file_write_access()        */
+	/* Needs to be granted since the caller doesn't check errors.    */
+	MNT_WANT_ANYWAY              /* init_file()                      */
+};
+
+extern int mnt_want_write(struct vfsmount *mnt, const int reason);
 extern void mnt_drop_write(struct vfsmount *mnt);
 extern void mntput_no_expire(struct vfsmount *mnt);
 extern void mnt_pin(struct vfsmount *mnt);
--- linux-2.6.28-rc7-mm1.orig/ipc/mqueue.c
+++ linux-2.6.28-rc7-mm1/ipc/mqueue.c
@@ -611,7 +611,7 @@ static struct file *do_create(struct den
 	}
 
 	mode &= ~current->fs->umask;
-	ret = mnt_want_write(mqueue_mnt);
+	ret = mnt_want_write(mqueue_mnt, MNT_WANT_FOR_VFS_REQUEST);
 	if (ret)
 		goto out;
 	ret = vfs_create(dir->d_inode, dentry, mode, NULL);
@@ -753,7 +753,7 @@ asmlinkage long sys_mq_unlink(const char
 	inode = dentry->d_inode;
 	if (inode)
 		atomic_inc(&inode->i_count);
-	err = mnt_want_write(mqueue_mnt);
+	err = mnt_want_write(mqueue_mnt, MNT_WANT_FOR_VFS_REQUEST);
 	if (err)
 		goto out_err;
 	err = vfs_unlink(dentry->d_parent->d_inode, dentry);
--- linux-2.6.28-rc7-mm1.orig/net/unix/af_unix.c
+++ linux-2.6.28-rc7-mm1/net/unix/af_unix.c
@@ -833,7 +833,7 @@ static int unix_bind(struct socket *sock
 		 */
 		mode = S_IFSOCK |
 		       (SOCK_INODE(sock)->i_mode & ~current->fs->umask);
-		err = mnt_want_write(nd.path.mnt);
+		err = mnt_want_write(nd.path.mnt, MNT_WANT_FOR_VFS_REQUEST);
 		if (err)
 			goto out_mknod_dput;
 		err = vfs_mknod(nd.path.dentry->d_inode, dentry, mode, 0);
