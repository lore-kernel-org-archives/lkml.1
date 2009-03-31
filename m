Return-Path: <linux-kernel-owner+w=401wt.eu-S1763971AbZCaWy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763971AbZCaWy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763801AbZCaWwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:52:23 -0400
Received: from gw.goop.org ([64.81.55.164]:53480 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761164AbZCaWwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:52:20 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 5/9] xen: enable swiotlb for xen domain 0.
Date: Tue, 31 Mar 2009 15:52:11 -0700
Message-Id: <1238539935-4295-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238539935-4295-1-git-send-email-jeremy@goop.org>
References: <1238539935-4295-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Impact: Xen DMA support

Enable swiotlb when running as a Xen dom0 domain.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/pci-swiotlb_64.c |    3 +++
 arch/x86/xen/Kconfig             |    1 +
 drivers/pci/xen-iommu.c          |    5 +++++
 include/xen/swiotlb.h            |    6 ++++++
 4 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index 7aa8c18..3b9f817 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -103,6 +103,9 @@ void __init pci_swiotlb_init(void)
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
index fcef078..95d0753 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -59,6 +59,11 @@ void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 			panic(KERN_ERR "xen_create_contiguous_region failed\n");
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
index e975aa0..9134516 100644
--- a/include/xen/swiotlb.h
+++ b/include/xen/swiotlb.h
@@ -6,6 +6,7 @@ extern void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs);
 extern phys_addr_t xen_bus_to_phys(dma_addr_t daddr);
 extern dma_addr_t xen_phys_to_bus(phys_addr_t paddr);
 extern int xen_range_needs_mapping(phys_addr_t phys, size_t size);
+extern int xen_wants_swiotlb(void);
 #else
 static inline void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 {
@@ -25,6 +26,11 @@ static inline int xen_range_needs_mapping(phys_addr_t phys, size_t size)
 {
 	return 0;
 }
+
+static inline int xen_wants_swiotlb(void)
+{
+	return 0;
+}
 #endif
 
 
-- 
1.6.0.6

