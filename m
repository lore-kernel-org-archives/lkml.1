Return-Path: <linux-kernel-owner+w=401wt.eu-S1759184AbYAJTId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbYAJTId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYAJTH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:07:28 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56829 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757873AbYAJTHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:07:24 -0500
Subject: [RFC][PATCH 4/4] check mount writers at superblock remount
To: linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, hch@infradead.org, serue@us.ibm.com,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 10 Jan 2008 11:07:02 -0800
References: <20080110190657.92A8B61F@kernel>
In-Reply-To: <20080110190657.92A8B61F@kernel>
Message-Id: <20080110190702.72D6BB95@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We're moving a big chunk of the burden of keeping people from
writing to r/o filesystems from the superblock into the
vfsmount.  This requires that we keep track somehow of the
mounts that might allow writes to a superblock.

You could track this directly by keeping a count of such
mounts in the superblock, but I think this is much simpler.

Introduce a list of vfsmounts hanging off the superblock.
On remount rw->ro operations, consult each mount of the
superblock and examine its __mnt_writers.  Lock out any
new writers to the mount until the remount operation is
complete.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/namespace.c        |   28 ++++++++++++++
 linux-2.6.git-dave/fs/super.c            |   58 ++++++++++++++++++++++++++++---
 linux-2.6.git-dave/include/linux/fs.h    |    1 
 linux-2.6.git-dave/include/linux/mount.h |    3 +
 4 files changed, 85 insertions(+), 5 deletions(-)

diff -puN fs/namespace.c~25-24-reintroduce-list-of-vfsmounts-over-superblock fs/namespace.c
--- linux-2.6.git/fs/namespace.c~25-24-reintroduce-list-of-vfsmounts-over-superblock	2008-01-10 10:46:08.000000000 -0800
+++ linux-2.6.git-dave/fs/namespace.c	2008-01-10 10:46:08.000000000 -0800
@@ -219,6 +219,21 @@ static void lock_and_coalesce_cpu_mnt_wr
 }
 
 /*
+ * These are just some shorter names for
+ * external users.
+ *
+ * Note that this nests outside lock_super().
+ */
+void lock_mnt_writers(void)
+{
+	lock_and_coalesce_cpu_mnt_writer_counts();
+}
+void unlock_mnt_writers(void)
+{
+	mnt_unlock_cpus();
+}
+
+/*
  * These per-cpu write counts are not guaranteed to have
  * matched increments and decrements on any given cpu.
  * A file open()ed for write on one cpu and close()d on
@@ -331,10 +346,18 @@ static void __mnt_unmake_readonly(struct
 	mnt->mnt_flags &= ~MNT_READONLY;
 }
 
+void add_mount_to_sb_list(struct vfsmount *mnt, struct super_block *sb)
+{
+	spin_lock(&vfsmount_lock);
+	list_add(&mnt->mnt_sb_list, &sb->s_vfsmounts);
+	spin_unlock(&vfsmount_lock);
+}
+
 int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
 	mnt->mnt_root = dget(sb->s_root);
+	add_mount_to_sb_list(mnt, sb);
 	return 0;
 }
 
@@ -342,6 +365,10 @@ EXPORT_SYMBOL(simple_set_mnt);
 
 void free_vfsmnt(struct vfsmount *mnt)
 {
+	spin_lock(&vfsmount_lock);
+	if (mnt->mnt_sb)
+		list_del(&mnt->mnt_sb_list);
+	spin_unlock(&vfsmount_lock);
 	kfree(mnt->mnt_devname);
 	kmem_cache_free(mnt_cache, mnt);
 }
@@ -494,6 +521,7 @@ static struct vfsmount *clone_mnt(struct
 		simple_set_mnt(mnt, sb);
 		mnt->mnt_mountpoint = mnt->mnt_root;
 		mnt->mnt_parent = mnt;
+		add_mount_to_sb_list(mnt, sb);
 
 		if (flag & CL_SLAVE) {
 			list_add(&mnt->mnt_slave, &old->mnt_slave_list);
diff -puN fs/super.c~25-24-reintroduce-list-of-vfsmounts-over-superblock fs/super.c
--- linux-2.6.git/fs/super.c~25-24-reintroduce-list-of-vfsmounts-over-superblock	2008-01-10 10:46:08.000000000 -0800
+++ linux-2.6.git-dave/fs/super.c	2008-01-10 10:46:08.000000000 -0800
@@ -36,6 +36,7 @@
 #include <linux/writeback.h>		/* for the emergency remount stuff */
 #include <linux/idr.h>
 #include <linux/kobject.h>
+#include <linux/list.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
 
