Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbYCCR0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbYCCR0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759651AbYCCRPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:15:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778AbYCCRPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:15:44 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 39/52] merge __cpu_disable and cpu_die
Date: Mon,  3 Mar 2008 14:13:07 -0300
Message-Id: <1204564400-17636-40-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-39-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
 <1204564400-17636-25-git-send-email-gcosta@redhat.com>
 <1204564400-17636-26-git-send-email-gcosta@redhat.com>
 <1204564400-17636-27-git-send-email-gcosta@redhat.com>
 <1204564400-17636-28-git-send-email-gcosta@redhat.com>
 <1204564400-17636-29-git-send-email-gcosta@redhat.com>
 <1204564400-17636-30-git-send-email-gcosta@redhat.com>
 <1204564400-17636-31-git-send-email-gcosta@redhat.com>
 <1204564400-17636-32-git-send-email-gcosta@redhat.com>
 <1204564400-17636-33-git-send-email-gcosta@redhat.com>
 <1204564400-17636-34-git-send-email-gcosta@redhat.com>
 <1204564400-17636-35-git-send-email-gcosta@redhat.com>
 <1204564400-17636-36-git-send-email-gcosta@redhat.com>
 <1204564400-17636-37-git-send-email-gcosta@redhat.com>
 <1204564400-17636-38-git-send-email-gcosta@redhat.com>
 <1204564400-17636-39-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are now equal, and are moved to a common file

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |   85 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot_32.c |   67 ---------------------------------
 arch/x86/kernel/smpboot_64.c |   79 ---------------------------------------
 include/asm-x86/smp.h        |    3 +
 include/asm-x86/smp_32.h     |    3 -
 include/asm-x86/smp_64.h     |    3 -
 6 files changed, 88 insertions(+), 152 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 644e609..c35cd31 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -2,6 +2,13 @@
 #include <linux/smp.h>
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/percpu.h>
+
+#include <asm/nmi.h>
+#include <asm/irq.h>
+#include <asm/smp.h>
+#include <asm/cpu.h>
+#include <asm/numa.h>
 
 /* Number of siblings per CPU package */
 int smp_num_siblings = 1;
@@ -181,5 +188,83 @@ __init void prefill_possible_map(void)
 	for (i = 0; i < possible; i++)
 		cpu_set(i, cpu_possible_map);
 }
+
+static void __ref remove_cpu_from_maps(int cpu)
+{
+	cpu_clear(cpu, cpu_online_map);
+#ifdef CONFIG_X86_64
+	cpu_clear(cpu, cpu_callout_map);
+	cpu_clear(cpu, cpu_callin_map);
+	/* was set by cpu_init() */
+	clear_bit(cpu, (unsigned long *)&cpu_initialized);
+	clear_node_cpumask(cpu);
+#endif
+}
+
+int __cpu_disable(void)
+{
+	int cpu = smp_processor_id();
+
+	/*
+	 * Perhaps use cpufreq to drop frequency, but that could go
+	 * into generic code.
+	 *
+	 * We won't take down the boot processor on i386 due to some
+	 * interrupts only being able to be serviced by the BSP.
+	 * Especially so if we're not using an IOAPIC	-zwane
+	 */
+	if (cpu == 0)
+		return -EBUSY;
+
+	if (nmi_watchdog == NMI_LOCAL_APIC)
+		stop_apic_nmi_watchdog(NULL);
+	clear_local_APIC();
+
+	/*
+	 * HACK:
+	 * Allow any queued timer interrupts to get serviced
+	 * This is only a temporary solution until we cleanup
+	 * fixup_irqs as we do for IA64.
+	 */
+	local_irq_enable();
+	mdelay(1);
+
+	local_irq_disable();
+	remove_siblinginfo(cpu);
+
+	/* It's now safe to remove this processor from the online map */
+	remove_cpu_from_maps(cpu);
+	fixup_irqs(cpu_online_map);
+	return 0;
+}
+
+void __cpu_die(unsigned int cpu)
+{
+	/* We don't do anything here: idle task is faking death itself. */
+	unsigned int i;
+
+	for (i = 0; i < 10; i++) {
+		/* They ack this in play_dead by setting CPU_DEAD */
+		if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
+			printk(KERN_INFO "CPU %d is now offline\n", cpu);
+			if (1 == num_online_cpus())
+				alternatives_smp_switch(0);
+			return;
+		}
+		msleep(100);
+	}
+	printk(KERN_ERR "CPU %u didn't die...\n", cpu);
+}
+#else /* ... !CONFIG_HOTPLUG_CPU */
+int __cpu_disable(void)
+{
+	return -ENOSYS;
+}
+
+void __cpu_die(unsigned int cpu)
+{
+	/* We said "no" in __cpu_disable */
+	BUG();
+}
 #endif
 
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 3d21c66..00b1b59 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -1040,73 +1040,6 @@ void __init native_smp_prepare_boot_cpu(void)
 	__get_cpu_var(cpu_state) = CPU_ONLINE;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-static void __ref remove_cpu_from_maps(int cpu)
