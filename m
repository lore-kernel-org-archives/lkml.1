Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbZDYBaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbZDYBaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbZDYB2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:28:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:44573 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbZDYB2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:28:48 -0400
Message-Id: <20090425012209.061706790@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sat, 25 Apr 2009 11:20:21 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 01/27] fs: cleanup files_lock
References: <20090425012020.457460929@suse.de>
Content-Disposition: inline; filename=fs-files_list-improve.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lock tty_files with tty_mutex, provide helpers to manipulate the per-sb
files list, and unexport the files_lock spinlock.
---
 drivers/char/pty.c       |    6 +++-
 drivers/char/tty_io.c    |   39 +++++++++++++++++++--------
 fs/file_table.c          |   66 ++++++++++++++++++++++++++++++++++-------------
 fs/open.c                |    4 +-
 fs/super.c               |   39 ---------------------------
 include/linux/fs.h       |    8 ++---
 security/selinux/hooks.c |    4 +-
 7 files changed, 89 insertions(+), 77 deletions(-)

Index: linux-2.6/drivers/char/pty.c
===================================================================
--- linux-2.6.orig/drivers/char/pty.c
+++ linux-2.6/drivers/char/pty.c
@@ -662,7 +662,11 @@ static int __ptmx_open(struct inode *ino
 
 	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
 	filp->private_data = tty;
-	file_move(filp, &tty->tty_files);
+
+	mutex_lock(&tty_mutex);
+	file_list_del(filp);
+	list_add(&filp->f_u.fu_list, &tty->tty_files);
+	mutex_unlock(&tty_mutex);
 
 	retval = devpts_pty_new(inode, tty->link);
 	if (retval)
Index: linux-2.6/drivers/char/tty_io.c
===================================================================
--- linux-2.6.orig/drivers/char/tty_io.c
+++ linux-2.6/drivers/char/tty_io.c
@@ -229,17 +229,15 @@ int tty_paranoia_check(struct tty_struct
 	return 0;
 }
 
-static int check_tty_count(struct tty_struct *tty, const char *routine)
+static int __check_tty_count(struct tty_struct *tty, const char *routine)
 {
 #ifdef CHECK_TTY_COUNT
 	struct list_head *p;
 	int count = 0;
 
-	file_list_lock();
 	list_for_each(p, &tty->tty_files) {
 		count++;
 	}
-	file_list_unlock();
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 	    tty->driver->subtype == PTY_TYPE_SLAVE &&
 	    tty->link && tty->link->count)
@@ -254,6 +252,19 @@ static int check_tty_count(struct tty_st
 	return 0;
 }
 
+static int check_tty_count(struct tty_struct *tty, const char *routine)
+{
+	int ret = 0;
+
+#ifdef CHECK_TTY_COUNT
+	mutex_lock(&tty_mutex);
+	ret = __check_tty_count(tty, routine);
+	mutex_unlock(&tty_mutex);
+#endif
+
+	return ret;
+}
+
 /**
  *	get_tty_driver		-	find device of a tty
  *	@dev_t: device identifier
@@ -543,6 +554,8 @@ static void do_tty_hangup(struct work_st
 	if (!tty)
 		return;
 
+	mutex_lock(&tty_mutex);
+
 	/* inuse_filps is protected by the single kernel lock */
 	lock_kernel();
 
@@ -553,8 +566,7 @@ static void do_tty_hangup(struct work_st
 	}
 	spin_unlock(&redirect_lock);
 
-	check_tty_count(tty, "do_tty_hangup");
-	file_list_lock();
+	__check_tty_count(tty, "do_tty_hangup");
 	/* This breaks for file handles being sent over AF_UNIX sockets ? */
 	list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
 		if (filp->f_op->write == redirected_tty_write)
@@ -565,7 +577,7 @@ static void do_tty_hangup(struct work_st
 		tty_fasync(-1, filp, 0);	/* can't block */
 		filp->f_op = &hung_up_tty_fops;
 	}
-	file_list_unlock();
+	mutex_unlock(&tty_mutex);
 	/*
 	 * FIXME! What are the locking issues here? This may me overdoing
 	 * things... This question is especially important now that we've
@@ -1467,9 +1479,9 @@ static void release_one_tty(struct kref
 	tty_driver_kref_put(driver);
 	module_put(driver->owner);
 
-	file_list_lock();
+	mutex_lock(&tty_mutex);
 	list_del_init(&tty->tty_files);
-	file_list_unlock();
+	mutex_unlock(&tty_mutex);
 
 	free_tty_struct(tty);
 }
@@ -1678,7 +1690,8 @@ void tty_release_dev(struct file *filp)
 	 *  - do_tty_hangup no longer sees this file descriptor as
 	 *    something that needs to be handled for hangups.
 	 */
-	file_kill(filp);
+	BUG_ON(list_empty(&filp->f_u.fu_list));
+	list_del_init(&filp->f_u.fu_list);
 	filp->private_data = NULL;
 
 	/*
@@ -1836,8 +1849,12 @@ got_driver:
 		return PTR_ERR(tty);
 
 	filp->private_data = tty;
-	file_move(filp, &tty->tty_files);
-	check_tty_count(tty, "tty_open");
+	mutex_lock(&tty_mutex);
+	BUG_ON(list_empty(&filp->f_u.fu_list));
+	file_list_del(filp); /* __dentry_open has put it on the sb list */
+	list_add(&filp->f_u.fu_list, &tty->tty_files);
+	__check_tty_count(tty, "tty_open");
+	mutex_unlock(&tty_mutex);
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 	    tty->driver->subtype == PTY_TYPE_MASTER)
 		noctty = 1;
