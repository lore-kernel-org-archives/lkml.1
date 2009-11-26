Return-Path: <linux-kernel-owner+w=401wt.eu-S932242AbZKZKMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbZKZKMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 05:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759332AbZKZKL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 05:11:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:37628 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbZKZKL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 05:11:57 -0500
Message-ID: <4B0E5458.30303@kernel.org>
Date: Thu, 26 Nov 2009 19:11:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/4 tip/sched/core] sched: rename preempt_notifier to sched_notifier
 and always enable it
References: <20091126190018.88a6dd77.sfr@canb.auug.org.au> <20091126081237.GA31034@elte.hu> <4B0E4741.10509@kernel.org> <20091126092631.GA17253@elte.hu> <4B0E4EFB.2070705@kernel.org> <20091126095154.GE32275@elte.hu>
In-Reply-To: <20091126095154.GE32275@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename preempt_notifier to sched_notifier, move it from preempt.h to
sched.h, drop sched_ prefixes from ops names and make sched_notifier
always enabled.

This is to prepare for adding more notification hooks.  This patch
doesn't make any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 arch/ia64/kvm/Kconfig    |    1 -
 arch/powerpc/kvm/Kconfig |    1 -
 arch/s390/kvm/Kconfig    |    1 -
 arch/x86/kvm/Kconfig     |    1 -
 include/linux/kvm_host.h |    4 +--
 include/linux/preempt.h  |   43 -------------------------------
 include/linux/sched.h    |   44 ++++++++++++++++++++++++++++---
 init/Kconfig             |    4 ---
 kernel/sched.c           |   64 +++++++++++++++-------------------------------
 virt/kvm/kvm_main.c      |   26 ++++++++----------
 10 files changed, 74 insertions(+), 115 deletions(-)

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
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b7bbb5d..bc0c1d4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -74,9 +74,7 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, struct kvm_io_bus *bus,
 
 struct kvm_vcpu {
 	struct kvm *kvm;
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-	struct preempt_notifier preempt_notifier;
-#endif
+	struct sched_notifier sched_notifier;
 	int vcpu_id;
 	struct mutex mutex;
 	int   cpu;
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
index 78ba664..68fffe8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1210,6 +1210,44 @@ struct sched_rt_entity {
 #endif
 };
 
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
 struct rcu_node;
 
 struct task_struct {
@@ -1233,10 +1271,8 @@ struct task_struct {
 	struct sched_entity se;
 	struct sched_rt_entity rt;
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-	/* list of struct preempt_notifier: */
-	struct hlist_head preempt_notifiers;
-#endif
+	/* list of struct sched_notifier: */
+	struct hlist_head sched_notifiers;
 
 	/*
 	 * fpu_counter contains the number of consecutive context switches
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
index 315ba40..b5278c2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2538,10 +2538,7 @@ static void __sched_fork(struct task_struct *p)
 	INIT_LIST_HEAD(&p->rt.run_list);
 	p->se.on_rq = 0;
 	INIT_LIST_HEAD(&p->se.group_node);
-
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-	INIT_HLIST_HEAD(&p->preempt_notifiers);
-#endif
+	INIT_HLIST_HEAD(&p->sched_notifiers);
 
 	/*
 	 * We mark the process as running here, but have not actually
@@ -2651,64 +2648,47 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	task_rq_unlock(rq, &flags);
 }
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-
 /**
- * preempt_notifier_register - tell me when current is being preempted & rescheduled
+ * sched_notifier_register - register scheduler notifier
  * @notifier: notifier struct to register
  */
-void preempt_notifier_register(struct preempt_notifier *notifier)
+void sched_notifier_register(struct sched_notifier *notifier)
 {
-	hlist_add_head(&notifier->link, &current->preempt_notifiers);
+	hlist_add_head(&notifier->link, &current->sched_notifiers);
 }
-EXPORT_SYMBOL_GPL(preempt_notifier_register);
+EXPORT_SYMBOL_GPL(sched_notifier_register);
 
 /**
- * preempt_notifier_unregister - no longer interested in preemption notifications
+ * sched_notifier_unregister - unregister scheduler notifier
  * @notifier: notifier struct to unregister
  *
- * This is safe to call from within a preemption notifier.
+ * This is safe to call from within a scheduler notifier.
  */
-void preempt_notifier_unregister(struct preempt_notifier *notifier)
+void sched_notifier_unregister(struct sched_notifier *notifier)
 {
 	hlist_del(&notifier->link);
 }
-EXPORT_SYMBOL_GPL(preempt_notifier_unregister);
+EXPORT_SYMBOL_GPL(sched_notifier_unregister);
 
-static void fire_sched_in_preempt_notifiers(struct task_struct *curr)
+static void fire_sched_in_notifiers(struct task_struct *curr)
 {
-	struct preempt_notifier *notifier;
+	struct sched_notifier *notifier;
 	struct hlist_node *node;
 
-	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
-		notifier->ops->sched_in(notifier, raw_smp_processor_id());
+	hlist_for_each_entry(notifier, node, &curr->sched_notifiers, link)
+		notifier->ops->in(notifier, raw_smp_processor_id());
 }
 
-static void
-fire_sched_out_preempt_notifiers(struct task_struct *curr,
-				 struct task_struct *next)
+static void fire_sched_out_notifiers(struct task_struct *curr,
+				     struct task_struct *next)
 {
-	struct preempt_notifier *notifier;
+	struct sched_notifier *notifier;
 	struct hlist_node *node;
 
-	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
-		notifier->ops->sched_out(notifier, next);
-}
-
-#else /* !CONFIG_PREEMPT_NOTIFIERS */
-
-static void fire_sched_in_preempt_notifiers(struct task_struct *curr)
-{
+	hlist_for_each_entry(notifier, node, &curr->sched_notifiers, link)
+		notifier->ops->out(notifier, next);
 }
 
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
@@ -2726,7 +2706,7 @@ static inline void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
-	fire_sched_out_preempt_notifiers(prev, next);
+	fire_sched_out_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
 }
@@ -2768,7 +2748,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	prev_state = prev->state;
 	finish_arch_switch(prev);
 	perf_event_task_sched_in(current, cpu_of(rq));
-	fire_sched_in_preempt_notifiers(current);
+	fire_sched_in_notifiers(current);
 	finish_lock_switch(rq, prev);
 
 	if (mm)
@@ -9584,9 +9564,7 @@ void __init sched_init(void)
 
 	set_load_weight(&init_task);
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-	INIT_HLIST_HEAD(&init_task.preempt_notifiers);
-#endif
+	INIT_HLIST_HEAD(&init_task.sched_notifiers);
 
 #ifdef CONFIG_SMP
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7495ce3..4e8e33f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -79,7 +79,7 @@ static cpumask_var_t cpus_hardware_enabled;
 struct kmem_cache *kvm_vcpu_cache;
 EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
 
-static __read_mostly struct preempt_ops kvm_preempt_ops;
+static __read_mostly struct sched_notifier_ops kvm_sched_notifier_ops;
 
 struct dentry *kvm_debugfs_dir;
 
@@ -713,7 +713,7 @@ void vcpu_load(struct kvm_vcpu *vcpu)
 
 	mutex_lock(&vcpu->mutex);
 	cpu = get_cpu();
-	preempt_notifier_register(&vcpu->preempt_notifier);
+	sched_notifier_register(&vcpu->sched_notifier);
 	kvm_arch_vcpu_load(vcpu, cpu);
 	put_cpu();
 }
@@ -722,7 +722,7 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
 	kvm_arch_vcpu_put(vcpu);
-	preempt_notifier_unregister(&vcpu->preempt_notifier);
+	sched_notifier_unregister(&vcpu->sched_notifier);
 	preempt_enable();
 	mutex_unlock(&vcpu->mutex);
 }
@@ -1772,7 +1772,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	if (IS_ERR(vcpu))
 		return PTR_ERR(vcpu);
 
-	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
+	sched_notifier_init(&vcpu->sched_notifier, &kvm_sched_notifier_ops);
 
 	r = kvm_arch_vcpu_setup(vcpu);
 	if (r)
@@ -2690,23 +2690,21 @@ static struct sys_device kvm_sysdev = {
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
@@ -2780,8 +2778,8 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 		goto out_free;
 	}
 
-	kvm_preempt_ops.sched_in = kvm_sched_in;
-	kvm_preempt_ops.sched_out = kvm_sched_out;
+	kvm_sched_notifier_ops.in = kvm_sched_in;
+	kvm_sched_notifier_ops.out = kvm_sched_out;
 
 	kvm_init_debug();
 
-- 
1.6.5.3

