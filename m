Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbZATOVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbZATOVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZATOVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:21:37 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:40867 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbZATOVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:21:36 -0500
Date: Tue, 20 Jan 2009 15:21:08 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: tom.leiming@gmail.com
Cc: kay.sievers@vrfy.org, greg@kroah.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] driver core: check bus->match without holding device
 lock
Message-ID: <20090120152108.032405b2@gondolin>
In-Reply-To: <1232458448-4412-1-git-send-email-tom.leiming@gmail.com>
References: <1232458448-4412-1-git-send-email-tom.leiming@gmail.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2009 21:34:08 +0800,
tom.leiming@gmail.com wrote:

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

I agree with the goal of that patch, as it essentially cleanly
seperates the quick check (->match) from the deeper probing (->probe).

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

This looks too complicated, I'd just change the if to
	if (dev && dev->driver == NULL && driver_match_device(drv,dev))

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

This is incorrect, really_probe() still returns 1 if the device could
be bound.

>   *
>   * This function must be called with @dev->sem held.  When called for a
>   * USB interface, @dev->parent->sem must be held as well.
> @@ -190,21 +184,22 @@ int driver_probe_device(struct device_driver *drv, struct device *dev)
> 
>  	if (!device_is_registered(dev))
>  		return -ENODEV;
> -	if (drv->bus->match && !drv->bus->match(dev, drv))
> -		goto done;
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

This should go into drivers/base/base.h instead, as no code outside the
driver core should use it.

>  void driver_init(void);
> 
>  /*
