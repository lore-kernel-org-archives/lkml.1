Return-Path: <linux-kernel-owner+w=401wt.eu-S1751389AbZKLGnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbZKLGnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 01:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbZKLGnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 01:43:51 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:53468 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZKLGnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 01:43:49 -0500
Date: Thu, 12 Nov 2009 15:43:53 +0900 (JST)
Message-Id: <20091112.154353.680961628170545165.mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Subject: [PATCH][RFC] Measuring term of acquiring spinlock
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

At first, I have to say that the patch this mail contains
is *VERY ROUGH*. Because this patch affects not only spinlock
but also wide range of kernel, including VFS, MM, and process management, etc.
So I didn't format this patch to adopt to check by checkpatch.pl
and not signed.

But I strongly believe that this patch will help some
virtualization people (and some non-virtualization people).
So I want your advice and comment on this.



* Description

This patch makes the file spinlock_stats on top of the debugfs.
When user reads this file, some statistical data related to
spinlocks are printed.

e.g.

name: count longest shortest total average
lock: 0 0 0 0 0
i8259A_lock: 44 408852 3596 643488 14624
i8253_lock: 0 0 0 0 0
rtc_lock: 3 63504 6980 77740 25913
mce_state_lock: 0 0 0 0 0
cmci_discover_lock: 4 33512 20292 94544 23636
set_atomicity_lock: 4 3247864 0 7534840 1883710
lock: 0 0 0 0 0
ioapic_lock: 221 15512 1848 1264832 5723
vector_lock: 82 31312 528 174716 2130
gart_lock: 0 0 0 0 0
iommu_bitmap_lock: 0 0 0 0 0
pgd_lock: 19404 39880 42 23864027 1229
cpa_lock: 2383 24836 576 1830496 768
......

The reason why I want to obtain this is that
in the virtualization world, there is the problem
called "Lock Holder Preemption" (LHP).

LHP is well described in this paper,
http://www.amd64.org/fileadmin/user_upload/pub/2008-Friebel-LHP-GI_OS.pdf

LHP is not a trivial problem. e.g. VMware employs coscheduling
to avoid this. (source: http://communities.vmware.com/docs/DOC-4960 )
And the paper I linked describes the problem and the way to deal it
on Xen environment.

And, this is the important point, some paper including the above
measures term of acquiring spinlock.
But the authors of these didn't describe the way to measuring.
(This is wonder! Is this the secret voodoo?)

So I implemented the patch to measure the term of acquiring spinlock.
The result this patch products is the above.

But this patch contains a lot of trivial and non-trivial problems.
So I want your advices and comments.

Below is the list of problems:

1) The way of detecting the data structures of spinlock_t
   This is a trivial problem.
   Current strategy this patch employs is that
   modify DEFINE_SPINLOCK() and add __section(.spinlock.data).
   So spinlock values are located in the section .spinlock.data.

   .spinlock.data is the section specially created for spinlock_t.
   So I thought that this will be the array of spinlock_t.
   But this was not. I thinks this caused by some problem related to alignment.

   But the my lack of knowledge about ld, I employed
   temporary way to detect spinlock_t.
   The way is that after setting char * value to start of .spinlock.data,
   increment this, and if this is equal to magic of spinlock,
   obtain head address of spinlock_t by container_of() macro.
   This way is implemented in spinlock_stats_show().

   Can I make the section .spinlock.data the array of spinlock_t?

2) Affecting to wide range of kernel
   Some spinlocks are declarated with __cacheline_aligned_in_smp.
   These declarations conflict with new DEFINE_SPINLOCK(),
   because __cacheline_aligned_in_smp contains __section(.data.page_aligned).

   So I manually added the code to print these spinlocks to spinlock_stats_show().
   Like this:
#define P(spin) do {				    \
		count = atomic64_read(&spin.count); \
		total = atomic64_read(&spin.total); \
		shortest = atomic64_read(&spin.shortest); \
		seq_printf(m, "%s: %ld %ld %ld %ld %ld\n", spin.dep_map.name, count, atomic64_read(&spin.longest), \
			  (shortest == LONG_MAX) ? 0 : shortest, total, count ? total / count : 0); \
	}while(0)

	P(bdev_lock);
	P(dcache_lock);
	P(files_lock);
...

   This is very ugly, and makes bad effect for maintaining the code.

3) Overhead
   This is the result of 'perf bench sched messaging -g 20 -l 1000'
   Raw kernel:
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 20 groups == 800 processes run

     Total time: 6.457 [sec]

  Patched kernel:
