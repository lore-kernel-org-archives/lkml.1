Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYISQYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYISQYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 12:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYISQYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 12:24:00 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:55073 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbYISQX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 12:23:59 -0400
Date: Sat, 20 Sep 2008 01:23:30 +0900
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org
Subject: [PATCH] remove fullflush and nofullflush in IOMMU generic option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080920012322R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch against tip/x86/iommu virtually reverts
2842e5bf3115193f05dc9dac20f940e7abf44c1a. But just reverting the
commit breaks AMD IOMMU so this patch also includes some fixes.

The above commit adds new two options to x86 IOMMU generic kernel boot
options, fullflush and nofullflush. But such change that affects all
the IOMMUs needs more discussion (all IOMMU parties need the chance to
discuss it):

http://lkml.org/lkml/2008/9/19/106

For me, adding these boot parameters doesn't make sense.

All the hardware IOMMUs could use 'fullflush' for lazy IOTLB flushing
but Calgary doesn't support it. Intel VT-d has the different option
for it (and we can't rename it). So it might be useful for only GART
and AMD IOMMU.

'nofullflush' definitely is pointless. 'nofullflush' option doesn't
change any kernel behavior and it was added just for GART
compatibility. We should not have such generic meaningless option just
for GART.

This patch removes the fullflush and nofullflush from the generic
kernel boot options and adds 'fullflush' support for AMD IOMMU.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/kernel-parameters.txt       |    9 +++++----
 Documentation/x86/x86_64/boot-options.txt |    2 ++
 arch/x86/kernel/amd_iommu.c               |    4 ++--
 arch/x86/kernel/amd_iommu_init.c          |    5 ++++-
 arch/x86/kernel/pci-dma.c                 |   13 -------------
 arch/x86/kernel/pci-gart_64.c             |   13 +++++++++++++
 include/asm-x86/amd_iommu_types.h         |    6 ++++++
 include/asm-x86/iommu.h                   |    1 -
 8 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 569527e..4b9ee9b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -284,6 +284,11 @@ and is between 256 and 4096 characters. It is defined in the file
 			isolate - enable device isolation (each device, as far
 			          as possible, will get its own protection
 			          domain)
+			fullflush - enable flushing of IO/TLB entries when
+				    they are unmapped. Otherwise they are
+				    flushed before they will be reused, which
+				    is a lot of faster
+
 	amd_iommu_size= [HW,X86-64]
 			Define the size of the aperture for the AMD IOMMU
 			driver. Possible values are:
@@ -888,10 +893,6 @@ and is between 256 and 4096 characters. It is defined in the file
 		nomerge
 		forcesac
 		soft
-		fullflush
-			Flush IO/TLB at every deallocation
-		nofullflush
-			Flush IO/TLB only when addresses are reused (default)
 
 
 	intel_iommu=	[DMAR] Intel IOMMU driver (DMAR) option
diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 42c887b..72ffb53 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -229,6 +229,8 @@ IOMMU (input/output memory management unit)
   iommu options only relevant to the AMD GART hardware IOMMU:
     <size>             Set the size of the remapping area in bytes.
     allowed            Overwrite iommu off workarounds for specific chipsets.
+    fullflush          Flush IOMMU on each allocation (default).
+    nofullflush        Don't use IOMMU fullflush.
     leak               Turn on simple iommu leak tracing (only when
                        CONFIG_IOMMU_LEAK is on). Default number of leak pages
                        is 20.
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 853b614..523e113 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -958,7 +958,7 @@ static dma_addr_t __map_single(struct device *dev,
 	}
 	address += offset;
 
-	if (unlikely(dma_dom->need_flush && !iommu_fullflush)) {
+	if (unlikely(dma_dom->need_flush && !amd_iommu_unmap_flush)) {
 		iommu_flush_tlb(iommu, dma_dom->domain.id);
 		dma_dom->need_flush = false;
 	} else if (unlikely(iommu_has_npcache(iommu)))
@@ -995,7 +995,7 @@ static void __unmap_single(struct amd_iommu *iommu,
 
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
 
-	if (iommu_fullflush)
+	if (amd_iommu_unmap_flush)
 		iommu_flush_pages(iommu, dma_dom->domain.id, dma_addr, size);
 }
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index db0c83a..148fcfe 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -122,6 +122,7 @@ LIST_HEAD(amd_iommu_unity_map);		/* a list of required unity mappings
 					   we find in ACPI */
 unsigned amd_iommu_aperture_order = 26; /* size of aperture in power of 2 */
 int amd_iommu_isolate;			/* if 1, device isolation is enabled */
+bool amd_iommu_unmap_flush;		/* if true, flush on every unmap */
 
 LIST_HEAD(amd_iommu_list);		/* list of all AMD IOMMUs in the
 					   system */
@@ -1144,7 +1145,7 @@ int __init amd_iommu_init(void)
 	else
 		printk("disabled\n");
 
-	if (iommu_fullflush)
+	if (amd_iommu_unmap_flush)
 		printk(KERN_INFO "AMD IOMMU: IO/TLB flush on unmap enabled\n");
 	else
 		printk(KERN_INFO "AMD IOMMU: Lazy IO/TLB flushing enabled\n");
@@ -1214,6 +1215,8 @@ static int __init parse_amd_iommu_options(char *str)
 	for (; *str; ++str) {
 		if (strncmp(str, "isolate", 7) == 0)
 			amd_iommu_isolate = 1;
+		if (strncmp(str, "fullflush", 11) == 0)
+			amd_iommu_unmap_flush = true;
 	}
 
 	return 1;
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 6dae123..23882c4 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -16,15 +16,6 @@ EXPORT_SYMBOL(dma_ops);
 
 static int iommu_sac_force __read_mostly;
 
-/*
- * If this is disabled the IOMMU will use an optimized flushing strategy
- * of only flushing when an mapping is reused. With it true the GART is
- * flushed for every mapping. Problem is that doing the lazy flush seems
- * to trigger bugs with some popular PCI cards, in particular 3ware (but
- * has been also also seen with Qlogic at least).
- */
-int iommu_fullflush;
-
 #ifdef CONFIG_IOMMU_DEBUG
 int panic_on_overflow __read_mostly = 1;
 int force_iommu __read_mostly = 1;
@@ -180,10 +171,6 @@ static __init int iommu_setup(char *p)
 		}
 		if (!strncmp(p, "nomerge", 7))
 			iommu_merge = 0;
-		if (!strncmp(p, "fullflush", 8))
-			iommu_fullflush = 1;
-		if (!strncmp(p, "nofullflush", 11))
-			iommu_fullflush = 0;
 		if (!strncmp(p, "forcesac", 8))
 			iommu_sac_force = 1;
 		if (!strncmp(p, "allowdac", 8))
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 508ef47..9739d56 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -45,6 +45,15 @@ static unsigned long iommu_pages;	/* .. and in pages */
 
 static u32 *iommu_gatt_base;		/* Remapping table */
 
+/*
+ * If this is disabled the IOMMU will use an optimized flushing strategy
+ * of only flushing when an mapping is reused. With it true the GART is
+ * flushed for every mapping. Problem is that doing the lazy flush seems
+ * to trigger bugs with some popular PCI cards, in particular 3ware (but
+ * has been also also seen with Qlogic at least).
+ */
+int iommu_fullflush = 1;
+
 /* Allocation bitmap for the remapping area: */
 static DEFINE_SPINLOCK(iommu_bitmap_lock);
 /* Guarded by iommu_bitmap_lock: */
@@ -892,6 +901,10 @@ void __init gart_parse_options(char *p)
 #endif
 	if (isdigit(*p) && get_option(&p, &arg))
 		iommu_size = arg;
+	if (!strncmp(p, "fullflush", 8))
+		iommu_fullflush = 1;
+	if (!strncmp(p, "nofullflush", 11))
+		iommu_fullflush = 0;
 	if (!strncmp(p, "noagp", 5))
 		no_agp = 1;
 	if (!strncmp(p, "noaperture", 10))
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index d90b66a..b308586 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -376,6 +376,12 @@ extern unsigned long *amd_iommu_pd_alloc_bitmap;
 /* will be 1 if device isolation is enabled */
 extern int amd_iommu_isolate;
 
+/*
+ * If true, the addresses will be flushed on unmap time, not when
+ * they are reused
+ */
+extern bool amd_iommu_unmap_flush;
+
 /* takes a PCI device id and prints it out in a readable form */
 static inline void print_devid(u16 devid, int nl)
 {
diff --git a/include/asm-x86/iommu.h b/include/asm-x86/iommu.h
index bcebc37..546ad31 100644
--- a/include/asm-x86/iommu.h
+++ b/include/asm-x86/iommu.h
@@ -7,7 +7,6 @@ extern struct dma_mapping_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 extern int dmar_disabled;
-extern int iommu_fullflush;
 
 extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len);
 
-- 
1.5.4.2

