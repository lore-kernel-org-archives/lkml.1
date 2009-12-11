Return-Path: <linux-kernel-owner+w=401wt.eu-S934314AbZLKWbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934314AbZLKWbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934293AbZLKWbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:31:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934274AbZLKWbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:31:37 -0500
Date: Fri, 11 Dec 2009 14:31:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912112311.08548.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912111415160.3922@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912110202.28536.rjw@sisk.pl> <alpine.LFD.2.00.0912101713440.3560@localhost.localdomain> <200912112311.08548.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Dec 2009, Rafael J. Wysocki wrote:
> 
> But fine, say we use the approach based on rwsems and consider suspend and
> the inner lock.  We acquire it using down_write(), because we want to wait for
> multiple other dirvers.  Now, in fact we could do literally
> 
> down_write(dev->power.rwsem);
> up_write(dev->power.rwsem);
> 
> because the lock doesn't really protect anything from anyone.  What it does is
> to prevent _us_ from doing something too early.  To me, personally, it's not a
> usual use of locks.

I agree that it's fairly unusual, but on the other hand, it's unusual only 
because you contrieved it to be.

If you instead do

	down_write(dev->power.rwsem);
	.. do the actual suspend ..
	up_write(dev->power.rwsem);

it doesn't look odd any more, does it? And while you don't _need_ to hold 
the power lock over the suspend call, it actually does make sense, and 
gives you some nicer guarantees.

For an example of the kinds of guarantees it would give you - I think that 
you might actually be able to do a partial suspend and then a resume 
without any other locks, and you'd know that just the per-device locking 
would already guarantee that no device is ever tried to resume before it 
has finished its asynchronous suspend.

Think about it.

In the completion model, the "async_synchronize_full()" will synchronize 
all async work, and as a result you think that you don't need that level 
of robustness from the locking itself.

But think about it this way: if you could abort a failed suspend, and 
start resuming devices immediately, without doing that 
"async_synchronize_full()" in between - simply because you know that the 
node locking itself will just "do the right thing".

To me, that's a sign of a _good_ design. Using a rwsem is simply just more 
robust and natural for the problem in question. Exactly because it's a 
real lock.

> > Don't try to make up problems. The _only_ subsystem we know wants this is 
> > USB, and we know USB is purely a tree.
> 
> Not really.
> 
> I've already said it once, but let me repeat.  Some device objects have those
> ACPI "shadow" device objects that represent the ACPI view of given "physical"
> device and have their own suspend and resume routines.  It turns out that
> these ACPI "shadow" devices have to be suspended after their "physical"
> counterparts and resumed before them, or else things beak really badly.
> I don't know the reason for that, I only verified it experimentally (I also
> don't like that design, but I didn't invent it and I have to live with it at
> least for now).  So if we don't enforce these constraints doing async
> suspend and resume, we won't be able to handle _any_ devices with those
> ACPI "shadow" things asynchronously.  Ever.  [That includes the majority
> PCI devices, at least the "planar" ones (which is unfortunate, but that's how
> it goes).]

So?

First off, you're wrong. It's not "ever". I'm happy to add complexity 
later, I just don't want to start out with a complex model. Adding 
complexity too early "just because we migth need it" is the wrong thing to 
do.

Secondly, I repeat: we don't want to do those PCI devices asynchronously 
anyway. You're again digging yourself deeper by just continually bringing 
up this total non-issue. I realize you did it for testing, but I'm serious 
when I say that we should limit these things as much as possible, rather 
than see it as an opportunity to do crazy things.

Solve the problem at hand _first_. Solve it as simply as you can. And hope 
that you never ever will need anything more complex.

				Linus
