Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbZAIFFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbZAIFFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 00:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZAIFFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 00:05:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbZAIFFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 00:05:41 -0500
Date: Thu, 8 Jan 2009 08:28:26 -0800
From: Greg KH <gregkh@suse.de>
To: Davide Rizzo <elpa.rizzo@gmail.com>
Cc: linux-kernel@vger.kernel.org, hjk@linutronix.de, ben-linux@fluff.org
Subject: Re: [PATCH 1/2] Driver for user access to internal timer
Message-ID: <20090108162826.GA26413@suse.de>
References: <8447d6730901080205o1a337d4cx867c7b2bd429ceb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8447d6730901080205o1a337d4cx867c7b2bd429ceb0@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 11:05:30AM +0100, Davide Rizzo wrote:
> Allows user programs to manage internal timers, through virtual files
>  frequency and duty.

If you are adding userspace apis, please also add the proper
documentation to Documentation/ABI/ as well.

> If pwm_one_shot is implemented, it allows also waiting for one-shot period.

How does userspace know if it is implemented or not?

> +++ linux-2.6.28.elpa/drivers/uio/Makefile	2009-01-06 18:20:17.000000000 +0100
> @@ -1,4 +1,5@@
>  obj-$(CONFIG_UIO)	+= uio.o
> +obj-$(CONFIG_UIO_TIMER) += timer.o

timer.ko is a pretty generic name for a module, how about changing it to
something a bit more unique and descriptive?

> --- linux-2.6.28/drivers/uio/timer.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.28.elpa/drivers/uio/timer.c	2009-01-07 19:02:25.000000000 +0100
> @@ -0,0 +1,302 @@
> +/*
> + drivers/misc/timer.c
> +
> + Written Jan 2009 by Davide Rizzo <elpa-rizzo@gmail.com>
> +
> + This driver allows user to access internal timers
> + You can use any timer to generate a fixed frequency signal, or to wait for a
> + defined short time (if hardware can do it).
> + To generate a PWM signal, you have to write the frequency value in Hz into the
> + virtual file "freq". After that you can program the duty cycle in the virtual
> + file "duty", in 1/1000 units (500 = 50%).
> + To wait for a time, you have to write the number of microseconds in virtual
> + file "wait". Reading from same file will complete when timer will expire.

Where are these files located at?

And can't you do this already with the existing kernel/user interfaces
for time?  What is different here from them?  The PWM signal?  Or
something else?

> + This program is free software; you can redistribute it and/or modify
> + it under the terms of the GNU General Public License as published by
> + the Free Software Foundation; either version 2 of the License, or
> + (at your option) any later version.

Do you really mean "any later version"?

> +#ifdef CONFIG_UIO_TIMER_ONESHOT

Please don't put #ifdefs in c files if at all possible.

> +#define NS_IN_HZ (1000000000UL)

Don't we already have this define in some .h file somewhere?

> +#ifdef CONFIG_UIO_TIMER_ONESHOT
> +	init_waitqueue_head(&info->wq);
> +	info->flag = 1;
> +	err = device_create_file(&pdev->dev, &dev_attr_wait);

<snip>

You can do all the creation and deletion of files using a group of
attributes, which would make your code much simpler.

> +MODULE_SUPPORTED_DEVICE("timers");

That sounds pretty generic :(

thanks,

greg k-h
