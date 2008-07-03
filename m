Return-Path: <linux-kernel-owner+w=401wt.eu-S933050AbYGCHI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050AbYGCHI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYGCG5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:51 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:46313 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbYGCD0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 23:26:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UZV7wMvWSm57BeAQHibKdZJkVzdhPQi1birMpgB/EHyZK/0eg3wlKRHk1Tno1asgjG
         lQLnlu8VWtNJpoyzEtr+5O9+jcQ8QQ+ETMhQKbAnNbu9bwDra7QytIyZ+rBa74hP2nm7
         ETmrD509SPM251MbTOeEA7Yo9tolwL4id6TXI=
Message-ID: <9e4733910807022026r98f565brc84da873747a5631@mail.gmail.com>
Date: Wed, 2 Jul 2008 23:26:07 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Anton Vorontsov" <avorontsov@ru.mvista.com>
Subject: Re: [PATCH] [RFC v3] OF: OpenFirmware bindings for the mmc_spi driver
Cc: "Pierre Ossman" <drzeus-mmc@drzeus.cx>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Grant Likely" <grant.likely@secretlab.ca>,
       "Jochen Friedrich" <jochen@scram.de>,
       "Segher Boessenkool" <segher@kernel.crashing.org>,
       "Gary Jennejohn" <garyj@denx.de>,
       "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080605161624.GA517@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080605161624.GA517@polina.dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/08, Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> Here is v3. I'm out of ideas if you won't like it. :-)
