Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbXHCTMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbXHCTMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 15:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbXHCTMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 15:12:30 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45410 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbXHCTM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 15:12:28 -0400
Date: Fri, 3 Aug 2007 12:12:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       ego@in.ibm.com, vatsa@in.ibm.com, josht@linux.vnet.ibm.com
Subject: [PATCH RFC -rt] synchronize_sched() without migration
Message-ID: <20070803191226.GA25017@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The combination of CPU hotplug and PREEMPT_RCU has resulted in deadlocks
due to the migration-based implementation of synchronize_sched() in -rt.
This experimental patch maps synchronize_sched() back onto Classic RCU,
eliminating the migration, thus hopefully also eliminating the deadlocks.
It is not clear that this is a good long-term approach, but it will at
least permit people doing CPU hotplug in -rt kernels additional wiggle
room in their design and implementation.

The basic approach is to cause the -rt kernel to incorporate rcuclassic.c
as well as rcupreempt.c, but to #ifdef out the conflicting portions of
rcuclassic.c so that only the code needed to implement synchronize_sched()
remains in a PREEMPT_RT build.  Invocations of grace-period detection
from the scheduling-clock interrupt go to rcuclassic.c, which then invokes
the corresponding functions in rcupreempt.c (with _rt suffix added to
keep the linker happy).

If this patch does turn out to be the right approach, the #ifdefs in
kernel/rcuclassic.c will be dealt with.  ;-)

Lightly tested only on x86 machines, bugs no doubt remain.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/rcuclassic.h |   79 +++++-----------------------------------
 include/linux/rcupdate.h   |   43 ++++++++++++++++-----
 include/linux/rcupreempt.h |   29 ++++++--------
 kernel/Makefile            |    2 -
 kernel/rcuclassic.c        |   88 +++++++++++++++++++++++++++++++++++++++------
 kernel/rcupdate.c          |   22 ++++++++---
 kernel/rcupreempt.c        |   46 +++++------------------
 7 files changed, 160 insertions(+), 149 deletions(-)

diff -urpNa -X dontdiff linux-2.6.22.1-rt4/include/linux/rcuclassic.h linux-2.6.22.1-rt4-sched/include/linux/rcuclassic.h
--- linux-2.6.22.1-rt4/include/linux/rcuclassic.h	2007-07-21 16:58:22.000000000 -0700
+++ linux-2.6.22.1-rt4-sched/include/linux/rcuclassic.h	2007-08-02 09:41:03.000000000 -0700
@@ -43,78 +43,19 @@
 #include <linux/seqlock.h>
 
 
-/* Global control variables for rcupdate callback mechanism. */
-struct rcu_ctrlblk {
-	long	cur;		/* Current batch number.                      */
-	long	completed;	/* Number of the last completed batch         */
-	int	next_pending;	/* Is the next batch already waiting?         */
-
-	int	signaled;
-
-	spinlock_t	lock	____cacheline_internodealigned_in_smp;
-	cpumask_t	cpumask; /* CPUs that need to switch in order    */
-	                         /* for current batch to proceed.        */
-} ____cacheline_internodealigned_in_smp;
-
-/* Is batch a before batch b ? */
-static inline int rcu_batch_before(long a, long b)
-{
-        return (a - b) < 0;
-}
-
-/* Is batch a after batch b ? */
-static inline int rcu_batch_after(long a, long b)
-{
-        return (a - b) > 0;
-}
+DECLARE_PER_CPU(int, rcu_data_bh_passed_quiesc);
 
 /*
- * Per-CPU data for Read-Copy UPdate.
- * nxtlist - new callbacks are added here
- * curlist - current batch for which quiescent cycle started if any
- */
-struct rcu_data {
-	/* 1) quiescent state handling : */
-	long		quiescbatch;     /* Batch # for grace period */
-	int		passed_quiesc;	 /* User-mode/idle loop etc. */
-	int		qs_pending;	 /* core waits for quiesc state */
-
-	/* 2) batch handling */
-	long  	       	batch;           /* Batch # for current RCU batch */
-	struct rcu_head *nxtlist;
-	struct rcu_head **nxttail;
-	long            qlen; 	 	 /* # of queued callbacks */
-	struct rcu_head *curlist;
-	struct rcu_head **curtail;
-	struct rcu_head *donelist;
-	struct rcu_head **donetail;
-	long		blimit;		 /* Upper limit on a processed batch */
-	int cpu;
-};
-
-DECLARE_PER_CPU(struct rcu_data, rcu_data);
-DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
-
-/*
- * Increment the quiescent state counter.
+ * Increment the bottom-half quiescent state counter.
  * The counter is a bit degenerated: We do not need to know
  * how many quiescent states passed, just if there was at least
  * one since the start of the grace period. Thus just a flag.
  */
