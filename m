Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYFJNMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYFJNMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 09:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbYFJNMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 09:12:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:51074 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbYFJNMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 09:12:08 -0400
Message-Id: <20080610111832.969119014@chello.nl>
References: <20080610111259.766940257@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 10 Jun 2008 13:13:04 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH -rt 5/5] cpu-hotplug: cpu_down vs preempt-rt
Content-Disposition: inline; filename=hotplug-idle_task_exit.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idle_task_exit() calls mmdrop() from the idle thread, but in PREEMPT_RT all the
allocator locks are sleeping locks - for obvious reasons scheduling away the
idle thread gives some curious problems.

Solve this by pushing the mmdrop() into an RCU callback, however we can't use
RCU because the CPU is already down and all the local RCU state has been
destroyed.

Therefore create a new call_rcu() variant that enqueues the callback on an
online cpu.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/mm_types.h   |    5 +++++
 include/linux/rcupreempt.h |    2 ++
 kernel/rcupreempt.c        |   29 +++++++++++++++++++++++++++++
 kernel/sched.c             |   13 +++++++++++++
 4 files changed, 49 insertions(+)

Index: linux-2.6.24.7.noarch/include/linux/mm_types.h
===================================================================
--- linux-2.6.24.7.noarch.orig/include/linux/mm_types.h
+++ linux-2.6.24.7.noarch/include/linux/mm_types.h
@@ -10,6 +10,7 @@
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
 #include <linux/completion.h>
+#include <linux/rcupdate.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
 
@@ -222,6 +223,10 @@ struct mm_struct {
 	/* aio bits */
 	rwlock_t		ioctx_list_lock;
 	struct kioctx		*ioctx_list;
+
+#ifdef CONFIG_PREEMPT_RT
+	struct rcu_head rcu_head;
+#endif
 };
 
 #endif /* _LINUX_MM_TYPES_H */
Index: linux-2.6.24.7.noarch/include/linux/rcupreempt.h
===================================================================
--- linux-2.6.24.7.noarch.orig/include/linux/rcupreempt.h
+++ linux-2.6.24.7.noarch/include/linux/rcupreempt.h
@@ -83,6 +83,8 @@ extern void FASTCALL(call_rcu_classic(st
 		     void (*func)(struct rcu_head *head)));
 extern void FASTCALL(call_rcu_preempt(struct rcu_head *head,
 		     void (*func)(struct rcu_head *head)));
+extern void FASTCALL(call_rcu_preempt_online(struct rcu_head *head,
+		     void (*func)(struct rcu_head *head)));
 extern void __rcu_read_lock(void);
 extern void __rcu_read_unlock(void);
 extern void __synchronize_sched(void);
Index: linux-2.6.24.7.noarch/kernel/rcupreempt.c
===================================================================
--- linux-2.6.24.7.noarch.orig/kernel/rcupreempt.c
+++ linux-2.6.24.7.noarch/kernel/rcupreempt.c
@@ -916,6 +916,35 @@ void fastcall call_rcu_preempt(struct rc
 }
 EXPORT_SYMBOL_GPL(call_rcu_preempt);
 
+void fastcall call_rcu_preempt_online(struct rcu_head *head,
+		void (*func)(struct rcu_head *rcu))
+{
+	struct rcu_data *rdp;
+	unsigned long flags;
+	int cpu;
+
+	head->func = func;
+	head->next = NULL;
+again:
+	cpu = first_cpu(cpu_online_map);
+	rdp = RCU_DATA_CPU(cpu);
+
+	spin_lock_irqsave(&rdp->lock, flags);
+	if (unlikely(!cpu_online(cpu))) {
+		/*
+		 * cpu is removed from the online map before rcu_offline_cpu
+		 * is called.
+		 */
+		spin_unlock_irqrestore(&rdp->lock, flags);
+		goto again;
+	}
+
+	*rdp->nexttail = head;
+	rdp->nexttail = &head->next;
+	spin_unlock_irqrestore(&rdp->lock, flags);
+
+}
+
 /*
  * Check to see if any future RCU-related work will need to be done
  * by the current CPU, even if none need be done immediately, returning
Index: linux-2.6.24.7.noarch/kernel/sched.c
===================================================================
--- linux-2.6.24.7.noarch.orig/kernel/sched.c
+++ linux-2.6.24.7.noarch/kernel/sched.c
@@ -5888,6 +5888,15 @@ void sched_idle_next(void)
 	spin_unlock_irqrestore(&rq->lock, flags);
 }
 
+#ifdef CONFIG_PREEMPT_RT
+void mmdrop_rcu(struct rcu_head *head)
+{
+	struct mm_struct *mm = container_of(head, struct mm_struct, rcu_head);
+
+	mmdrop(mm);
+}
+#endif
+
 /*
  * Ensures that the idle task is using init_mm right before its cpu goes
  * offline.
@@ -5900,7 +5909,11 @@ void idle_task_exit(void)
 
 	if (mm != &init_mm)
 		switch_mm(mm, &init_mm, current);
+#ifdef CONFIG_PREEMPT_RT
+	call_rcu_preempt_online(&mm->rcu_head, mmdrop_rcu);
+#else
 	mmdrop(mm);
+#endif
 }
 
 /* called under rq->lock with disabled interrupts */

-- 

