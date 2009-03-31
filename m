Return-Path: <linux-kernel-owner+w=401wt.eu-S1763989AbZCaWxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763989AbZCaWxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763602AbZCaWwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:52:21 -0400
Received: from gw.goop.org ([64.81.55.164]:53469 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758398AbZCaWwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:52:19 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 4/9] xen/swiotlb: add hook for swiotlb_arch_range_needs_mapping
Date: Tue, 31 Mar 2009 15:52:10 -0700
Message-Id: <1238539935-4295-5-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238539935-4295-1-git-send-email-jeremy@goop.org>
References: <1238539935-4295-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Impact: Xen support for DMA

Add hook so that Xen can determine whether a particular address range needs
pfn<->mfn mapping.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/pci-swiotlb_64.c |    3 +++
 drivers/pci/xen-iommu.c          |    5 +++++
 include/xen/swiotlb.h            |    8 ++++++++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index 7f87ce2..7aa8c18 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -54,6 +54,9 @@ phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
 
 int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
 {
+	if (xen_pv_domain())
+		return xen_range_needs_mapping(paddr, size);
+
 	return 0;
 }
 
diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index 47d87a7..fcef078 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -118,6 +118,11 @@ static int range_straddles_page_boundary(phys_addr_t p, size_t size)
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
index 3d96b07..e975aa0 100644
--- a/include/xen/swiotlb.h
+++ b/include/xen/swiotlb.h
@@ -5,6 +5,7 @@
 extern void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs);
 extern phys_addr_t xen_bus_to_phys(dma_addr_t daddr);
 extern dma_addr_t xen_phys_to_bus(phys_addr_t paddr);
+extern int xen_range_needs_mapping(phys_addr_t phys, size_t size);
 #else
 static inline void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 {
@@ -19,6 +20,13 @@ static inline dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
 {
 	return paddr;
 }
+
+static inline int xen_range_needs_mapping(phys_addr_t phys, size_t size)
+{
+	return 0;
+}
 #endif
 
+
+
 #endif /* _XEN_SWIOTLB_H */
-- 
1.6.0.6

