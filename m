Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbXJZLor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbXJZLor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 07:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbXJZLoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 07:44:30 -0400
Received: from styx.suse.cz ([82.119.242.94]:52933 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752681AbXJZLo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 07:44:27 -0400
Subject: Re: [AppArmor 32/45] Enable LSM hooks to distinguish operations on
	file descriptors from operations on pathnames
From: Miklos Szeredi <mszeredi@suse.cz>
To: jjohansen@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>
In-Reply-To: <1193398252.4721.7.camel@localhost>
References: <20071026064024.243943043@suse.de>
	 <20071026064051.393728475@suse.de>  <1193398252.4721.7.camel@localhost>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 13:45:32 +0200
Message-Id: <1193399132.4721.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 13:30 +0200, Miklos Szeredi wrote:

> So I think the correct solution (which was suggested by Trond and
> others) is to define an f_op->fsetattr() method, which interested
> filesystems can define.
> 

And here's the patch, which applies on top of the f_op->fgetattr()
patch, recently posted on -fsdevel.

(First time I'm trying to post a patch from this account, hope evolution
doesn't mess it up) 

Miklos
---

Subject: VFS: new fsetattr() file operation

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new file operation: f_op->fsetattr(), that is invoked by
ftruncate, fchmod, fchown and utimensat.  Fall back to i_op->setattr()
if it is not defined.

For the reasons why we need this, see patch adding fgetattr().

ftruncate() already passed the open file to the filesystem via the
ia_file member of struct iattr.  However it is cleaner to have a
separate file operation for this, so remove ia_file, ATTR_FILE and
convert existing users: fuse and AFS.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz> ---

Index: linux/fs/afs/dir.c
===================================================================
--- linux.orig/fs/afs/dir.c	2007-10-23 11:14:07.000000000 +0200
+++ linux/fs/afs/dir.c	2007-10-26 13:39:22.000000000 +0200
@@ -45,6 +45,7 @@ const struct file_operations afs_dir_fil
 	.release	= afs_release,
 	.readdir	= afs_readdir,
 	.lock		= afs_lock,
+	.fsetattr	= afs_fsetattr,
 };
 
 const struct inode_operations afs_dir_inode_operations = {
Index: linux/fs/afs/file.c
===================================================================
--- linux.orig/fs/afs/file.c	2007-10-09 22:31:38.000000000 +0200
+++ linux/fs/afs/file.c	2007-10-26 13:39:22.000000000 +0200
@@ -36,6 +36,7 @@ const struct file_operations afs_file_op
 	.fsync		= afs_fsync,
 	.lock		= afs_lock,
 	.flock		= afs_flock,
+	.fsetattr	= afs_fsetattr,
 };
 
 const struct inode_operations afs_file_inode_operations = {
Index: linux/fs/afs/inode.c
===================================================================
--- linux.orig/fs/afs/inode.c	2007-10-23 11:14:07.000000000 +0200
+++ linux/fs/afs/inode.c	2007-10-26 13:39:22.000000000 +0200
@@ -361,7 +361,8 @@ void afs_clear_inode(struct inode *inode
 /*
  * set the attributes of an inode
  */
-int afs_setattr(struct dentry *dentry, struct iattr *attr)
+static int afs_do_setattr(struct dentry *dentry, struct iattr *attr,
+		   struct file *file)
 {
 	struct afs_vnode *vnode = AFS_FS_I(dentry->d_inode);
 	struct key *key;
@@ -383,8 +384,8 @@ int afs_setattr(struct dentry *dentry, s
 		afs_writeback_all(vnode);
 	}
 
-	if (attr->ia_valid & ATTR_FILE) {
-		key = attr->ia_file->private_data;
+	if (file) {
+		key = file->private_data;
 	} else {
 		key = afs_request_key(vnode->volume->cell);
 		if (IS_ERR(key)) {
@@ -394,10 +395,20 @@ int afs_setattr(struct dentry *dentry, s
 	}
 
 	ret = afs_vnode_setattr(vnode, key, attr);
-	if (!(attr->ia_valid & ATTR_FILE))
+	if (!file)
 		key_put(key);
 
 error:
 	_leave(" = %d", ret);
 	return ret;
 }
+
+int afs_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	return afs_do_setattr(dentry, attr, NULL);
+}
+
+int afs_fsetattr(struct file *file, struct iattr *attr)
+{
+	return afs_do_setattr(file->f_path.dentry, attr, file);
+}
Index: linux/fs/afs/internal.h
===================================================================
--- linux.orig/fs/afs/internal.h	2007-10-23 11:14:07.000000000 +0200
+++ linux/fs/afs/internal.h	2007-10-26 13:39:22.000000000 +0200
@@ -550,6 +550,7 @@ extern void afs_zap_data(struct afs_vnod
 extern int afs_validate(struct afs_vnode *, struct key *);
 extern int afs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int afs_setattr(struct dentry *, struct iattr *);
+extern int afs_fsetattr(struct file *, struct iattr *);
 extern void afs_clear_inode(struct inode *);
 
 /*
Index: linux/fs/attr.c
===================================================================
--- linux.orig/fs/attr.c	2007-10-23 11:14:07.000000000 +0200
+++ linux/fs/attr.c	2007-10-26 13:39:22.000000000 +0200
@@ -100,7 +100,7 @@ int inode_setattr(struct inode * inode, 
 }
 EXPORT_SYMBOL(inode_setattr);
 
-int notify_change(struct dentry * dentry, struct iattr * attr)
+int fnotify_change(struct dentry *dentry, struct iattr *attr, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	mode_t mode = inode->i_mode;
@@ -159,8 +159,12 @@ int notify_change(struct dentry * dentry
 
 	if (inode->i_op && inode->i_op->setattr) {
 		error = security_inode_setattr(dentry, attr);
-		if (!error)
-			error = inode->i_op->setattr(dentry, attr);
+		if (!error) {
+			if (file && file->f_op && file->f_op->fsetattr)
+				error = file->f_op->fsetattr(file, attr);
+			else
+				error = inode->i_op->setattr(dentry, attr);
+		}
 	} else {
 		error = inode_change_ok(inode, attr);
 		if (!error)
@@ -183,4 +187,9 @@ int notify_change(struct dentry * dentry
 	return error;
 }
 
+int notify_change(struct dentry *dentry, struct iattr *attr)
+{
+	return fnotify_change(dentry, attr, NULL);
+}
+
 EXPORT_SYMBOL(notify_change);
Index: linux/fs/open.c
===================================================================
--- linux.orig/fs/open.c	2007-10-23 11:14:22.000000000 +0200
+++ linux/fs/open.c	2007-10-26 13:39:22.000000000 +0200
@@ -206,16 +206,12 @@ int do_truncate(struct dentry *dentry, l
 
 	newattrs.ia_size = length;
 	newattrs.ia_valid = ATTR_SIZE | time_attrs;
-	if (filp) {
-		newattrs.ia_file = filp;
-		newattrs.ia_valid |= ATTR_FILE;
-	}
 
 	/* Remove suid/sgid on truncate too */
 	newattrs.ia_valid |= should_remove_suid(dentry);
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	err = notify_change(dentry, &newattrs);
+	err = fnotify_change(dentry, &newattrs, filp);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 	return err;
 }
@@ -593,7 +589,7 @@ asmlinkage long sys_fchmod(unsigned int 
 		mode = inode->i_mode;
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	err = notify_change(dentry, &newattrs);
+	err = fnotify_change(dentry, &newattrs, file);
 	mutex_unlock(&inode->i_mutex);
 
 out_drop_write:
@@ -646,7 +642,8 @@ asmlinkage long sys_chmod(const char __u
 	return sys_fchmodat(AT_FDCWD, filename, mode);
 }
 
-static int chown_common(struct dentry * dentry, uid_t user, gid_t group)
+static int chown_common(struct dentry * dentry, uid_t user, gid_t group,
+			struct file *file)
 {
 	struct inode * inode;
 	int error;
@@ -673,7 +670,7 @@ static int chown_common(struct dentry * 
 		newattrs.ia_valid |=
 			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 	mutex_lock(&inode->i_mutex);
-	error = notify_change(dentry, &newattrs);
+	error = fnotify_change(dentry, &newattrs, file);
 	mutex_unlock(&inode->i_mutex);
 out:
 	return error;
@@ -690,7 +687,7 @@ asmlinkage long sys_chown(const char __u
 	error = mnt_want_write(nd.mnt);
 	if (error)
 		goto out_release;
-	error = chown_common(nd.dentry, user, group);
+	error = chown_common(nd.dentry, user, group, NULL);
 	mnt_drop_write(nd.mnt);
 out_release:
 	path_release(&nd);
@@ -715,7 +712,7 @@ asmlinkage long sys_fchownat(int dfd, co
 	error = mnt_want_write(nd.mnt);
 	if (error)
 		goto out_release;
-	error = chown_common(nd.dentry, user, group);
+	error = chown_common(nd.dentry, user, group, NULL);
 	mnt_drop_write(nd.mnt);
 out_release:
 	path_release(&nd);
@@ -734,7 +731,7 @@ asmlinkage long sys_lchown(const char __
 	error = mnt_want_write(nd.mnt);
 	if (error)
 		goto out_release;
-	error = chown_common(nd.dentry, user, group);
+	error = chown_common(nd.dentry, user, group, NULL);
 	mnt_drop_write(nd.mnt);
 out_release:
 	path_release(&nd);
@@ -758,7 +755,7 @@ asmlinkage long sys_fchown(unsigned int 
 		goto out_fput;
 	dentry = file->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = chown_common(dentry, user, group);
+	error = chown_common(dentry, user, group, file);
 	mnt_drop_write(file->f_vfsmnt);
 out_fput:
 	fput(file);
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-10-26 13:37:30.000000000 +0200
+++ linux/include/linux/fs.h	2007-10-26 13:39:22.000000000 +0200
@@ -335,7 +335,6 @@ typedef void (dio_iodone_t)(struct kiocb
 #define ATTR_ATTR_FLAG	1024
 #define ATTR_KILL_SUID	2048
 #define ATTR_KILL_SGID	4096
-#define ATTR_FILE	8192
 #define ATTR_KILL_PRIV	16384
 #define ATTR_OPEN	32768	/* Truncating from open(O_TRUNC) */
 
@@ -357,13 +356,6 @@ struct iattr {
 	struct timespec	ia_atime;
 	struct timespec	ia_mtime;
 	struct timespec	ia_ctime;
-
-	/*
-	 * Not an attribute, but an auxilary info for filesystems wanting to
-	 * implement an ftruncate() like method.  NOTE: filesystem should
-	 * check for (ia_valid & ATTR_FILE), and not for (ia_file != NULL).
-	 */
-	struct file	*ia_file;
 };
 
 /*
@@ -1196,6 +1188,7 @@ struct file_operations {
 	int (*setlease)(struct file *, long, struct file_lock **);
 	int (*revoke)(struct file *, struct address_space *);
 	int (*fgetattr)(struct file *, struct kstat *);
+	int (*fsetattr)(struct file *, struct iattr *);
 };
 
 struct inode_operations {
@@ -1703,6 +1696,7 @@ extern int do_remount_sb(struct super_bl
 extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
+extern int fnotify_change(struct dentry *, struct iattr *, struct file *);
 extern int permission(struct inode *, int, struct nameidata *);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
Index: linux/fs/utimes.c
===================================================================
--- linux.orig/fs/utimes.c	2007-10-23 11:14:23.000000000 +0200
+++ linux/fs/utimes.c	2007-10-26 13:39:22.000000000 +0200
@@ -135,7 +135,7 @@ long do_utimes(int dfd, char __user *fil
 		}
 	}
 	mutex_lock(&inode->i_mutex);
-	error = notify_change(dentry, &newattrs);
+	error = fnotify_change(dentry, &newattrs, f);
 	mutex_unlock(&inode->i_mutex);
 mnt_drop_write_and_out:
 	mnt_drop_write(mnt);
Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-10-25 21:48:16.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-10-26 13:39:22.000000000 +0200
@@ -1060,21 +1060,22 @@ static int fuse_dir_fsync(struct file *f
 	return file ? fuse_fsync_common(file, de, datasync, 1) : 0;
 }
 
-static bool update_mtime(unsigned ivalid)
+static bool update_mtime(unsigned ivalid, bool have_file)
 {
 	/* Always update if mtime is explicitly set  */
 	if (ivalid & ATTR_MTIME_SET)
 		return true;
 
 	/* If it's an open(O_TRUNC) or an ftruncate(), don't update */
-	if ((ivalid & ATTR_SIZE) && (ivalid & (ATTR_OPEN | ATTR_FILE)))
+	if ((ivalid & ATTR_SIZE) && ((ivalid & ATTR_OPEN) || have_file))
 		return false;
 
 	/* In all other cases update */
 	return true;
 }
 
-static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg)
+static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg,
+			   bool have_file)
 {
 	unsigned ivalid = iattr->ia_valid;
 
@@ -1093,7 +1094,7 @@ static void iattr_to_fattr(struct iattr 
 		if (!(ivalid & ATTR_ATIME_SET))
 			arg->valid |= FATTR_ATIME_NOW;
 	}
-	if ((ivalid & ATTR_MTIME) && update_mtime(ivalid)) {
+	if ((ivalid & ATTR_MTIME) && update_mtime(ivalid, have_file)) {
 		arg->valid |= FATTR_MTIME;
 		arg->mtime = iattr->ia_mtime.tv_sec;
 		arg->mtimensec = iattr->ia_mtime.tv_nsec;
@@ -1110,8 +1111,8 @@ static void iattr_to_fattr(struct iattr 
  * vmtruncate() doesn't allow for this case, so do the rlimit checking
  * and the actual truncation by hand.
  */
-static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
-			   struct file *file)
+int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
+		    struct file *file)
 {
 	struct inode *inode = entry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -1149,7 +1150,7 @@ static int fuse_do_setattr(struct dentry
 
 	memset(&inarg, 0, sizeof(inarg));
 	memset(&outarg, 0, sizeof(outarg));
-	iattr_to_fattr(attr, &inarg);
+	iattr_to_fattr(attr, &inarg, file != NULL);
 	if (file) {
 		struct fuse_file *ff = file->private_data;
 		inarg.valid |= FATTR_FH;
@@ -1191,10 +1192,7 @@ static int fuse_do_setattr(struct dentry
 
 static int fuse_setattr(struct dentry *entry, struct iattr *attr)
 {
-	if (attr->ia_valid & ATTR_FILE)
-		return fuse_do_setattr(entry, attr, attr->ia_file);
-	else
-		return fuse_do_setattr(entry, attr, NULL);
+	return fuse_do_setattr(entry, attr, NULL);
 }
 
 static int fuse_getattr(struct vfsmount *mnt, struct dentry *entry,
Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-10-26 13:37:30.000000000 +0200
+++ linux/fs/fuse/file.c	2007-10-26 13:39:22.000000000 +0200
@@ -918,6 +918,11 @@ static sector_t fuse_bmap(struct address
 	return err ? 0 : outarg.block;
 }
 
+static int fuse_fsetattr(struct file *file, struct iattr *attr)
+{
+	return fuse_do_setattr(file->f_path.dentry, attr, file);
+}
+
 static const struct file_operations fuse_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
@@ -932,6 +937,7 @@ static const struct file_operations fuse
 	.lock		= fuse_file_lock,
 	.flock		= fuse_file_flock,
 	.fgetattr	= fuse_file_fgetattr,
+	.fsetattr	= fuse_fsetattr,
 	.splice_read	= generic_file_splice_read,
 };
 
@@ -946,6 +952,7 @@ static const struct file_operations fuse
 	.lock		= fuse_file_lock,
 	.flock		= fuse_file_flock,
 	.fgetattr	= fuse_file_fgetattr,
+	.fsetattr	= fuse_fsetattr,
 	/* no mmap and splice_read */
 };
 
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-10-26 13:36:47.000000000 +0200
+++ linux/fs/fuse/fuse_i.h	2007-10-26 13:39:22.000000000 +0200
@@ -505,6 +505,10 @@ void fuse_change_attributes(struct inode
  */
 int fuse_dev_init(void);
 
+
+int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
+		    struct file *file);
+
 /**
  * Cleanup the client device
  */


