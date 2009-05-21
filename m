Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbZEUQQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbZEUQQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbZEUQPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:15:45 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26689 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbZEUQPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:15:44 -0400
X-IronPort-AV: E=Sophos;i="4.41,228,1241409600"; 
   d="scan'208";a="52100796"
From: Ian Campbell <ian.campbell@citrix.com>
To: ian.campbell@citrix.com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <beckyb@kernel.crashing.org>, Olaf Kirch <okir@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       xen-devel <xendevel@lists.xensource.com>,
       x86 maintainers <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] swiotlb/xen: update xen for changes to swiotlb allocation interface
Date: Thu, 21 May 2009 17:15:26 +0100
Message-Id: <1242922528-5982-6-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 21 May 2009 16:15:45.0515 (UTC) FILETIME=[6554E3B0:01C9DA2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is now implemented via an explicit hook in
arch/x86/kernel/pci-swiotlb.c rather than as a weak hook in
swiotlb.c

Initialsation of the hook needs to happen before xen_iommu_init() is
called so add detect_xen_iommu() (mirroring other IOMMU
implementations) which is called early enough.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Becky Bruce <beckyb@kernel.crashing.org>
Cc: Olaf Kirch <okir@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>
Cc: xen-devel <xendevel@lists.xensource.com>
Cc: x86 maintainers <x86@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
---
 arch/x86/include/asm/xen/iommu.h |    4 ++++
 arch/x86/kernel/pci-dma.c        |    4 +++-
 drivers/pci/xen-iommu.c          |   14 +++++++++++---
 include/xen/swiotlb.h            |    1 -
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/xen/iommu.h b/arch/x86/include/asm/xen/iommu.h
index 75df312..22b6091 100644
--- a/arch/x86/include/asm/xen/iommu.h
+++ b/arch/x86/include/asm/xen/iommu.h
@@ -1,8 +1,12 @@
 #ifndef ASM_X86__XEN_IOMMU_H
 
 #ifdef CONFIG_PCI_XEN
+extern void detect_xen_iommu(void);
 extern void xen_iommu_init(void);
 #else
+static inline void detect_xen_iommu(void)
+{
+}
 static inline void xen_iommu_init(void)
 {
 }
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 587cc6a..695f8a6 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -121,6 +121,8 @@ void __init pci_iommu_alloc(void)
 	 */
 	gart_iommu_hole_init();
 
+	detect_xen_iommu();
+
 	detect_calgary();
 
 	detect_intel_iommu();
@@ -277,7 +279,7 @@ static int __init pci_iommu_init(void)
 #endif
 
 	xen_iommu_init();
-	
+
 	calgary_iommu_init();
 
 	intel_iommu_init();
diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index f65660a..2d727d1 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -39,7 +39,8 @@ do {							\
 
 static int max_dma_bits = 32;
 
-void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
+static void __init xen_swiotlb_alloc_fixup(void *buf, size_t size,
+					   unsigned long nslabs)
 {
 	int i, rc;
 	int dma_bits;
@@ -314,6 +315,15 @@ static struct dma_map_ops xen_swiotlb_dma_ops = {
 	.is_phys = 0,
 };
 
+void __init detect_xen_iommu(void)
+{
+	if (!xen_pv_domain())
+		return;
+
+	x86_swiotlb_force_mapping = &xen_swiotlb_force_mapping;
+	x86_swiotlb_alloc_fixup = &xen_swiotlb_alloc_fixup;
+}
+
 void __init xen_iommu_init(void)
 {
 	if (!xen_pv_domain())
@@ -324,8 +334,6 @@ void __init xen_iommu_init(void)
 	force_iommu = 0;
 	dma_ops = &xen_dma_ops;
 
-	x86_swiotlb_force_mapping = &xen_swiotlb_force_mapping;
-
 	if (swiotlb) {
 		printk(KERN_INFO "Xen: Enabling DMA fallback to swiotlb\n");
 		dma_ops = &xen_swiotlb_dma_ops;
diff --git a/include/xen/swiotlb.h b/include/xen/swiotlb.h
index 64137fa..83ec002 100644
--- a/include/xen/swiotlb.h
+++ b/include/xen/swiotlb.h
@@ -1,7 +1,6 @@
 #ifndef _XEN_SWIOTLB_H
 #define _XEN_SWIOTLB_H
 
-extern void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs);
 extern phys_addr_t xen_bus_to_phys(dma_addr_t daddr);
 extern dma_addr_t xen_phys_to_bus(phys_addr_t paddr);
 
-- 
1.5.6.5