# 20 sender and receiver processes per group
# 20 groups == 800 processes run

     Total time: 6.607 [sec]

  It seems that there is a little overhead.
  I'm writing this email on the patched kernel,
  and I cannot distinguish the overhead from human's perspective.

  But I cannot decide the meaning of this overhead by myself.
  How should I think about this? Can we discard this?

  Of course, I isolated the code with ifdef.
  And if this patch was merged, I'll add new Kconfig option for this patch.



... these are my proposal. Sorry for long email :-(
But, as I mentioned at first, I strongly believe that
this patch makes amount of sense!

# And I'm working of 'perf bench mem memcpy' concurrently :)

Below is the patch. Request for comments.

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 8bed055..7ebee97 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -412,7 +412,7 @@ static int block_fsync(struct file *filp, struct dentry *dentry, int datasync)
  * pseudo-fs
  */
 
-static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(bdev_lock);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK_RAW(bdev_lock);
 static struct kmem_cache * bdev_cachep __read_mostly;
 
 static struct inode *bdev_alloc_inode(struct super_block *sb)
diff --git a/fs/dcache.c b/fs/dcache.c
index a100fa3..87bb305 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -38,7 +38,7 @@
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
- __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
+ __cacheline_aligned_in_smp DEFINE_SPINLOCK_RAW(dcache_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
 EXPORT_SYMBOL(dcache_lock);
diff --git a/fs/file_table.c b/fs/file_table.c
index 8eb4404..e59de52 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -31,7 +31,7 @@ struct files_stat_struct files_stat = {
 };
 
 /* public. Not pretty! */
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(files_lock);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK_RAW(files_lock);
 
 /* SLAB cache for file structures */
 static struct kmem_cache *filp_cachep __read_mostly;
diff --git a/fs/namespace.c b/fs/namespace.c
index bdc3cb4..791dcc4 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -38,7 +38,7 @@
 #define HASH_SIZE (1UL << HASH_SHIFT)
 
 /* spinlock for vfsmount related operations, inplace of dcache_lock */
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(vfsmount_lock);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK_RAW(vfsmount_lock);
 
 static int event;
 static DEFINE_IDA(mnt_id_ida);
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b6e818f..d0da219 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -154,6 +154,10 @@
 	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
 	*(__tracepoints)						\
 	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
+	. = ALIGN(8);							\
+	VMLINUX_SYMBOL(__lock_data_start) = .; 				\
+        *(.spinlock.data) 		    				\
+        VMLINUX_SYMBOL(__lock_data_end) = .;				\
 	/* implement dynamic printk debug */				\
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___verbose) = .;                          \
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index 7a7e18f..8f75bfe 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -196,6 +196,10 @@ static inline int __spin_trylock(spinlock_t *lock)
 	preempt_disable();
 	if (_raw_spin_trylock(lock)) {
 		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+		atomic64_inc(&lock->count);
+		atomic64_set(&lock->lock_start, native_read_tsc());
+#endif
 		return 1;
 	}
 	preempt_enable();
@@ -245,6 +249,11 @@ static inline unsigned long __spin_lock_irqsave(spinlock_t *lock)
 	local_irq_save(flags);
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+	atomic64_inc(&lock->count);
+	atomic64_set(&lock->lock_start, native_read_tsc());
+#endif
+
 	/*
 	 * On lockdep we dont want the hand-coded irq-enable of
 	 * _raw_spin_lock_flags() code, because lockdep assumes
@@ -263,6 +272,10 @@ static inline void __spin_lock_irq(spinlock_t *lock)
 	local_irq_disable();
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+	atomic64_inc(&lock->count);
+	atomic64_set(&lock->lock_start, native_read_tsc());
+#endif
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
@@ -271,6 +284,10 @@ static inline void __spin_lock_bh(spinlock_t *lock)
 	local_bh_disable();
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+	atomic64_inc(&lock->count);
+	atomic64_set(&lock->lock_start, native_read_tsc());
+#endif
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
@@ -334,6 +351,10 @@ static inline void __spin_lock(spinlock_t *lock)
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+	atomic64_inc(&lock->count);
+	atomic64_set(&lock->lock_start, native_read_tsc());
+#endif
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
@@ -348,8 +369,23 @@ static inline void __write_lock(rwlock_t *lock)
 
 static inline void __spin_unlock(spinlock_t *lock)
 {
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+	long end, locked_term;
+#endif
+
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
+
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+	end = native_read_tsc();
+	locked_term = end - atomic64_read(&lock->lock_start);
+	atomic64_add(locked_term, &lock->total);
+	if (locked_term > atomic64_read(&lock->longest))
+		atomic64_set(&lock->longest, locked_term);
+	else if (locked_term < atomic64_read(&lock->shortest))
+		atomic64_set(&lock->shortest, locked_term);
+#endif
+
 	preempt_enable();
 }
 
@@ -370,24 +406,66 @@ static inline void __read_unlock(rwlock_t *lock)
 static inline void __spin_unlock_irqrestore(spinlock_t *lock,
 					    unsigned long flags)
 {
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+	long end, locked_term;
+#endif
+
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
 	local_irq_restore(flags);
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+	end = native_read_tsc();
+	locked_term = end - atomic64_read(&lock->lock_start);
+	atomic64_add(locked_term, &lock->total);
+	if (locked_term > atomic64_read(&lock->longest))
+		atomic64_set(&lock->longest, locked_term);
+	else if (locked_term < atomic64_read(&lock->shortest))
+		atomic64_set(&lock->shortest, locked_term);
+#endif
+
 	preempt_enable();
 }
 
 static inline void __spin_unlock_irq(spinlock_t *lock)
 {
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+	long end, locked_term;
+#endif
+
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
 	local_irq_enable();
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+	end = native_read_tsc();
+	locked_term = end - atomic64_read(&lock->lock_start);
+	atomic64_add(locked_term, &lock->total);
+	if (locked_term > atomic64_read(&lock->longest))
+		atomic64_set(&lock->longest, locked_term);
+	else if (locked_term < atomic64_read(&lock->shortest))
+		atomic64_set(&lock->shortest, locked_term);
+#endif
+
 	preempt_enable();
 }
 
 static inline void __spin_unlock_bh(spinlock_t *lock)
 {
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+	long end, locked_term;
+#endif
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
+
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+	end = native_read_tsc();
+	locked_term = end - atomic64_read(&lock->lock_start);
+	atomic64_add(locked_term, &lock->total);
+	if (locked_term > atomic64_read(&lock->longest))
+		atomic64_set(&lock->longest, locked_term);
+	else if (locked_term < atomic64_read(&lock->shortest))
+		atomic64_set(&lock->shortest, locked_term);
+#endif
+
 	preempt_enable_no_resched();
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 }
@@ -447,6 +525,10 @@ static inline int __spin_trylock_bh(spinlock_t *lock)
 	preempt_disable();
 	if (_raw_spin_trylock(lock)) {
 		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+		atomic64_inc(&lock->count);
+		atomic64_set(&lock->lock_start, native_read_tsc());
+#endif
 		return 1;
 	}
 	preempt_enable_no_resched();
diff --git a/include/linux/spinlock_types.h b/include/linux/spinlock_types.h
index 68d88f7..a6e0db5 100644
--- a/include/linux/spinlock_types.h
+++ b/include/linux/spinlock_types.h
@@ -29,6 +29,10 @@ typedef struct {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
 #endif
+
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+	atomic64_t lock_start, longest, count, total, shortest;
+#endif
 } spinlock_t;
 
 #define SPINLOCK_MAGIC		0xdead4ead
@@ -69,6 +73,7 @@ typedef struct {
 				.magic = SPINLOCK_MAGIC,		\
 				.owner = SPINLOCK_OWNER_INIT,		\
 				.owner_cpu = -1,			\
+          			.shortest = ATOMIC64_INIT(LONG_MAX),	\
 				SPIN_DEP_MAP_INIT(lockname) }
 #define __RW_LOCK_UNLOCKED(lockname)					\
 	(rwlock_t)	{	.raw_lock = __RAW_RW_LOCK_UNLOCKED,	\
@@ -94,7 +99,13 @@ typedef struct {
 #define SPIN_LOCK_UNLOCKED	__SPIN_LOCK_UNLOCKED(old_style_spin_init)
 #define RW_LOCK_UNLOCKED	__RW_LOCK_UNLOCKED(old_style_rw_init)
 
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+#define DEFINE_SPINLOCK(x)	spinlock_t __section(.spinlock.data) x = __SPIN_LOCK_UNLOCKED(x)
+#define DEFINE_SPINLOCK_RAW(x)	spinlock_t x = __SPIN_LOCK_UNLOCKED(x)
+#else
 #define DEFINE_SPINLOCK(x)	spinlock_t x = __SPIN_LOCK_UNLOCKED(x)
+#endif
+
 #define DEFINE_RWLOCK(x)	rwlock_t x = __RW_LOCK_UNLOCKED(x)
 
 #endif /* __LINUX_SPINLOCK_TYPES_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 166b8c4..a19b0b8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -415,7 +415,7 @@ static inline void mm_free_pgd(struct mm_struct * mm)
 #define mm_free_pgd(mm)
 #endif /* CONFIG_MMU */
 
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(mmlist_lock);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK_RAW(mmlist_lock);
 
 #define allocate_mm()	(kmem_cache_alloc(mm_cachep, GFP_KERNEL))
 #define free_mm(mm)	(kmem_cache_free(mm_cachep, (mm)))
diff --git a/kernel/pid.c b/kernel/pid.c
index d3f722d..1e4accc 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -110,7 +110,7 @@ EXPORT_SYMBOL(is_container_init);
  * For now it is easier to be safe than to prove it can't happen.
  */
 
-static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(pidmap_lock);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK_RAW(pidmap_lock);
 
 static void free_pidmap(struct upid *upid)
 {
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 5ddab73..288e1a5 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -21,6 +21,11 @@
 #include <linux/debug_locks.h>
 #include <linux/module.h>
 
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#include <asm/msr.h>
+
 #ifndef _spin_trylock
 int __lockfunc _spin_trylock(spinlock_t *lock)
 {
@@ -385,3 +390,81 @@ notrace int in_lock_functions(unsigned long addr)
 	&& addr < (unsigned long)__lock_text_end;
 }
 EXPORT_SYMBOL(in_lock_functions);
+
+#if defined(CONFIG_DEBUG_SPINLOCK) && defined(CONFIG_DEBUG_LOCK_ALLOC)
+
+extern char __lock_data_start;
+extern char __lock_data_end;
+
+extern spinlock_t bdev_lock;
+extern spinlock_t dcache_lock;
+extern spinlock_t files_lock;
+extern spinlock_t vfsmount_lock;
+extern spinlock_t mmlist_lock;
+extern spinlock_t pidmap_lock;
+extern spinlock_t kernel_flag;
+
+static int spinlock_stats_show(struct seq_file *m, void *v)
+{
+	char *_spin;
+	spinlock_t *spin;
+	long count, total, shortest;
+
+	seq_printf(m, "name: count longest shortest total average\n");
+
+	for (_spin = &__lock_data_start; _spin < &__lock_data_end; _spin++) {
+		if (*(int *)_spin != SPINLOCK_MAGIC) /* DAMMIT! */
+			continue;
+
+		spin = container_of((unsigned int *)_spin, spinlock_t, magic);
+
+		count = atomic64_read(&spin->count);
+		total = atomic64_read(&spin->total);
+		shortest = atomic64_read(&spin->shortest);
+		seq_printf(m, "%s: %ld %ld %ld %ld %ld\n", spin->dep_map.name, count, atomic64_read(&spin->longest),
+			   (shortest == LONG_MAX) ? 0 : shortest , total, count ? total / count : 0);
+	}
+
+#define P(spin) do {				    \
+		count = atomic64_read(&spin.count); \
+		total = atomic64_read(&spin.total); \
+		shortest = atomic64_read(&spin.shortest); \
+		seq_printf(m, "%s: %ld %ld %ld %ld %ld\n", spin.dep_map.name, count, atomic64_read(&spin.longest), \
+			  (shortest == LONG_MAX) ? 0 : shortest, total, count ? total / count : 0); \
+	}while(0)
+
+	P(bdev_lock);
+	P(dcache_lock);
+	P(files_lock);
+	P(vfsmount_lock);
+	P(mmlist_lock);
+	P(pidmap_lock);
+	P(kernel_flag);
+
+#undef P
+
+	return 0;
+}
+
+static int spinlock_stats_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, spinlock_stats_show, NULL);
+}
+
+static struct file_operations spinlock_stats_fops = {
+	.open		= spinlock_stats_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static __init int init_spinlock_stats(void)
+{
+	debugfs_create_file("spinlock_stats", 0644, NULL, NULL,
+			&spinlock_stats_fops);
+
+	return 0;
+}
+late_initcall(init_spinlock_stats);
+
+#endif
diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index 39f1029..87841f9 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -20,7 +20,7 @@
  *
  * Don't use in new code.
  */
-static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kernel_flag);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK_RAW(kernel_flag);
 
 
 /*
