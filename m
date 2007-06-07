Return-Path: <linux-kernel-owner+w=401wt.eu-S937598AbXFGX6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937598AbXFGX6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936298AbXFGX54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:57:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54420 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644AbXFGX5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:57:54 -0400
Date: Thu, 7 Jun 2007 16:57:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: anil.s.keshavamurthy@intel.com
Cc: linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 06/10] Intel IOMMU driver
Message-Id: <20070607165739.dc437e96.akpm@linux-foundation.org>
In-Reply-To: <20070606190042.823168000@askeshav-devel.jf.intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
	<20070606190042.823168000@askeshav-devel.jf.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 11:57:04 -0700
anil.s.keshavamurthy@intel.com wrote:

> 	Actual intel IOMMU driver. Hardware spec can be found at:
> http://www.intel.com/technology/virtualization
> 
> This driver sets X86_64 'dma_ops', so hook into standard DMA APIs. In this way,
> PCI driver will get virtual DMA address. This change is transparent to PCI
> drivers.
> 
> ...
>  
> +#ifdef CONFIG_DMAR
> +	detect_intel_iommu();
> +#endif
> +
>  #ifdef CONFIG_SWIOTLB
>  	pci_swiotlb_init();
>  #endif
> @@ -314,6 +319,10 @@
>  	calgary_iommu_init();
>  #endif
>  
> +#ifdef CONFIG_DMAR
> +	intel_iommu_init();
> +#endif

We'd prefer that the header file have suitable #ifndef CONFIG_DMAR stubs,
so the ifdefs here become unneeded.

> +/* context entry handling */
> +static struct context_entry * device_to_context_entry(struct intel_iommu *iommu,
> +		u8 bus, u8 devfn)
> +{
> +	struct root_entry *root;
> +	struct context_entry *context;
> +	unsigned long phy_addr;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&iommu->lock, flags);
> +	root = &iommu->root_entry[bus];
> +	if (!(context = get_context_addr_from_root(*root))) {
> +		context = (struct context_entry *)alloc_pgtable_page();
> +		if (!context) {
> +			spin_unlock_irqrestore(&iommu->lock, flags);
> +			return NULL;
> +		}
> +		__iommu_flush_cache(iommu, (void *)context, PAGE_SIZE_4K);
> +		phy_addr = virt_to_phys((void *)context);
> +		set_root_value(*root, phy_addr);
> +		set_root_present(*root);
> +		__iommu_flush_cache(iommu, root, sizeof(*root));
> +	}
> +	spin_unlock_irqrestore(&iommu->lock, flags);
> +	return &context[devfn];
> +}

checkpatch.pl has lots of fun with this patch.

> +/* page table handling */
> +#define LEVEL_STRIDE		(9)
> +#define LEVEL_MASK		(((u64)1 << LEVEL_STRIDE) - 1)
> +#define agaw_to_level(val) ((val) + 2)
> +#define agaw_to_width(val) (30 + val * LEVEL_STRIDE)
> +#define width_to_agaw(w)  ((w - 30)/LEVEL_STRIDE)
> +#define level_to_offset_bits(l) (12 + (l - 1) * LEVEL_STRIDE)
> +#define address_level_offset(addr, level) \
> +	((addr >> level_to_offset_bits(level)) & LEVEL_MASK)
> +#define level_mask(l) (((u64)(-1)) << level_to_offset_bits(l))
> +#define level_size(l) ((u64)1 << level_to_offset_bits(l))
> +#define align_to_level(addr, l) ((addr + level_size(l) - 1) & level_mask(l))

static inlines are better than macros - please consider.

If you're going to stick with macros here then you'll find that many of the
above macro's arguments are insufficiently parenthesised.

> +#define IOMMU_WAIT_OP(iommu, offset, op, cond, sts) \
> +{\
> +	unsigned long start_time = jiffies;\
> +	while (1) {\
> +		sts = op (iommu->reg, offset);\
> +		if (cond)\
> +			break;\
> +		if (time_after(jiffies, start_time + DMAR_OPERATION_TIMEOUT))\
> +			panic("DMAR hardware is malfunctional, please disable IOMMU\n");\
> +		cpu_relax();\
> +	}\
> +}

wow, harsh treatment.

"malfunctioning" might parse better here.

> +static int inline get_alignment(u64 base, unsigned int size)
> +{
> +	int t = 0;
> +	u64 end;
> +
> +	end = base + size - 1;
> +	while (base != end) {
> +		t++;
> +		base >>= 1;
> +		end >>= 1;
> +	}
> +	return t;
> +}

What's this (too large to inline) function doing?  I suspect we might have
helper functions which already do it...  If not, perhasp we should.


