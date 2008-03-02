Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYCBNjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYCBNjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 08:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYCBNjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 08:39:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39138 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYCBNjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 08:39:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer removal
Date: Sun, 2 Mar 2008 14:37:31 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803010936490.4212-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803010936490.4212-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803021437.31977.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 1 of March 2008, Alan Stern wrote:
> On Sat, 1 Mar 2008, Rafael J. Wysocki wrote:
> 
> > On Friday, 29 of February 2008, Alan Stern wrote:
> > > On Fri, 29 Feb 2008, Rafael J. Wysocki wrote:
> > > 
> > > > I'm still not sure if this particular race would happen if only the registering
> > > > of children of already suspended partents were blocked.
> > > 
> > > That's different.  Before you were talking about acquiring
> > > dev->power.lock _before_ calling the suspend method.  Now you're
> > > talking about blocking child registration _after_ the parent is already
> > > suspended.
> > 
> > Hm, perhaps I don't understand the issue correctly, so please let me restate it.
> > 
> > We have the design issue that it's possible to register a child of a device
> > that was taken for suspend or even suspended which, in turn, leads to a wrong
> > ordering of devices on dpm_active.  Namely, suppose that device dev is taken
> > from the end of dpm_active and suspend_device(dev, state) is going to be called
> > If at the same time a child of dev is being registered and
> > suspend_device(dev, state) returns 0, dev will be taken out of dpm_active, but
> > the new device (its child) will be added to the end of dpm_active and
> > subsequently we'll attempt to suspend it.  That will be wrong.
> 
> That's right.
> 
> > Also, if a dev's child is registered after suspending all devices, it will go
> > to the end of dpm_active, so after the subsequent resume dev will end up
> > closer to the end of the list than the new child.  Thus, during the next
> > suspend it will be taken for suspending before this child and that will be
> > wrong either.  Note that this situation need not look dangerously from the
> > driver's perspective, since it doesn't know of the dpm_active ordering issue.
> 
> Yes, but it's still wrong.  It's also wrong to register a new device 
> (even one that has no parent) during the suspend_late stage, because 
> this device wouldn't get suspended before the system went to sleep.

That's correct.

> > One of the possible solutions is to require suspend_device(dev, state) to
> > return an error if it detects a concurrent child registration.   This, however
> > is not sufficient, because the registration of a child may go unseen, right
> > after suspend_device(dev, state) returns and before dpm_list_mtx is reacquired.
> 
> It's worse than you describe, because suspend_device() is unable to
> tell whether a concurrent child registration is valid or invalid.  By
> "valid", I mean that it took place during the window before the suspend
> method was called or before the method was able to prevent new child
> registrations.
> 
> Valid child registrations must be allowed to proceed. There's no 
> reason to fail them, because the driver has done nothing wrong -- and
> it wouldn't be safe since drivers don't check for failure.

Yes, that's bad, but I don't see any other solution at the moment (see below).

