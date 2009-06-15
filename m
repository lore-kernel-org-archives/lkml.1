Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbZFOKJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbZFOKJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbZFOKJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:09:13 -0400
Received: from mga10.intel.com ([192.55.52.92]:22229 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753172AbZFOKJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:09:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,221,1243839600"; 
   d="scan'208";a="699406579"
Date: Mon, 15 Jun 2009 12:11:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] MFD: Added Timberdale driver
Message-ID: <20090615101116.GB4094@sortiz.org>
References: <4A292099.2020306@mocean-labs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A292099.2020306@mocean-labs.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Fri, Jun 05, 2009 at 03:41:45PM +0200, Richard Röjfors wrote:
> MFD driver for the Timberdale FPGA The FPGA can be found on the
> Intel Atom development board, Russellville for in-vechicle infotainment
> 
> The FPGA is connected via PCIe
> 
> The driver basically exposes a lot of platform devices for the
> different IPs within the FPGA, and doing IRQ multiplexing
> 
> Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>
patch #4 of this serie is an mfd driver too, so I guess I should have been
cc'ed on it too.
So, if I understand this thread correctly, we should proceed like that:

1) Richard comes up with an updated xilinx patch (patch #2).
2) Andrew sends all patches but patch 7 to the relevant maintainers.
3) When all patches but 7 are in Linus tree, I take patch 7 and include it in
my pull request to Linus.

Andrew, does that make sense to you? Do you want me to take patch #4 as well?

Cheers,
Samuel.


