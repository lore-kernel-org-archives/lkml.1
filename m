Return-Path: <linux-kernel-owner+w=401wt.eu-S1762241AbYC0WTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762241AbYC0WTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 18:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761574AbYC0WS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 18:18:57 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:38050 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759921AbYC0WS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 18:18:56 -0400
Date: Fri, 28 Mar 2008 01:18:51 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
Message-ID: <20080327221851.GA9675@jurassic.park.msu.ru>
References: <20080326135458.GA27621@elte.hu> <20080326180701.GA6249@us.ibm.com> <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org> <20080326203012.GB6249@us.ibm.com> <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org> <20080326205828.GA15225@jurassic.park.msu.ru> <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org> <20080326232922.GA15784@jurassic.park.msu.ru> <alpine.LFD.1.00.0803261638350.2775@woody.linux-foundation.org> <alpine.LFD.1.00.0803271004380.2775@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803271004380.2775@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 10:12:10AM -0700, Linus Torvalds wrote:
> Actually, before we go any further, there might be a less intrusive 
> alternative: add just a couple of flags to the resource flags field (we 
> still have something like 8 unused bits on 32-bit), and use those to 
> implement a generic "resource_alignment()" routine.
> 
> Two flags would do it:
> 
>  - IORESOURCE_SIZEALIGN: size indicates alignment (regular PCI device 
>    resources)
> 
>  - IORESOURCE_STARTALIGN: start field is alignment (PCI bus resources 
>    during probing)

Sounds good to me. So here we go (completely untested, just for review).

Ivan.

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 2db2e4b..152ffa2 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -225,7 +225,7 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 			res->flags |= l & ~PCI_BASE_ADDRESS_IO_MASK;
 		}
 		res->end = res->start + (unsigned long) sz;
-		res->flags |= pci_calc_resource_flags(l);
+		res->flags |= pci_calc_resource_flags(l) | IORESOURCE_SIZEALIGN;
 		if (is_64bit_memory(l)) {
 			u32 szhi, lhi;
 
@@ -278,7 +278,8 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 			if (sz) {
 				res->flags = (l & IORESOURCE_ROM_ENABLE) |
 				  IORESOURCE_MEM | IORESOURCE_PREFETCH |
-				  IORESOURCE_READONLY | IORESOURCE_CACHEABLE;
+				  IORESOURCE_READONLY | IORESOURCE_CACHEABLE |
+				  IORESOURCE_SIZEALIGN;
 				res->start = l & PCI_ROM_ADDRESS_MASK;
 				res->end = res->start + (unsigned long) sz;
 			}
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index f7cb8e0..5cf8456 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -65,6 +65,7 @@ static void pbus_assign_resources_sorted(struct pci_bus *bus)
 		res = list->res;
 		idx = res - &list->dev->resource[0];
 		if (pci_assign_resource(list->dev, idx)) {
+			/* FIXME: get rid of this */
 			res->start = 0;
 			res->end = 0;
 			res->flags = 0;
@@ -327,6 +328,7 @@ static void pbus_size_io(struct pci_bus *bus)
 	/* Alignment of the IO window is always 4K */
 	b_res->start = 4096;
 	b_res->end = b_res->start + size - 1;
+	b_res->flags |= IORESOURCE_STARTALIGN;
 }
 
 /* Calculate the size of the bus and minimal alignment which
@@ -401,6 +403,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long
 	}
 	b_res->start = min_align;
 	b_res->end = size + min_align - 1;
+	b_res->flags |= IORESOURCE_STARTALIGN;
 	return 1;
 }
 
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 4be7ccf..0c1fdcd 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -137,10 +137,9 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 
 	size = res->end - res->start + 1;
 	min = (res->flags & IORESOURCE_IO) ? PCIBIOS_MIN_IO : PCIBIOS_MIN_MEM;
-	/* The bridge resources are special, as their
-	   size != alignment. Sizing routines return
-	   required alignment in the "start" field. */
-	align = (resno < PCI_BRIDGE_RESOURCES) ? size : res->start;
+
+	align = resource_alignment(res);
+	BUG_ON(!align);
 
 	/* First, try exact prefetching match.. */
 	ret = pci_bus_alloc_resource(bus, res, size, align, min,
@@ -164,8 +163,10 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 			res->flags & IORESOURCE_IO ? "I/O" : "mem",
 			resno, (unsigned long long)size,
 			(unsigned long long)res->start, pci_name(dev));
-	} else if (resno < PCI_BRIDGE_RESOURCES) {
-		pci_update_resource(dev, res, resno);
+	} else {
+		res->flags &= ~IORESOURCE_STARTALIGN;
+		if (resno < PCI_BRIDGE_RESOURCES)
+			pci_update_resource(dev, res, resno);
 	}
 
 	return ret;
