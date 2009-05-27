Return-Path: <linux-kernel-owner+w=401wt.eu-S1762594AbZE0XjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762594AbZE0XjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbZE0XjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:39:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754435AbZE0XjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:39:03 -0400
Date: Wed, 27 May 2009 16:38:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       baruch@tkos.co.il
Subject: Re: [PATCH] gpio: driver for PrimeCell PL061 GPIO controller
Message-Id: <20090527163844.b1284240.akpm@linux-foundation.org>
In-Reply-To: <1242718529-12637-1-git-send-email-baruch@tkos.co.il>
References: <1242718529-12637-1-git-send-email-baruch@tkos.co.il>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009 10:35:29 +0300
Baruch Siach <baruch@tkos.co.il> wrote:

> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Patch looks nice and simple.  Was there really nothing you can think of
for a changelog?  Like, what's a "PrimeCell PL061 GPIO"?  What hardware
would one find it on?  Is it possible that a "PrimeCell PL061 GPIO" can
appear on any CPU architecture at all, or is it specific to
arm/x86/whatever?

etc.

> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -67,6 +67,11 @@ config GPIO_SYSFS
>  
>  comment "Memory mapped GPIO expanders:"
>  
> +config GPIO_PL061
> +	bool "PrimeCell PL061 GPIO support"
> +	help
> +	  Say yes here to support the PrimeCell PL061 GPIO device
> +

hm, so gpio drivers can't be loaded as modules?

>
> ...
>
> --- /dev/null
> +++ b/drivers/gpio/pl061.c
> @@ -0,0 +1,336 @@
> +/*
> + *  linux/drivers/gpio/pl061.c
> + *
> + *  Copyright (C) 2008, 2009 Provigent Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Driver for the ARM PrimeCell(tm) General Purpose Input/Output (PL061)
> + *
> + * Data sheet: ARM DDI 0190B, September 2000
> + */
> +#include <linux/spinlock.h>
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/bitops.h>
> +#include <linux/workqueue.h>
> +#include <linux/gpio.h>
> +#include <linux/gpio/pl061.h>
> +
> +#define PL061_GPIO_NR	8
> +
> +struct pl061_gpio {
> +	spinlock_t		lock;
> +	spinlock_t		irq_lock;

It's unclear (to me) why this has two different locks.  Perhaps only
one was needed.  If we indeed need two locks then please add code
comments which explain the role of each one.  And the nesting rules if
appropriate.

> +	void __iomem		*base;
> +	struct gpio_chip	gc;
> +	struct work_struct	gpio_free_work;
> +	DECLARE_BITMAP(gpios_to_free, PL061_GPIO_NR);
> +};
> +
> +static u32 (*pl061_pending_irq)(int irq);
> +
> +static int pl061_direction_input(struct gpio_chip *gc, unsigned offset)
> +{
> +	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
> +	unsigned long flags;
> +	unsigned char gpiodir;
> +
> +	if (offset >= gc->ngpio)
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&chip->lock, flags);
> +	gpiodir = readb (chip->base + GPIODIR);

Please pass this patch (and indeed, all patches) through
scripts/checkpatch.pl and consider the resulting output.

> +	gpiodir &= ~(1 << offset);
> +	writeb(gpiodir, chip->base + GPIODIR);
> +	spin_unlock_irqrestore(&chip->lock, flags);
> +
> +	return 0;
> +}
> +
>
> ...
>
> +static void pl061_irq_shutdown(unsigned irq)
> +{
> +	struct pl061_gpio *chip = get_irq_chip_data(irq);
> +	int offset = irq_to_gpio(irq) - chip->gc.base;
> +
> +	pl061_irq_disable(irq);
> +	set_bit(offset, chip->gpios_to_free);
> +	schedule_work(&chip->gpio_free_work);
> +}

It's usually a bug to add a schedule_work() and no corresponding
flush_work()/cancel_work_sync()/etc.  

Because the callback might still be pending after module removal,
device shutdown, etc.

If this is for some reason not a bug, I'd suggest that code somments be
added explaining why.

