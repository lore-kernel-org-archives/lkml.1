Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZDKDbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZDKDbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 23:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZDKDbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 23:31:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:44975 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbZDKDbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 23:31:08 -0400
Message-ID: <49E00E9F.8030605@kernel.org>
Date: Fri, 10 Apr 2009 20:29:35 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: bugzilla-daemon@bugzilla.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [Bug 11103] Can't use framebuffer or vesa Xorg with two memory
 modules
References: <bug-11103-13546@http.bugzilla.kernel.org/> <200904101913.n3AJDhMm018684@demeter.kernel.org> <49DFABCC.3070001@kernel.org>
In-Reply-To: <49DFABCC.3070001@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check

[PATCH] pci: don't assume pref mem io are 64bit

Impact: fix bug with some devices

one system with 4g installed ( there is 1g hole)

when 4G installed.
BIOS put ACPI etc need the hole
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
[    0.000000]  BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e3000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffa0000 (usable)
[    0.000000]  BIOS-e820: 00000000bffa0000 - 00000000bffae000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bffae000 - 00000000bfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
so in kernel resource will be reserved for 0xbffa0000 - 0xbfff0000 for ACPI
0x100000 -  0xbffa0000 for RAM...

and BIOS set
[    0.240007] pci 0000:00:01.0: bridge 64bit mmio pref: [0xbdf00000-0xddefffff]
[    0.237102] pci 0000:01:00.0: reg 10 32bit mmio: [0xc0000000-0xcfffffff]
that is conflict with reserved res. so it can not be reserved Kernel.

then Kernel try to get range from 0x140000000 ( above the RAM, 5G and above 4g)
and set let the bridge to use it, and ATI cards to use it.

but the problem is that ATI only support 32bit ...

we should not assign 64bit range to pci device that only take 32bit pref

try to set PCI_PREF_RANGE_TYPE_64 in 64bit resource of pci_device (besides in pci_bridge),
and make the bus resource only have that bit set when all device under that do support
64bit pref mem
then use that flag to decide the max limit for find/request.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/bus.c       |    8 +++++++-
 drivers/pci/probe.c     |    8 ++++++--
 drivers/pci/setup-bus.c |   38 ++++++++++++++++++++++++++++----------
 3 files changed, 41 insertions(+), 13 deletions(-)

