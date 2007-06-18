Return-Path: <linux-kernel-owner+w=401wt.eu-S933240AbXFRV5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240AbXFRV5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765833AbXFRV5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:57:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54801 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932250AbXFRV5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:57:01 -0400
From: John Keller <jpk@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, steiner@sgi.com, John Keller <jpk@sgi.com>
Message-Id: <20070618215700.8097.77403.79754@attica.americas.sgi.com>
Subject: [PATCH] - Add IOAPIC NMI support on x86_64
Date: Mon, 18 Jun 2007 16:57:00 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for IOAPIC NMI interrupts on x86_64.

Changes include the following:

  - Obtain the NMI IOAPIC info via an ACPI NMI SRC structure that is
    part of the MADT, and program the IOAPIC redirection register.
    The NMI SRC struct will contain the GSI of the NMI interrupt.

  - Setup irq_desc[] and irq_2_pin[] entries for the NMI interrupt irq,
    which will be used by the generic mask/unmask routines. This will
    allow a driver to enable/disable the NMI interrupt via
    enable/disable_irq().


Signed-off-by: John Keller <jpk@sgi.com>
---

 arch/i386/kernel/acpi/boot.c |    3 -
 arch/i386/kernel/mpparse.c   |    5 ++
 arch/x86_64/kernel/io_apic.c |   78 ++++++++++++++++++++++++++++++---
 arch/x86_64/kernel/mpparse.c |   44 ++++++++++++++++++
 include/asm-i386/mpspec.h    |    1
 include/asm-x86_64/io_apic.h |    1
 include/asm-x86_64/mpspec.h  |    2
 7 files changed, 127 insertions(+), 7 deletions(-)


Index: linux-2.6/arch/x86_64/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/io_apic.c	2007-06-13 13:14:44.000000000 -0500
+++ linux-2.6/arch/x86_64/kernel/io_apic.c	2007-06-13 13:15:21.000000000 -0500
@@ -349,9 +349,12 @@ static void clear_IO_APIC_pin(unsigned i
 {
 	struct IO_APIC_route_entry entry;
 
-	/* Check delivery_mode to be sure we're not clearing an SMI pin */
+	/* Check delivery_mode to be sure we're not clearing an SMI
+	 * or NMI pin.
+	 */
 	entry = ioapic_read_entry(apic, pin);
-	if (entry.delivery_mode == dest_SMI)
+	if ((entry.delivery_mode == dest_SMI) ||
+	    (entry.delivery_mode == dest_NMI))
 		return;
 	/*
 	 * Disable it in the IO-APIC irq-routing table:
@@ -1139,10 +1142,14 @@ void __apicdebuginit print_PIC(void)
 
 #endif  /*  0  */
 
+static void setup_ioapic_nmi_irq(int ioapic, int pin,
+				 struct IO_APIC_route_entry *entry);
+
 static void __init enable_IO_APIC(void)
 {
 	union IO_APIC_reg_01 reg_01;
 	int i8259_apic, i8259_pin;
+	int found_i8259 = 0;
 	int i, apic;
 	unsigned long flags;
 
@@ -1162,7 +1169,7 @@ static void __init enable_IO_APIC(void)
 	}
 	for(apic = 0; apic < nr_ioapics; apic++) {
 		int pin;
-		/* See if any of the pins is in ExtINT mode */
+		/* See if any of the pins are in ExtINT  or NMI mode */
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
 			struct IO_APIC_route_entry entry;
 			entry = ioapic_read_entry(apic, pin);
@@ -1170,14 +1177,20 @@ static void __init enable_IO_APIC(void)
 			/* If the interrupt line is enabled and in ExtInt mode
 			 * I have found the pin where the i8259 is connected.
 			 */
-			if ((entry.mask == 0) && (entry.delivery_mode == dest_ExtINT)) {
+			if (!found_i8259 && (entry.mask == 0) &&
+			    (entry.delivery_mode == dest_ExtINT)) {
 				ioapic_i8259.apic = apic;
 				ioapic_i8259.pin  = pin;
-				goto found_i8259;
+				found_i8259 = 1;
+				continue;
+			}
+
+			if (entry.delivery_mode == dest_NMI) {
+				setup_ioapic_nmi_irq(apic, pin, &entry);
 			}
 		}
 	}
- found_i8259:
+
 	/* Look to see what if the MP table has reported the ExtINT */
 	i8259_pin  = find_isa_irq_pin(0, mp_ExtINT);
 	i8259_apic = find_isa_irq_apic(0, mp_ExtINT);
@@ -1519,6 +1532,40 @@ static void setup_nmi (void)
 	printk(" done.\n");
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
 /*
  * This looks a bit hackish but it's about the only one way of sending
  * a few INTA cycles to 8259As and any associated glue logic.  ICR does
@@ -2106,6 +2153,25 @@ int io_apic_set_pci_routing (int ioapic,
 	return 0;
 }
 
+void __init io_apic_set_nmi_src_irq(int ioapic, int pin, u16 polarity)
+{
+	struct IO_APIC_route_entry entry;
+
+	entry = ioapic_read_entry(ioapic, pin);
+
+	/*
+	 * Setup the IOAPIC redirection register for NMI
+	 * The dest_mode and dest fields are setup later, as
+	 * genapic is not yet initialized.
+	 */
+	entry.delivery_mode = dest_NMI;
+	entry.mask = 1;
+	entry.polarity = (polarity == 1) ? 0 : 1;
+	entry.trigger = 0;		/* Should always be edge for NMI */
+
+	ioapic_write_entry(ioapic, pin, entry);
+}
+
 #endif /* CONFIG_ACPI */
 
 
Index: linux-2.6/arch/x86_64/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/mpparse.c	2007-06-13 13:14:44.000000000 -0500
+++ linux-2.6/arch/x86_64/kernel/mpparse.c	2007-06-13 13:15:21.000000000 -0500
@@ -649,6 +649,18 @@ static int mp_find_ioapic(int gsi)
 	return -1;
 }
 