> +static int inline iommu_flush_iotlb_psi(struct intel_iommu *iommu, u16 did,
> +	u64 addr, unsigned int pages, int non_present_entry_flush)
> +{
> +	unsigned int align;
> +
> +	BUG_ON(addr & (~PAGE_MASK_4K));
> +	BUG_ON(pages == 0);
> +
> +	/* Fallback to domain selective flush if no PSI support */
> +	if (!cap_pgsel_inv(iommu->cap))
> +		return iommu_flush_iotlb_dsi(iommu, did,
> +			non_present_entry_flush);
> +
> +	/*
> +	 * PSI requires page size is 2 ^ x, and the base address is naturally
> +	 * aligned to the size
> +	 */
> +	align = get_alignment(addr >> PAGE_SHIFT_4K, pages);
> +	/* Fallback to domain selective flush if size is too big */
> +	if (align > cap_max_amask_val(iommu->cap))
> +		return iommu_flush_iotlb_dsi(iommu, did,
> +			non_present_entry_flush);
> +
> +	addr >>= PAGE_SHIFT_4K + align;
> +	addr <<= PAGE_SHIFT_4K + align;
> +
> +	return __iommu_flush_iotlb(iommu, did, addr, align,
> +		DMA_TLB_PSI_FLUSH, non_present_entry_flush);
> +}

too large for inlining.

> +static int iommu_enable_translation(struct intel_iommu *iommu)
> +{
> +	u32 sts;
> +	unsigned long flag;

we conventionally use "flags" for this.

> +	spin_lock_irqsave(&iommu->register_lock, flag);
> +	dmar_writel(iommu->reg, DMAR_GCMD_REG, iommu->gcmd|DMA_GCMD_TE);
> +
> +	/* Make sure hardware complete it */
> +	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG, dmar_readl, (sts & DMA_GSTS_TES), sts);
> +
> +	iommu->gcmd |= DMA_GCMD_TE;
> +	spin_unlock_irqrestore(&iommu->register_lock, flag);
> +	return 0;
> +}
>
> ...
>
>
> +#define aligned_size(host_addr, size) \
> +	PAGE_ALIGN_4K((host_addr & (~PAGE_MASK_4K)) + size)

insufficiently parenthesized.  Consider usign a static inline.

> +struct dma_mapping_ops intel_dma_ops = {
> +	.alloc_coherent = intel_alloc_coherent,
> +	.free_coherent = intel_free_coherent,
> +	.map_single = intel_map_single,
> +	.unmap_single = intel_unmap_single,
> +	.map_sg = intel_map_sg,
> +	.unmap_sg = intel_unmap_sg,
> +};

can it be static?

> +void *iommu_rpool_alloc(unsigned int size, gfp_t flag)
> +{
> +	if (size == PAGE_SIZE_4K)
> +		return(void *)get_zeroed_page(flag);
> +	else
> +		return kzalloc(size, flag);
> +}

kmalloc(4k) is pretty efficient and (I think) is guaranteed to return a
page-aligned address.

iow: can we just use kmalloc here?

> +
> +static inline int
> +iommu_devinfo_pool_init(void)
> +{
> +	return init_resource_pool(&iommu_devinfo_pool, MIN_DEVINFO_REQ,
> +		sizeof(struct device_domain_info),
> +		GROW_DEVINFO_REQ, iommu_rpool_alloc,
> +		iommu_rpool_free);
> +}
> +
> +static inline int
> +iommu_iova_pool_init(void)
> +{
> +	return init_resource_pool(&iommu_iova_pool, MIN_IOVA_REQ,
> +		sizeof(struct iova),
> +		GROW_IOVA_REQ, iommu_rpool_alloc, iommu_rpool_free);
> +}
> +
> +static int iommu_init_mempool(void)
> +{
> +	int ret;
> +	ret = iommu_iova_pool_init();
> +	if (ret)
> +		return ret;
> +
> +	ret = iommu_pgtable_pool_init();
> +	if (ret)
> +		goto pgtable_error;
> +
> +	ret = iommu_domain_pool_init();
> +	if (ret)
> +		goto domain_error;
> +
> +	ret = iommu_devinfo_pool_init();
> +	if (!ret)
> +		return ret;
> +
> +	destroy_resource_pool(&iommu_domain_pool);
> +domain_error:
> +	destroy_resource_pool(&iommu_pgtable_pool);
> +pgtable_error:
> +	destroy_resource_pool(&iommu_iova_pool);
> +
> +	return -ENOMEM;
> +}

can be __init

> +static void iommu_exit_mempool(void)
> +{
> +	destroy_resource_pool(&iommu_devinfo_pool);
> +	destroy_resource_pool(&iommu_domain_pool);
> +	destroy_resource_pool(&iommu_pgtable_pool);
> +	destroy_resource_pool(&iommu_iova_pool);
> +}

