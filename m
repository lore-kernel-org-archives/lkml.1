Return-Path: <linux-kernel-owner+w=401wt.eu-S1763917AbZCaWwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763917AbZCaWwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761187AbZCaWwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:52:20 -0400
Received: from gw.goop.org ([64.81.55.164]:53467 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758276AbZCaWwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:52:19 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 3/9] xen: add hooks for mapping phys<->bus addresses in swiotlb
Date: Tue, 31 Mar 2009 15:52:09 -0700
Message-Id: <1238539935-4295-4-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238539935-4295-1-git-send-email-jeremy@goop.org>
References: <1238539935-4295-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Impact: Xen support for DMA

Add hooks to allow Xen to do translation between pfn and mfns for the swiotlb
layer, so that dma actually ends up going to the proper machine pages.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/pci-swiotlb_64.c |    6 ++++++
 drivers/pci/xen-iommu.c          |   10 ++++++++++
 include/xen/swiotlb.h            |   12 ++++++++++++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index be379af..7f87ce2 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -38,11 +38,17 @@ void *swiotlb_alloc(unsigned order, unsigned long nslabs)
 
 dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 {
+	if (xen_pv_domain())
+		return xen_phys_to_bus(paddr);
+
 	return paddr;
 }
 
 phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
 {
+	if (xen_pv_domain())
+		return xen_bus_to_phys(baddr);
+
 	return baddr;
 }
 
diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index b9b4620..47d87a7 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -59,6 +59,16 @@ void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 			panic(KERN_ERR "xen_create_contiguous_region failed\n");
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
index 8d59439..3d96b07 100644
--- a/include/xen/swiotlb.h
+++ b/include/xen/swiotlb.h
@@ -3,10 +3,22 @@
 
 #ifdef CONFIG_PCI_XEN
 extern void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs);
+extern phys_addr_t xen_bus_to_phys(dma_addr_t daddr);
+extern dma_addr_t xen_phys_to_bus(phys_addr_t paddr);
 #else
 static inline void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 {
 }
+
+static inline phys_addr_t xen_bus_to_phys(dma_addr_t daddr)
+{
+	return daddr;
+}
+
+static inline dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
+{
+	return paddr;
+}
 #endif
 
 #endif /* _XEN_SWIOTLB_H */
-- 
1.6.0.6

