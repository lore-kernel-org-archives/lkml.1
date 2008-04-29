Return-Path: <linux-kernel-owner+w=401wt.eu-S1760869AbYD2TB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbYD2TB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758969AbYD2S75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:59:57 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49430 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774AbYD2S7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:59:53 -0400
Subject: [RFC][PATCH 5/5] check mount writers at superblock remount
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       trond.myklebust@fys.uio.no, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2008 11:59:50 -0700
References: <20080429185943.3BA6A050@kernel>
In-Reply-To: <20080429185943.3BA6A050@kernel>
Message-Id: <20080429185950.3A37E91B@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We're moving a big chunk of the burden of keeping people from
writing to r/o filesystems from the superblock into the
vfsmount.  This requires that we keep track somehow of the
mounts that might allow writes to a superblock.

You could track this directly by keeping a count of such
mounts in the superblock, but I think this is much simpler
in practice.

On remount rw->ro operations:
1. Use lock_mnt_writers() to exclude any new mnt_writers
   for any mount on the entire system, which also clears
   each cpu_writer->mnt.
2. Lock superblock to stop anyone from setting any new
   cpu_writer->mnt if the mount is of this sb.
3. unlock_mnt_writers() to let other fs's on the system
   to go about their business.
4. Consult each mount of the sb to examine its
   mnt->__mnt_writers.  Remember, this is stable because
   (1) cleared out all the per-cpu writers, and in (2)
   the sb lock is held, keeping out any new writers.
5. release sb lock at end of remount operation (after
   ->remount_fs())

I'm not completely happy with the sb_locked thing in
do_remount_sb().  Expanding the use of lock_super() over
a larger area may make the code look simpler, but will
not be as obviously correct.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/file_table.c       |   24 -----------
 linux-2.6.git-dave/fs/namespace.c        |    4 -
 linux-2.6.git-dave/fs/super.c            |   65 ++++++++++++++++++++++++++-----
 linux-2.6.git-dave/include/linux/fs.h    |    2 
 linux-2.6.git-dave/include/linux/mount.h |   10 +++-
 5 files changed, 65 insertions(+), 40 deletions(-)

diff -puN fs/file_table.c~check_mount_writers_at_superblock_remount fs/file_table.c
--- linux-2.6.git/fs/file_table.c~check_mount_writers_at_superblock_remount	2008-04-29 11:56:42.000000000 -0700
+++ linux-2.6.git-dave/fs/file_table.c	2008-04-29 11:56:42.000000000 -0700
@@ -365,30 +365,6 @@ void file_kill(struct file *file)
 	}
 }
 
-int fs_may_remount_ro(struct super_block *sb)
-{
-	struct file *file;
-
-	/* Check that no files are currently opened for writing. */
-	file_list_lock();
-	list_for_each_entry(file, &sb->s_files, f_u.fu_list) {
-		struct inode *inode = file->f_path.dentry->d_inode;
-
-		/* File with pending delete? */
-		if (inode->i_nlink == 0)
-			goto too_bad;
-
-		/* Writeable file? */
-		if (S_ISREG(inode->i_mode) && (file->f_mode & FMODE_WRITE))
-			goto too_bad;
-	}
-	file_list_unlock();
-	return 1; /* Tis' cool bro. */
-too_bad:
-	file_list_unlock();
-	return 0;
-}
-
 void __init files_init(unsigned long mempages)
 { 
 	int n; 
diff -puN fs/namespace.c~check_mount_writers_at_superblock_remount fs/namespace.c
--- linux-2.6.git/fs/namespace.c~check_mount_writers_at_superblock_remount	2008-04-29 11:56:42.000000000 -0700
+++ linux-2.6.git-dave/fs/namespace.c	2008-04-29 11:56:42.000000000 -0700
@@ -193,7 +193,7 @@ static int __init init_mnt_writers(void)
 }
 fs_initcall(init_mnt_writers);
 
