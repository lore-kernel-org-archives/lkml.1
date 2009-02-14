Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbZBNXaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbZBNXaX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757839AbZBNXVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:21:10 -0500
Received: from colo.lackof.org ([198.49.126.79]:44469 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757670AbZBNXVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:21:06 -0500
Date: Sat, 14 Feb 2009 16:20:52 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Yu Zhao <yu.zhao@intel.com>
Cc: jbarnes@virtuousgeek.org, dwmw2@infradead.org, linux-pci@vger.kernel.org,
       iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/6] VT-d: support the device IOTLB
Message-ID: <20090214232052.GB1515@colo.lackof.org>
References: <1234443038-15437-1-git-send-email-yu.zhao@intel.com> <1234443038-15437-7-git-send-email-yu.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234443038-15437-7-git-send-email-yu.zhao@intel.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 08:50:38PM +0800, Yu Zhao wrote:
> Support device IOTLB (i.e. ATS) for both native and KVM environments.
> 
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> ---
>  drivers/pci/intel-iommu.c   |   95 +++++++++++++++++++++++++++++++++++++++++-
>  include/linux/intel-iommu.h |    1 +
>  2 files changed, 93 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index 5fdbed3..fe09e7a 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -125,6 +125,7 @@ static inline void context_set_fault_enable(struct context_entry *context)
>  }
>  
>  #define CONTEXT_TT_MULTI_LEVEL 0
> +#define CONTEXT_TT_DEV_IOTLB	1
>  
>  static inline void context_set_translation_type(struct context_entry *context,
>  						unsigned long value)
> @@ -240,6 +241,7 @@ struct device_domain_info {
>  	struct list_head global; /* link to global list */
>  	u8 bus;			/* PCI bus numer */
>  	u8 devfn;		/* PCI devfn number */
> +	struct intel_iommu *iommu; /* IOMMU used by this device */
>  	struct pci_dev *dev; /* it's NULL for PCIE-to-PCI bridge */
>  	struct dmar_domain *domain; /* pointer to domain */
>  };
> @@ -922,6 +924,74 @@ static int __iommu_flush_iotlb(struct intel_iommu *iommu, u16 did,
>  	return 0;
>  }
>  
> +static struct device_domain_info *
> +iommu_support_dev_iotlb(struct dmar_domain *domain, u8 bus, u8 devfn)
> +{
> +	int found = 0;
> +	unsigned long flags;
> +	struct device_domain_info *info;
> +	struct intel_iommu *iommu = device_to_iommu(bus, devfn);
> +
> +	if (!ecap_dev_iotlb_support(iommu->ecap))
> +		return NULL;
> +
> +	if (!iommu->qi)
> +		return NULL;
> +
> +	spin_lock_irqsave(&device_domain_lock, flags);
> +	list_for_each_entry(info, &domain->devices, link)
> +		if (info->dev && info->bus == bus && info->devfn == devfn) {
> +			found = 1;
> +			break;
> +		}
> +	spin_unlock_irqrestore(&device_domain_lock, flags);
> +
> +	if (!found)
> +		return NULL;
> +
> +	if (!dmar_find_matched_atsr_unit(info->dev))
> +		return NULL;
> +
> +	info->iommu = iommu;
> +	if (!pci_ats_queue_depth(info->dev))
> +		return NULL;
> +
> +	return info;
> +}
> +
> +static void iommu_enable_dev_iotlb(struct device_domain_info *info)
> +{
> +	pci_enable_ats(info->dev, VTD_PAGE_SHIFT);
> +}

Why is a static function defined that calls a global function?

> +
> +static void iommu_disable_dev_iotlb(struct device_domain_info *info)
> +{
> +	if (info->dev && pci_ats_enabled(info->dev))
> +		pci_disable_ats(info->dev);
> +}

ditto. pci_disable_ats() should be able to handle the case when
"info->dev" is NULL and will know if ATS is enabled.

I think both of these functions can be dropped and just directly call pci_*_ats().

