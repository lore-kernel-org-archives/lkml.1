Return-Path: <linux-kernel-owner+w=401wt.eu-S1761305AbYBYXiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761305AbYBYXiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759821AbYBYXhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:37:55 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1134 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759022AbYBYXhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:37:54 -0500
Date: Mon, 25 Feb 2008 18:37:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer
 removal
In-Reply-To: <200802252325.09439.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802251829170.4620-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Rafael J. Wysocki wrote:

> > But when a system sleep begins, the PM core is expected to suspend
> > all the children of a device before calling the device driver's suspend
> > method.  If there are other threads trying to add new children at the
> > same time, it's the PM core's responsibility to synchronize with
> > them -- an impossible job, since only the device's driver knows what
> > those other threads are and how to stop them safely.
> 
> It's not a problem if new children are registered before the parent's
> ->suspend() is called, the PM core can handle that.  The problem is the
> potential race between the suspending task and the threads registering new
> children concurrently to the executing ->suspend(), because if those threads
> lose the race, the resume ordering will be broken.

Not only that, the new children will exist temporarily in a state where 
their parent is suspended and they are not.  Clearly we cannot allow 
children to be registered below suspended parents.

> Since the PM core knows nothing about the drivers internals, the drivers'
> ->suspend() methods must be responsible for synchronizing with the other
> threads used by the driver.

This is a new requirement.  We didn't have to worry about it with the 
freezer.  Driver maintainers need to know about it.

> I think we just attempted to take device semaphores too early.  We probably
> can take the device semaphores _after_ suspending all devices without
> much hassle.

At that stage there isn't any real need to hold the semaphores.  And it 
complicates unregistration, which should always be allowed.  At the 
moment I don't see any benefit to locking all the semaphores.

>  However, it's not actually a problem if a suspended device
> gets unregistered - it's removed from the list on which it is at the moment
> and won't be resumed.  It also is not a problem if the device is registered
> after it's master's ->resume() has run.

Correct.

> Besides, taking the semaphores for all _existing_ devices doesn't prevent
> new devices from being added and that's we needed to take
> pm_sleep_rwsem in device_add().

Yes.  We could keep it, but not acquire it until after all devices have 
been suspended.  This might catch some errors.

> IMO the device driver should assure that no new children will be registered
> concurrently with the ->suspend() method (IOW, ->suspend() should wait for
> all such registrations to complete and should prevent any new ones from
> being started) and it should make it impossible to register any new children
> after ->suspend() has run.  It's the driver's problem how to achieve that.

Exactly; this has to be added to the PM documentation.

The difficulty arises only for drivers that support hotplugging, that 
is, detecting and registering children from somewhere other than their 
probe method.

> > The PM core could help detect errors here.  If it tries to suspend a 
> > device and sees that the device's parent is already suspended, then the 
> > parent's driver has a bug.
> 
> Yes, I think we ought to fail the suspend in such cases.  Still, that's not
> sufficient to prevent a child from being registered after we've run
> dpm_suspend().  For this reason, we could also leave dpm_suspend() with
> dpm_list_mtx held and not release it until the next dpm_resume() is run.

The pm_sleep_rwsem will do a better job of catching such errors.

> That will potentially cause some trouble to CPU hotplug cotifiers, but we can
> handle that, for example, by using the in_suspend_context() test.

Do they need to register new CPUs at some point?  There ought to be a 
way to handle that.

Alan Stern

