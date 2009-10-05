Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbZJETL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbZJETL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 15:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbZJETL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 15:11:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:42813 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbZJETL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 15:11:56 -0400
Date: Mon, 5 Oct 2009 19:10:40 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, dhowells@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <12537246443634-git-send-email->
References: <12537246443634-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu-tiny: The Bloatwatch Edition, v6
Message-ID: <tip-a39e7d562c6ac49cc6020e5544babb41b7ff07ba@git.kernel.org>
Git-Commit-ID: a39e7d562c6ac49cc6020e5544babb41b7ff07ba
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 05 Oct 2009 19:10:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a39e7d562c6ac49cc6020e5544babb41b7ff07ba
Gitweb:     http://git.kernel.org/tip/a39e7d562c6ac49cc6020e5544babb41b7ff07ba
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 23 Sep 2009 09:50:44 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Oct 2009 21:05:36 +0200

rcu-tiny: The Bloatwatch Edition, v6

This patch is a version of RCU designed for !SMP provided for a
small-footprint RCU implementation.  In particular, the
implementation of synchronize_rcu() is extremely lightweight and
high performance. It passes rcutorture testing in each of the four
relevant configurations (combinations of NO_HZ and PREEMPT) on x86.

This saves about 1K bytes compared to old Classic RCU (which is no
longer in mainline), and more than three kilobytes compared to
Hierarchical RCU (updated to 2.6.30):

	CONFIG_TREE_RCU:

	   text	   data	    bss	    dec	    filename
	    663      32      20     715     kernel/rcupdate.o
	   3278     528      44    3850     kernel/rcutree.o
				   4565 Total (vs 4045 for v4)

	CONFIG_TREE_PREEMPT_RCU:

	   text	   data	    bss	    dec	    filename
	    743      32      20     795     kernel/rcupdate.o
	   4548     752      60    5360     kernel/rcutree.o
	   			   6155 Total (N/A for v4)

	CONFIG_TINY_RCU:

	   text	   data	    bss	    dec	    filename
	    574      32      20     626     kernel/rcupdate.o
	    486      28       0     514     kernel/rcutiny.o
	    			   1140 Total (vs 1024 for v5)

The above is for x86.  Your mileage may vary on other platforms.

