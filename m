Return-Path: <linux-kernel-owner+w=401wt.eu-S933023AbXLTOML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbXLTOML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932838AbXLTOKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:10:52 -0500
Received: from cantor.suse.de ([195.135.220.2]:40635 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932811AbXLTOKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:10:47 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:41 2007
Message-Id: <20071220140941.759779438@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:13 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 03/47] Add a vfsmount parameter to notify_change()
Content-Disposition: inline; filename=vfs-notify_change.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount parameter must be set appropriately for files visibile
outside the kernel. Files that are only used in a filesystem (e.g.,
reiserfs xattr files) will have a NULL vfsmount.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/attr.c           |    3 ++-
 fs/ecryptfs/inode.c |    4 +++-
 fs/exec.c           |    3 ++-
 fs/fat/file.c       |    2 +-
 fs/hpfs/namei.c     |    2 +-
 fs/namei.c          |    2 +-
 fs/nfsd/vfs.c       |    8 ++++----
 fs/open.c           |   29 ++++++++++++++++-------------
 fs/reiserfs/xattr.c |    6 +++---
 fs/sysfs/file.c     |    2 +-
 fs/unionfs/copyup.c |   22 +++++++++++++++-------
 fs/unionfs/inode.c  |   23 ++++++++++++++++-------
 fs/unionfs/rename.c |    3 ++-
 fs/unionfs/subr.c   |    3 ++-
 fs/unionfs/union.h  |    3 ++-
 fs/utimes.c         |   19 +++++++++----------
 include/linux/fs.h  |    6 +++---
 mm/filemap.c        |    2 +-
 mm/tiny-shmem.c     |    2 +-
 19 files changed, 85 insertions(+), 59 deletions(-)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -100,7 +100,8 @@ int inode_setattr(struct inode * inode, 
 }
 EXPORT_SYMBOL(inode_setattr);
 
