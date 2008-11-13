Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbYKMTlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbYKMTlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYKMTeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:21 -0500
Received: from gw.goop.org ([64.81.55.164]:34395 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbYKMTeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:08 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 18 of 38] x86: unify pci iommu setup and allow swiotlb to
	compile for 32 bit
X-Mercurial-Node: e918eb1b71515e7c2f99fccef9b44f9ad3225886
Message-Id: <e918eb1b71515e7c2f99.1226603416@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:16 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swiotlb on 32 bit will be used by Xen domain 0 support.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/x86/include/asm/dma-mapping.h |    6 +-----
 arch/x86/include/asm/pci.h         |    2 ++
 arch/x86/include/asm/pci_64.h      |    1 -
 arch/x86/kernel/Makefile           |    3 ++-
 arch/x86/kernel/pci-dma.c          |    6 ++++--
 arch/x86/kernel/pci-swiotlb_64.c   |    2 ++
 arch/x86/mm/init_32.c              |    3 +++
 7 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -66,21 +66,17 @@
 		return dma_ops;
 	else
 		return dev->archdata.dma_ops;
-#endif /* _ASM_X86_DMA_MAPPING_H */
+#endif
 }
 
 /* Make sure we keep the same behaviour */
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-#ifdef CONFIG_X86_32
-	return 0;
-#else
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
 
 	return (dma_addr == bad_dma_address);
-#endif
 }
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -84,6 +84,8 @@
 static inline void early_quirks(void) { }
 #endif
 
+extern void pci_iommu_alloc(void);
+
 #endif  /* __KERNEL__ */
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/include/asm/pci_64.h b/arch/x86/include/asm/pci_64.h
--- a/arch/x86/include/asm/pci_64.h
+++ b/arch/x86/include/asm/pci_64.h
@@ -23,7 +23,6 @@
 			       int reg, int len, u32 value);
 
 extern void dma32_reserve_bootmem(void);
-extern void pci_iommu_alloc(void);
 
 /* The PCI address space does equal the physical memory
  * address space.  The networking and block device layers use
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -115,6 +115,8 @@
 
 obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 
+obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb_64.o # NB rename without _64
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
@@ -128,7 +130,6 @@
         obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
         obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
         obj-$(CONFIG_AMD_IOMMU)		+= amd_iommu_init.o amd_iommu.o
-        obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb_64.o
 
         obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
 endif
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -105,11 +105,15 @@
 	dma32_bootmem_ptr = NULL;
 	dma32_bootmem_size = 0;
 }
+#endif
 
 void __init pci_iommu_alloc(void)
 {
+#ifdef CONFIG_X86_64
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
+#endif
+
 	/*
 	 * The order of these functions is important for
 	 * fall-back/fail-over reasons
@@ -125,8 +129,6 @@
 	pci_swiotlb_init();
 }
 
-#endif
-
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 				 dma_addr_t *dma_addr, gfp_t flag)
 {
diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -62,8 +62,10 @@
 void __init pci_swiotlb_init(void)
 {
 	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
+#ifdef CONFIG_X86_64
 	if (!iommu_detected && !no_iommu && max_pfn > MAX_DMA32_PFN)
 	       swiotlb = 1;
+#endif
 	if (swiotlb_force)
 		swiotlb = 1;
 	if (swiotlb) {
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/pci.h>
 #include <linux/pfn.h>
 #include <linux/poison.h>
 #include <linux/bootmem.h>
@@ -971,6 +972,8 @@
 	int codesize, reservedpages, datasize, initsize;
 	int tmp;
 
+	pci_iommu_alloc();
+
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
 #endif


