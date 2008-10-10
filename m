Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbYJJAp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbYJJAp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 20:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbYJJApT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 20:45:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57750 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYJJApO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 20:45:14 -0400
Date: Fri, 10 Oct 2008 02:44:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] RCU updates for v2.6.28
Message-ID: <20081010004453.GA1597@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest rcu-v28-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rcu-v28-for-linus

 Thanks,

	Ingo

------------------>
Harvey Harrison (1):
      rcu: fix sparse shadowed variable warning

Hiroshi Shimamoto (2):
      rcuclassic: fix compilation NG
      rcuclassic: fix compiler warning

Ingo Molnar (2):
      rcu, debug: detect stalled grace periods, cleanups
      rcu: RCU-based detection of stalled CPUs for Classic RCU, fix

Lai Jiangshan (3):
      rcu classic: simplify the next pending batch
      rcu classic: new algorithm for callbacks-processing(v2)
      doc/RCU: fix pseudocode in rcuref.txt

Mathieu Desnoyers (1):
      rcu: add rcu_read_lock_sched() / rcu_read_unlock_sched()

Paul E. McKenney (10):
      rcu, debug: detect stalled grace periods
      rcu: prevent console flood when one CPU sees another AWOL via RCU
      rcu: classic RCU locking and memory-barrier cleanups
      rcu: fixes to include/linux/rcupreempt.h
      rcu: remove list_for_each_rcu()
      rcu: fix classic RCU locking cleanup lockdep problem
      rcu: remove redundant ACCESS_ONCE definition from rcupreempt.c
      rcu: fix locking cleanup fallout
      rcu: use irq-safe locks
      rcu: RCU-based detection of stalled CPUs for Classic RCU

Steven Rostedt (2):
      rcu: just rename call_rcu_bh instead of making it a macro
      rcu: trace fix possible mem-leak


 Documentation/RCU/checklist.txt |    2 +-
 Documentation/RCU/rcuref.txt    |   16 +-
 Documentation/RCU/whatisRCU.txt |    2 -
 include/linux/compiler.h        |    4 +-
 include/linux/rcuclassic.h      |   37 +++--
 include/linux/rculist.h         |   14 --
 include/linux/rcupdate.h        |   20 +++
 include/linux/rcupreempt.h      |   11 +-
 kernel/rcuclassic.c             |  337 +++++++++++++++++++++++++++++----------
 kernel/rcupreempt.c             |    8 -
 kernel/rcupreempt_trace.c       |    7 +-
 lib/Kconfig.debug               |   13 ++
 12 files changed, 337 insertions(+), 134 deletions(-)

diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index cf5562c..6e25340 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -210,7 +210,7 @@ over a rather long period of time, but improvements are always welcome!
 		number of updates per grace period.
 
 9.	All RCU list-traversal primitives, which include
-	rcu_dereference(), list_for_each_rcu(), list_for_each_entry_rcu(),
+	rcu_dereference(), list_for_each_entry_rcu(),
 	list_for_each_continue_rcu(), and list_for_each_safe_rcu(),
 	must be either within an RCU read-side critical section or
 	must be protected by appropriate update-side locks.  RCU
diff --git a/Documentation/RCU/rcuref.txt b/Documentation/RCU/rcuref.txt
index 451de2a..4202ad0 100644
--- a/Documentation/RCU/rcuref.txt
+++ b/Documentation/RCU/rcuref.txt
@@ -29,9 +29,9 @@ release_referenced()			delete()
 					}
 
 If this list/array is made lock free using RCU as in changing the
-write_lock() in add() and delete() to spin_lock and changing read_lock
-in search_and_reference to rcu_read_lock(), the atomic_get in
-search_and_reference could potentially hold reference to an element which
+write_lock() in add() and delete() to spin_lock() and changing read_lock()
+in search_and_reference() to rcu_read_lock(), the atomic_inc() in
+search_and_reference() could potentially hold reference to an element which
 has already been deleted from the list/array.  Use atomic_inc_not_zero()
 in this scenario as follows:
 
