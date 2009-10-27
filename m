Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbZJ0T0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbZJ0T0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756629AbZJ0T0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:26:48 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:38818 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374AbZJ0T0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:26:44 -0400
Subject: [PATCH] vsprintf: use %pR, %pr instead of %pRt, %pRf
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Joe Perches <joe@perches.com>, Len Brown <lenb@kernel.org>
Date: Tue, 27 Oct 2009 13:26:47 -0600
Message-ID: <20091027192647.12712.36043.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse accidentally applied v1 [1] of the patchset instead of v2 [2].  This
is the diff between v1 and v2.

The changes in this patch are:
    - tidied vsprintf stack buffer to shrink and compute size more
      accurately
    - use %pR for decoding and %pr for "raw" (with type and flags) instead
      of adding %pRt and %pRf

[1] http://lkml.org/lkml/2009/10/6/491
[2] http://lkml.org/lkml/2009/10/13/441

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 arch/ia64/pci/pci.c     |   11 ++++---
 arch/x86/pci/acpi.c     |    7 ++--
 arch/x86/pci/i386.c     |   11 ++++---
 drivers/pci/pci.c       |    2 +
 drivers/pci/probe.c     |   17 +++++-----
 drivers/pci/quirks.c    |    2 +
 drivers/pci/setup-bus.c |   79 +++++++++++++++++++++--------------------------
 drivers/pci/setup-res.c |   20 +++++++-----
 drivers/pnp/quirks.c    |    5 ++-
 drivers/pnp/resource.c  |    8 ++---
 drivers/pnp/support.c   |    2 +
 drivers/pnp/system.c    |    2 +
 lib/vsprintf.c          |   55 ++++++++++++++++++---------------
 13 files changed, 114 insertions(+), 107 deletions(-)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index da37801..f24d972 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -293,18 +293,19 @@ static __devinit acpi_status add_window(struct acpi_resource *res, void *data)
 	window->offset = offset;
 
 	if (insert_resource(root, &window->resource)) {
-		dev_err(&info->bridge->dev, "can't allocate %pRt\n",
+		dev_err(&info->bridge->dev,
+			"can't allocate host bridge window %pR\n",
 			&window->resource);
 	} else {
 		if (offset)
-			dev_info(&info->bridge->dev, "host bridge window: %pRt "
+			dev_info(&info->bridge->dev, "host bridge window %pR "
 				 "(PCI address [%#llx-%#llx])\n",
 				 &window->resource,
 				 window->resource.start - offset,
 				 window->resource.end - offset);
 		else
 			dev_info(&info->bridge->dev,
-				 "host bridge window: %pRt\n",
+				 "host bridge window %pR\n",
 				 &window->resource);
 	}
 
@@ -325,7 +326,9 @@ pcibios_setup_root_windows(struct pci_bus *bus, struct pci_controller *ctrl)
 		    (res->end - res->start < 16))
 			continue;
 		if (j >= PCI_BUS_NUM_RESOURCES) {
-			dev_warn(&bus->dev, "ignoring %pRf (no space)\n", res);
+			dev_warn(&bus->dev,
+				 "ignoring host bridge window %pR (no space)\n",
+				 res);
 			continue;
 		}
 		bus->resource[j++] = res;
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 9b3daf9..6bf8091 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -108,18 +108,19 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 	res->child = NULL;
 
 	if (insert_resource(root, res)) {
-		dev_err(&info->bridge->dev, "can't allocate %pRt\n", res);
+		dev_err(&info->bridge->dev,
+			"can't allocate host bridge window %pR\n", res);
 	} else {
 		info->bus->resource[info->res_num] = res;
 		info->res_num++;
 		if (addr.translation_offset)
-			dev_info(&info->bridge->dev, "host bridge window: %pRt "
+			dev_info(&info->bridge->dev, "host bridge window %pR "
 				 "(PCI address [%#llx-%#llx])\n",
 				 res, res->start - addr.translation_offset,
 				 res->end - addr.translation_offset);
 		else
 			dev_info(&info->bridge->dev,
-				 "host bridge window: %pRt\n", res);
+				 "host bridge window %pR\n", res);
 	}
 	return AE_OK;
 }
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 52e656f..d49d17d 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -129,7 +129,7 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 					continue;
 				if (!r->start ||
 				    pci_claim_resource(dev, idx) < 0) {
-					dev_info(&dev->dev, "BAR %d: can't allocate %pRt\n", idx, r);
+					dev_info(&dev->dev, "BAR %d: can't allocate %pR\n", idx, r);
 					/*
 					 * Something is wrong with the region.
 					 * Invalidate the resource to prevent
@@ -164,10 +164,11 @@ static void __init pcibios_allocate_resources(int pass)
 			else
 				disabled = !(command & PCI_COMMAND_MEMORY);
 			if (pass == disabled) {
-				dev_dbg(&dev->dev, "%pRf (d=%d, p=%d)\n", r,
-					disabled, pass);
+				dev_dbg(&dev->dev,
+					"BAR %d: claiming %pr (d=%d, p=%d)\n",
+					idx, r, disabled, pass);
 				if (pci_claim_resource(dev, idx) < 0) {
-					dev_info(&dev->dev, "BAR %d: can't allocate %pRt\n", idx, r);
+					dev_info(&dev->dev, "BAR %d: can't claim %pR\n", idx, r);
 					/* We'll assign a new address later */
 					r->end -= r->start;
 					r->start = 0;
@@ -180,7 +181,7 @@ static void __init pcibios_allocate_resources(int pass)
 				/* Turn the ROM off, leave the resource region,
 				 * but keep it unregistered. */
 				u32 reg;
-				dev_dbg(&dev->dev, "disabling ROM %pRt\n", r);
+				dev_dbg(&dev->dev, "disabling ROM %pR\n", r);
 				r->flags &= ~IORESOURCE_ROM_ENABLE;
 				pci_read_config_dword(dev,
 						dev->rom_base_reg, &reg);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 5572182..f0da167 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1713,7 +1713,7 @@ static int __pci_request_region(struct pci_dev *pdev, int bar, const char *res_n
 	return 0;
 
 err_out:
-	dev_warn(&pdev->dev, "BAR %d: can't reserve %pRt\n", bar,
+	dev_warn(&pdev->dev, "BAR %d: can't reserve %pR\n", bar,
 		 &pdev->resource[bar]);
 	return -EBUSY;
 }
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index bb2cc39..782c258 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -224,12 +224,13 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		if (!sz64)
 			goto fail;
 
-		res->flags |= IORESOURCE_MEM_64;
-
 		if ((sizeof(resource_size_t) < 8) && (sz64 > 0x100000000ULL)) {
 			dev_err(&dev->dev, "can't handle 64-bit BAR\n");
 			goto fail;
-		} else if ((sizeof(resource_size_t) < 8) && l) {
+		}
+
+		res->flags |= IORESOURCE_MEM_64;
+		if ((sizeof(resource_size_t) < 8) && l) {
 			/* Address above 32-bit boundary; disable the BAR */
 			pci_write_config_dword(dev, pos, 0);
 			pci_write_config_dword(dev, pos + 4, 0);
@@ -238,7 +239,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		} else {
 			res->start = l64;
 			res->end = l64 + sz64;
-			dev_printk(KERN_DEBUG, &dev->dev, "reg %x: %pRt\n",
+			dev_printk(KERN_DEBUG, &dev->dev, "reg %x: %pR\n",
 				   pos, res);
 		}
 	} else {
@@ -250,7 +251,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		res->start = l;
 		res->end = l + sz;
 
-		dev_printk(KERN_DEBUG, &dev->dev, "reg %x: %pRt\n", pos, res);
+		dev_printk(KERN_DEBUG, &dev->dev, "reg %x: %pR\n", pos, res);
 	}
 
  out:
@@ -318,7 +319,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		dev_printk(KERN_DEBUG, &dev->dev, "bridge window: %pRt\n", res);
+		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
 	}
 
 	res = child->resource[1];
@@ -330,7 +331,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		dev_printk(KERN_DEBUG, &dev->dev, "bridge window: %pRt\n", res);
+		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
 	}
 
 	res = child->resource[2];
