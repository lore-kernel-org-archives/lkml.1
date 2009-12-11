Return-Path: <linux-kernel-owner+w=401wt.eu-S1762109AbZLKBCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762109AbZLKBCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757766AbZLKBCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:02:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60623 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849AbZLKBCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:02:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Fri, 11 Dec 2009 02:02:28 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912102040.11063.rjw@sisk.pl> <alpine.LFD.2.00.0912101507550.3560@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912101507550.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912110202.28536.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 December 2009, Linus Torvalds wrote:
> 
> On Thu, 10 Dec 2009, Rafael J. Wysocki wrote:
...
> 
> IOW, I'll happily take the completions version, but dammit, I refuse to 
> take it when there is a simpler approach that does NOT need to iterate, 
> and does NOT need to re-initialize the data structures each round etc.

I don't think it really is that simple.  For example, the fact that the outer
lock has to be taken by one thread and released by another is not exactly
straightforward.  [One might ask what's the critical section in this case.]

Besides, suppose a device driver wants some off-tree constraints to be
satisfied.  What's the driver writer supposed to do?  He only can lock the
other device, but that will cause lockdep to complain, because this lock
is going to be nested.  Moreover, it's already too late, because his async
thread has started and there's no guarantee that the other device hasn't
acquired its rwsem yet.

With completions, the driver doesn't have to take any action to prevent another
one from suspending too early.  Instead, the other one has to wait for its
suspend to complete, and for me personally this is a much more natural thing
to do.  IOW, if I were a driver writed, I'd probably prefer to wait on a
completion than to use a lock in a tricky manner.

> That's what I've been arguing against the whole time. It started as 
> arguing against complex and unnecessary infrastructure, and trying to show 
> that it _can_ be done so much simpler using existing basic locking.
> 
> And I get annoyed when you guys continually seem to want to make it more 
> complex than it needs to be. 
> 
> > > And this, for example, is pretty disgusting. Not only is that 
> > > INIT_COMPLETION purely brought on by the whole problem with completions 
> > > (they are fundamentally one-shot, but you want to use them over and over
> > 
> > Actually, twice.  However, since I don't want to do any async handling in the
> > _noirq phases any more, I can get rid of this whole function.  Thanks for
> > pointing that out to me.
> 
> Well, my point was that you'll need to do that
> 
> 	INIT_COMPLETION(dev->power.completion);
> 
> thing each suspend and each resume. Exactly because completions are 
> designed to be "onw-way" things, so you end up having to reset them each 
> cycle (you just reset them even _more_ than you needed).

Well, why actually do we need to preserve the state of the data structure from
one cycle to another?  There's no need whatsoever.

> Again, my point was that using locks is actually a very _natural_ thing to 
> do. I really don't understand what problems you and Alan have with just 
> using locks - we have way more locks in the kernel than we have 
> completions, so they are the "default" thing to do, and they really are 
> very natural to use.
> 
> [ Ok, so admittedly the actual use of 'struct rw_semaphore' is pretty 
>   unusual, but my point is that people are used to locking semantics in 
>   general, more so than the semantics of completions ]

I still don't think there are many places where locks are used in a way you're
suggesting.  I would even say it's quite unusual to use locks this way.

> Completions were literally designed to be used for one-off things - one of 
> the most common uses is that the 'struct completion' is on the _stack_. It 
> doesn't get much more one-off than that - and the completions are really 
> very explicitly designed so that you can do a 'complete()' on something 
> that will literally disappear from under you as you do it (because the 
> struct completion might be on the stack of the thing that is waiting for 
> it, and gets de-allocated when the waiter goes ahead).

We could literally throw away a completion after all of the potentially waiting
threads have finished their operations and then allocate it back again when
necessary.  We only need the synchronization in this particular phase of
suspend or resume and it doesn't need to extend to the other phases or other
cycles, because all of the concurrent threads we need to synchronize will
only live during this one particular phase of suspend or resume.  They will
all exit when it's finished anyway.

> That is why 'wait_for_completion()' always has to take the spinlock, for 
> example - there is no fastpath for completion, because the races for the 
> waiter releasing things too early are too nasty.
> 
> So completions are actually very subtle things - and you don't need any of 
> that subtlety. I realize that from a user perspective, completions look 
> very simple, but in many ways they actually have subtler semantics than a 
> regular lock has.

Well, I guess your point is that the implementation of completions is much
more complicated that we really need, but I'm not sure if that really hurts.

Rafael
