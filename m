Return-Path: <linux-kernel-owner+w=401wt.eu-S1751197AbZJWBWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbZJWBWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 21:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbZJWBWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 21:22:41 -0400
Received: from sous-sol.org ([216.99.217.87]:52775 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750863AbZJWBWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 21:22:40 -0400
Message-Id: <20091023012222.097196027@sequoia.sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 22 Oct 2009 18:22:01 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [RFC PATCH 3/3] [RFC PATCH] iommu: allow fallback to swiotlb upon hw iommu initialization failure
References: <20091023012158.177308035@sequoia.sous-sol.org>
Content-Disposition: inline; filename=vtd-swiotlb-fallback-v3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a hw iommu is detected during pci_iommu_alloc() it will disable
the swiotlb setup.  If the subsequent hw iommu initialization in
pci_iommu_init() fails, the box may be left in an unusable state.

The swiotlb is normally allocated early from bootmem to ensure a large
(64M) contiguous allocation.  This patch adds some logic to go ahead
and allocate the swiotlb despite the presence of a hw iommu, and later
free the swiotlb if it is not needed or enable it if it is.  Because
pci_iommu_init() is called after bootmem has been released to the page
allocator, we use free_bootmem_late, a new mechanism for freeing pages
directly back to the allocator.

This patch relies on (iommu_detected && !dma_ops) being true as a way
to see the failed hw iommu initialization.  This will not work w/ AMD
IOMMU in passthrough mode.

https://bugzilla.redhat.com/show_bug.cgi?id=524808

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/include/asm/swiotlb.h |    4 ++++
 arch/x86/kernel/pci-dma.c      |    4 +++-
 arch/x86/kernel/pci-swiotlb.c  |   27 +++++++++++++++++++++------
 include/linux/swiotlb.h        |    3 +++
 lib/swiotlb.c                  |   10 ++++++++++
 5 files changed, 41 insertions(+), 7 deletions(-)

--- a/arch/x86/include/asm/swiotlb.h
+++ b/arch/x86/include/asm/swiotlb.h
@@ -9,9 +9,13 @@ extern int swiotlb_force;
 
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
+extern void pci_swiotlb_alloc(void);
 extern void pci_swiotlb_init(void);
 #else
 #define swiotlb 0
+static inline void pci_swiotlb_alloc(void)
+{
+}
 static inline void pci_swiotlb_init(void)
 {
 }
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -141,7 +141,7 @@ void __init pci_iommu_alloc(void)
 
 	amd_iommu_detect();
 
-	pci_swiotlb_init();
+	pci_swiotlb_alloc();
 }
 
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,
@@ -300,6 +300,8 @@ static int __init pci_iommu_init(void)
 
 	gart_iommu_init();
 
+	pci_swiotlb_init();
+
 	no_iommu_init();
 	return 0;
 }
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -42,18 +42,33 @@ static struct dma_map_ops swiotlb_dma_op
 	.dma_supported = NULL,
 };
 
-void __init pci_swiotlb_init(void)
+static int swiotlb_try_init;
+
+void __init pci_swiotlb_alloc(void)
 {
 	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
 #ifdef CONFIG_X86_64
-	if ((!iommu_detected && !no_iommu && max_pfn > MAX_DMA32_PFN))
-		swiotlb = 1;
+	if (!no_iommu && max_pfn > MAX_DMA32_PFN) {
+		if (!iommu_detected)
+			swiotlb = 1;
+		else
+			swiotlb_try_init = 1;
+	}
 #endif
 	if (swiotlb_force)
 		swiotlb = 1;
-	if (swiotlb) {
-		printk(KERN_INFO "PCI-DMA: Using software bounce buffering for IO (SWIOTLB)\n");
+	if (swiotlb || swiotlb_try_init)
 		swiotlb_init();
+}
+
+void __init pci_swiotlb_init(void)
+{
+	if (!swiotlb && !swiotlb_try_init)
+		return;
+
+	if (iommu_detected && !dma_ops) {
+		pr_info("PCI-DMA: Using software bounce buffering for IO (SWIOTLB)\n");
 		dma_ops = &swiotlb_dma_ops;
-	}
+	} else
+		swiotlb_free();
 }
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -24,6 +24,9 @@ extern void
 swiotlb_init(void);
 
 extern void
+swiotlb_free(void);
+
+extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
 
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -181,6 +181,16 @@ swiotlb_init_with_default_size(size_t de
 }
 
 void __init
+swiotlb_free(void)
+{
+
+	free_bootmem_late(__pa(io_tlb_overflow_buffer), io_tlb_overflow);
+	free_bootmem_late(__pa(io_tlb_orig_addr), io_tlb_nslabs * sizeof(phys_addr_t));
+	free_bootmem_late(__pa(io_tlb_list), io_tlb_nslabs * sizeof(int));
+	free_bootmem_late(__pa(io_tlb_start) , io_tlb_nslabs << IO_TLB_SHIFT);
+}
+
+void __init
 swiotlb_init(void)
 {
 	swiotlb_init_with_default_size(64 * (1<<20));	/* default to 64MB */

