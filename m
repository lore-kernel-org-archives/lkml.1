Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbZDVWj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbZDVWj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 18:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbZDVWjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 18:39:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:34626 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbZDVWjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 18:39:15 -0400
Message-ID: <49EF9C10.6090107@kernel.org>
Date: Wed, 22 Apr 2009 15:37:04 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: [RFC PATCH 1/2] pci: don't assume pref memio are 64bit -v3
References: <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <alpine.LFD.2.00.0904181142530.4042@localhost.localdomain> <49EA57C4.1000603@kernel.org> <alpine.LFD.2.00.0904181602030.2199@localhost.localdomain> <alpine.LFD.2.00.0904182149240.2199@localhost.localdomain> <20090419090208.GA30211@elte.hu> <20090419090615.GA30631@elte.hu> <20090420223305.GA15340@jurassic.park.msu.ru> <49ED0EBC.4070901@kernel.org> <20090421105629.GB17904@jurassic.park.msu.ru>
In-Reply-To: <20090421105629.GB17904@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

v2: fix b_res->flags and logic and passing result.
v3: split iomem to iomem32, iomem64, and iomem64 will take IORESOURCE_MEM_64

[Impact: do assign wrong range to device that doesn't support it]


Reported-by: Yannick <yannick.roehlly@free.fr>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/bus.c       |    6 +++
 drivers/pci/probe.c     |   12 +++++--
 drivers/pci/setup-bus.c |   41 ++++++++++++++++++-------
 include/linux/ioport.h  |    4 ++
 init/main.c             |    7 ++++
 kernel/resource.c       |   76 ++++++++++++++++++++++++++++++++++++++----------
 6 files changed, 117 insertions(+), 29 deletions(-)

Index: linux-2.6/drivers/pci/bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/bus.c
+++ linux-2.6/drivers/pci/bus.c
@@ -53,6 +53,12 @@ pci_bus_alloc_resource(struct pci_bus *b
 		if ((res->flags ^ r->flags) & type_mask)
 			continue;
 
+		/* We cannot allocate a mem_32 resource
+		   from a mem_64 area */
+		if ((r->flags & IORESOURCE_MEM_64) &&
+		    !(res->flags & IORESOURCE_MEM_64))
+			continue;
+
 		/* We cannot allocate a non-prefetching resource
 		   from a pre-fetching area */
 		if ((r->flags & IORESOURCE_PREFETCH) &&
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
@@ -1178,7 +1183,8 @@ struct pci_bus * pci_create_bus(struct d
 
 	b->number = b->secondary = bus;
 	b->resource[0] = &ioport_resource;
-	b->resource[1] = &iomem_resource;
+	b->resource[1] = &iomem32_resource;
+	b->resource[2] = &iomem64_resource;
 
 	set_pci_bus_resources_arch_default(b);
 
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
@@ -255,8 +264,11 @@ static void pci_bridge_check_ranges(stru
 		pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &pmem);
 		pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, 0x0);
 	}
-	if (pmem)
+	if (pmem) {
 		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
+		if ((pmem & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64)
+			b_res[2].flags |= IORESOURCE_MEM_64;
+	}
 }
 
 /* Helper function for sizing routines: find first available
@@ -272,7 +284,8 @@ static struct resource *find_free_bus_re
 
 	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
 		r = bus->resource[i];
-		if (r == &ioport_resource || r == &iomem_resource)
+		if (r == &ioport_resource || r == &iomem32_resource
+			|| r == &iomem64_resource)
 			continue;
 		if (r && (r->flags & type_mask) == type && !r->parent)
 			return r;
@@ -336,6 +349,7 @@ static int pbus_size_mem(struct pci_bus
 	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
+	unsigned int mem64_mask = 0;
 
 	if (!b_res)
 		return 0;
@@ -344,9 +358,12 @@ static int pbus_size_mem(struct pci_bus
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
@@ -372,6 +389,7 @@ static int pbus_size_mem(struct pci_bus
 				aligns[order] += align;
 			if (order > max_order)
 				max_order = order;
+			mem64_mask &= r->flags & IORESOURCE_MEM_64;
 		}
 	}
 
@@ -396,6 +414,7 @@ static int pbus_size_mem(struct pci_bus
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
@@ -107,6 +109,8 @@ struct resource_list {
 /* PC/ISA/whatever - the normal PC address spaces: IO and memory */
 extern struct resource ioport_resource;
 extern struct resource iomem_resource;
+extern struct resource iomem32_resource;
+extern struct resource iomem64_resource;
 
 extern int request_resource(struct resource *root, struct resource *new);
 extern int release_resource(struct resource *new);
Index: linux-2.6/kernel/resource.c
===================================================================
--- linux-2.6.orig/kernel/resource.c
+++ linux-2.6/kernel/resource.c
@@ -37,6 +37,20 @@ struct resource iomem_resource = {
 };
 EXPORT_SYMBOL(iomem_resource);
 
+/* need to insert those two under iomem */
+struct resource iomem32_resource = {
+	.name	= "PCI mem 32bit",
+	.start	= 0,
+	.end	= 0xffffffff,
+	.flags	= IORESOURCE_MEM,
+};
+struct resource iomem64_resource = {
+	.name	= "PCI mem 64bit",
+	.start	= 1ULL<<32,
+	.end	= -1,
+	.flags	= IORESOURCE_MEM | IORESOURCE_MEM_64,
+};
+
 static DEFINE_RWLOCK(resource_lock);
 
 static void *r_next(struct seq_file *m, void *v, loff_t *pos)
@@ -200,7 +214,15 @@ int request_resource(struct resource *ro
 	struct resource *conflict;
 
 	write_lock(&resource_lock);
-	conflict = __request_resource(root, new);
+	if (root != &iomem_resource) {
+		conflict = __request_resource(root, new);
+	} else  {
+		/* assume no cross */
+		if (new->start >= (1ULL<<32))
+			conflict = __request_resource(&iomem64_resource, new);
+		else
+			conflict = __request_resource(&iomem32_resource, new);
+	}
 	write_unlock(&resource_lock);
 	return conflict ? -EBUSY : 0;
 }
@@ -437,20 +459,9 @@ int insert_resource(struct resource *par
 	return conflict ? -EBUSY : 0;
 }
 
-/**
- * insert_resource_expand_to_fit - Insert a resource into the resource tree
- * @root: root resource descriptor
- * @new: new resource to insert
- *
- * Insert a resource into the resource tree, possibly expanding it in order
- * to make it encompass any conflicting resources.
- */
-void insert_resource_expand_to_fit(struct resource *root, struct resource *new)
+static void __insert_resource_expand_to_fit(struct resource *root,
+						 struct resource *new)
 {
-	if (new->parent)
-		return;
-
-	write_lock(&resource_lock);
 	for (;;) {
 		struct resource *conflict;
 
@@ -468,6 +479,31 @@ void insert_resource_expand_to_fit(struc
 
 		printk("Expanded resource %s due to conflict with %s\n", new->name, conflict->name);
 	}
+}
+
+/**
+ * insert_resource_expand_to_fit - Insert a resource into the resource tree
+ * @root: root resource descriptor
+ * @new: new resource to insert
+ *
+ * Insert a resource into the resource tree, possibly expanding it in order
+ * to make it encompass any conflicting resources.
+ */
+void insert_resource_expand_to_fit(struct resource *root, struct resource *new)
+{
+	if (new->parent)
+		return;
+
+	write_lock(&resource_lock);
+	if (root != &iomem_resource) {
+		__insert_resource_expand_to_fit(root, new);
+	} else  {
+		/* assume no cross */
+		if (new->start >= (1ULL<<32))
+			__insert_resource_expand_to_fit(&iomem64_resource, new);
+		else
+			__insert_resource_expand_to_fit(&iomem32_resource, new);
+	}
 	write_unlock(&resource_lock);
 }
 
@@ -555,7 +591,17 @@ void __init reserve_region_with_split(st
 		const char *name)
 {
 	write_lock(&resource_lock);
-	__reserve_region_with_split(root, start, end, name);
+	if (root != &iomem_resource) {
+		__reserve_region_with_split(root, start, end, name);
+	} else  {
+		/* assume no cross */
+		if (start >= (1ULL<<32))
+			__reserve_region_with_split(&iomem64_resource, start,
+							 end, name);
+		else
+			__reserve_region_with_split(&iomem32_resource, start,
+							 end, name);
+	}
 	write_unlock(&resource_lock);
 }
 
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -534,6 +534,12 @@ void __init __weak thread_info_cache_ini
 {
 }
 
+static void __init resource_init(void)
+{
+	insert_resource(&iomem_resource, &iomem32_resource);
+	insert_resource(&iomem_resource, &iomem64_resource);
+}
+
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
@@ -569,6 +575,7 @@ asmlinkage void __init start_kernel(void
 	page_address_init();
 	printk(KERN_NOTICE);
 	printk(linux_banner);
+	resource_init();
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);
