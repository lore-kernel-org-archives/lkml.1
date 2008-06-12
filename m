Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbYFLT5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbYFLT5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbYFLT5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:57:14 -0400
Received: from www.tglx.de ([62.245.132.106]:43872 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbYFLT5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:57:14 -0400
Date: Thu, 12 Jun 2008 21:55:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ulrich Drepper <drepper@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5/5] futex: fix miss ordered wakeups
In-Reply-To: <1213286193.16459.53.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0806121802050.3193@apollo.tec.linutronix.de>
References: <20080611204916.271608740@mvista.com>  <20080611204917.523866467@mvista.com>  <alpine.LFD.1.10.0806121022250.3193@apollo.tec.linutronix.de>  <1213277402.16459.25.camel@localhost.localdomain>  <alpine.LFD.1.10.0806121533270.3193@apollo.tec.linutronix.de>
  <1213278286.16459.29.camel@localhost.localdomain>  <alpine.LFD.1.10.0806121636380.3193@apollo.tec.linutronix.de> <1213286193.16459.53.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008, Daniel Walker wrote:
> 
> On Thu, 2008-06-12 at 17:24 +0200, Thomas Gleixner wrote:
> > > Just because you don't use it, doesn't make it useless .. At least
> > > there's enough people asking for this that it warrants me writing it..
> > 
> > Which is not really a good technical reason to merge such a
> > patch. Your handwaving about "enough people" is just irrelevant. Are
> > you going to implement a root hole as well when enough people ask for
> > it ?
> 
> People asking for something is a very good reason to merge "features" ..
> You can like or dislike implementations , but that doesn't reflect on
> the nature of the feature.

Again, I have not yet seen a single request aside of yours. Who is
asking for that and what is the rationale for their request?

> > But there is also a Real Good technical reason why these patches are
> > going nowhere else than into /dev/null:
> > 
> >  your approach of hijacking blocked_on is fundamentaly wrong as it
> >  mixes kernel internal state with user space state.
> 
> It mixes kernel state with kernel state, not to mention each state is
> isolated from the others.

Wrong. The task is blocked on the user space futex and not on an in
kernel concurrency control. What's the isolation, the enum or the
union ? LOL.

The blocked_on mechanism is restricted to kernel internal concurrency
controls and while mutex and rt_mutex could share a common storage,
the user space futex can not. That would preclude to ever use a
(rt_)mutex in the futex code.

The reason is simple: A task can only be blocked on one concurrency
control, but it can be blocked on a user space futex and later on an
in kernel concurrency control.

Just get it. These are different concepts and do not mix at all.

> >  It will break in preempt-rt at the point when this state is set and
> >  the code blocks on a spinlock, which uses the rtmutex based sleeping
> >  spinlock implementation and overwrites blocked_on.
> 
> That's an intersting point, however "preempt-rt" is out of tree, so it's
> certainly not going be a reason to reject mainline changes.

It is a perfectly good reason, simply because we know that rt is on
the way to mainline and it would be pretty stupid to merge a change
with a questionable technical merit which needs to be reverted and
overhauled in the foreseeable future. Other not yet mainline features
/ changes coordinate as well to avoid wreckage like that.

Also putting on my preempt-rt hat I just wonder about your brashly
impertinence to expect that others clean up the mess you create.

> > If there would be a real good technical reason to fix this priority
> > ordering it could be done with less than 20 lines of code without
> > extra locking and wreckage waiting left and right, but I have not yet
> > seen a single convincing technical argument or a relevant use case
> > which might justify that.
>
> The technical reasons for including this are the same technical reasons
> why we want the waiters queued in priority order .. It's a requirement
> of posix, where many calls need the ordering and ultimately feed into
> the futex interface. So we have every reason to do the ordering
> correctly..

Making a halfways correct thing a bit more correct is not going to
reach full correctness. 

Also your interpretation of the POSIX requirement is very
questionable:

 "If there are threads blocked on the mutex object referenced by mutex
 when pthread_mutex_unlock() is called, resulting in the mutex
 becoming available, the scheduling policy shall determine which
 thread shall acquire the mutex."

So there is no explicit guarantee requirement AFAICT. "... the
scheduling policy shall determine ..." is a rather vague term which
has enough room for interpretation. 

My interpretation is, whoever has/gets the CPU will get the mutex. So
why should I care about the priority order correctness, which is only
incorrect in a corner case. Especially in a corner case which is not a
hot path in any sane application:

 It requires thread A to block on a futex together with other threads
 and thread B to adjust the priority of thread A while it is
 blocked.

This is definitely _NOT_ the common case in any application I'm aware
of.

If you think that this actually matters, then please stop your
handwaving and provide proof. I'm really keen to add the absurdities
of those use cases to my Ugly Code Museum.

Furthermore the rationale section says explicitely:

 "The mutex functions and the particular default settings of the mutex
 attributes have been motivated by the desire to not preclude fast,
 inlined implementations of mutex locking and unlocking."

This is another confirmation that the default pthread_mutex
implementation aims for performance and not for correctness.

We have an PI implementation which provides full correctness, so there
is no need to add artificial correctness to something which is by
default incorrect.

> If you have a 20 line fix for this then great tell me what it is..

I might write the patch once I can see a real world use case where
this actually matters.

Thanks,

	tglx
