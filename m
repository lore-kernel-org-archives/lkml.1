Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbYDRPcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbYDRPcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 11:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYDRPcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 11:32:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42981 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYDRPcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 11:32:45 -0400
Subject: Re: Semphore -> mutex in the device tree
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0804181014170.5443-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0804181014170.5443-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 17:32:42 +0200
Message-Id: <1208532762.7115.152.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-18 at 10:27 -0400, Alan Stern wrote:
> On Fri, 18 Apr 2008, Peter Zijlstra wrote:
> 
> > > Even so there is a potential for trouble.  I don't know of any concrete
> > > examples like this in the kernel, but they might exist.  Suppose a
> > > driver keeps a private mutex associated with each device it manages.  
> > > Normally the device's lock would be acquired first and the private
> > > mutex second.  But there could be places where the driver acquires a
> > > child device's lock while holding the parent's mutex; this would look
> > > to lockdep like a violation.
> > 
> > So lockdep cares about classes and the hierarchy of thereof; so given
> > your example:
> > 
> >    parent_tree_level
> >      child_tree_level
> >        device_lock
> > 
> > Its perfectly fine to take a lock from 'parent_tree_level' and then a
> > lock from 'device_lock', skipping the class in the middle - as long as
> > you thereafter never acquire a lock from it.
> > 
> > So given a pre-determined class hierarchy, you're not required to take
> > all locks in that hierarchy; as long as you always go down. If you ever
> > take a lock so that moves up in the hierarchy you're in trouble.
> 
> We must be talking at cross purposes.  Are classes and subclasses all 
> that lockdep looks at?

Yes, it is fully class based.

> Let's take a simpler example.  Suppose driver D's probe routine 
> registers a child device.  Then we have:
> 
> 	Subsystem:		Register device A with driver core
> 
> 	Driver core:		Lock device A with NESTING_PARENT
> 				Call D:probe()
> 
> 	D:probe():		Register device B with driver core
> 				as a child of A
> 
> 	Driver core:		Lock device B with NESTING_PARENT
> 				Call E:probe()
> 
> (where E is the appropriate driver for B).  Is this a lockdep 
> violation?  Both A and B are locked with the same nesting level, 
> because they are locked by the same code in the driver core, but 
> one is the parent of the other in the device tree.

Do I interpert this correct when I envision a call-chain like this:

  register_devise(A, some_parent)
    lock_device(A, NESTING_PARENT)
    D->probe()
      register_device(B, A)
      lock_device(B, NESTING_PARENT)

That would work iff register_device() sets a tree-level class on B that
is one down from A.

> Or maybe I misunderstood, and you're proposing to use a node's level in
> the tree as its lockdep nesting level.

Yes, associate a class with each level like this:

static struct lockdep_class_key device_tree_class[MAX_DEVICE_TREE_DEPTH];

register_device(child, parent)
{
	...
	child->depth = parent->depth + 1;
	WARN_ON(child->depth > MAX_DEVICE_TREE_DEPTH);
	mutex_destroy(&child->lock);
	mutex_init(&child->lock);
	lockdep_set_class(&child->lock, &device_tree_class[child->depth]);
	...
}

Now suppose we have a tree like:

0          A
         / | \
1       B  C  D
            / | \
2          E  F  F
           |
3          H


Now, you can lock the whole path to H like:

  mutex_lock(&A->lock);
  mutex_lock(&D->lock);
  mutex_unlock(&A->lock);
  mutex_lock(&E->lock);
  mutex_unlock(&D->lock);
  mutex_lock(&H->lock);
  mutex_unlock(&E->lock);

  < H locked >

without a single other lockdep annotation; this will teach lockdep the
following class order:

  device_tree_class[0]
    device_tree_class[1]
      device_tree_class[2]
        device_tree_class[3]

So a lock sequence like:

  mutex_lock(&E->lock);
  mutex_lock(&D->lock);

Which will go from 2 -> 1, will generate a complaint.

So, now your sibling scenario:

Lock D, E and F:

  mutex_lock(&D->lock);
  mutex_lock(&E->lock);
  mutex_lock_nested(&F->lock, SINGLE_DEPTH_NESTING);

This will teach lockdep the following class order:

  device_tree_class[1]
    device_tree_class[2]
      device_tree_class[2].subclass[1]

So, if at another time you do:

  mutex_lock(&D->lock);
  mutex_lock(&F->lock);
  mutex_lock(&E->lock, SINGLE_DEPTH_NESTING);

you're still obeying that order; of course you have to somehow guarantee
that it will never actually deadlock - otherwise you annotate a genuine
warning away.

>   In that case, consider this
> example.  Suppose driver D associates a private mutex M with each of
> its devices.  Suppose D is managing device A at level 4 and device B at
> level 5.  Then we might have:
> 
> 	D:		Lock device B at level 5
> 	D:		Lock B's associated M
> 
> (which tells lockdep that M comes after level 5), together with
> 
> 	D:		Lock device A at level 4
> 	D:		Lock A's associated M
> 	D:		Lock A's child at level 5
                                    ^ B, right?
> 
> Won't this then be a lockdep violation (since M is now locked before a
> device at level 5)?

Interesting.. yes, this would make lockdep upset - basically because you
introduce nesting of M.

  device_tree_class[4]
    M_class
      device_tree_class[5]
        M_class

So you take M_class inside M_class.

Is this a common scenario? Normally a driver would only deal with a
single device instance at a time, so I guess that once this scenario can
happen the driver is already aware of this, right?

It would need a separate annotation; if the coupling would be static
(ps2 keyboard/mouse comes to mind) then the driver can have different
lockdep_class_key instances.


