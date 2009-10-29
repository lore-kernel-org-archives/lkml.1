Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbZJ2I2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbZJ2I2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZJ2I2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:28:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:44138 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbZJ2I2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:28:16 -0400
Date: Thu, 29 Oct 2009 17:27:36 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, dwmw2@infradead.org, mingo@elte.hu
Subject: Re: [PATCH 0/10] x86: handle HW IOMMU initialization failure
 gracely
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091028132119.GC5876@amd.com>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20091028132119.GC5876@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091029172623X.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 29 Oct 2009 17:27:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009 14:21:19 +0100
Joerg Roedel <joerg.roedel@amd.com> wrote:

> > The new x86 IOMMU initialization sequence are:
> > 
> > 1. initializing swiotlb (and setting swiotlb to 1) in the case of
> > (max_pfn > MAX_DMA32_PFN && !no_iommu). dma_ops is set to
> > swiotlb_dma_ops or nommu_dma_ops.
> > 
> > 2. calling the detection functions of all the IOMMUs
> > 
> > 3. the detection function sets x86_init.iommu.iommu_init to the IOMMU
> > initialization function (so we can avoid calling the initialization
> > functions of all the IOMMUs needlessly).
> > 
> > 4. if the IOMMU initialization function doesn't need to swiotlb then
> > sets swiotlb to zero (e.g. the initialization is sucessful).
> > 
> > 5. if we find that swiotlb is set to zero, we free swiotlb resource.
> 
> I started to test this patchset. It breaks the iommu=soft selection to
> force using swiotlb usage. On my machine always the AMD IOMMU driver
> gots selected and initialized.

Thanks for testing the patchset.

Sorry about the bug. I need to add 1.5 to the above sequence:

1.5 if swiotlb usage is forced by the boot option, we skip the rest.

Here's a patch against the patchset.

diff --git a/arch/ia64/include/asm/swiotlb.h b/arch/ia64/include/asm/swiotlb.h
index dcbaea7..f0acde6 100644
--- a/arch/ia64/include/asm/swiotlb.h
+++ b/arch/ia64/include/asm/swiotlb.h
@@ -4,8 +4,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/swiotlb.h>
 
-extern int swiotlb_force;
-
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
 extern void pci_swiotlb_init(void);
diff --git a/arch/x86/include/asm/swiotlb.h b/arch/x86/include/asm/swiotlb.h
index b9e4e20..193aa75 100644
--- a/arch/x86/include/asm/swiotlb.h
+++ b/arch/x86/include/asm/swiotlb.h
@@ -5,8 +5,6 @@
 
 /* SWIOTLB interface */
 
-extern int swiotlb_force;
-
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
 extern void pci_swiotlb_init(void);
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 28fd54a..2583a0b 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -124,11 +124,15 @@ static void __init dma32_free_bootmem(void)
 
 void __init pci_iommu_alloc(void)
 {
+	/* swiotlb is forced by the boot option */
+	int use_swiotlb = swiotlb;
 #ifdef CONFIG_X86_64
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 #endif
 	pci_swiotlb_init();
+	if (use_swiotlb)
+		return;
 
 	gart_iommu_hole_init();
 
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 607fbb6..17ce422 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -49,8 +49,6 @@ void __init pci_swiotlb_init(void)
 	if (!no_iommu && max_pfn > MAX_DMA32_PFN)
 		swiotlb = 1;
 #endif
-	if (swiotlb_force)
-		swiotlb = 1;
 	if (swiotlb) {
 		swiotlb_init(0);
 		dma_ops = &swiotlb_dma_ops;
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 0c12d7c..2eae139 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -57,7 +57,7 @@ enum dma_sync_target {
 	SYNC_FOR_DEVICE = 1,
 };
 
-int swiotlb_force;
+static int swiotlb_force;
 
 /*
  * Used to do a quick range check in unmap_single and
@@ -109,8 +109,10 @@ setup_io_tlb_npages(char *str)
 	}
 	if (*str == ',')
 		++str;
-	if (!strcmp(str, "force"))
+	if (!strcmp(str, "force")) {
 		swiotlb_force = 1;
+		swiotlb = 1;
+	}
 	return 1;
 }
 __setup("swiotlb=", setup_io_tlb_npages);




