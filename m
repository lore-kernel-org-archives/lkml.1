Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbYGIXTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbYGIXTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 19:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYGIXTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 19:19:40 -0400
Received: from www.tglx.de ([62.245.132.106]:42917 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbYGIXTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 19:19:39 -0400
Date: Thu, 10 Jul 2008 01:19:14 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, Uwe.Kleine-Koenig@digi.com, gregkh@suse.de,
       akpm@linux-foundation.org, hjk@linutronix.de, lethal@linux-sh.org,
       tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] uio: add uio_pdrv_genirq platform driver
Message-ID: <20080709231913.GC3232@local>
References: <20080709065913.31342.11789.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709065913.31342.11789.sendpatchset@rx1.opensource.se>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 03:59:13PM +0900, Magnus Damm wrote:
> This patch adds uio_pdrv_genirq.c, a platform driver for UIO with 
> generic IRQ handling code. This driver is very similar to the regular
> UIO platform driver, but is only suitable for devices that are
> connected to the interrupt controller using unique interrupt lines.
> 
> The uio_pdrv_genirq driver includes generic interrupt handling code
> which disables the serviced interrupt in the interrupt controller
> and makes the user space driver responsible for acknowledging the
> interrupt in the device and reenabling the interrupt in the interrupt
> controller.
> 
> Shared interrupts are not supported since the in-kernel interrupt
> handler will disable the interrupt line in the interrupt controller,
> and in a shared interrupt configuration this will stop other devices
> from delivering interrupts.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>

Just one minor issue, see below. Everything else looks alright to me.
Nice to have, in some cases it allows me to be ready with my UIO
kernel module before the customer even specified the interrupt registers
of his FPGA...

Please resend with that irqcontrol issue fixed, and we can merge this as
far as I'm concerned.

Thanks for your work,
Hans

> ---
> 
>  Think of this as "User IRQ Mode V3".
> 
>  drivers/uio/Kconfig           |   13 +++
>  drivers/uio/Makefile          |    1 
>  drivers/uio/uio_pdrv_genirq.c |  169 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 183 insertions(+)
> 
> --- 0007/drivers/uio/Kconfig
> +++ work/drivers/uio/Kconfig	2008-07-09 15:34:03.000000000 +0900
> @@ -33,6 +33,19 @@ config UIO_PDRV
>  
>  	  If you don't know what to do here, say N.
>  
> +config UIO_PDRV_GENIRQ
> +	tristate "Userspace I/O platform driver with generic IRQ handling"
> +	help
> +	  Platform driver for Userspace I/O devices, including generic
> +	  interrupt handling code. Shared interrupts are not supported.
> +
> +	  This kernel driver requires that the matching userspace driver
> +	  handles interrupts in a special way. Userspace is responsible
> +	  for acknowledging the hardware device if needed, and re-enabling
> +	  interrupts in the interrupt controller using the write() syscall.
> +
> +	  If you don't know what to do here, say N.
> +
>  config UIO_SMX
>  	tristate "SMX cryptengine UIO interface"
>  	depends on UIO
> --- 0007/drivers/uio/Makefile
> +++ work/drivers/uio/Makefile	2008-07-09 15:33:02.000000000 +0900
> @@ -1,4 +1,5 @@
>  obj-$(CONFIG_UIO)	+= uio.o
>  obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
>  obj-$(CONFIG_UIO_PDRV)	+= uio_pdrv.o
> +obj-$(CONFIG_UIO_PDRV_GENIRQ)	+= uio_pdrv_genirq.o
>  obj-$(CONFIG_UIO_SMX)	+= uio_smx.o
> --- /dev/null
> +++ work/drivers/uio/uio_pdrv_genirq.c	2008-07-09 15:34:56.000000000 +0900
> @@ -0,0 +1,169 @@
> +/*
> + * drivers/uio/uio_pdrv_genirq.c
> + *
> + * Userspace I/O platform driver with generic IRQ handling code.
> + *
> + * Copyright (C) 2008 Magnus Damm
> + *
> + * Based on uio_pdrv.c by Uwe Kleine-Koenig,
> + * Copyright (C) 2008 by Digi International Inc.
> + * All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/uio_driver.h>
> +#include <linux/bitops.h>
> +#include <linux/interrupt.h>
> +#include <linux/stringify.h>
> +
> +#define DRIVER_NAME "uio_pdrv_genirq"
> +
> +struct uio_pdrv_genirq_platdata {
> +	struct uio_info *uioinfo;
> +	unsigned long flags;
> +};
> +
> +static irqreturn_t uio_pdrv_genirq_handler(int irq, struct uio_info *dev_info)
> +{
> +	struct uio_pdrv_genirq_platdata *priv = dev_info->priv;
> +
> +	/* Just disable the interrupt in the interrupt controller, and
> +	 * remember the state so we can allow user space to enable it later.
> +	 */
> +	disable_irq_nosync(irq);
> +	set_bit(0, &priv->flags);
> +	return IRQ_HANDLED;
> +}
> +
> +static int uio_pdrv_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
> +{
> +	struct uio_pdrv_genirq_platdata *priv = dev_info->priv;
> +
> +	/* Allow re-enabling of the interrupt in the interrupt controller */
> +	if (irq_on && test_and_clear_bit(0, &priv->flags)) {
> +		enable_irq(dev_info->irq);
> +		return 0;
> +	}

With irqcontrol(), if it exists, it must be possible to turn the irq on
_and_ off. It's simply defined that way. And in some cases (errors, user
app exits...) it might be necessary (or just convenient) to disable the 
interrupt by writing a zero to /dev/uioX.

