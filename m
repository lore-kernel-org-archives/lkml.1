Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbZHMDSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbZHMDSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 23:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZHMDSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 23:18:45 -0400
Received: from sh.osrg.net ([192.16.179.4]:60190 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbZHMDSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 23:18:44 -0400
Date: Thu, 13 Aug 2009 12:18:04 +0900
To: fujita.tomonori@lab.ntt.co.jp
Cc: luming.yu@gmail.com, dwmw2@infradead.org, fenghua.yu@intel.com,
       tony.luck@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init 
	failure
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090813121444W.fujita.tomonori@lab.ntt.co.jp>
References: <20090813110948V.fujita.tomonori@lab.ntt.co.jp>
	<3877989d0908121924t1589941fmcd45d3669b78bba4@mail.gmail.com>
	<20090813121444W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090813121727W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 13 Aug 2009 12:18:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 12:15:46 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Thu, 13 Aug 2009 10:24:20 +0800
> Luming Yu <luming.yu@gmail.com> wrote:
> 
> > On Thu, Aug 13, 2009 at 10:11 AM, FUJITA
> > Tomonori<fujita.tomonori@lab.ntt.co.jp> wrote:
> > > On Wed, 12 Aug 2009 17:20:11 +0800
> > > Luming Yu <luming.yu@gmail.com> wrote:
> > >
> > >> Hi there,
> > >>
> > >> On ia64 platform with dmar table and new upstream
> > >> kernel(config_dmar_default_on enabled),
> > >> if intel_iommu_init ends up without dma_ops initialized or other iommu
> > >> failures.
> > >> We got nothing to fall back. The following patch fixes it.
> > >
> > > Hmm, I think that the current code should work.
> > 
> > Without the patch, I encounters boot failure with the following .config
> > 
> > 162-CONFIG_IA64_GENERIC=y
> > 163-# CONFIG_IA64_DIG is not set
> > 164:# CONFIG_IA64_DIG_VTD is not set
> 
> Duh, yeah, intel_iommu_init() fails, it doesn't work.
> 
> X86 falls back into nommu_dam_ops but IA64 has nothing.
> 
> pci_swiotlb_init() can't set swiotlb to 1 or overwrite dma_ops? If it
> sets swiotlb to 1, intel_iommu_init() fails.
> 
> A quick fix could be something like this:

Oops, here's a good one.

diff --git a/arch/ia64/include/asm/swiotlb.h b/arch/ia64/include/asm/swiotlb.h
index dcbaea7..21b076e 100644
--- a/arch/ia64/include/asm/swiotlb.h
+++ b/arch/ia64/include/asm/swiotlb.h
@@ -5,6 +5,7 @@
 #include <linux/swiotlb.h>
 
 extern int swiotlb_force;
+extern struct dma_map_ops swiotlb_dma_ops;
 
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index f6b1ff0..344d783 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -11,6 +11,7 @@
 #include <asm/iommu.h>
 #include <asm/machvec.h>
 #include <linux/dma-mapping.h>
+#include <asm/swiotlb.h>
 
 #include <asm/system.h>
 
@@ -47,8 +48,13 @@ extern struct dma_map_ops intel_dma_ops;
 
 static int __init pci_iommu_init(void)
 {
-	if (iommu_detected)
-		intel_iommu_init();
+	int ret;
+
+	if (iommu_detected) {
+		ret = intel_iommu_init();
+		if (ret)
+			dma_ops = &swiotlb_dma_ops;
+	}
 
 	return 0;
 }
diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
index 223abb1..fb06ef6 100644
--- a/arch/ia64/kernel/pci-swiotlb.c
+++ b/arch/ia64/kernel/pci-swiotlb.c
@@ -46,12 +46,14 @@ void __init swiotlb_dma_init(void)
 
 void __init pci_swiotlb_init(void)
 {
+	/* for fallback */
+	swiotlb_init();
+
 	if (!iommu_detected || iommu_pass_through) {
 #ifdef CONFIG_IA64_GENERIC
 		swiotlb = 1;
 		printk(KERN_INFO "PCI-DMA: Re-initialize machine vector.\n");
 		machvec_init("dig");
-		swiotlb_init();
 		dma_ops = &swiotlb_dma_ops;
 #else
 		panic("Unable to find Intel IOMMU");
