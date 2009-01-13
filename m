Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbZAMWRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbZAMWRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbZAMWR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:17:28 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37465 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbZAMWR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:17:27 -0500
Date: Tue, 13 Jan 2009 14:17:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, niv@us.ibm.com,
       dvhltc@us.ibm.com
Subject: [PATCH fyi] RCU: the bloatwatch edition
Message-ID: <20090113221724.GA15307@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just FYI, not for inclusion.

This patch is a version of RCU designed for !CONFIG_SMP provided as a
proof of concept of a small-footprint RCU implementation.  In particular,
the implementation of synchronize_rcu() is extremely lightweight and
high performance.  It passes moderate rcutorture testing in each of the
four relevant configurations (combinations of NO_HZ and PREEMPT) on x86.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/rcupdate.h |    2 
 include/linux/rcutiny.h  |   68 +++++++++++
 init/Kconfig             |    7 +
 kernel/Makefile          |    1 
 kernel/rcupdate.c        |    4 
 kernel/rcutiny.c         |  290 +++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 372 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 921340a..06e3909 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -58,6 +58,8 @@ struct rcu_head {
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
index 0000000..f007cfa
--- /dev/null
+++ b/include/linux/rcutiny.h
@@ -0,0 +1,68 @@
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
+	long completed; 		/* Number of last completed batch. */
+	struct rcu_head *rcucblist;	/* List of pending callbacks (CBs). */
+	struct rcu_head **donetail;	/* ->next pointer of last "done" CB. */
+	struct rcu_head **curtail;	/* ->next pointer of last CB. */
+};
+
+void rcu_qsctr_inc(int cpu);
+void rcu_bh_qsctr_inc(int cpu);
+extern int rcu_needs_cpu(int cpu);
+
+#define __rcu_read_lock()	preempt_disable()
+#define __rcu_read_unlock()	preempt_enable()
+#define __rcu_read_lock_bh()	local_bh_disable()
+#define __rcu_read_unlock_bh()	local_bh_enable()
+#define __synchronize_sched	synchronize_rcu
+#define call_rcu_sched		call_rcu
+
+extern void __rcu_init(void);
+#define rcu_init_sched()	do { } while (0)
+extern void rcu_check_callbacks(int cpu, int user);
+extern void rcu_restart_cpu(int cpu);
+
+extern long rcu_batches_completed(void);
+extern long rcu_batches_completed_bh(void);
+
+#define rcu_pending(cpu)	1
+
+#ifdef CONFIG_NO_HZ
+void rcu_enter_nohz(void);
+void rcu_exit_nohz(void);
+#else /* #ifdef CONFIG_NO_HZ */
+#define rcu_enter_nohz() do { } while (0)
+#define rcu_exit_nohz()  do { } while (0)
+#endif /* #else #ifdef CONFIG_NO_HZ */
+
+#endif /* __LINUX_RCUTINY_H */
diff --git a/init/Kconfig b/init/Kconfig
index a724a14..bdcee3b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1004,6 +1004,13 @@ config PREEMPT_RCU
 	  now-naive assumptions about each RCU read-side critical section
 	  remaining on a given CPU through its execution.
 
+config TINY_RCU
+	bool "Tiny-Memory RCU"
+	depends on !SMP
+	help
+	  This option greatly reduces the memory footprint of RCU,
+	  but is usable only on UP systems.
+
 endchoice
 
 config RCU_TRACE
diff --git a/kernel/Makefile b/kernel/Makefile
index 2921d90..8c1390b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
+obj-$(CONFIG_TINY_RCU) += rcutiny.o
 obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
 obj-$(CONFIG_PREEMPT_RCU_TRACE) += rcupreempt_trace.o
 obj-$(CONFIG_RELAY) += relay.o
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index d92a76a..4bb7b0a 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -68,6 +68,8 @@ void wakeme_after_rcu(struct rcu_head  *head)
 	complete(&rcu->completion);
 }
 