>
> ...
>
> +static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
> +{
> +	desc->chip->ack(irq);
> +	while (1) {
> +		unsigned long pending;
> +		int gpio;
> +
> +		pending = pl061_pending_irq(irq);
> +		if (pending == 0)
> +			break;
> +
> +		for_each_bit(gpio, &pending, BITS_PER_LONG) {
> +			generic_handle_irq(gpio_to_irq(gpio));
> +		}

The braces are superfluous, but checkpatch misses this.

> +	}
> +	desc->chip->unmask(irq);
> +}
> +
> +static void pl061_gpio_free(struct work_struct *work)
> +{
> +	struct pl061_gpio *chip = container_of(work, struct pl061_gpio,
> +			gpio_free_work);
> +	int offset;
> +
> +	while (!bitmap_empty(chip->gpios_to_free, PL061_GPIO_NR)) {
> +		for_each_bit(offset, chip->gpios_to_free, PL061_GPIO_NR) {
> +			int gpio = offset + chip->gc.base;
> +
> +			if (test_and_clear_bit(offset, chip->gpios_to_free))
> +				gpio_free(gpio);
> +		}
> +	}

Does this function need to do multiple passes over gpios_to_free like
this?  It seems unnecessary.

If it is indeed needed then please add a comment explaining what's
going on.

> +}
> +
> +static int __init pl061_probe(struct platform_device *dev)
> +{
> +	struct pl061_platform_data *pdata;
> +	struct pl061_gpio *chip;
> +	struct resource *r;
> +	int ret, irq, i;
> +
> +	pdata = dev->dev.platform_data;
> +	if (pdata == NULL)
> +		return -ENODEV;
> +
> +	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
> +	if (chip == NULL)
> +		return -ENOMEM;
> +
> +	r = platform_get_resource(dev, IORESOURCE_MEM, 0);
> +	if (r == NULL) {
> +		ret = -ENODEV;
> +		goto free_mem;
> +	}
> +
> +	chip->base = ioremap(r->start, r->end - r->start + 1);
> +	if (chip->base == NULL) {
> +		ret = -ENOMEM;
> +		goto free_mem;
> +	}
> +
> +	spin_lock_init(&chip->lock);
> +	spin_lock_init(&chip->irq_lock);
> +
> +	bitmap_zero(chip->gpios_to_free, PL061_GPIO_NR);

Well.  kzalloc() already did that.

> +	INIT_WORK(&chip->gpio_free_work, pl061_gpio_free);
> +
> +	chip->gc.direction_input = pl061_direction_input;
> +	chip->gc.direction_output = pl061_direction_output;
> +	chip->gc.get = pl061_get_value;
> +	chip->gc.set = pl061_set_value;
> +	chip->gc.base = pdata->gpio_base;
> +	chip->gc.ngpio = PL061_GPIO_NR;
> +	chip->gc.label = dev->name;
> +	chip->gc.dev = &dev->dev;
> +	chip->gc.owner = THIS_MODULE;
> +
> +	ret = gpiochip_add(&chip->gc);
> +	if (ret)
> +		goto iounmap;
> +
> +	/*
> +	 * irq_chip support
> +	 */
> +	writeb(0, chip->base + GPIOIE); /* disable irqs */
> +	irq = platform_get_irq(dev, 0);
> +	if (irq < 0) {
> +		ret = -ENODEV;
> +		goto iounmap;
> +	}
> +	set_irq_chained_handler(irq, pl061_irq_handler);
> +	pl061_pending_irq = pdata->pending_irqs;
> +
> +	for (i = 0; i < PL061_GPIO_NR; i++) {
> +		if (pdata->directions & (1 << i))
> +			pl061_direction_output(&chip->gc, i,
> +					pdata->values & (1 << i));
> +		else
> +			pl061_direction_input(&chip->gc, i);
> +
> +		set_irq_chip(gpio_to_irq(i+pdata->gpio_base), &pl061_irqchip);
> +		set_irq_handler(gpio_to_irq(i+pdata->gpio_base),
> +				handle_simple_irq);
> +		set_irq_flags(gpio_to_irq(i+pdata->gpio_base), IRQF_VALID);
> +		set_irq_chip_data(gpio_to_irq(i+pdata->gpio_base), chip);
> +	}
> +
> +	return 0;
> +
> +iounmap:
> +	iounmap(chip->base);
> +free_mem:
> +	kfree(chip);
> +
> +	return ret;
> +}
> +
>
> ...
>

