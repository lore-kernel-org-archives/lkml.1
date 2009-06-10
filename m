Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbZFJVOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbZFJVOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbZFJVOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:14:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34086 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754620AbZFJVOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:14:05 -0400
Date: Wed, 10 Jun 2009 17:14:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re:
 [RFC][PATCH 0/2] PM: Rearrange core suspend code)
In-Reply-To: <200906101029.27529.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906101656100.2589-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009, Rafael J. Wysocki wrote:

> > The idea is that if ->autosuspend() or ->autoresume() returns an error code,
> > this is a situation the PM core cannot recover from by itself, so it shouldn't
> > pretend it knows what's happened.  Instead, it marks the device as "I don't
> > know if it is safe to touch this" and won't handle it until the device driver
> > or bus type clears the status.

I'm still not sure this is a good idea.  When would the device driver 
clear the status?  The autosuspend and autoresume methods run 
asynchronously, so after they're done the driver doesn't get a chance 
to do anything.

It might be best just to set the status to RPM_ACTIVE if a runtime 
suspend fails and RPM_SUSPENDED if a runtime resume fails.

> Finally, I decided to follow the Oliver's suggestion that some error codes returned
> by ->autosuspend() and ->autoresume() may be regarded as "go back to the
> previous state" information.  I chose to use -EAGAIN and -EBUSY for this
> purpose.

Maybe...


>  struct dev_pm_info {
>  	pm_message_t		power_state;
> -	unsigned		can_wakeup:1;
> -	unsigned		should_wakeup:1;
> +	unsigned int		can_wakeup:1;
> +	unsigned int		should_wakeup:1;
>  	enum dpm_state		status;		/* Owned by the PM core */
>  #ifdef	CONFIG_PM_SLEEP
>  	struct list_head	entry;
>  #endif
> +#ifdef	CONFIG_PM_RUNTIME
> +	struct delayed_work	suspend_work;
> +	unsigned int		suspend_aborted:1;
> +	struct work_struct	resume_work;
> +	struct completion	work_done;
> +	enum rpm_state		runtime_status;
> +	spinlock_t		lock;
> +#endif
>  };

You know, it doesn't make any sense to have a suspend and a resume 
both pending at the same time.  So you could add only a delayed_work 
structure and use its embedded work_struct for resume requests.

Also, you might borrow a trick from Dave Brownell.  Define the RPM_*
values so that the individual bits have meanings.  Then instead of
testing for multiple possible values of runtime_status, you could do a
simple bit test.

> +/**
> + * pm_device_suspended - Check if given device has been suspended at run time.
> + * @dev: Device to check.
> + * @data: Ignored.
> + *
> + * Returns 0 if the device has been suspended or -EBUSY otherwise.
> + */
> +static int pm_device_suspended(struct device *dev, void *data)
> +{
> +	int ret;
> +
> +	spin_lock(&dev->power.lock);
> +
> +	ret = dev->power.runtime_status == RPM_SUSPENDED ? 0 : -EBUSY;
> +
> +	spin_unlock(&dev->power.lock);

How does acquiring the lock help here?

> +/**
> + * pm_check_children - Check if all children of a device have been suspended.
> + * @dev: Device to check.
> + *
> + * Returns 0 if all children of the device have been suspended or -EBUSY
> + * otherwise.
> + */

We might want to do a runtime suspend even if the device's children
aren't already suspended.  For example, you could suspend a link while
leaving the device on the other end of the link at full power --
especially if powering down the device is slow but changing the link's
power level is fast.

> +/**
> + * pm_autosuspend - Run autosuspend callback of given device object's bus type.
> + * @work: Work structure used for scheduling the execution of this function.
> + *
> + * Use @work to get the device object the suspend has been scheduled for,
> + * check if the suspend request hasn't been cancelled and run the
> + * ->autosuspend() callback from the device's bus type driver.  Update the
> + * run-time PM flags in the device object to reflect the current status of the
> + * device.
> + */
> +static void pm_autosuspend(struct work_struct *work)

Can we call this something else?  "Autosuspend" implies that the 
suspend originated from within the kernel.  How about "pm_suspend_work" 
or "pm_runtime_suspend"?  Likewise for the resume routines.

I haven't checked the details of the code yet.  More later...

Alan Stern

