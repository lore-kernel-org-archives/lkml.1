Return-Path: <linux-kernel-owner+w=401wt.eu-S1759699AbZKKX6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbZKKX6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 18:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759679AbZKKX6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 18:58:07 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:50322 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759671AbZKKX6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 18:58:05 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/C6HWpuGXt9BCVgNN7EDmU
Date: Wed, 11 Nov 2009 15:58:08 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] omap3-iommu: reorganize
Message-ID: <20091111235808.GQ24837@atomide.com>
References: <1252874472-21089-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252874472-21089-1-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Contreras <felipe.contreras@gmail.com> [090913 13:41]:
> This way it's more object oriented and easier to see what is happening.
> No functional changes.

Felipe, can you please refresh this against omap for-next branch?

Thanks,

Tony
 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  arch/arm/mach-omap2/omap3-iommu.c |   62 ++++++++++++++++++------------------
>  1 files changed, 31 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap3-iommu.c b/arch/arm/mach-omap2/omap3-iommu.c
> index 194189c..6abc217 100644
> --- a/arch/arm/mach-omap2/omap3-iommu.c
> +++ b/arch/arm/mach-omap2/omap3-iommu.c
> @@ -14,47 +14,50 @@
>  
>  #include <mach/iommu.h>
>  
> -#define OMAP3_MMU1_BASE	0x480bd400
> -#define OMAP3_MMU2_BASE	0x5d000000
> -#define OMAP3_MMU1_IRQ	24
> -#define OMAP3_MMU2_IRQ	28
> -
> -
> -static unsigned long iommu_base[] __initdata = {
> -	OMAP3_MMU1_BASE,
> -	OMAP3_MMU2_BASE,
> -};
> -
> -static int iommu_irq[] __initdata = {
> -	OMAP3_MMU1_IRQ,
> -	OMAP3_MMU2_IRQ,
> +struct iommu_device {
> +	resource_size_t base;
> +	int irq;
> +	struct iommu_platform_data pdata;
> +	struct resource res[2];
>  };
>  
> -static const struct iommu_platform_data omap3_iommu_pdata[] __initconst = {
> +static struct iommu_device devices[] = {
>  	{
> -		.name = "isp",
> -		.nr_tlb_entries = 8,
> -		.clk_name = "cam_ick",
> +		.base = 0x480bd400,
> +		.irq = 24,
> +		.pdata = {
> +			.name = "isp",
> +			.nr_tlb_entries = 8,
> +			.clk_name = "cam_ick",
> +		},
>  	},
>  #if defined(CONFIG_MPU_BRIDGE_IOMMU)
>  	{
> -		.name = "iva2",
> -		.nr_tlb_entries = 32,
> -		.clk_name = "iva2_ck",
> +		.base = 0x5d000000,
> +		.irq = 28,
> +		.pdata = {
> +			.name = "iva2",
> +			.nr_tlb_entries = 32,
> +			.clk_name = "iva2_ck",
> +		},
>  	},
>  #endif
>  };
> -#define NR_IOMMU_DEVICES ARRAY_SIZE(omap3_iommu_pdata)
> +#define NR_IOMMU_DEVICES ARRAY_SIZE(devices)
>  
>  static struct platform_device *omap3_iommu_pdev[NR_IOMMU_DEVICES];
>  
>  static int __init omap3_iommu_init(void)
>  {
>  	int i, err;
> +	struct resource res[] = {
> +		{ .flags = IORESOURCE_MEM },
> +		{ .flags = IORESOURCE_IRQ },
> +	};
>  
>  	for (i = 0; i < NR_IOMMU_DEVICES; i++) {
>  		struct platform_device *pdev;
> -		struct resource res[2];
> +		const struct iommu_device *d = &devices[i];
>  
>  		pdev = platform_device_alloc("omap-iommu", i);
>  		if (!pdev) {
> @@ -62,19 +65,16 @@ static int __init omap3_iommu_init(void)
>  			goto err_out;
>  		}
>  
> -		memset(res, 0,  sizeof(res));
> -		res[0].start = iommu_base[i];
> -		res[0].end = iommu_base[i] + MMU_REG_SIZE - 1;
> -		res[0].flags = IORESOURCE_MEM;
> -		res[1].start = res[1].end = iommu_irq[i];
> -		res[1].flags = IORESOURCE_IRQ;
> +		res[0].start = d->base;
> +		res[0].end = d->base + MMU_REG_SIZE - 1;
> +		res[1].start = res[1].end = d->irq;
>  
>  		err = platform_device_add_resources(pdev, res,
>  						    ARRAY_SIZE(res));
>  		if (err)
>  			goto err_out;
> -		err = platform_device_add_data(pdev, &omap3_iommu_pdata[i],
> -					       sizeof(omap3_iommu_pdata[0]));
> +		err = platform_device_add_data(pdev, &d->pdata,
> +					       sizeof(d->pdata));
>  		if (err)
>  			goto err_out;
>  		err = platform_device_add(pdev);
> -- 
> 1.6.5.rc1
> 