> +
> +static void iommu_flush_dev_iotlb(struct dmar_domain *domain,
> +				  u64 addr, unsigned mask)
> +{
> +	int rc;
> +	u16 sid, qdep;
> +	unsigned long flags;
> +	struct device_domain_info *info;
> +
> +	spin_lock_irqsave(&device_domain_lock, flags);
> +	list_for_each_entry(info, &domain->devices, link) {

Would it be possible to define a single domain for each PCI device?
Or does "domain" represent an IOMMU?
Sorry, I forgot...I'm sure someone has mentioned this the past.

I want to point out list_for_each_entry() is effectively a "nested loop".
iommu_flush_dev_iotlb() will get called alot from flush_unmaps().
Perhaps do the lookup once there and pass that as a parameter?
I don't know if that is feasible. But if this is a very frequently
used code path, every CPU cycle counts.


> +		if (!info->dev || !pci_ats_enabled(info->dev))
> +			continue;
> +
> +		sid = info->bus << 8 | info->devfn;
> +		qdep = pci_ats_queue_depth(info->dev);

re Matthew Wilcox's comment - looks like caching ats_queue_depth
is appropriate.

thanks,
gant

> +		rc = qi_flush_dev_iotlb(info->iommu, sid, qdep, addr, mask);
> +		if (rc)
> +			printk(KERN_ERR "IOMMU: flush device IOTLB failed\n");

Can this be a dev_printk please?

Perhaps in general review the use of "printk" so when errors are reported,
users will know which devices might be affected by the failure.
If more than a few printk's should be "converted" to dev_printk(), I'd
be happy if that were a seperate patch (submitted later).


> +	}
> +	spin_unlock_irqrestore(&device_domain_lock, flags);
> +}
> +
>  static int iommu_flush_iotlb_psi(struct intel_iommu *iommu, u16 did,
>  	u64 addr, unsigned int pages, int non_present_entry_flush)
>  {
> @@ -945,6 +1015,9 @@ static int iommu_flush_iotlb_psi(struct intel_iommu *iommu, u16 did,
>  		rc = iommu->flush.flush_iotlb(iommu, did, addr, mask,
>  						DMA_TLB_PSI_FLUSH,
>  						non_present_entry_flush);
> +	if (!rc && !non_present_entry_flush)
> +		iommu_flush_dev_iotlb(iommu->domains[did], addr, mask);
> +
>  	return rc;
>  }
>  
> @@ -1469,6 +1542,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
>  	unsigned long ndomains;
>  	int id;
>  	int agaw;
> +	struct device_domain_info *info;
>  
>  	pr_debug("Set context mapping for %02x:%02x.%d\n",
>  		bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
> @@ -1534,7 +1608,11 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
>  	context_set_domain_id(context, id);
>  	context_set_address_width(context, iommu->agaw);
>  	context_set_address_root(context, virt_to_phys(pgd));
> -	context_set_translation_type(context, CONTEXT_TT_MULTI_LEVEL);
> +	info = iommu_support_dev_iotlb(domain, bus, devfn);
> +	if (info)
> +		context_set_translation_type(context, CONTEXT_TT_DEV_IOTLB);
> +	else
> +		context_set_translation_type(context, CONTEXT_TT_MULTI_LEVEL);

Would it be ok to rewrite this as:
+		context_set_translation_type(context,
+			 info ? CONTEXT_TT_DEV_IOTLB : CONTEXT_TT_MULTI_LEVEL);

>  	context_set_fault_enable(context);
>  	context_set_present(context);
>  	domain_flush_cache(domain, context, sizeof(*context));
> @@ -1546,6 +1624,8 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
>  		iommu_flush_write_buffer(iommu);
>  	else
>  		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_DSI_FLUSH, 0);

Adding a blank line here would make this more readable.
(AFAIK, not required by coding style, just my opinion.)

> +	if (info)
> +		iommu_enable_dev_iotlb(info);

Could iommu_enable_dev_iotlb() (or pci_enable_ats()) check if "info" is NULL?
Then this would just be a simple function call.

And it would be consistent with usage of iommu_disable_dev_iotlb().

thanks,
grant

>  
>  	spin_unlock_irqrestore(&iommu->lock, flags);
>  
> @@ -1687,6 +1767,7 @@ static void domain_remove_dev_info(struct dmar_domain *domain)
>  			info->dev->dev.archdata.iommu = NULL;
>  		spin_unlock_irqrestore(&device_domain_lock, flags);
>  
> +		iommu_disable_dev_iotlb(info);
>  		iommu = device_to_iommu(info->bus, info->devfn);
>  		iommu_detach_dev(iommu, info->bus, info->devfn);
>  		free_devinfo_mem(info);
> @@ -2304,8 +2385,14 @@ static void flush_unmaps(void)
>  		iommu->flush.flush_iotlb(iommu, 0, 0, 0,
>  					 DMA_TLB_GLOBAL_FLUSH, 0);
>  		for (j = 0; j < deferred_flush[i].next; j++) {
> -			__free_iova(&deferred_flush[i].domain[j]->iovad,
> -					deferred_flush[i].iova[j]);
> +			unsigned long mask;
> +			struct iova *iova = deferred_flush[i].iova[j];
> +
> +			mask = (iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT;
> +			mask = ilog2(mask >> VTD_PAGE_SHIFT);
> +			iommu_flush_dev_iotlb(deferred_flush[i].domain[j],
> +					iova->pfn_lo << PAGE_SHIFT, mask);
> +			__free_iova(&deferred_flush[i].domain[j]->iovad, iova);
>  		}
>  		deferred_flush[i].next = 0;
>  	}
> @@ -2792,6 +2879,7 @@ static void vm_domain_remove_one_dev_info(struct dmar_domain *domain,
>  				info->dev->dev.archdata.iommu = NULL;
>  			spin_unlock_irqrestore(&device_domain_lock, flags);
>  
> +			iommu_disable_dev_iotlb(info);
>  			iommu_detach_dev(iommu, info->bus, info->devfn);
>  			free_devinfo_mem(info);
>  
> @@ -2840,6 +2928,7 @@ static void vm_domain_remove_all_dev_info(struct dmar_domain *domain)
>  
>  		spin_unlock_irqrestore(&device_domain_lock, flags1);
>  
> +		iommu_disable_dev_iotlb(info);
>  		iommu = device_to_iommu(info->bus, info->devfn);
>  		iommu_detach_dev(iommu, info->bus, info->devfn);
>  
> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> index d82bdac..609af82 100644
> --- a/include/linux/intel-iommu.h
> +++ b/include/linux/intel-iommu.h
> @@ -123,6 +123,7 @@ static inline void dmar_writeq(void __iomem *addr, u64 val)
>  #define ecap_qis(e)		((e) & 0x2)
>  #define ecap_eim_support(e)	((e >> 4) & 0x1)
>  #define ecap_ir_support(e)	((e >> 3) & 0x1)
> +#define ecap_dev_iotlb_support(e)	(((e) >> 2) & 0x1)
>  #define ecap_max_handle_mask(e) ((e >> 20) & 0xf)
>  
>  
> -- 
> 1.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
