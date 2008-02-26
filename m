Return-Path: <linux-kernel-owner+w=401wt.eu-S932242AbYBZXSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbYBZXSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763286AbYBZXSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:18:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39524 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762945AbYBZXSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:18:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer removal
Date: Wed, 27 Feb 2008 00:17:15 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802261016540.4176-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802261016540.4176-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802270017.16108.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 26 of February 2008, Alan Stern wrote:
> On Tue, 26 Feb 2008, Rafael J. Wysocki wrote:
> 
> > > > IMO the device driver should assure that no new children will be registered
> > > > concurrently with the ->suspend() method (IOW, ->suspend() should wait for
> > > > all such registrations to complete and should prevent any new ones from
> > > > being started) and it should make it impossible to register any new children
> > > > after ->suspend() has run.  It's the driver's problem how to achieve that.
> > > 
> > > Exactly; this has to be added to the PM documentation.
> > 
> > Into Documentation/power/devices.txt, I gather?
> 
> Yes.
> 
> > > > > The PM core could help detect errors here.  If it tries to suspend a 
> > > > > device and sees that the device's parent is already suspended, then the 
> > > > > parent's driver has a bug.
> > > > 
> > > > Yes, I think we ought to fail the suspend in such cases.  Still, that's not
> > > > sufficient to prevent a child from being registered after we've run
> > > > dpm_suspend().  For this reason, we could also leave dpm_suspend() with
> > > > dpm_list_mtx held and not release it until the next dpm_resume() is run.
> > > 
> > > The pm_sleep_rwsem will do a better job of catching such errors.
> > 
> > But we should not leave a window between releasing dpm_list_mtx and taking
> > pm_sleep_rwsem.  Either that, or we should make sure that dpm_active is
> > empty after acquiring pm_sleep_rwsem.
> 
> I've got some ideas on how to implement this.
> 
> We can add a new field "suspend_called" to dev->power.

I'd call it "sleeping" or something like this, for it will also be used by
hibernation callbacks.

> It would be owned by the PM core (protect by dpm_list_mtx) and read-only to
> drivers.  Normally it will contain 0, but when the suspend method is
> running we set it to SUSPEND_RUNNING and when the method returns
> successfully we set it to SUSPEND_DONE.  Before calling the resume
> method we set it back to 0.

Why before?  I'd think that any non-suspended children should not be visible
by the partent's ->resume().

> Drivers can use this field as an easy way of checking that all the child
> devices have been suspended. 
> 
> When a new device is registered we check its parent's suspend_called
> value.  If it is SUSPEND_DONE then the caller has a bug and we have to
> fail the registration.  If it is SUSPEND_RUNNING then the registration
> is legal, but we remember what happened.

This seems to require some trickery.  Namely, device_add() will notice that
the registration is done concurrently with the running ->suspend() of the
parent and will have to communicate that to dpm_suspend() which is supposed
to resume the master in the next step.

> Then when the currently-running suspend method returns and we reacquire the
> dpm_list_mtx, we will realize that a race was lost.

How exactly do you want to check that?

> If the method completed successfully (which it shouldn't) we can resume that
> device immediately without ever taking it off the dpm_active list; but either
> way we should continue the suspend loop.  Now the new child will be at
> the end of the dpm_active_list, so it will be suspended before the
> parent is reached again.
> 
> This way we can recover from drivers that are willing to suspend their 
> device even though there are unsuspended children.  The only drawback 
> will be that for a short time the child will be active while its parent 
> is suspended.

Well, if the parent is a bus, that will be a problem.

> We should not abort the entire sleep transition simply because we lost 
> a race.

I don't agree here.  If we require drivers to prevent such races from happening
and they don't comply, we can give up instead of trying to work around the
non-compilance.

> With this scheme we won't even need the pm_sleep_rwsem; the  
> dpm_list_mtx will provide all the necessary protection.
> 
> This is more intricate than it should be.  It would have been better to
> have had "disable_new_children" and "enable_new_children" methods from
> the beginning; then there wouldn't be any races at all.  That's life...
> 
> The one tricky thing to watch out for is when a suspend or resume 
> method wants to unregister the device being suspended or resumed.

That can't happen, because dev->sem is taken by suspend_device() and
device_del() would lock up attempting to acquire it once again.

> Even  that should be doable (set suspend_called to UNREGISTERED or something 
> like that).
> 
> > > > That will potentially cause some trouble to CPU hotplug cotifiers, but we can
> > > > handle that, for example, by using the in_suspend_context() test.
> > > 
> > > Do they need to register new CPUs at some point?  There ought to be a 
> > > way to handle that.
> > 
> > No, they don't, but there are some CPU-related device objects that get
> > uregistered/registered.  Still, all of this work is really redundant if the CPU
> > in question comes back up during the resume, so it should be avoided in
> > general.  The CPU hotplug notifiers should only unregister those objects if
> > the CPU hasn't gone on line during the resume and they have all information
> > necessary for discovering that.
> 
> Unregistration should always be allowed, and registration should be 
> allowed whenever the parent isn't suspended.

I'm still thinking that registering while the parent is suspending should not
be allowed.

> For devices with no parent, we can imagine there is a fictitious parent at
> the root of the device tree.  Conceptually it gets suspended after every real
> device and resumed before.  Maybe even before dpm_power_up(), meaning that 
> devices with no parent could be registered by a resume_early method.
> 
> When your lock-removal stuff gets into Greg's tree, I'll write all 
> this.  Sound good?

The direction seems to be fine, but the details need a bit more clarification,
as far as I'm concerned.  Having a patch to discuss will certainly help a lot,
though. ;-)

Thanks,
Rafael
