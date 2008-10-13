Return-Path: <linux-kernel-owner+w=401wt.eu-S1758345AbYJMOw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345AbYJMOw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbYJMOws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:52:48 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:58097 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbYJMOwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:52:47 -0400
Date: Mon, 13 Oct 2008 16:52:42 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Add placeholders for WM8350 client devices
Message-ID: <20081013145241.GC4759@localdomain>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20081013133707.GA4759@localdomain> <1223909123-16376-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223909123-16376-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 03:45:22PM +0100, Mark Brown wrote:
> In order to avoid merge problems further down the line add placeholders
> for several of the WM8350 client devices and register them, otherwise
> the patches adding the client devices will all try to update the same
> code.
> 
> Also remove redundant checks for null regulator platform devices while
> we're at it.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Samuel Ortiz <sameo@openedhand.com>

Thanks Mark.

Cheers,
Samuel.

> ---
>  drivers/mfd/wm8350-core.c         |   18 ++++++++++++++++--
>  include/linux/mfd/wm8350/audio.h  |    6 ++++++
>  include/linux/mfd/wm8350/core.h   |   10 ++++++++++
>  include/linux/mfd/wm8350/gpio.h   |    6 ++++++
>  include/linux/mfd/wm8350/rtc.h    |    6 ++++++
>  include/linux/mfd/wm8350/supply.h |    6 ++++++
>  include/linux/mfd/wm8350/wdt.h    |    8 +++++++-
>  7 files changed, 57 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
> index cd1f76e..382e38c 100644
> --- a/drivers/mfd/wm8350-core.c
> +++ b/drivers/mfd/wm8350-core.c
> @@ -1234,6 +1234,15 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
>  
>  	wm8350_reg_write(wm8350, WM8350_SYSTEM_INTERRUPTS_MASK, 0x0);
>  
> +	wm8350_client_dev_register(wm8350, "wm8350-codec",
> +				   &(wm8350->codec.pdev));
> +	wm8350_client_dev_register(wm8350, "wm8350-gpio",
> +				   &(wm8350->gpio.pdev));
> +	wm8350_client_dev_register(wm8350, "wm8350-power",
> +				   &(wm8350->power.pdev));
> +	wm8350_client_dev_register(wm8350, "wm8350-rtc", &(wm8350->rtc.pdev));
> +	wm8350_client_dev_register(wm8350, "wm8350-wdt", &(wm8350->wdt.pdev));
> +
>  	return 0;
>  
>  err:
> @@ -1247,8 +1256,13 @@ void wm8350_device_exit(struct wm8350 *wm8350)
>  	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(wm8350->pmic.pdev); i++)
> -		if (wm8350->pmic.pdev[i] != NULL)
> -			platform_device_unregister(wm8350->pmic.pdev[i]);
> +		platform_device_unregister(wm8350->pmic.pdev[i]);
> +
> +	platform_device_unregister(wm8350->wdt.pdev);
> +	platform_device_unregister(wm8350->rtc.pdev);
> +	platform_device_unregister(wm8350->power.pdev);
> +	platform_device_unregister(wm8350->gpio.pdev);
> +	platform_device_unregister(wm8350->codec.pdev);
>  
>  	free_irq(wm8350->chip_irq, wm8350);
>  	flush_work(&wm8350->irq_work);
> diff --git a/include/linux/mfd/wm8350/audio.h b/include/linux/mfd/wm8350/audio.h
> index 43342f7..217bb22 100644
> --- a/include/linux/mfd/wm8350/audio.h
> +++ b/include/linux/mfd/wm8350/audio.h
> @@ -13,6 +13,8 @@
>  #ifndef __LINUX_MFD_WM8350_AUDIO_H_
>  #define __LINUX_MFD_WM8350_AUDIO_H_
>  
> +#include <linux/platform_device.h>
> +
>  #define WM8350_CLOCK_CONTROL_1                  0x28
>  #define WM8350_CLOCK_CONTROL_2                  0x29
>  #define WM8350_FLL_CONTROL_1                    0x2A
> @@ -589,4 +591,8 @@
>  #define WM8350_IRQ_CODEC_MICSCD			41
>  #define WM8350_IRQ_CODEC_MICD			42
>  
> +struct wm8350_codec {
> +	struct platform_device *pdev;
> +};
> +
>  #endif
> diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
> index 348101c..6ebf97f 100644
> --- a/include/linux/mfd/wm8350/core.h
> +++ b/include/linux/mfd/wm8350/core.h
> @@ -17,7 +17,12 @@
>  #include <linux/mutex.h>
>  #include <linux/workqueue.h>
>  
> +#include <linux/mfd/wm8350/audio.h>
> +#include <linux/mfd/wm8350/gpio.h>
>  #include <linux/mfd/wm8350/pmic.h>
> +#include <linux/mfd/wm8350/rtc.h>
> +#include <linux/mfd/wm8350/supply.h>
> +#include <linux/mfd/wm8350/wdt.h>
>  
>  /*
>   * Register values.
> @@ -574,7 +579,12 @@ struct wm8350 {
>  	int chip_irq;
>  
>  	/* Client devices */
> +	struct wm8350_codec codec;
> +	struct wm8350_gpio gpio;
>  	struct wm8350_pmic pmic;
> +	struct wm8350_power power;
> +	struct wm8350_rtc rtc;
> +	struct wm8350_wdt wdt;
>  };
>  
>  /**
> diff --git a/include/linux/mfd/wm8350/gpio.h b/include/linux/mfd/wm8350/gpio.h
> index c6cd2ca..ed91e8f 100644
> --- a/include/linux/mfd/wm8350/gpio.h
> +++ b/include/linux/mfd/wm8350/gpio.h
> @@ -13,6 +13,8 @@
>  #ifndef __LINUX_MFD_WM8350_GPIO_H_
>  #define __LINUX_MFD_WM8350_GPIO_H_
>  
> +#include <linux/platform_device.h>
> +
>  /*
>   * GPIO Registers.
>   */
> @@ -328,6 +330,10 @@ struct wm8350;
>  int wm8350_gpio_config(struct wm8350 *wm8350, int gpio, int dir, int func,
>  		       int pol, int pull, int invert, int debounce);
>  
> +struct wm8350_gpio {
> +	struct platform_device *pdev;
> +};
> +
>  /*
>   * GPIO Interrupts
>   */
> diff --git a/include/linux/mfd/wm8350/rtc.h b/include/linux/mfd/wm8350/rtc.h
> index cb337ea..dfda69e 100644
> --- a/include/linux/mfd/wm8350/rtc.h
> +++ b/include/linux/mfd/wm8350/rtc.h
> @@ -12,6 +12,8 @@
>  #ifndef __LINUX_MFD_WM8350_RTC_H
>  #define __LINUX_MFD_WM8350_RTC_H
>  
> +#include <linux/platform_device.h>
> +
>  /*
>   * Register values.
>   */
> @@ -257,4 +259,8 @@
>  #define WM8350_IRQ_RTC_SEC			8
>  #define WM8350_IRQ_RTC_ALM			9
>  
> +struct wm8350_rtc {
> +	struct platform_device *pdev;
> +};
> +
>  #endif
> diff --git a/include/linux/mfd/wm8350/supply.h b/include/linux/mfd/wm8350/supply.h
> index f1d4317..1c8f3cd 100644
> --- a/include/linux/mfd/wm8350/supply.h
> +++ b/include/linux/mfd/wm8350/supply.h
> @@ -13,6 +13,8 @@
>  #ifndef __LINUX_MFD_WM8350_SUPPLY_H_
>  #define __LINUX_MFD_WM8350_SUPPLY_H_
>  
> +#include <linux/platform_device.h>
> +
>  /*
>   * Charger registers
>   */
> @@ -102,4 +104,8 @@
>  #define WM8350_IRQ_EXT_WALL_FB			37
>  #define WM8350_IRQ_EXT_BAT_FB			38
>  
> +struct wm8350_power {
> +	struct platform_device *pdev;
> +};
> +
>  #endif
> diff --git a/include/linux/mfd/wm8350/wdt.h b/include/linux/mfd/wm8350/wdt.h
> index 72fc9f5..f6135b5 100644
> --- a/include/linux/mfd/wm8350/wdt.h
> +++ b/include/linux/mfd/wm8350/wdt.h
> @@ -1,7 +1,7 @@
>  /*
>   * wdt.h  --  Watchdog Driver for Wolfson WM8350 PMIC
>   *
> - * Copyright 2007 Wolfson Microelectronics PLC
> + * Copyright 2007, 2008 Wolfson Microelectronics PLC
>   *
>   *  This program is free software; you can redistribute  it and/or modify it
>   *  under  the terms of  the GNU General  Public License as published by the
> @@ -12,6 +12,8 @@
>  #ifndef __LINUX_MFD_WM8350_WDT_H_
>  #define __LINUX_MFD_WM8350_WDT_H_
>  
> +#include <linux/platform_device.h>
> +
>  #define WM8350_WDOG_HIB_MODE                    0x0080
>  #define WM8350_WDOG_DEBUG                       0x0040
>  #define WM8350_WDOG_MODE_MASK                   0x0030
> @@ -19,4 +21,8 @@
>  
>  #define WM8350_IRQ_SYS_WDOG_TO			24
>  
> +struct wm8350_wdt {
> +	struct platform_device *pdev;
> +};
> +
>  #endif
> -- 
> 1.5.6.5
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
