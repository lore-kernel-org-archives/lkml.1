Return-Path: <linux-kernel-owner+w=401wt.eu-S1762493AbZLKWKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762493AbZLKWKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761496AbZLKWKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:10:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36891 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761489AbZLKWKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:10:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Fri, 11 Dec 2009 23:11:08 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912110202.28536.rjw@sisk.pl> <alpine.LFD.2.00.0912101713440.3560@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912101713440.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912112311.08548.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 December 2009, Linus Torvalds wrote:
> 
> On Fri, 11 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > I don't think it really is that simple.  For example, the fact that the outer
> > lock has to be taken by one thread and released by another is not exactly
> > straightforward.  [One might ask what's the critical section in this case.]
> 
> Why is that any different from initializing the completion in one thread, 
> and completing it in another?
> 
> It's exactly equivalent.
> 
> Completions really are "locks that were initialized to locked". That is, 
> in fact, how completions came to be: we literally used to use semaphores 
> for them, and the reason for completions is literally the magic lifetime 
> rules they have.

I don't know how they emerged historically and that's why I look a them in a
different way than you do, probably.

But fine, say we use the approach based on rwsems and consider suspend and
the inner lock.  We acquire it using down_write(), because we want to wait for
multiple other dirvers.  Now, in fact we could do literally

down_write(dev->power.rwsem);
up_write(dev->power.rwsem);

because the lock doesn't really protect anything from anyone.  What it does is
to prevent _us_ from doing something too early.  To me, personally, it's not a
usual use of locks.

Moreover, if you think completions should be treated like locks, the up_write()
above plays the role of the INIT_COMPLETION() in my last patch (or vice versa),
so we reinitialize the data structure to the previous state in this case too,
only earlier (and we could do that later just as well).

The only real drawback of using completions I can see is that we have to
iterate over the children during suspend, but if async suspend is going to save
us any time at all, we can easily afford it (resume with completions is
actually simpler than with rwsems, because we only have to wait for one device
each time).

> > Besides, suppose a device driver wants some off-tree constraints to be
> > satisfied.
> 
> .. and I've told you several times that we should simply not do such 
> devices asynchronously. At least not unless there is some _overriding_ 
> reason to. And so far, nobody has suggested anything even remotely 
> likely for that.
> 
> Again - KISS: Keep It Simple, Stupid!
> 
> Don't try to make up problems. The _only_ subsystem we know wants this is 
> USB, and we know USB is purely a tree.

Not really.

I've already said it once, but let me repeat.  Some device objects have those
ACPI "shadow" device objects that represent the ACPI view of given "physical"
device and have their own suspend and resume routines.  It turns out that
these ACPI "shadow" devices have to be suspended after their "physical"
counterparts and resumed before them, or else things beak really badly.
I don't know the reason for that, I only verified it experimentally (I also
don't like that design, but I didn't invent it and I have to live with it at
least for now).  So if we don't enforce these constraints doing async
suspend and resume, we won't be able to handle _any_ devices with those
ACPI "shadow" things asynchronously.  Ever.  [That includes the majority
PCI devices, at least the "planar" ones (which is unfortunate, but that's how
it goes).]

If we had a clean way of representing off-tree constraints during asynchronous
suspend and resume, we'd be able to handle this issue at the bus type level.

And even if we don't anticipate it right now, I think the iteration over
children during suspend is a fair price for a clean interface that bus types or
drivers can use in future.  YMMV.

> > Well, I guess your point is that the implementation of completions is much
> > more complicated that we really need, but I'm not sure if that really hurts.
> 
> No. The implementation of completions is actually pretty simple, exactly 
> because they have that spinlock that is required to protect them. 
> 
> That wasn't the point. The point was that locks are actually the "normal" 
> thing to use. 
> 
> You are arguing as if completions are somehow the simpler model.

That's because I think so.

> That's simply not true. Completions are just a _special_case_of_locking_.

Which doesn't necessarily prevent them from being conceptually simpler
that the locking scheme based on rwsems.

> So why not just use regular locks instead, when it's actually the natural 
> way to do it, and results in simpler code?

Well, to me, it's way not natural and, quite frankly, in my not so humble
opinion, it's a matter of personal preference.

But, since your personal preference is what matters in this case, I'm not
going to argue any more, because that just plain doesn't make sense.

So, if you're not fine with the last patch I sent
(http://patchwork.kernel.org/patch/66375/), I'll send one using rwsems instead
of completions just to make _you_ happy, not because I think that's what we
should do objectively.

Rafael
