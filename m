Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbXFULck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbXFULck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 07:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbXFULcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 07:32:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbXFULcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 07:32:31 -0400
Message-ID: <467A61A3.7060804@redhat.com>
Date: Thu, 21 Jun 2007 13:31:47 +0200
From: Michal Schmidt <mschmidt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070529)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] irq nobody cared workaround for i386
References: <4676CF81.2000205@redhat.com> <4677D7AF.7040700@redhat.com> <467932B4.6030800@redhat.com> <467936FE.8050704@redhat.com>
In-Reply-To: <467936FE.8050704@redhat.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Michal Schmidt wrote:
>   
>> I came to the conclusion that the IO-APICs which need the fix for the
>> nobody cared bug don't have the issue ack_ioapic_quirk_irq is designed
>> to work-around. It should be safe simply to use the normal
>> ack_ioapic_irq as the .eoi method in pcix_ioapic_chip.
>> So this is the port of Steven's fix for the nobody cared bug to i386. It
>> works fine on IBM LS21 I have access to.
>>
>>     
> You want to make that "apic > 0".  Note the spacing. If it breaks
> 80 characters, then simply put it to a new line.
>   
> [...]
> ACK
>
> -- Steve
>   

OK, I fixed the spacing in both occurences.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

--- arch/i386/kernel/io_apic.c.orig	2007-06-19 08:40:05.000000000 -0400
+++ arch/i386/kernel/io_apic.c	2007-06-21 06:51:16.000000000 -0400
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
 
@@ -1336,7 +1371,8 @@ static void __init setup_IO_APIC_irqs(vo
 		if (IO_APIC_IRQ(irq)) {
 			vector = assign_irq_vector(irq);
 			entry.vector = vector;
-			ioapic_register_intr(irq, vector, IOAPIC_AUTO);
+			ioapic_register_intr(irq, vector, IOAPIC_AUTO,
+					     apic > 0);
 		
 			if (!apic && (irq < 16))
 				disable_8259A_irq(irq);
@@ -2058,6 +2094,18 @@ static struct irq_chip ioapic_chip __rea
 	.retrigger	= ioapic_retrigger_irq,
 };
 
+static struct irq_chip pcix_ioapic_chip __read_mostly = {
+	.name 		= "IO-APIC",
+	.startup 	= startup_ioapic_irq,
+	.mask	 	= pcix_mask_IO_APIC_irq,
+	.unmask	 	= pcix_unmask_IO_APIC_irq,
+	.ack 		= ack_ioapic_irq,
+	.eoi 		= ack_ioapic_irq,
+#ifdef CONFIG_SMP
+	.set_affinity 	= set_ioapic_affinity_irq,
+#endif
+	.retrigger	= ioapic_retrigger_irq,
+};
 
 static inline void init_IO_APIC_traps(void)
 {
@@ -2858,7 +2906,7 @@ int io_apic_set_pci_routing (int ioapic,
 		mp_ioapics[ioapic].mpc_apicid, pin, entry.vector, irq,
 		edge_level, active_high_low);
 
-	ioapic_register_intr(irq, entry.vector, edge_level);
+	ioapic_register_intr(irq, entry.vector, edge_level, ioapic > 0);
 
 	if (!ioapic && (irq < 16))
 		disable_8259A_irq(irq);


