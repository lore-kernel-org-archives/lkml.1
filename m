Return-Path: <linux-kernel-owner+w=401wt.eu-S932358AbYCAAOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbYCAAOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 19:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbYCAAOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 19:14:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33576 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbYCAAOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 19:14:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer removal
Date: Sat, 1 Mar 2008 01:13:11 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802291709330.3343-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802291709330.3343-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803010113.11748.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 29 of February 2008, Alan Stern wrote:
> On Fri, 29 Feb 2008, Rafael J. Wysocki wrote:
> 
> > I'm still not sure if this particular race would happen if only the registering
> > of children of already suspended partents were blocked.
> 
> That's different.  Before you were talking about acquiring
> dev->power.lock _before_ calling the suspend method.  Now you're
> talking about blocking child registration _after_ the parent is already
> suspended.

Hm, perhaps I don't understand the issue correctly, so please let me restate it.

We have the design issue that it's possible to register a child of a device
that was taken for suspend or even suspended which, in turn, leads to a wrong
ordering of devices on dpm_active.  Namely, suppose that device dev is taken
from the end of dpm_active and suspend_device(dev, state) is going to be called
If at the same time a child of dev is being registered and
suspend_device(dev, state) returns 0, dev will be taken out of dpm_active, but
the new device (its child) will be added to the end of dpm_active and
subsequently we'll attempt to suspend it.  That will be wrong.

Also, if a dev's child is registered after suspending all devices, it will go
to the end of dpm_active, so after the subsequent resume dev will end up
closer to the end of the list than the new child.  Thus, during the next
suspend it will be taken for suspending before this child and that will be
wrong either.  Note that this situation need not look dangerously from the
driver's perspective, since it doesn't know of the dpm_active ordering issue.

One of the possible solutions is to require suspend_device(dev, state) to
return an error if it detects a concurrent child registration.   This, however
is not sufficient, because the registration of a child may go unseen, right
after suspend_device(dev, state) returns and before dpm_list_mtx is reacquired.
For this reason, we need an additional mechanism to detect such situations
and work around them.  [Hence, the question arises whether it's really
necessary to require suspend_device(dev, state) to detect concurrent
registrations of children (we need to detect them independently anyway) etc.]
There also would have to be a mechanism for detecting registrations when
all devices have been suspended (we discussed that approach previously).

The other possible solution, and that's the one I'm considering, is to use
locking to prevent the registration of children of suspended or suspending
devices from happening.  [This is to protect _our_ data structure, which is
the dpm_active list, from corruption.]

Now, to this end, we'd need an additional lock for each device, because using
dev->sem for this purpose will be prone to deadlocks.  My idea is to take this
lock (call it dev->power.lock) as soon as dev is selected for suspending
and require that it be acquired for registering any new children of dev.  In
that case, the only open window is when a new child of dev is registered right
after we've found dev at the end of dpm_active and right prior to taking
dev->power.lock.  However, we may avoid this race by (1) selecting dev
for suspending under dpm_list_mtx and (2) checking if it's still at the end of
dpm_active under dev->power.lock and dpm_list_mtx (the selection of a device
for suspending is repeated if this check fails).

The patch I sent previously implemented this idea, but it released
dev->power.lock after calling resume_device(dev), which is not really necessary
(dev->power.lock may be released as soon as dev is put back on dpm_active).
Below is another version of this patch that releases dev->power.lock earlier
and uses semaphores instead of mutexes.  [Note that it's trivial to rework it
so that the registrations of children considered as invalid will fail instead
of being blocked.]

> It might work if you did it that way.  In theory it _should_ work,
> since nobody should ever try to register a child below a suspended
> parent.

The appended patch may be reworked to release dev->power.lock for all devices
once they all have been suspended, but since nobody should ever try to register
a child below a suspended parent, that shouldn't be necessary.

> Given that this is merely a way of preventing something which should
> never happen in the first place, is it really necessary to add the
> extra lock?  Certainly it's simpler just to fail the registration.

That actually requires quite a bit of entangled code, new flags etc. :-)

