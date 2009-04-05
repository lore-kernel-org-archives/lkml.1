Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbZDETkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbZDETkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 15:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbZDETk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 15:40:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43215 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757456AbZDETkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 15:40:22 -0400
Date: Sun, 5 Apr 2009 21:39:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [GIT PULL] SLAB include file dependency fixes + kmemtrace updates
Message-ID: <20090405193944.GA12691@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest kmemtrace-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git kmemtrace-for-linus

We kept this topic separate from the main tracing tree due to the 
unexpectedly wide and messy-looking scope of the fixes Pekka needed 
to do to untangle various slab*.h, rcu*.h and fs.h dependency 
chains.

After the many preparatory fixes, the tree does a few 
straightforward changes to update kmemtrace to new-style tracing 
APIs and to sync up the user-tool-ABI.

( Please note that i rebased the tree exactly once, shortly after it 
  got finished, to make it all bisectable and reviewable: the 
  perfect insight shown in the tree now was IMHO not humanly 
  possible to achieve in advance.

  In reality the real development flow did these changes exactly
  upside down: first we did the obvious change then all the
  non-obvious (and impossible to find via code reading) hidden
  dependency fixes, based on extensive testing.

  It ended up being and looking quite a mess so the rebase was 
  justified IMHO. This looked to me to be the exception that 
  strengthens the rule, but plese let me know if this is frowned
  upon ... )

Known risks:

  - Cross-arch or rare-config build breakages

No known regressions.

 Thanks,

	Ingo

------------------>
Eduard - Gabriel Munteanu (4):
      kmemtrace, rcu: don't include unnecessary headers, allow kmemtrace w/ tracepoints
      kmemtrace: use tracepoints
      kmemtrace: kmemtrace_alloc() must fill type_id
      kmemtrace: restore original tracing data binary format, improve ABI

Ingo Molnar (6):
      kmemtrace, fs: uninline simple_transaction_set()
      kmemtrace, fs: fix linux/fdtable.h header file dependencies
      kmemtrace, rcu: fix linux/rcutree.h and linux/rcuclassic.h dependencies
      kmemtrace, rcu: fix rcu_tree_trace.c data structure dependencies
      kmemtrace, rcu: fix rcupreempt.c data structure dependencies
      kmemtrace: small cleanups

Pekka Enberg (9):
      kmemtrace, fs, security: move alloc_secdata() and free_secdata() to linux/security.h
      kmemtrace, security: fix linux/key.h header file dependencies
      kmemtrace, befs: fix slab.h dependency problem
      kmemtrace, squashfs: fix slab.h dependency problem in squasfs
      kmemtrace, kbuild: fix slab.h dependency problem in lib/decompress_inflate.c
      kmemtrace, kbuild: fix slab.h dependency problem in lib/decompress_bunzip2.c
      kmemtrace, kbuild: fix slab.h dependency problem in lib/decompress_unlzma.c
      kmemtrace, mm: fix slab.h dependency problem in mm/failslab.c
      kmemtrace: trace kfree() calls with NULL or zero-length objects


 fs/befs/debug.c            |    1 +
 fs/libfs.c                 |   16 +++
 fs/squashfs/export.c       |    1 +
 include/linux/fdtable.h    |    4 +-
 include/linux/fs.h         |   35 +-----
 include/linux/key.h        |    1 +
 include/linux/rcuclassic.h |   16 +--
 include/linux/rcupdate.h   |    1 -
 include/linux/rcupreempt.h |   53 ++------
 include/linux/rcutree.h    |   27 +----
 include/linux/security.h   |   24 ++++
 include/linux/slab_def.h   |   10 +-
 include/linux/slub_def.h   |   12 +-
 include/trace/kmemtrace.h  |   92 ++++++-------
 kernel/rcuclassic.c        |   23 +++-
 kernel/rcupreempt.c        |   48 ++++++-
 kernel/rcutree.c           |   20 +++
 kernel/rcutree.h           |   10 ++
 kernel/rcutree_trace.c     |    2 +
 kernel/trace/kmemtrace.c   |  319 ++++++++++++++++++++++++++++++-------------
 kernel/trace/trace.h       |    6 +
 lib/decompress_bunzip2.c   |    1 +
 lib/decompress_inflate.c   |    1 +
 lib/decompress_unlzma.c    |    1 +
 mm/failslab.c              |    1 +
 mm/slab.c                  |   26 ++--
 mm/slob.c                  |   30 ++---
 mm/slub.c                  |   32 ++---
 mm/util.c                  |   16 +++
 29 files changed, 493 insertions(+), 336 deletions(-)
 create mode 100644 kernel/rcutree.h

diff --git a/fs/befs/debug.c b/fs/befs/debug.c
index b8e304a..622e737 100644
--- a/fs/befs/debug.c
+++ b/fs/befs/debug.c
@@ -17,6 +17,7 @@
 #include <linux/spinlock.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
+#include <linux/slab.h>
 
 #endif				/* __KERNEL__ */
 
diff --git a/fs/libfs.c b/fs/libfs.c
index 4910a36..cd22319 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -575,6 +575,21 @@ ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
  * possibly a read which collects the result - which is stored in a
  * file-local buffer.
  */
