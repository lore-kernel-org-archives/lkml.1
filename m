Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbXF2WFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbXF2WFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 18:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbXF2WFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 18:05:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44355 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754129AbXF2WFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 18:05:42 -0400
From: John Keller <jpk@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: randy.dunlap@oracle.com, akpm@linux-foundation.org, steiner@sgi.com,
       John Keller <jpk@sgi.com>
Date: Fri, 29 Jun 2007 17:05:40 -0500
Message-Id: <20070629220540.13496.17310.sendpatchset@attica.americas.sgi.com>
Subject: [PATCH] - x86_64-add-ioapic-nmi-support-fix-3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Place all the IOACPI NMI support code under CONFIG_ACPI
to clear up build errors with certain configs.

Signed-off-by: John Keller <jpk@sgi.com>
---

 arch/x86_64/kernel/io_apic.c |   77 +++++++++++++++++----------------
 1 file changed, 40 insertions(+), 37 deletions(-)


Index: linux-2.6.22-rc6/arch/x86_64/kernel/io_apic.c
===================================================================
--- linux-2.6.22-rc6.orig/arch/x86_64/kernel/io_apic.c	2007-06-29 08:56:46.000000000 -0500
+++ linux-2.6.22-rc6/arch/x86_64/kernel/io_apic.c	2007-06-29 10:28:08.109040333 -0500
@@ -76,6 +76,10 @@ struct irq_cfg irq_cfg[NR_IRQS] __read_m
 	[15] = { .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
 };
 
+#ifdef CONFIG_ACPI
+static void setup_ioapic_nmi_irq(int ioapic, int pin,
+				 struct IO_APIC_route_entry *entry);
+#endif
 static int assign_irq_vector(int irq, cpumask_t mask);
 
 #define __apicdebuginit  __init
@@ -1168,9 +1172,6 @@ void __apicdebuginit print_PIC(void)
 
 #endif  /*  0  */
 
-static void setup_ioapic_nmi_irq(int ioapic, int pin,
-				 struct IO_APIC_route_entry *entry);
-
 static void __init enable_IO_APIC(void)
 {
 	union IO_APIC_reg_01 reg_01;
@@ -1211,8 +1212,10 @@ static void __init enable_IO_APIC(void)
 				continue;
 			}
 
+#ifdef CONFIG_ACPI
 			if (entry.delivery_mode == dest_NMI)
 				setup_ioapic_nmi_irq(apic, pin, &entry);
+#endif
 		}
 	}
 
@@ -1586,40 +1589,6 @@ static void setup_nmi (void)
 	printk(" done.\n");
 }
 
-#define disable_nmi_ioapic      mask_IO_APIC_irq
-#define enable_nmi_ioapic       unmask_IO_APIC_irq
-
-static struct irq_chip nmi_ioapic_chip __read_mostly = {
-	.name		= "IO-APIC NMI",
-	.enable		= enable_nmi_ioapic,
-	.disable	= disable_nmi_ioapic,
-	.mask		= mask_IO_APIC_irq,
-	.unmask		= unmask_IO_APIC_irq,
-};
-
-void __init setup_ioapic_nmi_irq(int apic, int pin,
-				 struct IO_APIC_route_entry *entry)
-{
-	int irq;
-
-	entry->dest_mode = INT_DEST_MODE;
-	entry->dest = cpu_mask_to_apicid(TARGET_CPUS);
-	ioapic_write_entry(apic, pin, *entry);
-
-	irq = mp_apic_pin_to_gsi(apic, pin);
-
-	/* Setup pin_2_irq[irq] entry */
-	add_pin_to_irq(irq, apic, pin);
-
-	irq_desc[irq].status = IRQ_NOREQUEST | IRQ_NO_BALANCING;
-	if (!entry->mask) {
-		irq_desc[irq].status &= ~IRQ_DISABLED;
-		irq_desc[irq].depth = 0;
-	}
-
-	set_irq_chip(irq, &nmi_ioapic_chip);
-}
-
 /*
  * This looks a bit hackish but it's about the only one way of sending
  * a few INTA cycles to 8259As and any associated glue logic.  ICR does
@@ -2282,6 +2251,40 @@ void __init io_apic_set_nmi_src_irq(int 
 	ioapic_write_entry(ioapic, pin, entry);
 }
 
+#define disable_nmi_ioapic      mask_IO_APIC_irq
+#define enable_nmi_ioapic       unmask_IO_APIC_irq
+
+static struct irq_chip nmi_ioapic_chip __read_mostly = {
+	.name		= "IO-APIC NMI",
+	.enable		= enable_nmi_ioapic,
+	.disable	= disable_nmi_ioapic,
+	.mask		= mask_IO_APIC_irq,
+	.unmask		= unmask_IO_APIC_irq,
+};
+
+void __init setup_ioapic_nmi_irq(int apic, int pin,
+				 struct IO_APIC_route_entry *entry)
+{
+	int irq;
+
+	entry->dest_mode = INT_DEST_MODE;
+	entry->dest = cpu_mask_to_apicid(TARGET_CPUS);
+	ioapic_write_entry(apic, pin, *entry);
+
+	irq = mp_apic_pin_to_gsi(apic, pin);
+
+	/* Setup pin_2_irq[irq] entry */
+	add_pin_to_irq(irq, apic, pin);
+
+	irq_desc[irq].status = IRQ_NOREQUEST | IRQ_NO_BALANCING;
+	if (!entry->mask) {
+		irq_desc[irq].status &= ~IRQ_DISABLED;
+		irq_desc[irq].depth = 0;
+	}
+
+	set_irq_chip(irq, &nmi_ioapic_chip);
+}
+
 #endif /* CONFIG_ACPI */
 
 