> If it turns out later that we'd be better off blocking it instead, we can add
> the lock. 

We can use the lock for failing registrations just as well.
 
> > > > @@ -427,6 +433,13 @@ static int dpm_suspend(pm_message_t stat
> > > >  		struct device *dev = to_device(entry);
> > > >  
> > > >  		mutex_unlock(&dpm_list_mtx);
> > > > +		mutex_lock(&dev->power.lock);
> > > > +		mutex_lock(&dpm_list_mtx);
> > > > +		if (dev != to_device(dpm_active.prev)) {
> > > > +			mutex_unlock(&dev->power.lock);
> > > > +			continue;
> > > > +		}
> > > > +		mutex_unlock(&dpm_list_mtx);
> > > >  		error = suspend_device(dev, state);
> > > >  		mutex_lock(&dpm_list_mtx);
> > > >  		if (error) {
> > > 
> > > This looks pretty awkward.  Won't it cause lockdep to complain about
> > > recursive locking of dev->power.lock?
> > 
> > Why would it?  It's not taken recursively at any place.
> 
> It is as far as lockdep is concerned.  You acquire power.lock for the 
> first device, then you acquire it for the second device.  Lockdep 
> doesn't know the two devices are different; all it knows is that you 
> have tried to acquire a lock while already holding an instance of that 
> same lock.  It's the same problem that affects attempts to convert 
> dev->sem to a mutex.

Well, let the new lock be a semaphore, then. ;-)

> As for the ordering of the lock and moving the device to dpm_off -- 
> it's less of a problem if you don't acquire the lock until after the 
> suspend method returns.  You can lock it just before reacquiring 
> dpm_list_mtx, while the device is still on dpm_active.

The problem is that the new children should really be suspended _before_ the
parent.  One solution is to resume the parent in case we've detected new
children registered, the other one is not to suspend the parent at all in case
any new children appear, and that's what I'm attempting to achieve.

> > > > That doesn't buy us anything if drivers don't check whether the registration
> > > > succeeded.  And they don't.
> > > 
> > > It buys us one thing: The system will continue to limp along instead of 
> > > locking up.
> > 
> > It may oops, though, if a driver attempts to use a device that it failed to
> > register, but didn't check.
> 
> Which is better, an oops or a hang?  As far as the user is concerned, 
> either one is useless.  For kernel developers, an oops is easier to 
> debug.
> 
> In the end we should just try it and see what happens.  I don't think 
> we can decide which will work out better without some real-world 
> experience.

Agreed.

> > > > > Will that cause problems with the CPU hotplug or ACPI subsystems?  ACPI in
> > > > > particular may need to freeze the kacpi_notify workqueue -- in fact, that
> > > > > might solve the problem in Bugzilla #9874.
> > > > 
> > > > Well, my impression is that we do this thing to prepare for removing the
> > > > freezer in the future, so I'd rather solve issues in some other ways than just
> > > > by freezing threads that get in the way. ;-)
> > > 
> > > Right now that may be the easiest solution.  In fact, it may still be 
> > > the easiest solution even after we stop freezing user threads.
> > 
> > Well, people want to remove the freezing of tasks altogether from the suspend
> > code path.  Do you think it's not doable in the long run?
> 
> That's not what I mean.  In the long run it will turn out that certain
> kernel threads _want_ to be frozen.  That is, if allowed to run during
> a system sleep transition they would mess things up, and their
> subsystem is designed so that it can carry out a sleep transition
> perfectly well without the thread running.  (An example of such a
> thread is khubd.)
> 
> To accomodate these threads we can freeze them -- that's easy since the
> freezer already exists.  Or we can remove the freezer and provide a new
> way for these threads to block until the system wakes up.  IMO using
> the existing code is better than writing new code.

Well, it surely is reasonable. ;-)

> All the objections to the freezer have been about using it on arbitrary
> kernel threads and on all user tasks.  But if it gets used on only
> those kernel threads which request it, and on no user tasks, there
> shouldn't be any objections.

You may be right.

