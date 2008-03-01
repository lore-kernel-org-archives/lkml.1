Return-Path: <linux-kernel-owner+w=401wt.eu-S1761256AbYCAPaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256AbYCAPaZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 10:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbYCAPaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 10:30:14 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1939 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756089AbYCAPaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 10:30:12 -0500
Date: Sat, 1 Mar 2008 10:30:11 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer
 removal
In-Reply-To: <200803010113.11748.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803010936490.4212-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008, Rafael J. Wysocki wrote:

> On Friday, 29 of February 2008, Alan Stern wrote:
> > On Fri, 29 Feb 2008, Rafael J. Wysocki wrote:
> > 
> > > I'm still not sure if this particular race would happen if only the registering
> > > of children of already suspended partents were blocked.
> > 
> > That's different.  Before you were talking about acquiring
> > dev->power.lock _before_ calling the suspend method.  Now you're
> > talking about blocking child registration _after_ the parent is already
> > suspended.
> 
> Hm, perhaps I don't understand the issue correctly, so please let me restate it.
> 
> We have the design issue that it's possible to register a child of a device
> that was taken for suspend or even suspended which, in turn, leads to a wrong
> ordering of devices on dpm_active.  Namely, suppose that device dev is taken
> from the end of dpm_active and suspend_device(dev, state) is going to be called
> If at the same time a child of dev is being registered and
> suspend_device(dev, state) returns 0, dev will be taken out of dpm_active, but
> the new device (its child) will be added to the end of dpm_active and
> subsequently we'll attempt to suspend it.  That will be wrong.

That's right.

> Also, if a dev's child is registered after suspending all devices, it will go
> to the end of dpm_active, so after the subsequent resume dev will end up
> closer to the end of the list than the new child.  Thus, during the next
> suspend it will be taken for suspending before this child and that will be
> wrong either.  Note that this situation need not look dangerously from the
> driver's perspective, since it doesn't know of the dpm_active ordering issue.

Yes, but it's still wrong.  It's also wrong to register a new device 
(even one that has no parent) during the suspend_late stage, because 
this device wouldn't get suspended before the system went to sleep.

> One of the possible solutions is to require suspend_device(dev, state) to
> return an error if it detects a concurrent child registration.   This, however
> is not sufficient, because the registration of a child may go unseen, right
> after suspend_device(dev, state) returns and before dpm_list_mtx is reacquired.

It's worse than you describe, because suspend_device() is unable to
tell whether a concurrent child registration is valid or invalid.  By
"valid", I mean that it took place during the window before the suspend
method was called or before the method was able to prevent new child
registrations.

Valid child registrations must be allowed to proceed.  There's no
reason to fail them, because the driver has done nothing wrong -- and
it wouldn't be safe since drivers don't check for failure.  Likewise,
blocking them is likely to cause the suspend method to deadlock; see 
below.

