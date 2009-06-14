Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbZFNMPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbZFNMPr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbZFNMPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:15:38 -0400
Received: from www.tglx.de ([62.245.132.106]:41360 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756259AbZFNMPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:15:37 -0400
Date: Sun, 14 Jun 2009 14:15:19 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       devicetree-discuss@ozlabs.org, Magnus Damm <magnus.damm@gmail.com>,
       "Hans J. Koch" <hjk@linutronix.de>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/2] uio/pdrv_genirq: Refactor probe routine to expose
	a generic part
Message-ID: <20090614121519.GC3639@local>
References: <1244765062-14144-1-git-send-email-w.sang@pengutronix.de> <1244765062-14144-2-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244765062-14144-2-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 02:04:21AM +0200, Wolfram Sang wrote:
> This patch refactors the probe routine, so that an of-version of a similiar
> driver can pick it up later.

Looks good to me.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Cc: Hans J. Koch <hjk@linutronix.de>
> Cc: Greg KH <gregkh@suse.de>
> ---
>  drivers/uio/uio_pdrv_genirq.c   |   60 ++++++++++++++++++++------------------
>  include/linux/uio_pdrv_genirq.h |   13 ++++++++
>  2 files changed, 45 insertions(+), 28 deletions(-)
>  create mode 100644 include/linux/uio_pdrv_genirq.h
> 
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 3f06818..8f8a0f9 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -20,15 +20,10 @@
>  #include <linux/bitops.h>
>  #include <linux/interrupt.h>
>  #include <linux/stringify.h>
> +#include <linux/uio_pdrv_genirq.h>
>  
>  #define DRIVER_NAME "uio_pdrv_genirq"
>  
> -struct uio_pdrv_genirq_platdata {
> -	struct uio_info *uioinfo;
> -	spinlock_t lock;
> -	unsigned long flags;
> -};
> -
>  static irqreturn_t uio_pdrv_genirq_handler(int irq, struct uio_info *dev_info)
>  {
>  	struct uio_pdrv_genirq_platdata *priv = dev_info->priv;
> @@ -68,29 +63,18 @@ static int uio_pdrv_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
>  	return 0;
>  }
>  
> -static int uio_pdrv_genirq_probe(struct platform_device *pdev)
> +int __uio_pdrv_genirq_probe(struct device *dev, struct uio_info *uioinfo,
> +		struct resource *resources, unsigned int num_resources)
>  {
> -	struct uio_info *uioinfo = pdev->dev.platform_data;
>  	struct uio_pdrv_genirq_platdata *priv;
>  	struct uio_mem *uiomem;
> -	int ret = -EINVAL;
> -	int i;
> -
> -	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
> -		dev_err(&pdev->dev, "missing platform_data\n");
> -		goto bad0;
> -	}
> -
> -	if (uioinfo->handler || uioinfo->irqcontrol ||
> -	    uioinfo->irq_flags & IRQF_SHARED) {
> -		dev_err(&pdev->dev, "interrupt configuration error\n");
> -		goto bad0;
> -	}
> +	unsigned int i;
> +	int ret;
>  
>  	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>  	if (!priv) {
>  		ret = -ENOMEM;
> -		dev_err(&pdev->dev, "unable to kmalloc\n");
> +		dev_err(dev, "unable to kmalloc\n");
>  		goto bad0;
>  	}
>  
> @@ -100,14 +84,14 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  
>  	uiomem = &uioinfo->mem[0];
>  
> -	for (i = 0; i < pdev->num_resources; ++i) {
> -		struct resource *r = &pdev->resource[i];
> +	for (i = 0; i < num_resources; ++i) {
> +		struct resource *r = resources + i;
>  
>  		if (r->flags != IORESOURCE_MEM)
>  			continue;
>  
>  		if (uiomem >= &uioinfo->mem[MAX_UIO_MAPS]) {
> -			dev_warn(&pdev->dev, "device has more than "
> +			dev_warn(dev, "device has more than "
>  					__stringify(MAX_UIO_MAPS)
>  					" I/O memory resources.\n");
>  			break;
> @@ -138,19 +122,39 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  	uioinfo->irqcontrol = uio_pdrv_genirq_irqcontrol;
>  	uioinfo->priv = priv;
>  
> -	ret = uio_register_device(&pdev->dev, priv->uioinfo);
> +	ret = uio_register_device(dev, priv->uioinfo);
>  	if (ret) {
> -		dev_err(&pdev->dev, "unable to register uio device\n");
> +		dev_err(dev, "unable to register uio device\n");
>  		goto bad1;
>  	}
>  
> -	platform_set_drvdata(pdev, priv);
> +	dev_set_drvdata(dev, priv);
>  	return 0;
>   bad1:
>  	kfree(priv);
>   bad0:
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(__uio_pdrv_genirq_probe);
> +
> +static int uio_pdrv_genirq_probe(struct platform_device *pdev)
> +{
> +	struct uio_info *uioinfo = pdev->dev.platform_data;
> +
> +	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
> +		dev_err(&pdev->dev, "missing platform_data\n");
> +		return -EINVAL;
> +	}
> +
> +	if (uioinfo->handler || uioinfo->irqcontrol ||
> +	    uioinfo->irq_flags & IRQF_SHARED) {
> +		dev_err(&pdev->dev, "interrupt configuration error\n");
> +		return -EINVAL;
> +	}
> +
> +	return __uio_pdrv_genirq_probe(&pdev->dev, uioinfo, pdev->resource,
> +			pdev->num_resources);
> +}
>  
>  static int uio_pdrv_genirq_remove(struct platform_device *pdev)
>  {
> diff --git a/include/linux/uio_pdrv_genirq.h b/include/linux/uio_pdrv_genirq.h
> new file mode 100644
> index 0000000..a410390
> --- /dev/null
> +++ b/include/linux/uio_pdrv_genirq.h
> @@ -0,0 +1,13 @@
> +#ifndef _LINUX_UIO_PDRV_GENIRQ_H
> +#define _LINUX_UIO_PDRV_GENIRQ_H
> +
> +struct uio_pdrv_genirq_platdata {
> +	struct uio_info *uioinfo;
> +	spinlock_t lock;
> +	unsigned long flags;
> +};
> +
> +extern int __uio_pdrv_genirq_probe(struct device *dev, struct uio_info *uioinfo,
> +	struct resource *resources, unsigned int num_resources);
> +
> +#endif
> -- 
> 1.6.3.1
