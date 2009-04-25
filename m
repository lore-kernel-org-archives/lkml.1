Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbZDYB3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbZDYB3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZDYB2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:28:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbZDYB2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:28:48 -0400
Message-Id: <20090425012209.213810410@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sat, 25 Apr 2009 11:20:22 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 02/27] fs: scale files_lock
References: <20090425012020.457460929@suse.de>
Content-Disposition: inline; filename=fs-files_lock-scale.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve scalability of files_lock by adding per-cpu, per-sb files lists,
protected with per-cpu locking. Effectively turning it into a big-writer
lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/file_table.c    |  159 +++++++++++++++++++++++++++++++++++++++--------------
 fs/super.c         |   16 +++++
 include/linux/fs.h |    7 ++
 3 files changed, 141 insertions(+), 41 deletions(-)

Index: linux-2.6/fs/file_table.c
===================================================================
--- linux-2.6.orig/fs/file_table.c
+++ linux-2.6/fs/file_table.c
@@ -22,6 +22,7 @@
 #include <linux/fsnotify.h>
 #include <linux/sysctl.h>
 #include <linux/percpu_counter.h>
+#include <linux/percpu.h>
 
 #include <asm/atomic.h>
 
@@ -30,7 +31,7 @@ struct files_stat_struct files_stat = {
 	.max_files = NR_FILE
 };
 
-static __cacheline_aligned_in_smp DEFINE_SPINLOCK(files_lock);
+static DEFINE_PER_CPU(spinlock_t, files_cpulock);
 
 /* SLAB cache for file structures */
 static struct kmem_cache *filp_cachep __read_mostly;
@@ -124,6 +125,9 @@ struct file *get_empty_filp(void)
 		goto fail_sec;
 
 	INIT_LIST_HEAD(&f->f_u.fu_list);
+#ifdef CONFIG_SMP
+	f->f_sb_list_cpu = -1;
+#endif
 	atomic_long_set(&f->f_count, 1);
 	rwlock_init(&f->f_owner.lock);
 	f->f_cred = get_cred(cred);
@@ -357,42 +361,102 @@ void put_filp(struct file *file)
 
 void file_sb_list_add(struct file *file, struct super_block *sb)
 {
-	spin_lock(&files_lock);
+	spinlock_t *lock;
+	struct list_head *list;
+	int cpu;
+
+	lock = &get_cpu_var(files_cpulock);
+#ifdef CONFIG_SMP
+	BUG_ON(file->f_sb_list_cpu != -1);
+	cpu = smp_processor_id();
+	list = per_cpu_ptr(sb->s_files, cpu);
+	file->f_sb_list_cpu = cpu;
+#else
+	list = &sb->s_files;
+#endif
+	spin_lock(lock);
 	BUG_ON(!list_empty(&file->f_u.fu_list));
-	list_add(&file->f_u.fu_list, &sb->s_files);
-	spin_unlock(&files_lock);
+	list_add(&file->f_u.fu_list, list);
+	spin_unlock(lock);
+	put_cpu_var(files_cpulock);
 }
 
 void file_list_del(struct file *file)
 {
 	if (!list_empty(&file->f_u.fu_list)) {
-		spin_lock(&files_lock);
+		spinlock_t *lock;
+
+#ifdef CONFIG_SMP
+		BUG_ON(file->f_sb_list_cpu == -1);
+		lock = &per_cpu(files_cpulock, file->f_sb_list_cpu);
+		file->f_sb_list_cpu = -1;
+#else
+		lock = &__get_cpu_var(files_cpulock);
+#endif
+		spin_lock(lock);
 		list_del_init(&file->f_u.fu_list);
-		spin_unlock(&files_lock);
+		spin_unlock(lock);
+	}
+}
+
+static void file_list_lock_all(void)
+{
+	int i;
+	int nr = 0;
+
+	for_each_possible_cpu(i) {
+		spinlock_t *lock;
+
+		lock = &per_cpu(files_cpulock, i);
+		spin_lock_nested(lock, nr);
+		nr++;
+	}
+}
+
+static void file_list_unlock_all(void)
+{
+	int i;
+
+	for_each_possible_cpu(i) {
+		spinlock_t *lock;
+
+		lock = &per_cpu(files_cpulock, i);
+		spin_unlock(lock);
 	}
 }
 
 int fs_may_remount_ro(struct super_block *sb)
 {
-	struct file *file;
+	int i;
 
 	/* Check that no files are currently opened for writing. */
-	spin_lock(&files_lock);
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
+	file_list_lock_all();
+	for_each_possible_cpu(i) {
+		struct file *file;
+		struct list_head *list;
+
+#ifdef CONFIG_SMP
+		list = per_cpu_ptr(sb->s_files, i);
+#else
+		list = &sb->s_files;
+#endif
+		list_for_each_entry(file, list, f_u.fu_list) {
+			struct inode *inode = file->f_path.dentry->d_inode;
+
+			/* File with pending delete? */
+			if (inode->i_nlink == 0)
+				goto too_bad;
+
+			/* Writeable file? */
+			if (S_ISREG(inode->i_mode) &&
+					(file->f_mode & FMODE_WRITE))
+				goto too_bad;
+		}
 	}
-	spin_unlock(&files_lock);
+	file_list_unlock_all();
 	return 1; /* Tis' cool bro. */
 too_bad:
-	spin_unlock(&files_lock);
+	file_list_unlock_all();
 	return 0;
 }
 
