Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbYHRUpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbYHRUpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYHRUpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:45:42 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:32843 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbYHRUpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iKKwf+/tVLXBrTayvqyBBOLjuZiyHvmN42fyF+rdQpy2/Tbziq78NQJdQo//1/HpS3
         Q0U94I0gDpWoaEEGBNvRkpzyTye9T9SlcmDW5mZYJE7XAJlmTZJ+nKhjr0xf/HBmDo1+
         NqCDjApsYABs70Sbyb2v4u6H9Dnz/irFqyeFo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] irq: rename irq_desc() to to_irq_desc() - fix
Date: Mon, 18 Aug 2008 13:44:48 -0700
Message-Id: <1219092290-30154-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <no>
References: <no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

some left overs.
__do_IRQ not take desc as parameter

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/alpha/kernel/irq.c               |    2 +-
 arch/arm/kernel/irq.c                 |   10 ++++------
 arch/avr32/kernel/irq.c               |    8 +++-----
 arch/cris/kernel/irq.c                |    2 +-
 arch/h8300/kernel/irq.c               |    2 +-
 arch/ia64/kernel/iosapic.c            |    2 +-
 arch/ia64/kernel/msi_ia64.c           |    2 +-
 arch/ia64/sn/kernel/irq.c             |    2 +-
 arch/ia64/sn/kernel/msi_sn.c          |    2 +-
 arch/m32r/kernel/irq.c                |    2 +-
 arch/m68knommu/kernel/irq.c           |    2 +-
 arch/parisc/kernel/irq.c              |    2 +-
 arch/powerpc/platforms/powermac/pic.c |    2 +-
 arch/um/kernel/irq.c                  |    2 +-
 arch/x86/kernel/io_apic.c             |    4 +---
 drivers/parisc/dino.c                 |    3 +--
 drivers/parisc/eisa.c                 |    4 +---
 drivers/parisc/gsc.c                  |    3 +--
 drivers/parisc/superio.c              |    4 +---
 drivers/xen/events.c                  |    2 +-
 include/linux/irq.h                   |   10 +++++-----
 kernel/irq/handle.c                   |    3 ++-
 kernel/irq/migration.c                |    4 +++-
 23 files changed, 35 insertions(+), 44 deletions(-)

Index: linux-2.6/arch/alpha/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq.c
+++ linux-2.6/arch/alpha/kernel/irq.c
@@ -156,6 +156,6 @@ handle_irq(int irq)
 	 * at IPL 0.
 	 */
 	local_irq_disable();
-	__do_IRQ(irq, &irq_desc[irq]);
+	__do_IRQ(irq);
 	irq_exit();
 }
Index: linux-2.6/arch/arm/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/irq.c
+++ linux-2.6/arch/arm/kernel/irq.c
@@ -69,24 +69,22 @@ int show_interrupts(struct seq_file *p,
 	}
 
 	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_desc(i);
-
-		spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
 		if (!action)
 			goto unlock;
 
 		seq_printf(p, "%3d: ", i);
 		for_each_present_cpu(cpu)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
