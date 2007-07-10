Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbXGJTbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbXGJTbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbXGJTb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:31:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57563 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751687AbXGJTb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:31:28 -0400
Date: Tue, 10 Jul 2007 15:31:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
In-Reply-To: <4693CB1B.8070301@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0707101459580.2556-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Tejun Heo wrote:

> >> How high performance device addition/removal should be?  Wouldn't rwlock
> >> be enough?
> > 
> > rwlock is a type of spinlock, right?  Hence it can't sleep and can't be
> > used for device addition/removal.  Also rwlocks aren't fair and are
> > subject to livelock.
> 
> rwsem of course.  Sorry about the confusion.  Fairness doesn't matter
> here.  The synchronization is suspend vs. addition with priority on
> suspend (suspend does down_write, removal does down_read_trylock).

Right.  I think device addition/removal is infrequent enough that 
either SRCU or and rwsem could be used, without any significant 
slowdown.

> I'm still not a big fan of locking (or downing) all device semaphores
> when the same effect can be achieved with a rwsem.  One thing I like
> about rwsem approach is that it can never cause a deadlock because one
> side uses trylock exclusively.

But an rwsem _doesn't_ obtain the same effect.  The major difference is
that holding all the device semaphores blocks binding of drivers, which
we need to prevent during suspend.  A minor difference is that it won't
prevent adding a new device, since you don't need to hold any existing
semaphores before calling device_add().

> If you lock all the device sems, failing addition becomes more difficult
> (can be done but then you need something like the rwsem anyway).

That was the idea: First acquire the rwsem write lock so that all
existing calls to device_add will have finished and new ones will fail,
and then acquire all the semaphores.

The purpose of holding all the semaphores is not to prevent device
addition.  More like the other way around: In order to be sure of
holding _all_ the semaphores, we have to prevent new devices from being
added.

> Without special handling of dev->sem, when a driver screws up (try to
> add a child device from ->suspend), it will deadlock while suspend is in
> progress, which isn't pretty.

No it won't.  If it calls device_add from within its suspend method,
the down_read_trylock will fail and the call will return immediately.  
With a WARN_ON to let people know which driver tried to do device_add
at an illegal time.

> Please also note that currently dev->sem does not protect against adding
> children.  It says it does in the comment on the definition of the field
> but it's never acquired during device_add().

That's why we need the rwsem.

> Yeah, I'm all for centralizing things.  I just didn't see what could be
> simplified in LLDs by freezing sysfs access.  Can you point me to any
> example node which can benefit from such thing?

For USB devices, writes to the /sys/.../bConfigurationValue node will
call usb_set_configuration(), which registers child devices.  We don't
want these calls to fail because a suspend is underway, since suspends 
are supposed to be transparent to userspace.  So they need to block 
until the suspend is over.

Access (either read or write) to any sysfs node which actually touches 
the device hardware will fail while the device is suspended.  Again, 
for transparency such accesses should block.

> > Using a freezable workqueue for the callbacks would also localize the 
> > suspend handling.
> 
> But the freezable workqueue thing isn't really necessary if any of the
> discussed solutions is implemented, right?

It isn't necessary if the callbacks aren't needed (i.e., if we give
methods a way to unregister their attribute directly).  But if we do
keep the callbacks, then for safety's sake their workqueue should be
freezable.

Alan Stern

