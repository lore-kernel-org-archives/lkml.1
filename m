Return-Path: <linux-kernel-owner+w=401wt.eu-S1161569AbXDYBVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161569AbXDYBVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 21:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161568AbXDYBVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 21:21:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:21637 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161572AbXDYBVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 21:21:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,448,1170662400"; 
   d="scan'208";a="236183980"
Subject: Re: [Intel IOMMU][patch 3/8] Generic hardware support for Intel
	IOMMU.
From: Shaohua Li <shaohua.li@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com
In-Reply-To: <200704242127.09221.ak@suse.de>
References: <20070424060259.426374000@intel.com>
	 <20070424061037.653635000@intel.com>  <200704242127.09221.ak@suse.de>
Content-Type: text/plain
Date: Wed, 25 Apr 2007 09:17:31 +0800
Message-Id: <1177463851.11073.6.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-24 at 21:27 +0200, Andi Kleen wrote:
> On Tuesday 24 April 2007 08:03:02 Ashok Raj wrote:
> >
> > +#ifdef CONFIG_DMAR
> > +#ifdef CONFIG_SMP
> > +static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
> 
> 
> Why does it need an own interrupt type?
> 
> > +
> > +config IOVA_GUARD_PAGE
> > +	bool "Enables gaurd page when allocating IO Virtual Address for IOMMU"
> > +	depends on DMAR
> > +
> > +config IOVA_NEXT_CONTIG
> > +	bool "Keeps IOVA allocations consequent between allocations"
> > +	depends on DMAR && EXPERIMENTAL
> 
> Needs reference to Intel and better description
> 
> The file should have a high level description what it is good for etc.
> 
> Need high level overview over what locks protects what and if there
> is a locking order.
> 
> It doesn't seem to enable sg merging? Since you have enough space 
> that should work.
We actually have a patch to do sg merge. In my test, it doesn't have any
performance gain.

> > +static char *fault_reason_strings[] =
> > +{
> > +	"Software",
> > +	"Present bit in root entry is clear",
> > +	"Present bit in context entry is clear",
> > +	"Invalid context entry",
> > +	"Access beyond MGAW",
> > +	"PTE Write access is not set",
> > +	"PTE Read access is not set",
> > +	"Next page table ptr is invalid",
> > +	"Root table address invalid",
> > +	"Context table ptr is invalid",
> > +	"non-zero reserved fields in RTP",
> > +	"non-zero reserved fields in CTP",
> > +	"non-zero reserved fields in PTE",
> > +	"Unknown"
> > +};
> > +
> > +#define MAX_FAULT_REASON_IDX 	(12)
> 
> 
> You got 14 of them. better use ARRAY_SIZE
> 
> > +#define IOMMU_NAME_LEN		(7)
> > +
> > +struct iommu {
> 
> call it intel_iommu or somesuch even when it's private.
> 
> > +static int __init intel_iommu_setup(char *str)
> > +{
> > +	if (!str)
> > +		return -EINVAL;
> > +	while (*str) {
> > +		if (!strncmp(str, "off", 3)) {
> > +			dmar_disabled = 1;
> > +			printk(KERN_INFO"Intel-IOMMU: disabled\n");
> > +		}
> > +		str += strcspn(str, ",");
> > +		while (*str == ',')
> > +			str++;
> > +	}
> > +	return 0;
> > +}
> > +__setup("intel_iommu=", intel_iommu_setup);
> 
> Why can't you just use the normal iommu=off for this? 
iommu=off disable all iommu, intel_iommu=off just disables intel_iommu.
Isn't possible people want to use other iommu like swiotlb?
> > +
> > +#define MIN_PGTABLE_PAGES	(10)
> > +static mempool_t *pgtable_mempool;
> > +#define MIN_DOMAIN_REQ		(20)
> > +static mempool_t *domain_mempool;
> > +#define MIN_DEVINFO_REQ		(20)
> > +static mempool_t *devinfo_mempool;
> 
> Lots of mempools. How much memory does this pin?
> 
> > +
> > +#define alloc_pgtable_page() mempool_alloc(pgtable_mempool, GFP_ATOMIC)
> > +#define free_pgtable_page(vaddr) mempool_free(vaddr, pgtable_mempool)
> > +#define alloc_domain_mem() mempool_alloc(domain_mempool, GFP_ATOMIC)
> > +#define free_domain_mem(vaddr) mempool_free(vaddr, domain_mempool)
> > +#define alloc_devinfo_mem() mempool_alloc(devinfo_mempool, GFP_ATOMIC)
> > +#define free_devinfo_mem(vaddr) mempool_free(vaddr, devinfo_mempool)
> 
> Do we need the macros? Better expand them in the caller.
> 
> > +static void __iommu_flush_cache(struct iommu *iommu, void *addr, int size)
> > +{
> > +	if (!ecap_coherent(iommu->ecap))
> > +		clflush_cache_range(addr, size);
> > +}
> > +
> > +#define iommu_flush_cache_entry(iommu, addr) \
> > +	__iommu_flush_cache(iommu, addr, 8)
> > +#define iommu_flush_cache_page(iommu, addr) \
> > +	__iommu_flush_cache(iommu, addr, PAGE_SIZE_4K)
> 
> Similar.
> 
> And the 8 should be probably something more descriptive (sizeof?)
> 
> > +/* context entry handling */
> > +static struct context_entry * device_to_context_entry(struct iommu *iommu,
> > +		u8 bus, u8 devfn)
> > +{
> > +	struct root_entry *root;
> > +	struct context_entry *context;
> > +	unsigned long phy_addr;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&iommu->lock, flags);
> > +	root = &iommu->root_entry[bus];
> > +	if (!root_present(*root)) {
> > +		phy_addr = (unsigned long)alloc_pgtable_page();
> 
> A GFP_ATOMIC mempool is rather useless. mempool only works if it can block
> for someone else freeing memory and if it can't do that it's not failsafe.
> I'm afraid you need to revise the allocation strategy -- best would be
> to somehow move the memory allocations outside the spinlock paths
> and preallocate if possible.
The problem is pci_map_single and friends usually called with interrupt
disabled or spin locked, so we must use GFP_ATOMIC.

> Same problem in other code.
> 
> > +		if (!dma_pte_present(*pte)) {
> > +			tmp = alloc_pgtable_page();
> 
> Please don't name variable tmp. I know some other code does it, but it's
> just bad style imho.
> 
> 
> > +	/* Make sure hardware complete it */
> > +	start_time = jiffies;
> > +	while (1) {
> > +		sts = dmar_readl(iommu->reg, DMAR_GSTS_REG);
> > +		if (sts & DMA_GSTS_RTPS)
> > +			break;
> > +		if (time_after(jiffies, start_time + DMAR_OPERATION_TIMEOUT))
> > +			panic("DMAR hardware is malfunctional, please disable IOMMU\n");
> > +		cpu_relax();
> > +	}
> 
> Could MWAIT/MONITOR be used for this?
MWAIT/MONITOR just works for cached memory. And this is memory mapped io.

Thanks,
Shaohua
