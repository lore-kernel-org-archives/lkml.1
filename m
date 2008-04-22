Return-Path: <linux-kernel-owner+w=401wt.eu-S933088AbYDVPJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbYDVPJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763505AbYDVPJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:09:06 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15421 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735AbYDVPJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:09:05 -0400
Message-Id: <480E1BBA.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 16:09:14 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make /proc/stat account for all interrupts
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LAPIC interrupts, which don't go through the generic interrupt handling
code, aren't accounted for in /proc/stat. Hence this patch adds a
mechanism architectures can use to accordingly adjust the statistics.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/irq_32.c  |   38 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/irq_64.c  |   28 ++++++++++++++++++++++++++++
 fs/proc/proc_misc.c       |    9 +++++++++
 include/asm-x86/hardirq.h |    6 ++++++
 4 files changed, 81 insertions(+)

--- linux-2.6.25/arch/x86/kernel/irq_32.c	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-arch-irq-stat/arch/x86/kernel/irq_32.c	2008-04-17 15:26:48.000000000 +0200
@@ -315,16 +315,20 @@ skip:
 				per_cpu(irq_stat,j).irq_tlb_count);
 		seq_printf(p, "  TLB shootdowns\n");
 #endif
+#ifdef CONFIG_X86_MCE
 		seq_printf(p, "TRM: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ",
 				per_cpu(irq_stat,j).irq_thermal_count);
 		seq_printf(p, "  Thermal event interrupts\n");
+#endif
+#ifdef CONFIG_X86_LOCAL_APIC
 		seq_printf(p, "SPU: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ",
 				per_cpu(irq_stat,j).irq_spurious_count);
 		seq_printf(p, "  Spurious interrupts\n");
+#endif
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
 		seq_printf(p, "MIS: %10u\n", atomic_read(&irq_mis_count));
@@ -333,6 +337,40 @@ skip:
 	return 0;
 }
 
+/*
+ * /proc/stat helpers
+ */
+u64 arch_irq_stat_cpu(unsigned int cpu)
+{
+	u64 sum = nmi_count(cpu);
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	sum += per_cpu(irq_stat, cpu).apic_timer_irqs;
+#endif
+#ifdef CONFIG_SMP
+	sum += per_cpu(irq_stat, cpu).irq_resched_count;
+	sum += per_cpu(irq_stat, cpu).irq_call_count;
+	sum += per_cpu(irq_stat, cpu).irq_tlb_count;
+#endif
+#ifdef CONFIG_X86_MCE
+	sum += per_cpu(irq_stat, cpu).irq_thermal_count;
+#endif
+#ifdef CONFIG_X86_LOCAL_APIC
+	sum += per_cpu(irq_stat, cpu).irq_spurious_count;
+#endif
+	return sum;
+}
+
+u64 arch_irq_stat(void)
+{
+	u64 sum = atomic_read(&irq_err_count);
+
+#ifdef CONFIG_X86_IO_APIC
+	sum += atomic_read(&irq_mis_count);
+#endif
+	return sum;
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 #include <mach_apic.h>
 
--- linux-2.6.25/arch/x86/kernel/irq_64.c	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-arch-irq-stat/arch/x86/kernel/irq_64.c	2008-04-17 15:27:04.000000000 +0200
@@ -135,6 +135,7 @@ skip:
 			seq_printf(p, "%10u ", cpu_pda(j)->irq_tlb_count);
 		seq_printf(p, "  TLB shootdowns\n");
 #endif
+#ifdef CONFIG_X86_MCE
 		seq_printf(p, "TRM: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->irq_thermal_count);
@@ -143,6 +144,7 @@ skip:
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->irq_threshold_count);
 		seq_printf(p, "  Threshold APIC interrupts\n");
+#endif
 		seq_printf(p, "SPU: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->irq_spurious_count);
@@ -153,6 +155,32 @@ skip:
 }
 
 /*
+ * /proc/stat helpers
+ */
+u64 arch_irq_stat_cpu(unsigned int cpu)
+{
+	u64 sum = cpu_pda(cpu)->__nmi_count;
+
+	sum += cpu_pda(cpu)->apic_timer_irqs;
+#ifdef CONFIG_SMP
+	sum += cpu_pda(cpu)->irq_resched_count;
+	sum += cpu_pda(cpu)->irq_call_count;
+	sum += cpu_pda(cpu)->irq_tlb_count;
+#endif
+#ifdef CONFIG_X86_MCE
+	sum += cpu_pda(cpu)->irq_thermal_count;
+	sum += cpu_pda(cpu)->irq_threshold_count;
+#endif
+	sum += cpu_pda(cpu)->irq_spurious_count;
+	return sum;
+}
+
+u64 arch_irq_stat(void)
+{
+	return atomic_read(&irq_err_count);
+}
+
+/*
  * do_IRQ handles all normal device IRQ's (the special
  * SMP cross-CPU interrupts have their own specific
  * handlers).
--- linux-2.6.25/fs/proc/proc_misc.c	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-arch-irq-stat/fs/proc/proc_misc.c	2008-04-17 14:49:18.000000000 +0200
@@ -456,6 +456,13 @@ static const struct file_operations proc
 #endif
 #endif
 
+#ifndef arch_irq_stat_cpu
+#define arch_irq_stat_cpu(cpu) 0
+#endif
+#ifndef arch_irq_stat
+#define arch_irq_stat() 0
+#endif
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i;
@@ -493,7 +500,9 @@ static int show_stat(struct seq_file *p,
 			sum += temp;
 			per_irq_sum[j] += temp;
 		}
+		sum += arch_irq_stat_cpu(i);
 	}
+	sum += arch_irq_stat();
 
 	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu\n",
 		(unsigned long long)cputime64_to_clock_t(user),
--- linux-2.6.25/include/asm-x86/hardirq.h	2008-01-24 23:58:37.000000000 +0100
+++ 2.6.25-arch-irq-stat/include/asm-x86/hardirq.h	2008-04-17 15:01:11.000000000 +0200
@@ -3,3 +3,9 @@
 #else
 # include "hardirq_64.h"
 #endif
+
+extern u64 arch_irq_stat_cpu(unsigned int cpu);
+#define arch_irq_stat_cpu	arch_irq_stat_cpu
+
+extern u64 arch_irq_stat(void);
+#define arch_irq_stat		arch_irq_stat


