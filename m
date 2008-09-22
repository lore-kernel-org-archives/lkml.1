Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYIVStD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYIVStD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbYIVSss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:48:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41811 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbYIVSsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:48:47 -0400
Date: Mon, 22 Sep 2008 20:48:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic
	option
Message-ID: <20080922184822.GA24046@elte.hu>
References: <20080922111730.GF5987@elte.hu> <20080923002516R.fujita.tomonori@lab.ntt.co.jp> <20080922162314.GC24392@amd.com> <20080923015059M.fujita.tomonori@lab.ntt.co.jp> <20080922183414.GI24392@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922183414.GI24392@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Tue, Sep 23, 2008 at 01:51:05AM +0900, FUJITA Tomonori wrote:
> > The patch that I sent doesn't make any changes for you. GART works as
> > before and AMD IOMMU takes a new parameter, fullflush, as you want. It
> > does the exact same thing that the first version of your patchset for
> > 2.6.28.
> > 
> > So please let me apply it then we can stop this discussion.
> 
> Ok, so it was not nice from me to let Ingo pull this patch without 
> your ack, I already admitted. To end this discussion and get to 
> productive discussions, Ingo, please apply this patch. I hope we will 
> work together on a final solution for the problem.

applied Fujita's patch below to tip/x86/iommu that reverts those 
options, thanks guys!

i'm wondering how we should proceed. For debug, iommu=off is certainly 
good enough - all kernels are supposed to work out of box on all hw, and 
every other result is a regression that must be fixed.

For performance tuning, it probably makes sense for developers to tune 
IOMMU details (so that the bootup defaults can be improved - this is not 
really something that should be done on a workload basis), but for that 
IMO a /debug interface is a lot more useful than rather intrusive (and 
inflexible) boot options.

What do you think about a debugfs based tuning of various IOMMU details? 
Maybe even the active driver could be changed - say from AMD-IOMMU to 
GART, or to off.

Flipping IOMMU state on a running system means a whole lot of new 
complexities, but it might be rather useful. It's useful for testing as 
well, obviously.

	Ingo

------------------->
>From afa9fdc2f5f8e4d98f3e77bfa204412cbc181346 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Sat, 20 Sep 2008 01:23:30 +0900
Subject: [PATCH] iommu: remove fullflush and nofullflush in IOMMU generic option

This patch against tip/x86/iommu virtually reverts
2842e5bf3115193f05dc9dac20f940e7abf44c1a. But just reverting the
commit breaks AMD IOMMU so this patch also includes some fixes.

The above commit adds new two options to x86 IOMMU generic kernel boot
options, fullflush and nofullflush. But such change that affects all
the IOMMUs needs more discussion (all IOMMU parties need the chance to
discuss it):

http://lkml.org/lkml/2008/9/19/106

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index 40066ce..040ce30 100644
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
@@ -893,10 +898,6 @@ and is between 256 and 4096 characters. It is defined in the file
 		nomerge
 		forcesac
 		soft
-		fullflush
-			Flush IO/TLB at every deallocation
-		nofullflush
-			Flush IO/TLB only when addresses are reused (default)
 
 
 	intel_iommu=	[DMAR] Intel IOMMU driver (DMAR) option
diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index c83c8e4..b0c7b6c 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -233,6 +233,8 @@ IOMMU (input/output memory management unit)
   iommu options only relevant to the AMD GART hardware IOMMU:
     <size>             Set the size of the remapping area in bytes.
     allowed            Overwrite iommu off workarounds for specific chipsets.
+    fullflush          Flush IOMMU on each allocation (default).
+    nofullflush        Don't use IOMMU fullflush.
     leak               Turn on simple iommu leak tracing (only when
                        CONFIG_IOMMU_LEAK is on). Default number of leak pages
                        is 20.
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 70537d1..c192121 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -948,7 +948,7 @@ static dma_addr_t __map_single(struct device *dev,
 	}
 	address += offset;
 
-	if (unlikely(dma_dom->need_flush && !iommu_fullflush)) {
+	if (unlikely(dma_dom->need_flush && !amd_iommu_unmap_flush)) {
 		iommu_flush_tlb(iommu, dma_dom->domain.id);
 		dma_dom->need_flush = false;
 	} else if (unlikely(iommu_has_npcache(iommu)))
@@ -985,7 +985,7 @@ static void __unmap_single(struct amd_iommu *iommu,
 
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
index d2f2c01..0a1408a 100644
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
index 3dcb1ad..9e390f1 100644
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
index f953309..4ff892f 100644
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
index 67b2fd5..621a1af 100644
--- a/include/asm-x86/iommu.h
+++ b/include/asm-x86/iommu.h
@@ -7,7 +7,6 @@ extern struct dma_mapping_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 extern int dmar_disabled;
-extern int iommu_fullflush;
 
 extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len);
 