-static inline void rcu_qsctr_inc(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
-	rdp->passed_quiesc = 1;
-}
 static inline void rcu_bh_qsctr_inc(int cpu)
 {
-	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
-	rdp->passed_quiesc = 1;
+	per_cpu(rcu_data_bh_passed_quiesc, cpu) = 1;
 }
 
-extern int rcu_pending(int cpu);
-extern int rcu_needs_cpu(int cpu);
-
 #define __rcu_read_lock() \
 	do { \
 		preempt_disable(); \
@@ -139,13 +80,15 @@ extern int rcu_needs_cpu(int cpu);
 
 #define __synchronize_sched()	synchronize_rcu()
 
-extern void __rcu_init(void);
-extern void rcu_check_callbacks(int cpu, int user);
-extern void rcu_restart_cpu(int cpu);
-extern long rcu_batches_completed(void);
+#define rcu_advance_callbacks_rt(cpu, user)
+#define rcu_check_callbacks_rt(cpu, user)
+#define rcu_init_rt()
+#define rcu_needs_cpu_rt(cpu) 0
+#define rcu_pending_rt(cpu) 0
+#define rcu_process_callbacks_rt(unused)
 
-struct softirq_action;
-extern void rcu_process_callbacks(struct softirq_action *unused);
+extern void FASTCALL(call_rcu_classic(struct rcu_head *head,
+				      void (*func)(struct rcu_head *head)));
 
 #endif /* __KERNEL__ */
 #endif /* __LINUX_RCUCLASSIC_H */
diff -urpNa -X dontdiff linux-2.6.22.1-rt4/include/linux/rcupdate.h linux-2.6.22.1-rt4-sched/include/linux/rcupdate.h
--- linux-2.6.22.1-rt4/include/linux/rcupdate.h	2007-07-21 16:58:22.000000000 -0700
+++ linux-2.6.22.1-rt4-sched/include/linux/rcupdate.h	2007-08-01 13:58:35.000000000 -0700
@@ -42,12 +42,6 @@
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
-#ifdef CONFIG_CLASSIC_RCU
-#include <linux/rcuclassic.h>
-#else
-#include <linux/rcupreempt.h>
-#endif
-
 /**
  * struct rcu_head - callback structure for use with RCU
  * @next: next update requests in a list
@@ -58,6 +52,12 @@ struct rcu_head {
 	void (*func)(struct rcu_head *head);
 };
 
+#ifdef CONFIG_CLASSIC_RCU
+#include <linux/rcuclassic.h>
+#else
+#include <linux/rcupreempt.h>
+#endif
+
 #define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
 #define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
 #define INIT_RCU_HEAD(ptr) do { \
@@ -196,9 +196,11 @@ struct rcu_head {
  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
  * and may be nested.
  */
-extern void FASTCALL(call_rcu(struct rcu_head *head,
-				void (*func)(struct rcu_head *head)));
-
+#ifdef CONFIG_CLASSIC_RCU
+#define call_rcu(head, func) call_rcu_classic(head, func)
+#else /* #ifdef CONFIG_CLASSIC_RCU */
+#define call_rcu(head, func) call_rcu_preempt(head, func)
+#endif /* #else #ifdef CONFIG_CLASSIC_RCU */
 
 /**
  * call_rcu_bh - Queue an RCU for invocation after a quicker grace period.
@@ -224,10 +226,29 @@ extern void synchronize_rcu(void);
 extern void rcu_barrier(void);
 
 /* Internal to kernel */
-extern void rcu_init(void);
 extern void rcu_advance_callbacks(int cpu, int user);
-extern void rcu_check_callbacks(int cpu, int user);
+extern long rcu_batches_completed(void);
 extern long rcu_batches_completed_bh(void);
+extern void rcu_check_callbacks(int cpu, int user);
+extern void rcu_init(void);
+extern int  rcu_needs_cpu(int cpu);
+extern int  rcu_pending(int cpu);
+struct softirq_action;
+extern void rcu_process_callbacks(struct softirq_action *unused);
+extern void rcu_restart_cpu(int cpu);
+
+DECLARE_PER_CPU(int, rcu_data_passed_quiesc);
+
+/*
+ * Increment the quiescent state counter.
+ * The counter is a bit degenerated: We do not need to know
+ * how many quiescent states passed, just if there was at least
+ * one since the start of the grace period. Thus just a flag.
+ */
+static inline void rcu_qsctr_inc(int cpu)
+{
+	per_cpu(rcu_data_passed_quiesc, cpu) = 1;
+}
 
 #endif /* __KERNEL__ */
 #endif /* __LINUX_RCUPDATE_H */
diff -urpNa -X dontdiff linux-2.6.22.1-rt4/include/linux/rcupreempt.h linux-2.6.22.1-rt4-sched/include/linux/rcupreempt.h
--- linux-2.6.22.1-rt4/include/linux/rcupreempt.h	2007-07-21 16:58:22.000000000 -0700
+++ linux-2.6.22.1-rt4-sched/include/linux/rcupreempt.h	2007-08-02 09:43:47.000000000 -0700
@@ -42,30 +42,27 @@
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
-#define rcu_qsctr_inc(cpu)
-#define rcu_bh_qsctr_inc(cpu)
 #define call_rcu_bh(head, rcu) call_rcu(head, rcu)
-
-extern void __rcu_read_lock(void);
-extern void __rcu_read_unlock(void);
-extern int rcu_pending(int cpu);
-extern int rcu_needs_cpu(int cpu);
-
+#define rcu_bh_qsctr_inc(cpu)
 #define __rcu_read_lock_bh()	{ rcu_read_lock(); local_bh_disable(); }
 #define __rcu_read_unlock_bh()	{ local_bh_enable(); rcu_read_unlock(); }
-
 #define __rcu_read_lock_nesting()	(current->rcu_read_lock_nesting)
 
+extern void FASTCALL(call_rcu_classic(struct rcu_head *head,
+				      void (*func)(struct rcu_head *head)));
+extern void FASTCALL(call_rcu_preempt(struct rcu_head *head,
+				      void (*func)(struct rcu_head *head)));
+extern void __rcu_read_lock(void);
+extern void __rcu_read_unlock(void);
 extern void __synchronize_sched(void);
 
-extern void __rcu_init(void);
-extern void rcu_check_callbacks(int cpu, int user);
-extern void rcu_restart_cpu(int cpu);
-extern long rcu_batches_completed(void);
-
+extern void rcu_advance_callbacks_rt(int cpu, int user);
+extern void rcu_check_callbacks_rt(int cpu, int user);
+extern void rcu_init_rt(void);
+extern int  rcu_needs_cpu_rt(int cpu);
+extern int  rcu_pending_rt(int cpu);
 struct softirq_action;
-
-extern void rcu_process_callbacks(struct softirq_action *unused);
+extern void rcu_process_callbacks_rt(struct softirq_action *unused);
 
 #endif /* __KERNEL__ */
 #endif /* __LINUX_RCUPREEMPT_H */
diff -urpNa -X dontdiff linux-2.6.22.1-rt4/kernel/Makefile linux-2.6.22.1-rt4-sched/kernel/Makefile
--- linux-2.6.22.1-rt4/kernel/Makefile	2007-07-21 16:58:22.000000000 -0700
+++ linux-2.6.22.1-rt4-sched/kernel/Makefile	2007-08-02 09:52:06.000000000 -0700
@@ -56,7 +56,7 @@ obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_CLASSIC_RCU) += rcupdate.o rcuclassic.o
-obj-$(CONFIG_PREEMPT_RCU) += rcupdate.o rcupreempt.o
+obj-$(CONFIG_PREEMPT_RCU) += rcupdate.o rcupreempt.o rcuclassic.o
 obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
