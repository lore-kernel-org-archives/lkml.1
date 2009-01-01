Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbZAAAOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbZAAAOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 19:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbZAAANt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 19:13:49 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:55675 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbZAAANr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 19:13:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eZAeMxIaTI97oW1M9XOECn3ywJccvGRbhBJVEXVstyCuv1rKxbt9KBlQdIrSAI0Z8w
         DHiFND1047jhYvGgYQzOMJ+omM7LQgfJK4hL7nKNn5UJIHqKe/HwJ+O6Yw/lOKELbp9O
         6EtsS7Jxnw7lhcsaJWNmtbTRhdJpZ2URvP/80=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 3/4] x86-64: Move irq stats from PDA to per-cpu and consolidate with 32-bit.
Date: Wed, 31 Dec 2008 19:13:42 -0500
Message-Id: <1230768823-31037-4-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1230768823-31037-1-git-send-email-brgerst@gmail.com>
References: <1230768823-31037-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/hardirq_64.h         |   22 ++++++++++++++++++----
 arch/x86/include/asm/pda.h                |   10 ----------
 arch/x86/kernel/apic.c                    |    8 ++------
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c   |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    2 +-
 arch/x86/kernel/irq.c                     |    6 +-----
 arch/x86/kernel/irq_64.c                  |    3 +++
 arch/x86/kernel/nmi.c                     |   10 +---------
 arch/x86/kernel/smp.c                     |   18 +++---------------
 arch/x86/kernel/time_64.c                 |    2 +-
 arch/x86/kernel/tlb_64.c                  |    2 +-
 arch/x86/kernel/traps.c                   |    6 +-----
 arch/x86/xen/smp.c                        |   18 +++---------------
 13 files changed, 36 insertions(+), 73 deletions(-)

diff --git a/arch/x86/include/asm/hardirq_64.h b/arch/x86/include/asm/hardirq_64.h
index 1ba381f..4e003b5 100644
--- a/arch/x86/include/asm/hardirq_64.h
+++ b/arch/x86/include/asm/hardirq_64.h
@@ -3,20 +3,34 @@
 
 #include <linux/threads.h>
 #include <linux/irq.h>
-#include <asm/pda.h>
 #include <asm/apic.h>
 
+typedef struct {
+	unsigned int __softirq_pending;
+	unsigned int __nmi_count;	/* arch dependent */
+	unsigned int apic_timer_irqs;	/* arch dependent */
+	unsigned int irq0_irqs;
+	unsigned int irq_resched_count;
+	unsigned int irq_call_count;
+	unsigned int irq_tlb_count;
+	unsigned int irq_thermal_count;
+	unsigned int irq_spurious_count;
+	unsigned int irq_threshold_count;
+} ____cacheline_aligned irq_cpustat_t;
+
+DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
+
 /* We can have at most NR_VECTORS irqs routed to a cpu at a time */
 #define MAX_HARDIRQS_PER_CPU NR_VECTORS
 
 #define __ARCH_IRQ_STAT 1
 
-#define local_softirq_pending() read_pda(__softirq_pending)
+#define local_softirq_pending() x86_read_percpu(irq_stat.__softirq_pending)
 
 #define __ARCH_SET_SOFTIRQ_PENDING 1
 
-#define set_softirq_pending(x) write_pda(__softirq_pending, (x))
-#define or_softirq_pending(x)  or_pda(__softirq_pending, (x))
+#define set_softirq_pending(x) x86_write_percpu(irq_stat.__softirq_pending, (x))
+#define or_softirq_pending(x)  x86_or_percpu(irq_stat.__softirq_pending, (x))
 
 extern void ack_bad_irq(unsigned int irq);
 
diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 60e8d91..97a95fa 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -23,19 +23,9 @@ struct x8664_pda {
 #endif
 	char *irqstackptr;
 	short nodenumber;		/* number of current node (32k max) */
-	unsigned int __softirq_pending;
-	unsigned int __nmi_count;	/* number of NMI on this CPUs */
 	short mmu_state;
 	short isidle;
 	struct mm_struct *active_mm;
-	unsigned apic_timer_irqs;
-	unsigned irq0_irqs;
-	unsigned irq_resched_count;
-	unsigned irq_call_count;
-	unsigned irq_tlb_count;
-	unsigned irq_thermal_count;
-	unsigned irq_threshold_count;
-	unsigned irq_spurious_count;
 } ____cacheline_aligned_in_smp;
 
 extern void pda_init(int);
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 16f9487..088ecd6 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -783,11 +783,7 @@ static void local_apic_timer_interrupt(void)
 	/*
 	 * the NMI deadlock-detector uses this.
 	 */
-#ifdef CONFIG_X86_64
-	add_pda(apic_timer_irqs, 1);
-#else
-	per_cpu(irq_stat, cpu).apic_timer_irqs++;
-#endif
+	x86_add_percpu(irq_stat.apic_timer_irqs, 1);
 
 	evt->event_handler(evt);
 }
@@ -1696,7 +1692,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 		ack_APIC_irq();
 
 #ifdef CONFIG_X86_64
-	add_pda(irq_spurious_count, 1);
+	x86_add_percpu(irq_stat.irq_spurious_count, 1);
 #else
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	printk(KERN_INFO "spurious APIC interrupt on CPU#%d, "
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 5eb390a..e79e939 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -237,7 +237,7 @@ asmlinkage void mce_threshold_interrupt(void)
 		}
 	}
 out:
