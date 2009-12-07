Return-Path: <linux-kernel-owner+w=401wt.eu-S964792AbZLGQcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792AbZLGQcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:32:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935373AbZLGQcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:32:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935361AbZLGQcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:32:08 -0500
Date: Mon, 7 Dec 2009 08:31:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <Pine.LNX.4.44L0.0912071003270.3064-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0912070737150.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912071003270.3064-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Dec 2009, Alan Stern wrote:
> > 
> > I dunno. Maybe I'm overlooking something, but the above is much closer to 
> > what I think would be worth doing.
> 
> You're overlooking resume.  It's more difficult than suspend.  The
> issue is that a child can't start its async part until the parent's
> synchronous part is finished.

No, I haven't overlooked resume at all. I just assumed that it was 
obvious. It's the exact same thing, except in reverse (the locking ends 
up being slightly different, but the changes are actually fairly 
straightforward).

And by reverse, I mean that you walk the tree in the reverse order too, 
exactly like we already do - on suspend we walk it children-first, on 
resume we walk it parents-first (small detail: we actually just walk a 
simple linked list, but the list is topologically ordered, so walking it 
forwards/backwards is topologically the same thing as doing that 
depth-first search).

> So for example, suppose the device listing contains P, C, Q, where C is
> a child of P, Q is unrelated, and P has a long-lasting asynchronous
> requirement.  The resume process will stall upon reaching C, waiting
> for P to finish.  Thus even though P and Q might be able to resume in
> parallel, they won't get the chance.

No. The resume process does EXCTLY THE SAME THING as I outlined for 
suspend, but just all in reverse. So now the resume process becomes the 
same two-phase thing:

	# Phase one
	resume(root)
	{
		// This can do things asynchronously if it wants,
		// but needs to take the write lock on itself until
		// it is done if it does
		resume_one_node(root);
		for_each_child(root)
			resume(child);
	}

	# Phase two
	post_resume(root)
	{
		post_resume_one_node(root);
		for_each_child(root)
			post_resume(child);
	}

Notice? It's _exactly_ the same thing as suspend - except all turned 
around. We do the nodes before the children ("walk the list backwards"), 
and we also do the locking the other way around (ie on suspend we'd lock 
the _parent_ if we wanted to do async stuff - to keep it around - but on 
resume we lock _ourselves_, so that the children can have something to 
wait on. Also note how we take a _write_ lock rather than a read lock).

(And again, I've only written it out in email, I've not tested it or 
thought about it all that deeply, so you'll excuse any stupid thinkos.)

Now, for something like PCI, I'd suggest (once more) leaving all drivers 
totally unchanged, and you end up with the exact same behavior as we had 
before (no real change to the whole resume ordering, and everything is 
synchronous so there is no relevant locking). 

But how would the USB layer do this?

Simple: all the normal leaf devices would have their resume callback be 
called at "post_resume()" time (exactly the reverse of the suspend phase: 
we suspend early, and we resume late - it's all a mirror image). And I'd 
suggest that the USB layer do it all totally asynchronously, except again 
turned around the other way.

Remember how on suspend, the suspend of a leaf device ended up being an 
issue of asynchronously calling a function that did the suspend, and then 
released the read-lock of the parent. Resume is the same, except now we'd 
actually want to take the parent read-lock asynchronously too, so you'd do

	down_write(leaf->lock);
	async_schedule(usb_node_resume, leaf);

where that function simply does

	usb_node_resume(node)
	{
		/* Wait for the parent to have resumed completely */
		down_read(node->parent->lock);
		node->resume(node)
		up_read(node->parent->lock);
		up_write(node->lock);
	}

and you're all done. Once more the ordering and the locking takes care of 
any need to serialize - there is no data structures to keep track of.

And what about USB hubs? They get resumed in the first phase (again, 
exactly the mirror image of the suspend), and the only thing they need to 
do is that _exact_ same thing above:

	down_write(hub->lock);
	async_schedule(usb_node_resume, hub);

 - Ta-daa! All done.

Notice? It's really pretty straightforward, and there are _zero_ new 
concepts. And again, no callbacks, no nothing.  Just the obvious mirror 
image of what happened when suspending. We do everything with simple async 
calls. And none of the tree walking actually blocks (yes, we do a 
"down_write()" on the nodes as we schedule the resume code, but it won't 
be a blocking one, since that is the first time we encounter that node: 
the blocking will come later when the async threads actually need to wait 
for things).

Again, I do not guarantee that I've dotted every i, and crossed every t. 
It's just that I'm pretty sure that we really don't need any fancy 
"infrastructure" for something this simple. And I really much prefer 
"conceptually simple high-level model" over a model of "keep track of all 
the relationships and have some complex model of devices".

So let's just look at your example:

> So for example, suppose the device listing contains P, C, Q, where C is
> a child of P, Q is unrelated, and P has a long-lasting asynchronous
> requirement.

The tree is:

	... -> P -> C
	    -> Q

and with what I suggest, during phase one, P will asynchronously start the 
resume. As part of its async resume it will have to wait for it's parents, 
of course, but all of that happens in a separate context, and the tree 
traversal goes on. 

And during phase #1, C and Q won't do anything at all. We _could_ do them 
during this phase, and it would actually all work out fine, but we 
wouldn't want to do that for a simple reason: we _want_ the pre_suspend 
and post_resume phases to be total mirror images, because if we end up 
doing error handling for the pre-suspend case, then the post-resume phase 
would be the "fixup" for it, so we actually want leaf things to happen 
during phase #2 - not because it would screw up locking or ordering, but 
because of other issues.

When we hit phase #2, we then do C and Q, and do the same thing - we have 
an async call that does the read-lock on the parent to make sure it's 
all resumed, and then we resume C and Q. And they'll automatically resume 
in parallel (unless C is waiting for P, of course, in which case P and Q 
end up resuming in parallel, and C ends up waiting).

Now, the above just takes care of the inter-device ordering. There are 
unrelated semantics we want to give, like "all devices will have resumed 
before we start waking up user space". Those are unrelated to the 
topological requirements, of course, and are not a requirement imposed by 
the device tree, but by our _other_ semantics (IOW, in this respect it's 
kind of like how we wanted pre-suspend and post-resume to be mirror images 
for other outside reasons).

So we'd actually have a "phase #3", but that phase wouldn't be visible to 
the devices themselves, it would be a 

	# Phase tree: make sure everything is resumed
	for_each_device() {
		read_lock(dev->lock);
		read_unlock(dev->lock);
	}

but as you can see, there's no actual device callbacks involved. It would 
be just the code device layer saying "ok, now I'm going to wait for all 
the devices to have finished their resume".

			Linus
