Return-Path: <linux-kernel-owner+w=401wt.eu-S932658AbYB2Wqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbYB2Wqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932690AbYB2WqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:46:14 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57740 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932259AbYB2WqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:46:13 -0500
Date: Fri, 29 Feb 2008 17:46:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer
 removal
In-Reply-To: <200802292257.52480.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802291709330.3343-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008, Rafael J. Wysocki wrote:

> I'm still not sure if this particular race would happen if only the registering
> of children of already suspended partents were blocked.

That's different.  Before you were talking about acquiring
dev->power.lock _before_ calling the suspend method.  Now you're
talking about blocking child registration _after_ the parent is already
suspended.

It might work if you did it that way.  In theory it _should_ work,
since nobody should ever try to register a child below a suspended
parent.

Given that this is merely a way of preventing something which should
never happen in the first place, is it really necessary to add the
extra lock?  Certainly it's simpler just to fail the registration.  If
it turns out later that we'd be better off blocking it instead, we
can add the lock.

> > > @@ -427,6 +433,13 @@ static int dpm_suspend(pm_message_t stat
> > >  		struct device *dev = to_device(entry);
> > >  
> > >  		mutex_unlock(&dpm_list_mtx);
> > > +		mutex_lock(&dev->power.lock);
> > > +		mutex_lock(&dpm_list_mtx);
> > > +		if (dev != to_device(dpm_active.prev)) {
> > > +			mutex_unlock(&dev->power.lock);
> > > +			continue;
> > > +		}
> > > +		mutex_unlock(&dpm_list_mtx);
> > >  		error = suspend_device(dev, state);
> > >  		mutex_lock(&dpm_list_mtx);
> > >  		if (error) {
> > 
> > This looks pretty awkward.  Won't it cause lockdep to complain about
> > recursive locking of dev->power.lock?
> 
> Why would it?  It's not taken recursively at any place.

It is as far as lockdep is concerned.  You acquire power.lock for the 
first device, then you acquire it for the second device.  Lockdep 
doesn't know the two devices are different; all it knows is that you 
have tried to acquire a lock while already holding an instance of that 
same lock.  It's the same problem that affects attempts to convert 
dev->sem to a mutex.

As for the ordering of the lock and moving the device to dpm_off -- 
it's less of a problem if you don't acquire the lock until after the 
suspend method returns.  You can lock it just before reacquiring 
dpm_list_mtx, while the device is still on dpm_active.

> > > That doesn't buy us anything if drivers don't check whether the registration
> > > succeeded.  And they don't.
> > 
> > It buys us one thing: The system will continue to limp along instead of 
> > locking up.
> 
> It may oops, though, if a driver attempts to use a device that it failed to
> register, but didn't check.

Which is better, an oops or a hang?  As far as the user is concerned, 
either one is useless.  For kernel developers, an oops is easier to 
debug.

In the end we should just try it and see what happens.  I don't think 
we can decide which will work out better without some real-world 
experience.

> > > > Will that cause problems with the CPU hotplug or ACPI subsystems?  ACPI in
> > > > particular may need to freeze the kacpi_notify workqueue -- in fact, that
> > > > might solve the problem in Bugzilla #9874.
> > > 
> > > Well, my impression is that we do this thing to prepare for removing the
> > > freezer in the future, so I'd rather solve issues in some other ways than just
> > > by freezing threads that get in the way. ;-)
> > 
> > Right now that may be the easiest solution.  In fact, it may still be 
> > the easiest solution even after we stop freezing user threads.
> 
> Well, people want to remove the freezing of tasks altogether from the suspend
> code path.  Do you think it's not doable in the long run?

That's not what I mean.  In the long run it will turn out that certain
kernel threads _want_ to be frozen.  That is, if allowed to run during
a system sleep transition they would mess things up, and their
subsystem is designed so that it can carry out a sleep transition
perfectly well without the thread running.  (An example of such a
thread is khubd.)

To accomodate these threads we can freeze them -- that's easy since the
freezer already exists.  Or we can remove the freezer and provide a new
way for these threads to block until the system wakes up.  IMO using
the existing code is better than writing new code.

All the objections to the freezer have been about using it on arbitrary
kernel threads and on all user tasks.  But if it gets used on only
those kernel threads which request it, and on no user tasks, there
shouldn't be any objections.

> In fact, that's the matter of how we are going to handle the runtime PM vs
> the system-wide suspend.

This is an interesting matter.  My view is that runtime PM should be
almost completely disabled when the PM core calls the device's suspend
method.  The only exception is that remote wakeup may be enabled.  If a
remote wakeup event occurs and the device resumes, then its parent's
suspend method will realize what has happened when it sees that the
device is no longer suspended.  So the parent's suspend method will
return -EBUSY and the sleep will be aborted.

Right now USB does not disable runtime PM during a system sleep.  It
hasn't been necessary, thanks to the freezer.  But when we stop
freezing user tasks it will become necessary.  When that time arrives I
intend to put user threads doing runtime resume into the "icebox"  
(remember that?).  Khubd and other kernel threads could go into the
icebox also, instead of the freezer; in this way the freezer could be
removed completely.

> > Perhaps the "prevent_new_children" and "allow_new_children" methods could be
> > added then.  This would allow some of this complication to go away.
> 
> I wonder how that would be different from using dev->power.lock for blocking
> the registration of new children.  The only practical difference I see is that
> the driver will have to block the registrations, this way or another, instead
> of the core.

That is indeed the difference, and it's an important difference.  The
driver knows what other threads may be carrying out registrations, and
it knows which ones should be waited for and which can safely be
blocked or disabled.  The PM core doesn't know any of these things; all
it can do is blindly block everything.  That is dangerous and can lead
to deadlocks.

Alan Stern