Index: linux-2.6/drivers/pci/bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/bus.c
+++ linux-2.6/drivers/pci/bus.c
@@ -41,9 +41,15 @@ pci_bus_alloc_resource(struct pci_bus *b
 		void *alignf_data)
 {
 	int i, ret = -ENOMEM;
+	resource_size_t max = -1;
 
 	type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
 
+	/* don't allocate too high if the pref mem doesn't support 64bit*/
+	if ((res->flags & (IORESOURCE_PREFETCH | PCI_PREF_RANGE_TYPE_64)) ==
+	    IORESOURCE_PREFETCH)
+		max = 0xffffffff;
+
 	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
 		struct resource *r = bus->resource[i];
 		if (!r)
@@ -62,7 +68,7 @@ pci_bus_alloc_resource(struct pci_bus *b
 		/* Ok, try it out.. */
 		ret = allocate_resource(r, res, size,
 					r->start ? : min,
-					-1, align,
+					max, align,
 					alignf, alignf_data);
 		if (ret == 0)
 			break;
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -193,7 +193,7 @@ int __pci_read_base(struct pci_dev *dev,
 		res->flags |= pci_calc_resource_flags(l) | IORESOURCE_SIZEALIGN;
 		if (type == pci_bar_io) {
 			l &= PCI_BASE_ADDRESS_IO_MASK;
-			mask = PCI_BASE_ADDRESS_IO_MASK & 0xffff;
+			mask = PCI_BASE_ADDRESS_IO_MASK & IO_SPACE_LIMIT;
 		} else {
 			l &= PCI_BASE_ADDRESS_MEM_MASK;
 			mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
@@ -237,6 +237,9 @@ int __pci_read_base(struct pci_dev *dev,
 			dev_printk(KERN_DEBUG, &dev->dev,
 				"reg %x 64bit mmio: %pR\n", pos, res);
 		}
+
+		if (res->flags & IORESOURCE_PREFETCH)
+			res->flags |= PCI_PREF_RANGE_TYPE_64;
 	} else {
 		sz = pci_size(l, sz, mask);
 
@@ -362,7 +365,8 @@ void __devinit pci_read_bridge_bases(str
 		}
 	}
 	if (base <= limit) {
-		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
+		res->flags = (mem_base_lo & PCI_PREF_RANGE_TYPE_MASK) |
+					 IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
 		dev_printk(KERN_DEBUG, &dev->dev, "bridge %sbit mmio pref: %pR\n",
Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -143,6 +143,7 @@ static void pci_setup_bridge(struct pci_
 	struct pci_dev *bridge = bus->self;
 	struct pci_bus_region region;
 	u32 l, bu, lu, io_upper16;
+	int pref_mem64;
 
 	if (pci_is_enabled(bridge))
 		return;
@@ -198,16 +199,22 @@ static void pci_setup_bridge(struct pci_
 	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, 0);
 
 	/* Set up PREF base/limit. */
+	pref_mem64 = 0;
 	bu = lu = 0;
 	pcibios_resource_to_bus(bridge, &region, bus->resource[2]);
 	if (bus->resource[2]->flags & IORESOURCE_PREFETCH) {
+		int width = 8;
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
-		bu = upper_32_bits(region.start);
-		lu = upper_32_bits(region.end);
-		dev_info(&bridge->dev, "  PREFETCH window: %#016llx-%#016llx\n",
-		    (unsigned long long)region.start,
-		    (unsigned long long)region.end);
+		if (bus->resource[2]->flags & PCI_PREF_RANGE_TYPE_64) {
+			pref_mem64 = 1;
+			bu = upper_32_bits(region.start);
+			lu = upper_32_bits(region.end);
+			width = 16;
+		}
+		dev_info(&bridge->dev, "  PREFETCH window: %#0*llx-%#0*llx\n",
+				width, (unsigned long long)region.start,
+				width, (unsigned long long)region.end);
 	}
 	else {
 		l = 0x0000fff0;
@@ -215,9 +222,11 @@ static void pci_setup_bridge(struct pci_
 	}
 	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
 
-	/* Set the upper 32 bits of PREF base & limit. */
-	pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
-	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
+	if (pref_mem64) {
+		/* Set the upper 32 bits of PREF base & limit. */
+		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
+		pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
+	}
 
 	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, bus->bridge_ctl);
 }
@@ -255,8 +264,11 @@ static void pci_bridge_check_ranges(stru
 		pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &pmem);
 		pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, 0x0);
 	}
-	if (pmem)
+	if (pmem) {
 		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
+		if ((pmem & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64)
+			b_res[2].flags |= PCI_PREF_RANGE_TYPE_64;
+	}
 }
 
 /* Helper function for sizing routines: find first available
@@ -336,6 +348,7 @@ static int pbus_size_mem(struct pci_bus
 	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
+	unsigned int mem64_mask = 0;
 
 	if (!b_res)
 		return 0;
@@ -344,6 +357,9 @@ static int pbus_size_mem(struct pci_bus
 	max_order = 0;
 	size = 0;
 
+	if (type & IORESOURCE_PREFETCH)
+		mem64_mask = PCI_PREF_RANGE_TYPE_64;
+
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		int i;
 		
@@ -372,6 +388,8 @@ static int pbus_size_mem(struct pci_bus
 				aligns[order] += align;
 			if (order > max_order)
 				max_order = order;
+			if (r->flags & IORESOURCE_PREFETCH)
+				mem64_mask &= r->flags & PCI_PREF_RANGE_TYPE_64;
 		}
 	}
 
@@ -395,7 +413,7 @@ static int pbus_size_mem(struct pci_bus
 	}
 	b_res->start = min_align;
 	b_res->end = size + min_align - 1;
-	b_res->flags |= IORESOURCE_STARTALIGN;
+	b_res->flags |= IORESOURCE_STARTALIGN | mem64_mask;
 	return 1;
 }
 
