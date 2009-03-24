Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbZCXXqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbZCXXqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZCXXqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:46:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:49248 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751729AbZCXXqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:46:46 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18zE/ci9DIzX91cjX9lHDZnMGOwWKsTP2txrThCMq
	P4vFlbSZnjQQUE
Date: Wed, 25 Mar 2009 00:46:42 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ming Lei <tom.leiming@gmail.com>
cc: kay.sievers@vrfy.org, greg@kroah.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com
Subject: Re: [PATCH] driver core: check bus->match without holding device
 lock
In-Reply-To: <1232458448-4412-1-git-send-email-tom.leiming@gmail.com>
Message-ID: <Pine.LNX.4.64.0903250039160.4451@axis700.grange>
References: <1232458448-4412-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch breaks soc-camera because of this change in behaviour:

On Tue, 20 Jan 2009, tom.leiming@gmail.com wrote:

> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch moves bus->match out from driver_probe_device and
> does not hold device lock to check the match between a device
> and a driver.
> 
> The idea has been verified by the commit 6cd495860901,
> which leads to a faster boot. But the commit 6cd495860901 has
> the following drawbacks: 1),only does the quick check in
> the path of __driver_attach->driver_probe_device, not in other
> paths; 2),for a matched device and driver, check the same match
> twice. It is a waste of cpu ,especially for some drivers with long
> device id table (eg. usb-storage driver).
> 
> This patch adds a helper of driver_match_device to check the match
> in all paths, and testes the match only once.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/base/bus.c     |    8 +++++++-
>  drivers/base/dd.c      |   19 +++++++------------
>  include/linux/device.h |    6 ++++++
>  3 files changed, 20 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 83f32b8..c570d16 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -199,6 +199,12 @@ static ssize_t driver_bind(struct device_driver *drv,
>  
>  	dev = bus_find_device_by_name(bus, NULL, buf);
>  	if (dev && dev->driver == NULL) {
> +
> +		if (!driver_match_device(drv, dev)) {
> +			err = 0;
> +			goto not_match;
> +		}
> +
>  		if (dev->parent)	/* Needed for USB */
>  			down(&dev->parent->sem);
>  		down(&dev->sem);
> @@ -206,7 +212,7 @@ static ssize_t driver_bind(struct device_driver *drv,
>  		up(&dev->sem);
>  		if (dev->parent)
>  			up(&dev->parent->sem);
> -
> +not_match:
>  		if (err > 0) {
>  			/* success */
>  			err = count;
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 315bed8..61f32db 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -172,14 +172,8 @@ int driver_probe_done(void)
>   * @drv: driver to bind a device to
>   * @dev: device to try to bind to the driver
>   *
> - * First, we call the bus's match function, if one present, which should
> - * compare the device IDs the driver supports with the device IDs of the
> - * device. Note we don't do this ourselves because we don't know the
> - * format of the ID structures, nor what is to be considered a match and
> - * what is not.
> - *
> - * This function returns 1 if a match is found, -ENODEV if the device is
> - * not registered, and 0 otherwise.
> + * This function returns -ENODEV if the device is not registered,
> + * and 0 otherwise.
>   *
>   * This function must be called with @dev->sem held.  When called for a
>   * USB interface, @dev->parent->sem must be held as well.
> @@ -190,21 +184,22 @@ int driver_probe_device(struct device_driver *drv, struct device *dev)
>  
>  	if (!device_is_registered(dev))
>  		return -ENODEV;
> -	if (drv->bus->match && !drv->bus->match(dev, drv))
> -		goto done;

Previously, if no .match() was specified, the normal probing has been 
called.

>  
>  	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
>  		 drv->bus->name, __func__, dev_name(dev), drv->name);
>  
>  	ret = really_probe(dev, drv);
>  
> -done:
>  	return ret;
>  }
>  
>  static int __device_attach(struct device_driver *drv, void *data)
>  {
>  	struct device *dev = data;
> +
> +	if (!driver_match_device(drv, dev))
> +		return 0;
> +

Now, without .match() no probing is done. Is this an intended change and 
soc-camera has to be fixed or is this a bug?

>  	return driver_probe_device(drv, dev);
>  }
>  
> @@ -257,7 +252,7 @@ static int __driver_attach(struct device *dev, void *data)
>  	 * is an error.
>  	 */
>  
> -	if (drv->bus->match && !drv->bus->match(dev, drv))
> +	if (!driver_match_device(drv, dev))
>  		return 0;
>  
>  	if (dev->parent)	/* Needed for USB */
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 45e5b19..3c61315 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -466,6 +466,12 @@ static inline int device_is_registered(struct device *dev)
>  	return dev->kobj.state_in_sysfs;
>  }
>  
> +static inline int driver_match_device(struct device_driver *drv,
> +				      struct device *dev)
> +{
> +	return drv->bus->match && drv->bus->match(dev, drv);
> +}
> +
>  void driver_init(void);
>  
>  /*
> -- 
> 1.6.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
