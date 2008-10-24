Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbYJXXdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbYJXXdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYJXXcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:32:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:3217 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYJXXcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:32:53 -0400
Message-ID: <fa686aa40810241632j1382f76ah9cd3e66b747bf8c0@mail.gmail.com>
Date: Fri, 24 Oct 2008 17:32:52 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Trent Piepho" <tpiepho@freescale.com>
Subject: Re: [PATCH 1/4] of_gpio: Return GPIO flags from of_get_gpio()
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       "Anton Vorontsov" <avorontsov@ru.mvista.com>,
       "Richard Purdie" <rpurdie@rpsys.net>,
       "Sean MacLennan" <smaclennan@pikatech.com>,
       "Wolfram Sang" <w.sang@pengutronix.de>
In-Reply-To: <1224889741-4167-1-git-send-email-tpiepho@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0810241442240.3790@t2.domain.actdsltmp>
	 <1224889741-4167-1-git-send-email-tpiepho@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 5:08 PM, Trent Piepho <tpiepho@freescale.com> wrote:
> The device binding spec for OF GPIOs defines a flags field, but there is
> currently no way to get it.  This patch adds a parameter to of_get_gpio()
> where the flags will be returned if non-NULL.  of_get_gpio() in turn passes
> the parameter to the of_gpio_chip's xlate method, which can extract any
> flags present from the gpio_spec.
>
> The default (and currently only) of_gpio_chip xlate method,
> of_gpio_simple_xlate(), is modified to do this.
>
> Signed-off-by: Trent Piepho <tpiepho@freescale.com>

This looks sane to me

