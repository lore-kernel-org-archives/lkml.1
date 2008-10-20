Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973AbYJTEIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbYJTEIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 00:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYJTEI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 00:08:26 -0400
Received: from ozlabs.org ([203.10.76.45]:42936 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbYJTEIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 00:08:24 -0400
To: Linus Torvalds <torvalds@osdl.org>
CC: <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       linux-pci@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       <yhlu.kernel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 20 Oct 2008 15:07:37 +1100
Subject: [PATCH 2/2] pci: Use new %pR to print resource ranges
Message-Id: <20081020040823.871BDDDDEC@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts things in drivers/pci to use %pR to printout the
content of a struct resource instead of hand-casted %llx or
other variants.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

I didn't go down the subdirs in there and I might have missed one
or two but the bulk is converted.
 
 drivers/pci/pci.c       |    5 ++---
 drivers/pci/probe.c     |   28 +++++++++++++---------------
 drivers/pci/setup-bus.c |   13 ++++---------
 drivers/pci/setup-res.c |   40 +++++++++++++---------------------------
 4 files changed, 32 insertions(+), 54 deletions(-)

--- linux-work.orig/drivers/pci/probe.c	2008-10-17 16:11:00.000000000 +1100
+++ linux-work/drivers/pci/probe.c	2008-10-20 14:44:26.000000000 +1100
@@ -238,9 +238,8 @@ static int __pci_read_base(struct pci_de
 		} else {
 			res->start = l64;
 			res->end = l64 + sz64;
-			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
-				pci_name(dev), pos, (unsigned long long)res->start,
-				(unsigned long long)res->end);
+			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: %pR\n",
+				pci_name(dev), pos, res);
 		}
 	} else {
 		sz = pci_size(l, sz, mask);
@@ -250,9 +249,10 @@ static int __pci_read_base(struct pci_de
 
 		res->start = l;
 		res->end = l + sz;
-		printk(KERN_DEBUG "PCI: %s reg %x %s: [%llx, %llx]\n", pci_name(dev),
-			pos, (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
-			(unsigned long long)res->start, (unsigned long long)res->end);
+		printk(KERN_DEBUG "PCI: %s reg %x %s: %pR\n",
+		       pci_name(dev), pos,
+		       (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
+		       res);
 	}
 
  out:
@@ -323,9 +323,8 @@ void __devinit pci_read_bridge_bases(str
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_DEBUG "PCI: bridge %s io port: [%llx, %llx]\n",
-			pci_name(dev), (unsigned long long) res->start,
-			(unsigned long long) res->end);
+		printk(KERN_DEBUG "PCI: bridge %s io port: %pR\n",
+		       pci_name(dev), res);
 	}
 
 	res = child->resource[1];
@@ -337,9 +336,8 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
-			pci_name(dev), (unsigned long long) res->start,
-			(unsigned long long) res->end);
+		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: %pR\n",
+		       pci_name(dev), res);
 	}
 
 	res = child->resource[2];
@@ -375,9 +373,9 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
-			pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
-			(unsigned long long) res->start, (unsigned long long) res->end);
+		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: %pR\n",
+		       pci_name(dev),
+		       (res->flags & PCI_PREF_RANGE_TYPE_64) ? "64":"32", res);
 	}
 }
 
Index: linux-work/drivers/pci/setup-bus.c
===================================================================
--- linux-work.orig/drivers/pci/setup-bus.c	2008-10-17 16:11:00.000000000 +1100
+++ linux-work/drivers/pci/setup-bus.c	2008-10-20 14:44:26.000000000 +1100
@@ -356,10 +356,7 @@ static int pbus_size_mem(struct pci_bus 
 			order = __ffs(align) - 20;
 			if (order > 11) {
 				dev_warn(&dev->dev, "BAR %d bad alignment %llx: "
-				       "%#016llx-%#016llx\n", i,
-				       (unsigned long long)align,
-				       (unsigned long long)r->start,
-				       (unsigned long long)r->end);
+					 "%pR\n", i, (unsigned long long)align, r);
 				r->flags = 0;
 				continue;
 			}
@@ -539,11 +536,9 @@ static void pci_bus_dump_res(struct pci_
                 if (!res)
                         continue;
 
-		printk(KERN_INFO "bus: %02x index %x %s: [%llx, %llx]\n",
-			bus->number, i,
-			(res->flags & IORESOURCE_IO) ? "io port" : "mmio",
-			(unsigned long long) res->start,
-			(unsigned long long) res->end);
+		printk(KERN_INFO "bus: %02x index %x %s: %pR\n",
+		       bus->number, i,
+		       (res->flags & IORESOURCE_IO) ? "io port" : "mmio", res);
         }
 }
 