-	add_pda(irq_threshold_count, 1);
+	x86_add_percpu(irq_stat.irq_threshold_count, 1);
 	irq_exit();
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index c17eaf5..96d6ba0 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -26,7 +26,7 @@ asmlinkage void smp_thermal_interrupt(void)
 	if (therm_throt_process(msr_val & 1))
 		mce_log_therm_throt_event(smp_processor_id(), msr_val);
 
-	add_pda(irq_thermal_count, 1);
+	x86_add_percpu(irq_stat.irq_thermal_count, 1);
 	irq_exit();
 }
 
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 066e680..efeca70 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -35,11 +35,7 @@ void ack_bad_irq(unsigned int irq)
 #endif
 }
 
-#ifdef CONFIG_X86_32
-# define irq_stats(x)		(&per_cpu(irq_stat, x))
-#else
-# define irq_stats(x)		(&per_cpu(pda, x))
-#endif
+#define irq_stats(x)		(&per_cpu(irq_stat, x))
 /*
  * /proc/interrupts printing:
  */
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 60eb84e..ac54951 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -18,6 +18,9 @@
 #include <asm/idle.h>
 #include <asm/smp.h>
 
+DEFINE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
+EXPORT_PER_CPU_SYMBOL(irq_stat);
+
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 /*
  * Probabilistic stack overflow check:
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 4a5bb40..bbbaffd 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -63,11 +63,7 @@ static int endflag __initdata;
 
 static inline unsigned int get_nmi_count(int cpu)
 {
-#ifdef CONFIG_X86_64
-	return per_cpu(pda, cpu).__nmi_count;
-#else
-	return nmi_count(cpu);
-#endif
+	return per_cpu(irq_stat, cpu).__nmi_count;
 }
 
 static inline int mce_in_progress(void)
@@ -84,12 +80,8 @@ static inline int mce_in_progress(void)
  */
 static inline unsigned int get_timer_irqs(int cpu)
 {
-#ifdef CONFIG_X86_64
-	return read_pda(apic_timer_irqs) + read_pda(irq0_irqs);
-#else
 	return per_cpu(irq_stat, cpu).apic_timer_irqs +
 		per_cpu(irq_stat, cpu).irq0_irqs;
-#endif
 }
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 18f9b19..863ef11 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -178,11 +178,7 @@ static void native_smp_send_stop(void)
 void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_resched_count++;
-#else
-	add_pda(irq_resched_count, 1);
-#endif
+	x86_add_percpu(irq_stat.irq_resched_count, 1);
 }
 
 void smp_call_function_interrupt(struct pt_regs *regs)
@@ -190,11 +186,7 @@ void smp_call_function_interrupt(struct pt_regs *regs)
 	ack_APIC_irq();
 	irq_enter();
 	generic_smp_call_function_interrupt();
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_call_count++;
-#else
-	add_pda(irq_call_count, 1);
-#endif
+	x86_add_percpu(irq_stat.irq_call_count, 1);
 	irq_exit();
 }
 
@@ -203,11 +195,7 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 	ack_APIC_irq();
 	irq_enter();
 	generic_smp_call_function_single_interrupt();
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_call_count++;
-#else
-	add_pda(irq_call_count, 1);
-#endif
+	x86_add_percpu(irq_stat.irq_call_count, 1);
 	irq_exit();
 }
 
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index cb19d65..48391cf 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -51,7 +51,7 @@ EXPORT_SYMBOL(profile_pc);
 
 irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
-	add_pda(irq0_irqs, 1);
+	x86_add_percpu(irq_stat.irq0_irqs, 1);
 
 	global_clock_event->event_handler(global_clock_event);
 
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index 8f919ca..d4c9a00 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -154,7 +154,7 @@ asmlinkage void smp_invalidate_interrupt(struct pt_regs *regs)
 out:
 	ack_APIC_irq();
 	cpu_clear(cpu, f->flush_cpumask);
-	add_pda(irq_tlb_count, 1);
+	x86_add_percpu(irq_stat.irq_tlb_count, 1);
 }
 
 void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 04d242a..281a2ab 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -481,11 +481,7 @@ do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_enter();
 
-#ifdef CONFIG_X86_32
-	{ int cpu; cpu = smp_processor_id(); ++nmi_count(cpu); }
-#else
-	add_pda(__nmi_count, 1);
-#endif
+	x86_add_percpu(irq_stat.__nmi_count, 1);
 
 	if (!ignore_nmis)
 		default_do_nmi(regs);
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 17823cb..123f621 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -50,11 +50,7 @@ static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id);
  */
 static irqreturn_t xen_reschedule_interrupt(int irq, void *dev_id)
 {
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_resched_count++;
-#else
-	add_pda(irq_resched_count, 1);
-#endif
+	x86_add_percpu(irq_stat.irq_resched_count, 1);
 
 	return IRQ_HANDLED;
 }
@@ -432,11 +428,7 @@ static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
 {
 	irq_enter();
 	generic_smp_call_function_interrupt();
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_call_count++;
-#else
-	add_pda(irq_call_count, 1);
-#endif
+	x86_add_percpu(irq_stat.irq_call_count, 1);
 	irq_exit();
 
 	return IRQ_HANDLED;
@@ -446,11 +438,7 @@ static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
 {
 	irq_enter();
 	generic_smp_call_function_single_interrupt();
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_call_count++;
-#else
-	add_pda(irq_call_count, 1);
-#endif
+	x86_add_percpu(irq_stat.irq_call_count, 1);
 	irq_exit();
 
 	return IRQ_HANDLED;
-- 
1.6.1.rc1

