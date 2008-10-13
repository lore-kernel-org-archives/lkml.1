Return-Path: <linux-kernel-owner+w=401wt.eu-S1761216AbYJMXit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761216AbYJMXit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 19:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757739AbYJMXiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 19:38:24 -0400
Received: from fw.bitband.com ([213.8.50.174]:46504 "EHLO mail.bitband.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760779AbYJMXiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 19:38:22 -0400
Subject: Subject: [PATCH 2/2] linux-acpi : sos api
From: raz ben yehuda <razb@bitband.com>
To: lenb@kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, linux-acpi@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Oct 2008 01:38:19 +0200
Message-Id: <1223941099.5437.18.camel@raz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raz Ben Yehuda <razb@bitband.com>

SOS is a platform aimed to assign a service to an offloaded processor.
This patch is the facility for SOS (http://sos-linux.cvs.sourceforge.net/sos-linux/)

Signed-off-by: Raz Ben Yehuda <razb@bitband.com>
---
 arch/x86/kernel/process.c    |   42 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/process_32.c |    2 +
 arch/x86/kernel/process_64.c |    2 +
 arch/x86/kernel/smpboot.c    |    9 +++----
 include/linux/cpu.h          |   20 +++++++++++++++
 kernel/cpu.c                 |    1
 6 files changed, 72 insertions(+), 4 deletions(-)


diff -uprN -X dontdiff linux-2.6.27/arch/x86/kernel/process_32.c linux-2.6.27-dbg/arch/x86/kernel/process_32.c
--- linux-2.6.27/arch/x86/kernel/process_32.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-dbg/arch/x86/kernel/process_32.c	2008-10-13 23:29:04.000000000 +0200
@@ -106,6 +106,8 @@ static inline void play_dead(void)
 	 */
 	local_irq_disable();
 	/* mask all interrupts, flush any and all caches, and halt */
+	if (is_sossed(raw_smp_processor_id()))
+		run_sos();
 	wbinvd_halt();
 }
 #else
diff -uprN -X dontdiff linux-2.6.27/arch/x86/kernel/process_64.c linux-2.6.27-dbg/arch/x86/kernel/process_64.c
--- linux-2.6.27/arch/x86/kernel/process_64.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-dbg/arch/x86/kernel/process_64.c	2008-10-13 23:14:21.000000000 +0200
@@ -101,6 +101,8 @@ static inline void play_dead(void)
 
 	local_irq_disable();
 	/* mask all interrupts, flush any and all caches, and halt */
+	if (is_sossed(raw_smp_processor_id()))
+		run_sos();
 	wbinvd_halt();
 }
 #else
diff -uprN -X dontdiff linux-2.6.27/arch/x86/kernel/process.c linux-2.6.27-dbg/arch/x86/kernel/process.c
--- linux-2.6.27/arch/x86/kernel/process.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-dbg/arch/x86/kernel/process.c	2008-10-13 23:29:44.000000000 +0200
@@ -371,3 +371,45 @@ static int __init idle_setup(char *str)
 }
 early_param("idle", idle_setup);
 
