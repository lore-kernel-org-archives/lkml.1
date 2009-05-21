Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbZEUQQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbZEUQQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbZEUQPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:15:41 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26689 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbZEUQPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:15:40 -0400
X-IronPort-AV: E=Sophos;i="4.41,228,1241409600"; 
   d="scan'208";a="52100777"
From: Ian Campbell <ian.campbell@citrix.com>
To: ian.campbell@citrix.com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <beckyb@kernel.crashing.org>, Olaf Kirch <okir@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       xen-devel <xendevel@lists.xensource.com>,
       x86 maintainers <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] swiotlb/xen: update xen for swiotlb_arch_force_mapping changes
Date: Thu, 21 May 2009 17:15:24 +0100
Message-Id: <1242922528-5982-4-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 21 May 2009 16:15:40.0812 (UTC) FILETIME=[628744C0:01C9DA2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is now implemented via a hook in
arch/x86/include/asm/dma-mapping.h rather than as a weak hook in
swiotlb.c

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
 arch/x86/xen/pci-swiotlb.c |    8 --------
 drivers/pci/xen-iommu.c    |    4 +++-
 include/xen/swiotlb.h      |    1 -
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/pci-swiotlb.c b/arch/x86/xen/pci-swiotlb.c
index 5a46418..e23b00b 100644
--- a/arch/x86/xen/pci-swiotlb.c
+++ b/arch/x86/xen/pci-swiotlb.c
@@ -43,11 +43,3 @@ phys_addr_t swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
 
 	return baddr;
 }
-
-int swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
-{
-	if (xen_pv_domain())
-		return xen_range_needs_mapping(paddr, size);
-
-	return 0;
-}
diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index 41c276f..f65660a 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -130,7 +130,7 @@ static int range_straddles_page_boundary(phys_addr_t p, size_t size)
 	return 1;
 }
 
-int xen_range_needs_mapping(phys_addr_t paddr, size_t size)
+static int xen_swiotlb_force_mapping(phys_addr_t paddr, size_t size)
 {
 	return range_straddles_page_boundary(paddr, size);
 }
@@ -324,6 +324,8 @@ void __init xen_iommu_init(void)
 	force_iommu = 0;
 	dma_ops = &xen_dma_ops;
 
+	x86_swiotlb_force_mapping = &xen_swiotlb_force_mapping;
+
 	if (swiotlb) {
 		printk(KERN_INFO "Xen: Enabling DMA fallback to swiotlb\n");
 		dma_ops = &xen_swiotlb_dma_ops;
diff --git a/include/xen/swiotlb.h b/include/xen/swiotlb.h
index 75d1da1..64137fa 100644
--- a/include/xen/swiotlb.h
+++ b/include/xen/swiotlb.h
@@ -4,7 +4,6 @@
 extern void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs);
 extern phys_addr_t xen_bus_to_phys(dma_addr_t daddr);
 extern dma_addr_t xen_phys_to_bus(phys_addr_t paddr);
-extern int xen_range_needs_mapping(phys_addr_t phys, size_t size);
 
 #ifdef CONFIG_PCI_XEN
 extern int xen_wants_swiotlb(void);
-- 
1.5.6.5

