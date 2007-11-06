Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbXKFS5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbXKFS5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbXKFS5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:57:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56675 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbXKFS5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:57:33 -0500
Subject: Re: device struct bloat
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Oliver Neukum <oneukum@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, apw <apw@shadowen.org>,
       Ingo Molnar <mingo@elte.hu>, linux-usb-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.44L0.0711061241300.8395-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0711061241300.8395-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Tue, 06 Nov 2007 19:57:27 +0100
Message-Id: <1194375447.6289.85.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-06 at 13:05 -0500, Alan Stern wrote:
> On Tue, 6 Nov 2007, Peter Zijlstra wrote:
> 
> > > > *blink* someone needs to take all locks - why?
> > > 
> > > It's for system suspend.  All the devices are locked to prevent driver 
> > > binding and unbinding during the suspend transition.
> > 
> > Just locking the tree root is not enough? (thereby avoiding all any new
> > modifying operation to descend into the tree).
> 
> But not all modifying operations must descend into the tree from the
> root.  Not even operations that modify the tree itself,

Right, that is only required if you want to exclude sub-tree
modifications. If you drop this requirement you can just jump in the
middle, lock an element and check if its still linked into the tree.

>  let alone
> operations that modify the individual devices without changing their
> position in the tree.

Right, in that case the dev->sem serialises the variables inside the
struct device, that can be seen as a separate orthogonal lock, the fact
that they happen to be the same need not be relevant.

> > > Even apart from that, there are places where the USB core needs to
> > > acquire multiple layers of locks (more than just two).  For example, if
> > > somebody has hubs nested several deep and then unplugs the hub closest
> > > to the computer, this will happen.
> > 
> > Pin the sub-tree root with a reference, iterate the sub-tree and delete
> > the leafs one by one?
> 
> Pinning isn't the issue; serialization is.  You can't serialize 
> operations on device Y by locking device X, even if X is at the root of 
> a sub-tree containing Y.

Sometimes its enough if you know that locking Y requires locking X
first. But yeah it depends on the exact requirements.

> > > Shucks, any time a driver's probe routine tries to register a child 
> > > device you will run into problems.  probe() is always called with the 
> > > device locked, and registration of a child will acquire the child's 
> > > lock in order to probe drivers for the child.
> > 
> > Right, so you say you have unbounded stack recursion?
> 
> I didn't say anything about unbounded recursion.  I said there would be 
> one level of recursion, and that alone would mess up the lockdep scheme 
> in your proposed patch.

I'm quite aware that the scheme in my patch is insufficient. A single
level of recursion should be no problem, we do that in other places, it
just requires passing down enough knowledge to know we've recursed.

> >  How about pushing
> > each probe into a stack (workqueue perhaps). Then each stack entry would
> > only do a single level probe, if it would recurse push a new entry on
> > the stack. Basic recursive -> stack transform.
> 
> No.  You're advocating spending a lot of effort to take something that
> works well and for no good reason make it much more complicated and
> prone to failure.

Agreed, if there is only a single level of recursion this is overkill.

> > > I don't follow your reasoning.  Let's say a task wants to lock all the
> > > direct children of a particular device.  In what order should the locks
> > > be acquired?  
> > 
> > I'd first start by asking if you want to lock all the children or the
> > sub-tree. The latter can be done by locking the root of said sub-tree.
> 
> I want to lock all the children.  It can't be done just by locking the 
> root of the sub-tree.

ok

> > > There's no natural tree-related ordering to follow.
> > 
> > Of course there is a natural deadlock free locking order in a tree: lock
> > the parent, lock all its children, repeat by noting that each child is a
> > parent again. If you only ever lock top down, there should not be any
> > lateral dependencies.
> 
> Nonsense.  Consider a simple tree: A is the root, B and C are two
> children of A.  Task 1 wants to lock all the entries in the tree, so it
> acquires the locks for A (the parent), then B, and then C (the
> children).  Meanwhile task 2 also wants to lock all the entries in the
> tree, so it acquires the locks for A (the parent), then C, and then B
> (the children).  Now there _is_ a lateral dependency (BC/CB), despite
> the fact that both tasks lock from the top down.

Damn, I was thinking of a B+tree, in that case the children are ordered,
much like what you need I guess. (Although the balancing of the B+tree
makes it more complex)

> > > In the simple case where locks are acquired along a path in the tree,
> > > you could solve the lockdep issues by passing mutex_lock_nested() a key
> > > equal to the device's depth in the tree.  But that won't work with more
> > > complicated cases.
> > 
> > And only up to 8, as that's the max nesting depth.
> 
> I wasn't aware of the limit.  This definitely suggests that I will need
> to use lockdep-avoiding routines at some stage, even if not for the
> purpose being discussed here.

Please, don't do that. Lockdep really helps. It might be a little
getting used to, but it really pays itself back in the validation it
does. Not knowing what you were doing (might it be worth to start a new
thread on that?) lock classes might help annotate.

> > Right, but does the grandparent really need serialisation? Normal simple
> > tree manipulations don't require more than 2 locks to guarantee tree
> > consistency. So you either don't have a simple tree, or you have more
> > requirements.
> 
> Yes, the grandparent really needs serialization.  We guarantee, for 
> example, that suspend and resume methods won't get called while probe 
> is running.  That guarantee is provided by the device sem.  If you 
> change it into a mutex and release it inside a subroutine called from 
> probe then the guarantee won't be met.

OK, that makes sense.

> > > > Like said, I think the tree locking model should be revisited. A
> > > > top-down locking model with lock-coupling should, from my ignorant
> > > > perspective, solve your problems.
> > > 
> > > I don't understand what you mean by "lock-coupling".
> > 
> >       A
> >   B      C
> > D   E  F   G
> > 
> > In order to lock F we do:
> >   lock A, lock C, unlock A, lock F, unlock C
> > 
> > Look at it this way, either you're more complex than the VFS or it can
> > be annotated :-)
> 
> It would work, but what an awful waste of time!  Not to mention the 
> overhead due to cache-line bouncing on SMP systems.  And contention for 
> hotspots near the root of the device tree.

You can jump in between if you don't need the sub-tree condition
(locking X requires having locked all its parents Y).

In that case you lock, and validate that you're still linked in the
tree, at which point you can continue your descent.

> All just to make lockdep happy!  It doesn't seem worth it, to me.

I've learnt that making lockdep happy makes me happy. Really, the
validation it does really helps out.


Anyway, can we make a list of requirements so I can try and work
something out?

So its a simple tree with ordered children, where: 
 - probe can recurse once
 - probe must exclude suspend/resume
 - suspend/resume must exclude everything



