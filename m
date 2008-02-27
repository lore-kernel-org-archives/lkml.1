Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbYB0TwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbYB0TwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbYB0TwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:52:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46032 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756345AbYB0TwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:52:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer removal
Date: Wed, 27 Feb 2008 20:50:39 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802271029280.4920-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802271029280.4920-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802272050.39769.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 27 of February 2008, Alan Stern wrote:
> On Wed, 27 Feb 2008, Rafael J. Wysocki wrote:
> 
> > > I've got some ideas on how to implement this.
> > > 
> > > We can add a new field "suspend_called" to dev->power.
> > 
> > I'd call it "sleeping" or something like this, for it will also be used by
> > hibernation callbacks.
> 
> The name refers to the "suspend" method, not the type of sleep being
> carried out.  We use the same method for both suspend and hibernation.

We won't in the future.

> But maybe "sleeping" would be better.
> 
> > > It would be owned by the PM core (protect by dpm_list_mtx) and read-only to
> > > drivers.  Normally it will contain 0, but when the suspend method is
> > > running we set it to SUSPEND_RUNNING and when the method returns
> > > successfully we set it to SUSPEND_DONE.  Before calling the resume
> > > method we set it back to 0.
> > 
> > Why before?  I'd think that any non-suspended children should not be visible
> > by the partent's ->resume().
> 
> All right, we can set it to RESUME_RUNNING before calling the resume
> method and then set it to 0 afterwards.  The point is that the value
> shouldn't remain SUSPEND_DONE while resume runs, because it should be
> legal for resume to register new children.

I'm not sure.  The core moves the device to dpm_active only after ->resume()
has run.  Thus, if ->resume() registers new children, the ordering of
dpm_active will be wrong.

> > > When a new device is registered we check its parent's suspend_called
> > > value.  If it is SUSPEND_DONE then the caller has a bug and we have to
> > > fail the registration.  If it is SUSPEND_RUNNING then the registration
> > > is legal, but we remember what happened.
> > 
> > This seems to require some trickery.  Namely, device_add() will notice that
> > the registration is done concurrently with the running ->suspend() of the
> > parent and will have to communicate that to dpm_suspend() which is supposed
> > to resume the master in the next step.
> 
> It will get noticed in device_pm_add() while holding dpm_list_mtx.  
> The information can be stored in a static private flag
> "child_added_while_parent_suspends" (or maybe something more terse!).

Hmm, yes, we can do it this way.

> > > Then when the currently-running suspend method returns and we reacquire the
> > > dpm_list_mtx, we will realize that a race was lost.
> > 
> > How exactly do you want to check that?
> 
> Check whether child_added_while_parent_suspends is nonzero.
> 
> > > If the method completed successfully (which it shouldn't) we can resume that
> > > device immediately without ever taking it off the dpm_active list; but either
> > > way we should continue the suspend loop.  Now the new child will be at
> > > the end of the dpm_active_list, so it will be suspended before the
> > > parent is reached again.
> > > 
> > > This way we can recover from drivers that are willing to suspend their 
> > > device even though there are unsuspended children.  The only drawback 
> > > will be that for a short time the child will be active while its parent 
> > > is suspended.
> > 
> > Well, if the parent is a bus, that will be a problem.
> 
> Sure.  But it won't be the PM core's problem; it will be a bug in the
> bus's driver.  We will print a warning in the log so the bug can be 
> tracked down.
> 
> > > We should not abort the entire sleep transition simply because we lost 
> > > a race.
> > 
> > I don't agree here.  If we require drivers to prevent such races from happening
> > and they don't comply, we can give up instead of trying to work around the
> > non-compilance.
> 
> You misunderstand.

Well, I misunderstood indeed.

> We can't require drivers to prevent these races entirely.  As an example, a
> properly-written, compliant driver might work like this:
> 
> 	Task 0				Task 1
> 	------				------
> 	dev->power.sleeping =
> 	  SUSPEND_RUNNING;
> 	Call (drv->suspend)(dev)
> 					Register a child below dev
> 	suspend method prevents new
> 	  child registrations
> 	suspend method waits for
> 	  existing registration to
> 	  finish
> 					Check dev->power.sleeping and set
> 					  child_added_while_parent_suspends
> 					Registration completes successfully
> 	suspend method sees there is
> 	  an unsuspended child and
> 	  returns -EBUSY
> 
> 	Check child_added_while_parent_suspends
> 	  and realize that we lost the race
> 
> There's nothing illegal about this; it's just an accident of timing.  
> Nothing has gone wrong and we shouldn't abort the sleep.  We should
> continue where we left off, by suspending the new child and then trying
> to suspend the parent again.
> 
> > > With this scheme we won't even need the pm_sleep_rwsem; the  
> > > dpm_list_mtx will provide all the necessary protection.
> > > 
> > > This is more intricate than it should be.  It would have been better to
> > > have had "disable_new_children" and "enable_new_children" methods from
> > > the beginning; then there wouldn't be any races at all.  That's life...
> > > 
> > > The one tricky thing to watch out for is when a suspend or resume 
> > > method wants to unregister the device being suspended or resumed.
> > 
> > That can't happen, because dev->sem is taken by suspend_device() and
> > device_del() would lock up attempting to acquire it once again.
> 
> We'll have to fix device_del() to prevent that from happening.  Your 
> in_sleep_context() approach should work.

I'm not sure if we need to do it.  It's always been like this, so the current
drivers' ->suspend() and ->resume() don't unregister the device they're called
for.  I don't see any advantage from doing that for future drivers.

> > > Unregistration should always be allowed, and registration should be 
> > > allowed whenever the parent isn't suspended.
> > 
> > I'm still thinking that registering while the parent is suspending should not
> > be allowed.
> 
> Unfortunately the lack of "prevent_new_children" and 
> "allow_new_children" methods gives us no choice.  The example above 
> shows why.

Yes, it does.

Thanks,
Rafael
