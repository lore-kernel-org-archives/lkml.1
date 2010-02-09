Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0BIRRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:17:09 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:40978 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab0BIRRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:17:05 -0500
MIME-Version: 1.0
In-Reply-To: <20100205203232.GA1475@oksana.dev.rtsoft.ru>
References: <20100205203201.GA32281@oksana.dev.rtsoft.ru> <20100205203232.GA1475@oksana.dev.rtsoft.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 9 Feb 2010 10:16:44 -0700
X-Google-Sender-Auth: d61d07d1bdcbcb23
Message-ID: <fa686aa41002090916w613efcb9te15e4969a880f724@mail.gmail.com>
Subject: Re: [PATCH 1/4] gpiolib: Introduce chip addition/removal notifier
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
> Some platforms (e.g. OpenFirmware) want to know when a particular chip
> added or removed, so that the platforms could add their specifics for
> non-platform devices, like I2C or SPI GPIO chips.
>
> This patch implements the notifier for chip addition and removal events.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  drivers/gpio/gpiolib.c     |   14 ++++++++++++++
>  include/asm-generic/gpio.h |    8 ++++++++
>  2 files changed, 22 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 350842a..375c03a 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -9,6 +9,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/gpio.h>
>  #include <linux/idr.h>
> +#include <linux/notifier.h>
>
>
>  /* Optional implementation infrastructure for GPIO interfaces.
> @@ -1029,6 +1030,9 @@ static inline void gpiochip_unexport(struct gpio_chip *chip)
>
>  #endif /* CONFIG_GPIO_SYSFS */
>
> +BLOCKING_NOTIFIER_HEAD(gpio_notifier);
> +EXPORT_SYMBOL_GPL(gpio_notifier);
> +
>  /**
>  * gpiochip_add() - register a gpio_chip
>  * @chip: the chip to register, with chip->base initialized
> @@ -1103,6 +1107,9 @@ fail:
>                pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
>                        chip->base, chip->base + chip->ngpio - 1,
>                        chip->label ? : "generic");
> +       else
> +               blocking_notifier_call_chain(&gpio_notifier,
> +                                            GPIO_NOTIFY_CHIP_ADDED, chip);

Rather than doing an else block which will need to be reworked if/when
any additional code is added to the bottom of this routine, please
rework the if() block to bail on failure instead of implicitly falling
through to the return statement.

Otherwise, this patch looks okay to me, so you can go ahead and add my:

Acked-by: Grant Likely <grant.likely@secretlab.ca>

*however* (and don't kill me for saying this because I know I
suggested the notifier approach in the first place).  Looking at the
whole patch series, the notifier call adds a lot of code for very
little gain.  If you dropped just the notifier bits (but left the rest
of the series the same), then the the of gpio bits would be
considerably simpler, and the only impact on the core gpiolib would be
the addition of an of_gpiochip_register_simple() and
of_gpiochip_unregister() hooks that will be conditionally compiled.

And to address one of my previous concerns, I've got no problem with
the automatic registration of GPIO devices for OF usage, as long as
of-aware drivers have the option of overriding the simple defaults
when needed.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