@@ -65,6 +66,7 @@ static struct super_block *alloc_super(s
 		INIT_LIST_HEAD(&s->s_io);
 		INIT_LIST_HEAD(&s->s_more_io);
 		INIT_LIST_HEAD(&s->s_files);
+		INIT_LIST_HEAD(&s->s_vfsmounts);
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
@@ -575,6 +577,34 @@ static void mark_files_ro(struct super_b
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
+	lock_super(sb);
+	list_for_each(entry, &sb->s_vfsmounts) {
+		struct vfsmount *mnt;
+		mnt = list_entry(entry, struct vfsmount, mnt_sb_list);
+		if (!atomic_read(&mnt->__mnt_writers))
+			continue;
+		ret = -EBUSY;
+		break;
+	}
+	unlock_super(sb);
+	return ret;
+}
+
+/**
  *	do_remount_sb - asks filesystem to change mount options.
  *	@sb:	superblock in question
  *	@flags:	numeric part of options
@@ -585,6 +615,7 @@ static void mark_files_ro(struct super_b
  */
 int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 {
+	int mnt_writers_locked = 0;
 	int retval;
 	
 #ifdef CONFIG_BLOCK
@@ -599,10 +630,19 @@ int do_remount_sb(struct super_block *sb
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */
 	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
-		if (force)
+		if (force) {
 			mark_files_ro(sb);
-		else if (!fs_may_remount_ro(sb))
-			return -EBUSY;
+		} else {
+			/*
+			 * keeps new mnt writers out until
+			 * we can set the sb r/o flag
+			 */
+			lock_mnt_writers();
+			mnt_writers_locked = 1;
+			retval = __sb_can_remount_ro(sb);
+			if (retval)
+				goto out;
+		}
 	}
 
 	if (sb->s_op->remount_fs) {
@@ -610,10 +650,18 @@ int do_remount_sb(struct super_block *sb
 		retval = sb->s_op->remount_fs(sb, &flags, data);
 		unlock_super(sb);
 		if (retval)
-			return retval;
+			goto out;
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
-	return 0;
+out:
+	/*
+	 * This must stay locked until after the s_flags are
+	 * set because the flag will also lock out any new
+	 * writers.
+	 */
+	if (mnt_writers_locked)
+		unlock_mnt_writers();
+	return retval;
 }
 
 static void do_emergency_remount(unsigned long foo)
diff -puN include/linux/fs.h~25-24-reintroduce-list-of-vfsmounts-over-superblock include/linux/fs.h
--- linux-2.6.git/include/linux/fs.h~25-24-reintroduce-list-of-vfsmounts-over-superblock	2008-01-10 10:46:08.000000000 -0800
+++ linux-2.6.git-dave/include/linux/fs.h	2008-01-10 10:46:08.000000000 -0800
@@ -1012,6 +1012,7 @@ struct super_block {
 	struct list_head	s_io;		/* parked for writeback */
 	struct list_head	s_more_io;	/* parked for more writeback */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
+	struct list_head	s_vfsmounts;
 	struct list_head	s_files;
 
 	struct block_device	*s_bdev;
diff -puN include/linux/mount.h~25-24-reintroduce-list-of-vfsmounts-over-superblock include/linux/mount.h
--- linux-2.6.git/include/linux/mount.h~25-24-reintroduce-list-of-vfsmounts-over-superblock	2008-01-10 10:46:08.000000000 -0800
+++ linux-2.6.git-dave/include/linux/mount.h	2008-01-10 10:46:08.000000000 -0800
@@ -44,6 +44,7 @@ struct vfsmount {
 	struct dentry *mnt_mountpoint;	/* dentry of mountpoint */
 	struct dentry *mnt_root;	/* root of the mounted tree */
 	struct super_block *mnt_sb;	/* pointer to superblock */
+	struct list_head mnt_sb_list;	/* list of all mounts on same sb */
 	struct list_head mnt_mounts;	/* list of children, anchored here */
 	struct list_head mnt_child;	/* and going through their mnt_child */
 	int mnt_flags;
@@ -80,6 +81,8 @@ static inline struct vfsmount *mntget(st
 
 extern int mnt_want_write(struct vfsmount *mnt);
 extern void mnt_drop_write(struct vfsmount *mnt);
+extern void lock_mnt_writers(void);
+extern void unlock_mnt_writers(void);
 extern void mntput_no_expire(struct vfsmount *mnt);
 extern void mnt_pin(struct vfsmount *mnt);
 extern void mnt_unpin(struct vfsmount *mnt);
diff -puN fs/xfs/xfs_inode.c~25-24-reintroduce-list-of-vfsmounts-over-superblock fs/xfs/xfs_inode.c
diff -puN fs/dquot.c~25-24-reintroduce-list-of-vfsmounts-over-superblock fs/dquot.c
_
