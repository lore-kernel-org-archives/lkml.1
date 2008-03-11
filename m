Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbYCKISA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbYCKISA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYCKIRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:17:43 -0400
Received: from www.tglx.de ([62.245.132.106]:42279 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbYCKIRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:17:42 -0400
Date: Tue, 11 Mar 2008 09:15:25 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: Ben Nizette <bn@niasdigital.com>
Cc: gregkh@suse.de, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UIO: Implement a UIO interface for the SMX Cryptengine
Message-ID: <20080311091525.2bd0c7ed@dilbert.local>
In-Reply-To: <1205211430.3817.15.camel@moss.renham>
References: <1205211430.3817.15.camel@moss.renham>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tue, 11 Mar 2008 15:57:10 +1100
schrieb Ben Nizette <bn@niasdigital.com>:

Hi Ben,

> This patch implements a UIO interface for the SMX Cryptengine.
> 
> The Cryptengine found on the Nias Digital SMX board is best suited
> for a UIO interface.  It is not wired in to the cryptographic API
> as the engine handles it's own keys, algorithms, everything.  All
> that we know about is that if there's room in the buffer, you can
> write data to it and when there's data ready, you read it out again.
> 
> There isn't necessarily even any direct correlation between data
> going in and data coming out again, the engine may consume or
> generate data all on its own.
> 
> This driver is for proprietary hardware but we're always told to
> submit the drivers anyway; here you are.  :-)

I've got no problems with that, but I'd like to know if that board can
be bought somewhere (the niasdigital.com homepage doesn't mention it)
and if and under which license the userspace part of the driver is
available. The homepage says you're in favor of the GPL, so if it can
be checked out or downloaded somewhere, please mention it, maybe in
the Kconfig help text. If the userspace part is proprietary, please
mention that, too.

There are some minor problems with your patch, see below.
Note: testing your patches with checkpatch.pl would help...

> 
> Signed-Off-By: Ben Nizette <bn@niasdigital.com>

that should be signed-off-by (lower-case)

> ---
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2cdb591..480fd44 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3554,6 +3554,11 @@ M:	mhoffman@lightlink.com
>  L:	lm-sensors@lm-sensors.org
>  S:	Maintained
>  
> +SMX UIO Interface
> +P:	Ben Nizette
> +M:	bn@niasdigital.com
> +S:	Maintained
> +
>  SOFTMAC LAYER (IEEE 802.11)
>  P:	Daniel Drake
>  M:	dsd@gentoo.org
> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> index b778ed7..e1ab43b 100644
> --- a/drivers/uio/Kconfig
> +++ b/drivers/uio/Kconfig
> @@ -26,4 +26,12 @@ config UIO_CIF
>  	  To compile this driver as a module, choose M here: the
> module will be called uio_cif.
>  
> +config UIO_SMX
> +	tristate "SMX cryptengine UIO interface"
> +	depends on UIO
> +	default n
> +	help
> +	  Userspace IO interface to the Cryptography engine found on
> the
> +	  Nias Digital SMX boards.  If you compile this as a module,
> it
> +	  will be called uio_smx.

Please give a hint that a userspace part is needed, and how it can be
obtained.

>  endmenu
> diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
> index 7fecfb4..18c4566 100644
> --- a/drivers/uio/Makefile
> +++ b/drivers/uio/Makefile
> @@ -1,2 +1,3 @@
>  obj-$(CONFIG_UIO)	+= uio.o
>  obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
> +obj-$(CONFIG_UIO_SMX)	+= uio_smx.o
> diff --git a/drivers/uio/uio_smx.c b/drivers/uio/uio_smx.c
> new file mode 100644
> index 0000000..e56b37d
> --- /dev/null
> +++ b/drivers/uio/uio_smx.c
> @@ -0,0 +1,114 @@
> +/*
> + * UIO SMX Cryptengine driver.
> + *
> + * (C) 2008 Nias Digital P/L <bn@niasdigital.com>
> + *
> + * This program is free software; you can redistribute it and/or
> modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/uio_driver.h>
> +
> +#include <asm/io.h>
> +
> +#define SMX_CSR  0x00000000
> +#define SMX_EnD  0x00000001
> +#define SMX_RUN  0x00000002
> +#define SMX_DRDY 0x00000004
> +#define SMX_ERR  0x00000008
> +
> +static irqreturn_t smx_handler(int irq, struct uio_info *dev_info)
> +{
> +	void __iomem *csr = dev_info->mem[0].internal_addr + SMX_CSR;
> +
> +	u32 status = ioread32(csr);
> +
> +	/* Disable interrupt */
> +	iowrite8(status & ~SMX_DRDY, csr);
> +	return IRQ_HANDLED;
> +}

You don't support shared interrupts. Is that intentional?

> +
> +static int __devinit smx_ce_probe(struct platform_device *dev)
> +{
> +	struct uio_info *info;
> +	struct resource *regs;
> +
> +	info = kzalloc(sizeof(struct uio_info), GFP_KERNEL);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
> +	if (!regs)
> +		goto out_free;
> +
> +	info->mem[0].addr = regs->start;
> +	if (!info->mem[0].addr)
> +		goto out_free;
> +	info->mem[0].internal_addr = ioremap(regs->start, regs->end -
> regs->start);

Word wrap - please fix your mail client

> +	if (!info->mem[0].internal_addr)
> +		goto out_free;
> +
> +	info->mem[0].size = regs->end - regs->start;
> +	info->mem[0].memtype = UIO_MEM_PHYS;
> +
> +	info->name = "smx-ce";
> +	info->version = "0.03";
> +	info->irq = platform_get_irq(dev, 0);
> +	info->irq_flags = 0;
> +	info->handler = smx_handler;
> +
> +	platform_set_drvdata(dev, info);
> +
> +	if (uio_register_device(&dev->dev, info))
> +		goto out_unmap;
> +
> +	return 0;
> +out_unmap:
> +	iounmap(info->mem[0].internal_addr);
> +out_free:
> +	kfree(info);
> +
> +	return -ENODEV;
> +}
> +
> +static int __devexit smx_ce_remove(struct platform_device *dev)
> +{
> +	struct uio_info *info = platform_get_drvdata(dev);
> +
> +	uio_unregister_device(info);
> +	platform_set_drvdata(dev, NULL);
> +	iounmap(info->mem[0].internal_addr);
> +
> +	kfree (info);

No space before parenthesis

> +
> +	return 0;
> +}
> +
> +static struct platform_driver smx_ce_driver = {
> +	.probe		= smx_ce_probe,
> +	.remove		= __devexit_p(smx_ce_remove),
> +	.driver		= {
> +		.name	= "smx-ce",
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static int __init smx_ce_init_module(void)
> +{
> +	return platform_driver_register(&smx_ce_driver);
> +}
> +module_init(smx_ce_init_module);
> +
> +static void __exit smx_ce_exit_module(void)
> +{
> +	platform_driver_unregister(&smx_ce_driver);
> +}
> +module_exit(smx_ce_exit_module);
> +
> +MODULE_LICENSE("GPL V2");

this needs to be "GPL v2" (lowercase 'v'), otherwise it won't build the
module (at least on 2.6.25-rc5).

> +MODULE_AUTHOR("Ben Nizette <bn@niasdigital.com>");
