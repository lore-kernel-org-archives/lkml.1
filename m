Return-Path: <linux-kernel-owner+w=401wt.eu-S932624AbZLHQm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbZLHQm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 11:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZLHQmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 11:42:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756007AbZLHQmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 11:42:54 -0500
Date: Tue, 8 Dec 2009 08:42:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <Pine.LNX.4.44L0.0912081049010.3046-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0912080833170.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912081049010.3046-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Dec 2009, Alan Stern wrote:
> 
> The semantics needed for this kind of lock aren't really the same as
> for an rwsem (although obviously an rwsem will do the job).  Basically
> it needs to have the capability for multiple users to lock it (no
> blocking when acquiring a lock) and the capability for a user to wait
> until it is totally unlocked.  It could be implemented trivially using
> an atomic_t counter and a waitqueue head.
> 
> Is this a standard sort of lock?

Yes it is.

It's called a rwlock. The counter is for readers, the exclusion is for 
writers.

Really.

And the thing is, you actually do want the rwlock semantics, because on 
the resume side you want the parent to lock it for writing first (so that 
the children can wait for the parent to have completed its resume.

So we actually _want_ the full rwlock semantics. 

See the code I posted earlier. Here condensed into one email:

 - resume:

        usb_node_resume(node)
        {
		// Wait for parent to finish resume
                down_read(node->parent->lock);
		// .. before resuming outselves
                node->resume(node)

		// Now we're all done
                up_read(node->parent->lock);
                up_write(node->lock);
        }

	/* caller: */
	..
	// This won't block, because we resume parents before children,
	// and the children will take the read lock. 
        down_write(leaf->lock);
	// Do the blocking part asynchronously
        async_schedule(usb_node_resume, leaf);
	..

 - suspend:

        usb_node_suspend(node)
        {
                // Start our suspend. This will block if we have any
                // children that are still busy suspending (they will
                // have done a down_read() in their suspend).
                down_write(node->lock);
                node->suspend(node);
                up_write(node->lock);

                // This lets our parent continue
                up_read(node->parent->lock);
        }

	/* caller: */

	// This won't block, because we suspend nodes before parents
        down_read(node->parent->lock);
	// Do the part that may block asynchronously
	async_schedule(do_usb_node_suspend, node);

It really should be that simple. Nothing more, nothing less. And with the 
above, finishing the suspend (or resume) from interrupts is fine, and you 
don't have any new lock that has undefined memory ordering issues etc.

		Linus
