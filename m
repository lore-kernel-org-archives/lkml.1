Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbXLJGQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbXLJGQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 01:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXLJGQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 01:16:01 -0500
Received: from ozlabs.org ([203.10.76.45]:42592 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbXLJGQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 01:16:00 -0500
To: Greg Kroah-Hartman <greg@kroah.com>
CC: linux-pci@atrey.karlin.mff.cuni.cz, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 10 Dec 2007 17:15:57 +1100
Subject: [PATCH] pci: Fix bus resource assignment on 32 bits with 64b resources
Message-Id: <20071210061559.2E3DDDDE02@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current pci_assign_unassigned_resources() code doesn't work properly
on 32 bits platforms with 64 bits resources. The main reason is the use
of unsigned long in various places instead of resource_size_t.

This fixes it, along with some tricks to avoid casting to 64 bits on
platforms that don't need it in every printk around.

This is a pre-requisite for making powerpc use the generic code instead of
its own half-useful implementation.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

This version now uses casts as Greg asked for and adds proper setup
of the prefetchable base & limit "upper" registers when using 64 bits
resources.

 drivers/pci/setup-bus.c |   59 +++++++++++++++++++++++++++++-------------------
 include/linux/pci.h     |    4 +--
 2 files changed, 38 insertions(+), 25 deletions(-)

Index: linux-work/drivers/pci/setup-bus.c
===================================================================
--- linux-work.orig/drivers/pci/setup-bus.c	2007-12-10 16:56:51.000000000 +1100
+++ linux-work/drivers/pci/setup-bus.c	2007-12-10 17:12:27.000000000 +1100
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
@@ -372,7 +385,7 @@ static int pbus_size_mem(struct pci_bus 
 	align = 0;
 	min_align = 0;
 	for (order = 0; order <= max_order; order++) {
-		unsigned long align1 = 1UL << (order + 20);
+		resource_size_t align1 = RESOURCE_ORDER(order + 20);
 
 		if (!align)
 			min_align = align1;
Index: linux-work/include/linux/pci.h
===================================================================
--- linux-work.orig/include/linux/pci.h	2007-12-10 16:56:51.000000000 +1100
+++ linux-work/include/linux/pci.h	2007-12-10 16:57:20.000000000 +1100
@@ -314,8 +314,8 @@ struct pci_raw_ops {
 extern struct pci_raw_ops *raw_pci_ops;
 
 struct pci_bus_region {
-	unsigned long start;
-	unsigned long end;
+	resource_size_t start;
+	resource_size_t end;
 };
 
 struct pci_dynids {