@@ -40,20 +40,20 @@ add()					search_and_reference()
 {					{
     alloc_object			    rcu_read_lock();
     ...					    search_for_element
-    atomic_set(&el->rc, 1);		    if (atomic_inc_not_zero(&el->rc)) {
-    write_lock(&list_lock);		        rcu_read_unlock();
+    atomic_set(&el->rc, 1);		    if (!atomic_inc_not_zero(&el->rc)) {
+    spin_lock(&list_lock);		        rcu_read_unlock();
 					        return FAIL;
     add_element				    }
     ...					    ...
-    write_unlock(&list_lock);		    rcu_read_unlock();
+    spin_unlock(&list_lock);		    rcu_read_unlock();
 }					}
 3.					4.
 release_referenced()			delete()
 {					{
-    ...					    write_lock(&list_lock);
+    ...					    spin_lock(&list_lock);
     if (atomic_dec_and_test(&el->rc))       ...
         call_rcu(&el->head, el_free);       delete_element
-    ...                                     write_unlock(&list_lock);
+    ...                                     spin_unlock(&list_lock);
 } 					    ...
 					    if (atomic_dec_and_test(&el->rc))
 					        call_rcu(&el->head, el_free);
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index e04d643..9617082 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -786,8 +786,6 @@ RCU pointer/list traversal:
 	list_for_each_entry_rcu
 	hlist_for_each_entry_rcu
 
-	list_for_each_rcu		(to be deprecated in favor of
-					 list_for_each_entry_rcu)
 	list_for_each_continue_rcu	(to be deprecated in favor of new
 					 list_for_each_entry_continue_rcu)
 
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index c8bd2da..8322141 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -190,7 +190,9 @@ extern void __chk_io_ptr(const volatile void __iomem *);
  * ACCESS_ONCE() in different C statements.
  *
  * This macro does absolutely -nothing- to prevent the CPU from reordering,
- * merging, or refetching absolutely anything at any time.
+ * merging, or refetching absolutely anything at any time.  Its main intended
+ * use is to mediate communication between process-level code and irq/NMI
+ * handlers, all running on the same CPU.
  */
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 
diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 4ab8436..5f89b62 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -40,12 +40,21 @@
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+#define RCU_SECONDS_TILL_STALL_CHECK	( 3 * HZ) /* for rcp->jiffies_stall */
+#define RCU_SECONDS_TILL_STALL_RECHECK	(30 * HZ) /* for rcp->jiffies_stall */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /* Global control variables for rcupdate callback mechanism. */
 struct rcu_ctrlblk {
 	long	cur;		/* Current batch number.                      */
 	long	completed;	/* Number of the last completed batch         */
-	int	next_pending;	/* Is the next batch already waiting?         */
+	long	pending;	/* Number of the last pending batch           */
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+	unsigned long gp_start;	/* Time at which GP started in jiffies. */
+	unsigned long jiffies_stall;
+				/* Time at which to check for CPU stalls. */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 	int	signaled;
 
@@ -66,11 +75,7 @@ static inline int rcu_batch_after(long a, long b)
 	return (a - b) > 0;
 }
 
-/*
- * Per-CPU data for Read-Copy UPdate.
- * nxtlist - new callbacks are added here
- * curlist - current batch for which quiescent cycle started if any
- */
+/* Per-CPU data for Read-Copy UPdate. */
 struct rcu_data {
 	/* 1) quiescent state handling : */
 	long		quiescbatch;     /* Batch # for grace period */
@@ -78,12 +83,24 @@ struct rcu_data {
 	int		qs_pending;	 /* core waits for quiesc state */
 
 	/* 2) batch handling */
-	long  	       	batch;           /* Batch # for current RCU batch */
+	/*
+	 * if nxtlist is not NULL, then:
+	 * batch:
+	 *	The batch # for the last entry of nxtlist
+	 * [*nxttail[1], NULL = *nxttail[2]):
+	 *	Entries that batch # <= batch
+	 * [*nxttail[0], *nxttail[1]):
+	 *	Entries that batch # <= batch - 1
+	 * [nxtlist, *nxttail[0]):
+	 *	Entries that batch # <= batch - 2
+	 *	The grace period for these entries has completed, and
+	 *	the other grace-period-completed entries may be moved
+	 *	here temporarily in rcu_process_callbacks().
+	 */
+	long  	       	batch;
 	struct rcu_head *nxtlist;
-	struct rcu_head **nxttail;
+	struct rcu_head **nxttail[3];
 	long            qlen; 	 	 /* # of queued callbacks */
-	struct rcu_head *curlist;
-	struct rcu_head **curtail;
 	struct rcu_head *donelist;
 	struct rcu_head **donetail;
 	long		blimit;		 /* Upper limit on a processed batch */
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index eb4443c..e649bd3 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -198,20 +198,6 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	at->prev = last;
 }
 
-/**
- * list_for_each_rcu	-	iterate over an rcu-protected list
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_rcu(pos, head) \
-	for (pos = rcu_dereference((head)->next); \
-		prefetch(pos->next), pos != (head); \
-		pos = rcu_dereference(pos->next))
-
 #define __list_for_each_rcu(pos, head) \
 	for (pos = rcu_dereference((head)->next); \
 		pos != (head); \
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index e8b4039..86f1f5e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -133,6 +133,26 @@ struct rcu_head {
 #define rcu_read_unlock_bh() __rcu_read_unlock_bh()
 
 /**
+ * rcu_read_lock_sched - mark the beginning of a RCU-classic critical section
+ *
+ * Should be used with either
+ * - synchronize_sched()
+ * or
+ * - call_rcu_sched() and rcu_barrier_sched()
+ * on the write-side to insure proper synchronization.
+ */
+#define rcu_read_lock_sched() preempt_disable()
+
+/*
+ * rcu_read_unlock_sched - marks the end of a RCU-classic critical section
+ *
+ * See rcu_read_lock_sched for more information.
+ */
+#define rcu_read_unlock_sched() preempt_enable()
+
+
+
+/**
  * rcu_dereference - fetch an RCU-protected pointer in an
  * RCU read-side critical section.  This pointer may later
  * be safely dereferenced.
diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index 0967f03..3e05c09 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -57,7 +57,13 @@ static inline void rcu_qsctr_inc(int cpu)
 	rdssp->sched_qs++;
 }
 #define rcu_bh_qsctr_inc(cpu)
-#define call_rcu_bh(head, rcu) call_rcu(head, rcu)
+
+/*
+ * Someone might want to pass call_rcu_bh as a function pointer.
+ * So this needs to just be a rename and not a macro function.
+ *  (no parentheses)
+ */
+#define call_rcu_bh	 	call_rcu
 
 /**
  * call_rcu_sched - Queue RCU callback for invocation after sched grace period.
@@ -111,7 +117,6 @@ extern struct rcupreempt_trace *rcupreempt_trace_cpu(int cpu);
 struct softirq_action;
 
 #ifdef CONFIG_NO_HZ
-DECLARE_PER_CPU(struct rcu_dyntick_sched, rcu_dyntick_sched);
 
 static inline void rcu_enter_nohz(void)
 {
@@ -126,8 +131,8 @@ static inline void rcu_exit_nohz(void)
 {
 	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
 
-	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
 	__get_cpu_var(rcu_dyntick_sched).dynticks++;
+	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
 	WARN_ON_RATELIMIT(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1),
 				&rs);
 }
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index aad93cd..37f72e5 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -47,6 +47,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/mutex.h>
+#include <linux/time.h>
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
@@ -60,12 +61,14 @@ EXPORT_SYMBOL_GPL(rcu_lock_map);
 static struct rcu_ctrlblk rcu_ctrlblk = {
 	.cur = -300,
 	.completed = -300,
+	.pending = -300,
 	.lock = __SPIN_LOCK_UNLOCKED(&rcu_ctrlblk.lock),
 	.cpumask = CPU_MASK_NONE,
 };
 static struct rcu_ctrlblk rcu_bh_ctrlblk = {
 	.cur = -300,
 	.completed = -300,
+	.pending = -300,
 	.lock = __SPIN_LOCK_UNLOCKED(&rcu_bh_ctrlblk.lock),
 	.cpumask = CPU_MASK_NONE,
 };
@@ -83,7 +86,10 @@ static void force_quiescent_state(struct rcu_data *rdp,
 {
 	int cpu;
 	cpumask_t cpumask;
+	unsigned long flags;
+
 	set_need_resched();
+	spin_lock_irqsave(&rcp->lock, flags);
 	if (unlikely(!rcp->signaled)) {
 		rcp->signaled = 1;
 		/*
@@ -109,6 +115,7 @@ static void force_quiescent_state(struct rcu_data *rdp,
 		for_each_cpu_mask_nr(cpu, cpumask)
 			smp_send_reschedule(cpu);
 	}
+	spin_unlock_irqrestore(&rcp->lock, flags);
 }
 #else
 static inline void force_quiescent_state(struct rcu_data *rdp,
@@ -118,6 +125,126 @@ static inline void force_quiescent_state(struct rcu_data *rdp,
 }
 #endif
 
+static void __call_rcu(struct rcu_head *head, struct rcu_ctrlblk *rcp,
+		struct rcu_data *rdp)
+{
+	long batch;
+
+	head->next = NULL;
+	smp_mb(); /* Read of rcu->cur must happen after any change by caller. */
+
+	/*
+	 * Determine the batch number of this callback.
+	 *
+	 * Using ACCESS_ONCE to avoid the following error when gcc eliminates
+	 * local variable "batch" and emits codes like this:
+	 *	1) rdp->batch = rcp->cur + 1 # gets old value
+	 *	......
+	 *	2)rcu_batch_after(rcp->cur + 1, rdp->batch) # gets new value
+	 * then [*nxttail[0], *nxttail[1]) may contain callbacks
+	 * that batch# = rdp->batch, see the comment of struct rcu_data.
+	 */
+	batch = ACCESS_ONCE(rcp->cur) + 1;
+
+	if (rdp->nxtlist && rcu_batch_after(batch, rdp->batch)) {
+		/* process callbacks */
+		rdp->nxttail[0] = rdp->nxttail[1];
+		rdp->nxttail[1] = rdp->nxttail[2];
+		if (rcu_batch_after(batch - 1, rdp->batch))
+			rdp->nxttail[0] = rdp->nxttail[2];
+	}
+
+	rdp->batch = batch;
+	*rdp->nxttail[2] = head;
+	rdp->nxttail[2] = &head->next;
+
+	if (unlikely(++rdp->qlen > qhimark)) {
+		rdp->blimit = INT_MAX;
+		force_quiescent_state(rdp, &rcu_ctrlblk);
+	}
+}
+
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+
+static void record_gp_stall_check_time(struct rcu_ctrlblk *rcp)
+{
+	rcp->gp_start = jiffies;
+	rcp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_CHECK;
+}
+
+static void print_other_cpu_stall(struct rcu_ctrlblk *rcp)
+{
+	int cpu;
+	long delta;
+	unsigned long flags;
+
+	/* Only let one CPU complain about others per time interval. */
+
+	spin_lock_irqsave(&rcp->lock, flags);
+	delta = jiffies - rcp->jiffies_stall;
+	if (delta < 2 || rcp->cur != rcp->completed) {
+		spin_unlock_irqrestore(&rcp->lock, flags);
+		return;
+	}
+	rcp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
+	spin_unlock_irqrestore(&rcp->lock, flags);
+
+	/* OK, time to rat on our buddy... */
+
+	printk(KERN_ERR "RCU detected CPU stalls:");
+	for_each_possible_cpu(cpu) {
+		if (cpu_isset(cpu, rcp->cpumask))
+			printk(" %d", cpu);
+	}
+	printk(" (detected by %d, t=%ld jiffies)\n",
+	       smp_processor_id(), (long)(jiffies - rcp->gp_start));
+}
+
+static void print_cpu_stall(struct rcu_ctrlblk *rcp)
+{
+	unsigned long flags;
+
+	printk(KERN_ERR "RCU detected CPU %d stall (t=%lu/%lu jiffies)\n",
+			smp_processor_id(), jiffies,
+			jiffies - rcp->gp_start);
+	dump_stack();
+	spin_lock_irqsave(&rcp->lock, flags);
+	if ((long)(jiffies - rcp->jiffies_stall) >= 0)
+		rcp->jiffies_stall =
+			jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
+	spin_unlock_irqrestore(&rcp->lock, flags);
+	set_need_resched();  /* kick ourselves to get things going. */
+}
+
+static void check_cpu_stall(struct rcu_ctrlblk *rcp)
+{
+	long delta;
+
+	delta = jiffies - rcp->jiffies_stall;
+	if (cpu_isset(smp_processor_id(), rcp->cpumask) && delta >= 0) {
+
+		/* We haven't checked in, so go dump stack. */
+		print_cpu_stall(rcp);
+
+	} else if (rcp->cur != rcp->completed && delta >= 2) {
+
+		/* They had two seconds to dump stack, so complain. */
+		print_other_cpu_stall(rcp);
+	}
+}
+
+#else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
+static void record_gp_stall_check_time(struct rcu_ctrlblk *rcp)
+{
+}
+
+static inline void check_cpu_stall(struct rcu_ctrlblk *rcp)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
 /**
  * call_rcu - Queue an RCU callback for invocation after a grace period.
  * @head: structure to be used for queueing the RCU updates.
@@ -133,18 +260,10 @@ void call_rcu(struct rcu_head *head,
 				void (*func)(struct rcu_head *rcu))
 {
 	unsigned long flags;
-	struct rcu_data *rdp;
 
 	head->func = func;
-	head->next = NULL;
 	local_irq_save(flags);
-	rdp = &__get_cpu_var(rcu_data);
-	*rdp->nxttail = head;
-	rdp->nxttail = &head->next;
-	if (unlikely(++rdp->qlen > qhimark)) {
-		rdp->blimit = INT_MAX;
-		force_quiescent_state(rdp, &rcu_ctrlblk);
-	}
+	__call_rcu(head, &rcu_ctrlblk, &__get_cpu_var(rcu_data));
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(call_rcu);
@@ -169,20 +288,10 @@ void call_rcu_bh(struct rcu_head *head,
 				void (*func)(struct rcu_head *rcu))
 {
 	unsigned long flags;
-	struct rcu_data *rdp;
 
 	head->func = func;
-	head->next = NULL;
 	local_irq_save(flags);
-	rdp = &__get_cpu_var(rcu_bh_data);
-	*rdp->nxttail = head;
-	rdp->nxttail = &head->next;
-
-	if (unlikely(++rdp->qlen > qhimark)) {
-		rdp->blimit = INT_MAX;
-		force_quiescent_state(rdp, &rcu_bh_ctrlblk);
-	}
-
+	__call_rcu(head, &rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
@@ -211,12 +320,6 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
 static inline void raise_rcu_softirq(void)
 {
 	raise_softirq(RCU_SOFTIRQ);
-	/*
-	 * The smp_mb() here is required to ensure that this cpu's
-	 * __rcu_process_callbacks() reads the most recently updated
-	 * value of rcu->cur.
-	 */
-	smp_mb();
 }
 
 /*
@@ -225,6 +328,7 @@ static inline void raise_rcu_softirq(void)
  */
 static void rcu_do_batch(struct rcu_data *rdp)
 {
+	unsigned long flags;
 	struct rcu_head *next, *list;
 	int count = 0;
 
@@ -239,9 +343,9 @@ static void rcu_do_batch(struct rcu_data *rdp)
 	}
 	rdp->donelist = list;
 
-	local_irq_disable();
+	local_irq_save(flags);
 	rdp->qlen -= count;
-	local_irq_enable();
+	local_irq_restore(flags);
 	if (rdp->blimit == INT_MAX && rdp->qlen <= qlowmark)
 		rdp->blimit = blimit;
 
@@ -269,6 +373,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
  *   rcu_check_quiescent_state calls rcu_start_batch(0) to start the next grace
  *   period (if necessary).
  */
+
 /*
  * Register a new batch of callbacks, and start it up if there is currently no
  * active batch and the batch to be registered has not already occurred.
@@ -276,15 +381,10 @@ static void rcu_do_batch(struct rcu_data *rdp)
  */
 static void rcu_start_batch(struct rcu_ctrlblk *rcp)
 {
-	if (rcp->next_pending &&
+	if (rcp->cur != rcp->pending &&
 			rcp->completed == rcp->cur) {
-		rcp->next_pending = 0;
-		/*
-		 * next_pending == 0 must be visible in
-		 * __rcu_process_callbacks() before it can see new value of cur.
-		 */
-		smp_wmb();
 		rcp->cur++;
+		record_gp_stall_check_time(rcp);
 
 		/*
 		 * Accessing nohz_cpu_mask before incrementing rcp->cur needs a
@@ -322,6 +422,8 @@ static void cpu_quiet(int cpu, struct rcu_ctrlblk *rcp)
 static void rcu_check_quiescent_state(struct rcu_ctrlblk *rcp,
 					struct rcu_data *rdp)
 {
+	unsigned long flags;
+
 	if (rdp->quiescbatch != rcp->cur) {
 		/* start new grace period: */
 		rdp->qs_pending = 1;
@@ -345,7 +447,7 @@ static void rcu_check_quiescent_state(struct rcu_ctrlblk *rcp,
 		return;
 	rdp->qs_pending = 0;
 
-	spin_lock(&rcp->lock);
+	spin_lock_irqsave(&rcp->lock, flags);
 	/*
 	 * rdp->quiescbatch/rcp->cur and the cpu bitmap can come out of sync
 	 * during cpu startup. Ignore the quiescent state.
@@ -353,7 +455,7 @@ static void rcu_check_quiescent_state(struct rcu_ctrlblk *rcp,
 	if (likely(rdp->quiescbatch == rcp->cur))
 		cpu_quiet(rdp->cpu, rcp);
 
-	spin_unlock(&rcp->lock);
+	spin_unlock_irqrestore(&rcp->lock, flags);
 }
 
 
@@ -364,33 +466,38 @@ static void rcu_check_quiescent_state(struct rcu_ctrlblk *rcp,
  * which is dead and hence not processing interrupts.
  */
 static void rcu_move_batch(struct rcu_data *this_rdp, struct rcu_head *list,
-				struct rcu_head **tail)
+				struct rcu_head **tail, long batch)
 {
-	local_irq_disable();
-	*this_rdp->nxttail = list;
-	if (list)
-		this_rdp->nxttail = tail;
-	local_irq_enable();
+	unsigned long flags;
+
+	if (list) {
+		local_irq_save(flags);
+		this_rdp->batch = batch;
+		*this_rdp->nxttail[2] = list;
+		this_rdp->nxttail[2] = tail;
+		local_irq_restore(flags);
+	}
 }
 
 static void __rcu_offline_cpu(struct rcu_data *this_rdp,
 				struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
 {
-	/* if the cpu going offline owns the grace period
+	unsigned long flags;
+
+	/*
+	 * if the cpu going offline owns the grace period
 	 * we can block indefinitely waiting for it, so flush
 	 * it here
 	 */
-	spin_lock_bh(&rcp->lock);
+	spin_lock_irqsave(&rcp->lock, flags);
 	if (rcp->cur != rcp->completed)
 		cpu_quiet(rdp->cpu, rcp);
-	spin_unlock_bh(&rcp->lock);
-	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail);
-	rcu_move_batch(this_rdp, rdp->curlist, rdp->curtail);
-	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail);
+	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail, rcp->cur + 1);
+	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail[2], rcp->cur + 1);
+	spin_unlock(&rcp->lock);
 
-	local_irq_disable();
 	this_rdp->qlen += rdp->qlen;
-	local_irq_enable();
+	local_irq_restore(flags);
 }
 
 static void rcu_offline_cpu(int cpu)
@@ -420,38 +527,52 @@ static void rcu_offline_cpu(int cpu)
 static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
 					struct rcu_data *rdp)
 {
-	if (rdp->curlist && !rcu_batch_before(rcp->completed, rdp->batch)) {
-		*rdp->donetail = rdp->curlist;
-		rdp->donetail = rdp->curtail;
-		rdp->curlist = NULL;
-		rdp->curtail = &rdp->curlist;
-	}
+	unsigned long flags;
+	long completed_snap;
 
-	if (rdp->nxtlist && !rdp->curlist) {
-		local_irq_disable();
-		rdp->curlist = rdp->nxtlist;
-		rdp->curtail = rdp->nxttail;
-		rdp->nxtlist = NULL;
-		rdp->nxttail = &rdp->nxtlist;
-		local_irq_enable();
+	if (rdp->nxtlist) {
+		local_irq_save(flags);
+		completed_snap = ACCESS_ONCE(rcp->completed);
 
 		/*
-		 * start the next batch of callbacks
+		 * move the other grace-period-completed entries to
+		 * [rdp->nxtlist, *rdp->nxttail[0]) temporarily
 		 */
+		if (!rcu_batch_before(completed_snap, rdp->batch))
+			rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2];
+		else if (!rcu_batch_before(completed_snap, rdp->batch - 1))
+			rdp->nxttail[0] = rdp->nxttail[1];
 
-		/* determine batch number */
-		rdp->batch = rcp->cur + 1;
-		/* see the comment and corresponding wmb() in
-		 * the rcu_start_batch()
+		/*
+		 * the grace period for entries in
+		 * [rdp->nxtlist, *rdp->nxttail[0]) has completed and
+		 * move these entries to donelist
 		 */
-		smp_rmb();
+		if (rdp->nxttail[0] != &rdp->nxtlist) {
+			*rdp->donetail = rdp->nxtlist;
+			rdp->donetail = rdp->nxttail[0];
+			rdp->nxtlist = *rdp->nxttail[0];
+			*rdp->donetail = NULL;
+
+			if (rdp->nxttail[1] == rdp->nxttail[0])
+				rdp->nxttail[1] = &rdp->nxtlist;
+			if (rdp->nxttail[2] == rdp->nxttail[0])
+				rdp->nxttail[2] = &rdp->nxtlist;
+			rdp->nxttail[0] = &rdp->nxtlist;
+		}
+
+		local_irq_restore(flags);
+
+		if (rcu_batch_after(rdp->batch, rcp->pending)) {
+			unsigned long flags2;
 
-		if (!rcp->next_pending) {
 			/* and start it/schedule start if it's a new batch */
-			spin_lock(&rcp->lock);
-			rcp->next_pending = 1;
-			rcu_start_batch(rcp);
-			spin_unlock(&rcp->lock);
+			spin_lock_irqsave(&rcp->lock, flags2);
+			if (rcu_batch_after(rdp->batch, rcp->pending)) {
+				rcp->pending = rdp->batch;
+				rcu_start_batch(rcp);
+			}
+			spin_unlock_irqrestore(&rcp->lock, flags2);
 		}
 	}
 
@@ -462,21 +583,53 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
 
 static void rcu_process_callbacks(struct softirq_action *unused)
 {
+	/*
+	 * Memory references from any prior RCU read-side critical sections
+	 * executed by the interrupted code must be see before any RCU
+	 * grace-period manupulations below.
+	 */
+
+	smp_mb(); /* See above block comment. */
+
 	__rcu_process_callbacks(&rcu_ctrlblk, &__get_cpu_var(rcu_data));
 	__rcu_process_callbacks(&rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
+
+	/*
+	 * Memory references from any later RCU read-side critical sections
+	 * executed by the interrupted code must be see after any RCU
+	 * grace-period manupulations above.
+	 */
+
+	smp_mb(); /* See above block comment. */
 }
 
 static int __rcu_pending(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
 {
-	/* This cpu has pending rcu entries and the grace period
-	 * for them has completed.
-	 */
-	if (rdp->curlist && !rcu_batch_before(rcp->completed, rdp->batch))
-		return 1;
+	/* Check for CPU stalls, if enabled. */
+	check_cpu_stall(rcp);
 
-	/* This cpu has no pending entries, but there are new entries */
-	if (!rdp->curlist && rdp->nxtlist)
-		return 1;
+	if (rdp->nxtlist) {
+		long completed_snap = ACCESS_ONCE(rcp->completed);
+
+		/*
+		 * This cpu has pending rcu entries and the grace period
+		 * for them has completed.
+		 */
+		if (!rcu_batch_before(completed_snap, rdp->batch))
+			return 1;
+		if (!rcu_batch_before(completed_snap, rdp->batch - 1) &&
+				rdp->nxttail[0] != rdp->nxttail[1])
+			return 1;
+		if (rdp->nxttail[0] != &rdp->nxtlist)
+			return 1;
+
+		/*
+		 * This cpu has pending rcu entries and the new batch
+		 * for then hasn't been started nor scheduled start
+		 */
+		if (rcu_batch_after(rdp->batch, rcp->pending))
+			return 1;
+	}
 
 	/* This cpu has finished callbacks to invoke */
 	if (rdp->donelist)
@@ -512,9 +665,15 @@ int rcu_needs_cpu(int cpu)
 	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
 	struct rcu_data *rdp_bh = &per_cpu(rcu_bh_data, cpu);
 
-	return (!!rdp->curlist || !!rdp_bh->curlist || rcu_pending(cpu));
+	return !!rdp->nxtlist || !!rdp_bh->nxtlist || rcu_pending(cpu);
 }
 
+/*
+ * Top-level function driving RCU grace-period detection, normally
+ * invoked from the scheduler-clock interrupt.  This function simply
+ * increments counters that are read only from softirq by this same
+ * CPU, so there are no memory barriers required.
+ */
 void rcu_check_callbacks(int cpu, int user)
 {
 	if (user ||
@@ -558,14 +717,17 @@ void rcu_check_callbacks(int cpu, int user)
 static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
 						struct rcu_data *rdp)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&rcp->lock, flags);
 	memset(rdp, 0, sizeof(*rdp));
-	rdp->curtail = &rdp->curlist;
-	rdp->nxttail = &rdp->nxtlist;
+	rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2] = &rdp->nxtlist;
 	rdp->donetail = &rdp->donelist;
 	rdp->quiescbatch = rcp->completed;
 	rdp->qs_pending = 0;
 	rdp->cpu = cpu;
 	rdp->blimit = blimit;
+	spin_unlock_irqrestore(&rcp->lock, flags);
 }
 
 static void __cpuinit rcu_online_cpu(int cpu)
@@ -610,6 +772,9 @@ static struct notifier_block __cpuinitdata rcu_nb = {
  */
 void __init __rcu_init(void)
 {
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 	rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE,
 			(void *)(long)smp_processor_id());
 	/* Register notifier for non-boot CPUs */
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 2782793..ca4bbbe 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -59,14 +59,6 @@
 #include <linux/rcupreempt_trace.h>
 
 /*
- * Macro that prevents the compiler from reordering accesses, but does
- * absolutely -nothing- to prevent CPUs from reordering.  This is used
- * only to mediate communication between mainline code and hardware
- * interrupt and NMI handlers.
- */
-#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
-
-/*
  * PREEMPT_RCU data structures.
  */
 
diff --git a/kernel/rcupreempt_trace.c b/kernel/rcupreempt_trace.c
index 5edf82c..35c2d33 100644
--- a/kernel/rcupreempt_trace.c
+++ b/kernel/rcupreempt_trace.c
@@ -308,11 +308,16 @@ out:
 
 static int __init rcupreempt_trace_init(void)
 {
+	int ret;
+
 	mutex_init(&rcupreempt_trace_mutex);
 	rcupreempt_trace_buf = kmalloc(RCUPREEMPT_TRACE_BUF_SIZE, GFP_KERNEL);
 	if (!rcupreempt_trace_buf)
 		return 1;
-	return rcupreempt_debugfs_init();
+	ret = rcupreempt_debugfs_init();
+	if (ret)
+		kfree(rcupreempt_trace_buf);
+	return ret;
 }
 
 static void __exit rcupreempt_trace_cleanup(void)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 0b50481..9fee969 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -597,6 +597,19 @@ config RCU_TORTURE_TEST_RUNNABLE
 	  Say N here if you want the RCU torture tests to start only
 	  after being manually enabled via /proc.
 
+config RCU_CPU_STALL_DETECTOR
+	bool "Check for stalled CPUs delaying RCU grace periods"
+	depends on CLASSIC_RCU
+	default n
+	help
+	  This option causes RCU to printk information on which
+	  CPUs are delaying the current grace period, but only when
+	  the grace period extends for excessive time periods.
+
+	  Say Y if you want RCU to perform such checks.
+
+	  Say N if you are unsure.
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
