Return-Path: <linux-kernel-owner+w=401wt.eu-S932371AbZJ1G4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbZJ1G4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932092AbZJ1G4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:56:38 -0400
Received: from sh.osrg.net ([192.16.179.4]:54078 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463AbZJ1GyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:54:22 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: chrisw@sous-sol.org, dwmw2@infradead.org, joerg.roedel@amd.com,
       mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 03/10] GART: convert gart_iommu_hole_init to use iommu_init hook
Date: Wed, 28 Oct 2009 15:47:37 +0900
Message-Id: <1256712464-21472-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 28 Oct 2009 15:53:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes gart_iommu_hole_init() to set gart_iommu_init() to
iommu_init hook if gart_iommu_hole_init() finds the GART IOMMU.

We can kill the code to check if we found the IOMMU in
gart_iommu_init() since gart_iommu_hole_init() sets gart_iommu_init()
only when it found the IOMMU.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/include/asm/gart.h   |    5 +----
 arch/x86/kernel/aperture_64.c |    2 ++
 arch/x86/kernel/pci-dma.c     |    2 --
 arch/x86/kernel/pci-gart_64.c |   15 +++++----------
 4 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/gart.h b/arch/x86/include/asm/gart.h
index 6cfdafa..51d28a0 100644
--- a/arch/x86/include/asm/gart.h
+++ b/arch/x86/include/asm/gart.h
@@ -35,7 +35,7 @@ extern int gart_iommu_aperture_allowed;
 extern int gart_iommu_aperture_disabled;
 
 extern void early_gart_iommu_check(void);
-extern void gart_iommu_init(void);
+extern int gart_iommu_init(void);
 extern void gart_iommu_shutdown(void);
 extern void __init gart_parse_options(char *);
 extern void gart_iommu_hole_init(void);
@@ -48,9 +48,6 @@ extern void gart_iommu_hole_init(void);
 static inline void early_gart_iommu_check(void)
 {
 }
-static inline void gart_iommu_init(void)
-{
-}
 static inline void gart_iommu_shutdown(void)
 {
 }
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 128111d..03933cf 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -28,6 +28,7 @@
 #include <asm/pci-direct.h>
 #include <asm/dma.h>
 #include <asm/k8.h>
+#include <asm/x86_init.h>
 
 int gart_iommu_aperture;
 int gart_iommu_aperture_disabled __initdata;
@@ -400,6 +401,7 @@ void __init gart_iommu_hole_init(void)
 
 			iommu_detected = 1;
 			gart_iommu_aperture = 1;
+			x86_init.iommu.iommu_init = gart_iommu_init;
 
 			aper_order = (read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL) >> 1) & 7;
 			aper_size = (32 * 1024 * 1024) << aper_order;
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1b06714..9830f12 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -298,8 +298,6 @@ static int __init pci_iommu_init(void)
 
 	amd_iommu_init();
 
-	gart_iommu_init();
-
 	no_iommu_init();
 	return 0;
 }
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index a7f1b64..3bcae8f 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -708,7 +708,7 @@ void gart_iommu_shutdown(void)
 	}
 }
 
-void __init gart_iommu_init(void)
+int __init gart_iommu_init(void)
 {
 	struct agp_kern_info info;
 	unsigned long iommu_start;
@@ -718,7 +718,7 @@ void __init gart_iommu_init(void)
 	long i;
 
 	if (cache_k8_northbridges() < 0 || num_k8_northbridges == 0)
-		return;
+		return 0;
 
 #ifndef CONFIG_AGP_AMD64
 	no_agp = 1;
@@ -730,13 +730,6 @@ void __init gart_iommu_init(void)
 		(agp_copy_info(agp_bridge, &info) < 0);
 #endif
 
-	if (swiotlb)
-		return;
-
-	/* Did we detect a different HW IOMMU? */
-	if (iommu_detected && !gart_iommu_aperture)
-		return;
-
 	if (no_iommu ||
 	    (!force_iommu && max_pfn <= MAX_DMA32_PFN) ||
 	    !gart_iommu_aperture ||
@@ -746,7 +739,7 @@ void __init gart_iommu_init(void)
 			       "but GART IOMMU not available.\n");
 			printk(KERN_WARNING "falling back to iommu=soft.\n");
 		}
-		return;
+		return 0;
 	}
 
 	/* need to map that range */
@@ -838,6 +831,8 @@ void __init gart_iommu_init(void)
 
 	flush_gart();
 	dma_ops = &gart_dma_ops;
+
+	return 0;
 }
 
 void __init gart_parse_options(char *p)
-- 
1.5.6.5