> ---
> Index: linux-2.6.30-rc7/drivers/mfd/Kconfig
> ===================================================================
> --- linux-2.6.30-rc7/drivers/mfd/Kconfig	(revision 861)
> +++ linux-2.6.30-rc7/drivers/mfd/Kconfig	(working copy)
> @@ -241,6 +241,16 @@
>  	 Say yes here if you want to include support GPIO for pins on
>  	 the PCF50633 chip.
> 
> +config MFD_TIMBERDALE
> +	bool "Support for the Timberdale FPGA"
> +	select MFD_CORE
> +	---help---
> +	This is the core driver for the timberdale FPGA. This device is a
> +	multifunctioanl device which may provide numerous interfaces.
> +
> +	The timberdale FPGA can be found on the Intel Atom development board
> +	for automotive in-vehicle infontainment board called Russellville.
> +
>  config MFD_TIMBERDALE_DMA
>  	tristate "Support for timberdale DMA"
>  	depends on MFD_TIMBERDALE
> Index: linux-2.6.30-rc7/drivers/mfd/timberdale.c
> ===================================================================
> --- linux-2.6.30-rc7/drivers/mfd/timberdale.c	(revision 0)
> +++ linux-2.6.30-rc7/drivers/mfd/timberdale.c	(revision 888)
> @@ -0,0 +1,686 @@
> +/*
> + * timberdale.c timberdale FPGA mfd shim driver
> + * Copyright (c) 2009 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +/* Supports:
> + * Timberdale FPGA
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/msi.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/core.h>
> +#include <linux/irq.h>
> +
> +#include <linux/i2c.h>
> +#include <linux/i2c-ocores.h>
> +#include <linux/i2c/tsc2007.h>
> +
> +#include <linux/spi/spi.h>
> +#include <linux/spi/xilinx_spi.h>
> +#include <linux/spi/max7301.h>
> +#include <linux/spi/mc33880.h>
> +
> +#include <media/timb_video.h>
> +
> +#include "timberdale.h"
> +
> +struct timberdale_device {
> +	resource_size_t		intc_mapbase;
> +	resource_size_t		ctl_mapbase;
> +	unsigned char __iomem   *intc_membase;
> +	unsigned char __iomem   *ctl_membase;
> +	int			irq_base;
> +	u32			irq_ack_mask;
> +	/* locking from interrupts while modifiying registers */
> +	spinlock_t		lock;
> +};
> +
> +/*--------------------------------------------------------------------------*/
> +
> +struct tsc2007_platform_data timberdale_tsc2007_platform_data = {
> +	.model = 2003,
> +	.x_plate_ohms = 100
> +};
> +
> +struct i2c_board_info timberdale_i2c_board_info[] = {
> +	{
> +		I2C_BOARD_INFO("tsc2003", 0x48),
> +		.platform_data = &timberdale_tsc2007_platform_data,
> +		.irq = IRQ_TIMBERDALE_TSC_INT
> +	},
> +	{
> +		/* Requires jumper JP9 to be off */
> +		I2C_BOARD_INFO("adv7180", 0x42 >> 1),
> +		.irq = IRQ_TIMBERDALE_ADV7180
> +	}
> +};
> +
> +static __devinitdata struct ocores_i2c_platform_data
> +timberdale_i2c_platform_data = {
> +	.regstep = 4,
> +	.clock_khz = 62500,
> +	.devices = timberdale_i2c_board_info,
> +	.num_devices = ARRAY_SIZE(timberdale_i2c_board_info)
> +};
> +
> +const static __devinitconst struct resource timberdale_i2c_resources[] = {
> +	{
> +		.start	= I2COFFSET,
> +		.end	= I2CEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start 	= IRQ_TIMBERDALE_I2C,
> +		.end	= IRQ_TIMBERDALE_I2C,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +const struct max7301_platform_data timberdale_max7301_platform_data = {
> +	.base = -1
> +};
> +
> +const struct mc33880_platform_data timberdale_mc33880_platform_data = {
> +	.base = -1
> +};
> +
> +struct spi_board_info timberdale_spi_16bit_board_info[] = {
> +	{
> +		.modalias = "max7301",
> +		.max_speed_hz = 26000,
> +		.chip_select = 2,
> +		.mode = SPI_MODE_0,
> +		.platform_data = &timberdale_max7301_platform_data
> +	},
> +};
> +
> +struct spi_board_info timberdale_spi_8bit_board_info[] = {
> +	{
> +		.modalias = "mc33880",
> +		.max_speed_hz = 4000,
> +		.chip_select = 1,
> +		.mode = SPI_MODE_1,
> +		.platform_data = &timberdale_mc33880_platform_data
> +	},
> +};
> +
> +static __devinitdata struct xspi_platform_data timberdale_xspi_platform_data = {
> +	.bus_num = -1,
> +	/* Current(2009-03-06) revision of
> +	 * Timberdale we can handle 3 chip selects
> +	 */
> +	.num_chipselect = 3,
> +	.model = XILINX_SPI_MODEL_DS570,
> +	/* bits per word and devices will be filled in runtime depending
> +	 * on the HW config
> +	 */
> +};
> +
> +const static __devinitconst struct resource timberdale_spi_resources[] = {
> +	{
> +		.start 	= SPIOFFSET,
> +		.end	= SPIEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_SPI,
> +		.end	= IRQ_TIMBERDALE_SPI,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +const static __devinitconst struct resource timberdale_eth_resources[] = {
> +	{
> +		.start	= ETHOFFSET,
> +		.end	= ETHEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_ETHSW_IF,
> +		.end	= IRQ_TIMBERDALE_ETHSW_IF,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +const static __devinitconst struct resource timberdale_gpio_resources[] = {
> +	{
> +		.start	= GPIOOFFSET,
> +		.end	= GPIOEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_GPIO,
> +		.end	= IRQ_TIMBERDALE_GPIO,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +const static __devinitconst struct resource timberdale_most_resources[] = {
> +	{
> +		.start	= MOSTOFFSET,
> +		.end	= MOSTEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_MLB,
> +		.end	= IRQ_TIMBERDALE_MLB,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +const static __devinitconst struct resource timberdale_uart_resources[] = {
> +	{
> +		.start	= UARTOFFSET,
> +		.end	= UARTEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_UART,
> +		.end	= IRQ_TIMBERDALE_UART,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +const static __devinitconst struct resource timberdale_i2s_resources[] = {
> +	{
> +		.start	= I2SOFFSET,
> +		.end	= I2SEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_I2S,
> +		.end	= IRQ_TIMBERDALE_I2S,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static __devinitdata struct timb_video_platform_data
> +	timberdale_video_platform_data = {
> +	.i2c_adapter = 0,
> +	.encoder = "adv7180"
> +};
> +
> +const static __devinitconst struct resource timberdale_video_resources[] = {
> +	{
> +		.start	= LOGIWOFFSET,
> +		.end	= LOGIWEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	/*
> +	note that the "frame buffer" is located in DMA area
> +	starting at 0x1200000
> +	*/
> +};
> +
> +const static __devinitconst struct resource timberdale_dma_resources[] = {
> +	{
> +		.start	= DMAOFFSET,
> +		.end	= DMAEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_DMA,
> +		.end	= IRQ_TIMBERDALE_DMA,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static __devinitdata struct mfd_cell timberdale_cells_bar0[] = {
> +	{
> +		.name = "timb-uart",
> +		.num_resources = ARRAY_SIZE(timberdale_uart_resources),
> +		.resources = timberdale_uart_resources,
> +	},
> +	{
> +		.name = "ocores-i2c",
> +		.num_resources = ARRAY_SIZE(timberdale_i2c_resources),
> +		.resources = timberdale_i2c_resources,
> +		.platform_data = &timberdale_i2c_platform_data,
> +		.data_size = sizeof(timberdale_i2c_platform_data),
> +	},
> +	{
> +		.name = "timb-gpio",
> +		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
> +		.resources = timberdale_gpio_resources,
> +	},
> +	{
> +		.name = "timb-i2s",
> +		.num_resources = ARRAY_SIZE(timberdale_i2s_resources),
> +		.resources = timberdale_i2s_resources,
> +	},
> +	{
> +		.name = "timb-most",
> +		.num_resources = ARRAY_SIZE(timberdale_most_resources),
> +		.resources = timberdale_most_resources,
> +	},
> +	{
> +		.name = "timb-video",
> +		.num_resources = ARRAY_SIZE(timberdale_video_resources),
> +		.resources = timberdale_video_resources,
> +		.platform_data = &timberdale_video_platform_data,
> +		.data_size = sizeof(timberdale_video_platform_data),
> +	},
> +	{
> +		.name = "xilinx_spi",
> +		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
> +		.resources = timberdale_spi_resources,
> +		.platform_data = &timberdale_xspi_platform_data,
> +		.data_size = sizeof(timberdale_xspi_platform_data),
> +	},
> +	{
> +		.name = "ks8842",
> +		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
> +		.resources = timberdale_eth_resources,
> +	},
> +	{
> +		.name = "timb-dma",
> +		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
> +		.resources = timberdale_dma_resources,
> +	},
> +};
> +
> +static const __devinitconst struct resource timberdale_sdhc_resources[] = {
> +	/* located in bar 1 and bar 2 */
> +	{
> +		.start	= SDHC0OFFSET,
> +		.end	= SDHC0END,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_SDHC,
> +		.end	= IRQ_TIMBERDALE_SDHC,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static __devinitdata struct mfd_cell timberdale_cells_bar1[] = {
> +	{
> +		.name = "sdhci",
> +		.num_resources = ARRAY_SIZE(timberdale_sdhc_resources),
> +		.resources = timberdale_sdhc_resources,
> +	},
> +};
> +
> +static __devinitdata struct mfd_cell timberdale_cells_bar2[] = {
> +	{
> +		.name = "sdhci",
> +		.num_resources = ARRAY_SIZE(timberdale_sdhc_resources),
> +		.resources = timberdale_sdhc_resources,
> +	},
> +};
> +
> +/*--------------------------------------------------------------------------*/
> +
> +
> +/* Handle the timberdale interrupt mux */
> +static void timberdale_irq(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct timberdale_device *priv = get_irq_data(irq);
> +	unsigned int i, ipr;
> +
> +	desc->chip->ack(irq);
> +
> +	while ((ipr = ioread32(priv->intc_membase + IPR))) {
> +		for (i = 0; i < TIMBERDALE_NR_IRQS; i++)
> +			if (ipr & (1 << i)) {
> +				priv->irq_ack_mask = 0;
> +				generic_handle_irq(priv->irq_base + i);
> +				if (priv->irq_ack_mask)
> +					iowrite32(priv->irq_ack_mask,
> +						priv->intc_membase + IAR);
> +			}
> +	}
> +}
> +
> +static void timberdale_irq_mask(unsigned int irq)
> +{
> +	struct timberdale_device *priv = get_irq_chip_data(irq);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +	iowrite32(1 << (irq - priv->irq_base), priv->intc_membase + CIE);
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +}
> +
> +static void timberdale_irq_unmask(unsigned int irq)
> +{
> +	struct timberdale_device *priv = get_irq_chip_data(irq);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +	iowrite32(1 << (irq - priv->irq_base), priv->intc_membase + SIE);
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +}
> +
> +static void timberdale_irq_ack(unsigned int irq)
> +{
> +	struct timberdale_device *priv = get_irq_chip_data(irq);
> +	unsigned long flags;
> +	u32 ack_mask = 1 << (irq - priv->irq_base);
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +	/* if edge triggered, ack directly. Otherwhise ack in the end of
> +	 * irq handler
> +	 */
> +	if (ack_mask & IRQ_TIMBERDALE_EDGE_MASK)
> +		iowrite32(ack_mask, priv->intc_membase + IAR);
> +	else
> +		priv->irq_ack_mask |= ack_mask;
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +}
> +
> +static struct irq_chip timberdale_chip = {
> +	.name		= "timberdale",
> +	.ack		= timberdale_irq_ack,
> +	.mask		= timberdale_irq_mask,
> +	.unmask		= timberdale_irq_unmask,
> +	.disable	= timberdale_irq_mask,
> +	.enable		= timberdale_irq_unmask,
> +};
> +
> +/*--------------------------------------------------------------------------*/
> +
> +/* Install the IRQ handler */
> +static void timberdale_attach_irq(struct pci_dev *dev)
> +{
> +	struct timberdale_device *priv = pci_get_drvdata(dev);
> +	unsigned int irq, irq_base;
> +
> +	irq_base = priv->irq_base;
> +	for (irq = irq_base; irq < irq_base + TIMBERDALE_NR_IRQS; irq++) {
> +		set_irq_chip_and_handler_name(irq, &timberdale_chip,
> +			handle_edge_irq, "mux");
> +
> +		set_irq_chip_data(irq, priv);
> +
> +#ifdef CONFIG_ARM
> +		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
> +#endif
> +	}
> +
> +	set_irq_data(dev->irq, priv);
> +	set_irq_chained_handler(dev->irq, timberdale_irq);
> +}
> +
> +static void timberdale_detach_irq(struct pci_dev *dev)
> +{
> +	struct timberdale_device *priv = pci_get_drvdata(dev);
> +	unsigned int irq, irq_base;
> +
> +	irq_base = priv->irq_base;
> +
> +	set_irq_chained_handler(dev->irq, NULL);
> +	set_irq_data(dev->irq, NULL);
> +
> +	for (irq = irq_base; irq < irq_base + TIMBERDALE_NR_IRQS; irq++) {
> +#ifdef CONFIG_ARM
> +		set_irq_flags(irq, 0);
> +#endif
> +		set_irq_chip(irq, NULL);
> +		set_irq_chip_data(irq, NULL);
> +	}
> +}
> +
> +static int irq_range_free(int irq_start, int num_irq)
> +{
> +	int i;
> +
> +	for (i = 0; i < num_irq; i++)
> +		if (get_irq_chip(irq_start + i) != &no_irq_chip)
> +			return 0;
> +
> +	return 1;
> +}
> +
> +static int __devinit timb_probe(struct pci_dev *dev,
> +	const struct pci_device_id *id)
> +{
> +	struct timberdale_device *priv;
> +	int err, i;
> +	resource_size_t mapbase;
> +	u32 hw_config;
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&priv->lock);
> +	pci_set_drvdata(dev, priv);
> +
> +	err = pci_enable_device(dev);
> +	if (err)
> +		goto err_enable;
> +
> +	mapbase = pci_resource_start(dev, 0);
> +	if (!mapbase) {
> +		printk(KERN_ERR "timberdale: No resource\n");
> +		goto err_start;
> +	}
> +
> +	/* create a resource for the Interrupt controller registers */
> +	priv->intc_mapbase = mapbase + INTCOFFSET;
> +	if (!request_mem_region(priv->intc_mapbase, INTCSIZE, "timb-intc")) {
> +		printk(KERN_ERR "timberdale: Failed to request intc mem\n");
> +		goto err_request;
> +	}
> +
> +	/* create a resource for the PCI master register */
> +	priv->ctl_mapbase = mapbase + CHIPCTLOFFSET;
> +	if (!request_mem_region(priv->ctl_mapbase, CHIPCTLSIZE, "timb-intc")) {
> +		printk(KERN_ERR "timberdale: Failed to request ctl mem\n");
> +		goto err_request_ctl;
> +	}
> +
> +	priv->intc_membase = ioremap(priv->intc_mapbase, INTCSIZE);
> +	if (!priv->intc_membase) {
> +		printk(KERN_ALERT "timberdale: Map error, intc\n");
> +		goto err_ioremap;
> +	}
> +
> +	priv->ctl_membase = ioremap(priv->ctl_mapbase, CHIPCTLSIZE);
> +	if (!priv->ctl_membase) {
> +		printk(KERN_ALERT "timberdale: Map error, ctl\n");
> +		goto err_ioremap_ctl;
> +	}
> +
> +	err = pci_enable_msi(dev);
> +	if (err) {
> +		printk(KERN_WARNING "timberdale: MSI init failed: %d\n", err);
> +		goto err_msi;
> +	}
> +
> +	/* Reset all FPGA PLB peripherals */
> +	iowrite32(0x1, priv->ctl_membase + MAYSVILLERST);
> +
> +	/* read the HW config */
> +	hw_config = ioread32(priv->ctl_membase + TIMB_HW_CONFIG);
> +
> +	/* at this stage the FPGA does not generate a
> +	 * unique interrupt per function, to emulate real interrupts
> +	 * we assign them a faked interrupt which we issue in the
> +	 * interrupt handler. For now just hard code a base number
> +	 */
> +	priv->irq_base = NR_IRQS - TIMBERDALE_NR_IRQS - 1;
> +	while (priv->irq_base >= 0)
> +		if (irq_range_free(priv->irq_base, TIMBERDALE_NR_IRQS))
> +			break;
> +		else
> +			priv->irq_base -= TIMBERDALE_NR_IRQS;
> +
> +	if (priv->irq_base < 0)
> +		goto err_msi;
> +
> +	timberdale_attach_irq(dev);
> +
> +	/* update IRQ offsets in I2C board info */
> +	for (i = 0; i < ARRAY_SIZE(timberdale_i2c_board_info); i++)
> +		timberdale_i2c_board_info[i].irq += priv->irq_base;
> +
> +	/* Update the SPI configuration depending on the HW (8 or 16 bit) */
> +	if (hw_config & TIMB_HW_CONFIG_SPI_8BIT) {
> +		timberdale_xspi_platform_data.bits_per_word = 8;
> +		timberdale_xspi_platform_data.devices =
> +			timberdale_spi_8bit_board_info;
> +		timberdale_xspi_platform_data.num_devices =
> +			ARRAY_SIZE(timberdale_spi_8bit_board_info);
> +	} else {
> +		timberdale_xspi_platform_data.bits_per_word = 16;
> +		timberdale_xspi_platform_data.devices =
> +			timberdale_spi_16bit_board_info;
> +		timberdale_xspi_platform_data.num_devices =
> +			ARRAY_SIZE(timberdale_spi_16bit_board_info);
> +	}
> +
> +	err = mfd_add_devices(&dev->dev, 0,
> +		timberdale_cells_bar0, ARRAY_SIZE(timberdale_cells_bar0),
> +		&dev->resource[0], priv->irq_base);
> +	if (err) {
> +		printk(KERN_WARNING
> +			"timberdale: mfd_add_devices failed: %d\n", err);
> +		goto err_mfd;
> +	}
> +
> +	err = mfd_add_devices(&dev->dev, 1,
> +		timberdale_cells_bar1, ARRAY_SIZE(timberdale_cells_bar1),
> +		&dev->resource[1], priv->irq_base);
> +	if (err) {
> +		printk(KERN_WARNING
> +			"timberdale: mfd_add_devices failed: %d\n", err);
> +		goto err_mfd2;
> +	}
> +
> +	err = mfd_add_devices(&dev->dev, 2,
> +		timberdale_cells_bar2, ARRAY_SIZE(timberdale_cells_bar2),
> +		&dev->resource[2], priv->irq_base);
> +	if (err) {
> +		printk(KERN_WARNING
> +			"timberdale: mfd_add_devices failed: %d\n", err);
> +		goto err_mfd2;
> +	}
> +
> +	printk(KERN_INFO
> +		"Found Timberdale Card. Rev: %d.%d, HW config: 0x%02x\n",
> +		ioread32(priv->ctl_membase + TIMB_REV_MAJOR),
> +		ioread32(priv->ctl_membase + TIMB_REV_MINOR), hw_config);
> +
> +	/* Enable interrupts and wire the hardware interrupts */
> +	iowrite32(0x3, priv->intc_membase + MER);
> +
> +	return 0;
> +
> +err_mfd2:
> +	mfd_remove_devices(&dev->dev);
> +err_mfd:
> +	timberdale_detach_irq(dev);
> +	pci_disable_msi(dev);
> +err_msi:
> +	iounmap(priv->ctl_membase);
> +err_ioremap_ctl:
> +	iounmap(priv->intc_membase);
> +err_ioremap:
> +	release_mem_region(priv->ctl_mapbase, CHIPCTLSIZE);
> +err_request_ctl:
> +	release_mem_region(priv->intc_mapbase, INTCSIZE);
> +err_request:
> +	pci_set_drvdata(dev, NULL);
> +err_start:
> +	pci_disable_device(dev);
> +err_enable:
> +	kfree(priv);
> +	pci_set_drvdata(dev, NULL);
> +	return -ENODEV;
> +}
> +
> +static void __devexit timb_remove(struct pci_dev *dev)
> +{
> +	/* clean up any allocated resources and stuff here.
> +	 * like call release_region();
> +	 */
> +	struct timberdale_device *priv;
> +
> +	priv = pci_get_drvdata(dev);
> +
> +	mfd_remove_devices(&dev->dev);
> +
> +	timberdale_detach_irq(dev);
> +
> +	iowrite32(0xffffffff, priv->intc_membase + IAR);
> +	iowrite32(0, priv->intc_membase + MER);
> +	iowrite32(0, priv->intc_membase + IER);
> +
> +	iounmap(priv->ctl_membase);
> +	iounmap(priv->intc_membase);
> +	release_mem_region(priv->ctl_mapbase, CHIPCTLSIZE);
> +	release_mem_region(priv->intc_mapbase, INTCSIZE);
> +
> +	pci_disable_msi(dev);
> +	pci_disable_device(dev);
> +	pci_set_drvdata(dev, NULL);
> +	kfree(priv);
> +}
> +
> +static struct pci_device_id timberdale_pci_tbl[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_TIMB, PCI_DEVICE_ID_TIMB) },
> +	{ 0 }
> +};
> +MODULE_DEVICE_TABLE(pci, timberdale_pci_tbl);
> +
> +static struct pci_driver timberdale_pci_driver = {
> +	.name = "timberdale",
> +	.id_table = timberdale_pci_tbl,
> +	.probe = timb_probe,
> +	.remove = timb_remove,
> +};
> +
> +static int __init timberdale_init(void)
> +{
> +	int err;
> +
> +	err = pci_register_driver(&timberdale_pci_driver);
> +	if (err < 0) {
> +		printk(KERN_ERR
> +			"Failed to register PCI driver for %s device.\n",
> +			timberdale_pci_driver.name);
> +		return -ENODEV;
> +	}
> +
> +	printk(KERN_INFO "Driver for %s has been successfully registered.\n",
> +		timberdale_pci_driver.name);
> +
> +	return 0;
> +}
> +
> +static void __exit timberdale_exit(void)
> +{
> +	pci_unregister_driver(&timberdale_pci_driver);
> +
> +	printk(KERN_INFO "Driver for %s has been successfully unregistered.\n",
> +				timberdale_pci_driver.name);
> +}
> +
> +module_init(timberdale_init);
> +module_exit(timberdale_exit);
> +
> +MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
> +MODULE_VERSION(DRV_VERSION);
> +MODULE_LICENSE("GPL v2");
> +
> Index: linux-2.6.30-rc7/drivers/mfd/timberdale.h
> ===================================================================
> --- linux-2.6.30-rc7/drivers/mfd/timberdale.h	(revision 0)
> +++ linux-2.6.30-rc7/drivers/mfd/timberdale.h	(revision 864)
> @@ -0,0 +1,123 @@
> +/*
> + * timberdale.h timberdale FPGA mfd shim driver defines
> + * Copyright (c) 2009 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +/* Supports:
> + * Timberdale FPGA
> + */
> +
> +#ifndef MFD_TIMBERDALE_H
> +#define MFD_TIMBERDALE_H
> +
> +/* Registers of the interrupt controller */
> +#define ISR		0x00
> +#define IPR		0x04
> +#define IER		0x08
> +#define IAR		0x0c
> +#define SIE		0x10
> +#define CIE		0x14
> +#define MER		0x1c
> +
> +/* Registers of the control area */
> +#define TIMB_REV_MAJOR	0x00
> +#define TIMB_REV_MINOR	0x04
> +#define TIMB_HW_CONFIG	0x08
> +#define MAYSVILLERST	0x40
> +
> +/* bits in the TIMB_HW_CONFIG register */
> +#define TIMB_HW_CONFIG_SPI_8BIT	0x80
> +
> +#define I2COFFSET	0x0
> +#define I2CEND		0x1f
> +
> +#define SPIOFFSET	0x80
> +#define SPIEND		0xff
> +
> +#define ETHOFFSET	0x300
> +#define ETHEND		0x3ff
> +
> +#define GPIOOFFSET	0x400
> +#define GPIOEND		0x7ff
> +
> +#define CHIPCTLOFFSET	0x800
> +#define CHIPCTLEND	0x8ff
> +#define CHIPCTLSIZE	(CHIPCTLEND - CHIPCTLOFFSET)
> +
> +#define INTCOFFSET	0xc00
> +#define INTCEND		0xfff
> +#define INTCSIZE	(INTCEND - INTCOFFSET)
> +
> +#define MOSTOFFSET	0x1000
> +#define MOSTEND		0x13ff
> +
> +#define UARTOFFSET	0x1400
> +#define UARTEND		0x17ff
> +
> +#define I2SOFFSET	0x1C00
> +#define I2SEND		0x1fff
> +
> +#define LOGIWOFFSET	0x30000
> +#define LOGIWEND	0x37fff
> +
> +#define DMAOFFSET	0x01000000
> +#define DMAEND		0x013fffff
> +
> +/* SDHC0 is placed in PCI bar 1 */
> +#define SDHC0OFFSET	0x00
> +#define SDHC0END	0xff
> +
> +/* SDHC1 is placed in PCI bar 2 */
> +#define SDHC1OFFSET	0x00
> +#define SDHC1END	0xff
> +
> +#define PCI_VENDOR_ID_TIMB	0x10ee
> +#define PCI_DEVICE_ID_TIMB	0xa123
> +#define DRV_VERSION		"0.1"
> +
> +
> +#define IRQ_TIMBERDALE_INIC	0
> +#define IRQ_TIMBERDALE_MLB	1
> +#define IRQ_TIMBERDALE_GPIO	2
> +#define IRQ_TIMBERDALE_I2C	3
> +#define IRQ_TIMBERDALE_UART	4
> +#define IRQ_TIMBERDALE_DMA	5
> +#define IRQ_TIMBERDALE_I2S	6
> +#define IRQ_TIMBERDALE_TSC_INT	7
> +#define IRQ_TIMBERDALE_SDHC	8
> +#define IRQ_TIMBERDALE_ADV7180	9
> +#define IRQ_TIMBERDALE_ETHSW_IF	10
> +#define IRQ_TIMBERDALE_SPI	11
> +
> +#define TIMBERDALE_NR_IRQS	12
> +
> +/* Some of the interrupts are level triggered, some are edge triggered */
> +#define IRQ_TIMBERDALE_EDGE_MASK ((1 << IRQ_TIMBERDALE_ADV7180) | \
> +	(1 << IRQ_TIMBERDALE_TSC_INT) | \
> +	(1 << IRQ_TIMBERDALE_MLB) | (1 << IRQ_TIMBERDALE_INIC))
> +
> +#define IRQ_TIMBERDALE_LEVEL_MASK ((1 << IRQ_TIMBERDALE_SPI) | \
> +	(1 << IRQ_TIMBERDALE_ETHSW_IF) | (1 << IRQ_TIMBERDALE_SDHC) | \
> +	(1 << IRQ_TIMBERDALE_I2S) | (1 << IRQ_TIMBERDALE_UART) | \
> +	(1 << IRQ_TIMBERDALE_I2C) | (1 << IRQ_TIMBERDALE_GPIO) | \
> +	(1 << IRQ_TIMBERDALE_DMA))
> +
> +#define GPIO_PIN_INIC_RST	14
> +#define GPIO_PIN_BT_RST		15
> +
> +
> +#endif
> +
> Index: linux-2.6.30-rc7/drivers/mfd/Makefile
> ===================================================================
> --- linux-2.6.30-rc7/drivers/mfd/Makefile	(revision 861)
> +++ linux-2.6.30-rc7/drivers/mfd/Makefile	(working copy)
> @@ -42,4 +42,5 @@
>  obj-$(CONFIG_PCF50633_ADC)	+= pcf50633-adc.o
>  obj-$(CONFIG_PCF50633_GPIO)	+= pcf50633-gpio.o
> 
> +obj-$(CONFIG_MFD_TIMBERDALE)		+= timberdale.o
>  obj-$(CONFIG_MFD_TIMBERDALE_DMA)	+= timbdma.o
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
