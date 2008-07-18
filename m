Return-Path: <linux-kernel-owner+w=401wt.eu-S1759723AbYGRWaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723AbYGRWaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYGRWab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:30:31 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:59378 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbYGRWaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:30:30 -0400
Date: Fri, 18 Jul 2008 15:23:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Piot Skamruk <piotr.skamruk@gmail.com>, openwrt-devel@lists.openwrt.org
Subject: Re: [PATCH v2] Add SPI over GPIO driver
Message-Id: <20080718152358.3d514b73.randy.dunlap@oracle.com>
In-Reply-To: <200807182159.03571.mb@bu3sch.de>
References: <200807182159.03571.mb@bu3sch.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008 21:59:03 +0200 Michael Buesch wrote:

> This adds a driver that lets you drive an SPI bus over
> generic GPIO pins.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> This driver is used in OpenWrt since quite some time, so please
> consider for inclusion in mainline.

diffstat here, please.

> Index: linux-next/include/linux/spi/spi_gpio.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-next/include/linux/spi/spi_gpio.h	2008-07-15 20:44:30.000000000 +0200
> @@ -0,0 +1,67 @@
> +/*
> + * spi_gpio interface to platform code
> + *
> + * Copyright (c) 2008 Piotr Skamruk
> + * Copyright (c) 2008 Michael Buesch
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef _LINUX_SPI_SPI_GPIO
> +#define _LINUX_SPI_SPI_GPIO
> +
> +#include <linux/types.h>
> +#include <linux/spi/spi.h>
> +
> +
> +/** struct spi_gpio_platform_data - Data definitions for a SPI-GPIO device.
> + * This structure holds information about a GPIO-based SPI device.

kernel-doc blocks begin with /** on a line by itself.  E.g.:

/**
 * struct spi_gpio_platform_data - blah


> + *
> + * @pin_clk: The GPIO pin number of the CLOCK pin.
> + *
> + * @pin_miso: The GPIO pin number of the MISO pin.
> + *
> + * @pin_mosi: The GPIO pin number of the MOSI pin.
> + *
> + * @pin_cs: The GPIO pin number of the CHIPSELECT pin.
> + *
> + * @cs_activelow: If true, the chip is selected when the CS line is low.
> + *
> + * @no_spi_delay: If true, no delay is done in the lowlevel bitbanging.
> + *                Note that doing no delay is not standards compliant,
> + *                but it might be needed to speed up transfers on some
> + *                slow embedded machines.
> + *
> + * @boardinfo_setup: This callback is called after the
> + *                   SPI master device was registered, but before the
> + *                   device is registered.
> + * @boardinfo_setup_data: Data argument passed to boardinfo_setup().
> + */
> +struct spi_gpio_platform_data {
> +	unsigned int pin_clk;
> +	unsigned int pin_miso;
> +	unsigned int pin_mosi;
> +	unsigned int pin_cs;
> +	bool cs_activelow;
> +	bool no_spi_delay;
> +	int (*boardinfo_setup)(struct spi_board_info *bi,
> +			       struct spi_master *master,
> +			       void *data);
> +	void *boardinfo_setup_data;
> +};
> +
> +/** SPI_GPIO_PLATDEV_NAME - The platform device name string.
> + * The name string that has to be used for platform_device_alloc
> + * when allocating a spi-gpio device.
> + */
> +#define SPI_GPIO_PLATDEV_NAME	"spi-gpio"
> +
> +/** spi_gpio_next_id - Get another platform device ID number.
> + * This returns the next platform device ID number that has to be used
> + * for platform_device_alloc. The ID is opaque and should not be used for
> + * anything else.
> + */
> +int spi_gpio_next_id(void);
> +
> +#endif /* _LINUX_SPI_SPI_GPIO */

> Index: linux-next/drivers/spi/Kconfig
> ===================================================================
> --- linux-next.orig/drivers/spi/Kconfig	2008-07-14 20:52:44.000000000 +0200
> +++ linux-next/drivers/spi/Kconfig	2008-07-14 20:52:48.000000000 +0200
> @@ -100,6 +100,19 @@ config SPI_BUTTERFLY
>  	  inexpensive battery powered microcontroller evaluation board.
>  	  This same cable can be used to flash new firmware.
>  
> +config SPI_GPIO
> +	tristate "GPIO API based bitbanging SPI controller"
> +	depends on SPI_MASTER && GENERIC_GPIO
> +	select SPI_BITBANG
> +	help
> +	  This is a platform driver that can be used for bitbanging
> +	  an SPI bus over GPIO pins.
> +	  Select this, if you have any SPI device that is connected via

No comma.

> +	  GPIO pins.
> +	  The module will be called spi_gpio.
> +
> +	  If unsure, say N.
> +
>  config SPI_IMX
>  	tristate "Freescale iMX SPI controller"
>  	depends on SPI_MASTER && ARCH_IMX && EXPERIMENTAL



---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
