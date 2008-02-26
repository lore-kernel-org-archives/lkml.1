Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbYBZAJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbYBZAJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbYBZAJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:09:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33121 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbYBZAJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:09:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer removal
Date: Tue, 26 Feb 2008 01:07:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802251829170.4620-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802251829170.4620-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802260107.51385.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 26 of February 2008, Alan Stern wrote:
> On Mon, 25 Feb 2008, Rafael J. Wysocki wrote:
> 
> > > But when a system sleep begins, the PM core is expected to suspend
> > > all the children of a device before calling the device driver's suspend
> > > method.  If there are other threads trying to add new children at the
> > > same time, it's the PM core's responsibility to synchronize with
> > > them -- an impossible job, since only the device's driver knows what
> > > those other threads are and how to stop them safely.
> > 
> > It's not a problem if new children are registered before the parent's
> > ->suspend() is called, the PM core can handle that.  The problem is the
> > potential race between the suspending task and the threads registering new
> > children concurrently to the executing ->suspend(), because if those threads
> > lose the race, the resume ordering will be broken.
> 
> Not only that, the new children will exist temporarily in a state where 
> their parent is suspended and they are not.  Clearly we cannot allow 
> children to be registered below suspended parents.
> 
> > Since the PM core knows nothing about the drivers internals, the drivers'
> > ->suspend() methods must be responsible for synchronizing with the other
> > threads used by the driver.
> 
> This is a new requirement.  We didn't have to worry about it with the 
> freezer.  Driver maintainers need to know about it.

Certainly.  That's why I've been saying that it's not really a simple task to
get rid of the freezer. ;-)

> > I think we just attempted to take device semaphores too early.  We probably
> > can take the device semaphores _after_ suspending all devices without
> > much hassle.
> 
> At that stage there isn't any real need to hold the semaphores.  And it 
> complicates unregistration, which should always be allowed.  At the 
> moment I don't see any benefit to locking all the semaphores.

Agreed.

> >  However, it's not actually a problem if a suspended device
> > gets unregistered - it's removed from the list on which it is at the moment
> > and won't be resumed.  It also is not a problem if the device is registered
> > after it's master's ->resume() has run.
> 
> Correct.
> 
> > Besides, taking the semaphores for all _existing_ devices doesn't prevent
> > new devices from being added and that's we needed to take
> > pm_sleep_rwsem in device_add().
> 
> Yes.  We could keep it, but not acquire it until after all devices have 
> been suspended.  This might catch some errors.

Agreed.

> > IMO the device driver should assure that no new children will be registered
> > concurrently with the ->suspend() method (IOW, ->suspend() should wait for
> > all such registrations to complete and should prevent any new ones from
> > being started) and it should make it impossible to register any new children
> > after ->suspend() has run.  It's the driver's problem how to achieve that.
> 
> Exactly; this has to be added to the PM documentation.

Into Documentation/power/devices.txt, I gather?

> The difficulty arises only for drivers that support hotplugging, that 
> is, detecting and registering children from somewhere other than their 
> probe method.

Yes.

> > > The PM core could help detect errors here.  If it tries to suspend a 
> > > device and sees that the device's parent is already suspended, then the 
> > > parent's driver has a bug.
> > 
> > Yes, I think we ought to fail the suspend in such cases.  Still, that's not
> > sufficient to prevent a child from being registered after we've run
> > dpm_suspend().  For this reason, we could also leave dpm_suspend() with
> > dpm_list_mtx held and not release it until the next dpm_resume() is run.
> 
> The pm_sleep_rwsem will do a better job of catching such errors.

But we should not leave a window between releasing dpm_list_mtx and taking
pm_sleep_rwsem.  Either that, or we should make sure that dpm_active is
empty after acquiring pm_sleep_rwsem.
 
> > That will potentially cause some trouble to CPU hotplug cotifiers, but we can
> > handle that, for example, by using the in_suspend_context() test.
> 
> Do they need to register new CPUs at some point?  There ought to be a 
> way to handle that.

No, they don't, but there are some CPU-related device objects that get
uregistered/registered.  Still, all of this work is really redundant if the CPU
in question comes back up during the resume, so it should be avoided in
general.  The CPU hotplug notifiers should only unregister those objects if
the CPU hasn't gone on line during the resume and they have all information
necessary for discovering that.

Thanks,
Rafael
