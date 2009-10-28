Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbZJ1Gya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbZJ1Gya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbZJ1Gy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:54:27 -0400
Received: from sh.osrg.net ([192.16.179.4]:54081 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757497AbZJ1GyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:54:24 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: chrisw@sous-sol.org, dwmw2@infradead.org, joerg.roedel@amd.com,
       mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 04/10] amd_iommu: convert amd_iommu_detect to use iommu_init hook
Date: Wed, 28 Oct 2009 15:47:38 +0900
Message-Id: <1256712464-21472-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 28 Oct 2009 15:53:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes amd_iommu_detect() to set amd_iommu_init to
iommu_init hook if amd_iommu_detect() finds the AMD IOMMU.

We can kill the code to check if we found the IOMMU in
amd_iommu_init() since amd_iommu_detect() sets amd_iommu_init() only
when it found the IOMMU.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/include/asm/amd_iommu.h |    2 --
 arch/x86/kernel/amd_iommu_init.c |   17 +++--------------
 arch/x86/kernel/pci-dma.c        |    2 --
 3 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index ac95995..240617e 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -23,7 +23,6 @@
 #include <linux/irqreturn.h>
 
 #ifdef CONFIG_AMD_IOMMU
-extern int amd_iommu_init(void);
 extern int amd_iommu_init_dma_ops(void);
 extern int amd_iommu_init_passthrough(void);
 extern void amd_iommu_detect(void);
@@ -32,7 +31,6 @@ extern void amd_iommu_flush_all_domains(void);
 extern void amd_iommu_flush_all_devices(void);
 extern void amd_iommu_shutdown(void);
 #else
-static inline int amd_iommu_init(void) { return -ENODEV; }
 static inline void amd_iommu_detect(void) { }
 static inline void amd_iommu_shutdown(void) { }
 #endif
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index b4b61d4..52bf59f 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -29,6 +29,7 @@
 #include <asm/amd_iommu.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
+#include <asm/x86_init.h>
 
 /*
  * definitions for the ACPI scanning code
@@ -1154,19 +1155,10 @@ static struct sys_device device_amd_iommu = {
  * functions. Finally it prints some information about AMD IOMMUs and
  * the driver state and enables the hardware.
  */
-int __init amd_iommu_init(void)
+static int __init amd_iommu_init(void)
 {
 	int i, ret = 0;
 
-
-	if (no_iommu) {
-		printk(KERN_INFO "AMD-Vi disabled by kernel command line\n");
-		return 0;
-	}
-
-	if (!amd_iommu_detected)
-		return -ENODEV;
-
 	/*
 	 * First parse ACPI tables to find the largest Bus/Dev/Func
 	 * we need to handle. Upon this information the shared data
@@ -1326,10 +1318,7 @@ void __init amd_iommu_detect(void)
 	if (acpi_table_parse("IVRS", early_amd_iommu_detect) == 0) {
 		iommu_detected = 1;
 		amd_iommu_detected = 1;
-#ifdef CONFIG_GART_IOMMU
-		gart_iommu_aperture_disabled = 1;
-		gart_iommu_aperture = 0;
-#endif
+		x86_init.iommu.iommu_init = amd_iommu_init;
 	}
 }
 
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 9830f12..6abb8c2 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -296,8 +296,6 @@ static int __init pci_iommu_init(void)
 
 	intel_iommu_init();
 
-	amd_iommu_init();
-
 	no_iommu_init();
 	return 0;
 }
-- 
1.5.6.5