+
+void simple_transaction_set(struct file *file, size_t n)
+{
+	struct simple_transaction_argresp *ar = file->private_data;
+
+	BUG_ON(n > SIMPLE_TRANSACTION_LIMIT);
+
+	/*
+	 * The barrier ensures that ar->size will really remain zero until
+	 * ar->data is ready for reading.
+	 */
+	smp_mb();
+	ar->size = n;
+}
+
 char *simple_transaction_get(struct file *file, const char __user *buf, size_t size)
 {
 	struct simple_transaction_argresp *ar;
@@ -820,6 +835,7 @@ EXPORT_SYMBOL(simple_sync_file);
 EXPORT_SYMBOL(simple_unlink);
 EXPORT_SYMBOL(simple_read_from_buffer);
 EXPORT_SYMBOL(memory_read_from_buffer);
+EXPORT_SYMBOL(simple_transaction_set);
 EXPORT_SYMBOL(simple_transaction_get);
 EXPORT_SYMBOL(simple_transaction_read);
 EXPORT_SYMBOL(simple_transaction_release);
diff --git a/fs/squashfs/export.c b/fs/squashfs/export.c
index 69e971d..2b1b8fe 100644
--- a/fs/squashfs/export.c
+++ b/fs/squashfs/export.c
@@ -40,6 +40,7 @@
 #include <linux/dcache.h>
 #include <linux/exportfs.h>
 #include <linux/zlib.h>
+#include <linux/slab.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 09d6c5b..a2ec74b 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -5,12 +5,14 @@
 #ifndef __LINUX_FDTABLE_H
 #define __LINUX_FDTABLE_H
 
-#include <asm/atomic.h>
 #include <linux/posix_types.h>
 #include <linux/compiler.h>
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/types.h>
+#include <linux/init.h>
+
+#include <asm/atomic.h>
 
 /*
  * The default fd array needs to be at least BITS_PER_LONG,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 61211ad..e4de2b5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2323,19 +2323,7 @@ ssize_t simple_transaction_read(struct file *file, char __user *buf,
 				size_t size, loff_t *pos);
 int simple_transaction_release(struct inode *inode, struct file *file);
 
-static inline void simple_transaction_set(struct file *file, size_t n)
-{
-	struct simple_transaction_argresp *ar = file->private_data;
-
-	BUG_ON(n > SIMPLE_TRANSACTION_LIMIT);
-
-	/*
-	 * The barrier ensures that ar->size will really remain zero until
-	 * ar->data is ready for reading.
-	 */
-	smp_mb();
-	ar->size = n;
-}
+void simple_transaction_set(struct file *file, size_t n);
 
 /*
  * simple attribute files
@@ -2382,27 +2370,6 @@ ssize_t simple_attr_read(struct file *file, char __user *buf,
 ssize_t simple_attr_write(struct file *file, const char __user *buf,
 			  size_t len, loff_t *ppos);
 
-
-#ifdef CONFIG_SECURITY
-static inline char *alloc_secdata(void)
-{
-	return (char *)get_zeroed_page(GFP_KERNEL);
-}
-
-static inline void free_secdata(void *secdata)
-{
-	free_page((unsigned long)secdata);
-}
-#else
-static inline char *alloc_secdata(void)
-{
-	return (char *)1;
-}
-
-static inline void free_secdata(void *secdata)
-{ }
-#endif	/* CONFIG_SECURITY */
-
 struct ctl_table;
 int proc_nr_files(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
diff --git a/include/linux/key.h b/include/linux/key.h
index 21d32a1..e544f46 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -20,6 +20,7 @@
 #include <linux/rbtree.h>
 #include <linux/rcupdate.h>
 #include <linux/sysctl.h>
+#include <linux/rwsem.h>
 #include <asm/atomic.h>
 
 #ifdef __KERNEL__
diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 80044a4..bfd92e1 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -36,7 +36,6 @@
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
-#include <linux/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
@@ -108,25 +107,14 @@ struct rcu_data {
 	struct rcu_head barrier;
 };
 
-DECLARE_PER_CPU(struct rcu_data, rcu_data);
-DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
-
 /*
  * Increment the quiescent state counter.
  * The counter is a bit degenerated: We do not need to know
  * how many quiescent states passed, just if there was at least
  * one since the start of the grace period. Thus just a flag.
  */
-static inline void rcu_qsctr_inc(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
-	rdp->passed_quiesc = 1;
-}
-static inline void rcu_bh_qsctr_inc(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
-	rdp->passed_quiesc = 1;
-}
+extern void rcu_qsctr_inc(int cpu);
+extern void rcu_bh_qsctr_inc(int cpu);
 
 extern int rcu_pending(int cpu);
 extern int rcu_needs_cpu(int cpu);
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 528343e..15fbb3c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -36,7 +36,6 @@
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
-#include <linux/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 #include <linux/lockdep.h>
diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index 74304b4..fce5227 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -36,34 +36,19 @@
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
-#include <linux/percpu.h>
+#include <linux/smp.h>
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
-struct rcu_dyntick_sched {
-	int dynticks;
-	int dynticks_snap;
-	int sched_qs;
-	int sched_qs_snap;
-	int sched_dynticks_snap;
-};
-
-DECLARE_PER_CPU(struct rcu_dyntick_sched, rcu_dyntick_sched);
-
-static inline void rcu_qsctr_inc(int cpu)
-{
-	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
-
-	rdssp->sched_qs++;
-}
-#define rcu_bh_qsctr_inc(cpu)
+extern void rcu_qsctr_inc(int cpu);
+static inline void rcu_bh_qsctr_inc(int cpu) { }
 
 /*
  * Someone might want to pass call_rcu_bh as a function pointer.
  * So this needs to just be a rename and not a macro function.
  *  (no parentheses)
  */
-#define call_rcu_bh	 	call_rcu
+#define call_rcu_bh		call_rcu
 
 /**
  * call_rcu_sched - Queue RCU callback for invocation after sched grace period.
@@ -117,30 +102,12 @@ extern struct rcupreempt_trace *rcupreempt_trace_cpu(int cpu);
 struct softirq_action;
 
 #ifdef CONFIG_NO_HZ
-
-static inline void rcu_enter_nohz(void)
-{
-	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
-
-	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
-	__get_cpu_var(rcu_dyntick_sched).dynticks++;
-	WARN_ON_RATELIMIT(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1, &rs);
-}
-
-static inline void rcu_exit_nohz(void)
-{
-	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
-
-	__get_cpu_var(rcu_dyntick_sched).dynticks++;
-	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
-	WARN_ON_RATELIMIT(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1),
-				&rs);
-}
-
-#else /* CONFIG_NO_HZ */
-#define rcu_enter_nohz()	do { } while (0)
-#define rcu_exit_nohz()		do { } while (0)
-#endif /* CONFIG_NO_HZ */
+extern void rcu_enter_nohz(void);
+extern void rcu_exit_nohz(void);
+#else
+# define rcu_enter_nohz()	do { } while (0)
+# define rcu_exit_nohz()	do { } while (0)
+#endif
 
 /*
  * A context switch is a grace period for rcupreempt synchronize_rcu()
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index a722fb6..0cdda00 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -33,7 +33,6 @@
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
-#include <linux/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
@@ -236,30 +235,8 @@ struct rcu_state {
 #endif /* #ifdef CONFIG_NO_HZ */
 };
 
