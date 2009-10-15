Return-Path: <linux-kernel-owner+w=401wt.eu-S934689AbZJOGGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934689AbZJOGGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934555AbZJOGGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:06:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:35370 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933964AbZJOGE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:04:58 -0400
Message-Id: <20091015050049.074396070@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Thu, 15 Oct 2009 15:40:31 +1100
From: npiggin@suse.de
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [patch 5/6] fs: brlock vfsmount_lock
References: <20091015044026.319860788@suse.de>
Content-Disposition: inline; filename=fs-vfsmount_lock-scale-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a brlock for the vfsmount lock. It must be taken for write whenever
modifying the mount hash or associated fields, and may be taken for read
when performing mount hash lookups.

On a 64 core, 64 socket, 32 node Altix system (so a decent amount of
latency for remote nodes), a simple dumb mount microbenchmark
(mount --bind mnt mnt2 ; umount mnt2 loop 1000 times), before this patch
it took 6.8s, afterwards took 7.1s, or about 5% increase in time.

Number of atomics should remain the same for fastpath rlock cases, though
code will be slightly larger due to per-cpu access. Scalability will
probably not be incredibly improved in common cases yet, due to other locks
getting in the way. However independent path lookups over mountpoints should
be one case where scalability is improved.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/dcache.c                |    4 -
 fs/namei.c                 |   13 +--
 fs/namespace.c             |  178 ++++++++++++++++++++++++++++-----------------
 fs/pnode.c                 |   11 ++
 fs/proc/base.c             |    4 -
 include/linux/mount.h      |    4 -
 kernel/audit_tree.c        |    6 -
 security/tomoyo/realpath.c |    4 -
 8 files changed, 141 insertions(+), 83 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -1908,7 +1908,7 @@ char *__d_path(const struct path *path,
 	char *end = buffer + buflen;
 	char *retval;
 
-	spin_lock(&vfsmount_lock);
+	vfsmount_rlock();
 	prepend(&end, &buflen, "\0", 1);
 	if (d_unlinked(dentry) &&
 		(prepend(&end, &buflen, " (deleted)", 10) != 0))
@@ -1944,7 +1944,7 @@ char *__d_path(const struct path *path,
 	}
 
 out:
-	spin_unlock(&vfsmount_lock);
+	vfsmount_runlock();
 	return retval;
 
 global_root:
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -685,15 +685,16 @@ int follow_up(struct path *path)
 {
 	struct vfsmount *parent;
 	struct dentry *mountpoint;
-	spin_lock(&vfsmount_lock);
+
+	vfsmount_rlock();
 	parent = path->mnt->mnt_parent;
 	if (parent == path->mnt) {
-		spin_unlock(&vfsmount_lock);
+		vfsmount_runlock();
 		return 0;
 	}
 	mntget(parent);
 	mountpoint = dget(path->mnt->mnt_mountpoint);
-	spin_unlock(&vfsmount_lock);
+	vfsmount_runlock();
 	dput(path->dentry);
 	path->dentry = mountpoint;
 	mntput(path->mnt);
@@ -772,15 +773,15 @@ static __always_inline void follow_dotdo
 			break;
 		}
 		spin_unlock(&dcache_lock);
-		spin_lock(&vfsmount_lock);
+		vfsmount_rlock();
 		parent = nd->path.mnt->mnt_parent;
 		if (parent == nd->path.mnt) {
-			spin_unlock(&vfsmount_lock);
+			vfsmount_runlock();
 			break;
 		}
 		mntget(parent);
 		nd->path.dentry = dget(nd->path.mnt->mnt_mountpoint);
-		spin_unlock(&vfsmount_lock);
+		vfsmount_runlock();
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
@@ -37,12 +39,10 @@
 #define HASH_SHIFT ilog2(PAGE_SIZE / sizeof(struct list_head))
 #define HASH_SIZE (1UL << HASH_SHIFT)
 
-/* spinlock for vfsmount related operations, inplace of dcache_lock */
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(vfsmount_lock);
-
 static int event;
 static DEFINE_IDA(mnt_id_ida);
 static DEFINE_IDA(mnt_group_ida);
+static DEFINE_SPINLOCK(mnt_id_lock);
 static int mnt_id_start = 0;
 static int mnt_group_start = 1;
 
@@ -54,6 +54,16 @@ static struct rw_semaphore namespace_sem
 struct kobject *fs_kobj;
 EXPORT_SYMBOL_GPL(fs_kobj);
 
+/*
+ * vfsmount lock may be taken for read to prevent changes to the
+ * vfsmount hash, ie. during mountpoint lookups or walking back
+ * up the tree.
+ *
+ * It should be taken for write in all cases where the vfsmount
+ * tree or hash is modified or when a vfsmount structure is modified.
+ */
+DEFINE_BRLOCK(vfsmount);
+
 static inline unsigned long hash(struct vfsmount *mnt, struct dentry *dentry)
 {
 	unsigned long tmp = ((unsigned long)mnt / L1_CACHE_BYTES);
@@ -64,18 +74,21 @@ static inline unsigned long hash(struct
 
 #define MNT_WRITER_UNDERFLOW_LIMIT -(1<<16)
 
-/* allocation is serialized by namespace_sem */
+/*
+ * allocation is serialized by namespace_sem, but we need the spinlock to
+ * serialize with freeing.
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
 
@@ -85,11 +98,11 @@ retry:
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
@@ -344,7 +357,7 @@ static int mnt_make_readonly(struct vfsm
 {
 	int ret = 0;
 
-	spin_lock(&vfsmount_lock);
+	vfsmount_wlock();
 	mnt->mnt_flags |= MNT_WRITE_HOLD;
 	/*
 	 * After storing MNT_WRITE_HOLD, we'll read the counters. This store
@@ -378,15 +391,15 @@ static int mnt_make_readonly(struct vfsm
 	 */
 	smp_wmb();
 	mnt->mnt_flags &= ~MNT_WRITE_HOLD;
-	spin_unlock(&vfsmount_lock);
+	vfsmount_wunlock();
 	return ret;
 }
 
 static void __mnt_unmake_readonly(struct vfsmount *mnt)
 {
-	spin_lock(&vfsmount_lock);
+	vfsmount_wlock();
 	mnt->mnt_flags &= ~MNT_READONLY;
-	spin_unlock(&vfsmount_lock);
+	vfsmount_wunlock();
 }
 
 void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
@@ -410,6 +423,7 @@ void free_vfsmnt(struct vfsmount *mnt)
 /*
  * find the first or last mount at @dentry on vfsmount @mnt depending on
  * @dir. If @dir is set return the first mount else return the last mount.
+ * vfsmount_lock must be held for read or write.
  */
 struct vfsmount *__lookup_mnt(struct vfsmount *mnt, struct dentry *dentry,
 			      int dir)
@@ -439,10 +453,11 @@ struct vfsmount *__lookup_mnt(struct vfs
 struct vfsmount *lookup_mnt(struct path *path)
 {
 	struct vfsmount *child_mnt;
-	spin_lock(&vfsmount_lock);
+
+	vfsmount_rlock();
 	if ((child_mnt = __lookup_mnt(path->mnt, path->dentry, 1)))
 		mntget(child_mnt);
-	spin_unlock(&vfsmount_lock);
+	vfsmount_runlock();
 	return child_mnt;
 }
 
@@ -451,6 +466,9 @@ static inline int check_mnt(struct vfsmo
 	return mnt->mnt_ns == current->nsproxy->mnt_ns;
 }
 
+/*
+ * vfsmount lock must be held for write
+ */
 static void touch_mnt_namespace(struct mnt_namespace *ns)
 {
 	if (ns) {
@@ -459,6 +477,9 @@ static void touch_mnt_namespace(struct m
 	}
 }
 
+/*
+ * vfsmount lock must be held for write
+ */
 static void __touch_mnt_namespace(struct mnt_namespace *ns)
 {
 	if (ns && ns->event != event) {
@@ -467,6 +488,9 @@ static void __touch_mnt_namespace(struct
 	}
 }
 
+/*
+ * vfsmount lock must be held for write
+ */
 static void dentry_reset_mounted(struct vfsmount *mnt, struct dentry *dentry)
 {
 	if (!__lookup_mnt(mnt, dentry, 0)) {
@@ -476,6 +500,9 @@ static void dentry_reset_mounted(struct
 	}
 }
 
+/*
+ * vfsmount lock must be held for write
+ */
 static void detach_mnt(struct vfsmount *mnt, struct path *old_path)
 {
 	old_path->dentry = mnt->mnt_mountpoint;
@@ -487,6 +514,9 @@ static void detach_mnt(struct vfsmount *
 	dentry_reset_mounted(old_path->mnt, old_path->dentry);
 }
 
+/*
+ * vfsmount lock must be held for write
+ */
 void mnt_set_mountpoint(struct vfsmount *mnt, struct dentry *dentry,
 			struct vfsmount *child_mnt)
 {
@@ -497,6 +527,9 @@ void mnt_set_mountpoint(struct vfsmount
 	spin_unlock(&dentry->d_lock);
 }
 
+/*
+ * vfsmount lock must be held for write
+ */
 static void attach_mnt(struct vfsmount *mnt, struct path *path)
 {
 	mnt_set_mountpoint(path->mnt, path->dentry, mnt);
@@ -506,7 +539,7 @@ static void attach_mnt(struct vfsmount *
 }
 
 /*
- * the caller must hold vfsmount_lock
+ * vfsmount lock must be held for write
  */
 static void commit_tree(struct vfsmount *mnt)
 {
@@ -629,40 +662,41 @@ static inline void __mntput(struct vfsmo
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
+	if (!vfsmount_atomic_dec_and_wlock(&mnt->mnt_count))
+		return;
+
+	if (likely(!mnt->mnt_pinned)) {
+		vfsmount_wunlock();
+		__mntput(mnt);
+		return;
 	}
+	atomic_add(mnt->mnt_pinned + 1, &mnt->mnt_count);
+	mnt->mnt_pinned = 0;
+	vfsmount_wunlock();
+	acct_auto_close_mnt(mnt);
+	security_sb_umount_close(mnt);
+	goto repeat;
 }
 
 EXPORT_SYMBOL(mntput_no_expire);
 
 void mnt_pin(struct vfsmount *mnt)
 {
-	spin_lock(&vfsmount_lock);
+	vfsmount_wlock();
 	mnt->mnt_pinned++;
-	spin_unlock(&vfsmount_lock);
+	vfsmount_wunlock();
 }
 
 EXPORT_SYMBOL(mnt_pin);
 
 void mnt_unpin(struct vfsmount *mnt)
 {
-	spin_lock(&vfsmount_lock);
+	vfsmount_wlock();
 	if (mnt->mnt_pinned) {
 		atomic_inc(&mnt->mnt_count);
 		mnt->mnt_pinned--;
 	}
-	spin_unlock(&vfsmount_lock);
+	vfsmount_wunlock();
 }
 
 EXPORT_SYMBOL(mnt_unpin);
@@ -945,12 +979,12 @@ int may_umount_tree(struct vfsmount *mnt
 	int minimum_refs = 0;
 	struct vfsmount *p;
 
-	spin_lock(&vfsmount_lock);
+	vfsmount_rlock();
 	for (p = mnt; p; p = next_mnt(p, mnt)) {
 		actual_refs += atomic_read(&p->mnt_count);
 		minimum_refs += 2;
 	}
-	spin_unlock(&vfsmount_lock);
+	vfsmount_runlock();
 
 	if (actual_refs > minimum_refs)
 		return 0;
@@ -976,10 +1010,12 @@ EXPORT_SYMBOL(may_umount_tree);
 int may_umount(struct vfsmount *mnt)
 {
 	int ret = 1;
-	spin_lock(&vfsmount_lock);
+
+	vfsmount_rlock();
 	if (propagate_mount_busy(mnt, 2))
 		ret = 0;
-	spin_unlock(&vfsmount_lock);
+	vfsmount_runlock();
+
 	return ret;
 }
 
@@ -994,13 +1030,14 @@ void release_mounts(struct list_head *he
 		if (mnt->mnt_parent != mnt) {
 			struct dentry *dentry;
 			struct vfsmount *m;
-			spin_lock(&vfsmount_lock);
+
+			vfsmount_wlock();
 			dentry = mnt->mnt_mountpoint;
 			m = mnt->mnt_parent;
 			mnt->mnt_mountpoint = mnt->mnt_root;
 			mnt->mnt_parent = mnt;
 			m->mnt_ghosts--;
-			spin_unlock(&vfsmount_lock);
+			vfsmount_wunlock();
 			dput(dentry);
 			mntput(m);
 		}
@@ -1008,6 +1045,10 @@ void release_mounts(struct list_head *he
 	}
 }
 
+/*
+ * vfsmount lock must be held for write
+ * namespace_sem must be held for write
+ */
 void umount_tree(struct vfsmount *mnt, int propagate, struct list_head *kill)
 {
 	struct vfsmount *p;
@@ -1098,7 +1139,7 @@ static int do_umount(struct vfsmount *mn
 	}
 
 	down_write(&namespace_sem);
-	spin_lock(&vfsmount_lock);
+	vfsmount_wlock();
 	event++;
 
 	if (!(flags & MNT_DETACH))
@@ -1110,7 +1151,7 @@ static int do_umount(struct vfsmount *mn
 			umount_tree(mnt, 1, &umount_list);
 		retval = 0;
 	}
-	spin_unlock(&vfsmount_lock);
+	vfsmount_wunlock();
 	if (retval)
 		security_sb_umount_busy(mnt);
 	up_write(&namespace_sem);
@@ -1217,19 +1258,19 @@ struct vfsmount *copy_tree(struct vfsmou
 			q = clone_mnt(p, p->mnt_root, flag);
 			if (!q)
 				goto Enomem;
-			spin_lock(&vfsmount_lock);
+			vfsmount_wlock();
 			list_add_tail(&q->mnt_list, &res->mnt_list);
 			attach_mnt(q, &path);
-			spin_unlock(&vfsmount_lock);
+			vfsmount_wunlock();
 		}
 	}
 	return res;
 Enomem:
 	if (res) {
 		LIST_HEAD(umount_list);
-		spin_lock(&vfsmount_lock);
+		vfsmount_wlock();
 		umount_tree(res, 0, &umount_list);
-		spin_unlock(&vfsmount_lock);
+		vfsmount_wunlock();
 		release_mounts(&umount_list);
 	}
 	return NULL;
@@ -1248,9 +1289,9 @@ void drop_collected_mounts(struct vfsmou
 {
 	LIST_HEAD(umount_list);
 	down_write(&namespace_sem);
-	spin_lock(&vfsmount_lock);
+	vfsmount_wlock();
 	umount_tree(mnt, 0, &umount_list);
-	spin_unlock(&vfsmount_lock);
+	vfsmount_wunlock();
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
 }
@@ -1368,7 +1409,7 @@ static int attach_recursive_mnt(struct v
 			set_mnt_shared(p);
 	}
 
-	spin_lock(&vfsmount_lock);
+	vfsmount_wlock();
 	if (parent_path) {
 		detach_mnt(source_mnt, parent_path);
 		attach_mnt(source_mnt, path);
@@ -1382,7 +1423,8 @@ static int attach_recursive_mnt(struct v
 		list_del_init(&child->mnt_hash);
 		commit_tree(child);
 	}
-	spin_unlock(&vfsmount_lock);
+	vfsmount_wunlock();
+
 	return 0;
 
  out_cleanup_ids:
@@ -1444,10 +1486,10 @@ static int do_change_type(struct path *p
 			goto out_unlock;
 	}
 
-	spin_lock(&vfsmount_lock);
+	vfsmount_wlock();
 	for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL))
 		change_mnt_propagation(m, type);
-	spin_unlock(&vfsmount_lock);
+	vfsmount_wunlock();
 
  out_unlock:
 	up_write(&namespace_sem);
@@ -1491,9 +1533,10 @@ static int do_loopback(struct path *path
 	err = graft_tree(mnt, path);
 	if (err) {
 		LIST_HEAD(umount_list);
-		spin_lock(&vfsmount_lock);
+
+		vfsmount_wlock();
 		umount_tree(mnt, 0, &umount_list);
-		spin_unlock(&vfsmount_lock);
+		vfsmount_wunlock();
 		release_mounts(&umount_list);
 	}
 
@@ -1551,9 +1594,9 @@ static int do_remount(struct path *path,
 	if (!err) {
 		security_sb_post_remount(path->mnt, flags, data);
 
-		spin_lock(&vfsmount_lock);
+		vfsmount_wlock();
 		touch_mnt_namespace(path->mnt->mnt_ns);
-		spin_unlock(&vfsmount_lock);
+		vfsmount_wunlock();
 	}
 	return err;
 }
@@ -1728,7 +1771,7 @@ void mark_mounts_for_expiry(struct list_
 		return;
 
 	down_write(&namespace_sem);
-	spin_lock(&vfsmount_lock);
+	vfsmount_wlock();
 
 	/* extract from the expiration list every vfsmount that matches the
 	 * following criteria:
@@ -1747,7 +1790,7 @@ void mark_mounts_for_expiry(struct list_
 		touch_mnt_namespace(mnt->mnt_ns);
 		umount_tree(mnt, 1, &umounts);
 	}
-	spin_unlock(&vfsmount_lock);
+	vfsmount_wunlock();
 	up_write(&namespace_sem);
 
 	release_mounts(&umounts);
@@ -1804,6 +1847,8 @@ resume:
 /*
  * process a list of expirable mountpoints with the intent of discarding any
  * submounts of a specific parent mountpoint
+ *
+ * vfsmount_lock must be held for write
  */
 static void shrink_submounts(struct vfsmount *mnt, struct list_head *umounts)
 {
@@ -2022,9 +2067,9 @@ static struct mnt_namespace *dup_mnt_ns(
 		kfree(new_ns);
 		return ERR_PTR(-ENOMEM);
 	}
-	spin_lock(&vfsmount_lock);
+	vfsmount_wlock();
 	list_add_tail(&new_ns->list, &new_ns->root->mnt_list);
-	spin_unlock(&vfsmount_lock);
+	vfsmount_wunlock();
 
 	/*
 	 * Second pass: switch the tsk->fs->* elements and mark new vfsmounts
@@ -2221,7 +2266,7 @@ SYSCALL_DEFINE2(pivot_root, const char _
 		goto out2; /* not attached */
 	/* make sure we can reach put_old from new_root */
 	tmp = old.mnt;
-	spin_lock(&vfsmount_lock);
+	vfsmount_wlock();
 	if (tmp != new.mnt) {
 		for (;;) {
 			if (tmp->mnt_parent == tmp)
@@ -2241,7 +2286,7 @@ SYSCALL_DEFINE2(pivot_root, const char _
 	/* mount new_root on / */
 	attach_mnt(new.mnt, &root_parent);
 	touch_mnt_namespace(current->nsproxy->mnt_ns);
-	spin_unlock(&vfsmount_lock);
+	vfsmount_wunlock();
 	chroot_fs_refs(&root, &new);
 	security_sb_post_pivotroot(&root, &new);
 	error = 0;
@@ -2257,7 +2302,7 @@ out1:
 out0:
 	return error;
 out3:
-	spin_unlock(&vfsmount_lock);
+	vfsmount_wunlock();
 	goto out2;
 }
 
@@ -2304,6 +2349,8 @@ void __init mnt_init(void)
 	for (u = 0; u < HASH_SIZE; u++)
 		INIT_LIST_HEAD(&mount_hashtable[u]);
 
+	vfsmount_lock_init();
+
 	err = sysfs_init();
 	if (err)
 		printk(KERN_WARNING "%s: sysfs_init error: %d\n",
@@ -2320,15 +2367,16 @@ void put_mnt_ns(struct mnt_namespace *ns
 	struct vfsmount *root;
 	LIST_HEAD(umount_list);
 
-	if (!atomic_dec_and_lock(&ns->count, &vfsmount_lock))
+	if (!vfsmount_atomic_dec_and_rlock(&ns->count))
 		return;
 	root = ns->root;
 	ns->root = NULL;
-	spin_unlock(&vfsmount_lock);
+	vfsmount_runlock();
+
 	down_write(&namespace_sem);
-	spin_lock(&vfsmount_lock);
-	umount_tree(root, 0, &umount_list);
-	spin_unlock(&vfsmount_lock);
+	vfsmount_wlock();
+  	umount_tree(root, 0, &umount_list);
+	vfsmount_wunlock();
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
 	kfree(ns);
Index: linux-2.6/fs/pnode.c
===================================================================
--- linux-2.6.orig/fs/pnode.c
+++ linux-2.6/fs/pnode.c
@@ -126,6 +126,9 @@ static int do_make_slave(struct vfsmount
 	return 0;
 }
 
+/*
+ * vfsmount lock must be held for write
+ */
 void change_mnt_propagation(struct vfsmount *mnt, int type)
 {
 	if (type == MS_SHARED) {
@@ -264,12 +267,12 @@ int propagate_mnt(struct vfsmount *dest_
 		prev_src_mnt  = child;
 	}
 out:
-	spin_lock(&vfsmount_lock);
+	vfsmount_wlock();
 	while (!list_empty(&tmp_list)) {
 		child = list_first_entry(&tmp_list, struct vfsmount, mnt_hash);
 		umount_tree(child, 0, &umount_list);
 	}
-	spin_unlock(&vfsmount_lock);
+	vfsmount_wunlock();
 	release_mounts(&umount_list);
 	return ret;
 }
@@ -290,6 +293,8 @@ static inline int do_refcount_check(stru
  * other mounts its parent propagates to.
  * Check if any of these mounts that **do not have submounts**
  * have more references than 'refcnt'. If so return busy.
+ *
+ * vfsmount lock must be held for read or write
  */
 int propagate_mount_busy(struct vfsmount *mnt, int refcnt)
 {
@@ -347,6 +352,8 @@ static void __propagate_umount(struct vf
  * collect all mounts that receive propagation from the mount in @list,
  * and return these additional mounts in the same list.
  * @list: the list of mounts to be unmounted.
+ *
+ * vfsmount lock must be held for write
  */
 int propagate_umount(struct list_head *list)
 {
Index: linux-2.6/fs/proc/base.c
===================================================================
--- linux-2.6.orig/fs/proc/base.c
+++ linux-2.6/fs/proc/base.c
@@ -652,12 +652,12 @@ static unsigned mounts_poll(struct file
 
 	poll_wait(file, &ns->poll, wait);
 
-	spin_lock(&vfsmount_lock);
+	vfsmount_rlock();
 	if (p->event != ns->event) {
 		p->event = ns->event;
 		res |= POLLERR | POLLPRI;
 	}
-	spin_unlock(&vfsmount_lock);
+	vfsmount_runlock();
 
 	return res;
 }
Index: linux-2.6/include/linux/mount.h
===================================================================
--- linux-2.6.orig/include/linux/mount.h
+++ linux-2.6/include/linux/mount.h
@@ -13,6 +13,7 @@
 #include <linux/list.h>
 #include <linux/nodemask.h>
 #include <linux/spinlock.h>
+#include <linux/brlock.h>
 #include <asm/atomic.h>
 
 struct super_block;
@@ -90,6 +91,8 @@ static inline struct vfsmount *mntget(st
 
 struct file; /* forward dec */
 
+DECLARE_BRLOCK(vfsmount);
+
 extern int mnt_want_write(struct vfsmount *mnt);
 extern int mnt_want_write_file(struct file *file);
 extern int mnt_clone_write(struct vfsmount *mnt);
@@ -123,7 +126,6 @@ extern int do_add_mount(struct vfsmount
 
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
+		vfsmount_rlock();
 		if (!is_under(mnt, dentry, &path)) {
-			spin_unlock(&vfsmount_lock);
+			vfsmount_runlock();
 			path_put(&path);
 			put_tree(tree);
 			mutex_lock(&audit_filter_mutex);
 			continue;
 		}
-		spin_unlock(&vfsmount_lock);
+		vfsmount_runlock();
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
+		vfsmount_rlock();
 		if (root.mnt && root.mnt->mnt_ns)
 			ns_root.mnt = mntget(root.mnt->mnt_ns->root);
 		if (ns_root.mnt)
 			ns_root.dentry = dget(ns_root.mnt->mnt_root);
-		spin_unlock(&vfsmount_lock);
+		vfsmount_runlock();
 		spin_lock(&dcache_lock);
 		tmp = ns_root;
 		sp = __d_path(path, &tmp, newname, newname_len);


