Return-Path: <linux-kernel-owner+w=401wt.eu-S965471AbXA3Jez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965471AbXA3Jez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 04:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965474AbXA3Jez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 04:34:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46635 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965471AbXA3Jey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 04:34:54 -0500
Date: Tue, 30 Jan 2007 10:33:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] genirq: remove IRQ_DISABLED
Message-ID: <20070130093328.GB24436@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] genirq: remove IRQ_DISABLED
From: Ingo Molnar <mingo@elte.hu>

now that disable_irq() defaults to delayed-disable semantics, the 
IRQ_DISABLED flag is not needed anymore.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/kernel/irq.c                 |    3 +--
 arch/i386/kernel/io_apic.c            |    4 +---
 arch/powerpc/platforms/powermac/pic.c |    2 --
 arch/x86_64/kernel/io_apic.c          |    4 +---
 include/linux/irq.h                   |    7 +++----
 5 files changed, 6 insertions(+), 14 deletions(-)

Index: linux/arch/arm/kernel/irq.c
===================================================================
--- linux.orig/arch/arm/kernel/irq.c
+++ linux/arch/arm/kernel/irq.c
@@ -159,8 +159,7 @@ void __init init_IRQ(void)
 	int irq;
 
 	for (irq = 0; irq < NR_IRQS; irq++)
-		irq_desc[irq].status |= IRQ_NOREQUEST | IRQ_DELAYED_DISABLE |
-			IRQ_NOPROBE;
+		irq_desc[irq].status |= IRQ_NOREQUEST | IRQ_NOPROBE;
 
 #ifdef CONFIG_SMP
 	bad_irq_desc.affinity = CPU_MASK_ALL;
Index: linux/arch/i386/kernel/io_apic.c
===================================================================
--- linux.orig/arch/i386/kernel/io_apic.c
+++ linux/arch/i386/kernel/io_apic.c
@@ -1275,11 +1275,9 @@ static void ioapic_register_intr(int irq
 			trigger == IOAPIC_LEVEL)
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					 handle_fasteoi_irq, "fasteoi");
-	else {
-		irq_desc[irq].status |= IRQ_DELAYED_DISABLE;
+	else
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					 handle_edge_irq, "edge");
-	}
 	set_intr_gate(vector, interrupt[irq]);
 }
 
Index: linux/arch/powerpc/platforms/powermac/pic.c
===================================================================
--- linux.orig/arch/powerpc/platforms/powermac/pic.c
+++ linux/arch/powerpc/platforms/powermac/pic.c
@@ -305,8 +305,6 @@ static int pmac_pic_host_map(struct irq_
 	level = !!(level_mask[hw >> 5] & (1UL << (hw & 0x1f)));
 	if (level)
 		desc->status |= IRQ_LEVEL;
-	else
-		desc->status |= IRQ_DELAYED_DISABLE;
 	set_irq_chip_and_handler(virq, &pmac_pic, level ?
 				 handle_level_irq : handle_edge_irq);
 	return 0;
Index: linux/arch/x86_64/kernel/io_apic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/io_apic.c
+++ linux/arch/x86_64/kernel/io_apic.c
@@ -810,11 +810,9 @@ static void ioapic_register_intr(int irq
 			trigger == IOAPIC_LEVEL)
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					      handle_fasteoi_irq, "fasteoi");
-	else {
-		irq_desc[irq].status |= IRQ_DELAYED_DISABLE;
+	else
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					      handle_edge_irq, "edge");
-	}
 }
 static void __init setup_IO_APIC_irq(int apic, int pin, int idx, int irq)
 {
Index: linux/include/linux/irq.h
===================================================================
--- linux.orig/include/linux/irq.h
+++ linux/include/linux/irq.h
@@ -57,10 +57,9 @@ typedef	void fastcall (*irq_flow_handler
 #define IRQ_NOPROBE		0x00020000	/* IRQ is not valid for probing */
 #define IRQ_NOREQUEST		0x00040000	/* IRQ cannot be requested */
 #define IRQ_NOAUTOEN		0x00080000	/* IRQ will not be enabled on request irq */
-#define IRQ_DELAYED_DISABLE	0x00100000	/* IRQ disable (masking) happens delayed. */
-#define IRQ_WAKEUP		0x00200000	/* IRQ triggers system wakeup */
-#define IRQ_MOVE_PENDING	0x00400000	/* need to re-target IRQ destination */
-#define IRQ_NO_BALANCING	0x00800000	/* IRQ is excluded from balancing */
+#define IRQ_WAKEUP		0x00100000	/* IRQ triggers system wakeup */
+#define IRQ_MOVE_PENDING	0x00200000	/* need to re-target IRQ destination */
+#define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