-extern struct rcu_state rcu_state;
-DECLARE_PER_CPU(struct rcu_data, rcu_data);
-
-extern struct rcu_state rcu_bh_state;
-DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
-
-/*
- * Increment the quiescent state counter.
- * The counter is a bit degenerated: We do not need to know
- * how many quiescent states passed, just if there was at least
- * one since the start of the grace period. Thus just a flag.
- */
-static inline void rcu_qsctr_inc(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
-	rdp->passed_quiesc = 1;
-	rdp->passed_quiesc_completed = rdp->completed;
-}
-static inline void rcu_bh_qsctr_inc(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
-	rdp->passed_quiesc = 1;
-	rdp->passed_quiesc_completed = rdp->completed;
-}
+extern void rcu_qsctr_inc(int cpu);
+extern void rcu_bh_qsctr_inc(int cpu);
 
 extern int rcu_pending(int cpu);
 extern int rcu_needs_cpu(int cpu);
diff --git a/include/linux/security.h b/include/linux/security.h
index 54ed157..d5fd616 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -32,6 +32,7 @@
 #include <linux/sched.h>
 #include <linux/key.h>
 #include <linux/xfrm.h>
+#include <linux/gfp.h>
 #include <net/flow.h>
 
 /* Maximum number of letters for an LSM name string */
@@ -2953,5 +2954,28 @@ static inline void securityfs_remove(struct dentry *dentry)
 
 #endif
 
+#ifdef CONFIG_SECURITY
+
+static inline char *alloc_secdata(void)
+{
+	return (char *)get_zeroed_page(GFP_KERNEL);
+}
+
+static inline void free_secdata(void *secdata)
+{
+	free_page((unsigned long)secdata);
+}
+
+#else
+
+static inline char *alloc_secdata(void)
+{
+        return (char *)1;
+}
+
+static inline void free_secdata(void *secdata)
+{ }
+#endif /* CONFIG_SECURITY */
+
 #endif /* ! __LINUX_SECURITY_H */
 
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index f452365..5ac9b0b 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -73,8 +73,8 @@ found:
 
 		ret = kmem_cache_alloc_notrace(cachep, flags);
 
-		kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
-				     size, slab_buffer_size(cachep), flags);
+		trace_kmalloc(_THIS_IP_, ret,
+			      size, slab_buffer_size(cachep), flags);
 
 		return ret;
 	}
@@ -128,9 +128,9 @@ found:
 
 		ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_,
-					  ret, size, slab_buffer_size(cachep),
-					  flags, node);
+		trace_kmalloc_node(_THIS_IP_, ret,
+				   size, slab_buffer_size(cachep),
+				   flags, node);
 
 		return ret;
 	}
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index a1f9052..5046f90 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -233,8 +233,7 @@ static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
 	unsigned int order = get_order(size);
 	void *ret = (void *) __get_free_pages(flags | __GFP_COMP, order);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
-			     size, PAGE_SIZE << order, flags);
+	trace_kmalloc(_THIS_IP_, ret, size, PAGE_SIZE << order, flags);
 
 	return ret;
 }
@@ -255,9 +254,7 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 
 			ret = kmem_cache_alloc_notrace(s, flags);
 
-			kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC,
-					     _THIS_IP_, ret,
-					     size, s->size, flags);
+			trace_kmalloc(_THIS_IP_, ret, size, s->size, flags);
 
 			return ret;
 		}
@@ -296,9 +293,8 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 
 		ret = kmem_cache_alloc_node_notrace(s, flags, node);
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _THIS_IP_, ret,
-					  size, s->size, flags, node);
+		trace_kmalloc_node(_THIS_IP_, ret,
+				   size, s->size, flags, node);
 
 		return ret;
 	}
diff --git a/include/trace/kmemtrace.h b/include/trace/kmemtrace.h
index ad8b785..28ee69f 100644
--- a/include/trace/kmemtrace.h
+++ b/include/trace/kmemtrace.h
@@ -9,65 +9,53 @@
 
 #ifdef __KERNEL__
 
+#include <linux/tracepoint.h>
 #include <linux/types.h>
-#include <linux/marker.h>
-
-enum kmemtrace_type_id {
-	KMEMTRACE_TYPE_KMALLOC = 0,	/* kmalloc() or kfree(). */
-	KMEMTRACE_TYPE_CACHE,		/* kmem_cache_*(). */
-	KMEMTRACE_TYPE_PAGES,		/* __get_free_pages() and friends. */
-};
 
 #ifdef CONFIG_KMEMTRACE
-
 extern void kmemtrace_init(void);
-
-extern void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
-					     unsigned long call_site,
-					     const void *ptr,
-					     size_t bytes_req,
-					     size_t bytes_alloc,
-					     gfp_t gfp_flags,
-					     int node);
-
-extern void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
-				       unsigned long call_site,
-				       const void *ptr);
-
-#else /* CONFIG_KMEMTRACE */
-
+#else
 static inline void kmemtrace_init(void)
 {
 }