+#ifdef CONFIG_HOTPLUG_CPU
+struct hotplug_cpu{
+	long flags;
+	void (*hotplug_cpu_dead)(void);
+};
+
+#define CPU_SOS 31
+
+DEFINE_PER_CPU(struct hotplug_cpu, soscpu);
+
+void unregister_sos(int cpuid)
+{
+	struct hotplug_cpu *cpu = &per_cpu(soscpu, cpuid);
+	cpu->hotplug_cpu_dead = NULL;
+	clear_bit(CPU_SOS, &cpu->flags);
+}
+EXPORT_SYMBOL_GPL(unregister_sos);
+
+int is_sossed(int cpuid)
+{
+	struct hotplug_cpu *cpu = &per_cpu(soscpu, cpuid);
+	return test_bit(CPU_SOS, &cpu->flags);
+}
+
+int register_sos(void (*sos_callback)(void), int cpuid)
+{
+	struct hotplug_cpu *cpu = &per_cpu(soscpu, cpuid);
+	if (is_sossed(cpuid))
+		return -1;
+	cpu->hotplug_cpu_dead = sos_callback;
+	set_bit(CPU_SOS, &cpu->flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_sos);
+
+void run_sos(void)
+{
+	int cpuid = raw_smp_processor_id();
+	struct hotplug_cpu *cpu = &per_cpu(soscpu, cpuid);
+	cpu->hotplug_cpu_dead();
+}
+#endif
diff -uprN -X dontdiff linux-2.6.27/arch/x86/kernel/smpboot.c linux-2.6.27-dbg/arch/x86/kernel/smpboot.c
--- linux-2.6.27/arch/x86/kernel/smpboot.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-dbg/arch/x86/kernel/smpboot.c	2008-10-13 23:22:48.000000000 +0200
@@ -827,8 +827,8 @@ static int __cpuinit do_boot_cpu(int api
 			/* if can't get pda memory, can't start cpu */
 	}
 #endif
-
-	alternatives_smp_switch(1);
+	if (!is_sossed(cpu))
+		alternatives_smp_switch(1);
 
 	c_idle.idle = get_idle_for_cpu(cpu);
 
@@ -1393,8 +1393,9 @@ void __cpu_die(unsigned int cpu)
 	for (i = 0; i < 10; i++) {
 		/* They ack this in play_dead by setting CPU_DEAD */
 		if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
-			printk(KERN_INFO "CPU %d is now offline\n", cpu);
-			if (1 == num_online_cpus())
+			printk(KERN_INFO "CPU %d is now offline %s\n", cpu,
+				is_sossed(cpu) ? "and SOSSED" : "");
+			if (1 == num_online_cpus() && !is_sossed(cpu))
 				alternatives_smp_switch(0);
 			return;
 		}
diff -uprN -X dontdiff linux-2.6.27/include/linux/cpu.h linux-2.6.27-dbg/include/linux/cpu.h
--- linux-2.6.27/include/linux/cpu.h	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-dbg/include/linux/cpu.h	2008-10-13 23:23:42.000000000 +0200
@@ -44,6 +44,7 @@ extern int sched_create_sysfs_power_savi
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
+extern void unregister_sos(int cpuid);
 #endif
 struct notifier_block;
 
@@ -52,6 +53,9 @@ struct notifier_block;
 #ifdef CONFIG_HOTPLUG_CPU
 extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
+extern int register_sos(void (*hotplug_cpu_dead)(void), int cpuid);
+extern int is_sossed(int cpuid);
+extern void run_sos(void);
 #else
 
 #ifndef MODULE
@@ -61,11 +65,27 @@ static inline int register_cpu_notifier(
 {
 	return 0;
 }
+
+static inline int register_sos(void (*hotplug_cpu_dead)(void), int cpuid);
+{
+	return 0;
+}
 #endif
 
 static inline void unregister_cpu_notifier(struct notifier_block *nb)
 {
 }
+
+static inline void unregister_sos(int cpuid)
+{
+}
+static inline int is_sossed(int cpuid)
+{
+	return 0;
+}
+static inline void run_sos(void)
+{
+}
 #endif
 
 int cpu_up(unsigned int cpu);
diff -uprN -X dontdiff linux-2.6.27/kernel/cpu.c linux-2.6.27-dbg/kernel/cpu.c
--- linux-2.6.27/kernel/cpu.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27-dbg/kernel/cpu.c	2008-10-13 23:14:21.000000000 +0200
@@ -389,6 +389,7 @@ out:
 	cpu_maps_update_done();
 	return err;
 }
+EXPORT_SYMBOL(cpu_up);
 
 #ifdef CONFIG_PM_SLEEP_SMP
 static cpumask_t frozen_cpus;

