Return-Path: <linux-kernel-owner+w=401wt.eu-S934018AbXKOWOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018AbXKOWOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762390AbXKOWOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:14:38 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:35082 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762603AbXKOWOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:14:37 -0500
Message-ID: <473CC4C7.8080306@ct.jp.nec.com>
Date: Thu, 15 Nov 2007 14:14:31 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: clean up nmi_32/64.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] x86: clean up nmi_32/64.c

clean up and make nmi_32/64.c more similar.
- white space and coding style clean up.
- nmi_cpu_busy is available on CONFIG_SMP.
- move functions __acpi_nmi_enable, acpi_nmi_enable,
  __acpi_nmi_disable and acpi_nmi_disable.
- make variables name more similar.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/nmi_32.c |   18 +++++----
 arch/x86/kernel/nmi_64.c |   92 +++++++++++++++++++++++-----------------------
 2 files changed, 56 insertions(+), 54 deletions(-)

diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index 600fd40..d0da785 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -51,13 +51,13 @@ static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
 
 static int endflag __initdata = 0;
 
+#ifdef CONFIG_SMP
 /* The performance counters used by NMI_LOCAL_APIC don't trigger when
  * the CPU is idle. To make sure the NMI watchdog really ticks on all
  * CPUs during the test make them busy.
  */
 static __init void nmi_cpu_busy(void *data)
 {
-#ifdef CONFIG_SMP
 	local_irq_enable_in_hardirq();
 	/* Intentionally don't use cpu_relax here. This is
 	   to make sure that the performance counter really ticks,
@@ -67,8 +67,8 @@ static __init void nmi_cpu_busy(void *data)
 	   care if they get somewhat less cycles. */
 	while (endflag == 0)
 		mb();
-#endif
 }
+#endif
 
 static int __init check_nmi_watchdog(void)
 {
@@ -87,11 +87,13 @@ static int __init check_nmi_watchdog(void)
 
 	printk(KERN_INFO "Testing NMI watchdog ... ");
 
+#ifdef CONFIG_SMP
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0, 0);
+#endif
 
 	for_each_possible_cpu(cpu)
-		prev_nmi_count[cpu] = per_cpu(irq_stat, cpu).__nmi_count;
+		prev_nmi_count[cpu] = nmi_count(cpu);
 	local_irq_enable();
 	mdelay((20*1000)/nmi_hz); // wait 20 ticks
 
@@ -113,12 +115,13 @@ static int __init check_nmi_watchdog(void)
 			atomic_dec(&nmi_active);
 		}
 	}
-	endflag = 1;
 	if (!atomic_read(&nmi_active)) {
 		kfree(prev_nmi_count);
 		atomic_set(&nmi_active, -1);
+		endflag = 1;
 		return -1;
 	}
+	endflag = 1;
 	printk("OK.\n");
 
 	/* now that we know it works we can reduce NMI frequency to
@@ -173,7 +176,6 @@ static int lapic_nmi_resume(struct sys_device *dev)
 	return 0;
 }
 
-
 static struct sysdev_class nmi_sysclass = {
 	set_kset_name("lapic_nmi"),
 	.resume		= lapic_nmi_resume,
@@ -236,10 +238,10 @@ void acpi_nmi_disable(void)
 		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
 }
 
-void setup_apic_nmi_watchdog (void *unused)
+void setup_apic_nmi_watchdog(void *unused)
 {
 	if (__get_cpu_var(wd_enabled))
- 		return;
+		return;
 
 	/* cheap hack to support suspend/resume */
 	/* if cpu0 is not active neither should the other cpus */
@@ -328,7 +330,7 @@ __kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
 	unsigned int sum;
 	int touched = 0;
 	int cpu = smp_processor_id();
-	int rc=0;
+	int rc = 0;
 
 	/* check for other users first */
 	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index ce08111..b4f88d6 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -78,22 +78,22 @@ static __init void nmi_cpu_busy(void *data)
 }
 #endif
 
