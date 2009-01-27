Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZA0Ooa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZA0Ooa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 09:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZA0OoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 09:44:21 -0500
Received: from sh.osrg.net ([192.16.179.4]:34622 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbZA0OoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 09:44:20 -0500
Date: Tue, 27 Jan 2009 23:43:59 +0900
To: tony.luck@intel.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: [PATCH -tip] IA64: fix the compile error on IA64_DIG_VTD
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090127233530U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about fallout from my dma mapping ops unification.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] IA64: fix the compile error on IA64_DIG_VTD

This moves iommu_detected to arch/ia64/kernel/dma-mapping.c from
arch/ia64/kernel/pci-swiotlb.c to fix the following error on on
IA64_DIG_VTD:

arch/ia64/kernel/built-in.o: In function `pci_iommu_init':
pci-dma.c:(.init.text+0xa021): undefined reference to `iommu_detected'
pci-dma.c:(.init.text+0xa030): undefined reference to `iommu_detected'
drivers/built-in.o: In function `detect_intel_iommu':
(.init.text+0x11c0): undefined reference to `iommu_detected'
drivers/built-in.o: In function `detect_intel_iommu':
(.init.text+0x11e1): undefined reference to `iommu_detected'

iommu_detected is used to handle IOMMUs so I guess that
arch/ia64/kernel/dma-mapping.c is ok (there might be a better place
for it though).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/kernel/dma-mapping.c |    3 +++
 arch/ia64/kernel/pci-swiotlb.c |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/dma-mapping.c b/arch/ia64/kernel/dma-mapping.c
index 7060e13..086a2ae 100644
--- a/arch/ia64/kernel/dma-mapping.c
+++ b/arch/ia64/kernel/dma-mapping.c
@@ -1,5 +1,8 @@
 #include <linux/dma-mapping.h>
 
+/* Set this to 1 if there is a HW IOMMU in the system */
+int iommu_detected __read_mostly;
+
 struct dma_map_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
index d21dea4..717ad4f 100644
--- a/arch/ia64/kernel/pci-swiotlb.c
+++ b/arch/ia64/kernel/pci-swiotlb.c
@@ -13,9 +13,6 @@
 int swiotlb __read_mostly;
 EXPORT_SYMBOL(swiotlb);
 
-/* Set this to 1 if there is a HW IOMMU in the system */
-int iommu_detected __read_mostly;
-
 struct dma_map_ops swiotlb_dma_ops = {
 	.alloc_coherent = swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
-- 
1.6.0.6

