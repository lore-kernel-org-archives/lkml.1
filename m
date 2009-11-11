Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZKKPEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZKKPEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757276AbZKKPEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:04:09 -0500
Received: from sh.osrg.net ([192.16.179.4]:43955 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755318AbZKKPEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:04:08 -0500
Date: Thu, 12 Nov 2009 00:03:28 +0900
To: sfr@canb.auug.org.au
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, peterz@infradead.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: linux-next: tip tree build failure
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091111201302.da1bab60.sfr@canb.auug.org.au>
References: <20091111201302.da1bab60.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091112000258F.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 12 Nov 2009 00:03:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 20:13:02 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next build (powerpc allyesconfig) failed like this:
> 
> lib/swiotlb.c: In function 'setup_io_tlb_npages':
> lib/swiotlb.c:114: error: 'swiotlb' undeclared (first use in this function)
> 
> Caused by commit 75f1cdf1dda92cae037ec848ae63690d91913eac ("x86: Handle
> HW IOMMU initialization failure gracefully") from the tip tree.  It looks
> like the "swiotlb" variable only exists in x86 and ia64.
> 
> I have reverted that commit for today.

Duh, sorry about it. I should have complied that patchset for POWERPC
too. POWERPC has swiotlb but it doesn't expect it to be used (POWERPC
can remove it).

I think that the following patch works. I'll do more cleanup related
with x86 IOMMU initialization soon (I'm at JFK to go back to Japan).

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] swiotlb: remove the swiotlb variable usage

POWERPC doesn't expect it to be used.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/include/asm/swiotlb.h |    5 +++--
 arch/x86/kernel/pci-dma.c      |    5 +----
 arch/x86/kernel/pci-swiotlb.c  |   13 ++++++++++++-
 lib/swiotlb.c                  |    5 ++---
 4 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/swiotlb.h b/arch/x86/include/asm/swiotlb.h
index b9e4e20..940f13a 100644
--- a/arch/x86/include/asm/swiotlb.h
+++ b/arch/x86/include/asm/swiotlb.h
@@ -9,11 +9,12 @@ extern int swiotlb_force;
 
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
-extern void pci_swiotlb_init(void);
+extern int pci_swiotlb_init(void);
 #else
 #define swiotlb 0
-static inline void pci_swiotlb_init(void)
+static inline int pci_swiotlb_init(void)
 {
+	return 0;
 }
 #endif
 
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index f79870e..0b11bf1 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -125,16 +125,13 @@ static void __init dma32_free_bootmem(void)
 
 void __init pci_iommu_alloc(void)
 {
-	/* swiotlb is forced by the boot option */
-	int use_swiotlb = swiotlb;
 #ifdef CONFIG_X86_64
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 #else
 	dma_ops = &nommu_dma_ops;
 #endif
-	pci_swiotlb_init();
-	if (use_swiotlb)
+	if (pci_swiotlb_init())
 		return;
 
 	gart_iommu_hole_init();
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 17ce422..a6e5d0f 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -42,16 +42,27 @@ static struct dma_map_ops swiotlb_dma_ops = {
 	.dma_supported = NULL,
 };
 
-void __init pci_swiotlb_init(void)
+/*
+ * pci_swiotlb_init - initialize swiotlb if necessary
+ *
+ * This returns non-zero if we are forced to use swiotlb (by the boot
+ * option).
+ */
+int __init pci_swiotlb_init(void)
 {
 	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
 #ifdef CONFIG_X86_64
 	if (!no_iommu && max_pfn > MAX_DMA32_PFN)
 		swiotlb = 1;
 #endif
+	if (swiotlb_force)
+		swiotlb = 1;
+
 	if (swiotlb) {
 		swiotlb_init(0);
 		dma_ops = &swiotlb_dma_ops;
 	} else
 		dma_ops = &nommu_dma_ops;
+
+	return swiotlb_force;
 }
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index e6755a0..795472d 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -109,10 +109,9 @@ setup_io_tlb_npages(char *str)
 	}
 	if (*str == ',')
 		++str;
-	if (!strcmp(str, "force")) {
+	if (!strcmp(str, "force"))
 		swiotlb_force = 1;
-		swiotlb = 1;
-	}
+
 	return 1;
 }
 __setup("swiotlb=", setup_io_tlb_npages);
-- 
1.5.6.5