Index: linux-2.6/fs/file_table.c
===================================================================
--- linux-2.6.orig/fs/file_table.c
+++ linux-2.6/fs/file_table.c
@@ -30,8 +30,7 @@ struct files_stat_struct files_stat = {
 	.max_files = NR_FILE
 };
 
-/* public. Not pretty! */
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(files_lock);
+static __cacheline_aligned_in_smp DEFINE_SPINLOCK(files_lock);
 
 /* SLAB cache for file structures */
 static struct kmem_cache *filp_cachep __read_mostly;
@@ -285,7 +284,7 @@ void __fput(struct file *file)
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
 	put_pid(file->f_owner.pid);
-	file_kill(file);
+	file_list_del(file);
 	if (file->f_mode & FMODE_WRITE)
 		drop_file_write_access(file);
 	file->f_path.dentry = NULL;
@@ -347,31 +346,29 @@ struct file *fget_light(unsigned int fd,
 	return file;
 }
 
-
 void put_filp(struct file *file)
 {
 	if (atomic_long_dec_and_test(&file->f_count)) {
 		security_file_free(file);
-		file_kill(file);
+		file_list_del(file);
 		file_free(file);
 	}
 }
 
-void file_move(struct file *file, struct list_head *list)
+void file_sb_list_add(struct file *file, struct super_block *sb)
 {
-	if (!list)
-		return;
-	file_list_lock();
-	list_move(&file->f_u.fu_list, list);
-	file_list_unlock();
+	spin_lock(&files_lock);
+	BUG_ON(!list_empty(&file->f_u.fu_list));
+	list_add(&file->f_u.fu_list, &sb->s_files);
+	spin_unlock(&files_lock);
 }
 
-void file_kill(struct file *file)
+void file_list_del(struct file *file)
 {
 	if (!list_empty(&file->f_u.fu_list)) {
-		file_list_lock();
+		spin_lock(&files_lock);
 		list_del_init(&file->f_u.fu_list);
-		file_list_unlock();
+		spin_unlock(&files_lock);
 	}
 }
 
