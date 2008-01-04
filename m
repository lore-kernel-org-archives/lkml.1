Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYADCH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYADCH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 21:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYADCHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 21:07:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:26927 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbYADCHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 21:07:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,241,1196668800"; 
   d="scan'208";a="480939502"
Date: Fri, 4 Jan 2008 09:53:38 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Mark Gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Dave Airlie <airlied@linux.ie>
Subject: Re: [agp-mm][PATCH 1/4][intel_iommu] explicit export current graphics dmar status
Message-ID: <20080104015338.GA17253@zhen-devel.sh.intel.com>
Mail-Followup-To: Mark Gross <mgross@linux.intel.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>
References: <20071218050809.GA12564@zhen-devel.sh.intel.com> <20071219052030.GA24238@zhen-devel.sh.intel.com> <20071219052608.GB24238@zhen-devel.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219052608.GB24238@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.23 i686
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.12.19 13:26:08 +0000, Zhenyu Wang wrote:
> 
> [agp-mm] [intel_iommu] explicit export current graphics dmar status
> 
> To make it possbile to tell other modules about curent
> graphics dmar engine status, that could decide if graphics
> driver should remap physical address to dma address.
> 
> Also this one trys to make dmar_disabled really present
> current status of DMAR, which would be used for completely
> express graphics dmar engine is active or not.
> 
> Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
> ---
>  drivers/pci/intel-iommu.c |   18 ++++++++++++++++--
>  include/linux/dmar.h      |    6 ++++++
>  2 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index e079a52..81a0abc 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -53,7 +53,7 @@
>  static void domain_remove_dev_info(struct dmar_domain *domain);
>  
>  static int dmar_disabled;
> -static int __initdata dmar_map_gfx = 1;
> +static int dmar_map_gfx = 1;
>  static int dmar_forcedac;
>  
>  #define DUMMY_DEVICE_DOMAIN_INFO ((struct device_domain_info *)(-1))
> @@ -86,6 +86,16 @@ static int __init intel_iommu_setup(char *str)
>  }
>  __setup("intel_iommu=", intel_iommu_setup);
>  
> +int intel_iommu_gfx_remapping(void)
> +{
> +#ifndef CONFIG_DMAR_GFX_WA
> +	if (!dmar_disabled && iommu_detected && dmar_map_gfx)
> +		return 1;
> +#endif
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(intel_iommu_gfx_remapping);
> +
>  static struct kmem_cache *iommu_domain_cache;
>  static struct kmem_cache *iommu_devinfo_cache;
>  static struct kmem_cache *iommu_iova_cache;
> @@ -2189,8 +2199,12 @@ static void __init iommu_exit_mempool(void)
>  
>  void __init detect_intel_iommu(void)
>  {
> -	if (swiotlb || no_iommu || iommu_detected || dmar_disabled)
> +	if (dmar_disabled)
> +		return;
> +	if (swiotlb || no_iommu || iommu_detected) {
> +		dmar_disabled = 1;
>  		return;
> +	}
>  	if (early_dmar_detect()) {
>  		iommu_detected = 1;
>  	}
> diff --git a/include/linux/dmar.h b/include/linux/dmar.h
> index ffb6439..8ae435e 100644
> --- a/include/linux/dmar.h
> +++ b/include/linux/dmar.h
> @@ -47,6 +47,8 @@ extern int intel_iommu_init(void);
>  extern int dmar_table_init(void);
>  extern int early_dmar_detect(void);
>  
> +extern int intel_iommu_gfx_remapping(void);
> +
>  extern struct list_head dmar_drhd_units;
>  extern struct list_head dmar_rmrr_units;
>  
> @@ -81,6 +83,10 @@ static inline int intel_iommu_init(void)
>  {
>  	return -ENODEV;
>  }
> +static inline int intel_iommu_gfx_remapping(void)
> +{
> +	return 0;
> +}
>  
>  #endif /* !CONFIG_DMAR */
>  #endif /* __DMAR_H__ */
> -- 
> 1.5.3.4
> 

Any comments to this one? Is it ok to push this iommu patch with
agp dma remapping patches to next -mm?

Thanks.
