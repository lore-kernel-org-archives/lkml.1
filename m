Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbZEMDLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbZEMDLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbZEMDGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:14 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36219
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756049AbZEMDGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:06:07 -0400
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
Subject: [PATCH 03/10] xen: add hooks for mapping phys<->bus addresses in swiotlb
Date: Tue, 12 May 2009 14:50:44 -0700
Message-Id: <1242165051-6636-4-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242165051-6636-1-git-send-email-jeremy@goop.org>
References: <1242165051-6636-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Add hooks to allow Xen to do translation between pfn and mfns for the swiotlb
layer, so that dma actually ends up going to the proper machine pages.

[ Impact: Xen support for DMA ]
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-swiotlb.c |   10 ----------
 arch/x86/xen/pci-swiotlb.c    |   16 ++++++++++++++++
 drivers/pci/xen-iommu.c       |   10 ++++++++++
 include/xen/swiotlb.h         |    2 ++
 4 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 880b7bc..3e2ffd6 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -13,16 +13,6 @@
 
 int swiotlb __read_mostly;
 
-dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
-{
-	return paddr;
-}
-
-phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
-{
-	return baddr;
-}
-
 int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
 {
 	return 0;
diff --git a/arch/x86/xen/pci-swiotlb.c b/arch/x86/xen/pci-swiotlb.c
index 7665d3b..646f2bf 100644
--- a/arch/x86/xen/pci-swiotlb.c
+++ b/arch/x86/xen/pci-swiotlb.c
@@ -25,3 +25,19 @@ void *swiotlb_alloc(unsigned order, unsigned long nslabs)
 	WARN_ON(1);
 	return NULL;
 }
+
+dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
+{
+	if (xen_pv_domain())
+		return xen_phys_to_bus(paddr);
+
+	return paddr;
+}
+
+phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
+{
+	if (xen_pv_domain())
+		return xen_bus_to_phys(baddr);
+
+	return baddr;
+}
diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index ee7b9fb..a5a3b32 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -60,6 +60,16 @@ void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
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
index 67b7b42..4229f27 100644
--- a/include/xen/swiotlb.h
+++ b/include/xen/swiotlb.h
@@ -2,5 +2,7 @@
 #define _XEN_SWIOTLB_H
 
 extern void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs);
+extern phys_addr_t xen_bus_to_phys(dma_addr_t daddr);
+extern dma_addr_t xen_phys_to_bus(phys_addr_t paddr);
 
 #endif /* _XEN_SWIOTLB_H */
-- 
1.6.0.6