@@ -226,29 +227,25 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 		if (r->flags & IORESOURCE_PCI_FIXED)
 			continue;
 
-		r_align = r->end - r->start;
-		
 		if (!(r->flags) || r->parent)
 			continue;
+
+		r_align = resource_alignment(r);
 		if (!r_align) {
-			printk(KERN_WARNING "PCI: Ignore bogus resource %d "
-				"[%llx:%llx] of %s\n",
+			printk(KERN_WARNING "PCI: bogus alignment of resource "
+				"%d [%llx:%llx] (flags %lx) of %s\n",
 				i, (unsigned long long)r->start,
-				(unsigned long long)r->end, pci_name(dev));
+				(unsigned long long)r->end, r->flags,
+				pci_name(dev));
 			continue;
 		}
-		r_align = (i < PCI_BRIDGE_RESOURCES) ? r_align + 1 : r->start;
 		for (list = head; ; list = list->next) {
 			resource_size_t align = 0;
 			struct resource_list *ln = list->next;
-			int idx;
 
-			if (ln) {
-				idx = ln->res - &ln->dev->resource[0];
-				align = (idx < PCI_BRIDGE_RESOURCES) ?
-					ln->res->end - ln->res->start + 1 :
-					ln->res->start;
-			}
+			if (ln)
+				align = resource_alignment(ln->res);
+
 			if (r_align > align) {
 				tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
 				if (!tmp)
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 605d237..096346b 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -44,7 +44,9 @@ struct resource_list {
 #define IORESOURCE_CACHEABLE	0x00004000
 #define IORESOURCE_RANGELENGTH	0x00008000
 #define IORESOURCE_SHADOWABLE	0x00010000
-#define IORESOURCE_BUS_HAS_VGA	0x00080000
+
+#define IORESOURCE_SIZEALIGN	0x00020000	/* size indicates alignment */
+#define IORESOURCE_STARTALIGN	0x00040000	/* start field is alignment */
 
 #define IORESOURCE_DISABLED	0x10000000
 #define IORESOURCE_UNSET	0x20000000
diff --git a/kernel/resource.c b/kernel/resource.c
index 82aea81..cee12cc 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -486,6 +486,24 @@ int adjust_resource(struct resource *res, resource_size_t start, resource_size_t
 
 EXPORT_SYMBOL(adjust_resource);
 
+/**
+ * resource_alignment - calculate resource's alignment
+ * @res: resource pointer
+ *
+ * Returns alignment on success, 0 (invalid alignment) on failure.
+ */
+resource_size_t resource_alignment(struct resource *res)
+{
+	switch (res->flags & (IORESOURCE_SIZEALIGN | IORESOURCE_STARTALIGN)) {
+	case IORESOURCE_SIZEALIGN:
+		return res->end - res->start + 1;
+	case IORESOURCE_STARTALIGN:
+		return res->start;
+	default:
+		return 0;
+	}
+}
+
 /*
  * This is compatibility stuff for IO resources.
  *
