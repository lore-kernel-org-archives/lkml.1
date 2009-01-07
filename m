Return-Path: <linux-kernel-owner+w=401wt.eu-S1763763AbZAGXEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763763AbZAGXEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759022AbZAGXEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:04:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:46119 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761595AbZAGXEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:04:20 -0500
Message-ID: <496534B1.6080902@kernel.org>
Date: Wed, 07 Jan 2009 15:03:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] sparseirq: make some func to be used with genirq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: clean up

Ingo suggested to change some ifdef from SPARSE_IRQ to GENERIC_HARDIRQS
so we could some #ifdef later if all arch support genirq

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/char/random.c        |    2 +-
 drivers/pci/intr_remapping.c |    2 +-
 include/linux/irq.h          |    6 ++----
 include/linux/kernel_stat.h  |    6 +++---
 kernel/irq/handle.c          |    7 ++++---
 5 files changed, 11 insertions(+), 12 deletions(-)

Index: linux-2.6/drivers/char/random.c
===================================================================
--- linux-2.6.orig/drivers/char/random.c
+++ linux-2.6/drivers/char/random.c
@@ -558,7 +558,7 @@ struct timer_rand_state {
 	unsigned dont_count_entropy:1;
 };
 
-#ifndef CONFIG_SPARSE_IRQ
+#ifndef CONFIG_GENERIC_HARDIRQS
 
 static struct timer_rand_state *irq_timer_state[NR_IRQS];
 
Index: linux-2.6/drivers/pci/intr_remapping.c
===================================================================
--- linux-2.6.orig/drivers/pci/intr_remapping.c
+++ linux-2.6/drivers/pci/intr_remapping.c
@@ -20,7 +20,7 @@ struct irq_2_iommu {
 	u8  irte_mask;
 };
 
-#ifdef CONFIG_SPARSE_IRQ
+#ifdef CONFIG_GENERIC_HARDIRQS
 static struct irq_2_iommu *get_one_free_irq_2_iommu(int cpu)
 {
 	struct irq_2_iommu *iommu;
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -160,12 +160,10 @@ struct irq_2_iommu;
  */
 struct irq_desc {
 	unsigned int		irq;
-#ifdef CONFIG_SPARSE_IRQ
 	struct timer_rand_state *timer_rand_state;
 	unsigned int            *kstat_irqs;
-# ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_INTR_REMAP
 	struct irq_2_iommu      *irq_2_iommu;
-# endif
 #endif
 	irq_flow_handler_t	handle_irq;
 	struct irq_chip		*chip;
@@ -202,13 +200,13 @@ extern void arch_free_chip_data(struct i
 extern struct irq_desc irq_desc[NR_IRQS];
 #else /* CONFIG_SPARSE_IRQ */
 extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int cpu);
+#endif /* CONFIG_SPARSE_IRQ */
 
 #define kstat_irqs_this_cpu(DESC) \
 	((DESC)->kstat_irqs[smp_processor_id()])
 #define kstat_incr_irqs_this_cpu(irqno, DESC) \
 	((DESC)->kstat_irqs[smp_processor_id()]++)
 
-#endif /* CONFIG_SPARSE_IRQ */
 
 extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
 
Index: linux-2.6/include/linux/kernel_stat.h
===================================================================
--- linux-2.6.orig/include/linux/kernel_stat.h
+++ linux-2.6/include/linux/kernel_stat.h
@@ -28,7 +28,7 @@ struct cpu_usage_stat {
 
 struct kernel_stat {
 	struct cpu_usage_stat	cpustat;
-#ifndef CONFIG_SPARSE_IRQ
+#ifndef CONFIG_GENERIC_HARDIRQS
        unsigned int irqs[NR_IRQS];
 #endif
 };
@@ -41,7 +41,7 @@ DECLARE_PER_CPU(struct kernel_stat, ksta
 
 extern unsigned long long nr_context_switches(void);
 
-#ifndef CONFIG_SPARSE_IRQ
+#ifndef CONFIG_GENERIC_HARDIRQS
 #define kstat_irqs_this_cpu(irq) \
 	(kstat_this_cpu.irqs[irq])
 
@@ -55,7 +55,7 @@ static inline void kstat_incr_irqs_this_
 #endif
 
 
-#ifndef CONFIG_SPARSE_IRQ
+#ifndef CONFIG_GENERIC_HARDIRQS
 static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
        return kstat_cpu(cpu).irqs[irq];
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -213,6 +213,7 @@ struct irq_desc irq_desc[NR_IRQS] __cach
 	}
 };
 
+static unsigned int kstat_irqs_all[NR_IRQS][NR_CPUS];
 int __init early_irq_init(void)
 {
 	struct irq_desc *desc;
@@ -222,8 +223,10 @@ int __init early_irq_init(void)
 	desc = irq_desc;
 	count = ARRAY_SIZE(irq_desc);
 
-	for (i = 0; i < count; i++)
+	for (i = 0; i < count; i++) {
 		desc[i].irq = i;
+		desc[i].kstat_irqs = kstat_irqs_all[i];
+	}
 
 	return arch_early_irq_init();
 }
@@ -451,12 +454,10 @@ void early_init_irq_lock_class(void)
 	}
 }
 
-#ifdef CONFIG_SPARSE_IRQ
 unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	return desc ? desc->kstat_irqs[cpu] : 0;
 }
-#endif
 EXPORT_SYMBOL(kstat_irqs_cpu);
 
