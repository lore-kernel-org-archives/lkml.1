Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbXIKE1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbXIKE1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 00:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXIKE12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 00:27:28 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:39419 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbXIKE10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 00:27:26 -0400
Date: Tue, 11 Sep 2007 13:27:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] Maple Bus support for SEGA Dreamcast
Message-ID: <20070911042716.GA18367@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
	Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>
References: <8b67d60709101616p7430a572w3ed0921a846805@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60709101616p7430a572w3ed0921a846805@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding GregKH to the CC, he needs to Ack this before I can merge it).

On Tue, Sep 11, 2007 at 12:16:48AM +0100, Adrian McMenamin wrote:
> diff --git a/drivers/sh/maple/Makefile b/drivers/sh/maple/Makefile
> new file mode 100644
> index 0000000..f8c39f2
> --- /dev/null
> +++ b/drivers/sh/maple/Makefile
> @@ -0,0 +1,3 @@
> +#Makefile for Maple Bus
> +
> +obj-y	:= maplebus.o

Please use obj-$(CONFIG_MAPLE) here, too.

> diff --git a/drivers/sh/maple/maplebus.c b/drivers/sh/maple/maplebus.c
> new file mode 100644
> index 0000000..4662463
> --- /dev/null
> +++ b/drivers/sh/maple/maplebus.c
> @@ -0,0 +1,747 @@
> +/* maplebus.c
> + * Core maple bus functionality
> + * Original 2.4 code used here copyright
> + * YAEGASHI Takeshi, Paul Mundt, M. R. Brown and others
> + * Porting to 2.6 Copyright Adrian McMenamin, 2007
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
I don't believe the 'or any later version' thing was intended by any of
the original authors, this should probably be dropped. The original file
lacked explicit terms, so the default behaviour there is to fall back to
what the top-level COPYING says, which has the 'or any later version'
garbage removed.

> +static DEFINE_MUTEX(maple_list_lock);
> +
> +DEFINE_MUTEX(maple_dma_lock);
> +EXPORT_SYMBOL_GPL(maple_dma_lock);
> +
It would be better to have accessors for this rather than exporting the
mutex globally.

> +static void maple_add_packet(struct mapleq *mq)
> +{
> +	mutex_lock(&maple_list_lock);
> +	list_add((struct list_head *) mq, &maple_waitq);
> +	mutex_unlock(&maple_list_lock);
> +}
> +
Please use the mapleq list_head directly. Yes, it happens to exist at the
beginning of the structure, but casting outright rather than just using
mq->list is ridiculous.

> +static void maple_free_dev(struct maple_device *mdev)
> +{
> +	if (!mdev)
> +		return;
> +	kmem_cache_free(maple_cache, mdev->mq->recvbuf);

Is !mdev->mq possible?

> +	if (maple_packets > 0) {
> +		for (i = 0; i < (1 << MAPLE_DMA_PAGES); i++)
> +			dma_cache_wback_inv(maple_sendbuf + i * PAGE_SIZE,
> +					    PAGE_SIZE);

Use dma_cache_sync() for this. Ralf is currently trying to get rid of
these other dma_cache_xxx() functions.

> +static int setup_maple_commands(struct device *device, void *ignored)
> +{
> +	struct maple_device *maple_dev = to_maple_dev(device);
> +
> +	if  ((maple_dev->interval > 0) && (jiffies >maple_dev->when)) {
> +			maple_dev->when = jiffies + maple_dev->interval;
> +			maple_dev->mq->command = MAPLE_COMMAND_GETCOND;
> +			maple_dev->mq->sendbuf = &maple_dev->function;
> +			maple_dev->mq->length = 1;
> +			maple_add_packet(maple_dev->mq);
> +			liststatus++;
> +	} else {
> +		if (jiffies >= maple_pnp_time) {
> +			maple_dev->mq->command = MAPLE_COMMAND_DEVINFO;
> +			maple_dev->mq->length = 0;
> +			maple_add_packet(maple_dev->mq);
> +			liststatus++;
> +		}
> +	}
> +
You should be using time_before()/time_after() to guard against wraparound.

> +static struct maple_driver maple_null_driver = {
> +	.drv = {
> +		.name = "Maple_bus_basic_driver",
> +		.bus = 	&maple_bus_type,
> +		},

Please use a less visually offensive driver name. Also, why has the },
moved over a few levels for no reason?

> +	maple_cache =
> +	    kmem_cache_create("Maplebus_cache", 0x400, 0,
> +			      SLAB_HWCACHE_ALIGN, NULL);
> +
You don't need fancy caps in slab caches unless you're ACPI, please also
use a more descriptive name (maple_queue_cache or something like that).

> +      cleanup_cache:
> +	kmem_cache_destroy(maple_cache);
> +
Goto labels should be on the margin at the beginning of the line, not at
an arbitrary location.

> +/* use init call to ensure bus is registered ahead of devices */
> +fs_initcall(maple_bus_init);

Please use subsys_initcall() or something like that, this isn't a file
system. The comment is also pointless, it's obvious what the initcall is
for if you use the proper one.

> index 0000000..8a37c7e
> --- /dev/null
> +++ b/include/linux/maple.h
> @@ -0,0 +1,126 @@
> +/**
> + * maple.h
> + *
> + * porting to 2.6 driver model
> + * copyright Adrian McMenamin, 2007
> + *
> + */
> +
Please use the

#ifndef __LINUX_MAPLE_H
#define __LINUX_MAPLE_H

...

#endif /* __LINUX_MAPLE_H */

convention. And create an asm/maple.h that gets dragged in. Things like
the base address for the bus, ports/packets/dma setup and things like
that should be platform-specific properties, not things that are
hardcoded in a linux/ header. Only thing like the bus API, data
structures, and response codes are generic.

> +struct maple_driver {
> +	unsigned long function;
> +	int (*connect) (struct maple_device * dev);
> +	void (*disconnect) (struct maple_device * dev);
> +	struct device_driver drv;
> +};
> +
> +struct device_specify {
> +	int port;
> +	int unit;
> +};
> +
Namespace pollution.  You also seem to only use this as a convenience
accessor in certain places in the bus code itself, and it's never visible
to the API. Move the structure definition in to the .c code in that case.

> +void maple_setup_port_rescan(struct maple_device *mdev);
> +
> +void maplebus_init_hardware(void);
> +
Why would these ever be accessible to drivers?