Acked-by: Grant Likely <grant.likely@secretlab.ca>

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
> @@ -218,7 +218,7 @@ static int __devinit fun_probe(struct of_device *ofdev,
>        }
>        fun->upm_cmd_offset = *prop;
>
> -       fun->rnb_gpio = of_get_gpio(ofdev->node, 0);
> +       fun->rnb_gpio = of_get_gpio(ofdev->node, 0, NULL);
>        if (fun->rnb_gpio >= 0) {
>                ret = gpio_request(fun->rnb_gpio, ofdev->dev.bus_id);
>                if (ret) {
> diff --git a/drivers/net/fs_enet/fs_enet-main.c b/drivers/net/fs_enet/fs_enet-main.c
> index cb51c1f..5a3c7ee 100644
> --- a/drivers/net/fs_enet/fs_enet-main.c
> +++ b/drivers/net/fs_enet/fs_enet-main.c
> @@ -994,7 +994,7 @@ static int __devinit find_phy(struct device_node *np,
>                goto out_put_phy;
>        }
>
> -       bus_id = of_get_gpio(mdionode, 0);
> +       bus_id = of_get_gpio(mdionode, 0, NULL);
>        if (bus_id < 0) {
>                struct resource res;
>                ret = of_address_to_resource(mdionode, 0, &res);
> diff --git a/drivers/net/phy/mdio-ofgpio.c b/drivers/net/phy/mdio-ofgpio.c
> index 2ff9775..e3757c6 100644
> --- a/drivers/net/phy/mdio-ofgpio.c
> +++ b/drivers/net/phy/mdio-ofgpio.c
> @@ -78,8 +78,8 @@ static int __devinit mdio_ofgpio_bitbang_init(struct mii_bus *bus,
>  {
>        struct mdio_gpio_info *bitbang = bus->priv;
>
> -       bitbang->mdc = of_get_gpio(np, 0);
> -       bitbang->mdio = of_get_gpio(np, 1);
> +       bitbang->mdc = of_get_gpio(np, 0, NULL);
> +       bitbang->mdio = of_get_gpio(np, 1, NULL);
>
>        if (bitbang->mdc < 0 || bitbang->mdio < 0)
>                return -ENODEV;
> diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
> index 7cd7301..2123517 100644
> --- a/drivers/of/gpio.c
> +++ b/drivers/of/gpio.c
> @@ -22,11 +22,12 @@
>  * of_get_gpio - Get a GPIO number from the device tree to use with GPIO API
>  * @np:                device node to get GPIO from
>  * @index:     index of the GPIO
> + * @flags:     GPIO's flags are returned here if non-NULL
>  *
>  * Returns GPIO number to use with Linux generic GPIO API, or one of the errno
>  * value on the error condition.
>  */
> -int of_get_gpio(struct device_node *np, int index)
> +int of_get_gpio(struct device_node *np, int index, unsigned int *flags)
>  {
>        int ret;
>        struct device_node *gc;
> @@ -59,7 +60,9 @@ int of_get_gpio(struct device_node *np, int index)
>                goto err1;
>        }
>
> -       ret = of_gc->xlate(of_gc, np, gpio_spec);
> +       if (flags)
> +               *flags = 0;
> +       ret = of_gc->xlate(of_gc, np, gpio_spec, flags);
>        if (ret < 0)
>                goto err1;
>
> @@ -77,19 +80,23 @@ EXPORT_SYMBOL(of_get_gpio);
>  * @of_gc:     pointer to the of_gpio_chip structure
>  * @np:                device node of the GPIO chip
>  * @gpio_spec: gpio specifier as found in the device tree
> + * @flags:     if non-NUll flags are returned here
>  *
>  * This is simple translation function, suitable for the most 1:1 mapped
>  * gpio chips. This function performs only one sanity check: whether gpio
>  * is less than ngpios (that is specified in the gpio_chip).
>  */
>  int of_gpio_simple_xlate(struct of_gpio_chip *of_gc, struct device_node *np,
> -                        const void *gpio_spec)
> +                        const void *gpio_spec, unsigned int *flags)
>  {
>        const u32 *gpio = gpio_spec;
>
>        if (*gpio > of_gc->gc.ngpio)
>                return -EINVAL;
>
> +       if (flags && of_gc->gpio_cells > 1)
> +               *flags = gpio[1];
> +
>        return *gpio;
>  }
>  EXPORT_SYMBOL(of_gpio_simple_xlate);
> diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/serial/cpm_uart/cpm_uart_core.c
> index bde4b4b..7835cd4 100644
> --- a/drivers/serial/cpm_uart/cpm_uart_core.c
> +++ b/drivers/serial/cpm_uart/cpm_uart_core.c
> @@ -1094,7 +1094,7 @@ static int cpm_uart_init_port(struct device_node *np,
>        }
>
>        for (i = 0; i < NUM_GPIOS; i++)
> -               pinfo->gpios[i] = of_get_gpio(np, i);
> +               pinfo->gpios[i] = of_get_gpio(np, i, NULL);
>
>        return cpm_uart_request_port(&pinfo->port);
>
> diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
> index 67db101..0d332bf 100644
> --- a/include/linux/of_gpio.h
> +++ b/include/linux/of_gpio.h
> @@ -26,7 +26,7 @@ struct of_gpio_chip {
>        struct gpio_chip gc;
>        int gpio_cells;
>        int (*xlate)(struct of_gpio_chip *of_gc, struct device_node *np,
> -                    const void *gpio_spec);
> +                    const void *gpio_spec, unsigned int *flags);
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
> + */
> +#define OF_GPIO_ACTIVE_LOW     1
> +
> +/*
>  * OF GPIO chip for memory mapped banks
>  */
>  struct of_mm_gpio_chip {
> @@ -50,16 +58,17 @@ static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
>        return container_of(of_gc, struct of_mm_gpio_chip, of_gc);
>  }
>
> -extern int of_get_gpio(struct device_node *np, int index);
> +extern int of_get_gpio(struct device_node *np, int index, unsigned int *flags);
>  extern int of_mm_gpiochip_add(struct device_node *np,
>                              struct of_mm_gpio_chip *mm_gc);
>  extern int of_gpio_simple_xlate(struct of_gpio_chip *of_gc,
>                                struct device_node *np,
> -                               const void *gpio_spec);
> +                               const void *gpio_spec, unsigned int *flags);
>  #else
>
>  /* Drivers may not strictly depend on the GPIO support, so let them link. */
> -static inline int of_get_gpio(struct device_node *np, int index)
> +static inline int of_get_gpio(struct device_node *np, int index,
> +                             unsigned int *flags)
>  {
>        return -ENOSYS;
>  }
> --
> 1.5.4.3
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
