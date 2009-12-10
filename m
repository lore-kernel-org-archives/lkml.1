Return-Path: <linux-kernel-owner+w=401wt.eu-S1761704AbZLJXaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761704AbZLJXaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 18:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761561AbZLJXaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 18:30:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757023AbZLJXaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 18:30:12 -0500
Date: Thu, 10 Dec 2009 15:30:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912102040.11063.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912101507550.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912100018.19723.rjw@sisk.pl> <alpine.LFD.2.00.0912091835280.3560@localhost.localdomain> <200912102040.11063.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Dec 2009, Rafael J. Wysocki wrote:
> 
> OK, why don't you just say you won't merge anything that doesn't use rwsems

I did! Here's a quote (and it's pretty much the whole email, so it's not 
like it was hidden):

 - alpine.LFD.2.00.0912081309370.3560@localhost.localdomain:

   "Let me put this simply: I've told you guys how to do it simply, with 
    _zero_ crap. No "iterating over children". No games. No data structures. 
    No new infrastructure. Just a single new rwlock per device, and _trivial_ 
    code.

    So here's the challenge: try it my simple way first. I've quoted the code 
    about five million times already. If you _actually_ see some problems, 
    explain them. Don't make up stupid "iterate over each child" things. Don't 
    claim totally made-up "leads to difficulties". Don't make it any more 
    complicated than it needs to be.

    Keep it simple. And once you have tried that simple approach, and you 
    really can show why it doesn't work, THEN you can try something else.

    But before you try the simple approach and explain why it wouldn't work, I 
    simply will not pull anything more complex. Understood and agreed?"

And then later about completions:

 - alpine.LFD.2.00.0912081416470.3560@localhost.localdomain:

   "So I think completions should work, if done right. That whole "make the 
    parent wait for all the children to complete" is fine in that sense. And 
    I'll happily take such an approach if my rwlock thing doesn't work."

IOW, I'll happily take the completions version, but dammit, I refuse to 
take it when there is a simpler approach that does NOT need to iterate, 
and does NOT need to re-initialize the data structures each round etc.

That's what I've been arguing against the whole time. It started as 
arguing against complex and unnecessary infrastructure, and trying to show 
that it _can_ be done so much simpler using existing basic locking.

And I get annoyed when you guys continually seem to want to make it more 
complex than it needs to be. 

> > And this, for example, is pretty disgusting. Not only is that 
> > INIT_COMPLETION purely brought on by the whole problem with completions 
> > (they are fundamentally one-shot, but you want to use them over and over
> 
> Actually, twice.  However, since I don't want to do any async handling in the
> _noirq phases any more, I can get rid of this whole function.  Thanks for
> pointing that out to me.

Well, my point was that you'll need to do that

	INIT_COMPLETION(dev->power.completion);

thing each suspend and each resume. Exactly because completions are 
designed to be "onw-way" things, so you end up having to reset them each 
cycle (you just reset them even _more_ than you needed).

Again, my point was that using locks is actually a very _natural_ thing to 
do. I really don't understand what problems you and Alan have with just 
using locks - we have way more locks in the kernel than we have 
completions, so they are the "default" thing to do, and they really are 
very natural to use.

[ Ok, so admittedly the actual use of 'struct rw_semaphore' is pretty 
  unusual, but my point is that people are used to locking semantics in 
  general, more so than the semantics of completions ]

Completions were literally designed to be used for one-off things - one of 
the most common uses is that the 'struct completion' is on the _stack_. It 
doesn't get much more one-off than that - and the completions are really 
very explicitly designed so that you can do a 'complete()' on something 
that will literally disappear from under you as you do it (because the 
struct completion might be on the stack of the thing that is waiting for 
it, and gets de-allocated when the waiter goes ahead).

That is why 'wait_for_completion()' always has to take the spinlock, for 
example - there is no fastpath for completion, because the races for the 
waiter releasing things too early are too nasty.

So completions are actually very subtle things - and you don't need any of 
that subtlety. I realize that from a user perspective, completions look 
very simple, but in many ways they actually have subtler semantics than a 
regular lock has.

			Linus
