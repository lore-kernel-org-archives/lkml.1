Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbYHYTmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbYHYTmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 15:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbYHYTmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 15:42:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:21896 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbYHYTmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 15:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MmvEdF91qBbupBy8OtWEyLsW/QTVRSGB2ZPaTbQx6kdqqFQBz0v3ZXYGsqGFm4jSvx
         LJ6VsluPIIkuftyZh9E6U/Akm7brqKes2koz25MPTsour9rX8WdAbxGMgITRHH5+8nUi
         7Z3JMLwjemEecf++f7RMP6M87lm0SuC7YdG2k=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: x86: move kstat_irqs from kstat to irq_desc - fix
Date: Mon, 25 Aug 2008 12:41:19 -0700
Message-Id: <1219693279-22803-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix broken with kstat when rebasing sparse_irq

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 include/linux/irq.h         |    4 ++--
 include/linux/kernel_stat.h |   10 ++++++++--
 kernel/irq/chip.c           |   21 ++++++++++++++++++++-
 kernel/irq/handle.c         |   10 ++++++++++
 4 files changed, 40 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -161,8 +161,6 @@ struct irq_desc {
 #endif
 #ifdef CONFIG_HAVE_DYN_ARRAY
 	unsigned int            *kstat_irqs;
-#else
-	unsigned int            kstat_irqs[NR_CPUS];
 #endif
 #if defined(CONFIG_INTR_REMAP) && defined(CONFIG_HAVE_SPARSE_IRQ)
        struct irq_2_iommu      *irq_2_iommu;
@@ -219,8 +217,10 @@ extern struct irq_desc *sparse_irqs;
 
 #endif
 
+#ifdef CONFIG_HAVE_DYN_ARRAY
 #define kstat_irqs_this_cpu(DESC) \
 	((DESC)->kstat_irqs[smp_processor_id()])
+#endif
 
 /*
  * Migration helpers for obsolete names, they will go away:
Index: linux-2.6/include/linux/kernel_stat.h
===================================================================
--- linux-2.6.orig/include/linux/kernel_stat.h
+++ linux-2.6/include/linux/kernel_stat.h
@@ -28,7 +28,7 @@ struct cpu_usage_stat {
 
 struct kernel_stat {
 	struct cpu_usage_stat	cpustat;
-#ifndef CONFIG_GENERIC_HARDIRQS
+#ifndef CONFIG_HAVE_DYN_ARRAY
        unsigned int irqs[NR_IRQS];
 #endif
 };
@@ -41,7 +41,13 @@ DECLARE_PER_CPU(struct kernel_stat, ksta
 
 extern unsigned long long nr_context_switches(void);
 
-#ifndef CONFIG_GENERIC_HARDIRQS
+#ifndef CONFIG_HAVE_DYN_ARRAY
+#define kstat_irqs_this_cpu(irq) \
+	(kstat_this_cpu.irqs[irq])
+#endif
+
+
+#ifndef CONFIG_HAVE_DYN_ARRAY
 static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
        return kstat_cpu(cpu).irqs[irq];
Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -326,7 +326,11 @@ handle_simple_irq(unsigned int irq, stru
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
+#ifdef CONFIG_HAVE_DYN_ARRAY
 	kstat_irqs_this_cpu(desc)++;
+#else
+	kstat_irqs_this_cpu(irq)++;
+#endif
 
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
@@ -367,7 +371,11 @@ handle_level_irq(unsigned int irq, struc
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
+#ifdef CONFIG_HAVE_DYN_ARRAY
 	kstat_irqs_this_cpu(desc)++;
+#else
+	kstat_irqs_this_cpu(irq)++;
+#endif
 
 	/*
 	 * If its disabled or no action available
@@ -414,7 +422,11 @@ handle_fasteoi_irq(unsigned int irq, str
 		goto out;
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
+#ifdef CONFIG_HAVE_DYN_ARRAY
 	kstat_irqs_this_cpu(desc)++;
+#else
+	kstat_irqs_this_cpu(irq)++;
+#endif
 
 	/*
 	 * If its disabled or no action available
@@ -478,8 +490,11 @@ handle_edge_irq(unsigned int irq, struct
 		mask_ack_irq(desc, irq);
 		goto out_unlock;
 	}
-
+#ifdef CONFIG_HAVE_DYN_ARRAY
 	kstat_irqs_this_cpu(desc)++;
+#else
+	kstat_irqs_this_cpu(irq)++;
+#endif
 
 	/* Start handling the irq */
 	desc->chip->ack(irq);
@@ -534,7 +549,11 @@ handle_percpu_irq(unsigned int irq, stru
 {
 	irqreturn_t action_ret;
 
+#ifdef CONFIG_HAVE_DYN_ARRAY
 	kstat_irqs_this_cpu(desc)++;
+#else
+	kstat_irqs_this_cpu(irq)++;
+#endif
 
 	if (desc->chip->ack)
 		desc->chip->ack(irq);
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -34,7 +34,11 @@ void
 handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 {
 	print_irq_desc(irq, desc);
+#ifdef CONFIG_HAVE_DYN_ARRAY
 	kstat_irqs_this_cpu(desc)++;
+#else
+	kstat_irqs_this_cpu(irq)++;
+#endif
 	ack_bad_irq(irq);
 }
 
@@ -401,7 +405,11 @@ unsigned int __do_IRQ(unsigned int irq)
 	struct irqaction *action;
 	unsigned int status;
 
+#ifdef CONFIG_HAVE_DYN_ARRAY
 	kstat_irqs_this_cpu(desc)++;
+#else
+	kstat_irqs_this_cpu(irq)++;
+#endif
 	if (CHECK_IRQ_PER_CPU(desc->status)) {
 		irqreturn_t action_ret;
 
@@ -501,10 +509,12 @@ void early_init_irq_lock_class(void)
 }
 #endif
 
+#ifdef CONFIG_HAVE_DYN_ARRAY
 unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	return desc->kstat_irqs[cpu];
 }
+#endif
 EXPORT_SYMBOL(kstat_irqs_cpu);
 
