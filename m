Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYICS4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYICS4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYICS4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:56:46 -0400
Received: from sh.osrg.net ([192.16.179.4]:39219 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbYICS4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:56:45 -0400
Date: Thu, 4 Sep 2008 03:54:26 +0900
To: linux-kernel@vger.kernel.org
Cc: joerg.roedel@amd.com, mingo@redhat.com, tony.luck@intel.com,
       kamezawa.hiroyu@jp.fujitsu.com, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 1/3] x86: remove the NULL device hack in dma-mapping.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1220465065-10533-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220454224-25985-1-git-send-email-joerg.roedel@amd.com>
	<1220465065-10533-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1220465065-10533-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080904035432F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  4 Sep 2008 03:04:23 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> dma_alloc_coherent in dma-mapping.h has a hack to use
> x86_dma_fallback_dev if a pointer to a device is NULL. Some of IOMMUs
> don't need such hack. The hack also makes it difficult for IOMMUs to
> make a proper decision because the hack hides the information.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/kernel/pci-swiotlb_64.c |   15 ++++++++++++++-
>  include/asm-x86/dma-mapping.h    |    9 +--------
>  2 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
> index c4ce033..f3d8d0e 100644
> --- a/arch/x86/kernel/pci-swiotlb_64.c
> +++ b/arch/x86/kernel/pci-swiotlb_64.c
> @@ -11,6 +11,8 @@
>  
>  int swiotlb __read_mostly;
>  
> +extern struct device x86_dma_fallback_dev;
> +
>  static dma_addr_t
>  swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
>  			int direction)
> @@ -18,9 +20,20 @@ swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
>  	return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
>  }
>  
> +static void *x86_swiotlb_alloc_coherent(struct device *dev, size_t size,
> +					dma_addr_t *dma_handle, gfp_t gfp)
> +{
> +	if (!dev) {
> +		dev = &x86_dma_fallback_dev;
> +		gfp |= GFP_DMA;
> +	}
> +
> +	return swiotlb_alloc_coherent(dev, size, dma_handle, gfp);
> +}
> +
>  struct dma_mapping_ops swiotlb_dma_ops = {
>  	.mapping_error = swiotlb_dma_mapping_error,
> -	.alloc_coherent = swiotlb_alloc_coherent,
> +	.alloc_coherent = x86_swiotlb_alloc_coherent,
>  	.free_coherent = swiotlb_free_coherent,
>  	.map_single = swiotlb_map_single_phys,
>  	.unmap_single = swiotlb_unmap_single,
> diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
> index bc6c8df..3463702 100644
> --- a/include/asm-x86/dma-mapping.h
> +++ b/include/asm-x86/dma-mapping.h
> @@ -14,7 +14,6 @@
>  
>  extern dma_addr_t bad_dma_address;
>  extern int iommu_merge;
> -extern struct device x86_dma_fallback_dev;

Oops, removing extern struct device x86_dma_fallback_dev breaks the
GART IOMMU. Here's an updated patch.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86: remove the NULL device hack in dma-mapping.h

dma_alloc_coherent in dma-mapping.h has a hack to use
x86_dma_fallback_dev if a pointer to a device is NULL. Some of IOMMUs
don't need such hack. The hack also makes it difficult for IOMMUs to
make a proper decision because the hack hides the information.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-swiotlb_64.c |   13 ++++++++++++-
 include/asm-x86/dma-mapping.h    |    8 +-------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index c4ce033..d2463de 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -18,9 +18,20 @@ swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
 	return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
 }
 
+static void *x86_swiotlb_alloc_coherent(struct device *dev, size_t size,
+					dma_addr_t *dma_handle, gfp_t gfp)
+{
+	if (!dev) {
+		dev = &x86_dma_fallback_dev;
+		gfp |= GFP_DMA;
+	}
+
+	return swiotlb_alloc_coherent(dev, size, dma_handle, gfp);
+}
+
 struct dma_mapping_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
-	.alloc_coherent = swiotlb_alloc_coherent,
+	.alloc_coherent = x86_swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
 	.map_single = swiotlb_map_single_phys,
 	.unmap_single = swiotlb_unmap_single,
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index bc6c8df..e59607d 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -251,14 +251,8 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
 		return memory;
 
-	if (!dev) {
-		dev = &x86_dma_fallback_dev;
-		gfp |= GFP_DMA;
-	}
-
 	if (ops->alloc_coherent)
-		return ops->alloc_coherent(dev, size,
-				dma_handle, gfp);
+		return ops->alloc_coherent(dev, size, dma_handle, gfp);
 	return NULL;
 }
 
-- 
1.5.5.GIT


