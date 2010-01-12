Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199Ab0ALXKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0ALXKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 18:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419Ab0ALXJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 18:09:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560Ab0ALXJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 18:09:59 -0500
Date: Tue, 12 Jan 2010 15:09:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: David Brownell <david-b@pacbell.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: introduce gpio_request_one() and friends
Message-Id: <20100112150952.aa224e20.akpm@linux-foundation.org>
In-Reply-To: <f17812d71001072128g63361e74q74cf06ae1e1eb3d6@mail.gmail.com>
References: <f17812d71001072114g95c267cpa6dc06a636c6d9a@mail.gmail.com>
	<f17812d71001072128g63361e74q74cf06ae1e1eb3d6@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jan 2010 13:28:57 +0800
Eric Miao <eric.y.miao@gmail.com> wrote:

> Typo in GPIOF_* definitions, updated patch follows:
> 
> commit 29cd35f57699fd93a12132186d52109a55ed57e7
> Author: Eric Miao <eric.y.miao@gmail.com>
> Date:   Fri Jan 8 12:16:28 2010 +0800
> 
>     gpio: introduce gpio_request_one() and friends
> 
>     gpio_request() without initial configuration of the GPIO is normally
>     useless, introduce gpio_request_one() together with GPIOF_ flags for
>     input/output direction and initial output level.
> 
>     gpio_{request,free}_array() for multiple GPIOs.
> 
>     Cc: David Brownell <dbrownell@users.sourceforge.net>
>     Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index a25ad28..e80a1f8 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1239,6 +1239,48 @@ void gpio_free(unsigned gpio)
>  }
>  EXPORT_SYMBOL_GPL(gpio_free);
> 
> +int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
> +{
> +	int err;
> +
> +	err = gpio_request(gpio, label);
> +	if (err)
> +		return err;
> +
> +	if (flags & GPIOF_DIR_IN)
> +		err = gpio_direction_input(gpio);
> +	else
> +		err = gpio_direction_output(gpio,
> +				(flags & GPIOF_INIT_HIGH) ? 1 : 0);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(gpio_request_one);
> +
> +int gpio_request_array(struct gpio *array, size_t num)
> +{
> +	int i, err;
> +
> +	for (i = 0; i < num; i++, array++) {
> +		err = gpio_request_one(array->gpio, array->flags, array->label);
> +		if (err)
> +			goto err_free;
> +	}
> +	return 0;
> +
> +err_free:
> +	while (i--)
> +		gpio_free((--array)->gpio);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(gpio_request_array);
> +
> +void gpio_free_array(struct gpio *array, size_t num)
> +{
> +	while (num--)
> +		gpio_free((array++)->gpio);
> +}
> +EXPORT_SYMBOL_GPL(gpio_free_array);

Global, exported-to-modules interfaces should be documented, IMO.

>  /**
>   * gpiochip_is_requested - return string iff signal was requested
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index 485eeb6..a9e0b94 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -136,6 +136,26 @@ extern int __gpio_cansleep(unsigned gpio);
> 
>  extern int __gpio_to_irq(unsigned gpio);
> 
> +#define GPIOF_DIR_OUT	(0 << 0)
> +#define GPIOF_DIR_IN	(1 << 0)
> +
> +#define GPIOF_INIT_LOW	(0 << 1)
> +#define GPIOF_INIT_HIGH	(1 << 1)
> +
> +#define GPIOF_IN		(GPIOF_DIR_IN)
> +#define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
> +#define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
> +
> +struct gpio {
> +	unsigned	gpio;
> +	unsigned long	flags;
> +	const char	*label;
> +};

hm.  Was "struct gpio" a well-chosen identifier?  The name implies that
this structure is the definitive, unified, generic kernel-wide
representation of a "gpio", whatever that is.

> +extern int gpio_request_one(unsigned gpio, unsigned long flags, const
> char *label);

Your email client is wordwrapping the patches.
