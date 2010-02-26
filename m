Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935428Ab0BZHZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 02:25:49 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42856 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935405Ab0BZHZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 02:25:47 -0500
Date: Fri, 26 Feb 2010 18:25:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Martin Fuzzey <mfuzzey@gmail.com>,
       =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the usb tree with the i.MX tree
Message-Id: <20100226182545.b4d5b6c7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
arch/arm/mach-mx2/devices.c between various commits from the i.MX tree
and commits 304ae32ac8ac68ac5a091a67187645dc84b6067c ("USB: MXC: use
DMA_BIT_MASK macro rather than hardcoded constants") and
3f1c5d0f4c64f5e9e4ac329a935b3da67593691f ("USB: MXC: add platform
resources for i.MX21 USB host controller") from the usb tree.

I fixed it up (I think - see below) and cam carry the fixes as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-mx2/devices.c
index a4b809b,3956d82..0000000
--- a/arch/arm/mach-mx2/devices.c
+++ b/arch/arm/mach-mx2/devices.c
@@@ -270,38 -380,63 +271,38 @@@ struct platform_device mxc_pwm_device 
  /*
   * Resource definition for the MXC SDHC
   */
 -static struct resource mxc_sdhc1_resources[] = {
 -	{
 -		.start = SDHC1_BASE_ADDR,
 -		.end   = SDHC1_BASE_ADDR + SZ_4K - 1,
 -		.flags = IORESOURCE_MEM,
 -	}, {
 -		.start = MXC_INT_SDHC1,
 -		.end   = MXC_INT_SDHC1,
 -		.flags = IORESOURCE_IRQ,
 -	}, {
 -		.start  = DMA_REQ_SDHC1,
 -		.end    = DMA_REQ_SDHC1,
 -		.flags  = IORESOURCE_DMA,
 -	},
 -};
 -
 -static u64 mxc_sdhc1_dmamask = DMA_BIT_MASK(32);
 -
 -struct platform_device mxc_sdhc_device0 = {
 -	.name           = "mxc-mmc",
 -	.id             = 0,
 -	.dev            = {
 -		.dma_mask = &mxc_sdhc1_dmamask,
 -		.coherent_dma_mask = DMA_BIT_MASK(32),
 -	},
 -	.num_resources  = ARRAY_SIZE(mxc_sdhc1_resources),
 -	.resource       = mxc_sdhc1_resources,
 -};
 -
 -static struct resource mxc_sdhc2_resources[] = {
 -	{
 -		.start = SDHC2_BASE_ADDR,
 -		.end   = SDHC2_BASE_ADDR + SZ_4K - 1,
 -		.flags = IORESOURCE_MEM,
 -	}, {
 -		.start = MXC_INT_SDHC2,
 -		.end   = MXC_INT_SDHC2,
 -		.flags = IORESOURCE_IRQ,
 -	}, {
 -		.start  = DMA_REQ_SDHC2,
 -		.end    = DMA_REQ_SDHC2,
 -		.flags  = IORESOURCE_DMA,
 -	},
 -};
 -
 -static u64 mxc_sdhc2_dmamask = DMA_BIT_MASK(32);
 +#define DEFINE_MXC_MMC_DEVICE(n, baseaddr, irq, dmareq)			\
 +	static struct resource mxc_sdhc_resources ## n[] = {		\
 +		{							\
 +			.start = baseaddr,				\
 +			.end = baseaddr + SZ_4K - 1,			\
 +			.flags = IORESOURCE_MEM,			\
 +		}, {							\
 +			.start = irq,					\
 +			.end = irq,					\
 +			.flags = IORESOURCE_IRQ,			\
 +		}, {							\
 +			.start = dmareq,				\
 +			.end = dmareq,					\
 +			.flags = IORESOURCE_DMA,			\
 +		},							\
 +	};								\
 +									\
- 	static u64 mxc_sdhc ## n ## _dmamask = 0xffffffffUL;		\
++	static u64 mxc_sdhc ## n ## _dmamask = DMA_BIT_MASK(32);	\
 +									\
 +	struct platform_device mxc_sdhc_device ## n = {			\
 +		.name = "mxc-mmc",					\
 +		.id = n,						\
 +		.dev = {						\
 +			.dma_mask = &mxc_sdhc ## n ## _dmamask,		\
- 			.coherent_dma_mask = 0xffffffff,		\
++			.coherent_dma_mask = DMA_BIT_MASK(32),		\
 +		},							\
 +		.num_resources = ARRAY_SIZE(mxc_sdhc_resources ## n),	\
 +		.resource = mxc_sdhc_resources ## n,		\
 +	}
  
 -struct platform_device mxc_sdhc_device1 = {
 -	.name           = "mxc-mmc",
 -	.id             = 1,
 -	.dev            = {
 -		.dma_mask = &mxc_sdhc2_dmamask,
 -		.coherent_dma_mask = DMA_BIT_MASK(32),
 -	},
 -	.num_resources  = ARRAY_SIZE(mxc_sdhc2_resources),
 -	.resource       = mxc_sdhc2_resources,
 -};
 +DEFINE_MXC_MMC_DEVICE(0, MX2x_SDHC1_BASE_ADDR, MX2x_INT_SDHC1, MX2x_DMA_REQ_SDHC1);
 +DEFINE_MXC_MMC_DEVICE(1, MX2x_SDHC2_BASE_ADDR, MX2x_INT_SDHC2, MX2x_DMA_REQ_SDHC2);
  
  #ifdef CONFIG_MACH_MX27
  static struct resource otg_resources[] = {
@@@ -320,14 -455,14 +321,14 @@@ static u64 otg_dmamask = DMA_BIT_MASK(3
  
  /* OTG gadget device */
  struct platform_device mxc_otg_udc_device = {
- 	.name = "fsl-usb2-udc",
- 	.id = -1,
- 	.dev = {
- 		.dma_mask = &otg_dmamask,
- 		.coherent_dma_mask = 0xffffffffUL,
+ 	.name		= "fsl-usb2-udc",
+ 	.id		= -1,
+ 	.dev		= {
+ 		.dma_mask		= &otg_dmamask,
+ 		.coherent_dma_mask	= DMA_BIT_MASK(32),
  	},
 -	.resource	= otg_resources,
 -	.num_resources	= ARRAY_SIZE(otg_resources),
 +	.resource = otg_resources,
 +	.num_resources = ARRAY_SIZE(otg_resources),
  };
  
  /* OTG host */
@@@ -469,15 -641,32 +470,42 @@@ DEFINE_MXC_GPIO_PORTS(MX27, imx27)
  
  int __init mxc_register_gpios(void)
  {
 -	return mxc_gpio_init(imx_gpio_ports, ARRAY_SIZE(imx_gpio_ports));
 +#ifdef CONFIG_MACH_MX21
 +	if (cpu_is_mx21())
 +		return mxc_gpio_init(imx21_gpio_ports, ARRAY_SIZE(imx21_gpio_ports));
 +	else
 +#endif
 +#ifdef CONFIG_MACH_MX27
 +	if (cpu_is_mx27())
 +		return mxc_gpio_init(imx27_gpio_ports, ARRAY_SIZE(imx27_gpio_ports));
 +	else
 +#endif
 +		return 0;
  }
+ 
+ #ifdef CONFIG_MACH_MX21
+ static struct resource mx21_usbhc_resources[] = {
+ 	{
+ 		.start	= USBOTG_BASE_ADDR,
+ 		.end	= USBOTG_BASE_ADDR + 0x1FFF,
+ 		.flags	= IORESOURCE_MEM,
+ 	},
+ 	{
+ 		.start		= MXC_INT_USBHOST,
+ 		.end		= MXC_INT_USBHOST,
+ 		.flags		= IORESOURCE_IRQ,
+ 	},
+ };
+ 
+ struct platform_device mx21_usbhc_device = {
+ 	.name		= "imx21-hcd",
+ 	.id		= 0,
+ 	.dev		= {
+ 		.dma_mask = &mx21_usbhc_device.dev.coherent_dma_mask,
+ 		.coherent_dma_mask = DMA_BIT_MASK(32),
+ 	},
+ 	.num_resources	= ARRAY_SIZE(mx21_usbhc_resources),
+ 	.resource	= mx21_usbhc_resources,
+ };
+ #endif
+ 
