Return-Path: <linux-kernel-owner+w=401wt.eu-S1763536AbXLTXvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763536AbXLTXvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761580AbXLTXud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:50:33 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:50122 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761416AbXLTXuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:50:32 -0500
Subject: Re: iommu dma mapping alignment requirements
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
Reply-To: benh@au1.ibm.com
To: Steve Wise <swise@opengridcomputing.com>
Cc: benh@ozlabs.au.ibm.com, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org,
       OpenFabrics General <general@lists.openfabrics.org>,
       Benjamin Herrenschmidt <bherren@au1.ibm.com>,
       Wen Xiong <wenxiong@us.ibm.com>, Olof Johansson <olof@lixom.net>,
       Paul Mackerras <pmac@au1.ibm.com>
In-Reply-To: <476AE8C9.9080601@opengridcomputing.com>
References: <476AA2E2.5010007@opengridcomputing.com>
	 <1198181862.6779.3.camel@pasglop> <476AD84E.4000507@opengridcomputing.com>
	 <1198186017.6779.28.camel@pasglop> <476AE8C9.9080601@opengridcomputing.com>
Content-Type: text/plain
Organization: IBM Ozlabs
Date: Fri, 21 Dec 2007 10:49:45 +1100
Message-Id: <1198194585.6779.31.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Sounds good.  Thanks!
> 
> Note, that these smaller sub-host-page-sized mappings might pollute the 
> address space causing full aligned host-page-size maps to become 
> scarce...  Maybe there's a clever way to keep those in their own segment 
> of the address space?

We already have a large vs. small split in the iommu virtual space to
alleviate this (though it's not a hard constraint, we can still get
into the "other" side if the default one is full).

Try that patch and let me know:

Index: linux-work/arch/powerpc/kernel/iommu.c
===================================================================
--- linux-work.orig/arch/powerpc/kernel/iommu.c	2007-12-21 10:39:39.000000000 +1100
+++ linux-work/arch/powerpc/kernel/iommu.c	2007-12-21 10:46:18.000000000 +1100
@@ -278,6 +278,7 @@ int iommu_map_sg(struct iommu_table *tbl
 	unsigned long flags;
 	struct scatterlist *s, *outs, *segstart;
 	int outcount, incount, i;
+	unsigned int align;
 	unsigned long handle;
 
 	BUG_ON(direction == DMA_NONE);
@@ -309,7 +310,11 @@ int iommu_map_sg(struct iommu_table *tbl
 		/* Allocate iommu entries for that segment */
 		vaddr = (unsigned long) sg_virt(s);
 		npages = iommu_num_pages(vaddr, slen);
-		entry = iommu_range_alloc(tbl, npages, &handle, mask >> IOMMU_PAGE_SHIFT, 0);
+		align = 0;
+		if (IOMMU_PAGE_SHIFT < PAGE_SHIFT && (vaddr & ~PAGE_MASK) == 0)
+			align = PAGE_SHIFT - IOMMU_PAGE_SHIFT;
+		entry = iommu_range_alloc(tbl, npages, &handle,
+					  mask >> IOMMU_PAGE_SHIFT, align);
 
 		DBG("  - vaddr: %lx, size: %lx\n", vaddr, slen);
 
@@ -572,7 +577,7 @@ dma_addr_t iommu_map_single(struct iommu
 {
 	dma_addr_t dma_handle = DMA_ERROR_CODE;
 	unsigned long uaddr;
-	unsigned int npages;
+	unsigned int npages, align;
 
 	BUG_ON(direction == DMA_NONE);
 
@@ -580,8 +585,13 @@ dma_addr_t iommu_map_single(struct iommu
 	npages = iommu_num_pages(uaddr, size);
 
 	if (tbl) {
+		align = 0;
+		if (IOMMU_PAGE_SHIFT < PAGE_SHIFT &&
+		    ((unsigned long)vaddr & ~PAGE_MASK) == 0)
+			align = PAGE_SHIFT - IOMMU_PAGE_SHIFT;
+
 		dma_handle = iommu_alloc(tbl, vaddr, npages, direction,
-					 mask >> IOMMU_PAGE_SHIFT, 0);
+					 mask >> IOMMU_PAGE_SHIFT, align);
 		if (dma_handle == DMA_ERROR_CODE) {
 			if (printk_ratelimit())  {
 				printk(KERN_INFO "iommu_alloc failed, "


