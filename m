Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbYBYW0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbYBYW0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbYBYW00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:26:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60817 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834AbYBYW0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:26:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Fundamental flaw in system suspend, exposed by freezer removal
Date: Mon, 25 Feb 2008 23:24:57 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802251010330.2133-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802251010330.2133-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802252324.58301.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 25 of February 2008, Alan Stern wrote:
> Ongoing efforts to remove the freezer from the system suspend and
> hibernation code ("system sleep" is the proper catch-all term) have
> turned up a fundamental flaw in the Power Management subsystem's
> design.  In brief, we cannot handle the race between hotplug addition
> of new devices and suspending all existing devices.
> 
> It's not a simple problem (and I'm going to leave out a lot of details
> here).  For a comparison, think about what happens when a device is
> hot-unplugged.  When device_del() calls the driver's remove method, the
> driver is expected to manage all the details of synchronizing with
> other threads that may be trying to add new child devices as well as
> removing all existing children.
> 
> But when a system sleep begins, the PM core is expected to suspend
> all the children of a device before calling the device driver's suspend
> method.  If there are other threads trying to add new children at the
> same time, it's the PM core's responsibility to synchronize with
> them -- an impossible job, since only the device's driver knows what
> those other threads are and how to stop them safely.

It's not a problem if new children are registered before the parent's
->suspend() is called, the PM core can handle that.  The problem is the
potential race between the suspending task and the threads registering new
children concurrently to the executing ->suspend(), because if those threads
lose the race, the resume ordering will be broken.

Since the PM core knows nothing about the drivers internals, the drivers'
->suspend() methods must be responsible for synchronizing with the other
threads used by the driver.

> In the past this deficiency has been hidden by the freezer.  Other 
> tasks couldn't register new children because they were frozen.  But now 
> we are phasing out the freezer (already most kernel threads are not 
> freezable) and the problem is starting to show up.
> 
> A change to the PM core present in 2.6.25-rc2 (but which is about to be
> reverted!) has the core try to prevent these additions by acquiring the
> device semaphores for every registered device.  This has turned out to
> be too heavy-handed; for example, it prevents drivers from
> unregistering devices during a system sleep.  There are more subtle
> synchronization problems as well.

I think we just attempted to take device semaphores too early.  We probably
can take the device semaphores _after_ suspending all devices without
much hassle.  However, it's not actually a problem if a suspended device
gets unregistered - it's removed from the list on which it is at the moment
and won't be resumed.  It also is not a problem if the device is registered
after it's master's ->resume() has run.

Besides, taking the semaphores for all _existing_ devices doesn't prevent
new devices from being added and that's we needed to take
pm_sleep_rwsem in device_add().

> The only possible solution is to have the drivers themselves be
> responsible for preventing calls to device_add() or device_register()  
> during a system sleep.  (It's also necessary to prevent driver binding,
> but this isn't a major issue.)  The most straightforward approach is to
> add a new pair of driver methods: one to disable adding children and
> one to re-enable it.  Of course this would represent a significant
> addition to the Power Management driver interface.

I'd rather not do that.

> (Note that the existing suspend and resume methods cannot be used for 
> this purpose.  Drivers assume that when the suspend method is called, 
> it has already been called for all the child devices.  This wouldn't be 
> true if one of the purposes of the method was to prevent addition of 
> new children.)
> 
> Another way of accomplishing this is to require drivers to pay
> attention to pm_notifier chain and stop registering children when any
> of the PM_xxx_PREPARE messages is sent.  This approach feels a lot more
> awkward to me.

As I said above, I don't see a problem with registering new devices before
the parent's ->suspend() is run and after it's ->resume() has run.  That
doesn't break any ordering rules and we can handle it.

Thanks,
Rafael
