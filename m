Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbYCCQeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbYCCQeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYCCQeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:34:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45893 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbYCCQeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:34:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer removal
Date: Mon, 3 Mar 2008 17:32:52 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <Pine.LNX.4.44L0.0803022152270.6168-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803022152270.6168-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031732.52823.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 3 of March 2008, Alan Stern wrote:
> On Sun, 2 Mar 2008, Rafael J. Wysocki wrote:
[--snip--]
> 
> > > The prevent_new_children methods should be called in a separate initial
> > > forward pass through the dpm_active list -- rather like the reverted
> > > lock_all_devices() routine.  Similarly for the allow_new_children 
> > > methods (a final backward pass like unlock_all_devices()).
> > 
> > Agreed.
> 
> After more thought, I'm not so sure about this.  It might be a good
> idea to call the begin_sleep method just before the suspend method (or
> any of its variants: freeze, hibernate, prethaw, etc.) and call the
> end_sleep method just after the resume method.  This minimizes the time
> drivers will spend in a peculiar non-hotplug-aware state, although it 
> means that begin_sleep would have to be idempotent.
> 
> It also allows sophisticated drivers to do all their processing in the
> begin_sleep (and end_sleep) method: both preventing new child
> registrations and powering down the device.  At the moment I'm not sure
> whether this would turn out to be a good strategy, but it might.

Well, I think there should be a window between ->suspend_begin()
and ->suspend() allowing the core to cancel the suspending of given
device and to select another one.  For example, if there's a child
registration concurrent wrt ->suspend_begin() which completes after
->suspend_begin() has been called, but before ->suspend_begin() has a chance
to block it, the core should not call ->suspend() for the device, but select
another one (the child).

Of course, it won't be necessary if the ->suspend_begin() methods are called
in an initial forward pass through dpm_active.

> Alternatively, some subsystems might want to stop all child
> registrations right at the beginning of the sleep transition.  This
> would amount to blocking the kernel thread responsible for those
> registrations when the sleep begins -- in other words, making that
> thread freezable!

Well, I think the possibility to freeze kernel threads on demand may be
considered as one of suspend synchronization mechanisms available to drivers.

[--snip--] 
> > > Actually you can simplify the whole thing by getting rid of 
> > > dev->power.lock entirely.  Protect the "sleeping" flag by dpm_list_mtx.
> > 
> > Then, if a child registration occurs while suspend_device(parent) is being
> > run, dpm_active will be in a wrong order, unless suspend_device(parent) returns
> > an error (which, BTW, also imposes a new rule on drivers).
> 
> Sorry, I don't follow you.
> 
> I meant doing something approximately like this:
> 
> 	mutex_lock(&dpm_list_mtx);
> 	while (!list_is_empty(&dpm_active)) {
> 		dev = dpm_active.prev;
> 		dev->power.sleeping = true;
> 		mutex_unlock(&dpm_list_mtx);
> 		error = suspend_device(dev);
> 		mutex_lock(&dpm_list_mtx);
> 		...
> 	}
> 
> and make device_pm_add() fail if dev->parent->power.sleeping is true.
> This will do what you want, right?

Yes, that should work.  I'll rework the patch along these lines (it starts to
look really simple now :-); I'll post the new version in a separate thread).

> With the begin_sleep method call added it gets a little more
> complicated, since you have to reacquire dpm_list_mtx after calling the
> begin_sleep method and before setting dev->power.sleeping to true, in
> order to make sure that dev is still the last entry on dpm_active.  
> But it's quite doable.

Yes, it is.

> (BTW, I wonder if it's a good idea for device_add() to call 
> device_pm_add() before calling bus_add_device().  If a suspend occurs 
> in between, we could end up in a strange situation with a driver being 
> asked to suspend a device before that device has been fully registered 
> -- in fact the registration might still fail.)

That's correct.  Perhaps we should change device_add().

> > I'm not sure the "GONE" state willl really be necessary.
> 
> I'm not sure either.  You can get the same effect by checking 
> list_empty(&dev->power.entry).
> 
> > Well, we can add new callbacks for notifying drivers of an impending suspend.
> > In that case, say we add a ->begin() callback for this purpose (in fact that
> > would be two callbacks, ->suspend_begin() and ->hibernate_begin(), but let's
> > simplify things a bit for now), so there are the following questions:
> 
> In theory you could even expand it to freeze_begin and prethaw_begin.

I meant ->hibernate_begin() as ->freeze_begin() and I don't see any reason why
->prethaw_begin() would be different from it (the difference between ->freeze()
and ->prethaw() -- now called ->quiesce(), btw -- is that the former saves
device settings and the latter doesn't).
 
> > * Is it going to return a result?
> > * If it is, should we fail the suspend if an error is returned?
> > * In that case, should the ->suspend() callback return a result?
> 
> To be safe, everything should return a result and we should abort the 
> sleep if anything returns an error.
> 
> It's easier to ignore a return code now than to change a method
> signature later.  :-)
> 
> > * Perhaps we can require ->suspend() to always succeed after ->begin() has
> >   succeeded?
> 
> No.  Some drivers might implement just one and some drivers just the 
> other.

I thought ->suspend() would be mandatory, even if it's to be empty.

> > OTOH, IMO requiring ->suspend() to return an error if there's been a concurrent
> > child registration and resuming the device if that happens is not a trivial
> > change and it may require as many driver modifications as failing the
> > registration of the child right away.
> 
> That's true.  If the driver's author wants to do things that way, he
> can.  For instance, there are several subsystems which will probe for
> new children as part of their resume processing.  So if a child was
> detected just before the system went to sleep and failed to get
> registered, then it will be detected again when the system wakes up and
> now the registration will succeed.
> 
> Here's something else to think about.  We might want to allow some 
> devices to be "power-irrelevant".  That is, the device exists in the 
> kernel only as a representation of some software state, not as a 
> physical device.  It doesn't consume power, it doesn't have any state 
> to lose during a sleep, and its driver doesn't implement suspend or 
> resume methods.  For these sorts of devices, we might allow 
> device_add() to skip calling device_pm_add() altogether.  USB 
> interfaces are a little like this, as are SCSI hosts and MMC hosts.

If such devices serve as logical parents of some "real" ones, we should
at least mark them as "sleeping" during suspend to protect the dpm_active
ordering.

Thanks,
Rafael
