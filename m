Return-Path: <linux-kernel-owner+w=401wt.eu-S937797AbXHLPpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937797AbXHLPpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934752AbXHLPoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:44:37 -0400
Received: from www.osadl.org ([213.239.205.134]:50300 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764960AbXHLPof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:44:35 -0400
Message-Id: <20070812152303.177006193@inhelltoy.tec.linutronix.de>
References: <20070812152213.551812576@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 15:46:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       "marcin.slusarz" <marcin.slusarz@gmail.com>,
       Jarek Poplawski <jarkao2@o2.pl>
Subject: [patch 3/3] genirq: mark io_apic level interrupts to avoid resend
Content-Disposition: inline;
	filename=i386-x86-64-mark-fasteio-interrupts-level-triggered.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Level type interrupts do not need to be resent. It was also found that
some chipsets get confused in case of the resend. 

Mark the ioapic level type interrupts as such to avoid the resend
functionality in the generic irq code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/i386/kernel/io_apic.c   |    7 +++++--
 arch/x86_64/kernel/io_apic.c |    7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/i386/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/io_apic.c	2007-08-11 11:09:11.000000000 +0200
+++ linux-2.6/arch/i386/kernel/io_apic.c	2007-08-11 11:09:12.000000000 +0200
@@ -1256,12 +1256,15 @@ static struct irq_chip ioapic_chip;
 static void ioapic_register_intr(int irq, int vector, unsigned long trigger)
 {
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
-			trigger == IOAPIC_LEVEL)
+	    trigger == IOAPIC_LEVEL) {
+		irq_desc[irq].status |= IRQ_LEVEL;
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					 handle_fasteoi_irq, "fasteoi");
-	else
+	} else {
+		irq_desc[irq].status &= ~IRQ_LEVEL;
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					 handle_edge_irq, "edge");
+	}
 	set_intr_gate(vector, interrupt[irq]);
 }
 
Index: linux-2.6/arch/x86_64/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/io_apic.c	2007-08-11 11:09:11.000000000 +0200
+++ linux-2.6/arch/x86_64/kernel/io_apic.c	2007-08-11 11:09:12.000000000 +0200
@@ -800,12 +800,15 @@ static struct irq_chip ioapic_chip;
 
 static void ioapic_register_intr(int irq, unsigned long trigger)
 {
-	if (trigger)
+	if (trigger) {
+		irq_desc[irq].status |= IRQ_LEVEL;
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					      handle_fasteoi_irq, "fasteoi");
-	else
+	} else {
+		irq_desc[irq].status &= ~IRQ_LEVEL;
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					      handle_edge_irq, "edge");
+	}
 }
 
 static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,

-- 

