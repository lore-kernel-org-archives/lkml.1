Return-Path: <linux-kernel-owner+w=401wt.eu-S1756291AbYGDDzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbYGDDzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 23:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYGDDzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 23:55:06 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:62932 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbYGDDzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 23:55:05 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 4/5] spi: Add OF binding support for SPI busses
Date: Fri, 4 Jul 2008 11:54:57 +0800
Message-ID: <58A20A281BAF1047B4EAE68DE5C0BDC2010121B7@zch01exm21.fsl.freescale.net>
In-Reply-To: <20080703010313.26187.99119.stgit@trillian.secretlab.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 4/5] spi: Add OF binding support for SPI busses
Thread-Index: AcjcrAM4UszYWA5MQ2+v6L7LAvIWKQA3NlyQ
References: <20080703005749.26187.71719.stgit@trillian.secretlab.ca> <20080703010313.26187.99119.stgit@trillian.secretlab.ca>
From: "Chen Gong" <G.Chen@freescale.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Cc: <david-b@pacbell.net>, <fabrizio.garetto@gmail.com>,
       <linuxppc-dev@ozlabs.org>, <spi-devel-general@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: linuxppc-dev-bounces+b11801=freescale.com@ozlabs.org 
> [mailto:linuxppc-dev-bounces+b11801=freescale.com@ozlabs.org] 
> On Behalf Of Grant Likely
> Sent: 2008?7?3? 9:03
> To: linuxppc-dev@ozlabs.org; 
> spi-devel-general@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Cc: david-b@pacbell.net; fabrizio.garetto@gmail.com
> Subject: [PATCH v2 4/5] spi: Add OF binding support for SPI busses
> 
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> This patch adds support for populating an SPI bus based on data in the
> OF device tree.  This is useful for powerpc platforms which use the
> device tree instead of discrete code for describing platform layout.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
>  drivers/of/Kconfig     |    6 +++
>  drivers/of/Makefile    |    1 +
>  drivers/of/of_spi.c    |   88 
> ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_spi.h |   18 ++++++++++
>  4 files changed, 113 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index 3a7a11a..edd6e92 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -13,3 +13,9 @@ config OF_I2C
>  	depends on PPC_OF && I2C
>  	help
>  	  OpenFirmware I2C accessors
> +
> +config OF_SPI
> +	def_tristate SPI
> +	depends on OF && PPC_OF && SPI
> +	help
> +	  OpenFirmware SPI accessors
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index 548772e..4c3c6f8 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -2,3 +2,4 @@ obj-y = base.o
>  obj-$(CONFIG_OF_DEVICE) += device.o platform.o
>  obj-$(CONFIG_OF_GPIO)   += gpio.o
>  obj-$(CONFIG_OF_I2C)	+= of_i2c.o
> +obj-$(CONFIG_OF_SPI)	+= of_spi.o
> diff --git a/drivers/of/of_spi.c b/drivers/of/of_spi.c
> new file mode 100644
> index 0000000..ed0c807
> --- /dev/null
> +++ b/drivers/of/of_spi.c
> @@ -0,0 +1,88 @@
> +/*
> + * SPI OF support routines
> + * Copyright (C) 2008 Secret Lab Technologies Ltd.
> + *
> + * Support routines for deriving SPI device attachments from 
> the device
> + * tree.
> + */
> +
> +#include <linux/of.h>
> +#include <linux/device.h>
> +#include <linux/spi/spi.h>
> +#include <linux/of_spi.h>
> +
> +/**
> + * of_register_spi_devices - Register child devices onto the SPI bus
> + * @master:	Pointer to spi_master device
> + * @np:		parent node of SPI device nodes
> + *
> + * Registers an spi_device for each child node of 'np' which 
> has a 'reg'
> + * property.
> + */
> +void of_register_spi_devices(struct spi_master *master, 
> struct device_node *np)
> +{
> +	struct spi_device *spi;
> +	struct device_node *nc;
> +	const u32 *prop;
> +	const char *sprop;
> +	int rc;
> +	int len;
> +
> +	for_each_child_of_node(np, nc) {
> +		/* Alloc an spi_device */
> +		spi = spi_alloc_device(master);
> +		if (!spi) {
> +			dev_err(&master->dev, "spi_device alloc 
> error for %s\n",
> +				nc->full_name);
> +			continue;
> +		}
> +
> +		/* Device address */
> +		prop = of_get_property(nc, "reg", &len);
> +		if (!prop || len < sizeof(*prop)) {
> +			dev_err(&master->dev, "%s has no 'reg' 
> property\n",
> +				nc->full_name);
> +			continue;
> +		}
> +		spi->chip_select = *prop;
> +
> +		/* Mode (clock phase/polarity/etc.) */
> +		if (of_find_property(nc, "spi,cpha", NULL))
> +			spi->mode |= SPI_CPHA;
> +		if (of_find_property(nc, "spi,cpol", NULL))
> +			spi->mode |= SPI_CPOL;

so becuase in function spi_alloc_deive, spi is allocated by kzalloc,
how about writing as follows:
		/* Mode (clock phase/polarity/etc.) */
		prop = of_get_property(nc, "spi,cpha", NULL))
                        if (prop)
			spi->mode |= *prop;
		prop = of_get_property(nc, "spi,cpol", NULL))
                        if (prop)
			spi->mode |= *prop;

> +
> +		/* Device speed */
> +		prop = of_get_property(nc, "max-speed", &len);
> +		if (!prop || len < sizeof(*prop)) {
> +			dev_err(&master->dev, "%s has no 
> 'max-speed' property\n",
> +				nc->full_name);
> +			continue;
> +		}
> +		spi->max_speed_hz = *prop;
> +
> +		/* IRQ */
> +		spi->irq = irq_of_parse_and_map(nc, 0);
> +
> +		/* Select device driver */
> +		sprop = of_get_property(nc, "linux,modalias", &len);
> +		if (sprop && len > 0)
> +			strncpy(spi->modalias, sprop, KOBJ_NAME_LEN);
> +		else
> +			strncpy(spi->modalias, "spidev", KOBJ_NAME_LEN);
> +
 how about writing as follows:

		if (sprop && len > 0)
			strncpy(spi->modalias, sprop, KOBJ_NAME_LEN -
1);
		else
			strncpy(spi->modalias, "spidev", KOBJ_NAME_LEN -
1);
