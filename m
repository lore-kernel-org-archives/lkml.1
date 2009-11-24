Return-Path: <linux-kernel-owner+w=401wt.eu-S932995AbZKXNvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbZKXNvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932973AbZKXNvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:51:24 -0500
Received: from sh.osrg.net ([192.16.179.4]:49088 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932904AbZKXNvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:51:22 -0500
Date: Tue, 24 Nov 2009 22:50:22 +0900
To: yinghai@kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix gart iommu using for amd 64 bit system
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B0BB892.9080401@kernel.org>
References: <4B0BAC06.1000905@kernel.org>
	<20091124193031P.fujita.tomonori@lab.ntt.co.jp>
	<4B0BB892.9080401@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091124225000H.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 24 Nov 2009 22:50:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 02:42:26 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> at GART iommu workaround : it is not rare. a lot of systems have this problem.
> and that workaround works well for several years.

swiotlb has worked too.


> don't think user will like to use SWIOTLB instead of swiotlb.

I doubt that users care about a way to fix their problems.


> that gart iommu hardware is not broken, just those BIOS guys just forget to program it.
> 
> here intel vt-d is different, it seems can not make it work just program some hardware register...

Because BIOS is broken, IIRC. Both cases are pretty similar.

> please check my v2 patch, to see if it breaks your setup.

As I said, adding another trick only for GART is not good. And using
force_iommu in pci-dma.c is confusing since force_iommu should be used
only in X86_64.

The following patch works for you?


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
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index e0dfb68..750dd8d 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -401,6 +401,7 @@ void __init gart_iommu_hole_init(void)
 
 			iommu_detected = 1;
 			gart_iommu_aperture = 1;
+			swiotlb = 0;
 			x86_init.iommu.iommu_init = gart_iommu_init;
 
 			aper_order = (read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL) >> 1) & 7;
@@ -458,7 +459,7 @@ out:
 
 	if (aper_alloc) {
 		/* Got the aperture from the AGP bridge */
-	} else if (!valid_agp) {
+	} else if (swiotlb && !valid_agp) {
 		/* Do nothing */
 	} else if ((!no_iommu && max_pfn > MAX_DMA32_PFN) ||
 		   force_iommu ||
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
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index e6a0d40..2358409 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -847,7 +847,6 @@ int __init gart_iommu_init(void)
 	flush_gart();
 	dma_ops = &gart_dma_ops;
 	x86_platform.iommu_shutdown = gart_iommu_shutdown;
-	swiotlb = 0;
 
 	return 0;
 }
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index e36e71d..6971ba5 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -43,12 +43,12 @@ static struct dma_map_ops swiotlb_dma_ops = {
 };
 
 /*
- * pci_swiotlb_init - initialize swiotlb if necessary
+ * pci_swiotlb_init - set swiotlb to 1 if necessary
  *
  * This returns non-zero if we are forced to use swiotlb (by the boot
  * option).
  */
-int __init pci_swiotlb_init(void)
+int __init pci_swiotlb_detect(void)
 {
 	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
 #ifdef CONFIG_X86_64
@@ -58,10 +58,13 @@ int __init pci_swiotlb_init(void)
 	if (swiotlb_force)
 		swiotlb = 1;
 
+	return swiotlb_force;
+}
+
+void __init pci_swiotlb_init(void)
+{
 	if (swiotlb) {
 		swiotlb_init(0);
 		dma_ops = &swiotlb_dma_ops;
 	}
-
-	return swiotlb_force;
 }
