Return-Path: <linux-kernel-owner+w=401wt.eu-S1765236AbXGYMwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765236AbXGYMwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbXGYMwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:52:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49015 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759921AbXGYMwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:52:36 -0400
Date: Wed, 25 Jul 2007 14:52:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com, rusty@rustcorp.com.au, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 1/3] SCHED: Generic hooks for trapping task preemption
Message-ID: <20070725125220.GA8914@elte.hu>
References: <11853673872732-git-send-email-avi@qumranet.com> <11853673871109-git-send-email-avi@qumranet.com> <20070725124911.GC6841@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725124911.GC6841@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > This adds a general mechanism whereby a task can request the 
> > scheduler to notify it whenever it is preempted or scheduled back 
> > in.  This allows the task to swap any special-purpose registers like 
> > the fpu or Intel's VT registers.
> 
> ok, this looks very clean, i've added it to my scheduler tree. You've 
> tested this with KVM, on both 32-bit and 64-bit, correct?

note: i've done a hook -> notifier rename - 'hook' is way too generic 
sounding and also slightly loaded. (updated patch below)

	Ingo

------------------->
From: Avi Kivity <avi@qumranet.com>
Subject: sched: arch preempt notifier mechanism

This adds a general mechanism whereby a task can request the scheduler to
notify it whenever it is preempted or scheduled back in.  This allows the
task to swap any special-purpose registers like the fpu or Intel's VT
registers.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/preempt.h |   43 +++++++++++++++++++++++++++++++
 include/linux/sched.h   |    4 ++
 kernel/Kconfig.preempt  |    2 +
 kernel/sched.c          |   65 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 114 insertions(+)

Index: linux/include/linux/preempt.h
===================================================================
--- linux.orig/include/linux/preempt.h
+++ linux/include/linux/preempt.h
@@ -8,6 +8,7 @@
 
 #include <linux/thread_info.h>
 #include <linux/linkage.h>
+#include <linux/list.h>
 
 #ifdef CONFIG_DEBUG_PREEMPT
   extern void fastcall add_preempt_count(int val);
