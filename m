Return-Path: <linux-kernel-owner+w=401wt.eu-S1760911AbZCMRGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911AbZCMRGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759875AbZCMRB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:26 -0400
Received: from gw.goop.org ([64.81.55.164]:57422 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759782AbZCMRBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:23 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>, Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 13/27] xen/swiotlb: add hook for swiotlb_arch_range_needs_mapping
Date: Fri, 13 Mar 2009 09:59:58 -0700
Message-Id: <1236963612-14287-14-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Add hook so that Xen can determine whether a particular address range needs
pfn<->mfn mapping.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/pci-swiotlb.c |    4 ++++
 drivers/pci/xen-iommu.c       |    5 +++++
 include/xen/swiotlb.h         |    2 ++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 0943813..5826be8 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -51,6 +51,10 @@ phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
 
 int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
 {
+#ifdef CONFIG_PCI_XEN
+	if (xen_pv_domain())
+		return xen_range_needs_mapping(paddr, size);
+#endif
 	return 0;
 }
 
diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index e7ba06b..0995ddf 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -126,6 +126,11 @@ static int range_straddles_page_boundary(phys_addr_t p, size_t size)
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
index 9ecaff1..e15caa8 100644
--- a/include/xen/swiotlb.h
+++ b/include/xen/swiotlb.h
@@ -12,4 +12,6 @@ static inline void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslab
 extern phys_addr_t xen_bus_to_phys(dma_addr_t daddr);
 extern dma_addr_t xen_phys_to_bus(phys_addr_t paddr);
 
+extern int xen_range_needs_mapping(phys_addr_t phys, size_t size);
+
 #endif /* _XEN_SWIOTLB_H */
-- 
1.6.0.6

