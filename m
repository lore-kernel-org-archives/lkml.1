Return-Path: <linux-kernel-owner+w=401wt.eu-S964995AbXFFVEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964995AbXFFVEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936199AbXFFVDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:03:39 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:47563 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936193AbXFFVDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:03:37 -0400
Date: Thu, 7 Jun 2007 00:03:29 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] stop x86 ->sysdata abuse; introduce pci_sysdata
Message-ID: <20070606210329.GQ8541@rhun.ibm.com>
References: <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <20070604113344.0e71ca8c.akpm@linux-foundation.org> <20070604190654.GA20299@havoc.gtf.org> <20070604191346.GL4556@rhun.ibm.com> <20070604210551.GH20299@havoc.gtf.org> <20070605102905.GA3305@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605102905.GA3305@rhun.haifa.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 01:29:05PM +0300, Muli Ben-Yehuda wrote:
> On Mon, Jun 04, 2007 at 05:05:51PM -0400, Jeff Garzik wrote:
> > 
> > This patch introduces struct pci_sysdata to x86 and x86-64, and
> > converts the existing two users (NUMA, Calgary) to use it.
> > 
> > This eliminates the conflict between NUMA and Calgary using the same
> > pointer for different uses, and lays the groundwork for adding x86
> > PCI domain support.
> 
> Thanks for the patch. I am testing with Calgary and will push upstream
> through the next batch of Calgary updates when it will be ready. At
> the moment it doesn't boot on one of my test machines, I'm looking
> into it.

Ok, patch fixed, works for me with Calgary. Andi, it looks like you
added the acpi.c NUMA bits originally, perhaps you could test and/or
ack them?

This patch introduces struct pci_sysdata to x86 and x86-64, and
converts the existing two users (NUMA, Calgary) to use it.

This lays the groundwork for having other users of sysdata, such as
the PCI domains work.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>

---

NOTE: Calgary bits are tested, NUMA bits need to be tested.  

NOTE: I removed the PCI domains bits in Jeff's original patch so that
this patch only deals with ->sysdata users which are in mainline at
the moment. The PCI domains bits can be trivially added.

diff -r 05804111dbee arch/i386/pci/acpi.c
--- a/arch/i386/pci/acpi.c	Tue Jun 05 11:34:51 2007 +0300
+++ b/arch/i386/pci/acpi.c	Wed Jun 06 22:49:08 2007 +0300
@@ -8,20 +8,42 @@ struct pci_bus * __devinit pci_acpi_scan
 struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int domain, int busnum)
 {
 	struct pci_bus *bus;
+	struct pci_sysdata *sd;
+	int pxm;
+
+	/* Allocate per-root-bus (not per bus) arch-specific data.
+	 * TODO: leak; this memory is never freed.
+	 * It's arguable whether it's worth the trouble to care.
+	 */
+	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
+	if (!sd) {
+		printk(KERN_ERR "PCI: OOM, not probing PCI bus %02x\n", busnum);
+		return NULL;
+	}
 
 	if (domain != 0) {
 		printk(KERN_WARNING "PCI: Multiple domains not supported\n");
+		kfree(sd);
 		return NULL;
 	}
 
-	bus = pcibios_scan_root(busnum);
+	sd->node = -1;
+
+	pxm = acpi_get_pxm(device->handle);
+#ifdef CONFIG_ACPI_NUMA
+	if (pxm >= 0)
+		sd->node = pxm_to_node(pxm);
+#endif
+
+	bus = pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
+	if (!bus)
+		kfree(sd);
+
 #ifdef CONFIG_ACPI_NUMA
 	if (bus != NULL) {
-		int pxm = acpi_get_pxm(device->handle);
 		if (pxm >= 0) {
-			bus->sysdata = (void *)(unsigned long)pxm_to_node(pxm);
-			printk("bus %d -> pxm %d -> node %ld\n",
-				busnum, pxm, (long)(bus->sysdata));
+			printk("bus %d -> pxm %d -> node %d\n",
+				busnum, pxm, sd->node);
 		}
 	}
 #endif
diff -r 05804111dbee arch/i386/pci/common.c
--- a/arch/i386/pci/common.c	Tue Jun 05 11:34:51 2007 +0300
+++ b/arch/i386/pci/common.c	Wed Jun 06 22:36:53 2007 +0300
@@ -29,12 +29,14 @@ struct pci_raw_ops *raw_pci_ops;
 
 static int pci_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
 {
-	return raw_pci_ops->read(0, bus->number, devfn, where, size, value);
+	return raw_pci_ops->read(pci_domain_nr(bus), bus->number,
+				 devfn, where, size, value);
 }
 
 static int pci_write(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 value)
 {
-	return raw_pci_ops->write(0, bus->number, devfn, where, size, value);
+	return raw_pci_ops->write(pci_domain_nr(bus), bus->number,
+				  devfn, where, size, value);
 }
 
 struct pci_ops pci_root_ops = {
@@ -293,6 +295,7 @@ struct pci_bus * __devinit pcibios_scan_
 struct pci_bus * __devinit pcibios_scan_root(int busnum)
 {
 	struct pci_bus *bus = NULL;
+	struct pci_sysdata *sd;
 
 	dmi_check_system(pciprobe_dmi_table);
 
@@ -303,9 +306,19 @@ struct pci_bus * __devinit pcibios_scan_
 		}
 	}
 
+	/* Allocate per-root-bus (not per bus) arch-specific data.
+	 * TODO: leak; this memory is never freed.
+	 * It's arguable whether it's worth the trouble to care.
+	 */
+	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
+	if (!sd) {
+		printk(KERN_ERR "PCI: OOM, not probing PCI bus %02x\n", busnum);
+		return NULL;
+	}
+
 	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x)\n", busnum);
 
