Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738Ab0ARBCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab0ARBCP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 20:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556Ab0ARBB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 20:01:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:54258 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab0ARAxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:53:12 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 05/40] sched: make sched_notifiers unconditional
Date: Mon, 18 Jan 2010 09:57:17 +0900
Message-Id: <1263776272-382-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:09 +0000 (UTC)
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
index d3a65c6..38818c0 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -18,7 +18,6 @@ if VIRTUALIZATION
 
 config KVM
 	bool
-	select SCHED_NOTIFIERS
 	select ANON_INODES
 
 config KVM_BOOK3S_64_HANDLER
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index a0adddd..f9b46b0 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -18,7 +18,6 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on HAVE_KVM && EXPERIMENTAL
-	select SCHED_NOTIFIERS
 	select ANON_INODES
 	---help---
 	  Support hosting paravirtualized guest machines using the SIE
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index fd38f79..337a4e5 100644
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
index 8079759..45b631e 100644
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
index 803c6a8..9fc537a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1218,8 +1218,6 @@ struct sched_rt_entity {
 #endif
 };
 
-#ifdef CONFIG_SCHED_NOTIFIERS
-
 struct sched_notifier;
 
 /**
@@ -1263,8 +1261,6 @@ static inline void sched_notifier_init(struct sched_notifier *notifier,
 	notifier->ops = ops;
 }
 
-#endif	/* CONFIG_SCHED_NOTIFIERS */
-
 struct rcu_node;
 
 struct task_struct {
@@ -1288,10 +1284,8 @@ struct task_struct {
 	struct sched_entity se;
 	struct sched_rt_entity rt;
 
-#ifdef CONFIG_SCHED_NOTIFIERS
 	/* list of struct sched_notifier: */
 	struct hlist_head sched_notifiers;
-#endif
 
 	/*
 	 * fpu_counter contains the number of consecutive context switches
diff --git a/init/Kconfig b/init/Kconfig
index 06644b8..b1b7175 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1258,8 +1258,4 @@ config STOP_MACHINE
 	  Need stop_machine() primitive.
 
 source "block/Kconfig"
-
-config SCHED_NOTIFIERS
-	bool
-
 source "kernel/Kconfig.locks"
diff --git a/kernel/sched.c b/kernel/sched.c
index 63fcada..30b7ea8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1434,8 +1434,6 @@ static inline void cpuacct_update_stats(struct task_struct *tsk,
 		enum cpuacct_stat_index idx, cputime_t val) {}
 #endif
 
-#ifdef CONFIG_SCHED_NOTIFIERS
-
 #define fire_sched_notifiers(p, callback, args...) do {			\
 	struct sched_notifier *__sn;					\
 	struct hlist_node *__pos;					\
@@ -1466,12 +1464,6 @@ void sched_notifier_unregister(struct sched_notifier *notifier)
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
@@ -2621,10 +2613,7 @@ static void __sched_fork(struct task_struct *p)
 	INIT_LIST_HEAD(&p->rt.run_list);
 	p->se.on_rq = 0;
 	INIT_LIST_HEAD(&p->se.group_node);
-
-#ifdef CONFIG_SCHED_NOTIFIERS
 	INIT_HLIST_HEAD(&p->sched_notifiers);
-#endif
 }
 
 /*
@@ -9648,9 +9637,7 @@ void __init sched_init(void)
 
 	set_load_weight(&init_task);
 
-#ifdef CONFIG_SCHED_NOTIFIERS
 	INIT_HLIST_HEAD(&init_task.sched_notifiers);
-#endif
 
 #ifdef CONFIG_SMP
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
-- 
1.6.4.2

