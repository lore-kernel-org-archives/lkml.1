Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbXKFSFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbXKFSFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbXKFSFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:05:35 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59063 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752613AbXKFSFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:05:34 -0500
Date: Tue, 6 Nov 2007 13:05:31 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Greg KH <greg@kroah.com>, Oliver Neukum <oneukum@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, apw <apw@shadowen.org>,
       Ingo Molnar <mingo@elte.hu>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: device struct bloat
In-Reply-To: <1194369566.6289.59.camel@twins>
Message-ID: <Pine.LNX.4.44L0.0711061241300.8395-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007, Peter Zijlstra wrote:

> > > *blink* someone needs to take all locks - why?
> > 
> > It's for system suspend.  All the devices are locked to prevent driver 
> > binding and unbinding during the suspend transition.
> 
> Just locking the tree root is not enough? (thereby avoiding all any new
> modifying operation to descend into the tree).

But not all modifying operations must descend into the tree from the
root.  Not even operations that modify the tree itself, let alone
operations that modify the individual devices without changing their
position in the tree.

> > Even apart from that, there are places where the USB core needs to
> > acquire multiple layers of locks (more than just two).  For example, if
> > somebody has hubs nested several deep and then unplugs the hub closest
> > to the computer, this will happen.
> 
> Pin the sub-tree root with a reference, iterate the sub-tree and delete
> the leafs one by one?

Pinning isn't the issue; serialization is.  You can't serialize 
operations on device Y by locking device X, even if X is at the root of 
a sub-tree containing Y.

> > Shucks, any time a driver's probe routine tries to register a child 
> > device you will run into problems.  probe() is always called with the 
> > device locked, and registration of a child will acquire the child's 
> > lock in order to probe drivers for the child.
> 
> Right, so you say you have unbounded stack recursion?

I didn't say anything about unbounded recursion.  I said there would be 
one level of recursion, and that alone would mess up the lockdep scheme 
in your proposed patch.

>  How about pushing
> each probe into a stack (workqueue perhaps). Then each stack entry would
> only do a single level probe, if it would recurse push a new entry on
> the stack. Basic recursive -> stack transform.

No.  You're advocating spending a lot of effort to take something that
works well and for no good reason make it much more complicated and
prone to failure.

> > I don't follow your reasoning.  Let's say a task wants to lock all the
> > direct children of a particular device.  In what order should the locks
> > be acquired?  
> 
> I'd first start by asking if you want to lock all the children or the
> sub-tree. The latter can be done by locking the root of said sub-tree.

I want to lock all the children.  It can't be done just by locking the 
root of the sub-tree.

> > There's no natural tree-related ordering to follow.
> 
> Of course there is a natural deadlock free locking order in a tree: lock
> the parent, lock all its children, repeat by noting that each child is a
> parent again. If you only ever lock top down, there should not be any
> lateral dependencies.

Nonsense.  Consider a simple tree: A is the root, B and C are two
children of A.  Task 1 wants to lock all the entries in the tree, so it
acquires the locks for A (the parent), then B, and then C (the
children).  Meanwhile task 2 also wants to lock all the entries in the
tree, so it acquires the locks for A (the parent), then C, and then B
(the children).  Now there _is_ a lateral dependency (BC/CB), despite
the fact that both tasks lock from the top down.

> > In the simple case where locks are acquired along a path in the tree,
> > you could solve the lockdep issues by passing mutex_lock_nested() a key
> > equal to the device's depth in the tree.  But that won't work with more
> > complicated cases.
> 
> And only up to 8, as that's the max nesting depth.

I wasn't aware of the limit.  This definitely suggests that I will need
to use lockdep-avoiding routines at some stage, even if not for the
purpose being discussed here.

> > > > Deadlock is a serious consideration.  For the most part, routines 
> > > > locking devices do so along a single path in the tree.  For this simple 
> > > > case the rule is: Never acquire a parent's lock while holding the 
> > > > child's lock.
> > > 
> > > Sure, but once you have a parent's lock, you could unlock your
> > > grandparent, no? (it having a locked child, your parent, should be
> > > enough to guarantee its continued existence)
> > 
> > Of course.  So what?  In many cases the code needs to keep all three
> > locks.  The locks don't merely guarantee the device structs' continued
> > existence (a kref could do that) -- they serialize a number of related
> > operations.
> 
> Right, but does the grandparent really need serialisation? Normal simple
> tree manipulations don't require more than 2 locks to guarantee tree
> consistency. So you either don't have a simple tree, or you have more
> requirements.

Yes, the grandparent really needs serialization.  We guarantee, for 
example, that suspend and resume methods won't get called while probe 
is running.  That guarantee is provided by the device sem.  If you 
change it into a mutex and release it inside a subroutine called from 
probe then the guarantee won't be met.

> > > > The routine that locks all the devices acquires the locks in order of 
> > > > device registration.  The idea here is that children are always 
> > > > registered _after_ their parents, so this should be compatible with the 
> > > > previous rule.  But there is a potential problem: device_move() can 
> > > > move an older child under a younger parent!
> > > 
> > > Seems like a weird rule, a typical tree locking rule would be to lock
> > > them top-down - such a rule can easily cope with moves: lock old parent,
> > > lock child, lock new parent, move child, unlock all in reverse order.
> > 
> > Yep.  But this isn't a typical tree-locking.  System suspend sometimes
> > requires that devices be powered down in a specific order, and there
> > are constraints not captured by the positions in the tree.  We get
> > around this by powering devices down in reverse order of detection,
> > which should always be safe.  Although the locking need not necessarily
> > follow these same constraints, it is certainly the easiest approach.
> 
> Ah, there are more constraints than tree order (which as I get it
> resembles bus order)? Which confuses me, as you cannot detect a leaf
> before you have a parent, so top-down should still be good, no?

No.  You seem to think that top-down is a clear-cut, well-defined total
order.  It isn't; it's only a partial order.  In the example I gave
earlier, top-down doesn't establish any definite order relation between
B and C because they are siblings.  But there might be a power
dependency between them.

> > (And by the way, your example rule "lock old parent, lock child, lock
> > new parent" is subject to deadlocks.  What if another task tries to
> > move a different device from under the new parent to the old parent at
> > the same time?)
> 
> D'0h, right you are. How about a delete, insert sequence?

That would work.  But it shows that the situation is more complicated 
than it seems at first.

> > > Like said, I think the tree locking model should be revisited. A
> > > top-down locking model with lock-coupling should, from my ignorant
> > > perspective, solve your problems.
> > 
> > I don't understand what you mean by "lock-coupling".
> 
>       A
>   B      C
> D   E  F   G
> 
> In order to lock F we do:
>   lock A, lock C, unlock A, lock F, unlock C
> 
> Look at it this way, either you're more complex than the VFS or it can
> be annotated :-)

It would work, but what an awful waste of time!  Not to mention the 
overhead due to cache-line bouncing on SMP systems.  And contention for 
hotspots near the root of the device tree.

All just to make lockdep happy!  It doesn't seem worth it, to me.

Alan Stern