-int notify_change(struct dentry * dentry, struct iattr * attr)
+int notify_change(struct dentry *dentry, struct vfsmount *mnt,
+		  struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
 	mode_t mode = inode->i_mode;
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -860,6 +860,7 @@ static int ecryptfs_setattr(struct dentr
 {
 	int rc = 0;
 	struct dentry *lower_dentry;
+	struct vfsmount *lower_mnt;
 	struct inode *inode;
 	struct inode *lower_inode;
 	struct ecryptfs_crypt_stat *crypt_stat;
@@ -870,6 +871,7 @@ static int ecryptfs_setattr(struct dentr
 	inode = dentry->d_inode;
 	lower_inode = ecryptfs_inode_to_lower(inode);
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
 	mutex_lock(&crypt_stat->cs_mutex);
 	if (S_ISDIR(dentry->d_inode->i_mode))
 		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
@@ -920,7 +922,7 @@ static int ecryptfs_setattr(struct dentr
 	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
 		ia->ia_valid &= ~ATTR_MODE;
 
-	rc = notify_change(lower_dentry, ia);
+	rc = notify_change(lower_dentry, lower_mnt, ia);
 out:
 	fsstack_copy_attr_all(inode, lower_inode);
 	return rc;
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1786,7 +1786,8 @@ int do_coredump(long signr, int exit_cod
 		goto close_fail;
 	if (!file->f_op->write)
 		goto close_fail;
-	if (!ispipe && do_truncate(file->f_path.dentry, 0, 0, file) != 0)
+	if (!ispipe &&
+	    do_truncate(file->f_path.dentry, file->f_path.mnt, 0, 0, file) != 0)
 		goto close_fail;
 
 	retval = binfmt->core_dump(signr, regs, file, core_limit);
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -92,7 +92,7 @@ int fat_generic_ioctl(struct inode *inod
 		}
 
 		/* This MUST be done before doing anything irreversible... */
-		err = notify_change(filp->f_path.dentry, &ia);
+		err = notify_change(filp->f_path.dentry, filp->f_path.mnt, &ia);
 		if (err)
 			goto up;
 
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -426,7 +426,7 @@ again:
 			/*printk("HPFS: truncating file before delete.\n");*/
 			newattrs.ia_size = 0;
 			newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
-			err = notify_change(dentry, &newattrs);
+			err = notify_change(dentry, NULL, &newattrs);
 			put_write_access(inode);
 			if (!err)
 				goto again;
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1663,7 +1663,7 @@ int may_open(struct nameidata *nd, int a
 		if (!error) {
 			DQUOT_INIT(inode);
 
-			error = do_truncate(dentry, 0,
+			error = do_truncate(dentry, nd->path.mnt, 0,
 					    ATTR_MTIME|ATTR_CTIME|ATTR_OPEN,
 					    NULL);
 		}
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -388,7 +388,7 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 	err = nfserr_notsync;
 	if (!check_guard || guardtime == inode->i_ctime.tv_sec) {
 		fh_lock(fhp);
-		host_err = notify_change(dentry, iap);
+		host_err = notify_change(dentry, fhp->fh_export->ex_path.mnt, iap);
 		err = nfserrno(host_err);
 		fh_unlock(fhp);
 	}
@@ -944,13 +944,13 @@ out:
 	return err;
 }
 
-static void kill_suid(struct dentry *dentry)
+static void kill_suid(struct dentry *dentry, struct vfsmount *mnt)
 {
 	struct iattr	ia;
 	ia.ia_valid = ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	notify_change(dentry, &ia);
+	notify_change(dentry, mnt, &ia);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 }
 
@@ -1009,7 +1009,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 
 	/* clear setuid/setgid flag after write */
 	if (host_err >= 0 && (inode->i_mode & (S_ISUID | S_ISGID)))
-		kill_suid(dentry);
+		kill_suid(dentry, exp->ex_path.mnt);
 
 	if (host_err >= 0 && stable) {
 		static ino_t	last_ino;
--- a/fs/open.c
+++ b/fs/open.c
@@ -194,8 +194,8 @@ out:
 	return error;
 }
 
-int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
-	struct file *filp)
+int do_truncate(struct dentry *dentry, struct vfsmount *mnt, loff_t length,
+		unsigned int time_attrs, struct file *filp)
 {
 	int err;
 	struct iattr newattrs;
@@ -215,7 +215,7 @@ int do_truncate(struct dentry *dentry, l
 	newattrs.ia_valid |= should_remove_suid(dentry);
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	err = notify_change(dentry, &newattrs);
+	err = notify_change(dentry, mnt, &newattrs);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 	return err;
 }
@@ -271,7 +271,8 @@ static long do_sys_truncate(const char _
 	error = locks_verify_truncate(inode, NULL, length);
 	if (!error) {
 		DQUOT_INIT(inode);
-		error = do_truncate(nd.path.dentry, length, 0, NULL);
+		error = do_truncate(nd.path.dentry, nd.path.mnt, length, 0,
+				    NULL);
 	}
 
 put_write_and_out:
@@ -326,7 +327,8 @@ static long do_sys_ftruncate(unsigned in
 
 	error = locks_verify_truncate(inode, file, length);
 	if (!error)
-		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);
+		error = do_truncate(dentry, file->f_path.mnt, length,
+				    ATTR_MTIME|ATTR_CTIME, file);
 out_putf:
 	fput(file);
 out:
@@ -589,7 +591,7 @@ asmlinkage long sys_fchmod(unsigned int 
 		mode = inode->i_mode;
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	err = notify_change(dentry, &newattrs);
+	err = notify_change(dentry, file->f_path.mnt, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
 out_drop_write:
@@ -626,7 +628,7 @@ asmlinkage long sys_fchmodat(int dfd, co
 		mode = inode->i_mode;
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	error = notify_change(nd.path.dentry, &newattrs);
+	error = notify_change(nd.path.dentry, nd.path.mnt, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
 out_drop_write:
@@ -642,7 +644,8 @@ asmlinkage long sys_chmod(const char __u
 	return sys_fchmodat(AT_FDCWD, filename, mode);
 }
 
-static int chown_common(struct dentry * dentry, uid_t user, gid_t group)
+static int chown_common(struct dentry * dentry, struct vfsmount *mnt,
+			uid_t user, gid_t group)
 {
 	struct inode * inode;
 	int error;
@@ -669,7 +672,7 @@ static int chown_common(struct dentry * 
 		newattrs.ia_valid |=
 			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 	mutex_lock(&inode->i_mutex);
-	error = notify_change(dentry, &newattrs);
+	error = notify_change(dentry, mnt, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 out:
 	return error;
@@ -686,7 +689,7 @@ asmlinkage long sys_chown(const char __u
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_release;
-	error = chown_common(nd.path.dentry, user, group);
+	error = chown_common(nd.path.dentry, nd.path.mnt, user, group);
 	mnt_drop_write(nd.path.mnt);
 out_release:
 	path_put(&nd.path);
@@ -711,7 +714,7 @@ asmlinkage long sys_fchownat(int dfd, co
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_release;
-	error = chown_common(nd.path.dentry, user, group);
+	error = chown_common(nd.path.dentry, nd.path.mnt, user, group);
 	mnt_drop_write(nd.path.mnt);
 out_release:
 	path_put(&nd.path);
@@ -730,7 +733,7 @@ asmlinkage long sys_lchown(const char __
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_release;
-	error = chown_common(nd.path.dentry, user, group);
+	error = chown_common(nd.path.dentry, nd.path.mnt, user, group);
 	mnt_drop_write(nd.path.mnt);
 out_release:
 	path_put(&nd.path);
@@ -754,7 +757,7 @@ asmlinkage long sys_fchown(unsigned int 
 		goto out_fput;
 	dentry = file->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = chown_common(dentry, user, group);
+	error = chown_common(dentry, file->f_path.mnt, user, group);
 	mnt_drop_write(file->f_vfsmnt);
 out_fput:
 	fput(file);
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -460,7 +460,7 @@ reiserfs_xattr_set(struct inode *inode, 
 	newattrs.ia_size = buffer_size;
 	newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
 	mutex_lock_nested(&xinode->i_mutex, I_MUTEX_XATTR);
-	err = notify_change(dentry, &newattrs);
+	err = notify_change(dentry, NULL, &newattrs);
 	if (err)
 		goto out_filp;
 
@@ -791,7 +791,7 @@ reiserfs_chown_xattrs_filler(void *buf, 
 	}
 
 	if (!S_ISDIR(xafile->d_inode->i_mode))
-		err = notify_change(xafile, attrs);
+	    err = notify_change(xafile, NULL, attrs);
 	dput(xafile);
 
 	return err;
@@ -835,7 +835,7 @@ int reiserfs_chown_xattrs(struct inode *
 		goto out_dir;
 	}
 
-	err = notify_change(dir, attrs);
+	err = notify_change(dir, NULL, attrs);
 	unlock_kernel();
 
       out_dir:
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -582,7 +582,7 @@ int sysfs_chmod_file(struct kobject *kob
 
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	rc = notify_change(victim, &newattrs);
+	rc = notify_change(victim, NULL, &newattrs);
 
 	if (rc == 0) {
 		mutex_lock(&sysfs_mutex);
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -121,7 +121,8 @@ out:
  */
 static int copyup_permissions(struct super_block *sb,
 			      struct dentry *old_lower_dentry,
-			      struct dentry *new_lower_dentry)
+			      struct dentry *new_lower_dentry,
+			      struct vfsmount *new_lower_mnt)
 {
 	struct inode *i = old_lower_dentry->d_inode;
 	struct iattr newattrs;
@@ -135,14 +136,14 @@ static int copyup_permissions(struct sup
 	newattrs.ia_valid = ATTR_CTIME | ATTR_ATIME | ATTR_MTIME |
 		ATTR_ATIME_SET | ATTR_MTIME_SET | ATTR_FORCE |
 		ATTR_GID | ATTR_UID;
-	err = notify_change(new_lower_dentry, &newattrs);
+	err = notify_change(new_lower_dentry, new_lower_mnt, &newattrs);
 	if (err)
 		goto out;
 
 	/* now try to change the mode and ignore EOPNOTSUPP on symlinks */
 	newattrs.ia_mode = i->i_mode;
 	newattrs.ia_valid = ATTR_MODE | ATTR_FORCE;
-	err = notify_change(new_lower_dentry, &newattrs);
+	err = notify_change(new_lower_dentry, new_lower_mnt, &newattrs);
 	if (err == -EOPNOTSUPP &&
 	    S_ISLNK(new_lower_dentry->d_inode->i_mode)) {
 		printk(KERN_WARNING
@@ -373,6 +374,7 @@ int copyup_dentry(struct inode *dir, str
 		  struct file **copyup_file, loff_t len)
 {
 	struct dentry *new_lower_dentry;
+	struct vfsmount *new_lower_mnt;
 	struct dentry *old_lower_dentry = NULL;
 	struct super_block *sb;
 	int err = 0;
@@ -399,7 +401,8 @@ int copyup_dentry(struct inode *dir, str
 		goto out;
 
 	/* Create the directory structure above this dentry. */
-	new_lower_dentry = create_parents(dir, dentry, name, new_bindex);
+	new_lower_dentry = create_parents(dir, dentry, name, new_bindex,
+					  &new_lower_mnt);
 	if (IS_ERR(new_lower_dentry)) {
 		err = PTR_ERR(new_lower_dentry);
 		goto out;
@@ -460,7 +463,8 @@ int copyup_dentry(struct inode *dir, str
 		goto out_unlink;
 
 	/* Set permissions. */
-	err = copyup_permissions(sb, old_lower_dentry, new_lower_dentry);
+	err = copyup_permissions(sb, old_lower_dentry, new_lower_dentry,
+				 new_lower_mnt);
 	if (err)
 		goto out_unlink;
 
@@ -663,13 +667,15 @@ static void __set_dentry(struct dentry *
  * in the bindex branch.
  */
 struct dentry *create_parents(struct inode *dir, struct dentry *dentry,
-			      const char *name, int bindex)
+			      const char *name, int bindex,
+			      struct vfsmount **mnt)
 {
 	int err;
 	struct dentry *child_dentry;
 	struct dentry *parent_dentry;
 	struct dentry *lower_parent_dentry = NULL;
 	struct dentry *lower_dentry = NULL;
+	struct vfsmount *lower_mnt = NULL;
 	const char *childname;
 	unsigned int childnamelen;
 	int nr_dentry;
@@ -720,6 +726,7 @@ struct dentry *create_parents(struct ino
 		/* find out the lower_parent_dentry in the given branch */
 		lower_parent_dentry =
 			unionfs_lower_dentry_idx(parent_dentry, bindex);
+		lower_mnt = unionfs_lower_mnt_idx(parent_dentry, bindex);
 
 		/* grow path table */
 		if (count == nr_dentry) {
@@ -802,7 +809,7 @@ begin:
 
 		if (!err)
 			err = copyup_permissions(dir->i_sb, child_dentry,
-						 lower_dentry);
+						 lower_dentry, lower_mnt);
 		unlock_dir(lower_parent_dentry);
 		if (err) {
 			struct inode *inode = lower_dentry->d_inode;
@@ -843,6 +850,7 @@ out:
 		while (count)
 			unionfs_unlock_dentry(path[count--]);
 	kfree(path);
+	*mnt = lower_mnt;
 	return lower_dentry;
 }
 
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -23,6 +23,7 @@ static int unionfs_create(struct inode *
 {
 	int err = 0;
 	struct dentry *lower_dentry = NULL;
+	struct vfsmount *lower_mnt = NULL;
 	struct dentry *wh_dentry = NULL;
 	struct dentry *lower_parent_dentry = NULL;
 	char *name = NULL;
@@ -119,7 +120,8 @@ static int unionfs_create(struct inode *
 		 * dentry directory structure in branch 0.
 		 */
 		lower_dentry = create_parents(parent, dentry,
-					      dentry->d_name.name, 0);
+					      dentry->d_name.name, 0,
+					      &lower_mnt);
 		if (IS_ERR(lower_dentry)) {
 			err = PTR_ERR(lower_dentry);
 			goto out;
@@ -221,6 +223,7 @@ static int unionfs_link(struct dentry *o
 	int err = 0;
 	struct dentry *lower_old_dentry = NULL;
 	struct dentry *lower_new_dentry = NULL;
+	struct vfsmount *lower_new_mnt = NULL;
 	struct dentry *lower_dir_dentry = NULL;
 	struct dentry *whiteout_dentry;
 	char *name = NULL;
@@ -281,7 +284,8 @@ static int unionfs_link(struct dentry *o
 	if (dbstart(old_dentry) != dbstart(new_dentry)) {
 		lower_new_dentry = create_parents(dir, new_dentry,
 						  new_dentry->d_name.name,
-						  dbstart(old_dentry));
+						  dbstart(old_dentry),
+						  &lower_new_mnt);
 		err = PTR_ERR(lower_new_dentry);
 		if (IS_COPYUP_ERR(err))
 			goto docopyup;
@@ -314,7 +318,7 @@ docopyup:
 				lower_new_dentry =
 					create_parents(dir, new_dentry,
 						       new_dentry->d_name.name,
-						       bindex);
+						       bindex, &lower_new_mnt);
 				lower_old_dentry =
 					unionfs_lower_dentry(old_dentry);
 				lower_dir_dentry =
@@ -369,6 +373,7 @@ static int unionfs_symlink(struct inode 
 {
 	int err = 0;
 	struct dentry *lower_dentry = NULL;
+	struct vfsmount *lower_mnt = NULL;
 	struct dentry *whiteout_dentry = NULL;
 	struct dentry *lower_dir_dentry = NULL;
 	umode_t mode;
@@ -458,7 +463,7 @@ static int unionfs_symlink(struct inode 
 			 */
 			lower_dentry = create_parents(dir, dentry,
 						      dentry->d_name.name,
-						      bindex);
+						      bindex, &lower_mnt);
 			if (!lower_dentry || IS_ERR(lower_dentry)) {
 				if (IS_ERR(lower_dentry))
 					err = PTR_ERR(lower_dentry);
@@ -532,6 +537,7 @@ static int unionfs_mkdir(struct inode *p
 {
 	int err = 0;
 	struct dentry *lower_dentry = NULL, *whiteout_dentry = NULL;
+	struct vfsmount *lower_mnt = NULL;
 	struct dentry *lower_parent_dentry = NULL;
 	int bindex = 0, bstart;
 	char *name = NULL;
@@ -607,7 +613,7 @@ static int unionfs_mkdir(struct inode *p
 		if (!lower_dentry) {
 			lower_dentry = create_parents(parent, dentry,
 						      dentry->d_name.name,
-						      bindex);
+						      bindex, &lower_mnt);
 			if (!lower_dentry || IS_ERR(lower_dentry)) {
 				printk(KERN_ERR "unionfs: lower dentry "
 				       " NULL for bindex = %d\n", bindex);
@@ -687,6 +693,7 @@ static int unionfs_mknod(struct inode *d
 {
 	int err = 0;
 	struct dentry *lower_dentry = NULL, *whiteout_dentry = NULL;
+	struct vfsmount *lower_mnt = NULL;
 	struct dentry *lower_parent_dentry = NULL;
 	int bindex = 0, bstart;
 	char *name = NULL;
@@ -755,7 +762,7 @@ static int unionfs_mknod(struct inode *d
 		if (!lower_dentry) {
 			lower_dentry = create_parents(dir, dentry,
 						      dentry->d_name.name,
-						      bindex);
+						      bindex, &lower_mnt);
 			if (IS_ERR(lower_dentry)) {
 				printk(KERN_ERR "unionfs: failed to create "
 				       "parents on %d, err = %ld\n",
@@ -1004,6 +1011,7 @@ static int unionfs_setattr(struct dentry
 {
 	int err = 0;
 	struct dentry *lower_dentry;
+	struct vfsmount *lower_mnt;
 	struct inode *inode = NULL;
 	struct inode *lower_inode = NULL;
 	int bstart, bend, bindex;
@@ -1035,6 +1043,7 @@ static int unionfs_setattr(struct dentry
 		if (!lower_dentry)
 			continue;
 		BUG_ON(lower_dentry->d_inode == NULL);
+		lower_mnt = unionfs_lower_mnt_idx(dentry, bindex);
 
 		/* If the file is on a read only branch */
 		if (is_robranch_super(dentry->d_sb, bindex)
@@ -1067,7 +1076,7 @@ static int unionfs_setattr(struct dentry
 			}
 
 		}
-		err = notify_change(lower_dentry, ia);
+		err = notify_change(lower_dentry, lower_mnt, ia);
 		if (err)
 			goto out;
 		break;
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -25,6 +25,7 @@ static int __unionfs_rename(struct inode
 	int err = 0;
 	struct dentry *lower_old_dentry;
 	struct dentry *lower_new_dentry;
+	struct vfsmount *lower_new_mnt;
 	struct dentry *lower_old_dir_dentry;
 	struct dentry *lower_new_dir_dentry;
 	struct dentry *lower_wh_dentry;
@@ -38,7 +39,7 @@ static int __unionfs_rename(struct inode
 		lower_new_dentry =
 			create_parents(new_dentry->d_parent->d_inode,
 				       new_dentry, new_dentry->d_name.name,
-				       bindex);
+				       bindex, &lower_new_mnt);
 		if (IS_ERR(lower_new_dentry)) {
 			err = PTR_ERR(lower_new_dentry);
 			if (IS_COPYUP_ERR(err))
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -28,6 +28,7 @@ int create_whiteout(struct dentry *dentr
 	int bstart, bend, bindex;
 	struct dentry *lower_dir_dentry;
 	struct dentry *lower_dentry;
+	struct vfsmount *lower_mnt;
 	struct dentry *lower_wh_dentry;
 	struct nameidata nd;
 	char *name = NULL;
@@ -59,7 +60,7 @@ int create_whiteout(struct dentry *dentr
 			lower_dentry = create_parents(dentry->d_inode,
 						      dentry,
 						      dentry->d_name.name,
-						      bindex);
+						      bindex, &lower_mnt);
 			if (!lower_dentry || IS_ERR(lower_dentry)) {
 				int ret = PTR_ERR(lower_dentry);
 				if (!IS_COPYUP_ERR(ret))
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -292,7 +292,8 @@ extern void release_lower_nd(struct name
 
 /* replicates the directory structure up to given dentry in given branch */
 extern struct dentry *create_parents(struct inode *dir, struct dentry *dentry,
-				     const char *name, int bindex);
+				     const char *name, int bindex,
+				     struct vfsmount **mnt);
 extern int make_dir_opaque(struct dentry *dir, int bindex);
 
 /* partial lookup */
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -56,11 +56,10 @@ long do_utimes(int dfd, char __user *fil
 {
 	int error;
 	struct nameidata nd;
-	struct dentry *dentry;
+	struct path path;
 	struct inode *inode;
 	struct iattr newattrs;
 	struct file *f = NULL;
-	struct vfsmount *mnt;
 
 	error = -EINVAL;
 	if (times && (!nsec_valid(times[0].tv_nsec) ||
@@ -80,20 +79,20 @@ long do_utimes(int dfd, char __user *fil
 		f = fget(dfd);
 		if (!f)
 			goto out;
-		dentry = f->f_path.dentry;
-		mnt = f->f_path.mnt;
+
+		path = f->f_path;
 	} else {
 		error = __user_walk_fd(dfd, filename, (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW, &nd);
 		if (error)
 			goto out;
 
-		dentry = nd.path.dentry;
-		mnt = nd.path.mnt;
+		path.dentry = nd.path.dentry;
+		path.mnt = nd.path.mnt;
 	}
 
-	inode = dentry->d_inode;
+	inode = path.dentry->d_inode;
 
-	error = mnt_want_write(mnt);
+	error = mnt_want_write(path.mnt);
 	if (error)
 		goto dput_and_out;
 
@@ -136,10 +135,10 @@ long do_utimes(int dfd, char __user *fil
 		}
 	}
 	mutex_lock(&inode->i_mutex);
-	error = notify_change(dentry, &newattrs);
+	error = notify_change(path.dentry, path.mnt, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 mnt_drop_write_and_out:
-	mnt_drop_write(mnt);
+	mnt_drop_write(path.mnt);
 dput_and_out:
 	if (f)
 		fput(f);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1538,8 +1538,8 @@ static inline int break_lease(struct ino
 
 /* fs/open.c */
 
-extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
-		       struct file *filp);
+extern int do_truncate(struct dentry *, struct vfsmount *, loff_t start,
+		       unsigned int time_attrs, struct file *filp);
 extern long do_sys_open(int dfd, const char __user *filename, int flags,
 			int mode);
 extern struct file * dentry_open(struct dentry *, struct vfsmount *, int);
@@ -1695,7 +1695,7 @@ extern int do_remount_sb(struct super_bl
 #ifdef CONFIG_BLOCK
 extern sector_t bmap(struct inode *, sector_t);
 #endif
-extern int notify_change(struct dentry *, struct iattr *);
+extern int notify_change(struct dentry *, struct vfsmount *, struct iattr *);
 extern int permission(struct inode *, int, struct nameidata *);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1643,7 +1643,7 @@ int __remove_suid(struct path *path, int
 	struct iattr newattrs;
 
 	newattrs.ia_valid = ATTR_FORCE | kill;
-	return notify_change(path->dentry, &newattrs);
+	return notify_change(path->dentry, path->mnt, &newattrs);
 }
 
 int remove_suid(struct path *path)
--- a/mm/tiny-shmem.c
+++ b/mm/tiny-shmem.c
@@ -81,7 +81,7 @@ struct file *shmem_file_setup(char *name
 	inode->i_nlink = 0;	/* It is unlinked */
 
 	/* notify everyone as to the change of file size */
-	error = do_truncate(dentry, size, 0, file);
+	error = do_truncate(dentry, file->f_path.mnt, size, 0, file);
 	if (error < 0)
 		goto close_file;
 

-- 