-static void unlock_mnt_writers(void)
+void unlock_mnt_writers(void)
 {
 	int cpu;
 	struct mnt_writer *cpu_writer;
@@ -278,7 +278,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(mnt_want_write);
 
-static void lock_mnt_writers(void)
+void lock_mnt_writers(void)
 {
 	int cpu;
 	struct mnt_writer *cpu_writer;
diff -puN fs/super.c~check_mount_writers_at_superblock_remount fs/super.c
--- linux-2.6.git/fs/super.c~check_mount_writers_at_superblock_remount	2008-04-29 11:56:42.000000000 -0700
+++ linux-2.6.git-dave/fs/super.c	2008-04-29 11:56:42.000000000 -0700
@@ -36,6 +36,7 @@
 #include <linux/writeback.h>		/* for the emergency remount stuff */
 #include <linux/idr.h>
 #include <linux/kobject.h>
+#include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/file.h>
 #include <asm/uaccess.h>
@@ -598,6 +599,32 @@ retry:
 }
 
 /**
+ *	__sb_can_remount_ro - check a superblock for active writers
+ *	@sb: superblock in question
+ *
+ *	Must ensure that no new writers to the superblock can come
+ *	in (must hold lock_mnt_writers()) and that the s_vfsmounts
+ *	list can not change (must acquire lock_super()).
+ *
+ *	Returns 0 on success.
+ */
+static int __sb_can_remount_ro(struct super_block *sb)
+{
+	struct list_head *entry;
+	int ret = 0;
+
+	list_for_each(entry, &sb->s_vfsmounts) {
+		struct vfsmount *mnt;
+		mnt = list_entry(entry, struct vfsmount, mnt_sb_list);
+		if (!atomic_read(&mnt->__mnt_writers))
+			continue;
+		ret = -EBUSY;
+		break;
+	}
+	return ret;
+}
+
+/**
  *	do_remount_sb - asks filesystem to change mount options.
  *	@sb:	superblock in question
  *	@flags:	numeric part of options
@@ -608,8 +635,9 @@ retry:
  */
 int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 {
-	int retval;
+	int retval = 0;
 	int remount_rw;
+	int sb_locked = 0;
 	
 #ifdef CONFIG_BLOCK
 	if (!(flags & MS_RDONLY) && bdev_read_only(sb->s_bdev))
@@ -623,27 +651,44 @@ int do_remount_sb(struct super_block *sb
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */
 	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
-		if (force)
+		if (force) {
 			mark_files_ro(sb);
-		else if (!fs_may_remount_ro(sb))
-			return -EBUSY;
+		} else {
+			lock_mnt_writers();
+			/*
+			 * this locks out any new writers
+			 * on any of this sb's mounts.
+			 */
+			lock_super(sb);
+			sb_locked = 1;
+			retval = __sb_can_remount_ro(sb);
+			unlock_mnt_writers();
+			if (retval)
+				goto out;
+		}
 		retval = DQUOT_OFF(sb, 1);
-		if (retval < 0 && retval != -ENOSYS)
-			return -EBUSY;
+		if (retval < 0 && retval != -ENOSYS) {
+			retval = -EBUSY;
+			goto out;
+		}
 	}
 	remount_rw = !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
 
 	if (sb->s_op->remount_fs) {
-		lock_super(sb);
+		if (!sb_locked)
+			lock_super(sb);
+		sb_locked = 1;
 		retval = sb->s_op->remount_fs(sb, &flags, data);
-		unlock_super(sb);
 		if (retval)
-			return retval;
+			goto out;
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
 	if (remount_rw)
 		DQUOT_ON_REMOUNT(sb);
-	return 0;
+out:
+	if (sb_locked)
+		unlock_super(sb);
+	return retval;
 }
 
 static void do_emergency_remount(unsigned long foo)
diff -puN include/linux/fs.h~check_mount_writers_at_superblock_remount include/linux/fs.h
--- linux-2.6.git/include/linux/fs.h~check_mount_writers_at_superblock_remount	2008-04-29 11:56:42.000000000 -0700
+++ linux-2.6.git-dave/include/linux/fs.h	2008-04-29 11:56:42.000000000 -0700
@@ -1699,8 +1699,6 @@ extern const struct file_operations read
 extern const struct file_operations write_fifo_fops;
 extern const struct file_operations rdwr_fifo_fops;
 
-extern int fs_may_remount_ro(struct super_block *);
-
 #ifdef CONFIG_BLOCK
 /*
  * return READ, READA, or WRITE
diff -puN include/linux/mount.h~check_mount_writers_at_superblock_remount include/linux/mount.h
--- linux-2.6.git/include/linux/mount.h~check_mount_writers_at_superblock_remount	2008-04-29 11:56:42.000000000 -0700
+++ linux-2.6.git-dave/include/linux/mount.h	2008-04-29 11:56:42.000000000 -0700
@@ -69,8 +69,12 @@ struct vfsmount {
 	int mnt_pinned;
 	int mnt_ghosts;
 	/*
-	 * This value is not stable unless all of the mnt_writers[] spinlocks
-	 * are held, and all mnt_writer[]s on this mount have 0 as their ->count
+	 * This value is stable for all mounts when all of the
+	 * mnt_writers[] spinlocks are held.
+	 *
+	 * It is stable for all mounts of an sb when a lock_super()
+	 * is performed under a lock_mnt_writers() as long as the
+	 * sb stays locked.  See do_remount_sb(). - Dave Hansen
 	 */
 	atomic_t __mnt_writers;
 };
@@ -84,6 +88,8 @@ static inline struct vfsmount *mntget(st
 
 extern int mnt_want_write(struct vfsmount *mnt);
 extern void mnt_drop_write(struct vfsmount *mnt);
+extern void lock_mnt_writers(void);
+extern void unlock_mnt_writers(void);
 extern void mntput_no_expire(struct vfsmount *mnt);
 extern void mnt_pin(struct vfsmount *mnt);
 extern void mnt_unpin(struct vfsmount *mnt);
_