Changes from v5 (http://lkml.org/lkml/2009/6/23/12).

o	Ported to latest pre-2.6.32 merge window kernel.

	- Renamed rcu_qsctr_inc() to rcu_sched_qs().
	- Renamed rcu_bh_qsctr_inc() to rcu_bh_qs().
	- Provided trivial rcu_cpu_notify().
	- Provided trivial exit_rcu().
	- Provided trivial rcu_needs_cpu().
	- Fixed up the rcu_*_enter/exit() functions in linux/hardirq.h.

o	Removed the dependence on EMBEDDED, with a view to making
	TINY_RCU default for !SMP at some time in the future.

o	Added (trivial) support for expedited grace periods.

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

o	Paul is now OK with this being included, based on a poll at the
	Kernel Miniconf at linux.conf.au, where about ten people said
	that they cared about saving 900 bytes on single-CPU systems.

o	Applies to both mainline and tip/core/rcu.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12537246443634-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/hardirq.h  |   24 +++++
 include/linux/rcupdate.h |    6 +
 include/linux/rcutiny.h  |  103 +++++++++++++++++++
 init/Kconfig             |    9 ++
 kernel/Makefile          |    1 +
 kernel/rcupdate.c        |    4 +
 kernel/rcutiny.c         |  245 ++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 392 insertions(+), 0 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 6d527ee..d5b3876 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -139,10 +139,34 @@ static inline void account_system_vtime(struct task_struct *tsk)
 #endif
 
 #if defined(CONFIG_NO_HZ)
+#if defined(CONFIG_TINY_RCU)
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
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
 extern void rcu_nmi_enter(void);
 extern void rcu_nmi_exit(void);
+#endif
 #else
 # define rcu_irq_enter() do { } while (0)
 # define rcu_irq_exit() do { } while (0)
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3ebd0b7..2f1bc42 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -68,11 +68,17 @@ extern int sched_expedited_torture_stats(char *page);
 /* Internal to kernel */
 extern void rcu_init(void);
 extern void rcu_scheduler_starting(void);
+#ifndef CONFIG_TINY_RCU
 extern int rcu_needs_cpu(int cpu);
+#else
+static inline int rcu_needs_cpu(int cpu) { return 0; }
+#endif
 extern int rcu_scheduler_active;
 
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
+#elif defined(CONFIG_TINY_RCU)
+#include <linux/rcutiny.h>
 #else
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
new file mode 100644
index 0000000..08f17ab
--- /dev/null
+++ b/include/linux/rcutiny.h
@@ -0,0 +1,103 @@
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
+void rcu_sched_qs(int cpu);
+void rcu_bh_qs(int cpu);
+
+#define __rcu_read_lock()	preempt_disable()
+#define __rcu_read_unlock()	preempt_enable()
+#define __rcu_read_lock_bh()	local_bh_disable()
+#define __rcu_read_unlock_bh()	local_bh_enable()
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
+extern int rcu_expedited_torture_stats(char *page);
+
+static inline int rcu_pending(int cpu)
+{
+	return 1;
+}
+
+struct notifier_block;
+extern int rcu_cpu_notify(struct notifier_block *self,
+			  unsigned long action, void *hcpu);
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
+static inline void exit_rcu(void)
+{
+}
+
+#endif /* __LINUX_RCUTINY_H */
diff --git a/init/Kconfig b/init/Kconfig
index 0121c0e..4fecb53 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -334,6 +334,15 @@ config TREE_PREEMPT_RCU
 	  is also required.  It also scales down nicely to
 	  smaller systems.
 
+config TINY_RCU
+	bool "UP-only small-memory-footprint RCU"
+	depends on !SMP
+	help
+	  This option selects the RCU implementation that is
+	  designed for UP systems from which real-time response
+	  is not required.  This option greatly reduces the
+	  memory footprint of RCU.
+
 endchoice
 
 config RCU_TRACE
diff --git a/kernel/Makefile b/kernel/Makefile
index 7c9b0a5..0098bcf 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
 obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
+obj-$(CONFIG_TINY_RCU) += rcutiny.o
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index e432422..fd3ec49 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -75,6 +75,8 @@ void wakeme_after_rcu(struct rcu_head  *head)
 	complete(&rcu->completion);
 }
 
+#ifndef CONFIG_TINY_RCU
+
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
 /**
@@ -165,6 +167,8 @@ void synchronize_rcu_bh(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
+#endif /* #ifndef CONFIG_TINY_RCU */
+
 static void rcu_barrier_callback(struct rcu_head *notused)
 {
 	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
new file mode 100644
index 0000000..070c65f
--- /dev/null
+++ b/kernel/rcutiny.c
@@ -0,0 +1,245 @@
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
+		rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
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
+void rcu_sched_qs(int cpu)
+{
+	if (rcu_qsctr_help(&rcu_ctrlblk) + rcu_qsctr_help(&rcu_bh_ctrlblk))
+		raise_softirq(RCU_SOFTIRQ);
+}
+
+/*
+ * Record an rcu_bh quiescent state.
+ */
+void rcu_bh_qs(int cpu)
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
+		rcu_sched_qs(cpu);
+	else if (!in_softirq())
+		rcu_bh_qs(cpu);
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
+ * Null function to handle CPU being onlined.  Longer term, we want to
+ * make TINY_RCU avoid using rcupdate.c, but later...
+ */
+int rcu_cpu_notify(struct notifier_block *self,
+		   unsigned long action, void *hcpu)
+{
+	return NOTIFY_OK;
+}
+
+/*
+ * Wait for a grace period to elapse.  But it is illegal to invoke
+ * synchronize_sched() from within an RCU read-side critical section.
+ * Therefore, any legal call to synchronize_sched() is a quiescent
+ * state, and so on a UP system, synchronize_sched() need do nothing.
+ * Ditto for synchronize_rcu_bh().
+ *
+ * Cool, huh?  (Due to Josh Triplett.)
+ *
+ * But we want to make this a static inline later.
+ */
+void synchronize_sched(void)
+{
+}
+EXPORT_SYMBOL_GPL(synchronize_sched);
+
+void synchronize_rcu_bh(void)
+{
+}
+EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
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
