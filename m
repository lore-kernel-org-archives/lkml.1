Return-Path: <linux-kernel-owner+w=401wt.eu-S1765088AbXGKNpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765088AbXGKNpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763194AbXGKNpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:45:21 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:26010 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763210AbXGKNpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:45:18 -0400
Date: Wed, 11 Jul 2007 16:45:14 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>, Yinghai Lu <Yinghai.Lu@Sun.COM>,
       Andrew Morton <akpm@osdl.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jon Mason <jdmason@gmail.com>
Subject: [PATCH 1/1] x86-64: introduce struct pci_sysdata to facilitate sharing of ->sysdata
Message-ID: <20070711134514.GA4789@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi, please consider applying for 2.6.23. Applies on top of the
Calgary update I just sent out ("Calgary: more updates for 2.6.23").

This patch introduces struct pci_sysdata to x86 and x86-64, and
converts the existing two users (NUMA, Calgary) to use it.

This lays the groundwork for having other users of sysdata, such as
the PCI domains work.

The Calgary bits are tested, the NUMA bits just look ok.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/i386/pci/acpi.c             |   32 +++++++++++++++++++++++++++-----
 arch/i386/pci/common.c           |   13 ++++++++++++-
 arch/x86_64/kernel/pci-calgary.c |   29 +++++++++++++++--------------
 arch/x86_64/kernel/tce.c         |   12 ++++--------
 arch/x86_64/pci/k8-bus.c         |    6 +++++-
 include/asm-i386/pci.h           |    5 +++++
 include/asm-i386/topology.h      |    2 +-
 include/asm-x86_64/pci.h         |   19 +++++++++++++++++++
 include/asm-x86_64/topology.h    |    2 +-
 9 files changed, 89 insertions(+), 31 deletions(-)

