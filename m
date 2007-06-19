Return-Path: <linux-kernel-owner+w=401wt.eu-S1758429AbXFSNTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429AbXFSNTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 09:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbXFSNTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 09:19:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33068 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069AbXFSNTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 09:19:15 -0400
Message-ID: <4677D7AF.7040700@redhat.com>
Date: Tue, 19 Jun 2007 15:18:39 +0200
From: Michal Schmidt <mschmidt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070529)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -rt] irq nobody cared workaround for i386
References: <4676CF81.2000205@redhat.com>
In-Reply-To: <4676CF81.2000205@redhat.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> This is the final "design" for the nobody cared bug. For all IO-APICS 
> other than the first one (the chained IO-APICS) we use the PCIX version 
> of the mask and unmask interrupt routines.  This changes the interrupt 
> from level to edge for mask and edge to level for unmask. This keeps the 
> PCI-E from thinking it's in legacy mode and assert an old fashion INT# 
> interrupt which might spread to other interrupts.
>
>   

Here's a port of the workaround to i386. I tested it successfully on IBM
LS21.
Notice I had to disable the quirk handling in ack_ioapic_quirk_irq. The
code path was triggering on LS21 and because it plays with the Interrupt
Mask bit, it produced the doubled interrupts again. I don't like it and
I need to think about a solution which would handle both quirks correctly.

Michal

--- arch/i386/kernel/io_apic.c.orig	2007-06-19 08:40:05.000000000 -0400
+++ arch/i386/kernel/io_apic.c	2007-06-19 08:58:00.000000000 -0400
@@ -261,6 +261,18 @@ static void __unmask_IO_APIC_irq (unsign
 	__modify_IO_APIC_irq(irq, 0, 0x00010000);
 }
 
+/* trigger = 0 (edge mode) */
+static void __pcix_mask_IO_APIC_irq (unsigned int irq)
+{
+	__modify_IO_APIC_irq(irq, 0, 0x00008000);
+}
+
+/* mask = 0, trigger = 1 (level mode) */
+static void __pcix_unmask_IO_APIC_irq (unsigned int irq)
+{
+	__modify_IO_APIC_irq(irq, 0x00008000, 0x00010000);
+}
+
 static void mask_IO_APIC_irq (unsigned int irq)
 {
 	unsigned long flags;
@@ -279,6 +291,24 @@ static void unmask_IO_APIC_irq (unsigned
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
+static void pcix_mask_IO_APIC_irq (unsigned int irq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	__pcix_mask_IO_APIC_irq(irq);
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+}
+
+static void pcix_unmask_IO_APIC_irq (unsigned int irq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	__pcix_unmask_IO_APIC_irq(irq);
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+}
+
 static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 {
 	struct IO_APIC_route_entry entry;
@@ -1257,22 +1287,27 @@ static int assign_irq_vector(int irq)
 
 	return vector;
 }
+
 static struct irq_chip ioapic_chip;
+static struct irq_chip pcix_ioapic_chip;
 
 #define IOAPIC_AUTO	-1
 #define IOAPIC_EDGE	0
 #define IOAPIC_LEVEL	1
 
-static void ioapic_register_intr(int irq, int vector, unsigned long trigger)
+static void ioapic_register_intr(int irq, int vector, unsigned long trigger,
+				 int pcix)
 {
+	struct irq_chip *chip = pcix ? &pcix_ioapic_chip : &ioapic_chip;
+
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
 			trigger == IOAPIC_LEVEL)
-		set_irq_chip_and_handler_name(irq, &ioapic_chip,
-					 handle_fasteoi_irq, "fasteoi");
-	else {
-		set_irq_chip_and_handler_name(irq, &ioapic_chip,
-					 handle_edge_irq, "edge");
-	}
+		set_irq_chip_and_handler_name(irq, chip, handle_fasteoi_irq,
+					      pcix ? "pcix-fasteoi" : "fasteoi");
+	else
+		set_irq_chip_and_handler_name(irq, chip, handle_edge_irq,
+					      pcix ? "pcix-edge" : "edge");
+	
 	set_intr_gate(vector, interrupt[irq]);
 }
 
@@ -1336,7 +1371,7 @@ static void __init setup_IO_APIC_irqs(vo
 		if (IO_APIC_IRQ(irq)) {
 			vector = assign_irq_vector(irq);
 			entry.vector = vector;
-			ioapic_register_intr(irq, vector, IOAPIC_AUTO);
+			ioapic_register_intr(irq, vector, IOAPIC_AUTO, apic>0);
 		
 			if (!apic && (irq < 16))
 				disable_8259A_irq(irq);
@@ -2027,6 +2062,7 @@ static void ack_ioapic_quirk_irq(unsigne
 
 	ack_APIC_irq();
 
+#if 0
 	if (!(v & (1 << (i & 0x1f)))) {
 		atomic_inc(&irq_mis_count);
 		spin_lock(&ioapic_lock);
@@ -2036,6 +2072,7 @@ static void ack_ioapic_quirk_irq(unsigne
 		__modify_IO_APIC_irq(irq, 0x00008000, 0x00010000);
 		spin_unlock(&ioapic_lock);
 	}
+#endif
 }
 
 static int ioapic_retrigger_irq(unsigned int irq)
@@ -2058,6 +2095,18 @@ static struct irq_chip ioapic_chip __rea
 	.retrigger	= ioapic_retrigger_irq,
 };
 
+static struct irq_chip pcix_ioapic_chip __read_mostly = {
+	.name 		= "IO-APIC",
+	.startup 	= startup_ioapic_irq,
+	.mask	 	= pcix_mask_IO_APIC_irq,
+	.unmask	 	= pcix_unmask_IO_APIC_irq,
+	.ack 		= ack_ioapic_irq,
+	.eoi 		= ack_ioapic_quirk_irq,
+#ifdef CONFIG_SMP
+	.set_affinity 	= set_ioapic_affinity_irq,
+#endif
+	.retrigger	= ioapic_retrigger_irq,
+};
 
 static inline void init_IO_APIC_traps(void)
 {
@@ -2858,7 +2907,7 @@ int io_apic_set_pci_routing (int ioapic,
 		mp_ioapics[ioapic].mpc_apicid, pin, entry.vector, irq,
 		edge_level, active_high_low);
 
-	ioapic_register_intr(irq, entry.vector, edge_level);
+	ioapic_register_intr(irq, entry.vector, edge_level, ioapic>0);
 
 	if (!ioapic && (irq < 16))
 		disable_8259A_irq(irq);


