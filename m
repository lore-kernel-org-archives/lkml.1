Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbXKGQmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbXKGQmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 11:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbXKGQmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 11:42:37 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37155 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754767AbXKGQmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 11:42:36 -0500
Date: Wed, 7 Nov 2007 11:42:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Greg KH <greg@kroah.com>, Oliver Neukum <oneukum@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, apw <apw@shadowen.org>,
       Ingo Molnar <mingo@elte.hu>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: device struct bloat
In-Reply-To: <1194375447.6289.85.camel@twins>
Message-ID: <Pine.LNX.4.44L0.0711071056310.4444-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007, Peter Zijlstra wrote:

> > Nonsense.  Consider a simple tree: A is the root, B and C are two
> > children of A.  Task 1 wants to lock all the entries in the tree, so it
> > acquires the locks for A (the parent), then B, and then C (the
> > children).  Meanwhile task 2 also wants to lock all the entries in the
> > tree, so it acquires the locks for A (the parent), then C, and then B
> > (the children).  Now there _is_ a lateral dependency (BC/CB), despite
> > the fact that both tasks lock from the top down.
> 
> Damn, I was thinking of a B+tree, in that case the children are ordered,
> much like what you need I guess. (Although the balancing of the B+tree
> makes it more complex)

As a matter of fact there is a hidden ordering of the children, given
by klist_children in struct device.  But I think relying on it would be
a mistake.

There probably aren't many places in the kernel where a task needs to
lock two sibling devices.  The only one I know of is the locking
routine for system suspend -- but then I've never looked for any
others.  So maybe we don't have to worry about it much.  (On the other 
hand, if we don't worry about it now then you can bet someone will run 
into trouble in the future!)

> > > And only up to 8, as that's the max nesting depth.
> > 
> > I wasn't aware of the limit.  This definitely suggests that I will need
> > to use lockdep-avoiding routines at some stage, even if not for the
> > purpose being discussed here.
> 
> Please, don't do that. Lockdep really helps. It might be a little
> getting used to, but it really pays itself back in the validation it
> does. Not knowing what you were doing (might it be worth to start a new
> thread on that?) lock classes might help annotate.

I'm already using mutex_lock_nested.  But if the nesting limit is 8 
then there's a possibility it might be exceeded someday.  What's the 
alternative?

The application is dynamic power management (autosuspend and
autoresume).  There's a pm_mutex associated with the device, and it is
locked during the suspend and resume processing.  The problem is that
when a device gets suspended, it tells its parent -- and then the
parent may see that all the children are now suspended so the parent
can autosuspend itself, and so on up the device tree.  Likewise, if an
entire subtree is autosuspended and a device near the bottom needs to
autoresume for I/O, it first has to ask its parent to autoresume, which
then has to ask _its_ parent, etc.

Right now the implementation is confined to the USB subsystem so the
nesting can't get too deep, but in time it's likely to expand.


> Anyway, can we make a list of requirements so I can try and work
> something out?
> 
> So its a simple tree with ordered children, where: 
>  - probe can recurse once
>  - probe must exclude suspend/resume
>  - suspend/resume must exclude everything

Um.  How about instead if I try to list the places where dev->sem is 
currently used?

	As discussed earlier, during system-sleep transitions
	every device must be locked.

	Any place the driver core calls a driver method (probe,
	remove, suspend, resume), it does so with the lock held.
	The shutdown method may be different; I haven't paid any 
	attention to it.

	There are some unfortunate encroachments from the USB
	subsystem in the driver core.  USB requires that during
	probe and remove method calls, dev->parent->sem be locked
	as well as dev->sem.  Some of the time this happens
	automatically, but at other times (like when a new driver
	is registered) the driver core has to take the lock
	explicitly.  You can see comments about USB in
	drivers/base/{bus,dd}.c.

	Subsystems may have their own special uses for dev->sem.
	Whenever they need something to be mutually exclusive with
	probe, remove, suspend, or resume, they can use that lock.
	For example, USB requires dev->sem to be held while doing a
	device reset or a device-configuration change.

	Individual drivers can hold dev->sem when they want to
	synchronize some region of code with their remove, suspend,
	or resume methods.  The USB hub driver does this.

Incidentally, probe() can recurse more than once.  In fact it does in
some spots.

Alan Stern