-int __init check_nmi_watchdog (void)
+int __init check_nmi_watchdog(void)
 {
-	int *counts;
+	int *prev_nmi_count;
 	int cpu;
 
-	if ((nmi_watchdog == NMI_NONE) || (nmi_watchdog == NMI_DISABLED)) 
+	if ((nmi_watchdog == NMI_NONE) || (nmi_watchdog == NMI_DISABLED))
 		return 0;
 
 	if (!atomic_read(&nmi_active))
 		return 0;
 
-	counts = kmalloc(NR_CPUS * sizeof(int), GFP_KERNEL);
-	if (!counts)
+	prev_nmi_count = kmalloc(NR_CPUS * sizeof(int), GFP_KERNEL);
+	if (!prev_nmi_count)
 		return -1;
 
-	printk(KERN_INFO "testing NMI watchdog ... ");
+	printk(KERN_INFO "Testing NMI watchdog ... ");
 
 #ifdef CONFIG_SMP
 	if (nmi_watchdog == NMI_LOCAL_APIC)
@@ -101,24 +101,24 @@ int __init check_nmi_watchdog (void)
 #endif
 
 	for (cpu = 0; cpu < NR_CPUS; cpu++)
-		counts[cpu] = cpu_pda(cpu)->__nmi_count;
+		prev_nmi_count[cpu] = cpu_pda(cpu)->__nmi_count;
 	local_irq_enable();
 	mdelay((20*1000)/nmi_hz); // wait 20 ticks
 
 	for_each_online_cpu(cpu) {
 		if (!per_cpu(wd_enabled, cpu))
 			continue;
-		if (cpu_pda(cpu)->__nmi_count - counts[cpu] <= 5) {
+		if (cpu_pda(cpu)->__nmi_count - prev_nmi_count[cpu] <= 5) {
 			printk("CPU#%d: NMI appears to be stuck (%d->%d)!\n",
-			       cpu,
-			       counts[cpu],
-			       cpu_pda(cpu)->__nmi_count);
+				cpu,
+				prev_nmi_count[cpu],
+				cpu_pda(cpu)->__nmi_count);
 			per_cpu(wd_enabled, cpu) = 0;
 			atomic_dec(&nmi_active);
 		}
 	}
 	if (!atomic_read(&nmi_active)) {
-		kfree(counts);
+		kfree(prev_nmi_count);
 		atomic_set(&nmi_active, -1);
 		endflag = 1;
 		return -1;
@@ -131,7 +131,7 @@ int __init check_nmi_watchdog (void)
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		nmi_hz = lapic_adjust_nmi_hz(1);
 
-	kfree(counts);
+	kfree(prev_nmi_count);
 	return 0;
 }
 
@@ -158,34 +158,6 @@ static int __init setup_nmi_watchdog(char *str)
 
 __setup("nmi_watchdog=", setup_nmi_watchdog);
 
-
-static void __acpi_nmi_disable(void *__unused)
-{
-	apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
-}
-
-/*
- * Disable timer based NMIs on all CPUs:
- */
-void acpi_nmi_disable(void)
-{
-	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
-}
-
-static void __acpi_nmi_enable(void *__unused)
-{
-	apic_write(APIC_LVT0, APIC_DM_NMI);
-}
-
-/*
- * Enable timer based NMIs on all CPUs:
- */
-void acpi_nmi_enable(void)
-{
-	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
-}
 #ifdef CONFIG_PM
 
 static int nmi_pm_active; /* nmi_active before suspend */
@@ -216,7 +188,7 @@ static struct sysdev_class nmi_sysclass = {
 };
 
 static struct sys_device device_lapic_nmi = {
-	.id		= 0,
+	.id	= 0,
 	.cls	= &nmi_sysclass,
 };
 
@@ -230,7 +202,7 @@ static int __init init_lapic_nmi_sysfs(void)
 	if (nmi_watchdog != NMI_LOCAL_APIC)
 		return 0;
 
-	if ( atomic_read(&nmi_active) < 0 )
+	if (atomic_read(&nmi_active) < 0)
 		return 0;
 
 	error = sysdev_class_register(&nmi_sysclass);
@@ -243,9 +215,37 @@ late_initcall(init_lapic_nmi_sysfs);
 
 #endif	/* CONFIG_PM */
 
+static void __acpi_nmi_enable(void *__unused)
+{
+	apic_write(APIC_LVT0, APIC_DM_NMI);
+}
+
+/*
+ * Enable timer based NMIs on all CPUs:
+ */
+void acpi_nmi_enable(void)
+{
+	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
+		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
+}
+
+static void __acpi_nmi_disable(void *__unused)
+{
+	apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
+}
+
+/*
+ * Disable timer based NMIs on all CPUs:
+ */
+void acpi_nmi_disable(void)
+{
+	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
+		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
+}
+
 void setup_apic_nmi_watchdog(void *unused)
 {
-	if (__get_cpu_var(wd_enabled) == 1)
+	if (__get_cpu_var(wd_enabled))
 		return;
 
 	/* cheap hack to support suspend/resume */
@@ -310,8 +310,9 @@ void touch_nmi_watchdog(void)
 		}
 	}
 
- 	touch_softlockup_watchdog();
+	touch_softlockup_watchdog();
 }
+EXPORT_SYMBOL(touch_nmi_watchdog);
 
 int __kprobes nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
 {
@@ -478,4 +479,3 @@ void __trigger_all_cpu_backtrace(void)
 
 EXPORT_SYMBOL(nmi_active);
 EXPORT_SYMBOL(nmi_watchdog);
-EXPORT_SYMBOL(touch_nmi_watchdog);
-- 
1.5.3.4