-
-static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
-					     unsigned long call_site,
-					     const void *ptr,
-					     size_t bytes_req,
-					     size_t bytes_alloc,
-					     gfp_t gfp_flags,
-					     int node)
-{
-}
-
-static inline void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
-				       unsigned long call_site,
-				       const void *ptr)
-{
-}
-
-#endif /* CONFIG_KMEMTRACE */
-
-static inline void kmemtrace_mark_alloc(enum kmemtrace_type_id type_id,
-					unsigned long call_site,
-					const void *ptr,
-					size_t bytes_req,
-					size_t bytes_alloc,
-					gfp_t gfp_flags)
-{
-	kmemtrace_mark_alloc_node(type_id, call_site, ptr,
-				  bytes_req, bytes_alloc, gfp_flags, -1);
-}
+#endif
+
+DECLARE_TRACE(kmalloc,
+	      TP_PROTO(unsigned long call_site,
+		      const void *ptr,
+		      size_t bytes_req,
+		      size_t bytes_alloc,
+		      gfp_t gfp_flags),
+	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
+DECLARE_TRACE(kmem_cache_alloc,
+	      TP_PROTO(unsigned long call_site,
+		      const void *ptr,
+		      size_t bytes_req,
+		      size_t bytes_alloc,
+		      gfp_t gfp_flags),
+	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
+DECLARE_TRACE(kmalloc_node,
+	      TP_PROTO(unsigned long call_site,
+		      const void *ptr,
+		      size_t bytes_req,
+		      size_t bytes_alloc,
+		      gfp_t gfp_flags,
+		      int node),
+	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
+DECLARE_TRACE(kmem_cache_alloc_node,
+	      TP_PROTO(unsigned long call_site,
+		      const void *ptr,
+		      size_t bytes_req,
+		      size_t bytes_alloc,
+		      gfp_t gfp_flags,
+		      int node),
+	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
+DECLARE_TRACE(kfree,
+	      TP_PROTO(unsigned long call_site, const void *ptr),
+	      TP_ARGS(call_site, ptr));
+DECLARE_TRACE(kmem_cache_free,
+	      TP_PROTO(unsigned long call_site, const void *ptr),
+	      TP_ARGS(call_site, ptr));
 
 #endif /* __KERNEL__ */
 
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 654c640..0f2b0b3 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -65,6 +65,7 @@ static struct rcu_ctrlblk rcu_ctrlblk = {
 	.lock = __SPIN_LOCK_UNLOCKED(&rcu_ctrlblk.lock),
 	.cpumask = CPU_BITS_NONE,
 };
+
 static struct rcu_ctrlblk rcu_bh_ctrlblk = {
 	.cur = -300,
 	.completed = -300,
@@ -73,8 +74,26 @@ static struct rcu_ctrlblk rcu_bh_ctrlblk = {
 	.cpumask = CPU_BITS_NONE,
 };
 
-DEFINE_PER_CPU(struct rcu_data, rcu_data) = { 0L };
-DEFINE_PER_CPU(struct rcu_data, rcu_bh_data) = { 0L };
+static DEFINE_PER_CPU(struct rcu_data, rcu_data);
+static DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
+
+/*
+ * Increment the quiescent state counter.
+ * The counter is a bit degenerated: We do not need to know
+ * how many quiescent states passed, just if there was at least
+ * one since the start of the grace period. Thus just a flag.
+ */
+void rcu_qsctr_inc(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
+	rdp->passed_quiesc = 1;
+}
+
+void rcu_bh_qsctr_inc(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
+	rdp->passed_quiesc = 1;
+}
 
 static int blimit = 10;
 static int qhimark = 10000;
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 5d59e85..ce97a4d 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -147,7 +147,51 @@ struct rcu_ctrlblk {
 	wait_queue_head_t sched_wq;	/* Place for rcu_sched to sleep. */
 };
 
+struct rcu_dyntick_sched {
+	int dynticks;
+	int dynticks_snap;
+	int sched_qs;
+	int sched_qs_snap;
+	int sched_dynticks_snap;
+};
+
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_dyntick_sched, rcu_dyntick_sched) = {
+	.dynticks = 1,
+};
+
+void rcu_qsctr_inc(int cpu)
+{
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
+
+	rdssp->sched_qs++;
+}
+
+#ifdef CONFIG_NO_HZ
+
+void rcu_enter_nohz(void)
+{
+	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
+
+	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
+	__get_cpu_var(rcu_dyntick_sched).dynticks++;
+	WARN_ON_RATELIMIT(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1, &rs);
+}
+
+void rcu_exit_nohz(void)
+{
+	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
+
+	__get_cpu_var(rcu_dyntick_sched).dynticks++;
+	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
+	WARN_ON_RATELIMIT(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1),
+				&rs);
+}
+
+#endif /* CONFIG_NO_HZ */
+
+
 static DEFINE_PER_CPU(struct rcu_data, rcu_data);
+
 static struct rcu_ctrlblk rcu_ctrlblk = {
 	.fliplock = __SPIN_LOCK_UNLOCKED(rcu_ctrlblk.fliplock),
 	.completed = 0,
@@ -427,10 +471,6 @@ static void __rcu_advance_callbacks(struct rcu_data *rdp)
 	}
 }
 
-DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_dyntick_sched, rcu_dyntick_sched) = {
-	.dynticks = 1,
-};
-
 #ifdef CONFIG_NO_HZ
 static DEFINE_PER_CPU(int, rcu_update_flag);
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 97ce315..7f32669 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -78,6 +78,26 @@ DEFINE_PER_CPU(struct rcu_data, rcu_data);
 struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
+/*
+ * Increment the quiescent state counter.
+ * The counter is a bit degenerated: We do not need to know
+ * how many quiescent states passed, just if there was at least
+ * one since the start of the grace period. Thus just a flag.
+ */
+void rcu_qsctr_inc(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
+	rdp->passed_quiesc = 1;
+	rdp->passed_quiesc_completed = rdp->completed;
+}
+
+void rcu_bh_qsctr_inc(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
+	rdp->passed_quiesc = 1;
+	rdp->passed_quiesc_completed = rdp->completed;
+}
+
 #ifdef CONFIG_NO_HZ
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = 1,
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
new file mode 100644
index 0000000..5e872bb
--- /dev/null
+++ b/kernel/rcutree.h
@@ -0,0 +1,10 @@
+
+/*
+ * RCU implementation internal declarations:
+ */
+extern struct rcu_state rcu_state;
+DECLARE_PER_CPU(struct rcu_data, rcu_data);
+
+extern struct rcu_state rcu_bh_state;
+DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
+
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index d6db3e8..4ee954f 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -43,6 +43,8 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 
+#include "rcutree.h"
+
 static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index ae201b3..5011f4d 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -6,14 +6,16 @@
  * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
  */
 
-#include <linux/dcache.h>
+#include <linux/tracepoint.h>
+#include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/dcache.h>
 #include <linux/fs.h>
-#include <linux/seq_file.h>
+
 #include <trace/kmemtrace.h>
 
-#include "trace.h"
 #include "trace_output.h"
+#include "trace.h"
 
 /* Select an alternative, minimalistic output than the original one */
 #define TRACE_KMEM_OPT_MINIMAL	0x1
@@ -25,14 +27,156 @@ static struct tracer_opt kmem_opts[] = {
 };
 
 static struct tracer_flags kmem_tracer_flags = {
-	.val = 0,
-	.opts = kmem_opts
+	.val			= 0,
+	.opts			= kmem_opts
 };
 
-
-static bool kmem_tracing_enabled __read_mostly;
 static struct trace_array *kmemtrace_array;
 
+/* Trace allocations */
+static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
+				   unsigned long call_site,
+				   const void *ptr,
+				   size_t bytes_req,
+				   size_t bytes_alloc,
+				   gfp_t gfp_flags,
+				   int node)
+{
+	struct trace_array *tr = kmemtrace_array;
+	struct kmemtrace_alloc_entry *entry;
+	struct ring_buffer_event *event;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	if (!event)
+		return;
+
+	entry = ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+
+	entry->ent.type		= TRACE_KMEM_ALLOC;
+	entry->type_id		= type_id;
+	entry->call_site	= call_site;
+	entry->ptr		= ptr;
+	entry->bytes_req	= bytes_req;
+	entry->bytes_alloc	= bytes_alloc;
+	entry->gfp_flags	= gfp_flags;
+	entry->node		= node;
+
+	ring_buffer_unlock_commit(tr->buffer, event);
+
+	trace_wake_up();
+}
+
+static inline void kmemtrace_free(enum kmemtrace_type_id type_id,
+				  unsigned long call_site,
+				  const void *ptr)
+{
+	struct trace_array *tr = kmemtrace_array;
+	struct kmemtrace_free_entry *entry;
+	struct ring_buffer_event *event;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+
+	entry->ent.type		= TRACE_KMEM_FREE;
+	entry->type_id		= type_id;
+	entry->call_site	= call_site;
+	entry->ptr		= ptr;
+
+	ring_buffer_unlock_commit(tr->buffer, event);
+
+	trace_wake_up();
+}
+
+static void kmemtrace_kmalloc(unsigned long call_site,
+			      const void *ptr,
+			      size_t bytes_req,
+			      size_t bytes_alloc,
+			      gfp_t gfp_flags)
+{
+	kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, call_site, ptr,
+			bytes_req, bytes_alloc, gfp_flags, -1);
+}
+
+static void kmemtrace_kmem_cache_alloc(unsigned long call_site,
+				       const void *ptr,
+				       size_t bytes_req,
+				       size_t bytes_alloc,
+				       gfp_t gfp_flags)
+{
+	kmemtrace_alloc(KMEMTRACE_TYPE_CACHE, call_site, ptr,
+			bytes_req, bytes_alloc, gfp_flags, -1);
+}
+
+static void kmemtrace_kmalloc_node(unsigned long call_site,
+				   const void *ptr,
+				   size_t bytes_req,
+				   size_t bytes_alloc,
+				   gfp_t gfp_flags,
+				   int node)
+{
+	kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, call_site, ptr,
+			bytes_req, bytes_alloc, gfp_flags, node);
+}
+
+static void kmemtrace_kmem_cache_alloc_node(unsigned long call_site,
+					    const void *ptr,
+					    size_t bytes_req,
+					    size_t bytes_alloc,
+					    gfp_t gfp_flags,
+					    int node)
+{
+	kmemtrace_alloc(KMEMTRACE_TYPE_CACHE, call_site, ptr,
+			bytes_req, bytes_alloc, gfp_flags, node);
+}
+
+static void kmemtrace_kfree(unsigned long call_site, const void *ptr)
+{
+	kmemtrace_free(KMEMTRACE_TYPE_KMALLOC, call_site, ptr);
+}
+
+static void kmemtrace_kmem_cache_free(unsigned long call_site, const void *ptr)
+{
+	kmemtrace_free(KMEMTRACE_TYPE_CACHE, call_site, ptr);
+}
+
+static int kmemtrace_start_probes(void)
+{
+	int err;
+
+	err = register_trace_kmalloc(kmemtrace_kmalloc);
+	if (err)
+		return err;
+	err = register_trace_kmem_cache_alloc(kmemtrace_kmem_cache_alloc);
+	if (err)
+		return err;
+	err = register_trace_kmalloc_node(kmemtrace_kmalloc_node);
+	if (err)
+		return err;
+	err = register_trace_kmem_cache_alloc_node(kmemtrace_kmem_cache_alloc_node);
+	if (err)
+		return err;
+	err = register_trace_kfree(kmemtrace_kfree);
+	if (err)
+		return err;
+	err = register_trace_kmem_cache_free(kmemtrace_kmem_cache_free);
+
+	return err;
+}
+
+static void kmemtrace_stop_probes(void)
+{
+	unregister_trace_kmalloc(kmemtrace_kmalloc);
+	unregister_trace_kmem_cache_alloc(kmemtrace_kmem_cache_alloc);
+	unregister_trace_kmalloc_node(kmemtrace_kmalloc_node);
+	unregister_trace_kmem_cache_alloc_node(kmemtrace_kmem_cache_alloc_node);
+	unregister_trace_kfree(kmemtrace_kfree);
+	unregister_trace_kmem_cache_free(kmemtrace_kmem_cache_free);
+}
+
 static int kmem_trace_init(struct trace_array *tr)
 {
 	int cpu;
@@ -41,14 +185,14 @@ static int kmem_trace_init(struct trace_array *tr)
 	for_each_cpu_mask(cpu, cpu_possible_map)
 		tracing_reset(tr, cpu);
 
-	kmem_tracing_enabled = true;
+	kmemtrace_start_probes();
 
 	return 0;
 }
 
 static void kmem_trace_reset(struct trace_array *tr)
 {
-	kmem_tracing_enabled = false;
+	kmemtrace_stop_probes();
 }
 
 static void kmemtrace_headers(struct seq_file *s)
