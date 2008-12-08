Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbYLHVw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbYLHVw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 16:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYLHVwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 16:52:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:44369 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbYLHVwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 16:52:44 -0500
Subject: Re: [PATCH 1/2] Driver core: move the bus notifier call points
 (fwd)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0812081012030.2476-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0812081012030.2476-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 08:52:22 +1100
Message-Id: <1228773142.7101.38.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-08 at 10:14 -0500, Alan Stern wrote:
> Ben:
> 
> After posting the patch below, I noticed that you were the person who 
> originally added the bus notifier code.  You don't see any problems 
> with this code motion, do you?

I think it should be fine. I need to make sure the driver isn't bound
yet, that's my main requirement, since I use those callbacks to setup
the DMA operations & iommu for the device on Cell.

Cheers,
Ben.

> Alan Stern
> 
> 
> 
> This patch (as1184) changes the location of the notifications in
> device_add() and device_del().  Now the BUS_NOTIFY_ADD_DEVICE message
> is sent after dpm_sysfs_add(), which is necessary for clients that
> want to add attributes to the power/ subdirectory.  The
> BUS_NOTIFY_DEL_DEVICE message is correspondingly moved before
> dpm_sysfs_remove().
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> Index: usb-2.6/drivers/base/core.c
> ===================================================================
> --- usb-2.6.orig/drivers/base/core.c
> +++ usb-2.6/drivers/base/core.c
> @@ -884,11 +884,6 @@ int device_add(struct device *dev)
>  	if (platform_notify)
>  		platform_notify(dev);
>  
> -	/* notify clients of device entry (new way) */
> -	if (dev->bus)
> -		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
> -					     BUS_NOTIFY_ADD_DEVICE, dev);
> -
>  	error = device_create_file(dev, &uevent_attr);
>  	if (error)
>  		goto attrError;
> @@ -916,6 +911,14 @@ int device_add(struct device *dev)
>  	if (error)
>  		goto DPMError;
>  	device_pm_add(dev);
> +
> +	/* Notify clients of device addition.  This call must come
> +	 * after dpm_sysf_add() and before kobject_uevent().
> +	 */
> +	if (dev->bus)
> +		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
> +					     BUS_NOTIFY_ADD_DEVICE, dev);
> +
>  	kobject_uevent(&dev->kobj, KOBJ_ADD);
>  	bus_attach_device(dev);
>  	if (parent)
> @@ -940,9 +943,6 @@ done:
>   DPMError:
>  	bus_remove_device(dev);
>   BusError:
> -	if (dev->bus)
> -		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
> -					     BUS_NOTIFY_DEL_DEVICE, dev);
>  	device_remove_attrs(dev);
>   AttrsError:
>  	device_remove_class_symlinks(dev);
> @@ -1027,6 +1027,12 @@ void device_del(struct device *dev)
>  	struct device *parent = dev->parent;
>  	struct class_interface *class_intf;
>  
> +	/* Notify clients of device removal.  This call must come
> +	 * before dpm_sysfs_remove().
> +	 */
> +	if (dev->bus)
> +		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
> +					     BUS_NOTIFY_DEL_DEVICE, dev);
>  	device_pm_remove(dev);
>  	dpm_sysfs_remove(dev);
>  	if (parent)
> @@ -1064,9 +1070,6 @@ void device_del(struct device *dev)
>  	 */
>  	if (platform_notify_remove)
>  		platform_notify_remove(dev);
> -	if (dev->bus)
> -		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
> -					     BUS_NOTIFY_DEL_DEVICE, dev);
>  	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
>  	cleanup_device_parent(dev);
>  	if (!list_empty(&dev->klist_children.k_list))
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

