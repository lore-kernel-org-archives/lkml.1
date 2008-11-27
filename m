Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbYK0Rjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbYK0Rjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 12:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYK0Rjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 12:39:43 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:52428 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbYK0Rjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 12:39:41 -0500
X-BigFish: VPS8(zzzzzz92fbmz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KB06DF-04-FYP-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] x86: move GART specific stuff from iommu.h to gart.h
Date: Thu, 27 Nov 2008 18:39:15 +0100
Message-ID: <1227807555-10499-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 27 Nov 2008 17:39:15.0203 (UTC) FILETIME=[110C5D30:01C950B7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/gart.h      |   33 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/iommu.h     |   33 ---------------------------------
 arch/x86/kernel/amd_iommu.c      |    1 +
 arch/x86/kernel/amd_iommu_init.c |    1 +
 arch/x86/kernel/early-quirks.c   |    1 +
 arch/x86/kernel/pci-dma.c        |    1 +
 arch/x86/kernel/setup.c          |    1 +
 7 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/gart.h b/arch/x86/include/asm/gart.h
index 7425226..6cfdafa 100644
--- a/arch/x86/include/asm/gart.h
+++ b/arch/x86/include/asm/gart.h
@@ -29,6 +29,39 @@ extern int fix_aperture;
 #define AMD64_GARTCACHECTL	0x9c
 #define AMD64_GARTEN		(1<<0)
 
+#ifdef CONFIG_GART_IOMMU
+extern int gart_iommu_aperture;
+extern int gart_iommu_aperture_allowed;
+extern int gart_iommu_aperture_disabled;
+
+extern void early_gart_iommu_check(void);
+extern void gart_iommu_init(void);
+extern void gart_iommu_shutdown(void);
+extern void __init gart_parse_options(char *);
+extern void gart_iommu_hole_init(void);
+
+#else
+#define gart_iommu_aperture            0
+#define gart_iommu_aperture_allowed    0
+#define gart_iommu_aperture_disabled   1
+
+static inline void early_gart_iommu_check(void)
+{
+}
+static inline void gart_iommu_init(void)
+{
+}
+static inline void gart_iommu_shutdown(void)
+{
+}
+static inline void gart_parse_options(char *options)
+{
+}
+static inline void gart_iommu_hole_init(void)
+{
+}
+#endif
+
 extern int agp_amd64_init(void);
 
 static inline void enable_gart_translation(struct pci_dev *dev, u64 addr)
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index 0b500c5..295b131 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -12,37 +12,4 @@ extern unsigned long iommu_nr_pages(unsigned long addr, unsigned long len);
 /* 10 seconds */
 #define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000)
 
-#ifdef CONFIG_GART_IOMMU
-extern int gart_iommu_aperture;
-extern int gart_iommu_aperture_allowed;
-extern int gart_iommu_aperture_disabled;
-
-extern void early_gart_iommu_check(void);
-extern void gart_iommu_init(void);
-extern void gart_iommu_shutdown(void);
-extern void __init gart_parse_options(char *);
-extern void gart_iommu_hole_init(void);
-
-#else
-#define gart_iommu_aperture            0
-#define gart_iommu_aperture_allowed    0
-#define gart_iommu_aperture_disabled   1
-
-static inline void early_gart_iommu_check(void)
-{
-}
-static inline void gart_iommu_init(void)
-{
-}
-static inline void gart_iommu_shutdown(void)
-{
-}
-static inline void gart_parse_options(char *options)
-{
-}
-static inline void gart_iommu_hole_init(void)
-{
-}
-#endif
-
 #endif /* _ASM_X86_IOMMU_H */
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index e4899e0..d434a97 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -24,6 +24,7 @@
 #include <linux/iommu-helper.h>
 #include <asm/proto.h>
 #include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/amd_iommu_types.h>
 #include <asm/amd_iommu.h>
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 30ae270..1188b98 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -28,6 +28,7 @@
 #include <asm/amd_iommu_types.h>
 #include <asm/amd_iommu.h>
 #include <asm/iommu.h>
+#include <asm/gart.h>
 
 /*
  * definitions for the ACPI scanning code
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 1b894b7..744aa7f 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -17,6 +17,7 @@
 #include <asm/io_apic.h>
 #include <asm/apic.h>
 #include <asm/iommu.h>
+#include <asm/gart.h>
 
 static void __init fix_hypertransport_config(int num, int slot, int func)
 {
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1926248..12eeb4b 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -6,6 +6,7 @@
 #include <asm/proto.h>
 #include <asm/dma.h>
 #include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/calgary.h>
 #include <asm/amd_iommu.h>
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9d5674f..decb492 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -93,6 +93,7 @@
 #include <asm/desc.h>
 #include <asm/dma.h>
 #include <asm/iommu.h>
+#include <asm/gart.h>
 #include <asm/mmu_context.h>
 #include <asm/proto.h>
 
-- 
1.5.6.4


