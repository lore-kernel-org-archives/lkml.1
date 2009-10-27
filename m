Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbZJ0He6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbZJ0He6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbZJ0He5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:34:57 -0400
Received: from sh.osrg.net ([192.16.179.4]:42780 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbZJ0He4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:34:56 -0400
Date: Tue, 27 Oct 2009 16:34:44 +0900
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, joerg.roedel@amd.com
Subject: [PATCH] x86: use x86_platform for iommu_shutdown
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091027163358F.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 27 Oct 2009 16:34:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up pci_iommu_shutdown() a bit to use x86_platform
(similar to how IA64 initializes an IOMMU driver).

This adds iommu_shutdown() to x86_platform to avoid calling every
IOMMUs' shutdown functions in pci_iommu_shutdown() in order. The IOMMU
shutdown functions are platform specific (we don't have multiple
different IOMMU hardware) so the current way is pointless.

An IOMMU driver sets x86_platform.iommu_shutdown to the shutdown
function if necessary.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/include/asm/amd_iommu.h |    2 --
 arch/x86/include/asm/gart.h      |    4 ----
 arch/x86/include/asm/iommu.h     |    2 +-
 arch/x86/include/asm/x86_init.h  |    1 +
 arch/x86/kernel/amd_iommu_init.c |    6 +-----
 arch/x86/kernel/crash.c          |    5 ++---
 arch/x86/kernel/pci-dma.c        |    7 -------
 arch/x86/kernel/pci-gart_64.c    |    6 ++++--
 arch/x86/kernel/reboot.c         |    4 ++--
 arch/x86/kernel/x86_init.c       |    2 ++
 10 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index ac95995..5b0713b 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -30,11 +30,9 @@ extern void amd_iommu_detect(void);
 extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
 extern void amd_iommu_flush_all_domains(void);
 extern void amd_iommu_flush_all_devices(void);
-extern void amd_iommu_shutdown(void);
 #else
 static inline int amd_iommu_init(void) { return -ENODEV; }
 static inline void amd_iommu_detect(void) { }
-static inline void amd_iommu_shutdown(void) { }
 #endif
 
 #endif /* _ASM_X86_AMD_IOMMU_H */
diff --git a/arch/x86/include/asm/gart.h b/arch/x86/include/asm/gart.h
index 6cfdafa..4fdd5b3 100644
--- a/arch/x86/include/asm/gart.h
+++ b/arch/x86/include/asm/gart.h
@@ -36,7 +36,6 @@ extern int gart_iommu_aperture_disabled;
 
 extern void early_gart_iommu_check(void);
 extern void gart_iommu_init(void);
-extern void gart_iommu_shutdown(void);
 extern void __init gart_parse_options(char *);
 extern void gart_iommu_hole_init(void);
 
@@ -51,9 +50,6 @@ static inline void early_gart_iommu_check(void)
 static inline void gart_iommu_init(void)
 {
 }
-static inline void gart_iommu_shutdown(void)
-{
-}
 static inline void gart_parse_options(char *options)
 {
 }
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index fd6d21b..878b307 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_IOMMU_H
 #define _ASM_X86_IOMMU_H
 
-extern void pci_iommu_shutdown(void);
+static inline void iommu_shutdown_noop(void) {}
 extern void no_iommu_init(void);
 extern struct dma_map_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 2c756fd..66008ed 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -121,6 +121,7 @@ struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
 	unsigned long (*get_wallclock)(void);
 	int (*set_wallclock)(unsigned long nowtime);
+	void (*iommu_shutdown)(void);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index b4b61d4..c4c6f29 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1275,6 +1275,7 @@ int __init amd_iommu_init(void)
 	else
 		printk(KERN_INFO "AMD-Vi: Lazy IO/TLB flushing enabled\n");
 
+	x86_platform.iommu_shutdown = disable_iommus;
 out:
 	return ret;
 
@@ -1301,11 +1302,6 @@ free:
 	goto out;
 }
 
-void amd_iommu_shutdown(void)
-{
-	disable_iommus();
-}
-
 /****************************************************************************
  *
  * Early detect code. This code runs at IOMMU detection time in the DMA
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 5e409dc..a4849c1 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -27,8 +27,7 @@
 #include <asm/cpu.h>
 #include <asm/reboot.h>
 #include <asm/virtext.h>
-#include <asm/iommu.h>
-
+#include <asm/x86_init.h>
 
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
@@ -106,7 +105,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 #endif
 
 #ifdef CONFIG_X86_64
-	pci_iommu_shutdown();
+	x86_platform.iommu_shutdown();
 #endif
 
 	crash_save_cpu(regs, safe_smp_processor_id());
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index b2a71dc..ce2fb91 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -303,13 +303,6 @@ static int __init pci_iommu_init(void)
 	no_iommu_init();
 	return 0;
 }
-
-void pci_iommu_shutdown(void)
-{
-	gart_iommu_shutdown();
-
-	amd_iommu_shutdown();
-}
 /* Must execute after PCI subsystem */
 rootfs_initcall(pci_iommu_init);
 
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index a7f1b64..a9bcdf7 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -39,6 +39,7 @@
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
 #include <asm/k8.h>
+#include <asm/x86_init.h>
 
 static unsigned long iommu_bus_base;	/* GART remapping area (physical) */
 static unsigned long iommu_size;	/* size of remapping area bytes */
@@ -688,12 +689,12 @@ static struct dma_map_ops gart_dma_ops = {
 	.free_coherent			= gart_free_coherent,
 };
 
-void gart_iommu_shutdown(void)
+static void gart_iommu_shutdown(void)
 {
 	struct pci_dev *dev;
 	int i;
 
-	if (no_agp && (dma_ops != &gart_dma_ops))
+	if (no_agp)
 		return;
 
 	for (i = 0; i < num_k8_northbridges; i++) {
@@ -838,6 +839,7 @@ void __init gart_iommu_init(void)
 
 	flush_gart();
 	dma_ops = &gart_dma_ops;
+	x86_platform.iommu_shutdown = gart_iommu_shutdown;
 }
 
 void __init gart_parse_options(char *p)
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index a1a3cdd..6f97599 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -23,7 +23,7 @@
 # include <linux/ctype.h>
 # include <linux/mc146818rtc.h>
 #else
-# include <asm/iommu.h>
+# include <asm/x86_init.h>
 #endif
 
 /*
@@ -614,7 +614,7 @@ void native_machine_shutdown(void)
 #endif
 
 #ifdef CONFIG_X86_64
-	pci_iommu_shutdown();
+	x86_platform.iommu_shutdown();
 #endif
 }
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 4449a4a..bc9b230 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -14,6 +14,7 @@
 #include <asm/time.h>
 #include <asm/irq.h>
 #include <asm/tsc.h>
+#include <asm/iommu.h>
 
 void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
@@ -72,4 +73,5 @@ struct x86_platform_ops x86_platform = {
 	.calibrate_tsc			= native_calibrate_tsc,
 	.get_wallclock			= mach_get_cmos_time,
 	.set_wallclock			= mach_set_rtc_mmss,
+	.iommu_shutdown			= iommu_shutdown_noop,
 };
-- 
1.5.6.5

