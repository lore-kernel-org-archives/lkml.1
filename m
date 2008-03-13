Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbYCMKHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbYCMKHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYCMKHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:07:10 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:39753 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751293AbYCMKHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:07:08 -0400
Date: Thu, 13 Mar 2008 19:06:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ben Nizette <bn@niasdigital.com>
Cc: Hans-J?rgen Koch <hjk@linutronix.de>, gregkh <gregkh@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] UIO: Implement a UIO interface for the SMX Cryptengine
Message-ID: <20080313100655.GA6705@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ben Nizette <bn@niasdigital.com>,
	Hans-J?rgen Koch <hjk@linutronix.de>, gregkh <gregkh@suse.de>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1205400940.3735.15.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205400940.3735.15.camel@moss.renham>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 08:35:40PM +1100, Ben Nizette wrote:
> diff --git a/drivers/uio/uio_smx.c b/drivers/uio/uio_smx.c
> new file mode 100644
> index 0000000..fda8b8b
> --- /dev/null
> +++ b/drivers/uio/uio_smx.c
> @@ -0,0 +1,118 @@
> +/*
> + * UIO SMX Cryptengine driver.
> + *
> + * (C) 2008 Nias Digital P/L <bn@niasdigital.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
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
linux/io.h is preferable here.

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
> +
> +	info->mem[0].size = regs->end - regs->start + 1;
> +	info->mem[0].internal_addr = ioremap(regs->start, info->mem[0].size);
> +	if (!info->mem[0].internal_addr)
> +		goto out_free;
> +
> +	info->mem[0].memtype = UIO_MEM_PHYS;
> +
> +	info->name = "smx-ce";
> +	info->version = "0.03";

You may as well use DRV_NAME and DRV_VERSION, then you can toss that over
to MODULE_VERSION() if you're so inclined. It's generally nice to keep
modinfo happy.

> +	info->irq = platform_get_irq(dev, 0);
> +	info->irq_flags = IRQF_SHARED;
> +	info->handler = smx_handler;
> +
platform_get_irq() can fail, which you don't presently handle (though I
guess uio_register_device() will error out if you hand off -ENXIO as your
IRQ anyways, so it's not technically an issue). That's a pretty minor
issue, though, but might be something you wish to fix up if you are
planning on using this as an example driver for others.

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
Your error paths are also pretty quiet. A dev_err() or so in the few
failure cases you do have might not be a terrible idea.

uio_register_device() also has quite a few different error cases, so it's
at least worth preserving the error value and returning that back,
rather than always returning -ENODEV.
