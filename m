Return-Path: <linux-kernel-owner+w=401wt.eu-S934145AbZJMTXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145AbZJMTXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934135AbZJMTXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:23:06 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:21922 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934125AbZJMTXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:23:03 -0400
Subject: [PATCH v2 6/9] PCI: print resources consistently with %pR
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Joe Perches <joe@perches.com>, Len Brown <lenb@kernel.org>
Date: Tue, 13 Oct 2009 13:22:25 -0600
Message-ID: <20091013192225.22336.58085.stgit@bob.kio>
In-Reply-To: <20091013192040.22336.84876.stgit@bob.kio>
References: <20091013192040.22336.84876.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses %pR to print additional resource information (type, size,
prefetchability, etc.) consistently.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 drivers/pci/pci.c       |    4 +---
 drivers/pci/probe.c     |   22 ++++++----------------
 drivers/pci/quirks.c    |    2 +-
 drivers/pci/setup-bus.c |   43 ++++++++++++-------------------------------
 drivers/pci/setup-res.c |   20 +++++++++-----------
 5 files changed, 29 insertions(+), 62 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 3835871..832243f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1669,9 +1669,7 @@ static int __pci_request_region(struct pci_dev *pdev, int bar, const char *res_n
 	return 0;
 
 err_out:
-	dev_warn(&pdev->dev, "BAR %d: can't reserve %s region %pR\n",
-		 bar,
-		 pci_resource_flags(pdev, bar) & IORESOURCE_IO ? "I/O" : "mem",
+	dev_warn(&pdev->dev, "BAR %d: can't reserve %pR\n", bar,
 		 &pdev->resource[bar]);
 	return -EBUSY;
 }
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index f760c19..6f0a6fb 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -237,11 +237,8 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		} else {
 			res->start = l64;
 			res->end = l64 + sz64;
-			dev_printk(KERN_DEBUG, &dev->dev,
-				"reg %x %s: %pR\n", pos,
-				 (res->flags & IORESOURCE_PREFETCH) ?
-					"64bit mmio pref" : "64bit mmio",
-				 res);
+			dev_printk(KERN_DEBUG, &dev->dev, "reg %x: %pR\n",
+				   pos, res);
 		}
 	} else {
 		sz = pci_size(l, sz, mask);
@@ -252,11 +249,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		res->start = l;
 		res->end = l + sz;
 
-		dev_printk(KERN_DEBUG, &dev->dev, "reg %x %s: %pR\n", pos,
-			(res->flags & IORESOURCE_IO) ? "io port" :
-			 ((res->flags & IORESOURCE_PREFETCH) ?
-				 "32bit mmio pref" : "32bit mmio"),
-			res);
+		dev_printk(KERN_DEBUG, &dev->dev, "reg %x: %pR\n", pos, res);
 	}
 
  out:
@@ -324,7 +317,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		dev_printk(KERN_DEBUG, &dev->dev, "bridge io port: %pR\n", res);
+		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
 	}
 
 	res = child->resource[1];
@@ -336,8 +329,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		dev_printk(KERN_DEBUG, &dev->dev, "bridge 32bit mmio: %pR\n",
-			res);
+		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
 	}
 
 	res = child->resource[2];
@@ -376,9 +368,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			res->flags |= IORESOURCE_MEM_64;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		dev_printk(KERN_DEBUG, &dev->dev, "bridge %sbit mmio pref: %pR\n",
-			(res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
-			res);
+		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
 	}
 }
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index efa6534..d996a2f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -357,7 +357,7 @@ static void __devinit quirk_io_region(struct pci_dev *dev, unsigned region,
 		pcibios_bus_to_resource(dev, res, &bus_region);
 
 		pci_claim_resource(dev, nr);
-		dev_info(&dev->dev, "quirk: region %04x-%04x claimed by %s\n", region, region + size - 1, name);
+		dev_info(&dev->dev, "quirk: %pR claimed by %s\n", res, name);
 	}
 }	
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index fd66a89..63544a9 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -84,9 +84,7 @@ void pci_setup_cardbus(struct pci_bus *bus)
 		 * The IO resource is allocated a range twice as large as it
 		 * would normally need.  This allows us to set both IO regs.
 		 */
