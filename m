Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbZDXDvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbZDXDvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 23:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZDXDuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 23:50:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:35438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZDXDuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 23:50:51 -0400
Message-ID: <49F13690.3080902@kernel.org>
Date: Thu, 23 Apr 2009 20:48:32 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: [PATCH 1/4] pci/x86: don't assume pref memio are 64bit -v4
References: <20090420223305.GA15340@jurassic.park.msu.ru> <49ED0EBC.4070901@kernel.org> <20090421105629.GB17904@jurassic.park.msu.ru> <49EF9C10.6090107@kernel.org> <20090422154900.08f8f366@hobbes> <49EFBB0E.3030401@kernel.org> <20090422180505.2518e837@hobbes> <49EFCE15.3030605@kernel.org> <20090423132202.GB13984@jurassic.park.msu.ru> <49F08580.9050407@kernel.org> <20090423221936.GA24171@jurassic.park.msu.ru>
In-Reply-To: <20090423221936.GA24171@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we should not assign 64bit range to pci device that only take 32bit pref

try to set IORESOURCE_MEM_64 in 64bit resource of pci_device/pci_bridge
and make the bus resource only have that bit set when all device under that do support
64bit pref mem then use that flag to allocate resource in wanted area

v2: fix b_res->flags and logic and passing result.
v3: split iomem to iomem32, iomem64, and iomem64 will take IORESOURCE_MEM_64
V4: according to Ivan
    make it support x86 only, by PCIBIOS_MAX_MEM_32
    double check if the bridge does support pref mem64 with write/read UPPER32

[Impact: do assign wrong range to device that doesn't support it]

Reported-by: Yannick <yannick.roehlly@free.fr>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/pci.h |    1 
 drivers/pci/bus.c          |    7 +++++-
 drivers/pci/probe.c        |    9 ++++++-
 drivers/pci/setup-bus.c    |   52 ++++++++++++++++++++++++++++++++++++---------
 include/linux/ioport.h     |    2 +
 include/linux/pci.h        |    4 +++
 6 files changed, 62 insertions(+), 13 deletions(-)

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
@@ -237,6 +237,8 @@ int __pci_read_base(struct pci_dev *dev,
 			dev_printk(KERN_DEBUG, &dev->dev,
 				"reg %x 64bit mmio: %pR\n", pos, res);
 		}
+
+		res->flags |= IORESOURCE_MEM_64;
 	} else {
 		sz = pci_size(l, sz, mask);
 
@@ -362,7 +364,10 @@ void __devinit pci_read_bridge_bases(str
 		}
 	}
 	if (base <= limit) {
-		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
+		res->flags = (mem_base_lo & PCI_PREF_RANGE_TYPE_MASK) |
+					 IORESOURCE_MEM | IORESOURCE_PREFETCH;
+		if (res->flags & PCI_PREF_RANGE_TYPE_64)
+			res->flags |= IORESOURCE_MEM_64;
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
+		if (bus->resource[2]->flags & IORESOURCE_MEM_64) {
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
@@ -255,8 +264,25 @@ static void pci_bridge_check_ranges(stru
 		pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &pmem);
 		pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, 0x0);
 	}
-	if (pmem)
+	if (pmem) {
 		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
+		if ((pmem & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64)
+			b_res[2].flags |= IORESOURCE_MEM_64;
+	}
+
+	/* double check if bridge does support 64 bit pref */
+	if (b_res[2].flags & IORESOURCE_MEM_64) {
+		u32 mem_base_hi, tmp;
+		pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32,
+					 &mem_base_hi);
+		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
+					       0xffffffff);
+		pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32, &tmp);
+		if (!tmp)
+			b_res[2].flags &= ~IORESOURCE_MEM_64;
+		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
+				       mem_base_hi);
+	}
 }
 
 /* Helper function for sizing routines: find first available
@@ -336,6 +362,7 @@ static int pbus_size_mem(struct pci_bus
 	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
+	unsigned int mem64_mask = 0;
 
 	if (!b_res)
 		return 0;
@@ -344,9 +371,12 @@ static int pbus_size_mem(struct pci_bus
 	max_order = 0;
 	size = 0;
 
+	mem64_mask = b_res->flags & IORESOURCE_MEM_64;
+	b_res->flags &= ~IORESOURCE_MEM_64;
+
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		int i;
-		
+
 		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
 			struct resource *r = &dev->resource[i];
 			resource_size_t r_size;
@@ -372,6 +402,7 @@ static int pbus_size_mem(struct pci_bus
 				aligns[order] += align;
 			if (order > max_order)
 				max_order = order;
+			mem64_mask &= r->flags & IORESOURCE_MEM_64;
 		}
 	}
 
@@ -396,6 +427,7 @@ static int pbus_size_mem(struct pci_bus
 	b_res->start = min_align;
 	b_res->end = size + min_align - 1;
 	b_res->flags |= IORESOURCE_STARTALIGN;
+	b_res->flags |= mem64_mask;
 	return 1;
 }
 
Index: linux-2.6/include/linux/ioport.h
===================================================================
--- linux-2.6.orig/include/linux/ioport.h
+++ linux-2.6/include/linux/ioport.h
@@ -49,6 +49,8 @@ struct resource_list {
 #define IORESOURCE_SIZEALIGN	0x00020000	/* size indicates alignment */
 #define IORESOURCE_STARTALIGN	0x00040000	/* start field is alignment */
 
+#define IORESOURCE_MEM_64	0x00100000
+
 #define IORESOURCE_EXCLUSIVE	0x08000000	/* Userland may not map this resource */
 #define IORESOURCE_DISABLED	0x10000000
 #define IORESOURCE_UNSET	0x20000000
Index: linux-2.6/drivers/pci/bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/bus.c
+++ linux-2.6/drivers/pci/bus.c
@@ -41,9 +41,14 @@ pci_bus_alloc_resource(struct pci_bus *b
 		void *alignf_data)
 {
 	int i, ret = -ENOMEM;
+	resource_size_t max = -1;
 
 	type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
 
+	/* don't allocate too high if the pref mem doesn't support 64bit*/
+	if (!(res->flags & IORESOURCE_MEM_64))
+		max = PCIBIOS_MAX_MEM_32;
+
 	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
 		struct resource *r = bus->resource[i];
 		if (!r)
@@ -62,7 +67,7 @@ pci_bus_alloc_resource(struct pci_bus *b
 		/* Ok, try it out.. */
 		ret = allocate_resource(r, res, size,
 					r->start ? : min,
-					-1, align,
+					max, align,
 					alignf, alignf_data);
 		if (ret == 0)
 			break;
Index: linux-2.6/arch/x86/include/asm/pci.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pci.h
+++ linux-2.6/arch/x86/include/asm/pci.h
@@ -130,6 +130,7 @@ extern void pci_iommu_alloc(void);
 
 /* generic pci stuff */
 #include <asm-generic/pci.h>
+#define PCIBIOS_MAX_MEM_32 0xffffffff
 
 #ifdef CONFIG_NUMA
 /* Returns the node based on pci bus */
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -1100,6 +1100,10 @@ static inline struct pci_dev *pci_get_bu
 
 #include <asm/pci.h>
 
+#ifndef PCIBIOS_MAX_MEM_32
+#define PCIBIOS_MAX_MEM_32 (-1)
+#endif
+
 /* these helpers provide future and backwards compatibility
  * for accessing popular PCI BAR info */
 #define pci_resource_start(dev, bar)	((dev)->resource[(bar)].start)