+int mp_apic_pin_to_gsi(int apic, int pin)
+{
+        if (apic > nr_ioapics) {
+                 printk(KERN_ERR
+			 "ERROR: Invalid I/O APIC (%d), exceeds number"
+			 " found (%d)\n", apic, nr_ioapics);
+                return -1;
+        }
+
+        return (mp_ioapic_routing[apic].gsi_start + pin);
+}
+
 void __init mp_register_ioapic(u8 id, u32 address, u32 gsi_base)
 {
 	int idx = 0;
@@ -787,6 +799,38 @@ void __init mp_config_acpi_legacy_irqs(v
 	}
 }
 
+void __init mp_config_acpi_nmi_src(u32 gsi, u16 polarity)
+{
+	int idx, bit = 0;
+	int ioapic = -1;
+	int ioapic_pin = 0;
+
+	ioapic = mp_find_ioapic(gsi);
+	if (ioapic < 0) {
+		printk(KERN_WARNING "No IOAPIC for NMI Src GSI %u\n", gsi);
+		return;
+	}
+
+	ioapic_pin = gsi - mp_ioapic_routing[ioapic].gsi_start;
+	bit = ioapic_pin % 32;
+	idx = (ioapic_pin < 32) ? 0 : (ioapic_pin / 32);
+	if (idx > 3) {
+		printk(KERN_ERR "Invalid reference to IOAPIC pin "
+			"%d-%d\n", mp_ioapic_routing[ioapic].apic_id,
+			ioapic_pin);
+		return;
+	}
+	if ((1 << bit) & mp_ioapic_routing[ioapic].pin_programmed[idx]) {
+		printk(KERN_ERR "Pin %d-%d already programmed\n",
+			mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
+		return;
+	}
+
+	mp_ioapic_routing[ioapic].pin_programmed[idx] |= (1 << bit);
+
+	io_apic_set_nmi_src_irq(ioapic, ioapic_pin, polarity);
+}
+
 int mp_register_gsi(u32 gsi, int triggering, int polarity)
 {
 	int ioapic = -1;
Index: linux-2.6/arch/i386/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/acpi/boot.c	2007-06-13 13:14:44.000000000 -0500
+++ linux-2.6/arch/i386/kernel/acpi/boot.c	2007-06-13 13:15:21.000000000 -0500
@@ -397,7 +397,8 @@ acpi_parse_nmi_src(struct acpi_subtable_
 
 	acpi_table_print_madt_entry(header);
 
-	/* TBD: Support nimsrc entries? */
+	mp_config_acpi_nmi_src(nmi_src->global_irq,
+			       nmi_src->inti_flags & ACPI_MADT_POLARITY_MASK);
 
 	return 0;
 }
Index: linux-2.6/include/asm-x86_64/io_apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/io_apic.h	2007-06-13 13:14:44.000000000 -0500
+++ linux-2.6/include/asm-x86_64/io_apic.h	2007-06-13 13:15:21.000000000 -0500
@@ -119,6 +119,7 @@ extern int skip_ioapic_setup;
 extern int io_apic_get_version (int ioapic);
 extern int io_apic_get_redir_entries (int ioapic);
 extern int io_apic_set_pci_routing (int ioapic, int pin, int irq, int, int);
+extern void io_apic_set_nmi_src_irq (int ioapic, int pin, u16 polarity);
 #endif
 
 extern int sis_apic_bug; /* dummy */ 
Index: linux-2.6/include/asm-x86_64/mpspec.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/mpspec.h	2007-06-13 13:14:44.000000000 -0500
+++ linux-2.6/include/asm-x86_64/mpspec.h	2007-06-13 13:15:21.000000000 -0500
@@ -181,9 +181,11 @@ extern void mp_register_ioapic (u8 id, u
 extern void mp_override_legacy_irq (u8 bus_irq, u8 polarity, u8 trigger, u32 gsi);
 extern void mp_config_acpi_legacy_irqs (void);
 extern int mp_register_gsi (u32 gsi, int triggering, int polarity);
+extern void mp_config_acpi_nmi_src(u32 gsi, u16 flags);
 #endif
 
 extern int using_apic_timer;
+extern int mp_apic_pin_to_gsi(int apic, int pin);
 
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
 
Index: linux-2.6/include/asm-i386/mpspec.h
===================================================================
--- linux-2.6.orig/include/asm-i386/mpspec.h	2007-06-13 13:14:44.000000000 -0500
+++ linux-2.6/include/asm-i386/mpspec.h	2007-06-13 13:15:21.000000000 -0500
@@ -31,6 +31,7 @@ extern void mp_register_ioapic (u8 id, u
 extern void mp_override_legacy_irq (u8 bus_irq, u8 polarity, u8 trigger, u32 gsi);
 extern void mp_config_acpi_legacy_irqs (void);
 extern int mp_register_gsi (u32 gsi, int edge_level, int active_high_low);
+extern void mp_config_acpi_nmi_src(u32 gsi, u16 flags);
 #endif /* CONFIG_ACPI */
 
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
Index: linux-2.6/arch/i386/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/mpparse.c	2007-06-13 13:14:44.000000000 -0500
+++ linux-2.6/arch/i386/kernel/mpparse.c	2007-06-13 13:15:21.000000000 -0500
@@ -1040,6 +1040,11 @@ void __init mp_config_acpi_legacy_irqs (
 	}
 }
 
+void __init mp_config_acpi_nmi_src(u32 gsi, u16 polarity)
+{
+	/* TBD: Support nmi src entries? */
+}
+
 #define MAX_GSI_NUM	4096
 
 int mp_register_gsi(u32 gsi, int triggering, int polarity)