-		dev_info(&bridge->dev, "  IO window: %#08lx-%#08lx\n",
-		       (unsigned long)region.start,
-		       (unsigned long)region.end);
+		dev_info(&bridge->dev, "  bridge window %pR\n", res);
 		pci_write_config_dword(bridge, PCI_CB_IO_BASE_0,
 					region.start);
 		pci_write_config_dword(bridge, PCI_CB_IO_LIMIT_0,
@@ -96,9 +94,7 @@ void pci_setup_cardbus(struct pci_bus *bus)
 	res = bus->resource[1];
 	pcibios_resource_to_bus(bridge, &region, res);
 	if (res->flags & IORESOURCE_IO) {
-		dev_info(&bridge->dev, "  IO window: %#08lx-%#08lx\n",
-		       (unsigned long)region.start,
-		       (unsigned long)region.end);
+		dev_info(&bridge->dev, "  bridge window %pR\n", res);
 		pci_write_config_dword(bridge, PCI_CB_IO_BASE_1,
 					region.start);
 		pci_write_config_dword(bridge, PCI_CB_IO_LIMIT_1,
@@ -108,9 +104,7 @@ void pci_setup_cardbus(struct pci_bus *bus)
 	res = bus->resource[2];
 	pcibios_resource_to_bus(bridge, &region, res);
 	if (res->flags & IORESOURCE_MEM) {
-		dev_info(&bridge->dev, "  PREFETCH window: %#08lx-%#08lx\n",
-		       (unsigned long)region.start,
-		       (unsigned long)region.end);
+		dev_info(&bridge->dev, "  bridge window %pR\n", res);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_0,
 					region.start);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_LIMIT_0,
@@ -120,9 +114,7 @@ void pci_setup_cardbus(struct pci_bus *bus)
 	res = bus->resource[3];
 	pcibios_resource_to_bus(bridge, &region, res);
 	if (res->flags & IORESOURCE_MEM) {
-		dev_info(&bridge->dev, "  MEM window: %#08lx-%#08lx\n",
-		       (unsigned long)region.start,
-		       (unsigned long)region.end);
+		dev_info(&bridge->dev, "  bridge window %pR\n", res);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_1,
 					region.start);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_LIMIT_1,
@@ -166,15 +158,13 @@ static void pci_setup_bridge(struct pci_bus *bus)
 		l |= region.end & 0xf000;
 		/* Set up upper 16 bits of I/O base/limit. */
 		io_upper16 = (region.end & 0xffff0000) | (region.start >> 16);
-		dev_info(&bridge->dev, "  IO window: %#04lx-%#04lx\n",
-		    (unsigned long)region.start,
-		    (unsigned long)region.end);
+		dev_info(&bridge->dev, "  bridge window %pR\n", res);
 	}
 	else {
 		/* Clear upper 16 bits of I/O base/limit. */
 		io_upper16 = 0;
 		l = 0x00f0;
-		dev_info(&bridge->dev, "  IO window: disabled\n");
+		dev_info(&bridge->dev, "  bridge window [io  disabled]\n");
 	}
 	/* Temporarily disable the I/O range before updating PCI_IO_BASE. */
 	pci_write_config_dword(bridge, PCI_IO_BASE_UPPER16, 0x0000ffff);
@@ -190,13 +180,11 @@ static void pci_setup_bridge(struct pci_bus *bus)
 	if (res->flags & IORESOURCE_MEM) {
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
-		dev_info(&bridge->dev, "  MEM window: %#08lx-%#08lx\n",
-		    (unsigned long)region.start,
-		    (unsigned long)region.end);
+		dev_info(&bridge->dev, "  bridge window %pR\n", res);
 	}
 	else {
 		l = 0x0000fff0;
-		dev_info(&bridge->dev, "  MEM window: disabled\n");
+		dev_info(&bridge->dev, "  bridge window [mem disabled]\n");
 	}
 	pci_write_config_dword(bridge, PCI_MEMORY_BASE, l);
 
@@ -211,22 +199,18 @@ static void pci_setup_bridge(struct pci_bus *bus)
 	res = bus->resource[2];
 	pcibios_resource_to_bus(bridge, &region, res);
 	if (res->flags & IORESOURCE_PREFETCH) {
-		int width = 8;
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
 		if (res->flags & IORESOURCE_MEM_64) {
 			pref_mem64 = 1;
 			bu = upper_32_bits(region.start);
 			lu = upper_32_bits(region.end);
-			width = 16;
 		}
-		dev_info(&bridge->dev, "  PREFETCH window: %#0*llx-%#0*llx\n",
-				width, (unsigned long long)region.start,
-				width, (unsigned long long)region.end);
+		dev_info(&bridge->dev, "  bridge window %pR\n", res);
 	}
 	else {
 		l = 0x0000fff0;
-		dev_info(&bridge->dev, "  PREFETCH window: disabled\n");
+		dev_info(&bridge->dev, "  bridge window [mem pref disabled]\n");
 	}
 	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
 
@@ -408,7 +392,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			align = pci_resource_alignment(dev, r);
 			order = __ffs(align) - 20;
 			if (order > 11) {
-				dev_warn(&dev->dev, "BAR %d bad alignment %llx: "
+				dev_warn(&dev->dev, "BAR %d: bad alignment %llx: "
 					 "%pR\n", i, (unsigned long long)align, r);
 				r->flags = 0;
 				continue;
@@ -600,10 +584,7 @@ static void pci_bus_dump_res(struct pci_bus *bus)
                 if (!res || !res->end)
                         continue;
 
-		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %s %pR\n", i,
-			   (res->flags & IORESOURCE_IO) ? "io: " :
-			    ((res->flags & IORESOURCE_PREFETCH)? "pref mem":"mem:"),
-			   res);
+		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %pR\n", i, res);
         }
 }
 
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index c54526b..a00ae3b 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -91,9 +91,9 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 		}
 	}
 	res->flags &= ~IORESOURCE_UNSET;
