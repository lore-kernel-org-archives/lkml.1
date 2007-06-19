Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbXFSXcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbXFSXcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbXFSXcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:32:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58476 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752463AbXFSXcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:32:24 -0400
Date: Tue, 19 Jun 2007 16:32:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, davem@davemloft.net
Subject: Re: [Intel IOMMU 05/10] Intel IOMMU driver
In-Reply-To: <20070619213808.716432000@askeshav-devel.jf.intel.com>
Message-ID: <Pine.LNX.4.64.0706191627060.15951@schroedinger.engr.sgi.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
 <20070619213808.716432000@askeshav-devel.jf.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Keshavamurthy, Anil S wrote:

> +static inline void *alloc_pgtable_page(void)
> +{
> +	return (void *)get_zeroed_page(GFP_ATOMIC);
> +}

Need to pass gfp_t parameter. Repeates a couple of times.

> +	addr &= (((u64)1) << addr_width) - 1;
> +	parent = domain->pgd;
> +
> +	spin_lock_irqsave(&domain->mapping_lock, flags);
> +	while (level > 0) {
> +		void *tmp_page;
> +
> +		offset = address_level_offset(addr, level);
> +		pte = &parent[offset];
> +		if (level == 1)
> +			break;
> +
> +		if (!dma_pte_present(*pte)) {
> +			tmp_page = alloc_pgtable_page();

Is it not possible here to drop the lock and do the alloc with GFP_KERNEL 
and deal with the resulting race? That is done in other parts of the 
kernel.

> +/* iommu handling */
> +static int iommu_alloc_root_entry(struct intel_iommu *iommu)
> +{
> +	struct root_entry *root;
> +	unsigned long flags;
> +
> +	root = (struct root_entry *)alloc_pgtable_page();

This may be able to become a GFP_KERNEL alloc since interrupts are enabled 
at this point?

> +int __init init_dmars(void)
> +{
> +	struct dmar_drhd_unit *drhd;
> +	struct dmar_rmrr_unit *rmrr;
> +	struct pci_dev *pdev;
> +	struct intel_iommu *iommu;
> +	int ret, unit = 0;
> +
> +	/*
> +	 * for each drhd
> +	 *    allocate root
> +	 *    initialize and program root entry to not present
> +	 * endfor
> +	 */
> +	for_each_drhd_unit(drhd) {
> +		if (drhd->ignored)
> +			continue;
> +		iommu = alloc_iommu(drhd);

GFP_KERNEL alloc possible?

> +{
> +	int ret = 0;
> +
> +	iommu_devinfo_cache = kmem_cache_create("iommu_devinfo",
> +					 sizeof(struct device_domain_info),
> +					 0,
> +					 SLAB_HWCACHE_ALIGN,
> +					 NULL,

Replace by

iommu_devinfo_cache = KMEM_CACHE(iommu_devinfo, SLAB_HWCACHE_ALIGN)

> +static inline int iommu_iova_cache_init(void)
> +{
> +	int ret = 0;
> +
> +	iommu_iova_cache = kmem_cache_create("iommu_iova",
> +					 sizeof(struct iova),
> +					 0,
> +					 SLAB_HWCACHE_ALIGN,
> +					 NULL,
> +					 NULL);

Ditto

