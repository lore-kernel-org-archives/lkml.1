Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbXFQTLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbXFQTLr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761095AbXFQTJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:09:59 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36850 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760837AbXFQTJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:09:47 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 15/16] Unionfs: Change the semantics of sb info's rwsem
Date: Sun, 17 Jun 2007 15:09:22 -0400
Message-Id: <11821073652131-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
References: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This rw semaphore is used to make sure that a branch management operation...

1) will not begin before all currently in-flight operations complete

2) any new operations do not execute until the currently running branch
management operation completes

TODO: rename the functions unionfs_{read,write}_{,un}lock() to something
more descriptive.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |   33 ++++++++---------------
 fs/unionfs/copyup.c     |   10 -------
 fs/unionfs/dentry.c     |    7 +++++
 fs/unionfs/dirfops.c    |   10 ++++---
 fs/unionfs/dirhelper.c  |   10 -------
 fs/unionfs/file.c       |   16 +++++-----
 fs/unionfs/inode.c      |   66 ++++++++++++++++++++++++++++++----------------
 fs/unionfs/main.c       |   23 ++++++++--------
 fs/unionfs/rename.c     |    2 +
 fs/unionfs/super.c      |   34 +++++++++++++++++++-----
 fs/unionfs/union.h      |   15 +++++++---
 fs/unionfs/unlink.c     |    4 +++
 fs/unionfs/xattr.c      |    8 +++++
 13 files changed, 138 insertions(+), 100 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 731e3a9..a6917fe 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -119,10 +119,8 @@ static void cleanup_file(struct file *file)
 				printk(KERN_ERR "unionfs: no superblock for "
 				       "file %p\n", file);
 			else {
-				unionfs_read_lock(sb);
 				/* decrement count of open files */
 				branchput(sb, i);
-				unionfs_read_unlock(sb);
 				/*
 				 * fput will perform an mntput for us on the
 				 * correct branch.  Although we're using the
@@ -164,9 +162,7 @@ static int open_all_files(struct file *file)
 
 		dget(hidden_dentry);
 		unionfs_mntget(dentry, bindex);
-		unionfs_read_lock(sb);
 		branchget(sb, bindex);
-		unionfs_read_unlock(sb);
 
 		hidden_file =
 			dentry_open(hidden_dentry,
@@ -213,9 +209,7 @@ static int open_highest_file(struct file *file, int willwrite)
 
 	dget(hidden_dentry);
 	unionfs_mntget(dentry, bstart);
-	unionfs_read_lock(sb);
 	branchget(sb, bstart);
-	unionfs_read_unlock(sb);
 	hidden_file = dentry_open(hidden_dentry,
 				  unionfs_lower_mnt_idx(dentry, bstart),
 				  file->f_flags);
@@ -259,9 +253,7 @@ static int do_delayed_copyup(struct file *file, struct dentry *dentry)
 		bend = fbend(file);
 		for (bindex = bstart; bindex <= bend; bindex++) {
 			if (unionfs_lower_file_idx(file, bindex)) {
-				unionfs_read_lock(dentry->d_sb);
 				branchput(dentry->d_sb, bindex);
-				unionfs_read_unlock(dentry->d_sb);
 				fput(unionfs_lower_file_idx(file, bindex));
 				unionfs_set_lower_file_idx(file, bindex, NULL);
 			}
@@ -400,9 +392,7 @@ static int __open_dir(struct inode *inode, struct file *file)
 		 * The branchget goes after the open, because otherwise
 		 * we would miss the reference on release.
 		 */
-		unionfs_read_lock(inode->i_sb);
 		branchget(inode->i_sb, bindex);
-		unionfs_read_unlock(inode->i_sb);
 	}
 
 	return 0;
@@ -463,9 +453,7 @@ static int __open_file(struct inode *inode, struct file *file)
 		return PTR_ERR(hidden_file);
 
 	unionfs_set_lower_file(file, hidden_file);
-	unionfs_read_lock(inode->i_sb);
 	branchget(inode->i_sb, bstart);
-	unionfs_read_unlock(inode->i_sb);
 
 	return 0;
 }
@@ -479,6 +467,7 @@ int unionfs_open(struct inode *inode, struct file *file)
 	int size;
 
 	unionfs_read_lock(inode->i_sb);
