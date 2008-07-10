Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYGJA2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYGJA2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 20:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYGJA2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 20:28:45 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:49542 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbYGJA2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 20:28:44 -0400
Date: Thu, 10 Jul 2008 02:30:07 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: let asic3 use mem resource instead of bus_shift
Message-ID: <20080710003006.GB2637@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1215289200.23398.40.camel@localhost.localdomain> <1215356754.1672.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215356754.1672.1.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Sun, Jul 06, 2008 at 05:05:54PM +0200, Philipp Zabel wrote:
> The bus_shift parameter in platform_data is not needed
> as we can tell the driver with the IOMEM_RESOURCE whether
> the ASIC is located on a 16bit or 32bit memory bus.
> 
> The htc-egpio driver uses a more descriptive bus_width parameter,
> but for drivers where the register map size fixed, we don't even
> need this.
> bus_shift as a configuration parameter is confusing at best
> because sometimes it means "shift register number left by n bits",
> sometimes it means "shift 32bit register address right by n bits"
> (see asic->bus_shift = 2 - pdata->bus_shift ...).
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Looks good, thanks. Applied.

Cheers,
Samuel.

> ---
>  drivers/mfd/asic3.c       |   11 +++++------
>  include/linux/mfd/asic3.h |    5 ++---
>  2 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
> index f2fb233..3b870e7 100644
> --- a/drivers/mfd/asic3.c
> +++ b/drivers/mfd/asic3.c
> @@ -313,6 +313,7 @@ static int __init asic3_irq_probe(struct platform_device *pdev)
>  	struct asic3 *asic = platform_get_drvdata(pdev);
>  	unsigned long clksel = 0;
>  	unsigned int irq, irq_base;
> +	int map_size;
>  
>  	asic->irq_nr = platform_get_irq(pdev, 0);
>  	if (asic->irq_nr < 0)
> @@ -551,8 +552,8 @@ static int __init asic3_probe(struct platform_device *pdev)
>  		goto out_free;
>  	}
>  
> -
> -	asic->mapping = ioremap(mem->start, PAGE_SIZE);
> +	map_size = mem->end - mem->start + 1;
> +	asic->mapping = ioremap(mem->start, map_size);
>  	if (!asic->mapping) {
>  		ret = -ENOMEM;
>  		dev_err(asic->dev, "Couldn't ioremap\n");
> @@ -561,10 +562,8 @@ static int __init asic3_probe(struct platform_device *pdev)
>  
>  	asic->irq_base = pdata->irq_base;
>  
> -	if (pdata && pdata->bus_shift)
> -		asic->bus_shift = 2 - pdata->bus_shift;
> -	else
> -		asic->bus_shift = 0;
> +	/* calculate bus shift from mem resource */
> +	asic->bus_shift = 2 - (map_size >> 12);
>  
>  	clksel = 0;
>  	asic3_write_register(asic, ASIC3_OFFSET(CLOCK, SEL), clksel);
> diff --git a/include/linux/mfd/asic3.h b/include/linux/mfd/asic3.h
> index 8f8c46c..322cd6d 100644
> --- a/include/linux/mfd/asic3.h
> +++ b/include/linux/mfd/asic3.h
> @@ -20,8 +20,6 @@ struct asic3_platform_data {
>  	u16 *gpio_config;
>  	unsigned int gpio_config_num;
>  
> -	unsigned int bus_shift;
> -
>  	unsigned int irq_base;
>  
>  	unsigned int gpio_base;
> @@ -498,6 +496,7 @@ struct asic3_platform_data {
>  #define ASIC3_SDIO_CTRL_LEDCtrl              0x7C
>  #define ASIC3_SDIO_CTRL_SoftwareReset        0x1C0
>  
> -#define ASIC3_MAP_SIZE	     		     0x2000
> +#define ASIC3_MAP_SIZE_32BIT	0x2000
> +#define ASIC3_MAP_SIZE_16BIT	0x1000
>  
>  #endif /* __ASIC3_H__ */
> -- 
> 1.5.6
> 
> 