diff -urpNa -X dontdiff linux-2.6.22.1-rt4/kernel/rcuclassic.c linux-2.6.22.1-rt4-sched/kernel/rcuclassic.c
--- linux-2.6.22.1-rt4/kernel/rcuclassic.c	2007-07-21 16:58:22.000000000 -0700
+++ linux-2.6.22.1-rt4-sched/kernel/rcuclassic.c	2007-08-02 09:40:54.000000000 -0700
@@ -51,6 +51,55 @@
 #include <linux/byteorder/swabb.h>
 
 
+/* Global control variables for rcupdate callback mechanism. */
+struct rcu_ctrlblk {
+	long	cur;		/* Current batch number.                      */
+	long	completed;	/* Number of the last completed batch         */
+	int	next_pending;	/* Is the next batch already waiting?         */
+
+	int	signaled;
+
+	spinlock_t	lock	____cacheline_internodealigned_in_smp;
+	cpumask_t	cpumask; /* CPUs that need to switch in order    */
+	                         /* for current batch to proceed.        */
+} ____cacheline_internodealigned_in_smp;
+
+/* Is batch a before batch b ? */
+static inline int rcu_batch_before(long a, long b)
+{
+        return (a - b) < 0;
+}
+
+/* Is batch a after batch b ? */
+static inline int rcu_batch_after(long a, long b)
+{
+        return (a - b) > 0;
+}
+
+/*
+ * Per-CPU data for Read-Copy UPdate.
+ * nxtlist - new callbacks are added here
+ * curlist - current batch for which quiescent cycle started if any
+ */
+struct rcu_data {
+	/* 1) quiescent state handling : */
+	long		quiescbatch;     /* Batch # for grace period */
+	int		*passed_quiesc;	 /* User-mode/idle loop etc. */
+	int		qs_pending;	 /* core waits for quiesc state */
+
+	/* 2) batch handling */
+	long  	       	batch;           /* Batch # for current RCU batch */
+	struct rcu_head *nxtlist;
+	struct rcu_head **nxttail;
+	long            qlen; 	 	 /* # of queued callbacks */
+	struct rcu_head *curlist;
+	struct rcu_head **curtail;
+	struct rcu_head *donelist;
+	struct rcu_head **donetail;
+	long		blimit;		 /* Upper limit on a processed batch */
+	int cpu;
+};
+
 /* Definition for rcupdate control block. */
 static struct rcu_ctrlblk rcu_ctrlblk = {
 	.cur = -300,
@@ -65,8 +114,9 @@ static struct rcu_ctrlblk rcu_bh_ctrlblk
 	.cpumask = CPU_MASK_NONE,
 };
 