-		seq_printf(p, " %10s", desc->chip->name ? : "-");
+		seq_printf(p, " %10s", irq_desc[i].chip->name ? : "-");
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
 			seq_printf(p, ", %s", action->name);
 
 		seq_putc(p, '\n');
 unlock:
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == NR_IRQS) {
 #ifdef CONFIG_ARCH_ACORN
 		show_fiq_list(p, v);
Index: linux-2.6/arch/avr32/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/avr32/kernel/irq.c
+++ linux-2.6/arch/avr32/kernel/irq.c
@@ -51,10 +51,8 @@ int show_interrupts(struct seq_file *p,
 	}
 
 	if (i < NR_IRQS) {
-		struct irq_desc *desc = irq_desc(i);
-
-		spin_lock_irqsave(&desc->lock, flags);
-		action = desc->action;
+		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		action = irq_desc[i].action;
 		if (!action)
 			goto unlock;
 
@@ -68,7 +66,7 @@ int show_interrupts(struct seq_file *p,
 
 		seq_putc(p, '\n');
 	unlock:
-		spin_unlock_irqrestore(&desc->lock, flags);
+		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	}
 
 	return 0;
Index: linux-2.6/arch/cris/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/kernel/irq.c
+++ linux-2.6/arch/cris/kernel/irq.c
@@ -99,7 +99,7 @@ asmlinkage void do_IRQ(int irq, struct p
 		printk("do_IRQ: stack overflow: %lX\n", sp);
 		show_stack(NULL, (unsigned long *)sp);
 	}
-	__do_IRQ(irq, &irq_desc[irq]);
+	__do_IRQ(irq);
         irq_exit();
 	set_irq_regs(old_regs);
 }
Index: linux-2.6/arch/h8300/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/irq.c
+++ linux-2.6/arch/h8300/kernel/irq.c
@@ -176,7 +176,7 @@ void __init init_IRQ(void)
 asmlinkage void do_IRQ(int irq)
 {
 	irq_enter();
-	__do_IRQ(irq, &irq_desc[irq]);
+	__do_IRQ(irq);
 	irq_exit();
 }
 
Index: linux-2.6/arch/ia64/kernel/iosapic.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/iosapic.c
+++ linux-2.6/arch/ia64/kernel/iosapic.c
@@ -452,7 +452,7 @@ iosapic_ack_edge_irq (unsigned int irq)
 	irq_desc_t *idesc = irq_desc + irq;
 
 	irq_complete_move(irq);
-	move_native_irq(irq, idesc);
+	move_native_irq(irq);
 	/*
 	 * Once we have recorded IRQ_PENDING already, we can mask the
 	 * interrupt for real. This prevents IRQ storms from unhandled
Index: linux-2.6/arch/ia64/kernel/msi_ia64.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/msi_ia64.c
+++ linux-2.6/arch/ia64/kernel/msi_ia64.c
@@ -120,7 +120,7 @@ void ia64_teardown_msi_irq(unsigned int
 static void ia64_ack_msi_irq(unsigned int irq)
 {
 	irq_complete_move(irq);
-	move_native_irq(irq, &irq_desc[irq]);
+	move_native_irq(irq);
 	ia64_eoi();
 }
 
Index: linux-2.6/arch/ia64/sn/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/irq.c
+++ linux-2.6/arch/ia64/sn/kernel/irq.c
@@ -110,7 +110,7 @@ static void sn_ack_irq(unsigned int irq)
 	HUB_S((u64*)LOCAL_MMR_ADDR(SH_EVENT_OCCURRED_ALIAS), mask);
 	__set_bit(irq, (volatile void *)pda->sn_in_service_ivecs);
 
-	move_native_irq(irq, &irq_desc[irq]);
+	move_native_irq(irq);
 }
 
 static void sn_end_irq(unsigned int irq)
Index: linux-2.6/arch/ia64/sn/kernel/msi_sn.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/msi_sn.c
+++ linux-2.6/arch/ia64/sn/kernel/msi_sn.c
@@ -210,7 +210,7 @@ static void sn_set_msi_irq_affinity(unsi
 
 static void sn_ack_msi_irq(unsigned int irq)
 {
-	move_native_irq(irq, &irq_desc[irq]);
+	move_native_irq(irq);
 	ia64_eoi();
 }
 
Index: linux-2.6/arch/m32r/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/m32r/kernel/irq.c
+++ linux-2.6/arch/m32r/kernel/irq.c
@@ -84,7 +84,7 @@ asmlinkage unsigned int do_IRQ(int irq,
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	/* FIXME M32R */
 #endif
-	__do_IRQ(irq, &irq_desc[irq]);
+	__do_IRQ(irq);
 	irq_exit();
 	set_irq_regs(old_regs);
 
Index: linux-2.6/arch/m68knommu/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/kernel/irq.c
+++ linux-2.6/arch/m68knommu/kernel/irq.c
@@ -23,7 +23,7 @@ asmlinkage void do_IRQ(int irq, struct p
 	struct pt_regs *oldregs = set_irq_regs(regs);
 
 	irq_enter();
-	__do_IRQ(irq, &irq_desc[irq]);
+	__do_IRQ(irq);
 	irq_exit();
 
 	set_irq_regs(oldregs);
Index: linux-2.6/arch/parisc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/irq.c
+++ linux-2.6/arch/parisc/kernel/irq.c
@@ -363,7 +363,7 @@ void do_cpu_irq_mask(struct pt_regs *reg
 		goto set_out;
 	}
 #endif
-	__do_IRQ(irq, irq_desc);
+	__do_IRQ(irq);
 
  out:
 	irq_exit();
Index: linux-2.6/arch/powerpc/platforms/powermac/pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/powermac/pic.c
+++ linux-2.6/arch/powerpc/platforms/powermac/pic.c
@@ -221,7 +221,7 @@ static irqreturn_t gatwick_action(int cp
 			continue;
 		irq += __ilog2(bits);
 		spin_unlock_irqrestore(&pmac_pic_lock, flags);
-		__do_IRQ(irq, &irq_desc[irq]);
+		__do_IRQ(irq);
 		spin_lock_irqsave(&pmac_pic_lock, flags);
 		rc = IRQ_HANDLED;
 	}
Index: linux-2.6/arch/um/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/irq.c
+++ linux-2.6/arch/um/kernel/irq.c
@@ -332,7 +332,7 @@ unsigned int do_IRQ(int irq, struct uml_
 {
 	struct pt_regs *old_regs = set_irq_regs((struct pt_regs *)regs);
 	irq_enter();
-	__do_IRQ(irq, &irq_desc[irq]);
+	__do_IRQ(irq);
 	irq_exit();
 	set_irq_regs(old_regs);
 	return 1;
Index: linux-2.6/drivers/parisc/dino.c
===================================================================
--- linux-2.6.orig/drivers/parisc/dino.c
+++ linux-2.6/drivers/parisc/dino.c
@@ -389,10 +389,9 @@ ilr_again:
 	do {
 		int local_irq = __ffs(mask);
 		int irq = dino_dev->global_irq[local_irq];
-		struct irq_desc *desc = to_irq_desc(irq);
 		DBG(KERN_DEBUG "%s(%d, %p) mask 0x%x\n",
 			__func__, irq, intr_dev, mask);
-		__do_IRQ(irq, desc);
+		__do_IRQ(irq);
 		mask &= ~(1 << local_irq);
 	} while (mask);
 
Index: linux-2.6/drivers/parisc/eisa.c
===================================================================
--- linux-2.6.orig/drivers/parisc/eisa.c
+++ linux-2.6/drivers/parisc/eisa.c
@@ -202,7 +202,6 @@ static irqreturn_t eisa_irq(int wax_irq,
 {
 	int irq = gsc_readb(0xfc01f000); /* EISA supports 16 irqs */
 	unsigned long flags;
-	struct irq_desc *desc;
         
 	spin_lock_irqsave(&eisa_irq_lock, flags);
 	/* read IRR command */
@@ -234,8 +233,7 @@ static irqreturn_t eisa_irq(int wax_irq,
 	}
 	spin_unlock_irqrestore(&eisa_irq_lock, flags);
 
-	desc = to_irq_desc(irq);
-	__do_IRQ(irq, desc);
+	__do_IRQ(irq);
    
 	spin_lock_irqsave(&eisa_irq_lock, flags);
 	/* unmask */
Index: linux-2.6/drivers/parisc/gsc.c
===================================================================
--- linux-2.6.orig/drivers/parisc/gsc.c
+++ linux-2.6/drivers/parisc/gsc.c
@@ -87,8 +87,7 @@ irqreturn_t gsc_asic_intr(int gsc_asic_i
 	do {
 		int local_irq = __ffs(irr);
 		unsigned int irq = gsc_asic->global_irq[local_irq];
-		struct irq_desc *desc = to_irq_desc(irq);
-		__do_IRQ(irq, desc);
+		__do_IRQ(irq);
 		irr &= ~(1 << local_irq);
 	} while (irr);
 
Index: linux-2.6/drivers/parisc/superio.c
===================================================================
--- linux-2.6.orig/drivers/parisc/superio.c
+++ linux-2.6/drivers/parisc/superio.c
@@ -99,7 +99,6 @@ superio_interrupt(int parent_irq, void *
 {
 	u8 results;
 	u8 local_irq;
-	struct irq_desc *desc;
 
 	/* Poll the 8259 to see if there's an interrupt. */
 	outb (OCW3_POLL,IC_PIC1+0);
@@ -140,8 +139,7 @@ superio_interrupt(int parent_irq, void *
 	}
 
 	/* Call the appropriate device's interrupt */
-	desc = to_irq_desc(local_irq);
-	__do_IRQ(local_irq, desc);
+	__do_IRQ(local_irq);
 
 	/* set EOI - forces a new interrupt if a lower priority device
 	 * still needs service.
Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c
+++ linux-2.6/drivers/xen/events.c
@@ -640,7 +640,7 @@ static void ack_dynirq(unsigned int irq)
 {
 	int evtchn = evtchn_from_irq(irq);
 
-	move_native_irq(irq, to_irq_desc(irq));
+	move_native_irq(irq);
 
 	if (VALID_EVTCHN(evtchn))
 		clear_evtchn(evtchn);
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -244,7 +244,7 @@ extern int setup_irq(unsigned int irq, s
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 
 void set_pending_irq(unsigned int irq, cpumask_t mask);
-void move_native_irq(int irq, struct irq_desc *desc);
+void move_native_irq(int irq);
 void move_masked_irq(int irq, struct irq_desc *desc);
 
 #else /* CONFIG_GENERIC_PENDING_IRQ */
@@ -253,7 +253,7 @@ static inline void move_irq(int irq)
 {
 }
 
-static inline void move_native_irq(int irq, struct irq_desc *desc)
+static inline void move_native_irq(int irq)
 {
 }
 
@@ -269,7 +269,7 @@ static inline void set_pending_irq(unsig
 
 #else /* CONFIG_SMP */
 
-#define move_native_irq(x, y)
+#define move_native_irq(x)
 #define move_masked_irq(x, y)
 
 #endif /* CONFIG_SMP */
@@ -302,7 +302,7 @@ extern void handle_bad_irq(unsigned int
  * Monolithic do_IRQ implementation.
  */
 #ifndef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
-extern unsigned int __do_IRQ(unsigned int irq, struct irq_desc *desc);
+extern unsigned int __do_IRQ(unsigned int irq);
 #endif
 
 /*
@@ -319,7 +319,7 @@ static inline void generic_handle_irq_de
 	if (likely(desc->handle_irq))
 		desc->handle_irq(irq, desc);
 	else
-		__do_IRQ(irq, desc);
+		__do_IRQ(irq);
 #endif
 }
 
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -385,10 +385,11 @@ irqreturn_t handle_IRQ_event(unsigned in
  * This is the original x86 implementation which is used for every
  * interrupt type.
  */
-unsigned int __do_IRQ(unsigned int irq, struct irq_desc *desc)
+unsigned int __do_IRQ(unsigned int irq)
 {
 	struct irqaction *action;
 	unsigned int status;
+	struct irq_desc *desc = to_irq_desc(irq);
 
 	kstat_irqs_this_cpu(desc)++;
 	if (CHECK_IRQ_PER_CPU(desc->status)) {
Index: linux-2.6/kernel/irq/migration.c
===================================================================
--- linux-2.6.orig/kernel/irq/migration.c
+++ linux-2.6/kernel/irq/migration.c
@@ -57,8 +57,10 @@ void move_masked_irq(int irq, struct irq
 	cpus_clear(desc->pending_mask);
 }
 
-void move_native_irq(int irq, struct irq_desc *desc)
+void move_native_irq(int irq)
 {
+	struct irq_desc *desc = to_irq_desc(irq);
+
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
 
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -2426,10 +2426,8 @@ static void ack_x2apic_edge(unsigned int
 
 static void ack_apic_edge(unsigned int irq)
 {
-	struct irq_desc *desc = to_irq_desc(irq);
-
 	irq_complete_move(irq);
-	move_native_irq(irq, desc);
+	move_native_irq(irq);
 	ack_APIC_irq();
 }
 
