Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbZHMGxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbZHMGxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 02:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZHMGxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 02:53:08 -0400
Received: from sh.osrg.net ([192.16.179.4]:47125 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbZHMGxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 02:53:06 -0400
Date: Thu, 13 Aug 2009 15:52:18 +0900
To: luming.yu@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, fenghua.yu@intel.com, dwmw2@infradead.org,
       tony.luck@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init 
	failure
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <3877989d0908122248s4212ef95w7606a4dca5c7a855@mail.gmail.com>
References: <20090812181722.GA32653@linux-os.sc.intel.com>
	<20090813132845R.fujita.tomonori@lab.ntt.co.jp>
	<3877989d0908122248s4212ef95w7606a4dca5c7a855@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090813155118P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 13 Aug 2009 15:52:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 13:48:45 +0800
Luming Yu <luming.yu@gmail.com> wrote:

> >>
> >> This check can not be removed. Otherwise, swiotlb_dma_ops will always override
> >> previous dma_ops value.
> >
> > Yeah.
> 
> I think pci_swiotlb_init needs to be cleaned up for both x86_{32,64} and ia64.
> it should be used to init default dma_ops, and the call site of it should be
> as early as platform_dma_init in mem_init. SInce swiotlb_dma_ops is pitched as
> default dma_ops for x86, ia64, we really don't need to let pci_swiotlb_init
> know iommu_deteced, dmar_disabled or iommu_passthrough...and anything
> like that..
> Please note the major wrong assumption of the current implementation is
> "iommu_deteced == iommu working" that I was trying to fix.

How about this?

You can work around that assumption, I guess.


diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index f6b1ff0..48caafa 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -20,6 +20,8 @@
 
 #include <asm/page.h>
 
+extern int swiotlb_late_init_with_default_size (size_t size);
+
 dma_addr_t bad_dma_address __read_mostly;
 EXPORT_SYMBOL(bad_dma_address);
 
@@ -44,11 +46,25 @@ struct device fallback_dev = {
 };
 
 extern struct dma_map_ops intel_dma_ops;
+extern struct dma_map_ops swiotlb_dma_ops;
 
 static int __init pci_iommu_init(void)
 {
-	if (iommu_detected)
-		intel_iommu_init();
+	int ret;
+
+	if (iommu_detected) {
+		ret = intel_iommu_init();
+		if (ret) {
+#ifdef CONFIG_IA64_GENERIC
+			dma_ops = &swiotlb_dma_ops;
+			if (swiotlb_late_init_with_default_size(64 * (1<<20)))
+				panic("failed to initialize swiotlb");
+			machvec_init("dig");
+#else
+			panic("Unable to find Intel IOMMU");
+#endif
+		}
+	}
 
 	return 0;
 }
