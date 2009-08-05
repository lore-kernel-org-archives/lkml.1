Return-Path: <linux-kernel-owner+w=401wt.eu-S933731AbZHEH7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731AbZHEH7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 03:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933694AbZHEH7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 03:59:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52524 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933660AbZHEH7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 03:59:13 -0400
Subject: Re: [PATCH 1/4] Bug Fix drivers/pci/intel-iommu.c: correct sglist
 size calculation
From: David Woodhouse <dwmw2@infradead.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, iommu@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090804220937.GA17945@linux-os.sc.intel.com>
References: <Pine.LNX.4.64.0908021044540.15557@ask.diku.dk>
	 <20090804220937.GA17945@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 08:59:10 +0100
Message-Id: <1249459150.9324.346.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 15:09 -0700, Fenghua Yu wrote:
> 
> -       for_each_sg(sglist, sg, nelems, i)
> -               size += aligned_nrpages(sg->offset, sg->length);
> +       for_each_sg(sglist, sg, nelems, i) {
> +               dma_addr_t addr = sg_phys(sg);
> +               size += aligned_nrpages(addr, sg->length);
> +       }

What's the point in this part? We mask off the high bits of the first
argument to aligned_nrpages() -- we're only interested in the offset
within the (mm) page. So sg->offset is fine; we don't need to use
sg_phys(), surely? And this is in code where we're desperately trying to
shave off as many cycles as we can...

This version of the patch should suffice, yes?

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index ebc9b8d..ed6109d 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1648,6 +1648,15 @@ static int domain_context_mapped(struct pci_dev *pdev)
 					     tmp->devfn);
 }
 
+/* Returns a number of VTD pages, but aligned to MM page size */
+static inline unsigned long aligned_nrpages(unsigned long host_addr,
+					    size_t size)
+{
+	host_addr &= ~PAGE_MASK;
+	return PAGE_ALIGN(host_addr + size) >> VTD_PAGE_SHIFT;
+}
+
+
 static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 			    struct scatterlist *sg, unsigned long phys_pfn,
 			    unsigned long nr_pages, int prot)
@@ -1675,7 +1684,7 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 		uint64_t tmp;
 
 		if (!sg_res) {
-			sg_res = (sg->offset + sg->length + VTD_PAGE_SIZE - 1) >> VTD_PAGE_SHIFT;
+			sg_res = aligned_nrpages(sg->offset, sg->length);
 			sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + sg->offset;
 			sg->dma_length = sg->length;
 			pteval = page_to_phys(sg_page(sg)) | prot;
@@ -2415,14 +2424,6 @@ error:
 	return ret;
 }
 
-/* Returns a number of VTD pages, but aligned to MM page size */
-static inline unsigned long aligned_nrpages(unsigned long host_addr,
-					    size_t size)
-{
-	host_addr &= ~PAGE_MASK;
-	return PAGE_ALIGN(host_addr + size) >> VTD_PAGE_SHIFT;
-}
-
 /* This takes a number of _MM_ pages, not VTD pages */
 static struct iova *intel_alloc_iova(struct device *dev,
 				     struct dmar_domain *domain,
@@ -2875,7 +2876,7 @@ static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist, int ne
 
 	start_vpfn = mm_to_dma_pfn(iova->pfn_lo);
 
-	ret = domain_sg_mapping(domain, start_vpfn, sglist, mm_to_dma_pfn(size), prot);
+	ret = domain_sg_mapping(domain, start_vpfn, sglist, size, prot);
 	if (unlikely(ret)) {
 		/*  clear the page */
 		dma_pte_clear_range(domain, start_vpfn,


-- 
dwmw2

