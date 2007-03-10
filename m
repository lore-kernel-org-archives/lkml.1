Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbXCJNMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbXCJNMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 08:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbXCJNMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 08:12:22 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:11033 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbXCJNMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 08:12:21 -0500
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, James Simmons <jsimmons@infradead.org>
Subject: Re: [PATCH 8/9] Driver core: fix error by cleanup up symlinks properly
References: <20070223231426.GA20498@kroah.com>
	<11722725561867-git-send-email-gregkh@suse.de>
	<11722725592291-git-send-email-gregkh@suse.de>
	<11722725623183-git-send-email-gregkh@suse.de>
	<1172272565581-git-send-email-gregkh@suse.de>
	<1172272569255-git-send-email-gregkh@suse.de>
	<11722725722238-git-send-email-gregkh@suse.de>
	<11722725761560-git-send-email-gregkh@suse.de>
	<1172272579116-git-send-email-gregkh@suse.de>
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Sat, 10 Mar 2007 16:11:40 +0300
In-Reply-To: <1172272579116-git-send-email-gregkh@suse.de> (Greg Kroah-Hartman's message of "Fri, 23 Feb 2007 15:15:55 -0800")
Message-ID: <87abyl8cqb.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@suse.de> writes:

> From: James Simmons <jsimmons@infradead.org>
>
> When a device fails to register the class symlinks where not cleaned up.
> This left a symlink in the /sys/class/"device"/ directory that pointed
> to no where. This caused the sysfs_follow_link Oops I reported earlier.
> This patch cleanups up the symlink. Please apply. Thank you.
>
> Signed-Off: James Simmons <jsimmons@infradead.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/base/core.c |   31 ++++++++++++++++++++++++++++++-
>  1 files changed, 30 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index d04fd33..cf2a398 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -637,12 +637,41 @@ int device_add(struct device *dev)
>  					     BUS_NOTIFY_DEL_DEVICE, dev);
>  	device_remove_groups(dev);
>   GroupError:
> - 	device_remove_attrs(dev);
> +	device_remove_attrs(dev);
>   AttrsError:
>  	if (dev->devt_attr) {
>  		device_remove_file(dev, dev->devt_attr);
>  		kfree(dev->devt_attr);
>  	}
> +
> +	if (dev->class) {
> +		sysfs_remove_link(&dev->kobj, "subsystem");
> +		/* If this is not a "fake" compatible device, remove the
> +		 * symlink from the class to the device. */
> +		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
> +			sysfs_remove_link(&dev->class->subsys.kset.kobj,
> +					  dev->bus_id);
> +#ifdef CONFIG_SYSFS_DEPRECATED
> +		if (parent) {
> +			char *class_name = make_class_name(dev->class->name,
> +							   &dev->kobj);
> +			if (class_name)
> +				sysfs_remove_link(&dev->parent->kobj,
> +						  class_name);
> +			kfree(class_name);
> +			sysfs_remove_link(&dev->kobj, "device");
> +		}
> +#endif
> +
<<<<< block begin
> +		down(&dev->class->sem);
> +		/* notify any interfaces that the device is now gone */
> +		list_for_each_entry(class_intf, &dev->class->interfaces, node)
> +			if (class_intf->remove_dev)
> +				class_intf->remove_dev(dev, class_intf);
> +		/* remove the device from the class list */
> +		list_del_init(&dev->node);
> +		up(&dev->class->sem);
<<<<<< block end 
May be i've missed something, but i'm confuesd a litle bit.
For example if error happens while device_pm_add() we jump to label "PMError"
and code from block above will be executed (device will be remove from list),
but this device wasn't added to this list yet!
> +	}
>   ueventattrError:
>  	device_remove_file(dev, &dev->uevent_attr);
>   attrError:
> -- 
> 1.5.0.1
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

