Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbYCCDyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbYCCDyW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 22:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbYCCDyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 22:54:13 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4028 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754969AbYCCDyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 22:54:12 -0500
Date: Sun, 2 Mar 2008 22:54:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer
 removal
In-Reply-To: <200803022011.50976.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803022152270.6168-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Mar 2008, Rafael J. Wysocki wrote:

> Would you agree, however, that the driver should be prepared for its
> ->resume() being called right after ->suspend() and the ->suspend() repeated
> immediately after that?  This is not a trivial change too ...

This is now a moot point, but I'll answer it anyway...

Drivers should not depend on any particular time interval between their 
suspend and resume methods being called.  It should be okay to call one 
and then the other a microsecond later, or 100 days later.  The driver 
shouldn't know or care.  I doubt that many drivers do.

> > I admit these failures will be very rare, since they depend on a race
> > with a small window.  Here's a compromise: I'll agree to let these
> > registrations fail if you'll agree to add "prevent_new_children" and
> > "allow_new_children" methods along with the new pm_ops patch you and
> > Alex have prepared.  Then drivers and subsystems can implement the
> > methods later on, after which they won't have to worry about spurious
> > registration failures.
> 
> I'm fine with that, although I'd call the new methods ->begin() and ->end() or
> something like this, since they may generally be used for other purposes
> too.

"begin_sleep" and "end_sleep" are less ambiguous.

I was just thinking the same thing.  For instance, plenty of drivers
register children as part of their probe method, so the begin_sleep
method should prevent subsystems from probing the device.  (Not to
mention that it's kind of awkward for a driver to probe a suspended
device.)

> > The prevent_new_children methods should be called in a separate initial
> > forward pass through the dpm_active list -- rather like the reverted
> > lock_all_devices() routine.  Similarly for the allow_new_children 
> > methods (a final backward pass like unlock_all_devices()).
> 
> Agreed.

After more thought, I'm not so sure about this.  It might be a good
idea to call the begin_sleep method just before the suspend method (or
any of its variants: freeze, hibernate, prethaw, etc.) and call the
end_sleep method just after the resume method.  This minimizes the time
drivers will spend in a peculiar non-hotplug-aware state, although it 
means that begin_sleep would have to be idempotent.

It also allows sophisticated drivers to do all their processing in the
begin_sleep (and end_sleep) method: both preventing new child
registrations and powering down the device.  At the moment I'm not sure
whether this would turn out to be a good strategy, but it might.

Alternatively, some subsystems might want to stop all child
registrations right at the beginning of the sleep transition.  This
would amount to blocking the kernel thread responsible for those
registrations when the sleep begins -- in other words, making that
thread freezable!

> > The PM notifier messages can serve as a "prevent new children" 
> > announcement to prevent registration of devices with no parent.

This isn't quite so simple either.  A notifier isn't good enough
because it doesn't provide any synchronization.  On the other hand, how
many devices ever get registered without a parent?  Does this happen at
all after system startup?  Maybe when a loadable module for a new bus
type initializes...  We could block module loading at the start of a
sleep transition, if necessary.

> > > > There must some strange interactions going on.  For instance, what if a
> > > > device sends a remote wakeup request before the system is fully asleep?
> > > 
> > > On the systems I'm talking about there are some devices referred to by the
> > > ACPI _PTS method, so they must be on line whey this method is being executed.
> > > Since we don't know a priori what devices they are, we must put all devices on
> > > line (into the full power state) before executing _PTS.
> 
> Well, "must" is too strong here ...
> 
> > Um.  Nobody has mentioned this before.  Are you saying that a disk 
> > drive (for example) which has been spun down and put in a low-power 
> > runtime-PM state must be spun up again before the system can suspend?
> 
> On the systems in question (some NVidia chipsets for K8) USB controllers have
> to be in the full power state before executing _PTS.

Fortunately that won't cause any problems for some time to come.  
There are no current plans for doing runtime PM of PCI-based USB
controllers.  This may change eventually, but not for a while.

> IMO these systems are just badly designed and we can blacklist or something
>  like this.  It also is against the ACPI 2.0 spec, although it's compliant
> with ACPI 1.0 .

Or have a "no runtime PM" quirk for the devices in question.

> > > Below is the current version of the patch for handling device registrations
> > > in the PM core.  In this version, the new registrations are failed if done too
> > > late (or too early) and the locks are not held during the entire suspend/resume
> > > cycle.
> > 
> > Actually you can simplify the whole thing by getting rid of 
> > dev->power.lock entirely.  Protect the "sleeping" flag by dpm_list_mtx.
> 
> Then, if a child registration occurs while suspend_device(parent) is being
> run, dpm_active will be in a wrong order, unless suspend_device(parent) returns
> an error (which, BTW, also imposes a new rule on drivers).

Sorry, I don't follow you.

I meant doing something approximately like this:

	mutex_lock(&dpm_list_mtx);
	while (!list_is_empty(&dpm_active)) {
		dev = dpm_active.prev;
		dev->power.sleeping = true;
		mutex_unlock(&dpm_list_mtx);
		error = suspend_device(dev);
		mutex_lock(&dpm_list_mtx);
		...
	}

and make device_pm_add() fail if dev->parent->power.sleeping is true.
This will do what you want, right?

With the begin_sleep method call added it gets a little more
complicated, since you have to reacquire dpm_list_mtx after calling the
begin_sleep method and before setting dev->power.sleeping to true, in
order to make sure that dev is still the last entry on dpm_active.  
But it's quite doable.

(BTW, I wonder if it's a good idea for device_add() to call 
device_pm_add() before calling bus_add_device().  If a suspend occurs 
in between, we could end up in a strange situation with a driver being 
asked to suspend a device before that device has been fully registered 
-- in fact the registration might still fail.)

> I'm not sure the "GONE" state willl really be necessary.

I'm not sure either.  You can get the same effect by checking 
list_empty(&dev->power.entry).

> Well, we can add new callbacks for notifying drivers of an impending suspend.
> In that case, say we add a ->begin() callback for this purpose (in fact that
> would be two callbacks, ->suspend_begin() and ->hibernate_begin(), but let's
> simplify things a bit for now), so there are the following questions:

In theory you could even expand it to freeze_begin and prethaw_begin.

> * Is it going to return a result?
> * If it is, should we fail the suspend if an error is returned?
> * In that case, should the ->suspend() callback return a result?

To be safe, everything should return a result and we should abort the 
sleep if anything returns an error.

It's easier to ignore a return code now than to change a method
signature later.  :-)

> * Perhaps we can require ->suspend() to always succeed after ->begin() has
>   succeeded?

No.  Some drivers might implement just one and some drivers just the 
other.

> OTOH, IMO requiring ->suspend() to return an error if there's been a concurrent
> child registration and resuming the device if that happens is not a trivial
> change and it may require as many driver modifications as failing the
> registration of the child right away.

That's true.  If the driver's author wants to do things that way, he
can.  For instance, there are several subsystems which will probe for
new children as part of their resume processing.  So if a child was
detected just before the system went to sleep and failed to get
registered, then it will be detected again when the system wakes up and
now the registration will succeed.

Here's something else to think about.  We might want to allow some 
devices to be "power-irrelevant".  That is, the device exists in the 
kernel only as a representation of some software state, not as a 
physical device.  It doesn't consume power, it doesn't have any state 
to lose during a sleep, and its driver doesn't implement suspend or 
resume methods.  For these sorts of devices, we might allow 
device_add() to skip calling device_pm_add() altogether.  USB 
interfaces are a little like this, as are SCSI hosts and MMC hosts.

Alan Stern

