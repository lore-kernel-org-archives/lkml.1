Return-Path: <linux-kernel-owner+w=401wt.eu-S1757752AbZFSOPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752AbZFSOPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 10:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZFSOPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 10:15:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:47437 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZFSOPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 10:15:38 -0400
Date: Fri, 19 Jun 2009 07:11:28 -0700
From: Greg KH <gregkh@suse.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register:  warn if probe is in
	.init.text
Message-ID: <20090619141128.GA11506@suse.de>
References: <20090616182310.GC13048@pengutronix.de> <1245418939-20758-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1245418939-20758-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 03:42:19PM +0200, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/base/platform.c |   42 ++++++++++++++++++++++++++++++++++++------
>  include/linux/kernel.h  |    2 ++
>  include/linux/module.h  |   12 ++++++++++++
>  kernel/extable.c        |   12 ++++++++++++
>  kernel/module.c         |   36 ++++++++++++++++++++++++++++++++++++
>  5 files changed, 98 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 81cb01b..851ba84 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -470,11 +470,7 @@ static void platform_drv_shutdown(struct device *_dev)
>  	drv->shutdown(dev);
>  }
>  
> -/**
> - * platform_driver_register
> - * @drv: platform driver structure
> - */
> -int platform_driver_register(struct platform_driver *drv)
> +static int __platform_driver_register(struct platform_driver *drv)
>  {
>  	drv->driver.bus = &platform_bus_type;
>  	if (drv->probe)
> @@ -489,6 +485,40 @@ int platform_driver_register(struct platform_driver *drv)
>  
>  	return driver_register(&drv->driver);
>  }
> +
> +/**
> + * platform_driver_register
> + * @drv: platform driver structure
> + */
> +int platform_driver_register(struct platform_driver *drv)
> +{
> +	int ret = __platform_driver_register(drv);
> +
> +#if defined(CONFIG_HOTPLUG)
> +	/*
> +	 * drivers that are registered by platform_driver_register
> +	 * should not have their probe function in .init.text.  The
> +	 * reason is that a probe can happen after .init.text is
> +	 * discarded which then results in an oops.  The alternatives
> +	 * are using .devinit.text for the probe function or "register"
> +	 * with platform_driver_probe.
> +	 */

That's not true, remember, drivers built into the system, like platform
ones, can have their probe function in .init.text, as it will be called
before we discard .init.text, and will never be called again as the
device will never be "hot added" at any future time.

So this could trigger a lot of false positives :(

thanks,

greg k-h
