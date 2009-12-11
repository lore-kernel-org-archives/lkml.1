Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbZLKDmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbZLKDmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 22:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbZLKDmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 22:42:09 -0500
Received: from netrider.rowland.org ([192.131.102.5]:50176 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756299AbZLKDmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 22:42:07 -0500
Date: Thu, 10 Dec 2009 22:42:11 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <alpine.LFD.2.00.0912101713440.3560@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912102155390.12136-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up front: This is my personal view of the matter.  Which probably isn't
of much interest to anybody, so I won't bother to defend these views or
comment any further on them.  The decision about what version to use is
up to the two of you.  The fact is, either implementation would get the 
job done.

On Thu, 10 Dec 2009, Linus Torvalds wrote:

> Completions really are "locks that were initialized to locked". That is, 
> in fact, how completions came to be: we literally used to use semaphores 
> for them, and the reason for completions is literally the magic lifetime 
> rules they have.
> 
> So when you do
> 
> 	INIT_COMPLETION(dev->power.completion);
> 
> that really is historically, logically, and conceptually exactly the same 
> thing as initializing a lock to the locked state. We literally used to do 
> it with the equivalent of
> 
> 	init_MUTEX_LOCKED()
> 
> way back when (well, except we didn't have mutexes back then, we had only 
> counting semaphores) and instead of "complete()", we had "up()" on the 
> semaphore to complete it.

You think of it that way because you have been closely involved in the
development of the various kinds of locks.  Speaking as an outsider who
has relatively little interest in the internal details, completions
appear simpler than rwsems.  Mostly because they have a smaller API:  
complete() (or complete_all()) and wait_for_completion() as opposed to
down_read(), up_read(), down_write(), and up_write().

> > Besides, suppose a device driver wants some off-tree constraints to be
> > satisfied.
> 
> .. and I've told you several times that we should simply not do such 
> devices asynchronously. At least not unless there is some _overriding_ 
> reason to. And so far, nobody has suggested anything even remotely 
> likely for that.

Agreed.  The fact that async non-tree suspend constraints are difficult 
with rwsems isn't a drawback if nobody needs to use them.

> > Well, why actually do we need to preserve the state of the data structure from
> > one cycle to another?  There's no need whatsoever.
> 
> My point is, with locks, none of that is necessary. Because they 
> automatically do the right thing.
> 
> By picking the right concept, you don't have any of those "oh, we need to 
> re-initialize things" issues. They just work.

That's true, but it's not entirely clear.  There are subtle questions
about what happens if you stop in the middle or a device gets
unregistered or registered in the middle.  They require careful thought
in both approaches.

Having to reinitialize a completion each time doesn't bother me.  It's 
merely an indication that each suspend & resume is independent of all 
the others.

> > I still don't think there are many places where locks are used in a way you're
> > suggesting.  I would even say it's quite unusual to use locks this way.
> 
> See above. It's what completions _are_.

This is almost a philosophical issue.  If each A_i must wait for some
B_j's, is the onus on each A_i to test the B_j's it's interested in?  
Or is the onus on each B_j to tell the A_i's waiting for it that they
may proceed?  As Humpty-Dumpty said, "The question is which is to be
master -- that's all".

> > Well, I guess your point is that the implementation of completions is much
> > more complicated that we really need, but I'm not sure if that really hurts.
> 
> No. The implementation of completions is actually pretty simple, exactly 
> because they have that spinlock that is required to protect them. 
> 
> That wasn't the point. The point was that locks are actually the "normal" 
> thing to use. 
> 
> You are arguing as if completions are somehow the simpler model. That's 
> simply not true. Completions are just a _special_case_of_locking_.

Doesn't that make them simpler by definition?  Special cases always 
have less to worry about than the general case.

> So why not just use regular locks instead, when it's actually the natural 
> way to do it, and results in simpler code?

Simpler but also more subtle, IMO.  If you didn't already know how the
algorithm worked, figuring it out from the code would be harder with
rwsems than with completions.  Partly because of the way readers and
writers exchange roles in suspend vs. resume, and partly because
sometimes devices lock themselves and sometimes they lock other
devices.  With completions each device has its own, and each device
waits for other devices' completions -- easier to keep track of 
mentally.

(I still think this whole readers vs. writers thing is a red herring.  
The essential property is that there are two opposing classes of lock
holders.  The fact that multiple writers can't hold the lock at the
same time whereas multiple readers can is of no importance; the
algorithm would work just as well if multiple writers _could_ hold the
lock simultaneously.)

Balancing the additional conceptual complexity of the rwsem approach is 
the conceptual simplicity afforded by not needing to check all the 
children.  To me this makes it pretty much a toss-up.

Alan Stern

