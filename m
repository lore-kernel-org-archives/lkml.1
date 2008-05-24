Return-Path: <linux-kernel-owner+w=401wt.eu-S1760849AbYEXPpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849AbYEXPpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757333AbYEXPmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:42:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:10415 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990AbYEXPl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=ZpGtmT6myQOuPUjl8WTIq7BtiSH5YutLaqzOQPhzdhxHw9PNV69k210uKpJl8ky+McSvNoyagl6RsNos7mzJGMYL7txuODf0k5DyGWnPHoK+REwmEOej3HkBPHth5qt/Lr+z8LlxKaDGnWl6HMLNLCiqcnmrPQd0GNIZBZbhSTA=
References: <20080524153630.669797039@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 24 May 2008 19:36:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 10/11] x86: nmi_32/64.c - add helper functions to hide mode-specific data
Content-Disposition: inline; filename=nmi-add-helpers
Message-ID: <48383742.0437560a.0574.ffff8107@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/nmi_32.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi_32.c	2008-05-24 13:20:13.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi_32.c	2008-05-24 14:14:51.000000000 +0400
@@ -51,6 +51,26 @@ static DEFINE_PER_CPU(short, wd_enabled)
 
 static int endflag __initdata = 0;
 
+static inline unsigned int get_nmi_count(int cpu)
+{
+	return nmi_count(cpu);
+}
+
+static inline int mce_in_progress(void)
+{
+	return 0;
+}
+
+/*
+ * Take the local apic timer and PIT/HPET into account. We don't
+ * know which one is active, when we have highres/dyntick on
+ */
+static inline unsigned int get_timer_irqs(int cpu)
+{
+	return per_cpu(irq_stat, cpu).apic_timer_irqs +
+		per_cpu(irq_stat, cpu).irq0_irqs;
+}
+
 /* Run after command line and cpu_init init, but before all other checks */
 void nmi_watchdog_default(void)
 {
@@ -104,19 +124,19 @@ int __init check_nmi_watchdog(void)
 #endif
 
 	for_each_possible_cpu(cpu)
-		prev_nmi_count[cpu] = nmi_count(cpu);
+		prev_nmi_count[cpu] = get_nmi_count(cpu);
 	local_irq_enable();
 	mdelay((20*1000)/nmi_hz); // wait 20 ticks
 
 	for_each_online_cpu(cpu) {
 		if (!per_cpu(wd_enabled, cpu))
 			continue;
-		if (nmi_count(cpu) - prev_nmi_count[cpu] <= 5) {
+		if (get_nmi_count(cpu) - prev_nmi_count[cpu] <= 5) {
 			printk(KERN_WARNING "WARNING: CPU#%d: NMI "
 				"appears to be stuck (%d->%d)!\n",
 				cpu,
 				prev_nmi_count[cpu],
-				nmi_count(cpu));
+				get_nmi_count(cpu));
 			per_cpu(wd_enabled, cpu) = 0;
 			atomic_dec(&nmi_active);
 		}
@@ -355,6 +375,13 @@ nmi_watchdog_tick(struct pt_regs *regs, 
 		touched = 1;
 	}
 
+	sum = get_timer_irqs(cpu);
+
+	if (__get_cpu_var(nmi_touch)) {
+		__get_cpu_var(nmi_touch) = 0;
+		touched = 1;
+	}
+
 	if (cpu_isset(cpu, backtrace_mask)) {
 		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
 
@@ -365,16 +392,9 @@ nmi_watchdog_tick(struct pt_regs *regs, 
 		cpu_clear(cpu, backtrace_mask);
 	}
 
-	/*
-	 * Take the local apic timer and PIT/HPET into account. We don't
-	 * know which one is active, when we have highres/dyntick on
-	 */
-	sum = per_cpu(irq_stat, cpu).apic_timer_irqs +
-		per_cpu(irq_stat, cpu).irq0_irqs;
-	if (__get_cpu_var(nmi_touch)) {
-		__get_cpu_var(nmi_touch) = 0;
+	/* Could check oops_in_progress here too, but it's safer not to */
+	if (mce_in_progress())
 		touched = 1;
-	}
 
 	/* if the none of the timers isn't firing, this cpu isn't doing much */
 	if (!touched && __get_cpu_var(last_irq_sum) == sum) {
Index: linux-2.6.git/arch/x86/kernel/nmi_64.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi_64.c	2008-05-24 13:19:23.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi_64.c	2008-05-24 14:13:08.000000000 +0400
@@ -47,6 +47,30 @@ static unsigned int nmi_hz = HZ;
 
 static DEFINE_PER_CPU(short, wd_enabled);
 
+static int endflag __initdata = 0;
+
+static inline unsigned int get_nmi_count(int cpu)
+{
+	return cpu_pda(cpu)->__nmi_count;
+}
+
+static inline int mce_in_progress(void)
+{
+#ifdef CONFIG_X86_MCE
+	return atomic_read(&mce_entry) > 0;
+#endif
+	return 0;
+}
+
+/*
+ * Take the local apic timer and PIT/HPET into account. We don't
+ * know which one is active, when we have highres/dyntick on
+ */
+static inline unsigned int get_timer_irqs(int cpu)
+{
+	return read_pda(apic_timer_irqs) + read_pda(irq0_irqs);
+}
+
 /* Run after command line and cpu_init init, but before all other checks */
 void nmi_watchdog_default(void)
 {
@@ -55,8 +79,6 @@ void nmi_watchdog_default(void)
 	nmi_watchdog = NMI_NONE;
 }
 
-static int endflag __initdata = 0;
-
 #ifdef CONFIG_SMP
 /* The performance counters used by NMI_LOCAL_APIC don't trigger when
  * the CPU is idle. To make sure the NMI watchdog really ticks on all
@@ -99,19 +121,19 @@ int __init check_nmi_watchdog(void)
 #endif
 
 	for_each_possible_cpu(cpu)
-		prev_nmi_count[cpu] = cpu_pda(cpu)->__nmi_count;
+		prev_nmi_count[cpu] = get_nmi_count(cpu);
 	local_irq_enable();
 	mdelay((20*1000)/nmi_hz); // wait 20 ticks
 
 	for_each_online_cpu(cpu) {
 		if (!per_cpu(wd_enabled, cpu))
 			continue;
-		if (cpu_pda(cpu)->__nmi_count - prev_nmi_count[cpu] <= 5) {
+		if (get_nmi_count(cpu) - prev_nmi_count[cpu] <= 5) {
 			printk(KERN_WARNING "WARNING: CPU#%d: NMI "
 			       "appears to be stuck (%d->%d)!\n",
 				cpu,
 				prev_nmi_count[cpu],
-				cpu_pda(cpu)->__nmi_count);
+				get_nmi_count(cpu));
 			per_cpu(wd_enabled, cpu) = 0;
 			atomic_dec(&nmi_active);
 		}
@@ -327,7 +349,8 @@ nmi_watchdog_tick(struct pt_regs *regs, 
 		touched = 1;
 	}
 
-	sum = read_pda(apic_timer_irqs) + read_pda(irq0_irqs);
+	sum = get_timer_irqs(cpu);
+
 	if (__get_cpu_var(nmi_touch)) {
 		__get_cpu_var(nmi_touch) = 0;
 		touched = 1;
@@ -343,12 +366,9 @@ nmi_watchdog_tick(struct pt_regs *regs, 
 		cpu_clear(cpu, backtrace_mask);
 	}
 
-#ifdef CONFIG_X86_MCE
-	/* Could check oops_in_progress here too, but it's safer
-	   not too */
-	if (atomic_read(&mce_entry) > 0)
+	if (mce_in_progress())
 		touched = 1;
-#endif
+
 	/* if the apic timer isn't firing, this cpu isn't doing much */
 	if (!touched && __get_cpu_var(last_irq_sum) == sum) {
 		/*

-- 
