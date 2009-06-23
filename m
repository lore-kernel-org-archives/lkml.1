Return-Path: <linux-kernel-owner+w=401wt.eu-S1751729AbZFWEnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbZFWEnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 00:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbZFWEnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 00:43:31 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42274 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbZFWEna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 00:43:30 -0400
Date: Mon, 22 Jun 2009 21:24:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, niv@us.ibm.com,
       dvhltc@us.ibm.com, dhowells@redhat.com, lethal@linux-sh.org,
       kernel@wantstofly.org, matthew@wil.cx
Subject: [PATCH] v5 RCU: the bloatwatch edition
Message-ID: <20090623042442.GA15630@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a version of RCU designed for (!SMP && EMBEDDED)
provided as a proof of concept of a small-footprint RCU implementation.
In particular, the implementation of synchronize_rcu() is extremely
lightweight and high performance.  It passes rcutorture testing in each
of the four relevant configurations (combinations of NO_HZ and PREEMPT)
on x86.  This saves 1263 bytes compared to Classic RCU, and more than
three kilobytes compared to Hierarchical RCU (updated to 2.6.30):

	CONFIG_CLASSIC_RCU:

	   text	   data	    bss	    dec	    filename
	    544	     32	     16	    592	    kernel/rcupdate.o
	   1495	    200	      0	   1695	    kernel/rcuclassic.o
				   2287 Total (vs 2112 for v4)

	CONFIG_TREE_RCU:

	   text	   data	    bss	    dec	    filename
	    544	     32	     16	    592	    kernel/rcupdate.o
	   3005	    448	      0	   3453	    kernel/rcutree.o
	   			   4045 Total (vs 3622 for v4)

	CONFIG_TINY_RCU:

	   text	   data	    bss	    dec	    filename
	    506	     32	     16	    554	    kernel/rcupdate.o
	    442	     28	      0	    470	    kernel/rcutiny.o
	    			   1024 Total (vs 1041 for v4)

The above is for x86.  Your mileage may vary on other platforms.

