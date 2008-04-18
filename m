Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbYDRVqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbYDRVqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYDRVpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 17:45:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45027 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751163AbYDRVpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 17:45:53 -0400
Date: Fri, 18 Apr 2008 17:45:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: Semphore -> mutex in the device tree
In-Reply-To: <1208532762.7115.152.camel@twins>
Message-ID: <Pine.LNX.4.44L0.0804181726490.2186-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008, Peter Zijlstra wrote:

> Do I interpert this correct when I envision a call-chain like this:
> 
>   register_devise(A, some_parent)
>     lock_device(A, NESTING_PARENT)
>     D->probe()
>       register_device(B, A)
>       lock_device(B, NESTING_PARENT)
> 
> That would work iff register_device() sets a tree-level class on B that
> is one down from A.
> 
> > Or maybe I misunderstood, and you're proposing to use a node's level in
> > the tree as its lockdep nesting level.
> 
> Yes, associate a class with each level like this:
> 
> static struct lockdep_class_key device_tree_class[MAX_DEVICE_TREE_DEPTH];
> 
> register_device(child, parent)
> {
> 	...
> 	child->depth = parent->depth + 1;
> 	WARN_ON(child->depth > MAX_DEVICE_TREE_DEPTH);
> 	mutex_destroy(&child->lock);
> 	mutex_init(&child->lock);
> 	lockdep_set_class(&child->lock, &device_tree_class[child->depth]);
> 	...
> }

Aha.  I never understood that lockdep classes worked like that.

...
> So, now your sibling scenario:
> 
> Lock D, E and F:
> 
>   mutex_lock(&D->lock);
>   mutex_lock(&E->lock);
>   mutex_lock_nested(&F->lock, SINGLE_DEPTH_NESTING);
> 
> This will teach lockdep the following class order:
> 
>   device_tree_class[1]
>     device_tree_class[2]
>       device_tree_class[2].subclass[1]
> 
> So, if at another time you do:
> 
>   mutex_lock(&D->lock);
>   mutex_lock(&F->lock);
>   mutex_lock(&E->lock, SINGLE_DEPTH_NESTING);
> 
> you're still obeying that order; of course you have to somehow guarantee
> that it will never actually deadlock - otherwise you annotate a genuine
> warning away.

I'm still not sure this will end up working.  In the situation I have 
in mind both sibling classes are locked by the same line of code; 
hence they will end up with the same nesting/subclass.

> >   In that case, consider this
> > example.  Suppose driver D associates a private mutex M with each of
> > its devices.  Suppose D is managing device A at level 4 and device B at
> > level 5.  Then we might have:
> > 
> > 	D:		Lock device B at level 5
> > 	D:		Lock B's associated M
> > 
> > (which tells lockdep that M comes after level 5), together with
> > 
> > 	D:		Lock device A at level 4
> > 	D:		Lock A's associated M
> > 	D:		Lock A's child at level 5
>                                     ^ B, right?

Doesn't have to be B.  It could be any device.

> > Won't this then be a lockdep violation (since M is now locked before a
> > device at level 5)?
> 
> Interesting.. yes, this would make lockdep upset - basically because you
> introduce nesting of M.
> 
>   device_tree_class[4]
>     M_class
>       device_tree_class[5]
>         M_class
> 
> So you take M_class inside M_class.
> 
> Is this a common scenario? Normally a driver would only deal with a
> single device instance at a time, so I guess that once this scenario can
> happen the driver is already aware of this, right?

I don't know if this ever occurs in the kernel.  But it is a plausible 
scenario.

In situations like this, where a private lock is acquired both before 
and after a device lock (albeit on different levels), the most logical 
solution is to assign each private lock to a class connected with the 
associated device's class.  Can that be made to work?

> It would need a separate annotation; if the coupling would be static
> (ps2 keyboard/mouse comes to mind) then the driver can have different
> lockdep_class_key instances.

Rather like what I just said, right?


I have wondered if it would be feasible for lockdep to support 
tree-ordered locks directly.  It would have to know which mutexes 
belong to a tree structure, as well as the offsets to the parent 
pointer and to the mutex from the beginning of the enclosing structure.

Since processes rarely lock more than a few tree members at a time, 
lockdep could get away with checking a few simple rules (for downward 
lock ordering):

	When locking a device D, if any other device locks are
	held then D's parent must already be locked.  (A little
	more strict than necessary, but this should be acceptable.)

	When locking a device D, none of the other device locks
	already held may be for descendants of D.

No doubt there are details making this less easy than I have painted 
it.  Still, could it reasonably be done?

Alan Stern

