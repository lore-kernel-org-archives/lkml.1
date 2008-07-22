Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYGVK7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYGVK7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYGVK7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:59:14 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:54793 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbYGVK7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:59:11 -0400
To: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [RFC] Add a counter in task_struct for skipping permission check. (Was: Should LSM hooks be called by filesystem's requests?)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200807142020.BCC17654.SMtQFVFOFOHOJL@I-love.SAKURA.ne.jp>
	<487C22A2.9090402@schaufler-ca.com>
In-Reply-To: <487C22A2.9090402@schaufler-ca.com>
Message-Id: <200807221959.HDJ90154.FFLMOtVOOQJFSH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 22 Jul 2008 19:59:04 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I have a problem with unionfs and LSM.
The unionfs causes NULL pointer dereference if copyup_dentry()
failed by LSM's decision, so I'm searching for a solution.

http://marc.info/?l=linux-security-module&m=121609490418118&w=2

It seems that the unionfs is not handling error paths correctly.
But since the unionfs's operation is not always atomic,
there is no guarantee that unionfs can rollback unionfs's internal
operations properly.

For example, unionfs is trying to create a rw copy of a ro file.

 Request by unionfs                       Decision by LSM
 "I want to create a rw file."            "OK. You can create the file."
 "I want to copy the ro file's attribute" "No. You must not."
 "I have to delete the rw file."          "No. You must not."

Then, it might be better to completely disable LSM for unionfs's
internal operations.
At least, I think we need to disable LSM for rollback operation so that
the rw file in the above example is properly deleted.

I think this patch can disable LSM checks if vfs_*() and
notify_change() is called by unionfs's internal operations.
This patch is just an idea, not tested at all.

Does somebody have a solution?

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/unionfs/commonfops.c |    2 ++
 fs/unionfs/copyup.c     |   14 ++++++++++++++
 fs/unionfs/dirfops.c    |    6 ++++++
 fs/unionfs/dirhelper.c  |    4 ++++
 fs/unionfs/file.c       |    8 ++++++++
 fs/unionfs/inode.c      |   18 ++++++++++++++++++
 fs/unionfs/rename.c     |    8 ++++++++
 fs/unionfs/sioq.c       |   10 ++++++++++
 fs/unionfs/subr.c       |    4 ++++
 fs/unionfs/super.c      |    2 ++
 fs/unionfs/unlink.c     |    4 ++++
 fs/unionfs/xattr.c      |    8 ++++++++
 include/linux/fs.h      |    3 ++-
 include/linux/sched.h   |    1 +
 14 files changed, 91 insertions(+), 1 deletion(-)

--- linux-2.6.26-rc8-mm1.orig/fs/unionfs/commonfops.c
+++ linux-2.6.26-rc8-mm1/fs/unionfs/commonfops.c
@@ -88,7 +88,9 @@ retry:
 					    lower_dentry->d_inode);
 	}
 	lower_dir_dentry = lock_parent(lower_dentry);
+	current->no_perm_check++;
 	err = vfs_unlink(lower_dir_dentry->d_inode, lower_dentry);
+	current->no_perm_check--;
 	unlock_dir(lower_dir_dentry);
 
 out:
--- linux-2.6.26-rc8-mm1.orig/fs/unionfs/copyup.c
+++ linux-2.6.26-rc8-mm1/fs/unionfs/copyup.c
@@ -35,7 +35,9 @@ static int copyup_xattrs(struct dentry *
 	char *name_list_buf = NULL;
 
 	/* query the actual size of the xattr list */
+	current->no_perm_check++;
 	list_size = vfs_listxattr(old_lower_dentry, NULL, 0);
+	current->no_perm_check--;
 	if (list_size <= 0) {
 		err = list_size;
 		goto out;
@@ -51,7 +53,9 @@ static int copyup_xattrs(struct dentry *
 	name_list_buf = name_list; /* save for kfree at end */
 
 	/* now get the actual xattr list of the source file */
+	current->no_perm_check++;
 	list_size = vfs_listxattr(old_lower_dentry, name_list, list_size);
+	current->no_perm_check--;
 	if (list_size <= 0) {
 		err = list_size;
 		goto out;
@@ -70,8 +74,10 @@ static int copyup_xattrs(struct dentry *
 
 		/* Lock here since vfs_getxattr doesn't lock for us */
 		mutex_lock(&old_lower_dentry->d_inode->i_mutex);
+		current->no_perm_check++;
 		size = vfs_getxattr(old_lower_dentry, name_list,
 				    attr_value, XATTR_SIZE_MAX);
+		current->no_perm_check--;
 		mutex_unlock(&old_lower_dentry->d_inode->i_mutex);
 		if (size < 0) {
 			err = size;
@@ -82,8 +88,10 @@ static int copyup_xattrs(struct dentry *
 			goto out;
 		}
 		/* Don't lock here since vfs_setxattr does it for us. */
+		current->no_perm_check++;
 		err = vfs_setxattr(new_lower_dentry, name_list, attr_value,
 				   size, 0);
+		current->no_perm_check--;
 		/*
 		 * Selinux depends on "security.*" xattrs, so to maintain
 		 * the security of copied-up files, if Selinux is active,
@@ -93,8 +101,10 @@ static int copyup_xattrs(struct dentry *
 		 */
 		if (err == -EPERM && !capable(CAP_FOWNER)) {
 			cap_raise(current->cap_effective, CAP_FOWNER);
+			current->no_perm_check++;
 			err = vfs_setxattr(new_lower_dentry, name_list,
 					   attr_value, size, 0);
+			current->no_perm_check--;
 			cap_lower(current->cap_effective, CAP_FOWNER);
 		}
 		if (err < 0)
@@ -136,6 +146,7 @@ static int copyup_permissions(struct sup
 		ATTR_ATIME_SET | ATTR_MTIME_SET | ATTR_FORCE |
 		ATTR_GID | ATTR_UID;
 	mutex_lock(&new_lower_dentry->d_inode->i_mutex);
+	current->no_perm_check++;
 	err = notify_change(new_lower_dentry, &newattrs);
 	if (err)
 		goto out;
@@ -153,6 +164,7 @@ static int copyup_permissions(struct sup
 	}
 
 out:
+	current->no_perm_check--;
 	mutex_unlock(&new_lower_dentry->d_inode->i_mutex);
 	return err;
 }
@@ -488,7 +500,9 @@ out_unlink:
 	 * quota, or something else happened so let's unlink; we don't
 	 * really care about the return value of vfs_unlink
 	 */
+	current->no_perm_check++;
 	vfs_unlink(new_lower_parent_dentry->d_inode, new_lower_dentry);
+	current->no_perm_check--;
 
 	if (copyup_file) {
 		/* need to close the file */
--- linux-2.6.26-rc8-mm1.orig/fs/unionfs/dirfops.c
+++ linux-2.6.26-rc8-mm1/fs/unionfs/dirfops.c
@@ -149,15 +149,21 @@ static int unionfs_readdir(struct file *
 		buf.sb = inode->i_sb;
 
 		/* Read starting from where we last left off. */
+		current->no_perm_check++;
 		offset = vfs_llseek(lower_file, uds->dirpos, SEEK_SET);
+		current->no_perm_check--;
 		if (offset < 0) {
 			err = offset;
 			goto out;
 		}
+		current->no_perm_check++;
 		err = vfs_readdir(lower_file, unionfs_filldir, &buf);
+		current->no_perm_check--;
 
 		/* Save the position for when we continue. */
+		current->no_perm_check++;
 		offset = vfs_llseek(lower_file, 0, SEEK_CUR);
+		current->no_perm_check--;
 		if (offset < 0) {
 			err = offset;
 			goto out;
--- linux-2.6.26-rc8-mm1.orig/fs/unionfs/dirhelper.c
+++ linux-2.6.26-rc8-mm1/fs/unionfs/dirhelper.c
@@ -69,8 +69,10 @@ int do_delete_whiteouts(struct dentry *d
 				err = PTR_ERR(lower_dentry);
 				break;
 			}
+			current->no_perm_check++;
 			if (lower_dentry->d_inode)
 				err = vfs_unlink(lower_dir, lower_dentry);
+			current->no_perm_check--;
 			dput(lower_dentry);
 			if (err)
 				break;
@@ -239,8 +241,10 @@ int check_empty(struct dentry *dentry, s
 		do {
 			buf->filldir_called = 0;
 			buf->rdstate->bindex = bindex;
+			current->no_perm_check++;
 			err = vfs_readdir(lower_file,
 					  readdir_util_callback, buf);
+			current->no_perm_check--;
 			if (buf->err)
 				err = buf->err;
 		} while ((err >= 0) && buf->filldir_called);
--- linux-2.6.26-rc8-mm1.orig/fs/unionfs/file.c
+++ linux-2.6.26-rc8-mm1/fs/unionfs/file.c
@@ -32,7 +32,9 @@ static ssize_t unionfs_read(struct file 
 		goto out;
 
 	lower_file = unionfs_lower_file(file);
+	current->no_perm_check++;
 	err = vfs_read(lower_file, buf, count, ppos);
+	current->no_perm_check--;
 	/* update our inode atime upon a successful lower read */
 	if (err >= 0) {
 		fsstack_copy_attr_atime(dentry->d_inode,
@@ -62,7 +64,9 @@ static ssize_t unionfs_write(struct file
 		goto out;
 
 	lower_file = unionfs_lower_file(file);
+	current->no_perm_check++;
 	err = vfs_write(lower_file, buf, count, ppos);
+	current->no_perm_check--;
 	/* update our inode times+sizes upon a successful lower write */
 	if (err >= 0) {
 		fsstack_copy_inode_size(dentry->d_inode,
@@ -279,7 +283,9 @@ static ssize_t unionfs_splice_read(struc
 		goto out;
 
 	lower_file = unionfs_lower_file(file);
+	current->no_perm_check++;
 	err = vfs_splice_to(lower_file, ppos, pipe, len, flags);
+	current->no_perm_check--;
 	/* update our inode atime upon a successful lower splice-read */
 	if (err >= 0) {
 		fsstack_copy_attr_atime(dentry->d_inode,
@@ -308,7 +314,9 @@ static ssize_t unionfs_splice_write(stru
 		goto out;
 
 	lower_file = unionfs_lower_file(file);
+	current->no_perm_check++;
 	err = vfs_splice_from(pipe, lower_file, ppos, len, flags);
+	current->no_perm_check--;
 	/* update our inode times+sizes upon a successful lower write */
 	if (err >= 0) {
 		fsstack_copy_inode_size(dentry->d_inode,
--- linux-2.6.26-rc8-mm1.orig/fs/unionfs/inode.c
+++ linux-2.6.26-rc8-mm1/fs/unionfs/inode.c
@@ -62,7 +62,9 @@ static int check_for_whiteout(struct den
 	lower_dir_dentry = lock_parent_wh(wh_dentry);
 	/* see Documentation/filesystems/unionfs/issues.txt */
 	lockdep_off();
+	current->no_perm_check++;
 	err = vfs_unlink(lower_dir_dentry->d_inode, wh_dentry);
+	current->no_perm_check--;
 	lockdep_on();
 	unlock_dir(lower_dir_dentry);
 
@@ -208,8 +210,10 @@ static int unionfs_create(struct inode *
 	err = init_lower_nd(&lower_nd, LOOKUP_CREATE);
 	if (unlikely(err < 0))
 		goto out;
+	current->no_perm_check++;
 	err = vfs_create(lower_parent_dentry->d_inode, lower_dentry, mode,
 			 &lower_nd);
+	current->no_perm_check--;
 	release_lower_nd(&lower_nd, err);
 
 	if (!err) {
@@ -348,8 +352,10 @@ static int unionfs_link(struct dentry *o
 		if (!err) {
 			/* see Documentation/filesystems/unionfs/issues.txt */
 			lockdep_off();
+			current->no_perm_check++;
 			err = vfs_unlink(lower_dir_dentry->d_inode,
 					 whiteout_dentry);
+			current->no_perm_check--;
 			lockdep_on();
 		}
 
@@ -381,8 +387,10 @@ static int unionfs_link(struct dentry *o
 	if (!err) {
 		/* see Documentation/filesystems/unionfs/issues.txt */
 		lockdep_off();
+		current->no_perm_check++;
 		err = vfs_link(lower_old_dentry, lower_dir_dentry->d_inode,
 			       lower_new_dentry);
+		current->no_perm_check--;
 		lockdep_on();
 	}
 	unlock_dir(lower_dir_dentry);
@@ -409,9 +417,11 @@ docopyup:
 			/* see Documentation/filesystems/unionfs/issues.txt */
 			lockdep_off();
 			/* do vfs_link */
+			current->no_perm_check++;
 			err = vfs_link(lower_old_dentry,
 				       lower_dir_dentry->d_inode,
 				       lower_new_dentry);
+			current->no_perm_check--;
 			lockdep_on();
 			unlock_dir(lower_dir_dentry);
 			goto check_link;
@@ -498,8 +508,10 @@ static int unionfs_symlink(struct inode 
 	}
 
 	mode = S_IALLUGO;
+	current->no_perm_check++;
 	err = vfs_symlink(lower_parent_dentry->d_inode, lower_dentry,
 			  symname, mode);
+	current->no_perm_check--;
 	if (!err) {
 		err = PTR_ERR(unionfs_interpose(dentry, parent->i_sb, 0));
 		if (!err) {
@@ -629,8 +641,10 @@ static int unionfs_mkdir(struct inode *p
 			goto out;
 		}
 
+		current->no_perm_check++;
 		err = vfs_mkdir(lower_parent_dentry->d_inode, lower_dentry,
 				mode);
+		current->no_perm_check--;
 
 		unlock_dir(lower_parent_dentry);
 
@@ -733,7 +747,9 @@ static int unionfs_mknod(struct inode *p
 		goto out;
 	}
 
+	current->no_perm_check++;
 	err = vfs_mknod(lower_parent_dentry->d_inode, lower_dentry, mode, dev);
+	current->no_perm_check--;
 	if (!err) {
 		err = PTR_ERR(unionfs_interpose(dentry, parent->i_sb, 0));
 		if (!err) {
@@ -1043,7 +1059,9 @@ static int unionfs_setattr(struct dentry
 
 	/* notify the (possibly copied-up) lower inode */
 	mutex_lock(&lower_dentry->d_inode->i_mutex);
+	current->no_perm_check++;
 	err = notify_change(lower_dentry, ia);
+	current->no_perm_check--;
 	mutex_unlock(&lower_dentry->d_inode->i_mutex);
 	if (err)
 		goto out;
--- linux-2.6.26-rc8-mm1.orig/fs/unionfs/rename.c
+++ linux-2.6.26-rc8-mm1/fs/unionfs/rename.c
@@ -79,9 +79,11 @@ static int __unionfs_rename(struct inode
 
 		lower_wh_dir_dentry = lock_parent_wh(lower_wh_dentry);
 		err = is_robranch_super(old_dentry->d_sb, bindex);
+		current->no_perm_check++;
 		if (!err)
 			err = vfs_unlink(lower_wh_dir_dentry->d_inode,
 					 lower_wh_dentry);
+		current->no_perm_check--;
 
 		dput(lower_wh_dentry);
 		unlock_dir(lower_wh_dir_dentry);
@@ -135,8 +137,10 @@ static int __unionfs_rename(struct inode
 		err = -ENOTEMPTY;
 		goto out_err_unlock;
 	}
+	current->no_perm_check++;
 	err = vfs_rename(lower_old_dir_dentry->d_inode, lower_old_dentry,
 			 lower_new_dir_dentry->d_inode, lower_new_dentry);
+	current->no_perm_check--;
 out_err_unlock:
 	if (!err) {
 		/* update parent dir times */
@@ -220,9 +224,11 @@ static int do_unionfs_rename(struct inod
 
 		unlink_dir_dentry = lock_parent(unlink_dentry);
 		err = is_robranch_super(old_dir->i_sb, bindex);
+		current->no_perm_check++;
 		if (!err)
 			err = vfs_unlink(unlink_dir_dentry->d_inode,
 					 unlink_dentry);
+		current->no_perm_check--;
 
 		fsstack_copy_attr_times(new_dentry->d_parent->d_inode,
 					unlink_dir_dentry->d_inode);
@@ -294,8 +300,10 @@ static int do_unionfs_rename(struct inod
 		if (unlikely(err < 0))
 			goto out;
 		lower_parent = lock_parent_wh(wh_old);
+		current->no_perm_check++;
 		local_err = vfs_create(lower_parent->d_inode, wh_old, S_IRUGO,
 				       &nd);
+		current->no_perm_check--;
 		unlock_dir(lower_parent);
 		if (!local_err) {
 			set_dbopaque(old_dentry, bwh_old);
--- linux-2.6.26-rc8-mm1.orig/fs/unionfs/sioq.c
+++ linux-2.6.26-rc8-mm1/fs/unionfs/sioq.c
@@ -60,7 +60,9 @@ void __unionfs_create(struct work_struct
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct create_args *c = &args->create;
 
+	current->no_perm_check++;
 	args->err = vfs_create(c->parent, c->dentry, c->mode, c->nd);
+	current->no_perm_check--;
 	complete(&args->comp);
 }
 
@@ -69,7 +71,9 @@ void __unionfs_mkdir(struct work_struct 
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct mkdir_args *m = &args->mkdir;
 
+	current->no_perm_check++;
 	args->err = vfs_mkdir(m->parent, m->dentry, m->mode);
+	current->no_perm_check--;
 	complete(&args->comp);
 }
 
@@ -78,7 +82,9 @@ void __unionfs_mknod(struct work_struct 
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct mknod_args *m = &args->mknod;
 
+	current->no_perm_check++;
 	args->err = vfs_mknod(m->parent, m->dentry, m->mode, m->dev);
+	current->no_perm_check--;
 	complete(&args->comp);
 }
 
@@ -87,7 +93,9 @@ void __unionfs_symlink(struct work_struc
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct symlink_args *s = &args->symlink;
 
+	current->no_perm_check++;
 	args->err = vfs_symlink(s->parent, s->dentry, s->symbuf, s->mode);
+	current->no_perm_check--;
 	complete(&args->comp);
 }
 
@@ -96,7 +104,9 @@ void __unionfs_unlink(struct work_struct
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct unlink_args *u = &args->unlink;
 
+	current->no_perm_check++;
 	args->err = vfs_unlink(u->parent, u->dentry);
+	current->no_perm_check--;
 	complete(&args->comp);
 }
 
--- linux-2.6.26-rc8-mm1.orig/fs/unionfs/subr.c
+++ linux-2.6.26-rc8-mm1/fs/unionfs/subr.c
@@ -92,11 +92,13 @@ int create_whiteout(struct dentry *dentr
 			goto out;
 		lower_dir_dentry = lock_parent_wh(lower_wh_dentry);
 		err = is_robranch_super(dentry->d_sb, bindex);
+		current->no_perm_check++;
 		if (!err)
 			err = vfs_create(lower_dir_dentry->d_inode,
 					 lower_wh_dentry,
 					 ~current->fs->umask & S_IRWXUGO,
 					 &nd);
+		current->no_perm_check--;
 		unlock_dir(lower_dir_dentry);
 		dput(lower_wh_dentry);
 		release_lower_nd(&nd, err);
@@ -192,8 +194,10 @@ int make_dir_opaque(struct dentry *dentr
 	err = init_lower_nd(&nd, LOOKUP_CREATE);
 	if (unlikely(err < 0))
 		goto out;
+	current->no_perm_check++;
 	if (!diropq->d_inode)
 		err = vfs_create(lower_dir, diropq, S_IRUGO, &nd);
+	current->no_perm_check--;
 	if (!err)
 		set_dbopaque(dentry, bindex);
 	release_lower_nd(&nd, err);
--- linux-2.6.26-rc8-mm1.orig/fs/unionfs/super.c
+++ linux-2.6.26-rc8-mm1/fs/unionfs/super.c
@@ -163,7 +163,9 @@ static int unionfs_statfs(struct dentry 
 	unionfs_check_dentry(dentry);
 
 	lower_dentry = unionfs_lower_dentry(sb->s_root);
+	current->no_perm_check++;
 	err = vfs_statfs(lower_dentry, buf);
+	current->no_perm_check--;
 
 	/* set return buf to our f/s to avoid confusing user-level utils */
 	buf->f_type = UNIONFS_SUPER_MAGIC;
--- linux-2.6.26-rc8-mm1.orig/fs/unionfs/unlink.c
+++ linux-2.6.26-rc8-mm1/fs/unionfs/unlink.c
@@ -69,12 +69,14 @@ static int unionfs_unlink_whiteout(struc
 		if (!err) {
 			/* see Documentation/filesystems/unionfs/issues.txt */
 			lockdep_off();
+			current->no_perm_check++;
 			if (!S_ISDIR(lower_dentry->d_inode->i_mode))
 				err = vfs_unlink(lower_dir_dentry->d_inode,
 								lower_dentry);
 			else
 				err = vfs_rmdir(lower_dir_dentry->d_inode,
 								lower_dentry);
+			current->no_perm_check--;
 			lockdep_on();
 		}
 
@@ -193,7 +195,9 @@ static int unionfs_rmdir_first(struct in
 	if (!err) {
 		/* see Documentation/filesystems/unionfs/issues.txt */
 		lockdep_off();
+		current->no_perm_check++;
 		err = vfs_rmdir(lower_dir_dentry->d_inode, lower_dentry);
+		current->no_perm_check--;
 		lockdep_on();
 	}
 	dput(lower_dentry);
--- linux-2.6.26-rc8-mm1.orig/fs/unionfs/xattr.c
+++ linux-2.6.26-rc8-mm1/fs/unionfs/xattr.c
@@ -55,7 +55,9 @@ ssize_t unionfs_getxattr(struct dentry *
 
 	lower_dentry = unionfs_lower_dentry(dentry);
 
+	current->no_perm_check++;
 	err = vfs_getxattr(lower_dentry, (char *) name, value, size);
+	current->no_perm_check--;
 
 out:
 	unionfs_check_dentry(dentry);
@@ -84,8 +86,10 @@ int unionfs_setxattr(struct dentry *dent
 
 	lower_dentry = unionfs_lower_dentry(dentry);
 
+	current->no_perm_check++;
 	err = vfs_setxattr(lower_dentry, (char *) name, (void *) value,
 			   size, flags);
+	current->no_perm_check--;
 
 out:
 	unionfs_check_dentry(dentry);
@@ -113,7 +117,9 @@ int unionfs_removexattr(struct dentry *d
 
 	lower_dentry = unionfs_lower_dentry(dentry);
 
+	current->no_perm_check++;
 	err = vfs_removexattr(lower_dentry, (char *) name);
+	current->no_perm_check--;
 
 out:
 	unionfs_check_dentry(dentry);
@@ -143,7 +149,9 @@ ssize_t unionfs_listxattr(struct dentry 
 	lower_dentry = unionfs_lower_dentry(dentry);
 
 	encoded_list = list;
+	current->no_perm_check++;
 	err = vfs_listxattr(lower_dentry, encoded_list, size);
+	current->no_perm_check--;
 
 out:
 	unionfs_check_dentry(dentry);
--- linux-2.6.26-rc8-mm1.orig/include/linux/fs.h
+++ linux-2.6.26-rc8-mm1/include/linux/fs.h
@@ -190,7 +190,8 @@ extern int dir_notify_enable;
 #define IS_DEADDIR(inode)	((inode)->i_flags & S_DEAD)
 #define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
 #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
-#define IS_PRIVATE(inode)	((inode)->i_flags & S_PRIVATE)
+#define IS_PRIVATE(inode)	(((inode)->i_flags & S_PRIVATE) || \
+				current->no_perm_check)
 
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */
--- linux-2.6.26-rc8-mm1.orig/include/linux/sched.h
+++ linux-2.6.26-rc8-mm1/include/linux/sched.h
@@ -1296,6 +1296,7 @@ struct task_struct {
 	int latency_record_count;
 	struct latency_record latency_record[LT_SAVECOUNT];
 #endif
+	u8 no_perm_check; /* Skip permission check. */
 };
 
 /*
