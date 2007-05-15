Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbXEOWj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbXEOWj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 18:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbXEOWjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 18:39:20 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:4396 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838AbXEOWjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 18:39:19 -0400
Date: Wed, 16 May 2007 02:39:53 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Adam Jackson <ajackson@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: PCI bridge range sizing bug
Message-ID: <20070516023953.A7394@jurassic.park.msu.ru>
References: <1175812632.17147.12.camel@localhost.localdomain> <alpine.LFD.0.98.0704201102000.9964@woody.linux-foundation.org> <20070421003020.A21503@jurassic.park.msu.ru> <200705141045.44059.jesse.barnes@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <200705141045.44059.jesse.barnes@intel.com>; from jesse.barnes@intel.com on Mon, May 14, 2007 at 10:45:43AM -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 10:45:43AM -0700, Jesse Barnes wrote:
> Any update on this, Ivan?  Maybe I missed your post, but I haven't seen 
> anything yet...

No, I didn't post anything, sorry. This turned out to be not as trivial
as I thought - I've played with that code on amd64, and results were rather
discouraging. For example, I forced reassignment of video card resources
and initially this failed because of the way how pci/setup-* allocates ROM
addresses: ROMs are obviously prefetchable, so we're always trying to put
them in prefetchable windows of the bridge. Technically, this is correct,
but leads to the waste of PCI address space due to size/alignment
requirements, especially when ROM is assigned to the same window as
a prefetchable framebuffer resource (typically 64-256M).
On the other hand, we could allocate ROMs in non-prefetch ranges just
for free, as minimal memory window of the bridges is 1M and both MMIO
register blocks and ROMs are usually much smaller. 
Probably we need some global variable to control this (and some other things)
in pci/setup-*, just like pci_probe on i386...

Another funny thing found on x86_64 - if we ran out of PCI address space 
below 4G, resources get happily assigned above 4G, even if respective BARs
are 32-bit.

Anyway, here's what I have so far, though I doubt that it's a breakthrough
for Adam...

Ivan.

--- orig/arch/i386/pci/common.c	Sat Apr 21 21:55:30 2007
+++ linux/arch/i386/pci/common.c	Sat Apr 21 21:55:33 2007
@@ -290,6 +290,12 @@ static struct dmi_system_id __devinitdat
 	{}
 };
 
+static struct resource pci_mem32 = {
+	.name	= "PCI 32-bit memory space",
+	.end	= 0xffffffff,
+	.flags	= IORESOURCE_MEM,
+};
+
 struct pci_bus * __devinit pcibios_scan_root(int busnum)
 {
 	struct pci_bus *bus = NULL;
@@ -305,7 +311,13 @@ struct pci_bus * __devinit pcibios_scan_
 
 	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x)\n", busnum);
 
-	return pci_scan_bus_parented(NULL, busnum, &pci_root_ops, NULL);
+	bus = pci_scan_bus_parented(NULL, busnum, &pci_root_ops, NULL);
+	if (bus && bus->resource[1] == &iomem_resource) {
+		pci_mem32.start = pci_mem_start;
+		if (insert_resource(&iomem_resource, &pci_mem32) == 0)
+			bus->resource[1] = &pci_mem32;
+	}
+	return bus;
 }
 
 extern u8 pci_cache_line_size;
@@ -418,6 +418,9 @@ char * __devinit  pcibios_setup(char *st
 	} else if (!strcmp(str, "routeirq")) {
 		pci_routeirq = 1;
 		return NULL;
+	} else if (!strcmp(str, "assign-bus-resources")) {
+		pci_probe |= PCI_ASSIGN_BUS_RESOURCES;
+		return NULL;
 	}
 	return str;
 }
--- orig/arch/i386/pci/pci.h	Sat Apr 21 21:55:30 2007
+++ linux/arch/i386/pci/pci.h	Sat Apr 21 21:55:33 2007
@@ -26,6 +26,7 @@
 #define PCI_ASSIGN_ROMS		0x1000
 #define PCI_BIOS_IRQ_SCAN	0x2000
 #define PCI_ASSIGN_ALL_BUSSES	0x4000
+#define PCI_ASSIGN_BUS_RESOURCES	0x8000
 
 extern unsigned int pci_probe;
 extern unsigned long pirq_table_addr;
