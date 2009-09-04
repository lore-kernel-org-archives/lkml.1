Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbZIDG66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbZIDG66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 02:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933000AbZIDG64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 02:58:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:56545 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671AbZIDG6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:58:37 -0400
Message-Id: <20090904065534.447753909@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 04 Sep 2009 16:51:45 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 04/33] fs: brlock vfsmount_lock
References: <20090904065142.114706411@nick.local0.net>
Content-Disposition: inline; filename=fs-vfsmount_lock-scale.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a brlock for the vfsmount lock.
---
 fs/dcache.c                |    4 
 fs/namei.c                 |   13 +-
 fs/namespace.c             |  201 ++++++++++++++++++++++++++++++---------------
 fs/pnode.c                 |    4 
 fs/proc/base.c             |    4 
 include/linux/mount.h      |    6 +
 kernel/audit_tree.c        |    6 -
 security/tomoyo/realpath.c |    4 
 8 files changed, 161 insertions(+), 81 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -1908,7 +1908,7 @@ char *__d_path(const struct path *path,
 	char *end = buffer + buflen;
 	char *retval;
 
-	spin_lock(&vfsmount_lock);
+	vfsmount_read_lock();
 	prepend(&end, &buflen, "\0", 1);
 	if (d_unlinked(dentry) &&
 		(prepend(&end, &buflen, " (deleted)", 10) != 0))
@@ -1944,7 +1944,7 @@ char *__d_path(const struct path *path,
 	}
 
 out:
-	spin_unlock(&vfsmount_lock);
+	vfsmount_read_unlock();
 	return retval;
 
 global_root:
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -679,15 +679,16 @@ int follow_up(struct path *path)
 {
 	struct vfsmount *parent;
 	struct dentry *mountpoint;
-	spin_lock(&vfsmount_lock);
+
+	vfsmount_read_unlock();
 	parent = path->mnt->mnt_parent;
 	if (parent == path->mnt) {
-		spin_unlock(&vfsmount_lock);
+		vfsmount_read_unlock();
 		return 0;
 	}
 	mntget(parent);
 	mountpoint = dget(path->mnt->mnt_mountpoint);
-	spin_unlock(&vfsmount_lock);
+	vfsmount_read_unlock();
 	dput(path->dentry);
 	path->dentry = mountpoint;
 	mntput(path->mnt);
@@ -766,15 +767,15 @@ static __always_inline void follow_dotdo
 			break;
 		}
 		spin_unlock(&dcache_lock);
-		spin_lock(&vfsmount_lock);
+		vfsmount_read_lock();
 		parent = nd->path.mnt->mnt_parent;
 		if (parent == nd->path.mnt) {
-			spin_unlock(&vfsmount_lock);
+			vfsmount_read_unlock();
 			break;
 		}
 		mntget(parent);
 		nd->path.dentry = dget(nd->path.mnt->mnt_mountpoint);
-		spin_unlock(&vfsmount_lock);
+		vfsmount_read_unlock();
 		dput(old);
 		mntput(nd->path.mnt);
 		nd->path.mnt = parent;
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c
+++ linux-2.6/fs/namespace.c
@@ -11,6 +11,8 @@
 #include <linux/syscalls.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/percpu.h>
 #include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -37,12 +39,16 @@
 #define HASH_SHIFT ilog2(PAGE_SIZE / sizeof(struct list_head))
 #define HASH_SIZE (1UL << HASH_SHIFT)
 
-/* spinlock for vfsmount related operations, inplace of dcache_lock */
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(vfsmount_lock);
+/*
+ * vfsmount "brlock" style spinlock for vfsmount related operations, use
+ * vfsmount_read_lock/vfsmount_write_lock functions.
+ */
+static DEFINE_PER_CPU(spinlock_t, vfsmount_lock);
 
 static int event;
 static DEFINE_IDA(mnt_id_ida);
 static DEFINE_IDA(mnt_group_ida);
+static DEFINE_SPINLOCK(mnt_id_lock);
 static int mnt_id_start = 0;
 static int mnt_group_start = 1;
 
@@ -54,6 +60,49 @@ static struct rw_semaphore namespace_sem
 struct kobject *fs_kobj;
 EXPORT_SYMBOL_GPL(fs_kobj);
 
+void vfsmount_read_lock(void)
+{
+	spinlock_t *lock;
+
+	lock = &get_cpu_var(vfsmount_lock);
+	spin_lock(lock);
+}
+
+void vfsmount_read_unlock(void)
+{
+	spinlock_t *lock;
+
+	lock = &__get_cpu_var(vfsmount_lock);
+	spin_unlock(lock);
+	put_cpu_var(vfsmount_lock);
+}
+
+void vfsmount_write_lock(void)
+{
+	int i;
+	int nr = 0;
+
+	for_each_possible_cpu(i) {
+		spinlock_t *lock;
+
+		lock = &per_cpu(vfsmount_lock, i);
+		spin_lock_nested(lock, nr);
+		nr++;
+	}
+}
+
+void vfsmount_write_unlock(void)
+{
+	int i;
+
+	for_each_possible_cpu(i) {
+		spinlock_t *lock;
+
+		lock = &per_cpu(vfsmount_lock, i);
+		spin_unlock(lock);
+	}
+}
+
 static inline unsigned long hash(struct vfsmount *mnt, struct dentry *dentry)
 {
 	unsigned long tmp = ((unsigned long)mnt / L1_CACHE_BYTES);
@@ -64,18 +113,21 @@ static inline unsigned long hash(struct
 
 #define MNT_WRITER_UNDERFLOW_LIMIT -(1<<16)
 
-/* allocation is serialized by namespace_sem */
+/*
+ * allocation is serialized by namespace_sem, but we need the spinlock to
+ * serialise with freeing.
+ */
 static int mnt_alloc_id(struct vfsmount *mnt)
 {
 	int res;
 
 retry:
 	ida_pre_get(&mnt_id_ida, GFP_KERNEL);
-	spin_lock(&vfsmount_lock);
+	spin_lock(&mnt_id_lock);
 	res = ida_get_new_above(&mnt_id_ida, mnt_id_start, &mnt->mnt_id);
 	if (!res)
 		mnt_id_start = mnt->mnt_id + 1;
-	spin_unlock(&vfsmount_lock);
+	spin_unlock(&mnt_id_lock);
 	if (res == -EAGAIN)
 		goto retry;
 
@@ -85,11 +137,11 @@ retry:
 static void mnt_free_id(struct vfsmount *mnt)
 {
 	int id = mnt->mnt_id;
-	spin_lock(&vfsmount_lock);
+	spin_lock(&mnt_id_lock);
 	ida_remove(&mnt_id_ida, id);
 	if (mnt_id_start > id)
 		mnt_id_start = id;
-	spin_unlock(&vfsmount_lock);
+	spin_unlock(&mnt_id_lock);
 }
 
 /*
@@ -344,7 +396,7 @@ static int mnt_make_readonly(struct vfsm
 {
 	int ret = 0;
 
-	spin_lock(&vfsmount_lock);
+	vfsmount_write_lock();
 	mnt->mnt_flags |= MNT_WRITE_HOLD;
 	/*
 	 * After storing MNT_WRITE_HOLD, we'll read the counters. This store
@@ -378,15 +430,15 @@ static int mnt_make_readonly(struct vfsm
 	 */
 	smp_wmb();
 	mnt->mnt_flags &= ~MNT_WRITE_HOLD;
-	spin_unlock(&vfsmount_lock);
+	vfsmount_write_unlock();
 	return ret;
 }
 
 static void __mnt_unmake_readonly(struct vfsmount *mnt)
 {
-	spin_lock(&vfsmount_lock);
+	vfsmount_write_lock();
 	mnt->mnt_flags &= ~MNT_READONLY;
-	spin_unlock(&vfsmount_lock);
+	vfsmount_write_unlock();
 }
 
 void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
@@ -439,10 +491,11 @@ struct vfsmount *__lookup_mnt(struct vfs
 struct vfsmount *lookup_mnt(struct path *path)
 {
 	struct vfsmount *child_mnt;
-	spin_lock(&vfsmount_lock);
+
+	vfsmount_read_lock();
 	if ((child_mnt = __lookup_mnt(path->mnt, path->dentry, 1)))
 		mntget(child_mnt);
-	spin_unlock(&vfsmount_lock);
+	vfsmount_read_unlock();
 	return child_mnt;
 }
 
@@ -618,40 +671,47 @@ static inline void __mntput(struct vfsmo
 void mntput_no_expire(struct vfsmount *mnt)
 {
 repeat:
-	if (atomic_dec_and_lock(&mnt->mnt_count, &vfsmount_lock)) {
-		if (likely(!mnt->mnt_pinned)) {
-			spin_unlock(&vfsmount_lock);
-			__mntput(mnt);
-			return;
-		}
-		atomic_add(mnt->mnt_pinned + 1, &mnt->mnt_count);
-		mnt->mnt_pinned = 0;
-		spin_unlock(&vfsmount_lock);
-		acct_auto_close_mnt(mnt);
-		security_sb_umount_close(mnt);
-		goto repeat;
+	/* open-code atomic_dec_and_lock for the vfsmount lock */
+	if (atomic_add_unless(&mnt->mnt_count, -1, 1))
+		return;
+	vfsmount_write_lock();
+	if (!atomic_dec_and_test(&mnt->mnt_count)) {
+		vfsmount_write_unlock();
+		return;
 	}
+
+	if (likely(!mnt->mnt_pinned)) {
+		vfsmount_write_unlock();
+		__mntput(mnt);
+		return;
+	}
+	atomic_add(mnt->mnt_pinned + 1, &mnt->mnt_count);
+	mnt->mnt_pinned = 0;
+	vfsmount_write_unlock();
+	acct_auto_close_mnt(mnt);
+	security_sb_umount_close(mnt);
+	goto repeat;
 }
 
 EXPORT_SYMBOL(mntput_no_expire);
 
 void mnt_pin(struct vfsmount *mnt)
 {
-	spin_lock(&vfsmount_lock);
+	vfsmount_write_lock();
 	mnt->mnt_pinned++;
-	spin_unlock(&vfsmount_lock);
+	vfsmount_write_unlock();
 }
 
 EXPORT_SYMBOL(mnt_pin);
 
 void mnt_unpin(struct vfsmount *mnt)
 {
-	spin_lock(&vfsmount_lock);
+	vfsmount_write_lock();
 	if (mnt->mnt_pinned) {
 		atomic_inc(&mnt->mnt_count);
 		mnt->mnt_pinned--;
 	}
-	spin_unlock(&vfsmount_lock);
+	vfsmount_write_unlock();
 }
 
 EXPORT_SYMBOL(mnt_unpin);
@@ -934,12 +994,12 @@ int may_umount_tree(struct vfsmount *mnt
 	int minimum_refs = 0;
 	struct vfsmount *p;
 
-	spin_lock(&vfsmount_lock);
+	vfsmount_read_lock();
 	for (p = mnt; p; p = next_mnt(p, mnt)) {
 		actual_refs += atomic_read(&p->mnt_count);
 		minimum_refs += 2;
 	}
-	spin_unlock(&vfsmount_lock);
+	vfsmount_read_unlock();
 
 	if (actual_refs > minimum_refs)
 		return 0;
@@ -965,10 +1025,12 @@ EXPORT_SYMBOL(may_umount_tree);
 int may_umount(struct vfsmount *mnt)
 {
 	int ret = 1;
-	spin_lock(&vfsmount_lock);
+
+	vfsmount_read_lock();
 	if (propagate_mount_busy(mnt, 2))
 		ret = 0;
-	spin_unlock(&vfsmount_lock);
+	vfsmount_read_unlock();
+
 	return ret;
 }
 
@@ -983,13 +1045,14 @@ void release_mounts(struct list_head *he
 		if (mnt->mnt_parent != mnt) {
 			struct dentry *dentry;
 			struct vfsmount *m;
-			spin_lock(&vfsmount_lock);
+
+			vfsmount_write_lock();
 			dentry = mnt->mnt_mountpoint;
 			m = mnt->mnt_parent;
 			mnt->mnt_mountpoint = mnt->mnt_root;
 			mnt->mnt_parent = mnt;
 			m->mnt_ghosts--;
-			spin_unlock(&vfsmount_lock);
+			vfsmount_write_unlock();
 			dput(dentry);
 			mntput(m);
 		}
@@ -1087,7 +1150,7 @@ static int do_umount(struct vfsmount *mn
 	}
 
 	down_write(&namespace_sem);
-	spin_lock(&vfsmount_lock);
+	vfsmount_write_lock();
 	event++;
 
 	if (!(flags & MNT_DETACH))
@@ -1099,7 +1162,7 @@ static int do_umount(struct vfsmount *mn
 			umount_tree(mnt, 1, &umount_list);
 		retval = 0;
 	}
-	spin_unlock(&vfsmount_lock);
+	vfsmount_write_unlock();
 	if (retval)
 		security_sb_umount_busy(mnt);
 	up_write(&namespace_sem);
@@ -1206,19 +1269,19 @@ struct vfsmount *copy_tree(struct vfsmou
 			q = clone_mnt(p, p->mnt_root, flag);
 			if (!q)
 				goto Enomem;
-			spin_lock(&vfsmount_lock);
+			vfsmount_write_lock();
 			list_add_tail(&q->mnt_list, &res->mnt_list);
 			attach_mnt(q, &path);
-			spin_unlock(&vfsmount_lock);
+			vfsmount_write_unlock();
 		}
 	}
 	return res;
 Enomem:
 	if (res) {
 		LIST_HEAD(umount_list);
-		spin_lock(&vfsmount_lock);
+		vfsmount_write_lock();
 		umount_tree(res, 0, &umount_list);
-		spin_unlock(&vfsmount_lock);
+		vfsmount_write_unlock();
 		release_mounts(&umount_list);
 	}
 	return NULL;
@@ -1237,9 +1300,9 @@ void drop_collected_mounts(struct vfsmou
 {
 	LIST_HEAD(umount_list);
 	down_write(&namespace_sem);
-	spin_lock(&vfsmount_lock);
+	vfsmount_write_lock();
 	umount_tree(mnt, 0, &umount_list);
-	spin_unlock(&vfsmount_lock);
+	vfsmount_write_unlock();
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
 }
@@ -1357,7 +1420,7 @@ static int attach_recursive_mnt(struct v
 			set_mnt_shared(p);
 	}
 
-	spin_lock(&vfsmount_lock);
+	vfsmount_write_lock();
 	if (parent_path) {
 		detach_mnt(source_mnt, parent_path);
 		attach_mnt(source_mnt, path);
@@ -1371,7 +1434,8 @@ static int attach_recursive_mnt(struct v
 		list_del_init(&child->mnt_hash);
 		commit_tree(child);
 	}
-	spin_unlock(&vfsmount_lock);
+	vfsmount_write_unlock();
+
 	return 0;
 
  out_cleanup_ids:
@@ -1433,10 +1497,10 @@ static int do_change_type(struct path *p
 			goto out_unlock;
 	}
 
-	spin_lock(&vfsmount_lock);
+	vfsmount_write_lock();
 	for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL))
 		change_mnt_propagation(m, type);
-	spin_unlock(&vfsmount_lock);
+	vfsmount_write_unlock();
 
  out_unlock:
 	up_write(&namespace_sem);
@@ -1480,9 +1544,10 @@ static int do_loopback(struct path *path
 	err = graft_tree(mnt, path);
 	if (err) {
 		LIST_HEAD(umount_list);
-		spin_lock(&vfsmount_lock);
+
+		vfsmount_write_lock();
 		umount_tree(mnt, 0, &umount_list);
-		spin_unlock(&vfsmount_lock);
+		vfsmount_write_unlock();
 		release_mounts(&umount_list);
 	}
 
@@ -1540,9 +1605,9 @@ static int do_remount(struct path *path,
 	if (!err) {
 		security_sb_post_remount(path->mnt, flags, data);
 
-		spin_lock(&vfsmount_lock);
+		vfsmount_write_lock();
 		touch_mnt_namespace(path->mnt->mnt_ns);
-		spin_unlock(&vfsmount_lock);
+		vfsmount_write_unlock();
 	}
 	return err;
 }
@@ -1717,7 +1782,7 @@ void mark_mounts_for_expiry(struct list_
 		return;
 
 	down_write(&namespace_sem);
-	spin_lock(&vfsmount_lock);
+	vfsmount_write_lock();
 
 	/* extract from the expiration list every vfsmount that matches the
 	 * following criteria:
@@ -1736,7 +1801,7 @@ void mark_mounts_for_expiry(struct list_
 		touch_mnt_namespace(mnt->mnt_ns);
 		umount_tree(mnt, 1, &umounts);
 	}
-	spin_unlock(&vfsmount_lock);
+	vfsmount_write_unlock();
 	up_write(&namespace_sem);
 
 	release_mounts(&umounts);
@@ -1996,9 +2061,9 @@ static struct mnt_namespace *dup_mnt_ns(
 		kfree(new_ns);
 		return ERR_PTR(-ENOMEM);
 	}
-	spin_lock(&vfsmount_lock);
+	vfsmount_write_lock();
 	list_add_tail(&new_ns->list, &new_ns->root->mnt_list);
-	spin_unlock(&vfsmount_lock);
+	vfsmount_write_unlock();
 
 	/*
 	 * Second pass: switch the tsk->fs->* elements and mark new vfsmounts
@@ -2193,7 +2258,7 @@ SYSCALL_DEFINE2(pivot_root, const char _
 		goto out2; /* not attached */
 	/* make sure we can reach put_old from new_root */
 	tmp = old.mnt;
-	spin_lock(&vfsmount_lock);
+	vfsmount_write_lock();
 	if (tmp != new.mnt) {
 		for (;;) {
 			if (tmp->mnt_parent == tmp)
@@ -2213,7 +2278,7 @@ SYSCALL_DEFINE2(pivot_root, const char _
 	/* mount new_root on / */
 	attach_mnt(new.mnt, &root_parent);
 	touch_mnt_namespace(current->nsproxy->mnt_ns);
-	spin_unlock(&vfsmount_lock);
+	vfsmount_write_unlock();
 	chroot_fs_refs(&root, &new);
 	security_sb_post_pivotroot(&root, &new);
 	error = 0;
@@ -2229,7 +2294,7 @@ out1:
 out0:
 	return error;
 out3:
-	spin_unlock(&vfsmount_lock);
+	vfsmount_write_unlock();
 	goto out2;
 }
 
@@ -2259,6 +2324,7 @@ static void __init init_mount_tree(void)
 void __init mnt_init(void)
 {
 	unsigned u;
+	int i;
 	int err;
 
 	init_rwsem(&namespace_sem);
@@ -2276,6 +2342,9 @@ void __init mnt_init(void)
 	for (u = 0; u < HASH_SIZE; u++)
 		INIT_LIST_HEAD(&mount_hashtable[u]);
 
+	for_each_possible_cpu(i)
+		spin_lock_init(&per_cpu(vfsmount_lock, i));
+
 	err = sysfs_init();
 	if (err)
 		printk(KERN_WARNING "%s: sysfs_init error: %d\n",
@@ -2291,16 +2360,22 @@ void put_mnt_ns(struct mnt_namespace *ns
 {
 	struct vfsmount *root;
 	LIST_HEAD(umount_list);
+	spinlock_t *lock;
 
-	if (!atomic_dec_and_lock(&ns->count, &vfsmount_lock))
+	lock = &get_cpu_var(vfsmount_lock);
+	if (!atomic_dec_and_lock(&ns->count, lock)) {
+		put_cpu_var(vfsmount_lock);
 		return;
+	}
 	root = ns->root;
 	ns->root = NULL;
-	spin_unlock(&vfsmount_lock);
+	spin_unlock(lock);
+	put_cpu_var(vfsmount_lock);
+
 	down_write(&namespace_sem);
-	spin_lock(&vfsmount_lock);
-	umount_tree(root, 0, &umount_list);
-	spin_unlock(&vfsmount_lock);
+	vfsmount_write_lock();
+  	umount_tree(root, 0, &umount_list);
+	vfsmount_write_unlock();
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
 	kfree(ns);
Index: linux-2.6/fs/pnode.c
===================================================================
--- linux-2.6.orig/fs/pnode.c
+++ linux-2.6/fs/pnode.c
@@ -264,12 +264,12 @@ int propagate_mnt(struct vfsmount *dest_
 		prev_src_mnt  = child;
 	}
 out:
-	spin_lock(&vfsmount_lock);
+	vfsmount_write_lock();
 	while (!list_empty(&tmp_list)) {
 		child = list_first_entry(&tmp_list, struct vfsmount, mnt_hash);
 		umount_tree(child, 0, &umount_list);
 	}
-	spin_unlock(&vfsmount_lock);
+	vfsmount_write_unlock();
 	release_mounts(&umount_list);
 	return ret;
 }
Index: linux-2.6/fs/proc/base.c
===================================================================
--- linux-2.6.orig/fs/proc/base.c
+++ linux-2.6/fs/proc/base.c
@@ -652,12 +652,12 @@ static unsigned mounts_poll(struct file
 
 	poll_wait(file, &ns->poll, wait);
 
-	spin_lock(&vfsmount_lock);
+	vfsmount_read_lock();
 	if (p->event != ns->event) {
 		p->event = ns->event;
 		res |= POLLERR | POLLPRI;
 	}
-	spin_unlock(&vfsmount_lock);
+	vfsmount_read_unlock();
 
 	return res;
 }
Index: linux-2.6/include/linux/mount.h
===================================================================
--- linux-2.6.orig/include/linux/mount.h
+++ linux-2.6/include/linux/mount.h
@@ -90,6 +90,11 @@ static inline struct vfsmount *mntget(st
 
 struct file; /* forward dec */
 
+extern void vfsmount_read_lock(void);
+extern void vfsmount_read_unlock(void);
+extern void vfsmount_write_lock(void);
+extern void vfsmount_write_unlock(void);
+
 extern int mnt_want_write(struct vfsmount *mnt);
 extern int mnt_want_write_file(struct file *file);
 extern int mnt_clone_write(struct vfsmount *mnt);
@@ -123,7 +128,6 @@ extern int do_add_mount(struct vfsmount
 
 extern void mark_mounts_for_expiry(struct list_head *mounts);
 
-extern spinlock_t vfsmount_lock;
 extern dev_t name_to_dev_t(char *name);
 
 #endif /* _LINUX_MOUNT_H */
Index: linux-2.6/kernel/audit_tree.c
===================================================================
--- linux-2.6.orig/kernel/audit_tree.c
+++ linux-2.6/kernel/audit_tree.c
@@ -758,15 +758,15 @@ int audit_tag_tree(char *old, char *new)
 			continue;
 		}
 
-		spin_lock(&vfsmount_lock);
+		vfsmount_read_lock();
 		if (!is_under(mnt, dentry, &path)) {
-			spin_unlock(&vfsmount_lock);
+			vfsmount_read_unlock();
 			path_put(&path);
 			put_tree(tree);
 			mutex_lock(&audit_filter_mutex);
 			continue;
 		}
-		spin_unlock(&vfsmount_lock);
+		vfsmount_read_unlock();
 		path_put(&path);
 
 		list_for_each_entry(p, &list, mnt_list) {
Index: linux-2.6/security/tomoyo/realpath.c
===================================================================
--- linux-2.6.orig/security/tomoyo/realpath.c
+++ linux-2.6/security/tomoyo/realpath.c
@@ -96,12 +96,12 @@ int tomoyo_realpath_from_path2(struct pa
 		root = current->fs->root;
 		path_get(&root);
 		read_unlock(&current->fs->lock);
-		spin_lock(&vfsmount_lock);
+		vfsmount_read_lock();
 		if (root.mnt && root.mnt->mnt_ns)
 			ns_root.mnt = mntget(root.mnt->mnt_ns->root);
 		if (ns_root.mnt)
 			ns_root.dentry = dget(ns_root.mnt->mnt_root);
-		spin_unlock(&vfsmount_lock);
+		vfsmount_read_unlock();
 		spin_lock(&dcache_lock);
 		tmp = ns_root;
 		sp = __d_path(path, &tmp, newname, newname_len);


