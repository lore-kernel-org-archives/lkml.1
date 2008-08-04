Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbYHDPBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbYHDPBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbYHDPAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:00:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45826 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbYHDPAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:00:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] [PM] Fixes missing PM entries in sysfs without CONFIG_PM_SLEEP
Date: Mon, 4 Aug 2008 17:03:27 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Dasgupta, Romit" <romit@ti.com>, David Engraf <david.engraf@netcom.eu>,
       Greg KH <greg@kroah.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0808041041070.2815-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808041041070.2815-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808041703.28229.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 4 of August 2008, Alan Stern wrote:
> On Sun, 3 Aug 2008, Dasgupta, Romit wrote:
> 
> > Alan,
> >          Here is a patch for you. Tested with
> > 
> > 1) CONFIG_SUSPEND, CONFIG_HIBERNATION i.e. with CONFIG_PM_SLEEP
> > 2) without CONFIG_PM_SLEEP but with CONFIG_PM
> > 3) without CONFIG_PM
> 
> I'd prefer to use the patch below.  Although it's a little longer, the 
> end result is slightly less complicated.  Also, it fixes two problems:
> 
> 	dpm_sysfs_add/remove should be called whenever CONFIG_PM
> 	is defined, regardless of CONFIG_PM_SLEEP.
> 
> 	dev->power.status should be initialized to DPM_ON even if
> 	CONFIG_PM isn't defined.
> 
> Can you make sure it compiles properly under all three configurations?
> 
> Rafael, any objections?

Hm, well, one thing below.

> Index: usb-2.6/drivers/base/power/power.h
> ===================================================================
> --- usb-2.6.orig/drivers/base/power/power.h
> +++ usb-2.6/drivers/base/power/power.h
> @@ -1,3 +1,8 @@
> +static inline void device_pm_init(struct device *dev)
> +{
> +	dev->power.status = DPM_ON;
> +}
> +
>  #ifdef CONFIG_PM_SLEEP
>  
>  /*
> Index: usb-2.6/drivers/base/core.c
> ===================================================================
> --- usb-2.6.orig/drivers/base/core.c
> +++ usb-2.6/drivers/base/core.c
> @@ -542,6 +542,7 @@ void device_initialize(struct device *de
>  	spin_lock_init(&dev->devres_lock);
>  	INIT_LIST_HEAD(&dev->devres_head);
>  	device_init_wakeup(dev, 0);
> +	device_pm_init(dev);
>  	set_dev_node(dev, -1);
>  }
>  
> @@ -898,6 +899,9 @@ int device_add(struct device *dev)
>  	error = bus_add_device(dev);
>  	if (error)
>  		goto BusError;
> +	error = dpm_sysfs_add(dev);
> +	if (error)
> +		goto DPMError;
>  	error = device_pm_add(dev);
>
>  	if (error)
>  		goto PMError;
> @@ -922,6 +926,8 @@ int device_add(struct device *dev)
>  	put_device(dev);
>  	return error;
>   PMError:
> +	dpm_sysfs_remove(dev);
> + DPMError:
>  	bus_remove_device(dev);
>   BusError:
>  	if (dev->bus)
> @@ -1008,6 +1014,7 @@ void device_del(struct device *dev)
>  	struct class_interface *class_intf;
>  
>  	device_pm_remove(dev);
> +	dpm_sysfs_remove(dev);
>  	if (parent)
>  		klist_del(&dev->knode_parent);
>  	if (MAJOR(dev->devt)) {
> Index: usb-2.6/drivers/base/power/main.c
> ===================================================================
> --- usb-2.6.orig/drivers/base/power/main.c
> +++ usb-2.6/drivers/base/power/main.c
> @@ -69,7 +69,7 @@ void device_pm_unlock(void)
>   */

device_pm_add() can now be void and the error variable in there is not
necessary any more.

>  int device_pm_add(struct device *dev)
>  {
> -	int error;
> +	int error = 0;
>  
>  	pr_debug("PM: Adding info for %s:%s\n",
>  		 dev->bus ? dev->bus->name : "No Bus",
> @@ -89,11 +89,8 @@ int device_pm_add(struct device *dev)
>  		 */
>  		WARN_ON(true);
>  	}
> -	error = dpm_sysfs_add(dev);
> -	if (!error) {
> -		dev->power.status = DPM_ON;
> -		list_add_tail(&dev->power.entry, &dpm_list);
> -	}
> +
> +	list_add_tail(&dev->power.entry, &dpm_list);
>  	mutex_unlock(&dpm_list_mtx);
>  	return error;
>  }
> @@ -110,7 +107,6 @@ void device_pm_remove(struct device *dev
>  		 dev->bus ? dev->bus->name : "No Bus",
>  		 kobject_name(&dev->kobj));
>  	mutex_lock(&dpm_list_mtx);
> -	dpm_sysfs_remove(dev);
>  	list_del_init(&dev->power.entry);
>  	mutex_unlock(&dpm_list_mtx);
>  }

Thanks,
Rafael
