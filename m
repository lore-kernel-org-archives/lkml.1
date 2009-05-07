Return-Path: <linux-kernel-owner+w=401wt.eu-S1764211AbZEHAdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764211AbZEHAdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759968AbZEHAKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:55 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52712
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755617AbZEHAJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:59 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 07/11] Xen/x86/PCI: Add support for the Xen PCI subsytem
Date: Thu,  7 May 2009 14:45:33 -0700
Message-Id: <1241732737-7669-8-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241732737-7669-1-git-send-email-jeremy@goop.org>
References: <1241732737-7669-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

Impact: add core of Xen PCI support

On boot, the system will search to see if a Xen iommu/pci subsystem is
available.  If the kernel detects it's running in a domain rather than
on bare hardware, this subsystem will be used.  Otherwise, it falls
back to using hardware as usual.

The frontend stub lives in arch/x86/pci-xen.c, alongside other
sub-arch PCI init code (e.g. olpc.c)

(All subsequent fixes, API changes and swiotlb operations folded in.)

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/Kconfig                 |    4 +
 arch/x86/include/asm/pci_x86.h   |    1 +
 arch/x86/include/asm/xen/iommu.h |   12 ++
 arch/x86/kernel/pci-dma.c        |    3 +
 arch/x86/pci/Makefile            |    1 +
 arch/x86/pci/init.c              |    6 +
 arch/x86/pci/xen.c               |   52 +++++++
 drivers/pci/Makefile             |    2 +
 drivers/pci/xen-iommu.c          |  302 ++++++++++++++++++++++++++++++++++++++
 9 files changed, 383 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/iommu.h
 create mode 100644 arch/x86/pci/xen.c
 create mode 100644 drivers/pci/xen-iommu.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4b34082..4a62659 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1830,6 +1830,10 @@ config PCI_OLPC
 	def_bool y
 	depends on PCI && OLPC && (PCI_GOOLPC || PCI_GOANY)
 
+config PCI_XEN
+	def_bool y
+	depends on XEN_PCI_PASSTHROUGH || XEN_DOM0_PCI
+
 config PCI_DOMAINS
 	def_bool y
 	depends on PCI
diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index 5401ca2..34f03a4 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -107,6 +107,7 @@ extern int pci_direct_probe(void);
 extern void pci_direct_init(int type);
 extern void pci_pcbios_init(void);
 extern int pci_olpc_init(void);
+extern int pci_xen_init(void);
 extern void __init dmi_check_pciprobe(void);
 extern void __init dmi_check_skip_isa_align(void);
 
diff --git a/arch/x86/include/asm/xen/iommu.h b/arch/x86/include/asm/xen/iommu.h
new file mode 100644
index 0000000..75df312
--- /dev/null
+++ b/arch/x86/include/asm/xen/iommu.h
@@ -0,0 +1,12 @@
+#ifndef ASM_X86__XEN_IOMMU_H
+
+#ifdef CONFIG_PCI_XEN
+extern void xen_iommu_init(void);
+#else
+static inline void xen_iommu_init(void)
+{
+}
+#endif
+
+#endif
+
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 745579b..2fffc22 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -10,6 +10,7 @@
 #include <asm/gart.h>
 #include <asm/calgary.h>
 #include <asm/amd_iommu.h>
+#include <asm/xen/iommu.h>
 
 static int forbid_dac __read_mostly;
 
@@ -275,6 +276,8 @@ static int __init pci_iommu_init(void)
 	dma_debug_add_bus(&pci_bus_type);
 #endif
 
+	xen_iommu_init();
+	
 	calgary_iommu_init();
 
 	intel_iommu_init();
diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index d49202e..64182c5 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_PCI_BIOS)		+= pcbios.o
 obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_$(BITS).o direct.o mmconfig-shared.o
 obj-$(CONFIG_PCI_DIRECT)	+= direct.o
 obj-$(CONFIG_PCI_OLPC)		+= olpc.o
+obj-$(CONFIG_PCI_XEN)		+= xen.o
 
 obj-y				+= fixup.o
 obj-$(CONFIG_ACPI)		+= acpi.o
