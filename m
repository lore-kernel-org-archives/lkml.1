Return-Path: <linux-kernel-owner+w=401wt.eu-S932673AbYB2PyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbYB2PyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 10:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758298AbYB2Px7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 10:53:59 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40835 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756370AbYB2Px5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 10:53:57 -0500
Date: Fri, 29 Feb 2008 10:53:57 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer
 removal
In-Reply-To: <200802291526.08522.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802291025450.2140-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008, Rafael J. Wysocki wrote:

> > +There is an unavoidable race between the PM core suspending all the
> > +children of a device and the device's driver registering new children.
> > +As a result, it is possible that the core may try to suspend a device
> > +without first having suspended all of the device's children.  Drivers
> > +must check for this; a suspend method should return -EBUSY if there are
> > +unsuspended children.  (The child->power.sleeping field can be used
> > +for this check.)  In addition, it is illegal to register a child device
> 
> s/illegal/invalid/

How about instead: "attempts to register a child device below a 
suspended parent will fail.  Hence..."?

> > +below a suspended parent; hence suspend methods must synchronize with
> > +other kernel threads that may attempt to add new children.  The suspend
> > +method must prevent new registrations and wait for concurrent registrations
> > +to complete before it returns.  New children may be added once more when
> > +the resume method runs.

...

> > --- usb-2.6.orig/include/linux/pm.h
> > +++ usb-2.6/include/linux/pm.h
> > @@ -180,8 +180,20 @@ typedef struct pm_message {
> >  #define PMSG_HIBERNATE	((struct pm_message){ .event = PM_EVENT_HIBERNATE, })
> >  #define PMSG_ON		((struct pm_message){ .event = PM_EVENT_ON, })
> >  
> > +/* This records which method calls have been made, not the device's
> > + * actual power state.  It is read-only to drivers.
> > + */
> > +enum pm_sleep_state {
> 
> I'd call it dev_pm_state, in analogy with dev_pm_info etc.

Okay.

> > +	PM_AWAKE,		/* = 0, normal situation */
> > +	PM_SLEEPING,		/* suspend method is running */
> > +	PM_ASLEEP,		/* suspend method has returned */
> > +	PM_WAKING,		/* resume method is running */
> > +	PM_GONE,		/* device has been unregistered */
> > +};
> > +
> >  struct dev_pm_info {
> >  	pm_message_t		power_state;
> > +	enum pm_sleep_state	sleeping;
> 
> In fact 'sleeping' doesn't look good in this context.  'pm_state' seems
> better to me (although it is confusingly similar to 'power_state', we're going
> to get rid of the latter anyway).

Okay.

> > Index: usb-2.6/drivers/base/power/main.c
> > ===================================================================
> > --- usb-2.6.orig/drivers/base/power/main.c
> > +++ usb-2.6/drivers/base/power/main.c
> > @@ -54,7 +54,9 @@ static LIST_HEAD(dpm_destroy);
> >  
> >  static DEFINE_MUTEX(dpm_list_mtx);
> >  
> > -static DECLARE_RWSEM(pm_sleep_rwsem);
> > +/* Protected by dpm_list_mtx */
> > +static bool child_added_while_parent_suspends; 
> 
> I don't like this name, but I have no better idea at the moment.

It gets used in only a couple of places, so nobody should object too 
violently.  :-)

> > -void device_pm_add(struct device *dev)
> > +int device_pm_add(struct device *dev)
> >  {
> > +	int rc = 0;
> > +
> >  	pr_debug("PM: Adding info for %s:%s\n",
> >  		 dev->bus ? dev->bus->name : "No Bus",
> >  		 kobject_name(&dev->kobj));
> >  	mutex_lock(&dpm_list_mtx);
> > -	list_add_tail(&dev->power.entry, &dpm_active);
> > +	if (dev->parent) {
> 
> Hmm.
> 
> Suppose we add a mutex to dev_pm_info, say pm_mtx, and require it to be:
> (1) taken by suspend_device(dev) (at the beginning)
> (2) released by resume_device(dev) (at the end)
> (3) taken (and released) by device_pm_add() if dev is the parent of the device
>     being added.
> 
> In that case, device_pm_add() will block on attepmpts to register devices whose
> parents are suspended (or suspending) and we're done.  At least so it would
> seem.

No; this would repeat the same mistake we were struggling with last
week.  Blocking registration attempts (especially if we start _before_
calling the device's suspend method or end _after_ calling the resume
method) will lead to deadlocks while suspending or resuming.

If the blocking starts after the suspend method returns then it will be 
safer.  But what's the point?  If a registration attempt is made at 
that stage, it means there's a bug in the driver.  So failing the 
registration seems like a reasonable thing to do.

One issue: This rule doesn't allow suspend_late or resume_early methods
to register any new devices.  Will that cause problems with the CPU
hotplug or ACPI subsystems?  ACPI in particular may need to freeze the
kacpi_notify workqueue -- in fact, that might solve the problem in
Bugzilla #9874.

> > +		switch (dev->parent->power.sleeping) {
> > +		case PM_SLEEPING:
> > +			child_added_while_parent_suspends = true;
> > +			break;
> > +		case PM_ASLEEP:
> > +			dev_err(dev, "added while parent '%s' is asleep\n",
> > +					dev->parent->bus_id);
> > +			rc = -EHOSTDOWN;
> > +			break;
> > +		default:
> > +			break;
> > +		}
> > +	} else if (all_devices_asleep) {
> > +		dev_err(dev, "added while all devices are asleep\n");
> > +		rc = -ENETDOWN;
> > +	}
> 
> The error codes are a bit unusual, but whatever.

I agree.  But there aren't any -EPOWER* or -EPM* error codes defined!  
Some should be added, but this patch isn't the place to do it.

> > @@ -433,10 +446,24 @@ static int dpm_suspend(pm_message_t stat
> >  					""));
> >  			break;
> >  		}
> > -		mutex_lock(&dpm_list_mtx);
> > -		if (!list_empty(&dev->power.entry))
> > -			list_move(&dev->power.entry, &dpm_off);
> > +		if (dev->power.sleeping != PM_GONE) {
> > +			if (child_added_while_parent_suspends) {
> > +				dev_err(dev, "suspended while a child "
> > +						"was added\n");
> > +				dev->power.sleeping = PM_WAKING;
> > +				mutex_unlock(&dpm_list_mtx);
> 
> This seems to be a weak spot.  The resuming of the device at this point need
> not work correctly, given that the system's target state is still a sleep
> state.

That may be true.  But this is an error-recovery path intended to work
around a driver bug.  It doesn't have to guarantee perfect operation, 
just do its best.

Remember too that the target state is set before any devices are
suspended.  Hence, after the state is set there may still be runtime
resumes taking place.  Those _must_ not fail, which means that this
resume ought to work also.

> > +				resume_device(dev);
> > +				mutex_lock(&dpm_list_mtx);
> > +				if (dev->power.sleeping != PM_GONE)
> > +					dev->power.sleeping = PM_AWAKE;
> > +			} else {

> Well, I wish it could be simpler ...

Me too.  But until the API is changed, this seems to be the best we can 
do.  It's not quite as bad as it looks, since a fair amount of the new 
code is just for reporting on and recovering from bugs in drivers.

Alan Stern

