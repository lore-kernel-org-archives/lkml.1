Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbZCMRFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbZCMRFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759636AbZCMRBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:17 -0400
Received: from gw.goop.org ([64.81.55.164]:57423 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759650AbZCMRBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:16 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>, Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 14/27] xen: enable swiotlb for xen domain 0.
Date: Fri, 13 Mar 2009 09:59:59 -0700
Message-Id: <1236963612-14287-15-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/x86/kernel/pci-swiotlb.c |    4 ++++
 arch/x86/xen/Kconfig          |    1 +
 drivers/pci/xen-iommu.c       |    5 +++++
 include/xen/swiotlb.h         |    2 ++
 4 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 5826be8..6d3ba02 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -94,6 +94,10 @@ void __init pci_swiotlb_init(void)
 	if (!iommu_detected && !no_iommu && max_pfn > MAX_DMA32_PFN)
 	       swiotlb = 1;
 #endif
+#ifdef CONFIG_PCI_XEN
+	if (xen_wants_swiotlb())
+		swiotlb = 1;
+#endif
 	if (swiotlb_force)
 		swiotlb = 1;
 	if (swiotlb) {
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 87c13db..2c85967 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -6,6 +6,7 @@ config XEN
 	bool "Xen guest support"
 	select PARAVIRT
 	select PARAVIRT_CLOCK
+	select SWIOTLB
 	depends on X86_64 || (X86_32 && X86_PAE && !X86_VISWS)
 	depends on X86_CMPXCHG && X86_TSC
 	help
diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index 0995ddf..80bb7ed 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -67,6 +67,11 @@ void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 	}
 }
 
+int xen_wants_swiotlb(void)
+{
+	return xen_initial_domain();
+}
+
 dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
 {
 	return phys_to_machine(XPADDR(paddr)).maddr;
diff --git a/include/xen/swiotlb.h b/include/xen/swiotlb.h
index e15caa8..defac5c 100644
--- a/include/xen/swiotlb.h
+++ b/include/xen/swiotlb.h
@@ -9,6 +9,8 @@ static inline void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslab
 }
 #endif
 
+extern int xen_wants_swiotlb(void);
+
 extern phys_addr_t xen_bus_to_phys(dma_addr_t daddr);
 extern dma_addr_t xen_phys_to_bus(phys_addr_t paddr);
 
-- 
1.6.0.6