@@ -66,47 +210,84 @@ static void kmemtrace_headers(struct seq_file *s)
 }
 
 /*
- * The two following functions give the original output from kmemtrace,
- * or something close to....perhaps they need some missing things
+ * The following functions give the original output from kmemtrace,
+ * plus the origin CPU, since reordering occurs in-kernel now.
  */
+
+#define KMEMTRACE_USER_ALLOC	0
+#define KMEMTRACE_USER_FREE	1
+
+struct kmemtrace_user_event {
+	u8			event_id;
+	u8			type_id;
+	u16			event_size;
+	u32			cpu;
+	u64			timestamp;
+	unsigned long		call_site;
+	unsigned long		ptr;
+};
+
+struct kmemtrace_user_event_alloc {
+	size_t			bytes_req;
+	size_t			bytes_alloc;
+	unsigned		gfp_flags;
+	int			node;
+};
+
 static enum print_line_t
-kmemtrace_print_alloc_original(struct trace_iterator *iter,
-				struct kmemtrace_alloc_entry *entry)
+kmemtrace_print_alloc_user(struct trace_iterator *iter,
+			   struct kmemtrace_alloc_entry *entry)
 {
+	struct kmemtrace_user_event_alloc *ev_alloc;
 	struct trace_seq *s = &iter->seq;
-	int ret;
+	struct kmemtrace_user_event *ev;
+
+	ev = trace_seq_reserve(s, sizeof(*ev));
+	if (!ev)
+		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Taken from the old linux/kmemtrace.h */
-	ret = trace_seq_printf(s, "type_id %d call_site %lu ptr %lu "
-	  "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d\n",
-	   entry->type_id, entry->call_site, (unsigned long) entry->ptr,
-	   (unsigned long) entry->bytes_req, (unsigned long) entry->bytes_alloc,
-	   (unsigned long) entry->gfp_flags, entry->node);
+	ev->event_id		= KMEMTRACE_USER_ALLOC;
+	ev->type_id		= entry->type_id;
+	ev->event_size		= sizeof(*ev) + sizeof(*ev_alloc);
+	ev->cpu			= iter->cpu;
+	ev->timestamp		= iter->ts;
+	ev->call_site		= entry->call_site;
+	ev->ptr			= (unsigned long)entry->ptr;
 
-	if (!ret)
+	ev_alloc = trace_seq_reserve(s, sizeof(*ev_alloc));
+	if (!ev_alloc)
 		return TRACE_TYPE_PARTIAL_LINE;
 
+	ev_alloc->bytes_req	= entry->bytes_req;
+	ev_alloc->bytes_alloc	= entry->bytes_alloc;
+	ev_alloc->gfp_flags	= entry->gfp_flags;
+	ev_alloc->node		= entry->node;
+
 	return TRACE_TYPE_HANDLED;
 }
 
 static enum print_line_t
