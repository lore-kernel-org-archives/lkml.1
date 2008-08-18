Return-Path: <linux-kernel-owner+w=401wt.eu-S1759116AbYHRUqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116AbYHRUqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbYHRUpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:45:44 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:33657 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbYHRUpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:45:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wPVCOd8UHpEIXsiXLdoXHrc8l8/oMfjgeCx4UvdiJJ6lDRNV1slOpajbecflDEQ6Xb
         n+kUFIJ0zzh6MevdmX7aA9pGVPPQ3nlnSzl6XE5vVMo0CUDFRmyv1G4ykawk1YJLz/Ga
         DRhHCBwZq7UW3vEvXvLpC/9ap/1a31hn7YmNE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] irq: rename irq_desc() to to_irq_desc() - fix #2
Date: Mon, 18 Aug 2008 13:44:49 -0700
Message-Id: <1219092290-30154-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219092290-30154-1-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1219092290-30154-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kstat_irqs related, so only CONFIG_DYN_ARRAY/SPARSE_IRQ will have kstat_irqs in irq_desc

other arch still have kstat_irqs in kstat

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/alpha/kernel/irq.c                 |    2 +-
 arch/alpha/kernel/irq_alpha.c           |    2 +-
 arch/arm/kernel/irq.c                   |    2 +-
 arch/arm/mach-ns9xxx/irq.c              |    3 ++-
 arch/avr32/kernel/irq.c                 |    4 ++--
 arch/cris/kernel/irq.c                  |    2 +-
 arch/frv/kernel/irq.c                   |    2 +-
 arch/h8300/kernel/irq.c                 |    2 +-
 arch/ia64/kernel/irq.c                  |    2 +-
 arch/ia64/kernel/irq_ia64.c             |    8 ++++----
 arch/m32r/kernel/irq.c                  |    2 +-
 arch/mips/kernel/irq.c                  |    2 +-
 arch/mips/sgi-ip22/ip22-int.c           |    2 +-
 arch/mips/sgi-ip22/ip22-time.c          |    2 +-
 arch/mips/sibyte/bcm1480/smp.c          |    2 +-
 arch/mips/sibyte/sb1250/smp.c           |    2 +-
 arch/mn10300/kernel/irq.c               |    2 +-
 arch/parisc/kernel/irq.c                |    2 +-
 arch/powerpc/kernel/irq.c               |    2 +-
 arch/powerpc/platforms/cell/interrupt.c |    2 +-
 arch/sh/kernel/irq.c                    |    2 +-
 arch/sparc64/kernel/irq.c               |    2 +-
 arch/sparc64/kernel/time.c              |    3 +--
 arch/um/kernel/irq.c                    |    2 +-
 arch/xtensa/kernel/irq.c                |    2 +-
 include/linux/irq.h                     |    5 +++++
 include/linux/kernel_stat.h             |    4 ++--
 kernel/irq/chip.c                       |   20 ++++++++++++++++++++
 kernel/irq/handle.c                     |   10 ++++++++++
 29 files changed, 67 insertions(+), 32 deletions(-)

Index: linux-2.6/arch/alpha/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq.c
+++ linux-2.6/arch/alpha/kernel/irq.c
@@ -89,7 +89,7 @@ show_interrupts(struct seq_file *p, void
 		seq_printf(p, "%10u ", kstat_irqs(irq));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(irq, j));
