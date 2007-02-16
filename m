Return-Path: <linux-kernel-owner+w=401wt.eu-S1423258AbXBPFQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423258AbXBPFQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 00:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423251AbXBPFQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 00:16:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:48655 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423258AbXBPFQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 00:16:30 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andi Kleen <ak@suse.de>
Subject: [PATCH] i386: irq: Kill IRQ compression
Date: Fri, 16 Feb 2007 00:15:04 -0500
User-Agent: KMail/1.9.5
Cc: "Eric Biederman" <ebiederm@xmission.com>,
       Natalie Protasevich <Natalie.Protasevich@unisys.com>,
       "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702160015.04453.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This code makes simple systems complex:

ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 18 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 17
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 18
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 19

The same code was already removed from x86_64

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Natalie Protasevich <Natalie.Protasevich@UNISYS.com>
---
 arch/i386/kernel/io_apic.c |    5 ----
 arch/i386/kernel/mpparse.c |   41 ---------------------------------
 include/asm-i386/io_apic.h |    1
 3 files changed, 1 insertion(+), 46 deletions(-)

Index: linus/arch/i386/kernel/mpparse.c
===================================================================
--- linus.orig/arch/i386/kernel/mpparse.c
+++ linus/arch/i386/kernel/mpparse.c
@@ -1041,20 +1041,12 @@ void __init mp_config_acpi_legacy_irqs (
 	}
 }
 
-#define MAX_GSI_NUM	4096
-
 int mp_register_gsi(u32 gsi, int triggering, int polarity)
 {
 	int ioapic = -1;
 	int ioapic_pin = 0;
 	int idx, bit = 0;
 	static int pci_irq = 16;
-	/*
-	 * Mapping between Global System Interrups, which
-	 * represent all possible interrupts, and IRQs
-	 * assigned to actual devices.
-	 */
-	static int		gsi_to_irq[MAX_GSI_NUM];
 
 	/* Don't set up the ACPI SCI because it's already set up */
 	if (acpi_gbl_FADT.sci_interrupt == gsi)
@@ -1087,42 +1079,11 @@ int mp_register_gsi(u32 gsi, int trigger
 	if ((1<<bit) & mp_ioapic_routing[ioapic].pin_programmed[idx]) {
 		Dprintk(KERN_DEBUG "Pin %d-%d already programmed\n",
 			mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
-		return gsi_to_irq[gsi];
+		return gsi;
 	}
 
 	mp_ioapic_routing[ioapic].pin_programmed[idx] |= (1<<bit);
 
-	if (triggering == ACPI_LEVEL_SENSITIVE) {
-		/*
-		 * For PCI devices assign IRQs in order, avoiding gaps
-		 * due to unused I/O APIC pins.
-		 */
-		int irq = gsi;
-		if (gsi < MAX_GSI_NUM) {
-			/*
-			 * Retain the VIA chipset work-around (gsi > 15), but
-			 * avoid a problem where the 8254 timer (IRQ0) is setup
-			 * via an override (so it's not on pin 0 of the ioapic),
-			 * and at the same time, the pin 0 interrupt is a PCI
-			 * type.  The gsi > 15 test could cause these two pins
-			 * to be shared as IRQ0, and they are not shareable.
-			 * So test for this condition, and if necessary, avoid
-			 * the pin collision.
-			 */
-			if (gsi > 15 || (gsi == 0 && !timer_uses_ioapic_pin_0))
-				gsi = pci_irq++;
-			/*
-			 * Don't assign IRQ used by ACPI SCI
-			 */
-			if (gsi == acpi_gbl_FADT.sci_interrupt)
-				gsi = pci_irq++;
-			gsi_to_irq[irq] = gsi;
-		} else {
-			printk(KERN_ERR "GSI %u is too high\n", gsi);
-			return gsi;
-		}
-	}
-
 	io_apic_set_pci_routing(ioapic, ioapic_pin, gsi,
 		    triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
 		    polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
Index: linus/arch/i386/kernel/io_apic.c
===================================================================
--- linus.orig/arch/i386/kernel/io_apic.c
+++ linus/arch/i386/kernel/io_apic.c
@@ -2212,8 +2212,6 @@ static inline void unlock_ExtINT_logic(v
 	ioapic_write_entry(apic, pin, entry0);
 }
 
-int timer_uses_ioapic_pin_0;
-
 /*
  * This code may look a bit paranoid, but it's supposed to cooperate with
  * a wide range of boards and BIOS bugs.  Fortunately only the timer IRQ
@@ -2250,9 +2248,6 @@ static inline void __init check_timer(vo
 	pin2  = ioapic_i8259.pin;
 	apic2 = ioapic_i8259.apic;
 
-	if (pin1 == 0)
-		timer_uses_ioapic_pin_0 = 1;
-
 	printk(KERN_INFO "..TIMER: vector=0x%02X apic1=%d pin1=%d apic2=%d pin2=%d\n",
 		vector, apic1, pin1, apic2, pin2);
 
Index: linus/include/asm-i386/io_apic.h
===================================================================
--- linus.orig/include/asm-i386/io_apic.h
+++ linus/include/asm-i386/io_apic.h
@@ -142,7 +142,6 @@ extern int io_apic_get_unique_id (int io
 extern int io_apic_get_version (int ioapic);
 extern int io_apic_get_redir_entries (int ioapic);
 extern int io_apic_set_pci_routing (int ioapic, int pin, int irq, int edge_level, int active_high_low);
-extern int timer_uses_ioapic_pin_0;
 #endif /* CONFIG_ACPI */
 
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
