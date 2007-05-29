Return-Path: <linux-kernel-owner+w=401wt.eu-S1763281AbXE2TLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763281AbXE2TLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbXE2TLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:11:43 -0400
Received: from rtr.ca ([64.26.128.89]:3500 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbXE2TLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:11:42 -0400
Message-ID: <465C7AEB.7030304@rtr.ca>
Date: Tue, 29 May 2007 15:11:39 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel
 chipset
References: <Pine.LNX.4.44L0.0705291428230.3340-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0705291428230.3340-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Tue, 29 May 2007, Mark Lord wrote:
>> Mark Lord wrote:
>>> 7ed92f1a149dddc3cb537ccd7441e98adac12c3e USB: make the autosuspend 
>>> workqueue thread freezable
>>> ef7f6c7084b333c7524dcd297e0578d43733a2a2 USB: more autosuspend timer stuff
>>>
>>> I yanked them both, as they appeared to be releated based on the titles.
>>> Reverting this pair of commits fixes the USB suspend/resume regression.
>> Okay, just to make it trivial,
>> I've narrowed it down to only this commit from Alan Stern:
>>
>> 7ed92f1a149dddc3cb537ccd7441e98adac12c3e USB: make the autosuspend workqueue thread freezable
> 
> I'm a little surprised; I would have expected the other patch to be the 
> one responsible.  Are you sure you got the right one?

Absolutely, 100% sure.

> Your symptoms suggest that the ksuspend_usbd and khubd kernel threads
> are in deadlock.
..
> If this is indeed the case, the patch below ought to fix your problem.  
> Essentially it replaces calls to flush_workqueue() with
> cancel_sync_work().  I sent it to Andrew last week, but his problem
> occurs only sporadically so it's hard to test.

I didn't re-break the kernel to do the alt-sysrq thing,
but I did reapply the b0rken commit plus your new patch (below).

So far, so good with that combination, thanks.
..

> Index: 2.6.22-rc3/drivers/usb/core/hub.c
> ===================================================================
> --- 2.6.22-rc3.orig/drivers/usb/core/hub.c
> +++ 2.6.22-rc3/drivers/usb/core/hub.c
> @@ -1158,6 +1158,30 @@ static void release_address(struct usb_d
>  	}
>  }
>  
> +#ifdef	CONFIG_USB_SUSPEND
> +
> +static void usb_stop_pm(struct usb_device *udev)
> +{
> +	/* Synchronize with the ksuspend thread to prevent any more
> +	 * autosuspend requests from being submitted, and decrement
> +	 * the parent's count of unsuspended children.
> +	 */
> +	usb_pm_lock(udev);
> +	if (udev->parent && !udev->discon_suspended)
> +		usb_autosuspend_device(udev->parent);
> +	usb_pm_unlock(udev);
> +
> +	/* Stop any autosuspend requests already submitted */
> +	cancel_rearming_delayed_work(&udev->autosuspend);
> +}
> +
> +#else
> +
> +static inline void usb_stop_pm(struct usb_device *udev)
> +{ }
> +
> +#endif
> +
>  /**
>   * usb_disconnect - disconnect a device (usbcore-internal)
>   * @pdev: pointer to device being disconnected
> @@ -1224,13 +1248,7 @@ void usb_disconnect(struct usb_device **
>  	*pdev = NULL;
>  	spin_unlock_irq(&device_state_lock);
>  
> -	/* Decrement the parent's count of unsuspended children */
> -	if (udev->parent) {
> -		usb_pm_lock(udev);
> -		if (!udev->discon_suspended)
> -			usb_autosuspend_device(udev->parent);
> -		usb_pm_unlock(udev);
> -	}
> +	usb_stop_pm(udev);
>  
>  	put_device(&udev->dev);
>  }
> Index: 2.6.22-rc3/drivers/usb/core/usb.c
> ===================================================================
> --- 2.6.22-rc3.orig/drivers/usb/core/usb.c
> +++ 2.6.22-rc3/drivers/usb/core/usb.c
> @@ -184,10 +184,6 @@ static void usb_release_dev(struct devic
>  
>  	udev = to_usb_device(dev);
>  
> -#ifdef	CONFIG_USB_SUSPEND
> -	cancel_delayed_work(&udev->autosuspend);
> -	flush_workqueue(ksuspend_usb_wq);
> -#endif
>  	usb_destroy_configuration(udev);
>  	usb_put_hcd(bus_to_hcd(udev->bus));
>  	kfree(udev->product);
> Index: 2.6.22-rc3/drivers/usb/core/hcd.c
> ===================================================================
> --- 2.6.22-rc3.orig/drivers/usb/core/hcd.c
> +++ 2.6.22-rc3/drivers/usb/core/hcd.c
> @@ -1681,7 +1681,7 @@ void usb_remove_hcd(struct usb_hcd *hcd)
>  	spin_unlock_irq (&hcd_root_hub_lock);
>  
>  #ifdef CONFIG_PM
> -	flush_workqueue(ksuspend_usb_wq);
> +	cancel_work_sync(&hcd->wakeup_work);
>  #endif
>  
>  	mutex_lock(&usb_bus_list_lock);