-kmemtrace_print_free_original(struct trace_iterator *iter,
-				struct kmemtrace_free_entry *entry)
+kmemtrace_print_free_user(struct trace_iterator *iter,
+			  struct kmemtrace_free_entry *entry)
 {
 	struct trace_seq *s = &iter->seq;
-	int ret;
+	struct kmemtrace_user_event *ev;
 
-	/* Taken from the old linux/kmemtrace.h */
-	ret = trace_seq_printf(s, "type_id %d call_site %lu ptr %lu\n",
-	   entry->type_id, entry->call_site, (unsigned long) entry->ptr);
-
-	if (!ret)
+	ev = trace_seq_reserve(s, sizeof(*ev));
+	if (!ev)
 		return TRACE_TYPE_PARTIAL_LINE;
 
+	ev->event_id		= KMEMTRACE_USER_FREE;
+	ev->type_id		= entry->type_id;
+	ev->event_size		= sizeof(*ev);
+	ev->cpu			= iter->cpu;
+	ev->timestamp		= iter->ts;
+	ev->call_site		= entry->call_site;
+	ev->ptr			= (unsigned long)entry->ptr;
+
 	return TRACE_TYPE_HANDLED;
 }
 
-
 /* The two other following provide a more minimalistic output */
 static enum print_line_t
 kmemtrace_print_alloc_compress(struct trace_iterator *iter,
@@ -178,7 +359,7 @@ kmemtrace_print_alloc_compress(struct trace_iterator *iter,
 
 static enum print_line_t
 kmemtrace_print_free_compress(struct trace_iterator *iter,
-				struct kmemtrace_free_entry *entry)
+			      struct kmemtrace_free_entry *entry)
 {
 	struct trace_seq *s = &iter->seq;
 	int ret;
@@ -239,20 +420,22 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 	switch (entry->type) {
 	case TRACE_KMEM_ALLOC: {
 		struct kmemtrace_alloc_entry *field;
+
 		trace_assign_type(field, entry);
 		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
 			return kmemtrace_print_alloc_compress(iter, field);
 		else
-			return kmemtrace_print_alloc_original(iter, field);
+			return kmemtrace_print_alloc_user(iter, field);
 	}
 
 	case TRACE_KMEM_FREE: {
 		struct kmemtrace_free_entry *field;
+
 		trace_assign_type(field, entry);
 		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
 			return kmemtrace_print_free_compress(iter, field);
 		else
-			return kmemtrace_print_free_original(iter, field);
+			return kmemtrace_print_free_user(iter, field);
 	}
 
 	default:
@@ -260,70 +443,13 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 	}
 }
 
-/* Trace allocations */
-void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
-			     unsigned long call_site,
-			     const void *ptr,
-			     size_t bytes_req,
-			     size_t bytes_alloc,
-			     gfp_t gfp_flags,
-			     int node)
-{
-	struct ring_buffer_event *event;
-	struct kmemtrace_alloc_entry *entry;
-	struct trace_array *tr = kmemtrace_array;
-
-	if (!kmem_tracing_enabled)
-		return;
-
-	event = trace_buffer_lock_reserve(tr, TRACE_KMEM_ALLOC,
-					  sizeof(*entry), 0, 0);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-
-	entry->call_site = call_site;
-	entry->ptr = ptr;
-	entry->bytes_req = bytes_req;
-	entry->bytes_alloc = bytes_alloc;
-	entry->gfp_flags = gfp_flags;
-	entry->node	=	node;
-
-	trace_buffer_unlock_commit(tr, event, 0, 0);
-}
-EXPORT_SYMBOL(kmemtrace_mark_alloc_node);
-
-void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
-		       unsigned long call_site,
-		       const void *ptr)
-{
-	struct ring_buffer_event *event;
-	struct kmemtrace_free_entry *entry;
-	struct trace_array *tr = kmemtrace_array;
-
-	if (!kmem_tracing_enabled)
-		return;
-
-	event = trace_buffer_lock_reserve(tr, TRACE_KMEM_FREE,
-					  sizeof(*entry), 0, 0);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	entry->type_id	= type_id;
-	entry->call_site = call_site;
-	entry->ptr = ptr;
-
-	trace_buffer_unlock_commit(tr, event, 0, 0);
-}
-EXPORT_SYMBOL(kmemtrace_mark_free);
-
 static struct tracer kmem_tracer __read_mostly = {
-	.name		= "kmemtrace",
-	.init		= kmem_trace_init,
-	.reset		= kmem_trace_reset,
-	.print_line	= kmemtrace_print_line,
-	.print_header = kmemtrace_headers,
-	.flags		= &kmem_tracer_flags
+	.name			= "kmemtrace",
+	.init			= kmem_trace_init,
+	.reset			= kmem_trace_reset,
+	.print_line		= kmemtrace_print_line,
+	.print_header		= kmemtrace_headers,
+	.flags			= &kmem_tracer_flags
 };
 
 void kmemtrace_init(void)
