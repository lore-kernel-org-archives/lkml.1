Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbXGHCx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbXGHCx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 22:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbXGHCxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 22:53:47 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4186 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754917AbXGHCxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 22:53:46 -0400
Date: Sat, 7 Jul 2007 22:53:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, <linux-kernel@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <1183855732.3388.240.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007, Benjamin Herrenschmidt wrote:

> > (And rather than trying to manage a waitqueue or struct completion, it
> > would be easiest to jump directly into the freezer!  The driver or the 
> > core wouldn't have to worry about waking up all these blocked threads.)
> 
> That's wrong. The freezer is NOT a solution for that sort of thing. Just
> because you guys can't get your locking right.

You misunderstood.  Stop trying to incite riot, calm down, and pay
attention to what I actually wrote.  I'll explain it again in more
explicit terms:

You agree that drivers need to block various activities during suspend.  
Principally I/O requests, but other things as well.  So when one of 
these requests arrives, the driver has to make it wait somehow and then 
has to allow it to proceed at the appropriate time.

Normally a waitqueue or a struct completion would be used for this
purpose.  But either one puts the burden on the driver of defining a
data structure and signalling it at the right time.  That time is
generally when the device is resumed, but there's nothing wrong with
delaying it slightly, to after all the devices have been resumed (i.e.,
the time when the current PM code takes everything out of the freezer).  
In fact, we definitely don't want to unblock plug events until this
later time.

So instead, why not have the PM core take care of all this?  There
could be a block_task_until_suspend_is_over() routine available for all
drivers to use.  Its effect would be exactly the same as sending the
current task into the freezer, but it wouldn't be the freezer that
exists now.  It would just be some routine that blocks until the system 
suspend is over.  We could call it "the icebox" instead of "the 
freezer".  :-)

Does that make you happier?


> > > Face it, we should seriously look into doing suspend/resume without a
> > > freezer.
> > 
> > I'm willing to try, although I think it will be a tremendous amount of 
> > work to verify that every driver does the right thing.  There's lots of 
> > support missing.  For example, don't you think we should block all 
> > sysfs I/O during suspend?  And likewise for insmod/rmmod?
> 
> sysfs is a matter of driver. If a sysfs read/write callback in a driver
> is hitting the HW, it most certainly already has some kind of locking.
> That locking can/should be extended to deal with blocking when the HW is
> suspended.

User tasks can cause driver binding by writing to sysfs.  Binding 
_can't_ be blocked in the driver; by then it's already too late.  If 
it is going to be blocked at all, it has to be blocked earlier.  One 
possibility is in the sysfs attribute code; another is to block all 
sysfs access.

Of course, another possibility is simply to fail the bind.  But that's 
not very satisfying, since suspends should be transparent.

> However, since it seems that people universally consider it very hard to
> get right (I don't but heh), Linus and Paul have come up with a solution
> for most simple enough directly-mapped drivers such as PCI (ok, that
> doesn't include USB) which is to simply do the HW suspend in a late
> callback after IRQs are off, and not bother with the rest.

Ben, you haven't given enough thought to the work needed to avoid 
locking problems.

For instance, you agree that during suspend we must not allow device or
driver registration or unregistration, right?  And we must not allow
driver binding or unbinding.  But these events generally involve
acquiring a device semaphore, in the driver core and quite often in the
core's caller.  Since that semaphore is also needed for calling the
suspend and resume methods, we have to be very careful about blocking
binding/unbinding/registration/unregistration.  It has to be done at a 
time when no device semaphores are held.

You also agree that kernel threads and workqueues must be allowed to 
operate during suspend.  But consider this: By writing the appropriate 
sysfs attribute, a user task can cause a workqueue item to be queued to 
keventd that tries to unregister a device.  That really puts you on the 
spot: Unregistration can't be allowed to fail, it can't be allowed to 
succeed during a suspend, and keventd can't be blocked!  So what should 
we do?

Alan Stern

