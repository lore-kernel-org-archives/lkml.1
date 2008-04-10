Return-Path: <linux-kernel-owner+w=401wt.eu-S1759201AbYDJWsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbYDJWsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYDJWsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:48:15 -0400
Received: from www.tglx.de ([62.245.132.106]:48995 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029AbYDJWsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:48:12 -0400
Date: Fri, 11 Apr 2008 00:48:04 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] UIO: generic platform driver
Message-ID: <20080410224804.GI3193@local>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-5-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1207831023-8583-5-git-send-email-Uwe.Kleine-Koenig@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 02:37:03PM +0200, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> ---
>  drivers/uio/Kconfig    |    7 ++
>  drivers/uio/Makefile   |    1 +
>  drivers/uio/uio_pdrv.c |  165 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 173 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/uio/uio_pdrv.c

I looked it over again. Some comments below.
I'm beginning to like the idea...

Hans

> 
> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> index 6bc2891..5ec353f 100644
> --- a/drivers/uio/Kconfig
> +++ b/drivers/uio/Kconfig
> @@ -26,4 +26,11 @@ config UIO_CIF
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called uio_cif.
>  
> +config UIO_PDRV
> +	tristate "Userspace I/O platform driver"
> +	help
> +	  Generic platform driver for Userspace I/O devices.
> +
> +	  If you don't know what to do here, say N.
> +
>  endif
> diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
> index 7fecfb4..a6dcb99 100644
> --- a/drivers/uio/Makefile
> +++ b/drivers/uio/Makefile
> @@ -1,2 +1,3 @@
>  obj-$(CONFIG_UIO)	+= uio.o
>  obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
> +obj-$(CONFIG_UIO_PDRV) += uio_pdrv.o
> diff --git a/drivers/uio/uio_pdrv.c b/drivers/uio/uio_pdrv.c
> new file mode 100644
> index 0000000..31d1aaf
> --- /dev/null
> +++ b/drivers/uio/uio_pdrv.c
> @@ -0,0 +1,165 @@
> +/*
> + * drivers/uio/uio_pdrv.c
> + *
> + * Copyright (C) 2008 by Digi International Inc.
> + * All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +#include <linux/clk.h>
> +#include <linux/platform_device.h>
> +#include <linux/uio_driver.h>
> +
> +#define DRIVER_NAME "uio"
> +
> +/* XXX: I thought there already exists something like STRINGIFY, but I could not
> + * find it ...
> + */

Why do you want that macro? You only use it once. The macro definition and the
comment above are more than you can ever expect to save with it.

> +#ifndef STRINGIFY
> +#define STRINGIFY(x) __STRINGIFY_HELPER(x)
> +#define __STRINGIFY_HELPER(x) #x
> +#endif
> +
> +struct uio_platdata {
> +	struct uio_info *uioinfo;
> +	struct clk *clk;
> +};
> +
> +static int uio_pdrv_open(struct uio_info *info, struct inode *inode)
> +{
> +	struct uio_platdata *pdata = info->priv;
> +	int ret;
> +
> +	BUG_ON(pdata->uioinfo != info);

How can this BUG ever be triggered?

> +
> +	ret = clk_enable(pdata->clk);
> +	if (ret)
> +		/* XXX: better use dev_dbg, but which device should I use?
> +		 * info->uio_dev->dev isn't accessible here as struct uio_device
> +		 * is opaque.
> +		 */
> +		pr_debug("%s: err_clk_enable -> %d\n", __func__, ret);
> +
> +	return ret;
> +}
> +
> +static int uio_pdrv_release(struct uio_info *info, struct inode *inode)
> +{
> +	struct uio_platdata *pdata = info->priv;
> +
> +	BUG_ON(pdata->uioinfo != info);
> +
> +	clk_disable(pdata->clk);
> +
> +	return 0;
> +}
> +
> +static int uio_pdrv_probe(struct platform_device *pdev)
> +{
> +	struct uio_info *uioinfo = pdev->dev.platform_data;
> +	struct uio_platdata *pdata;
> +	struct uio_mem *uiomem;
> +	int ret = -ENODEV;
> +	int i;
> +
> +	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
> +		dev_dbg(&pdev->dev, "%s: err_uioinfo\n", __func__);
> +		goto err_uioinfo;
> +	}
> +
> +	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata) {
> +		ret = -ENOMEM;
> +		dev_dbg(&pdev->dev, "%s: err_alloc_pdata\n", __func__);
> +		goto err_alloc_pdata;
> +	}
> +
> +	pdata->uioinfo = uioinfo;
> +
> +	pdata->clk = clk_get(&pdev->dev, DRIVER_NAME);
> +	if (IS_ERR(pdata->clk)) {
> +		ret = PTR_ERR(pdata->clk);
> +		dev_dbg(&pdev->dev, "%s: err_clk_get -> %d\n", __func__, ret);
> +		goto err_clk_get;
> +	}
> +
> +	uiomem = &uioinfo->mem[0];
> +
> +	for (i = 0; i < pdev->num_resources; ++i) {
> +		struct resource *r = &pdev->resource[i];

Please don't define new variables in the middle of a function.

> +
> +		if (r->flags != IORESOURCE_MEM)
> +			continue;
> +
> +		if (uiomem >= &uioinfo->mem[MAX_UIO_MAPS]) {

I'd prefer this:
		if (i >= MAX_UIO_MAPS) {
		...


> +			dev_warn(&pdev->dev, "device has more than "
> +					STRINGIFY(MAX_UIO_MAPS)
> +					" I/O memory resources.\n");

What about this:

			dev_warn(&pdev->dev, "device has more than %d"
				" I/O memory resources.\n", MAX_UIO_MAPS);

would save the macro.

> +			break;
> +		}
> +
> +		uiomem->memtype = UIO_MEM_PHYS;
> +		uiomem->addr = r->start;
> +		uiomem->size = r->end - r->start + 1;
> +		++uiomem;
> +	}
> +
> +	pdata->uioinfo->open = uio_pdrv_open;
> +	pdata->uioinfo->release = uio_pdrv_release;
> +	pdata->uioinfo->priv = pdata;
> +
> +	ret = uio_register_device(&pdev->dev, pdata->uioinfo);
> +
> +	if (ret) {
> +		clk_put(pdata->clk);
> +err_clk_get:
> +
> +		kfree(pdata);
> +err_alloc_pdata:
> +err_uioinfo:
> +		return ret;
> +	}

How I hate labels within blocks... OK, I admit, it looks good here...
Well...

> +
> +	platform_set_drvdata(pdev, pdata);
> +
> +	return 0;
> +}
> +
> +static int uio_pdrv_remove(struct platform_device *pdev)
> +{
> +	struct uio_platdata *pdata = platform_get_drvdata(pdev);
> +
> +	uio_unregister_device(pdata->uioinfo);
> +
> +	clk_put(pdata->clk);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver uio_pdrv = {
> +	.probe = uio_pdrv_probe,
> +	.remove = uio_pdrv_remove,
> +	.driver = {
> +		.name = DRIVER_NAME,
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +static int __init uio_pdrv_init(void)
> +{
> +	return platform_driver_register(&uio_pdrv);
> +}
> +
> +static void __exit uio_pdrv_exit(void)
> +{
> +	platform_driver_unregister(&uio_pdrv);
> +}
> +module_init(uio_pdrv_init);
> +module_exit(uio_pdrv_exit);
> +
> +MODULE_AUTHOR("Uwe Kleine-Koenig");
> +MODULE_DESCRIPTION("Userspace I/O platform driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:" DRIVER_NAME);
> -- 
> 1.5.4.5
