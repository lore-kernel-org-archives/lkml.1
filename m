Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbZAEPIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbZAEPIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbZAEPIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:08:40 -0500
Received: from main.gmane.org ([80.91.229.2]:36651 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbZAEPIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:08:39 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [REPOST^3] [PATCH] timer iomem hwrng driver
Date: Mon, 5 Jan 2009 14:30:13 +0000
Message-ID: <l4i936-is3.ln1@woodchuck.wormnet.eu>
References: <20081230145209.GA26015@woodchuck>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: woodchuck.wormnet.eu
User-Agent: tin/1.9.2-20070201 ("Dalaruan") (UNIX) (Linux/2.6.24-etchnhalf.1-sparc64 (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Clouter <alex@digriz.org.uk> wrote:
>
> I submitted this some time back but got no 'love' from the community[1] 
> so I'm reposting it.
> 
Please, can *someone* give me some feedback.  After the second time of
submitting this code still no-one has any feedback.  It really really is 
demoralising.

I understand this is more or less a patch to an orphaned subsystem but I 
have also made submissions to ARM and MTD and it's as if I have the 
'spot' :(

Cheers

Alex

> Some hardware platforms, the TS-7800[2] is one for example, can supply 
> the kernel with an entropy source, albeit a slow one for TS-7800 users, 
> by just reading a particular IO address.  This source must not be read 
> above a certain rate otherwise the quality is not suitable.
> 
> The driver is then hooked into by calling
> platform_device_(register|add|del) passing a structure similar to: 
> ------------
> #define TS_RNG          (TS78XX_FPGA_REGS_VIRT_BASE | 0x044)
> 
> static struct timeriomem_rng_data ts78xx_ts_rng_data = {
>        .address        = (u32 *__iomem) TS_RNG,
>        .period         = 1000000, /* one second */
> };
> 
> static struct platform_device ts78xx_ts_rng_device = {
>        .name           = "timeriomem_rng",
>        .id             = -1,
>        .dev            = {
>                .platform_data  = &ts78xx_ts_rng_data,
>        },
>        .num_resources  = 0,
> };
> ------------
> 
> Feedback welcomed.
> 
> Cheers
> 
> Alex
> 
> [1] http://lkml.org/lkml/2008/6/15/106
> [2] http://www.embeddedarm.com/products/board-detail.php?product=TS-7800
> 
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 8822eca..638e060 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -20,6 +20,19 @@ config HW_RANDOM
> 
>          If unsure, say Y.
> 
> +config HW_RANDOM_TIMERIOMEM
> +       tristate "Timer IOMEM HW Random Number Generator support"
> +       depends on HW_RANDOM
> +       ---help---
> +         This driver provides kernel-side support for a generic Random
> +         Number Generator provisioned by hardware through a 'dumb' iomem
> +         address; for example the TS-7800 is such a device.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called timeriomem-rng.
> +
> +         If unsure, say Y.
> +
> config HW_RANDOM_INTEL
>        tristate "Intel HW Random Number Generator support"
>        depends on HW_RANDOM && (X86 || IA64) && PCI
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index b6effb7..e81d21a 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -4,6 +4,7 @@
> 
> obj-$(CONFIG_HW_RANDOM) += rng-core.o
> rng-core-y := core.o
> +obj-$(CONFIG_HW_RANDOM_TIMERIOMEM) += timeriomem-rng.o
> obj-$(CONFIG_HW_RANDOM_INTEL) += intel-rng.o
> obj-$(CONFIG_HW_RANDOM_AMD) += amd-rng.o
> obj-$(CONFIG_HW_RANDOM_GEODE) += geode-rng.o
> diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
> new file mode 100644
> index 0000000..42f2813
> --- /dev/null
> +++ b/drivers/char/hw_random/timeriomem-rng.c
> @@ -0,0 +1,153 @@
> +/*
> + * drivers/char/hw_random/timeriomem-rng.c
> + *
> + * Copyright (C) 2008 Alexander Clouter <alex@digriz.org.uk>
> + *
> + * Derived from drivers/char/hw_random/omap-rng.c
> + *   Copyright 2005 (c) MontaVista Software, Inc.
> + *   Author: Deepak Saxena <dsaxena@plexity.net>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Overview:
> + *   This driver is useful for platforms that have an IO range that provides
> + *   periodic random data from a single IO memory address.  All the platform
> + *   has to do is provide the address and 'wait time' that new data becomes
> + *   available.
> + *
> + * TODO: add support for reading sizes other than 32bits and masking
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/hw_random.h>
> +#include <linux/io.h>
> +#include <linux/timeriomem-rng.h>
> +#include <linux/jiffies.h>
> +#include <linux/sched.h>
> +#include <linux/timer.h>
> +
> +static struct timeriomem_rng_data *timeriomem_rng_data;
> +
> +static void timeriomem_rng_trigger(unsigned long);
> +static DEFINE_TIMER(timeriomem_rng_timer, &timeriomem_rng_trigger, 0, 0);
> +
> +/*
> + * have data return 1, however return 0 if we have nothing
> + */
> +static int timeriomem_rng_data_present(struct hwrng *rng, int wait)
> +{
> +       s32 delay;
> +
> +       if (rng->priv == 0)
> +               return 1;
> +
> +       if (timer_pending(&timeriomem_rng_timer)) {
> +               if (!wait)
> +                       return 0;
> +
> +               del_timer(&timeriomem_rng_timer);
> +               delay = (long)timeriomem_rng_timer.expires - (long)jiffies;
> +
> +               schedule_timeout_uninterruptible(delay);
> +       }
> +
> +       return 1;
> +}
> +
> +static int timeriomem_rng_data_read(struct hwrng *rng, u32 *data)
> +{
> +       u32 cur;
> +       s32 delay;
> +
> +       *data = *timeriomem_rng_data->address;
> +
> +       if (rng->priv != 0) {
> +               cur = jiffies;
> +
> +               delay = (long)cur - (long)timeriomem_rng_timer.expires;
> +               delay = rng->priv - (delay % rng->priv);
> +
> +               timeriomem_rng_timer.expires = cur + delay;
> +               add_timer(&timeriomem_rng_timer);
> +       }
> +
> +       return 4;
> +}
> +
> +static void timeriomem_rng_trigger(unsigned long dummy)
> +{
> +       del_timer(&timeriomem_rng_timer);
> +}
> +
> +static struct hwrng timeriomem_rng_ops = {
> +       .name           = "timeriomem",
> +       .data_present   = timeriomem_rng_data_present,
> +       .data_read      = timeriomem_rng_data_read,
> +       .priv           = 0,
> +};
> +
> +static int __init timeriomem_rng_probe(struct platform_device *pdev)
> +{
> +       int ret;
> +
> +       timeriomem_rng_data = pdev->dev.platform_data;
> +
> +       if (timeriomem_rng_data->period != 0
> +               && usecs_to_jiffies(timeriomem_rng_data->period) > 0) {
> +               timeriomem_rng_timer.expires = jiffies;
> +               init_timer(&timeriomem_rng_timer);
> +
> +               timeriomem_rng_ops.priv = usecs_to_jiffies(
> +                                               timeriomem_rng_data->period);
> +       }
> +
> +       ret = hwrng_register(&timeriomem_rng_ops);
> +       if (ret) {
> +               dev_err(&pdev->dev, "problem registering\n");
> +               return ret;
> +       }
> +
> +       dev_info(&pdev->dev, "32bits from 0x%p @ %dus\n",
> +                       timeriomem_rng_data->address,
> +                       timeriomem_rng_data->period);
> +
> +       return 0;
> +}
> +
> +static int __devexit timeriomem_rng_remove(struct platform_device *pdev)
> +{
> +       del_timer(&timeriomem_rng_timer);
> +       hwrng_unregister(&timeriomem_rng_ops);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver timeriomem_rng_driver = {
> +       .driver = {
> +               .name           = "timeriomem_rng",
> +               .owner          = THIS_MODULE,
> +       },
> +       .probe          = timeriomem_rng_probe,
> +       .remove         = __devexit_p(timeriomem_rng_remove),
> +};
> +
> +static int __init timeriomem_rng_init(void)
> +{
> +       return platform_driver_register(&timeriomem_rng_driver);
> +}
> +
> +static void __exit timeriomem_rng_exit(void)
> +{
> +       platform_driver_unregister(&timeriomem_rng_driver);
> +}
> +
> +module_init(timeriomem_rng_init);
> +module_exit(timeriomem_rng_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Alexander Clouter <alex@digriz.org.uk>");
> +MODULE_DESCRIPTION("Timer IOMEM H/W RNG driver");
> diff --git a/include/linux/timeriomem-rng.h b/include/linux/timeriomem-rng.h
> new file mode 100644
> index 0000000..16dd9e4
> --- /dev/null
> +++ b/include/linux/timeriomem-rng.h
> @@ -0,0 +1,16 @@
> +/*
> + * linux/include/linux/timeriomem-rng.h
> + *
> + * Copyright (c) 2008 Alexander Clouter <alex@digriz.org.uk>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +struct timeriomem_rng_data {
> +       u32 __iomem     *address;
> +
> +       /* measures in usecs */
> +       unsigned int    period;
> +};

-- 
Alexander Clouter
.sigmonster says: It's more than magnificent -- it's mediocre.
                  		-- Sam Goldwyn

