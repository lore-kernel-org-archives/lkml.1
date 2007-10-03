Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbXJCNyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbXJCNyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 09:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbXJCNyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 09:54:14 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:61025 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbXJCNyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 09:54:11 -0400
Subject: [RFC PATCH] RCU preemption priority boosting
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 09:53:44 -0400
Message-Id: <1191419624.11881.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

** RFC not for inclusion **

Although this patch is against the -rt tree, it is also applicable to
mainline after Paul's RCU preempt patches make it in.

This patch adds RCU preemption boosting to RCU readers that were
preempted (or sleep due to spin_locks in -rt).

The approach I took is similar to priority inheritance. When a task does
a synchronize_rcu, all sleeping RCU readers will inherit the priority of
the caller. Any new RCU reader that schedules out will also boost its
priority until the end of the grace period.

The way this works is that there's a global rcu_boost_prio variable that
keeps track of what the RCU readers that schedule out should boost their
priority to.

Along with that is a rcu_boost_dat structure per cpu that keeps its own
copy of the rcu_boost_prio.  When a RCU reader is preempted and
schedules, it adds itself to a "toboost" link list in the local CPU
rcu_boost_dat.  If the rcu_boost_prio is lower (higher in priority) than
the priority of the RCU reader that is about to sleep, the RCU reader
will increase its priority to that of the rcu_boost_prio.

The RCU reader will keep this priority until it releases the last of the
RCU read locks that it held. At that time the RCU reader will lower its
priority back to what it was originally.

When a call is made to synchronize_rcu, if the rcu_boost_prio is higher
than (lower in priority) the caller's priority, then the caller will set
the rcu_boost_prio to its priority. An iteration is done to all the CPUs
rcu_boost_dat. If there are any RCU readers already on the "boosted"
link list a rcu_boost_dat they are moved back to the "toboost" list.
Then each task is moved back to the the "boosted" list after it has its
priority boosted to the new rcu_boost_prio. This is done until there are
no more tasks on the "toboost" list.

Each iteration releases all locks and reacquires them and checks to see
if another task of higher priority didn't come in and start boosting
them higher. If this happened, then the lower priority task simply
exits.

Note, the RCU readers do not lower their priority after the grace period
that caused the boosting happens. So there is a slight priority leak.
But the leak is bounded to the time the RCU read lock is held. If a high
priority task is calling synchronize_rcu, then that priority will be of
risk to having this leak. But that should not be a problem since:
  1) RCU read-side critical sections are usually short.
  2) In the RT point of view, a RCU synchronize_rcu must take into 
     account any RCU read-side critical sections.

Other things that can be added to this patch:

 1) Priority inheritance. Right now if we increase the priority of
    a RCU reader that is blocked on a spin_lock mutex (-rt only)
    we do not push up the priority chain of the locks. This can
    be added with little pain, but will only be done if we see
    that it is a problem.

  2) There's a time where a high priority process called
     synchronize_rcu, and just before the grace period ended
     a slightly lower priority process also called the
     sychronize_rcu. When the grace period ends for the
     high priority process, new RCU sleepers will not get the
     priority of the lower priority process that is doing the
     synchronize_rcu.  This is a small window and shouldn't
     be a problem. But it can be trivially fixed.


Comments?

-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.23-rc9-rt1/include/linux/init_task.h
===================================================================
--- linux-2.6.23-rc9-rt1.orig/include/linux/init_task.h
+++ linux-2.6.23-rc9-rt1/include/linux/init_task.h
@@ -90,6 +90,17 @@ extern struct nsproxy init_nsproxy;
 	.signalfd_wqh	= __WAIT_QUEUE_HEAD_INITIALIZER(sighand.signalfd_wqh),	\
 }
 
+#ifdef CONFIG_PREEMPT_RCU_BOOST
+#define INIT_RCU_BOOST_PRIO .rcu_prio	= MAX_PRIO,
+#define INIT_PREEMPT_RCU_BOOST(tsk)					\
+	.rcub_rbdp	= NULL,						\
+	.rcub_state	= RCU_BOOST_IDLE,				\
+	.rcub_entry	= LIST_HEAD_INIT(tsk.rcub_entry),
+#else /* #ifdef CONFIG_PREEMPT_RCU_BOOST */
+#define INIT_RCU_BOOST_PRIO
+#define INIT_PREEMPT_RCU_BOOST(tsk)
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU_BOOST */
+
 extern struct group_info init_groups;
 
 #define INIT_STRUCT_PID {						\
@@ -129,6 +140,7 @@ extern struct group_info init_groups;
 	.static_prio	= MAX_PRIO-20,					\
 	.normal_prio	= MAX_PRIO-20,					\
 	.policy		= SCHED_NORMAL,					\