@@ -380,7 +377,7 @@ int fs_may_remount_ro(struct super_block
 	struct file *file;
 
 	/* Check that no files are currently opened for writing. */
-	file_list_lock();
+	spin_lock(&files_lock);
 	list_for_each_entry(file, &sb->s_files, f_u.fu_list) {
 		struct inode *inode = file->f_path.dentry->d_inode;
 
@@ -392,13 +389,48 @@ int fs_may_remount_ro(struct super_block
 		if (S_ISREG(inode->i_mode) && (file->f_mode & FMODE_WRITE))
 			goto too_bad;
 	}
-	file_list_unlock();
+	spin_unlock(&files_lock);
 	return 1; /* Tis' cool bro. */
 too_bad:
-	file_list_unlock();
+	spin_unlock(&files_lock);
 	return 0;
 }
 
+/**
+ *	mark_files_ro - mark all files read-only
+ *	@sb: superblock in question
+ *
+ *	All files are marked read-only.  We don't care about pending
+ *	delete files so this should be used in 'force' mode only.
+ */
+void mark_files_ro(struct super_block *sb)
+{
+	struct file *f;
+
+retry:
+	spin_lock(&files_lock);
+	list_for_each_entry(f, &sb->s_files, f_u.fu_list) {
+		struct vfsmount *mnt;
+		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
+		       continue;
+		if (!file_count(f))
+			continue;
+		if (!(f->f_mode & FMODE_WRITE))
+			continue;
+		f->f_mode &= ~FMODE_WRITE;
+		if (file_check_writeable(f) != 0)
+			continue;
+		file_release_write(f);
+		mnt = mntget(f->f_path.mnt);
+		/* This can sleep, so we can't hold the spinlock. */
+		spin_unlock(&files_lock);
+		mnt_drop_write(mnt);
+		mntput(mnt);
+		goto retry;
+	}
+	spin_unlock(&files_lock);
+}
+
 void __init files_init(unsigned long mempages)
 { 
 	int n; 
Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c
+++ linux-2.6/fs/open.c
@@ -828,7 +828,7 @@ static struct file *__dentry_open(struct
 	f->f_path.mnt = mnt;
 	f->f_pos = 0;
 	f->f_op = fops_get(inode->i_fop);
-	file_move(f, &inode->i_sb->s_files);
+	file_sb_list_add(f, inode->i_sb);
 
 	error = security_dentry_open(f, cred);
 	if (error)
@@ -873,7 +873,7 @@ cleanup_all:
 			mnt_drop_write(mnt);
 		}
 	}
-	file_kill(f);
+	file_list_del(f);
 	f->f_path.dentry = NULL;
 	f->f_path.mnt = NULL;
 cleanup_file:
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -934,9 +934,6 @@ struct file {
 	unsigned long f_mnt_write_state;
 #endif
 };
-extern spinlock_t files_lock;
-#define file_list_lock() spin_lock(&files_lock);
-#define file_list_unlock() spin_unlock(&files_lock);
 
 #define get_file(x)	atomic_long_inc(&(x)->f_count)
 #define file_count(x)	atomic_long_read(&(x)->f_count)
@@ -2021,6 +2018,7 @@ extern const struct file_operations read
 extern const struct file_operations write_pipefifo_fops;
 extern const struct file_operations rdwr_pipefifo_fops;
 
+extern void mark_files_ro(struct super_block *sb);
 extern int fs_may_remount_ro(struct super_block *);
 
 #ifdef CONFIG_BLOCK
@@ -2172,8 +2170,8 @@ static inline void insert_inode_hash(str
 }
 
 extern struct file * get_empty_filp(void);
-extern void file_move(struct file *f, struct list_head *list);
-extern void file_kill(struct file *f);
+extern void file_sb_list_add(struct file *f, struct super_block *sb);
+extern void file_list_del(struct file *f);
 #ifdef CONFIG_BLOCK
 struct bio;
 extern void submit_bio(int, struct bio *);
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c
+++ linux-2.6/fs/super.c
@@ -588,45 +588,6 @@ out:
 }
 
 /**
- *	mark_files_ro - mark all files read-only
- *	@sb: superblock in question
- *
- *	All files are marked read-only.  We don't care about pending
- *	delete files so this should be used in 'force' mode only.
- */
-
-static void mark_files_ro(struct super_block *sb)
-{
-	struct file *f;
-
-retry:
-	file_list_lock();
-	list_for_each_entry(f, &sb->s_files, f_u.fu_list) {
-		struct vfsmount *mnt;
-		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
-		       continue;
-		if (!file_count(f))
-			continue;
-		if (!(f->f_mode & FMODE_WRITE))
-			continue;
-		f->f_mode &= ~FMODE_WRITE;
-		if (file_check_writeable(f) != 0)
-			continue;
-		file_release_write(f);
-		mnt = mntget(f->f_path.mnt);
-		file_list_unlock();
-		/*
-		 * This can sleep, so we can't hold
-		 * the file_list_lock() spinlock.
-		 */
-		mnt_drop_write(mnt);
-		mntput(mnt);
-		goto retry;
-	}
-	file_list_unlock();
-}
-
-/**
  *	do_remount_sb - asks filesystem to change mount options.
  *	@sb:	superblock in question
  *	@flags:	numeric part of options
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c
+++ linux-2.6/security/selinux/hooks.c
@@ -2244,7 +2244,7 @@ static inline void flush_unauthorized_fi
 
 	tty = get_current_tty();
 	if (tty) {
-		file_list_lock();
+		mutex_lock(&tty_mutex);
 		if (!list_empty(&tty->tty_files)) {
 			struct inode *inode;
 
@@ -2260,7 +2260,7 @@ static inline void flush_unauthorized_fi
 				drop_tty = 1;
 			}
 		}
-		file_list_unlock();
+		mutex_unlock(&tty_mutex);
 		tty_kref_put(tty);
 	}
 	/* Reset controlling tty. */


