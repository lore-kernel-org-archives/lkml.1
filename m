Return-Path: <linux-kernel-owner+w=401wt.eu-S1758484AbZD2A51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbZD2A51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 20:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbZD2A5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 20:57:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59254 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbZD2A5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 20:57:16 -0400
Date: Tue, 28 Apr 2009 17:57:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       niv@us.ibm.com, dvhltc@us.ibm.com, lethal@linux-sh.org,
       kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v3 RCU: the bloatwatch edition
Message-ID: <20090429005715.GO6730@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090428194537.GN6730@linux.vnet.ibm.com> <20090329203118.GA14005@linux.vnet.ibm.com> <20090203183426.GA14409@linux.vnet.ibm.com> <13990.1240928654@redhat.com> <1454.1240954799@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1454.1240954799@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 10:39:59PM +0100, David Howells wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Your thought is that some of the functions could be moved to tinyrcu.h?
> > Indeed, some of them would be smaller if inlined than even the call
> > sequence.  For example, rcu_needs_cpu() should remove code from the
> > dynticks implementation given that it always returns zero.
> 
> tinyrcu.h is probably not a bad idea.  Some of the functions are trivial, and
> the code to do a function call is bigger than the body of the function itself.
> 
> rcu_exit_nohz(), rcu_nmi_enter/exit(), rcu_batches_completed[_bh](), for
> example.  Even call_rcu() and call_rcu_bh() might perhaps benefit from
> inlining.

Well, here is something that should knock off an additional 100 bytes or
so.  Untested, probably does not compile.  I skipped putting call_rcu()
in tinyrcu.h because it is called so many times that the extra argument
would probably bite harder than the current code + export.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/hardirq.h  |   19 ++--
 include/linux/rcupdate.h |    2 
 include/linux/rcutiny.h  |  112 ++++++++++++++++++++++++
 init/Kconfig             |    7 +
 kernel/Makefile          |    1 
 kernel/rcupdate.c        |    4 
 kernel/rcutiny.c         |  214 +++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 352 insertions(+), 7 deletions(-)

diff -urpNa -X dontdiff linux-2.6.30-rc2-rcu/include/linux/hardirq.h linux-2.6.29-tinyrcu/include/linux/hardirq.h
--- linux-2.6.30-rc2-rcu/include/linux/hardirq.h	2009-03-23 16:12:14.000000000 -0700
+++ linux-2.6.29-tinyrcu/include/linux/hardirq.h	2009-04-28 17:05:11.000000000 -0700
@@ -119,17 +119,22 @@ static inline void account_system_vtime(
 }
 #endif
 
