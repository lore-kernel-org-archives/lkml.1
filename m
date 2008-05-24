Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbYEXFTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbYEXFTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 01:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYEXFTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 01:19:31 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:33500 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbYEXFT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 01:19:29 -0400
Message-ID: <fa686aa40805232219x7e888d80y394958f1c0a0fad0@mail.gmail.com>
Date: Fri, 23 May 2008 23:19:28 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Anton Vorontsov" <avorontsov@ru.mvista.com>
Subject: Re: [RFC PATCH 2/2] mmc: add OpenFirmware bindings for the mmc_spi driver
Cc: "Pierre Ossman" <drzeus-mmc@drzeus.cx>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Gary Jennejohn" <garyj@denx.de>,
       "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080523182842.GB469@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080523182754.GA26891@polina.dev.rtsoft.ru>
	 <20080523182842.GB469@polina.dev.rtsoft.ru>
X-Google-Sender-Auth: 89b876630ab8eba6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yup, I like this approach better.  I had been thinking about putting
this all in the same file (drivers/mmc/host/mmc_spi.c) instead of
exporting the probe/remove symbols and by using clear comment blocks
to divide the sections, but I've got no issues with this approach.

This is good work.  Some comments below.  (I won't repeat Stephen's comments)

On Fri, May 23, 2008 at 12:28 PM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> This patch depends on the Grant Likely's SPI patches, so this is
> for RFC only.
>
> Also, later we'll able to remove OF_GPIO dependency.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  Documentation/powerpc/booting-without-of.txt |   24 ++++
>  drivers/mmc/host/Kconfig                     |    7 ++
>  drivers/mmc/host/Makefile                    |    2 +-
>  drivers/mmc/host/of_mmc_spi.c                |  151 ++++++++++++++++++++++++++
>  4 files changed, 183 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/mmc/host/of_mmc_spi.c
>
> diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
> index 423cb2b..7d0ef80 100644
> --- a/Documentation/powerpc/booting-without-of.txt
> +++ b/Documentation/powerpc/booting-without-of.txt
> @@ -3151,7 +3151,31 @@ platforms are moved over to use the flattened-device-tree model.
>                        };
>                };
>
> +    ...) MMC-over-SPI
>
> +      Required properties:
> +      - #address-cells : should be 0.
> +      - #size-cells : should be 0.

Are these properties required at all?  Will this node have any children.

> +      - compatible : should be "linux,mmc-spi".
> +      - linux,modalias  - should be "of_mmc_spi".

I'm not even sure if the whole linux,modalias is even a good idea.  I
had kind of thrown it in there as a convenient way to override
compatible when needed, but I haven't really thought it out very well
and I think it is rather a hack.

The real problem is we don't yet have good method (or place) to apply
a translation table from compatible values to modaliases.  Ideally,
the translations should be part of the drivers themselves, but that
causes a chicken and egg problem of needing to load the driver to get
access to the table to know if it is the correct driver... Of course,
I'm really not very familiar with the whole module autoloading
mechanism.  Regardless; binding should be based on compatible, not on
a hacky and bogus linux,modalias property.

> +      - reg : should specify SPI address (chip-select number).
> +      - max-speed : (optional) maximum frequency for this device (Hz).
> +      - linux,mmc-ocr-mask : (optional) Linux-specific MMC OCR mask
> +        (slot voltage).

Should this property be better defined?

> +      - gpios : (optional) may specify GPIOs in this order: Write-Protect GPIO,
> +        Card-Detect GPIO.
> +
> +      Example:
> +
> +       mmc-slot@0 {
> +               compatible = "linux,mmc-spi";
> +               linux,modalias = "of_mmc_spi";
> +               reg = <0>;
> +               max-speed = <50000000>;
> +               linux,mmc-ocr-mask = <0x00200000>;
> +               gpios = <&sdcsr_pio 6 0   /*  WP */
> +                        &sdcsr_pio 7 1>; /* nCD */
> +       };
>
>  VII - Marvell Discovery mv64[345]6x System Controller chips
>  ===========================================================
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index dead617..f468544 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -130,3 +130,10 @@ config MMC_SPI
>
>          If unsure, or if your system has no SPI master driver, say N.
>
> +config OF_MMC_SPI
> +       tristate "MMC/SD over SPI OpenFirmware bindings"
> +       depends on MMC_SPI && SPI_MASTER_OF && OF_GPIO
> +       default y
> +       help
> +         Say Y here to enable OpenFirmware bindings for the MMC/SD over SPI
> +         driver.
> diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
> index 3877c87..d77f880 100644
> --- a/drivers/mmc/host/Makefile
> +++ b/drivers/mmc/host/Makefile
> @@ -17,4 +17,4 @@ obj-$(CONFIG_MMC_OMAP)                += omap.o
>  obj-$(CONFIG_MMC_AT91)         += at91_mci.o
>  obj-$(CONFIG_MMC_TIFM_SD)      += tifm_sd.o
>  obj-$(CONFIG_MMC_SPI)          += mmc_spi.o
> -
> +obj-$(CONFIG_OF_MMC_SPI)       += of_mmc_spi.o
> diff --git a/drivers/mmc/host/of_mmc_spi.c b/drivers/mmc/host/of_mmc_spi.c
> new file mode 100644
> index 0000000..b8211ce
> --- /dev/null
> +++ b/drivers/mmc/host/of_mmc_spi.c
> @@ -0,0 +1,151 @@
> +/*
> + * OpenFirmware bindings for the MMC-over-SPI driver
> + *
> + * Copyright (c) MontaVista Software, Inc. 2008.
> + *
> + * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/of_platform.h>
> +#include <linux/spi/spi.h>
> +#include <linux/spi/spi_of.h>
> +#include <linux/spi/mmc_spi.h>
> +#include <linux/mmc/host.h>
> +#include <linux/gpio.h>
> +#include <linux/of_gpio.h>
> +#include "mmc_spi.h"
> +
> +struct of_mmc_spi {
> +       int wp_gpio;
> +       int cd_gpio;
> +       struct mmc_spi_platform_data mmc_pdata;
> +};
> +
> +static int mmc_get_ro(struct device *dev)
> +{
> +       struct of_mmc_spi *oms = dev->archdata.of_node->data;
> +
> +       return gpio_get_value(oms->wp_gpio);
> +}
> +
> +static int mmc_get_cd(struct device *dev)
> +{
> +       struct of_mmc_spi *oms = dev->archdata.of_node->data;
> +
> +       return gpio_get_value(oms->cd_gpio);
> +}
> +
> +static int of_mmc_spi_probe(struct spi_device *spi)
> +{
> +       int ret = -EINVAL;
> +       struct device_node *np = spi->dev.archdata.of_node;
> +       struct device *dev = &spi->dev;
> +       struct of_mmc_spi *oms = kzalloc(sizeof(*oms), GFP_KERNEL);
> +       const u32 *ocr_mask;
> +       int size;
> +
> +       if (!oms)
> +               return -ENOMEM;
> +
> +       /* Somebody occupied node's data? */
> +       WARN_ON(spi->dev.archdata.of_node->data);

