Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbZLBD51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbZLBD51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 22:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbZLBD5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 22:57:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:56243 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbZLBD5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 22:57:19 -0500
From: Tejun Heo <tj@kernel.org>
To: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, peterz@infradead.org,
       efault@gmx.de, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/7] sched: make sched_notifiers unconditional
Date: Wed,  2 Dec 2009 12:56:50 +0900
Message-Id: <1259726212-30259-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1259726212-30259-1-git-send-email-tj@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_notifiers will be used by workqueue which is always there.
Always enable sched_notifiers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/ia64/kvm/Kconfig    |    1 -
 arch/powerpc/kvm/Kconfig |    1 -
 arch/s390/kvm/Kconfig    |    1 -
 arch/x86/kvm/Kconfig     |    1 -
 include/linux/kvm_host.h |    2 --
 include/linux/sched.h    |    6 ------
 init/Kconfig             |    4 ----
 kernel/sched.c           |   13 -------------
 8 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index a38b72e..a9e2b9c 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	depends on HAVE_KVM && MODULES && EXPERIMENTAL
 	# for device assignment:
 	depends on PCI
-	select SCHED_NOTIFIERS
 	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
 	select KVM_APIC_ARCHITECTURE
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 6447702..092503e 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -18,7 +18,6 @@ if VIRTUALIZATION
 
 config KVM
 	bool
-	select SCHED_NOTIFIERS
 	select ANON_INODES
 
 config KVM_440
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 3bc7045..e125d45 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -18,7 +18,6 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on HAVE_KVM && EXPERIMENTAL
-	select SCHED_NOTIFIERS
 	select ANON_INODES
 	select S390_SWITCH_AMODE
 	---help---
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 23609bd..b391852 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	depends on HAVE_KVM
 	# for device assignment:
 	depends on PCI
-	select SCHED_NOTIFIERS
 	select MMU_NOTIFIER
 	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d05fadc..bc0c1d4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -74,9 +74,7 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, struct kvm_io_bus *bus,
 
 struct kvm_vcpu {
 	struct kvm *kvm;
-#ifdef CONFIG_SCHED_NOTIFIERS
 	struct sched_notifier sched_notifier;
-#endif
 	int vcpu_id;
 	struct mutex mutex;
 	int   cpu;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ae4fcfe..bc8be2d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1210,8 +1210,6 @@ struct sched_rt_entity {
 #endif
 };
 
-#ifdef CONFIG_SCHED_NOTIFIERS
-
 struct sched_notifier;
 
 /**
@@ -1255,8 +1253,6 @@ static inline void sched_notifier_init(struct sched_notifier *notifier,
 	notifier->ops = ops;
 }
 
-#endif	/* CONFIG_SCHED_NOTIFIERS */
-
 struct rcu_node;
 
 struct task_struct {
@@ -1280,10 +1276,8 @@ struct task_struct {
 	struct sched_entity se;
 	struct sched_rt_entity rt;
 
-#ifdef CONFIG_SCHED_NOTIFIERS
 	/* list of struct sched_notifier: */
 	struct hlist_head sched_notifiers;
-#endif
 
 	/*
 	 * fpu_counter contains the number of consecutive context switches
diff --git a/init/Kconfig b/init/Kconfig
index c7eef2b..0220aa7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1206,7 +1206,3 @@ config STOP_MACHINE
 	  Need stop_machine() primitive.
 
 source "block/Kconfig"
-
-config SCHED_NOTIFIERS
-	bool
-
diff --git a/kernel/sched.c b/kernel/sched.c
index 8fd3981..f7d9bb3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1433,8 +1433,6 @@ static inline void cpuacct_update_stats(struct task_struct *tsk,
 		enum cpuacct_stat_index idx, cputime_t val) {}
 #endif
 
-#ifdef CONFIG_SCHED_NOTIFIERS
-
 #define fire_sched_notifiers(p, callback, args...) do {			\
 	struct sched_notifier *__sn;					\
 	struct hlist_node *__pos;					\
@@ -1465,12 +1463,6 @@ void sched_notifier_unregister(struct sched_notifier *notifier)
 }
 EXPORT_SYMBOL_GPL(sched_notifier_unregister);
 
-#else	/* !CONFIG_SCHED_NOTIFIERS */
-
-#define fire_sched_notifiers(p, callback, args...)	do { } while (0)
-
-#endif	/* CONFIG_SCHED_NOTIFIERS */
-
 static inline void inc_cpu_load(struct rq *rq, unsigned long load)
 {
 	update_load_add(&rq->load, load);
@@ -2592,10 +2584,7 @@ static void __sched_fork(struct task_struct *p)
 	INIT_LIST_HEAD(&p->rt.run_list);
 	p->se.on_rq = 0;
 	INIT_LIST_HEAD(&p->se.group_node);
-
-#ifdef CONFIG_SCHED_NOTIFIERS
 	INIT_HLIST_HEAD(&p->sched_notifiers);
-#endif
 
 	/*
 	 * We mark the process as running here, but have not actually
@@ -9594,9 +9583,7 @@ void __init sched_init(void)
 
 	set_load_weight(&init_task);
 
-#ifdef CONFIG_SCHED_NOTIFIERS
 	INIT_HLIST_HEAD(&init_task.sched_notifiers);
-#endif
 
 #ifdef CONFIG_SMP
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
-- 
1.6.4.2

