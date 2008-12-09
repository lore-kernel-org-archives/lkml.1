Return-Path: <linux-kernel-owner+w=401wt.eu-S1751609AbYLIDTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbYLIDTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 22:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYLIDT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 22:19:28 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:59084 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbYLIDT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 22:19:27 -0500
Message-ID: <493DE3BE.9070202@ct.jp.nec.com>
Date: Mon, 08 Dec 2008 19:19:26 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: hardirq: introduce inc_irq_stat()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Introduce inc_irq_stat() macro and unify irq_stat accounting code.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/hardirq_32.h  |    2 ++
 arch/x86/include/asm/hardirq_64.h  |    2 ++
 arch/x86/kernel/apic.c             |   13 +++----------
 arch/x86/kernel/cpu/perf_counter.c |    6 +-----
 arch/x86/kernel/smp.c              |   18 +++---------------
 arch/x86/kernel/traps.c            |    6 +-----
 6 files changed, 12 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/hardirq_32.h b/arch/x86/include/asm/hardirq_32.h
index b3e475d..7a07897 100644
--- a/arch/x86/include/asm/hardirq_32.h
+++ b/arch/x86/include/asm/hardirq_32.h
@@ -23,6 +23,8 @@ DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
 #define __ARCH_IRQ_STAT
 #define __IRQ_STAT(cpu, member) (per_cpu(irq_stat, cpu).member)
 
+#define inc_irq_stat(member)	(__get_cpu_var(irq_stat).member++)
+
 void ack_bad_irq(unsigned int irq);
 #include <linux/irq_cpustat.h>
 
diff --git a/arch/x86/include/asm/hardirq_64.h b/arch/x86/include/asm/hardirq_64.h
index 1ba381f..b5a6b5d 100644
--- a/arch/x86/include/asm/hardirq_64.h
+++ b/arch/x86/include/asm/hardirq_64.h
@@ -11,6 +11,8 @@
 
 #define __ARCH_IRQ_STAT 1
 
+#define inc_irq_stat(member)	add_pda(member, 1)
+
 #define local_softirq_pending() read_pda(__softirq_pending)
 
 #define __ARCH_SET_SOFTIRQ_PENDING 1
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 91c4257..a0f55df 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -778,11 +778,7 @@ static void local_apic_timer_interrupt(void)
 	/*
 	 * the NMI deadlock-detector uses this.
 	 */
-#ifdef CONFIG_X86_64
-	add_pda(apic_timer_irqs, 1);
-#else
-	per_cpu(irq_stat, cpu).apic_timer_irqs++;
-#endif
+	inc_irq_stat(apic_timer_irqs);
 
 	evt->event_handler(evt);
 }
@@ -1679,14 +1675,11 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
 		ack_APIC_irq();
 
-#ifdef CONFIG_X86_64
-	add_pda(irq_spurious_count, 1);
-#else
+	inc_irq_stat(irq_spurious_count);
+
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	pr_info("spurious APIC interrupt on CPU#%d, "
 		"should never happen.\n", smp_processor_id());
-	__get_cpu_var(irq_stat).irq_spurious_count++;
-#endif
 	irq_exit();
 }
 
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 615e953..dc7e7a7 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -449,11 +449,7 @@ out:
 void smp_perf_counter_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
-#ifdef CONFIG_X86_64
-	add_pda(apic_perf_irqs, 1);
-#else
-	per_cpu(irq_stat, smp_processor_id()).apic_perf_irqs++;
-#endif
+	inc_irq_stat(apic_perf_irqs);
 	apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
 	__smp_perf_counter_interrupt(regs, 0);
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 3f92b13..7e558db 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -165,11 +165,7 @@ static void native_smp_send_stop(void)
 void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_resched_count++;
-#else
-	add_pda(irq_resched_count, 1);
-#endif
+	inc_irq_stat(irq_resched_count);
 }
 
 void smp_call_function_interrupt(struct pt_regs *regs)
@@ -177,11 +173,7 @@ void smp_call_function_interrupt(struct pt_regs *regs)
 	ack_APIC_irq();
 	irq_enter();
 	generic_smp_call_function_interrupt();
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_call_count++;
-#else
-	add_pda(irq_call_count, 1);
-#endif
+	inc_irq_stat(irq_call_count);
 	irq_exit();
 }
 
@@ -190,11 +182,7 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 	ack_APIC_irq();
 	irq_enter();
 	generic_smp_call_function_single_interrupt();
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_call_count++;
-#else
-	add_pda(irq_call_count, 1);
-#endif
+	inc_irq_stat(irq_call_count);
 	irq_exit();
 }
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 47f6041..da81c6c 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -482,11 +482,7 @@ do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_enter();
 
-#ifdef CONFIG_X86_32
-	{ int cpu; cpu = smp_processor_id(); ++nmi_count(cpu); }
-#else
-	add_pda(__nmi_count, 1);
-#endif
+	inc_irq_stat(__nmi_count);
 
 	if (!ignore_nmis)
 		default_do_nmi(regs);
-- 
1.6.0.4

