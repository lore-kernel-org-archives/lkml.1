Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbYH1Hel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbYH1Hel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbYH1Hed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:34:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:52944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbYH1Hea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:34:30 -0400
Date: Thu, 28 Aug 2008 09:34:28 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [rfc][patch] queueing spinlocks?
Message-ID: <20080828073428.GA19638@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've implemented a sort of spin local, queueing MCS lock that uses per-cpu
nodes that can be shared by multiple locks. I guess it is preferable to
remove global locks, but some don't seem to be going anywhere soon.

The only issue is that only one set of nodes can be actively used for a lock
at once, so if we want to nest these locks, we have to use different
sets for each one. This shouldn't be much of a problem because we don't have
too many "big" locks, and yet fewer ones that are nested in one another.

With this modification to MCS locks, each lock is pretty small in size, so it
could even be used for some per-object locks if we really wanted.

I've converted dcache lock as well... it shows improved results on a 64-way
Altix. Unfortunately this adds an extra atomic to the unlock path. I didn't
look too hard at array based queue locks, there might be a a type of those
that would work better.

Index: linux-2.6/include/linux/mcslock.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/mcslock.h
@@ -0,0 +1,76 @@
+/*
+ *	"Shared-node" MCS lock.
+ *	Nick Piggin <npiggin@suse.de>
+ */
+#ifndef _LINUX_MCSLOCK_H
+#define _LINUX_MCSLOCK_H
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/irqflags.h>
+#include <asm/atomic.h>
+#include <asm/system.h>
+#include <asm/processor.h>
+
+#ifndef CONFIG_SMP
+typdef struct {
+} mcslock_t;
+
+static inline void mcs_lock_init(mcslock_t *lock)
+{
+}
+
+static inline int mcs_is_locked(mcslock_t *lock)
+{
+	return 0;
+}
+
+static inline void mcs_unlock_wait(mcslock_t *lock)
+{
+}
+
+static inline void mcs_lock(mcslock_t *lock, int nest)
+{
+}
+static inline int mcs_trylock(mcslock_t *lock, int nest)
+{
+	return 1;
+}
+static inline void mcs_unlock(mcslock_t *lock, int nest)
+{
+}
+
+#else /*!CONFIG_SMP*/
+
+typedef struct {
+	atomic_t cpu;
+} mcslock_t;
+
+#define MCS_CPU_NONE	0x7fffffff
+
+#define DEFINE_MCS_LOCK(name) mcslock_t name = { .cpu = ATOMIC_INIT(MCS_CPU_NONE) }
+static inline void mcs_lock_init(mcslock_t *lock)
+{
+	atomic_set(&lock->cpu, MCS_CPU_NONE); /* unlocked */
+}
+
+static inline int mcs_is_locked(mcslock_t *lock)
+{
+	return atomic_read(&lock->cpu) != MCS_CPU_NONE;
+}
+
+static inline void mcs_unlock_wait(mcslock_t *lock)
+{
+	while (mcs_is_locked(lock))
+		cpu_relax();
+}
+
+extern void mcs_lock(mcslock_t *lock, int nest);
+extern int mcs_trylock(mcslock_t *lock, int nest);
+extern void mcs_unlock(mcslock_t *lock, int nest);
+
+#endif /*!CONFIG_SMP*/
+
+extern int atomic_dec_and_mcslock(atomic_t *atomic, mcslock_t *lock, int nest);
+
+#endif
Index: linux-2.6/lib/Makefile
===================================================================
--- linux-2.6.orig/lib/Makefile
+++ linux-2.6/lib/Makefile
@@ -19,7 +19,8 @@ lib-$(CONFIG_SMP) += cpumask.o
 lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
-	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o
+	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
+	 mcslock.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
Index: linux-2.6/lib/mcslock.c
===================================================================
--- /dev/null
+++ linux-2.6/lib/mcslock.c
@@ -0,0 +1,72 @@
+#include <linux/mcslock.h>
+#include <linux/percpu.h>
+
+struct mcsnode {
+	unsigned long next;
+	unsigned long wait;
+};
+
+#define NR_NEST_LEVELS	2
+static DEFINE_PER_CPU(struct mcsnode, mcsnodes)[NR_NEST_LEVELS];
+
+void mcs_lock(mcslock_t *lock, int nest)
+{
+	struct mcsnode *instance;
+	unsigned int t, me;
+
+	instance = &get_cpu_var(mcsnodes)[nest];
+	me = smp_processor_id();
+	instance->next = MCS_CPU_NONE;
+
+	t = atomic_xchg(&lock->cpu, me);
+	if (t != MCS_CPU_NONE) {
+		struct mcsnode *before;
+
+		before = &per_cpu(mcsnodes, t)[nest];
+		instance->wait = 1;
+		smp_wmb();
+		before->next = me;
+		while (instance->wait)
+			cpu_relax();
+	}
+}
+
+int mcs_trylock(mcslock_t *lock, int nest)
+{
+	struct mcsnode *instance;
+	unsigned int t, me;
+
+	instance = &get_cpu_var(mcsnodes)[nest];
+	me = smp_processor_id();
+	instance->next = MCS_CPU_NONE;
+
+	t = atomic_cmpxchg(&lock->cpu, MCS_CPU_NONE, me);
+	if (t == MCS_CPU_NONE)
+		return 1;
+	put_cpu_var(mcsnodes);
+	return 0;
+}
+
+void mcs_unlock(mcslock_t *lock, int nest)
+{
+	struct mcsnode *instance;
+	struct mcsnode *next;
+
+	instance = &__get_cpu_var(mcsnodes)[nest];
+
+	if (instance->next == MCS_CPU_NONE) {
+		unsigned int t, me;
+
+		me = smp_processor_id();
+		t = atomic_cmpxchg(&lock->cpu, me, MCS_CPU_NONE);
+		if (t == me)
+			return;
+		while (instance->next == MCS_CPU_NONE)
+			cpu_relax();
+		smp_read_barrier_depends();
+	} else
+		smp_mb(); /* unlock barrier */
+	next = &per_cpu(mcsnodes, instance->next)[nest];
+	next->wait = 0;
+	put_cpu_var(mcsnodes);
+}
Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -29,6 +29,7 @@
 #include <linux/file.h>
 #include <asm/uaccess.h>
 #include <linux/security.h>
