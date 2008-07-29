Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbYG2FYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbYG2FYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYG2FYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:24:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56550
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751875AbYG2FYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:24:40 -0400
Date: Mon, 28 Jul 2008 22:24:39 -0700 (PDT)
Message-Id: <20080728.222439.176200666.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, joerg.roedel@amd.com,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080729135652.f89042c1.sfr@canb.auug.org.au>
References: <20080729110749.728c54e6.sfr@canb.auug.org.au>
	<20080729104722H.fujita.tomonori@lab.ntt.co.jp>
	<20080729135652.f89042c1.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 29 Jul 2008 13:56:52 +1000

> Um, did you see the linux-next build report I posted (possibly not):
> 
> arch/powerpc/kernel/iommu.c:56: error: static declaration of 'iommu_num_pages' follows non-static declaration
> include/linux/iommu-helper.h:11: error: previous declaration of 'iommu_num_pages' was here
> 
> This is now a build of 2.6.27-rc1 for powerpc64 ppc64_defconfig ...

It breaks sparc64 the same exact way. :-/

sparc64: Fix build after addition of iommu_num_pages() helper.

It would have been much more pleasant if that new interface:

1) Took an "io_page_size" argument so powerpc and sparc64
   could make use of it.

2) Was build tested on something other than x86.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc64/kernel/iommu.c b/arch/sparc64/kernel/iommu.c
index 2a37a6c..600f712 100644
--- a/arch/sparc64/kernel/iommu.c
+++ b/arch/sparc64/kernel/iommu.c
@@ -575,7 +575,7 @@ static int dma_4u_map_sg(struct device *dev, struct scatterlist *sglist,
 		}
 		/* Allocate iommu entries for that segment */
 		paddr = (unsigned long) SG_ENT_PHYS_ADDRESS(s);
-		npages = iommu_num_pages(paddr, slen);
+		npages = sparc64_iommu_num_pages(paddr, slen);
 		entry = iommu_range_alloc(dev, iommu, npages, &handle);
 
 		/* Handle failure */
@@ -647,7 +647,7 @@ iommu_map_failed:
 			iopte_t *base;
 
 			vaddr = s->dma_address & IO_PAGE_MASK;
-			npages = iommu_num_pages(s->dma_address, s->dma_length);
+			npages = sparc64_iommu_num_pages(s->dma_address, s->dma_length);
 			iommu_range_free(iommu, vaddr, npages);
 
 			entry = (vaddr - iommu->page_table_map_base)
@@ -715,7 +715,7 @@ static void dma_4u_unmap_sg(struct device *dev, struct scatterlist *sglist,
 
 		if (!len)
 			break;
-		npages = iommu_num_pages(dma_handle, len);
+		npages = sparc64_iommu_num_pages(dma_handle, len);
 		iommu_range_free(iommu, dma_handle, npages);
 
 		entry = ((dma_handle - iommu->page_table_map_base)
diff --git a/arch/sparc64/kernel/iommu_common.h b/arch/sparc64/kernel/iommu_common.h
index 53b19c8..e64152b 100644
--- a/arch/sparc64/kernel/iommu_common.h
+++ b/arch/sparc64/kernel/iommu_common.h
@@ -35,8 +35,8 @@
 
 #define SG_ENT_PHYS_ADDRESS(SG)	(__pa(sg_virt((SG))))
 
-static inline unsigned long iommu_num_pages(unsigned long vaddr,
-					    unsigned long slen)
+static inline unsigned long sparc64_iommu_num_pages(unsigned long vaddr,
+						    unsigned long slen)
 {
 	unsigned long npages;
 
@@ -53,7 +53,7 @@ static inline int is_span_boundary(unsigned long entry,
 				   struct scatterlist *sg)
 {
 	unsigned long paddr = SG_ENT_PHYS_ADDRESS(outs);
-	int nr = iommu_num_pages(paddr, outs->dma_length + sg->length);
+	int nr = sparc64_iommu_num_pages(paddr, outs->dma_length + sg->length);
 
 	return iommu_is_span_boundary(entry, nr, shift, boundary_size);
 }
diff --git a/arch/sparc64/kernel/pci_sun4v.c b/arch/sparc64/kernel/pci_sun4v.c
index a104c80..08dcdbd 100644
--- a/arch/sparc64/kernel/pci_sun4v.c
+++ b/arch/sparc64/kernel/pci_sun4v.c
@@ -382,7 +382,7 @@ static int dma_4v_map_sg(struct device *dev, struct scatterlist *sglist,
 		}
 		/* Allocate iommu entries for that segment */
 		paddr = (unsigned long) SG_ENT_PHYS_ADDRESS(s);
-		npages = iommu_num_pages(paddr, slen);
+		npages = sparc64_iommu_num_pages(paddr, slen);
 		entry = iommu_range_alloc(dev, iommu, npages, &handle);
 
 		/* Handle failure */
@@ -459,7 +459,7 @@ iommu_map_failed:
 			unsigned long vaddr, npages;
 
 			vaddr = s->dma_address & IO_PAGE_MASK;
-			npages = iommu_num_pages(s->dma_address, s->dma_length);
+			npages = sparc64_iommu_num_pages(s->dma_address, s->dma_length);
 			iommu_range_free(iommu, vaddr, npages);
 			/* XXX demap? XXX */
 			s->dma_address = DMA_ERROR_CODE;
@@ -498,7 +498,7 @@ static void dma_4v_unmap_sg(struct device *dev, struct scatterlist *sglist,
 
 		if (!len)
 			break;
-		npages = iommu_num_pages(dma_handle, len);
+		npages = sparc64_iommu_num_pages(dma_handle, len);
 		iommu_range_free(iommu, dma_handle, npages);
 
 		entry = ((dma_handle - iommu->page_table_map_base) >> IO_PAGE_SHIFT);