-	dev_dbg(&dev->dev, "BAR %d: moved to bus [%#llx-%#llx] flags %#lx\n",
-		resno, (unsigned long long)region.start,
-		(unsigned long long)region.end, res->flags);
+	dev_dbg(&dev->dev, "BAR %d: moved to %pR (PCI address [%#llx-%#llx]\n",
+		resno, res, (unsigned long long)region.start,
+		(unsigned long long)region.end);
 }
 
 int pci_claim_resource(struct pci_dev *dev, int resource)
@@ -181,9 +181,8 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 
 	align = pci_resource_alignment(dev, res);
 	if (!align) {
-		dev_info(&dev->dev, "BAR %d: can't allocate resource (bogus "
-			"alignment) %pR flags %#lx\n",
-			resno, res, res->flags);
+		dev_info(&dev->dev, "BAR %d: can't allocate %pR "
+			 "(bogus alignment)\n", resno, res);
 		return -EINVAL;
 	}
 
@@ -199,8 +198,8 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	}
 
 	if (ret)
-		dev_info(&dev->dev, "BAR %d: can't allocate %s resource %pR\n",
-			resno, res->flags & IORESOURCE_IO ? "I/O" : "mem", res);
+		dev_info(&dev->dev, "BAR %d: can't allocate %pR\n",
+			 resno, res);
 
 	return ret;
 }
@@ -225,9 +224,8 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 
 		r_align = pci_resource_alignment(dev, r);
 		if (!r_align) {
-			dev_warn(&dev->dev, "BAR %d: bogus alignment "
-				"%pR flags %#lx\n",
-				i, r, r->flags);
+			dev_warn(&dev->dev, "BAR %d: %pR has bogus alignment\n",
+				 i, r);
 			continue;
 		}
 		for (list = head; ; list = list->next) {

