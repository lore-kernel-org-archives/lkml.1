Return-Path: <linux-kernel-owner+w=401wt.eu-S1759645AbZEMDQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645AbZEMDQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbZEMDG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:29 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36224
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756070AbZEMDGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:06:11 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 04/10] xen/swiotlb: add hook for swiotlb_arch_range_needs_mapping
Date: Tue, 12 May 2009 14:50:45 -0700
Message-Id: <1242165051-6636-5-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242165051-6636-1-git-send-email-jeremy@goop.org>
References: <1242165051-6636-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Add hook so that Xen can determine whether a particular address range needs
pfn<->mfn mapping.

[ Impact: make Xen DMA work ]
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-swiotlb.c |    5 -----
 arch/x86/xen/pci-swiotlb.c    |    8 ++++++++
 drivers/pci/xen-iommu.c       |    5 +++++
 include/xen/swiotlb.h         |    1 +
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 3e2ffd6..9640e17 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -13,11 +13,6 @@
 
 int swiotlb __read_mostly;
 
-int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
-{
-	return 0;
-}
-
 static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flags)
 {
diff --git a/arch/x86/xen/pci-swiotlb.c b/arch/x86/xen/pci-swiotlb.c
index 646f2bf..c2850b3 100644
--- a/arch/x86/xen/pci-swiotlb.c
+++ b/arch/x86/xen/pci-swiotlb.c
@@ -41,3 +41,11 @@ phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
 
 	return baddr;
 }
+
+int swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
+{
+	if (xen_pv_domain())
+		return xen_range_needs_mapping(paddr, size);
+
+	return 0;
+}
diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index a5a3b32..be50f0f 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -119,6 +119,11 @@ static int range_straddles_page_boundary(phys_addr_t p, size_t size)
 	return 1;
 }
 
+int xen_range_needs_mapping(phys_addr_t paddr, size_t size)
+{
+	return range_straddles_page_boundary(paddr, size);
+}
+
 static inline void xen_dma_unmap_page(struct page *page)
 {
 	/* Xen TODO: 2.6.18 xen calls __gnttab_dma_unmap_page here
diff --git a/include/xen/swiotlb.h b/include/xen/swiotlb.h
index 4229f27..8b51ff7 100644
--- a/include/xen/swiotlb.h
+++ b/include/xen/swiotlb.h
@@ -4,5 +4,6 @@
 extern void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs);
 extern phys_addr_t xen_bus_to_phys(dma_addr_t daddr);
 extern dma_addr_t xen_phys_to_bus(phys_addr_t paddr);
+extern int xen_range_needs_mapping(phys_addr_t phys, size_t size);
 
 #endif /* _XEN_SWIOTLB_H */
-- 
1.6.0.6

