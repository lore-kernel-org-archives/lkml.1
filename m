Return-Path: <linux-kernel-owner+w=401wt.eu-S1759887AbXKGWHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbXKGWHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758984AbXKGWHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:07:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47659 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758928AbXKGWHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:07:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Drake <dsd@gentoo.org>, greg@kroah.com
Subject: Re: [PATCH] create /sys/.../power when CONFIG_PM is set
Date: Wed, 7 Nov 2007 23:24:55 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-hotplug-devel@lists.sourceforge.net, oneukum@suse.de,
       Pavel Machek <pavel@ucw.cz>
References: <20071107101043.2E64C9D4ECC@zog.reactivated.net>
In-Reply-To: <20071107101043.2E64C9D4ECC@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711072324.56125.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 7 of November 2007, Daniel Drake wrote:
> The CONFIG_SUSPEND changes in 2.6.23 caused a regression under certain
> configuration conditions (SUSPEND=n, USB_AUTOSUSPEND=y) where all USB device
> attributes in sysfs (idVendor, idProduct, ...) silently disappeared, causing
> udev breakage and more.
> 
> The cause of this is that the /sys/.../power subdirectory is now only created
> when CONFIG_PM_SLEEP is set, however, it should be created whenever CONFIG_PM
> is set to handle the above situation. The following patch fixes the
> regression.
> 
> Signed-off-by: Daniel Drake <dsd@gentoo.org>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

Greg, I think this patch should go through your tree?

> Index: linux-2.6.24-rc1-git14/drivers/base/core.c
> ===================================================================
> --- linux-2.6.24-rc1-git14.orig/drivers/base/core.c
> +++ linux-2.6.24-rc1-git14/drivers/base/core.c
> @@ -770,9 +770,10 @@ int device_add(struct device *dev)
>  	error = device_add_attrs(dev);
>  	if (error)
>  		goto AttrsError;
> -	error = device_pm_add(dev);
> +	error = dpm_sysfs_add(dev);
>  	if (error)
>  		goto PMError;
> +	device_pm_add(dev);
>  	error = bus_add_device(dev);
>  	if (error)
>  		goto BusError;
> @@ -797,6 +798,7 @@ int device_add(struct device *dev)
>  	return error;
>   BusError:
>  	device_pm_remove(dev);
> +	dpm_sysfs_remove(dev);
>   PMError:
>  	if (dev->bus)
>  		blocking_notifier_call_chain(&dev->bus->bus_notifier,
> Index: linux-2.6.24-rc1-git14/drivers/base/power/Makefile
> ===================================================================
> --- linux-2.6.24-rc1-git14.orig/drivers/base/power/Makefile
> +++ linux-2.6.24-rc1-git14/drivers/base/power/Makefile
> @@ -1,5 +1,6 @@
>  obj-y			:= shutdown.o
> -obj-$(CONFIG_PM_SLEEP)	+= main.o sysfs.o
> +obj-$(CONFIG_PM)	+= sysfs.o
> +obj-$(CONFIG_PM_SLEEP)	+= main.o
>  obj-$(CONFIG_PM_TRACE)	+= trace.o
>  
>  ifeq ($(CONFIG_DEBUG_DRIVER),y)
> Index: linux-2.6.24-rc1-git14/drivers/base/power/power.h
> ===================================================================
> --- linux-2.6.24-rc1-git14.orig/drivers/base/power/power.h
> +++ linux-2.6.24-rc1-git14/drivers/base/power/power.h
> @@ -18,9 +18,24 @@ static inline struct device * to_device(
>  	return container_of(entry, struct device, power.entry);
>  }
>  
> -extern int device_pm_add(struct device *);
> +extern void device_pm_add(struct device *);
>  extern void device_pm_remove(struct device *);
>  
> +#else /* CONFIG_PM_SLEEP */
> +
> +
> +static inline void device_pm_add(struct device * dev)
> +{
> +}
> +static inline void device_pm_remove(struct device * dev)
> +{
> +
> +}
> +
> +#endif
> +
> +#ifdef CONFIG_PM
> +
>  /*
>   * sysfs.c
>   */
> @@ -28,16 +43,16 @@ extern void device_pm_remove(struct devi
>  extern int dpm_sysfs_add(struct device *);
>  extern void dpm_sysfs_remove(struct device *);
>  
> -#else /* CONFIG_PM_SLEEP */
> +#else /* CONFIG_PM */
>  
> -
> -static inline int device_pm_add(struct device * dev)
> +static inline int dpm_sysfs_add(struct device * dev)
>  {
>  	return 0;
>  }
> -static inline void device_pm_remove(struct device * dev)
> +static inline void dpm_sysfs_remove(struct device * dev)
>  {
>  
>  }
>  
> -#endif
> +#endif /* CONFIG_PM */
> +
> Index: linux-2.6.24-rc1-git14/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.24-rc1-git14.orig/drivers/base/power/main.c
> +++ linux-2.6.24-rc1-git14/drivers/base/power/main.c
> @@ -38,20 +38,14 @@ static DEFINE_MUTEX(dpm_list_mtx);
>  int (*platform_enable_wakeup)(struct device *dev, int is_on);
>  
>  
> -int device_pm_add(struct device *dev)
> +void device_pm_add(struct device *dev)
>  {
> -	int error;
> -
>  	pr_debug("PM: Adding info for %s:%s\n",
>  		 dev->bus ? dev->bus->name : "No Bus",
>  		 kobject_name(&dev->kobj));
>  	mutex_lock(&dpm_list_mtx);
>  	list_add_tail(&dev->power.entry, &dpm_active);
> -	error = dpm_sysfs_add(dev);
> -	if (error)
> -		list_del(&dev->power.entry);
>  	mutex_unlock(&dpm_list_mtx);
> -	return error;
>  }
>  
>  void device_pm_remove(struct device *dev)
> 
> 