Please handle the case when irq_on==0, you cannot just return -ENOSYS.

> +
> +	return -ENOSYS;
> +}
> +
> +static int uio_pdrv_genirq_probe(struct platform_device *pdev)
> +{
> +	struct uio_info *uioinfo = pdev->dev.platform_data;
> +	struct uio_pdrv_genirq_platdata *pdata;
> +	struct uio_mem *uiomem;
> +	int ret = -EINVAL;
> +	int i;
> +
> +	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
> +		dev_err(&pdev->dev, "missing platform_data\n");
> +		goto bad0;
> +	}
> +
> +	if (uioinfo->handler || uioinfo->irqcontrol || uioinfo->irq_flags) {
> +		dev_err(&pdev->dev, "interrupt configuration error\n");
> +		goto bad0;
> +	}
> +
> +	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata) {
> +		ret = -ENOMEM;
> +		dev_err(&pdev->dev, "unable to kmalloc\n");
> +		goto bad0;
> +	}
> +
> +	pdata->uioinfo = uioinfo;
> +	pdata->uioinfo->priv = pdata;
> +	uiomem = &uioinfo->mem[0];
> +
> +	for (i = 0; i < pdev->num_resources; ++i) {
> +		struct resource *r = &pdev->resource[i];
> +
> +		if (r->flags != IORESOURCE_MEM)
> +			continue;
> +
> +		if (uiomem >= &uioinfo->mem[MAX_UIO_MAPS]) {
> +			dev_warn(&pdev->dev, "device has more than "
> +					__stringify(MAX_UIO_MAPS)
> +					" I/O memory resources.\n");
> +			break;
> +		}
> +
> +		uiomem->memtype = UIO_MEM_PHYS;
> +		uiomem->addr = r->start;
> +		uiomem->size = r->end - r->start + 1;
> +		++uiomem;
> +	}
> +
> +	while (uiomem < &uioinfo->mem[MAX_UIO_MAPS]) {
> +		uiomem->size = 0;
> +		++uiomem;
> +	}
> +
> +	/* This driver requires no hardware specific kernel code to handle
> +	 * interrupts. Instead, the interrupt handler simply disables the
> +	 * interrupt in the interrupt controller. User space is responsible
> +	 * for performing hardware specific acknowledge and re-enabling of
> +	 * the interrupt in the interrupt controller.
> +	 *
> +	 * Interrupt sharing is not supported.
> +	 */
> +
> +	uioinfo->irq_flags = IRQF_DISABLED;
> +	uioinfo->handler = uio_pdrv_genirq_handler;
> +	uioinfo->irqcontrol = uio_pdrv_genirq_irqcontrol;
> +
> +	ret = uio_register_device(&pdev->dev, pdata->uioinfo);
> +	if (ret) {
> +		dev_err(&pdev->dev, "unable to register uio device\n");
> +		goto bad1;
> +	}
> +
> +	platform_set_drvdata(pdev, pdata);
> +	return 0;
> + bad1:
> +	kfree(pdata);
> + bad0:
> +	return ret;
> +}
> +
> +static int uio_pdrv_genirq_remove(struct platform_device *pdev)
> +{
> +	struct uio_pdrv_genirq_platdata *pdata = platform_get_drvdata(pdev);
> +
> +	uio_unregister_device(pdata->uioinfo);
> +	kfree(pdata);
> +	return 0;
> +}
> +
> +static struct platform_driver uio_pdrv_genirq = {
> +	.probe = uio_pdrv_genirq_probe,
> +	.remove = uio_pdrv_genirq_remove,
> +	.driver = {
> +		.name = DRIVER_NAME,
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +static int __init uio_pdrv_genirq_init(void)
> +{
> +	return platform_driver_register(&uio_pdrv_genirq);
> +}
> +
> +static void __exit uio_pdrv_genirq_exit(void)
> +{
> +	platform_driver_unregister(&uio_pdrv_genirq);
> +}
> +
> +module_init(uio_pdrv_genirq_init);
> +module_exit(uio_pdrv_genirq_exit);
> +
> +MODULE_AUTHOR("Magnus Damm");
> +MODULE_DESCRIPTION("Userspace I/O platform driver with generic IRQ handling");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:" DRIVER_NAME);
