Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZKPRQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZKPRQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbZKPRQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:16:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:33316 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbZKPRQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:16:33 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
       andi@firstfloor.org, fweisbec@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/21] sched: drop preempt notifiers
Date: Tue, 17 Nov 2009 02:15:11 +0900
Message-Id: <1258391726-30264-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258391726-30264-1-git-send-email-tj@kernel.org>
References: <1258391726-30264-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With kvm converted, preempt notifiers have no user.  Kill it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/ia64/kvm/Kconfig    |    1 -
 arch/powerpc/kvm/Kconfig |    1 -
 arch/s390/kvm/Kconfig    |    1 -
 arch/x86/kvm/Kconfig     |    1 -
 include/linux/preempt.h  |   43 ------------------------------
 include/linux/sched.h    |    4 ---
 init/Kconfig             |    4 ---
 kernel/sched.c           |   66 ----------------------------------------------
 8 files changed, 0 insertions(+), 121 deletions(-)

diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index ef3e7be..a9e2b9c 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	depends on HAVE_KVM && MODULES && EXPERIMENTAL
 	# for device assignment:
 	depends on PCI
-	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
 	select KVM_APIC_ARCHITECTURE
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index c299268..092503e 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -18,7 +18,6 @@ if VIRTUALIZATION
 
 config KVM
 	bool
-	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 
 config KVM_440
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index bf164fc..e125d45 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -18,7 +18,6 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on HAVE_KVM && EXPERIMENTAL
-	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select S390_SWITCH_AMODE
 	---help---
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index b84e571..b391852 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	depends on HAVE_KVM
 	# for device assignment:
 	depends on PCI
-	select PREEMPT_NOTIFIERS
 	select MMU_NOTIFIER
 	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 72b1a10..538c675 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -93,47 +93,4 @@ do { \
 
 #endif
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-
-struct preempt_notifier;
-
-/**
- * preempt_ops - notifiers called when a task is preempted and rescheduled
- * @sched_in: we're about to be rescheduled:
- *    notifier: struct preempt_notifier for the task being scheduled
- *    cpu:  cpu we're scheduled on
- * @sched_out: we've just been preempted
- *    notifier: struct preempt_notifier for the task being preempted
- *    next: the task that's kicking us out
- */
-struct preempt_ops {
-	void (*sched_in)(struct preempt_notifier *notifier, int cpu);
-	void (*sched_out)(struct preempt_notifier *notifier,
-			  struct task_struct *next);
-};
-
-/**
- * preempt_notifier - key for installing preemption notifiers
- * @link: internal use
- * @ops: defines the notifier functions to be called
- *
- * Usually used in conjunction with container_of().
- */
-struct preempt_notifier {
-	struct hlist_node link;
-	struct preempt_ops *ops;
-};
-
-void preempt_notifier_register(struct preempt_notifier *notifier);
-void preempt_notifier_unregister(struct preempt_notifier *notifier);
-
-static inline void preempt_notifier_init(struct preempt_notifier *notifier,
-				     struct preempt_ops *ops)
-{
-	INIT_HLIST_NODE(&notifier->link);
-	notifier->ops = ops;
-}
-
-#endif
-
 #endif /* __LINUX_PREEMPT_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0012980..16dcd58 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1264,10 +1264,6 @@ struct task_struct {
 	struct sched_entity se;
 	struct sched_rt_entity rt;
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-	/* list of struct preempt_notifier: */
-	struct hlist_head preempt_notifiers;
-#endif
 	/* sched notifiers */
 	struct hlist_head notifiers[SCHED_NR_NOTIFIERS];
 
diff --git a/init/Kconfig b/init/Kconfig
index 9e03ef8..0220aa7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1206,7 +1206,3 @@ config STOP_MACHINE
 	  Need stop_machine() primitive.
 
 source "block/Kconfig"
-
-config PREEMPT_NOTIFIERS
-	bool
-
diff --git a/kernel/sched.c b/kernel/sched.c
index 946c7a8..a25b993 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2546,9 +2546,6 @@ static void __sched_fork(struct task_struct *p)
 	p->se.on_rq = 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-	INIT_HLIST_HEAD(&p->preempt_notifiers);
-#endif
 	for (i = 0; i < SCHED_NR_NOTIFIERS; i++)
 		INIT_HLIST_HEAD(&p->notifiers[i]);
 
@@ -2656,64 +2653,6 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	task_rq_unlock(rq, &flags);
 }
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-
-/**
- * preempt_notifier_register - tell me when current is being preempted & rescheduled
- * @notifier: notifier struct to register
- */
-void preempt_notifier_register(struct preempt_notifier *notifier)
-{
-	hlist_add_head(&notifier->link, &current->preempt_notifiers);
-}
-EXPORT_SYMBOL_GPL(preempt_notifier_register);
-
-/**
- * preempt_notifier_unregister - no longer interested in preemption notifications
- * @notifier: notifier struct to unregister
- *
- * This is safe to call from within a preemption notifier.
- */
-void preempt_notifier_unregister(struct preempt_notifier *notifier)
-{
-	hlist_del(&notifier->link);
-}
-EXPORT_SYMBOL_GPL(preempt_notifier_unregister);
-
-static void fire_sched_in_preempt_notifiers(struct task_struct *curr)
-{
-	struct preempt_notifier *notifier;
-	struct hlist_node *node;
-
-	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
-		notifier->ops->sched_in(notifier, raw_smp_processor_id());
-}
-
-static void
-fire_sched_out_preempt_notifiers(struct task_struct *curr,
-				 struct task_struct *next)
-{
-	struct preempt_notifier *notifier;
-	struct hlist_node *node;
-
-	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
-		notifier->ops->sched_out(notifier, next);
-}
-
-#else /* !CONFIG_PREEMPT_NOTIFIERS */
-
-static void fire_sched_in_preempt_notifiers(struct task_struct *curr)
-{
-}
-
-static void
-fire_sched_out_preempt_notifiers(struct task_struct *curr,
-				 struct task_struct *next)
-{
-}
-
-#endif /* CONFIG_PREEMPT_NOTIFIERS */
-
 /**
  * prepare_task_switch - prepare to switch tasks
  * @rq: the runqueue preparing to switch
@@ -2732,7 +2671,6 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
 	sched_notifier_call(prev, SCHED_NOTIFIER_OUT, out, next);
-	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
 }
@@ -2775,7 +2713,6 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	finish_arch_switch(prev);
 	perf_event_task_sched_in(current, cpu_of(rq));
 	sched_notifier_call(current, SCHED_NOTIFIER_IN, in, prev);
-	fire_sched_in_preempt_notifiers(current);
 	finish_lock_switch(rq, prev);
 
 	if (mm)
@@ -9583,9 +9520,6 @@ void __init sched_init(void)
 
 	set_load_weight(&init_task);
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-	INIT_HLIST_HEAD(&init_task.preempt_notifiers);
-#endif
 	for (i = 0; i < SCHED_NR_NOTIFIERS; i++)
 		INIT_HLIST_HEAD(&init_task.notifiers[i]);
 
-- 
1.6.4.2