-	return pci_scan_bus_parented(NULL, busnum, &pci_root_ops, NULL);
+	return pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
 }
 
 extern u8 pci_cache_line_size;
diff -r 05804111dbee arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c	Tue Jun 05 11:34:51 2007 +0300
+++ b/arch/x86_64/kernel/pci-calgary.c	Wed Jun 06 23:27:53 2007 +0300
@@ -375,7 +375,7 @@ static inline struct iommu_table *find_i
 	else
 		pbus = pdev->bus;
 
-	tbl = pbus->self->sysdata;
+	tbl = pci_iommu(pbus);
 
 	BUG_ON(pdev->bus->parent &&
 	       (tbl->it_busno != pdev->bus->parent->number));
@@ -718,7 +718,7 @@ static void __init calgary_reserve_mem_r
 	limit++;
 
 	numpages = ((limit - start) >> PAGE_SHIFT);
-	iommu_range_reserve(dev->sysdata, start, numpages);
+	iommu_range_reserve(pci_iommu(dev->bus), start, numpages);
 }
 
 static void __init calgary_reserve_peripheral_mem_1(struct pci_dev *dev)
@@ -726,7 +726,7 @@ static void __init calgary_reserve_perip
 	void __iomem *target;
 	u64 low, high, sizelow;
 	u64 start, limit;
-	struct iommu_table *tbl = dev->sysdata;
+	struct iommu_table *tbl = pci_iommu(dev->bus);
 	unsigned char busnum = dev->bus->number;
 	void __iomem *bbar = tbl->bbar;
 
@@ -750,7 +750,7 @@ static void __init calgary_reserve_perip
 	u32 val32;
 	u64 low, high, sizelow, sizehigh;
 	u64 start, limit;
-	struct iommu_table *tbl = dev->sysdata;
+	struct iommu_table *tbl = pci_iommu(dev->bus);
 	unsigned char busnum = dev->bus->number;
 	void __iomem *bbar = tbl->bbar;
 