diff --git a/arch/i386/pci/acpi.c b/arch/i386/pci/acpi.c
index b33aea8..bc8a44b 100644
--- a/arch/i386/pci/acpi.c
+++ b/arch/i386/pci/acpi.c
@@ -8,20 +8,42 @@
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
diff --git a/arch/i386/pci/common.c b/arch/i386/pci/common.c
index 3f78d4d..85503de 100644
--- a/arch/i386/pci/common.c
+++ b/arch/i386/pci/common.c
@@ -293,6 +293,7 @@ static struct dmi_system_id __devinitdata pciprobe_dmi_table[] = {
 struct pci_bus * __devinit pcibios_scan_root(int busnum)
 {
 	struct pci_bus *bus = NULL;
+	struct pci_sysdata *sd;
 
 	dmi_check_system(pciprobe_dmi_table);
 
@@ -303,9 +304,19 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
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
diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index aec8f76..a186f82 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -375,7 +375,7 @@ static inline struct iommu_table *find_iommu_table(struct device *dev)
 	else
 		pbus = pdev->bus;
 
-	tbl = pbus->self->sysdata;
+	tbl = pci_iommu(pbus);
 
 	BUG_ON(pdev->bus->parent &&
 	       (tbl->it_busno != pdev->bus->parent->number));
@@ -718,7 +718,7 @@ static void __init calgary_reserve_mem_region(struct pci_dev *dev, u64 start,
 	limit++;
 
 	numpages = ((limit - start) >> PAGE_SHIFT);
-	iommu_range_reserve(dev->sysdata, start, numpages);
+	iommu_range_reserve(pci_iommu(dev->bus), start, numpages);
 }
 
 static void __init calgary_reserve_peripheral_mem_1(struct pci_dev *dev)
@@ -726,7 +726,7 @@ static void __init calgary_reserve_peripheral_mem_1(struct pci_dev *dev)
 	void __iomem *target;
 	u64 low, high, sizelow;
 	u64 start, limit;
-	struct iommu_table *tbl = dev->sysdata;
+	struct iommu_table *tbl = pci_iommu(dev->bus);
 	unsigned char busnum = dev->bus->number;
 	void __iomem *bbar = tbl->bbar;
 
@@ -750,7 +750,7 @@ static void __init calgary_reserve_peripheral_mem_2(struct pci_dev *dev)
 	u32 val32;
 	u64 low, high, sizelow, sizehigh;
 	u64 start, limit;
-	struct iommu_table *tbl = dev->sysdata;
+	struct iommu_table *tbl = pci_iommu(dev->bus);
 	unsigned char busnum = dev->bus->number;
 	void __iomem *bbar = tbl->bbar;
 
@@ -786,7 +786,7 @@ static void __init calgary_reserve_regions(struct pci_dev *dev)
 {
 	unsigned int npages;
 	u64 start;
-	struct iommu_table *tbl = dev->sysdata;
+	struct iommu_table *tbl = pci_iommu(dev->bus);
 
 	/* reserve EMERGENCY_PAGES from bad_dma_address and up */
 	iommu_range_reserve(tbl, bad_dma_address, EMERGENCY_PAGES);
@@ -820,7 +820,7 @@ static int __init calgary_setup_tar(struct pci_dev *dev, void __iomem *bbar)
 	if (ret)
 		return ret;
 
-	tbl = dev->sysdata;
+	tbl = pci_iommu(dev->bus);
 	tbl->it_base = (unsigned long)bus_info[dev->bus->number].tce_space;
 	tce_free(tbl, 0, tbl->it_size);
 
@@ -857,7 +857,7 @@ static int __init calgary_setup_tar(struct pci_dev *dev, void __iomem *bbar)
 static void __init calgary_free_bus(struct pci_dev *dev)
 {
 	u64 val64;
-	struct iommu_table *tbl = dev->sysdata;
+	struct iommu_table *tbl = pci_iommu(dev->bus);
 	void __iomem *target;
 	unsigned int bitmapsz;
 
@@ -872,7 +872,8 @@ static void __init calgary_free_bus(struct pci_dev *dev)
 	tbl->it_map = NULL;
 
 	kfree(tbl);
-	dev->sysdata = NULL;
+	
+	set_pci_iommu(dev->bus, NULL);
 
 	/* Can't free bootmem allocated memory after system is up :-( */
 	bus_info[dev->bus->number].tce_space = NULL;
@@ -945,7 +946,7 @@ static void calioc2_dump_error_regs(struct iommu_table *tbl)
 static void calgary_watchdog(unsigned long data)
 {
 	struct pci_dev *dev = (struct pci_dev *)data;
-	struct iommu_table *tbl = dev->sysdata;
+	struct iommu_table *tbl = pci_iommu(dev->bus);
 	void __iomem *bbar = tbl->bbar;
 	u32 val32;
 	void __iomem *target;
@@ -1043,7 +1044,7 @@ static void __init calgary_enable_translation(struct pci_dev *dev)
 	struct iommu_table *tbl;
 
 	busnum = dev->bus->number;
-	tbl = dev->sysdata;
+	tbl = pci_iommu(dev->bus);
 	bbar = tbl->bbar;
 
 	/* enable TCE in PHB Config Register */
@@ -1075,7 +1076,7 @@ static void __init calgary_disable_translation(struct pci_dev *dev)
 	struct iommu_table *tbl;
 
 	busnum = dev->bus->number;
-	tbl = dev->sysdata;
+	tbl = pci_iommu(dev->bus);
 	bbar = tbl->bbar;
 
 	/* disable TCE in PHB Config Register */
@@ -1093,7 +1094,7 @@ static void __init calgary_disable_translation(struct pci_dev *dev)
 static void __init calgary_init_one_nontraslated(struct pci_dev *dev)
 {
 	pci_dev_get(dev);
-	dev->sysdata = NULL;
+	set_pci_iommu(dev->bus, NULL);
 
 	/* is the device behind a bridge? */
 	if (dev->bus->parent)
@@ -1125,7 +1126,7 @@ static int __init calgary_init_one(struct pci_dev *dev)
 	} else
 		dev->bus->self = dev;
 
-	tbl = dev->sysdata;
+	tbl = pci_iommu(dev->bus);
 	tbl->chip_ops->handle_quirks(tbl, dev);
 
 	calgary_enable_translation(dev);
@@ -1522,7 +1523,7 @@ static void __init calgary_fixup_one_tce_space(struct pci_dev *dev)
 	unsigned int npages;
 	int i;
 
-	tbl = dev->sysdata;
+	tbl = pci_iommu(dev->bus);
 
 	for (i = 0; i < 4; i++) {
 		struct resource *r = &dev->resource[PCI_BRIDGE_RESOURCES + i];
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
index 64b6d0b..64c7e94 100644
--- a/include/asm-i386/pci.h
+++ b/include/asm-i386/pci.h
@@ -3,6 +3,11 @@
 
 
 #ifdef __KERNEL__
+
+struct pci_sysdata {
+	int		node;		/* NUMA node */
+};
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
index 49c5e92..12ec371 100644
--- a/include/asm-x86_64/pci.h
+++ b/include/asm-x86_64/pci.h
@@ -5,6 +5,25 @@
 
 #ifdef __KERNEL__
 
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
-- 
1.5.2


