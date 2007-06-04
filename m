Return-Path: <linux-kernel-owner+w=401wt.eu-S1761204AbXFDVGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761204AbXFDVGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbXFDVFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:05:53 -0400
Received: from havoc.gtf.org ([69.61.125.42]:37443 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbXFDVFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:05:52 -0400
Date: Mon, 4 Jun 2007 17:05:51 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Muli Ben-Yehuda <muli@il.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] stop x86 ->sysdata abuse; introduce pci_sysdata
Message-ID: <20070604210551.GH20299@havoc.gtf.org>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <20070604113344.0e71ca8c.akpm@linux-foundation.org> <20070604190654.GA20299@havoc.gtf.org> <20070604191346.GL4556@rhun.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604191346.GL4556@rhun.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch introduces struct pci_sysdata to x86 and x86-64, and
converts the existing two users (NUMA, Calgary) to use it.

This eliminates the conflict between NUMA and Calgary using the same
pointer for different uses, and lays the groundwork for adding x86
PCI domain support.

Signed-off-by: Jeff Garzik <jeff@garzik.org>

---

NOTE:  This patch is untested, extract from the larger changes found in
jgarzik/misc-2.6.git#pciseg.  Hopefully NUMA and/or Calgary users will
test and ack this, then build patches on top of it.


