Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbXJXKwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbXJXKwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 06:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbXJXKuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 06:50:20 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:31981 "EHLO
	mail63-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192AbXJXKuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 06:50:11 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       "Muli Ben-Yehuda" <muli@il.ibm.com>,
       "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 4/4] x86 gart: rename symbols only used for the GART
 implementation
Date: Wed, 24 Oct 2007 12:49:50 +0200
Message-ID: <1193222990220-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11932229902428-git-send-email-joerg.roedel@amd.com>
References: <11932229902428-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Oct 2007 10:49:50.0961 (UTC)
 FILETIME=[9A627E10:01C8162B]
MIME-Version: 1.0
X-WSS-ID: 6B01FCDE0QK73692-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames the 4 symbols iommu_hole_init(), iommu_aperture,
iommu_aperture_allowed, iommu_aperture_disabled. All these symbols are only
used for the GART implementation of IOMMUs.

It adds and additional gart_ prefix to them.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/aperture_64.c  |   13 +++++++------
 arch/x86/kernel/early-quirks.c |    4 ++--
 arch/x86/kernel/pci-dma_64.c   |    2 +-
 arch/x86/kernel/pci-gart_64.c  |    8 ++++----
 include/asm-x86/gart.h         |   12 ++++++------
 5 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 70c854f..5b69927 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -25,9 +25,9 @@
 #include <asm/dma.h>
 #include <asm/k8.h>
 
-int iommu_aperture;
-int iommu_aperture_disabled __initdata = 0;
-int iommu_aperture_allowed __initdata = 0;
+int gart_iommu_aperture;
+int gart_iommu_aperture_disabled __initdata = 0;
+int gart_iommu_aperture_allowed __initdata = 0;
 
 int fallback_aper_order __initdata = 1; /* 64MB */
 int fallback_aper_force __initdata = 0; 
@@ -204,14 +204,15 @@ static __u32 __init search_agp_bridge(u32 *order, int *valid_agp)
 	return 0;
 }
 
-void __init iommu_hole_init(void) 
+void __init gart_iommu_hole_init(void)
 { 
 	int fix, num; 
 	u32 aper_size, aper_alloc = 0, aper_order = 0, last_aper_order = 0;
 	u64 aper_base, last_aper_base = 0;
 	int valid_agp = 0;
 
-	if (iommu_aperture_disabled || !fix_aperture || !early_pci_allowed())
+	if (gart_iommu_aperture_disabled || !fix_aperture ||
+	    !early_pci_allowed())
 		return;
 
 	printk(KERN_INFO  "Checking aperture...\n");
@@ -222,7 +223,7 @@ void __init iommu_hole_init(void)
 			continue;
 
 		iommu_detected = 1;
-		iommu_aperture = 1; 
+		gart_iommu_aperture = 1;
 
 		aper_order = (read_pci_config(0, num, 3, 0x90) >> 1) & 7; 
 		aper_size = (32 * 1024 * 1024) << aper_order; 
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 5330745..7b24ab7 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -25,11 +25,11 @@ static void __init via_bugs(void)
 {
 #ifdef CONFIG_GART_IOMMU
 	if ((end_pfn > MAX_DMA32_PFN ||  force_iommu) &&
-	    !iommu_aperture_allowed) {
+	    !gart_iommu_aperture_allowed) {
 		printk(KERN_INFO
 		       "Looks like a VIA chipset. Disabling IOMMU."
 		       " Override with iommu=allowed\n");
-		iommu_aperture_disabled = 1;
+		gart_iommu_aperture_disabled = 1;
 	}
 #endif
 }
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index 66b3dc5..aa805b1 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -299,7 +299,7 @@ void __init pci_iommu_alloc(void)
 	 * fall-back/fail-over reasons
 	 */
 #ifdef CONFIG_GART_IOMMU
-	iommu_hole_init();
+	gart_iommu_hole_init();
 #endif
 
 #ifdef CONFIG_CALGARY_IOMMU
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 7097ef8..dcca30b 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -628,12 +628,12 @@ void __init gart_iommu_init(void)
 		return;
 
 	/* Did we detect a different HW IOMMU? */
-	if (iommu_detected && !iommu_aperture)
+	if (iommu_detected && !gart_iommu_aperture)
 		return;
 
 	if (no_iommu ||
 	    (!force_iommu && end_pfn <= MAX_DMA32_PFN) ||
-	    !iommu_aperture ||
+	    !gart_iommu_aperture ||
 	    (no_agp && init_k8_gatt(&info) < 0)) {
 		if (end_pfn > MAX_DMA32_PFN) {
 			printk(KERN_ERR "WARNING more than 4GB of memory "
@@ -734,9 +734,9 @@ void __init gart_parse_options(char *p)
 		fix_aperture = 0;
 	/* duplicated from pci-dma.c */
 	if (!strncmp(p,"force",5))
-		iommu_aperture_allowed = 1;
+		gart_iommu_aperture_allowed = 1;
 	if (!strncmp(p,"allowed",7))
-		iommu_aperture_allowed = 1;
+		gart_iommu_aperture_allowed = 1;
 	if (!strncmp(p, "memaper", 7)) {
 		fallback_aper_force = 1;
 		p += 7;
diff --git a/include/asm-x86/gart.h b/include/asm-x86/gart.h
index cb7e989..27b4469 100644
--- a/include/asm-x86/gart.h
+++ b/include/asm-x86/gart.h
@@ -9,16 +9,16 @@ extern int iommu_detected;
 extern void gart_iommu_init(void);
 extern void gart_iommu_shutdown(void);
 extern void __init gart_parse_options(char *);
-extern void iommu_hole_init(void);
+extern void gart_iommu_hole_init(void);
 extern int fallback_aper_order;
 extern int fallback_aper_force;
-extern int iommu_aperture;
-extern int iommu_aperture_allowed;
-extern int iommu_aperture_disabled;
+extern int gart_iommu_aperture;
+extern int gart_iommu_aperture_allowed;
+extern int gart_iommu_aperture_disabled;
 extern int fix_aperture;
 #else
-#define iommu_aperture 0
-#define iommu_aperture_allowed 0
+#define gart_iommu_aperture 0
+#define gart_iommu_aperture_allowed 0
 
 static inline void gart_iommu_shutdown(void)
 {
-- 
1.5.2.5