Perhaps bail at this point to avoid corruption?  Would it be better to
use container_of() instead for getting a pointer back to the private
structure from the pdata pointer?

> +
> +       /*
> +        * mmc_spi_probe will use drvdata, so we can't use it. Use node's
> +        * data instead.
> +        */
> +       spi->dev.archdata.of_node->data = oms;
> +
> +       /* We don't support interrupts yet, let's poll. */
> +       oms->mmc_pdata.caps |= MMC_CAP_NEEDS_POLL;
> +
> +       ocr_mask = of_get_property(np, "linux,mmc-ocr-mask", &size);
> +       if (ocr_mask && size >= sizeof(ocr_mask))
> +               oms->mmc_pdata.ocr_mask = *ocr_mask;
> +
> +       oms->wp_gpio = of_get_gpio(np, 0);
> +       if (gpio_is_valid(oms->wp_gpio)) {
> +               ret = gpio_request(oms->wp_gpio, dev->bus_id);
> +               if (ret < 0)
> +                       goto err_wp_gpio;
> +               oms->mmc_pdata.get_ro = &mmc_get_ro;
> +       }
> +
> +       oms->cd_gpio = of_get_gpio(np, 1);
> +       if (gpio_is_valid(oms->cd_gpio)) {
> +               ret = gpio_request(oms->cd_gpio, dev->bus_id);
> +               if (ret < 0)
> +                       goto err_cd_gpio;
> +               oms->mmc_pdata.get_cd = &mmc_get_cd;
> +       }
> +
> +       spi->dev.platform_data = &oms->mmc_pdata;
> +
> +       ret = mmc_spi_probe(spi);
> +       if (ret)
> +               goto err_mmc_spi;
> +
> +       return 0;
> +err_mmc_spi:
> +       if (gpio_is_valid(oms->cd_gpio))
> +               gpio_free(oms->cd_gpio);
> +err_cd_gpio:
> +       if (gpio_is_valid(oms->wp_gpio))
> +               gpio_free(oms->wp_gpio);
> +err_wp_gpio:
> +       spi->dev.archdata.of_node->data = NULL;
> +       kfree(oms);
> +       return ret;
> +}
> +
> +int __devexit of_mmc_spi_remove(struct spi_device *spi)
> +{
> +       struct of_mmc_spi *oms = spi->dev.archdata.of_node->data;
> +       int ret;
> +
> +       ret = mmc_spi_remove(spi);
> +       if (ret)
> +               return ret;
> +
> +       if (gpio_is_valid(oms->cd_gpio))
> +               gpio_free(oms->cd_gpio);
> +       if (gpio_is_valid(oms->wp_gpio))
> +               gpio_free(oms->wp_gpio);
> +
> +       spi->dev.archdata.of_node->data = NULL;
> +       kfree(oms);
> +       return 0;
> +}
> +
> +static struct spi_driver of_mmc_spi_driver = {
> +       .driver = {
> +               .name = "of_mmc_spi",
> +               .bus = &spi_bus_type,
> +               .owner = THIS_MODULE,
> +       },
> +       .probe = of_mmc_spi_probe,
> +       .remove = __devexit_p(of_mmc_spi_remove),
> +};
> +
> +static int __init of_mmc_spi_init(void)
> +{
> +       return spi_register_driver(&of_mmc_spi_driver);
> +}
> +module_init(of_mmc_spi_init);
> +
> +static void __exit of_mmc_spi_exit(void)
> +{
> +       spi_unregister_driver(&of_mmc_spi_driver);
> +}
> +module_exit(of_mmc_spi_exit);
> +
> +MODULE_DESCRIPTION("OpenFirmware bindings for the MMC-over-SPI driver");
> +MODULE_AUTHOR("Anton Vorontsov <avorontsov@ru.mvista.com>");
> +MODULE_LICENSE("GPL");
> --
> 1.5.5.1
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
