Return-Path: <linux-kernel-owner+w=401wt.eu-S1759928AbYF0Ox3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbYF0Ox3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbYF0Owk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:52:40 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:15254 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbYF0Owf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:52:35 -0400
Message-Id: <20080627144753.163958078@ldl.fc.hp.com>
References: <20080627144538.743154341@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 08:45:40 -0600
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
Subject: [patch 2/6] PCI: use dev_printk when possible
Content-Disposition: inline; filename=pci-dev_printk
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printks to use dev_printk().

I converted pr_debug() to dev_dbg().  Both use KERN_DEBUG and are enabled
only when DEBUG is defined.

I converted printk(KERN_DEBUG) to dev_printk(KERN_DEBUG), not to dev_dbg(),
because dev_dbg() is only enabled when DEBUG is defined.

I converted DBG(KERN_INFO) (only in setup-bus.c) to dev_info().  The DBG()
name makes it sound like debug, but it's been enabled forever, so dev_info()
preserves the previous behavior.

I tried to make the resource assignment formats more consistent, e.g.,
  "BAR %d: got res [%#llx-%#llx] bus [%#llx-%#llx] flags %#lx\n"
instead of sometimes using "start-end" and sometimes using "size@start".
I'm not attached to one or the other; I'd just like them consistent.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pci/msi.c       |   10 ++----
 drivers/pci/pci.c       |   40 ++++++++++++---------------
 drivers/pci/probe.c     |   28 +++++++++----------
 drivers/pci/setup-bus.c |   43 ++++++++++++-----------------
 drivers/pci/setup-irq.c |    3 --
 drivers/pci/setup-res.c |   69 ++++++++++++++++++++++--------------------------
 6 files changed, 87 insertions(+), 106 deletions(-)

Index: work11/drivers/pci/msi.c
===================================================================
--- work11.orig/drivers/pci/msi.c	2008-06-26 12:27:39.000000000 -0600
+++ work11/drivers/pci/msi.c	2008-06-26 12:29:57.000000000 -0600
@@ -561,9 +561,8 @@ int pci_enable_msi(struct pci_dev* dev)
 
 	/* Check whether driver already requested for MSI-X irqs */
 	if (dev->msix_enabled) {
-		printk(KERN_INFO "PCI: %s: Can't enable MSI.  "
-			"Device already has MSI-X enabled\n",
-			pci_name(dev));
+		dev_info(&dev->dev, "can't enable MSI "
+			 "(MSI-X already enabled)\n");
 		return -EINVAL;
 	}
 	status = msi_capability_init(dev);