--- orig/arch/i386/pci/i386.c	Sat Apr 21 21:55:30 2007
+++ linux/arch/i386/pci/i386.c	Sat Apr 21 21:56:39 2007
@@ -60,6 +60,67 @@ pcibios_align_resource(void *data, struc
 	}
 }
 
+static int __init
+pcibios_estimate_bus_space(struct pci_dev *bridge, resource_size_t *mem,
+			   resource_size_t *pref)
+{
+	int i;
+	struct resource *r;
+	struct pci_dev *dev;
+
+	if (!bridge->subordinate ||
+	    (bridge->class >> 8) != PCI_CLASS_BRIDGE_PCI)
+		return 0;
+	list_for_each_entry(dev, &bridge->subordinate->devices, bus_list) {
+		for (i = 0; i <= PCI_ROM_RESOURCE; i++) {
+			r = &dev->resource[i];
+			if (r->flags & IORESOURCE_PREFETCH)
+				*pref += r->end + 1 - r->start;
+			else if (r->flags & IORESOURCE_MEM)
+				*mem += r->end + 1 - r->start;
+		}
+		pcibios_estimate_bus_space(dev, mem, pref);
+	}
+	return 1;
+}
+
+static void __init
+pcibios_validate_bus_ranges(struct pci_dev *bridge)
+{
+	resource_size_t memory = 0, prefetch = 0, bridge_mem, bridge_pref;
+	struct resource *bmem = &bridge->resource[PCI_BRIDGE_RESOURCES + 1];
+	struct resource *bpref = &bridge->resource[PCI_BRIDGE_RESOURCES + 2];
+
+	if (!(pci_probe & PCI_ASSIGN_BUS_RESOURCES) ||
+	    !pcibios_estimate_bus_space(bridge, &memory, &prefetch))
+		return;
+	bridge_mem = bmem->end + 1 - bmem->start;
+	bridge_pref = bpref->end + 1 - bpref->start;
+	/* First, check if bridge memory window can hold all the memory
+	   resources on the secondary buses. */
+	if (bridge_mem >= memory) {
+		/* Yes, it seems to be large enough and probably can hold
+		   [some of] prefetchable memory also. */
+		if (bridge_mem - memory < prefetch)
+			prefetch -= bridge_mem - memory;
+		else
+			prefetch = 0;
+	} else {
+		printk(KERN_INFO "PCI: MEM window of bridge %s too small "
+		       "(%llx, at least %llx required), will be reassigned\n",
+		       pci_name(bridge), (unsigned long long)bridge_mem,
+		       (unsigned long long)memory);
+		bmem->flags = 0;
+	}
+	/* Check the prefetchable memory window. */
+	if (bridge_pref < prefetch) {
+		printk(KERN_INFO "PCI: PREFETCH window of bridge %s too small, "
+		       "(%llx, at least %llx required), will be reassigned\n",
+		       pci_name(bridge), (unsigned long long)bridge_pref,
+		       (unsigned long long)prefetch);
+		bpref->flags = 0;
+	}
+}
 
 /*
  *  Handle resources of PCI devices.  If the world were perfect, we could
@@ -104,6 +165,7 @@ static void __init pcibios_allocate_bus_
 	/* Depth-First Search on bus tree */
 	list_for_each_entry(bus, bus_list, node) {
 		if ((dev = bus->self)) {
+			pcibios_validate_bus_ranges(dev);
 			for (idx = PCI_BRIDGE_RESOURCES;
 			    idx < PCI_NUM_RESOURCES; idx++) {
 				r = &dev->resource[idx];
--- orig/drivers/pci/setup-bus.c	Tue Apr 10 11:33:39 2007
+++ linux/drivers/pci/setup-bus.c	Sat Apr 21 19:56:28 2007
@@ -347,9 +347,12 @@ pbus_size_mem(struct pci_bus *bus, unsig
 		
 		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
 			struct resource *r = &dev->resource[i];
-			unsigned long r_size;
+			unsigned long r_size, r_flags = r->flags;
 
-			if (r->parent || (r->flags & mask) != type)
+			if (i == PCI_ROM_RESOURCE)
+				r_flags &= ~IORESOURCE_PREFETCH;
+
+			if (r->parent || (r_flags & mask) != type)
 				continue;
 			r_size = r->end - r->start + 1;
 			/* For bridges size != alignment */
