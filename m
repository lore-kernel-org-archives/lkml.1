Return-Path: <linux-kernel-owner+w=401wt.eu-S1752220AbZKJKt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbZKJKt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbZKJKt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:49:57 -0500
Received: from sh.osrg.net ([192.16.179.4]:45972 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbZKJKt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:49:56 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, chrisw@sous-sol.org, wmw2@infradead.org,
       joerg.roedel@amd.com, muli@il.ibm.com, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -v2 4/9] amd_iommu: convert amd_iommu_detect to use iommu_init hook
Date: Tue, 10 Nov 2009 19:46:15 +0900
Message-Id: <1257849980-22640-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 10 Nov 2009 19:49:32 +0900 (JST)
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
index 3604669..b8ef2ee 100644
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
 extern void amd_iommu_apply_erratum_63(u16 devid);
 #else
-static inline int amd_iommu_init(void) { return -ENODEV; }
 static inline void amd_iommu_detect(void) { }
 #endif
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 6acd43e..c41aabd 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -29,6 +29,7 @@
 #include <asm/amd_iommu.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
+#include <asm/x86_init.h>
 
 /*
  * definitions for the ACPI scanning code
@@ -1176,19 +1177,10 @@ static struct sys_device device_amd_iommu = {
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
@@ -1344,10 +1336,7 @@ void __init amd_iommu_detect(void)
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
index ecde854..5ca44a9 100644
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

