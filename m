Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbZKJNXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbZKJNXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbZKJNX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:23:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:34095 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528AbZKJNX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:23:27 -0500
Date: Tue, 10 Nov 2009 13:23:06 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257849980-22640-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1257849980-22640-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86: GART: Convert gart_iommu_hole_init() to use iommu_init hook
Message-ID: <tip-de957628ce7c84764ff41331111036b3ae5bad0f@git.kernel.org>
Git-Commit-ID: de957628ce7c84764ff41331111036b3ae5bad0f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de957628ce7c84764ff41331111036b3ae5bad0f
Gitweb:     http://git.kernel.org/tip/de957628ce7c84764ff41331111036b3ae5bad0f
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Tue, 10 Nov 2009 19:46:14 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 12:31:23 +0100

x86: GART: Convert gart_iommu_hole_init() to use iommu_init hook

This changes gart_iommu_hole_init() to set gart_iommu_init() to
iommu_init hook if gart_iommu_hole_init() finds the GART IOMMU.

We can kill the code to check if we found the IOMMU in
gart_iommu_init() since gart_iommu_hole_init() sets
gart_iommu_init() only when it found the IOMMU.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: chrisw@sous-sol.org
Cc: dwmw2@infradead.org
Cc: joerg.roedel@amd.com
Cc: muli@il.ibm.com
LKML-Reference: <1257849980-22640-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/gart.h   |    5 +----
 arch/x86/kernel/aperture_64.c |    2 ++
 arch/x86/kernel/pci-dma.c     |    2 --
 arch/x86/kernel/pci-gart_64.c |   15 +++++----------
 4 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/gart.h b/arch/x86/include/asm/gart.h
index 4fdd5b3..4ac5b0f 100644
--- a/arch/x86/include/asm/gart.h
+++ b/arch/x86/include/asm/gart.h
@@ -35,7 +35,7 @@ extern int gart_iommu_aperture_allowed;
 extern int gart_iommu_aperture_disabled;
 
 extern void early_gart_iommu_check(void);
-extern void gart_iommu_init(void);
+extern int gart_iommu_init(void);
 extern void __init gart_parse_options(char *);
 extern void gart_iommu_hole_init(void);
 
@@ -47,9 +47,6 @@ extern void gart_iommu_hole_init(void);
 static inline void early_gart_iommu_check(void)
 {
 }
-static inline void gart_iommu_init(void)
-{
-}
 static inline void gart_parse_options(char *options)
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
index 0224da8..ecde854 100644
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
index eb46ab3..0410bd3 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -709,7 +709,7 @@ static void gart_iommu_shutdown(void)
 	}
 }
 
-void __init gart_iommu_init(void)
+int __init gart_iommu_init(void)
 {
 	struct agp_kern_info info;
 	unsigned long iommu_start;
@@ -719,7 +719,7 @@ void __init gart_iommu_init(void)
 	long i;
 
 	if (cache_k8_northbridges() < 0 || num_k8_northbridges == 0)
-		return;
+		return 0;
 
 #ifndef CONFIG_AGP_AMD64
 	no_agp = 1;
@@ -731,13 +731,6 @@ void __init gart_iommu_init(void)
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
@@ -747,7 +740,7 @@ void __init gart_iommu_init(void)
 			       "but GART IOMMU not available.\n");
 			printk(KERN_WARNING "falling back to iommu=soft.\n");
 		}
-		return;
+		return 0;
 	}
 
 	/* need to map that range */
@@ -840,6 +833,8 @@ void __init gart_iommu_init(void)
 	flush_gart();
 	dma_ops = &gart_dma_ops;
 	x86_platform.iommu_shutdown = gart_iommu_shutdown;
+
+	return 0;
 }
 
 void __init gart_parse_options(char *p)