diff --git a/arch/x86/pci/init.c b/arch/x86/pci/init.c
index 25a1f8e..4e2f90a 100644
--- a/arch/x86/pci/init.c
+++ b/arch/x86/pci/init.c
@@ -15,10 +15,16 @@ static __init int pci_arch_init(void)
 	if (!(pci_probe & PCI_PROBE_NOEARLY))
 		pci_mmcfg_early_init();
 
+#ifdef CONFIG_PCI_XEN
+	if (!pci_xen_init())
+		return 0;
+#endif
+
 #ifdef CONFIG_PCI_OLPC
 	if (!pci_olpc_init())
 		return 0;	/* skip additional checks if it's an XO */
 #endif
+
 #ifdef CONFIG_PCI_BIOS
 	pci_pcbios_init();
 #endif
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
new file mode 100644
index 0000000..76f803f
--- /dev/null
+++ b/arch/x86/pci/xen.c
@@ -0,0 +1,52 @@
+/*
+ * Xen PCI Frontend Stub - puts some "dummy" functions in to the Linux
+ * 			   x86 PCI core to support the Xen PCI Frontend
+ *
+ *   Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/acpi.h>
+
+#include <asm/pci_x86.h>
+
+#include <asm/xen/hypervisor.h>
+
+static int xen_pcifront_enable_irq(struct pci_dev *dev)
+{
+	return 0;
+}
+
+extern int isapnp_disable;
+
+int __init pci_xen_init(void)
+{
+	if (!xen_pv_domain() || xen_initial_domain())
+		return -ENODEV;
+
+	printk(KERN_INFO "PCI: setting up Xen PCI frontend stub\n");
+
+	pcibios_set_cache_line_size();
+
+	pcibios_enable_irq = xen_pcifront_enable_irq;
+	pcibios_disable_irq = NULL;
+
+#ifdef CONFIG_ACPI
+	/* Keep ACPI out of the picture */
+	acpi_noirq = 1;
+#endif
+
+#ifdef CONFIG_ISAPNP
+	/* Stop isapnp from probing */
+	isapnp_disable = 1;
+#endif
+
+	/* Ensure a device still gets scanned even if it's fn number
+	 * is non-zero.
+	 */
+	pci_scan_all_fns = 1;
+
+	return 0;
+}
+
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index ba6af16..8db0cb5 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -27,6 +27,8 @@ obj-$(CONFIG_HT_IRQ) += htirq.o
 # Build Intel IOMMU support
 obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
 
+# Build Xen IOMMU support
+obj-$(CONFIG_PCI_XEN) += xen-iommu.o
 obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
 
 obj-$(CONFIG_PCI_IOV) += iov.o
diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
new file mode 100644
index 0000000..e7a22f1
--- /dev/null
+++ b/drivers/pci/xen-iommu.c
@@ -0,0 +1,302 @@
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/pci.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/scatterlist.h>
+#include <linux/io.h>
+#include <linux/bug.h>
+
+#include <xen/interface/xen.h>
+#include <xen/grant_table.h>
+#include <xen/page.h>
+#include <xen/xen-ops.h>
+
+#include <asm/iommu.h>
+#include <asm/swiotlb.h>
+#include <asm/tlbflush.h>
+
+#define IOMMU_BUG_ON(test)				\
+do {							\
+	if (unlikely(test)) {				\
+		printk(KERN_ALERT "Fatal DMA error! "	\
+		       "Please use 'swiotlb=force'\n");	\
+		BUG();					\
+	}						\
+} while (0)
+
+/* Print address range with message */
+#define PAR(msg, addr, size)					\
+do {							\
+	printk(msg "[%#llx - %#llx]\n",			\
+	(unsigned long long)addr,			\
+	(unsigned long long)addr + size);		\
+} while (0)
+
+struct dma_coherent_mem {
+	void		*virt_base;
+	u32		device_base;
+	int		size;
+	int		flags;
+	unsigned long	*bitmap;
+};
+
+static inline int address_needs_mapping(struct device *hwdev,
+						dma_addr_t addr)
+{
+	dma_addr_t mask = 0xffffffff;
+	int ret;
+
+	/* If the device has a mask, use it, otherwise default to 32 bits */
+	if (hwdev && hwdev->dma_mask)
+		mask = *hwdev->dma_mask;
+
+	ret = (addr & ~mask) != 0;
+
+	if (ret) {
+		printk(KERN_ERR "dma address needs mapping\n");
+		printk(KERN_ERR "mask: %#llx\n address: [%#llx]\n", mask, addr);
+	}
+	return ret;
+}
+
+static int check_pages_physically_contiguous(unsigned long pfn,
+					     unsigned int offset,
+					     size_t length)
+{
+	unsigned long next_mfn;
+	int i;
+	int nr_pages;
+
+	next_mfn = pfn_to_mfn(pfn);
+	nr_pages = (offset + length + PAGE_SIZE-1) >> PAGE_SHIFT;
+
+	for (i = 1; i < nr_pages; i++) {
+		if (pfn_to_mfn(++pfn) != ++next_mfn)
+			return 0;
+	}
+	return 1;
+}
+
+static int range_straddles_page_boundary(phys_addr_t p, size_t size)
+{
+	unsigned long pfn = PFN_DOWN(p);
+	unsigned int offset = p & ~PAGE_MASK;
+
+	if (offset + size <= PAGE_SIZE)
+		return 0;
+	if (check_pages_physically_contiguous(pfn, offset, size))
+		return 0;
+	return 1;
+}
+
+static inline void xen_dma_unmap_page(struct page *page)
+{
+	/* Xen TODO: 2.6.18 xen calls __gnttab_dma_unmap_page here
+	 * to deal with foreign pages.  We'll need similar logic here at
+	 * some point.
+	 */
+}
+
+/* Gets dma address of a page */
+static inline dma_addr_t xen_dma_map_page(struct page *page)
+{
+	/* Xen TODO: 2.6.18 xen calls __gnttab_dma_map_page here to deal
+	 * with foreign pages.  We'll need similar logic here at some
+	 * point.
+	 */
+	return ((dma_addr_t)pfn_to_mfn(page_to_pfn(page))) << PAGE_SHIFT;
+}
+
+static int xen_map_sg(struct device *hwdev, struct scatterlist *sg,
+			int nents, int direction)
+{
+	struct scatterlist *s;
+	struct page *page;
+	int i, rc;
+
+	BUG_ON(direction == DMA_NONE);
+	WARN_ON(nents == 0 || sg[0].length == 0);
+
+	for_each_sg(sg, s, nents, i) {
+		BUG_ON(!sg_page(s));
+		page = sg_page(s);
+		s->dma_address = xen_dma_map_page(page) + s->offset;
+		s->dma_length = s->length;
+		IOMMU_BUG_ON(range_straddles_page_boundary(
+				page_to_phys(page), s->length));
+	}
+
+	rc = nents;
+
+	flush_write_buffers();
+	return rc;
+}
+
+static void xen_unmap_sg(struct device *hwdev, struct scatterlist *sg,
+			 int nents, int direction)
+{
+	struct scatterlist *s;
+	struct page *page;
+	int i;
+
+	for_each_sg(sg, s, nents, i) {
+		page = pfn_to_page(mfn_to_pfn(PFN_DOWN(s->dma_address)));
+		xen_dma_unmap_page(page);
+	}
+}
+
+static void *xen_alloc_coherent(struct device *dev, size_t size,
+				dma_addr_t *dma_handle, gfp_t gfp)
+{
+	void *ret;
+	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
+	unsigned int order = get_order(size);
+	unsigned long vstart;
+	u64 mask;
+
+	/* ignore region specifiers */
+	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
+
+	if (mem) {
+		int page = bitmap_find_free_region(mem->bitmap, mem->size,
+						     order);
+		if (page >= 0) {
+			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
+			ret = mem->virt_base + (page << PAGE_SHIFT);
+			memset(ret, 0, size);
+			return ret;
+		}
+		if (mem->flags & DMA_MEMORY_EXCLUSIVE)
+			return NULL;
+	}
+
+	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
+		gfp |= GFP_DMA;
+
+	vstart = __get_free_pages(gfp, order);
+	ret = (void *)vstart;
+
+	if (dev != NULL && dev->coherent_dma_mask)
+		mask = dev->coherent_dma_mask;
+	else
+		mask = 0xffffffff;
+
+	if (ret != NULL) {
+		if (xen_create_contiguous_region(vstart, order,
+						 fls64(mask)) != 0) {
+			free_pages(vstart, order);
+			return NULL;
+		}
+		memset(ret, 0, size);
+		*dma_handle = virt_to_machine(ret).maddr;
+	}
+	return ret;
+}
+
+static void xen_free_coherent(struct device *dev, size_t size,
+			 void *vaddr, dma_addr_t dma_addr)
+{
+	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
+	int order = get_order(size);
+
+	if (mem && vaddr >= mem->virt_base &&
+	    vaddr < (mem->virt_base + (mem->size << PAGE_SHIFT))) {
+		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
+		bitmap_release_region(mem->bitmap, page, order);
+	} else {
+		xen_destroy_contiguous_region((unsigned long)vaddr, order);
+		free_pages((unsigned long)vaddr, order);
+	}
+}
+
+static dma_addr_t xen_swiotlb_map_single(struct device *dev, phys_addr_t paddr,
+					 size_t size, int direction)
+{
+	dma_addr_t dma;
+	BUG_ON(direction == DMA_NONE);
+
+	WARN_ON(size == 0);
+	dma = swiotlb_map_single(dev, phys_to_virt(paddr), size, direction);
+
+	flush_write_buffers();
+	return dma;
+}
+
+static dma_addr_t xen_map_single(struct device *dev, phys_addr_t paddr,
+					size_t size, int direction)
+{
+	struct page *page;
+	dma_addr_t dma;
+
+	BUG_ON(direction == DMA_NONE);
+
+	WARN_ON(size == 0);
+	page = pfn_to_page(PFN_DOWN(paddr));
+
+	dma = xen_dma_map_page(page) + offset_in_page(paddr);
+
+	IOMMU_BUG_ON(address_needs_mapping(dev, dma));
+	IOMMU_BUG_ON(range_straddles_page_boundary(paddr, size));
+	flush_write_buffers();
+	return dma;
+}
+
+static void xen_unmap_single(struct device *dev, dma_addr_t dma_addr,
+				size_t size, int direction)
+{
+	BUG_ON(direction == DMA_NONE);
+	xen_dma_unmap_page(pfn_to_page(mfn_to_pfn(PFN_DOWN(dma_addr))));
+}
+
+static struct dma_mapping_ops xen_dma_ops = {
+	.dma_supported = NULL,
+
+	.alloc_coherent = xen_alloc_coherent,
+	.free_coherent = xen_free_coherent,
+
+	.map_single = xen_map_single,
+	.unmap_single = xen_unmap_single,
+
+	.map_sg = xen_map_sg,
+	.unmap_sg = xen_unmap_sg,
+
+	.mapping_error = NULL,
+
+	.is_phys = 0,
+};
+
+static struct dma_mapping_ops xen_swiotlb_dma_ops = {
+	.dma_supported = swiotlb_dma_supported,
+
+	.alloc_coherent = xen_alloc_coherent,
+	.free_coherent = xen_free_coherent,
+
+	.map_single = xen_swiotlb_map_single,	/* swiotlb_map_single has a different prototype */
+	.unmap_single = swiotlb_unmap_single,
+
+	.map_sg = swiotlb_map_sg,
+	.unmap_sg = swiotlb_unmap_sg,
+
+	.mapping_error = swiotlb_dma_mapping_error,
+
+	.is_phys = 0,
+};
+
+void __init xen_iommu_init(void)
+{
+	if (!xen_pv_domain())
+		return;
+
+	printk(KERN_INFO "Xen: Initializing Xen DMA ops\n");
+
+	force_iommu = 0;
+	dma_ops = &xen_dma_ops;
+
+	if (swiotlb) {
+		printk(KERN_INFO "Xen: Enabling DMA fallback to swiotlb\n");
+		dma_ops = &xen_swiotlb_dma_ops;
+	}
+}
+
-- 
1.6.0.6