@@ -786,7 +786,7 @@ static void __init calgary_reserve_regio
 {
 	unsigned int npages;
 	u64 start;
-	struct iommu_table *tbl = dev->sysdata;
+	struct iommu_table *tbl = pci_iommu(dev->bus);
 	void __iomem *target;
 	u32 val1, val2;
 	unsigned char busnum = dev->bus->number;
@@ -831,7 +831,7 @@ static int __init calgary_setup_tar(stru
 	if (ret)
 		return ret;
 
-	tbl = dev->sysdata;
+	tbl = pci_iommu(dev->bus);
 	tbl->it_base = (unsigned long)bus_info[dev->bus->number].tce_space;
 	tce_free(tbl, 0, tbl->it_size);
 
@@ -868,7 +868,7 @@ static void __init calgary_free_bus(stru
 static void __init calgary_free_bus(struct pci_dev *dev)
 {
 	u64 val64;
-	struct iommu_table *tbl = dev->sysdata;
+	struct iommu_table *tbl = pci_iommu(dev->bus);
 	void __iomem *target;
 	unsigned int bitmapsz;
 
@@ -883,7 +883,8 @@ static void __init calgary_free_bus(stru
 	tbl->it_map = NULL;
 
 	kfree(tbl);
-	dev->sysdata = NULL;
+	
+	set_pci_iommu(dev->bus, NULL);
 
 	/* Can't free bootmem allocated memory after system is up :-( */
 	bus_info[dev->bus->number].tce_space = NULL;
@@ -956,7 +957,7 @@ static void calgary_watchdog(unsigned lo
 static void calgary_watchdog(unsigned long data)
 {
 	struct pci_dev *dev = (struct pci_dev *)data;
-	struct iommu_table *tbl = dev->sysdata;
+	struct iommu_table *tbl = pci_iommu(dev->bus);
 	void __iomem *bbar = tbl->bbar;
 	u32 val32;
 	void __iomem *target;
@@ -1056,7 +1057,7 @@ static void __init calgary_enable_transl
 	struct iommu_table *tbl;
 
 	busnum = dev->bus->number;
-	tbl = dev->sysdata;
+	tbl = pci_iommu(dev->bus);
 	bbar = tbl->bbar;
 
 	/* dump the configuration register */
@@ -1093,7 +1094,7 @@ static void __init calgary_disable_trans
 	struct iommu_table *tbl;
 
 	busnum = dev->bus->number;
-	tbl = dev->sysdata;
+	tbl = pci_iommu(dev->bus);
 	bbar = tbl->bbar;
 
 	/* disable TCE in PHB Config Register */
@@ -1111,7 +1112,7 @@ static void __init calgary_init_one_nont
 static void __init calgary_init_one_nontraslated(struct pci_dev *dev)
 {
 	pci_dev_get(dev);
-	dev->sysdata = NULL;
+	set_pci_iommu(dev->bus, NULL);
 
 	/* is the device behind a bridge? */
 	if (dev->bus->parent)
@@ -1144,7 +1145,7 @@ static int __init calgary_init_one(struc
 	else
 		dev->bus->self = dev;
 
-	tbl = dev->sysdata;
+	tbl = pci_iommu(dev->bus);
 	tbl->chip_ops->handle_quirks(tbl, dev);
 
 	calgary_enable_translation(dev);
@@ -1541,7 +1542,7 @@ static void __init calgary_fixup_one_tce
 	unsigned int npages;
 	int i;
 
-	tbl = dev->sysdata;
+	tbl = pci_iommu(dev->bus);
 
 	for (i = 0; i < 4; i++) {
 		struct resource *r = &dev->resource[PCI_BRIDGE_RESOURCES + i];
diff -r 05804111dbee arch/x86_64/kernel/tce.c
--- a/arch/x86_64/kernel/tce.c	Tue Jun 05 11:34:51 2007 +0300
+++ b/arch/x86_64/kernel/tce.c	Wed Jun 06 22:36:53 2007 +0300
@@ -136,9 +136,9 @@ int build_tce_table(struct pci_dev *dev,
 	struct iommu_table *tbl;
 	int ret;
 
-	if (dev->sysdata) {
-		printk(KERN_ERR "Calgary: dev %p has sysdata %p\n",
-		       dev, dev->sysdata);
+	if (pci_iommu(dev->bus)) {
+		printk(KERN_ERR "Calgary: dev %p has sysdata->iommu %p\n",
+		       dev, pci_iommu(dev->bus));
 		BUG();
 	}
 
@@ -155,11 +155,7 @@ int build_tce_table(struct pci_dev *dev,
 
 	tbl->bbar = bbar;
 
-	/*
-	 * NUMA is already using the bus's sysdata pointer, so we use
-	 * the bus's pci_dev's sysdata instead.
-	 */
-	dev->sysdata = tbl;
+	set_pci_iommu(dev->bus, tbl);
 
 	return 0;
 
diff -r 05804111dbee arch/x86_64/pci/k8-bus.c
--- a/arch/x86_64/pci/k8-bus.c	Tue Jun 05 11:34:51 2007 +0300
+++ b/arch/x86_64/pci/k8-bus.c	Wed Jun 06 22:36:53 2007 +0300
@@ -59,6 +59,8 @@ fill_mp_bus_to_cpumask(void)
 				     j <= SUBORDINATE_LDT_BUS_NUMBER(ldtbus);
 				     j++) { 
 					struct pci_bus *bus;
+					struct pci_sysdata *sd;
+
 					long node = NODE_ID(nid);
 					/* Algorithm a bit dumb, but
  					   it shouldn't matter here */
@@ -67,7 +69,9 @@ fill_mp_bus_to_cpumask(void)
 						continue;
 					if (!node_online(node))
 						node = 0;
-					bus->sysdata = (void *)node;
+
+					sd = bus->sysdata;
+					sd->node = node;
 				}		
 			}
 		}
diff -r 05804111dbee include/asm-i386/pci.h
--- a/include/asm-i386/pci.h	Tue Jun 05 11:34:51 2007 +0300
+++ b/include/asm-i386/pci.h	Wed Jun 06 22:48:04 2007 +0300
@@ -3,6 +3,11 @@
 
 
 #ifdef __KERNEL__
+
+struct pci_sysdata {
+	int		node;		/* NUMA node */
+};
+
 #include <linux/mm.h>		/* for struct page */
 
 /* Can be used to override the logic in pci_scan_bus for skipping
diff -r 05804111dbee include/asm-i386/topology.h
--- a/include/asm-i386/topology.h	Tue Jun 05 11:34:51 2007 +0300
+++ b/include/asm-i386/topology.h	Wed Jun 06 22:36:53 2007 +0300
@@ -67,7 +67,7 @@ static inline int node_to_first_cpu(int 
 	return first_cpu(mask);
 }
 
-#define pcibus_to_node(bus) ((long) (bus)->sysdata)
+#define pcibus_to_node(bus) ((struct pci_sysdata *)((bus)->sysdata))->node
 #define pcibus_to_cpumask(bus) node_to_cpumask(pcibus_to_node(bus))
 
 /* sched_domains SD_NODE_INIT for NUMAQ machines */
diff -r 05804111dbee include/asm-x86_64/pci.h
--- a/include/asm-x86_64/pci.h	Tue Jun 05 11:34:51 2007 +0300
+++ b/include/asm-x86_64/pci.h	Wed Jun 06 22:48:15 2007 +0300
@@ -4,6 +4,25 @@
 #include <asm/io.h>
 
 #ifdef __KERNEL__
+
+struct pci_sysdata {
+	int		node;		/* NUMA node */
+	void*		iommu;		/* IOMMU private data */
+};
+
+#ifdef CONFIG_CALGARY_IOMMU
+static inline void* pci_iommu(struct pci_bus *bus)
+{
+	struct pci_sysdata *sd = bus->sysdata;
+	return sd->iommu;
+}
+
+static inline void set_pci_iommu(struct pci_bus *bus, void *val)
+{
+	struct pci_sysdata *sd = bus->sysdata;
+	sd->iommu = val;
+}
+#endif /* CONFIG_CALGARY_IOMMU */
 
 #include <linux/mm.h> /* for struct page */
 
diff -r 05804111dbee include/asm-x86_64/topology.h
--- a/include/asm-x86_64/topology.h	Tue Jun 05 11:34:51 2007 +0300
+++ b/include/asm-x86_64/topology.h	Wed Jun 06 22:36:53 2007 +0300
@@ -22,7 +22,7 @@ extern int __node_distance(int, int);
 #define parent_node(node)		(node)
 #define node_to_first_cpu(node) 	(first_cpu(node_to_cpumask[node]))
 #define node_to_cpumask(node)		(node_to_cpumask[node])
-#define pcibus_to_node(bus)		((long)(bus->sysdata))	
+#define pcibus_to_node(bus)	((struct pci_sysdata *)((bus)->sysdata))->node
 #define pcibus_to_cpumask(bus)		node_to_cpumask(pcibus_to_node(bus));
 
 #define numa_node_id()			read_pda(nodenumber)