> Likewise, blocking them is likely to cause the suspend method to deadlock;
> see below.
> 
> But since suspend_device() can't tell which concurrent child
> registrations are valid, it has no choice but to allow all of them.  
> This means our only option for recovering from a concurrent child
> registration is to resume the parent (don't move it to dpm_off) and 
> continue.  That way the list ordering will remain correct.

If new children get registered when the parent is suspended, that's already
wrong, because the children should have been suspended before.  Think of a case
when the parent is a bus and the children are devices on it.  In that case, by
suspending the parent before the children we can make the children
unresponsive etc. (that would break the PCI PM rules, for one example).

> Once the parent is fully suspended, suspend_device() has returned, and
> the parent has been moved to dpm_off, the situation is different.

In fact we don't.  We only know that suspend_device() has won the race with
the device registration.

> Then we _know_ that child registrations are invalid, so either blocking
> or failing them would be okay.
> 
> > For this reason, we need an additional mechanism to detect such situations
> > and work around them.  [Hence, the question arises whether it's really
> > necessary to require suspend_device(dev, state) to detect concurrent
> > registrations of children (we need to detect them independently anyway) etc.]
> > There also would have to be a mechanism for detecting registrations when
> > all devices have been suspended (we discussed that approach previously).
> > 
> > The other possible solution, and that's the one I'm considering, is to use
> > locking to prevent the registration of children of suspended or suspending
> > devices from happening.  [This is to protect _our_ data structure, which is
> > the dpm_active list, from corruption.]
> 
> In view of my comments above, we _must not_ prevent registration of
> children of suspending devices.  It's okay to prevent registration of
> suspended devices.

I don't agree with that (not only because the last sentence is oversimplified ;-)).

I think that the rule "the driver must not register new children after
->suspend() has run" is not a good one, because in fact we don't want
->suspend() to be called while new children are being registered.  IMO, we
should make the rule that "device registration may fail if it's carried out
concurrently with the parent's ->suspend() method".  At least, that will tell
the drivers what to do or avoid.

> There's nothing wrong with using a lock for this 
> purpose, but the lock should not be acquired until after
> suspend_device() has returned and we have verified that no children
> were added while suspend_device() was running.

I don't agree with that too.

> > Now, to this end, we'd need an additional lock for each device, because using
> > dev->sem for this purpose will be prone to deadlocks.  My idea is to take this
> > lock (call it dev->power.lock) as soon as dev is selected for suspending
> > and require that it be acquired for registering any new children of dev.  In
> 
> Consider a situation where a kernel thread is used by a driver for 
> several purposes, including registering new children.  The suspend 
> method will have to synchronize with the thread for obvious reasons: 
> you don't want the thread to be using the device at the same time as 
> the device is being suspended.
> 
> A typical synchronization approach is for the suspend method to wait
> until the other thread is idle (the sort of thing that
> flush_scheduled_work() does).  But if the other thread is blocked on
> dev->power.lock, it will never become idle and the suspend will
> deadlock.

I agree it's not a good idea to hold the locks throughout the entire cycle,
but that can be overcome if we use an additional variable under
dev_pm_info (see patch below).

> A better approach IMO is for the other thread to always acquire 
> dev->sem before doing anything.  (That's how khubd works.)  Then it is 
> automatically mutually exclusive with the suspend method, with no need 
> to add dev->power.lock at all.  In fact, I have long believed that any 
> thread adding a child device should hold the parent's semaphore.
> 
> But until all drivers are carefully designed in accordance with these
> ideas, we have to assume it is dangerous to block child registrations
> before the parent is fully suspended.

Still, I think we can fail them.

In fact, drivers _should_ check for device_add() failures and if they don't,
it's a plain bug.
 
> > that case, the only open window is when a new child of dev is registered right
> > after we've found dev at the end of dpm_active and right prior to taking
> > dev->power.lock.  However, we may avoid this race by (1) selecting dev
> > for suspending under dpm_list_mtx and (2) checking if it's still at the end of
> > dpm_active under dev->power.lock and dpm_list_mtx (the selection of a device
> > for suspending is repeated if this check fails).
> > 
> > The patch I sent previously implemented this idea, but it released
> > dev->power.lock after calling resume_device(dev), which is not really necessary
> > (dev->power.lock may be released as soon as dev is put back on dpm_active).
> > Below is another version of this patch that releases dev->power.lock earlier
> > and uses semaphores instead of mutexes.  [Note that it's trivial to rework it
> > so that the registrations of children considered as invalid will fail instead
> > of being blocked.]
> 
> > The appended patch may be reworked to release dev->power.lock for all devices
> > once they all have been suspended, but since nobody should ever try to register
> > a child below a suspended parent, that shouldn't be necessary.
> 
> That's not the issue.  The only problem I have with your approach is
> that it blocks child registrations before the parent is fully
> suspended.

Well, I think it's not correct to allow the parent to suspend with active (not
suspended) children.

> > > As for the ordering of the lock and moving the device to dpm_off -- 
> > > it's less of a problem if you don't acquire the lock until after the 
> > > suspend method returns.  You can lock it just before reacquiring 
> > > dpm_list_mtx, while the device is still on dpm_active.
> > 
> > The problem is that the new children should really be suspended _before_ the
> > parent.  One solution is to resume the parent in case we've detected new
> > children registered, the other one is not to suspend the parent at all in case
> > any new children appear, and that's what I'm attempting to achieve.
> 
> I believe it isn't achievable without modifying the drivers.  That was 
> the case with the MMC subsystem, for instance.

I agree.  What I was trying to say is that the core should protect itself, to
the maximum reasonable extent possible, from suspending a parent before the
children which may lead to some subtle problems.

> > > This is an interesting matter.  My view is that runtime PM should be
> > > almost completely disabled when the PM core calls the device's suspend
> > > method.  The only exception is that remote wakeup may be enabled.  If a
> > > remote wakeup event occurs and the device resumes, then its parent's
> > > suspend method will realize what has happened when it sees that the
> > > device is no longer suspended.  So the parent's suspend method will
> > > return -EBUSY and the sleep will be aborted.
> > 
> > I think that we may have to disable runtime PM as soon even earlier, just prior
> > to starting a transition to a sleep state.  There are systems which may crash
> > if we don't do that.
> 
> There must some strange interactions going on.  For instance, what if a
> device sends a remote wakeup request before the system is fully asleep?

On the systems I'm talking about there are some devices referred to by the
ACPI _PTS method, so they must be on line whey this method is being executed.
Since we don't know a priori what devices they are, we must put all devices on
line (into the full power state) before executing _PTS.

> > > Right now USB does not disable runtime PM during a system sleep.  It
> > > hasn't been necessary, thanks to the freezer.  But when we stop
> > > freezing user tasks it will become necessary.  When that time arrives I
> > > intend to put user threads doing runtime resume into the "icebox"  
> > > (remember that?).  Khubd and other kernel threads could go into the
> > > icebox also, instead of the freezer; in this way the freezer could be
> > > removed completely.
> > 
> > Yes.
> > 
> > In fact I'd like to work out some generic guidance for all device drivers
> > describing how to do such things.
> 
> When the USB design is complete it could be used as a model.  But I 
> have to admit that it is rather intricate.
> 
> > > That is indeed the difference, and it's an important difference.  The
> > > driver knows what other threads may be carrying out registrations, and
> > > it knows which ones should be waited for and which can safely be
> > > blocked or disabled.  The PM core doesn't know any of these things; all
> > > it can do is blindly block everything.  That is dangerous and can lead
> > > to deadlocks.
> > 
> > OTOH, the core should be allowed to protect it's data structures ...
> 
> Oh, I agree.  But this protection simply isn't possible without either 
> allowing devices to resume after the target sleep state has been set or 
> else modifying an unknown number of drivers.

Well, that's correct.  However, if we make the rule that device_add() may fail
if it's run concurrently with the parent's ->suspend(), the changes of the
drivers need not be substantial (they should check for the failures of
device_add() anyway).

[BTW, there is a bug in the error path of device_add() for which I'm going to
send a fix later today.  Namely, in case of a BusError, dpm_sysfs_remove()
is executed after device_pm_remove() which calls dpm_sysfs_remove().]

Below is the current version of the patch for handling device registrations
in the PM core.  In this version, the new registrations are failed if done too
late (or too early) and the locks are not held during the entire suspend/resume
cycle.

The patch is against the mainline with
http://marc.info/?l=linux-acpi&m=120389632114090&w=2
and your fix applied and has been (slightly) tested on x86-64.

Thanks,
Rafael

---
 drivers/base/core.c        |    7 ++-
 drivers/base/power/main.c  |   86 ++++++++++++++++++++++++++++-----------------
 drivers/base/power/power.h |   23 +-----------
 include/linux/pm.h         |    3 +
 4 files changed, 65 insertions(+), 54 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -24,6 +24,7 @@
 #ifdef __KERNEL__
 
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <asm/atomic.h>
 #include <asm/errno.h>
 
@@ -186,6 +187,8 @@ struct dev_pm_info {
 #ifdef	CONFIG_PM_SLEEP
 	unsigned		should_wakeup:1;
 	struct list_head	entry;
+	struct mutex		lock;
+	bool			sleeping;	/* Protected by 'lock' */
 #endif
 };
 
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -54,15 +54,13 @@ static LIST_HEAD(dpm_destroy);
 
 static DEFINE_MUTEX(dpm_list_mtx);
 
-static DECLARE_RWSEM(pm_sleep_rwsem);
-
 int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
 /**
- *	device_pm_add - add a device to the list of active devices
+ *	__device_pm_add - add a device to the list of active devices
  *	@dev:	Device to be added to the list
  */
-void device_pm_add(struct device *dev)
+static void __device_pm_add(struct device *dev)
 {
 	pr_debug("PM: Adding info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
@@ -73,6 +71,28 @@ void device_pm_add(struct device *dev)
 }
 
 /**
+ *	device_pm_add - check if given device can be safely added to the list of
+ *			active devices and use __device_pm_add() to do that
+ *	@dev:	Device to be added to the list
+ */
+int device_pm_add(struct device *dev)
+{
+	mutex_init(&dev->power.lock);
+	if (dev->parent) {
+		mutex_lock(&dev->parent->power.lock);
+		if (dev->parent->power.sleeping) {
+			mutex_unlock(&dev->parent->power.lock);
+			return -EBUSY;
+		}
+		__device_pm_add(dev);
+		mutex_unlock(&dev->parent->power.lock);
+	} else {
+		__device_pm_add(dev);
+	}
+	return 0;
+}
+
+/**
  *	device_pm_remove - remove a device from the list of active devices
  *	@dev:	Device to be removed from the list
  *
@@ -107,32 +127,6 @@ void device_pm_schedule_removal(struct d
 }
 EXPORT_SYMBOL_GPL(device_pm_schedule_removal);
 
-/**
- *	pm_sleep_lock - mutual exclusion for registration and suspend
- *
- *	Returns 0 if no suspend is underway and device registration
- *	may proceed, otherwise -EBUSY.
- */
-int pm_sleep_lock(void)
-{
-	if (down_read_trylock(&pm_sleep_rwsem))
-		return 0;
-
-	return -EBUSY;
-}
-
-/**
- *	pm_sleep_unlock - mutual exclusion for registration and suspend
- *
- *	This routine undoes the effect of device_pm_add_lock
- *	when a device's registration is complete.
- */
-void pm_sleep_unlock(void)
-{
-	up_read(&pm_sleep_rwsem);
-}
-
-
 /*------------------------- Resume routines -------------------------*/
 
 /**
@@ -248,7 +242,10 @@ static void dpm_resume(void)
 
 		list_move_tail(entry, &dpm_active);
 		mutex_unlock(&dpm_list_mtx);
+		mutex_lock(&dev->power.lock);
 		resume_device(dev);
+		dev->power.sleeping = false;
+		mutex_unlock(&dev->power.lock);
 		mutex_lock(&dpm_list_mtx);
 	}
 	mutex_unlock(&dpm_list_mtx);
@@ -285,7 +282,6 @@ void device_resume(void)
 	might_sleep();
 	dpm_resume();
 	unregister_dropped_devices();
-	up_write(&pm_sleep_rwsem);
 }
 EXPORT_SYMBOL_GPL(device_resume);
 
@@ -427,6 +423,30 @@ static int dpm_suspend(pm_message_t stat
 		struct device *dev = to_device(entry);
 
 		mutex_unlock(&dpm_list_mtx);
+		if (dev->parent) {
+			mutex_lock(&dev->parent->power.lock);
+			if (dev->parent->power.sleeping)
+				error = -EAGAIN;
+			mutex_unlock(&dev->parent->power.lock);
+			if (error)
+				break;
+		}
+		/*
+		 * We can't take dev->power.lock under dpm_list_mtx, because
+		 * we want to release dpm_list_mtx for the execution of
+		 * suspend_device() and recquire it afterwards, all with
+		 * dev->power.lock held.  However, since we've released
+		 * dpm_list_mtx above, dpm_active might have changed after
+		 * dev was initialized, so we must check if dev is still valid
+		 * after dpm_list_mtx have been reacquired.
+		 */
+		mutex_lock(&dev->power.lock);
+		mutex_lock(&dpm_list_mtx);
+		if (dev != to_device(dpm_active.prev)) {
+			mutex_unlock(&dev->power.lock);
+			continue;
+		}
+		mutex_unlock(&dpm_list_mtx);
 		error = suspend_device(dev, state);
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
@@ -437,10 +457,13 @@ static int dpm_suspend(pm_message_t stat
 					(error == -EAGAIN ?
 					" (please convert to suspend_late)" :
 					""));
+			mutex_unlock(&dev->power.lock);
 			break;
 		}
 		if (!list_empty(&dev->power.entry))
 			list_move(&dev->power.entry, &dpm_off);
+		dev->power.sleeping = true;
+		mutex_unlock(&dev->power.lock);
 	}
 	mutex_unlock(&dpm_list_mtx);
 