>
>  v3:
>  - Now these bindings are using bus notifiers chain, thus we adhere to the
>   spi bus.
>
>   By the way, this scheme (IMO) looks good for I2C devices which needs
>   platform_data extracted from the device tree too (Cc'ing Jochen).
>
>  - Plus changed the OF bindings themselves, implemented voltage-range
>   property. (Pierre, please take a look at vddrange_to_ocrmask(). I
>   wonder if you would like this in the MMC core instead, with a kernel
>   doc, of course.)
>
>  v2:
>  - Bindings were adhered to the MMC_SPI driver. Withdrawn by Pierre Ossman.
>
>  v1:
>  - Bindings were adhered to the OF SPI core. Withdrawn by OF people.
>
>  Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
>  ---
>   Documentation/powerpc/booting-without-of.txt |   21 +++
>   drivers/of/Kconfig                           |    8 +
>   drivers/of/Makefile                          |    1 +
>   drivers/of/of_mmc_spi.c                      |  210 ++++++++++++++++++++++++++
>   4 files changed, 240 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/of/of_mmc_spi.c
>
>  diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
>  index 6e1711c..6c55f3f 100644
>  --- a/Documentation/powerpc/booting-without-of.txt
>  +++ b/Documentation/powerpc/booting-without-of.txt
>  @@ -3143,7 +3143,28 @@ platforms are moved over to use the flattened-device-tree model.
>                         };
>                 };
>
>  +    ...) MMC-over-SPI
>
>  +      Required properties:
>  +      - compatible : should be "mmc-spi".
>  +      - reg : should specify SPI address (chip-select number).
>  +      - max-speed : (optional) maximum frequency for this device (Hz).
>  +      - voltage-range : two cells are required, first cell specifies minimum
>  +        slot voltage (mV), second cell specifies maximum slot voltage (mV).
>  +      - gpios : (optional) may specify GPIOs in this order: Write-Protect GPIO,
>  +        Card-Detect GPIO.
>  +
>  +      Example:
>  +
>  +       mmc-slot@0 {
>  +               compatible = "mmc-spi";
>  +               reg = <0>;
>  +               max-speed = <50000000>;
>  +               /* Unregulated slot. */
>  +               voltage-range = <3300 3300>;
>  +               gpios = <&sdcsr_pio 1 0   /*  WP */
>  +                        &sdcsr_pio 0 1>; /* nCD */
>  +       };
>
>   VII - Marvell Discovery mv64[345]6x System Controller chips
>   ===========================================================
>  diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
>  index 3a7a11a..aadbfb3 100644
>  --- a/drivers/of/Kconfig
>  +++ b/drivers/of/Kconfig
>  @@ -13,3 +13,11 @@ config OF_I2C
>         depends on PPC_OF && I2C
>         help
>           OpenFirmware I2C accessors
>  +
>  +config OF_MMC_SPI
>  +       bool "OpenFirmware bindings for MMC/SD over SPI"
>  +       depends on PPC_OF && SPI
>  +       default y if MMC_SPI
>  +       help
>  +         Say Y here to enable OpenFirmware bindings for the MMC/SD over SPI
>  +         driver.
>  diff --git a/drivers/of/Makefile b/drivers/of/Makefile
>  index 548772e..a7c44fc 100644
>  --- a/drivers/of/Makefile
>  +++ b/drivers/of/Makefile
>  @@ -2,3 +2,4 @@ obj-y = base.o
>   obj-$(CONFIG_OF_DEVICE) += device.o platform.o
>   obj-$(CONFIG_OF_GPIO)   += gpio.o
>   obj-$(CONFIG_OF_I2C)   += of_i2c.o
>  +obj-$(CONFIG_OF_MMC_SPI)       += of_mmc_spi.o
>  diff --git a/drivers/of/of_mmc_spi.c b/drivers/of/of_mmc_spi.c
>  new file mode 100644
>  index 0000000..aa4e017
>  --- /dev/null
>  +++ b/drivers/of/of_mmc_spi.c
>  @@ -0,0 +1,210 @@
>  +/*
>  + * OpenFirmware bindings for the MMC-over-SPI driver
>  + *
>  + * Copyright (c) MontaVista Software, Inc. 2008.
>  + *
>  + * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
>  + *
>  + * This program is free software; you can redistribute  it and/or modify it
>  + * under  the terms of  the GNU General  Public License as published by the
>  + * Free Software Foundation;  either version 2 of the  License, or (at your
>  + * option) any later version.
>  + */
>  +
>  +#include <linux/init.h>
>  +#include <linux/device.h>
>  +#include <linux/notifier.h>
>  +#include <linux/gpio.h>
>  +#include <linux/of.h>
>  +#include <linux/of_gpio.h>
>  +#include <linux/of_platform.h>
>  +#include <linux/spi/spi.h>
>  +#include <linux/spi/mmc_spi.h>
>  +#include <linux/mmc/host.h>
>  +
>  +/*
>  + * XXX: Place it somewhere in the generic MMC code?
>  + */
>  +static int vdd_to_bitnum(int vdd)
>  +{
>  +       int bit;
>  +       const int max_bit = ilog2(MMC_VDD_35_36);
>  +
>  +       if (vdd < 1650 || vdd > 3600)
>  +               return -EINVAL;
>  +
>  +       if (vdd >= 1650 && vdd <= 1950)
>  +               return ilog2(MMC_VDD_165_195);
>  +
>  +       /* base 2000 mV, step 100 mV, bit's base 8 */
>  +       bit = (vdd - 2000) / 100 + 8;
>  +       if (bit > max_bit)
>  +               return max_bit;
>  +       return bit;
>  +}
>  +
>  +static int vddrange_to_ocrmask(int vdd_min, int vdd_max, unsigned int *mask)
>  +{
>  +       if (vdd_max < vdd_min)
>  +               return -EINVAL;
>  +
>  +       vdd_max = vdd_to_bitnum(vdd_max);
>  +       if (vdd_max < 0)
>  +               return -EINVAL;
>  +
>  +       vdd_min = vdd_to_bitnum(vdd_min);
>  +       if (vdd_min < 0)
>  +               return -EINVAL;
>  +
>  +       /* fill the mask, from max bit to min bit */
>  +       while (vdd_max >= vdd_min)
>  +               *mask |= 1 << vdd_max--;
>  +       return 0;
>  +}
>  +
>  +struct of_mmc_spi {
>  +       int wp_gpio;
>  +       int cd_gpio;
>  +       struct mmc_spi_platform_data mmc_pdata;
>  +};
>  +
>  +static struct of_mmc_spi *to_of_mmc_spi(struct device *dev)
>  +{
>  +       return container_of(dev->platform_data, struct of_mmc_spi, mmc_pdata);
>  +}
>  +
>  +static int mmc_get_ro(struct device *dev)
>  +{
>  +       struct of_mmc_spi *oms = to_of_mmc_spi(dev);
>  +
>  +       return gpio_get_value(oms->wp_gpio);
>  +}
>  +
>  +static int mmc_get_cd(struct device *dev)
>  +{
>  +       struct of_mmc_spi *oms = to_of_mmc_spi(dev);
>  +
>  +       return gpio_get_value(oms->cd_gpio);
>  +}
>  +
>  +static int of_mmc_spi_add(struct device *dev)
>  +{
>  +       int ret = -EINVAL;
>  +       struct device_node *np = dev->archdata.of_node;
>  +       struct of_mmc_spi *oms;
>  +       const u32 *voltage_range;
>  +       int size;
>  +
>  +       if (!np || !of_device_is_compatible(np, "mmc-spi"))
>  +               return NOTIFY_DONE;
>  +
>  +       oms = kzalloc(sizeof(*oms), GFP_KERNEL);
>  +       if (!oms)
>  +               return notifier_to_errno(-ENOMEM);
>  +
>  +       /* We don't support interrupts yet, let's poll. */
>  +       oms->mmc_pdata.caps |= MMC_CAP_NEEDS_POLL;
>  +
>  +       voltage_range = of_get_property(np, "voltage-range", &size);
>  +       if (!voltage_range || size < sizeof(*voltage_range) * 2) {
>  +               dev_err(dev, "OF: voltage-range unspecified\n");
>  +               goto err_ocr;
>  +       }
>  +
>  +       ret = vddrange_to_ocrmask(voltage_range[0], voltage_range[1],
>  +                                 &oms->mmc_pdata.ocr_mask);
>  +       if (ret) {
>  +               dev_err(dev, "OF: specified voltage-range is invalid\n");
>  +               goto err_ocr;
>  +       }
>  +
>  +       oms->wp_gpio = of_get_gpio(np, 0);
>  +       if (gpio_is_valid(oms->wp_gpio)) {
>  +               ret = gpio_request(oms->wp_gpio, dev->bus_id);
>  +               if (ret < 0)
>  +                       goto err_wp_gpio;
>  +               oms->mmc_pdata.get_ro = &mmc_get_ro;
>  +       }
>  +
>  +       oms->cd_gpio = of_get_gpio(np, 1);
>  +       if (gpio_is_valid(oms->cd_gpio)) {
>  +               ret = gpio_request(oms->cd_gpio, dev->bus_id);
>  +               if (ret < 0)
>  +                       goto err_cd_gpio;
>  +               oms->mmc_pdata.get_cd = &mmc_get_cd;
>  +       }
>  +
>  +       dev->platform_data = &oms->mmc_pdata;
>  +
>  +       return NOTIFY_STOP;
>  +
>  +err_cd_gpio:
>  +       if (gpio_is_valid(oms->wp_gpio))
>  +               gpio_free(oms->wp_gpio);
>  +err_wp_gpio:
>  +err_ocr:
>  +       kfree(oms);
>  +       return notifier_to_errno(ret);
>  +}
>  +
>  +static int of_mmc_spi_del(struct device *dev)
>  +{
>  +       struct device_node *np = dev->archdata.of_node;
>  +       struct of_mmc_spi *oms;
>  +
>  +       if (!np || !of_device_is_compatible(np, "mmc-spi") ||
>  +                       !dev->platform_data)
>  +               return NOTIFY_DONE;
>  +
>  +       oms = to_of_mmc_spi(dev);
>  +
>  +       if (gpio_is_valid(oms->cd_gpio))
>  +               gpio_free(oms->cd_gpio);
>  +       if (gpio_is_valid(oms->wp_gpio))
>  +               gpio_free(oms->wp_gpio);
>  +
>  +       kfree(oms);
>  +       return NOTIFY_STOP;
>  +}
>  +
>  +static int of_mmc_spi_notify(struct notifier_block *nb, unsigned long action,
>  +                            void *_dev)
>  +{
>  +       struct device *dev = _dev;
>  +
>  +       switch (action) {
>  +       case BUS_NOTIFY_ADD_DEVICE:
>  +               return of_mmc_spi_add(dev);
>  +       case BUS_NOTIFY_DEL_DEVICE:
>  +               return of_mmc_spi_del(dev);
>  +       };
>  +       return NOTIFY_DONE;
>  +}
>  +
>  +static struct notifier_block of_mmc_spi_notifier = {
>  +       .notifier_call = of_mmc_spi_notify,
>  +};
>  +
>  +/*
>  + * Should be called early enough, but after SPI core initializes. So, we
>  + * use subsys_initcall (as in the SPI core), and link order guaranties
>  + * that we'll be called at the right time.
>  + */