@@ -369,7 +370,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			res->flags |= IORESOURCE_MEM_64;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		dev_printk(KERN_DEBUG, &dev->dev, "bridge window: %pRt\n", res);
+		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
 	}
 }
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 1812ae7..4a20029 100644
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
index 9930583..63544a9 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -71,53 +71,50 @@ static void pbus_assign_resources_sorted(const struct pci_bus *bus)
 void pci_setup_cardbus(struct pci_bus *bus)
 {
 	struct pci_dev *bridge = bus->self;
+	struct resource *res;
 	struct pci_bus_region region;
 
 	dev_info(&bridge->dev, "CardBus bridge, secondary bus %04x:%02x\n",
 		 pci_domain_nr(bus), bus->number);
 
-	pcibios_resource_to_bus(bridge, &region, bus->resource[0]);
-	if (bus->resource[0]->flags & IORESOURCE_IO) {
+	res = bus->resource[0];
+	pcibios_resource_to_bus(bridge, &region, res);
+	if (res->flags & IORESOURCE_IO) {
 		/*
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
 					region.end);
 	}
 
-	pcibios_resource_to_bus(bridge, &region, bus->resource[1]);
-	if (bus->resource[1]->flags & IORESOURCE_IO) {
-		dev_info(&bridge->dev, "  IO window: %#08lx-%#08lx\n",
-		       (unsigned long)region.start,
-		       (unsigned long)region.end);
+	res = bus->resource[1];
+	pcibios_resource_to_bus(bridge, &region, res);
+	if (res->flags & IORESOURCE_IO) {
+		dev_info(&bridge->dev, "  bridge window %pR\n", res);
 		pci_write_config_dword(bridge, PCI_CB_IO_BASE_1,
 					region.start);
 		pci_write_config_dword(bridge, PCI_CB_IO_LIMIT_1,
 					region.end);
 	}
 
-	pcibios_resource_to_bus(bridge, &region, bus->resource[2]);
-	if (bus->resource[2]->flags & IORESOURCE_MEM) {
-		dev_info(&bridge->dev, "  PREFETCH window: %#08lx-%#08lx\n",
-		       (unsigned long)region.start,
-		       (unsigned long)region.end);
+	res = bus->resource[2];
+	pcibios_resource_to_bus(bridge, &region, res);
+	if (res->flags & IORESOURCE_MEM) {
+		dev_info(&bridge->dev, "  bridge window %pR\n", res);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_0,
 					region.start);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_LIMIT_0,
 					region.end);
 	}
 
-	pcibios_resource_to_bus(bridge, &region, bus->resource[3]);
-	if (bus->resource[3]->flags & IORESOURCE_MEM) {
-		dev_info(&bridge->dev, "  MEM window: %#08lx-%#08lx\n",
-		       (unsigned long)region.start,
-		       (unsigned long)region.end);
+	res = bus->resource[3];
+	pcibios_resource_to_bus(bridge, &region, res);
+	if (res->flags & IORESOURCE_MEM) {
+		dev_info(&bridge->dev, "  bridge window %pR\n", res);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_1,
 					region.start);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_LIMIT_1,
@@ -140,6 +137,7 @@ EXPORT_SYMBOL(pci_setup_cardbus);
 static void pci_setup_bridge(struct pci_bus *bus)
 {
 	struct pci_dev *bridge = bus->self;
+	struct resource *res;
 	struct pci_bus_region region;
 	u32 l, bu, lu, io_upper16;
 	int pref_mem64;
@@ -151,23 +149,22 @@ static void pci_setup_bridge(struct pci_bus *bus)
 		 pci_domain_nr(bus), bus->number);
 
 	/* Set up the top and bottom of the PCI I/O segment for this bus. */
-	pcibios_resource_to_bus(bridge, &region, bus->resource[0]);
-	if (bus->resource[0]->flags & IORESOURCE_IO) {
+	res = bus->resource[0];
+	pcibios_resource_to_bus(bridge, &region, res);
+	if (res->flags & IORESOURCE_IO) {
 		pci_read_config_dword(bridge, PCI_IO_BASE, &l);
 		l &= 0xffff0000;
 		l |= (region.start >> 8) & 0x00f0;
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
@@ -178,17 +175,16 @@ static void pci_setup_bridge(struct pci_bus *bus)
 
 	/* Set up the top and bottom of the PCI Memory segment
 	   for this bus. */
-	pcibios_resource_to_bus(bridge, &region, bus->resource[1]);
-	if (bus->resource[1]->flags & IORESOURCE_MEM) {
+	res = bus->resource[1];
+	pcibios_resource_to_bus(bridge, &region, res);
+	if (res->flags & IORESOURCE_MEM) {
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
 
@@ -200,24 +196,21 @@ static void pci_setup_bridge(struct pci_bus *bus)
 	/* Set up PREF base/limit. */
 	pref_mem64 = 0;
 	bu = lu = 0;
-	pcibios_resource_to_bus(bridge, &region, bus->resource[2]);
-	if (bus->resource[2]->flags & IORESOURCE_PREFETCH) {
-		int width = 8;
+	res = bus->resource[2];
+	pcibios_resource_to_bus(bridge, &region, res);
+	if (res->flags & IORESOURCE_PREFETCH) {
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
-		if (bus->resource[2]->flags & IORESOURCE_MEM_64) {
+		if (res->flags & IORESOURCE_MEM_64) {
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
 
@@ -400,7 +393,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			order = __ffs(align) - 20;
 			if (order > 11) {
 				dev_warn(&dev->dev, "BAR %d: bad alignment %llx: "
-					 "%pRt\n", i, (unsigned long long)align, r);
+					 "%pR\n", i, (unsigned long long)align, r);
 				r->flags = 0;
 				continue;
 			}
@@ -591,7 +584,7 @@ static void pci_bus_dump_res(struct pci_bus *bus)
                 if (!res || !res->end)
                         continue;
 
-		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %pRt\n", i, res);
+		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %pR\n", i, res);
         }
 }
 
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 5e78f20..357ca5c 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -51,9 +51,11 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 
 	pcibios_resource_to_bus(dev, &region, res);
 
-	dev_dbg(&dev->dev, "BAR %d: got %pRf (bus addr [%#llx-%#llx])\n",
-		resno, res, (unsigned long long)region.start,
-		(unsigned long long)region.end);
+	dev_dbg(&dev->dev, "BAR %d: got res %pR bus [%#llx-%#llx] "
+		"flags %#lx\n", resno, res,
+		 (unsigned long long)region.start,
+		 (unsigned long long)region.end,
+		 (unsigned long)res->flags);
 
 	new = region.start | (res->flags & PCI_REGION_FLAG_MASK);
 	if (res->flags & IORESOURCE_IO)
@@ -89,8 +91,8 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 		}
 	}
 	res->flags &= ~IORESOURCE_UNSET;
-	dev_dbg(&dev->dev, "BAR %d: moved to bus addr [%#llx-%#llx]\n",
-		resno, (unsigned long long)region.start,
+	dev_dbg(&dev->dev, "BAR %d: moved to %pR (bus addr [%#llx-%#llx])\n",
+		resno, res, (unsigned long long)region.start,
 		(unsigned long long)region.end);
 }
 
@@ -108,7 +110,7 @@ int pci_claim_resource(struct pci_dev *dev, int resource)
 
 	if (err) {
 		const char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
-		dev_err(&dev->dev, "BAR %d: %s %s %pRt\n",
+		dev_err(&dev->dev, "BAR %d: %s of %s %pR\n",
 			resource,
 			root ? "address space collision on" :
 				"no parent found for",
@@ -179,7 +181,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 
 	align = pci_resource_alignment(dev, res);
 	if (!align) {
-		dev_info(&dev->dev, "BAR %d: can't allocate %pRf "
+		dev_info(&dev->dev, "BAR %d: can't allocate %pR "
 			 "(bogus alignment)\n", resno, res);
 		return -EINVAL;
 	}
@@ -196,7 +198,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	}
 
 	if (ret)
-		dev_info(&dev->dev, "BAR %d: can't allocate %pRt\n",
+		dev_info(&dev->dev, "BAR %d: can't allocate %pR\n",
 			 resno, res);
 
 	return ret;
@@ -222,7 +224,7 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 
 		r_align = pci_resource_alignment(dev, r);
 		if (!r_align) {
-			dev_warn(&dev->dev, "BAR %d: bogus alignment %pRf\n",
+			dev_warn(&dev->dev, "BAR %d: %pR has bogus alignment\n",
 				 i, r);
 			continue;
 		}
diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 3a2031b..dfbd5a6 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -285,8 +285,9 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 				 * the PCI region, and that might prevent a PCI
 				 * driver from requesting its resources.
 				 */
-				dev_warn(&dev->dev, "resource %pRt overlaps %s "
-					 "BAR %d %pRt, disabling\n", res,
+				dev_warn(&dev->dev,
+					 "disabling %pR because it overlaps "
+					 "%s BAR %d %pR\n", res,
 					 pci_name(pdev), i, &pdev->resource[i]);
 				res->flags |= IORESOURCE_DISABLED;
 			}
diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index 18557d7..64d0596 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -517,7 +517,7 @@ struct pnp_resource *pnp_add_irq_resource(struct pnp_dev *dev, int irq,
 	res->start = irq;
 	res->end = irq;
 
-	pnp_dbg(&dev->dev, "  add %pRf\n", res);
+	pnp_dbg(&dev->dev, "  add %pr\n", res);
 	return pnp_res;
 }
 
@@ -538,7 +538,7 @@ struct pnp_resource *pnp_add_dma_resource(struct pnp_dev *dev, int dma,
 	res->start = dma;
 	res->end = dma;
 
-	pnp_dbg(&dev->dev, "  add %pRf\n", res);
+	pnp_dbg(&dev->dev, "  add %pr\n", res);
 	return pnp_res;
 }
 
@@ -562,7 +562,7 @@ struct pnp_resource *pnp_add_io_resource(struct pnp_dev *dev,
 	res->start = start;
 	res->end = end;
 
-	pnp_dbg(&dev->dev, "  add %pRf\n", res);
+	pnp_dbg(&dev->dev, "  add %pr\n", res);
 	return pnp_res;
 }
 
@@ -586,7 +586,7 @@ struct pnp_resource *pnp_add_mem_resource(struct pnp_dev *dev,
 	res->start = start;
 	res->end = end;
 
-	pnp_dbg(&dev->dev, "  add %pRf\n", res);
+	pnp_dbg(&dev->dev, "  add %pr\n", res);
 	return pnp_res;
 }
 
diff --git a/drivers/pnp/support.c b/drivers/pnp/support.c
index 1f8a33b..9585c1c 100644
--- a/drivers/pnp/support.c
+++ b/drivers/pnp/support.c
@@ -82,7 +82,7 @@ void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
 	else {
 		pnp_dbg(&dev->dev, "%s: current resources:\n", desc);
 		list_for_each_entry(pnp_res, &dev->resources, list)
-			pnp_dbg(&dev->dev, "%pRf\n", &pnp_res->res);
+			pnp_dbg(&dev->dev, "%pr\n", &pnp_res->res);
 	}
 }
 
diff --git a/drivers/pnp/system.c b/drivers/pnp/system.c
index 242d3a8..49c1720 100644
--- a/drivers/pnp/system.c
+++ b/drivers/pnp/system.c
@@ -48,7 +48,7 @@ static void reserve_range(struct pnp_dev *dev, struct resource *r, int port)
 	 * example do reserve stuff they know about too, so we may well
 	 * have double reservations.
 	 */
-	dev_info(&dev->dev, "%pRt %s reserved\n", r,
+	dev_info(&dev->dev, "%pR %s reserved\n", r,
 		 res ? "has been" : "could not be");
 }
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index a6e1951..6438cd5 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -624,13 +624,19 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 		.precision = -1,
 		.flags = SPECIAL | SMALL,
 	};
-	/*
-	 * room for three actual numbers (decimal or hex), plus
-	 * "[mem 0x-0x 64bit pref disabled flags 0x]\0"
-	 */
-	char sym[3*3*sizeof(resource_size_t) + 41];
+
+	/* 32-bit res (sizeof==4): 10 chars in dec, 10 in hex ("0x" + 8)
+	 * 64-bit res (sizeof==8): 20 chars in dec, 18 in hex ("0x" + 16) */
+#define RSRC_BUF_SIZE		((2 * sizeof(resource_size_t)) + 4)
+#define FLAG_BUF_SIZE		(2 * sizeof(res->flags))
+#define DECODED_BUF_SIZE	sizeof("[mem - 64bit pref disabled]")
+#define RAW_BUF_SIZE		sizeof("[mem - flags 0x]")
+	char sym[max(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
+		     2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
+
 	char *p = sym, *pend = sym + sizeof(sym);
 	int size = -1, addr = 0;
+	int decode = (fmt[0] == 'R') ? 1 : 0;
 
 	if (res->flags & IORESOURCE_IO) {
 		size = IO_RSRC_PRINTK_SIZE;
@@ -641,15 +647,17 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 	}
 
 	*p++ = '[';
-	if (fmt[1] == 't' || fmt[1] == 'f') {
-		if (res->flags & IORESOURCE_IO)
-			p = string(p, pend, "io  ", str_spec);
-		else if (res->flags & IORESOURCE_MEM)
-			p = string(p, pend, "mem ", str_spec);
-		else if (res->flags & IORESOURCE_IRQ)
-			p = string(p, pend, "irq ", str_spec);
-		else if (res->flags & IORESOURCE_DMA)
-			p = string(p, pend, "dma ", str_spec);
+	if (res->flags & IORESOURCE_IO)
+		p = string(p, pend, "io  ", str_spec);
+	else if (res->flags & IORESOURCE_MEM)
+		p = string(p, pend, "mem ", str_spec);
+	else if (res->flags & IORESOURCE_IRQ)
+		p = string(p, pend, "irq ", str_spec);
+	else if (res->flags & IORESOURCE_DMA)
+		p = string(p, pend, "dma ", str_spec);
+	else {
+		p = string(p, pend, "??? ", str_spec);
+		decode = 0;
 	}
 	hex_spec.field_width = size;
 	p = number(p, pend, res->start, addr ? hex_spec : dec_spec);
@@ -657,21 +665,19 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 		*p++ = '-';
 		p = number(p, pend, res->end, addr ? hex_spec : dec_spec);
 	}
-	if (fmt[1] == 't' || fmt[1] == 'f') {
+	if (decode) {
 		if (res->flags & IORESOURCE_MEM_64)
 			p = string(p, pend, " 64bit", str_spec);
 		if (res->flags & IORESOURCE_PREFETCH)
 			p = string(p, pend, " pref", str_spec);
 		if (res->flags & IORESOURCE_DISABLED)
 			p = string(p, pend, " disabled", str_spec);
-		if (fmt[1] == 'f') {
-			p = string(p, pend, " flags ", str_spec);
-			p = number(p, pend, res->flags & ~IORESOURCE_TYPE_BITS,
-				   flag_spec);
-		}
+	} else {
+		p = string(p, pend, " flags ", str_spec);
+		p = number(p, pend, res->flags, flag_spec);
 	}
 	*p++ = ']';
-	*p = 0;
+	*p = '\0';
 
 	return string(buf, end, sym, spec);
 }
@@ -847,10 +853,8 @@ static char *ip4_addr_string(char *buf, char *end, const u8 *addr,
  * - 'f' For simple symbolic function names without offset
  * - 'S' For symbolic direct pointers with offset
  * - 's' For symbolic direct pointers without offset
- * - 'R' For a struct resource pointer, print:
- *       R   address range only ([0x0-0x1f])
- *       Rt  type and range ([mem 0x0-0x1f 64bit pref])
- *       Rf  type, range, and flags ([mem 0x0-0x1f 64bit pref flags 0x1])
+ * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
+ * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
  * - 'M' For a 6-byte MAC address, it prints the address in the
  *       usual colon-separated hex notation
  * - 'm' For a 6-byte MAC address, it prints the hex address without colons
@@ -881,6 +885,7 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	case 'S':
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
+	case 'r':
 		return resource_string(buf, end, ptr, spec, fmt);
 	case 'M':			/* Colon separated: 00:01:02:03:04:05 */
 	case 'm':			/* Contiguous: 000102030405 */

