Return-Path: <linux-kernel-owner+w=401wt.eu-S1758444AbYDJUJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbYDJUJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYDJUJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:09:03 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:11489 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751736AbYDJUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:09:01 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-11.tower-29.messagelabs.com!1207858138!650334!7
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Thu, 10 Apr 2008 22:08:19 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] UIO: generic platform driver
Message-ID: <20080410200819.GA16292@digi.com>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-5-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410195438.GE3193@local>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080410195438.GE3193@local>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 10 Apr 2008 20:08:19.0887 (UTC) FILETIME=[9F1293F0:01C89B46]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15842.001
X-TM-AS-Result: No--27.101000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello Hans,

Hans J. Koch wrote:
> On Thu, Apr 10, 2008 at 02:37:03PM +0200, Uwe Kleine-König wrote:
> > Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> > ---
> >  drivers/uio/Kconfig    |    7 ++
> >  drivers/uio/Makefile   |    1 +
> >  drivers/uio/uio_pdrv.c |  165 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 173 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/uio/uio_pdrv.c
> 
> I'm a bit slow today, I don't really understand what this is good for.
> It's to complicated to serve as a template, and it doesn't support
> interrupts, so it's not good for any real device, too. So the only
> usecase would be an irq-less platform_device that just needs its memory
> mapped. Is this what you intended? What do _you_ use it for?
In my use case I don't use an irq, but you're free to provide a handler
when you create the platform device.  Attached is the file that provides
an uio platform device.  Current vanilla's support for ns9xxx isn't
(yet) complete enough to compile that, but you should be able to see how
it works.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962

--sm4nu43k4a2Rpi4c
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="plat-uio.c"

/*
 * arch/arm/mach-ns9xxx/plat-uio.c
 *
 * Copyright (C) 2008 by Digi International Inc.
 * All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 as published by
 * the Free Software Foundation.
 */
#include <linux/err.h>
#include <linux/platform_device.h>
#include <linux/uio_driver.h>

#include <asm/mach-types.h>

#include "clock.h"

#define DRIVER_NAME "uio"

struct ns9xxx_uio_platdata {
	struct uio_info uioinfo;
	struct clk clk;
};

static struct platform_device *__init ns9xxx_plat_uio_alloc(
		struct ns9xxx_uio_platdata **pdata)
{
	struct platform_device *pdev;
	static int id;

	BUG_ON(!pdata);

	pdev = platform_device_alloc(DRIVER_NAME, id);
	if (!pdev)
		goto err;

	*pdata = kzalloc(sizeof(**pdata), GFP_KERNEL);
	if (!*pdata) {
err:
		platform_device_put(pdev);
		return ERR_PTR(-ENOMEM);
	}

	(*pdata)->clk.owner = THIS_MODULE;
	(*pdata)->clk.name = DRIVER_NAME;
	(*pdata)->clk.id = id;

	pdev->dev.platform_data = *pdata;

	++id;

	return pdev;
}

static int __init ns9xxx_plat_uio_inc20otter_init(void)
{
	struct ns9xxx_uio_platdata *uninitialized_var(pdata);
	struct platform_device *pdev = ns9xxx_plat_uio_alloc(&pdata);
	struct resource res[] = {
		{
			.start = 0x70000000,
			.end = 0x70001fff,
			.flags = IORESOURCE_MEM,
		}, {
			.start = 0xa0700000,
			.end = 0xa070027b,
			.flags = IORESOURCE_MEM,
		}
	};
	int ret;

	if (IS_ERR(pdev)) {
		ret = PTR_ERR(pdev);
		pr_debug("%s: err_alloc_pdev -> %d\n", __func__, ret);
		goto err_alloc_pdev;
	}

	ret = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
	if (ret) {
		pr_debug("%s: err_add_resources -> %d\n", __func__, ret);
		goto err_add_resources;
	}

	ret = clk_register(&pdata->clk);
	if (ret) {
		pr_debug("%s: err_clk_register -> %d", __func__, ret);
		goto err_clk_register;
	}

	pdata->uioinfo.name = "inc20otter CS3";
	pdata->uioinfo.version = "0.0a";
	pdata->uioinfo.irq = UIO_IRQ_NONE;

	ret = platform_device_add(pdev);
	if (ret) {

		clk_unregister(&pdata->clk);
err_clk_register:
err_add_resources:

		/* this kfrees pdata, too */
		platform_device_put(pdev);
err_alloc_pdev:
		return ret;
	}

	return 0;
}


static int __init ns9xxx_plat_uio_init(void)
{
	if (machine_is_inc20otter())
		ns9xxx_plat_uio_inc20otter_init();

	return 0;
}

arch_initcall(ns9xxx_plat_uio_init);

--sm4nu43k4a2Rpi4c--
