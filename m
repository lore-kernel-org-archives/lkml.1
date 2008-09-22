Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbYIVSX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbYIVSX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYIVSVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:21:46 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:31713 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbYIVSVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:21:41 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7M0BG-03-3J7-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: David Woodhouse <dwmw2@infradead.org>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Amit Shah <amit.shah@qumranet.com>, Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/9] x86/iommu: change SWIOTLB to use dma_ops register interface
Date: Mon, 22 Sep 2008 20:21:16 +0200
Message-ID: <1222107681-8185-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Sep 2008 18:21:21.0316 (UTC) FILETIME=[03771E40:01C91CE0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-dma.c        |    6 +++++-
 arch/x86/kernel/pci-swiotlb_64.c |   16 +++++++++++++++-
 include/asm-x86/swiotlb.h        |    1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index c783b73..b990fb6 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -156,7 +156,7 @@ void __init pci_iommu_alloc(void)
 
 	amd_iommu_detect();
 
-	pci_swiotlb_init();
+	pci_swiotlb_detect();
 }
 
 unsigned long iommu_num_pages(unsigned long addr, unsigned long len)
@@ -296,6 +296,10 @@ static int __init pci_iommu_init(void)
 
 	gart_iommu_init();
 
+#ifdef CONFIG_X86_64
+	pci_swiotlb_init();
+#endif
+
 	no_iommu_init();
 	return 0;
 }
diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index c4ce033..26747e0 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -18,6 +18,12 @@ swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
 	return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
 }
 
+static int
+swiotlb_device_supported(struct device *hwdev)
+{
+	return 1;
+}
+
 struct dma_mapping_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 	.alloc_coherent = swiotlb_alloc_coherent,
@@ -33,9 +39,10 @@ struct dma_mapping_ops swiotlb_dma_ops = {
 	.map_sg = swiotlb_map_sg,
 	.unmap_sg = swiotlb_unmap_sg,
 	.dma_supported = NULL,
+	.device_supported = swiotlb_device_supported,
 };
 
-void __init pci_swiotlb_init(void)
+void __init pci_swiotlb_detect(void)
 {
 	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
 	if (!iommu_detected && !no_iommu && max_pfn > MAX_DMA32_PFN)
@@ -45,6 +52,13 @@ void __init pci_swiotlb_init(void)
 	if (swiotlb) {
 		printk(KERN_INFO "PCI-DMA: Using software bounce buffering for IO (SWIOTLB)\n");
 		swiotlb_init();
+	}
+}
+
+void __init pci_swiotlb_init(void)
+{
+	if (swiotlb) {
+		x86_register_dma_ops(&swiotlb_dma_ops, DMA_OPS_TYPE_SOFT);
 		dma_ops = &swiotlb_dma_ops;
 	}
 }
diff --git a/include/asm-x86/swiotlb.h b/include/asm-x86/swiotlb.h
index 2730b35..20dfcb0 100644
--- a/include/asm-x86/swiotlb.h
+++ b/include/asm-x86/swiotlb.h
@@ -45,6 +45,7 @@ extern int swiotlb_force;
 
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
+extern void pci_swiotlb_detect(void);
 extern void pci_swiotlb_init(void);
 #else
 #define swiotlb 0
-- 
1.5.6.4