+#include <linux/mcslock.h>
 #include <linux/seqlock.h>
 #include <linux/swap.h>
 #include <linux/bootmem.h>
@@ -38,7 +39,7 @@
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
- __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
+__cacheline_aligned_in_smp DEFINE_MCS_LOCK(dcache_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
 EXPORT_SYMBOL(dcache_lock);
@@ -108,7 +109,7 @@ static void dentry_iput(struct dentry * 
 		dentry->d_inode = NULL;
 		list_del_init(&dentry->d_alias);
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 		if (!inode->i_nlink)
 			fsnotify_inoderemove(inode);
 		if (dentry->d_op && dentry->d_op->d_iput)
@@ -117,7 +118,7 @@ static void dentry_iput(struct dentry * 
 			iput(inode);
 	} else {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 	}
 }
 
@@ -216,13 +217,13 @@ void dput(struct dentry *dentry)
 repeat:
 	if (atomic_read(&dentry->d_count) == 1)
 		might_sleep();
-	if (!atomic_dec_and_lock(&dentry->d_count, &dcache_lock))
+	if (!atomic_dec_and_mcslock(&dentry->d_count, &dcache_lock, 0))
 		return;
 
 	spin_lock(&dentry->d_lock);
 	if (atomic_read(&dentry->d_count)) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 		return;
 	}
 
@@ -241,7 +242,7 @@ repeat:
 		dentry_lru_add(dentry);
   	}
  	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	return;
 
 unhash_it:
@@ -271,9 +272,9 @@ int d_invalidate(struct dentry * dentry)
 	/*
 	 * If it's already been dropped, return OK.
 	 */
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	if (d_unhashed(dentry)) {
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 		return 0;
 	}
 	/*
@@ -281,9 +282,9 @@ int d_invalidate(struct dentry * dentry)
 	 * to get rid of unused child entries.
 	 */
 	if (!list_empty(&dentry->d_subdirs)) {
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 		shrink_dcache_parent(dentry);
-		spin_lock(&dcache_lock);
+		mcs_lock(&dcache_lock, 0);
 	}
 
 	/*
@@ -300,14 +301,14 @@ int d_invalidate(struct dentry * dentry)
 	if (atomic_read(&dentry->d_count) > 1) {
 		if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode)) {
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 			return -EBUSY;
 		}
 	}
 
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	return 0;
 }
 
@@ -374,9 +375,9 @@ struct dentry * d_find_alias(struct inod
 	struct dentry *de = NULL;
 
 	if (!list_empty(&inode->i_dentry)) {
-		spin_lock(&dcache_lock);
+		mcs_lock(&dcache_lock, 0);
 		de = __d_find_alias(inode, 0);
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 	}
 	return de;
 }
@@ -389,20 +390,20 @@ void d_prune_aliases(struct inode *inode
 {
 	struct dentry *dentry;
 restart:
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (!atomic_read(&dentry->d_count)) {
 			__dget_locked(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 			dput(dentry);
 			goto restart;
 		}
 		spin_unlock(&dentry->d_lock);
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 /*
@@ -425,7 +426,7 @@ static void prune_one_dentry(struct dent
 	 * Prune ancestors.  Locking is simpler than in dput(),
 	 * because dcache_lock needs to be taken anyway.
 	 */
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	while (dentry) {
 		if (!atomic_dec_and_lock(&dentry->d_count, &dentry->d_lock))
 			return;
@@ -435,7 +436,7 @@ static void prune_one_dentry(struct dent
 		dentry_lru_del_init(dentry);
 		__d_drop(dentry);
 		dentry = d_kill(dentry);
-		spin_lock(&dcache_lock);
+		mcs_lock(&dcache_lock, 0);
 	}
 }
 
@@ -456,7 +457,7 @@ static void __shrink_dcache_sb(struct su
 
 	BUG_ON(!sb);
 	BUG_ON((flags & DCACHE_REFERENCED) && count == NULL);
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	if (count != NULL)
 		/* called from prune_dcache() and shrink_dcache_parent() */
 		cnt = *count;
@@ -487,7 +488,7 @@ restart:
 				if (!cnt)
 					break;
 			}
-			cond_resched_lock(&dcache_lock);
+//			cond_resched_lock(&dcache_lock);
 		}
 	}
 	while (!list_empty(&tmp)) {
@@ -505,7 +506,7 @@ restart:
 		}
 		prune_one_dentry(dentry);
 		/* dentry->d_lock was dropped in prune_one_dentry() */
-		cond_resched_lock(&dcache_lock);
+//		cond_resched_lock(&dcache_lock);
 	}
 	if (count == NULL && !list_empty(&sb->s_dentry_lru))
 		goto restart;
@@ -513,7 +514,7 @@ restart:
 		*count = cnt;
 	if (!list_empty(&referenced))
 		list_splice(&referenced, &sb->s_dentry_lru);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 /**
@@ -535,7 +536,7 @@ static void prune_dcache(int count)
 
 	if (unused == 0 || count == 0)
 		return;
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 restart:
 	if (count >= unused)
 		prune_ratio = 1;
@@ -571,11 +572,11 @@ restart:
 		if (down_read_trylock(&sb->s_umount)) {
 			if ((sb->s_root != NULL) &&
 			    (!list_empty(&sb->s_dentry_lru))) {
-				spin_unlock(&dcache_lock);
+				mcs_unlock(&dcache_lock, 0);
 				__shrink_dcache_sb(sb, &w_count,
 						DCACHE_REFERENCED);
 				pruned -= w_count;
-				spin_lock(&dcache_lock);
+				mcs_lock(&dcache_lock, 0);
 			}
 			up_read(&sb->s_umount);
 		}
@@ -591,7 +592,7 @@ restart:
 		}
 	}
 	spin_unlock(&sb_lock);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 /**
@@ -620,10 +621,10 @@ static void shrink_dcache_for_umount_sub
 	BUG_ON(!IS_ROOT(dentry));
 
 	/* detach this root from the system */
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	dentry_lru_del_init(dentry);
 	__d_drop(dentry);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 	for (;;) {
 		/* descend to the first leaf in the current subtree */
@@ -632,14 +633,14 @@ static void shrink_dcache_for_umount_sub
 
 			/* this is a branch with children - detach all of them
 			 * from the system in one go */
-			spin_lock(&dcache_lock);
+			mcs_lock(&dcache_lock, 0);
 			list_for_each_entry(loop, &dentry->d_subdirs,
 					    d_u.d_child) {
 				dentry_lru_del_init(loop);
 				__d_drop(loop);
-				cond_resched_lock(&dcache_lock);
+//				cond_resched_lock(&dcache_lock);
 			}
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 
 			/* move to the first child */
 			dentry = list_entry(dentry->d_subdirs.next,
@@ -702,9 +703,9 @@ static void shrink_dcache_for_umount_sub
 	}
 out:
 	/* several dentries were freed, need to correct nr_dentry */
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	dentry_stat.nr_dentry -= detached;
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 /*
@@ -755,7 +756,7 @@ int have_submounts(struct dentry *parent
 	struct dentry *this_parent = parent;
 	struct list_head *next;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	if (d_mountpoint(parent))
 		goto positive;
 repeat:
@@ -781,10 +782,10 @@ resume:
 		this_parent = this_parent->d_parent;
 		goto resume;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	return 0; /* No mount points found in tree */
 positive:
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	return 1;
 }
 