+#ifndef CONFIG_TINY_RCU
+
 /**
  * synchronize_rcu - wait until a grace period has elapsed.
  *
@@ -88,6 +90,8 @@ void synchronize_rcu(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
+#endif /* #ifndef CONFIG_TINY_RCU */
+
 static void rcu_barrier_callback(struct rcu_head *notused)
 {
 	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
new file mode 100644
index 0000000..f7f8ca0
--- /dev/null
+++ b/kernel/rcutiny.c
@@ -0,0 +1,290 @@
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
+static struct rcu_ctrlblk rcu_ctrlblk = {
+	.completed = -300,
+	.rcucblist = NULL,
+	.donetail = &rcu_ctrlblk.rcucblist,
+	.curtail = &rcu_ctrlblk.rcucblist,
+};
+static struct rcu_ctrlblk rcu_bh_ctrlblk = {
+	.completed = -300,
+	.rcucblist = NULL,
+	.donetail = &rcu_bh_ctrlblk.rcucblist,
+	.curtail = &rcu_bh_ctrlblk.rcucblist,
+};
+
+#ifdef CONFIG_NO_HZ
+static long dynticks_nesting = 1;
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
+ * Record an rcu quiescent state.  And an rcu_bh quiescent state
+ * while we are at it, given that any rcu quiescent state is also
+ * an rcu_bh quiescent state.
+ */
+void rcu_qsctr_inc(int cpu)
+{
+	if (rcu_qsctr_help(&rcu_ctrlblk) ||
+	    rcu_qsctr_help(&rcu_bh_ctrlblk))
+	    	raise_softirq(RCU_SOFTIRQ);
+}
+
+/*
+ * Record an rcu_bh quiescent state.
+ */
+void rcu_bh_qsctr_inc(int cpu)
+{
+	if (rcu_qsctr_help(&rcu_bh_ctrlblk))
+	    	raise_softirq(RCU_SOFTIRQ);
+}
+
+/*
+ * Return non-zero if there is RCU work remaining to be done.
+ */
+int rcu_needs_cpu(int cpu)
+{
+	return rcu_ctrlblk.rcucblist != NULL ||
+	       rcu_bh_ctrlblk.rcucblist != NULL;
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
+	     	rcu_qsctr_inc(cpu);
+	else if (!in_softirq())
+		rcu_bh_qsctr_inc(cpu);
+}
+
+#ifdef CONFIG_NO_HZ
+
+/*
+ * Enter dynticks-idle mode, which is an extended quiescent state
+ * if we have fully entered that mode (i.e., if the new value of
+ * dynticks_nesting is zero).
+ */
+void rcu_enter_nohz(void)
+{
+	if (--dynticks_nesting == 0)
+		rcu_qsctr_inc(0); /* implies rcu_bh_qsctr_inc(0) */
+}
+
+/*
+ * Exit dynticks-idle mode, so that we are no longer in an extended
+ * quiescent state.
+ */
+void rcu_exit_nohz(void)
+{
+	dynticks_nesting++;
+}
+
+/*
+ * Entering an interrupt handler exits nohz mode.
+ */
+void rcu_irq_enter(void)
+{
+	rcu_exit_nohz();
+}
+
+/*
+ * Exiting an interrupt handler enters nohz mode.
+ */
+void rcu_irq_exit(void)
+{
+	rcu_enter_nohz();
+}
+
+void rcu_nmi_enter(void)
+{
+}
+
+void rcu_nmi_exit(void)
+{
+}
+
+#endif /* #ifdef CONFIG_NO_HZ */
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
+	rcp->completed++;
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
+ *
+ * However, we do update the grace-period counter to prevent rcutorture
+ * from hammering us.
+ */
+void synchronize_rcu(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	rcu_ctrlblk.completed++;
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(synchronize_rcu);
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
+EXPORT_SYMBOL(call_rcu);
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
+EXPORT_SYMBOL(call_rcu_bh);
+
+/*
+ * Return the number of grace periods.
+ */
+long rcu_batches_completed(void)
+{
+	return rcu_ctrlblk.completed;
+}
+EXPORT_SYMBOL(rcu_batches_completed);
+
+/*
+ * Return the number of bottom-half grace periods.
+ */
+long rcu_batches_completed_bh(void)
+{
+	return rcu_bh_ctrlblk.completed;
+}
+EXPORT_SYMBOL(rcu_batches_completed_bh);
+
+void __init __rcu_init(void)
+{
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+}