@@ -335,5 +461,4 @@ static int __init init_kmem_tracer(void)
 {
 	return register_tracer(&kmem_tracer);
 }
-
 device_initcall(init_kmem_tracer);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cb0ce3f..cbc168f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -182,6 +182,12 @@ struct trace_power {
 	struct power_trace	state_data;
 };
 
+enum kmemtrace_type_id {
+	KMEMTRACE_TYPE_KMALLOC = 0,	/* kmalloc() or kfree(). */
+	KMEMTRACE_TYPE_CACHE,		/* kmem_cache_*(). */
+	KMEMTRACE_TYPE_PAGES,		/* __get_free_pages() and friends. */
+};
+
 struct kmemtrace_alloc_entry {
 	struct trace_entry	ent;
 	enum kmemtrace_type_id type_id;
diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 5d3ddb5..708e2a8 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -50,6 +50,7 @@
 #endif /* !STATIC */
 
 #include <linux/decompress/mm.h>
+#include <linux/slab.h>
 
 #ifndef INT_MAX
 #define INT_MAX 0x7fffffff
diff --git a/lib/decompress_inflate.c b/lib/decompress_inflate.c
index 839a329..e36b296 100644
--- a/lib/decompress_inflate.c
+++ b/lib/decompress_inflate.c
@@ -23,6 +23,7 @@
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
+#include <linux/slab.h>
 
 #define INBUF_LEN (16*1024)
 
diff --git a/lib/decompress_unlzma.c b/lib/decompress_unlzma.c
index 546f2f4..32123a1 100644
--- a/lib/decompress_unlzma.c
+++ b/lib/decompress_unlzma.c
@@ -34,6 +34,7 @@
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
+#include <linux/slab.h>
 
 #define	MIN(a, b) (((a) < (b)) ? (a) : (b))
 
diff --git a/mm/failslab.c b/mm/failslab.c
index 7c6ea64..9339de5 100644
--- a/mm/failslab.c
+++ b/mm/failslab.c
@@ -1,4 +1,5 @@
 #include <linux/fault-inject.h>
+#include <linux/gfp.h>
 
 static struct {
 	struct fault_attr attr;
diff --git a/mm/slab.c b/mm/slab.c
index 9ec66c3..b584002 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3565,8 +3565,8 @@ void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 {
 	void *ret = __cache_alloc(cachep, flags, __builtin_return_address(0));
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-			     obj_size(cachep), cachep->buffer_size, flags);
+	trace_kmem_cache_alloc(_RET_IP_, ret,
+			       obj_size(cachep), cachep->buffer_size, flags);
 
 	return ret;
 }
@@ -3627,9 +3627,9 @@ void *kmem_cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 	void *ret = __cache_alloc_node(cachep, flags, nodeid,
 				       __builtin_return_address(0));
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-				  obj_size(cachep), cachep->buffer_size,
-				  flags, nodeid);
+	trace_kmem_cache_alloc_node(_RET_IP_, ret,
+				    obj_size(cachep), cachep->buffer_size,
+				    flags, nodeid);
 
 	return ret;
 }
@@ -3657,9 +3657,8 @@ __do_kmalloc_node(size_t size, gfp_t flags, int node, void *caller)
 		return cachep;
 	ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-				  (unsigned long) caller, ret,
-				  size, cachep->buffer_size, flags, node);
+	trace_kmalloc_node((unsigned long) caller, ret,
+			   size, cachep->buffer_size, flags, node);
 
 	return ret;
 }
@@ -3709,9 +3708,8 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
 		return cachep;
 	ret = __cache_alloc(cachep, flags, caller);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC,
-			     (unsigned long) caller, ret,
-			     size, cachep->buffer_size, flags);
+	trace_kmalloc((unsigned long) caller, ret,
+		      size, cachep->buffer_size, flags);
 
 	return ret;
 }
@@ -3757,7 +3755,7 @@ void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 	__cache_free(cachep, objp);
 	local_irq_restore(flags);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, objp);
+	trace_kmem_cache_free(_RET_IP_, objp);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -3775,6 +3773,8 @@ void kfree(const void *objp)
 	struct kmem_cache *c;
 	unsigned long flags;
 
+	trace_kfree(_RET_IP_, objp);
+
 	if (unlikely(ZERO_OR_NULL_PTR(objp)))
 		return;
 	local_irq_save(flags);
@@ -3784,8 +3784,6 @@ void kfree(const void *objp)
 	debug_check_no_obj_freed(objp, obj_size(c));
 	__cache_free(c, (void *)objp);
 	local_irq_restore(flags);
-
-	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, objp);
 }
 EXPORT_SYMBOL(kfree);
 