@@ -808,7 +809,7 @@ static int select_parent(struct dentry *
 	struct list_head *next;
 	int found = 0;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -852,7 +853,7 @@ resume:
 		goto resume;
 	}
 out:
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	return found;
 }
 
@@ -958,11 +959,11 @@ struct dentry *d_alloc(struct dentry * p
 		INIT_LIST_HEAD(&dentry->d_u.d_child);
 	}
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	if (parent)
 		list_add(&dentry->d_u.d_child, &parent->d_subdirs);
 	dentry_stat.nr_dentry++;
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 	return dentry;
 }
@@ -995,12 +996,12 @@ struct dentry *d_alloc_name(struct dentr
 void d_instantiate(struct dentry *entry, struct inode * inode)
 {
 	BUG_ON(!list_empty(&entry->d_alias));
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	if (inode)
 		list_add(&entry->d_alias, &inode->i_dentry);
 	entry->d_inode = inode;
 	fsnotify_d_instantiate(entry, inode);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	security_d_instantiate(entry, inode);
 }
 
@@ -1060,9 +1061,9 @@ struct dentry *d_instantiate_unique(stru
 
 	BUG_ON(!list_empty(&entry->d_alias));
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	result = __d_instantiate_unique(entry, inode);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 	if (!result) {
 		security_d_instantiate(entry, inode);
@@ -1147,7 +1148,7 @@ struct dentry * d_alloc_anon(struct inod
 
 	tmp->d_parent = tmp; /* make sure dput doesn't croak */
 	
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	res = __d_find_alias(inode, 0);
 	if (!res) {
 		/* attach a disconnected dentry */
@@ -1165,7 +1166,7 @@ struct dentry * d_alloc_anon(struct inod
 
 		inode = NULL; /* don't drop reference */
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 	if (inode)
 		iput(inode);
@@ -1196,12 +1197,12 @@ struct dentry *d_splice_alias(struct ino
 	struct dentry *new = NULL;
 
 	if (inode && S_ISDIR(inode->i_mode)) {
-		spin_lock(&dcache_lock);
+		mcs_lock(&dcache_lock, 0);
 		new = __d_find_alias(inode, 1);
 		if (new) {
 			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
 			fsnotify_d_instantiate(new, inode);
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 			security_d_instantiate(new, inode);
 			d_rehash(dentry);
 			d_move(new, dentry);
@@ -1211,7 +1212,7 @@ struct dentry *d_splice_alias(struct ino
 			list_add(&dentry->d_alias, &inode->i_dentry);
 			dentry->d_inode = inode;
 			fsnotify_d_instantiate(dentry, inode);
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 			security_d_instantiate(dentry, inode);
 			d_rehash(dentry);
 		}
@@ -1286,7 +1287,7 @@ struct dentry *d_add_ci(struct dentry *d
 		d_instantiate(found, inode);
 		return found;
 	}
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	if (list_empty(&inode->i_dentry)) {
 		/*
 		 * Directory without a 'disconnected' dentry; we need to do
@@ -1295,7 +1296,7 @@ struct dentry *d_add_ci(struct dentry *d
 		 */
 		list_add(&found->d_alias, &inode->i_dentry);
 		found->d_inode = inode;
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 		security_d_instantiate(found, inode);
 		return found;
 	}
@@ -1305,7 +1306,7 @@ struct dentry *d_add_ci(struct dentry *d
 	 */
 	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
 	dget_locked(new);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	/* Do security vodoo. */
 	security_d_instantiate(found, inode);
 	/* Move new in place of found. */
@@ -1474,7 +1475,7 @@ int d_validate(struct dentry *dentry, st
 	if (dentry->d_parent != dparent)
 		goto out;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	base = d_hash(dparent, dentry->d_name.hash);
 	hlist_for_each(lhp,base) { 
 		/* hlist_for_each_entry_rcu() not required for d_hash list
@@ -1482,11 +1483,11 @@ int d_validate(struct dentry *dentry, st
 		 */
 		if (dentry == hlist_entry(lhp, struct dentry, d_hash)) {
 			__dget_locked(dentry);
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 			return 1;
 		}
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 out:
 	return 0;
 }
@@ -1518,7 +1519,7 @@ void d_delete(struct dentry * dentry)
 	/*
 	 * Are we the only user?
 	 */
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
 	if (atomic_read(&dentry->d_count) == 1) {
@@ -1531,7 +1532,7 @@ void d_delete(struct dentry * dentry)
 		__d_drop(dentry);
 
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 	fsnotify_nameremove(dentry, isdir);
 }
@@ -1557,11 +1558,11 @@ static void _d_rehash(struct dentry * en
  
 void d_rehash(struct dentry * entry)
 {
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	spin_lock(&entry->d_lock);
 	_d_rehash(entry);
 	spin_unlock(&entry->d_lock);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 #define do_switch(x,y) do { \
@@ -1707,9 +1708,9 @@ already_unhashed:
 
 void d_move(struct dentry * dentry, struct dentry * target)
 {
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	d_move_locked(dentry, target);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 /*
@@ -1762,7 +1763,7 @@ out_unalias:
 	d_move_locked(alias, dentry);
 	ret = alias;
 out_err:
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	if (m2)
 		mutex_unlock(m2);
 	if (m1)
@@ -1816,7 +1817,7 @@ struct dentry *d_materialise_unique(stru
 
 	BUG_ON(!d_unhashed(dentry));
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 
 	if (!inode) {
 		actual = dentry;
@@ -1859,7 +1860,7 @@ found_lock:
 found:
 	_d_rehash(actual);
 	spin_unlock(&actual->d_lock);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 out_nolock:
 	if (actual == dentry) {
 		security_d_instantiate(dentry, inode);
@@ -1870,7 +1871,7 @@ out_nolock:
 	return actual;
 
 shouldnt_be_hashed:
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	BUG();
 }
 
@@ -1999,10 +2000,10 @@ char *d_path(const struct path *path, ch
 	root = current->fs->root;
 	path_get(&root);
 	read_unlock(&current->fs->lock);
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	tmp = root;
 	res = __d_path(path, &tmp, buf, buflen);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	path_put(&root);
 	return res;
 }
@@ -2036,7 +2037,7 @@ char *dentry_path(struct dentry *dentry,
 	char *end = buf + buflen;
 	char *retval;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	prepend(&end, &buflen, "\0", 1);
 	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
 		(prepend(&end, &buflen, "//deleted", 9) != 0))
@@ -2058,10 +2059,10 @@ char *dentry_path(struct dentry *dentry,
 		retval = end;
 		dentry = parent;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	return retval;
 Elong:
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	return ERR_PTR(-ENAMETOOLONG);
 }
 
@@ -2101,14 +2102,14 @@ asmlinkage long sys_getcwd(char __user *
 
 	error = -ENOENT;
 	/* Has the current directory has been unlinked? */
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	if (IS_ROOT(pwd.dentry) || !d_unhashed(pwd.dentry)) {
 		unsigned long len;
 		struct path tmp = root;
 		char * cwd;
 
 		cwd = __d_path(&pwd, &tmp, page, PAGE_SIZE);
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 
 		error = PTR_ERR(cwd);
 		if (IS_ERR(cwd))
@@ -2122,7 +2123,7 @@ asmlinkage long sys_getcwd(char __user *
 				error = -EFAULT;
 		}
 	} else
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 
 out:
 	path_put(&pwd);
@@ -2184,7 +2185,7 @@ void d_genocide(struct dentry *root)
 	struct dentry *this_parent = root;
 	struct list_head *next;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -2206,7 +2207,7 @@ resume:
 		this_parent = this_parent->d_parent;
 		goto resume;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 /**
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -7,6 +7,7 @@
 #include <linux/spinlock.h>
 #include <linux/cache.h>
 #include <linux/rcupdate.h>
+#include <linux/mcslock.h>
 
 struct nameidata;
 struct path;
@@ -177,7 +178,7 @@ d_iput:		no		no		no       yes
 
 #define DCACHE_INOTIFY_PARENT_WATCHED	0x0020 /* Parent inode is watched */
 
-extern spinlock_t dcache_lock;
+extern mcslock_t dcache_lock;
 extern seqlock_t rename_lock;
 
 /**
@@ -206,11 +207,11 @@ static inline void __d_drop(struct dentr
 
 static inline void d_drop(struct dentry *dentry)
 {
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	spin_lock(&dentry->d_lock);
  	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 static inline int dname_external(struct dentry *dentry)
Index: linux-2.6/fs/configfs/configfs_internal.h
===================================================================
--- linux-2.6.orig/fs/configfs/configfs_internal.h
+++ linux-2.6/fs/configfs/configfs_internal.h
@@ -117,7 +117,7 @@ static inline struct config_item *config
 {
 	struct config_item * item = NULL;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	if (!d_unhashed(dentry)) {
 		struct configfs_dirent * sd = dentry->d_fsdata;
 		if (sd->s_type & CONFIGFS_ITEM_LINK) {
@@ -126,7 +126,7 @@ static inline struct config_item *config
 		} else
 			item = config_item_get(sd->s_element);
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 	return item;
 }
Index: linux-2.6/fs/configfs/inode.c
===================================================================
--- linux-2.6.orig/fs/configfs/inode.c
+++ linux-2.6/fs/configfs/inode.c
@@ -218,17 +218,17 @@ void configfs_drop_dentry(struct configf
 	struct dentry * dentry = sd->s_dentry;
 
 	if (dentry) {
-		spin_lock(&dcache_lock);
+		mcs_lock(&dcache_lock, 0);
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry) && dentry->d_inode)) {
 			dget_locked(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 			simple_unlink(parent->d_inode, dentry);
 		} else {
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 		}
 	}
 }
Index: linux-2.6/fs/inotify.c
===================================================================
--- linux-2.6.orig/fs/inotify.c
+++ linux-2.6/fs/inotify.c
@@ -163,7 +163,7 @@ static void set_dentry_child_flags(struc
 {
 	struct dentry *alias;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
 		struct dentry *child;
 
@@ -179,7 +179,7 @@ static void set_dentry_child_flags(struc
 			spin_unlock(&child->d_lock);
 		}
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 /*
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -95,7 +95,7 @@ loff_t dcache_dir_lseek(struct file *fil
 			struct dentry *cursor = file->private_data;
 			loff_t n = file->f_pos - 2;
 
-			spin_lock(&dcache_lock);
+			mcs_lock(&dcache_lock, 0);
 			list_del(&cursor->d_u.d_child);
 			p = file->f_path.dentry->d_subdirs.next;
 			while (n && p != &file->f_path.dentry->d_subdirs) {
@@ -106,7 +106,7 @@ loff_t dcache_dir_lseek(struct file *fil
 				p = p->next;
 			}
 			list_add_tail(&cursor->d_u.d_child, p);
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 		}
 	}
 	mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
@@ -149,7 +149,7 @@ int dcache_readdir(struct file * filp, v
 			i++;
 			/* fallthrough */
 		default:
-			spin_lock(&dcache_lock);
+			mcs_lock(&dcache_lock, 0);
 			if (filp->f_pos == 2)
 				list_move(q, &dentry->d_subdirs);
 
@@ -159,19 +159,19 @@ int dcache_readdir(struct file * filp, v
 				if (d_unhashed(next) || !next->d_inode)
 					continue;
 
-				spin_unlock(&dcache_lock);
+				mcs_unlock(&dcache_lock, 0);
 				if (filldir(dirent, next->d_name.name, 
 					    next->d_name.len, filp->f_pos, 
 					    next->d_inode->i_ino, 
 					    dt_type(next->d_inode)) < 0)
 					return 0;
-				spin_lock(&dcache_lock);
+				mcs_lock(&dcache_lock, 0);
 				/* next is still alive */
 				list_move(q, p);
 				p = q;
 				filp->f_pos++;
 			}
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 	}
 	return 0;
 }
@@ -273,13 +273,13 @@ int simple_empty(struct dentry *dentry)
 	struct dentry *child;
 	int ret = 0;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child)
 		if (simple_positive(child))
 			goto out;
 	ret = 1;
 out:
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	return ret;
 }
 
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -776,14 +776,14 @@ static __always_inline void follow_dotdo
 			break;
 		}
                 read_unlock(&fs->lock);
-		spin_lock(&dcache_lock);
+		mcs_lock(&dcache_lock, 0);
 		if (nd->path.dentry != nd->path.mnt->mnt_root) {
 			nd->path.dentry = dget(nd->path.dentry->d_parent);
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 			dput(old);
 			break;
 		}
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 		spin_lock(&vfsmount_lock);
 		parent = nd->path.mnt->mnt_parent;
 		if (parent == nd->path.mnt) {
@@ -2125,12 +2125,12 @@ void dentry_unhash(struct dentry *dentry
 {
 	dget(dentry);
 	shrink_dcache_parent(dentry);
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	spin_lock(&dentry->d_lock);
 	if (atomic_read(&dentry->d_count) == 2)
 		__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 int vfs_rmdir(struct inode *dir, struct dentry *dentry)
Index: linux-2.6/fs/seq_file.c
===================================================================
--- linux-2.6.orig/fs/seq_file.c
+++ linux-2.6/fs/seq_file.c
@@ -412,9 +412,9 @@ int seq_path_root(struct seq_file *m, st
 		char *s = m->buf + m->count;
 		char *p;
 
-		spin_lock(&dcache_lock);
+		mcs_lock(&dcache_lock, 0);
 		p = __d_path(path, root, s, m->size - m->count);
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 		err = PTR_ERR(p);
 		if (!IS_ERR(p)) {
 			s = mangle_path(s, p, esc);
Index: linux-2.6/fs/sysfs/dir.c
===================================================================
--- linux-2.6.orig/fs/sysfs/dir.c
+++ linux-2.6/fs/sysfs/dir.c
@@ -520,7 +520,7 @@ static void sysfs_drop_dentry(struct sys
 	 * dput to immediately free the dentry  if it is not in use.
 	 */
 repeat:
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		if (d_unhashed(dentry))
 			continue;
@@ -528,11 +528,11 @@ repeat:
 		spin_lock(&dentry->d_lock);
 		__d_drop(dentry);
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 		dput(dentry);
 		goto repeat;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 	/* adjust nlink and update timestamp */
 	mutex_lock(&inode->i_mutex);
Index: linux-2.6/lib/dec_and_lock.c
===================================================================
--- linux-2.6.orig/lib/dec_and_lock.c
+++ linux-2.6/lib/dec_and_lock.c
@@ -1,5 +1,6 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/mcslock.h>
 #include <asm/atomic.h>
 
 /*
@@ -31,5 +32,20 @@ int _atomic_dec_and_lock(atomic_t *atomi
 	spin_unlock(lock);
 	return 0;
 }
-
 EXPORT_SYMBOL(_atomic_dec_and_lock);
+
+int atomic_dec_and_mcslock(atomic_t *atomic, mcslock_t *lock, int nest)
+{
+#ifdef CONFIG_SMP
+	/* Subtract 1 from counter unless that drops it to 0 (ie. it was 1) */
+	if (atomic_add_unless(atomic, -1, 1))
+		return 0;
+#endif
+	/* Otherwise do it the slow way */
+	mcs_lock(lock, nest);
+	if (atomic_dec_and_test(atomic))
+		return 1;
+	mcs_unlock(lock, nest);
+	return 0;
+}
+EXPORT_SYMBOL(atomic_dec_and_mcslock);
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/inode.c
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
@@ -159,18 +159,18 @@ static void spufs_prune_dir(struct dentr
 
 	mutex_lock(&dir->d_inode->i_mutex);
 	list_for_each_entry_safe(dentry, tmp, &dir->d_subdirs, d_u.d_child) {
-		spin_lock(&dcache_lock);
+		mcs_lock(&dcache_lock, 0);
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry)) && dentry->d_inode) {
 			dget_locked(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			simple_unlink(dir->d_inode, dentry);
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 			dput(dentry);
 		} else {
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 		}
 	}
 	shrink_dcache_parent(dir);
Index: linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ipath/ipath_fs.c
+++ linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -275,17 +275,17 @@ static int remove_file(struct dentry *pa
 		goto bail;
 	}
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
 		dget_locked(tmp);
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 		simple_unlink(parent->d_inode, tmp);
 	} else {
 		spin_unlock(&tmp->d_lock);
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 	}
 
 	ret = 0;
Index: linux-2.6/drivers/usb/core/inode.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/inode.c
+++ linux-2.6/drivers/usb/core/inode.c
@@ -342,17 +342,17 @@ static int usbfs_empty (struct dentry *d
 {
 	struct list_head *list;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 
 	list_for_each(list, &dentry->d_subdirs) {
 		struct dentry *de = list_entry(list, struct dentry, d_u.d_child);
 		if (usbfs_positive(de)) {
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 			return 0;
 		}
 	}
 
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	return 1;
 }
 
Index: linux-2.6/fs/affs/amigaffs.c
===================================================================
--- linux-2.6.orig/fs/affs/amigaffs.c
+++ linux-2.6/fs/affs/amigaffs.c
@@ -128,7 +128,7 @@ affs_fix_dcache(struct dentry *dentry, u
 	void *data = dentry->d_fsdata;
 	struct list_head *head, *next;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	head = &inode->i_dentry;
 	next = head->next;
 	while (next != head) {
@@ -139,7 +139,7 @@ affs_fix_dcache(struct dentry *dentry, u
 		}
 		next = next->next;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 
Index: linux-2.6/fs/autofs4/expire.c
===================================================================
--- linux-2.6.orig/fs/autofs4/expire.c
+++ linux-2.6/fs/autofs4/expire.c
@@ -146,7 +146,7 @@ static int autofs4_tree_busy(struct vfsm
 	if (!simple_positive(top))
 		return 1;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	for (p = top; p; p = next_dentry(p, top)) {
 		/* Negative dentry - give up */
 		if (!simple_positive(p))
@@ -156,7 +156,7 @@ static int autofs4_tree_busy(struct vfsm
 			p, (int) p->d_name.len, p->d_name.name);
 
 		p = dget(p);
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 
 		/*
 		 * Is someone visiting anywhere in the subtree ?
@@ -193,9 +193,9 @@ static int autofs4_tree_busy(struct vfsm
 			}
 		}
 		dput(p);
-		spin_lock(&dcache_lock);
+		mcs_lock(&dcache_lock, 0);
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 	/* Timeout of a tree mount is ultimately determined by its top dentry */
 	if (!autofs4_can_expire(top, timeout, do_now))
@@ -214,7 +214,7 @@ static struct dentry *autofs4_check_leav
 	DPRINTK("parent %p %.*s",
 		parent, (int)parent->d_name.len, parent->d_name.name);
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	for (p = parent; p; p = next_dentry(p, parent)) {
 		/* Negative dentry - give up */
 		if (!simple_positive(p))
@@ -224,7 +224,7 @@ static struct dentry *autofs4_check_leav
 			p, (int) p->d_name.len, p->d_name.name);
 
 		p = dget(p);
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 
 		if (d_mountpoint(p)) {
 			/* Can we umount this guy */
@@ -237,9 +237,9 @@ static struct dentry *autofs4_check_leav
 		}
 cont:
 		dput(p);
-		spin_lock(&dcache_lock);
+		mcs_lock(&dcache_lock, 0);
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	return NULL;
 }
 
@@ -303,7 +303,7 @@ static struct dentry *autofs4_expire_ind
 	now = jiffies;
 	timeout = sbi->exp_timeout;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	next = root->d_subdirs.next;
 
 	/* On exit from the loop expire is set to a dgot dentry
@@ -318,7 +318,7 @@ static struct dentry *autofs4_expire_ind
 		}
 
 		dentry = dget(dentry);
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 
 		spin_lock(&sbi->fs_lock);
 		ino = autofs4_dentry_ino(dentry);
@@ -383,10 +383,10 @@ static struct dentry *autofs4_expire_ind
 next:
 		spin_unlock(&sbi->fs_lock);
 		dput(dentry);
-		spin_lock(&dcache_lock);
+		mcs_lock(&dcache_lock, 0);
 		next = next->next;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	return NULL;
 
 found:
@@ -396,9 +396,9 @@ found:
 	ino->flags |= AUTOFS_INF_EXPIRING;
 	init_completion(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	return expired;
 }
 
Index: linux-2.6/fs/autofs4/inode.c
===================================================================
--- linux-2.6.orig/fs/autofs4/inode.c
+++ linux-2.6/fs/autofs4/inode.c
@@ -107,7 +107,7 @@ static void autofs4_force_release(struct
 	if (!sbi->sb->s_root)
 		return;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -126,13 +126,13 @@ resume:
 		}
 
 		next = next->next;
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 
 		DPRINTK("dentry %p %.*s",
 			dentry, (int)dentry->d_name.len, dentry->d_name.name);
 
 		dput(dentry);
-		spin_lock(&dcache_lock);
+		mcs_lock(&dcache_lock, 0);
 	}
 
 	if (this_parent != sbi->sb->s_root) {
@@ -140,14 +140,14 @@ resume:
 
 		next = this_parent->d_u.d_child.next;
 		this_parent = this_parent->d_parent;
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 		DPRINTK("parent dentry %p %.*s",
 			dentry, (int)dentry->d_name.len, dentry->d_name.name);
 		dput(dentry);
-		spin_lock(&dcache_lock);
+		mcs_lock(&dcache_lock, 0);
 		goto resume;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 void autofs4_kill_sb(struct super_block *sb)
Index: linux-2.6/fs/autofs4/root.c
===================================================================
--- linux-2.6.orig/fs/autofs4/root.c
+++ linux-2.6/fs/autofs4/root.c
@@ -92,12 +92,12 @@ static int autofs4_dir_open(struct inode
 	 * autofs file system so just let the libfs routines handle
 	 * it.
 	 */
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	if (!d_mountpoint(dentry) && __simple_empty(dentry)) {
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 		return -ENOENT;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 out:
 	return dcache_dir_open(inode, file);
@@ -211,10 +211,10 @@ static void *autofs4_follow_link(struct 
 	 * multi-mount with no root mount offset. So don't try to
 	 * mount it again.
 	 */
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	if (dentry->d_flags & DCACHE_AUTOFS_PENDING ||
 	    (!d_mountpoint(dentry) && __simple_empty(dentry))) {
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 
 		status = try_to_fill_dentry(dentry, 0);
 		if (status)
@@ -222,7 +222,7 @@ static void *autofs4_follow_link(struct 
 
 		goto follow;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 follow:
 	/*
 	 * If there is no root mount it must be an autofs
@@ -293,13 +293,13 @@ static int autofs4_revalidate(struct den
 		return 0;
 
 	/* Check for a non-mountpoint directory with no contents */
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	if (S_ISDIR(dentry->d_inode->i_mode) &&
 	    !d_mountpoint(dentry) && 
 	    __simple_empty(dentry)) {
 		DPRINTK("dentry=%p %.*s, emptydir",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 
 		/* The daemon never causes a mount to trigger */
 		if (oz_mode)
@@ -315,7 +315,7 @@ static int autofs4_revalidate(struct den
 
 		return status;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 	return 1;
 }
@@ -367,7 +367,7 @@ static struct dentry *autofs4_lookup_act
 	const unsigned char *str = name->name;
 	struct list_head *p, *head;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	spin_lock(&sbi->lookup_lock);
 	head = &sbi->active_list;
 	list_for_each(p, head) {
@@ -400,14 +400,14 @@ static struct dentry *autofs4_lookup_act
 			dget(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&sbi->lookup_lock);
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 			return dentry;
 		}
 next:
 		spin_unlock(&dentry->d_lock);
 	}
 	spin_unlock(&sbi->lookup_lock);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 	return NULL;
 }
@@ -419,7 +419,7 @@ static struct dentry *autofs4_lookup_exp
 	const unsigned char *str = name->name;
 	struct list_head *p, *head;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	spin_lock(&sbi->lookup_lock);
 	head = &sbi->expiring_list;
 	list_for_each(p, head) {
@@ -452,14 +452,14 @@ static struct dentry *autofs4_lookup_exp
 			dget(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&sbi->lookup_lock);
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 			return dentry;
 		}
 next:
 		spin_unlock(&dentry->d_lock);
 	}
 	spin_unlock(&sbi->lookup_lock);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 	return NULL;
 }
@@ -704,7 +704,7 @@ static int autofs4_dir_unlink(struct ino
 
 	dir->i_mtime = CURRENT_TIME;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	spin_lock(&sbi->lookup_lock);
 	if (list_empty(&ino->expiring))
 		list_add(&ino->expiring, &sbi->expiring_list);
@@ -712,7 +712,7 @@ static int autofs4_dir_unlink(struct ino
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 	return 0;
 }
@@ -729,9 +729,9 @@ static int autofs4_dir_rmdir(struct inod
 	if (!autofs4_oz_mode(sbi))
 		return -EACCES;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	if (!list_empty(&dentry->d_subdirs)) {
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 		return -ENOTEMPTY;
 	}
 	spin_lock(&sbi->lookup_lock);
@@ -741,7 +741,7 @@ static int autofs4_dir_rmdir(struct inod
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 	if (atomic_dec_and_test(&ino->count)) {
 		p_ino = autofs4_dentry_ino(dentry->d_parent);
Index: linux-2.6/fs/autofs4/waitq.c
===================================================================
--- linux-2.6.orig/fs/autofs4/waitq.c
+++ linux-2.6/fs/autofs4/waitq.c
@@ -190,12 +190,12 @@ static int autofs4_getpath(struct autofs
 	char *p;
 	int len = 0;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	for (tmp = dentry ; tmp != root ; tmp = tmp->d_parent)
 		len += tmp->d_name.len + 1;
 
 	if (!len || --len > NAME_MAX) {
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 		return 0;
 	}
 
@@ -208,7 +208,7 @@ static int autofs4_getpath(struct autofs
 		p -= tmp->d_name.len;
 		strncpy(p, tmp->d_name.name, tmp->d_name.len);
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 	return len;
 }
Index: linux-2.6/fs/coda/cache.c
===================================================================
--- linux-2.6.orig/fs/coda/cache.c
+++ linux-2.6/fs/coda/cache.c
@@ -86,7 +86,7 @@ static void coda_flag_children(struct de
 	struct list_head *child;
 	struct dentry *de;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	list_for_each(child, &parent->d_subdirs)
 	{
 		de = list_entry(child, struct dentry, d_u.d_child);
@@ -95,7 +95,7 @@ static void coda_flag_children(struct de
 			continue;
 		coda_flag_inode(de->d_inode, flag);
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	return; 
 }
 
Index: linux-2.6/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.orig/fs/exportfs/expfs.c
+++ linux-2.6/fs/exportfs/expfs.c
@@ -46,20 +46,20 @@ find_acceptable_alias(struct dentry *res
 	if (acceptable(context, result))
 		return result;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	list_for_each_entry(dentry, &result->d_inode->i_dentry, d_alias) {
 		dget_locked(dentry);
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 		if (toput)
 			dput(toput);
 		if (dentry != result && acceptable(context, dentry)) {
 			dput(result);
 			return dentry;
 		}
-		spin_lock(&dcache_lock);
+		mcs_lock(&dcache_lock, 0);
 		toput = dentry;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 	if (toput)
 		dput(toput);
Index: linux-2.6/fs/ncpfs/dir.c
===================================================================
--- linux-2.6.orig/fs/ncpfs/dir.c
+++ linux-2.6/fs/ncpfs/dir.c
@@ -364,7 +364,7 @@ ncp_dget_fpos(struct dentry *dentry, str
 	}
 
 	/* If a pointer is invalid, we search the dentry. */
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dent = list_entry(next, struct dentry, d_u.d_child);
@@ -373,12 +373,12 @@ ncp_dget_fpos(struct dentry *dentry, str
 				dget_locked(dent);
 			else
 				dent = NULL;
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 			goto out;
 		}
 		next = next->next;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	return NULL;
 
 out:
Index: linux-2.6/fs/ncpfs/ncplib_kernel.h
===================================================================
--- linux-2.6.orig/fs/ncpfs/ncplib_kernel.h
+++ linux-2.6/fs/ncpfs/ncplib_kernel.h
@@ -192,7 +192,7 @@ ncp_renew_dentries(struct dentry *parent
 	struct list_head *next;
 	struct dentry *dentry;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dentry = list_entry(next, struct dentry, d_u.d_child);
@@ -204,7 +204,7 @@ ncp_renew_dentries(struct dentry *parent
 
 		next = next->next;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 static inline void
@@ -214,7 +214,7 @@ ncp_invalidate_dircache_entries(struct d
 	struct list_head *next;
 	struct dentry *dentry;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dentry = list_entry(next, struct dentry, d_u.d_child);
@@ -222,7 +222,7 @@ ncp_invalidate_dircache_entries(struct d
 		ncp_age_dentry(server, dentry);
 		next = next->next;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 struct ncp_cache_head {
Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c
+++ linux-2.6/fs/nfs/dir.c
@@ -1422,11 +1422,11 @@ static int nfs_unlink(struct inode *dir,
 	dfprintk(VFS, "NFS: unlink(%s/%ld, %s)\n", dir->i_sb->s_id,
 		dir->i_ino, dentry->d_name.name);
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	spin_lock(&dentry->d_lock);
 	if (atomic_read(&dentry->d_count) > 1) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 		/* Start asynchronous writeout of the inode */
 		write_inode_now(dentry->d_inode, 0);
 		error = nfs_sillyrename(dir, dentry);
@@ -1437,7 +1437,7 @@ static int nfs_unlink(struct inode *dir,
 		need_rehash = 1;
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	error = nfs_safe_remove(dentry);
 	if (!error || error == -ENOENT) {
 		nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
Index: linux-2.6/fs/nfs/getroot.c
===================================================================
--- linux-2.6.orig/fs/nfs/getroot.c
+++ linux-2.6/fs/nfs/getroot.c
@@ -65,9 +65,9 @@ static int nfs_superblock_set_dummy_root
 		 * This again causes shrink_dcache_for_umount_subtree() to
 		 * Oops, since the test for IS_ROOT() will fail.
 		 */
-		spin_lock(&dcache_lock);
+		mcs_lock(&dcache_lock, 0);
 		list_del_init(&sb->s_root->d_alias);
-		spin_unlock(&dcache_lock);
+		mcs_unlock(&dcache_lock, 0);
 	}
 	return 0;
 }
Index: linux-2.6/fs/nfs/namespace.c
===================================================================
--- linux-2.6.orig/fs/nfs/namespace.c
+++ linux-2.6/fs/nfs/namespace.c
@@ -53,7 +53,7 @@ char *nfs_path(const char *base,
 
 	*--end = '\0';
 	buflen--;
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	while (!IS_ROOT(dentry) && dentry != droot) {
 		namelen = dentry->d_name.len;
 		buflen -= namelen + 1;
@@ -64,7 +64,7 @@ char *nfs_path(const char *base,
 		*--end = '/';
 		dentry = dentry->d_parent;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	namelen = strlen(base);
 	/* Strip off excess slashes in base string */
 	while (namelen > 0 && base[namelen - 1] == '/')
@@ -76,7 +76,7 @@ char *nfs_path(const char *base,
 	memcpy(end, base, namelen);
 	return end;
 Elong_unlock:
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 Elong:
 	return ERR_PTR(-ENAMETOOLONG);
 }
Index: linux-2.6/fs/ocfs2/dcache.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dcache.c
+++ linux-2.6/fs/ocfs2/dcache.c
@@ -139,7 +139,7 @@ struct dentry *ocfs2_find_local_alias(st
 	struct list_head *p;
 	struct dentry *dentry = NULL;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 
 	list_for_each(p, &inode->i_dentry) {
 		dentry = list_entry(p, struct dentry, d_alias);
@@ -155,7 +155,7 @@ struct dentry *ocfs2_find_local_alias(st
 		dentry = NULL;
 	}
 
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 
 	return dentry;
 }
Index: linux-2.6/fs/smbfs/cache.c
===================================================================
--- linux-2.6.orig/fs/smbfs/cache.c
+++ linux-2.6/fs/smbfs/cache.c
@@ -62,7 +62,7 @@ smb_invalidate_dircache_entries(struct d
 	struct list_head *next;
 	struct dentry *dentry;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dentry = list_entry(next, struct dentry, d_u.d_child);
@@ -70,7 +70,7 @@ smb_invalidate_dircache_entries(struct d
 		smb_age_dentry(server, dentry);
 		next = next->next;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 /*
@@ -96,7 +96,7 @@ smb_dget_fpos(struct dentry *dentry, str
 	}
 
 	/* If a pointer is invalid, we search the dentry. */
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dent = list_entry(next, struct dentry, d_u.d_child);
@@ -111,7 +111,7 @@ smb_dget_fpos(struct dentry *dentry, str
 	}
 	dent = NULL;
 out_unlock:
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	return dent;
 }
 
Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c
+++ linux-2.6/kernel/cgroup.c
@@ -645,7 +645,7 @@ static void cgroup_clear_directory(struc
 	struct list_head *node;
 
 	BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	node = dentry->d_subdirs.next;
 	while (node != &dentry->d_subdirs) {
 		struct dentry *d = list_entry(node, struct dentry, d_u.d_child);
@@ -655,15 +655,15 @@ static void cgroup_clear_directory(struc
 			 * directory with child cgroups */
 			BUG_ON(d->d_inode->i_mode & S_IFDIR);
 			d = dget_locked(d);
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 			d_delete(d);
 			simple_unlink(dentry->d_inode, d);
 			dput(d);
-			spin_lock(&dcache_lock);
+			mcs_lock(&dcache_lock, 0);
 		}
 		node = dentry->d_subdirs.next;
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 /*
@@ -673,9 +673,9 @@ static void cgroup_d_remove_dir(struct d
 {
 	cgroup_clear_directory(dentry);
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	list_del_init(&dentry->d_u.d_child);
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	remove_dir(dentry);
 }
 
Index: linux-2.6/net/sunrpc/rpc_pipe.c
===================================================================
--- linux-2.6.orig/net/sunrpc/rpc_pipe.c
+++ linux-2.6/net/sunrpc/rpc_pipe.c
@@ -533,7 +533,7 @@ static void rpc_depopulate(struct dentry
 
 	mutex_lock_nested(&dir->i_mutex, I_MUTEX_CHILD);
 repeat:
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	list_for_each_safe(pos, next, &parent->d_subdirs) {
 		dentry = list_entry(pos, struct dentry, d_u.d_child);
 		if (!dentry->d_inode ||
@@ -551,7 +551,7 @@ repeat:
 		} else
 			spin_unlock(&dentry->d_lock);
 	}
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 	if (n) {
 		do {
 			dentry = dvec[--n];
Index: linux-2.6/security/selinux/selinuxfs.c
===================================================================
--- linux-2.6.orig/security/selinux/selinuxfs.c
+++ linux-2.6/security/selinux/selinuxfs.c
@@ -1011,7 +1011,7 @@ static void sel_remove_entries(struct de
 {
 	struct list_head *node;
 
-	spin_lock(&dcache_lock);
+	mcs_lock(&dcache_lock, 0);
 	node = de->d_subdirs.next;
 	while (node != &de->d_subdirs) {
 		struct dentry *d = list_entry(node, struct dentry, d_u.d_child);
@@ -1019,16 +1019,16 @@ static void sel_remove_entries(struct de
 
 		if (d->d_inode) {
 			d = dget_locked(d);
-			spin_unlock(&dcache_lock);
+			mcs_unlock(&dcache_lock, 0);
 			d_delete(d);
 			simple_unlink(de->d_inode, d);
 			dput(d);
-			spin_lock(&dcache_lock);
+			mcs_lock(&dcache_lock, 0);
 		}
 		node = de->d_subdirs.next;
 	}
 
-	spin_unlock(&dcache_lock);
+	mcs_unlock(&dcache_lock, 0);
 }
 
 #define BOOL_DIR_NAME "booleans"
