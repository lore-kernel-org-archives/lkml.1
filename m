Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbZEFRLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbZEFRLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 13:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759969AbZEFRLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 13:11:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:44385 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbZEFRLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 13:11:40 -0400
Message-ID: <4A01C46E.8000501@kernel.org>
Date: Wed, 06 May 2009 10:10:06 -0700
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
Subject: [PATCH 7/7] x86/pci: update pirq_enable_irq to setup io apic routing
 -v2
References: <4A01C35C.7060207@kernel.org>
In-Reply-To: <4A01C35C.7060207@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so we could set io apic routing only when enable device irq.

also could make setup_IO_APIC_irqs and setup_ioapic_dest only handle
first ioapic...

v2: remove one one not needed style change.
    merge the patch only setup io_apic for acpi on in setup_IO_APIC_irqs

[ Impact: make mptable irq enable more like acpi is used, and numa_irq_desc could get correct node when acpi=off ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |  148 ++++++++++++++++++++---------------------
 arch/x86/pci/irq.c             |   84 ++++++++---------------
 2 files changed, 103 insertions(+), 129 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1481,9 +1481,13 @@ static void setup_IO_APIC_irq(int apic_i
 	ioapic_write_entry(apic_id, pin, entry);
 }
 
+static struct {
+	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
+} mp_ioapic_routing[MAX_IO_APICS];
+
 static void __init setup_IO_APIC_irqs(void)
 {
-	int apic_id, pin, idx, irq;
+	int apic_id = 0, pin, idx, irq;
 	int notcon = 0;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
@@ -1491,48 +1495,53 @@ static void __init setup_IO_APIC_irqs(vo
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-	for (apic_id = 0; apic_id < nr_ioapics; apic_id++) {
-		for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
+#ifdef CONFIG_ACPI
+	if (!acpi_disabled && acpi_ioapic) {
+		apic_id = mp_find_ioapic(0);
+		if (apic_id < 0)
+			apic_id = 0;
+	}
+#endif
 
-			idx = find_irq_entry(apic_id, pin, mp_INT);
-			if (idx == -1) {
-				if (!notcon) {
-					notcon = 1;
-					apic_printk(APIC_VERBOSE,
-						KERN_DEBUG " %d-%d",
-						mp_ioapics[apic_id].apicid, pin);
-				} else
-					apic_printk(APIC_VERBOSE, " %d-%d",
-						mp_ioapics[apic_id].apicid, pin);
-				continue;
-			}
-			if (notcon) {
+	for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
+		idx = find_irq_entry(apic_id, pin, mp_INT);
+		if (idx == -1) {
+			if (!notcon) {
+				notcon = 1;
 				apic_printk(APIC_VERBOSE,
-					" (apicid-pin) not connected\n");
-				notcon = 0;
-			}
+					KERN_DEBUG " %d-%d",
+					mp_ioapics[apic_id].apicid, pin);
+			} else
+				apic_printk(APIC_VERBOSE, " %d-%d",
+					mp_ioapics[apic_id].apicid, pin);
+			continue;
+		}
+		if (notcon) {
+			apic_printk(APIC_VERBOSE,
+				" (apicid-pin) not connected\n");
+			notcon = 0;
+		}
 
-			irq = pin_2_irq(idx, apic_id, pin);
+		irq = pin_2_irq(idx, apic_id, pin);
 
-			/*
-			 * Skip the timer IRQ if there's a quirk handler
-			 * installed and if it returns 1:
-			 */
-			if (apic->multi_timer_check &&
-					apic->multi_timer_check(apic_id, irq))
-				continue;
-
-			desc = irq_to_desc_alloc_node(irq, node);
-			if (!desc) {
-				printk(KERN_INFO "can not get irq_desc for %d\n", irq);
-				continue;
-			}
-			cfg = desc->chip_data;
-			add_pin_to_irq_node(cfg, node, apic_id, pin);
+		/*
+		 * Skip the timer IRQ if there's a quirk handler
+		 * installed and if it returns 1:
+		 */
+		if (apic->multi_timer_check &&
+				apic->multi_timer_check(apic_id, irq))
+			continue;
 
-			setup_IO_APIC_irq(apic_id, pin, irq, desc,
-					irq_trigger(idx), irq_polarity(idx));
+		desc = irq_to_desc_alloc_node(irq, node);
+		if (!desc) {
+			printk(KERN_INFO "can not get irq_desc for %d\n", irq);
+			continue;
 		}
+		cfg = desc->chip_data;
+		add_pin_to_irq_node(cfg, node, apic_id, pin);
+		set_bit(pin, mp_ioapic_routing[apic_id].pin_programmed);
+		setup_IO_APIC_irq(apic_id, pin, irq, desc,
+				irq_trigger(idx), irq_polarity(idx));
 	}
 
 	if (notcon)
@@ -3877,10 +3886,6 @@ static int __io_apic_set_pci_routing(str
 	return 0;
 }
 
-static struct {
-	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
-} mp_ioapic_routing[MAX_IO_APICS];
-
 int io_apic_set_pci_routing(struct device *dev, int ioapic, int pin, int irq,
 				 int triggering, int polarity)
 {
@@ -4024,51 +4029,44 @@ int acpi_get_override_irq(int bus_irq, i
 #ifdef CONFIG_SMP
 void __init setup_ioapic_dest(void)
 {
-	int pin, ioapic, irq, irq_entry;
+	int pin, ioapic = 0, irq, irq_entry;
 	struct irq_desc *desc;
-	struct irq_cfg *cfg;
 	const struct cpumask *mask;
 
 	if (skip_ioapic_setup == 1)
 		return;
 
-	for (ioapic = 0; ioapic < nr_ioapics; ioapic++) {
-		for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
-			irq_entry = find_irq_entry(ioapic, pin, mp_INT);
-			if (irq_entry == -1)
-				continue;
-			irq = pin_2_irq(irq_entry, ioapic, pin);
-
-			/* setup_IO_APIC_irqs could fail to get vector for some device
-			 * when you have too many devices, because at that time only boot
-			 * cpu is online.
-			 */
-			desc = irq_to_desc(irq);
-			cfg = desc->chip_data;
-			if (!cfg->vector) {
-				setup_IO_APIC_irq(ioapic, pin, irq, desc,
-						  irq_trigger(irq_entry),
-						  irq_polarity(irq_entry));
-				continue;
+#ifdef CONFIG_ACPI
+	if (!acpi_disabled && acpi_ioapic) {
+		ioapic = mp_find_ioapic(0);
+		if (ioapic < 0)
+			ioapic = 0;
+	}
+#endif
 
-			}
+	for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
+		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
+		if (irq_entry == -1)
+			continue;
+		irq = pin_2_irq(irq_entry, ioapic, pin);
 
-			/*
-			 * Honour affinities which have been set in early boot
-			 */
-			if (desc->status &
-			    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
-				mask = desc->affinity;
-			else
-				mask = apic->target_cpus();
+		desc = irq_to_desc(irq);
 
-			if (intr_remapping_enabled)
-				set_ir_ioapic_affinity_irq_desc(desc, mask);
-			else
-				set_ioapic_affinity_irq_desc(desc, mask);
-		}
+		/*
+		 * Honour affinities which have been set in early boot
+		 */
+		if (desc->status &
+		    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
+			mask = desc->affinity;
+		else
+			mask = apic->target_cpus();
 
+		if (intr_remapping_enabled)
+			set_ir_ioapic_affinity_irq_desc(desc, mask);
+		else
+			set_ioapic_affinity_irq_desc(desc, mask);
 	}
+
 }
 #endif
 
Index: linux-2.6/arch/x86/pci/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/irq.c
+++ linux-2.6/arch/x86/pci/irq.c
@@ -889,6 +889,9 @@ static int pcibios_lookup_irq(struct pci
 		return 0;
 	}
 
+	if (io_apic_assign_pci_irqs)
+		return 0;
+
 	/* Find IRQ routing entry */
 
 	if (!pirq_table)
@@ -1039,63 +1042,15 @@ static void __init pcibios_fixup_irqs(vo
 		pirq_penalty[dev->irq]++;
 	}
 
+	if (io_apic_assign_pci_irqs)
+		return;
+
 	dev = NULL;
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 		pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 		if (!pin)
 			continue;
 
-#ifdef CONFIG_X86_IO_APIC
-		/*
-		 * Recalculate IRQ numbers if we use the I/O APIC.
-		 */
-		if (io_apic_assign_pci_irqs) {
-			int irq;
-			int ioapic = -1, ioapic_pin = -1;
-			int triggering, polarity;
-
-			/*
-			 * interrupt pins are numbered starting from 1
-			 */
-			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
-						PCI_SLOT(dev->devfn), pin - 1,
-						&ioapic, &ioapic_pin,
-						&triggering, &polarity);
-			/*
-			 * Busses behind bridges are typically not listed in the
-			 * MP-table.  In this case we have to look up the IRQ
-			 * based on the parent bus, parent slot, and pin number.
-			 * The SMP code detects such bridged busses itself so we
-			 * should get into this branch reliably.
-			 */
-			if (irq < 0 && dev->bus->parent) {
-				/* go back to the bridge */
-				struct pci_dev *bridge = dev->bus->self;
-				int bus;
-
-				pin = pci_swizzle_interrupt_pin(dev, pin);
-				bus = bridge->bus->number;
-				irq = IO_APIC_get_PCI_irq_vector(bus,
-						PCI_SLOT(bridge->devfn),
-						pin - 1,
-						&ioapic, &ioapic_pin,
-						&triggering, &polarity);
-				if (irq >= 0)
-					dev_warn(&dev->dev,
-						"using bridge %s INT %c to "
-							"get IRQ %d\n",
-						 pci_name(bridge),
-						 'A' + pin - 1, irq);
-			}
-			if (irq >= 0) {
-				dev_info(&dev->dev,
-					"PCI->APIC IRQ transform: INT %c "
-						"-> IRQ %d\n",
-					'A' + pin - 1, irq);
-				dev->irq = irq;
-			}
-		}
-#endif
 		/*
 		 * Still no IRQ? Try to lookup one...
 		 */
@@ -1190,6 +1145,19 @@ int __init pcibios_irq_init(void)
 	pcibios_enable_irq = pirq_enable_irq;
 
 	pcibios_fixup_irqs();
+
+	if (io_apic_assign_pci_irqs && pci_routeirq) {
+		struct pci_dev *dev = NULL;
+		/*
+		 * PCI IRQ routing is set up by pci_enable_device(), but we
+		 * also do it here in case there are still broken drivers that
+		 * don't use pci_enable_device().
+		 */
+		printk(KERN_INFO "PCI: Routing PCI interrupts for all devices because \"pci=routeirq\" specified\n");
+		for_each_pci_dev(dev)
+			pirq_enable_irq(dev);
+	}
+
 	return 0;
 }
 
@@ -1220,13 +1188,17 @@ void pcibios_penalize_isa_irq(int irq, i
 static int pirq_enable_irq(struct pci_dev *dev)
 {
 	u8 pin;
-	struct pci_dev *temp_dev;
 
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
-	if (pin && !pcibios_lookup_irq(dev, 1) && !dev->irq) {
+	if (pin && !pcibios_lookup_irq(dev, 1)) {
 		char *msg = "";
 
+		if (!io_apic_assign_pci_irqs && dev->irq)
+			return 0;
+
 		if (io_apic_assign_pci_irqs) {
+#ifdef CONFIG_X86_IO_APIC
+			struct pci_dev *temp_dev;
 			int irq;
 			int ioapic = -1, ioapic_pin = -1;
 			int triggering, polarity;
@@ -1261,12 +1233,16 @@ static int pirq_enable_irq(struct pci_de
 			}
 			dev = temp_dev;
 			if (irq >= 0) {
+				io_apic_set_pci_routing(&dev->dev, ioapic,
+							ioapic_pin, irq,
+							triggering, polarity);
+				dev->irq = irq;
 				dev_info(&dev->dev, "PCI->APIC IRQ transform: "
 					 "INT %c -> IRQ %d\n", 'A' + pin - 1, irq);
-				dev->irq = irq;
 				return 0;
 			} else
 				msg = "; probably buggy MP table";
+#endif
 		} else if (pci_probe & PCI_BIOS_IRQ_SCAN)
 			msg = "";
 		else
