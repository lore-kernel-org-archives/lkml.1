Return-Path: <linux-kernel-owner+w=401wt.eu-S935300AbZLGPPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935300AbZLGPPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935250AbZLGPPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:15:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42562 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935279AbZLGPPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:15:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Date: Mon, 7 Dec 2009 16:15:34 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>, Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912060953190.4442-100000@netrider.rowland.org> <1260158279.27069.181.camel@rzhang1-desktop> <alpine.LFD.2.00.0912062122460.3560@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912062122460.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912071615.34788.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 December 2009, Linus Torvalds wrote:
> 
> On Mon, 7 Dec 2009, Zhang Rui wrote:
> > 
> > Hi, Linus,
> > can you please look at this patch set and see if the idea is right?
> > http://marc.info/?l=linux-kernel&m=124840449826386&w=2
> > http://marc.info/?l=linux-acpi&m=124840456826456&w=2
> > http://marc.info/?l=linux-acpi&m=124840456926459&w=2
> > http://marc.info/?l=linux-acpi&m=124840457026468&w=2
> > http://marc.info/?l=linux-acpi&m=124840457126471&w=2
> 
> So I'm not entirely sure about that patch-set, but the thing I like about 
> it is how drivers really sign up to it one by one, rather than having all 
> PCI devices automatically signed up for async behavior.
> 
> That said, the thing I don't like about it is some of the same thing I 
> don't necessarily like about the series in Rafael's tree either:

Just for the record, it's not in there any more.

> it looks rather over-designed with the whole infrastructure for async device logic 
> (your patch in http://marc.info/?l=linux-acpi&m=124840456926459&w=2). How 
> would you explain that whole async_dev_register() logic in simple terms to 
> somebody else?
> 
> (I think yours is simpler that the one in the PM tree, but I dunno. I've 
> not really compared the two).
> 
> So let me explain my dislike by trying to outline some conceptually simple 
> thing that doesn't have any call-backs, doesn't have any "classes", 
> doesn't require registration etc. It just allows drivers at any level to 
> decide to do some things (not necessarily everything) asynchronously.
> 
> Here's the outline:
> 
>  - first off: drivers that don't know that they nest clearly don't do 
>    anything asynchronous. No "PCI devices can be done in parallel" crap, 
>    because they really can't - not in the general case. So just forget 
>    about that kind of logic entirely: it's just wrong.
> 
>  - the 'suspend' thing is a depth-first tree walk. As we suspend a node, 
>    we first suspend the child nodes, and then we suspend the node itself. 
>    Everybody agrees about that, right?
> 
>  - Trivial "async rule": the tree is walked synchronously, but as we walk 
>    it, any point in the tree may decide to do some or all of its suspend 
>    asynchronously. For example, when we hit a disk node, the disk driver 
>    may just decide that (a) it knows that the disk is an independent thing 
>    and (b) it's hierarchical wrt it's parent so (c) it can do the disk 
>    suspend asynchronously.
> 
>  - To protect against a parent node being suspended before any async child 
>    work has completed, the child suspend - before it kicks off the actual 
>    async work - just needs to take a read-lock on the parent (read-lock, 
>    because you may have multiple children sharing a parent, and they don't 
>    lock each other out). Then the only thing the asynchronous code needs 
>    to do is to release the read lock when it is done.
> 
>  - Now, the rule just becomes that the parent has to take a write lock on 
>    itself when it suspends itself. That will automatically block until 
>    all children are done.
> 
> Doesn't the above sound _simple_?

I don't think the idea is really that much simpler than the one behind the
patchset you've just rejected.  The only real difference is that in that
patchset the entire suspend and resume callbacks could be either
asynchronous or synchronous and in your approach each callback may
be devided into the synchronous and asynchronous part, which admittedly is
more flexible, but not necessarily simpler.

Now, apart from the idea there are some details that need to be taken into
consideration like the fact that the children may not be the only devices
you need to wait for with the parent suspend and that implies additional
locking rules.  But you need to know which devices to lock and that has
to be represented somehow (the PM links in my patchset were for this and
_nothing_ else).

Also, it looks like the parent locking should rather be done at the core
level, as it appears to be a piece of code that needs to be called for each
device:

if (I_have_children || I_have_other_dependent_devices)
        write_lock_myself

> Now, the problem remains that when you walk the device tree starting off 
> all these potentially asynchronous events, you don't want to do that 
> serialization part (the "parent suspend") as you walk the tree - because 
> then you would only ever do one single level asynchronously. Which is why 
> I suggested splitting the suspend into a "pre-suspend" phase (and a 
> "post-resume" one). Because then the tree walk goes from
> 
> 	# single depth-first thing
> 	suspend(root)
> 	{
> 		for_each_child(root) {
> 			// This may take the parent lock for
> 			// reading if it does something async
> 			suspend(child);
> 		}
> 
> 		// This serializes with any async children
> 		write_lock(root->lock);
> 		suspend_one_node(root);
> 		write_unlock(root->lock);
> 	}
> 
> to
> 
> 	# Phase one: walk the tree synchronously, starting any
> 	# async work on the leaves
> 	suspend_prepare(root)
> 	{
> 		for_each_child(root) {
> 			// This may take the parent lock for
> 			// reading if it does something async
> 			suspend_prepare(child);
> 		}
> 		suspend_prepare_one_node(root);
> 	}
> 
> 	# Phase two: walk the tree synchronously, waiting for
> 	# and finishing the suspend
> 	suspend(root)
> 	{
> 		for_each_child(root) {
> 			suspend(child);
> 		}
> 		// This serializes with any async children started in phase 1
> 		write_lock(root->lock);
> 		suspend_one_node(root);
> 		write_unlock(root->lock);
> 	}
> 
> and I really think this should work.

We already have prepare and complete suspend callbacks, for a different reason,
and I'm not sure they're suitable for doing the async thing.

So, we'd need to add another two callbacks, just for suspend to RAM, and what
about hibernation?  Isn't that going to become a bit too complicated?

> The advantage: untouched drivers don't change ANY SEMANTICS AT ALL.

This also was true for my patchset.

> If they don't have a 'suspend_prepare()' function, then they still see that 
> exact same sequence of 'suspend()' calls.

The same holded for drivers without the async_suspend flag set in my patchset
(I really should have left setting it to individual drivers).

> In fact, even if they have children that _do_ have drivers that have that
> async phase, they'll never know, because that simple write-semaphore
> trivially guarantees that whether there was async work or not, it will be
> completed by the time we call 'suspend()'.

Ditto.

> And drivers that want to do things asynchronously don't need to register 
> or worry: all they do is literally
> 
>  - move their 'suspend()' function to 'suspend_prepare()' instead
> 
>  - add a
> 
> 	down_read(dev->parent->lock);
> 	async_run(mysuspend, dev);
> 
>    to the point that they want to be asynchronous (which may be _all_ of 
>    it or just some slow part). The 'mysuspend' part would be the async 
>    part.
> 
>  - add a
> 
> 	up_read(dev->parent->lock);
> 
>    to the end of their asynchronous 'mysuspend()' function, so that when 
>    the child has finished suspending, the parent down_write() will finally 
>    succeed.

In my patchset the drivers didn't need to do all that stuff.  The only thing
they needed, if they wanted their suspend/resume to be executed
asynchronously, was to set the async_suspend flag.

But this is just for the record, in case you end up with code that's more
complicated than the rejected one.

Rafael
