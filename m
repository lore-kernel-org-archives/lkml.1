Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbZJ1Gze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbZJ1Gze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbZJ1Gy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:54:26 -0400
Received: from sh.osrg.net ([192.16.179.4]:54077 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757459AbZJ1GyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:54:21 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: chrisw@sous-sol.org, dwmw2@infradead.org, joerg.roedel@amd.com,
       mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 02/10] Calgary: convert detect_calgary to use iommu_init hook
Date: Wed, 28 Oct 2009 15:47:36 +0900
Message-Id: <1256712464-21472-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 28 Oct 2009 15:53:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes detect_calgary() to set init_calgary() to iommu_init hook
if detect_calgary() finds the Calgary IOMMU.

We can kill the code to check if we found the IOMMU in init_calgary()
since detect_calgary() sets init_calgary() only when it found the
IOMMU.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/include/asm/calgary.h   |    2 --
 arch/x86/kernel/pci-calgary_64.c |   11 +++++------
 arch/x86/kernel/pci-dma.c        |    2 --
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/calgary.h b/arch/x86/include/asm/calgary.h
index b03bedb..0918654 100644
--- a/arch/x86/include/asm/calgary.h
+++ b/arch/x86/include/asm/calgary.h
@@ -62,10 +62,8 @@ struct cal_chipset_ops {
 extern int use_calgary;
 
 #ifdef CONFIG_CALGARY_IOMMU
-extern int calgary_iommu_init(void);
 extern void detect_calgary(void);
 #else
-static inline int calgary_iommu_init(void) { return 1; }
 static inline void detect_calgary(void) { return; }
 #endif
 
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 971a3be..47bd419 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -46,6 +46,7 @@
 #include <asm/dma.h>
 #include <asm/rio.h>
 #include <asm/bios_ebda.h>
+#include <asm/x86_init.h>
 
 #ifdef CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT
 int use_calgary __read_mostly = 1;
@@ -1344,6 +1345,8 @@ static void __init get_tce_space_from_tar(void)
 	return;
 }
 
+int __init calgary_iommu_init(void);
+
 void __init detect_calgary(void)
 {
 	int bus;
@@ -1445,6 +1448,8 @@ void __init detect_calgary(void)
 		/* swiotlb for devices that aren't behind the Calgary. */
 		if (max_pfn > MAX_DMA32_PFN)
 			swiotlb = 1;
+
+		x86_init.iommu.iommu_init = calgary_iommu_init;
 	}
 	return;
 
@@ -1461,12 +1466,6 @@ int __init calgary_iommu_init(void)
 {
 	int ret;
 
-	if (no_iommu || (swiotlb && !calgary_detected))
-		return -ENODEV;
-
-	if (!calgary_detected)
-		return -ENODEV;
-
 	/* ok, we're trying to use Calgary - let's roll */
 	printk(KERN_INFO "PCI-DMA: Using Calgary IOMMU\n");
 
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 5609973..1b06714 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -294,8 +294,6 @@ static int __init pci_iommu_init(void)
 
 	x86_init.iommu.iommu_init();
 
-	calgary_iommu_init();
-
 	intel_iommu_init();
 
 	amd_iommu_init();
-- 
1.5.6.5

