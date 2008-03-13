Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbYCMJBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbYCMJBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 05:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYCMJB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 05:01:27 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:27434
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929AbYCMJB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 05:01:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqABAGeK2Ed8qMER/2dsb2JhbAAIpjY
X-IronPort-AV: E=Sophos;i="4.25,493,1199631600"; 
   d="scan'208";a="288979349"
Subject: Re: [PATCH v2] UIO: Implement a UIO interface for the SMX
	Cryptengine
From: Ben Nizette <bn@niasdigital.com>
To: =?ISO-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
Cc: gregkh <gregkh@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20080313095301.4aea6d0e@dilbert.local>
References: <1205316382.4344.15.camel@moss.renham>
	 <20080313095301.4aea6d0e@dilbert.local>
Content-Type: text/plain; charset=UTF-8
Organization: Nias Digital
Date: Thu, 13 Mar 2008 20:07:00 +1100
Message-Id: <1205399220.3735.4.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-13 at 09:53 +0100, Hans-Jürgen Koch wrote:
> Am Wed, 12 Mar 2008 21:06:22 +1100
> schrieb Ben Nizette <bn@niasdigital.com>:
> > 
> > This is version 2 of this patch and addresses all issues raised by
> > Hans-Jürgen Koch in his review of version 1.
> 
> But it doesn't address the issue Paul Mundt has raised. As this driver will
> probably serve as an example for other UIO platform drivers, it should be
> correct. And I also consider it a bit impolite if you completely ignore Paul,
> who has taken the time to review your driver and pointed out a mistake. His
> solution is obviously the correct one.
> 

Unfortunately v2 of this patch missed Paul's comments by about a minute.
I have made his change and was waiting any comments on this version
before I pushed out a v3.  If this version here ostensibly meets with
your approval, I shall send out a new and hopefully final version.

I too am hoping this will serve as an example to people who previously
have just used /dev/mem and polled the device; I'm very much committed
to getting it right!

Thanks,
	--Ben.

