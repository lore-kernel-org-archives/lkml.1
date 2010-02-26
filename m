Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936064Ab0BZMPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:15:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:43549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936025Ab0BZMPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:15:18 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 02/43] sched: rename preempt_notifiers to sched_notifiers and refactor implementation
Date: Fri, 26 Feb 2010 21:22:39 +0900
Message-Id: <1267187000-18791-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename preempt_notifiers to sched_notifiers and move it to sched.h.
Also, refactor implementation in sched.c such that adding new
callbacks is easier.

This patch does not introduce any functional change and in fact
generates the same binary at least with my configuration (x86_64 SMP,
kvm and some debug options).

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/ia64/kvm/Kconfig    |    2 +-
 arch/powerpc/kvm/Kconfig |    2 +-
 arch/s390/kvm/Kconfig    |    2 +-
 arch/x86/kvm/Kconfig     |    2 +-
 include/linux/kvm_host.h |    4 +-
 include/linux/preempt.h  |   48 --------------------
 include/linux/sched.h    |   53 +++++++++++++++++++++-
 init/Kconfig             |    2 +-
 kernel/sched.c           |  108 +++++++++++++++++++---------------------------
 virt/kvm/kvm_main.c      |   26 +++++------
 10 files changed, 113 insertions(+), 136 deletions(-)

diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index ef3e7be..a38b72e 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -22,7 +22,7 @@ config KVM
 	depends on HAVE_KVM && MODULES && EXPERIMENTAL
 	# for device assignment:
 	depends on PCI
-	select PREEMPT_NOTIFIERS
+	select SCHED_NOTIFIERS
 	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
 	select KVM_APIC_ARCHITECTURE
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 6fb6e8a..607fb26 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -18,7 +18,7 @@ if VIRTUALIZATION
 
 config KVM
 	bool
-	select PREEMPT_NOTIFIERS
+	select SCHED_NOTIFIERS
 	select ANON_INODES
 
 config KVM_BOOK3S_64_HANDLER
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 6ee55ae..a0adddd 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -18,7 +18,7 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on HAVE_KVM && EXPERIMENTAL
-	select PREEMPT_NOTIFIERS
+	select SCHED_NOTIFIERS
 	select ANON_INODES
 	---help---
 	  Support hosting paravirtualized guest machines using the SIE
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 4cd4983..fd38f79 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -22,7 +22,7 @@ config KVM
 	depends on HAVE_KVM
 	# for device assignment:
 	depends on PCI
