Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbZGWBCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbZGWBCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 21:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZGWBCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 21:02:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38807 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbZGWBCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 21:02:34 -0400
Date: Thu, 23 Jul 2009 10:22:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chaithrika U S <chaithrika@ti.com>, Manjunath Hadli <mrh@ti.com>,
       Brijesh Jadav <brijesh.j@ti.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Hemant Pedanekar <hemantp@ti.com>
Subject: linux-next: manual merge of the v4l-dvb tree with the davinci tree
Message-Id: <20090723102257.2e9852b4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
arch/arm/mach-davinci/dm646x.c between commits
e94c101ce3ef11bc00f8ea5db4b65c4b01874cf8 ("davinci: ASoC: Add the
platform devices for ASP") and da7f706415a5392ba5ff21228cf61c30e6371566
("davinci: dm646x: Add IDE setup") from the davinci tree and commit
be45110fa4525939a32c0509229a1781c5c3da78 ("rch/arm/mach-davinci: Platform
and board specific setup for DM646x EVM") from the v4l-dvb tree.

Again, assuming that these changes are orthogonal, I have fixed it up
(see below) and can carry the fixes as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-davinci/dm646x.c
index 8fa2803,3877ba3..0000000
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@@ -600,92 -518,37 +609,123 @@@ static struct platform_device dm646x_ed
  	.resource		= edma_resources,
  };
  
 +static struct resource ide_resources[] = {
 +	{
 +		.start          = DM646X_ATA_REG_BASE,
 +		.end            = DM646X_ATA_REG_BASE + 0x7ff,
 +		.flags          = IORESOURCE_MEM,
 +	},
 +	{
 +		.start          = IRQ_DM646X_IDE,
 +		.end            = IRQ_DM646X_IDE,
 +		.flags          = IORESOURCE_IRQ,
 +	},
 +};
 +
 +static u64 ide_dma_mask = DMA_BIT_MASK(32);
 +
 +static struct platform_device ide_dev = {
 +	.name           = "palm_bk3710",
 +	.id             = -1,
 +	.resource       = ide_resources,
 +	.num_resources  = ARRAY_SIZE(ide_resources),
 +	.dev = {
 +		.dma_mask		= &ide_dma_mask,
 +		.coherent_dma_mask      = DMA_BIT_MASK(32),
 +	},
 +};
 +
 +static struct resource dm646x_mcasp0_resources[] = {
 +	{
 +		.name	= "mcasp0",
 +		.start 	= DAVINCI_DM646X_MCASP0_REG_BASE,
 +		.end 	= DAVINCI_DM646X_MCASP0_REG_BASE + (SZ_1K << 1) - 1,
 +		.flags 	= IORESOURCE_MEM,
 +	},
 +	/* first TX, then RX */
 +	{
 +		.start	= DAVINCI_DM646X_DMA_MCASP0_AXEVT0,
 +		.end	= DAVINCI_DM646X_DMA_MCASP0_AXEVT0,
 +		.flags	= IORESOURCE_DMA,
 +	},
 +	{
 +		.start	= DAVINCI_DM646X_DMA_MCASP0_AREVT0,
 +		.end	= DAVINCI_DM646X_DMA_MCASP0_AREVT0,
 +		.flags	= IORESOURCE_DMA,
 +	},
 +};
 +
 +static struct resource dm646x_mcasp1_resources[] = {
 +	{
 +		.name	= "mcasp1",
 +		.start	= DAVINCI_DM646X_MCASP1_REG_BASE,
 +		.end	= DAVINCI_DM646X_MCASP1_REG_BASE + (SZ_1K << 1) - 1,
 +		.flags	= IORESOURCE_MEM,
 +	},
 +	/* DIT mode, only TX event */
 +	{
 +		.start	= DAVINCI_DM646X_DMA_MCASP1_AXEVT1,
 +		.end	= DAVINCI_DM646X_DMA_MCASP1_AXEVT1,
 +		.flags	= IORESOURCE_DMA,
 +	},
 +	/* DIT mode, dummy entry */
 +	{
 +		.start	= -1,
 +		.end	= -1,
 +		.flags	= IORESOURCE_DMA,
 +	},
 +};
 +
 +static struct platform_device dm646x_mcasp0_device = {
 +	.name		= "davinci-mcasp",
 +	.id		= 0,
 +	.num_resources	= ARRAY_SIZE(dm646x_mcasp0_resources),
 +	.resource	= dm646x_mcasp0_resources,
 +};
 +
 +static struct platform_device dm646x_mcasp1_device = {
 +	.name		= "davinci-mcasp",
 +	.id		= 1,
 +	.num_resources	= ARRAY_SIZE(dm646x_mcasp1_resources),
 +	.resource	= dm646x_mcasp1_resources,
 +};
 +
 +static struct platform_device dm646x_dit_device = {
 +	.name	= "spdif-dit",
 +	.id	= -1,
 +};
 +
+ static u64 vpif_dma_mask = DMA_BIT_MASK(32);
+ 
+ static struct resource vpif_resource[] = {
+ 	{
+ 		.start	= DAVINCI_VPIF_BASE,
+ 		.end	= DAVINCI_VPIF_BASE + 0x03fff,
+ 		.flags	= IORESOURCE_MEM,
+ 	},
+ 	{
+ 		.start = IRQ_DM646X_VP_VERTINT2,
+ 		.end   = IRQ_DM646X_VP_VERTINT2,
+ 		.flags = IORESOURCE_IRQ,
+ 	},
+ 	{
+ 		.start = IRQ_DM646X_VP_VERTINT3,
+ 		.end   = IRQ_DM646X_VP_VERTINT3,
+ 		.flags = IORESOURCE_IRQ,
+ 	},
+ };
+ 
+ static struct platform_device vpif_display_dev = {
+ 	.name		= "vpif_display",
+ 	.id		= -1,
+ 	.dev		= {
+ 			.dma_mask 		= &vpif_dma_mask,
+ 			.coherent_dma_mask	= DMA_32BIT_MASK,
+ 	},
+ 	.resource	= vpif_resource,
+ 	.num_resources	= ARRAY_SIZE(vpif_resource),
+ };
+ 
  /*----------------------------------------------------------------------*/
  
  static struct map_desc dm646x_io_desc[] = {
@@@ -795,25 -659,28 +835,47 @@@ static struct davinci_soc_info davinci_
  	.sram_len		= SZ_32K,
  };
  
 +void __init dm646x_init_ide()
 +{
 +	davinci_cfg_reg(DM646X_ATAEN);
 +	platform_device_register(&ide_dev);
 +}
 +
 +void __init dm646x_init_mcasp0(struct snd_platform_data *pdata)
 +{
 +	dm646x_mcasp0_device.dev.platform_data = pdata;
 +	platform_device_register(&dm646x_mcasp0_device);
 +}
 +
 +void __init dm646x_init_mcasp1(struct snd_platform_data *pdata)
 +{
 +	dm646x_mcasp1_device.dev.platform_data = pdata;
 +	platform_device_register(&dm646x_mcasp1_device);
 +	platform_device_register(&dm646x_dit_device);
 +}
 +
+ void dm646x_setup_vpif(struct vpif_config *config)
+ {
+ 	unsigned int value;
+ 	void __iomem *base = IO_ADDRESS(DAVINCI_SYSTEM_MODULE_BASE);
+ 
+ 	value = __raw_readl(base + VSCLKDIS_OFFSET);
+ 	value &= ~VSCLKDIS_MASK;
+ 	__raw_writel(value, base + VSCLKDIS_OFFSET);
+ 
+ 	value = __raw_readl(base + VDD3P3V_PWDN_OFFSET);
+ 	value &= ~VDD3P3V_VID_MASK;
+ 	__raw_writel(value, base + VDD3P3V_PWDN_OFFSET);
+ 
+ 	davinci_cfg_reg(DM646X_STSOMUX_DISABLE);
+ 	davinci_cfg_reg(DM646X_STSIMUX_DISABLE);
+ 	davinci_cfg_reg(DM646X_PTSOMUX_DISABLE);
+ 	davinci_cfg_reg(DM646X_PTSIMUX_DISABLE);
+ 
+ 	vpif_display_dev.dev.platform_data = config;
+ 	platform_device_register(&vpif_display_dev);
+ }
+ 
  void __init dm646x_init(void)
  {
  	davinci_common_init(&davinci_soc_info_dm646x);
