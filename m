Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbZEFRKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbZEFRKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 13:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759263AbZEFRKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 13:10:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:44309 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390AbZEFRKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 13:10:09 -0400
Message-ID: <4A01C406.2040303@kernel.org>
Date: Wed, 06 May 2009 10:08:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [PATCH 5/7] x86/pci: add 4 more return param in IO_APIC_get_PCI_irq_vector
References: <4A01C35C.7060207@kernel.org>
In-Reply-To: <4A01C35C.7060207@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so prepare those params for pcibios_irq_enable to call setup_io_apic_routing

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/hw_irq.h     |    4 +
 arch/x86/kernel/apic/io_apic.c    |  107 ++++++++++++++++++++------------------
 arch/x86/pci/irq.c                |   24 +++++++-
 drivers/pci/hotplug/ibmphp_core.c |   52 +++++++++---------
 4 files changed, 110 insertions(+), 77 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -874,54 +874,6 @@ static int __init find_isa_irq_apic(int
 	return -1;
 }
 
-/*
- * Find a specific PCI IRQ entry.
- * Not an __init, possibly needed by modules
- */
-static int pin_2_irq(int idx, int apic, int pin);
-
-int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
-{
-	int apic, i, best_guess = -1;
-
-	apic_printk(APIC_DEBUG, "querying PCI -> IRQ mapping bus:%d, slot:%d, pin:%d.\n",
-		bus, slot, pin);
-	if (test_bit(bus, mp_bus_not_pci)) {
-		apic_printk(APIC_VERBOSE, "PCI BIOS passed nonexistent PCI bus %d!\n", bus);
-		return -1;
-	}
-	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].srcbus;
-
-		for (apic = 0; apic < nr_ioapics; apic++)
-			if (mp_ioapics[apic].apicid == mp_irqs[i].dstapic ||
-			    mp_irqs[i].dstapic == MP_APIC_ALL)
-				break;
-
-		if (!test_bit(lbus, mp_bus_not_pci) &&
-		    !mp_irqs[i].irqtype &&
-		    (bus == lbus) &&
-		    (slot == ((mp_irqs[i].srcbusirq >> 2) & 0x1f))) {
-			int irq = pin_2_irq(i, apic, mp_irqs[i].dstirq);
-
-			if (!(apic || IO_APIC_IRQ(irq)))
-				continue;
-
-			if (pin == (mp_irqs[i].srcbusirq & 3))
-				return irq;
-			/*
-			 * Use the first all-but-pin matching entry as a
-			 * best-guess fuzzy result for broken mptables.
-			 */
-			if (best_guess < 0)
-				best_guess = irq;
-		}
-	}
-	return best_guess;
-}
-
-EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
-
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 /*
  * EISA Edge/Level control register, ELCR
@@ -1140,6 +1092,65 @@ static int pin_2_irq(int idx, int apic,
 	return irq;
 }
 
+/*
+ * Find a specific PCI IRQ entry.
+ * Not an __init, possibly needed by modules
+ */
+int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
+				int *ioapic, int *ioapic_pin,
+				int *trigger, int *polarity)
+{
+	int apic, i, best_guess = -1;
+
+	apic_printk(APIC_DEBUG,
+		    "querying PCI -> IRQ mapping bus:%d, slot:%d, pin:%d.\n",
+		    bus, slot, pin);
+	if (test_bit(bus, mp_bus_not_pci)) {
+		apic_printk(APIC_VERBOSE,
+			    "PCI BIOS passed nonexistent PCI bus %d!\n", bus);
+		return -1;
+	}
+	for (i = 0; i < mp_irq_entries; i++) {
+		int lbus = mp_irqs[i].srcbus;
+
+		for (apic = 0; apic < nr_ioapics; apic++)
+			if (mp_ioapics[apic].apicid == mp_irqs[i].dstapic ||
+			    mp_irqs[i].dstapic == MP_APIC_ALL)
+				break;
+
+		if (!test_bit(lbus, mp_bus_not_pci) &&
+		    !mp_irqs[i].irqtype &&
+		    (bus == lbus) &&
+		    (slot == ((mp_irqs[i].srcbusirq >> 2) & 0x1f))) {
+			int irq = pin_2_irq(i, apic, mp_irqs[i].dstirq);
+
+			if (!(apic || IO_APIC_IRQ(irq)))
+				continue;
+
+			if (pin == (mp_irqs[i].srcbusirq & 3)) {
+				*ioapic = apic;
+				*ioapic_pin = mp_irqs[i].dstirq;
+				*trigger = irq_trigger(i);
+				*polarity = irq_polarity(i);
+				return irq;
+			}
+			/*
+			 * Use the first all-but-pin matching entry as a
+			 * best-guess fuzzy result for broken mptables.
+			 */
+			if (best_guess < 0) {
+				*ioapic = apic;
+				*ioapic_pin = mp_irqs[i].dstirq;
+				*trigger = irq_trigger(i);
+				*polarity = irq_polarity(i);
+				best_guess = irq;
+			}
+		}
+	}
+	return best_guess;
+}
+EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
+
 void lock_vector_lock(void)
 {
 	/* Used to the online set of cpus does not change
Index: linux-2.6/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hw_irq.h
+++ linux-2.6/arch/x86/include/asm/hw_irq.h
@@ -66,7 +66,9 @@ extern unsigned long io_apic_irqs;
 extern void init_VISWS_APIC_irqs(void);
 extern void setup_IO_APIC(void);
 extern void disable_IO_APIC(void);
-extern int IO_APIC_get_PCI_irq_vector(int bus, int slot, int fn);
+extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin,
+					int *ioapic, int *ioapic_pin,
+					int *trigger, int *polarity);
 extern void setup_ioapic_dest(void);
 
 extern void enable_IO_APIC(void);
Index: linux-2.6/drivers/pci/hotplug/ibmphp_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/ibmphp_core.c
+++ linux-2.6/drivers/pci/hotplug/ibmphp_core.c
@@ -153,45 +153,49 @@ int ibmphp_init_devno(struct slot **cur_
 		return -1;
 	}
 	for (loop = 0; loop < len; loop++) {
-		if ((*cur_slot)->number == rtable->slots[loop].slot) {
-		if ((*cur_slot)->bus == rtable->slots[loop].bus) {
+		if ((*cur_slot)->number == rtable->slots[loop].slot &&
+		    (*cur_slot)->bus == rtable->slots[loop].bus) {
+			int ioapic = -1, ioapic_pin = -1;
+			int triggering, polarity;
+
 			(*cur_slot)->device = PCI_SLOT(rtable->slots[loop].devfn);
 			for (i = 0; i < 4; i++)
 				(*cur_slot)->irq[i] = IO_APIC_get_PCI_irq_vector((int) (*cur_slot)->bus,
-						(int) (*cur_slot)->device, i);
+						(int) (*cur_slot)->device, i.
+						&ioapic, &ioapic_pin,
+						&triggering, &polarity);
 
-				debug("(*cur_slot)->irq[0] = %x\n",
-						(*cur_slot)->irq[0]);
-				debug("(*cur_slot)->irq[1] = %x\n",
-						(*cur_slot)->irq[1]);
-				debug("(*cur_slot)->irq[2] = %x\n",
-						(*cur_slot)->irq[2]);
-				debug("(*cur_slot)->irq[3] = %x\n",
-						(*cur_slot)->irq[3]);
+			debug("(*cur_slot)->irq[0] = %x\n",
+					(*cur_slot)->irq[0]);
+			debug("(*cur_slot)->irq[1] = %x\n",
+					(*cur_slot)->irq[1]);
+			debug("(*cur_slot)->irq[2] = %x\n",
+					(*cur_slot)->irq[2]);
+			debug("(*cur_slot)->irq[3] = %x\n",
+					(*cur_slot)->irq[3]);
 
-				debug("rtable->exlusive_irqs = %x\n",
+			debug("rtable->exlusive_irqs = %x\n",
 					rtable->exclusive_irqs);
-				debug("rtable->slots[loop].irq[0].bitmap = %x\n",
+			debug("rtable->slots[loop].irq[0].bitmap = %x\n",
 					rtable->slots[loop].irq[0].bitmap);
-				debug("rtable->slots[loop].irq[1].bitmap = %x\n",
+			debug("rtable->slots[loop].irq[1].bitmap = %x\n",
 					rtable->slots[loop].irq[1].bitmap);
-				debug("rtable->slots[loop].irq[2].bitmap = %x\n",
+			debug("rtable->slots[loop].irq[2].bitmap = %x\n",
 					rtable->slots[loop].irq[2].bitmap);
-				debug("rtable->slots[loop].irq[3].bitmap = %x\n",
+			debug("rtable->slots[loop].irq[3].bitmap = %x\n",
 					rtable->slots[loop].irq[3].bitmap);
 
-				debug("rtable->slots[loop].irq[0].link = %x\n",
+			debug("rtable->slots[loop].irq[0].link = %x\n",
 					rtable->slots[loop].irq[0].link);
-				debug("rtable->slots[loop].irq[1].link = %x\n",
+			debug("rtable->slots[loop].irq[1].link = %x\n",
 					rtable->slots[loop].irq[1].link);
-				debug("rtable->slots[loop].irq[2].link = %x\n",
+			debug("rtable->slots[loop].irq[2].link = %x\n",
 					rtable->slots[loop].irq[2].link);
-				debug("rtable->slots[loop].irq[3].link = %x\n",
+			debug("rtable->slots[loop].irq[3].link = %x\n",
 					rtable->slots[loop].irq[3].link);
-				debug("end of init_devno\n");
-				kfree(rtable);
-				return 0;
-			}
+			debug("end of init_devno\n");
+			kfree(rtable);
+			return 0;
 		}
 	}
 
Index: linux-2.6/arch/x86/pci/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/irq.c
+++ linux-2.6/arch/x86/pci/irq.c
@@ -1051,12 +1051,16 @@ static void __init pcibios_fixup_irqs(vo
 		 */
 		if (io_apic_assign_pci_irqs) {
 			int irq;
+			int ioapic = -1, ioapic_pin = -1;
+			int triggering, polarity;
 
 			/*
 			 * interrupt pins are numbered starting from 1
 			 */
 			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
-				PCI_SLOT(dev->devfn), pin - 1);
+						PCI_SLOT(dev->devfn), pin - 1,
+						&ioapic, &ioapic_pin,
+						&triggering, &polarity);
 			/*
 			 * Busses behind bridges are typically not listed in the
 			 * MP-table.  In this case we have to look up the IRQ
@@ -1072,7 +1076,10 @@ static void __init pcibios_fixup_irqs(vo
 				pin = pci_swizzle_interrupt_pin(dev, pin);
 				bus = bridge->bus->number;
 				irq = IO_APIC_get_PCI_irq_vector(bus,
-						PCI_SLOT(bridge->devfn), pin - 1);
+						PCI_SLOT(bridge->devfn),
+						pin - 1,
+						&ioapic, &ioapic_pin,
+						&triggering, &polarity);
 				if (irq >= 0)
 					dev_warn(&dev->dev,
 						"using bridge %s INT %c to "
@@ -1221,8 +1228,14 @@ static int pirq_enable_irq(struct pci_de
 
 		if (io_apic_assign_pci_irqs) {
 			int irq;
+			int ioapic = -1, ioapic_pin = -1;
+			int triggering, polarity;
 
-			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number, PCI_SLOT(dev->devfn), pin - 1);
+			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
+						PCI_SLOT(dev->devfn),
+						pin - 1,
+						&ioapic, &ioapic_pin,
+						&triggering, &polarity);
 			/*
 			 * Busses behind bridges are typically not listed in the MP-table.
 			 * In this case we have to look up the IRQ based on the parent bus,
@@ -1235,7 +1248,10 @@ static int pirq_enable_irq(struct pci_de
 
 				pin = pci_swizzle_interrupt_pin(dev, pin);
 				irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number,
-						PCI_SLOT(bridge->devfn), pin - 1);
+						PCI_SLOT(bridge->devfn),
+						pin - 1,
+						&ioapic, &ioapic_pin,
+						&triggering, &polarity);
 				if (irq >= 0)
 					dev_warn(&dev->dev, "using bridge %s "
 						 "INT %c to get IRQ %d\n",
