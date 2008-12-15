Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYLOJCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYLOJCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 04:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYLOJCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 04:02:20 -0500
Received: from 89.6b.364a.static.theplanet.com ([74.54.107.137]:45994 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbYLOJCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 04:02:19 -0500
Message-ID: <49461CFB.9080108@compulab.co.il>
Date: Mon, 15 Dec 2008 11:01:47 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Liam Girdwood <lrg@kernel.org>, Mark Brown <broonie@sirena.org.uk>
Subject: Re: [PATCH] mfd: DA9030 USB charge pump mode selection support
References: <4943FA3E.9090507@cam.ac.uk>
In-Reply-To: <4943FA3E.9090507@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jonathan Cameron wrote:
> From: Jonathan Cameron <jic23@cam.ac.uk>
> 
> Add support for changing the mode of the da9030 usb charge pump
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> 
> --
> This simple driver is intended to allow board configs to control
> the mode in which the usb charge pump on th da9030 pmic is
> running (typically as part of usb enable callbacks).
> 
> The 3 options are:
> 
> auto - controlled entirely by hardware signals.
> 100mA charge pump manual enable
> 10mA current source manual enable 
> 
> Note this function is completely separate from the usb charging
> functionality (which will need a much more sophisticated driver).
> 
> As ever, all comments welcomed.
> 
> The main question on this is whether it should just be rolled into
> the core mfd driver.  I'm inclined to keep it separate and decidedly
> optional as the fact it isn't already in the driver implies that
> it may not be commonly used. (Intel Stargate 2 does need this
> functionality though, hence the submission as I'm hoping to get
> the relevant board code in soonish.)

I'm for adding "da9030_set_usb_charge_pump_mode" to the core mfd driver.

> I don't have the da9034 data sheet, so not a clue if this is
> relevant for that as well?
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
>  drivers/mfd/Kconfig              |    7 +++
>  drivers/mfd/Makefile             |    3 +-
>  drivers/mfd/da9030-usb.c         |   79 ++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/da9030-usbcp.h |   20 ++++++++++
>  4 files changed, 108 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 2572773..d53e82d 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -114,6 +114,13 @@ config PMIC_DA903X
>  	  individual components like LCD backlight, voltage regulators,
>  	  LEDs and battery-charger under the corresponding menus.
>  
> +config PMIC_DA9030_USBCP
> +       bool "DA9030 USB charge pump mode control"
> +       depends on PMIC_DA903X
> +       help
> +         Say yes here to support control of the USB charge pump on
> +	 the DA9030 PMIC.
> +
>  config MFD_WM8400
>  	tristate "Support Wolfson Microelectronics WM8400"
>  	depends on I2C
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 9a5ad8a..eeb86c9 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -31,4 +31,5 @@ obj-$(CONFIG_MCP_UCB1200)	+= ucb1x00-assabet.o
>  endif
>  obj-$(CONFIG_UCB1400_CORE)	+= ucb1400_core.o
>  
> -obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
> \ No newline at end of file
> +obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
> +obj-$(CONFIG_PMIC_DA9030_USBCP)	+= da9030-usb.o
> \ No newline at end of file
> diff --git a/drivers/mfd/da9030-usb.c b/drivers/mfd/da9030-usb.c
> new file mode 100644
> index 0000000..f1160c6
> --- /dev/null
> +++ b/drivers/mfd/da9030-usb.c
> @@ -0,0 +1,79 @@
> +/* mfd/da9030-usb.c
> + *
> + * Minimal control driver for the da9030 usb charge pump.
> + *
> + * Jonathan Cameron <jic23@cam.ac.uk> 2008
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/da903x.h>
> +#include <linux/mfd/da9030-usbcp.h>
> +
> +/* Single device assumption */
> +struct device *da9030_mfd;
> +
> +int da9030_set_usb_charge_pump_mode(int mode)
> +{
> +	uint8_t val = 0;
> +
> +	switch (mode) {
> +	case DA9030_USBPUMP_AUTO:
> +		val = 0;
> +		break;
> +	case DA9030_USBPUMP_CHARGE_PUMP:
> +		val = 0x40;
> +		break;
> +	case DA9030_USBPUMP_CURRENT_SOURCE:
> +		val = 0x80;
> +		break;
> +	}
> +
> +	return da903x_write(da9030_mfd, DA9030_USBPUMP_REG, val);
> +}
> +EXPORT_SYMBOL_GPL(da9030_set_usb_charge_pump_mode);
> +
> +static int __devinit da9030_usb_probe(struct platform_device *pdev)
> +{
> +	da9030_mfd = pdev->dev.parent;
> +
> +	return 0;
> +}
> +
> +static int __devexit da9030_usb_remove(struct platform_device *pdev)
> +{
> +	da9030_mfd = NULL;
> +	return 0;
> +}
> +
> +static struct platform_driver da9030_usb_driver = {
> +	.driver = {
> +		.name = "da9030-usb",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = da9030_usb_probe,
> +	.remove = __devexit_p(da9030_usb_remove),
> +};
> +
> +static int __init da9030_usb_init(void)
> +{
> +	return platform_driver_register(&da9030_usb_driver);
> +}
> +module_init(da9030_usb_init);
> +
> +static void __exit da9030_usb_exit(void)
> +{
> +	platform_driver_unregister(&da9030_usb_driver);
> +}
> +module_exit(da9030_usb_exit);
> +
> +MODULE_DESCRIPTION("USB charge pump control driver for Dialog DA9030");
> +MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform::da9030-usb");
> diff --git a/include/linux/mfd/da9030-usbcp.h b/include/linux/mfd/da9030-usbcp.h
> new file mode 100644
> index 0000000..62af5a7
> --- /dev/null
> +++ b/include/linux/mfd/da9030-usbcp.h
> @@ -0,0 +1,20 @@
> +/* linux/mfd/da9030-usbcp.h
> + *
> + * Minimal control driver for the da9030 usb charge pump.
> + *
> + * Jonathan Cameron <jic23@cam.ac.uk> 2008
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#define DA9030_USBPUMP_AUTO 1
> +#define DA9030_USBPUMP_CHARGE_PUMP 2
> +#define DA9030_USBPUMP_CURRENT_SOURCE 3
> +
> +#define DA9030_USBPUMP_REG 0x19
> +
> +int da9030_set_usb_charge_pump_mode(int mode);
> +
> +
> 

-- 
Sincerely yours,
Mike.