Index: linux-work/drivers/pci/setup-res.c
===================================================================
--- linux-work.orig/drivers/pci/setup-res.c	2008-10-17 16:11:00.000000000 +1100
+++ linux-work/drivers/pci/setup-res.c	2008-10-20 14:44:26.000000000 +1100
@@ -49,10 +49,8 @@ void pci_update_resource(struct pci_dev 
 
 	pcibios_resource_to_bus(dev, &region, res);
 
-	dev_dbg(&dev->dev, "BAR %d: got res [%#llx-%#llx] bus [%#llx-%#llx] "
-		"flags %#lx\n", resno,
-		 (unsigned long long)res->start,
-		 (unsigned long long)res->end,
+	dev_dbg(&dev->dev, "BAR %d: got res %pR bus [%#llx-%#llx] "
+		"flags %#lx\n", resno, res,
 		 (unsigned long long)region.start,
 		 (unsigned long long)region.end,
 		 (unsigned long)res->flags);
@@ -114,13 +112,11 @@ int pci_claim_resource(struct pci_dev *d
 		err = insert_resource(root, res);
 
 	if (err) {
-		dev_err(&dev->dev, "BAR %d: %s of %s [%#llx-%#llx]\n",
+		dev_err(&dev->dev, "BAR %d: %s of %s %pR\n",
 			resource,
 			root ? "address space collision on" :
 				"no parent found for",
-			dtype,
-			(unsigned long long)res->start,
-			(unsigned long long)res->end);
+			dtype, res);
 	}
 
 	return err;
@@ -139,9 +135,8 @@ int pci_assign_resource(struct pci_dev *
 	align = resource_alignment(res);
 	if (!align) {
 		dev_err(&dev->dev, "BAR %d: can't allocate resource (bogus "
-			"alignment) [%#llx-%#llx] flags %#lx\n",
-			resno, (unsigned long long)res->start,
-			(unsigned long long)res->end, res->flags);
+			"alignment) %pR flags %#lx\n",
+			resno, res, res->flags);
 		return -EINVAL;
 	}
 
@@ -162,11 +157,8 @@ int pci_assign_resource(struct pci_dev *
 	}
 
 	if (ret) {
-		dev_err(&dev->dev, "BAR %d: can't allocate %s resource "
-			"[%#llx-%#llx]\n", resno,
-			res->flags & IORESOURCE_IO ? "I/O" : "mem",
-			(unsigned long long)res->start,
-			(unsigned long long)res->end);
+		dev_err(&dev->dev, "BAR %d: can't allocate %s resource %pR\n",
+			resno, res->flags & IORESOURCE_IO ? "I/O" : "mem", res);
 	} else {
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		if (resno < PCI_BRIDGE_RESOURCES)
@@ -202,11 +194,8 @@ int pci_assign_resource_fixed(struct pci
 	}
 
 	if (ret) {
-		dev_err(&dev->dev, "BAR %d: can't allocate %s resource "
-			"[%#llx-%#llx\n]", resno,
-			res->flags & IORESOURCE_IO ? "I/O" : "mem",
-			(unsigned long long)res->start,
-			(unsigned long long)res->end);
+		dev_err(&dev->dev, "BAR %d: can't allocate %s resource %pR\n",
+			resno, res->flags & IORESOURCE_IO ? "I/O" : "mem", res);
 	} else if (resno < PCI_BRIDGE_RESOURCES) {
 		pci_update_resource(dev, res, resno);
 	}
@@ -237,9 +226,8 @@ void pdev_sort_resources(struct pci_dev 
 		r_align = resource_alignment(r);
 		if (!r_align) {
 			dev_warn(&dev->dev, "BAR %d: bogus alignment "
-				"[%#llx-%#llx] flags %#lx\n",
-				i, (unsigned long long)r->start,
-				(unsigned long long)r->end, r->flags);
+				"%pR flags %#lx\n",
+				i, r, r->flags);
 			continue;
 		}
 		for (list = head; ; list = list->next) {
@@ -287,9 +275,7 @@ int pci_enable_resources(struct pci_dev 
 
 		if (!r->parent) {
 			dev_err(&dev->dev, "device not available because of "
-				"BAR %d [%#llx-%#llx] collisions\n", i,
-				(unsigned long long) r->start,
-				(unsigned long long) r->end);
+				"BAR %d %pR collisions\n", i, r);
 			return -EINVAL;
 		}
 
Index: linux-work/drivers/pci/pci.c
===================================================================
--- linux-work.orig/drivers/pci/pci.c	2008-10-17 16:11:00.000000000 +1100
+++ linux-work/drivers/pci/pci.c	2008-10-20 14:44:26.000000000 +1100
@@ -1358,11 +1358,10 @@ int pci_request_region(struct pci_dev *p
 	return 0;
 
 err_out:
-	dev_warn(&pdev->dev, "BAR %d: can't reserve %s region [%#llx-%#llx]\n",
+	dev_warn(&pdev->dev, "BAR %d: can't reserve %s region %pR\n",
 		 bar,
 		 pci_resource_flags(pdev, bar) & IORESOURCE_IO ? "I/O" : "mem",
-		 (unsigned long long)pci_resource_start(pdev, bar),
-		 (unsigned long long)pci_resource_end(pdev, bar));
+		 &pdev->resource[bar]);
 	return -EBUSY;
 }
 