Why does this need to be loaded at subsys_initcall time? We have the
equivalent code on i2c loading as a normal module.

When the spi bus driver code is processing the child SPI device nodes,
it should request_module() this driver as a module. I made a note to
fix that on Grant's SPI bus driver.

		spi@f00 {
			#address-cells = <1>;
			#size-cells = <0>;
			compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
Triggers loading of Grant's SPI module via normal OF module mechanism
			reg = <0xf00 0x20>;
			interrupts = <0x2 0xd 0x0 0x2 0xe 0x0>;
			interrupt-parent = <&mpc5200_pic>;
			
Grant's code loops through the child nodes
			mmc-slot@0 {
				compatible = "mmc-spi";
Finds this and does request_module("mmc-spi");
Then it registers the device
				reg = <0>;
				max-speed = <50000000>;
				/* Unregulated slot. */
				voltage-range = <3300 3300>;
				/*gpios = <&sdcsr_pio 1 0   /*  WP */
				/*		 &sdcsr_pio 0 1>; /* nCD */
			};			
		};

As part of this module's initialization it may need to request_module
generic mmc core module, but I haven't traced things out that far yet.
None of these parts should need to be compiled in, they should all be
capable of being loaded as a modules.

>  +static int __init of_mmc_spi_init(void)
>  +{
>  +       int ret;
>  +
>  +       ret = bus_register_notifier(&spi_bus_type, &of_mmc_spi_notifier);
>  +       if (ret) {
>  +               pr_err("%s: unable to register notifier on the spi bus\n",
>  +                       __func__);
>  +               return ret;
>  +       }
>  +
>  +       return 0;
>  +}
>  +subsys_initcall(of_mmc_spi_init);
>  +
>  +MODULE_DESCRIPTION("OpenFirmware bindings for the MMC-over-SPI driver");
>  +MODULE_AUTHOR("Anton Vorontsov <avorontsov@ru.mvista.com>");
>  +MODULE_LICENSE("GPL");
>  --
>  1.5.5.1
>
> --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Jon Smirl
jonsmirl@gmail.com
