Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZBZDUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZBZDUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758260AbZBZDUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:20:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:33331 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370AbZBZDUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:20:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,268,1233561600"; 
   d="scan'208";a="493186630"
Date: Thu, 26 Feb 2009 11:21:15 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/6] VT-d: support the device IOTLB
Message-ID: <20090226032115.GB12973@yzhao-otc.sh.intel.com>
References: <1234443038-15437-1-git-send-email-yu.zhao@intel.com> <1234443038-15437-7-git-send-email-yu.zhao@intel.com> <20090214232052.GB1515@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090214232052.GB1515@colo.lackof.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 07:20:52AM +0800, Grant Grundler wrote:
> On Thu, Feb 12, 2009 at 08:50:38PM +0800, Yu Zhao wrote:
> > Support device IOTLB (i.e. ATS) for both native and KVM environments.
> > +
> > +static void iommu_enable_dev_iotlb(struct device_domain_info *info)
> > +{
> > +	pci_enable_ats(info->dev, VTD_PAGE_SHIFT);
> > +}
> 
> Why is a static function defined that calls a global function?

There would be some extra steps to do before VT-d enables ATS in the
future, so this wrapper makes code expandable later.

> 
> > +
> > +static void iommu_disable_dev_iotlb(struct device_domain_info *info)
> > +{
> > +	if (info->dev && pci_ats_enabled(info->dev))
> > +		pci_disable_ats(info->dev);
> > +}
> 
> ditto. pci_disable_ats() should be able to handle the case when
> "info->dev" is NULL and will know if ATS is enabled.

The info->dev could be NULL only because the VT-d code makes it so. AMD
an IBM IOMMU may not have this requirement. If we make pci_disable_ats()
accept NULL pci_dev, it would fail to catch some errors like using
pci_disable_ats without calling pci_enable_ats before.

> 
> I think both of these functions can be dropped and just directly call pci_*_ats().
> 
> > +
> > +static void iommu_flush_dev_iotlb(struct dmar_domain *domain,
> > +				  u64 addr, unsigned mask)
> > +{
> > +	int rc;
> > +	u16 sid, qdep;
> > +	unsigned long flags;
> > +	struct device_domain_info *info;
> > +
> > +	spin_lock_irqsave(&device_domain_lock, flags);
> > +	list_for_each_entry(info, &domain->devices, link) {
> 
> Would it be possible to define a single domain for each PCI device?
> Or does "domain" represent an IOMMU?
> Sorry, I forgot...I'm sure someone has mentioned this the past.

A domain represents one translation mapping. For device used by the host,
there is one domain per device. Device assigned to a guest shares one
domain.

> 
> I want to point out list_for_each_entry() is effectively a "nested loop".
> iommu_flush_dev_iotlb() will get called alot from flush_unmaps().
> Perhaps do the lookup once there and pass that as a parameter?
> I don't know if that is feasible. But if this is a very frequently
> used code path, every CPU cycle counts.

iommu_flush_dev_iotlb() is only used to flush the devices used in the
host, which means there is always one entry on the list.

> 
> 
> > +		if (!info->dev || !pci_ats_enabled(info->dev))
> > +			continue;
> > +
> > +		sid = info->bus << 8 | info->devfn;
> > +		qdep = pci_ats_queue_depth(info->dev);
> 
> re Matthew Wilcox's comment - looks like caching ats_queue_depth
> is appropriate.

Yes, it's cached as of v3.

> > +		rc = qi_flush_dev_iotlb(info->iommu, sid, qdep, addr, mask);
> > +		if (rc)
> > +			printk(KERN_ERR "IOMMU: flush device IOTLB failed\n");
> 
> Can this be a dev_printk please?

Yes, will replace it with dev_err().

> Perhaps in general review the use of "printk" so when errors are reported,
> users will know which devices might be affected by the failure.
> If more than a few printk's should be "converted" to dev_printk(), I'd
> be happy if that were a seperate patch (submitted later).
> 
> 
> >  	pr_debug("Set context mapping for %02x:%02x.%d\n",
> >  		bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
> > @@ -1534,7 +1608,11 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
> >  	context_set_domain_id(context, id);
> >  	context_set_address_width(context, iommu->agaw);
> >  	context_set_address_root(context, virt_to_phys(pgd));
> > -	context_set_translation_type(context, CONTEXT_TT_MULTI_LEVEL);
> > +	info = iommu_support_dev_iotlb(domain, bus, devfn);
> > +	if (info)
> > +		context_set_translation_type(context, CONTEXT_TT_DEV_IOTLB);
> > +	else
> > +		context_set_translation_type(context, CONTEXT_TT_MULTI_LEVEL);
> 
> Would it be ok to rewrite this as:
> +		context_set_translation_type(context,
> +			 info ? CONTEXT_TT_DEV_IOTLB : CONTEXT_TT_MULTI_LEVEL);

Yes, this one looks better.

> 
> >  	context_set_fault_enable(context);
> >  	context_set_present(context);
> >  	domain_flush_cache(domain, context, sizeof(*context));
> > @@ -1546,6 +1624,8 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
> >  		iommu_flush_write_buffer(iommu);
> >  	else
> >  		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_DSI_FLUSH, 0);
> 
> Adding a blank line here would make this more readable.
> (AFAIK, not required by coding style, just my opinion.)

Yes, I prefer a bank line here too, somehow I missed it.

> 
> > +	if (info)
> > +		iommu_enable_dev_iotlb(info);
> 
> Could iommu_enable_dev_iotlb() (or pci_enable_ats()) check if "info" is NULL?
> Then this would just be a simple function call.
> 
> And it would be consistent with usage of iommu_disable_dev_iotlb().

Yes, good idea.

Thanks a lot for reviewing it!
Yu