diff --git a/arch/i386/pci/acpi.c b/arch/i386/pci/acpi.c
index b33aea8..1210a89 100644
--- a/arch/i386/pci/acpi.c
+++ b/arch/i386/pci/acpi.c
@@ -8,20 +8,46 @@
 struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int domain, int busnum)
 {
 	struct pci_bus *bus;
+	struct pci_sysdata *sd;
+	int pxm;
 
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
+#ifdef CONFIG_PCI_DOMAINS
+	sd->domain = domain;
+#else
 	if (domain != 0) {
 		printk(KERN_WARNING "PCI: Multiple domains not supported\n");
+		kfree(sd);
 		return NULL;
 	}
+#endif /* CONFIG_PCI_DOMAINS */
+
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
 
-	bus = pcibios_scan_root(busnum);
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
diff --git a/arch/i386/pci/common.c b/arch/i386/pci/common.c
index 3f78d4d..0519519 100644
--- a/arch/i386/pci/common.c
+++ b/arch/i386/pci/common.c
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
@@ -293,6 +295,7 @@ static struct dmi_system_id __devinitdata pciprobe_dmi_table[] = {
 struct pci_bus * __devinit pcibios_scan_root(int busnum)
 {
 	struct pci_bus *bus = NULL;
+	struct pci_sysdata *sd;
 
 	dmi_check_system(pciprobe_dmi_table);
 
@@ -303,9 +306,19 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
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
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 5ce9443..6a27e08 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -716,6 +716,10 @@ config PCI_MMCONFIG
 	bool "Support mmconfig PCI config space access"
 	depends on PCI && ACPI
 
+config PCI_DOMAINS
+	bool "PCI domain support"
+	depends on PCI
+
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 5bd20b5..55725ec 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -359,7 +359,7 @@ void calgary_unmap_sg(struct device *dev, struct scatterlist *sglist,
 		      int nelems, int direction)
 {
 	unsigned long flags;
-	struct iommu_table *tbl = to_pci_dev(dev)->bus->self->sysdata;
+	struct iommu_table *tbl = pci_iommu(to_pci_dev(dev)->bus);
 
 	if (!translate_phb(to_pci_dev(dev)))
 		return;
@@ -388,7 +388,7 @@ static int calgary_nontranslate_map_sg(struct device* dev,
 int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	int nelems, int direction)
 {
-	struct iommu_table *tbl = to_pci_dev(dev)->bus->self->sysdata;
+	struct iommu_table *tbl = pci_iommu(to_pci_dev(dev)->bus);
 	unsigned long flags;
 	unsigned long vaddr;
 	unsigned int npages;
@@ -442,7 +442,7 @@ dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
 	dma_addr_t dma_handle = bad_dma_address;
 	unsigned long uaddr;
 	unsigned int npages;
-	struct iommu_table *tbl = to_pci_dev(dev)->bus->self->sysdata;
+	struct iommu_table *tbl = pci_iommu(to_pci_dev(dev)->bus);
 
 	uaddr = (unsigned long)vaddr;
 	npages = num_dma_pages(uaddr, size);
@@ -458,7 +458,7 @@ dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
 void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
 	size_t size, int direction)
 {
-	struct iommu_table *tbl = to_pci_dev(dev)->bus->self->sysdata;
+	struct iommu_table *tbl = pci_iommu(to_pci_dev(dev)->bus);
 	unsigned int npages;
 
 	if (!translate_phb(to_pci_dev(dev)))
@@ -476,7 +476,7 @@ void* calgary_alloc_coherent(struct device *dev, size_t size,
 	unsigned int npages, order;
 	struct iommu_table *tbl;
 
-	tbl = to_pci_dev(dev)->bus->self->sysdata;
+	tbl = pci_iommu(to_pci_dev(dev)->bus);
 
 	size = PAGE_ALIGN(size); /* size rounded up to full pages */
 	npages = size >> PAGE_SHIFT;
@@ -598,7 +598,7 @@ static void __init calgary_reserve_mem_region(struct pci_dev *dev, u64 start,
 	limit++;
 
 	numpages = ((limit - start) >> PAGE_SHIFT);
-	iommu_range_reserve(dev->sysdata, start, numpages);
+	iommu_range_reserve(pci_iommu(dev->bus), start, numpages);
 }
 
 static void __init calgary_reserve_peripheral_mem_1(struct pci_dev *dev)
@@ -606,7 +606,7 @@ static void __init calgary_reserve_peripheral_mem_1(struct pci_dev *dev)
 	void __iomem *target;
 	u64 low, high, sizelow;
 	u64 start, limit;
-	struct iommu_table *tbl = dev->sysdata;
+	struct iommu_table *tbl = pci_iommu(dev->bus);
 	unsigned char busnum = dev->bus->number;
 	void __iomem *bbar = tbl->bbar;
 
@@ -630,7 +630,7 @@ static void __init calgary_reserve_peripheral_mem_2(struct pci_dev *dev)
 	u32 val32;
 	u64 low, high, sizelow, sizehigh;
 	u64 start, limit;
-	struct iommu_table *tbl = dev->sysdata;
+	struct iommu_table *tbl = pci_iommu(dev->bus);
 	unsigned char busnum = dev->bus->number;
 	void __iomem *bbar = tbl->bbar;
 
@@ -666,7 +666,7 @@ static void __init calgary_reserve_regions(struct pci_dev *dev)
 {
 	unsigned int npages;
 	u64 start;
-	struct iommu_table *tbl = dev->sysdata;
+	struct iommu_table *tbl = pci_iommu(dev->bus);
 
 	/* reserve EMERGENCY_PAGES from bad_dma_address and up */
 	iommu_range_reserve(tbl, bad_dma_address, EMERGENCY_PAGES);
@@ -694,7 +694,7 @@ static int __init calgary_setup_tar(struct pci_dev *dev, void __iomem *bbar)
 	if (ret)
 		return ret;
 
-	tbl = dev->sysdata;
+	tbl = pci_iommu(dev->bus);
 	tbl->it_base = (unsigned long)bus_info[dev->bus->number].tce_space;
 	tce_free(tbl, 0, tbl->it_size);
 
@@ -707,7 +707,7 @@ static int __init calgary_setup_tar(struct pci_dev *dev, void __iomem *bbar)
 	/* zero out all TAR bits under sw control */
 	val64 &= ~TAR_SW_BITS;
 
-	tbl = dev->sysdata;
+	tbl = pci_iommu(dev->bus);
 	table_phys = (u64)__pa(tbl->it_base);
 	val64 |= table_phys;
 
@@ -724,7 +724,7 @@ static int __init calgary_setup_tar(struct pci_dev *dev, void __iomem *bbar)
 static void __init calgary_free_bus(struct pci_dev *dev)
 {
 	u64 val64;
-	struct iommu_table *tbl = dev->sysdata;
+	struct iommu_table *tbl = pci_iommu(dev->bus);
 	void __iomem *target;
 	unsigned int bitmapsz;
 
@@ -739,7 +739,8 @@ static void __init calgary_free_bus(struct pci_dev *dev)
 	tbl->it_map = NULL;
 
 	kfree(tbl);
-	dev->sysdata = NULL;
+	
+	set_pci_iommu(dev->bus, NULL);
 
 	/* Can't free bootmem allocated memory after system is up :-( */
 	bus_info[dev->bus->number].tce_space = NULL;
@@ -748,7 +749,7 @@ static void __init calgary_free_bus(struct pci_dev *dev)
 static void calgary_watchdog(unsigned long data)
 {
 	struct pci_dev *dev = (struct pci_dev *)data;
-	struct iommu_table *tbl = dev->sysdata;
+	struct iommu_table *tbl = pci_iommu(dev->bus);
 	void __iomem *bbar = tbl->bbar;
 	u32 val32;
 	void __iomem *target;
@@ -816,7 +817,7 @@ static void __init calgary_enable_translation(struct pci_dev *dev)
 	struct iommu_table *tbl;
 
 	busnum = dev->bus->number;
-	tbl = dev->sysdata;
+	tbl = pci_iommu(dev->bus);
 	bbar = tbl->bbar;
 
 	/* enable TCE in PHB Config Register */
@@ -853,7 +854,7 @@ static void __init calgary_disable_translation(struct pci_dev *dev)
 	struct iommu_table *tbl;
 
 	busnum = dev->bus->number;
-	tbl = dev->sysdata;
+	tbl = pci_iommu(dev->bus);
 	bbar = tbl->bbar;
 
 	/* disable TCE in PHB Config Register */
@@ -871,8 +872,7 @@ static void __init calgary_disable_translation(struct pci_dev *dev)
 static void __init calgary_init_one_nontraslated(struct pci_dev *dev)
 {
 	pci_dev_get(dev);
-	dev->sysdata = NULL;
-	dev->bus->self = dev;
+	set_pci_iommu(dev->bus, NULL);
 }
 
 static int __init calgary_init_one(struct pci_dev *dev)
diff --git a/arch/x86_64/kernel/tce.c b/arch/x86_64/kernel/tce.c
index f61fb8e..3aeae2f 100644
--- a/arch/x86_64/kernel/tce.c
+++ b/arch/x86_64/kernel/tce.c
@@ -136,9 +136,9 @@ int build_tce_table(struct pci_dev *dev, void __iomem *bbar)
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
 
@@ -155,11 +155,7 @@ int build_tce_table(struct pci_dev *dev, void __iomem *bbar)
 
 	tbl->bbar = bbar;
 
-	/*
-	 * NUMA is already using the bus's sysdata pointer, so we use
-	 * the bus's pci_dev's sysdata instead.
-	 */
-	dev->sysdata = tbl;
+	set_pci_iommu(dev->bus, tbl);
 
 	return 0;
 
diff --git a/arch/x86_64/pci/k8-bus.c b/arch/x86_64/pci/k8-bus.c
index 3acf60d..9cc813e 100644
--- a/arch/x86_64/pci/k8-bus.c
+++ b/arch/x86_64/pci/k8-bus.c
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
diff --git a/include/asm-i386/pci.h b/include/asm-i386/pci.h
index 64b6d0b..2c8b5e9 100644
--- a/include/asm-i386/pci.h
+++ b/include/asm-i386/pci.h
@@ -3,6 +3,25 @@
 
 
 #ifdef __KERNEL__
+
+struct pci_sysdata {
+	int		domain;		/* PCI domain */
+	int		node;		/* NUMA node */
+};
+
+#ifdef CONFIG_PCI_DOMAINS
+static inline int pci_domain_nr(struct pci_bus *bus)
+{
+	struct pci_sysdata *sd = bus->sysdata;
+	return sd->domain;
+}
+
+static inline int pci_proc_domain(struct pci_bus *bus)
+{
+	return pci_domain_nr(bus);
+}
+#endif /* CONFIG_PCI_DOMAINS */
+
 #include <linux/mm.h>		/* for struct page */
 
 /* Can be used to override the logic in pci_scan_bus for skipping
diff --git a/include/asm-i386/topology.h b/include/asm-i386/topology.h
index 7fc512d..19b2daf 100644
--- a/include/asm-i386/topology.h
+++ b/include/asm-i386/topology.h
@@ -67,7 +67,7 @@ static inline int node_to_first_cpu(int node)
 	return first_cpu(mask);
 }
 
-#define pcibus_to_node(bus) ((long) (bus)->sysdata)
+#define pcibus_to_node(bus) ((struct pci_sysdata *)((bus)->sysdata))->node
 #define pcibus_to_cpumask(bus) node_to_cpumask(pcibus_to_node(bus))
 
 /* sched_domains SD_NODE_INIT for NUMAQ machines */
diff --git a/include/asm-x86_64/pci.h b/include/asm-x86_64/pci.h
index 49c5e92..550207f 100644
--- a/include/asm-x86_64/pci.h
+++ b/include/asm-x86_64/pci.h
@@ -5,6 +5,39 @@
 
 #ifdef __KERNEL__
 
+struct pci_sysdata {
+	int		domain;		/* PCI domain */
+	int		node;		/* NUMA node */
+	void*		iommu;		/* IOMMU private data */
+};
+
+#ifdef CONFIG_PCI_DOMAINS
+static inline int pci_domain_nr(struct pci_bus *bus)
+{
+	struct pci_sysdata *sd = bus->sysdata;
+	return sd->domain;
+}
+
+static inline int pci_proc_domain(struct pci_bus *bus)
+{
+	return pci_domain_nr(bus);
+}
+#endif /* CONFIG_PCI_DOMAINS */
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
+
 #include <linux/mm.h> /* for struct page */
 
 /* Can be used to override the logic in pci_scan_bus for skipping
diff --git a/include/asm-x86_64/topology.h b/include/asm-x86_64/topology.h
index 4fd6fb2..36e52fb 100644
--- a/include/asm-x86_64/topology.h
+++ b/include/asm-x86_64/topology.h
@@ -22,7 +22,7 @@ extern int __node_distance(int, int);
 #define parent_node(node)		(node)
 #define node_to_first_cpu(node) 	(first_cpu(node_to_cpumask[node]))
 #define node_to_cpumask(node)		(node_to_cpumask[node])
-#define pcibus_to_node(bus)		((long)(bus->sysdata))	
+#define pcibus_to_node(bus)	((struct pci_sysdata *)((bus)->sysdata))->node
 #define pcibus_to_cpumask(bus)		node_to_cpumask(pcibus_to_node(bus));
 
 #define numa_node_id()			read_pda(nodenumber)
