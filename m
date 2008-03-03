Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbYCCRoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbYCCRoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYCCRn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:43:29 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:50002 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755651AbYCCRnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:43:22 -0500
Date: Mon, 3 Mar 2008 12:43:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer
 removal
In-Reply-To: <200803031732.52823.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803031217070.3611-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Rafael J. Wysocki wrote:

> > After more thought, I'm not so sure about this.  It might be a good
> > idea to call the begin_sleep method just before the suspend method (or
> > any of its variants: freeze, hibernate, prethaw, etc.) and call the
> > end_sleep method just after the resume method.  This minimizes the time
> > drivers will spend in a peculiar non-hotplug-aware state, although it 
> > means that begin_sleep would have to be idempotent.
> > 
> > It also allows sophisticated drivers to do all their processing in the
> > begin_sleep (and end_sleep) method: both preventing new child
> > registrations and powering down the device.  At the moment I'm not sure
> > whether this would turn out to be a good strategy, but it might.
> 
> Well, I think there should be a window between ->suspend_begin()
> and ->suspend() allowing the core to cancel the suspending of given
> device and to select another one.  For example, if there's a child
> registration concurrent wrt ->suspend_begin() which completes after
> ->suspend_begin() has been called, but before ->suspend_begin() has a chance
> to block it, the core should not call ->suspend() for the device, but select
> another one (the child).

With a sophisticated driver that would never happen, because after
blocking new child registrations, the driver would check that the
power.sleeping flag is set in all the children before powering down the 
device.  But like I said, I'm not sure if this would be a good 
strategy.

(This partly has to do with the requirements for runtime PM.  During a
runtime suspend the driver does have to check the children's status; it
can't rely on the PM core.  So if the check has to be done anyway, why
not also check during a system sleep?)

With non-sophisticated drivers, it definitely could happen that a new
child is registered concurrently with begin_sleep.  Then the core would
go back and suspend the child first, as you say.  Eventually the core
would return to the parent device, at which time it would call the
parent's begin_sleep method again -- unless we add another flag to
indicate that it had already been called.

> Of course, it won't be necessary if the ->suspend_begin() methods are called
> in an initial forward pass through dpm_active.

Right.  That would be simpler.

> > (BTW, I wonder if it's a good idea for device_add() to call 
> > device_pm_add() before calling bus_add_device().  If a suspend occurs 
> > in between, we could end up in a strange situation with a driver being 
> > asked to suspend a device before that device has been fully registered 
> > -- in fact the registration might still fail.)
> 
> That's correct.  Perhaps we should change device_add().

I had a change like that in my version of the patch.  It's excerpted 
below.

> > > Well, we can add new callbacks for notifying drivers of an impending suspend.
> > > In that case, say we add a ->begin() callback for this purpose (in fact that
> > > would be two callbacks, ->suspend_begin() and ->hibernate_begin(), but let's
> > > simplify things a bit for now), so there are the following questions:
> > 
> > In theory you could even expand it to freeze_begin and prethaw_begin.
> 
> I meant ->hibernate_begin() as ->freeze_begin() and I don't see any reason why
> ->prethaw_begin() would be different from it (the difference between ->freeze()
> and ->prethaw() -- now called ->quiesce(), btw -- is that the former saves
> device settings and the latter doesn't).

AFAICS there needs to be only one begin_sleep method.  It should apply 
equally well to suspend, freeze, quiesce, and hibernate.  (But not to 
suspend_late.)

> > > * Perhaps we can require ->suspend() to always succeed after ->begin() has
> > >   succeeded?
> > 
> > No.  Some drivers might implement just one and some drivers just the 
> > other.
> 
> I thought ->suspend() would be mandatory, even if it's to be empty.

There's no need for that.  If it isn't implemented, treat it as though 
it was successful.

But if a driver implements suspend() and leaves begin_sleep() as just a 
stub (which many drivers might reasonably do, if they never register 
any children), then the core shouldn't require suspend() to succeed 
merely because begin_sleep() did.

And especially not if begin_sleep() is called in a separate pass.

> > Here's something else to think about.  We might want to allow some 
> > devices to be "power-irrelevant".  That is, the device exists in the 
> > kernel only as a representation of some software state, not as a 
> > physical device.  It doesn't consume power, it doesn't have any state 
> > to lose during a sleep, and its driver doesn't implement suspend or 
> > resume methods.  For these sorts of devices, we might allow 
> > device_add() to skip calling device_pm_add() altogether.  USB 
> > interfaces are a little like this, as are SCSI hosts and MMC hosts.
> 
> If such devices serve as logical parents of some "real" ones, we should
> at least mark them as "sleeping" during suspend to protect the dpm_active
> ordering.

They wouldn't have to be marked at all.  They would never get on any of 
the PM lists, because they would never be passed to device_pm_add().

The status of such devices is a little peculiar.  For example, consider 
the MMC subsystem.  There's an MMC controller, generally a platform 
device.  Its child is an mmc_host device, but the mmc_host methods are 
called by the platform device's methods -- there is no driver 
associated with an mmc_host.  At one time the mmc_host was a 
class_device; that's may explain in part why it works this way.

Alan Stern


Index: usb-2.6/drivers/base/core.c
===================================================================
--- usb-2.6.orig/drivers/base/core.c
+++ usb-2.6/drivers/base/core.c
@@ -815,10 +815,12 @@ int device_add(struct device *dev)
 	error = dpm_sysfs_add(dev);
 	if (error)
 		goto PMError;
-	device_pm_add(dev);
 	error = bus_add_device(dev);
 	if (error)
 		goto BusError;
+	error = device_pm_add(dev);
+	if (error)
+		goto PMAddError;
 	kobject_uevent(&dev->kobj, KOBJ_ADD);
 	bus_attach_device(dev);
 	if (parent)
@@ -838,8 +840,9 @@ int device_add(struct device *dev)
  Done:
 	put_device(dev);
 	return error;
+ PMAddError:
+	bus_remove_device(dev);
  BusError:
-	device_pm_remove(dev);
 	dpm_sysfs_remove(dev);
  PMError:
 	if (dev->bus)

