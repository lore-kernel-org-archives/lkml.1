Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbYBXT2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbYBXT2M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 14:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbYBXT1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 14:27:53 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2626 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755320AbYBXT1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 14:27:52 -0500
Date: Sun, 24 Feb 2008 14:27:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <200802241451.17334.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802241409320.11316-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008, Rafael J. Wysocki wrote:

> > You know, with this new patch we probably don't need 
> > device_pm_schedule_removal() any more.
> 
> No, we don't.  However, because of that dpm_suspend() and device_power_down()
> need to be changed not to assume that the removed devices will end up on
> dpm_destroy.

Yes.  The safest approach will be to check whether the device is still 
at the end of the dpm_locked or dpm_off list; if it hasn't then we can 
assume that it has been removed (or scheduled for removal).

> IMO you also should add this change in device_power_down():
> 
> @@ -388,18 +343,15 @@ int device_power_down(pm_message_t state
>  		struct list_head *entry = dpm_off.prev;
>  		struct device *dev = to_device(entry);
>  
> -		list_del_init(&dev->power.entry);
>  		error = suspend_device_late(dev, state);
>  		if (error) {
>  			printk(KERN_ERR "Could not power down device %s: "
>  					"error %d\n",
>  					kobject_name(&dev->kobj), error);
> -			if (list_empty(&dev->power.entry))
> -				list_add(&dev->power.entry, &dpm_off);
>  			break;
>  		}
> -		if (list_empty(&dev->power.entry))
> -			list_add(&dev->power.entry, &dpm_off_irq);
> +		if (!list_empty(&dev->power.entry))
> +			list_move(&dev->power.entry, &dpm_off_irq);
>  	}

Actually I changed the last two lines to:

+
+		/* Don't move the entry if the device has been unregistered */
+		if (entry == dpm_off.prev)
+			list_move(entry, &dpm_off_irq);

with analogous changes to dpm_suspend().

Any more suggestions for updates?

Alan Stern

