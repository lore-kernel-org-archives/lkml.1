Return-Path: <linux-kernel-owner+w=401wt.eu-S1759949AbYDKKeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949AbYDKKeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758229AbYDKKd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:33:56 -0400
Received: from www.tglx.de ([62.245.132.106]:60072 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757603AbYDKKd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:33:56 -0400
Date: Fri, 11 Apr 2008 12:33:46 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 v2] [RFC] UIO: generic platform driver
Message-ID: <20080411103346.GC3185@local>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-5-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410224804.GI3193@local> <20080411062106.GA18096@digi.com> <20080411092158.GB31625@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080411092158.GB31625@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 11:21:58AM +0200, Uwe Kleine-König wrote:
> 
> Below is a new version that uses linux/stringify and zeros size for
> unused mappings (line 102ff).

Thanks, but it doesn't compile, neither with -rc8 nor with Linus' git.

One problem can easily be fixed, the macro is called __stringify, not
stringify.

But what about this:

ERROR: "clk_get" [drivers/uio/uio_pdrv.ko] undefined!
ERROR: "clk_enable" [drivers/uio/uio_pdrv.ko] undefined!
ERROR: "clk_disable" [drivers/uio/uio_pdrv.ko] undefined!
ERROR: "clk_put" [drivers/uio/uio_pdrv.ko] undefined!

Do you have any extra patches applied?
Against which kernel do you test?

Thanks,
Hans


> 
> Best regards
> Uwe
> 
>  drivers/uio/Kconfig    |    7 ++
>  drivers/uio/Makefile   |    1 +
>  drivers/uio/uio_pdrv.c |  163 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 171 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/uio/uio_pdrv.c
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
> index 0000000..47506aa
> --- /dev/null
> +++ b/drivers/uio/uio_pdrv.c
> @@ -0,0 +1,163 @@
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
> +#include <linux/stringify.h>
> +
> +#define DRIVER_NAME "uio"
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
> +
> +		if (r->flags != IORESOURCE_MEM)
> +			continue;
> +
> +		if (uiomem >= &uioinfo->mem[MAX_UIO_MAPS]) {
> +			dev_warn(&pdev->dev, "device has more than "
> +					stringify(MAX_UIO_MAPS)
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
> 
> 
> 
> -- 
> Uwe Kleine-König, Software Engineer
> Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
> Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
