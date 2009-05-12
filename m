Return-Path: <linux-kernel-owner+w=401wt.eu-S1759776AbZEMDPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776AbZEMDPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbZEMDG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:28 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36235
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755980AbZEMDGL (ORCPT
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
Subject: [PATCH 05/10] xen: enable swiotlb for xen domain 0.
Date: Tue, 12 May 2009 14:50:46 -0700
Message-Id: <1242165051-6636-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242165051-6636-1-git-send-email-jeremy@goop.org>
References: <1242165051-6636-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Enable swiotlb when running as a Xen dom0 domain.

[ Impact: enable swiotlb under Xen ]
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-swiotlb.c |    5 +++++
 arch/x86/xen/Kconfig          |    1 +
 drivers/pci/xen-iommu.c       |    5 +++++
 include/xen/swiotlb.h         |    1 +
 4 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 9640e17..7267376 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -11,6 +11,8 @@
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
 
+#include <xen/swiotlb.h>
+
 int swiotlb __read_mostly;
 
 static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
@@ -49,6 +51,9 @@ void __init pci_swiotlb_init(void)
 	if (!iommu_detected && !no_iommu && max_pfn > MAX_DMA32_PFN)
 	       swiotlb = 1;
 #endif
+	if (xen_wants_swiotlb())
+		swiotlb = 1;
+
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
index be50f0f..678a0e5 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -60,6 +60,11 @@ void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
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
index 8b51ff7..f35183b 100644
--- a/include/xen/swiotlb.h
+++ b/include/xen/swiotlb.h
@@ -5,5 +5,6 @@ extern void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs);
 extern phys_addr_t xen_bus_to_phys(dma_addr_t daddr);
 extern dma_addr_t xen_phys_to_bus(phys_addr_t paddr);
 extern int xen_range_needs_mapping(phys_addr_t phys, size_t size);
+extern int xen_wants_swiotlb(void);
 
 #endif /* _XEN_SWIOTLB_H */
-- 
1.6.0.6

