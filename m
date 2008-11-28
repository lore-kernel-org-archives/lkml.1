Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYK1Cvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYK1Cvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 21:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYK1Cvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 21:51:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:55126 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbYK1Cvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 21:51:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,679,1220252400"; 
   d="scan'208";a="468101074"
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
Date: Fri, 28 Nov 2008 10:50:48 +0800
Subject: RE: [PATCH 8/9] VT-d: register functions for the IOMMU API
Thread-Topic: [PATCH 8/9] VT-d: register functions for the IOMMU API
Thread-Index: AclQppnr3RPaQLV4QtedpE8HR9wcnwAW/fEw
Message-ID: <715D42877B251141A38726ABF5CABF2C018BF04FC3@pdsmsx503.ccr.corp.intel.com>
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
 <1227800454-9555-9-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1227800454-9555-9-git-send-email-joerg.roedel@amd.com>
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
>  drivers/pci/intel-iommu.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index 8fa0269..71b4d2f 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -57,6 +57,7 @@
> 
> 
>  static void flush_unmaps_timeout(unsigned long data);
> +static struct iommu_ops intel_iommu_ops;
> 
>  DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
> 
> @@ -2326,6 +2327,9 @@ int __init intel_iommu_init(void)
>  	init_timer(&unmap_timer);
>  	force_iommu = 1;
>  	dma_ops = &intel_dma_ops;
> +
> +	register_iommu(&intel_iommu_ops);
> +
>  	return 0;
>  }
> 
> @@ -2514,3 +2518,12 @@ static phys_addr_t intel_iova_to_phys(struct
> iommu_domain *domain, 
> 
>  	return (pfn << PAGE_SHIFT) & offset;
>  }
> +
> +static struct iommu_ops intel_iommu_ops = {
> +	.domain_init	= intel_iommu_domain_init,
> +	.domain_destroy	= intel_iommu_domain_destroy,
> +	.attach_dev	= intel_iommu_attach_device,
> +	.detach_dev	= intel_iommu_detach_device,
> +	.map		= intel_iommu_map,

change to:
	.map_pages	= intel_iommu_map_pages,
	.unmap_pages	= intel_iommu_unmap_pages,

> +	.iova_to_phys	= intel_iova_to_phys,
> +};

should remove old kvm VT-d API declarations in include/linux/intel-iommu.h, and don't export them. In fact, should remove old kvm VT-d APIs, and move their code to corresponding new APIs. I can help you to do this if need.

Regards,
Weidong

