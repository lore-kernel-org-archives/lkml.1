Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbZEUQRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbZEUQRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756446AbZEUQPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:15:49 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26689 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbZEUQPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:15:48 -0400
X-IronPort-AV: E=Sophos;i="4.41,228,1241409600"; 
   d="scan'208";a="52100809"
From: Ian Campbell <ian.campbell@citrix.com>
To: ian.campbell@citrix.com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <beckyb@kernel.crashing.org>, Olaf Kirch <okir@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       xen-devel <xendevel@lists.xensource.com>,
       x86 maintainers <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] swiotlb/xen: update xen swiotlb for phys<->bus API changes
Date: Thu, 21 May 2009 17:15:28 +0100
Message-Id: <1242922528-5982-8-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 21 May 2009 16:15:50.0077 (UTC) FILETIME=[680CFED0:01C9DA2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are now implemented via explicit hooks in
arch/x86/kernel/pci-swiotlb.c rather than as weak hooks in swiotlb.c

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
 drivers/pci/xen-iommu.c |    6 ++++--
 include/xen/swiotlb.h   |    3 ---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index 2d727d1..02de48a 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -72,12 +72,12 @@ int xen_wants_swiotlb(void)
 	return xen_initial_domain();
 }
 
-dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
+static dma_addr_t xen_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 {
 	return phys_to_machine(XPADDR(paddr)).maddr;
 }
 
-phys_addr_t xen_bus_to_phys(dma_addr_t daddr)
+static phys_addr_t xen_bus_to_phys(struct device *hwdev, dma_addr_t daddr)
 {
 	return machine_to_phys(XMADDR(daddr)).paddr;
 }
@@ -322,6 +322,8 @@ void __init detect_xen_iommu(void)
 
 	x86_swiotlb_force_mapping = &xen_swiotlb_force_mapping;
 	x86_swiotlb_alloc_fixup = &xen_swiotlb_alloc_fixup;
+	x86_bus_to_phys = &xen_bus_to_phys;
+	x86_phys_to_bus = &xen_phys_to_bus;
 }
 
 void __init xen_iommu_init(void)
diff --git a/include/xen/swiotlb.h b/include/xen/swiotlb.h
index 83ec002..e6c7707 100644
--- a/include/xen/swiotlb.h
+++ b/include/xen/swiotlb.h
@@ -1,9 +1,6 @@
 #ifndef _XEN_SWIOTLB_H
 #define _XEN_SWIOTLB_H
 
-extern phys_addr_t xen_bus_to_phys(dma_addr_t daddr);
-extern dma_addr_t xen_phys_to_bus(phys_addr_t paddr);
-
 #ifdef CONFIG_PCI_XEN
 extern int xen_wants_swiotlb(void);
 #else
-- 
1.5.6.5

