Return-Path: <linux-kernel-owner+w=401wt.eu-S934714AbZJOGGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934714AbZJOGGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934610AbZJOGGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:06:02 -0400
Received: from cantor.suse.de ([195.135.220.2]:35374 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934088AbZJOGE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:04:57 -0400
Message-Id: <20091015050049.384986103@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Thu, 15 Oct 2009 15:40:32 +1100
From: npiggin@suse.de
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [patch 6/6] fs: scale mntget/mntput
References: <20091015044026.319860788@suse.de>
Content-Disposition: inline; filename=fs-mntget-scale.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve scalability of mntget/mntput by using per-cpu counters protected by the
reader side of the brlock vfsmount_lock. MNT_MOUNTED in mnt_flags keeps track
of whether the vfsmount is actually attached to the tree so we can shortcut the
now-expensive refcount check in mntput (just decrement the count because we
know there must be at least one ref left).

No extra atomics in the common case because atomic mnt refcount is now replaced
with per-CPU spinlock. Code will be bigger and more complex however. With the
previous per-cpu locking patch, mount lookups and common case refcounting are
now per-cpu and should be ideally scalable. path lookups (and hence
path_get/path_put) within the same vfsmount should now be more scalable,
however this will often be hidden by dcache_lock on final dput, and d_lock on
common path elements (eg. cwd or root dentry).

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/libfs.c            |    1 
 fs/namespace.c        |  151 +++++++++++++++++++++++++++++++++++++++++++++-----
 fs/pnode.c            |    4 -
 include/linux/mount.h |   34 ++++-------
 4 files changed, 152 insertions(+), 38 deletions(-)

Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c
+++ linux-2.6/fs/namespace.c
@@ -138,6 +138,61 @@ void mnt_release_group_id(struct vfsmoun
 	mnt->mnt_group_id = 0;
 }
 
+/*
+ * vfsmount lock must be held for read
+ */
+static inline void add_mnt_count(struct vfsmount *mnt, int n)
+{
+#ifdef CONFIG_SMP
+	(*per_cpu_ptr(mnt->mnt_count, smp_processor_id())) += n;
+#else
+	mnt->mnt_count += n;
+#endif
+}
+
+/*
+ * vfsmount lock must be held for read
+ */
+static inline void inc_mnt_count(struct vfsmount *mnt)
+{
+#ifdef CONFIG_SMP
+	(*per_cpu_ptr(mnt->mnt_count, smp_processor_id()))++;
+#else
+	mnt->mnt_count++;
+#endif
+}
+
+/*
+ * vfsmount lock must be held for read
+ */
+static inline void dec_mnt_count(struct vfsmount *mnt)
+{
+#ifdef CONFIG_SMP
+	(*per_cpu_ptr(mnt->mnt_count, smp_processor_id()))--;
+#else
+	mnt->mnt_count--;
+#endif
+}
+
+/*
+ * vfsmount lock must be held for write
+ */
+unsigned int count_mnt_count(struct vfsmount *mnt)
+{
+#ifdef CONFIG_SMP
+	unsigned int count = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		count += *per_cpu_ptr(mnt->mnt_count, cpu);
+	}
+
+	return count;
+#else
+	return mnt->mnt_count;
+#endif
+}
+
 struct vfsmount *alloc_vfsmnt(const char *name)
 {
 	struct vfsmount *mnt = kmem_cache_zalloc(mnt_cache, GFP_KERNEL);
@@ -154,7 +209,13 @@ struct vfsmount *alloc_vfsmnt(const char
 				goto out_free_id;
 		}
 
-		atomic_set(&mnt->mnt_count, 1);
+#ifdef CONFIG_SMP
+		mnt->mnt_count = alloc_percpu(int);
+		if (!mnt->mnt_count)
+			goto out_free_devname;
+#else
+		mnt->mnt_count = 0;
+#endif
 		INIT_LIST_HEAD(&mnt->mnt_hash);
 		INIT_LIST_HEAD(&mnt->mnt_child);
 		INIT_LIST_HEAD(&mnt->mnt_mounts);
@@ -166,14 +227,19 @@ struct vfsmount *alloc_vfsmnt(const char
 #ifdef CONFIG_SMP
 		mnt->mnt_writers = alloc_percpu(int);
 		if (!mnt->mnt_writers)
-			goto out_free_devname;
+			goto out_free_mntcount;
 #else
 		mnt->mnt_writers = 0;
 #endif
+		preempt_disable();
+		inc_mnt_count(mnt);
+		preempt_enable();
 	}
 	return mnt;
 
 #ifdef CONFIG_SMP
+out_free_mntcount:
+	free_percpu(mnt->mnt_count);
 out_free_devname:
 	kfree(mnt->mnt_devname);
 #endif
@@ -512,6 +578,8 @@ static void detach_mnt(struct vfsmount *
 	list_del_init(&mnt->mnt_child);
 	list_del_init(&mnt->mnt_hash);
 	dentry_reset_mounted(old_path->mnt, old_path->dentry);
+	WARN_ON(!(mnt->mnt_flags & MNT_MOUNTED));
+	mnt->mnt_flags &= ~MNT_MOUNTED;
 }
 
 /*
@@ -536,6 +604,8 @@ static void attach_mnt(struct vfsmount *
 	list_add_tail(&mnt->mnt_hash, mount_hashtable +
 			hash(path->mnt, path->dentry));
 	list_add_tail(&mnt->mnt_child, &path->mnt->mnt_mounts);
+	WARN_ON(mnt->mnt_flags & MNT_MOUNTED);
+	mnt->mnt_flags |= MNT_MOUNTED;
 }
 
 /*
@@ -558,6 +628,8 @@ static void commit_tree(struct vfsmount
 	list_add_tail(&mnt->mnt_hash, mount_hashtable +
 				hash(parent, mnt->mnt_mountpoint));
 	list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
+	WARN_ON(mnt->mnt_flags & MNT_MOUNTED);
+	mnt->mnt_flags |= MNT_MOUNTED;
 	touch_mnt_namespace(n);
 }
 
@@ -652,6 +724,9 @@ static inline void __mntput(struct vfsmo
 	/*
 	 * atomic_dec_and_lock() used to deal with ->mnt_count decrements
 	 * provides barriers, so count_mnt_writers() below is safe.  AV
+	 * XXX: hmm, we no longer have an atomic_dec_and_lock, so load of
+	 * mnt_writers may be moved up into the vfsmount lock critical
+	 * section? Do we need an smp_mb()?
 	 */
 	WARN_ON(count_mnt_writers(mnt));
 	dput(mnt->mnt_root);
@@ -661,44 +736,79 @@ static inline void __mntput(struct vfsmo
 
 void mntput_no_expire(struct vfsmount *mnt)
 {
-repeat:
-	if (!vfsmount_atomic_dec_and_wlock(&mnt->mnt_count))
+	if (likely(mnt->mnt_flags & MNT_MOUNTED)) {
+		vfsmount_rlock();
+		if (unlikely(!mnt->mnt_flags & MNT_MOUNTED)) {
+			vfsmount_runlock();
+			goto repeat;
+		}
+		dec_mnt_count(mnt);
+		vfsmount_runlock();
+
 		return;
+	}
 
+repeat:
+	vfsmount_wlock();
+	BUG_ON(mnt->mnt_flags & MNT_MOUNTED);
+	dec_mnt_count(mnt);
+	if (count_mnt_count(mnt)) {
+		vfsmount_wunlock();
+		return;
+	}
 	if (likely(!mnt->mnt_pinned)) {
 		vfsmount_wunlock();
 		__mntput(mnt);
 		return;
 	}
-	atomic_add(mnt->mnt_pinned + 1, &mnt->mnt_count);
+	add_mnt_count(mnt, mnt->mnt_pinned + 1);
 	mnt->mnt_pinned = 0;
 	vfsmount_wunlock();
 	acct_auto_close_mnt(mnt);
 	security_sb_umount_close(mnt);
 	goto repeat;
 }
-
 EXPORT_SYMBOL(mntput_no_expire);
 
+void mntput(struct vfsmount *mnt)
+{
+	if (mnt) {
+		/* avoid cacheline pingpong, hope gcc doesn't get "smart" */
+		if (unlikely(mnt->mnt_expiry_mark))
+			mnt->mnt_expiry_mark = 0;
+		mntput_no_expire(mnt);
+	}
+}
+EXPORT_SYMBOL(mntput);
+
+struct vfsmount *mntget(struct vfsmount *mnt)
+{
+	if (mnt) {
+		preempt_disable();
+		inc_mnt_count(mnt);
+		preempt_enable();
+	}
+	return mnt;
+}
+EXPORT_SYMBOL(mntget);
+
 void mnt_pin(struct vfsmount *mnt)
 {
 	vfsmount_wlock();
 	mnt->mnt_pinned++;
 	vfsmount_wunlock();
 }
-
 EXPORT_SYMBOL(mnt_pin);
 
 void mnt_unpin(struct vfsmount *mnt)
 {
 	vfsmount_wlock();
 	if (mnt->mnt_pinned) {
-		atomic_inc(&mnt->mnt_count);
+		inc_mnt_count(mnt);
 		mnt->mnt_pinned--;
 	}
 	vfsmount_wunlock();
 }
-
 EXPORT_SYMBOL(mnt_unpin);
 
 static inline void mangle(struct seq_file *m, const char *s)
@@ -979,12 +1089,13 @@ int may_umount_tree(struct vfsmount *mnt
 	int minimum_refs = 0;
 	struct vfsmount *p;
 
-	vfsmount_rlock();
+	/* write lock needed for count_mnt_count */
+	vfsmount_wlock();
 	for (p = mnt; p; p = next_mnt(p, mnt)) {
-		actual_refs += atomic_read(&p->mnt_count);
+		actual_refs += count_mnt_count(p);
 		minimum_refs += 2;
 	}
-	vfsmount_runlock();
+	vfsmount_wunlock();
 
 	if (actual_refs > minimum_refs)
 		return 0;
@@ -1011,10 +1122,10 @@ int may_umount(struct vfsmount *mnt)
 {
 	int ret = 1;
 
-	vfsmount_rlock();
+	vfsmount_wlock();
 	if (propagate_mount_busy(mnt, 2))
 		ret = 0;
-	vfsmount_runlock();
+	vfsmount_wunlock();
 
 	return ret;
 }
@@ -1065,6 +1176,8 @@ void umount_tree(struct vfsmount *mnt, i
 		__touch_mnt_namespace(p->mnt_ns);
 		p->mnt_ns = NULL;
 		list_del_init(&p->mnt_child);
+		WARN_ON(!(p->mnt_flags & MNT_MOUNTED));
+		p->mnt_flags &= ~MNT_MOUNTED;
 		if (p->mnt_parent != p) {
 			p->mnt_parent->mnt_ghosts++;
 			dentry_reset_mounted(p->mnt_parent, p->mnt_mountpoint);
@@ -1096,8 +1209,16 @@ static int do_umount(struct vfsmount *mn
 		    flags & (MNT_FORCE | MNT_DETACH))
 			return -EINVAL;
 
-		if (atomic_read(&mnt->mnt_count) != 2)
+		/*
+		 * probably don't strictly need the lock here if we examined
+		 * all race cases, but it's a slowpath.
+		 */
+		vfsmount_wlock();
+		if (count_mnt_count(mnt) != 2) {
+			vfsmount_wlock();
 			return -EBUSY;
+		}
+		vfsmount_wunlock();
 
 		if (!xchg(&mnt->mnt_expiry_mark, 1))
 			return -EAGAIN;
Index: linux-2.6/include/linux/mount.h
===================================================================
--- linux-2.6.orig/include/linux/mount.h
+++ linux-2.6/include/linux/mount.h
@@ -32,11 +32,13 @@ struct mnt_namespace;
 
 #define MNT_SHRINKABLE	0x100
 #define MNT_WRITE_HOLD	0x200
+#define MNT_MOUNTED	0x400
 
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
 #define MNT_PNODE_MASK	0x3000	/* propagation flag mask */
 
+
 struct vfsmount {
 	struct list_head mnt_hash;
 	struct vfsmount *mnt_parent;	/* fs we are mounted on */
@@ -57,12 +59,6 @@ struct vfsmount {
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
 	int mnt_id;			/* mount identifier */
 	int mnt_group_id;		/* peer group identifier */
-	/*
-	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
-	 * to let these frequently modified fields in a separate cache line
-	 * (so that reads of mnt_flags wont ping-pong on SMP machines)
-	 */
-	atomic_t mnt_count;
 	int mnt_expiry_mark;		/* true if marked for expiry */
 	int mnt_pinned;
 	int mnt_ghosts;
@@ -71,6 +67,11 @@ struct vfsmount {
 #else
 	int mnt_writers;
 #endif
+#ifdef CONFIG_SMP
+	int *mnt_count;
+#else
+	int mnt_count;
+#endif
 };
 
 static inline int *get_mnt_writers_ptr(struct vfsmount *mnt)
@@ -82,34 +83,25 @@ static inline int *get_mnt_writers_ptr(s
 #endif
 }
 
-static inline struct vfsmount *mntget(struct vfsmount *mnt)
-{
-	if (mnt)
-		atomic_inc(&mnt->mnt_count);
-	return mnt;
-}
-
 struct file; /* forward dec */
 
 DECLARE_BRLOCK(vfsmount);
 
+extern unsigned int count_mnt_count(struct vfsmount *mnt);
+
 extern int mnt_want_write(struct vfsmount *mnt);
 extern int mnt_want_write_file(struct file *file);
 extern int mnt_clone_write(struct vfsmount *mnt);
 extern void mnt_drop_write(struct vfsmount *mnt);
+
 extern void mntput_no_expire(struct vfsmount *mnt);
+extern struct vfsmount *mntget(struct vfsmount *mnt);
+extern void mntput(struct vfsmount *mnt);
+
 extern void mnt_pin(struct vfsmount *mnt);
 extern void mnt_unpin(struct vfsmount *mnt);
 extern int __mnt_is_readonly(struct vfsmount *mnt);
 
-static inline void mntput(struct vfsmount *mnt)
-{
-	if (mnt) {
-		mnt->mnt_expiry_mark = 0;
-		mntput_no_expire(mnt);
-	}
-}
-
 extern struct vfsmount *do_kern_mount(const char *fstype, int flags,
 				      const char *name, void *data);
 
Index: linux-2.6/fs/pnode.c
===================================================================
--- linux-2.6.orig/fs/pnode.c
+++ linux-2.6/fs/pnode.c
@@ -282,7 +282,7 @@ out:
  */
 static inline int do_refcount_check(struct vfsmount *mnt, int count)
 {
-	int mycount = atomic_read(&mnt->mnt_count) - mnt->mnt_ghosts;
+	int mycount = count_mnt_count(mnt) - mnt->mnt_ghosts;
 	return (mycount > count);
 }
 
@@ -294,7 +294,7 @@ static inline int do_refcount_check(stru
  * Check if any of these mounts that **do not have submounts**
  * have more references than 'refcnt'. If so return busy.
  *
- * vfsmount lock must be held for read or write
+ * vfsmount lock must be held for write
  */
 int propagate_mount_busy(struct vfsmount *mnt, int refcnt)
 {
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -244,6 +244,7 @@ int get_sb_pseudo(struct file_system_typ
 	d_instantiate(dentry, root);
 	s->s_root = dentry;
 	s->s_flags |= MS_ACTIVE;
+	mnt->mnt_flags |= MNT_MOUNTED;
 	simple_set_mnt(mnt, s);
 	return 0;
 


