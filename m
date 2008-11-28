Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbYK1Cu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbYK1Cu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 21:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYK1Cuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 21:50:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:54638 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbYK1Cup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 21:50:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,679,1220252400"; 
   d="scan'208";a="365073039"
From: "Han, Weidong" <weidong.han@intel.com>
To: "'Joerg Roedel'" <joerg.roedel@amd.com>,
       "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>
CC: "'avi@redhat.com'" <avi@redhat.com>,
       "'mingo@redhat.com'" <mingo@redhat.com>,
       "'dwmw2@infradead.org'" <dwmw2@infradead.org>,
       "'amit.shah@redhat.com'" <amit.shah@redhat.com>
Date: Fri, 28 Nov 2008 10:50:36 +0800
Subject: RE: [PATCH 3/9] add frontend implementation for the IOMMU API
Thread-Topic: [PATCH 3/9] add frontend implementation for the IOMMU API
Thread-Index: AclQpp+v2DfYMfDfSLecZzW9QHoPCwAVgeGA
Message-ID: <715D42877B251141A38726ABF5CABF2C018BF04FC2@pdsmsx503.ccr.corp.intel.com>
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
 <1227800454-9555-4-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1227800454-9555-4-git-send-email-joerg.roedel@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/base/iommu.c |   94
>  ++++++++++++++++++++++++++++++++++++++++++++++++++ 1 files changed,
>  94 insertions(+), 0 deletions(-) create mode 100644
> drivers/base/iommu.c 
> 
> diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
> new file mode 100644
> index 0000000..7250b9c
> --- /dev/null
> +++ b/drivers/base/iommu.c
> @@ -0,0 +1,94 @@
> +/*
> + * Copyright (C) 2007-2008 Advanced Micro Devices, Inc.
> + * Author: Joerg Roedel <joerg.roedel@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or
> modify it + * under the terms of the GNU General Public License
> version 2 as published + * by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 
> 02111-1307 USA + */
> +
> +#include <linux/bug.h>
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <linux/iommu.h>
> +
> +static struct iommu_ops *iommu_ops;
> +
> +void register_iommu(struct iommu_ops *ops)
> +{
> +	if (iommu_ops)
> +		BUG();
> +
> +	iommu_ops = ops;
> +}
> +
> +bool iommu_found()
> +{
> +	return iommu_ops != NULL;
> +}
> +EXPORT_SYMBOL_GPL(iommu_found);
> +
> +struct iommu_domain *iommu_domain_alloc(struct device *dev)
> +{
> +	struct iommu_domain *domain;
> +	int ret;
> +
> +	domain = kmalloc(sizeof(*domain), GFP_KERNEL);
> +	if (!domain)
> +		return NULL;
> +
> +	ret = iommu_ops->domain_init(domain, dev);
> +	if (ret)
> +		goto out_free;
> +
> +	return domain;
> +
> +out_free:
> +	kfree(domain);
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(iommu_domain_alloc);

remove the parameter dev.

> +
> +void iommu_domain_free(struct iommu_domain *domain)
> +{
> +	iommu_ops->domain_destroy(domain);
> +	kfree(domain);
> +}
> +EXPORT_SYMBOL_GPL(iommu_domain_free);
> +
> +int iommu_attach_device(struct iommu_domain *domain, struct device
> *dev) +{
> +	return iommu_ops->attach_dev(domain, dev);
> +}
> +EXPORT_SYMBOL_GPL(iommu_attach_device);
> +
> +void iommu_detach_device(struct iommu_domain *domain, struct device
> *dev) +{
> +	iommu_ops->detach_dev(domain, dev);
> +}
> +EXPORT_SYMBOL_GPL(iommu_detach_device);
> +
> +int iommu_map_address(struct iommu_domain *domain,
> +		      dma_addr_t iova, phys_addr_t paddr,
> +		      size_t size, int prot)
> +{
> +	return iommu_ops->map(domain, iova, paddr, size, prot);
> +}
> +EXPORT_SYMBOL_GPL(iommu_map_address);

change to:
int iommu_map_pages(struct iommu_domain *domain, unsigned long gfn,
		unsigned long pfn, unsigned long npages, int prot)
{
	return iommu_ops->map(domain, gfn, pfn, npages, prot);
}
EXPORT_SYMBOL_GPL(iommu_map_pages);

int iommu_unmap_pages(struct iommu_domain *domain, unsigned long gfn, unsigned long npages)
{
	return iommu_ops->map(domain, gfn, npages);
}
EXPORT_SYMBOL_GPL(iommu_unmap_pages);

Regards,
Weidong

> +
> +phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
> +			       dma_addr_t iova)
> +{
> +	return iommu_ops->iova_to_phys(domain, iova);
> +}
> +EXPORT_SYMBOL_GPL(iommu_iova_to_phys);