+	INIT_RCU_BOOST_PRIO						\
 	.cpus_allowed	= CPU_MASK_ALL,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
@@ -173,6 +185,7 @@ extern struct group_info init_groups;
 	},								\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
+	INIT_PREEMPT_RCU_BOOST(tsk)					\
 }
 
 
Index: linux-2.6.23-rc9-rt1/include/linux/rcupdate.h
===================================================================
--- linux-2.6.23-rc9-rt1.orig/include/linux/rcupdate.h
+++ linux-2.6.23-rc9-rt1/include/linux/rcupdate.h
@@ -252,5 +252,51 @@ static inline void rcu_qsctr_inc(int cpu
 	per_cpu(rcu_data_passed_quiesc, cpu) = 1;
 }
 
+struct dentry;
+
+#ifdef CONFIG_PREEMPT_RCU_BOOST
+extern void init_rcu_boost_late(void);
+extern void rcu_boost_readers(void);
+extern void rcu_unboost_readers(void);
+extern void __rcu_preempt_boost(void);
+#ifdef CONFIG_RCU_TRACE
+extern int rcu_trace_boost_create(struct dentry *rcudir);
+extern void rcu_trace_boost_destroy(void);
+#endif /* CONFIG_RCU_TRACE */
+#define rcu_preempt_boost() /* cpp to avoid #include hell. */ \
+	do { \
+		if (unlikely(current->rcu_read_lock_nesting > 0)) \
+			__rcu_preempt_boost(); \
+	} while (0)
+extern void __rcu_preempt_unboost(void);
+#else /* #ifdef CONFIG_PREEMPT_RCU_BOOST */
+static inline void init_rcu_boost_late(void)
+{
+}
+static inline void rcu_preempt_boost(void)
+{
+}
+static inline void __rcu_preempt_unboost(void)
+{
+}
+static inline void rcu_boost_readers(void)
+{
+}
+static inline void rcu_unboost_readers(void)
+{
+}
+static inline void rcu_unboost_readers(void)
+{
+}
+#ifdef CONFIG_RCU_TRACE
+static inline int rcu_trace_boost_create(struct dentry *rcudir)
+{
+}
+static inline void rcu_trace_boost_destroy(void)
+{
+}
+#endif /* CONFIG_RCU_TRACE */
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU_BOOST */
+
 #endif /* __KERNEL__ */
 #endif /* __LINUX_RCUPDATE_H */
Index: linux-2.6.23-rc9-rt1/include/linux/rcupreempt.h
===================================================================
--- linux-2.6.23-rc9-rt1.orig/include/linux/rcupreempt.h
+++ linux-2.6.23-rc9-rt1/include/linux/rcupreempt.h
@@ -42,6 +42,26 @@
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
+#ifdef CONFIG_PREEMPT_RCU_BOOST
+/*
+ * Task state with respect to being RCU-boosted.  This state is changed
+ * by the task itself in response to the following three events:
+ * 1. Preemption (or block on lock) while in RCU read-side critical section.
+ * 2. Outermost rcu_read_unlock() for blocked RCU read-side critical section.
+ *
+ * The RCU-boost task also updates the state when boosting priority.
+ */
+enum rcu_boost_state {
+	RCU_BOOST_IDLE = 0,	   /* Not yet blocked if in RCU read-side. */
+	RCU_BOOST_BLOCKED = 1,	   /* Blocked from RCU read-side. */
+	RCU_BOOSTED = 2,	   /* Boosting complete. */
+	RCU_BOOST_INVALID = 3,	   /* For bogus state sightings. */
+};
+
+#define N_RCU_BOOST_STATE (RCU_BOOST_INVALID + 1)
+
+#endif /* #ifdef CONFIG_PREEMPT_RCU_BOOST */
+
 /*
  * Someone might want to pass call_rcu_bh as a function pointer.
  * So this needs to just be a rename and not a macro function.
Index: linux-2.6.23-rc9-rt1/include/linux/sched.h
===================================================================
--- linux-2.6.23-rc9-rt1.orig/include/linux/sched.h
+++ linux-2.6.23-rc9-rt1/include/linux/sched.h
@@ -733,6 +733,22 @@ struct signal_struct {
 #define SIGNAL_STOP_CONTINUED	0x00000004 /* SIGCONT since WCONTINUED reap */
 #define SIGNAL_GROUP_EXIT	0x00000008 /* group exit in progress */
 
