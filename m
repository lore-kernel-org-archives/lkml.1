Return-Path: <linux-kernel-owner+w=401wt.eu-S1764991AbZARQnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764991AbZARQnG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932515AbZARQjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:39:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:37543 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763182AbZARQjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:39:43 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/12] x86-64: Move irq stats from PDA to per-cpu and consolidate with 32-bit.
Date: Mon, 19 Jan 2009 01:39:08 +0900
Message-Id: <1232296759-2253-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232296759-2253-1-git-send-email-tj@kernel.org>
References: <1232296759-2253-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 16:39:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/hardirq_64.h |   24 +++++++++++++++++++-----
 arch/x86/include/asm/pda.h        |   10 ----------
 arch/x86/kernel/irq.c             |    6 +-----
 arch/x86/kernel/irq_64.c          |    3 +++
 arch/x86/kernel/nmi.c             |   10 +---------
 arch/x86/xen/smp.c                |   18 +++---------------
 6 files changed, 27 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/hardirq_64.h b/arch/x86/include/asm/hardirq_64.h
index b5a6b5d..a65bab2 100644
--- a/arch/x86/include/asm/hardirq_64.h
+++ b/arch/x86/include/asm/hardirq_64.h
@@ -3,22 +3,36 @@
 
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
 
-#define inc_irq_stat(member)	add_pda(member, 1)
+#define inc_irq_stat(member)	percpu_add(irq_stat.member, 1)
 
-#define local_softirq_pending() read_pda(__softirq_pending)
+#define local_softirq_pending() percpu_read(irq_stat.__softirq_pending)
 
 #define __ARCH_SET_SOFTIRQ_PENDING 1
 
-#define set_softirq_pending(x) write_pda(__softirq_pending, (x))
-#define or_softirq_pending(x)  or_pda(__softirq_pending, (x))
+#define set_softirq_pending(x) percpu_write(irq_stat.__softirq_pending, (x))
+#define or_softirq_pending(x)  percpu_or(irq_stat.__softirq_pending, (x))
 
 extern void ack_bad_irq(unsigned int irq);
 
diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 47f274f..69a4075 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -25,19 +25,9 @@ struct x8664_pda {
 	char *irqstackptr;
 	short nodenumber;		/* number of current node (32k max) */
 	short in_bootmem;		/* pda lives in bootmem */
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
 
 DECLARE_PER_CPU(struct x8664_pda, __pda);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3973e2d..8b30d0c 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -36,11 +36,7 @@ void ack_bad_irq(unsigned int irq)
 #endif
 }
 
-#ifdef CONFIG_X86_32
-# define irq_stats(x)		(&per_cpu(irq_stat, x))
-#else
-# define irq_stats(x)		cpu_pda(x)
-#endif
+#define irq_stats(x)		(&per_cpu(irq_stat, x))
 /*
  * /proc/interrupts printing:
  */
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 0b21cb1..1db0524 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -19,6 +19,9 @@
 #include <asm/io_apic.h>
 #include <asm/idle.h>
 
+DEFINE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
+EXPORT_PER_CPU_SYMBOL(irq_stat);
+
 /*
  * Probabilistic stack overflow check:
  *
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 7228979..23b6d9e 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -61,11 +61,7 @@ static int endflag __initdata;
 
 static inline unsigned int get_nmi_count(int cpu)
 {
-#ifdef CONFIG_X86_64
-	return cpu_pda(cpu)->__nmi_count;
-#else
-	return nmi_count(cpu);
-#endif
+	return per_cpu(irq_stat, cpu).__nmi_count;
 }
 
 static inline int mce_in_progress(void)
@@ -82,12 +78,8 @@ static inline int mce_in_progress(void)
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
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 3bfd6dd..9ff3b09 100644
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
+	inc_irq_stat(irq_resched_count);
 
 	return IRQ_HANDLED;
 }
@@ -435,11 +431,7 @@ static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
 {
 	irq_enter();
 	generic_smp_call_function_interrupt();
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_call_count++;
-#else
-	add_pda(irq_call_count, 1);
-#endif
+	inc_irq_stat(irq_call_count);
 	irq_exit();
 
 	return IRQ_HANDLED;
@@ -449,11 +441,7 @@ static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
 {
 	irq_enter();
 	generic_smp_call_function_single_interrupt();
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_call_count++;
-#else
-	add_pda(irq_call_count, 1);
-#endif
+	inc_irq_stat(irq_call_count);
 	irq_exit();
 
 	return IRQ_HANDLED;
-- 
1.6.0.2