diff --git a/mm/slob.c b/mm/slob.c
index 4dd6516..a2d4ab3 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -490,9 +490,8 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 		*m = size;
 		ret = (void *)m + align;
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _RET_IP_, ret,
-					  size, size + align, gfp, node);
+		trace_kmalloc_node(_RET_IP_, ret,
+				   size, size + align, gfp, node);
 	} else {
 		unsigned int order = get_order(size);
 
@@ -503,9 +502,8 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 			page->private = size;
 		}
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _RET_IP_, ret,
-					  size, PAGE_SIZE << order, gfp, node);
+		trace_kmalloc_node(_RET_IP_, ret,
+				   size, PAGE_SIZE << order, gfp, node);
 	}
 
 	return ret;
@@ -516,6 +514,8 @@ void kfree(const void *block)
 {
 	struct slob_page *sp;
 
+	trace_kfree(_RET_IP_, block);
+
 	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
 
@@ -526,8 +526,6 @@ void kfree(const void *block)
 		slob_free(m, *m + align);
 	} else
 		put_page(&sp->page);
-
-	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, block);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -599,16 +597,14 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 
 	if (c->size < PAGE_SIZE) {
 		b = slob_alloc(c->size, flags, c->align, node);
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE,
-					  _RET_IP_, b, c->size,
-					  SLOB_UNITS(c->size) * SLOB_UNIT,
-					  flags, node);
+		trace_kmem_cache_alloc_node(_RET_IP_, b, c->size,
+					    SLOB_UNITS(c->size) * SLOB_UNIT,
+					    flags, node);
 	} else {
 		b = slob_new_pages(flags, get_order(c->size), node);
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE,
-					  _RET_IP_, b, c->size,
-					  PAGE_SIZE << get_order(c->size),
-					  flags, node);
+		trace_kmem_cache_alloc_node(_RET_IP_, b, c->size,
+					    PAGE_SIZE << get_order(c->size),
+					    flags, node);
 	}
 
 	if (c->ctor)
@@ -646,7 +642,7 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
 		__kmem_cache_free(b, c->size);
 	}
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, b);
+	trace_kmem_cache_free(_RET_IP_, b);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
diff --git a/mm/slub.c b/mm/slub.c
index 7aaa121..7ab54ec 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1621,8 +1621,7 @@ void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
 	void *ret = slab_alloc(s, gfpflags, -1, _RET_IP_);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-			     s->objsize, s->size, gfpflags);
+	trace_kmem_cache_alloc(_RET_IP_, ret, s->objsize, s->size, gfpflags);
 
 	return ret;
 }
@@ -1641,8 +1640,8 @@ void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
 	void *ret = slab_alloc(s, gfpflags, node, _RET_IP_);
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
-				  s->objsize, s->size, gfpflags, node);
+	trace_kmem_cache_alloc_node(_RET_IP_, ret,
+				    s->objsize, s->size, gfpflags, node);
 
 	return ret;
 }
@@ -1767,7 +1766,7 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 
 	slab_free(s, page, x, _RET_IP_);
 
-	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, x);
+	trace_kmem_cache_free(_RET_IP_, x);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -2702,8 +2701,7 @@ void *__kmalloc(size_t size, gfp_t flags)
 
 	ret = slab_alloc(s, flags, -1, _RET_IP_);
 
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, ret,
-			     size, s->size, flags);
+	trace_kmalloc(_RET_IP_, ret, size, s->size, flags);
 
 	return ret;
 }
@@ -2729,10 +2727,9 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 	if (unlikely(size > SLUB_MAX_SIZE)) {
 		ret = kmalloc_large_node(size, flags, node);
 
-		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
-					  _RET_IP_, ret,
-					  size, PAGE_SIZE << get_order(size),
-					  flags, node);
+		trace_kmalloc_node(_RET_IP_, ret,
+				   size, PAGE_SIZE << get_order(size),
+				   flags, node);
 
 		return ret;
 	}
@@ -2744,8 +2741,7 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 
 	ret = slab_alloc(s, flags, node, _RET_IP_);
 
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, ret,
-				  size, s->size, flags, node);
+	trace_kmalloc_node(_RET_IP_, ret, size, s->size, flags, node);
 
 	return ret;
 }
@@ -2796,6 +2792,8 @@ void kfree(const void *x)
 	struct page *page;
 	void *object = (void *)x;
 
+	trace_kfree(_RET_IP_, x);
+
 	if (unlikely(ZERO_OR_NULL_PTR(x)))
 		return;
 
@@ -2806,8 +2804,6 @@ void kfree(const void *x)
 		return;
 	}
 	slab_free(page->slab, page, object, _RET_IP_);
-
-	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, x);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -3290,8 +3286,7 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
 	ret = slab_alloc(s, gfpflags, -1, caller);
 
 	/* Honor the call site pointer we recieved. */
-	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, caller, ret, size,
-			     s->size, gfpflags);
+	trace_kmalloc(caller, ret, size, s->size, gfpflags);
 
 	return ret;
 }
@@ -3313,8 +3308,7 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 	ret = slab_alloc(s, gfpflags, node, caller);
 
 	/* Honor the call site pointer we recieved. */
-	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, caller, ret,
-				  size, s->size, gfpflags, node);
+	trace_kmalloc_node(caller, ret, size, s->size, gfpflags, node);
 
 	return ret;
 }
diff --git a/mm/util.c b/mm/util.c
index 7c122e4..2599e83 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -4,6 +4,7 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/sched.h>
+#include <linux/tracepoint.h>
 #include <asm/uaccess.h>
 
 /**
@@ -236,3 +237,18 @@ int __attribute__((weak)) get_user_pages_fast(unsigned long start,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
+
+/* Tracepoints definitions. */
+DEFINE_TRACE(kmalloc);
+DEFINE_TRACE(kmem_cache_alloc);
+DEFINE_TRACE(kmalloc_node);
+DEFINE_TRACE(kmem_cache_alloc_node);
+DEFINE_TRACE(kfree);
+DEFINE_TRACE(kmem_cache_free);
+
+EXPORT_TRACEPOINT_SYMBOL(kmalloc);
+EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
+EXPORT_TRACEPOINT_SYMBOL(kmalloc_node);
+EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc_node);
+EXPORT_TRACEPOINT_SYMBOL(kfree);
+EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
