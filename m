Return-Path: <linux-kernel-owner+w=401wt.eu-S965426AbXA3Hy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426AbXA3Hy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 02:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965434AbXA3Hy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 02:54:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56053 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965426AbXA3Hy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 02:54:58 -0500
Date: Tue, 30 Jan 2007 08:53:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
Message-ID: <20070130075325.GA591@elte.hu>
References: <1170109401.29240.49.camel@localhost.localdomain> <Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org> <20070129144055.151cfe52@freekitty> <Pine.LNX.4.64.0701291501180.3611@woody.linux-foundation.org> <20070129154518.40b0b3d3@freekitty> <Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org> <20070129161626.33277eb1@freekitty> <Pine.LNX.4.64.0701291623360.3611@woody.linux-foundation.org> <20070130065457.GA23390@elte.hu> <45BEF61F.7000400@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BEF61F.7000400@garzik.org>
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


* Jeff Garzik <jeff@garzik.org> wrote:

> Ingo Molnar wrote:
> >i'm wondering, could we go with Thomas' temporary patch that disables 
> >sky2 MSI if CONFIG_PM is enabled - we could revert that after 2.6.20. 
> >It's not like MSI is a life and death feature. On IO-APIC systems 
> >vectors are abundant and in any case we share irqs just fine. The 
> >true advantage of MSI is minimal. (MSI-X has the potential to be 
> >better by being message based, but in reality it still goes through 
> >the full IRQ layer.) MSI might be useful on really, really large 
> >systems - but i really hope those really large systems dont rely on 
> >CONFIG_PM. Meanwhile Thomas' patch maximizes the amount of working 
> >hardware (it has the chance to produce working systems in 100% of the 
> >cases) - which is a few orders of magnitude more important than IRQ 
> >management micro-costs. Am i missing anything?
> 
> 
> Sharing irqs /sucks/.  I routinely have to fight a USB device dying, 
> because the ATA device is causing an interrupt storm, or vice versa. 
> /Very/ common headache.

Yeah. Admittedly, ATA is very special because it is still edge-triggered 
most of the time (for legacy reasons):

 14:     389907          0   IO-APIC-edge      ide0

so if it shares an irq with a device that has level-triggered 
assumptions, those two dont intermix very well. That's why i have the 
delayed-disable patches (see the two patches below), which will unify 
the two methods, and the irq flow handling method will be mostly a 
'performance hint' not a correctness issue. This has been in -rt for 
quite a few weeks now and it works well.

btw., it would be great if you could help us here: could you perhaps, 
from a past example, outline a specific case of such an ATA/USB IRQ 
storm and how it occured (precisely) - and what the fix was? I'd like to 
analyze a specific case to make sure the genirq layer recovers from such 
cases more gracefully. In general, i think the IRQ subsystem needs to 
become more failure-resilient and needs to become more auto-learning 
(and these two dont stand in the way of good performance). This problem 
of shared IRQs will be with us for at least another 10 years, if not 
more. (for example ISA is /still/ not dead everywhere and it was already 
legacy technology 15 years ago when Linux was started.)

	Ingo

------------------->
Subject: irq: do not mask interrupts by default
From: Ingo Molnar <mingo@elte.hu>

never mask interrupts immediately upon request. Disabling interrupts in 
high-performance codepaths is rare, and on the other hand this change 
could recover lost edges (or even other types of lost interrupts) by 
conservatively only masking interrupts after they happen. (NOTE: with 
this change the highlevel irq-disable code still soft-disables this IRQ 
line - and if such an interrupt happens then the IRQ flow handler keeps 
the IRQ masked.)

mark i8529A controllers as 'never loses an edge'.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/kernel/i8259.c   |    1 +
 arch/x86_64/kernel/i8259.c |    1 +
 kernel/irq/chip.c          |   17 ++++++++++-------
 3 files changed, 12 insertions(+), 7 deletions(-)

Index: linux/arch/i386/kernel/i8259.c
===================================================================
--- linux.orig/arch/i386/kernel/i8259.c
+++ linux/arch/i386/kernel/i8259.c
@@ -41,6 +41,7 @@ static void mask_and_ack_8259A(unsigned 
 static struct irq_chip i8259A_chip = {
 	.name		= "XT-PIC",
 	.mask		= disable_8259A_irq,
+	.disable	= disable_8259A_irq,
 	.unmask		= enable_8259A_irq,
 	.mask_ack	= mask_and_ack_8259A,
 };
Index: linux/arch/x86_64/kernel/i8259.c
===================================================================
--- linux.orig/arch/x86_64/kernel/i8259.c
+++ linux/arch/x86_64/kernel/i8259.c
@@ -103,6 +103,7 @@ static void mask_and_ack_8259A(unsigned 
 static struct irq_chip i8259A_chip = {
 	.name		= "XT-PIC",
 	.mask		= disable_8259A_irq,
+	.disable	= disable_8259A_irq,
 	.unmask		= enable_8259A_irq,
 	.mask_ack	= mask_and_ack_8259A,
 };
Index: linux/kernel/irq/chip.c
===================================================================
--- linux.orig/kernel/irq/chip.c
+++ linux/kernel/irq/chip.c
@@ -202,10 +202,6 @@ static void default_enable(unsigned int 
  */
 static void default_disable(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
-
-	if (!(desc->status & IRQ_DELAYED_DISABLE))
-		desc->chip->mask(irq);
 }
 
 /*
@@ -270,13 +266,18 @@ handle_simple_irq(unsigned int irq, stru
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
 	kstat_cpu(cpu).irqs[irq]++;
 
 	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
+	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
+		if (desc->chip->mask)
+			desc->chip->mask(irq);
+		desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
+		desc->status |= IRQ_PENDING;
 		goto out_unlock;
+	}
 
+	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING | IRQ_PENDING);
 	desc->status |= IRQ_INPROGRESS;
 	spin_unlock(&desc->lock);
 
@@ -368,11 +369,13 @@ handle_fasteoi_irq(unsigned int irq, str
 
 	/*
 	 * If its disabled or no action available
-	 * keep it masked and get out of here
+	 * then mask it and get out of here:
 	 */
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
 		desc->status |= IRQ_PENDING;
+		if (desc->chip->mask)
+			desc->chip->mask(irq);
 		goto out;
 	}

----------------------> 
Subject: genirq: remove IRQ_DISABLED
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
