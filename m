Return-Path: <linux-kernel-owner+w=401wt.eu-S1765183AbXJRLz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765183AbXJRLz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762387AbXJRLyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:54:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36693
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758182AbXJRLyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:54:51 -0400
Date: Thu, 18 Oct 2007 04:55:05 -0700 (PDT)
Message-Id: <20071018.045505.106265100.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: torvalds@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071018082145.GK5063@kernel.dk>
References: <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org>
	<20071017.181907.63126798.davem@davemloft.net>
	<20071018082145.GK5063@kernel.dk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 18 Oct 2007 10:21:45 +0200

> I like it. Basically the only real change is using bit 2 as a
> termination point, so we avoid going beyond the end of the sgtable.
> Here's a starting point, it actually booted for me in the first go
> (boggle). Only x86 so far, archs will need to be converted. And lots
> more drivers I'm sure, I only fixed up the ones that botched my compile.
> 
> So just consider this a directional patch.

Here are some sparc64 bits:

diff --git a/arch/sparc64/kernel/iommu.c b/arch/sparc64/kernel/iommu.c
index 29af777..73852a2 100644
--- a/arch/sparc64/kernel/iommu.c
+++ b/arch/sparc64/kernel/iommu.c
@@ -473,7 +473,7 @@ static void dma_4u_unmap_single(struct device *dev, dma_addr_t bus_addr,
 }
 
 #define SG_ENT_PHYS_ADDRESS(SG)	\
-	(__pa(page_address((SG)->page)) + (SG)->offset)
+	(__pa(page_address(sg_page(SG))) + (SG)->offset)
 
 static void fill_sg(iopte_t *iopte, struct scatterlist *sg,
 		    int nused, int nelems,
@@ -566,7 +566,7 @@ static int dma_4u_map_sg(struct device *dev, struct scatterlist *sglist,
 	if (nelems == 1) {
 		sglist->dma_address =
 			dma_4u_map_single(dev,
-					  (page_address(sglist->page) +
+					  (page_address(sg_page(sglist)) +
 					   sglist->offset),
 					  sglist->length, direction);
 		if (unlikely(sglist->dma_address == DMA_ERROR_CODE))
diff --git a/arch/sparc64/kernel/iommu_common.c b/arch/sparc64/kernel/iommu_common.c
index d7ca900..ec863e0 100644
--- a/arch/sparc64/kernel/iommu_common.c
+++ b/arch/sparc64/kernel/iommu_common.c
@@ -73,7 +73,7 @@ static int verify_one_map(struct scatterlist *dma_sg, struct scatterlist **__sg,
 
 	daddr = dma_sg->dma_address;
 	sglen = sg->length;
-	sgaddr = (unsigned long) (page_address(sg->page) + sg->offset);
+	sgaddr = (unsigned long) (page_address(sg_page(sg)) + sg->offset);
 	while (dlen > 0) {
 		unsigned long paddr;
 
@@ -123,7 +123,7 @@ static int verify_one_map(struct scatterlist *dma_sg, struct scatterlist **__sg,
 		sg = sg_next(sg);
 		if (--nents <= 0)
 			break;
-		sgaddr = (unsigned long) (page_address(sg->page) + sg->offset);
+		sgaddr = (unsigned long) (page_address(sg_page(sg)) + sg->offset);
 		sglen = sg->length;
 	}
 	if (dlen < 0) {
@@ -191,7 +191,7 @@ void verify_sglist(struct scatterlist *sglist, int nents, iopte_t *iopte, int np
 			printk("sg(%d): page_addr(%p) off(%x) length(%x) "
 			       "dma_address[%016x] dma_length[%016x]\n",
 			       i,
-			       page_address(sg->page), sg->offset,
+			       page_address(sg_page(sg)), sg->offset,
 			       sg->length,
 			       sg->dma_address, sg->dma_length);
 		}
@@ -207,15 +207,15 @@ unsigned long prepare_sg(struct scatterlist *sg, int nents)
 	unsigned long prev;
 	u32 dent_addr, dent_len;
 
-	prev  = (unsigned long) (page_address(sg->page) + sg->offset);
+	prev  = (unsigned long) (page_address(sg_page(sg)) + sg->offset);
 	prev += (unsigned long) (dent_len = sg->length);
-	dent_addr = (u32) ((unsigned long)(page_address(sg->page) + sg->offset)
+	dent_addr = (u32) ((unsigned long)(page_address(sg_page(sg)) + sg->offset)
 			   & (IO_PAGE_SIZE - 1UL));
 	while (--nents) {
 		unsigned long addr;
 
 		sg = sg_next(sg);
-		addr = (unsigned long) (page_address(sg->page) + sg->offset);
+		addr = (unsigned long) (page_address(sg_page(sg)) + sg->offset);
 		if (! VCONTIG(prev, addr)) {
 			dma_sg->dma_address = dent_addr;
 			dma_sg->dma_length = dent_len;
diff --git a/arch/sparc64/kernel/pci_sun4v.c b/arch/sparc64/kernel/pci_sun4v.c
index fe46ace..5324a34 100644
--- a/arch/sparc64/kernel/pci_sun4v.c
+++ b/arch/sparc64/kernel/pci_sun4v.c
@@ -366,7 +366,7 @@ static void dma_4v_unmap_single(struct device *dev, dma_addr_t bus_addr,
 }
 
 #define SG_ENT_PHYS_ADDRESS(SG)	\
-	(__pa(page_address((SG)->page)) + (SG)->offset)
+	(__pa(page_address(sg_page(SG))) + (SG)->offset)
 
 static long fill_sg(long entry, struct device *dev,
 		    struct scatterlist *sg,
@@ -478,7 +478,7 @@ static int dma_4v_map_sg(struct device *dev, struct scatterlist *sglist,
 	if (nelems == 1) {
 		sglist->dma_address =
 			dma_4v_map_single(dev,
-					  (page_address(sglist->page) +
+					  (page_address(sg_page(sglist)) +
 					   sglist->offset),
 					  sglist->length, direction);
 		if (unlikely(sglist->dma_address == DMA_ERROR_CODE))
diff --git a/include/asm-sparc64/scatterlist.h b/include/asm-sparc64/scatterlist.h
index 703c5bb..6df23f0 100644
--- a/include/asm-sparc64/scatterlist.h
+++ b/include/asm-sparc64/scatterlist.h
@@ -6,7 +6,10 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page	*page;
+#ifdef CONFIG_DEBUG_SG
+	unsigned long	sg_magic;
+#endif
+	unsigned long	page_link;
 	unsigned int	offset;
 
 	unsigned int	length;
