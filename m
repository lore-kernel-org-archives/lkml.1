Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbXKFRTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbXKFRTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 12:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbXKFRTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 12:19:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50755 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbXKFRTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 12:19:34 -0500
Subject: Re: device struct bloat
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Oliver Neukum <oneukum@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, apw <apw@shadowen.org>,
       Ingo Molnar <mingo@elte.hu>, linux-usb-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.44L0.0711061114010.3883-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0711061114010.3883-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Tue, 06 Nov 2007 18:19:26 +0100
Message-Id: <1194369566.6289.59.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-06 at 11:32 -0500, Alan Stern wrote:
> On Tue, 6 Nov 2007, Peter Zijlstra wrote:
> > On Tue, 2007-11-06 at 10:36 -0500, Alan Stern wrote:

> > > You can't possibly solve the lockdep problems here with a simple-minded
> > > approach like your DRIVER_NORMAL, DRIVER_PARENT, etc.  The device tree
> > > is arbitrarily deep & wide, and there is at least one routine that
> > > acquires the semaphores for _all_ the devices in the tree. 
> > 
> > *blink* someone needs to take all locks - why?
> 
> It's for system suspend.  All the devices are locked to prevent driver 
> binding and unbinding during the suspend transition.

Just locking the tree root is not enough? (thereby avoiding all any new
modifying operation to descend into the tree).

> Even apart from that, there are places where the USB core needs to
> acquire multiple layers of locks (more than just two).  For example, if
> somebody has hubs nested several deep and then unplugs the hub closest
> to the computer, this will happen.

Pin the sub-tree root with a reference, iterate the sub-tree and delete
the leafs one by one?

> Shucks, any time a driver's probe routine tries to register a child 
> device you will run into problems.  probe() is always called with the 
> device locked, and registration of a child will acquire the child's 
> lock in order to probe drivers for the child.

Right, so you say you have unbounded stack recursion? How about pushing
each probe into a stack (workqueue perhaps). Then each stack entry would
only do a single level probe, if it would recurse push a new entry on
the stack. Basic recursive -> stack transform.

> > >  This fact
> > > alone seems to preclude using lockdep for device locks.  (If there was 
> > > a form of mutex_lock() that bypassed the lockdep checks, you could use 
> > > it and avoid these issues.)
> > 
> > I'm sceptical of this, since its a simple tree (as opposed to a balanced
> > tree) a simple lock-coupling approach should be enough to guarantee
> > consistency.
> 
> I don't follow your reasoning.  Let's say a task wants to lock all the
> direct children of a particular device.  In what order should the locks
> be acquired?  

I'd first start by asking if you want to lock all the children or the
sub-tree. The latter can be done by locking the root of said sub-tree.

> There's no natural tree-related ordering to follow.

Of course there is a natural deadlock free locking order in a tree: lock
the parent, lock all its children, repeat by noting that each child is a
parent again. If you only ever lock top down, there should not be any
lateral dependencies.

> In the simple case where locks are acquired along a path in the tree,
> you could solve the lockdep issues by passing mutex_lock_nested() a key
> equal to the device's depth in the tree.  But that won't work with more
> complicated cases.

And only up to 8, as that's the max nesting depth.

> > > Deadlock is a serious consideration.  For the most part, routines 
> > > locking devices do so along a single path in the tree.  For this simple 
> > > case the rule is: Never acquire a parent's lock while holding the 
> > > child's lock.
> > 
> > Sure, but once you have a parent's lock, you could unlock your
> > grandparent, no? (it having a locked child, your parent, should be
> > enough to guarantee its continued existence)
> 
> Of course.  So what?  In many cases the code needs to keep all three
> locks.  The locks don't merely guarantee the device structs' continued
> existence (a kref could do that) -- they serialize a number of related
> operations.

Right, but does the grandparent really need serialisation? Normal simple
tree manipulations don't require more than 2 locks to guarantee tree
consistency. So you either don't have a simple tree, or you have more
requirements.

> > > The routine that locks all the devices acquires the locks in order of 
> > > device registration.  The idea here is that children are always 
> > > registered _after_ their parents, so this should be compatible with the 
> > > previous rule.  But there is a potential problem: device_move() can 
> > > move an older child under a younger parent!
> > 
> > Seems like a weird rule, a typical tree locking rule would be to lock
> > them top-down - such a rule can easily cope with moves: lock old parent,
> > lock child, lock new parent, move child, unlock all in reverse order.
> 
> Yep.  But this isn't a typical tree-locking.  System suspend sometimes
> requires that devices be powered down in a specific order, and there
> are constraints not captured by the positions in the tree.  We get
> around this by powering devices down in reverse order of detection,
> which should always be safe.  Although the locking need not necessarily
> follow these same constraints, it is certainly the easiest approach.

Ah, there are more constraints than tree order (which as I get it
resembles bus order)? Which confuses me, as you cannot detect a leaf
before you have a parent, so top-down should still be good, no?

> (And by the way, your example rule "lock old parent, lock child, lock
> new parent" is subject to deadlocks.  What if another task tries to
> move a different device from under the new parent to the old parent at
> the same time?)

D'0h, right you are. How about a delete, insert sequence?

> > Like said, I think the tree locking model should be revisited. A
> > top-down locking model with lock-coupling should, from my ignorant
> > perspective, solve your problems.
> 
> I don't understand what you mean by "lock-coupling".

      A
  B      C
D   E  F   G

In order to lock F we do:
  lock A, lock C, unlock A, lock F, unlock C

Look at it this way, either you're more complex than the VFS or it can
be annotated :-)