> Thanks,
> Hans
> 
> > 
> > Signed-off-by: Ben Nizette <bn@niasdigital.com>
> > ---
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 2cdb591..480fd44 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -3554,6 +3554,11 @@ M:	mhoffman@lightlink.com
> >  L:	lm-sensors@lm-sensors.org
> >  S:	Maintained
> >  
> > +SMX UIO Interface
> > +P:	Ben Nizette
> > +M:	bn@niasdigital.com
> > +S:	Maintained
> > +
> >  SOFTMAC LAYER (IEEE 802.11)
> >  P:	Daniel Drake
> >  M:	dsd@gentoo.org
> > diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> > index b778ed7..f57b347 100644
> > --- a/drivers/uio/Kconfig
> > +++ b/drivers/uio/Kconfig
> > @@ -26,4 +26,16 @@ config UIO_CIF
> >  	  To compile this driver as a module, choose M here: the module
> >  	  will be called uio_cif.
> >  
> > +config UIO_SMX
> > +	tristate "SMX cryptengine UIO interface"
> > +	depends on UIO
> > +	default n
> > +	help
> > +	  Userspace IO interface to the Cryptography engine found on the
> > +	  Nias Digital SMX boards.  These will be available from Q4 2008
> > +	  from http://www.niasdigital.com.  The userspace part of this
> > +	  driver will be released under the GPL at the same time as the
> > +	  hardware and will be able to be downloaded from the same site.
> > +
> > +	  If you compile this as a module, it will be called uio_smx.
> >  endmenu
> > diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
> > index 7fecfb4..18c4566 100644
> > --- a/drivers/uio/Makefile
> > +++ b/drivers/uio/Makefile
> > @@ -1,2 +1,3 @@
> >  obj-$(CONFIG_UIO)	+= uio.o
> >  obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
> > +obj-$(CONFIG_UIO_SMX)	+= uio_smx.o
> > diff --git a/drivers/uio/uio_smx.c b/drivers/uio/uio_smx.c
> > new file mode 100644
> > index 0000000..6a8bb6e
> > --- /dev/null
> > +++ b/drivers/uio/uio_smx.c
> > @@ -0,0 +1,118 @@
> > +/*
> > + * UIO SMX Cryptengine driver.
> > + *
> > + * (C) 2008 Nias Digital P/L <bn@niasdigital.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + */
> > +
> > +#include <linux/device.h>
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/uio_driver.h>
> > +
> > +#include <asm/io.h>
> > +
> > +#define SMX_CSR  0x00000000
> > +#define SMX_EnD  0x00000001
> > +#define SMX_RUN  0x00000002
> > +#define SMX_DRDY 0x00000004
> > +#define SMX_ERR  0x00000008
> > +
> > +static irqreturn_t smx_handler(int irq, struct uio_info *dev_info)
> > +{
> > +	void __iomem *csr = dev_info->mem[0].internal_addr + SMX_CSR;
> > +
> > +	u32 status = ioread32(csr);
> > +
> > +	if (!csr & SMX_DRDY)
> > +		return IRQ_NONE;
> > +
> > +	/* Disable interrupt */
> > +	iowrite32(status & ~SMX_DRDY, csr);
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static int __devinit smx_ce_probe(struct platform_device *dev)
> > +{
> > +	struct uio_info *info;
> > +	struct resource *regs;
> > +
> > +	info = kzalloc(sizeof(struct uio_info), GFP_KERNEL);
> > +	if (!info)
> > +		return -ENOMEM;
> > +
> > +	regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
> > +	if (!regs)
> > +		goto out_free;
> > +
> > +	info->mem[0].addr = regs->start;
> > +	if (!info->mem[0].addr)
> > +		goto out_free;
> > +	info->mem[0].internal_addr = ioremap(regs->start,
> > +					     regs->end - regs->start);
> > +	if (!info->mem[0].internal_addr)
> > +		goto out_free;
> > +
> > +	info->mem[0].size = regs->end - regs->start;
> > +	info->mem[0].memtype = UIO_MEM_PHYS;
> > +
> > +	info->name = "smx-ce";
> > +	info->version = "0.03";
> > +	info->irq = platform_get_irq(dev, 0);
> > +	info->irq_flags = IRQF_SHARED;
> > +	info->handler = smx_handler;
> > +
> > +	platform_set_drvdata(dev, info);
> > +
> > +	if (uio_register_device(&dev->dev, info))
> > +		goto out_unmap;
> > +
> > +	return 0;
> > +out_unmap:
> > +	iounmap(info->mem[0].internal_addr);
> > +out_free:
> > +	kfree(info);
> > +
> > +	return -ENODEV;
> > +}
> > +
> > +static int __devexit smx_ce_remove(struct platform_device *dev)
> > +{
> > +	struct uio_info *info = platform_get_drvdata(dev);
> > +
> > +	uio_unregister_device(info);
> > +	platform_set_drvdata(dev, NULL);
> > +	iounmap(info->mem[0].internal_addr);
> > +
> > +	kfree(info);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver smx_ce_driver = {
> > +	.probe		= smx_ce_probe,
> > +	.remove		= __devexit_p(smx_ce_remove),
> > +	.driver		= {
> > +		.name	= "smx-ce",
> > +		.owner	= THIS_MODULE,
> > +	},
> > +};
> > +
> > +static int __init smx_ce_init_module(void)
> > +{
> > +	return platform_driver_register(&smx_ce_driver);
> > +}
> > +module_init(smx_ce_init_module);
> > +
> > +static void __exit smx_ce_exit_module(void)
> > +{
> > +	platform_driver_unregister(&smx_ce_driver);
> > +}
> > +module_exit(smx_ce_exit_module);
> > +
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_AUTHOR("Ben Nizette <bn@niasdigital.com>");
