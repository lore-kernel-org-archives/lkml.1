Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYLASQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYLASQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 13:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbYLASQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 13:16:16 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:12215 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbYLASQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 13:16:12 -0500
X-BigFish: VPS-28(ze80iz1432R98dR1805M936fOzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KB7MQJ-04-GN0-01
Date: Mon, 1 Dec 2008 19:16:00 +0100
From: "'Joerg Roedel'" <joerg.roedel@amd.com>
To: "Han, Weidong" <weidong.han@intel.com>
CC: "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'avi@redhat.com'" <avi@redhat.com>,
       "'mingo@redhat.com'" <mingo@redhat.com>,
       "'dwmw2@infradead.org'" <dwmw2@infradead.org>,
       "'amit.shah@redhat.com'" <amit.shah@redhat.com>
Subject: Re: [PATCH 3/9] add frontend implementation for the IOMMU API
Message-ID: <20081201181600.GE12816@amd.com>
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com> <1227800454-9555-4-git-send-email-joerg.roedel@amd.com> <715D42877B251141A38726ABF5CABF2C018BF04FC2@pdsmsx503.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <715D42877B251141A38726ABF5CABF2C018BF04FC2@pdsmsx503.ccr.corp.intel.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 01 Dec 2008 18:16:00.0458 (UTC) FILETIME=[DD2292A0:01C953E0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 10:50:36AM +0800, Han, Weidong wrote:
> Joerg Roedel wrote:
> > +struct iommu_domain *iommu_domain_alloc(struct device *dev)
> > +{
> > +	struct iommu_domain *domain;
> > +	int ret;
> > +
> > +	domain = kmalloc(sizeof(*domain), GFP_KERNEL);
> > +	if (!domain)
> > +		return NULL;
> > +
> > +	ret = iommu_ops->domain_init(domain, dev);
> > +	if (ret)
> > +		goto out_free;
> > +
> > +	return domain;
> > +
> > +out_free:
> > +	kfree(domain);
> > +
> > +	return NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(iommu_domain_alloc);
> 
> remove the parameter dev.

[x] Done.

> > +
> > +void iommu_domain_free(struct iommu_domain *domain)
> > +{
> > +	iommu_ops->domain_destroy(domain);
> > +	kfree(domain);
> > +}
> > +EXPORT_SYMBOL_GPL(iommu_domain_free);
> > +
> > +int iommu_attach_device(struct iommu_domain *domain, struct device
> > *dev) +{
> > +	return iommu_ops->attach_dev(domain, dev);
> > +}
> > +EXPORT_SYMBOL_GPL(iommu_attach_device);
> > +
> > +void iommu_detach_device(struct iommu_domain *domain, struct device
> > *dev) +{
> > +	iommu_ops->detach_dev(domain, dev);
> > +}
> > +EXPORT_SYMBOL_GPL(iommu_detach_device);
> > +
> > +int iommu_map_address(struct iommu_domain *domain,
> > +		      dma_addr_t iova, phys_addr_t paddr,
> > +		      size_t size, int prot)
> > +{
> > +	return iommu_ops->map(domain, iova, paddr, size, prot);
> > +}
> > +EXPORT_SYMBOL_GPL(iommu_map_address);
> 
> change to:
> int iommu_map_pages(struct iommu_domain *domain, unsigned long gfn,
> 		unsigned long pfn, unsigned long npages, int prot)
> {
> 	return iommu_ops->map(domain, gfn, pfn, npages, prot);
> }
> EXPORT_SYMBOL_GPL(iommu_map_pages);
> 
> int iommu_unmap_pages(struct iommu_domain *domain, unsigned long gfn, unsigned long npages)
> {
> 	return iommu_ops->map(domain, gfn, npages);
> }
> EXPORT_SYMBOL_GPL(iommu_unmap_pages);

Ok, I added the unmap function. But I think this API should work with
addresses instead of page numbers. This way the IO page size is
transparent for the user.

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

