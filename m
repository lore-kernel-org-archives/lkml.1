Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbZLHLHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbZLHLHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 06:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZLHLHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 06:07:39 -0500
Received: from sh.osrg.net ([192.16.179.4]:59923 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbZLHLHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 06:07:39 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 1/2] x86: move swiotlb initialization after IOMMU detection
Date: Tue,  8 Dec 2009 20:04:58 +0900
Message-Id: <1260270299-18325-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1260270299-18325-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1260270299-18325-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 08 Dec 2009 20:05:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 75f1cdf1dda92cae037ec848ae63690d91913eac moved SWIOTLB
initialization before IOMMU detection since the majority of IOMMU
drivers need SWIOTLB even if we find them. And the code is cleaner
if we initialize SWIOTLB earlier.

The problem is that we initialize SWIOTLB after dma32_free_bootmem so
we wrongly steal memory area allocated for GART with broken BIOS
earlier.

We could initialize SWIOTLB before dma32_free_bootmem however it means
that we temporarily allocate more memory during booting. It could
break systems that don't have lots of memory. So unfortunately it
seems that we need to allocate SWIOTLB after IOMMU detection.

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
---
 arch/x86/include/asm/swiotlb.h |    8 ++++++--
 arch/x86/kernel/pci-dma.c      |    6 ++++--
 arch/x86/kernel/pci-swiotlb.c  |   11 +++++++----
 3 files changed, 17 insertions(+), 8 deletions(-)

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
index afcc58b..75e14e2 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -124,8 +124,8 @@ void __init pci_iommu_alloc(void)
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 #endif
-	if (pci_swiotlb_init())
-		return;
+	if (pci_swiotlb_detect())
+		goto out;
 
 	gart_iommu_hole_init();
 
@@ -135,6 +135,8 @@ void __init pci_iommu_alloc(void)
 
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