@@ -405,35 +469,46 @@ too_bad:
  */
 void mark_files_ro(struct super_block *sb)
 {
-	struct file *f;
+	int i;
 
 retry:
-	spin_lock(&files_lock);
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
-		/* This can sleep, so we can't hold the spinlock. */
-		spin_unlock(&files_lock);
-		mnt_drop_write(mnt);
-		mntput(mnt);
-		goto retry;
+	file_list_lock_all();
+	for_each_possible_cpu(i) {
+		struct file *f;
+		struct list_head *list;
+
+#ifdef CONFIG_SMP
+		list = per_cpu_ptr(sb->s_files, i);
+#else
+		list = &sb->s_files;
+#endif
+		list_for_each_entry(f, list, f_u.fu_list) {
+			struct vfsmount *mnt;
+			if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
+			       continue;
+			if (!file_count(f))
+				continue;
+			if (!(f->f_mode & FMODE_WRITE))
+				continue;
+			f->f_mode &= ~FMODE_WRITE;
+			if (file_check_writeable(f) != 0)
+				continue;
+			file_release_write(f);
+			mnt = mntget(f->f_path.mnt);
+			/* This can sleep, so we can't hold the spinlock. */
+			file_list_unlock_all();
+			mnt_drop_write(mnt);
+			mntput(mnt);
+			goto retry;
+		}
 	}
-	spin_unlock(&files_lock);
+	file_list_unlock_all();
 }
 
 void __init files_init(unsigned long mempages)
 { 
 	int n; 
+	int i;
 
 	filp_cachep = kmem_cache_create("filp", sizeof(struct file), 0,
 			SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
@@ -448,5 +523,7 @@ void __init files_init(unsigned long mem
 	if (files_stat.max_files < NR_FILE)
 		files_stat.max_files = NR_FILE;
 	files_defer_init();
+	for_each_possible_cpu(i)
+		spin_lock_init(&per_cpu(files_cpulock, i));
 	percpu_counter_init(&nr_files, 0);
 } 
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c
+++ linux-2.6/fs/super.c
@@ -67,7 +67,23 @@ static struct super_block *alloc_super(s
 		INIT_LIST_HEAD(&s->s_dirty);
 		INIT_LIST_HEAD(&s->s_io);
 		INIT_LIST_HEAD(&s->s_more_io);
+#ifdef CONFIG_SMP
+		s->s_files = alloc_percpu(struct list_head);
+		if (!s->s_files) {
+			security_sb_free(s);
+			kfree(s);
+			s = NULL;
+			goto out;
+		} else {
+			int i;
+
+			for_each_possible_cpu(i)
+				INIT_LIST_HEAD(per_cpu_ptr(s->s_files, i));
+		}
+#else
 		INIT_LIST_HEAD(&s->s_files);
+#endif
+
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -910,6 +910,9 @@ struct file {
 #define f_vfsmnt	f_path.mnt
 	const struct file_operations	*f_op;
 	spinlock_t		f_lock;  /* f_ep_links, f_flags, no IRQ */
+#ifdef CONFIG_SMP
+	int			f_sb_list_cpu;
+#endif
 	atomic_long_t		f_count;
 	unsigned int 		f_flags;
 	fmode_t			f_mode;
@@ -1330,7 +1333,11 @@ struct super_block {
 	struct list_head	s_io;		/* parked for writeback */
 	struct list_head	s_more_io;	/* parked for more writeback */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
+#ifdef CONFIG_SMP
+	struct list_head	*s_files;
+#else
 	struct list_head	s_files;
+#endif
 	/* s_dentry_lru and s_nr_dentry_unused are protected by dcache_lock */
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	int			s_nr_dentry_unused;	/* # of dentry on lru */


