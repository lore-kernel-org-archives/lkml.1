Return-Path: <linux-kernel-owner+w=401wt.eu-S1764322AbZEHAjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764322AbZEHAjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932310AbZEHARa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:17:30 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:48370
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762512AbZEHAR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:17:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 5/9] xen: enable swiotlb for xen domain 0.
Date: Thu,  7 May 2009 17:17:18 -0700
Message-Id: <1241741842-7966-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241741842-7966-1-git-send-email-jeremy@goop.org>
References: <1241741842-7966-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Impact: Xen DMA support

Enable swiotlb when running as a Xen dom0 domain.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-swiotlb.c |    5 +++++
 arch/x86/xen/Kconfig          |    1 +
 drivers/pci/xen-iommu.c       |    5 +++++
 include/xen/swiotlb.h         |    9 +++++++++
 4 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 861c869..2d8dd35 100644
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
index 994671c..4625143 100644
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
index 8b51ff7..75d1da1 100644
--- a/include/xen/swiotlb.h
+++ b/include/xen/swiotlb.h
@@ -6,4 +6,13 @@ extern phys_addr_t xen_bus_to_phys(dma_addr_t daddr);
 extern dma_addr_t xen_phys_to_bus(phys_addr_t paddr);
 extern int xen_range_needs_mapping(phys_addr_t phys, size_t size);
 
+#ifdef CONFIG_PCI_XEN
+extern int xen_wants_swiotlb(void);
+#else
+static inline int xen_wants_swiotlb(void)
+{
+	return 0;
+}
+#endif
+
 #endif /* _XEN_SWIOTLB_H */
-- 
1.6.0.6