-DEFINE_PER_CPU(struct rcu_data, rcu_data) = { 0L };
-DEFINE_PER_CPU(struct rcu_data, rcu_bh_data) = { 0L };
+static DEFINE_PER_CPU(struct rcu_data, rcu_data) = { 0L };
+static DEFINE_PER_CPU(struct rcu_data, rcu_bh_data) = { 0L };
+DEFINE_PER_CPU(int, rcu_data_bh_passed_quiesc);
 
 /* Fake initialization required by compiler */
 static int blimit = 10;
@@ -110,9 +160,11 @@ static inline void force_quiescent_state
  * read-side critical sections have completed.  RCU read-side critical
  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
  * and may be nested.
+ *
+ * This is the "classic RCU" implementation.
  */
-void fastcall call_rcu(struct rcu_head *head,
-				void (*func)(struct rcu_head *rcu))
+void fastcall call_rcu_classic(struct rcu_head *head,
+			       void (*func)(struct rcu_head *rcu))
 {
 	unsigned long flags;
 	struct rcu_data *rdp;
@@ -130,6 +182,8 @@ void fastcall call_rcu(struct rcu_head *
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_CLASSIC_RCU
+
 /*
  * call_rcu_bh - Queue an RCU for invocation after a quicker grace period.
  * @head: structure to be used for queueing the RCU updates.
@@ -185,6 +239,8 @@ long rcu_batches_completed_bh(void)
 	return rcu_bh_ctrlblk.completed;
 }
 
+#endif /* #ifdef CONFIG_CLASSIC_RCU */
+
 /*
  * Invoke the completed RCU callbacks. They are expected to be in
  * a per-cpu list.
@@ -291,7 +347,7 @@ static void rcu_check_quiescent_state(st
 	if (rdp->quiescbatch != rcp->cur) {
 		/* start new grace period: */
 		rdp->qs_pending = 1;
-		rdp->passed_quiesc = 0;
+		*rdp->passed_quiesc = 0;
 		rdp->quiescbatch = rcp->cur;
 		return;
 	}
@@ -307,7 +363,7 @@ static void rcu_check_quiescent_state(st
 	 * Was there a quiescent state since the beginning of the grace
 	 * period? If no, then exit and wait for the next call.
 	 */
-	if (!rdp->passed_quiesc)
+	if (!*rdp->passed_quiesc)
 		return;
 	rdp->qs_pending = 0;
 
@@ -428,6 +484,7 @@ void rcu_process_callbacks(struct softir
 {
 	__rcu_process_callbacks(&rcu_ctrlblk, &__get_cpu_var(rcu_data));
 	__rcu_process_callbacks(&rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
+	rcu_process_callbacks_rt(unused);
 }
 
 static int __rcu_pending(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
@@ -461,8 +518,9 @@ static int __rcu_pending(struct rcu_ctrl
  */
 int rcu_pending(int cpu)
 {
-	return __rcu_pending(&rcu_ctrlblk, &per_cpu(rcu_data, cpu)) ||
-		__rcu_pending(&rcu_bh_ctrlblk, &per_cpu(rcu_bh_data, cpu));
+	return  __rcu_pending(&rcu_ctrlblk, &per_cpu(rcu_data, cpu)) ||
+		__rcu_pending(&rcu_bh_ctrlblk, &per_cpu(rcu_bh_data, cpu)) ||
+		rcu_pending_rt(cpu);
 }
 
 /*
@@ -476,7 +534,8 @@ int rcu_needs_cpu(int cpu)
 	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
 	struct rcu_data *rdp_bh = &per_cpu(rcu_bh_data, cpu);
 
-	return (!!rdp->curlist || !!rdp_bh->curlist || rcu_pending(cpu));
+	return (!!rdp->curlist || !!rdp_bh->curlist || rcu_pending(cpu) ||
+		rcu_needs_cpu_rt(cpu));
 }
 
 void rcu_advance_callbacks(int cpu, int user)
@@ -488,6 +547,7 @@ void rcu_advance_callbacks(int cpu, int 
 		rcu_bh_qsctr_inc(cpu);
 	} else if (!in_softirq())
 		rcu_bh_qsctr_inc(cpu);
+	rcu_advance_callbacks_rt(cpu, user);
 }
 
 void rcu_check_callbacks(int cpu, int user)
@@ -499,6 +559,7 @@ void rcu_check_callbacks(int cpu, int us
 		rcu_bh_qsctr_inc(cpu);
 	} else if (!in_softirq())
 		rcu_bh_qsctr_inc(cpu);
+	rcu_check_callbacks_rt(cpu, user);
 	raise_softirq(RCU_SOFTIRQ);
 }
 
@@ -521,7 +582,9 @@ static void __devinit rcu_online_cpu(int
 	struct rcu_data *bh_rdp = &per_cpu(rcu_bh_data, cpu);
 
 	rcu_init_percpu_data(cpu, &rcu_ctrlblk, rdp);
+	rdp->passed_quiesc = &per_cpu(rcu_data_passed_quiesc, cpu);
 	rcu_init_percpu_data(cpu, &rcu_bh_ctrlblk, bh_rdp);
+	bh_rdp->passed_quiesc = &per_cpu(rcu_data_bh_passed_quiesc, cpu);
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
 }
 
@@ -554,19 +617,22 @@ static struct notifier_block __devinitda
  * Note that rcu_qsctr and friends are implicitly
  * initialized due to the choice of ``0'' for RCU_CTR_INVALID.
  */
-void __init __rcu_init(void)
+void __init rcu_init(void)
 {
 	rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE,
 			(void *)(long)smp_processor_id());
 	/* Register notifier for non-boot CPUs */
 	register_cpu_notifier(&rcu_nb);
+	rcu_init_rt();
 }
 
 module_param(blimit, int, 0);
 module_param(qhimark, int, 0);
 module_param(qlowmark, int, 0);
 
+#ifdef CONFIG_CLASSIC_RCU
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
 EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
-EXPORT_SYMBOL_GPL(call_rcu);
 EXPORT_SYMBOL_GPL(call_rcu_bh);
+#endif /* #ifdef CONFIG_CLASSIC_RCU */
+EXPORT_SYMBOL_GPL(call_rcu_classic);
diff -urpNa -X dontdiff linux-2.6.22.1-rt4/kernel/rcupdate.c linux-2.6.22.1-rt4-sched/kernel/rcupdate.c
--- linux-2.6.22.1-rt4/kernel/rcupdate.c	2007-07-21 16:58:22.000000000 -0700
+++ linux-2.6.22.1-rt4-sched/kernel/rcupdate.c	2007-08-02 09:40:56.000000000 -0700
@@ -51,6 +51,7 @@ struct rcu_synchronize {
 	struct completion completion;
 };
 
+DEFINE_PER_CPU(int, rcu_data_passed_quiesc);
 static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head);
 static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
@@ -89,6 +90,21 @@ void synchronize_rcu(void)
 	wait_for_completion(&rcu.completion);
 }
 
+#ifdef CONFIG_PREEMPT_RCU
+
+/*
+ * Map synchronize_sched() to the classic RCU implementation.
+ */
+void __synchronize_sched(void)
+{
+	struct rcu_synchronize rcu;
+
+	init_completion(&rcu.completion);
+	call_rcu_classic(&rcu.head, wakeme_after_rcu);
+	wait_for_completion(&rcu.completion);
+}
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
+
 static void rcu_barrier_callback(struct rcu_head *notused)
 {
 	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
@@ -122,10 +138,4 @@ void rcu_barrier(void)
 	mutex_unlock(&rcu_barrier_mutex);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier);
-
-void __init rcu_init(void)
-{
-	__rcu_init();
-}
-
 EXPORT_SYMBOL_GPL(synchronize_rcu);
diff -urpNa -X dontdiff linux-2.6.22.1-rt4/kernel/rcupreempt.c linux-2.6.22.1-rt4-sched/kernel/rcupreempt.c
--- linux-2.6.22.1-rt4/kernel/rcupreempt.c	2007-07-21 16:58:22.000000000 -0700
+++ linux-2.6.22.1-rt4-sched/kernel/rcupreempt.c	2007-08-02 09:40:58.000000000 -0700
@@ -237,7 +237,7 @@ static void rcu_try_flip(void)
 	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, oldirq);
 }
 
-void rcu_check_callbacks(int cpu, int user)
+void rcu_check_callbacks_rt(int cpu, int user)
 {
 	unsigned long oldirq;
 
@@ -250,19 +250,14 @@ void rcu_check_callbacks(int cpu, int us
 	spin_lock_irqsave(&rcu_data.lock, oldirq);
 	RCU_TRACE(rcupreempt_trace_check_callbacks, &rcu_data.trace);
 	__rcu_advance_callbacks();
-	if (rcu_data.donelist == NULL) {
-		spin_unlock_irqrestore(&rcu_data.lock, oldirq);
-	} else {
-		spin_unlock_irqrestore(&rcu_data.lock, oldirq);
-		raise_softirq(RCU_SOFTIRQ);
-	}
+	spin_unlock_irqrestore(&rcu_data.lock, oldirq);
 }
 
 /*
  * Needed by dynticks, to make sure all RCU processing has finished
  * when we go idle:
  */
-void rcu_advance_callbacks(int cpu, int user)
+void rcu_advance_callbacks_rt(int cpu, int user)
 {
 	unsigned long oldirq;
 
@@ -278,7 +273,7 @@ void rcu_advance_callbacks(int cpu, int 
 	spin_unlock_irqrestore(&rcu_data.lock, oldirq);
 }
 
-void rcu_process_callbacks(struct softirq_action *unused)
+void rcu_process_callbacks_rt(struct softirq_action *unused)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list;
@@ -301,8 +296,8 @@ void rcu_process_callbacks(struct softir
 	}
 }
 
-void fastcall call_rcu(struct rcu_head *head,
-				void (*func)(struct rcu_head *rcu))
+void fastcall call_rcu_preempt(struct rcu_head *head,
+			       void (*func)(struct rcu_head *rcu))
 {
 	unsigned long flags;
 
@@ -317,45 +312,24 @@ void fastcall call_rcu(struct rcu_head *
 }
 
 /*
- * Crude hack, reduces but does not eliminate possibility of failure.
- * Needs to wait for all CPUs to pass through a -voluntary- context
- * switch to eliminate possibility of failure.  (Maybe just crank
- * priority down...)
- */
-void __synchronize_sched(void)
-{
-	cpumask_t oldmask;
-	int cpu;
-
-	if (sched_getaffinity(0, &oldmask) < 0) {
-		oldmask = cpu_possible_map;
-	}
-	for_each_online_cpu(cpu) {
-		sched_setaffinity(0, cpumask_of_cpu(cpu));
-		schedule();
-	}
-	sched_setaffinity(0, oldmask);
-}
-
-/*
  * Check to see if any future RCU-related work will need to be done
  * by the current CPU, even if none need be done immediately, returning
  * 1 if so.  This function is part of the RCU implementation; it is -not-
  * an exported member of the RCU API.
  */
-int rcu_needs_cpu(int cpu)
+int rcu_needs_cpu_rt(int cpu)
 {
 	return !!rcu_data.waitlist || rcu_pending(cpu);
 }
 
-int notrace rcu_pending(int cpu)
+int notrace rcu_pending_rt(int cpu)
 {
 	return (rcu_data.donelist != NULL ||
 		rcu_data.waitlist != NULL ||
 		rcu_data.nextlist != NULL);
 }
 
-void __init __rcu_init(void)
+void __init rcu_init_rt(void)
 {
 /*&&&&*/printk("WARNING: experimental RCU implementation.\n");
 	spin_lock_init(&rcu_data.lock);
@@ -445,7 +419,7 @@ int rcu_read_proc_ctrs_data(char *page)
 
 #endif /* #ifdef CONFIG_RCU_TRACE */
 
-EXPORT_SYMBOL_GPL(call_rcu);
+EXPORT_SYMBOL_GPL(call_rcu_preempt);
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
 EXPORT_SYMBOL_GPL(__synchronize_sched);
 EXPORT_SYMBOL_GPL(__rcu_read_lock);
