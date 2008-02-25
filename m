Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbYBYPkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbYBYPkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 10:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbYBYPjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 10:39:51 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44127 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751943AbYBYPjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 10:39:51 -0500
Date: Mon, 25 Feb 2008 10:39:49 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Fundamental flaw in system suspend, exposed by freezer removal
Message-ID: <Pine.LNX.4.44L0.0802251010330.2133-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ongoing efforts to remove the freezer from the system suspend and
hibernation code ("system sleep" is the proper catch-all term) have
turned up a fundamental flaw in the Power Management subsystem's
design.  In brief, we cannot handle the race between hotplug addition
of new devices and suspending all existing devices.

It's not a simple problem (and I'm going to leave out a lot of details
here).  For a comparison, think about what happens when a device is
hot-unplugged.  When device_del() calls the driver's remove method, the
driver is expected to manage all the details of synchronizing with
other threads that may be trying to add new child devices as well as
removing all existing children.

But when a system sleep begins, the PM core is expected to suspend
all the children of a device before calling the device driver's suspend
method.  If there are other threads trying to add new children at the
same time, it's the PM core's responsibility to synchronize with
them -- an impossible job, since only the device's driver knows what
those other threads are and how to stop them safely.

In the past this deficiency has been hidden by the freezer.  Other 
tasks couldn't register new children because they were frozen.  But now 
we are phasing out the freezer (already most kernel threads are not 
freezable) and the problem is starting to show up.

A change to the PM core present in 2.6.25-rc2 (but which is about to be
reverted!) has the core try to prevent these additions by acquiring the
device semaphores for every registered device.  This has turned out to
be too heavy-handed; for example, it prevents drivers from
unregistering devices during a system sleep.  There are more subtle
synchronization problems as well.

The only possible solution is to have the drivers themselves be
responsible for preventing calls to device_add() or device_register()  
during a system sleep.  (It's also necessary to prevent driver binding,
but this isn't a major issue.)  The most straightforward approach is to
add a new pair of driver methods: one to disable adding children and
one to re-enable it.  Of course this would represent a significant
addition to the Power Management driver interface.

(Note that the existing suspend and resume methods cannot be used for 
this purpose.  Drivers assume that when the suspend method is called, 
it has already been called for all the child devices.  This wouldn't be 
true if one of the purposes of the method was to prevent addition of 
new children.)

Another way of accomplishing this is to require drivers to pay
attention to pm_notifier chain and stop registering children when any
of the PM_xxx_PREPARE messages is sent.  This approach feels a lot more
awkward to me.

Comments and discussion?

Alan Stern

