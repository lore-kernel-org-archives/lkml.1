Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbZCMRDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbZCMRDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759590AbZCMRBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:05 -0400
Received: from gw.goop.org ([64.81.55.164]:57410 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757548AbZCMRBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:03 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>, Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 12/27] xen: add hooks for mapping phys<->bus addresses in swiotlb
Date: Fri, 13 Mar 2009 09:59:57 -0700
Message-Id: <1236963612-14287-13-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Add hooks to allow Xen to do translation between pfn and mfns for the swiotlb
layer, so that dma actually ends up going to the proper machine pages.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/pci-swiotlb.c |    8 ++++++++
 drivers/pci/xen-iommu.c       |   10 ++++++++++
 include/xen/swiotlb.h         |    3 +++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 298f01d..0943813 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -33,11 +33,19 @@ void *swiotlb_alloc(unsigned order, unsigned long nslabs)
 
 dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 {
+#ifdef CONFIG_PCI_XEN
+	if (xen_pv_domain())
+		return xen_phys_to_bus(paddr);
+#endif
 	return paddr;
 }
 
 phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
 {
+#ifdef CONFIG_PCI_XEN
+	if (xen_pv_domain())
+		return xen_bus_to_phys(baddr);
+#endif
 	return baddr;
 }
 
diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index d546698..e7ba06b 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -67,6 +67,16 @@ void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 	}
 }
 
+dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
+{
+	return phys_to_machine(XPADDR(paddr)).maddr;
+}
+
+phys_addr_t xen_bus_to_phys(dma_addr_t daddr)
+{
+	return machine_to_phys(XMADDR(daddr)).paddr;
+}
+
 static inline int address_needs_mapping(struct device *hwdev,
 						dma_addr_t addr)
 {
diff --git a/include/xen/swiotlb.h b/include/xen/swiotlb.h
index 8d59439..9ecaff1 100644
--- a/include/xen/swiotlb.h
+++ b/include/xen/swiotlb.h
@@ -9,4 +9,7 @@ static inline void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslab
 }
 #endif
 
+extern phys_addr_t xen_bus_to_phys(dma_addr_t daddr);
+extern dma_addr_t xen_phys_to_bus(phys_addr_t paddr);
+
 #endif /* _XEN_SWIOTLB_H */
-- 
1.6.0.6

