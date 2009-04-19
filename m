Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbZDSF3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbZDSF3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 01:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZDSF27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 01:28:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:43697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbZDSF25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 01:28:57 -0400
Message-ID: <49EAB60C.3010606@kernel.org>
Date: Sat, 18 Apr 2009 22:26:36 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>, yannick.roehlly@free.fr
CC: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
References: <49E00E9F.8030605@kernel.org> <49E4F6D6.6030709@kernel.org> <49E4F71F.10107@kernel.org> <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain> <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <alpine.LFD.2.00.0904181142530.4042@localhost.localdomain> <49EA57C4.1000603@kernel.org> <alpine.LFD.2.00.0904181602030.2199@localhost.localdomain> <alpine.LFD.2.00.0904182149240.2199@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904182149240.2199@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------040206040601030400000805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040206040601030400000805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> 
> On Sat, 18 Apr 2009, Linus Torvalds wrote:
>> And that _is_ a really odd hole. I wonder what it is all about. But the 
>> approach does seem to have done the right thing.
> 
> I'll commit the reserve_region_with_split() change. There are no actual 
> users of it now, so committing that change doesn't really do anything, but 
> I like removing code, and with the only current potential user actively 
> wanting just the simpler behavior, why keep the code around?
> 
sure.

yannick, can you check attached three patches on linus tree?
like
http://people.redhat.com/mingo/tip.git/readme.txt
and
git checkout -b linus_2009_04_18 linus/master

YH

--------------040206040601030400000805
Content-Type: text/x-patch;
 name="pci_start_linus.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pci_start_linus.patch"

From: Linus Torvalds <torvalds@linux-foundation.org>

[PATCH] x86: reserve range near the ram

Impact: protect stolen RAM

The point is to take all RAM resources we have, and 
_after_ we've added all the resources we've seen in the E820 tree, we then 
_also_ try to add fake reserved entries for any "round up to X" at the end 
of the RAM resources.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1370,6 +1370,23 @@ void __init e820_reserve_resources(void)
 	}
 }
 
+/* How much should we pad RAM ending depending on where it is? */
+static unsigned long ram_alignment(resource_size_t pos)
+{
+	unsigned long mb = pos >> 20;
+
+	/* To 64kB in the first megabyte */
+	if (!mb)
+		return 64*1024;
+
+	/* To 1MB in the first 16MB */
+	if (mb < 16)
+		return 1024*1024;
+
+	/* To 32MB for anything above that */
+	return 32*1024*1024;
+}
+
 void __init e820_reserve_resources_late(void)
 {
 	int i;
@@ -1381,6 +1398,24 @@ void __init e820_reserve_resources_late(
 			insert_resource_expand_to_fit(&iomem_resource, res);
 		res++;
 	}
+
+	/*
+	 * Try to bump up RAM regions to reasonable boundaries to
+	 * avoid stolen RAM
+	 */
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *entry = &e820_saved.map[i];
+		resource_size_t start, end;
+
+		if (entry->type != E820_RAM)
+			continue;
+		start = entry->addr + entry->size;
+		end = round_up(start, ram_alignment(start));
+		if (start == end)
+			continue;
+		reserve_region_with_split(&iomem_resource, start, end -1,
+						 "RAM buffer");
+	}
 }
 
 char *__init default_machine_specific_memory_setup(void)

--------------040206040601030400000805
Content-Type: text/x-patch;
 name="pci_start_x.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pci_start_x.patch"

[PATCH] x86/pci: make pci_mem_start to be aligned only -v5

don't need to reserved one round after the gapstart.

because have round up in via e820_reserve_stolen_ram already.

[Impact: make more big space below 4g for assigning to unassigned pci devices]

Reported-by: Yannick <yannick.roehlly@free.fr>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -617,7 +617,7 @@ __init int e820_search_gap(unsigned long
  */
 __init void e820_setup_gap(void)
 {
-	unsigned long gapstart, gapsize, round;
+	unsigned long gapstart, gapsize;
 	int found;
 
 	gapstart = 0x10000000;
@@ -635,14 +635,9 @@ __init void e820_setup_gap(void)
 #endif
 
 	/*
-	 * See how much we want to round up: start off with
-	 * rounding to the next 1MB area.
+	 * e820_reserve_stolen_ram protect stolen RAM already
 	 */
-	round = 0x100000;
-	while ((gapsize >> 4) > round)
-		round += round;
-	/* Fun with two's complement */
-	pci_mem_start = (gapstart + round) & -round;
+	pci_mem_start = gapstart;
 
 	printk(KERN_INFO
 	       "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",

--------------040206040601030400000805
Content-Type: text/x-patch;
 name="pref_mem_32bit_v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pref_mem_32bit_v2.patch"

[PATCH 2/3] pci: don't assume pref memio are 64bit -v2

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

[Impact: do assign wrong range to device that doesn't support it]

v2: fix b_res->flags and logic and passing result.

Reported-and-tested-by: Yannick <yannick.roehlly@free.fr>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/bus.c       |    8 +++++++-
 drivers/pci/probe.c     |    8 ++++++--
 drivers/pci/setup-bus.c |   40 +++++++++++++++++++++++++++++++---------
 3 files changed, 44 insertions(+), 12 deletions(-)

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
@@ -344,6 +357,11 @@ static int pbus_size_mem(struct pci_bus
 	max_order = 0;
 	size = 0;
 
+	if (type & IORESOURCE_PREFETCH) {
+		mem64_mask = b_res->flags & PCI_PREF_RANGE_TYPE_64;
+		b_res->flags &= ~PCI_PREF_RANGE_TYPE_64;
+	}
+
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		int i;
 		
@@ -372,6 +390,8 @@ static int pbus_size_mem(struct pci_bus
 				aligns[order] += align;
 			if (order > max_order)
 				max_order = order;
+			if (r->flags & IORESOURCE_PREFETCH)
+				mem64_mask &= r->flags & PCI_PREF_RANGE_TYPE_64;
 		}
 	}
 
@@ -396,6 +416,8 @@ static int pbus_size_mem(struct pci_bus
 	b_res->start = min_align;
 	b_res->end = size + min_align - 1;
 	b_res->flags |= IORESOURCE_STARTALIGN;
+	if (type & IORESOURCE_PREFETCH)
+		b_res->flags |= mem64_mask;
 	return 1;
 }
 

--------------040206040601030400000805--
