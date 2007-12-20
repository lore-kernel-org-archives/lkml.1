Return-Path: <linux-kernel-owner+w=401wt.eu-S1756948AbXLTXlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbXLTXlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbXLTXlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:41:37 -0500
Received: from cantor.suse.de ([195.135.220.2]:54069 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbXLTXlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:41:36 -0500
Subject: patch pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch added to gregkh-2.6 tree
To: benh@kernel.crashing.org, greg@kroah.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
From: <gregkh@suse.de>
Date: Thu, 20 Dec 2007 15:37:16 -0800
In-Reply-To: <20071210063216.89DBBDDE1E@ozlabs.org>
Message-ID: <11981938363358@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: PCI: Fix bus resource assignment on 32 bits with 64b resources

to my gregkh-2.6 tree.  Its filename is

     pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From benh@ozlabs.org Sun Dec  9 22:32:23 2007
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 10 Dec 2007 17:32:15 +1100
Subject: PCI: Fix bus resource assignment on 32 bits with 64b resources
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>
Message-ID: <20071210063216.89DBBDDE1E@ozlabs.org>


The current pci_assign_unassigned_resources() code doesn't work properly
on 32 bits platforms with 64 bits resources. The main reason is the use
of unsigned long in various places instead of resource_size_t.

This fixes it, along with some tricks to avoid casting to 64 bits on
platforms that don't need it in every printk around.

This is a pre-requisite for making powerpc use the generic code instead of
its own half-useful implementation.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/setup-bus.c |   64 ++++++++++++++++++++++++++++++------------------
 include/linux/pci.h     |    4 +--
 2 files changed, 42 insertions(+), 26 deletions(-)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -89,8 +89,9 @@ void pci_setup_cardbus(struct pci_bus *b
 		 * The IO resource is allocated a range twice as large as it
 		 * would normally need.  This allows us to set both IO regs.
 		 */
-		printk("  IO window: %08lx-%08lx\n",
-			region.start, region.end);
+		printk(KERN_INFO "  IO window: 0x%08lx-0x%08lx\n",
+		       (unsigned long)region.start,
+		       (unsigned long)region.end);
 		pci_write_config_dword(bridge, PCI_CB_IO_BASE_0,
 					region.start);
 		pci_write_config_dword(bridge, PCI_CB_IO_LIMIT_0,
@@ -99,8 +100,9 @@ void pci_setup_cardbus(struct pci_bus *b
 
 	pcibios_resource_to_bus(bridge, &region, bus->resource[1]);
 	if (bus->resource[1]->flags & IORESOURCE_IO) {
-		printk("  IO window: %08lx-%08lx\n",
-			region.start, region.end);
+		printk(KERN_INFO "  IO window: 0x%08lx-0x%08lx\n",
+		       (unsigned long)region.start,
+		       (unsigned long)region.end);
 		pci_write_config_dword(bridge, PCI_CB_IO_BASE_1,
 					region.start);
 		pci_write_config_dword(bridge, PCI_CB_IO_LIMIT_1,
@@ -109,8 +111,9 @@ void pci_setup_cardbus(struct pci_bus *b
 
 	pcibios_resource_to_bus(bridge, &region, bus->resource[2]);
 	if (bus->resource[2]->flags & IORESOURCE_MEM) {
-		printk("  PREFETCH window: %08lx-%08lx\n",
-			region.start, region.end);
+		printk(KERN_INFO "  PREFETCH window: 0x%08lx-0x%08lx\n",
+		       (unsigned long)region.start,
+		       (unsigned long)region.end);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_0,
 					region.start);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_LIMIT_0,
@@ -119,8 +122,9 @@ void pci_setup_cardbus(struct pci_bus *b
 
 	pcibios_resource_to_bus(bridge, &region, bus->resource[3]);
 	if (bus->resource[3]->flags & IORESOURCE_MEM) {
-		printk("  MEM window: %08lx-%08lx\n",
-			region.start, region.end);
+		printk(KERN_INFO "  MEM window: 0x%08lx-0x%08lx\n",
+		       (unsigned long)region.start,
+		       (unsigned long)region.end);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_1,
 					region.start);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_LIMIT_1,
@@ -145,7 +149,7 @@ pci_setup_bridge(struct pci_bus *bus)
 {
 	struct pci_dev *bridge = bus->self;
 	struct pci_bus_region region;
-	u32 l, io_upper16;
+	u32 l, bu, lu, io_upper16;
 
 	DBG(KERN_INFO "PCI: Bridge: %s\n", pci_name(bridge));
 
@@ -159,7 +163,8 @@ pci_setup_bridge(struct pci_bus *bus)
 		/* Set up upper 16 bits of I/O base/limit. */
 		io_upper16 = (region.end & 0xffff0000) | (region.start >> 16);
 		DBG(KERN_INFO "  IO window: %04lx-%04lx\n",
-				region.start, region.end);
+		    (unsigned long)region.start,
+		    (unsigned long)region.end);
 	}
 	else {
 		/* Clear upper 16 bits of I/O base/limit. */
@@ -180,8 +185,9 @@ pci_setup_bridge(struct pci_bus *bus)
 	if (bus->resource[1]->flags & IORESOURCE_MEM) {
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
-		DBG(KERN_INFO "  MEM window: %08lx-%08lx\n",
-				region.start, region.end);
+		DBG(KERN_INFO "  MEM window: 0x%08lx-0x%08lx\n",
+		    (unsigned long)region.start,
+		    (unsigned long)region.end);
 	}
 	else {
 		l = 0x0000fff0;
@@ -195,12 +201,18 @@ pci_setup_bridge(struct pci_bus *bus)
 	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, 0);
 
 	/* Set up PREF base/limit. */
+	bu = lu = 0;
 	pcibios_resource_to_bus(bridge, &region, bus->resource[2]);
 	if (bus->resource[2]->flags & IORESOURCE_PREFETCH) {
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
-		DBG(KERN_INFO "  PREFETCH window: %08lx-%08lx\n",
-				region.start, region.end);
+#ifdef CONFIG_RESOURCES_64BIT
+		bu = region.start >> 32;
+		lu = region.end >> 32;
+#endif
+		DBG(KERN_INFO "  PREFETCH window: 0x%016llx-0x%016llx\n",
+		    (unsigned long long)region.start,
+		    (unsigned long long)region.end);
 	}
 	else {
 		l = 0x0000fff0;
@@ -208,8 +220,9 @@ pci_setup_bridge(struct pci_bus *bus)
 	}
 	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
 
-	/* Clear out the upper 32 bits of PREF base. */
-	pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, 0);
+	/* Set the upper 32 bits of PREF base & limit. */
+	pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
+	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
 
 	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, bus->bridge_ctl);
 }
@@ -323,8 +336,8 @@ static void pbus_size_io(struct pci_bus 
 static int pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long type)
 {
 	struct pci_dev *dev;
-	unsigned long min_align, align, size;
-	unsigned long aligns[12];	/* Alignments from 1Mb to 2Gb */
+	resource_size_t min_align, align, size;
+	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
 
@@ -340,7 +353,7 @@ static int pbus_size_mem(struct pci_bus 
 		
 		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
 			struct resource *r = &dev->resource[i];
-			unsigned long r_size;
+			resource_size_t r_size;
 
 			if (r->parent || (r->flags & mask) != type)
 				continue;
@@ -350,10 +363,10 @@ static int pbus_size_mem(struct pci_bus 
 			order = __ffs(align) - 20;
 			if (order > 11) {
 				printk(KERN_WARNING "PCI: region %s/%d "
-				       "too large: %llx-%llx\n",
+				       "too large: 0x%016llx-0x%016llx\n",
 					pci_name(dev), i,
-					(unsigned long long)r->start,
-					(unsigned long long)r->end);
+				       (unsigned long long)r->start,
+				       (unsigned long long)r->end);
 				r->flags = 0;
 				continue;
 			}
@@ -372,8 +385,11 @@ static int pbus_size_mem(struct pci_bus 
 	align = 0;
 	min_align = 0;
 	for (order = 0; order <= max_order; order++) {
-		unsigned long align1 = 1UL << (order + 20);
-
+#ifdef CONFIG_RESOURCES_64BIT
+		resource_size_t align1 = 1ULL << (order + 20);
+#else
+		resource_size_t align1 = 1U << (order + 20);
+#endif
 		if (!align)
 			min_align = align1;
 		else if (ALIGN(align + min_align, min_align) < align1)
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -309,8 +309,8 @@ struct pci_raw_ops {
 extern struct pci_raw_ops *raw_pci_ops;
 
 struct pci_bus_region {
-	unsigned long start;
-	unsigned long end;
+	resource_size_t start;
+	resource_size_t end;
 };
 
 struct pci_dynids {


Patches currently in gregkh-2.6 which might be from benh@kernel.crashing.org are

bad/battery-class-driver.patch
driver/adb-convert-from-class_device-to-device.patch
driver/kobject-convert-hvc_console-to-use-kref-not-kobject.patch
driver/kobject-convert-hvcs-to-use-kref-not-kobject.patch
driver/kobject-convert-icom-to-use-kref-not-kobject.patch
pci/pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
pci/pci-fix-warning-in-setup-res.c-on-32-bit-platforms-with-64-bit-resources.patch
usb/usb-remove-ohci-useless-masking-unmasking-of-wdh-interrupt.patch