-{
-	cpu_clear(cpu, cpu_online_map);
-}
-
-int __cpu_disable(void)
-{
-	cpumask_t map = cpu_online_map;
-	int cpu = smp_processor_id();
-
-	/*
-	 * Perhaps use cpufreq to drop frequency, but that could go
-	 * into generic code.
- 	 *
-	 * We won't take down the boot processor on i386 due to some
-	 * interrupts only being able to be serviced by the BSP.
-	 * Especially so if we're not using an IOAPIC	-zwane
-	 */
-	if (cpu == 0)
-		return -EBUSY;
-	if (nmi_watchdog == NMI_LOCAL_APIC)
-		stop_apic_nmi_watchdog(NULL);
-	clear_local_APIC();
-	/* Allow any queued timer interrupts to get serviced */
-	local_irq_enable();
-	mdelay(1);
-	local_irq_disable();
-
-	remove_siblinginfo(cpu);
-
-	remove_cpu_from_maps(cpu);
-	fixup_irqs(map);
-
-	return 0;
-}
-
-void __cpu_die(unsigned int cpu)
-{
-	/* We don't do anything here: idle task is faking death itself. */
-	unsigned int i;
-
-	for (i = 0; i < 10; i++) {
-		/* They ack this in play_dead by setting CPU_DEAD */
-		if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
-			printk ("CPU %d is now offline\n", cpu);
-			if (1 == num_online_cpus())
-				alternatives_smp_switch(0);
-			return;
-		}
-		msleep(100);
-	}
- 	printk(KERN_ERR "CPU %u didn't die...\n", cpu);
-}
-#else /* ... !CONFIG_HOTPLUG_CPU */
-int __cpu_disable(void)
-{
-	return -ENOSYS;
-}
-
-void __cpu_die(unsigned int cpu)
-{
-	/* We said "no" in __cpu_disable */
-	BUG();
-}
-#endif /* CONFIG_HOTPLUG_CPU */
-
 int __cpuinit native_cpu_up(unsigned int cpu)
 {
 	unsigned long flags;
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 6509d3c..0c67e5a 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -836,82 +836,3 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 	setup_ioapic_dest();
 	check_nmi_watchdog();
 }
-
-#ifdef CONFIG_HOTPLUG_CPU
-static void __ref remove_cpu_from_maps(int cpu)
-{
-	cpu_clear(cpu, cpu_online_map);
-	cpu_clear(cpu, cpu_callout_map);
-	cpu_clear(cpu, cpu_callin_map);
-	clear_bit(cpu, (unsigned long *)&cpu_initialized); /* was set by cpu_init() */
-	clear_node_cpumask(cpu);
-}
-
-int __cpu_disable(void)
-{
-	int cpu = smp_processor_id();
-
-	/*
-	 * Perhaps use cpufreq to drop frequency, but that could go
-	 * into generic code.
- 	 *
-	 * We won't take down the boot processor on i386 due to some
-	 * interrupts only being able to be serviced by the BSP.
-	 * Especially so if we're not using an IOAPIC	-zwane
-	 */
-	if (cpu == 0)
-		return -EBUSY;
-
-	if (nmi_watchdog == NMI_LOCAL_APIC)
-		stop_apic_nmi_watchdog(NULL);
-	clear_local_APIC();
-
-	/*
-	 * HACK:
-	 * Allow any queued timer interrupts to get serviced
-	 * This is only a temporary solution until we cleanup
-	 * fixup_irqs as we do for IA64.
-	 */
-	local_irq_enable();
-	mdelay(1);
-
-	local_irq_disable();
-	remove_siblinginfo(cpu);
-
-	/* It's now safe to remove this processor from the online map */
-	remove_cpu_from_maps(cpu);
-	fixup_irqs(cpu_online_map);
-	return 0;
-}
-
-void __cpu_die(unsigned int cpu)
-{
-	/* We don't do anything here: idle task is faking death itself. */
-	unsigned int i;
-
-	for (i = 0; i < 10; i++) {
-		/* They ack this in play_dead by setting CPU_DEAD */
-		if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
-			printk ("CPU %d is now offline\n", cpu);
-			if (1 == num_online_cpus())
-				alternatives_smp_switch(0);
-			return;
-		}
-		msleep(100);
-	}
- 	printk(KERN_ERR "CPU %u didn't die...\n", cpu);
-}
-
-#else /* ... !CONFIG_HOTPLUG_CPU */
-
-int __cpu_disable(void)
-{
-	return -ENOSYS;
-}
-
-void __cpu_die(unsigned int cpu)
-{
-	/* We said "no" in __cpu_disable */
-	BUG();
-}
-#endif /* CONFIG_HOTPLUG_CPU */
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index c800b81..27d9f65 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -70,6 +70,9 @@ void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
 int native_cpu_up(unsigned int cpunum);
 
+extern int __cpu_disable(void);
+extern void __cpu_die(unsigned int cpu);
+
 extern unsigned disabled_cpus;
 extern void prefill_possible_map(void);
 #endif
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 0b25134..4fec2fe 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -34,9 +34,6 @@ DECLARE_PER_CPU(u16, x86_cpu_to_apicid);
 #define startup_ipi_hook(phys_apicid, start_eip, start_esp) do { } while (0)
 #endif
 
-extern int __cpu_disable(void);
-extern void __cpu_die(unsigned int cpu);
-
 /*
  * This function is needed by all SMP systems. It must _always_ be valid
  * from the initial startup. We map APIC_BASE very early in page_setup(),
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index 1ecf813..d554d7d 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -42,9 +42,6 @@ static inline int cpu_present_to_apicid(int mps_cpu)
 
 #define SMP_TRAMPOLINE_BASE 0x6000
 
-extern int __cpu_disable(void);
-extern void __cpu_die(unsigned int cpu);
-
 #define raw_smp_processor_id()	read_pda(cpunumber)
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
 
-- 
1.5.0.6