> > In fact, that's the matter of how we are going to handle the runtime PM vs
> > the system-wide suspend.
> 
> This is an interesting matter.  My view is that runtime PM should be
> almost completely disabled when the PM core calls the device's suspend
> method.  The only exception is that remote wakeup may be enabled.  If a
> remote wakeup event occurs and the device resumes, then its parent's
> suspend method will realize what has happened when it sees that the
> device is no longer suspended.  So the parent's suspend method will
> return -EBUSY and the sleep will be aborted.

I think that we may have to disable runtime PM as soon even earlier, just prior
to starting a transition to a sleep state.  There are systems which may crash
if we don't do that.

> Right now USB does not disable runtime PM during a system sleep.  It
> hasn't been necessary, thanks to the freezer.  But when we stop
> freezing user tasks it will become necessary.  When that time arrives I
> intend to put user threads doing runtime resume into the "icebox"  
> (remember that?).  Khubd and other kernel threads could go into the
> icebox also, instead of the freezer; in this way the freezer could be
> removed completely.

Yes.

In fact I'd like to work out some generic guidance for all device drivers
describing how to do such things.
 
> > > Perhaps the "prevent_new_children" and "allow_new_children" methods could be
> > > added then.  This would allow some of this complication to go away.
> > 
> > I wonder how that would be different from using dev->power.lock for blocking
> > the registration of new children.  The only practical difference I see is that
> > the driver will have to block the registrations, this way or another, instead
> > of the core.
> 
> That is indeed the difference, and it's an important difference.  The
> driver knows what other threads may be carrying out registrations, and
> it knows which ones should be waited for and which can safely be
> blocked or disabled.  The PM core doesn't know any of these things; all
> it can do is blindly block everything.  That is dangerous and can lead
> to deadlocks.

OTOH, the core should be allowed to protect it's data structures ...

Thanks,
Rafael

---
 drivers/base/power/main.c |   14 ++++++++++++++
 include/linux/pm.h        |    2 ++
 2 files changed, 16 insertions(+)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -26,6 +26,7 @@
 #include <linux/list.h>
 #include <asm/atomic.h>
 #include <asm/errno.h>
+#include <asm/semaphore.h>
 
 /*
  * Power management requests... these are passed to pm_send_all() and friends.
@@ -186,6 +187,7 @@ struct dev_pm_info {
 #ifdef	CONFIG_PM_SLEEP
 	unsigned		should_wakeup:1;
 	struct list_head	entry;
+	struct semaphore	lock;
 #endif
 };
 
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -67,9 +67,14 @@ void device_pm_add(struct device *dev)
 	pr_debug("PM: Adding info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
+	init_MUTEX(&dev->power.lock);
+	if (dev->parent)
+		down(&dev->parent->power.lock);
 	mutex_lock(&dpm_list_mtx);
 	list_add_tail(&dev->power.entry, &dpm_active);
 	mutex_unlock(&dpm_list_mtx);
+	if (dev->parent)
+		up(&dev->parent->power.lock);
 }
 
 /**
@@ -248,6 +253,7 @@ static void dpm_resume(void)
 
 		list_move_tail(entry, &dpm_active);
 		mutex_unlock(&dpm_list_mtx);
+		up(&dev->power.lock);
 		resume_device(dev);
 		mutex_lock(&dpm_list_mtx);
 	}
@@ -427,6 +433,13 @@ static int dpm_suspend(pm_message_t stat
 		struct device *dev = to_device(entry);
 
 		mutex_unlock(&dpm_list_mtx);
+		down(&dev->power.lock);
+		mutex_lock(&dpm_list_mtx);
+		if (dev != to_device(dpm_active.prev)) {
+			up(&dev->power.lock);
+			continue;
+		}
+		mutex_unlock(&dpm_list_mtx);
 		error = suspend_device(dev, state);
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
@@ -437,6 +450,7 @@ static int dpm_suspend(pm_message_t stat
 					(error == -EAGAIN ?
 					" (please convert to suspend_late)" :
 					""));
+			up(&dev->power.lock);
 			break;
 		}
 		if (!list_empty(&dev->power.entry))