@@ -60,4 +61,46 @@ do { \
 
 #endif
 
+#ifdef CONFIG_PREEMPT_NOTIFIERS
+
+struct preempt_notifier;
+
+/**
+ * preempt_ops - notifiers called when a task is preempted and rescheduled
+ * @sched_in: we're about to be rescheduled:
+ *    notifier: struct preempt_notifier for the task being scheduled
+ *    cpu:  cpu we're scheduled on
+ * @sched_out: we've just been preempted
+ *    notifier: struct preempt_notifier for the task being preempted
+ *    next: the task that's kicking us out
+ */
+struct preempt_ops {
+	void (*sched_in)(struct preempt_notifier *notifier, int cpu);
+	void (*sched_out)(struct preempt_notifier *notifier, struct task_struct *next);
+};
+
+/**
+ * preempt_notifier - key for installing preemption notifiers
+ * @link: internal use
+ * @ops: defines the notifier functions to be called
+ *
+ * Usually used in conjunction with container_of().
+ */
+struct preempt_notifier {
+	struct hlist_node link;
+	struct preempt_ops *ops;
+};
+
+void preempt_notifier_register(struct preempt_notifier *notifier);
+void preempt_notifier_unregister(struct preempt_notifier *notifier);
+
+static inline void preempt_notifier_init(struct preempt_notifier *notifier,
+				     struct preempt_ops *ops)
+{
+	INIT_HLIST_NODE(&notifier->link);
+	notifier->ops = ops;
+}
+
+#endif
+
 #endif /* __LINUX_PREEMPT_H */
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -935,6 +935,10 @@ struct task_struct {
 	struct sched_class *sched_class;
 	struct sched_entity se;
 
+#ifdef CONFIG_PREEMPT_NOTIFIERS
+	struct hlist_head preempt_notifiers;  /* list of struct preempt_notifier */
+#endif
+
 	unsigned short ioprio;
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	unsigned int btrace_seq;
Index: linux/kernel/Kconfig.preempt
===================================================================
--- linux.orig/kernel/Kconfig.preempt
+++ linux/kernel/Kconfig.preempt
@@ -63,3 +63,5 @@ config PREEMPT_BKL
 	  Say Y here if you are building a kernel for a desktop system.
 	  Say N if you are unsure.
 
+config PREEMPT_NOTIFIERS
+	bool
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -1592,6 +1592,10 @@ static void __sched_fork(struct task_str
 	INIT_LIST_HEAD(&p->run_list);
 	p->se.on_rq = 0;
 
+#ifdef CONFIG_PREEMPT_NOTIFIERS
+	INIT_HLIST_HEAD(&p->preempt_notifiers);
+#endif
+
 	/*
 	 * We mark the process as running here, but have not actually
 	 * inserted it onto the runqueue yet. This guarantees that
@@ -1673,6 +1677,61 @@ void fastcall wake_up_new_task(struct ta
 	task_rq_unlock(rq, &flags);
 }
 
+#ifdef CONFIG_PREEMPT_NOTIFIERS
+
+/**
+ * preempt_notifier_register - tell me when current is being being preempted
+ *                         and rescheduled
+ */
+void preempt_notifier_register(struct preempt_notifier *notifier)
+{
+	hlist_add_head(&notifier->link, &current->preempt_notifiers);
+}
+EXPORT_SYMBOL_GPL(preempt_notifier_register);
+
+/**
+ * preempt_notifier_unregister - no longer interested in preemption notifications
+ *
+ * This is safe to call from within a preemption notifier.
+ */
+void preempt_notifier_unregister(struct preempt_notifier *notifier)
+{
+	hlist_del(&notifier->link);
+}
+EXPORT_SYMBOL_GPL(preempt_notifier_unregister);
+
+static void fire_sched_in_preempt_notifiers(struct task_struct *tsk)
+{
+	struct preempt_notifier *notifier;
+	struct hlist_node *node;
+
+	hlist_for_each_entry(notifier, node, &tsk->preempt_notifiers, link)
+		notifier->ops->sched_in(notifier, raw_smp_processor_id());
+}
+
+static void fire_sched_out_preempt_notifiers(struct task_struct *tsk,
+					 struct task_struct *next)
+{
+	struct preempt_notifier *notifier;
+	struct hlist_node *node;
+
+	hlist_for_each_entry(notifier, node, &tsk->preempt_notifiers, link)
+		notifier->ops->sched_out(notifier, next);
+}
+
+#else
+
+static void fire_sched_in_preempt_notifiers(struct task_struct *tsk)
+{
+}
+
+static void fire_sched_out_preempt_notifiers(struct task_struct *tsk,
+					 struct task_struct *next)
+{
+}
+
+#endif
+
 /**
  * prepare_task_switch - prepare to switch tasks
  * @rq: the runqueue preparing to switch
@@ -1687,6 +1746,7 @@ void fastcall wake_up_new_task(struct ta
  */
 static inline void prepare_task_switch(struct rq *rq, struct task_struct *next)
 {
+	fire_sched_out_preempt_notifiers(current);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
 }
@@ -1728,6 +1788,7 @@ static inline void finish_task_switch(st
 	prev_state = prev->state;
 	finish_arch_switch(prev);
 	finish_lock_switch(rq, prev);
+	fire_sched_in_preempt_notifiers(current);
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
@@ -6335,6 +6396,10 @@ void __init sched_init(void)
 
 	set_load_weight(&init_task);
 
+#ifdef CONFIG_PREEMPT_NOTIFIERS
+	INIT_HLIST_HEAD(&init_task.preempt_notifiers);
+#endif
+
 #ifdef CONFIG_SMP
 	nr_cpu_ids = highest_cpu + 1;
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
