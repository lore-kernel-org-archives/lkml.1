Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbZLOLtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbZLOLtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 06:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbZLOLs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 06:48:59 -0500
Received: from sh.osrg.net ([192.16.179.4]:42055 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbZLOLs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 06:48:58 -0500
Date: Tue, 15 Dec 2009 20:47:56 +0900
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, yinghai@kernel.org, rdreier@cisco.com
Subject: [PATCH] x86: split swiotlb initialization into two stages
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091215204729A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 15 Dec 2009 20:47:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit f4780ca005404166cc40af77ef0e86132ab98a81 moves swiotlb
initialization before dma32_free_bootmem(). It's supposed to fix a bug
that the commit 75f1cdf1dda92cae037ec848ae63690d91913eac introduced,
we initialize SWIOTLB right after dma32_free_bootmem so we wrongly
steal memory area allocated for GART with broken BIOS earlier.

However, the above commit introduced another problem, which likely
breaks machines with huge amount of memory. Such a box use the
majority of DMA32_ZONE so there is no memory for swiotlb.

With this patch, the x86 IOMMU initialization sequence are:

1. We set swiotlb to 1 in the case of (max_pfn > MAX_DMA32_PFN &&
   !no_iommu). If swiotlb usage is forced by the boot option, we go to
   the step 3 and finish (we don't try to detect IOMMUs).

2. We call the detection functions of all the IOMMUs. The detection
   function sets x86_init.iommu.iommu_init to the IOMMU initialization
   function (so we can avoid calling the initialization functions of
   all the IOMMUs needlessly).

3. We initialize swiotlb (and set dma_ops to swiotlb_dma_ops) if
   swiotlb is set to 1.

4. If the IOMMU initialization function doesn't need swiotlb (e.g. the
   initialization is sucessful) then sets swiotlb to zero.

5. If we find that swiotlb is set to zero, we free swiotlb
   resource.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reported-by: Roland Dreier <rdreier@cisco.com>
Reported-by: Yinghai Lu <yinghai@kernel.org>
Tested-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/swiotlb.h |    8 ++++++--
 arch/x86/kernel/pci-dma.c      |    9 ++++-----
 arch/x86/kernel/pci-swiotlb.c  |   11 +++++++----
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/swiotlb.h b/arch/x86/include/asm/swiotlb.h
index 87ffcb1..8085277 100644
--- a/arch/x86/include/asm/swiotlb.h
+++ b/arch/x86/include/asm/swiotlb.h
@@ -5,13 +5,17 @@
 
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
-extern int pci_swiotlb_init(void);
+extern int __init pci_swiotlb_detect(void);
+extern void __init pci_swiotlb_init(void);
 #else
 #define swiotlb 0
-static inline int pci_swiotlb_init(void)
+static inline int pci_swiotlb_detect(void)
 {
 	return 0;
 }
+static inline void pci_swiotlb_init(void)
+{
+}
 #endif
 
 static inline void dma_mark_clean(void *addr, size_t size) {}
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index fcc2f2b..75e14e2 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -120,15 +120,12 @@ static void __init dma32_free_bootmem(void)
 
 void __init pci_iommu_alloc(void)
 {
-	int use_swiotlb;
-
-	use_swiotlb = pci_swiotlb_init();
 #ifdef CONFIG_X86_64
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 #endif
-	if (use_swiotlb)
-		return;
+	if (pci_swiotlb_detect())
+		goto out;
 
 	gart_iommu_hole_init();
 
@@ -138,6 +135,8 @@ void __init pci_iommu_alloc(void)
 
 	/* needs to be called after gart_iommu_hole_init */
 	amd_iommu_detect();
+out:
+	pci_swiotlb_init();
 }
 
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index e3c0a66..7d2829d 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -43,12 +43,12 @@ static struct dma_map_ops swiotlb_dma_ops = {
 };
 
 /*
- * pci_swiotlb_init - initialize swiotlb if necessary
+ * pci_swiotlb_detect - set swiotlb to 1 if necessary
  *
  * This returns non-zero if we are forced to use swiotlb (by the boot
  * option).
  */
-int __init pci_swiotlb_init(void)
+int __init pci_swiotlb_detect(void)
 {
 	int use_swiotlb = swiotlb | swiotlb_force;
 
@@ -60,10 +60,13 @@ int __init pci_swiotlb_init(void)
 	if (swiotlb_force)
 		swiotlb = 1;
 
+	return use_swiotlb;
+}
+
+void __init pci_swiotlb_init(void)
+{
 	if (swiotlb) {
 		swiotlb_init(0);
 		dma_ops = &swiotlb_dma_ops;
 	}
-
-	return use_swiotlb;
 }
-- 
1.5.6.5

