Return-Path: <linux-kernel-owner+w=401wt.eu-S1758998AbXGCOuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998AbXGCOuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbXGCOub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:50:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43213 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754196AbXGCOub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:50:31 -0400
Date: Tue, 3 Jul 2007 10:50:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Johannes Berg <johannes@sipsolutions.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <1183472474.3722.13.camel@johannes.berg>
Message-ID: <Pine.LNX.4.44L0.0707031026260.3720-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007, Johannes Berg wrote:

> On Tue, 2007-07-03 at 14:56 +0200, Rafael J. Wysocki wrote:
> 
> > Still, can you please read this post from Alan Stern:
> > 
> > https://lists.linux-foundation.org/pipermail/linux-pm/2007-June/012847.html
> > 
> > ?  I don't think I'm able to repeat the arguments given in there in a
> > convincing way.
> 
> As I read it, Alan basically has two objections:
>  (1) drivers shouldn't need to worry about this
>  (2) suspend should be transparent to userspace
> 
> His proposed solution (freezing tasks when they cross the kernel
> boundary) helps for the s-t-r case, but in fact doesn't solve (1)
> because devices can be suspended at runtime and then you certainly do
> not want to freeze tasks that try to access the device.
> 
> (2) is related but not identical, what if you have a device suspended at
> runtime and some tasks tries to access it; should the task block until
> you wake up that device?

Time for me to jump in.

USB already implements runtime PM.  If a device is suspended at runtime
and a task tries to access it, the device is automatically resumed.  
No problem there.

The problem comes when the system is doing a STR.  Right now the code
doesn't keep track of the difference between a runtime suspend and a
system suspend -- once the device is suspended, it's suspended, period.  
Consequently, a non-frozen user task trying to do I/O to a suspended
device during STR will cause that device to resume, thereby forcing the
system suspend to abort.  Something much like this has actually
happened and been reported as a bug on LKML (I don't have a URL handy,
and it was actually a non-frozen kernel thread interfering with
hibernate rather than a non-frozen user task interfering with STR, but
the principle is the same).

Yes, the code could be changed to keep track of the reason for a device
suspend.  But that just raises the old problem of what to do when
there's an I/O request for a suspended device during STR.

> I think the core of the discussion isn't appreciated by everybody here
> yet---we need to solve both run-time and suspend-to-ram-time device
> suspend, not just one of them.

Runtime suspend isn't a problem.  Only STR.

Consider a particularly troublesome case: During STR, a non-frozen task
writes to /sys/bus/BBB/drivers/DDD/bind.  The sysfs core grabs the
device semaphore and calls the driver's probe routine.  If the driver
isn't PM-aware it simply tries to initialize the device and fails
because the device is already suspended.  That's no good; it isn't
transparent.

So assume the driver is PM-aware.  It tries to resume the device, which
fails because STR is underway.  Now what can it do?  There's only one 
possibility: It must block until the resume call can succeed.  But when 
is that?

It has to be before the PM core tries to resume the device, because the 
core will try to acquire the device semaphore and will block waiting 
for the probe call to complete.  But it has to be after the PM core 
resumes the device's parent, because obviously the device can't resume 
until its parent is awake.

As you can see, this is a very difficult problem to solve.

Alan Stern

