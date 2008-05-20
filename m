Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbYETVJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbYETVJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761684AbYETVI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:08:57 -0400
Received: from www.tglx.de ([62.245.132.106]:48101 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758895AbYETVIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:08:55 -0400
Date: Tue, 20 May 2008 23:08:44 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UIO: generic platform driver
Message-ID: <20080520210844.GF3220@local>
References: <20080520092312.GA10745@digi.com> <1211275482-11249-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1211275482-11249-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1211275482-11249-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 11:24:42AM +0200, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

> ---
>  drivers/uio/Kconfig    |    7 +++
>  drivers/uio/Makefile   |    1 +
>  drivers/uio/uio_pdrv.c |  118 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 126 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/uio/uio_pdrv.c
> 
> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> index 78e139c..2e9079d 100644
> --- a/drivers/uio/Kconfig
> +++ b/drivers/uio/Kconfig
> @@ -26,6 +26,13 @@ config UIO_CIF
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
>  config UIO_SMX
>  	tristate "SMX cryptengine UIO interface"
>  	default n
> diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
> index 18c4566..e00ce0d 100644
> --- a/drivers/uio/Makefile
> +++ b/drivers/uio/Makefile
> @@ -1,3 +1,4 @@
>  obj-$(CONFIG_UIO)	+= uio.o
>  obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
> +obj-$(CONFIG_UIO_PDRV)	+= uio_pdrv.o
>  obj-$(CONFIG_UIO_SMX)	+= uio_smx.o
> diff --git a/drivers/uio/uio_pdrv.c b/drivers/uio/uio_pdrv.c
> new file mode 100644
> index 0000000..5d0d2e8
> --- /dev/null
> +++ b/drivers/uio/uio_pdrv.c
> @@ -0,0 +1,118 @@
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
> +#include <linux/platform_device.h>
> +#include <linux/uio_driver.h>
> +#include <linux/stringify.h>
> +
> +#define DRIVER_NAME "uio"
> +
> +struct uio_platdata {
> +	struct uio_info *uioinfo;
> +};
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
> +	pdata->uioinfo->priv = pdata;
> +
> +	ret = uio_register_device(&pdev->dev, pdata->uioinfo);
> +
> +	if (ret) {
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
> 1.5.5.1
