Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbXLDGJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbXLDGJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 01:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbXLDGJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 01:09:14 -0500
Received: from ozlabs.org ([203.10.76.45]:34622 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbXLDGJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 01:09:13 -0500
To: Greg Kroah-Hartman <greg@kroah.com>
CC: linux-pci@atrey.karlin.mff.cuni.cz, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 04 Dec 2007 17:08:03 +1100
Subject: [PATCH] pci: Fix bus resource assignment on 32 bits with 64b resources
Message-Id: <20071204060911.EA82BDDE19@ozlabs.org>
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

 drivers/pci/pci.h       |   11 +++++++++++
 drivers/pci/setup-bus.c |   32 +++++++++++++++++---------------
 drivers/pci/setup-res.c |    5 ++---
 include/linux/pci.h     |    4 ++--
 4 files changed, 32 insertions(+), 20 deletions(-)

Index: linux-work/drivers/pci/pci.h
===================================================================
--- linux-work.orig/drivers/pci/pci.h	2007-12-04 17:00:43.000000000 +1100
+++ linux-work/drivers/pci/pci.h	2007-12-04 17:02:11.000000000 +1100
@@ -91,3 +91,14 @@ pci_match_one_device(const struct pci_de
 }
 
 struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
+
+#ifdef CONFIG_RESOURCES_64BIT
+#define RESOURCE_ORDER(order)	(1ULL << (order))
+#define RES_PR			"%016llx"
+#else
+#define RESOURCE_ORDER(order)	(1UL << (order))
+#define RES_PR			"%08lx"
+#endif
+
+#define RANGE_PR		RES_PR "-" RES_PR
+
Index: linux-work/drivers/pci/setup-bus.c
===================================================================
--- linux-work.orig/drivers/pci/setup-bus.c	2007-12-04 17:00:43.000000000 +1100
+++ linux-work/drivers/pci/setup-bus.c	2007-12-04 17:04:23.000000000 +1100
@@ -26,6 +26,7 @@
 #include <linux/cache.h>
 #include <linux/slab.h>
 
+#include "pci.h"
 
 #define DEBUG_CONFIG 1
 #if DEBUG_CONFIG
@@ -89,8 +90,9 @@ void pci_setup_cardbus(struct pci_bus *b
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
@@ -99,7 +101,7 @@ void pci_setup_cardbus(struct pci_bus *b
 
 	pcibios_resource_to_bus(bridge, &region, bus->resource[1]);
 	if (bus->resource[1]->flags & IORESOURCE_IO) {
-		printk("  IO window: %08lx-%08lx\n",
+		printk(KERN_INFO "  IO window: "RANGE_PR"\n",
 			region.start, region.end);
 		pci_write_config_dword(bridge, PCI_CB_IO_BASE_1,
 					region.start);
@@ -109,7 +111,7 @@ void pci_setup_cardbus(struct pci_bus *b
 
 	pcibios_resource_to_bus(bridge, &region, bus->resource[2]);
 	if (bus->resource[2]->flags & IORESOURCE_MEM) {
-		printk("  PREFETCH window: %08lx-%08lx\n",
+		printk(KERN_INFO "  PREFETCH window: "RANGE_PR"\n",
 			region.start, region.end);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_0,
 					region.start);
@@ -119,7 +121,7 @@ void pci_setup_cardbus(struct pci_bus *b
 
 	pcibios_resource_to_bus(bridge, &region, bus->resource[3]);
 	if (bus->resource[3]->flags & IORESOURCE_MEM) {
-		printk("  MEM window: %08lx-%08lx\n",
+		printk(KERN_INFO "  MEM window: "RANGE_PR"\n",
 			region.start, region.end);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_1,
 					region.start);
@@ -159,7 +161,8 @@ pci_setup_bridge(struct pci_bus *bus)
 		/* Set up upper 16 bits of I/O base/limit. */
 		io_upper16 = (region.end & 0xffff0000) | (region.start >> 16);
 		DBG(KERN_INFO "  IO window: %04lx-%04lx\n",
-				region.start, region.end);
+		    (unsigned long)region.start,
+		    (unsigned long)region.end);
 	}
 	else {
 		/* Clear upper 16 bits of I/O base/limit. */
@@ -180,7 +183,7 @@ pci_setup_bridge(struct pci_bus *bus)
 	if (bus->resource[1]->flags & IORESOURCE_MEM) {
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
-		DBG(KERN_INFO "  MEM window: %08lx-%08lx\n",
+		DBG(KERN_INFO "  MEM window: "RANGE_PR"\n",
 				region.start, region.end);
 	}
 	else {
@@ -199,7 +202,7 @@ pci_setup_bridge(struct pci_bus *bus)
 	if (bus->resource[2]->flags & IORESOURCE_PREFETCH) {
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
-		DBG(KERN_INFO "  PREFETCH window: %08lx-%08lx\n",
+		DBG(KERN_INFO "  PREFETCH window: "RANGE_PR"\n",
 				region.start, region.end);
 	}
 	else {
@@ -323,8 +326,8 @@ static void pbus_size_io(struct pci_bus 
 static int pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long type)
 {
 	struct pci_dev *dev;
-	unsigned long min_align, align, size;
-	unsigned long aligns[12];	/* Alignments from 1Mb to 2Gb */
+	resource_size_t min_align, align, size;
+	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
 
@@ -340,7 +343,7 @@ static int pbus_size_mem(struct pci_bus 
 		
 		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
 			struct resource *r = &dev->resource[i];
-			unsigned long r_size;
+			resource_size_t r_size;
 
 			if (r->parent || (r->flags & mask) != type)
 				continue;
@@ -350,10 +353,9 @@ static int pbus_size_mem(struct pci_bus 
 			order = __ffs(align) - 20;
 			if (order > 11) {
 				printk(KERN_WARNING "PCI: region %s/%d "
-				       "too large: %llx-%llx\n",
+				       "too large: " RANGE_PR "\n",
 					pci_name(dev), i,
-					(unsigned long long)r->start,
-					(unsigned long long)r->end);
+					r->start, r->end);
 				r->flags = 0;
 				continue;
 			}
@@ -372,7 +374,7 @@ static int pbus_size_mem(struct pci_bus 
 	align = 0;
 	min_align = 0;
 	for (order = 0; order <= max_order; order++) {
-		unsigned long align1 = 1UL << (order + 20);
+		resource_size_t align1 = RESOURCE_ORDER(order + 20);
 
 		if (!align)
 			min_align = align1;
Index: linux-work/drivers/pci/setup-res.c
===================================================================
--- linux-work.orig/drivers/pci/setup-res.c	2007-12-04 17:00:43.000000000 +1100
+++ linux-work/drivers/pci/setup-res.c	2007-12-04 17:02:11.000000000 +1100
@@ -51,9 +51,8 @@ pci_update_resource(struct pci_dev *dev,
 
 	pcibios_resource_to_bus(dev, &region, res);
 
-	pr_debug("  got res [%llx:%llx] bus [%lx:%lx] flags %lx for "
-		 "BAR %d of %s\n", (unsigned long long)res->start,
-		 (unsigned long long)res->end,
+	pr_debug("  got res ["RANGE_PR"] bus ["RANGE_PR"] flags %lx for "
+		 "BAR %d of %s\n", res->start, res->end,
 		 region.start, region.end, res->flags, resno, pci_name(dev));
 
 	new = region.start | (res->flags & PCI_REGION_FLAG_MASK);
Index: linux-work/include/linux/pci.h
===================================================================
--- linux-work.orig/include/linux/pci.h	2007-12-04 17:00:43.000000000 +1100
+++ linux-work/include/linux/pci.h	2007-12-04 17:02:11.000000000 +1100
@@ -314,8 +314,8 @@ struct pci_raw_ops {
 extern struct pci_raw_ops *raw_pci_ops;
 
 struct pci_bus_region {
-	unsigned long start;
-	unsigned long end;
+	resource_size_t start;
+	resource_size_t end;
 };
 
 struct pci_dynids {