ditto (unexpectedly)

> +void __init detect_intel_iommu(void)
> +{
> +	if (swiotlb || no_iommu || iommu_detected || dmar_disabled)
> +		return;
> +	if (early_dmar_detect()) {
> +		iommu_detected = 1;
> +	}
> +}
> +
> +static void __init init_no_remapping_devices(void)
> +{
> +	struct dmar_drhd_unit *drhd;
> +
> +	for_each_drhd_unit(drhd)
> +		if (!drhd->include_all) {
> +			int i;
> +			for (i=0; i < drhd->devices_cnt; i++)
> +				if (drhd->devices[i] != NULL)
> +					break;
> +			/* ignore DMAR unit if no pci devices exist */
> +			if (i == drhd->devices_cnt)
> +				drhd->ignored = 1;
> +		}

looks weird - I'd add the extra braces here.

> +	if (dmar_map_gfx)
> +		return;
> +
> +	for_each_drhd_unit(drhd) {
> +		int i;
> +		if (drhd->ignored || drhd->include_all)
> +			continue;
> +
> +		for (i = 0; i < drhd->devices_cnt; i++)
> +			if (drhd->devices[i] && !IS_GFX_DEVICE(drhd->devices[i]))
> +				break;
> +
> +		if (i < drhd->devices_cnt)
> +			continue;
> +
> +		/* bypass IOMMU if it is just for gfx devices */
> +		drhd->ignored = 1;
> +		for (i = 0; i < drhd->devices_cnt; i++) {
> +			if (!drhd->devices[i])
> +				continue;
> +			drhd->devices[i]->sysdata = DUMMY_DEVICE_DOMAIN_INFO;
> +		}
> +	}
> +}
> +
>
> ...
>
> +#define OFFSET_STRIDE		(9)
> +#define dmar_readl(dmar, reg) readl(dmar + reg)
> +#define dmar_writel(dmar, reg, val) writel((val), dmar + reg)

Is this pointless obfuscation?

> +#define dmar_readq(dmar, reg) ({ \
> +		u32 lo, hi; \
> +		lo = dmar_readl(dmar, reg); \
> +		hi = dmar_readl(dmar, reg + 4); \
> +		(((u64) hi) << 32) + lo; })
> +#define dmar_writeq(dmar, reg, val) do {\
> +		dmar_writel(dmar, reg, (u32)(val)); \
> +		dmar_writel(dmar, reg + 4, (u32)((val) >> 32)); \
> +	} while (0)

Do these need to be macros?  If not, a regular C function would be better. 
Not necessarily an inlined one, either.

> +#define VER_MAJOR(v)		(((v) & 0xf0) >> 4)
> +#define VER_MINOR(v)		((v) & 0x0f)

We already have several VER_MAJORs defined in the tree, so adding a new one
is asking for trouble.  Suggest the use of a more specific identifier.

> +#define set_root_value(root, value) \
> +	do {(root).val |= ((value) & PAGE_MASK_4K);} while(0)

Methinks that could be written in C too.

> +struct domain {

hm, "domain" is a pretty generic term.  I think there's a bit of namespace
hogging here..

> +	int	id;			/* domain id */
> +	struct intel_iommu *iommu;	/* back pointer to owning iommu */
> +
> +	struct list_head devices; 	/* all devices' list */
> +	struct iova_domain iovad;	/* iova's that belong to this domain */
> +
> +	struct dma_pte	*pgd;		/* virtual address */
> +	spinlock_t	mapping_lock;	/* page table lock */
> +	int		gaw;		/* max guest address width */
> +	int		agaw;		/* adjusted guest address width, 0 is level 2 30-bit */
> +
> +#define DOMAIN_FLAG_MULTIPLE_DEVICES 1
> +	int		flags;
> +};
> +
>
> ...
>
> +#define for_each_drhd_unit(drhd) \
> +	list_for_each_entry(drhd, &dmar_drhd_units, list)
> +#define for_each_rmrr_units(rmrr) \
> +	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
> +#define begin_for_each_rmrr_device(rmrr, pdev) \
> +	for_each_rmrr_units(rmrr) { \
> +		int _i; \
> +		for (_i = 0; _i < rmrr->devices_cnt; _i++) { \
> +			pdev = rmrr->devices[_i]; \
> +			/* some BIOS lists non-exist devices in DMAR table */\
> +			if (!pdev) \
> +				continue;
> +#define end_for_each_rmrr_device(rmrr, pdev) \
> +		} \
> +	}
> +

Are these used often enough to justify their inclusion?

Would it be possible to implement these as regular C functions which are
passed the address of a callback function?

