Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbZJ1Gy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbZJ1Gy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbZJ1GyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:54:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:54075 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757458AbZJ1GyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:54:20 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: chrisw@sous-sol.org, dwmw2@infradead.org, joerg.roedel@amd.com,
       mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 10/10] x86: handle HW IOMMU initialization failure gracely
Date: Wed, 28 Oct 2009 15:47:44 +0900
Message-Id: <1256712464-21472-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 28 Oct 2009 15:53:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If HW IOMMU initialization fails (Intel VT-d often does typically due
to BIOS bugs), we fall back to nommu. It doesn't work for the majority
since nowadays we have more than 4GB memory so we must use swiotlb
instead of nommu.

The problem is that it's too late to initialize swiotlb when HW IOMMU
initialization fails. We need to allocate swiotlb memory earlier from
bootmem allocator. Chris explained the issue in detail:

http://marc.info/?l=linux-kernel&m=125657444317079&w=2

The current x86 IOMMU initialization sequence is too complicated and
handling the above issue makes it more hacky.

This patch changes x86 IOMMU initialization sequence to handle the
above issue cleanly.

The new x86 IOMMU initialization sequence are:

1. initializing swiotlb (and setting swiotlb to 1) in the case of
(max_pfn > MAX_DMA32_PFN && !no_iommu). dma_ops is set to
swiotlb_dma_ops or nommu_dma_ops.

2. calling the detection functions of all the IOMMUs

3. the detection function sets x86_init.iommu.iommu_init to the IOMMU
initialization function (so we can avoid calling the initialization
functions of all the IOMMUs needlessly).

4. if the IOMMU initialization function doesn't need to swiotlb then
sets swiotlb to zero (e.g. the initialization is sucessful).

5. if we find that swiotlb is set to zero, we free swiotlb resource.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/include/asm/iommu.h     |    1 -
 arch/x86/kernel/amd_iommu.c      |    2 +-
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 arch/x86/kernel/aperture_64.c    |    2 +-
 arch/x86/kernel/pci-calgary_64.c |   10 +---------
 arch/x86/kernel/pci-dma.c        |   17 +++++++++--------
 arch/x86/kernel/pci-gart_64.c    |    1 +
 arch/x86/kernel/pci-nommu.c      |    9 ---------
 arch/x86/kernel/pci-swiotlb.c    |    5 +++--
 drivers/pci/dmar.c               |    3 +--
 drivers/pci/intel-iommu.c        |    4 ++--
 11 files changed, 20 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index 42aa977..9254199 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -2,7 +2,6 @@
 #define _ASM_X86_IOMMU_H
 
 extern void pci_iommu_shutdown(void);
-extern void no_iommu_init(void);
 static inline int iommu_init_noop(void) { return 0; }
 extern struct dma_map_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 98f230f..383bf83 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2108,8 +2108,8 @@ int __init amd_iommu_init_dma_ops(void)
 		prealloc_protection_domains();
 
 	iommu_detected = 1;
-	force_iommu = 1;
 	bad_dma_address = 0;
+	swiotlb = 0;
 #ifdef CONFIG_GART_IOMMU
 	gart_iommu_aperture_disabled = 1;
 	gart_iommu_aperture = 0;
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 52bf59f..5eda21a 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1312,7 +1312,7 @@ static int __init early_amd_iommu_detect(struct acpi_table_header *table)
 
 void __init amd_iommu_detect(void)
 {
-	if (swiotlb || no_iommu || (iommu_detected && !gart_iommu_aperture))
+	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
 		return;
 
 	if (acpi_table_parse("IVRS", early_amd_iommu_detect) == 0) {
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 03933cf..e0dfb68 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -458,7 +458,7 @@ out:
 
 	if (aper_alloc) {
 		/* Got the aperture from the AGP bridge */
-	} else if (swiotlb && !valid_agp) {
+	} else if (!valid_agp) {
 		/* Do nothing */
 	} else if ((!no_iommu && max_pfn > MAX_DMA32_PFN) ||
 		   force_iommu ||
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 47bd419..833f491 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1360,7 +1360,7 @@ void __init detect_calgary(void)
 	 * if the user specified iommu=off or iommu=soft or we found
 	 * another HW IOMMU already, bail out.
 	 */
-	if (swiotlb || no_iommu || iommu_detected)
+	if (no_iommu || iommu_detected)
 		return;
 
 	if (!use_calgary)
@@ -1445,10 +1445,6 @@ void __init detect_calgary(void)
 		printk(KERN_INFO "PCI-DMA: Calgary TCE table spec is %d\n",
 		       specified_table_size);
 
-		/* swiotlb for devices that aren't behind the Calgary. */
-		if (max_pfn > MAX_DMA32_PFN)
-			swiotlb = 1;
-
 		x86_init.iommu.iommu_init = calgary_iommu_init;
 	}
 	return;
@@ -1476,11 +1472,7 @@ int __init calgary_iommu_init(void)
 		return ret;
 	}
 
-	force_iommu = 1;
 	bad_dma_address = 0x0;
-	/* dma_ops is set to swiotlb or nommu */
-	if (!dma_ops)
-		dma_ops = &nommu_dma_ops;
 
 	return 0;
 }
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index f70b766..28fd54a 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -128,20 +128,16 @@ void __init pci_iommu_alloc(void)
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 #endif
+	pci_swiotlb_init();
 
