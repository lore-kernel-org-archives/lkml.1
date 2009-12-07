Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbZLGF54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbZLGF54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 00:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZLGF5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 00:57:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751522AbZLGF5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 00:57:54 -0500
Date: Sun, 6 Dec 2009 21:57:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Zhang Rui <rui.zhang@intel.com>
cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <1260158279.27069.181.camel@rzhang1-desktop>
Message-ID: <alpine.LFD.2.00.0912062122460.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912060953190.4442-100000@netrider.rowland.org> <1260158279.27069.181.camel@rzhang1-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Dec 2009, Zhang Rui wrote:
> 
> Hi, Linus,
> can you please look at this patch set and see if the idea is right?
> http://marc.info/?l=linux-kernel&m=124840449826386&w=2
> http://marc.info/?l=linux-acpi&m=124840456826456&w=2
> http://marc.info/?l=linux-acpi&m=124840456926459&w=2
> http://marc.info/?l=linux-acpi&m=124840457026468&w=2
> http://marc.info/?l=linux-acpi&m=124840457126471&w=2

So I'm not entirely sure about that patch-set, but the thing I like about 
it is how drivers really sign up to it one by one, rather than having all 
PCI devices automatically signed up for async behavior.

That said, the thing I don't like about it is some of the same thing I 
don't necessarily like about the series in Rafael's tree either: it looks 
rather over-designed with the whole infrastructure for async device logic 
(your patch in http://marc.info/?l=linux-acpi&m=124840456926459&w=2). How 
would you explain that whole async_dev_register() logic in simple terms to 
somebody else?

(I think yours is simpler that the one in the PM tree, but I dunno. I've 
not really compared the two).

So let me explain my dislike by trying to outline some conceptually simple 
thing that doesn't have any call-backs, doesn't have any "classes", 
doesn't require registration etc. It just allows drivers at any level to 
decide to do some things (not necessarily everything) asynchronously.

Here's the outline:

 - first off: drivers that don't know that they nest clearly don't do 
   anything asynchronous. No "PCI devices can be done in parallel" crap, 
   because they really can't - not in the general case. So just forget 
   about that kind of logic entirely: it's just wrong.

 - the 'suspend' thing is a depth-first tree walk. As we suspend a node, 
   we first suspend the child nodes, and then we suspend the node itself. 
   Everybody agrees about that, right?

 - Trivial "async rule": the tree is walked synchronously, but as we walk 
   it, any point in the tree may decide to do some or all of its suspend 
   asynchronously. For example, when we hit a disk node, the disk driver 
   may just decide that (a) it knows that the disk is an independent thing 
   and (b) it's hierarchical wrt it's parent so (c) it can do the disk 
   suspend asynchronously.

 - To protect against a parent node being suspended before any async child 
   work has completed, the child suspend - before it kicks off the actual 
   async work - just needs to take a read-lock on the parent (read-lock, 
   because you may have multiple children sharing a parent, and they don't 
   lock each other out). Then the only thing the asynchronous code needs 
   to do is to release the read lock when it is done.

 - Now, the rule just becomes that the parent has to take a write lock on 
   itself when it suspends itself. That will automatically block until 
   all children are done.

Doesn't the above sound _simple_? Doesn't that sound like it should just 
obviously do the right thing? It sounds like something you can explain as 
a locking rule without having any complex semantic registration or 
anything at all.

Now, the problem remains that when you walk the device tree starting off 
all these potentially asynchronous events, you don't want to do that 
serialization part (the "parent suspend") as you walk the tree - because 
then you would only ever do one single level asynchronously. Which is why 
I suggested splitting the suspend into a "pre-suspend" phase (and a 
"post-resume" one). Because then the tree walk goes from

	# single depth-first thing
	suspend(root)
	{
		for_each_child(root) {
			// This may take the parent lock for
			// reading if it does something async
			suspend(child);
		}

		// This serializes with any async children
		write_lock(root->lock);
		suspend_one_node(root);
		write_unlock(root->lock);
	}

to

	# Phase one: walk the tree synchronously, starting any
	# async work on the leaves
	suspend_prepare(root)
	{
		for_each_child(root) {
			// This may take the parent lock for
			// reading if it does something async
			suspend_prepare(child);
		}
		suspend_prepare_one_node(root);
	}

	# Phase two: walk the tree synchronously, waiting for
	# and finishing the suspend
	suspend(root)
	{
		for_each_child(root) {
			suspend(child);
		}
		// This serializes with any async children started in phase 1
		write_lock(root->lock);
		suspend_one_node(root);
		write_unlock(root->lock);
	}

and I really think this should work.

The advantage: untouched drivers don't change ANY SEMANTICS AT ALL. If 
they don't have a 'suspend_prepare()' function, then they still see that 
exact same sequence of 'suspend()' calls. In fact, even if they have 
children that _do_ have drivers that have that async phase, they'll never 
know, because that simple write-semaphore trivially guarantees that 
whether there was async work or not, it will be completed by the time we 
call 'suspend()'.

And drivers that want to do things asynchronously don't need to register 
or worry: all they do is literally

 - move their 'suspend()' function to 'suspend_prepare()' instead

 - add a

	down_read(dev->parent->lock);
	async_run(mysuspend, dev);

   to the point that they want to be asynchronous (which may be _all_ of 
   it or just some slow part). The 'mysuspend' part would be the async 
   part.

 - add a

	up_read(dev->parent->lock);

   to the end of their asynchronous 'mysuspend()' function, so that when 
   the child has finished suspending, the parent down_write() will finally 
   succeed.

Doesn't that all sound pretty simple? And it has a very clear architecture 
that is pretty easy to explain to anybody who knows about traversing trees 
depth-first.

No complex concepts. No change to existing tested drivers. No callbacks, 
no flags, no nothing. And a pretty simple way for a driver to decide: I'll 
do my suspends asynchronously (without parent drivers really ever even 
having to know about it).

I dunno. Maybe I'm overlooking something, but the above is much closer to 
what I think would be worth doing.

			Linus
