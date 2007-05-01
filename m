Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbXEAG4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbXEAG4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 02:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932819AbXEAG4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 02:56:35 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932451AbXEAG4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 02:56:34 -0400
Date: Mon, 30 Apr 2007 23:56:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Sokolovsky <pmiscml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 1/4] SoC base drivers: SoC helper API
Message-Id: <20070430235630.e862aefc.akpm@linux-foundation.org>
In-Reply-To: <181733600.20070501080827@gmail.com>
References: <181733600.20070501080827@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 08:08:27 +0300 Paul Sokolovsky <pmiscml@gmail.com> wrote:

> diff --git a/drivers/soc/soc-core.c b/drivers/soc/soc-core.c
> new file mode 100644
> index 0000000..24c654c
> --- /dev/null
> +++ b/drivers/soc/soc-core.c
> @@ -0,0 +1,106 @@
> +/*
> + * drivers/soc/soc-core.c
> + *
> + * core SoC support
> + * Copyright (c) 2006 Ian Molton
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This file contains functionality used by many SoC type devices.
> + *
> + * Created: 2006-11-28
> + *
> + */
> +
> +#include <linux/ioport.h>
> +#include <linux/slab.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include "soc-core.h"
> +
> +void soc_free_devices(struct platform_device *devices, int nr_devs)
> +{
> +	struct platform_device *dev = devices;
> +	int i;
> +
> +	for (i = 0; i < nr_devs; i++) {
> +		struct resource *res = dev->resource;
> +		platform_device_unregister(dev++);
> +		kfree(res);
> +	}
> +	kfree(devices);
> +}
> +EXPORT_SYMBOL_GPL(soc_free_devices);
> +
> +#define SIGNED_SHIFT(val, shift) ((shift) >= 0 ? ((val) << (shift)) : ((val) >> -(shift)))

This will do bad things with

	SIGNED_SHIFT(val, distance++);

So either

a) take a copy of the args inside the macro or, better

b) use a static inline.

It's probably worth putting the result into include/linux/kernel.h as well.
It's quite generic.  If so, that's a standalone patch, please.  Or keep it
here if you can't be bothered with that.

> +struct platform_device *soc_add_devices(struct platform_device *dev,
> +					struct soc_device_data *soc, int nr_devs,
> +					struct resource *mem,
> +					int relative_addr_shift, int irq_base)
> +{
> +	struct platform_device *devices;
> +	int i, r, base;
> +
> +	devices = kzalloc(nr_devs * sizeof(struct platform_device), GFP_KERNEL);
> +	if (!devices)
> +		return NULL;
> +
> +	for (i = 0; i < nr_devs; i++) {
> +		struct platform_device *sdev = &devices[i];
> +		struct soc_device_data *blk = &soc[i];
> +		struct resource *res;
> +
> +		sdev->id = -1;
> +		sdev->name = blk->name;
> +
> +		sdev->dev.parent = &dev->dev;
> +		sdev->dev.platform_data = (void *)blk->hwconfig;
> +		sdev->num_resources = blk->num_resources;
> +
> +		/* Allocate space for the subdevice resources */
> +		res = kzalloc (blk->num_resources * sizeof (struct resource), GFP_KERNEL);
> +		if (!res)
> +			goto fail;
> +
> +		for (r = 0 ; r < blk->num_resources ; r++) {
> +			res[r].name = blk->res[r].name; // Fixme - should copy

fix me then ;)

With kstrdup(), presumably.

> +
> +			/* Find out base to use */
> +			base = 0;
> +			if (blk->res[r].flags & IORESOURCE_MEM) {
> +				base = mem->start;

mem->start is of type resource_size_t, and `base' should be of that type as
well.

> +			} else if ((blk->res[r].flags & IORESOURCE_IRQ) &&
> +				(blk->res[r].flags & IORESOURCE_IRQ_SOC_SUBDEVICE)) {
> +				base = irq_base;
> +			}
> +
> +			/* Adjust resource */
> +			if (blk->res[r].flags & IORESOURCE_MEM) {
> +				res[r].parent = mem;
> +				res[r].start = base + SIGNED_SHIFT(blk->res[r].start, relative_addr_shift);
> +				res[r].end   = base + SIGNED_SHIFT(blk->res[r].end,   relative_addr_shift);

Which means that SIGNED_SHIFT really has to be a macro, as it needs to
handle resource_size_t's and you don't know what type they have.

Also, things get interesting when working out how to handle right-shift of
a negative quantity of unknown type.

> +			} else {
> +				res[r].start = base + blk->res[r].start;
> +				res[r].end   = base + blk->res[r].end;
> +			}
> +			res[r].flags = blk->res[r].flags;
> +		}
> +
> +		sdev->resource = res;
> +		if (platform_device_register(sdev)) {
> +			kfree(res);
> +			goto fail;
> +		}
> +
> +		printk(KERN_INFO "SoC: registering %s\n", blk->name);
> +	}
> +	return devices;
> +
> +fail:
> +	soc_free_devices(devices, i + 1);
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(soc_add_devices);
> diff --git a/drivers/soc/soc-core.h b/drivers/soc/soc-core.h
> new file mode 100644
> index 0000000..8659f7e
> --- /dev/null
> +++ b/drivers/soc/soc-core.h
> @@ -0,0 +1,30 @@
> +/*
> + * drivers/soc/soc-core.h
> + *
> + * core SoC support
> + * Copyright (c) 2006 Ian Molton
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This file contains prototypes for the functions in soc-core.c
> + *
> + * Created: 2006-11-28
> + *
> + */
> +
> +struct soc_device_data {
> +	char *name;
> +	struct resource *res;
> +	int num_resources;
> +	void *hwconfig; /* platform_data to pass to the subdevice */
> +};
> +
> +struct platform_device *soc_add_devices(struct platform_device *dev,
> +					struct soc_device_data *soc, int n_devs,
> +					struct resource *mem,
> +					int relative_addr_shift, int irq_base);
> +
> +void soc_free_devices(struct platform_device *devices, int nr_devs);
> +
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index 6859a3b..65f0fcd 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -57,6 +57,9 @@ struct resource_list {
>  #define IORESOURCE_IRQ_LOWLEVEL		(1<<3)
>  #define IORESOURCE_IRQ_SHAREABLE	(1<<4)
>  
> +/* SoC device IRQ specific bits (IORESOURCE_BITS) */
> +#define IORESOURCE_IRQ_SOC_SUBDEVICE    (1<<5)
> +
>  /* ISA PnP DMA specific bits (IORESOURCE_BITS) */
>  #define IORESOURCE_DMA_TYPE_MASK	(3<<0)
>  #define IORESOURCE_DMA_8BIT		(0<<0)
> 

It looks reasonable to me, but I'm not Greg or Russell or anything like
that.