-	/*
-	 * The order of these functions is important for
-	 * fall-back/fail-over reasons
-	 */
 	gart_iommu_hole_init();
 
 	detect_calgary();
 
 	detect_intel_iommu();
 
+	/* needs to be called after gart_iommu_hole_init */
 	amd_iommu_detect();
-
-	pci_swiotlb_init();
 }
 
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,
@@ -291,10 +287,15 @@ static int __init pci_iommu_init(void)
 #ifdef CONFIG_PCI
 	dma_debug_add_bus(&pci_bus_type);
 #endif
-
 	x86_init.iommu.iommu_init();
 
-	no_iommu_init();
+	if (swiotlb) {
+		printk(KERN_INFO "PCI-DMA: "
+		       "Using software bounce buffering for IO (SWIOTLB)\n");
+		swiotlb_print_info();
+	} else
+		swiotlb_free();
+
 	return 0;
 }
 
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 3bcae8f..e36f5f4 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -831,6 +831,7 @@ int __init gart_iommu_init(void)
 
 	flush_gart();
 	dma_ops = &gart_dma_ops;
+	swiotlb = 0;
 
 	return 0;
 }
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index a3933d4..875e382 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -103,12 +103,3 @@ struct dma_map_ops nommu_dma_ops = {
 	.sync_sg_for_device	= nommu_sync_sg_for_device,
 	.is_phys		= 1,
 };
-
-void __init no_iommu_init(void)
-{
-	if (dma_ops)
-		return;
-
-	force_iommu = 0; /* no HW IOMMU */
-	dma_ops = &nommu_dma_ops;
-}
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index ea20ef7..607fbb6 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -46,7 +46,7 @@ void __init pci_swiotlb_init(void)
 {
 	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
 #ifdef CONFIG_X86_64
-	if ((!iommu_detected && !no_iommu && max_pfn > MAX_DMA32_PFN))
+	if (!no_iommu && max_pfn > MAX_DMA32_PFN)
 		swiotlb = 1;
 #endif
 	if (swiotlb_force)
@@ -54,5 +54,6 @@ void __init pci_swiotlb_init(void)
 	if (swiotlb) {
 		swiotlb_init(0);
 		dma_ops = &swiotlb_dma_ops;
-	}
+	} else
+		dma_ops = &nommu_dma_ops;
 }
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index bce9cd7..4373996 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -613,8 +613,7 @@ void __init detect_intel_iommu(void)
 			       "x2apic and Intr-remapping.\n");
 #endif
 #ifdef CONFIG_DMAR
-		if (ret && !no_iommu && !iommu_detected && !swiotlb &&
-		    !dmar_disabled)
+		if (ret && !no_iommu && !iommu_detected && !dmar_disabled)
 			iommu_detected = 1;
 #endif
 #ifdef CONFIG_X86
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index b1e97e6..c7a8bcf 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3231,7 +3231,7 @@ int __init intel_iommu_init(void)
 	 * Check the need for DMA-remapping initialization now.
 	 * Above initialization will also be used by Interrupt-remapping.
 	 */
-	if (no_iommu || swiotlb || dmar_disabled)
+	if (no_iommu || dmar_disabled)
 		return -ENODEV;
 
 	iommu_init_mempool();
@@ -3252,7 +3252,7 @@ int __init intel_iommu_init(void)
 	"PCI-DMA: Intel(R) Virtualization Technology for Directed I/O\n");
 
 	init_timer(&unmap_timer);
-	force_iommu = 1;
+	swiotlb = 0;
 	dma_ops = &intel_dma_ops;
 
 	init_iommu_sysfs();
-- 
1.5.6.5

