Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYK1Cum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYK1Cum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 21:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYK1Cua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 21:50:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:61036 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbYK1Cu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 21:50:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,679,1220252400"; 
   d="scan'208";a="644395930"
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
Date: Fri, 28 Nov 2008 10:50:20 +0800
Subject: RE: [PATCH 2/9] introcude linux/iommu.h for an iommu api
Thread-Topic: [PATCH 2/9] introcude linux/iommu.h for an iommu api
Thread-Index: AclQppqXW0ANfZwATP2imoxgTdGNvgAUy+bw
Message-ID: <715D42877B251141A38726ABF5CABF2C018BF04FC1@pdsmsx503.ccr.corp.intel.com>
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
 <1227800454-9555-3-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1227800454-9555-3-git-send-email-joerg.roedel@amd.com>
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
> This patch introduces the API to abstract the exported VT-d functions
> for KVM into a generic API. This way the AMD IOMMU implementation can
> plug into this API later.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  include/linux/iommu.h |  100
>  +++++++++++++++++++++++++++++++++++++++++++++++++ 1 files changed,
>  100 insertions(+), 0 deletions(-) create mode 100644
> include/linux/iommu.h 
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> new file mode 100644
> index 0000000..6dbc279
> --- /dev/null
> +++ b/include/linux/iommu.h
> @@ -0,0 +1,100 @@
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
> +#ifndef __LINUX_IOMMU_H
> +#define __LINUX_IOMMU_H
> +
> +struct device;
> +
> +struct iommu_domain {
> +	void *priv;
> +};
> +
> +struct iommu_ops {
> +	int (*domain_init)(struct iommu_domain *domain, struct device *dev);

needn't parameter dev, use attach_dev to assign dev to domain.

> +	void (*domain_destroy)(struct iommu_domain *domain);
> +	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
> +	void (*detach_dev)(struct iommu_domain *domain, struct device *dev);
> +	int (*map)(struct iommu_domain *domain, dma_addr_t iova,
> +		   phys_addr_t paddr, size_t size, int prot);

It maps/unmaps pages for iommu in kvm, so I think it's better change to 
	int (*map_pages)(struct iommu_domain *domain, unsigned long gfn, unsigned long pfn,
			  unsigned long npages, int prot);
and also add unmap op:
	int (*unmap_pages)(struct iommu_domain *domain, unsigned long gfn, unsigned long npages);

> +	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain,
> +				    dma_addr_t iova);
> +};
> +
> +#ifdef CONFIG_IOMMU_API
> +
> +extern void register_iommu(struct iommu_ops *ops);
> +extern bool iommu_found(void);
> +extern struct iommu_domain *iommu_domain_alloc(struct device *dev);
> +extern void iommu_domain_free(struct iommu_domain *domain);
> +extern int iommu_attach_device(struct iommu_domain *domain,
> +			       struct device *dev);
> +extern void iommu_detach_device(struct iommu_domain *domain,
> +				struct device *dev);
> +extern int iommu_map_address(struct iommu_domain *domain, dma_addr_t
> iova, +			     phys_addr_t paddr, size_t size, int prot);

similarly:
extern int iommu_map_pages(struct iommu_domain *domain, unsigned long gfn, unsigned long pfn,
			        unsigned long npages, int prot);
extern int iommu_unmap_pages(struct iommu_domain *domain, unsigned long gfn, unsigned long npages);

Regards,
Weidong

