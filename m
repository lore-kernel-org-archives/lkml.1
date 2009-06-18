Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbZFRTQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbZFRTQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbZFRTQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:16:32 -0400
Received: from sous-sol.org ([216.99.217.87]:34611 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbZFRTQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:16:31 -0400
Date: Thu, 18 Jun 2009 12:15:36 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Christopher Wright'" <chrisw@redhat.com>,
       "'Allen Kay'" <allen.m.kay@intel.com>,
       "'iommu'" <iommu@lists.linux-foundation.org>,
       "'lkml'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] IOMMU Identity Mapping Support: Intel IOMMU
	implementation
Message-ID: <20090618191536.GD19771@sequoia.sous-sol.org>
References: <20090327212241.234500000@intel.com> <20090327212321.070229000@intel.com> <20090416001957.GA1527@linux-os.sc.intel.com> <1240135508.3589.75.camel@macbook.infradead.org> <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com> <20090520174259.GA10646@linux-os.sc.intel.com> <20090526225146.2faeeb05.akpm@linux-foundation.org> <A6AD88C3F2289247BE726C37303E1EB8AF9331CE@orsmsx505.amr.corp.intel.com> <20090618180527.GA24078@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618180527.GA24078@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Fenghua Yu (fenghua.yu@intel.com) wrote:
> IOMMU Identity Mapping Support: Intel IOMMU implementation

BTW, this doesn't apply at all to Linus' current tree, and does w/ minor
fuzz and offset to David's VT-d tree.

Some quick feedback.

> @@ -1189,48 +1207,74 @@ void free_dmar_iommu(struct intel_iommu *iommu)
>  	free_context_table(iommu);
>  }
>  
> -static struct dmar_domain * iommu_alloc_domain(struct intel_iommu *iommu)
> +/* Sequential domain id starting from 0. */
> +static unsigned long domain_id;

This doesn't look SMP safe.

> +static int iommu_prepare_static_identity_mapping(void)
> +{
> +	int i;
> +	struct pci_dev *pdev = NULL;
> +	int ret;
> +
> +	ret = si_domain_init();
> +	if (ret)
> +		return -EFAULT;
> +
> +	printk(KERN_INFO "IOMMU: Setting identity map:\n");
> +	for_each_pci_dev(pdev) {
> +		/* Devices not in the identity list won't do identity map. */
> +		if (!identity_list(pdev))
> +			continue;
> +
> +		for (i = 0; i < e820.nr_map; i++) {
> +			struct e820entry *ei = &e820.map[i];
> +
> +			if (ei->type == E820_RAM) {
> +				ret = iommu_prepare_identity_map(pdev,

What about RMRR?

And in this mode,  you shouldn't need gfx workaround.

> +					ei->addr, ei->addr + ei->size);
> +				if (ret)  {
> +					printk(KERN_INFO "1:1 mapping to one domain failed.\n");
> +					return -EFAULT;
> +				}
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +int __init init_dmars(void)
>  {
>  	struct dmar_drhd_unit *drhd;
>  	struct dmar_rmrr_unit *rmrr;
> @@ -2076,6 +2206,7 @@ static int __init init_dmars(void)
>  		}
>  	}
>  
> +
>  	/*
>  	 * If pass through is set and enabled, context entries of all pci
>  	 * devices are intialized by pass through translation type.
> @@ -2093,6 +2224,9 @@ static int __init init_dmars(void)
>  	 * identity mappings for rmrr, gfx, and isa.
>  	 */
>  	if (!iommu_pass_through) {
> +		if (iommu_identity_mapping)
> +			iommu_prepare_static_identity_mapping();
> +
>  		/*
>  		 * For each rmrr
>  		 *   for each dev attached to rmrr
> @@ -2107,6 +2241,7 @@ static int __init init_dmars(void)
>  		 *    endfor
>  		 * endfor
>  		 */

...Ah, RMRR looks OK.

> +		printk(KERN_INFO "IOMMU: Setting RMRR:\n");
>  		for_each_rmrr_units(rmrr) {
>  			for (i = 0; i < rmrr->devices_cnt; i++) {
>  				pdev = rmrr->devices[i];
> @@ -2259,6 +2394,9 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
>  	int ret;
>  	struct intel_iommu *iommu;
>  
> +	if (identity_list(pdev))
> +		return paddr;
> +

This is same as DUMMY_DEVICE_DOMAIN_INFO.  Please consolidate to a test
that just says "do i need translation".

And what about DMA mask smaller than physical memory.  The PT mode drops
back to swiotlb iirc.


>  	BUG_ON(dir == DMA_NONE);
>  	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
>  		return paddr;
> @@ -2401,6 +2539,9 @@ static void intel_unmap_page(struct device *dev, dma_addr_t dev_addr,
>  	struct iova *iova;
>  	struct intel_iommu *iommu;
>  
> +	if (identity_list(pdev))
> +		return;
> +

Same...duplicate test

>  	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
>  		return;
>  	domain = find_domain(pdev);
> @@ -2492,6 +2633,9 @@ static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
>  	struct scatterlist *sg;
>  	struct intel_iommu *iommu;
>  
> +	if (identity_list(pdev))
> +		return;
> +

Same duplicate test

>  	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
>  		return;
>  
> @@ -2552,6 +2696,16 @@ static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist, int ne
>  	unsigned long start_addr;
>  	struct intel_iommu *iommu;
>  
> +	if (identity_list(pdev)) {
> +		for_each_sg(sglist, sg, nelems, i) {
> +			addr = page_to_phys(sg_page(sg)) + sg->offset;
> +			sg->dma_address = addr;
> +			sg->dma_length = sg->length;
> +		}
> +

This is just the same as intel_nontranslate_map_sg()
Please consolidate this.

thanks,
-chris