+			seq_printf(p, "%10u ", kstat_cpu(j).irqs[irq]);
 #endif
 		seq_printf(p, " %14s", irq_desc[irq].chip->typename);
 		seq_printf(p, "  %c%s",
Index: linux-2.6/arch/alpha/kernel/irq_alpha.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_alpha.c
+++ linux-2.6/arch/alpha/kernel/irq_alpha.c
@@ -64,7 +64,7 @@ do_entInt(unsigned long type, unsigned l
 		smp_percpu_timer_interrupt(regs);
 		cpu = smp_processor_id();
 		if (cpu != boot_cpuid) {
-			irq_desc[RTC_IRQ].kstat_irqs[cpu]++;
+		        kstat_cpu(cpu).irqs[RTC_IRQ]++;
 		} else {
 			handle_irq(RTC_IRQ);
 		}
Index: linux-2.6/arch/arm/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/irq.c
+++ linux-2.6/arch/arm/kernel/irq.c
@@ -76,7 +76,7 @@ int show_interrupts(struct seq_file *p,
 
 		seq_printf(p, "%3d: ", i);
 		for_each_present_cpu(cpu)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
+			seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
 		seq_printf(p, " %10s", irq_desc[i].chip->name ? : "-");
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
Index: linux-2.6/arch/arm/mach-ns9xxx/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ns9xxx/irq.c
+++ linux-2.6/arch/arm/mach-ns9xxx/irq.c
@@ -63,6 +63,7 @@ static struct irq_chip ns9xxx_chip = {
 #else
 static void handle_prio_irq(unsigned int irq, struct irq_desc *desc)
 {
+	unsigned int cpu = smp_processor_id();
 	struct irqaction *action;
 	irqreturn_t action_ret;
 
@@ -71,7 +72,7 @@ static void handle_prio_irq(unsigned int
 	BUG_ON(desc->status & IRQ_INPROGRESS);
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-	kstat_irqs_this_cpu(desc)++;
+	kstat_cpu(cpu).irqs[irq]++;
 
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
Index: linux-2.6/arch/avr32/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/avr32/kernel/irq.c
+++ linux-2.6/arch/avr32/kernel/irq.c
@@ -58,8 +58,8 @@ int show_interrupts(struct seq_file *p,
 
 		seq_printf(p, "%3d: ", i);
 		for_each_online_cpu(cpu)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
-		seq_printf(p, " %8s", desc->chip->name ? : "-");
+			seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
+		seq_printf(p, " %8s", irq_desc[i].chip->name ? : "-");
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
 			seq_printf(p, ", %s", action->name);
Index: linux-2.6/arch/cris/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/kernel/irq.c
+++ linux-2.6/arch/cris/kernel/irq.c
@@ -66,7 +66,7 @@ int show_interrupts(struct seq_file *p,
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
Index: linux-2.6/arch/frv/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/irq.c
+++ linux-2.6/arch/frv/kernel/irq.c
@@ -74,7 +74,7 @@ int show_interrupts(struct seq_file *p,
 		if (action) {
 			seq_printf(p, "%3d: ", i);
 			for_each_present_cpu(cpu)
-				seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
+				seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
 			seq_printf(p, " %10s", irq_desc[i].chip->name ? : "-");
 			seq_printf(p, "  %s", action->name);
 			for (action = action->next;
Index: linux-2.6/arch/h8300/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/irq.c
+++ linux-2.6/arch/h8300/kernel/irq.c
@@ -196,7 +196,7 @@ int show_interrupts(struct seq_file *p,
 		if (!action)
 			goto unlock;
 		seq_printf(p, "%3d: ",i);
-		seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+		seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 		seq_printf(p, " %14s", irq_desc[i].chip->name);
 		seq_printf(p, "-%-8s", irq_desc[i].name);
 		seq_printf(p, "  %s", action->name);
Index: linux-2.6/arch/ia64/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/irq.c
+++ linux-2.6/arch/ia64/kernel/irq.c
@@ -80,7 +80,7 @@ int show_interrupts(struct seq_file *p,
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j) {
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 		}
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->name);
Index: linux-2.6/arch/ia64/kernel/irq_ia64.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/irq_ia64.c
+++ linux-2.6/arch/ia64/kernel/irq_ia64.c
@@ -495,9 +495,9 @@ ia64_handle_irq (ia64_vector vector, str
 	while (vector != IA64_SPURIOUS_INT_VECTOR) {
 		if (unlikely(IS_LOCAL_TLB_FLUSH(vector))) {
 			smp_local_flush_tlb();
-			kstat_irqs_this_cpu(&irq_desc[vector])++;
+			kstat_this_cpu.irqs[vector]++;
 		} else if (unlikely(IS_RESCHEDULE(vector)))
-			kstat_irqs_this_cpu(&irq_desc[vector])++;
+			kstat_this_cpu.irqs[vector]++;
 		else {
 			int irq = local_vector_to_irq(vector);
 
@@ -553,9 +553,9 @@ void ia64_process_pending_intr(void)
 	while (vector != IA64_SPURIOUS_INT_VECTOR) {
 		if (unlikely(IS_LOCAL_TLB_FLUSH(vector))) {
 			smp_local_flush_tlb();
-			kstat_irqs_this_cpu(&irq_desc[vector])++;
+			kstat_this_cpu.irqs[vector]++;
 		} else if (unlikely(IS_RESCHEDULE(vector)))
-			kstat_irqs_this_cpu(&irq_desc[vector])++;
+			kstat_this_cpu.irqs[vector]++;
 		else {
 			struct pt_regs *old_regs = set_irq_regs(NULL);
 			int irq = local_vector_to_irq(vector);
Index: linux-2.6/arch/m32r/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/m32r/kernel/irq.c
+++ linux-2.6/arch/m32r/kernel/irq.c
@@ -52,7 +52,7 @@ int show_interrupts(struct seq_file *p,
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
Index: linux-2.6/arch/mips/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq.c
+++ linux-2.6/arch/mips/kernel/irq.c
@@ -108,7 +108,7 @@ int show_interrupts(struct seq_file *p,
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->name);
 		seq_printf(p, "  %s", action->name);
Index: linux-2.6/arch/mips/sgi-ip22/ip22-int.c
===================================================================
--- linux-2.6.orig/arch/mips/sgi-ip22/ip22-int.c
+++ linux-2.6/arch/mips/sgi-ip22/ip22-int.c
@@ -164,7 +164,7 @@ static void indy_buserror_irq(void)
 	int irq = SGI_BUSERR_IRQ;
 
 	irq_enter();
-	kstat_irqs_this_cpu(&irq_desc[irq])++;
+	kstat_this_cpu.irqs[irq]++;
 	ip22_be_interrupt(irq);
 	irq_exit();
 }
Index: linux-2.6/arch/mips/sgi-ip22/ip22-time.c
===================================================================
--- linux-2.6.orig/arch/mips/sgi-ip22/ip22-time.c
+++ linux-2.6/arch/mips/sgi-ip22/ip22-time.c
@@ -186,7 +186,7 @@ void indy_8254timer_irq(void)
 	char c;
 
 	irq_enter();
-	kstat_irqs_this_cpu(&irq_desc[irq])++;
+	kstat_this_cpu.irqs[irq]++;
 	printk(KERN_ALERT "Oops, got 8254 interrupt.\n");
 	ArcRead(0, &c, 1, &cnt);
 	ArcEnterInteractiveMode();
Index: linux-2.6/arch/mips/sibyte/bcm1480/smp.c
===================================================================
--- linux-2.6.orig/arch/mips/sibyte/bcm1480/smp.c
+++ linux-2.6/arch/mips/sibyte/bcm1480/smp.c
@@ -180,7 +180,7 @@ void bcm1480_mailbox_interrupt(void)
 	int cpu = smp_processor_id();
 	unsigned int action;
 
-	irq_desc[K_BCM1480_INT_MBOX_0_0].kstat_irqs[cpu]++;
+	kstat_this_cpu.irqs[K_BCM1480_INT_MBOX_0_0]++;
 	/* Load the mailbox register to figure out what we're supposed to do */
 	action = (__raw_readq(mailbox_0_regs[cpu]) >> 48) & 0xffff;
 
Index: linux-2.6/arch/mips/sibyte/sb1250/smp.c
===================================================================
--- linux-2.6.orig/arch/mips/sibyte/sb1250/smp.c
+++ linux-2.6/arch/mips/sibyte/sb1250/smp.c
@@ -168,7 +168,7 @@ void sb1250_mailbox_interrupt(void)
 	int cpu = smp_processor_id();
 	unsigned int action;
 
-	irq_desc[K_INT_MBOX_0].kstat_irqs[cpu]++;
+	kstat_this_cpu.irqs[K_INT_MBOX_0]++;
 	/* Load the mailbox register to figure out what we're supposed to do */
 	action = (____raw_readq(mailbox_regs[cpu]) >> 48) & 0xffff;
 
Index: linux-2.6/arch/mn10300/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/irq.c
+++ linux-2.6/arch/mn10300/kernel/irq.c
@@ -201,7 +201,7 @@ int show_interrupts(struct seq_file *p,
 		if (action) {
 			seq_printf(p, "%3d: ", i);
 			for_each_present_cpu(cpu)
-				seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
+				seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
 			seq_printf(p, " %14s.%u", irq_desc[i].chip->name,
 				   (GxICR(i) & GxICR_LEVEL) >>
 				   GxICR_LEVEL_SHIFT);
Index: linux-2.6/arch/parisc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/irq.c
+++ linux-2.6/arch/parisc/kernel/irq.c
@@ -183,7 +183,7 @@ int show_interrupts(struct seq_file *p,
 		seq_printf(p, "%3d: ", i);
 #ifdef CONFIG_SMP
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #else
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #endif
Index: linux-2.6/arch/powerpc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/irq.c
+++ linux-2.6/arch/powerpc/kernel/irq.c
@@ -190,7 +190,7 @@ int show_interrupts(struct seq_file *p,
 		seq_printf(p, "%3d: ", i);
 #ifdef CONFIG_SMP
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #else
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #endif /* CONFIG_SMP */
Index: linux-2.6/arch/powerpc/platforms/cell/interrupt.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/interrupt.c
+++ linux-2.6/arch/powerpc/platforms/cell/interrupt.c
@@ -254,7 +254,7 @@ static void handle_iic_irq(unsigned int
 		goto out_eoi;
 	}
 
-	kstat_irqs_this_cpu(desc)++;
+	kstat_cpu(cpu).irqs[irq]++;
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
Index: linux-2.6/arch/sh/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/irq.c
+++ linux-2.6/arch/sh/kernel/irq.c
@@ -51,7 +51,7 @@ int show_interrupts(struct seq_file *p,
 			goto unlock;
 		seq_printf(p, "%3d: ",i);
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 		seq_printf(p, " %14s", irq_desc[i].chip->name);
 		seq_printf(p, "-%-8s", irq_desc[i].name);
 		seq_printf(p, "  %s", action->name);
Index: linux-2.6/arch/sparc64/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/irq.c
+++ linux-2.6/arch/sparc64/kernel/irq.c
@@ -185,7 +185,7 @@ int show_interrupts(struct seq_file *p,
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
 		seq_printf(p, " %9s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
Index: linux-2.6/arch/sparc64/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/time.c
+++ linux-2.6/arch/sparc64/kernel/time.c
@@ -16,7 +16,6 @@
 #include <linux/param.h>
 #include <linux/string.h>
 #include <linux/mm.h>
-#include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/timex.h>
@@ -943,7 +942,7 @@ void timer_interrupt(int irq, struct pt_
 
 	irq_enter();
 
-	irq_desc[0].kstat_irqs[0]++;
+	kstat_this_cpu.irqs[0]++;
 
 	if (unlikely(!evt->event_handler)) {
 		printk(KERN_WARNING
Index: linux-2.6/arch/um/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/irq.c
+++ linux-2.6/arch/um/kernel/irq.c
@@ -42,7 +42,7 @@ int show_interrupts(struct seq_file *p,
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
Index: linux-2.6/arch/xtensa/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/xtensa/kernel/irq.c
+++ linux-2.6/arch/xtensa/kernel/irq.c
@@ -99,7 +99,7 @@ int show_interrupts(struct seq_file *p,
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
 #endif
 		seq_printf(p, " %14s", irq_desc[i].chip->typename);
 		seq_printf(p, "  %s", action->name);
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -219,8 +219,13 @@ extern struct irq_desc *irq_descX;
 
 #endif
 
+#ifdef CONFIG_HAVE_DYN_ARRAY
 #define kstat_irqs_this_cpu(DESC) \
 	((DESC)->kstat_irqs[smp_processor_id()])
+#else
+#define kstat_irqs_this_cpu(irq) \
+	kstat_this_cpu.irqs[irq]
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
-#ifndef CONFIG_GENRIC_HARDIRQS
+#ifndef CONFIG_HAVE_DYN_ARRAY
        unsigned int irqs[NR_IRQS];
 #endif
 };
@@ -41,7 +41,7 @@ DECLARE_PER_CPU(struct kernel_stat, ksta
 
 extern unsigned long long nr_context_switches(void);
 
-#ifndef CONFIG_GENERIC_HARDIRQS
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
@@ -479,7 +491,11 @@ handle_edge_irq(unsigned int irq, struct
 		goto out_unlock;
 	}
 
+#ifdef CONFIG_HAVE_DYN_ARRAY
 	kstat_irqs_this_cpu(desc)++;
+#else
+	kstat_irqs_this_cpu(irq)++;
+#endif
 
 	/* Start handling the irq */
 	desc->chip->ack(irq);
@@ -534,7 +550,11 @@ handle_percpu_irq(unsigned int irq, stru
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
 
@@ -391,7 +395,11 @@ unsigned int __do_IRQ(unsigned int irq)
 	unsigned int status;
 	struct irq_desc *desc = to_irq_desc(irq);
 
+#ifdef CONFIG_HAVE_DYN_ARRAY
 	kstat_irqs_this_cpu(desc)++;
+#else
+	kstat_irqs_this_cpu(irq)++;
+#endif
 	if (CHECK_IRQ_PER_CPU(desc->status)) {
 		irqreturn_t action_ret;
 
@@ -493,10 +501,12 @@ void early_init_irq_lock_class(void)
 }
 #endif
 
+#ifdef CONFIG_HAVE_DYN_ARRAY
 unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
 	struct irq_desc *desc = to_irq_desc(irq);
 	return desc->kstat_irqs[cpu];
 }
+#endif
 EXPORT_SYMBOL(kstat_irqs_cpu);
 