Changes from v4 (http://lkml.org/lkml/2009/5/2/91) include:

o	Squeeze the size down a bit further by removing the
	->completed field from struct rcu_ctrlblk.

o	This permits synchronize_rcu() to become the empty function.
	Previous concerns about rcutorture were unfounded, as
	rcutorture correctly handles a constant value from
	rcu_batches_completed() and rcu_batches_completed_bh().

Changes from v3 (http://lkml.org/lkml/2009/3/29/221) include:

o	Changed rcu_batches_completed(), rcu_batches_completed_bh()
	rcu_enter_nohz(), rcu_exit_nohz(), rcu_nmi_enter(), and
	rcu_nmi_exit(), to be static inlines, as suggested by David
	Howells.  Doing this saves about 100 bytes from rcutiny.o.
	(The numbers between v3 and this v4 of the patch are not directly
	comparable, since they are against different versions of Linux.)

Changes from v2 (http://lkml.org/lkml/2009/2/3/333) include:

o	Fix whitespace issues.

o	Change short-circuit "||" operator to instead be "+" in order to
	fix performance bug noted by "kraai" on LWN.

		(http://lwn.net/Articles/324348/)

Changes from v1 (http://lkml.org/lkml/2009/1/13/440) include:

o	This version depends on EMBEDDED as well as !SMP, as suggested
	by Ingo.

o	Updated rcu_needs_cpu() to unconditionally return zero,
	permitting the CPU to enter dynticks-idle mode at any time.
	This works because callbacks can be invoked upon entry to
	dynticks-idle mode.

o	I am now OK with this being included, based on a poll at the
	Kernel Miniconf at linux.conf.au, where about ten people said
	that they cared about saving 900 bytes on single-CPU systems.

o	Applies to both mainline and tip/core/rcu.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/hardirq.h  |   52 +++++++++-
 include/linux/rcupdate.h |    2 
 include/linux/rcutiny.h  |  102 +++++++++++++++++++++
 init/Kconfig             |    7 +
 kernel/Makefile          |    1 
 kernel/rcupdate.c        |    4 
 kernel/rcutiny.c         |  227 +++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 388 insertions(+), 7 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 4525747..b0d1e83 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -130,17 +130,55 @@ static inline void account_system_vtime(struct task_struct *tsk)
 }
 #endif
 
-#if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU)
+#if !defined(CONFIG_NO_HZ) || defined(CONFIG_CLASSIC_RCU)
+
+static inline void rcu_irq_enter(void)
+{
+}
+
+static inline void rcu_irq_exit(void)
+{
+}
+
+static inline void rcu_nmi_enter(void)
+{
+}
+
+static inline void rcu_nmi_exit(void)
+{
+}
+
+#elif defined(CONFIG_TINY_RCU)
+
+extern void rcu_enter_nohz(void);
+extern void rcu_exit_nohz(void);
+
+static inline void rcu_irq_enter(void)
+{
+	rcu_exit_nohz();
+}
+
+static inline void rcu_irq_exit(void)
+{
+	rcu_enter_nohz();
+}
+
+static inline void rcu_nmi_enter(void)
+{
+}
+
+static inline void rcu_nmi_exit(void)
+{
+}
+
+#else
+
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
 extern void rcu_nmi_enter(void);
 extern void rcu_nmi_exit(void);
-#else
-# define rcu_irq_enter() do { } while (0)
-# define rcu_irq_exit() do { } while (0)
-# define rcu_nmi_enter() do { } while (0)
-# define rcu_nmi_exit() do { } while (0)
-#endif /* #if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU) */
+
+#endif
 
 /*
  * It is safe to do non-atomic ops on ->hardirq_context,
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 15fbb3c..bd91ffa 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -60,6 +60,8 @@ extern int rcu_scheduler_active;
 #include <linux/rcutree.h>
 #elif defined(CONFIG_PREEMPT_RCU)
 #include <linux/rcupreempt.h>
+#elif CONFIG_TINY_RCU
+#include <linux/rcutiny.h>
 #else
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif /* #else #if defined(CONFIG_CLASSIC_RCU) */
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
new file mode 100644
index 0000000..02e9ef4
--- /dev/null
+++ b/include/linux/rcutiny.h
@@ -0,0 +1,102 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion, the Bloatwatch edition.
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
+ * Copyright IBM Corporation, 2008
+ *
+ * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ * 		Documentation/RCU
+ */
+
+#ifndef __LINUX_TINY_H
+#define __LINUX_TINY_H
+
+#include <linux/cache.h>
+
+/* Global control variables for rcupdate callback mechanism. */
+struct rcu_ctrlblk {
+	struct rcu_head *rcucblist;	/* List of pending callbacks (CBs). */
+	struct rcu_head **donetail;	/* ->next pointer of last "done" CB. */
+	struct rcu_head **curtail;	/* ->next pointer of last CB. */
+};
+
+extern struct rcu_ctrlblk rcu_ctrlblk;
+extern struct rcu_ctrlblk rcu_bh_ctrlblk;
+
+/*
+ * Return non-zero if there is RCU work remaining to be done.
+ */
+static inline int rcu_needs_cpu(int cpu)
+{
+	return 0;
+}
+
+void rcu_qsctr_inc(int cpu);
+void rcu_bh_qsctr_inc(int cpu);
+
+#define __rcu_read_lock()	preempt_disable()
+#define __rcu_read_unlock()	preempt_enable()
+#define __rcu_read_lock_bh()	local_bh_disable()
+#define __rcu_read_unlock_bh()	local_bh_enable()
+#define __synchronize_sched	synchronize_rcu
+#define call_rcu_sched		call_rcu
+
+#define rcu_init_sched()	do { } while (0)
+extern void rcu_check_callbacks(int cpu, int user);
+extern void __rcu_init(void);
+/* extern void rcu_restart_cpu(int cpu); */
+
+/*
+ * Return the number of grace periods.
+ */
+static inline long rcu_batches_completed(void)
+{
+	return 0;
+}
+
+/*
+ * Return the number of bottom-half grace periods.
+ */
+static inline long rcu_batches_completed_bh(void)
+{
+	return 0;
+}
+
+static inline int rcu_pending(int cpu)
+{
+	return 1;
+}
+
+#ifdef CONFIG_NO_HZ
+
+extern void rcu_enter_nohz(void);
+extern void rcu_exit_nohz(void);
+
+#else /* #ifdef CONFIG_NO_HZ */
+
+static inline void rcu_enter_nohz(void)
+{
+}
+
+static inline void rcu_exit_nohz(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_NO_HZ */
+
+#endif /* __LINUX_RCUTINY_H */
diff --git a/init/Kconfig b/init/Kconfig
index 7be4d38..f088d51 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -337,6 +337,13 @@ config PREEMPT_RCU
 	  now-naive assumptions about each RCU read-side critical section
 	  remaining on a given CPU through its execution.
 
+config TINY_RCU
+	bool "Tiny-Memory RCU"
+	depends on !SMP && EMBEDDED
+	help
+	  This option greatly reduces the memory footprint of RCU,
+	  but is usable only on UP systems.
+
 endchoice
 
 config RCU_TRACE
diff --git a/kernel/Makefile b/kernel/Makefile
index 4242366..c76518c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -81,6 +81,7 @@ obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
+obj-$(CONFIG_TINY_RCU) += rcutiny.o
 obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
 obj-$(CONFIG_PREEMPT_RCU_TRACE) += rcupreempt_trace.o
 obj-$(CONFIG_RELAY) += relay.o
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a967c9f..a866940 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -74,6 +74,8 @@ void wakeme_after_rcu(struct rcu_head  *head)
 	complete(&rcu->completion);
 }
 
+#ifndef CONFIG_TINY_RCU
+
 /**
  * synchronize_rcu - wait until a grace period has elapsed.
  *
@@ -98,6 +100,8 @@ void synchronize_rcu(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
+#endif /* #ifndef CONFIG_TINY_RCU */
+
 static void rcu_barrier_callback(struct rcu_head *notused)
 {
 	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
new file mode 100644
index 0000000..94bef81
--- /dev/null
+++ b/kernel/rcutiny.c
@@ -0,0 +1,227 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion, the Bloatwatch edition.
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
+ * Copyright IBM Corporation, 2008
+ *
+ * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ * 		Documentation/RCU
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/rcupdate.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/completion.h>
+#include <linux/moduleparam.h>
+#include <linux/notifier.h>
+#include <linux/cpu.h>
+#include <linux/mutex.h>
+#include <linux/time.h>
+
+/* Definition for rcupdate control block. */
+struct rcu_ctrlblk rcu_ctrlblk = {
+	.rcucblist = NULL,
+	.donetail = &rcu_ctrlblk.rcucblist,
+	.curtail = &rcu_ctrlblk.rcucblist,
+};
+EXPORT_SYMBOL_GPL(rcu_ctrlblk);
+struct rcu_ctrlblk rcu_bh_ctrlblk = {
+	.rcucblist = NULL,
+	.donetail = &rcu_bh_ctrlblk.rcucblist,
+	.curtail = &rcu_bh_ctrlblk.rcucblist,
+};
+EXPORT_SYMBOL_GPL(rcu_bh_ctrlblk);
+
+#ifdef CONFIG_NO_HZ
+
+static long rcu_dynticks_nesting = 1;
+
+/*
+ * Enter dynticks-idle mode, which is an extended quiescent state
+ * if we have fully entered that mode (i.e., if the new value of
+ * dynticks_nesting is zero).
+ */
+void rcu_enter_nohz(void)
+{
+	if (--rcu_dynticks_nesting == 0)
+		rcu_qsctr_inc(0); /* implies rcu_bh_qsctr_inc(0) */
+}
+
+/*
+ * Exit dynticks-idle mode, so that we are no longer in an extended
+ * quiescent state.
+ */
+void rcu_exit_nohz(void)
+{
+	rcu_dynticks_nesting++;
+}
+
+#endif /* #ifdef CONFIG_NO_HZ */
+
+/*
+ * Helper function for rcu_qsctr_inc() and rcu_bh_qsctr_inc().
+ */
+static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
+{
+	if (rcp->rcucblist != NULL &&
+	    rcp->donetail != rcp->curtail) {
+		rcp->donetail = rcp->curtail;
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * Record an rcu quiescent state.  And an rcu_bh quiescent state while we
+ * are at it, given that any rcu quiescent state is also an rcu_bh
+ * quiescent state.  Use "+" instead of "||" to defeat short circuiting.
+ */
+void rcu_qsctr_inc(int cpu)
+{
+	if (rcu_qsctr_help(&rcu_ctrlblk) + rcu_qsctr_help(&rcu_bh_ctrlblk))
+		raise_softirq(RCU_SOFTIRQ);
+}
+
+/*
+ * Record an rcu_bh quiescent state.
+ */
+void rcu_bh_qsctr_inc(int cpu)
+{
+	if (rcu_qsctr_help(&rcu_bh_ctrlblk))
+		raise_softirq(RCU_SOFTIRQ);
+}
+
+/*
+ * Check to see if the scheduling-clock interrupt came from an extended
+ * quiescent state, and, if so, tell RCU about it.
+ */
+void rcu_check_callbacks(int cpu, int user)
+{
+	if (!rcu_needs_cpu(0))
+		return;	/* RCU doesn't need anything to be done. */
+	if (user ||
+	    (idle_cpu(cpu) &&
+	     !in_softirq() &&
+	     hardirq_count() <= (1 << HARDIRQ_SHIFT)))
+		rcu_qsctr_inc(cpu);
+	else if (!in_softirq())
+		rcu_bh_qsctr_inc(cpu);
+}
+
+/*
+ * Helper function for rcu_process_callbacks() that operates on the
+ * specified rcu_ctrlkblk structure.
+ */
+static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
+{
+	unsigned long flags;
+	struct rcu_head *next, *list;
+
+	/* If no RCU callbacks ready to invoke, just return. */
+	if (&rcp->rcucblist == rcp->donetail)
+		return;
+
+	/* Move the ready-to-invoke callbacks to a local list. */
+	local_irq_save(flags);
+	list = rcp->rcucblist;
+	rcp->rcucblist = *rcp->donetail;
+	*rcp->donetail = NULL;
+	if (rcp->curtail == rcp->donetail)
+		rcp->curtail = &rcp->rcucblist;
+	rcp->donetail = &rcp->rcucblist;
+	local_irq_restore(flags);
+
+	/* Invoke the callbacks on the local list. */
+	while (list) {
+		next = list->next;
+		prefetch(next);
+		list->func(list);
+		list = next;
+	}
+}
+
+/*
+ * Invoke any callbacks whose grace period has completed.
+ */
+static void rcu_process_callbacks(struct softirq_action *unused)
+{
+	__rcu_process_callbacks(&rcu_ctrlblk);
+	__rcu_process_callbacks(&rcu_bh_ctrlblk);
+}
+
+/*
+ * Wait for a grace period to elapse.  But it is illegal to invoke
+ * synchronize_rcu() from within an RCU read-side critical section.
+ * Therefore, any legal call to synchronize_rcu() is a quiescent
+ * state, and so on a UP system, synchronize_rcu() need do nothing.
+ *
+ * Cool, huh?  (Due to Josh Triplett.)
+ */
+void synchronize_rcu(void)
+{
+}
+EXPORT_SYMBOL_GPL(synchronize_rcu);
+
+/*
+ * Helper function for call_rcu() and call_rcu_bh().
+ */
+static void __call_rcu(struct rcu_head *head,
+		       void (*func)(struct rcu_head *rcu),
+		       struct rcu_ctrlblk *rcp)
+{
+	unsigned long flags;
+
+	head->func = func;
+	head->next = NULL;
+	local_irq_save(flags);
+	*rcp->curtail = head;
+	rcp->curtail = &head->next;
+	local_irq_restore(flags);
+}
+
+/*
+ * Post an RCU callback to be invoked after the end of an RCU grace
+ * period.  But since we have but one CPU, that would be after any
+ * quiescent state.
+ */
+void call_rcu(struct rcu_head *head,
+	      void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_ctrlblk);
+}
+EXPORT_SYMBOL_GPL(call_rcu);
+
+/*
+ * Post an RCU bottom-half callback to be invoked after any subsequent
+ * quiescent state.
+ */
+void call_rcu_bh(struct rcu_head *head,
+		 void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_bh_ctrlblk);
+}
+EXPORT_SYMBOL_GPL(call_rcu_bh);
+
+void __rcu_init(void)
+{
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+}
