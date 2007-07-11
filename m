Return-Path: <linux-kernel-owner+w=401wt.eu-S1765342AbXGKPzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765342AbXGKPzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 11:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbXGKPz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 11:55:27 -0400
Received: from il.qumranet.com ([82.166.9.18]:48392 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbXGKPz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 11:55:26 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shaohua.li@intel.com, rusty@rustcorp.com.au,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 1/2] SCHED: Generic hooks for trapping task preemption
Date: Wed, 11 Jul 2007 18:55:32 +0300
Message-Id: <11841693333159-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.3
In-Reply-To: <11841693332609-git-send-email-avi@qumranet.com>
References: <11841693332609-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a general mechanism whereby a task can request the scheduler to
notify it whenever it is preempted or scheduled back in.  This allows the
task to swap any special-purpose registers like the fpu or Intel's VT
registers.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/preempt.h |   27 +++++++++++++++++++++++
 include/linux/sched.h   |    4 +++
 kernel/Kconfig.preempt  |    4 +++
 kernel/sched.c          |   54 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index d0926d6..376fb57 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -8,6 +8,7 @@
 
 #include <linux/thread_info.h>
 #include <linux/linkage.h>
+#include <linux/list.h>
 
 #ifdef CONFIG_DEBUG_PREEMPT
   extern void fastcall add_preempt_count(int val);
@@ -60,4 +61,30 @@ do { \
 
 #endif
 
+#ifdef CONFIG_PREEMPT_HOOKS
+
+struct preempt_hook;
+
+struct preempt_ops {
+	void (*sched_in)(struct preempt_hook *hook, int cpu);
+	void (*sched_out)(struct preempt_hook *hook);
+};
+
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
index cfb6805..a5f3d35 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -908,6 +908,10 @@ struct task_struct {
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
index c64ce9c..d45df49 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -63,3 +63,7 @@ config PREEMPT_BKL
 	  Say Y here if you are building a kernel for a desktop system.
 	  Say N if you are unsure.
 
+config PREEMPT_HOOKS
+	bool
+	depends on X86
+	default y
diff --git a/kernel/sched.c b/kernel/sched.c
index 9fbced6..080ab35 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1566,6 +1566,10 @@ static void __sched_fork(struct task_struct *p)
 	INIT_LIST_HEAD(&p->run_list);
 	p->se.on_rq = 0;
 
+#ifdef CONFIG_PREEMPT_HOOKS
+	INIT_HLIST_HEAD(&p->preempt_hooks);
+#endif
+
 	/*
 	 * We mark the process as running here, but have not actually
 	 * inserted it onto the runqueue yet. This guarantees that
@@ -1647,6 +1651,50 @@ void fastcall wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	task_rq_unlock(rq, &flags);
 }
 
+#ifdef CONFIG_PREEMPT_HOOKS
+
+void preempt_hook_register(struct preempt_hook *hook)
+{
+	hlist_add_head(&hook->link, &current->preempt_hooks);
+}
+EXPORT_SYMBOL_GPL(preempt_hook_register);
+
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
+static void fire_sched_out_preempt_hooks(struct task_struct *tsk)
+{
+	struct preempt_hook *hook;
+	struct hlist_node *node;
+
+	hlist_for_each_entry(hook, node, &tsk->preempt_hooks, link)
+		hook->ops->sched_out(hook);
+}
+
+#else
+
+static void fire_sched_in_preempt_hooks(struct task_struct *tsk)
+{
+}
+
+static void fire_sched_out_preempt_hooks(struct task_struct *tsk)
+{
+}
+
+#endif
+
 /**
  * prepare_task_switch - prepare to switch tasks
  * @rq: the runqueue preparing to switch
@@ -1661,6 +1709,7 @@ void fastcall wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
  */
 static inline void prepare_task_switch(struct rq *rq, struct task_struct *next)
 {
+	fire_sched_out_preempt_hooks(current);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
 }
@@ -1702,6 +1751,7 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	prev_state = prev->state;
 	finish_arch_switch(prev);
 	finish_lock_switch(rq, prev);
+	fire_sched_in_preempt_hooks(current);
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
@@ -6314,6 +6364,10 @@ void __init sched_init(void)
 
 	set_load_weight(&init_task);
 
+#ifdef CONFIG_PREEMPT_HOOKS
+	INIT_HLIST_HEAD(&init_task.preempt_hooks);
+#endif
+
 #ifdef CONFIG_SMP
 	nr_cpu_ids = highest_cpu + 1;
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
-- 
1.5.2.3

