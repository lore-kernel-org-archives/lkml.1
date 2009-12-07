Return-Path: <linux-kernel-owner+w=401wt.eu-S935447AbZLGQzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935447AbZLGQzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757954AbZLGQzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:55:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935437AbZLGQzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:55:50 -0500
Date: Mon, 7 Dec 2009 08:55:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <alpine.LFD.2.00.0912070737150.3560@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0912070841250.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912071003270.3064-100000@iolanthe.rowland.org> <alpine.LFD.2.00.0912070737150.3560@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Dec 2009, Linus Torvalds wrote:
> 
> And during phase #1, C and Q won't do anything at all. We _could_ do them 
> during this phase, and it would actually all work out fine, but we 
> wouldn't want to do that for a simple reason: we _want_ the pre_suspend 
> and post_resume phases to be total mirror images, because if we end up 
> doing error handling for the pre-suspend case, then the post-resume phase 
> would be the "fixup" for it, so we actually want leaf things to happen 
> during phase #2 - not because it would screw up locking or ordering, but 
> because of other issues.

Ho humm.

This part made me think. Since I started mulling over the fact that we 
could do the resume thing in a single phase (and really only wanted the 
second phase in order to be a mirror image to the suspend), I started 
thinking that we could perhaps do even the suspend with a single phase, 
and avoid introducing that pre-suspend/post-resume phase at all.

And now that I think about it, we can do that by simply changing the 
locking just a tiny bit.

I originally envisioned that two-pase suspend because I was thinking that 
the first phase would start off the suspend, and the second phase would 
finish it, but we can actually do it all with a single phase that does 
both. So starting with just the regular depth-first post-ordering that is 
a suspend:

        suspend(root)
        {
                for_each_child(root)
			suspend(child);
		suspend_one_node(root)
        }

the rule would be that for something like USB that wants to do the suspend 
asynchronously, the node suspend routine would do

	usb_node_suspend(node)
	{
		// Make sure parent doesn't suspend: this will not block, 
		// because we'll call the 'suspend' function for all nodes
		// before we call it for the parent.
		down_read(node->parent->lock);

		// Do the part that may block asynchronously
		async_schedule(do_usb_node_suspend, node);
	}

	do_usb_node_suspend(node)
	{
		// Start out suspend. This will block if we have any
		// children that are still busy suspending (they will
		// have done a down_read() in their suspend).
		down_write(node->lock);
		node->suspend(node);
		up_write(node->lock);

		// This lets our parent continue
		up_read(node->parent->lock);
	}

and it looks like we don't even need a second phase at all.

IOW, I think USB could do this on its own right now, with no extra 
infrastructure from the device layer AT ALL, except for one small thing: 
that new "rwsem" lock in the device data structure, and then we'd need the 
"wait for everybody to have completed" loop, ie

	for_each_dev(dev) {
		down_write(dev->lock);
		up_write(dev->lock);
	}

thing at the end of the suspend loop (same thing as I mentioned about 
resuming).

So I think even that whole two-phase thing was unnecessarily complicated.

		Linus