-	select PREEMPT_NOTIFIERS
+	select SCHED_NOTIFIERS
 	select MMU_NOTIFIER
 	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bd5a616..8079759 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -74,8 +74,8 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, struct kvm_io_bus *bus,
 
 struct kvm_vcpu {
 	struct kvm *kvm;
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-	struct preempt_notifier preempt_notifier;
+#ifdef CONFIG_SCHED_NOTIFIERS
+	struct sched_notifier sched_notifier;
 #endif
 	int vcpu_id;
 	struct mutex mutex;
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 2e681d9..538c675 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -93,52 +93,4 @@ do { \
 
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
- *
- * Please note that sched_in and out are called under different
- * contexts.  sched_out is called with rq lock held and irq disabled
- * while sched_in is called without rq lock and irq enabled.  This
- * difference is intentional and depended upon by its users.
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
index 78efe7c..184389d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1227,6 +1227,53 @@ struct sched_rt_entity {
 #endif
 };
 
+#ifdef CONFIG_SCHED_NOTIFIERS
+
+struct sched_notifier;
+
+/**
+ * sched_notifier_ops - notifiers called for scheduling events
+ * @in: we're about to be rescheduled:
+ *    notifier: struct sched_notifier for the task being scheduled
+ *    cpu:  cpu we're scheduled on
+ * @out: we've just been preempted
+ *    notifier: struct sched_notifier for the task being preempted
+ *    next: the task that's kicking us out
+ *
+ * Please note that in and out are called under different contexts.
+ * out is called with rq lock held and irq disabled while in is called
+ * without rq lock and irq enabled.  This difference is intentional
+ * and depended upon by its users.
+ */
+struct sched_notifier_ops {
+	void (*in)(struct sched_notifier *notifier, int cpu);
+	void (*out)(struct sched_notifier *notifier, struct task_struct *next);
+};
+
+/**
+ * sched_notifier - key for installing scheduler notifiers
+ * @link: internal use
+ * @ops: defines the notifier functions to be called
+ *
+ * Usually used in conjunction with container_of().
+ */
+struct sched_notifier {
+	struct hlist_node link;
+	struct sched_notifier_ops *ops;
+};
+
+void sched_notifier_register(struct sched_notifier *notifier);
+void sched_notifier_unregister(struct sched_notifier *notifier);
+
+static inline void sched_notifier_init(struct sched_notifier *notifier,
+				       struct sched_notifier_ops *ops)
+{
+	INIT_HLIST_NODE(&notifier->link);
+	notifier->ops = ops;
+}
+
+#endif	/* CONFIG_SCHED_NOTIFIERS */
+
 struct rcu_node;
 
 struct task_struct {
@@ -1250,9 +1297,9 @@ struct task_struct {
 	struct sched_entity se;
 	struct sched_rt_entity rt;
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-	/* list of struct preempt_notifier: */
-	struct hlist_head preempt_notifiers;
+#ifdef CONFIG_SCHED_NOTIFIERS
+	/* list of struct sched_notifier: */
+	struct hlist_head sched_notifiers;
 #endif
 
 	/*
diff --git a/init/Kconfig b/init/Kconfig
index d95ca7c..06644b8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1259,7 +1259,7 @@ config STOP_MACHINE
 
 source "block/Kconfig"
 
-config PREEMPT_NOTIFIERS
+config SCHED_NOTIFIERS
 	bool
 
 source "kernel/Kconfig.locks"
diff --git a/kernel/sched.c b/kernel/sched.c
index ca32adc..65dba66 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1434,6 +1434,44 @@ static inline void cpuacct_update_stats(struct task_struct *tsk,
 		enum cpuacct_stat_index idx, cputime_t val) {}
 #endif
 
+#ifdef CONFIG_SCHED_NOTIFIERS
+
+#define fire_sched_notifiers(p, callback, args...) do {			\
+	struct sched_notifier *__sn;					\
+	struct hlist_node *__pos;					\
+									\
+	hlist_for_each_entry(__sn, __pos, &(p)->sched_notifiers, link)	\
+		__sn->ops->callback(__sn , ##args);			\
+} while (0)
+
+/**
+ * sched_notifier_register - register scheduler notifier
+ * @notifier: notifier struct to register
+ */
+void sched_notifier_register(struct sched_notifier *notifier)
+{
+	hlist_add_head(&notifier->link, &current->sched_notifiers);
+}
+EXPORT_SYMBOL_GPL(sched_notifier_register);
+
+/**
+ * sched_notifier_unregister - unregister scheduler notifier
+ * @notifier: notifier struct to unregister
+ *
+ * This is safe to call from within a scheduler notifier.
+ */
+void sched_notifier_unregister(struct sched_notifier *notifier)
+{
+	hlist_del(&notifier->link);
+}
+EXPORT_SYMBOL_GPL(sched_notifier_unregister);
+
+#else	/* !CONFIG_SCHED_NOTIFIERS */
+
+#define fire_sched_notifiers(p, callback, args...)	do { } while (0)
+
+#endif	/* CONFIG_SCHED_NOTIFIERS */
+
 static inline void inc_cpu_load(struct rq *rq, unsigned long load)
 {
 	update_load_add(&rq->load, load);
@@ -2566,8 +2604,8 @@ static void __sched_fork(struct task_struct *p)
 	p->se.on_rq = 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-	INIT_HLIST_HEAD(&p->preempt_notifiers);
+#ifdef CONFIG_SCHED_NOTIFIERS
+	INIT_HLIST_HEAD(&p->sched_notifiers);
 #endif
 }
 
@@ -2679,64 +2717,6 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	put_cpu();
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
@@ -2754,7 +2734,7 @@ static inline void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
-	fire_sched_out_preempt_notifiers(prev, next);
+	fire_sched_notifiers(prev, out, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
 }
@@ -2798,7 +2778,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	perf_event_task_sched_in(current, cpu_of(rq));
 	finish_lock_switch(rq, prev);
 
-	fire_sched_in_preempt_notifiers(current);
+	fire_sched_notifiers(current, in, raw_smp_processor_id());
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
@@ -9655,8 +9635,8 @@ void __init sched_init(void)
 
 	set_load_weight(&init_task);
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-	INIT_HLIST_HEAD(&init_task.preempt_notifiers);
+#ifdef CONFIG_SCHED_NOTIFIERS
+	INIT_HLIST_HEAD(&init_task.sched_notifiers);
 #endif
 
 #ifdef CONFIG_SMP
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a944be3..557d5f9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -77,7 +77,7 @@ static atomic_t hardware_enable_failed;
 struct kmem_cache *kvm_vcpu_cache;
 EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
 
-static __read_mostly struct preempt_ops kvm_preempt_ops;
+static __read_mostly struct sched_notifier_ops kvm_sched_notifier_ops;
 
 struct dentry *kvm_debugfs_dir;
 
@@ -109,7 +109,7 @@ void vcpu_load(struct kvm_vcpu *vcpu)
 
 	mutex_lock(&vcpu->mutex);
 	cpu = get_cpu();
-	preempt_notifier_register(&vcpu->preempt_notifier);
+	sched_notifier_register(&vcpu->sched_notifier);
 	kvm_arch_vcpu_load(vcpu, cpu);
 	put_cpu();
 }
@@ -118,7 +118,7 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
 	kvm_arch_vcpu_put(vcpu);
-	preempt_notifier_unregister(&vcpu->preempt_notifier);
+	sched_notifier_unregister(&vcpu->sched_notifier);
 	preempt_enable();
 	mutex_unlock(&vcpu->mutex);
 }
@@ -1195,7 +1195,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	if (IS_ERR(vcpu))
 		return PTR_ERR(vcpu);
 
-	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
+	sched_notifier_init(&vcpu->sched_notifier, &kvm_sched_notifier_ops);
 
 	r = kvm_arch_vcpu_setup(vcpu);
 	if (r)
@@ -2029,23 +2029,21 @@ static struct sys_device kvm_sysdev = {
 struct page *bad_page;
 pfn_t bad_pfn;
 
-static inline
-struct kvm_vcpu *preempt_notifier_to_vcpu(struct preempt_notifier *pn)
+static inline struct kvm_vcpu *sched_notifier_to_vcpu(struct sched_notifier *sn)
 {
-	return container_of(pn, struct kvm_vcpu, preempt_notifier);
+	return container_of(sn, struct kvm_vcpu, sched_notifier);
 }
 
-static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
+static void kvm_sched_in(struct sched_notifier *sn, int cpu)
 {
-	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
+	struct kvm_vcpu *vcpu = sched_notifier_to_vcpu(sn);
 
 	kvm_arch_vcpu_load(vcpu, cpu);
 }
 
-static void kvm_sched_out(struct preempt_notifier *pn,
-			  struct task_struct *next)
+static void kvm_sched_out(struct sched_notifier *sn, struct task_struct *next)
 {
-	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
+	struct kvm_vcpu *vcpu = sched_notifier_to_vcpu(sn);
 
 	kvm_arch_vcpu_put(vcpu);
 }
@@ -2118,8 +2116,8 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 		goto out_free;
 	}
 
-	kvm_preempt_ops.sched_in = kvm_sched_in;
-	kvm_preempt_ops.sched_out = kvm_sched_out;
+	kvm_sched_notifier_ops.in = kvm_sched_in;
+	kvm_sched_notifier_ops.out = kvm_sched_out;
 
 	kvm_init_debug();
 
-- 
1.6.4.2

