Return-Path: <linux-kernel-owner+w=401wt.eu-S1760590AbYF0Oto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbYF0Oto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbYF0OtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:49:20 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:29690 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbYF0OtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:49:15 -0400
Message-Id: <20080627144754.035246519@ldl.fc.hp.com>
References: <20080627144538.743154341@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 08:45:44 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-acpi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 6/6] x86 PCI: use dev_printk when possible
Content-Disposition: inline; filename=x86-pci-dev_printk
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printks to use dev_printk().

I converted DBG() to dev_dbg().  This DBG() is from arch/x86/pci/pci.h
and requires source-code modification to enable, so dev_dbg() seems
roughly equivalent.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 arch/x86/pci/fixup.c |    3 +
 arch/x86/pci/i386.c  |   26 ++++++--------
 arch/x86/pci/irq.c   |   91 ++++++++++++++++++++++-----------------------------
 arch/x86/pci/numa.c  |    5 +-
 4 files changed, 57 insertions(+), 68 deletions(-)

Index: work11/arch/x86/pci/fixup.c
===================================================================
--- work11.orig/arch/x86/pci/fixup.c	2008-06-26 12:27:39.000000000 -0600
+++ work11/arch/x86/pci/fixup.c	2008-06-26 12:30:27.000000000 -0600
@@ -23,7 +23,8 @@ static void __devinit pci_fixup_i450nx(s
 		pci_read_config_byte(d, reg++, &busno);
 		pci_read_config_byte(d, reg++, &suba);
 		pci_read_config_byte(d, reg++, &subb);
-		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
+		dev_dbg(&d->dev, "i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno,
+			suba, subb);
 		if (busno)
 			pci_scan_bus_with_sysdata(busno);	/* Bus A */
 		if (suba < subb)
Index: work11/arch/x86/pci/i386.c
===================================================================
--- work11.orig/arch/x86/pci/i386.c	2008-06-26 12:27:39.000000000 -0600
+++ work11/arch/x86/pci/i386.c	2008-06-26 12:30:27.000000000 -0600
@@ -128,10 +128,8 @@ static void __init pcibios_allocate_bus_
 				pr = pci_find_parent_resource(dev, r);
 				if (!r->start || !pr ||
 				    request_resource(pr, r) < 0) {
-					printk(KERN_ERR "PCI: Cannot allocate "
-						"resource region %d "
-						"of bridge %s\n",
-						idx, pci_name(dev));
+					dev_err(&dev->dev, "BAR %d: can't "
+						"allocate resource\n", idx);
 					/*
 					 * Something is wrong with the region.
 					 * Invalidate the resource to prevent
@@ -166,15 +164,15 @@ static void __init pcibios_allocate_reso
 			else
 				disabled = !(command & PCI_COMMAND_MEMORY);
 			if (pass == disabled) {
-				DBG("PCI: Resource %08lx-%08lx "
-				    "(f=%lx, d=%d, p=%d)\n",
-				    r->start, r->end, r->flags, disabled, pass);
+				dev_dbg(&dev->dev, "resource %#08llx-%#08llx "
+					"(f=%lx, d=%d, p=%d)\n",
+					(unsigned long long) r->start,
+					(unsigned long long) r->end,
+					r->flags, disabled, pass);
 				pr = pci_find_parent_resource(dev, r);
 				if (!pr || request_resource(pr, r) < 0) {
-					printk(KERN_ERR "PCI: Cannot allocate "
-						"resource region %d "
-						"of device %s\n",
-						idx, pci_name(dev));
+					dev_err(&dev->dev, "BAR %d: can't "
+						"allocate resource\n", idx);
 					/* We'll assign a new address later */
 					r->end -= r->start;
 					r->start = 0;
@@ -187,8 +185,7 @@ static void __init pcibios_allocate_reso
 				/* Turn the ROM off, leave the resource region,
 				 * but keep it unregistered. */
 				u32 reg;
-				DBG("PCI: Switching off ROM of %s\n",
-					pci_name(dev));
+				dev_dbg(&dev->dev, "disabling ROM\n");
 				r->flags &= ~IORESOURCE_ROM_ENABLE;
 				pci_read_config_dword(dev,
 						dev->rom_base_reg, &reg);
@@ -257,8 +254,7 @@ void pcibios_set_master(struct pci_dev *
 		lat = pcibios_max_latency;
 	else
 		return;
-	printk(KERN_DEBUG "PCI: Setting latency timer of device %s to %d\n",
-		pci_name(dev), lat);
+	dev_printk(KERN_DEBUG, &dev->dev, "setting latency timer to %d\n", lat);
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
 }
 
Index: work11/arch/x86/pci/irq.c
===================================================================
--- work11.orig/arch/x86/pci/irq.c	2008-06-26 12:27:39.000000000 -0600
+++ work11/arch/x86/pci/irq.c	2008-06-26 12:35:03.000000000 -0600
@@ -433,7 +433,7 @@ static int pirq_vlsi_get(struct pci_dev 
 {
 	WARN_ON_ONCE(pirq >= 9);
 	if (pirq > 8) {
-		printk(KERN_INFO "VLSI router pirq escape (%d)\n", pirq);
+		dev_info(&dev->dev, "VLSI router PIRQ escape (%d)\n", pirq);
 		return 0;
 	}
 	return read_config_nybble(router, 0x74, pirq-1);
@@ -443,7 +443,7 @@ static int pirq_vlsi_set(struct pci_dev 
 {
 	WARN_ON_ONCE(pirq >= 9);
 	if (pirq > 8) {
-		printk(KERN_INFO "VLSI router pirq escape (%d)\n", pirq);
+		dev_info(&dev->dev, "VLSI router PIRQ escape (%d)\n", pirq);
 		return 0;
 	}
 	write_config_nybble(router, 0x74, pirq-1, irq);
@@ -487,22 +487,18 @@ static int pirq_amd756_get(struct pci_de
 	u8 irq;
 	irq = 0;
 	if (pirq <= 4)
-	{
 		irq = read_config_nybble(router, 0x56, pirq - 1);
-	}
-	printk(KERN_INFO "AMD756: dev %04x:%04x, router pirq : %d get irq : %2d\n",
-		dev->vendor, dev->device, pirq, irq);
+	dev_info(&dev->dev, "AMD756: dev [%04x/%04x], router PIRQ %d get "
+		 "IRQ %d\n", dev->vendor, dev->device, pirq, irq);
 	return irq;
 }
 
 static int pirq_amd756_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
 {
-	printk(KERN_INFO "AMD756: dev %04x:%04x, router pirq : %d SET irq : %2d\n", 
-		dev->vendor, dev->device, pirq, irq);
+	dev_info(&dev->dev, "AMD756: dev [%04x/%04x], router PIRQ %d set "
+		 "IRQ %d\n", dev->vendor, dev->device, pirq, irq);
 	if (pirq <= 4)
-	{
 		write_config_nybble(router, 0x56, pirq - 1, irq);
-	}
 	return 1;
 }
 
@@ -736,7 +732,6 @@ static __init int ali_router_probe(struc
 	{
 	case PCI_DEVICE_ID_AL_M1533:
 	case PCI_DEVICE_ID_AL_M1563:
-		printk(KERN_DEBUG "PCI: Using ALI IRQ Router\n");
 		r->name = "ALI";
 		r->get = pirq_ali_get;
 		r->set = pirq_ali_set;
@@ -845,11 +840,9 @@ static void __init pirq_find_router(stru
 		if (pirq_router_dev->vendor == h->vendor && h->probe(r, pirq_router_dev, pirq_router_dev->device))
 			break;
 	}
-	printk(KERN_INFO "PCI: Using IRQ router %s [%04x/%04x] at %s\n",
-		pirq_router.name,
-		pirq_router_dev->vendor,
-		pirq_router_dev->device,
-		pci_name(pirq_router_dev));
+	dev_info(&pirq_router_dev->dev, "%s IRQ router [%04x/%04x]\n",
+		 pirq_router.name,
+		 pirq_router_dev->vendor, pirq_router_dev->device);
 
 	/* The device remains referenced for the kernel lifetime */
 }
@@ -880,7 +873,7 @@ static int pcibios_lookup_irq(struct pci
 	/* Find IRQ pin */
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (!pin) {
-		DBG(KERN_DEBUG " -> no interrupt pin\n");
+		dev_dbg(&dev->dev, "no interrupt pin\n");
 		return 0;
 	}
 	pin = pin - 1;
@@ -889,20 +882,21 @@ static int pcibios_lookup_irq(struct pci
 
 	if (!pirq_table)
 		return 0;
-	
-	DBG(KERN_DEBUG "IRQ for %s[%c]", pci_name(dev), 'A' + pin);
+
 	info = pirq_get_info(dev);
 	if (!info) {
-		DBG(" -> not found in routing table\n" KERN_DEBUG);
+		dev_dbg(&dev->dev, "PCI INT %c not found in routing table\n",
+			'A' + pin);
 		return 0;
 	}
 	pirq = info->irq[pin].link;
 	mask = info->irq[pin].bitmap;
 	if (!pirq) {
-		DBG(" -> not routed\n" KERN_DEBUG);
+		dev_dbg(&dev->dev, "PCI INT %c not routed\n", 'A' + pin);
 		return 0;
 	}
-	DBG(" -> PIRQ %02x, mask %04x, excl %04x", pirq, mask, pirq_table->exclusive_irqs);
+	dev_dbg(&dev->dev, "PCI INT %c -> PIRQ %02x, mask %04x, excl %04x",
+		'A' + pin, pirq, mask, pirq_table->exclusive_irqs);
 	mask &= pcibios_irq_mask;
 
 	/* Work around broken HP Pavilion Notebooks which assign USB to
@@ -928,11 +922,11 @@ static int pcibios_lookup_irq(struct pci
 	 */
 	newirq = dev->irq;
 	if (newirq && !((1 << newirq) & mask)) {
-		if ( pci_probe & PCI_USE_PIRQ_MASK) newirq = 0;
-		else printk("\n" KERN_WARNING
-			"PCI: IRQ %i for device %s doesn't match PIRQ mask "
-			"- try pci=usepirqmask\n" KERN_DEBUG, newirq,
-			pci_name(dev));
+		if (pci_probe & PCI_USE_PIRQ_MASK)
+			newirq = 0;
+		else
+			dev_warn(&dev->dev, "IRQ %d doesn't match PIRQ mask "
+				 "%#x; try pci=usepirqmask\n", newirq, mask);
 	}
 	if (!newirq && assign) {
 		for (i = 0; i < 16; i++) {
@@ -942,37 +936,32 @@ static int pcibios_lookup_irq(struct pci
 				newirq = i;
 		}
 	}
-	DBG(" -> newirq=%d", newirq);
+	dev_dbg(&dev->dev, "PCI INT %c -> newirq %d", 'A' + pin, newirq);
 
 	/* Check if it is hardcoded */
 	if ((pirq & 0xf0) == 0xf0) {
 		irq = pirq & 0xf;
-		DBG(" -> hardcoded IRQ %d\n", irq);
-		msg = "Hardcoded";
+		msg = "hardcoded";
 	} else if ( r->get && (irq = r->get(pirq_router_dev, dev, pirq)) && \
 	((!(pci_probe & PCI_USE_PIRQ_MASK)) || ((1 << irq) & mask)) ) {
-		DBG(" -> got IRQ %d\n", irq);
-		msg = "Found";
+		msg = "found";
 		eisa_set_level_irq(irq);
 	} else if (newirq && r->set && (dev->class >> 8) != PCI_CLASS_DISPLAY_VGA) {
-		DBG(" -> assigning IRQ %d", newirq);
 		if (r->set(pirq_router_dev, dev, pirq, newirq)) {
 			eisa_set_level_irq(newirq);
-			DBG(" ... OK\n");
-			msg = "Assigned";
+			msg = "assigned";
 			irq = newirq;
 		}
 	}
 
 	if (!irq) {
-		DBG(" ... failed\n");
 		if (newirq && mask == (1 << newirq)) {
-			msg = "Guessed";
+			msg = "guessed";
 			irq = newirq;
 		} else
 			return 0;
 	}
-	printk(KERN_INFO "PCI: %s IRQ %d for device %s\n", msg, irq, pci_name(dev));
+	dev_info(&dev->dev, "%s PCI INT %c -> IRQ %d\n", msg, 'A' + pin, irq);
 
 	/* Update IRQ for all devices with the same pirq value */
 	while ((dev2 = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev2)) != NULL) {
@@ -989,15 +978,17 @@ static int pcibios_lookup_irq(struct pci
 			(!(pci_probe & PCI_USE_PIRQ_MASK) || \
 			((1 << dev2->irq) & mask)) ) {
 #ifndef CONFIG_PCI_MSI
-		    		printk(KERN_INFO "IRQ routing conflict for %s, have irq %d, want irq %d\n",
-				       pci_name(dev2), dev2->irq, irq);
+				dev_info(&dev2->dev, "IRQ routing conflict: "
+					 "have IRQ %d, want IRQ %d\n",
+					 dev2->irq, irq);
 #endif
 		    		continue;
 		    	}
 			dev2->irq = irq;
 			pirq_penalty[irq]++;
 			if (dev != dev2)
-				printk(KERN_INFO "PCI: Sharing IRQ %d with %s\n", irq, pci_name(dev2));
+				dev_info(&dev->dev, "sharing IRQ %d with %s\n",
+					 irq, pci_name(dev2));
 		}
 	}
 	return 1;
@@ -1015,7 +1006,7 @@ static void __init pcibios_fixup_irqs(vo
 		 * Also keep track of which IRQ's are already in use.
 		 */
 		if (dev->irq >= 16) {
-			DBG(KERN_DEBUG "%s: ignoring bogus IRQ %d\n", pci_name(dev), dev->irq);
+			dev_dbg(&dev->dev, "ignoring bogus IRQ %d\n", dev->irq);
 			dev->irq = 0;
 		}
 		/* If the IRQ is already assigned to a PCI device, ignore its ISA use penalty */
@@ -1051,12 +1042,16 @@ static void __init pcibios_fixup_irqs(vo
 					irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number, 
 							PCI_SLOT(bridge->devfn), pin);
 					if (irq >= 0)
-						printk(KERN_WARNING "PCI: using PPB %s[%c] to get irq %d\n",
-							pci_name(bridge), 'A' + pin, irq);
+						dev_warn(&dev->dev, "using "
+							 "bridge %s INT %c to "
+							 "get IRQ %d\n",
+							 pci_name(bridge),
+							 'A' + pin, irq);
 				}
 				if (irq >= 0) {
-					printk(KERN_INFO "PCI->APIC IRQ transform: %s[%c] -> IRQ %d\n",
-						pci_name(dev), 'A' + pin, irq);
+					dev_info(&dev->dev, "PCI->APIC IRQ "
+						 "transform: INT %c -> "
+						 "IRQ %d\n", 'A' + pin, irq);
 					dev->irq = irq;
 				}
 			}
@@ -1209,14 +1204,16 @@ static int pirq_enable_irq(struct pci_de
 				irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number, 
 						PCI_SLOT(bridge->devfn), pin);
 				if (irq >= 0)
-					printk(KERN_WARNING "PCI: using PPB %s[%c] to get irq %d\n",
-						pci_name(bridge), 'A' + pin, irq);
+					dev_warn(&dev->dev, "using bridge %s "
+						 "INT %c to get IRQ %d\n",
+						 pci_name(bridge), 'A' + pin,
+						 irq);
 				dev = bridge;
 			}
 			dev = temp_dev;
 			if (irq >= 0) {
-				printk(KERN_INFO "PCI->APIC IRQ transform: %s[%c] -> IRQ %d\n",
-					pci_name(dev), 'A' + pin, irq);
+				dev_info(&dev->dev, "PCI->APIC IRQ transform: "
+					 "INT %c -> IRQ %d\n", 'A' + pin, irq);
 				dev->irq = irq;
 				return 0;
 			} else
@@ -1230,8 +1227,8 @@ static int pirq_enable_irq(struct pci_de
 		if (dev->class >> 8 == PCI_CLASS_STORAGE_IDE && !(dev->class & 0x5))
 			return 0;
 
-		printk(KERN_WARNING "PCI: No IRQ known for interrupt pin %c of device %s.%s\n",
-		       'A' + pin, pci_name(dev), msg);
+		dev_warn(&dev->dev, "no IRQ known for PCI INT %c. %s\n",
+			 'A' + pin, msg);
 	}
 	return 0;
 }
Index: work11/arch/x86/pci/numa.c
===================================================================
--- work11.orig/arch/x86/pci/numa.c	2008-06-26 12:27:39.000000000 -0600
+++ work11/arch/x86/pci/numa.c	2008-06-26 12:30:27.000000000 -0600
@@ -155,13 +155,14 @@ static void __devinit pci_fixup_i450nx(s
 	u8 busno, suba, subb;
 	int quad = BUS2QUAD(d->bus->number);
 
-	printk("PCI: Searching for i450NX host bridges on %s\n", pci_name(d));
+	dev_info(&d->dev, "searching for i450NX host bridges\n");
 	reg = 0xd0;
 	for(pxb=0; pxb<2; pxb++) {
 		pci_read_config_byte(d, reg++, &busno);
 		pci_read_config_byte(d, reg++, &suba);
 		pci_read_config_byte(d, reg++, &subb);
-		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
+		dev_dbg(&d->dev, "i450NX PXB %d: %02x/%02x/%02x\n",
+			pxb, busno, suba, subb);
 		if (busno) {
 			/* Bus A */
 			pci_scan_bus_with_sysdata(QUADLOCAL2BUS(quad, busno));

-- 