-#if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU)
+#if !defined(CONFIG_NO_HZ) || defined(CONFIG_CLASSIC_RCU)
+# define rcu_irq_enter()	do { } while (0)
+# define rcu_irq_exit()		do { } while (0)
+# define rcu_nmi_enter()	do { } while (0)
+# define rcu_nmi_exit()		do { } while (0)
+#elif defined(CONFIG_RCU_TINY)
+# define rcu_irq_enter		rcu_exit_nohz
+# define rcu_irq_exit		rcu_enter_nohz
+# define rcu_nmi_enter()	do { } while (0)
+# define rcu_nmi_exit()		do { } while (0)
+#else
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
+#endif
 
 /*
  * It is safe to do non-atomic ops on ->hardirq_context,
diff -urpNa -X dontdiff linux-2.6.30-rc2-rcu/include/linux/rcupdate.h linux-2.6.29-tinyrcu/include/linux/rcupdate.h
--- linux-2.6.30-rc2-rcu/include/linux/rcupdate.h	2009-04-28 17:20:36.000000000 -0700
+++ linux-2.6.29-tinyrcu/include/linux/rcupdate.h	2009-04-28 16:40:37.000000000 -0700
@@ -60,6 +60,8 @@ extern int rcu_scheduler_active;
 #include <linux/rcutree.h>
 #elif defined(CONFIG_PREEMPT_RCU)
 #include <linux/rcupreempt.h>
+#elif CONFIG_TINY_RCU
+#include <linux/rcutiny.h>
 #else
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif /* #else #if defined(CONFIG_CLASSIC_RCU) */
diff -urpNa -X dontdiff linux-2.6.30-rc2-rcu/include/linux/rcutiny.h linux-2.6.29-tinyrcu/include/linux/rcutiny.h
--- linux-2.6.30-rc2-rcu/include/linux/rcutiny.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.29-tinyrcu/include/linux/rcutiny.h	2009-04-28 17:17:01.000000000 -0700
@@ -0,0 +1,112 @@
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
+	return rcu_ctrlblk.completed;
+}
+
+/*
+ * Return the number of bottom-half grace periods.
+ */
+static inline long rcu_batches_completed_bh(void)
+{
+	return rcu_bh_ctrlblk.completed;
+}
+
+#define rcu_pending(cpu)	1
+
+#ifdef CONFIG_NO_HZ
+
+extern long rcu_dynticks_nesting;
+
+/*
+ * Enter dynticks-idle mode, which is an extended quiescent state
+ * if we have fully entered that mode (i.e., if the new value of
+ * dynticks_nesting is zero).
+ */
+static inline void rcu_enter_nohz(void)
+{
+	if (--rcu_dynticks_nesting == 0)
+		rcu_qsctr_inc(0); /* implies rcu_bh_qsctr_inc(0) */
+}
+
+/*
+ * Exit dynticks-idle mode, so that we are no longer in an extended
+ * quiescent state.
+ */
+static inline void rcu_exit_nohz(void)
+{
+	rcu_dynticks_nesting++;
+}
+
+#else /* #ifdef CONFIG_NO_HZ */
+#define rcu_enter_nohz() do { } while (0)
+#define rcu_exit_nohz()  do { } while (0)
+#endif /* #else #ifdef CONFIG_NO_HZ */
+
+#endif /* __LINUX_RCUTINY_H */
diff -urpNa -X dontdiff linux-2.6.30-rc2-rcu/init/Kconfig linux-2.6.29-tinyrcu/init/Kconfig
--- linux-2.6.30-rc2-rcu/init/Kconfig	2009-03-23 16:12:14.000000000 -0700
+++ linux-2.6.29-tinyrcu/init/Kconfig	2009-04-28 16:40:37.000000000 -0700
@@ -271,6 +271,13 @@ config PREEMPT_RCU
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
diff -urpNa -X dontdiff linux-2.6.30-rc2-rcu/kernel/Makefile linux-2.6.29-tinyrcu/kernel/Makefile
--- linux-2.6.30-rc2-rcu/kernel/Makefile	2009-03-23 16:12:14.000000000 -0700
+++ linux-2.6.29-tinyrcu/kernel/Makefile	2009-04-28 16:40:37.000000000 -0700
@@ -80,6 +80,7 @@ obj-$(CONFIG_RCU_TORTURE_TEST) += rcutor
 obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
+obj-$(CONFIG_TINY_RCU) += rcutiny.o
 obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
 obj-$(CONFIG_PREEMPT_RCU_TRACE) += rcupreempt_trace.o
 obj-$(CONFIG_RELAY) += relay.o
diff -urpNa -X dontdiff linux-2.6.30-rc2-rcu/kernel/rcupdate.c linux-2.6.29-tinyrcu/kernel/rcupdate.c
--- linux-2.6.30-rc2-rcu/kernel/rcupdate.c	2009-04-28 17:20:36.000000000 -0700
+++ linux-2.6.29-tinyrcu/kernel/rcupdate.c	2009-04-28 16:40:37.000000000 -0700
@@ -74,6 +74,8 @@ void wakeme_after_rcu(struct rcu_head  *
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
diff -urpNa -X dontdiff linux-2.6.30-rc2-rcu/kernel/rcutiny.c linux-2.6.29-tinyrcu/kernel/rcutiny.c
--- linux-2.6.30-rc2-rcu/kernel/rcutiny.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.29-tinyrcu/kernel/rcutiny.c	2009-04-28 17:15:40.000000000 -0700
@@ -0,0 +1,214 @@
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
+	.completed = -300,
+	.rcucblist = NULL,
+	.donetail = &rcu_ctrlblk.rcucblist,
+	.curtail = &rcu_ctrlblk.rcucblist,
+};
+struct rcu_ctrlblk rcu_bh_ctrlblk = {
+	.completed = -300,
+	.rcucblist = NULL,
+	.donetail = &rcu_bh_ctrlblk.rcucblist,
+	.curtail = &rcu_bh_ctrlblk.rcucblist,
+};
+
+#ifdef CONFIG_NO_HZ
+long rcu_dynticks_nesting = 1;
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
+void __rcu_init(void)
+{
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+}