@@ -459,7 +482,6 @@ int device_suspend(pm_message_t state)
 	int error;
 
 	might_sleep();
-	down_write(&pm_sleep_rwsem);
 	error = dpm_suspend(state);
 	if (error)
 		device_resume();
Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h
+++ linux-2.6/drivers/base/power/power.h
@@ -11,30 +11,13 @@ static inline struct device *to_device(s
 	return container_of(entry, struct device, power.entry);
 }
 
-extern void device_pm_add(struct device *);
+extern int device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
-extern int pm_sleep_lock(void);
-extern void pm_sleep_unlock(void);
 
 #else /* CONFIG_PM_SLEEP */
 
-
-static inline void device_pm_add(struct device *dev)
-{
-}
-
-static inline void device_pm_remove(struct device *dev)
-{
-}
-
-static inline int pm_sleep_lock(void)
-{
-	return 0;
-}
-
-static inline void pm_sleep_unlock(void)
-{
-}
+static inline int device_pm_add(struct device *dev) { return 0; }
+static inline void device_pm_remove(struct device *dev) {}
 
 #endif
 
Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -814,7 +814,11 @@ int device_add(struct device *dev)
 	error = dpm_sysfs_add(dev);
 	if (error)
 		goto PMError;
-	device_pm_add(dev);
+	error = device_pm_add(dev);
+	if (error) {
+		dpm_sysfs_remove(dev);
+		goto PMError;
+	}
 	error = bus_add_device(dev);
 	if (error)
 		goto BusError;
@@ -839,7 +843,6 @@ int device_add(struct device *dev)
 	return error;
  BusError:
 	device_pm_remove(dev);
-	dpm_sysfs_remove(dev);
  PMError:
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
