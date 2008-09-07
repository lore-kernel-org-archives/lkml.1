Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYIHRLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYIHRLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbYIHRKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:10:49 -0400
Received: from sing.entic.net ([208.64.63.147]:35798 "EHLO mail.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbYIHRKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:10:47 -0400
Message-Id: <200809081710.m88HAgXl015314@mail.q-ag.de>
From: Manfred Spraul <manfred@colorfullife.com>
To: Ingo Molnar <mingo@elte.hu>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Date: Sun, 7 Sep 2008 16:57:22 +0200
Subject: [PATCH] kernel/cpu.c: create a CPU_STARTING cpu_chain notifier
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, there is no notifier that is called on a new cpu, before the new
cpu begins processing interrupts/softirqs.
Various kernel function would need that notification, e.g. kvm works around
by calling smp_call_function_single(), rcu polls cpu_online_map.

The patch adds a CPU_STARTING notification. It also adds a helper function
that sends the message to all cpu_chain handlers.

Tested on x86-64.
All other archs are untested. Especially on sparc, I'm not sure if I got
it right.

Signed-Off-By: Manfred Spraul <manfred@colorfullife.com>
---
 arch/alpha/kernel/smp.c             |    3 +++
 arch/arm/kernel/smp.c               |    1 +
 arch/cris/arch-v32/kernel/smp.c     |    1 +
 arch/ia64/kernel/smpboot.c          |    1 +
 arch/m32r/kernel/smpboot.c          |    2 ++
 arch/mips/kernel/smp.c              |    2 ++
 arch/powerpc/kernel/smp.c           |    1 +
 arch/s390/kernel/smp.c              |    2 ++
 arch/sh/kernel/smp.c                |    2 ++
 arch/sparc/kernel/sun4d_smp.c       |    1 +
 arch/sparc/kernel/sun4m_smp.c       |    2 ++
 arch/um/kernel/smp.c                |    1 +
 arch/x86/kernel/smpboot.c           |    1 +
 arch/x86/mach-voyager/voyager_smp.c |    2 ++
 include/linux/cpu.h                 |    1 +
 include/linux/notifier.h            |   10 +++++++++-
 kernel/cpu.c                        |   20 +++++++++++++++++++-
 17 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 83df541..06b6fda 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -149,6 +149,9 @@ smp_callin(void)
 	atomic_inc(&init_mm.mm_count);
 	current->active_mm = &init_mm;
 
+	/* inform the notifiers about the new cpu */
+	notify_cpu_starting(cpuid);
+
 	/* Must have completely accurate bogos.  */
 	local_irq_enable();
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index e9842f6..e42a749 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -277,6 +277,7 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	/*
 	 * Enable local interrupts.
 	 */
+	notify_cpu_starting(cpu);
 	local_irq_enable();
 	local_fiq_enable();
 
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 952a24b..52e16c6 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -178,6 +178,7 @@ void __init smp_callin(void)
 	unmask_irq(IPI_INTR_VECT);
 	unmask_irq(TIMER0_INTR_VECT);
 	preempt_disable();
+	notify_cpu_starting(cpu);
 	local_irq_enable();
 
 	cpu_set(cpu, cpu_online_map);
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index bcea81e..333b58f 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -401,6 +401,7 @@ smp_callin (void)
 	spin_lock(&vector_lock);
 	/* Setup the per cpu irq handling data structures */
 	__setup_vector_irq(cpuid);
+	notify_cpu_starting(cpuid);
 	cpu_set(cpuid, cpu_online_map);
 	per_cpu(cpu_state, cpuid) = CPU_ONLINE;
 	spin_unlock(&vector_lock);
diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index 2c03ac1..fc29948 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -498,6 +498,8 @@ static void __init smp_online(void)
 {
 	int cpu_id = smp_processor_id();
 
+	notify_cpu_starting(cpu_id);
+
 	local_irq_enable();
 
 	/* Get our bogomips. */
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 4410f17..7b59cfb 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -121,6 +121,8 @@ asmlinkage __cpuinit void start_secondary(void)
 	cpu = smp_processor_id();
 	cpu_data[cpu].udelay_val = loops_per_jiffy;
 
+	notify_cpu_starting(cpu);
+
 	mp_ops->smp_finish();
 	set_cpu_sibling_map(cpu);
 
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 5337ca7..c27b10a 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -453,6 +453,7 @@ int __devinit start_secondary(void *unused)
 	secondary_cpu_time_init();
 
 	ipi_call_lock();
+	notify_cpu_starting(cpu);
 	cpu_set(cpu, cpu_online_map);
 	/* Update sibling maps */
 	base = cpu_first_thread_in_core(cpu);
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 00b9b4d..9e8b1f9 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -585,6 +585,8 @@ int __cpuinit start_secondary(void *cpuvoid)
 	/* Enable pfault pseudo page faults on this cpu. */
 	pfault_init();
 
+	/* call cpu notifiers */
+	notify_cpu_starting(smp_processor_id());
 	/* Mark this cpu as online */
 	spin_lock(&call_lock);
 	cpu_set(smp_processor_id(), cpu_online_map);
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 60c5084..001778f 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -82,6 +82,8 @@ asmlinkage void __cpuinit start_secondary(void)
 
 	preempt_disable();
 
+	notify_cpu_starting(smp_processor_id());
+
 	local_irq_enable();
 
 	calibrate_delay();
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
index 6959640..446767e 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -88,6 +88,7 @@ void __init smp4d_callin(void)
 	local_flush_cache_all();
 	local_flush_tlb_all();
 
+	notify_cpu_starting(cpuid);
 	/*
 	 * Unblock the master CPU _only_ when the scheduler state
 	 * of all secondary CPUs will be up-to-date, so after
diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
index a14a76a..9964890 100644
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -71,6 +71,8 @@ void __cpuinit smp4m_callin(void)
 	local_flush_cache_all();
 	local_flush_tlb_all();
 
+	notify_cpu_starting(cpuid);
+
 	/* Get our local ticker going. */
 	smp_setup_percpu_timer();
 
diff --git a/arch/um/kernel/smp.c b/arch/um/kernel/smp.c
index be2d50c..0457721 100644
--- a/arch/um/kernel/smp.c
+++ b/arch/um/kernel/smp.c
@@ -85,6 +85,7 @@ static int idle_proc(void *cpup)
 	while (!cpu_isset(cpu, smp_commenced_mask))
 		cpu_relax();
 
+	notify_cpu_starting(cpu);
 	cpu_set(cpu, cpu_online_map);
 	default_idle();
 	return 0;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7985c5b..0b8261c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -257,6 +257,7 @@ static void __cpuinit smp_callin(void)
 	end_local_APIC_setup();
 	map_cpu_to_logical_apicid();
 
+	notify_cpu_starting(cpuid);
 	/*
 	 * Get our bogomips.
 	 *
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index ee0fba0..199a5f4 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -448,6 +448,8 @@ static void __init start_secondary(void *unused)
 
 	VDEBUG(("VOYAGER SMP: CPU%d, stack at about %p\n", cpuid, &cpuid));
 
+	notify_cpu_starting(cpuid);
+
 	/* enable interrupts */
 	local_irq_enable();
 
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index d7faf88..c2747ac 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -69,6 +69,7 @@ static inline void unregister_cpu_notifier(struct notifier_block *nb)
 #endif
 
 int cpu_up(unsigned int cpu);
+void notify_cpu_starting(unsigned int cpu);
 extern void cpu_hotplug_init(void);
 extern void cpu_maps_update_begin(void);
 extern void cpu_maps_update_done(void);
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index da2698b..8e47661 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -213,9 +213,16 @@ static inline int notifier_to_errno(int ret)
 #define CPU_DOWN_FAILED		0x0006 /* CPU (unsigned)v NOT going down */
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
 #define CPU_DYING		0x0008 /* CPU (unsigned)v not running any task,
-				        * not handling interrupts, soon dead */
+				        * not handling interrupts, soon dead.
+				        * Called on the dying cpu, interrupts
+				        * are already disabled. Must not
+				        * sleep, must not fail */
 #define CPU_POST_DEAD		0x0009 /* CPU (unsigned)v dead, cpu_hotplug
 					* lock is dropped */
+#define CPU_STARTING		0x000A /* CPU (unsigned)v soon running.
+					* Called on the new cpu, just before
+					* enabling interrupts. Must not sleep,
+					* must not fail */
 
 /* Used for CPU hotplug events occuring while tasks are frozen due to a suspend
  * operation in progress
@@ -229,6 +236,7 @@ static inline int notifier_to_errno(int ret)
 #define CPU_DOWN_FAILED_FROZEN	(CPU_DOWN_FAILED | CPU_TASKS_FROZEN)
 #define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
 #define CPU_DYING_FROZEN	(CPU_DYING | CPU_TASKS_FROZEN)
+#define CPU_STARTING_FROZEN	(CPU_STARTING | CPU_TASKS_FROZEN)
 
 /* Hibernation and suspend events */
 #define PM_HIBERNATION_PREPARE	0x0001 /* Going to hibernate */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index f17e985..46a8bbd 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -453,6 +453,25 @@ out:
 }
 #endif /* CONFIG_PM_SLEEP_SMP */
 
+/**
+ * notify_cpu_starting(cpu) - call the CPU_STARTING notifiers
+ * @cpu: cpu that just started
+ *
+ * This function calls the cpu_chain notifiers with CPU_STARTING.
+ * It must be called by the arch code on the new cpu, before the new cpu
+ * enables interrupts and before the "boot" cpu returns from __cpu_up().
+ */
+void notify_cpu_starting(unsigned int cpu)
+{
+	unsigned long val = CPU_STARTING;
+
+#ifdef CONFIG_PM_SLEEP_SMP
+	if (cpu_isset(cpu, frozen_cpus))
+		val = CPU_STARTING_FROZEN;
+#endif /* CONFIG_PM_SLEEP_SMP */
+	raw_notifier_call_chain(&cpu_chain, val, (void*)(long)cpu);
+}
+
 #endif /* CONFIG_SMP */
 
 /*
-- 
1.5.5.1
