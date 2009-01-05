Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZAEPQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZAEPQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZAEPQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:16:04 -0500
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:33776 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbZAEPQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:16:03 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 06/13] add dma_mapping_ops for SWIOTLB
Date: Mon,  5 Jan 2009 23:36:11 +0900
Message-Id: <1231166178-20050-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231166178-20050-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1231166178-20050-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166178-20050-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166178-20050-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166178-20050-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166178-20050-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166178-20050-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is already dma_mapping_ops for SWIOTLB but there are some
missing hooks.

This is for IA64_DIG_VTD, IA64_HP_ZX1_SWIOTLB, IA64_SGI_UV,
IA64_HP_SIM, IA64_XEN_GUEST and IA64_GENERIC.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/kernel/Makefile      |    2 --
 arch/ia64/kernel/pci-dma.c     |    3 ---
 arch/ia64/kernel/pci-swiotlb.c |    9 ++++++++-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/ia64/kernel/Makefile b/arch/ia64/kernel/Makefile
index c381ea9..bc1f62a 100644
--- a/arch/ia64/kernel/Makefile
+++ b/arch/ia64/kernel/Makefile
@@ -43,9 +43,7 @@ ifneq ($(CONFIG_IA64_ESI),)
 obj-y				+= esi_stub.o	# must be in kernel proper
 endif
 obj-$(CONFIG_DMAR)		+= pci-dma.o
-ifeq ($(CONFIG_DMAR), y)
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb.o
-endif
 
 # The gate DSO image is built using a special linker script.
 targets += gate.so gate-syms.o
diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index 2a92f63..f8c38bd 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -32,9 +32,6 @@ int force_iommu __read_mostly = 1;
 int force_iommu __read_mostly;
 #endif
 
-/* Set this to 1 if there is a HW IOMMU in the system */
-int iommu_detected __read_mostly;
-
 /* Dummy device used for NULL arguments (normally ISA). Better would
    be probably a smaller DMA mask, but this is bug-to-bug compatible
    to i386. */
diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
index 16c5051..b62fb93 100644
--- a/arch/ia64/kernel/pci-swiotlb.c
+++ b/arch/ia64/kernel/pci-swiotlb.c
@@ -13,12 +13,18 @@
 int swiotlb __read_mostly;
 EXPORT_SYMBOL(swiotlb);
 
+/* Set this to 1 if there is a HW IOMMU in the system */
+int iommu_detected __read_mostly;
+
 struct dma_mapping_ops swiotlb_dma_ops = {
-	.mapping_error = swiotlb_dma_mapping_error,
 	.alloc_coherent = swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
 	.map_single = swiotlb_map_single,
 	.unmap_single = swiotlb_unmap_single,
+	.map_single_attrs = swiotlb_map_single_attrs,
+	.unmap_single_attrs = swiotlb_unmap_single_attrs,
+	.map_sg_attrs = swiotlb_map_sg_attrs,
+	.unmap_sg_attrs	= swiotlb_unmap_sg_attrs,
 	.sync_single_for_cpu = swiotlb_sync_single_for_cpu,
 	.sync_single_for_device = swiotlb_sync_single_for_device,
 	.sync_single_range_for_cpu = swiotlb_sync_single_range_for_cpu,
@@ -28,6 +34,7 @@ struct dma_mapping_ops swiotlb_dma_ops = {
 	.map_sg = swiotlb_map_sg,
 	.unmap_sg = swiotlb_unmap_sg,
 	.dma_supported_op = swiotlb_dma_supported,
+	.mapping_error = swiotlb_dma_mapping_error,
 };
 
 void __init pci_swiotlb_init(void)
-- 
1.6.0.6

