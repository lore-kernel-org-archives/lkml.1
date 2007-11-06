Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbXKFQdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbXKFQdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 11:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbXKFQdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 11:33:02 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34461 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751729AbXKFQdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 11:33:00 -0500
Date: Tue, 6 Nov 2007 11:32:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Greg KH <greg@kroah.com>, Oliver Neukum <oneukum@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, apw <apw@shadowen.org>,
       Ingo Molnar <mingo@elte.hu>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: device struct bloat
In-Reply-To: <1194364684.6289.40.camel@twins>
Message-ID: <Pine.LNX.4.44L0.0711061114010.3883-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007, Peter Zijlstra wrote:

> On Tue, 2007-11-06 at 10:36 -0500, Alan Stern wrote:
> 
> > I gather the idea is to convert dev->sem to a mutex.  This idea had 
> > occurred to me a long time ago but I didn't pursue it because of the 
> > sheer number of places where dev->sem gets used
> 
> That should never stop us from doing the right thing :-), also dev->sem
> isn't used nearly as much as for example work_struct which was changed.

My hat is off to David Howells.  He's willing to carry out far-ranging 
changes well beyond the point I can stomach.

> > You can't possibly solve the lockdep problems here with a simple-minded
> > approach like your DRIVER_NORMAL, DRIVER_PARENT, etc.  The device tree
> > is arbitrarily deep & wide, and there is at least one routine that
> > acquires the semaphores for _all_ the devices in the tree. 
> 
> *blink* someone needs to take all locks - why?

It's for system suspend.  All the devices are locked to prevent driver 
binding and unbinding during the suspend transition.

Even apart from that, there are places where the USB core needs to
acquire multiple layers of locks (more than just two).  For example, if
somebody has hubs nested several deep and then unplugs the hub closest
to the computer, this will happen.

Shucks, any time a driver's probe routine tries to register a child 
device you will run into problems.  probe() is always called with the 
device locked, and registration of a child will acquire the child's 
lock in order to probe drivers for the child.

> >  This fact
> > alone seems to preclude using lockdep for device locks.  (If there was 
> > a form of mutex_lock() that bypassed the lockdep checks, you could use 
> > it and avoid these issues.)
> 
> I'm sceptical of this, since its a simple tree (as opposed to a balanced
> tree) a simple lock-coupling approach should be enough to guarantee
> consistency.

I don't follow your reasoning.  Let's say a task wants to lock all the
direct children of a particular device.  In what order should the locks
be acquired?  There's no natural tree-related ordering to follow.

In the simple case where locks are acquired along a path in the tree,
you could solve the lockdep issues by passing mutex_lock_nested() a key
equal to the device's depth in the tree.  But that won't work with more
complicated cases.

> > Deadlock is a serious consideration.  For the most part, routines 
> > locking devices do so along a single path in the tree.  For this simple 
> > case the rule is: Never acquire a parent's lock while holding the 
> > child's lock.
> 
> Sure, but once you have a parent's lock, you could unlock your
> grandparent, no? (it having a locked child, your parent, should be
> enough to guarantee its continued existence)

Of course.  So what?  In many cases the code needs to keep all three
locks.  The locks don't merely guarantee the device structs' continued
existence (a kref could do that) -- they serialize a number of related
operations.

> > The routine that locks all the devices acquires the locks in order of 
> > device registration.  The idea here is that children are always 
> > registered _after_ their parents, so this should be compatible with the 
> > previous rule.  But there is a potential problem: device_move() can 
> > move an older child under a younger parent!
> 
> Seems like a weird rule, a typical tree locking rule would be to lock
> them top-down - such a rule can easily cope with moves: lock old parent,
> lock child, lock new parent, move child, unlock all in reverse order.

Yep.  But this isn't a typical tree-locking.  System suspend sometimes
requires that devices be powered down in a specific order, and there
are constraints not captured by the positions in the tree.  We get
around this by powering devices down in reverse order of detection,
which should always be safe.  Although the locking need not necessarily
follow these same constraints, it is certainly the easiest approach.

(And by the way, your example rule "lock old parent, lock child, lock
new parent" is subject to deadlocks.  What if another task tries to
move a different device from under the new parent to the old parent at
the same time?)

> Like said, I think the tree locking model should be revisited. A
> top-down locking model with lock-coupling should, from my ignorant
> perspective, solve your problems.

I don't understand what you mean by "lock-coupling".

Alan Stern

