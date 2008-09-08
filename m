Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYIHSHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYIHSHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYIHSH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:07:29 -0400
Received: from sh.osrg.net ([192.16.179.4]:51912 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbYIHSH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:07:28 -0400
Date: Tue, 9 Sep 2008 03:06:44 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] fix alloc_coherent allocation issues
	(tip/x86/iommu)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080908173525.GA23419@elte.hu>
References: <20080905181155W.fujita.tomonori@lab.ntt.co.jp>
	<20080905104518.GA17776@elte.hu>
	<20080908173525.GA23419@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080909030508F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008 19:35:25 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> btw., the build became very noisy - see the messages below.
> 
> 	Ingo
> 
> ---------->
> init/initramfs.c:517: warning: 'clean_rootfs' defined but not used
> In file included from include/linux/dma-mapping.h:53,
>                  from include/linux/dmaengine.h:30,
>                  from include/linux/skbuff.h:30,
>                  from include/linux/netlink.h:156,
>                  from include/linux/genetlink.h:5,
>                  from include/net/genetlink.h:5,
>                  from include/linux/taskstats_kern.h:13,
>                  from init/main.c:48:
> include/asm/dma-mapping.h: In function 'dma_alloc_coherent_gfp_flags':
> include/asm/dma-mapping.h:258: warning: unused variable 'dma_mask'
> In file included from include/linux/dma-mapping.h:53,
>                  from arch/x86/kernel/pci-dma.c:2:

Very sorry, I should have compile this on X86_32...

Can you replace the fourth patch with this?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86: dma_alloc_coherent sets gfp flags properly

Non real IOMMU implemenations (which doesn't do virtual mappings,
e.g. swiotlb, pci-nommu, etc) need to use proper gfp flags and
dma_mask to allocate pages in their own dma_alloc_coherent()
(allocated page need to be suitable for device's coherent_dma_mask).

This patch makes dma_alloc_coherent do this job so that IOMMUs don't
need to take care of it any more.

Real IOMMU implemenataions can simply ignore the gfp flags.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-nommu.c   |   19 ++-----------------
 include/asm-x86/dma-mapping.h |   32 ++++++++++++++++++++++++++++----
 2 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index ada1c87..8e398b5 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -80,26 +80,11 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
 	int node;
 	struct page *page;
 
-	gfp |= __GFP_ZERO;
-
-	dma_mask = hwdev->coherent_dma_mask;
-	if (!dma_mask)
-		dma_mask = *(hwdev->dma_mask);
+	dma_mask = dma_alloc_coherent_mask(hwdev, gfp);
 
-	if (dma_mask < DMA_24BIT_MASK)
-		return NULL;
+	gfp |= __GFP_ZERO;
 
 	node = dev_to_node(hwdev);
-
-#ifdef CONFIG_X86_64
-	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
-		gfp |= GFP_DMA32;
-#endif
-
-	/* No alloc-free penalty for ISA devices */
-	if (dma_mask == DMA_24BIT_MASK)
-		gfp |= GFP_DMA;
-
 again:
 	page = alloc_pages_node(node, gfp, get_order(size));
 	if (!page)
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 9d6dcf4..8bb3108 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -241,6 +241,29 @@ static inline int dma_get_cache_alignment(void)
 	return boot_cpu_data.x86_clflush_size;
 }
 
+static inline unsigned long dma_alloc_coherent_mask(struct device *dev,
+						    gfp_t gfp)
+{
+	unsigned long dma_mask = 0;
+
+	dma_mask = dev->coherent_dma_mask;
+	if (!dma_mask)
+		dma_mask = (gfp & GFP_DMA) ? DMA_24BIT_MASK : DMA_32BIT_MASK;
+
+	return dma_mask;
+}
+
+static inline gfp_t dma_alloc_coherent_gfp_flags(struct device *dev, gfp_t gfp)
+{
+#ifdef CONFIG_X86_64
+	unsigned long dma_mask = dma_alloc_coherent_mask(dev, gfp);
+
+	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
+		gfp |= GFP_DMA32;
+#endif
+       return gfp;
+}
+
 static inline void *
 dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp)
@@ -261,10 +284,11 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	if (!dev->dma_mask)
 		return NULL;
 
-	if (ops->alloc_coherent)
-		return ops->alloc_coherent(dev, size,
-				dma_handle, gfp);
-	return NULL;
+	if (!ops->alloc_coherent)
+		return NULL;
+
+	return ops->alloc_coherent(dev, size, dma_handle,
+				   dma_alloc_coherent_gfp_flags(dev, gfp));
 }
 
 static inline void dma_free_coherent(struct device *dev, size_t size,
-- 
1.5.5.GIT


