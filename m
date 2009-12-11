Return-Path: <linux-kernel-owner+w=401wt.eu-S1762137AbZLKBZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762137AbZLKBZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761767AbZLKBZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:25:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759018AbZLKBZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:25:46 -0500
Date: Thu, 10 Dec 2009 17:25:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912110202.28536.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912101713440.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912102040.11063.rjw@sisk.pl> <alpine.LFD.2.00.0912101507550.3560@localhost.localdomain> <200912110202.28536.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Dec 2009, Rafael J. Wysocki wrote:
> 
> I don't think it really is that simple.  For example, the fact that the outer
> lock has to be taken by one thread and released by another is not exactly
> straightforward.  [One might ask what's the critical section in this case.]

Why is that any different from initializing the completion in one thread, 
and completing it in another?

It's exactly equivalent.

Completions really are "locks that were initialized to locked". That is, 
in fact, how completions came to be: we literally used to use semaphores 
for them, and the reason for completions is literally the magic lifetime 
rules they have.

So when you do

	INIT_COMPLETION(dev->power.completion);

that really is historically, logically, and conceptually exactly the same 
thing as initializing a lock to the locked state. We literally used to do 
it with the equivalent of

	init_MUTEX_LOCKED()

way back when (well, except we didn't have mutexes back then, we had only 
counting semaphores) and instead of "complete()", we had "up()" on the 
semaphore to complete it.

> Besides, suppose a device driver wants some off-tree constraints to be
> satisfied.

.. and I've told you several times that we should simply not do such 
devices asynchronously. At least not unless there is some _overriding_ 
reason to. And so far, nobody has suggested anything even remotely 
likely for that.

Again - KISS: Keep It Simple, Stupid!

Don't try to make up problems. The _only_ subsystem we know wants this is 
USB, and we know USB is purely a tree.

> > 	INIT_COMPLETION(dev->power.completion);
> > 
> > thing each suspend and each resume. Exactly because completions are 
> > designed to be "onw-way" things, so you end up having to reset them each 
> > cycle (you just reset them even _more_ than you needed).
> 
> Well, why actually do we need to preserve the state of the data structure from
> one cycle to another?  There's no need whatsoever.

My point is, with locks, none of that is necessary. Because they 
automatically do the right thing.

By picking the right concept, you don't have any of those "oh, we need to 
re-initialize things" issues. They just work.

> I still don't think there are many places where locks are used in a way you're
> suggesting.  I would even say it's quite unusual to use locks this way.

See above. It's what completions _are_.

> Well, I guess your point is that the implementation of completions is much
> more complicated that we really need, but I'm not sure if that really hurts.

No. The implementation of completions is actually pretty simple, exactly 
because they have that spinlock that is required to protect them. 

That wasn't the point. The point was that locks are actually the "normal" 
thing to use. 

You are arguing as if completions are somehow the simpler model. That's 
simply not true. Completions are just a _special_case_of_locking_.

So why not just use regular locks instead, when it's actually the natural 
way to do it, and results in simpler code?

		Linus
