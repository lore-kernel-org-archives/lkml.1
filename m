Return-Path: <linux-kernel-owner+w=401wt.eu-S1423053AbXDXT1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423053AbXDXT1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423054AbXDXT1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:27:20 -0400
Received: from ns.suse.de ([195.135.220.2]:34643 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423053AbXDXT1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:27:19 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ashok Raj <ashok.raj@intel.com>
Subject: Re: [Intel IOMMU][patch 3/8] Generic hardware support for Intel IOMMU.
Date: Tue, 24 Apr 2007 21:27:08 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
References: <20070424060259.426374000@intel.com> <20070424061037.653635000@intel.com>
In-Reply-To: <20070424061037.653635000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704242127.09221.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007 08:03:02 Ashok Raj wrote:
>
> +#ifdef CONFIG_DMAR
> +#ifdef CONFIG_SMP
> +static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)


Why does it need an own interrupt type?

> +
> +config IOVA_GUARD_PAGE
> +	bool "Enables gaurd page when allocating IO Virtual Address for IOMMU"
> +	depends on DMAR
> +
> +config IOVA_NEXT_CONTIG
> +	bool "Keeps IOVA allocations consequent between allocations"
> +	depends on DMAR && EXPERIMENTAL

Needs reference to Intel and better description

The file should have a high level description what it is good for etc.

Need high level overview over what locks protects what and if there
is a locking order.

It doesn't seem to enable sg merging? Since you have enough space 
that should work.

> +static char *fault_reason_strings[] =
> +{
> +	"Software",
> +	"Present bit in root entry is clear",
> +	"Present bit in context entry is clear",
> +	"Invalid context entry",
> +	"Access beyond MGAW",
> +	"PTE Write access is not set",
> +	"PTE Read access is not set",
> +	"Next page table ptr is invalid",
> +	"Root table address invalid",
> +	"Context table ptr is invalid",
> +	"non-zero reserved fields in RTP",
> +	"non-zero reserved fields in CTP",
> +	"non-zero reserved fields in PTE",
> +	"Unknown"
> +};
> +
> +#define MAX_FAULT_REASON_IDX 	(12)


You got 14 of them. better use ARRAY_SIZE

> +#define IOMMU_NAME_LEN		(7)
> +
> +struct iommu {

call it intel_iommu or somesuch even when it's private.

> +static int __init intel_iommu_setup(char *str)
> +{
> +	if (!str)
> +		return -EINVAL;
> +	while (*str) {
> +		if (!strncmp(str, "off", 3)) {
> +			dmar_disabled = 1;
> +			printk(KERN_INFO"Intel-IOMMU: disabled\n");
> +		}
> +		str += strcspn(str, ",");
> +		while (*str == ',')
> +			str++;
> +	}
> +	return 0;
> +}
> +__setup("intel_iommu=", intel_iommu_setup);

Why can't you just use the normal iommu=off for this? 

> +
> +#define MIN_PGTABLE_PAGES	(10)
> +static mempool_t *pgtable_mempool;
> +#define MIN_DOMAIN_REQ		(20)
> +static mempool_t *domain_mempool;
> +#define MIN_DEVINFO_REQ		(20)
> +static mempool_t *devinfo_mempool;

Lots of mempools. How much memory does this pin?

> +
> +#define alloc_pgtable_page() mempool_alloc(pgtable_mempool, GFP_ATOMIC)
> +#define free_pgtable_page(vaddr) mempool_free(vaddr, pgtable_mempool)
> +#define alloc_domain_mem() mempool_alloc(domain_mempool, GFP_ATOMIC)
> +#define free_domain_mem(vaddr) mempool_free(vaddr, domain_mempool)
> +#define alloc_devinfo_mem() mempool_alloc(devinfo_mempool, GFP_ATOMIC)
> +#define free_devinfo_mem(vaddr) mempool_free(vaddr, devinfo_mempool)

Do we need the macros? Better expand them in the caller.

> +static void __iommu_flush_cache(struct iommu *iommu, void *addr, int size)
> +{
> +	if (!ecap_coherent(iommu->ecap))
> +		clflush_cache_range(addr, size);
> +}
> +
> +#define iommu_flush_cache_entry(iommu, addr) \
> +	__iommu_flush_cache(iommu, addr, 8)
> +#define iommu_flush_cache_page(iommu, addr) \
> +	__iommu_flush_cache(iommu, addr, PAGE_SIZE_4K)

Similar.

And the 8 should be probably something more descriptive (sizeof?)

> +/* context entry handling */
> +static struct context_entry * device_to_context_entry(struct iommu *iommu,
> +		u8 bus, u8 devfn)
> +{
> +	struct root_entry *root;
> +	struct context_entry *context;
> +	unsigned long phy_addr;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&iommu->lock, flags);
> +	root = &iommu->root_entry[bus];
> +	if (!root_present(*root)) {
> +		phy_addr = (unsigned long)alloc_pgtable_page();

A GFP_ATOMIC mempool is rather useless. mempool only works if it can block
for someone else freeing memory and if it can't do that it's not failsafe.
I'm afraid you need to revise the allocation strategy -- best would be
to somehow move the memory allocations outside the spinlock paths
and preallocate if possible.

Same problem in other code.

> +		if (!dma_pte_present(*pte)) {
> +			tmp = alloc_pgtable_page();

Please don't name variable tmp. I know some other code does it, but it's
just bad style imho.


> +	/* Make sure hardware complete it */
> +	start_time = jiffies;
> +	while (1) {
> +		sts = dmar_readl(iommu->reg, DMAR_GSTS_REG);
> +		if (sts & DMA_GSTS_RTPS)
> +			break;
> +		if (time_after(jiffies, start_time + DMAR_OPERATION_TIMEOUT))
> +			panic("DMAR hardware is malfunctional, please disable IOMMU\n");
> +		cpu_relax();
> +	}

Could MWAIT/MONITOR be used for this?


> +	spin_unlock_irqrestore(&iommu->register_lock, flag);
> +}
> +
> +static void iommu_flush_write_buffer(struct iommu *iommu)
> +{
> +	u32 val;
> +	unsigned long flag;
> +	unsigned long start_time;
> +
> +	if (!cap_rwbf(iommu->cap))
> +		return;
> +	val = iommu->gcmd | DMA_GCMD_WBF;
> +
> +	spin_lock_irqsave(&iommu->register_lock, flag);
> +	dmar_writel(iommu->reg, DMAR_GCMD_REG, val);
> +
> +	/* Make sure hardware complete it */
> +	start_time = jiffies;
> +	while (1) {
> +		val = dmar_readl(iommu->reg, DMAR_GSTS_REG);
> +		if (!(val & DMA_GSTS_WBFS))
> +			break;
> +		if (time_after(jiffies, start_time + DMAR_OPERATION_TIMEOUT))
> +			panic("DMAR hardware is malfunctional, please disable IOMMU\n");
> +		cpu_relax();
> +	}
> +	spin_unlock_irqrestore(&iommu->register_lock, flag);

Surely some code sharing with the previous function is possible? This code seems
to be cut'n'pasted a lot

> +/* iommu interrupt handling. Most staffs are MSI-like. */

staffs? 

> +static struct iova *alloc_iova_from_pool(void)
> +{
> +	struct iova *iova;
> +	iova = mempool_alloc(iova_mempool, GFP_ATOMIC);

Similar comment as earlier. Non blocking mempool doesn't make sense

-Andi