+
 	file->private_data =
 		kzalloc(sizeof(struct unionfs_file_info), GFP_KERNEL);
 	if (!UNIONFS_F(file)) {
@@ -529,9 +518,7 @@ int unionfs_open(struct inode *inode, struct file *file)
 			if (!hidden_file)
 				continue;
 
-			unionfs_read_lock(file->f_dentry->d_sb);
 			branchput(file->f_dentry->d_sb, bindex);
-			unionfs_read_unlock(file->f_dentry->d_sb);
 			/* fput calls dput for hidden_dentry */
 			fput(hidden_file);
 		}
@@ -550,7 +537,11 @@ out_nofree:
 	return err;
 }
 
-/* release all lower object references & free the file info structure */
+/*
+ * release all lower object references & free the file info structure
+ *
+ * No need to grab sb info's rwsem.
+ */
 int unionfs_file_release(struct inode *inode, struct file *file)
 {
 	struct file *hidden_file = NULL;
@@ -583,9 +574,7 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 
 		if (hidden_file) {
 			fput(hidden_file);
-			unionfs_read_lock(inode->i_sb);
 			branchput(inode->i_sb, bindex);
-			unionfs_read_unlock(inode->i_sb);
 		}
 	}
 	kfree(fileinfo->lower_files);
@@ -607,7 +596,6 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 		fileinfo->rdstate = NULL;
 	}
 	kfree(fileinfo);
-	unionfs_read_unlock(inode->i_sb);
 	return 0;
 }
 
@@ -684,7 +672,8 @@ long unionfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long err;
 
-	unionfs_read_lock(file->f_dentry->d_sb);
+	unionfs_read_lock(file->f_path.dentry->d_sb);
+
 	if ((err = unionfs_file_revalidate(file, 1)))
 		goto out;
 
@@ -709,7 +698,7 @@ long unionfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 
 out:
-	unionfs_read_unlock(file->f_dentry->d_sb);
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
 	return err;
 }
 
@@ -720,7 +709,7 @@ int unionfs_flush(struct file *file, fl_owner_t id)
 	struct dentry *dentry = file->f_dentry;
 	int bindex, bstart, bend;
 
-	unionfs_read_lock(file->f_dentry->d_sb);
+	unionfs_read_lock(file->f_path.dentry->d_sb);
 
 	if ((err = unionfs_file_revalidate(file, 1)))
 		goto out;
@@ -754,6 +743,6 @@ int unionfs_flush(struct file *file, fl_owner_t id)
 out_lock:
 	unionfs_unlock_dentry(dentry);
 out:
-	unionfs_read_unlock(file->f_dentry->d_sb);
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
 	return err;
 }
diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index dff4f1c..8f13670 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -210,9 +210,7 @@ static int __copyup_reg_data(struct dentry *dentry,
 
 	/* open old file */
 	unionfs_mntget(dentry, old_bindex);
-	unionfs_read_lock(sb);
 	branchget(sb, old_bindex);
-	unionfs_read_unlock(sb);
 	input_file = dentry_open(old_hidden_dentry,
 				 unionfs_lower_mnt_idx(dentry, old_bindex),
 				 O_RDONLY | O_LARGEFILE);
@@ -229,9 +227,7 @@ static int __copyup_reg_data(struct dentry *dentry,
 	/* open new file */
 	dget(new_hidden_dentry);
 	unionfs_mntget(dentry, new_bindex);
-	unionfs_read_lock(sb);
 	branchget(sb, new_bindex);
-	unionfs_read_unlock(sb);
 	output_file = dentry_open(new_hidden_dentry,
 				  unionfs_lower_mnt_idx(dentry, new_bindex),
 				  O_WRONLY | O_LARGEFILE);
@@ -307,17 +303,13 @@ out_close_out:
 	fput(output_file);
 
 out_close_in2:
-	unionfs_read_lock(sb);
 	branchput(sb, new_bindex);
-	unionfs_read_unlock(sb);
 
 out_close_in:
 	fput(input_file);
 
 out:
-	unionfs_read_lock(sb);
 	branchput(sb, old_bindex);
-	unionfs_read_unlock(sb);
 
 	return err;
 }
@@ -461,9 +453,7 @@ out_unlink:
 		/* need to close the file */
 
 		fput(*copyup_file);
-		unionfs_read_lock(sb);
 		branchput(sb, new_bindex);
-		unionfs_read_unlock(sb);
 	}
 
 	/*
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 9bd521b..306e171 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -290,10 +290,14 @@ static int unionfs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	int err;
 
+	unionfs_read_lock(dentry->d_sb);
+
 	unionfs_lock_dentry(dentry);
 	err = __unionfs_d_revalidate_chain(dentry, nd);
 	unionfs_unlock_dentry(dentry);
 
+	unionfs_read_unlock(dentry->d_sb);
+
 	return err;
 }
 
@@ -305,6 +309,8 @@ static void unionfs_d_release(struct dentry *dentry)
 {
 	int bindex, bstart, bend;
 
+	unionfs_read_lock(dentry->d_sb);
+
 	/* this could be a negative dentry, so check first */
 	if (!UNIONFS_D(dentry)) {
 		printk(KERN_DEBUG "unionfs: dentry without private data: %.*s",
@@ -337,6 +343,7 @@ out_free:
 	free_dentry_private_data(dentry);
 
 out:
+	unionfs_read_unlock(dentry->d_sb);
 	return;
 }
 
diff --git a/fs/unionfs/dirfops.c b/fs/unionfs/dirfops.c
index 7306b3f..95b0946 100644
--- a/fs/unionfs/dirfops.c
+++ b/fs/unionfs/dirfops.c
@@ -97,7 +97,8 @@ static int unionfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 	int bend;
 	loff_t offset;
 
-	unionfs_read_lock(file->f_dentry->d_sb);
+	unionfs_read_lock(file->f_path.dentry->d_sb);
+
 	if ((err = unionfs_file_revalidate(file, 0)))
 		goto out;
 
@@ -179,7 +180,7 @@ static int unionfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 		file->f_pos = rdstate2offset(uds);
 
 out:
-	unionfs_read_unlock(file->f_dentry->d_sb);
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
 	return err;
 }
 
@@ -198,7 +199,8 @@ static loff_t unionfs_dir_llseek(struct file *file, loff_t offset, int origin)
 	struct unionfs_dir_state *rdstate;
 	loff_t err;
 
-	unionfs_read_lock(file->f_dentry->d_sb);
+	unionfs_read_lock(file->f_path.dentry->d_sb);
+
 	if ((err = unionfs_file_revalidate(file, 0)))
 		goto out;
 
@@ -255,7 +257,7 @@ static loff_t unionfs_dir_llseek(struct file *file, loff_t offset, int origin)
 	}
 
 out:
-	unionfs_read_unlock(file->f_dentry->d_sb);
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
 	return err;
 }
 
diff --git a/fs/unionfs/dirhelper.c b/fs/unionfs/dirhelper.c
index 975d6fe..82e7896 100644
--- a/fs/unionfs/dirhelper.c
+++ b/fs/unionfs/dirhelper.c
@@ -99,7 +99,6 @@ int delete_whiteouts(struct dentry *dentry, int bindex,
 	struct sioq_args args;
 
 	sb = dentry->d_sb;
-	unionfs_read_lock(sb);
 
 	BUG_ON(!S_ISDIR(dentry->d_inode->i_mode));
 	BUG_ON(bindex < dbstart(dentry));
@@ -126,7 +125,6 @@ int delete_whiteouts(struct dentry *dentry, int bindex,
 	mutex_unlock(&hidden_dir->i_mutex);
 
 out:
-	unionfs_read_unlock(sb);
 	return err;
 }
 
@@ -195,7 +193,6 @@ int check_empty(struct dentry *dentry, struct unionfs_dir_state **namelist)
 
 	sb = dentry->d_sb;
 
-	unionfs_read_lock(sb);
 
 	BUG_ON(!S_ISDIR(dentry->d_inode->i_mode));
 
@@ -233,9 +230,7 @@ int check_empty(struct dentry *dentry, struct unionfs_dir_state **namelist)
 
 		dget(hidden_dentry);
 		unionfs_mntget(dentry, bindex);
-		unionfs_read_lock(sb);
 		branchget(sb, bindex);
-		unionfs_read_unlock(sb);
 		hidden_file =
 			dentry_open(hidden_dentry,
 				    unionfs_lower_mnt_idx(dentry, bindex),
@@ -243,9 +238,7 @@ int check_empty(struct dentry *dentry, struct unionfs_dir_state **namelist)
 		if (IS_ERR(hidden_file)) {
 			err = PTR_ERR(hidden_file);
 			dput(hidden_dentry);
-			unionfs_read_lock(sb);
 			branchput(sb, bindex);
-			unionfs_read_unlock(sb);
 			goto out;
 		}
 
@@ -260,9 +253,7 @@ int check_empty(struct dentry *dentry, struct unionfs_dir_state **namelist)
 
 		/* fput calls dput for hidden_dentry */
 		fput(hidden_file);
-		unionfs_read_lock(sb);
 		branchput(sb, bindex);
-		unionfs_read_unlock(sb);
 
 		if (err < 0)
 			goto out;
@@ -277,7 +268,6 @@ out:
 		kfree(buf);
 	}
 
-	unionfs_read_unlock(sb);
 
 	return err;
 }
diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index afffe59..aea378d 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -27,7 +27,7 @@ static ssize_t unionfs_read(struct file *file, char __user *buf,
 {
 	int err;
 
-	unionfs_read_lock(file->f_dentry->d_sb);
+	unionfs_read_lock(file->f_path.dentry->d_sb);
 
 	if ((err = unionfs_file_revalidate(file, 0)))
 		goto out;
@@ -39,7 +39,7 @@ static ssize_t unionfs_read(struct file *file, char __user *buf,
 			    unionfs_lower_dentry(file->f_path.dentry));
 
 out:
-	unionfs_read_unlock(file->f_dentry->d_sb);
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
 	return err;
 }
 
@@ -49,7 +49,7 @@ static ssize_t unionfs_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	int err = 0;
 	struct file *file = iocb->ki_filp;
 
-	unionfs_read_lock(file->f_dentry->d_sb);
+	unionfs_read_lock(file->f_path.dentry->d_sb);
 
 	if ((err = unionfs_file_revalidate(file, 0)))
 		goto out;
@@ -64,7 +64,7 @@ static ssize_t unionfs_aio_read(struct kiocb *iocb, const struct iovec *iov,
 			    unionfs_lower_dentry(file->f_path.dentry));
 
 out:
-	unionfs_read_unlock(file->f_dentry->d_sb);
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
 	return err;
 }
 static ssize_t unionfs_write(struct file * file, const char __user * buf,
@@ -72,7 +72,7 @@ static ssize_t unionfs_write(struct file * file, const char __user * buf,
 {
 	int err = 0;
 
-	unionfs_read_lock(file->f_dentry->d_sb);
+	unionfs_read_lock(file->f_path.dentry->d_sb);
 
 	if ((err = unionfs_file_revalidate(file, 1)))
 		goto out;
@@ -80,7 +80,7 @@ static ssize_t unionfs_write(struct file * file, const char __user * buf,
 	err = do_sync_write(file, buf, count, ppos);
 
 out:
-	unionfs_read_unlock(file->f_dentry->d_sb);
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
 	return err;
 }
 
@@ -96,7 +96,7 @@ static int unionfs_mmap(struct file *file, struct vm_area_struct *vma)
 	int willwrite;
 	struct file *lower_file;
 
-	unionfs_read_lock(file->f_dentry->d_sb);
+	unionfs_read_lock(file->f_path.dentry->d_sb);
 
 	if ((err = unionfs_file_revalidate(file, 1)))
 		goto out;
@@ -128,7 +128,7 @@ static int unionfs_mmap(struct file *file, struct vm_area_struct *vma)
 	}
 
 out:
-	unionfs_read_unlock(file->f_dentry->d_sb);
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
 	return err;
 }
 
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index aaabfcf..cdd1a7c 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -30,16 +30,6 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 	char *name = NULL;
 	int valid = 0;
 
-	/*
-	 * We have to read-lock the superblock rwsem, and we have to
-	 * revalidate the parent dentry and this one.  A branch-management
-	 * operation could have taken place, mid-way through a VFS operation
-	 * that eventually reaches here.  So we have to ensure consistency,
-	 * just as we do with the file operations.
-	 *
-	 * XXX: we may need to do this for all other inode ops that take a
-	 * dentry.
-	 */
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
@@ -234,11 +224,7 @@ static struct dentry *unionfs_lookup(struct inode *parent,
 	struct path path_save;
 	struct dentry *ret;
 
-	/*
-	 * lookup is the only special function which takes a dentry, yet we
-	 * do NOT want to call __unionfs_d_revalidate_chain because by
-	 * definition, we don't have a valid dentry here yet.
-	 */
+	unionfs_read_lock(dentry->d_sb);
 
 	/* save the dentry & vfsmnt from namei */
 	if (nd) {
@@ -255,6 +241,8 @@ static struct dentry *unionfs_lookup(struct inode *parent,
 		nd->mnt = path_save.mnt;
 	}
 
+	unionfs_read_unlock(dentry->d_sb);
+
 	return ret;
 }
 
@@ -268,6 +256,7 @@ static int unionfs_link(struct dentry *old_dentry, struct inode *dir,
 	struct dentry *whiteout_dentry;
 	char *name = NULL;
 
+	unionfs_read_lock(old_dentry->d_sb);
 	unionfs_double_lock_dentry(new_dentry, old_dentry);
 
 	if (!__unionfs_d_revalidate_chain(old_dentry, NULL)) {
@@ -391,6 +380,8 @@ out:
 	unionfs_unlock_dentry(new_dentry);
 	unionfs_unlock_dentry(old_dentry);
 
+	unionfs_read_unlock(old_dentry->d_sb);
+
 	return err;
 }
 
@@ -405,6 +396,7 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 	int bindex = 0, bstart;
 	char *name = NULL;
 
+	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
 	if (dentry->d_inode &&
@@ -538,6 +530,7 @@ out:
 
 	kfree(name);
 	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
 
@@ -551,6 +544,7 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 	int whiteout_unlinked = 0;
 	struct sioq_args args;
 
+	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
 	if (dentry->d_inode &&
@@ -676,6 +670,7 @@ out:
 	kfree(name);
 
 	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
 
@@ -689,6 +684,7 @@ static int unionfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
 	char *name = NULL;
 	int whiteout_unlinked = 0;
 
+	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
 	if (dentry->d_inode &&
@@ -792,6 +788,7 @@ out:
 	kfree(name);
 
 	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
 
@@ -801,6 +798,7 @@ static int unionfs_readlink(struct dentry *dentry, char __user *buf,
 	int err;
 	struct dentry *hidden_dentry;
 
+	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
 	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
@@ -824,9 +822,23 @@ static int unionfs_readlink(struct dentry *dentry, char __user *buf,
 
 out:
 	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
 
+/*
+ * Check if dentry is valid or not, as per our generation numbers.
+ * @dentry: dentry to check.
+ * Returns 1 (valid) or 0 (invalid/stale).
+ */
+static inline int is_valid_dentry(struct dentry *dentry)
+{
+	BUG_ON(!UNIONFS_D(dentry));
+	BUG_ON(!UNIONFS_SB(dentry->d_sb));
+	return (atomic_read(&UNIONFS_D(dentry)->generation) ==
+			atomic_read(&UNIONFS_SB(dentry->d_sb)->generation));
+}
+
 /* We don't lock the dentry here, because readlink does the heavy lifting. */
 static void *unionfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
@@ -834,13 +846,17 @@ static void *unionfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 	int len = PAGE_SIZE, err;
 	mm_segment_t old_fs;
 
-	unionfs_lock_dentry(dentry);
+	/*
+	 * FIXME: Really nasty...we can get called from two distinct places:
+	 * 1) read_link - locks the dentry
+	 * 2) VFS lookup code - does NOT lock the dentry
+	 *
+	 * The proper thing would be to call dentry revalidate. It however
+	 * expects a locked dentry, and we can't cleanly guarantee that.
+	 */
+	BUG_ON(!is_valid_dentry(dentry));
 
-	if (dentry->d_inode &&
-	    !__unionfs_d_revalidate_chain(dentry, nd)) {
-		err = -ESTALE;
-		goto out;
-	}
+	unionfs_read_lock(dentry->d_sb);
 
 	/* This is freed by the put_link method assuming a successful call. */
 	buf = kmalloc(len, GFP_KERNEL);
@@ -864,13 +880,17 @@ static void *unionfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 	err = 0;
 
 out:
+	unionfs_read_unlock(dentry->d_sb);
 	return ERR_PTR(err);
 }
 
+/* FIXME: We may not have to lock here */
 static void unionfs_put_link(struct dentry *dentry, struct nameidata *nd,
 			     void *cookie)
 {
+	unionfs_read_lock(dentry->d_sb);
 	kfree(nd_get_link(nd));
+	unionfs_read_unlock(dentry->d_sb);
 }
 
 /*
@@ -912,9 +932,7 @@ static int inode_permission(struct inode *inode, int mask,
 		    (!strcmp("nfs", (inode)->i_sb->s_type->name)) &&
 		    (nd) && (nd->mnt) && (nd->mnt->mnt_sb)) {
 			int perms;
-			unionfs_read_lock(nd->mnt->mnt_sb);
 			perms = branchperms(nd->mnt->mnt_sb, bindex);
-			unionfs_read_unlock(nd->mnt->mnt_sb);
 			if (perms & MAY_NFSRO)
 				retval = generic_permission(inode, submask,
 							    NULL);
@@ -1006,6 +1024,7 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 	int i;
 	int copyup = 0;
 
+	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
 	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
@@ -1075,6 +1094,7 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 
 out:
 	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
 
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index b9fe431..c6bf729 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -242,7 +242,13 @@ int parse_branch_mode(const char *name)
 	return perms;
 }
 
-/* parse the dirs= mount argument */
+/* 
+ * parse the dirs= mount argument
+ *
+ * We don't need to lock the superblock private data's rwsem, as we get
+ * called only by unionfs_read_super - it is still a long time before anyone
+ * can even get a reference to us.
+ */
 static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 			     *hidden_root_info, char *options)
 {
@@ -325,11 +331,9 @@ static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 		hidden_root_info->lower_paths[bindex].dentry = nd.dentry;
 		hidden_root_info->lower_paths[bindex].mnt = nd.mnt;
 
-		unionfs_write_lock(sb);
 		set_branchperms(sb, bindex, perms);
 		set_branch_count(sb, bindex, 0);
 		new_branch_id(sb, bindex);
-		unionfs_write_unlock(sb);
 
 		if (hidden_root_info->bstart < 0)
 			hidden_root_info->bstart = bindex;
@@ -530,6 +534,10 @@ static struct dentry *unionfs_d_alloc_root(struct super_block *sb)
 	return ret;
 }
 
+/*
+ * There is no need to lock the unionfs_super_info's rwsem as there is no
+ * way anyone can have a reference to the superblock at this point in time.
+ */
 static int unionfs_read_super(struct super_block *sb, void *raw_data,
 			      int silent)
 {
@@ -577,19 +585,12 @@ static int unionfs_read_super(struct super_block *sb, void *raw_data,
 	BUG_ON(bstart != 0);
 	sbend(sb) = bend = hidden_root_info->bend;
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		struct dentry *d;
-
-		d = hidden_root_info->lower_paths[bindex].dentry;
-
-		unionfs_write_lock(sb);
+		struct dentry *d = hidden_root_info->lower_paths[bindex].dentry;
 		unionfs_set_lower_super_idx(sb, bindex, d->d_sb);
-		unionfs_write_unlock(sb);
 	}
 
 	/* max Bytes is the maximum bytes from highest priority branch */
-	unionfs_read_lock(sb);
 	sb->s_maxbytes = unionfs_lower_super_idx(sb, 0)->s_maxbytes;
-	unionfs_read_unlock(sb);
 
 	sb->s_op = &unionfs_sops;
 
diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index 4ceb815..861c8db 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -398,6 +398,7 @@ int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	int err = 0;
 	struct dentry *wh_dentry;
 
+	unionfs_read_lock(old_dentry->d_sb);
 	unionfs_double_lock_dentry(old_dentry, new_dentry);
 
 	if (!__unionfs_d_revalidate_chain(old_dentry, NULL)) {
@@ -471,5 +472,6 @@ out:
 
 	unionfs_unlock_dentry(new_dentry);
 	unionfs_unlock_dentry(old_dentry);
+	unionfs_read_unlock(old_dentry->d_sb);
 	return err;
 }
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 3f334f3..9f248b9 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -30,6 +30,8 @@ static void unionfs_read_inode(struct inode *inode)
 	int size;
 	struct unionfs_inode_info *info = UNIONFS_I(inode);
 
+	unionfs_read_lock(inode->i_sb);
+
 	if (!info) {
 		printk(KERN_ERR "unionfs: no kernel memory when allocating "
 		       "inode private data!\n");
@@ -59,6 +61,8 @@ static void unionfs_read_inode(struct inode *inode)
 	inode->i_fop = &unionfs_main_fops;
 
 	inode->i_mapping->a_ops = &unionfs_aops;
+
+	unionfs_read_unlock(inode->i_sb);
 }
 
 /*
@@ -67,6 +71,8 @@ static void unionfs_read_inode(struct inode *inode)
  * else that's needed, and the other is fine.  This way we truncate the inode
  * size (and its pages) and then clear our own inode, which will do an iput
  * on our and the lower inode.
+ *
+ * No need to lock sb info's rwsem.
  */
 static void unionfs_delete_inode(struct inode *inode)
 {
@@ -78,7 +84,11 @@ static void unionfs_delete_inode(struct inode *inode)
 	clear_inode(inode);
 }
 
-/* final actions when unmounting a file system */
+/*
+ * final actions when unmounting a file system
+ *
+ * No need to lock rwsem.
+ */
 static void unionfs_put_super(struct super_block *sb)
 {
 	int bindex, bstart, bend;
@@ -117,6 +127,9 @@ static int unionfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct super_block *sb;
 	struct dentry *lower_dentry;
 
+	sb = dentry->d_sb;
+
+	unionfs_read_lock(sb);
 	unionfs_lock_dentry(dentry);
 
 	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
@@ -124,8 +137,6 @@ static int unionfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		goto out;
 	}
 
-	sb = dentry->d_sb;
-
 	lower_dentry = unionfs_lower_dentry(sb->s_root);
 	err = vfs_statfs(lower_dentry, buf);
 
@@ -143,6 +154,7 @@ static int unionfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 out:
 	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(sb);
 	return err;
 }
 
@@ -787,6 +799,8 @@ out_error:
  * and the inode is not hashed anywhere.  Used to clear anything
  * that needs to be, before the inode is completely destroyed and put
  * on the inode free list.
+ *
+ * No need to lock sb info's rwsem.
  */
 static void unionfs_clear_inode(struct inode *inode)
 {
@@ -871,6 +885,8 @@ void unionfs_destroy_inode_cache(void)
 /*
  * Called when we have a dirty inode, right here we only throw out
  * parts of our readdir list that are too old.
+ *
+ * No need to grab sb info's rwsem.
  */
 static int unionfs_write_inode(struct inode *inode, int sync)
 {
@@ -911,18 +927,20 @@ static void unionfs_umount_begin(struct vfsmount *mnt, int flags)
 
 	sb = mnt->mnt_sb;
 
+	unionfs_read_lock(sb);
+
 	bstart = sbstart(sb);
 	bend = sbend(sb);
 	for (bindex = bstart; bindex <= bend; bindex++) {
 		hidden_mnt = unionfs_lower_mnt_idx(sb->s_root, bindex);
-		unionfs_read_lock(sb);
 		hidden_sb = unionfs_lower_super_idx(sb, bindex);
-		unionfs_read_unlock(sb);
 
 		if (hidden_mnt && hidden_sb && hidden_sb->s_op &&
 		    hidden_sb->s_op->umount_begin)
 			hidden_sb->s_op->umount_begin(hidden_mnt, flags);
 	}
+
+	unionfs_read_unlock(sb);
 }
 
 static int unionfs_show_options(struct seq_file *m, struct vfsmount *mnt)
@@ -934,6 +952,8 @@ static int unionfs_show_options(struct seq_file *m, struct vfsmount *mnt)
 	int bindex, bstart, bend;
 	int perms;
 
+	unionfs_read_lock(sb);
+
 	unionfs_lock_dentry(sb->s_root);
 
 	tmp_page = (char*) __get_free_page(GFP_KERNEL);
@@ -955,9 +975,7 @@ static int unionfs_show_options(struct seq_file *m, struct vfsmount *mnt)
 			goto out;
 		}
 
-		unionfs_read_lock(sb);
 		perms = branchperms(sb, bindex);
-		unionfs_read_unlock(sb);
 
 		seq_printf(m, "%s=%s", path,
 			   perms & MAY_WRITE ? "rw" : "ro");
@@ -970,6 +988,8 @@ out:
 
 	unionfs_unlock_dentry(sb->s_root);
 
+	unionfs_read_unlock(sb);
+
 	return ret;
 }
 
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 6eb151e..3fb4c14 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -134,7 +134,16 @@ struct unionfs_sb_info {
 	int bend;
 
 	atomic_t generation;
-	struct rw_semaphore rwsem; /* protects access to data+id fields */
+
+	/*
+	 * This rwsem is used to make sure that a branch management
+	 * operation...
+	 *   1) will not begin before all currently in-flight operations
+	 *      complete
+	 *   2) any new operations do not execute until the currently
+	 *      running branch management operation completes
+	 */
+	struct rw_semaphore rwsem;
 	int high_branch_id;	/* last unique branch ID given */
 	struct unionfs_data *data;
 };
@@ -371,9 +380,7 @@ static inline int is_robranch_super(const struct super_block *sb, int index)
 {
 	int ret;
 
-	unionfs_read_lock(sb);
   	ret = (!(branchperms(sb, index) & MAY_WRITE)) ? -EROFS : 0;
-	unionfs_read_unlock(sb);
 	return ret;
 }
 
@@ -384,11 +391,9 @@ static inline int is_robranch_idx(const struct dentry *dentry, int index)
 
 	BUG_ON(index < 0);
 
-	unionfs_read_lock(dentry->d_sb);
 	if ((!(branchperms(dentry->d_sb, index) & MAY_WRITE)) ||
 	    IS_RDONLY(unionfs_lower_dentry_idx(dentry, index)->d_inode))
 		err = -EROFS;
-	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
 
diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index c785ff0..a6b8bab 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -74,6 +74,7 @@ int unionfs_unlink(struct inode *dir, struct dentry *dentry)
 {
 	int err = 0;
 
+	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
 	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
@@ -88,6 +89,7 @@ int unionfs_unlink(struct inode *dir, struct dentry *dentry)
 
 out:
 	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
 
@@ -128,6 +130,7 @@ int unionfs_rmdir(struct inode *dir, struct dentry *dentry)
 	int err = 0;
 	struct unionfs_dir_state *namelist = NULL;
 
+	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
 	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
@@ -168,5 +171,6 @@ out:
 		free_rdstate(namelist);
 
 	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
diff --git a/fs/unionfs/xattr.c b/fs/unionfs/xattr.c
index 1beb373..5bb8054 100644
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -57,6 +57,7 @@ ssize_t unionfs_getxattr(struct dentry *dentry, const char *name, void *value,
 	struct dentry *hidden_dentry = NULL;
 	int err = -EOPNOTSUPP;
 
+	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
 	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
@@ -70,6 +71,7 @@ ssize_t unionfs_getxattr(struct dentry *dentry, const char *name, void *value,
 
 out:
 	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
 
@@ -83,6 +85,7 @@ int unionfs_setxattr(struct dentry *dentry, const char *name,
 	struct dentry *hidden_dentry = NULL;
 	int err = -EOPNOTSUPP;
 
+	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
 	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
@@ -97,6 +100,7 @@ int unionfs_setxattr(struct dentry *dentry, const char *name,
 
 out:
 	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
 
@@ -109,6 +113,7 @@ int unionfs_removexattr(struct dentry *dentry, const char *name)
 	struct dentry *hidden_dentry = NULL;
 	int err = -EOPNOTSUPP;
 
+	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
 	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
@@ -122,6 +127,7 @@ int unionfs_removexattr(struct dentry *dentry, const char *name)
 
 out:
 	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
 
@@ -135,6 +141,7 @@ ssize_t unionfs_listxattr(struct dentry *dentry, char *list, size_t size)
 	int err = -EOPNOTSUPP;
 	char *encoded_list = NULL;
 
+	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
 	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
@@ -149,5 +156,6 @@ ssize_t unionfs_listxattr(struct dentry *dentry, char *list, size_t size)
 
 out:
 	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
-- 
1.5.2.rc1.165.gaf9b

