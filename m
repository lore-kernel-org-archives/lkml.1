Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYJ1Ojo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYJ1Ojo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYJ1Ojg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:39:36 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:57002 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752381AbYJ1Ojf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:39:35 -0400
Date: Tue, 28 Oct 2008 17:39:33 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Richard Purdie <rpurdie@rpsys.net>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/4] of_gpio: Return GPIO flags from of_get_gpio()
Message-ID: <20081028143933.GA18453@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <Pine.LNX.4.64.0810241442240.3790@t2.domain.actdsltmp> <1224889741-4167-1-git-send-email-tpiepho@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <1224889741-4167-1-git-send-email-tpiepho@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 04:08:58PM -0700, Trent Piepho wrote:
> The device binding spec for OF GPIOs defines a flags field, but there is
> currently no way to get it.  This patch adds a parameter to of_get_gpio()
> where the flags will be returned if non-NULL.  of_get_gpio() in turn passes
> the parameter to the of_gpio_chip's xlate method, which can extract any
> flags present from the gpio_spec.
> 
> The default (and currently only) of_gpio_chip xlate method,
> of_gpio_simple_xlate(), is modified to do this.

Looks good. Few comments below.

> Signed-off-by: Trent Piepho <tpiepho@freescale.com>
> ---
>  drivers/mtd/nand/fsl_upm.c              |    2 +-
>  drivers/net/fs_enet/fs_enet-main.c      |    2 +-
>  drivers/net/phy/mdio-ofgpio.c           |    4 ++--
>  drivers/of/gpio.c                       |   13 ++++++++++---
>  drivers/serial/cpm_uart/cpm_uart_core.c |    2 +-
>  include/linux/of_gpio.h                 |   17 +++++++++++++----
>  6 files changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/mtd/nand/fsl_upm.c b/drivers/mtd/nand/fsl_upm.c
> index 024e3ff..a25d962 100644
> --- a/drivers/mtd/nand/fsl_upm.c
> +++ b/drivers/mtd/nand/fsl_upm.c

[...]
> @@ -59,7 +60,9 @@ int of_get_gpio(struct device_node *np, int index)
>  		goto err1;
>  	}
>  
> -	ret = of_gc->xlate(of_gc, np, gpio_spec);
> +	if (flags)
> +		*flags = 0;
> +	ret = of_gc->xlate(of_gc, np, gpio_spec, flags);
>  	if (ret < 0)
>  		goto err1;
>  
> @@ -77,19 +80,23 @@ EXPORT_SYMBOL(of_get_gpio);
>   * @of_gc:	pointer to the of_gpio_chip structure
>   * @np:		device node of the GPIO chip
>   * @gpio_spec:	gpio specifier as found in the device tree
> + * @flags:	if non-NUll flags are returned here

NULL, not NUll.

>   *
>   * This is simple translation function, suitable for the most 1:1 mapped
>   * gpio chips. This function performs only one sanity check: whether gpio
>   * is less than ngpios (that is specified in the gpio_chip).
>   */
>  int of_gpio_simple_xlate(struct of_gpio_chip *of_gc, struct device_node *np,
> -			 const void *gpio_spec)
> +			 const void *gpio_spec, unsigned int *flags)

Why you made it unsigned int? In my original patch, I used
named enum, which is self-documenting type.

>  {
>  	const u32 *gpio = gpio_spec;
>  
>  	if (*gpio > of_gc->gc.ngpio)
>  		return -EINVAL;
>  
> +	if (flags && of_gc->gpio_cells > 1)
> +		*flags = gpio[1];
> +
>  	return *gpio;
>  }
>  EXPORT_SYMBOL(of_gpio_simple_xlate);
> diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/serial/cpm_uart/cpm_uart_core.c
> index bde4b4b..7835cd4 100644
> --- a/drivers/serial/cpm_uart/cpm_uart_core.c
> +++ b/drivers/serial/cpm_uart/cpm_uart_core.c
> @@ -1094,7 +1094,7 @@ static int cpm_uart_init_port(struct device_node *np,
>  	}
>  
>  	for (i = 0; i < NUM_GPIOS; i++)
> -		pinfo->gpios[i] = of_get_gpio(np, i);
> +		pinfo->gpios[i] = of_get_gpio(np, i, NULL);
>  
>  	return cpm_uart_request_port(&pinfo->port);
>  
> diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
> index 67db101..0d332bf 100644
> --- a/include/linux/of_gpio.h
> +++ b/include/linux/of_gpio.h
> @@ -26,7 +26,7 @@ struct of_gpio_chip {
>  	struct gpio_chip gc;
>  	int gpio_cells;
>  	int (*xlate)(struct of_gpio_chip *of_gc, struct device_node *np,
> -		     const void *gpio_spec);
> +		     const void *gpio_spec, unsigned int *flags);
>  };
>  
>  static inline struct of_gpio_chip *to_of_gpio_chip(struct gpio_chip *gc)
> @@ -35,6 +35,14 @@ static inline struct of_gpio_chip *to_of_gpio_chip(struct gpio_chip *gc)
>  }
>  
>  /*
> + * Flags as returned by OF GPIO chip's xlate function.
> + * These do not need to be the same as the flags in the GPIO specifier in the
> + * OF device tree, but it's convenient if they are.  The mm chip OF GPIO
> + * driver works this way.

This is not of_mm_gpio_chip specific.

> + */
> +#define OF_GPIO_ACTIVE_LOW	1
> +
> +/*
>   * OF GPIO chip for memory mapped banks
>   */
>  struct of_mm_gpio_chip {
> @@ -50,16 +58,17 @@ static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
>  	return container_of(of_gc, struct of_mm_gpio_chip, of_gc);
>  }
>  
> -extern int of_get_gpio(struct device_node *np, int index);
> +extern int of_get_gpio(struct device_node *np, int index, unsigned int *flags);
>  extern int of_mm_gpiochip_add(struct device_node *np,
>  			      struct of_mm_gpio_chip *mm_gc);
>  extern int of_gpio_simple_xlate(struct of_gpio_chip *of_gc,
>  				struct device_node *np,
> -				const void *gpio_spec);
> +				const void *gpio_spec, unsigned int *flags);
>  #else
>  
>  /* Drivers may not strictly depend on the GPIO support, so let them link. */
> -static inline int of_get_gpio(struct device_node *np, int index)
> +static inline int of_get_gpio(struct device_node *np, int index,
> +			      unsigned int *flags)
>  {
>  	return -ENOSYS;
>  }
> -- 
> 1.5.4.3

Can you repost a fixed version with my Ack and Cc: Andrew Morton,
Benjamin Herrenschmidt?

I think this change should go into the 2.6.28, so that we can
write new code on top of new API. Otherwise this change will cause
issues in the next merge window.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