But since suspend_device() can't tell which concurrent child
registrations are valid, it has no choice but to allow all of them.  
This means our only option for recovering from a concurrent child
registration is to resume the parent (don't move it to dpm_off) and 
continue.  That way the list ordering will remain correct.

Once the parent is fully suspended, suspend_device() has returned, and
the parent has been moved to dpm_off, the situation is different.  
Then we _know_ that child registrations are invalid, so either blocking
or failing them would be okay.

> For this reason, we need an additional mechanism to detect such situations
> and work around them.  [Hence, the question arises whether it's really
> necessary to require suspend_device(dev, state) to detect concurrent
> registrations of children (we need to detect them independently anyway) etc.]
> There also would have to be a mechanism for detecting registrations when
> all devices have been suspended (we discussed that approach previously).
> 
> The other possible solution, and that's the one I'm considering, is to use
> locking to prevent the registration of children of suspended or suspending
> devices from happening.  [This is to protect _our_ data structure, which is
> the dpm_active list, from corruption.]

In view of my comments above, we _must not_ prevent registration of
children of suspending devices.  It's okay to prevent registration of
suspended devices.  There's nothing wrong with using a lock for this
purpose, but the lock should not be acquired until after
suspend_device() has returned and we have verified that no children
were added while suspend_device() was running.

> Now, to this end, we'd need an additional lock for each device, because using
> dev->sem for this purpose will be prone to deadlocks.  My idea is to take this
> lock (call it dev->power.lock) as soon as dev is selected for suspending
> and require that it be acquired for registering any new children of dev.  In

Consider a situation where a kernel thread is used by a driver for 
several purposes, including registering new children.  The suspend 
method will have to synchronize with the thread for obvious reasons: 
you don't want the thread to be using the device at the same time as 
the device is being suspended.

A typical synchronization approach is for the suspend method to wait
until the other thread is idle (the sort of thing that
flush_scheduled_work() does).  But if the other thread is blocked on
dev->power.lock, it will never become idle and the suspend will
deadlock.

A better approach IMO is for the other thread to always acquire 
dev->sem before doing anything.  (That's how khubd works.)  Then it is 
automatically mutually exclusive with the suspend method, with no need 
to add dev->power.lock at all.  In fact, I have long believed that any 
thread adding a child device should hold the parent's semaphore.

But until all drivers are carefully designed in accordance with these
ideas, we have to assume it is dangerous to block child registrations
before the parent is fully suspended.

> that case, the only open window is when a new child of dev is registered right
> after we've found dev at the end of dpm_active and right prior to taking
> dev->power.lock.  However, we may avoid this race by (1) selecting dev
> for suspending under dpm_list_mtx and (2) checking if it's still at the end of
> dpm_active under dev->power.lock and dpm_list_mtx (the selection of a device
> for suspending is repeated if this check fails).
> 
> The patch I sent previously implemented this idea, but it released
> dev->power.lock after calling resume_device(dev), which is not really necessary
> (dev->power.lock may be released as soon as dev is put back on dpm_active).
> Below is another version of this patch that releases dev->power.lock earlier
> and uses semaphores instead of mutexes.  [Note that it's trivial to rework it
> so that the registrations of children considered as invalid will fail instead
> of being blocked.]

> The appended patch may be reworked to release dev->power.lock for all devices
> once they all have been suspended, but since nobody should ever try to register
> a child below a suspended parent, that shouldn't be necessary.

That's not the issue.  The only problem I have with your approach is
that it blocks child registrations before the parent is fully
suspended.

> > As for the ordering of the lock and moving the device to dpm_off -- 
> > it's less of a problem if you don't acquire the lock until after the 
> > suspend method returns.  You can lock it just before reacquiring 
> > dpm_list_mtx, while the device is still on dpm_active.
> 
> The problem is that the new children should really be suspended _before_ the
> parent.  One solution is to resume the parent in case we've detected new
> children registered, the other one is not to suspend the parent at all in case
> any new children appear, and that's what I'm attempting to achieve.

I believe it isn't achievable without modifying the drivers.  That was 
the case with the MMC subsystem, for instance.

> > This is an interesting matter.  My view is that runtime PM should be
> > almost completely disabled when the PM core calls the device's suspend
> > method.  The only exception is that remote wakeup may be enabled.  If a
> > remote wakeup event occurs and the device resumes, then its parent's
> > suspend method will realize what has happened when it sees that the
> > device is no longer suspended.  So the parent's suspend method will
> > return -EBUSY and the sleep will be aborted.
> 
> I think that we may have to disable runtime PM as soon even earlier, just prior
> to starting a transition to a sleep state.  There are systems which may crash
> if we don't do that.

There must some strange interactions going on.  For instance, what if a
device sends a remote wakeup request before the system is fully asleep?

> > Right now USB does not disable runtime PM during a system sleep.  It
> > hasn't been necessary, thanks to the freezer.  But when we stop
> > freezing user tasks it will become necessary.  When that time arrives I
> > intend to put user threads doing runtime resume into the "icebox"  
> > (remember that?).  Khubd and other kernel threads could go into the
> > icebox also, instead of the freezer; in this way the freezer could be
> > removed completely.
> 
> Yes.
> 
> In fact I'd like to work out some generic guidance for all device drivers
> describing how to do such things.

When the USB design is complete it could be used as a model.  But I 
have to admit that it is rather intricate.

> > That is indeed the difference, and it's an important difference.  The
> > driver knows what other threads may be carrying out registrations, and
> > it knows which ones should be waited for and which can safely be
> > blocked or disabled.  The PM core doesn't know any of these things; all
> > it can do is blindly block everything.  That is dangerous and can lead
> > to deadlocks.
> 
> OTOH, the core should be allowed to protect it's data structures ...

Oh, I agree.  But this protection simply isn't possible without either 
allowing devices to resume after the target sleep state has been set or 
else modifying an unknown number of drivers.

Alan Stern

