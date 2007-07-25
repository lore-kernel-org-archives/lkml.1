Return-Path: <linux-kernel-owner+w=401wt.eu-S1764965AbXGYMn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764965AbXGYMn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759702AbXGYMm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:42:59 -0400
Received: from il.qumranet.com ([82.166.9.18]:39207 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbXGYMm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:42:58 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shaohua.li@intel.com, rusty@rustcorp.com.au, Andi Kleen <ak@suse.de>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 1/3] SCHED: Generic hooks for trapping task preemption
Date: Wed, 25 Jul 2007 15:43:05 +0300
Message-Id: <11853673871109-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <11853673872732-git-send-email-avi@qumranet.com>
References: <11853673872732-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a general mechanism whereby a task can request the scheduler to
notify it whenever it is preempted or scheduled back in.  This allows the
task to swap any special-purpose registers like the fpu or Intel's VT
registers.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/preempt.h |   43 +++++++++++++++++++++++++++++++
 include/linux/sched.h   |    4 +++
 kernel/Kconfig.preempt  |    2 +
 kernel/sched.c          |   65 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index d0926d6..788d2e5 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -8,6 +8,7 @@
 
 #include <linux/thread_info.h>
 #include <linux/linkage.h>
+#include <linux/list.h>
 
 #ifdef CONFIG_DEBUG_PREEMPT
   extern void fastcall add_preempt_count(int val);
@@ -60,4 +61,46 @@ do { \
 
 #endif
 
+#ifdef CONFIG_PREEMPT_HOOKS
+
+struct preempt_hook;
+
+/**
+ * preempt_ops - hooks called when a task is preempted and rescheduled
+ * @sched_in: we're about to be rescheduled:
+ *    hook: struct preempt_hook for the task being scheduled
+ *    cpu:  cpu we're scheduled on
+ * @sched_out: we've just been preempted
+ *    hook: struct preempt_hook for the task being preempted
+ *    next: the task that's kicking us out
+ */
+struct preempt_ops {
+	void (*sched_in)(struct preempt_hook *hook, int cpu);
+	void (*sched_out)(struct preempt_hook *hook, struct task_struct *next);
+};
+
+/**
+ * preempt_hook - key for installing preemption hooks
+ * @link: internal use
+ * @ops: defines the hook functions to be called
+ *
+ * Usually used in conjunction with container_of().
+ */
+struct preempt_hook {
+	struct hlist_node link;
+	struct preempt_ops *ops;
+};
+
+void preempt_hook_register(struct preempt_hook *hook);
+void preempt_hook_unregister(struct preempt_hook *hook);
+
+static inline void preempt_hook_init(struct preempt_hook *hook,
+				     struct preempt_ops *ops)
+{
+	INIT_HLIST_NODE(&hook->link);
+	hook->ops = ops;
+}
+
+#endif
+
 #endif /* __LINUX_PREEMPT_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 33b9b48..c5e3f19 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -935,6 +935,10 @@ struct task_struct {
 	struct sched_class *sched_class;
 	struct sched_entity se;
 
+#ifdef CONFIG_PREEMPT_HOOKS
+	struct hlist_head preempt_hooks;  /* list of struct preempt_hook */
+#endif
+
 	unsigned short ioprio;
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	unsigned int btrace_seq;
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index c64ce9c..6af9c72 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -63,3 +63,5 @@ config PREEMPT_BKL
 	  Say Y here if you are building a kernel for a desktop system.
 	  Say N if you are unsure.
 
+config PREEMPT_HOOKS
+	bool
diff --git a/kernel/sched.c b/kernel/sched.c
index 93cf241..100fe93 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1592,6 +1592,10 @@ static void __sched_fork(struct task_struct *p)
 	INIT_LIST_HEAD(&p->run_list);
 	p->se.on_rq = 0;
 
+#ifdef CONFIG_PREEMPT_HOOKS
+	INIT_HLIST_HEAD(&p->preempt_hooks);
+#endif
+
 	/*
 	 * We mark the process as running here, but have not actually
 	 * inserted it onto the runqueue yet. This guarantees that
@@ -1673,6 +1677,61 @@ void fastcall wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	task_rq_unlock(rq, &flags);
 }
 
+#ifdef CONFIG_PREEMPT_HOOKS
+
+/**
+ * preempt_hook_register - tell me when current is being being preempted
+ *                         and rescheduled
+ */
+void preempt_hook_register(struct preempt_hook *hook)
+{
+	hlist_add_head(&hook->link, &current->preempt_hooks);
+}
+EXPORT_SYMBOL_GPL(preempt_hook_register);
+
+/**
+ * preempt_hook_unregister - no longer interested in preemption notifications
+ *
+ * This is safe to call from within a preemption hook.
+ */
+void preempt_hook_unregister(struct preempt_hook *hook)
+{
+	hlist_del(&hook->link);
+}
+EXPORT_SYMBOL_GPL(preempt_hook_unregister);
+
+static void fire_sched_in_preempt_hooks(struct task_struct *tsk)
+{
+	struct preempt_hook *hook;
+	struct hlist_node *node;
+
+	hlist_for_each_entry(hook, node, &tsk->preempt_hooks, link)
+		hook->ops->sched_in(hook, raw_smp_processor_id());
+}
+
+static void fire_sched_out_preempt_hooks(struct task_struct *tsk,
+					 struct task_struct *next)
+{
+	struct preempt_hook *hook;
+	struct hlist_node *node;
+
+	hlist_for_each_entry(hook, node, &tsk->preempt_hooks, link)
+		hook->ops->sched_out(hook, next);
+}
+
+#else
+
+static void fire_sched_in_preempt_hooks(struct task_struct *tsk)
+{
+}
+
+static void fire_sched_out_preempt_hooks(struct task_struct *tsk,
+					 struct task_struct *next)
+{
+}
+
+#endif
+
 /**
  * prepare_task_switch - prepare to switch tasks
  * @rq: the runqueue preparing to switch
@@ -1687,6 +1746,7 @@ void fastcall wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
  */
 static inline void prepare_task_switch(struct rq *rq, struct task_struct *next)
 {
+	fire_sched_out_preempt_hooks(current);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
 }
@@ -1728,6 +1788,7 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	prev_state = prev->state;
 	finish_arch_switch(prev);
 	finish_lock_switch(rq, prev);
+	fire_sched_in_preempt_hooks(current);
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
@@ -6335,6 +6396,10 @@ void __init sched_init(void)
 
 	set_load_weight(&init_task);
 
+#ifdef CONFIG_PREEMPT_HOOKS
+	INIT_HLIST_HEAD(&init_task.preempt_hooks);
+#endif
+
 #ifdef CONFIG_SMP
 	nr_cpu_ids = highest_cpu + 1;
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
-- 
1.5.2.4

