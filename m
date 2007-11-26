Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbXKZMXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbXKZMXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 07:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbXKZMXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 07:23:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54532 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbXKZMXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 07:23:48 -0500
Date: Mon, 26 Nov 2007 12:23:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: ian <spyro@f2s.com>
Cc: eric miao <eric.y.miao@gmail.com>, Dmitry Baryshkov <dbaryshkov@gmail.com>,
       ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [UPDATED PATCH] Support for Toshiba TMIO multifunction devices
Message-ID: <20071126122330.GG19049@flint.arm.linux.org.uk>
References: <1195591234.2329.52.camel@wirenth> <474359E3.2020603@gmail.com> <1195597252.2329.70.camel@wirenth> <f17812d70711201823w6201bf88uf6268aaee3a32312@mail.gmail.com> <1195617255.2329.78.camel@wirenth> <f17812d70711202005m110ae880m5ba195988e57a638@mail.gmail.com> <1195691649.2329.105.camel@wirenth> <20071122005230.GA6170@flint.arm.linux.org.uk> <1195728766.2329.113.camel@wirenth>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195728766.2329.113.camel@wirenth>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 10:52:46AM +0000, ian wrote:
> On Thu, 2007-11-22 at 00:52 +0000, Russell King - ARM Linux wrote:
> > On Thu, Nov 22, 2007 at 12:34:09AM +0000, ian wrote:
> 
> > Unfortunately, this is broken as designed (in fact this whole file is.)
> 
> Fix attached below.

Thanks.

> +		/* Allocate space for the subdevice resources temporarily so
> +		   that we can modify them */
> +
> +                res = kzalloc(blk->num_resources * sizeof (struct
> resource), GFP_KERNEL);

Looks like your mailer wrapped the patches.

> +                if (!res)
> +                        goto fail;

Plus weird indentation.

> +		platform_device_add_resources(sdev, res, blk->num_resources);
> +		kfree(res);
> +
> +		if (platform_device_add(sdev)) {
> +			goto fail;
> +		}
> +
> +		printk(KERN_INFO "MFD: registering %s\n", blk->name);
> +	}
> +	return devices;
> +
> +fail:
> +	mfd_free_devices(devices, i + 1);

If 'sdev' failed to register, you don't want to call platform_device_del()
on it (via platform_device_unregister()) since it's not been registered
into the device tree.

The removal procedure for platform devices is:

	if platform_device_alloc() fails, return -ENOMEM.
	if platform_device_add() fails, call platform_device_put() on it.
	if platform_device_add() suceeds, call either
		platform_device_del() + platform_device_put()  _or_
		platform_device_unregister()

> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index 6187a85..5e8360a 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -57,6 +57,9 @@ struct resource_list {
>  #define IORESOURCE_IRQ_LOWLEVEL		(1<<3)
>  #define IORESOURCE_IRQ_SHAREABLE	(1<<4)
>  
> +/* MFD device IRQ specific bits (IORESOURCE_BITS) */
> +#define IORESOURCE_IRQ_MFD_SUBDEVICE    (1<<5)
> +

Something others (== mainline) needs to see first.

> diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
> new file mode 100644
> index 0000000..e3057f6
> --- /dev/null
> +++ b/drivers/mfd/t7l66xb.c
> @@ -0,0 +1,286 @@
> +/*
> + * drivers/mfd/t7l66xb.c
> + *
> + * Toshiba T7L66XB support
> + * Copyright (c) 2005 Ian Molton
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This is based on my and Dirk Opfers work on the tc6393xb SoC.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/delay.h>

Do you need linux/delay.h ?

> +#include <linux/errno.h>
> +#include <linux/ioport.h>
> +#include <linux/irq.h>

Do you need linux/irq.h ?

> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +
> +#include <asm/hardware.h>
> +#include <asm/mach-types.h>

Doesn't use machine types in this file.

> +#include <asm/io.h>
> +#include <asm/arch/pxa-regs.h>
> +
> +#include <linux/t7l66xb.h>
> +#include <linux/tmio_mmc.h>
> +#include "mfd-core.h"
> +
> +#define platform_get_platdata(_dev)      ((_dev)->dev.platform_data)

Should this be something generic?  Eg in platform_device.h ?

> +	while ( (req = (readb(data->mapbase + T7L66XB_SYS_ISR)
> +			& ~(readb(data->mapbase + T7L66XB_SYS_IMR)))) ) {

Do the additional parens buy anything here (other than more line noise) ?

> +		for (i = 0; i <= 7; i++) {
> +			int dev_irq = data->irq_base + i;
> +			struct irq_desc *d = NULL;
> +			if ((req & (1<<i))) {

Ditto.

> +	set_irq_data (tchip->irq_nr, tchip);
> +        set_irq_chained_handler (tchip->irq_nr, t7l66xb_irq_handler);

Weird indentation.
> +	set_irq_type (tchip->irq_nr, IRQT_FALLING);
> +}
> +
> +static void t7l66xb_hwinit(struct platform_device *dev)
> +{
> +	struct t7l66xb_platform_data *pdata = platform_get_platdata(dev);
> +
> +	if (pdata && pdata->hw_init)
> +		pdata->hw_init();
> +}
> +
> +
> +#ifdef CONFIG_PM
> +
> +static int t7l66xb_suspend(struct platform_device *dev, pm_message_t
> state)
> +{
> +	struct t7l66xb_platform_data *pdata = platform_get_platdata(dev);
> +
> +
> +	if (pdata && pdata->suspend)
> +		pdata->suspend();
> +
> +	return 0;
> +}
> +
> +static int t7l66xb_resume(struct platform_device *dev)
> +{
> +	struct t7l66xb_platform_data *pdata = platform_get_platdata(dev);
> +
> +	if (pdata && pdata->resume)
> +		pdata->resume();
> +
> +	t7l66xb_hwinit(dev);
> +
> +	return 0;
> +}
> +#endif
> +
> +static int t7l66xb_probe(struct platform_device *dev)
> +{
> +	struct t7l66xb_platform_data *pdata = dev->dev.platform_data;
> +	unsigned long pbase = (unsigned long)dev->resource[0].start;
> +	unsigned long plen = dev->resource[0].end - dev->resource[0].start;
> +	int err = -ENOMEM;
> +	struct t7l66xb_data *data;
> +
> +	data = kmalloc (sizeof (struct t7l66xb_data), GFP_KERNEL);
> +	if (!data)
> +		goto out;
> +
> +	data->irq_base = pdata->irq_base;
> +	data->irq_nr   = dev->resource[1].start;

platform_get_irq() ?

> +
> +	if (!data->irq_base) {
> +		printk("t7166xb: uninitialized irq_base!\n");

KERN_ERR ?

> +		goto out_free_data;
> +	}
> +
> +	data->mapbase = ioremap(pbase, plen);
> +	if(!data->mapbase)
> +		goto out_free_irqs;
> +
> +	platform_set_drvdata(dev, data);
> +	t7l66xb_setup_irq(data);
> +	t7l66xb_hwinit(dev);
> +
> +	/* Mask IRQs  -- should we mask/unmask on suspend/resume? */
> +	writew(0xbf, data->mapbase + T7L66XB_SYS_IMR);
> +
> +	printk(KERN_INFO "%s rev %d @ 0x%08lx using irq %d-%d on irq %d\n",
> +	       dev->name,  readw(data->mapbase + T7L66XB_SYS_RIDR),
> +	       (unsigned long)data->mapbase, data->irq_base,
> +	       data->irq_base + T7L66XB_NR_IRQS - 1, data->irq_nr);
> +
> +	data->devices = mfd_add_devices(dev, t7l66xb_devices,
> +	                                ARRAY_SIZE(t7l66xb_devices),
> +	                                &dev->resource[0], 0, data->irq_base);

dev->resource === &dev->resource[0]

> +
> +	if(!data->devices){

should be:
	if (!data->devices) {

> +		printk(KERN_INFO "%s: Failed to allocate devices!\n",

KERN_ERR ?

> +		       dev->name);
> +		goto out_free_devices;
> +	}
> +
> +	return 0;
> +
> +out_free_devices:
> +	mfd_free_devices(data->devices, ARRAY_SIZE(t7l66xb_devices));
> +out_free_irqs:
> +out_free_data:
> +	kfree(data);
> +out:
> +	return err;
> +}
> +
> +static int t7l66xb_remove(struct platform_device *dev)
> +{
> +	struct t7l66xb_data *tchip = platform_get_drvdata(dev);
> +	int i;
> +
> +	/* Free subdevices */
> +        mfd_free_devices(tchip->devices, ARRAY_SIZE(t7l66xb_devices));

Weird indentation.

> +
> +	/* Take down IRQ handling */
> +        for (i = 0; i < T7L66XB_NR_IRQS; i++) {
> +                int irq = i + tchip->irq_base;
> +                set_irq_handler (irq, NULL);
> +                set_irq_chip (irq, NULL);
> +                set_irq_chip_data (irq, NULL);
> +        }

Ditto for most of the above lines.

> +static int __init t7l66xb_init(void)
> +{
> +	int retval = 0;
> +		
> +	retval = platform_driver_register (&t7l66xb_platform_driver);
> +	return retval;

Looks like a long winded way of writing

	return platform_driver_register (&t7l66xb_platform_driver);

> diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
> new file mode 100644
> index 0000000..d309b9f
> --- /dev/null
> +++ b/drivers/mfd/tc6387xb.c
> @@ -0,0 +1,143 @@
> +/*
> + * drivers/mfd/tc6387xb.c
> + *
> + * Toshiba TC6387XB support
> + * Copyright (c) 2005 Ian Molton
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/delay.h>

Delays not used?

> +#include <linux/errno.h>
> +#include <linux/ioport.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +
> +#include <asm/hardware.h>
> +#include <asm/mach-types.h>

No machine types used?

> diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
> new file mode 100644
> index 0000000..3d43ce3
> --- /dev/null
> +++ b/drivers/mfd/tc6393xb.c
> @@ -0,0 +1,369 @@
> +/*
> + * drivers/mfd/tc6393xb.c
> + *
> + * Toshiba TC6393 support
> + * Copyright (c) 2005 Dirk Opfer
> + * Copyright (c) 2005 Ian Molton <spyro@f2s.com>
> + *
> + *	Based on code written by Sharp/Lineo for 2.4 kernels
> + *	Based on locomo.c
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/delay.h>

linux/delay.h not used?

> +#include <linux/errno.h>
> +#include <linux/ioport.h>
> +#include <linux/irq.h>

linux/irq.h not used?

> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +
> +#include <asm/hardware.h>
> +#include <asm/mach-types.h>

machine types not used?

> +#include <asm/io.h>
> +#include <asm/arch/pxa-regs.h>
> +
> +#include <linux/tmio_mmc.h>
> +#include <linux/tmio_nand.h>
> +#include <linux/tmio_ohci.h>
> +#include <linux/tc6393.h>
> +#include "mfd-core.h"
> +
> +#define platform_get_platdata(_dev)      ((_dev)->dev.platform_data)

should be in linux/platform_device.h ?

> +static struct tmio_mmc_hwconfig tc6393xb_mmc_hwconfig = {
> +        .set_mmc_clock  = tc6393xb_mmc_set_clock,

Indentation?

> +	while ( (req = (readb(data->mapbase + TC6393_SYS_ISR)
> +			& ~(readb(data->mapbase + TC6393_SYS_IMR)))) ) {

Revenge of the parens.

> +		for (i = 0; i <= 7; i++) {
> +			int dev_irq = data->irq_base + i;
> +			struct irq_desc *d = NULL;
> +			if ((req & (1<<i))) {

Parens strike back.

> +				if(i != 1)  printk("IRQ! from %d\n", i);

But strange spacing moves in for the kill.

> +	if(!pdata || !tchip){

And again.  Life points reducing.

> +	data->irq_base = pdata->irq_base;
> +	data->irq_nr = dev->resource[1].start;

platform_get_irq() ?

> +
> +	if (!data->irq_base) {
> +		printk("tc6393xb: uninitialized irq_base!\n");

KERN_ERR ?

> +		goto out_free_data;
> +	}
> +
> +	data->mapbase = ioremap(pbase, plen);
> +	if(!data->mapbase)

Spacing.

> +		goto out_free_irqs;
> +
> +	platform_set_drvdata(dev, data);
> +	tc6393xb_setup_irq (data);
> +	tc6393xb_hwinit(dev);
> +
> +	/* Enable (but mask!) our IRQs */
> +	writew(0,    data->mapbase + TC6393_SYS_IRR);
> +	writew(0xbf, data->mapbase + TC6393_SYS_IMR);
> +
> +	printk(KERN_INFO "%s rev %d @ 0x%08lx using irq %d-%d on irq %d\n",
> +	       dev->name,  readw(data->mapbase + TC6393_SYS_RIDR),
> +	       (unsigned long)data->mapbase, data->irq_base,
> +	       data->irq_base + TC6393XB_NR_IRQS - 1, data->irq_nr);
> +
> +	data->devices =  mfd_add_devices(dev, tc6393xb_devices,
> +	                                ARRAY_SIZE(tc6393xb_devices),
> +	                                &dev->resource[0], 0, data->irq_base);

dev->resource === &dev->resource[0]

> +
> +	if(!data->devices) {

Spacing.

> +		printk(KERN_INFO "%s: Failed to allocate devices!\n",

KERN_ERR.

> +static int tc6393xb_remove(struct platform_device *dev)
> +{
> +	struct tc6393xb_data *tchip = platform_get_drvdata(dev);
> +	int i;
> +
> +	/* Free subdevices */
> +        mfd_free_devices(tchip->devices, ARRAY_SIZE(tc6393xb_devices));

Indentation.

> +
> +	/* Take down IRQ handling */
> +	for (i = 0; i < TC6393XB_NR_IRQS; i++) {
> +		int irq = i + tchip->irq_base;
> +		set_irq_handler (irq, NULL);
> +		set_irq_chip (irq, NULL);
> +		set_irq_chip_data (irq, NULL);
> +	}
> +	
> +	set_irq_chained_handler (tchip->irq_nr, NULL);
> +
> +	/* Free core resources */
> +        iounmap (tchip->mapbase);

Indentation.

I think by now you get the idea, so I'm not going to continue with this
review.  Maybe if you can fix up the above plus further instances of them
in the remainder of the patch set, it can be reviewed again.

Note that leaving soo many such trivialities for a reviewer to find causes
reviewer tiredness, increases the number of reviews, and decreases the
motivation for reviewers to read your code.

There's a tool (scripts/checkpatch.pl) designed to aid you in identifying
trivialities like the above.  Please consider using it.  (It won't find
all of the above, and it's not always 100% correct, but that is where a
review by humans come in.)