+#ifdef CONFIG_PREEMPT_RCU_BOOST
+#define set_rcu_prio(p, prio) /* cpp to avoid #include hell */ \
+	do { \
+		(p)->rcu_prio = (prio); \
+	} while (0)
+#define get_rcu_prio(p) (p)->rcu_prio  /* cpp to avoid #include hell */
+#else /* #ifdef CONFIG_PREEMPT_RCU_BOOST */
+static inline void set_rcu_prio(struct task_struct *p, int prio)
+{
+}
+static inline int get_rcu_prio(struct task_struct *p)
+{
+	return MAX_PRIO;
+}
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU_BOOST */
+
 /*
  * Some day this will be a full-fledged user tracking system..
  */
@@ -1112,6 +1128,9 @@ struct task_struct {
 #endif
 
 	int prio, static_prio, normal_prio;
+#ifdef CONFIG_PREEMPT_RCU_BOOST
+	int rcu_prio;
+#endif
 	struct list_head run_list;
 	struct sched_class *sched_class;
 	struct sched_entity se;
@@ -1138,6 +1157,12 @@ struct task_struct {
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
 #endif
+#ifdef CONFIG_PREEMPT_RCU_BOOST
+	struct rcu_boost_dat *rcub_rbdp;
+	enum rcu_boost_state rcub_state;
+	struct list_head rcub_entry;
+	unsigned long rcu_preempt_counter;
+#endif
 
 	struct list_head tasks;
 	/*
Index: linux-2.6.23-rc9-rt1/kernel/Kconfig.preempt
===================================================================
--- linux-2.6.23-rc9-rt1.orig/kernel/Kconfig.preempt
+++ linux-2.6.23-rc9-rt1/kernel/Kconfig.preempt
@@ -171,6 +171,19 @@ config PREEMPT_RCU
 
 	  Say N if you are unsure.
 
+config PREEMPT_RCU_BOOST
+	bool "Enable priority boosting of RCU read-side critical sections"
+	depends on PREEMPT_RCU
+	help
+	  This option permits priority boosting of RCU read-side critical
+	  sections tat have been preempted and a RT process is waiting
+	  on a synchronize_rcu.
+
+	  An RCU thread is also created that periodically wakes up and
+	  performs a synchronize_rcu to make sure that all readers eventually
+	  do complete to prevent an indefinite delay of grace periods and
+	  possible OOM problems.
+
 endchoice
 
 config RCU_TRACE
Index: linux-2.6.23-rc9-rt1/kernel/Makefile
===================================================================
--- linux-2.6.23-rc9-rt1.orig/kernel/Makefile
+++ linux-2.6.23-rc9-rt1/kernel/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
 obj-$(CONFIG_PREEMPT_RCU) += rcuclassic.o rcupreempt.o
+obj-$(CONFIG_PREEMPT_RCU_BOOST) += rcupreempt-boost.o
 ifeq ($(CONFIG_PREEMPT_RCU),y)
 obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
 endif
Index: linux-2.6.23-rc9-rt1/kernel/fork.c
===================================================================
--- linux-2.6.23-rc9-rt1.orig/kernel/fork.c
+++ linux-2.6.23-rc9-rt1/kernel/fork.c
@@ -1081,7 +1081,13 @@ static struct task_struct *copy_process(
 #ifdef CONFIG_PREEMPT_RCU
 	p->rcu_read_lock_nesting = 0;
 	p->rcu_flipctr_idx = 0;
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
+#ifdef CONFIG_PREEMPT_RCU_BOOST
+	p->rcu_prio = MAX_PRIO;
+	p->rcub_rbdp = NULL;
+	p->rcub_state = RCU_BOOST_IDLE;
+	INIT_LIST_HEAD(&p->rcub_entry);
+#endif
+#endif /* CONFIG_PREEMPT_RCU */
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
 
Index: linux-2.6.23-rc9-rt1/kernel/rcupreempt-boost.c
===================================================================
--- /dev/null
+++ linux-2.6.23-rc9-rt1/kernel/rcupreempt-boost.c
@@ -0,0 +1,538 @@
+/*
+ * Read-Copy Update preempt priority boosting
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright Red Hat Inc, 2007
+ *
+ * Authors: Steven Rostedt <srostedt@redhat.com>
+ *
+ * Based on the original work by Paul McKenney <paulmck@us.ibm.com>.
+ *
+ */
+#include <linux/sched.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/debugfs.h>
+#include <linux/module.h>
+#include <linux/syscalls.h>
+#include <linux/kthread.h>
+
+DEFINE_RAW_SPINLOCK(rcu_boost_wake_lock);
+static int rcu_boost_prio = MAX_PRIO;	/* Prio to set preempted RCU readers */
+static long rcu_boost_counter;		/* used to keep track of who boosted */
+static int rcu_preempt_thread_secs = 3;	/* Seconds between waking rcupreemptd thread */
+
+struct rcu_boost_dat {
+	raw_spinlock_t rbs_lock;	/* Sync changes to this struct */
+	int rbs_prio;			/* CPU copy of rcu_boost_prio  */
+	struct list_head rbs_toboost;	/* Preempted RCU readers       */
+	struct list_head rbs_boosted;	/* RCU readers that have been boosted */
+#ifdef CONFIG_RCU_TRACE
+	/* The rest are for statistics */
+	unsigned long rbs_stat_task_boost_called;
+	unsigned long rbs_stat_task_boosted;
+	unsigned long rbs_stat_boost_called;
+	unsigned long rbs_stat_try_boost;
+	unsigned long rbs_stat_boosted;
+	unsigned long rbs_stat_unboost_called;
+	unsigned long rbs_stat_unboosted;
+	unsigned long rbs_stat_try_boost_readers;
+	unsigned long rbs_stat_boost_readers;
+	unsigned long rbs_stat_try_unboost_readers;
+	unsigned long rbs_stat_unboost_readers;
+	unsigned long rbs_stat_over_taken;
+#endif /* CONFIG_RCU_TRACE */
+};
+
+static DEFINE_PER_CPU(struct rcu_boost_dat, rcu_boost_data);
+#define RCU_BOOST_ME &__get_cpu_var(rcu_boost_data)
+
+#ifdef CONFIG_RCU_TRACE
+
+#define RCUPREEMPT_BOOST_TRACE_BUF_SIZE 4096
+static char rcupreempt_boost_trace_buf[RCUPREEMPT_BOOST_TRACE_BUF_SIZE];
+
+static ssize_t rcuboost_read(struct file *filp, char __user *buffer,
+				size_t count, loff_t *ppos)
+{
+	static DEFINE_MUTEX(mutex);
+	int cnt = 0;
+	int cpu;
+	struct rcu_boost_dat *rbd;
+	ssize_t bcount;
+	unsigned long task_boost_called = 0;
+	unsigned long task_boosted = 0;
+	unsigned long boost_called = 0;
+	unsigned long try_boost = 0;
+	unsigned long boosted = 0;
+	unsigned long unboost_called = 0;
+	unsigned long unboosted = 0;
+	unsigned long try_boost_readers = 0;
+	unsigned long boost_readers = 0;
+	unsigned long try_unboost_readers = 0;
+	unsigned long unboost_readers = 0;
+	unsigned long over_taken = 0;
+
+	mutex_lock(&mutex);
+
+	for_each_online_cpu(cpu) {
+		rbd = &per_cpu(rcu_boost_data, cpu);
+
+		task_boost_called += rbd->rbs_stat_task_boost_called;
+		task_boosted += rbd->rbs_stat_task_boosted;
+		boost_called += rbd->rbs_stat_boost_called;
+		try_boost += rbd->rbs_stat_try_boost;
+		boosted += rbd->rbs_stat_boosted;
+		unboost_called += rbd->rbs_stat_unboost_called;
+		unboosted += rbd->rbs_stat_unboosted;
+		try_boost_readers += rbd->rbs_stat_try_boost_readers;
+		boost_readers += rbd->rbs_stat_boost_readers;
+		try_unboost_readers += rbd->rbs_stat_try_boost_readers;
+		unboost_readers += rbd->rbs_stat_boost_readers;
+		over_taken += rbd->rbs_stat_boost_readers;
+	}
+
+	cnt += snprintf(&rcupreempt_boost_trace_buf[cnt],
+			RCUPREEMPT_BOOST_TRACE_BUF_SIZE - cnt,
+			"task_boost_called = %ld\n",
+			task_boost_called);
+	cnt += snprintf(&rcupreempt_boost_trace_buf[cnt],
+			RCUPREEMPT_BOOST_TRACE_BUF_SIZE - cnt,
+			"task_boosted = %ld\n",
+			task_boosted);
+	cnt += snprintf(&rcupreempt_boost_trace_buf[cnt],
+			RCUPREEMPT_BOOST_TRACE_BUF_SIZE - cnt,
+			"boost_called = %ld\n",
+			boost_called);
+	cnt += snprintf(&rcupreempt_boost_trace_buf[cnt],
+			RCUPREEMPT_BOOST_TRACE_BUF_SIZE - cnt,
+			"try_boost = %ld\n",
+			try_boost);
+	cnt += snprintf(&rcupreempt_boost_trace_buf[cnt],
+			RCUPREEMPT_BOOST_TRACE_BUF_SIZE - cnt,
+			"boosted = %ld\n",
+			boosted);
+	cnt += snprintf(&rcupreempt_boost_trace_buf[cnt],
+			RCUPREEMPT_BOOST_TRACE_BUF_SIZE - cnt,
+			"unboost_called = %ld\n",
+			unboost_called);
+	cnt += snprintf(&rcupreempt_boost_trace_buf[cnt],
+			RCUPREEMPT_BOOST_TRACE_BUF_SIZE - cnt,
+			"unboosted = %ld\n",
+			unboosted);
+	cnt += snprintf(&rcupreempt_boost_trace_buf[cnt],
+			RCUPREEMPT_BOOST_TRACE_BUF_SIZE - cnt,
+			"try_boost_readers = %ld\n",
+			try_boost_readers);
+	cnt += snprintf(&rcupreempt_boost_trace_buf[cnt],
+			RCUPREEMPT_BOOST_TRACE_BUF_SIZE - cnt,
+			"boost_readers = %ld\n",
+			boost_readers);
+	cnt += snprintf(&rcupreempt_boost_trace_buf[cnt],
+			RCUPREEMPT_BOOST_TRACE_BUF_SIZE - cnt,
+			"try_unboost_readers = %ld\n",
+			try_unboost_readers);
+	cnt += snprintf(&rcupreempt_boost_trace_buf[cnt],
+			RCUPREEMPT_BOOST_TRACE_BUF_SIZE - cnt,
+			"unboost_readers = %ld\n",
+			unboost_readers);
+	cnt += snprintf(&rcupreempt_boost_trace_buf[cnt],
+			RCUPREEMPT_BOOST_TRACE_BUF_SIZE - cnt,
+			"over_taken = %ld\n",
+			over_taken);
+	cnt += snprintf(&rcupreempt_boost_trace_buf[cnt],
+			RCUPREEMPT_BOOST_TRACE_BUF_SIZE - cnt,
+			"rcu_boost_prio = %d\n",
+			rcu_boost_prio);
+	bcount = simple_read_from_buffer(buffer, count, ppos,
+			rcupreempt_boost_trace_buf, strlen(rcupreempt_boost_trace_buf));
+	mutex_unlock(&mutex);
+
+	return bcount;
+}
+
+static struct file_operations rcuboost_fops = {
+	.read = rcuboost_read,
+};
+
+static struct dentry  *rcuboostdir;
+int rcu_trace_boost_create(struct dentry *rcudir)
+{
+	rcuboostdir = debugfs_create_file("rcuboost", 0444, rcudir,
+					  NULL, &rcuboost_fops);
+	if (!rcuboostdir)
+		return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rcu_trace_boost_create);
+
+void rcu_trace_boost_destroy(void)
+{
+	if (rcuboostdir)
+		debugfs_remove(rcuboostdir);
+	rcuboostdir = NULL;
+}
+EXPORT_SYMBOL_GPL(rcu_trace_boost_destroy);
+
+#define RCU_BOOST_TRACE_FUNC_DECL(type)			      \
+	static void rcu_trace_boost_##type(struct rcu_boost_dat *rbd)	\
+	{								\
+		rbd->rbs_stat_##type++;					\
+	}
+RCU_BOOST_TRACE_FUNC_DECL(task_boost_called)
+RCU_BOOST_TRACE_FUNC_DECL(task_boosted)
+RCU_BOOST_TRACE_FUNC_DECL(boost_called)
+RCU_BOOST_TRACE_FUNC_DECL(try_boost)
+RCU_BOOST_TRACE_FUNC_DECL(boosted)
+RCU_BOOST_TRACE_FUNC_DECL(unboost_called)
+RCU_BOOST_TRACE_FUNC_DECL(unboosted)
+RCU_BOOST_TRACE_FUNC_DECL(try_boost_readers)
+RCU_BOOST_TRACE_FUNC_DECL(boost_readers)
+RCU_BOOST_TRACE_FUNC_DECL(try_unboost_readers)
+RCU_BOOST_TRACE_FUNC_DECL(unboost_readers)
+RCU_BOOST_TRACE_FUNC_DECL(over_taken)
+#else /* CONFIG_RCU_TRACE */
+/* These were created by the above macro "RCU_BOOST_TRACE_FUNC_DECL" */
+# define rcu_trace_boost_task_boost_called(rbd) do { } while (0)
+# define rcu_trace_boost_task_boosted(rbd) do { } while (0)
+# define rcu_trace_boost_boost_called(rbd) do { } while (0)
+# define rcu_trace_boost_try_boost(rbd) do { } while (0)
+# define rcu_trace_boost_boosted(rbd) do { } while (0)
+# define rcu_trace_boost_unboost_called(rbd) do { } while (0)
+# define rcu_trace_boost_unboosted(rbd) do { } while (0)
+# define rcu_trace_boost_try_boost_readers(rbd) do { } while (0)
+# define rcu_trace_boost_boost_readers(rbd) do { } while (0)
+# define rcu_trace_boost_try_unboost_readers(rbd) do { } while (0)
+# define rcu_trace_boost_unboost_readers(rbd) do { } while (0)
+# define rcu_trace_boost_over_taken(rbd) do { } while (0)
+#endif /* CONFIG_RCU_TRACE */
+
+/*
+ * Helper function to boost a task's prio.
+ */
+static void rcu_boost_task(struct task_struct *task)
+{
+	WARN_ON(!irqs_disabled());
+	WARN_ON(!spin_is_locked(&task->pi_lock));
+
+	rcu_trace_boost_task_boost_called(RCU_BOOST_ME);
+
+	if (task->rcu_prio < task->prio) {
+		rcu_trace_boost_task_boosted(RCU_BOOST_ME);
+		rt_mutex_setprio(task, task->rcu_prio);
+	}
+}
+
+/**
+ * __rcu_preepmt_boost - Called by sleeping RCU readers.
+ *
+ * When the RCU read-side critical section is preempted
+ * (or schedules out due to RT mutex)
+ * it places itself onto a list to notify that it is sleeping
+ * while holding a RCU read lock. If there is already a
+ * synchronize_rcu happening, then it will increase its
+ * priority (if necessary).
+ */
+void __rcu_preempt_boost(void)
+{
+	struct task_struct *curr = current;
+	struct rcu_boost_dat *rbd;
+	int prio;
+	unsigned long flags;
+
+	WARN_ON(!current->rcu_read_lock_nesting);
+
+	rcu_trace_boost_boost_called(RCU_BOOST_ME);
+
+	/* check to see if we are already boosted */
+	if (unlikely(curr->rcub_rbdp))
+		return;
+
+	/*
+	 * To keep us from preempting between grabing
+	 * the rbd and locking it, we use local_irq_save
+	 */
+	local_irq_save(flags);
+	rbd = &__get_cpu_var(rcu_boost_data);
+	spin_lock(&rbd->rbs_lock);
+
+	spin_lock(&curr->pi_lock);
+
+	curr->rcub_rbdp = rbd;
+
+	rcu_trace_boost_try_boost(rbd);
+
+	prio = rt_mutex_getprio(curr);
+
+	if (list_empty(&curr->rcub_entry))
+		list_add_tail(&curr->rcub_entry, &rbd->rbs_toboost);
+	if (prio <= rbd->rbs_prio)
+		goto out;
+
+	rcu_trace_boost_boosted(curr->rcub_rbdp);
+
+	curr->rcu_prio = rbd->rbs_prio;
+	rcu_boost_task(curr);
+
+ out:
+	spin_unlock(&curr->pi_lock);
+	spin_unlock_irqrestore(&rbd->rbs_lock, flags);
+}
+
+/**
+ * __rcu_preempt_unboost - called when releasing the RCU read lock
+ *
+ * When releasing the RCU read lock, a check is made to see if
+ * the task was preempted. If it was, it removes itself from the
+ * RCU data lists and if necessary, sets its priority back to
+ * normal.
+ */
+void __rcu_preempt_unboost(void)
+{
+	struct task_struct *curr = current;
+	struct rcu_boost_dat *rbd;
+	int prio;
+	unsigned long flags;
+
+	rcu_trace_boost_unboost_called(RCU_BOOST_ME);
+
+	/* if not boosted, then ignore */
+	if (likely(!curr->rcub_rbdp))
+		return;
+
+	rbd = curr->rcub_rbdp;
+
+	spin_lock_irqsave(&rbd->rbs_lock, flags);
+	list_del_init(&curr->rcub_entry);
+
+	rcu_trace_boost_unboosted(curr->rcub_rbdp);
+
+	curr->rcu_prio = MAX_PRIO;
+
+	spin_lock(&curr->pi_lock);
+	prio = rt_mutex_getprio(curr);
+	rt_mutex_setprio(curr, prio);
+
+	curr->rcub_rbdp = NULL;
+
+	spin_unlock(&curr->pi_lock);
+	spin_unlock_irqrestore(&rbd->rbs_lock, flags);
+}
+
+/*
+ * For each rcu_boost_dat structure, update all the tasks that
+ * are on the lists to the priority of the caller of
+ * synchronize_rcu.
+ */
+static int __rcu_boost_readers(struct rcu_boost_dat *rbd, int prio, unsigned long flags)
+{
+	struct task_struct *curr = current;
+	struct task_struct *p;
+
+	spin_lock(&rbd->rbs_lock);
+
+	rbd->rbs_prio = prio;
+
+	/*
+	 * Move the already boosted readers onto the list and reboost
+	 * them.
+	 */
+	list_splice_init(&rbd->rbs_boosted,
+			 &rbd->rbs_toboost);
+
+	while (!list_empty(&rbd->rbs_toboost)) {
+		p = list_entry(rbd->rbs_toboost.next,
+			       struct task_struct, rcub_entry);
+		list_move_tail(&p->rcub_entry,
+			       &rbd->rbs_boosted);
+		p->rcu_prio = prio;
+		rcu_boost_task(p);
+
+		/*
+		 * Now we release the lock to allow for a higher
+		 * priority task to come in and boost the readers
+		 * even higher. Or simply to let a higher priority
+		 * task to run now.
+		 */
+		spin_unlock(&rbd->rbs_lock);
+		spin_unlock_irqrestore(&rcu_boost_wake_lock, flags);
+
+		cpu_relax();
+		spin_lock_irqsave(&rcu_boost_wake_lock, flags);
+		/*
+		 * Another task may have taken over.
+		 */
+		if (curr->rcu_preempt_counter != rcu_boost_counter) {
+			rcu_trace_boost_over_taken(rbd);
+			return 1;
+		}
+
+		spin_lock(&rbd->rbs_lock);
+	}
+
+	spin_unlock(&rbd->rbs_lock);
+
+	return 0;
+}
+
+/**
+ * rcu_boost_readers - called by synchronize_rcu to boost sleeping RCU readers.
+ *
+ * This function iterates over all the per_cpu rcu_boost_data descriptors
+ * and boosts any sleeping (or slept) RCU readers.
+ */
+void rcu_boost_readers(void)
+{
+	struct task_struct *curr = current;
+	struct rcu_boost_dat *rbd;
+	unsigned long flags;
+	int prio;
+	int cpu;
+	int ret;
+
+	spin_lock_irqsave(&rcu_boost_wake_lock, flags);
+
+	prio = rt_mutex_getprio(curr);
+
+	rcu_trace_boost_try_boost_readers(RCU_BOOST_ME);
+
+	if (prio >= rcu_boost_prio) {
+		/* already boosted */
+		spin_unlock_irqrestore(&rcu_boost_wake_lock, flags);
+		return;
+	}
+
+	rcu_boost_prio = prio;
+
+	rcu_trace_boost_boost_readers(RCU_BOOST_ME);
+
+	/* Flag that we are the one to unboost */
+	curr->rcu_preempt_counter = ++rcu_boost_counter;
+
+	for_each_online_cpu(cpu) {
+		rbd = &per_cpu(rcu_boost_data, cpu);
+		ret = __rcu_boost_readers(rbd, prio, flags);
+		if (ret)
+			break;
+	}
+
+	spin_unlock_irqrestore(&rcu_boost_wake_lock, flags);
+
+}
+
+/**
+ * rcu_unboost_readers - set the boost level back to normal.
+ *
+ * This function DOES NOT change the priority of any RCU reader
+ * that was boosted. The RCU readers do that when they release
+ * the RCU lock. This function only sets the global
+ * rcu_boost_prio to MAX_PRIO so that new RCU readers that sleep
+ * do not increase their priority.
+ */
+void rcu_unboost_readers(void)
+{
+	struct rcu_boost_dat *rbd;
+	unsigned long flags;
+	int cpu;
+
+	spin_lock_irqsave(&rcu_boost_wake_lock, flags);
+
+	rcu_trace_boost_try_unboost_readers(RCU_BOOST_ME);
+
+	if (current->rcu_preempt_counter != rcu_boost_counter)
+		goto out;
+
+	rcu_trace_boost_unboost_readers(RCU_BOOST_ME);
+
+	/*
+	 * We could also put in something that
+	 * would allow other synchronize_rcu callers
+	 * of lower priority that are still waiting
+	 * to boost the prio.
+	 */
+	rcu_boost_prio = MAX_PRIO;
+
+	for_each_online_cpu(cpu) {
+		rbd = &per_cpu(rcu_boost_data, cpu);
+
+		spin_lock(&rbd->rbs_lock);
+		rbd->rbs_prio = rcu_boost_prio;
+		spin_unlock(&rbd->rbs_lock);
+	}
+
+ out:
+	spin_unlock_irqrestore(&rcu_boost_wake_lock, flags);
+}
+
+/*
+ * The krcupreemptd wakes up every "rcu_preempt_thread_secs"
+ * seconds at the minimum priority of 1 to do a
+ * synchronize_rcu. This ensures that grace periods finish
+ * and that we do not starve the system. If there are RT
+ * tasks above priority 1 that are hogging the system and
+ * preventing release of memory, then its the fault of the
+ * system designer running RT tasks too aggressively and the
+ * system is flawed regardless.
+ */
+static int krcupreemptd(void *data)
+{
+	struct sched_param param = { .sched_priority = 1 };
+
+	sys_sched_setscheduler(current->pid, SCHED_FIFO, &param);
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	while (!kthread_should_stop()) {
+		schedule_timeout(rcu_preempt_thread_secs * HZ);
+
+		__set_current_state(TASK_RUNNING);
+
+		synchronize_rcu();
+
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
+	__set_current_state(TASK_RUNNING);
+	return 0;
+}
+
+static int __init rcu_preempt_boost_init(void)
+{
+	struct rcu_boost_dat *rbd;
+	struct task_struct *p;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		rbd = &per_cpu(rcu_boost_data, cpu);
+
+		spin_lock_init(&rbd->rbs_lock);
+		rbd->rbs_prio = MAX_PRIO;
+		INIT_LIST_HEAD(&rbd->rbs_toboost);
+		INIT_LIST_HEAD(&rbd->rbs_boosted);
+	}
+
+	p = kthread_create(krcupreemptd, NULL,
+			   "krcupreemptd");
+
+	if (IS_ERR(p)) {
+		printk("krcupreemptd failed\n");
+		return NOTIFY_BAD;
+	}
+	wake_up_process(p);
+
+	return 0;
+}
+
+core_initcall(rcu_preempt_boost_init);
Index: linux-2.6.23-rc9-rt1/kernel/rcupreempt.c
===================================================================
--- linux-2.6.23-rc9-rt1.orig/kernel/rcupreempt.c
+++ linux-2.6.23-rc9-rt1/kernel/rcupreempt.c
@@ -310,6 +310,8 @@ void __rcu_read_unlock(void)
 
 		ACCESS_ONCE(__get_cpu_var(rcu_flipctr)[idx])--;
 		local_irq_restore(oldirq);
+
+		__rcu_preempt_unboost();
 	}
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
Index: linux-2.6.23-rc9-rt1/kernel/rtmutex.c
===================================================================
--- linux-2.6.23-rc9-rt1.orig/kernel/rtmutex.c
+++ linux-2.6.23-rc9-rt1/kernel/rtmutex.c
@@ -121,11 +121,12 @@ static inline void init_lists(struct rt_
  */
 int rt_mutex_getprio(struct task_struct *task)
 {
+	int prio = min(task->normal_prio, get_rcu_prio(task));
+
 	if (likely(!task_has_pi_waiters(task)))
-		return task->normal_prio;
+		return prio;
 
-	return min(task_top_pi_waiter(task)->pi_list_entry.prio,
-		   task->normal_prio);
+	return min(task_top_pi_waiter(task)->pi_list_entry.prio, prio);
 }
 
 /*
Index: linux-2.6.23-rc9-rt1/kernel/sched.c
===================================================================
--- linux-2.6.23-rc9-rt1.orig/kernel/sched.c
+++ linux-2.6.23-rc9-rt1/kernel/sched.c
@@ -3882,6 +3882,8 @@ asmlinkage void __sched __schedule(void)
 	struct rq *rq;
 	int cpu;
 
+	rcu_preempt_boost();
+
 	preempt_disable();
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
Index: linux-2.6.23-rc9-rt1/kernel/rcupdate.c
===================================================================
--- linux-2.6.23-rc9-rt1.orig/kernel/rcupdate.c
+++ linux-2.6.23-rc9-rt1/kernel/rcupdate.c
@@ -84,8 +84,11 @@ void synchronize_rcu(void)
 	/* Will wake me after RCU finished */
 	call_rcu(&rcu.head, wakeme_after_rcu);
 
+	rcu_boost_readers();
+
 	/* Wait for it */
 	wait_for_completion(&rcu.completion);
+	rcu_unboost_readers();
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
Index: linux-2.6.23-rc9-rt1/kernel/rcupreempt_trace.c
===================================================================
--- linux-2.6.23-rc9-rt1.orig/kernel/rcupreempt_trace.c
+++ linux-2.6.23-rc9-rt1/kernel/rcupreempt_trace.c
@@ -296,8 +296,14 @@ static int rcupreempt_debugfs_init(void)
 						NULL, &rcuctrs_fops);
 	if (!ctrsdir)
 		goto free_out;
+
+	if (!rcu_trace_boost_create(rcudir))
+		goto free_out;
+
 	return 0;
 free_out:
+	if (ctrsdir)
+		debugfs_remove(ctrsdir);
 	if (statdir)
 		debugfs_remove(statdir);
 	if (gpdir)
@@ -323,6 +329,7 @@ static int __init rcupreempt_trace_init(
 
 static void __exit rcupreempt_trace_cleanup(void)
 {
+	rcu_trace_boost_destroy();
 	debugfs_remove(statdir);
 	debugfs_remove(gpdir);
 	debugfs_remove(ctrsdir);


