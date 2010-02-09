Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab0BIRIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:08:22 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:53326 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab0BIRIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:08:21 -0500
MIME-Version: 1.0
In-Reply-To: <20100205203236.GC1475@oksana.dev.rtsoft.ru>
References: <20100205203201.GA32281@oksana.dev.rtsoft.ru> <20100205203236.GC1475@oksana.dev.rtsoft.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 9 Feb 2010 10:08:00 -0700
X-Google-Sender-Auth: fb8bba299ccda421
Message-ID: <fa686aa41002090908tbeed469k417af2a59757f8a@mail.gmail.com>
Subject: Re: [PATCH 3/4] of/gpio: Implement GPIOLIB notifier hooks
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 5, 2010 at 1:32 PM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> This patch implements GPIOLIB notifier hooks, and thus makes device-enabled
> GPIO chips (i.e. the ones that have gpio_chip->dev specified) automatically
> attached to the OpenFirmware subsystem. Which means that now we can handle
> I2C and SPI GPIO chips almost* transparently.
>
> * "Almost" because some chips still require platform data, and for these
>  chips OF-glue is still needed, though with this support the glue will
>  be much smaller.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  drivers/of/gpio.c |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 100 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
> index 12c4af0..9d8df77 100644
> --- a/drivers/of/gpio.c
> +++ b/drivers/of/gpio.c
> @@ -13,6 +13,7 @@
>
>  #include <linux/kernel.h>
>  #include <linux/errno.h>
> +#include <linux/notifier.h>
>  #include <linux/io.h>
>  #include <linux/of.h>
>  #include <linux/of_gpio.h>
> @@ -236,3 +237,102 @@ err0:
>        return ret;
>  }
>  EXPORT_SYMBOL(of_mm_gpiochip_add);
> +
> +/**
> + * of_gpiochip_register_simple - Register a chip with the OF GPIO subsystem
> + * @chip       pointer to a GPIO chip
> + * @np:                device node to register the GPIO chip with
> + *
> + * This function registers a GPIO chip with the OF infrastructure. It is
> + * assumed that the chip was previsously allocated and added to a generic
> + * GPIOLIB framework (using gpiochip_add() function).
> + *
> + * The `simple' name means that the chip is using simple two-cells scheme for
> + * the gpio-specifier.
> + */
> +static int of_gpiochip_register_simple(struct gpio_chip *chip,
> +                                      struct device_node *np)
> +{
> +       struct of_gpio_chip *of_gc;
> +
> +       if (np->data) {
> +               WARN_ON(1);
> +               return -EBUSY;
> +       }
> +
> +       of_gc = kzalloc(sizeof(*of_gc), GFP_KERNEL);
> +       if (!of_gc)
> +               return -ENOMEM;
> +
> +       of_gc->gpio_cells = 2;
> +       of_gc->xlate = of_gpio_simple_xlate;
> +       of_gc->chip = chip;

One concern.

How does an OF-aware GPIO driver override these settings?  What is to
be done when a GPIO chip requires a different xlate hook?  Or a
different number of gpio_cells?

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