@@ -686,9 +685,8 @@ int pci_enable_msix(struct pci_dev* dev,
 
 	/* Check whether driver already requested for MSI irq */
    	if (dev->msi_enabled) {
-		printk(KERN_INFO "PCI: %s: Can't enable MSI-X.  "
-		       "Device already has an MSI irq assigned\n",
-		       pci_name(dev));
+		dev_info(&dev->dev, "can't enable MSI-X "
+		       "(MSI IRQ already assigned)\n");
 		return -EINVAL;
 	}
 	status = msix_capability_init(dev, entries, nvec);
Index: work11/drivers/pci/pci.c
===================================================================
--- work11.orig/drivers/pci/pci.c	2008-06-26 12:27:39.000000000 -0600
+++ work11/drivers/pci/pci.c	2008-06-26 12:29:57.000000000 -0600
@@ -424,8 +424,8 @@ pci_set_power_state(struct pci_dev *dev,
 	 * to sleep if we're already in a low power state
 	 */
 	if (state != PCI_D0 && dev->current_state > state) {
-		printk(KERN_ERR "%s(): %s: state=%d, current state=%d\n",
-			__func__, pci_name(dev), state, dev->current_state);
+		dev_err(&dev->dev, "invalid power transition "
+			"(from state %d to %d)\n", dev->current_state, state);
 		return -EINVAL;
 	} else if (dev->current_state == state)
 		return 0;        /* we're already there */
@@ -433,9 +433,8 @@ pci_set_power_state(struct pci_dev *dev,
 
 	pci_read_config_word(dev,pm + PCI_PM_PMC,&pmc);
 	if ((pmc & PCI_PM_CAP_VER_MASK) > 3) {
-		printk(KERN_DEBUG
-		       "PCI: %s has unsupported PM cap regs version (%u)\n",
-		       pci_name(dev), pmc & PCI_PM_CAP_VER_MASK);
+		dev_printk(KERN_DEBUG, &dev->dev, "unsupported PM cap regs "
+			   "version (%u)\n", pmc & PCI_PM_CAP_VER_MASK);
 		return -EIO;
 	}
 
@@ -543,7 +542,8 @@ pci_power_t pci_choose_state(struct pci_
 	case PM_EVENT_HIBERNATE:
 		return PCI_D3hot;
 	default:
-		printk("Unrecognized suspend event %d\n", state.event);
+		dev_info(&dev->dev, "unrecognized suspend event %d\n",
+			 state.event);
 		BUG();
 	}
 	return PCI_D0;
@@ -568,7 +568,7 @@ static int pci_save_pcie_state(struct pc
 	else
 		found = 1;
 	if (!save_state) {
-		dev_err(&dev->dev, "Out of memory in pci_save_pcie_state\n");
+		dev_err(&dev->dev, "out of memory in pci_save_pcie_state\n");
 		return -ENOMEM;
 	}
 	cap = (u16 *)&save_state->data[0];
@@ -619,7 +619,7 @@ static int pci_save_pcix_state(struct pc
 	else
 		found = 1;
 	if (!save_state) {
-		dev_err(&dev->dev, "Out of memory in pci_save_pcie_state\n");
+		dev_err(&dev->dev, "out of memory in pci_save_pcie_state\n");
 		return -ENOMEM;
 	}
 	cap = (u16 *)&save_state->data[0];
@@ -685,10 +685,9 @@ pci_restore_state(struct pci_dev *dev)
 	for (i = 15; i >= 0; i--) {
 		pci_read_config_dword(dev, i * 4, &val);
 		if (val != dev->saved_config_space[i]) {
-			printk(KERN_DEBUG "PM: Writing back config space on "
-				"device %s at offset %x (was %x, writing %x)\n",
-				pci_name(dev), i,
-				val, (int)dev->saved_config_space[i]);
+			dev_printk(KERN_DEBUG, &dev->dev, "restoring config "
+				"space at offset %#x (was %#x, writing %#x)\n",
+				i, val, (int)dev->saved_config_space[i]);
 			pci_write_config_dword(dev,i * 4,
 				dev->saved_config_space[i]);
 		}
@@ -1116,13 +1115,11 @@ int pci_request_region(struct pci_dev *p
 	return 0;
 
 err_out:
-	printk (KERN_WARNING "PCI: Unable to reserve %s region #%d:%llx@%llx "
-		"for device %s\n",
-		pci_resource_flags(pdev, bar) & IORESOURCE_IO ? "I/O" : "mem",
+	dev_warn(&pdev->dev, "BAR %d: can't reserve %s region [%#llx-%#llx]\n",
 		bar + 1, /* PCI BAR # */
-		(unsigned long long)pci_resource_len(pdev, bar),
+		pci_resource_flags(pdev, bar) & IORESOURCE_IO ? "I/O" : "mem",
 		(unsigned long long)pci_resource_start(pdev, bar),
-		pci_name(pdev));
+		(unsigned long long)pci_resource_end(pdev, bar));
 	return -EBUSY;
 }
 
@@ -1214,7 +1211,7 @@ pci_set_master(struct pci_dev *dev)
 
 	pci_read_config_word(dev, PCI_COMMAND, &cmd);
 	if (! (cmd & PCI_COMMAND_MASTER)) {
-		pr_debug("PCI: Enabling bus mastering for device %s\n", pci_name(dev));
+		dev_dbg(&dev->dev, "enabling bus mastering\n");
 		cmd |= PCI_COMMAND_MASTER;
 		pci_write_config_word(dev, PCI_COMMAND, cmd);
 	}
@@ -1279,8 +1276,8 @@ pci_set_cacheline_size(struct pci_dev *d
 	if (cacheline_size == pci_cache_line_size)
 		return 0;
 
-	printk(KERN_DEBUG "PCI: cache line size of %d is not supported "
-	       "by device %s\n", pci_cache_line_size << 2, pci_name(dev));
+	dev_printk(KERN_DEBUG, &dev->dev, "cache line size of %d is not "
+		   "supported\n", pci_cache_line_size << 2);
 
 	return -EINVAL;
 }
@@ -1305,8 +1302,7 @@ pci_set_mwi(struct pci_dev *dev)
 
 	pci_read_config_word(dev, PCI_COMMAND, &cmd);
 	if (! (cmd & PCI_COMMAND_INVALIDATE)) {
-		pr_debug("PCI: Enabling Mem-Wr-Inval for device %s\n",
-			pci_name(dev));
+		dev_dbg(&dev->dev, "enabling Mem-Wr-Inval\n");
 		cmd |= PCI_COMMAND_INVALIDATE;
 		pci_write_config_word(dev, PCI_COMMAND, cmd);
 	}
Index: work11/drivers/pci/probe.c
===================================================================
--- work11.orig/drivers/pci/probe.c	2008-06-26 12:27:39.000000000 -0600
+++ work11/drivers/pci/probe.c	2008-06-26 12:29:57.000000000 -0600
@@ -277,8 +277,8 @@ static void pci_read_bases(struct pci_de
 			res->end = res->start + sz64;
 #else
 			if (sz64 > 0x100000000ULL) {
-				printk(KERN_ERR "PCI: Unable to handle 64-bit "
-					"BAR for device %s\n", pci_name(dev));
+				dev_err(&dev->dev, "BAR %d: can't handle 64-bit"
+					" BAR\n", pos);
 				res->start = 0;
 				res->flags = 0;
 			} else if (lhi) {
@@ -329,7 +329,7 @@ void __devinit pci_read_bridge_bases(str
 		return;
 
 	if (dev->transparent) {
-		printk(KERN_INFO "PCI: Transparent bridge - %s\n", pci_name(dev));
+		dev_info(&dev->dev, "transparent bridge\n");
 		for(i = 3; i < PCI_BUS_NUM_RESOURCES; i++)
 			child->resource[i] = child->parent->resource[i - 3];
 	}
@@ -392,7 +392,8 @@ void __devinit pci_read_bridge_bases(str
 			limit |= ((long) mem_limit_hi) << 32;
 #else
 			if (mem_base_hi || mem_limit_hi) {
-				printk(KERN_ERR "PCI: Unable to handle 64-bit address space for bridge %s\n", pci_name(dev));
+				dev_err(&dev->dev, "can't handle 64-bit "
+					"address space for bridge\n");
 				return;
 			}
 #endif
@@ -511,8 +512,8 @@ int __devinit pci_scan_bridge(struct pci
 
 	pci_read_config_dword(dev, PCI_PRIMARY_BUS, &buses);
 
-	pr_debug("PCI: Scanning behind PCI bridge %s, config %06x, pass %d\n",
-		 pci_name(dev), buses & 0xffffff, pass);
+	dev_dbg(&dev->dev, "scanning behind bridge, config %06x, pass %d\n",
+		buses & 0xffffff, pass);
 
 	/* Disable MasterAbortMode during probing to avoid reporting
 	   of bus errors (in some architectures) */ 
@@ -535,8 +536,8 @@ int __devinit pci_scan_bridge(struct pci
 		 * ignore it.  This can happen with the i450NX chipset.
 		 */
 		if (pci_find_bus(pci_domain_nr(bus), busnr)) {
-			printk(KERN_INFO "PCI: Bus %04x:%02x already known\n",
-					pci_domain_nr(bus), busnr);
+			dev_info(&dev->dev, "bus %04x:%02x already known\n",
+				 pci_domain_nr(bus), busnr);
 			goto out;
 		}
 
@@ -720,7 +721,7 @@ static int pci_setup_device(struct pci_d
 	dev->class = class;
 	class >>= 8;
 
-	pr_debug("PCI: Found %s [%04x/%04x] %06x %02x\n", pci_name(dev),
+	dev_dbg(&dev->dev, "found [%04x/%04x] class %06x header type %02x\n",
 		 dev->vendor, dev->device, class, dev->hdr_type);
 
 	/* "Unknown power state" */
@@ -788,13 +789,13 @@ static int pci_setup_device(struct pci_d
 		break;
 
 	default:				    /* unknown header */
-		printk(KERN_ERR "PCI: device %s has unknown header type %02x, ignoring.\n",
-			pci_name(dev), dev->hdr_type);
+		dev_err(&dev->dev, "unknown header type %02x, "
+			"ignoring device\n", dev->hdr_type);
 		return -1;
 
 	bad:
-		printk(KERN_ERR "PCI: %s: class %x doesn't match header type %02x. Ignoring class.\n",
-		       pci_name(dev), class, dev->hdr_type);
+		dev_err(&dev->dev, "ignoring class %02x (doesn't match header "
+			"type %02x)\n", class, dev->hdr_type);
 		dev->class = PCI_CLASS_NOT_DEFINED;
 	}
 
@@ -927,7 +928,7 @@ static struct pci_dev *pci_scan_device(s
 			return NULL;
 		/* Card hasn't responded in 60 seconds?  Must be stuck. */
 		if (delay > 60 * 1000) {
-			printk(KERN_WARNING "Device %04x:%02x:%02x.%d not "
+			printk(KERN_WARNING "pci %04x:%02x:%02x.%d: not "
 					"responding\n", pci_domain_nr(bus),
 					bus->number, PCI_SLOT(devfn),
 					PCI_FUNC(devfn));
Index: work11/drivers/pci/setup-bus.c
===================================================================
--- work11.orig/drivers/pci/setup-bus.c	2008-06-26 12:27:39.000000000 -0600
+++ work11/drivers/pci/setup-bus.c	2008-06-26 12:29:57.000000000 -0600
@@ -27,13 +27,6 @@
 #include <linux/slab.h>
 
 
-#define DEBUG_CONFIG 1
-#if DEBUG_CONFIG
-#define DBG(x...)     printk(x)
-#else
-#define DBG(x...)
-#endif
-
 static void pbus_assign_resources_sorted(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
@@ -81,8 +74,8 @@ void pci_setup_cardbus(struct pci_bus *b
 	struct pci_dev *bridge = bus->self;
 	struct pci_bus_region region;
 
-	printk("PCI: Bus %d, cardbus bridge: %s\n",
-		bus->number, pci_name(bridge));
+	dev_info(&bridge->dev, "CardBus bridge, secondary bus %04x:%02x\n",
+		 pci_domain_nr(bus), bus->number);
 
 	pcibios_resource_to_bus(bridge, &region, bus->resource[0]);
 	if (bus->resource[0]->flags & IORESOURCE_IO) {
@@ -90,7 +83,7 @@ void pci_setup_cardbus(struct pci_bus *b
 		 * The IO resource is allocated a range twice as large as it
 		 * would normally need.  This allows us to set both IO regs.
 		 */
-		printk(KERN_INFO "  IO window: 0x%08lx-0x%08lx\n",
+		dev_info(&bridge->dev, "  IO window: %#08lx-%#08lx\n",
 		       (unsigned long)region.start,
 		       (unsigned long)region.end);
 		pci_write_config_dword(bridge, PCI_CB_IO_BASE_0,
@@ -101,7 +94,7 @@ void pci_setup_cardbus(struct pci_bus *b
 
 	pcibios_resource_to_bus(bridge, &region, bus->resource[1]);
 	if (bus->resource[1]->flags & IORESOURCE_IO) {
-		printk(KERN_INFO "  IO window: 0x%08lx-0x%08lx\n",
+		dev_info(&bridge->dev, "  IO window: %#08lx-%#08lx\n",
 		       (unsigned long)region.start,
 		       (unsigned long)region.end);
 		pci_write_config_dword(bridge, PCI_CB_IO_BASE_1,
@@ -112,7 +105,7 @@ void pci_setup_cardbus(struct pci_bus *b
 
 	pcibios_resource_to_bus(bridge, &region, bus->resource[2]);
 	if (bus->resource[2]->flags & IORESOURCE_MEM) {
-		printk(KERN_INFO "  PREFETCH window: 0x%08lx-0x%08lx\n",
+		dev_info(&bridge->dev, "  PREFETCH window: %#08lx-%#08lx\n",
 		       (unsigned long)region.start,
 		       (unsigned long)region.end);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_0,
@@ -123,7 +116,7 @@ void pci_setup_cardbus(struct pci_bus *b
 
 	pcibios_resource_to_bus(bridge, &region, bus->resource[3]);
 	if (bus->resource[3]->flags & IORESOURCE_MEM) {
-		printk(KERN_INFO "  MEM window: 0x%08lx-0x%08lx\n",
+		dev_info(&bridge->dev, "  MEM window: %#08lx-%#08lx\n",
 		       (unsigned long)region.start,
 		       (unsigned long)region.end);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_1,
@@ -151,7 +144,8 @@ static void pci_setup_bridge(struct pci_
 	struct pci_bus_region region;
 	u32 l, bu, lu, io_upper16;
 
-	DBG(KERN_INFO "PCI: Bridge: %s\n", pci_name(bridge));
+	dev_info(&bridge->dev, "PCI bridge, secondary bus %04x:%02x\n",
+		 pci_domain_nr(bus), bus->number);
 
 	/* Set up the top and bottom of the PCI I/O segment for this bus. */
 	pcibios_resource_to_bus(bridge, &region, bus->resource[0]);
@@ -162,7 +156,7 @@ static void pci_setup_bridge(struct pci_
 		l |= region.end & 0xf000;
 		/* Set up upper 16 bits of I/O base/limit. */
 		io_upper16 = (region.end & 0xffff0000) | (region.start >> 16);
-		DBG(KERN_INFO "  IO window: %04lx-%04lx\n",
+		dev_info(&bridge->dev, "  IO window: %#04lx-%#04lx\n",
 		    (unsigned long)region.start,
 		    (unsigned long)region.end);
 	}
@@ -170,7 +164,7 @@ static void pci_setup_bridge(struct pci_
 		/* Clear upper 16 bits of I/O base/limit. */
 		io_upper16 = 0;
 		l = 0x00f0;
-		DBG(KERN_INFO "  IO window: disabled.\n");
+		dev_info(&bridge->dev, "  IO window: disabled\n");
 	}
 	/* Temporarily disable the I/O range before updating PCI_IO_BASE. */
 	pci_write_config_dword(bridge, PCI_IO_BASE_UPPER16, 0x0000ffff);
@@ -185,13 +179,13 @@ static void pci_setup_bridge(struct pci_
 	if (bus->resource[1]->flags & IORESOURCE_MEM) {
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
-		DBG(KERN_INFO "  MEM window: 0x%08lx-0x%08lx\n",
+		dev_info(&bridge->dev, "  MEM window: %#08lx-%#08lx\n",
 		    (unsigned long)region.start,
 		    (unsigned long)region.end);
 	}
 	else {
 		l = 0x0000fff0;
-		DBG(KERN_INFO "  MEM window: disabled.\n");
+		dev_info(&bridge->dev, "  MEM window: disabled\n");
 	}
 	pci_write_config_dword(bridge, PCI_MEMORY_BASE, l);
 
@@ -208,13 +202,13 @@ static void pci_setup_bridge(struct pci_
 		l |= region.end & 0xfff00000;
 		bu = upper_32_bits(region.start);
 		lu = upper_32_bits(region.end);
-		DBG(KERN_INFO "  PREFETCH window: 0x%016llx-0x%016llx\n",
+		dev_info(&bridge->dev, "  PREFETCH window: %#016llx-%#016llx\n",
 		    (unsigned long long)region.start,
 		    (unsigned long long)region.end);
 	}
 	else {
 		l = 0x0000fff0;
-		DBG(KERN_INFO "  PREFETCH window: disabled.\n");
+		dev_info(&bridge->dev, "  PREFETCH window: disabled\n");
 	}
 	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
 
@@ -361,9 +355,8 @@ static int pbus_size_mem(struct pci_bus 
 			align = (i < PCI_BRIDGE_RESOURCES) ? r_size : r->start;
 			order = __ffs(align) - 20;
 			if (order > 11) {
-				printk(KERN_WARNING "PCI: region %s/%d "
-				       "too large: 0x%016llx-0x%016llx\n",
-					pci_name(dev), i,
+				dev_warn(&dev->dev, "BAR %d too large: "
+				       "%#016llx-%#016llx\n", i,
 				       (unsigned long long)r->start,
 				       (unsigned long long)r->end);
 				r->flags = 0;
@@ -529,8 +522,8 @@ void __ref pci_bus_assign_resources(stru
 			break;
 
 		default:
-			printk(KERN_INFO "PCI: not setting up bridge %s "
-			       "for bus %d\n", pci_name(dev), b->number);
+			dev_info(&dev->dev, "not setting up bridge for bus "
+				 "%04x:%02x\n", pci_domain_nr(b), b->number);
 			break;
 		}
 	}
Index: work11/drivers/pci/setup-irq.c
===================================================================
--- work11.orig/drivers/pci/setup-irq.c	2008-06-26 12:27:39.000000000 -0600
+++ work11/drivers/pci/setup-irq.c	2008-06-26 12:29:57.000000000 -0600
@@ -47,8 +47,7 @@ pdev_fixup_irq(struct pci_dev *dev,
 	}
 	dev->irq = irq;
 
-	pr_debug("PCI: fixup irq: (%s) got %d\n",
-		kobject_name(&dev->dev.kobj), dev->irq);
+	dev_dbg(&dev->dev, "fixup irq: got %d\n", dev->irq);
 
 	/* Always tell the device, so the driver knows what is
 	   the real IRQ to use; the device does not use it. */
Index: work11/drivers/pci/setup-res.c
===================================================================
--- work11.orig/drivers/pci/setup-res.c	2008-06-26 12:27:39.000000000 -0600
+++ work11/drivers/pci/setup-res.c	2008-06-26 12:29:57.000000000 -0600
@@ -26,8 +26,7 @@
 #include "pci.h"
 
 
-void
-pci_update_resource(struct pci_dev *dev, struct resource *res, int resno)
+void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno)
 {
 	struct pci_bus_region region;
 	u32 new, check, mask;
@@ -43,20 +42,20 @@ pci_update_resource(struct pci_dev *dev,
 	/*
 	 * Ignore non-moveable resources.  This might be legacy resources for
 	 * which no functional BAR register exists or another important
-	 * system resource we should better not move around in system address
-	 * space.
+	 * system resource we shouldn't move around.
 	 */
 	if (res->flags & IORESOURCE_PCI_FIXED)
 		return;
 
 	pcibios_resource_to_bus(dev, &region, res);
 
-	pr_debug("  got res [%llx:%llx] bus [%llx:%llx] flags %lx for "
-		 "BAR %d of %s\n", (unsigned long long)res->start,
+	dev_dbg(&dev->dev, "BAR %d: got res [%#llx-%#llx] bus [%#llx-%#llx] "
+		"flags %#lx\n", resno,
+		 (unsigned long long)res->start,
 		 (unsigned long long)res->end,
 		 (unsigned long long)region.start,
 		 (unsigned long long)region.end,
-		 (unsigned long)res->flags, resno, pci_name(dev));
+		 (unsigned long)res->flags);
 
 	new = region.start | (res->flags & PCI_REGION_FLAG_MASK);
 	if (res->flags & IORESOURCE_IO)
@@ -81,9 +80,8 @@ pci_update_resource(struct pci_dev *dev,
 	pci_read_config_dword(dev, reg, &check);
 
 	if ((new ^ check) & mask) {
-		printk(KERN_ERR "PCI: Error while updating region "
-		       "%s/%d (%08x != %08x)\n", pci_name(dev), resno,
-		       new, check);
+		dev_err(&dev->dev, "BAR %d: error updating (%#08x != %#08x)\n",
+			resno, new, check);
 	}
 
 	if ((new & (PCI_BASE_ADDRESS_SPACE|PCI_BASE_ADDRESS_MEM_TYPE_MASK)) ==
@@ -92,15 +90,14 @@ pci_update_resource(struct pci_dev *dev,
 		pci_write_config_dword(dev, reg + 4, new);
 		pci_read_config_dword(dev, reg + 4, &check);
 		if (check != new) {
-			printk(KERN_ERR "PCI: Error updating region "
-			       "%s/%d (high %08x != %08x)\n",
-			       pci_name(dev), resno, new, check);
+			dev_err(&dev->dev, "BAR %d: error updating "
+			       "(high %#08x != %#08x)\n", resno, new, check);
 		}
 	}
 	res->flags &= ~IORESOURCE_UNSET;
-	pr_debug("PCI: moved device %s resource %d (%lx) to %x\n",
-		pci_name(dev), resno, res->flags,
-		new & ~PCI_REGION_FLAG_MASK);
+	dev_dbg(&dev->dev, "BAR %d: moved to bus [%#llx-%#llx] flags %#lx\n",
+		resno, (unsigned long long)region.start,
+		(unsigned long long)region.end, res->flags);
 }
 
 int pci_claim_resource(struct pci_dev *dev, int resource)
@@ -117,10 +114,11 @@ int pci_claim_resource(struct pci_dev *d
 		err = insert_resource(root, res);
 
 	if (err) {
-		printk(KERN_ERR "PCI: %s region %d of %s %s [%llx:%llx]\n",
-			root ? "Address space collision on" :
-				"No parent found for",
-			resource, dtype, pci_name(dev),
+		dev_err(&dev->dev, "BAR %d: %s of %s [%#llx-%#llx]\n",
+			resource,
+			root ? "address space collision on" :
+				"no parent found for",
+			dtype,
 			(unsigned long long)res->start,
 			(unsigned long long)res->end);
 	}
@@ -140,11 +138,10 @@ int pci_assign_resource(struct pci_dev *
 
 	align = resource_alignment(res);
 	if (!align) {
-		printk(KERN_ERR "PCI: Cannot allocate resource (bogus "
-			"alignment) %d [%llx:%llx] (flags %lx) of %s\n",
+		dev_err(&dev->dev, "BAR %d: can't allocate resource (bogus "
+			"alignment) [%#llx-%#llx] flags %#lx\n",
 			resno, (unsigned long long)res->start,
-			(unsigned long long)res->end, res->flags,
-			pci_name(dev));
+			(unsigned long long)res->end, res->flags);
 		return -EINVAL;
 	}
 
@@ -165,11 +162,11 @@ int pci_assign_resource(struct pci_dev *
 	}
 
 	if (ret) {
-		printk(KERN_ERR "PCI: Failed to allocate %s resource "
-			"#%d:%llx@%llx for %s\n",
+		dev_err(&dev->dev, "BAR %d: can't allocate %s resource "
+			"[%#llx-%#llx]\n", resno,
 			res->flags & IORESOURCE_IO ? "I/O" : "mem",
-			resno, (unsigned long long)size,
-			(unsigned long long)res->start, pci_name(dev));
+			(unsigned long long)res->start,
+			(unsigned long long)res->end);
 	} else {
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		if (resno < PCI_BRIDGE_RESOURCES)
@@ -205,11 +202,11 @@ int pci_assign_resource_fixed(struct pci
 	}
 
 	if (ret) {
-		printk(KERN_ERR "PCI: Failed to allocate %s resource "
-				"#%d:%llx@%llx for %s\n",
+		dev_err(&dev->dev, "BAR %d: can't allocate %s resource "
+			"[%#llx-%#llx\n]", resno,
 			res->flags & IORESOURCE_IO ? "I/O" : "mem",
-			resno, (unsigned long long)(res->end - res->start + 1),
-			(unsigned long long)res->start, pci_name(dev));
+			(unsigned long long)res->start,
+			(unsigned long long)res->end);
 	} else if (resno < PCI_BRIDGE_RESOURCES) {
 		pci_update_resource(dev, res, resno);
 	}
@@ -239,11 +236,10 @@ void pdev_sort_resources(struct pci_dev 
 
 		r_align = resource_alignment(r);
 		if (!r_align) {
-			printk(KERN_WARNING "PCI: bogus alignment of resource "
-				"%d [%llx:%llx] (flags %lx) of %s\n",
+			dev_warn(&dev->dev, "BAR %d: bogus alignment "
+				"[%#llx-%#llx] flags %#lx\n",
 				i, (unsigned long long)r->start,
-				(unsigned long long)r->end, r->flags,
-				pci_name(dev));
+				(unsigned long long)r->end, r->flags);
 			continue;
 		}
 		for (list = head; ; list = list->next) {
@@ -291,7 +287,7 @@ int pci_enable_resources(struct pci_dev 
 
 		if (!r->parent) {
 			dev_err(&dev->dev, "device not available because of "
-				"BAR %d [%llx:%llx] collisions\n", i,
+				"BAR %d [%#llx-%#llx] collisions\n", i,
 				(unsigned long long) r->start,
 				(unsigned long long) r->end);
 			return -EINVAL;

-- 
