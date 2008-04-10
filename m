Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbYDJVRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbYDJVRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 17:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbYDJVR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 17:17:26 -0400
Received: from www.tglx.de ([62.245.132.106]:34780 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756454AbYDJVRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 17:17:25 -0400
Date: Thu, 10 Apr 2008 23:17:17 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] UIO: generic platform driver
Message-ID: <20080410211717.GG3193@local>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-5-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410195438.GE3193@local> <20080410200819.GA16292@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080410200819.GA16292@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 10:08:19PM +0200, Uwe Kleine-König wrote:
> Hello Hans,
> 
> Hans J. Koch wrote:
> > On Thu, Apr 10, 2008 at 02:37:03PM +0200, Uwe Kleine-König wrote:
> > > Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> > > ---
> > >  drivers/uio/Kconfig    |    7 ++
> > >  drivers/uio/Makefile   |    1 +
> > >  drivers/uio/uio_pdrv.c |  165 ++++++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 173 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/uio/uio_pdrv.c
> > 
> > I'm a bit slow today, I don't really understand what this is good for.
> > It's to complicated to serve as a template, and it doesn't support
> > interrupts, so it's not good for any real device, too. So the only
> > usecase would be an irq-less platform_device that just needs its memory
> > mapped. Is this what you intended? What do _you_ use it for?
> In my use case I don't use an irq, but you're free to provide a handler
> when you create the platform device.

Hmm, I get the idea. You could have a UIO driver for a platform device
just by setting up a struct in the board support file. Nice thought.

Hmm. It's late, let me sleep over it... Tomorrow I'll look at it again.

Thanks,
Hans


> Attached is the file that provides
> an uio platform device.  Current vanilla's support for ns9xxx isn't
> (yet) complete enough to compile that, but you should be able to see how
> it works.
> 
> Best regards
> Uwe
> 
> -- 
> Uwe Kleine-König, Software Engineer
> Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
> Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962

> /*
>  * arch/arm/mach-ns9xxx/plat-uio.c
>  *
>  * Copyright (C) 2008 by Digi International Inc.
>  * All rights reserved.
>  *
>  * This program is free software; you can redistribute it and/or modify it
>  * under the terms of the GNU General Public License version 2 as published by
>  * the Free Software Foundation.
>  */
> #include <linux/err.h>
> #include <linux/platform_device.h>
> #include <linux/uio_driver.h>
> 
> #include <asm/mach-types.h>
> 
> #include "clock.h"
> 
> #define DRIVER_NAME "uio"
> 
> struct ns9xxx_uio_platdata {
> 	struct uio_info uioinfo;
> 	struct clk clk;
> };
> 
> static struct platform_device *__init ns9xxx_plat_uio_alloc(
> 		struct ns9xxx_uio_platdata **pdata)
> {
> 	struct platform_device *pdev;
> 	static int id;
> 
> 	BUG_ON(!pdata);
> 
> 	pdev = platform_device_alloc(DRIVER_NAME, id);
> 	if (!pdev)
> 		goto err;
> 
> 	*pdata = kzalloc(sizeof(**pdata), GFP_KERNEL);
> 	if (!*pdata) {
> err:
> 		platform_device_put(pdev);
> 		return ERR_PTR(-ENOMEM);
> 	}
> 
> 	(*pdata)->clk.owner = THIS_MODULE;
> 	(*pdata)->clk.name = DRIVER_NAME;
> 	(*pdata)->clk.id = id;
> 
> 	pdev->dev.platform_data = *pdata;
> 
> 	++id;
> 
> 	return pdev;
> }
> 
> static int __init ns9xxx_plat_uio_inc20otter_init(void)
> {
> 	struct ns9xxx_uio_platdata *uninitialized_var(pdata);
> 	struct platform_device *pdev = ns9xxx_plat_uio_alloc(&pdata);
> 	struct resource res[] = {
> 		{
> 			.start = 0x70000000,
> 			.end = 0x70001fff,
> 			.flags = IORESOURCE_MEM,
> 		}, {
> 			.start = 0xa0700000,
> 			.end = 0xa070027b,
> 			.flags = IORESOURCE_MEM,
> 		}
> 	};
> 	int ret;
> 
> 	if (IS_ERR(pdev)) {
> 		ret = PTR_ERR(pdev);
> 		pr_debug("%s: err_alloc_pdev -> %d\n", __func__, ret);
> 		goto err_alloc_pdev;
> 	}
> 
> 	ret = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
> 	if (ret) {
> 		pr_debug("%s: err_add_resources -> %d\n", __func__, ret);
> 		goto err_add_resources;
> 	}
> 
> 	ret = clk_register(&pdata->clk);
> 	if (ret) {
> 		pr_debug("%s: err_clk_register -> %d", __func__, ret);
> 		goto err_clk_register;
> 	}
> 
> 	pdata->uioinfo.name = "inc20otter CS3";
> 	pdata->uioinfo.version = "0.0a";
> 	pdata->uioinfo.irq = UIO_IRQ_NONE;
> 
> 	ret = platform_device_add(pdev);
> 	if (ret) {
> 
> 		clk_unregister(&pdata->clk);
> err_clk_register:
> err_add_resources:
> 
> 		/* this kfrees pdata, too */
> 		platform_device_put(pdev);
> err_alloc_pdev:
> 		return ret;
> 	}
> 
> 	return 0;
> }
> 
> 
> static int __init ns9xxx_plat_uio_init(void)
> {
> 	if (machine_is_inc20otter())
> 		ns9xxx_plat_uio_inc20otter_init();
> 
> 	return 0;
> }
> 
> arch_initcall(ns9xxx_plat_uio_init);

