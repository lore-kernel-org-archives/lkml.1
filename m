Return-Path: <linux-kernel-owner+w=401wt.eu-S933190AbYB2Sm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190AbYB2Sm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757706AbYB2SmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:42:19 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38696 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756809AbYB2SmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:42:18 -0500
Date: Fri, 29 Feb 2008 13:42:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer
 removal
In-Reply-To: <200802291802.41590.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802291227430.6695-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008, Rafael J. Wysocki wrote:

> > > Suppose we add a mutex to dev_pm_info, say pm_mtx, and require it to be:
> > > (1) taken by suspend_device(dev) (at the beginning)
> > > (2) released by resume_device(dev) (at the end)
> > > (3) taken (and released) by device_pm_add() if dev is the parent of the device
> > >     being added.
> > > 
> > > In that case, device_pm_add() will block on attepmpts to register devices whose
> > > parents are suspended (or suspending) and we're done.  At least so it would
> > > seem.
> > 
> > No; this would repeat the same mistake we were struggling with last
> > week.
> 
> Not exactly, because in that case we blocked all attempts to register devices,
> while I think we can only block those regarding the children of a suspending
> (or suspended) device.

It's the "suspending" case that causes trouble.  Go back and look at 
the race I diagrammed in

https://lists.linux-foundation.org/pipermail/linux-pm/2008-February/016763.html

> > Blocking registration attempts (especially if we start _before_ 
> > calling the device's suspend method or end _after_ calling the resume
> > method) will lead to deadlocks while suspending or resuming.
> 
> I'm not really convinced that it'll happen.

It _did_ happen.  Precisely this race occurred in Bug #10030 (the SD
card insertion/removal), although there the window was bigger because
we blocked registrations starting from the start of the system sleep
instead of from when the parent's suspend method was called.

>  If we make the rule that
> registering children from the device's own ->suspend() method is forbidden
> (I don't really see why it should be allowed), something like this might work
> (it seems to me):

It's not that the suspend method itself will want to register children.  
The problem is that the method has to wait for other threads that may 
already have started to register a child.  If those other threads are 
blocked then suspend will deadlock.

> @@ -427,6 +433,13 @@ static int dpm_suspend(pm_message_t stat
>  		struct device *dev = to_device(entry);
>  
>  		mutex_unlock(&dpm_list_mtx);
> +		mutex_lock(&dev->power.lock);
> +		mutex_lock(&dpm_list_mtx);
> +		if (dev != to_device(dpm_active.prev)) {
> +			mutex_unlock(&dev->power.lock);
> +			continue;
> +		}
> +		mutex_unlock(&dpm_list_mtx);
>  		error = suspend_device(dev, state);
>  		mutex_lock(&dpm_list_mtx);
>  		if (error) {

This looks pretty awkward.  Won't it cause lockdep to complain about
recursive locking of dev->power.lock?

> > If the blocking starts after the suspend method returns then it will be 
> > safer.  But what's the point?  If a registration attempt is made at 
> > that stage, it means there's a bug in the driver.  So failing the 
> > registration seems like a reasonable thing to do.
> 
> That doesn't buy us anything if drivers don't check whether the registration
> succeeded.  And they don't.

It buys us one thing: The system will continue to limp along instead of 
locking up.

If drivers don't check whether registration succeeded...  What can I 
say?  It's another bug.

> > One issue: This rule doesn't allow suspend_late or resume_early methods
> > to register any new devices.
> 
> Not exactly.  Just the children of suspended devices, which makes a difference
> IMO. :-)

During suspend_late and resume_early _every_ device is suspended, 
including the fictitious "device-tree-root" device.  Hence _every_ 
registration is for a child of a suspended device.

Besides, you don't want to allow new devices to be registered during 
suspend_late, do you?  They wouldn't get suspended before the system 
went to sleep.

> > Will that cause problems with the CPU hotplug or ACPI subsystems?  ACPI in
> > particular may need to freeze the kacpi_notify workqueue -- in fact, that
> > might solve the problem in Bugzilla #9874.
> 
> Well, my impression is that we do this thing to prepare for removing the
> freezer in the future, so I'd rather solve issues in some other ways than just
> by freezing threads that get in the way. ;-)

Right now that may be the easiest solution.  In fact, it may still be 
the easiest solution even after we stop freezing user threads.

> > Remember too that the target state is set before any devices are
> > suspended.  Hence, after the state is set there may still be runtime
> > resumes taking place.  Those _must_ not fail, which means that this
> > resume ought to work also.
> 
> They may be handled in a different way, not by ->resume().

I'm not sure I understand.  Sure, autoresume may not involve calling 
the driver's resume method.  But it does involve actually setting the 
device back to full power, so what's the difference?

> > > > +				resume_device(dev);
> > > > +				mutex_lock(&dpm_list_mtx);
> > > > +				if (dev->power.sleeping != PM_GONE)
> > > > +					dev->power.sleeping = PM_AWAKE;
> > > > +			} else {
> > 
> > > Well, I wish it could be simpler ...
> > 
> > Me too.  But until the API is changed, this seems to be the best we can 
> > do.  It's not quite as bad as it looks, since a fair amount of the new 
> > code is just for reporting on and recovering from bugs in drivers.
> 
> Still, it doesn't look very nice ...

Are you still considering adding separate methods for suspend and 
hibernate (maybe also for freeze and prethaw)?  Perhaps the 
"prevent_new_children" and "allow_new_children" methods could be added 
then.  This would allow some of this complication to go away.

Alan Stern

