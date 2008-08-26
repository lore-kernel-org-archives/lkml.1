Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbYHZViV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbYHZViV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 17:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbYHZViF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 17:38:05 -0400
Received: from www.tglx.de ([62.245.132.106]:48969 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbYHZViD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 17:38:03 -0400
Date: Tue, 26 Aug 2008 23:37:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
In-Reply-To: <200808262127.26803.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.1.10.0808262228030.3243@apollo.tec.linutronix.de>
References: <20080819103301.787700742@chello.nl> <200808261954.47987.nickpiggin@yahoo.com.au> <alpine.LFD.1.10.0808261219050.3243@apollo.tec.linutronix.de> <200808262127.26803.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008, Nick Piggin wrote:
> On Tuesday 26 August 2008 21:09, Thomas Gleixner wrote:
> > On Tue, 26 Aug 2008, Nick Piggin wrote:
> > > On Tuesday 26 August 2008 19:30, Ingo Molnar wrote:
> > > > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > > So... no reply to this? I'm really wondering how it's OK to break
> > > > > documented standards and previous Linux behaviour by default for
> > > > > something that it is trivial to solve in userspace? [...]
> > > >
> > > > I disagree
> > >
> > > Your arguments were along the line of:
> > >
> > > * It probably doesn't break anything (except we had somebody report
> > >   that it breaks their app)
> >
> > I'm a real-time oldtimer. An application which hogs the CPU for 9.9
> > seconds with SCHED_FIFO priority is just broken. It's broken beyond
> > all limits, whether POSIX allows to do that or Linux obeyed the
> > request of the braindamaged application design.
> 
> Oh with this much handwaving from you old timers I feel much better
> about it ;) I bet before the bug report and change to 10s, any
> application that hogged the CPU for more than 0.9 seconds was just
> broken too, right? But 10s is more than enough for everybody?

Well, we might have a public opinion poll, whether a system is
declared frozen after 1, 10 or 100 seconds. Even a one second
unresponsivness shows up on the kernel bugzilla and you request that
unlimited unresponsivness w/o a chance to debug it is the sane
default.

An one second RT CPU hog is just a broken application, nothing
else. Your precious customer use case is simply crap.

Real-time is about determinism and not about the allowance to fuck up
a system at will. If a system failed to prevent the fuckup once then
this is not at all a guarantee that it allows to do that forever.

Especially not in the Open Source space, where developers are still
allowed to use their brain and apply common sense to prevent such a
wreckage and abuse. Still, your not yet specified use case can
continue to do stupid things forever with the simple tweak that it
needs to declare itself broken by turning off the kernel sanity
checks.

> I may not be an old timer, but I can say the kernel is just broken
> if it deliberately deviates from standards to undocumented behaviour,
> and even more so if it changes from working to broken behaviour for
> reasons that can be worked around in userspace (eg. running a higher
> priority watchdog).

Right. I appreciate the nitpicking janitor of the most important POSIX
feature: 

"The unlimited right to monopolize the CPU for any given timeframe."

Get your brain together. Just because it worked before and POSIX
allows it is not an argument at all that it is something useful. If
you want to do this you still can do it by resetting the limit.

Your request to enforce that stupid and braindead behaviour on
everyone is simply annyoing.
 
> > > * If it does break something then they must be doing something stupid
> > >   (I refuted that because there are several legitimate ways to use rt
> > >   scheduling that is broken by this)
> > >
> > > * We have many other APIs and tools that don't conform to posix (why
> > >   is that a reason to break this one?)
> >
> > Simply because we use common sense instead of following every single
> > POSIX brainfart by the letter.
> 
> How is that a brainfart? It is simple, relatively unambiguous, and not
> arbitrary. You really say the POSIX specified behaviour is "a brainfart",
> but adding an arbitrary 10s throttle "but the process might be preempted
> and lose the CPU to a lower priority task if it uses 10s of consecutive
> CPU time" would eliminate that brainfart? I have to laugh.

No, I did not say that. All I said is that giving the normal and
common sense capable user/developer the chance to debug a runaway task
w/o rebooting the system via the power off button is a sensible and
useful default.

Your request to default to a possibly unusable system serves some yet
to be explained higher goal, which is definitely out of the scope of
common sense.

You still did not explain why this behaviour is useful and your
handwaving vs. some (probably closed source) customer application is
not an argument at all.

> > > * We should break the API to cater for stupid users and distros who
> > >   create local DoS and/or lock up their boxes (except this is trivial
> > >   to solve by setting sysctls or having a watchdog or using sysrq)
> >
> > For the vast majority of users and RT developers a sane default of
> > sanity measures is useful and sensible.
> 
> You seriously develop complex rt tasks without having at least a simple
> watchdog task?

Dude, don't tell me how to design and debug a real time system. 

It's not about me, but about the general usability and debuggability
of Linux even in extreme situations, e.g. an unvoluntary runaway task,
which we see even from time to time in bug reports. Having a sensible
default guard is helping in the common case and denying it is just a
selfserving attitude to keep some braindamaged customer niche
application alive. Linux and Open Source is not about the customer
application, it is about having a sane and safe environment for 99% of
the use cases. Your pretious CPU hog SCHED_FIFO application is an
engineering brainfart which is really not relevant to any community
decision of a sane and per default safe guarded OS.

> > If someone wants to shoot himself in the foot then it's not an
> > unreasonable request that he needs to disable the safety guards before
> > pulling the trigger.
> 
> root is allowed to shoot themselves in the foot. root is the safeguard.

Sure. You are allowed to shoot yourself in the foot as well. Does the
gun manufacturer omit safety guards just because you are allowed to
and just because the 1990 version of the gun did not have that safety
guard ?

Again. Common sense is way more important than some green table
specification and some esoteric customer application.

Thanks,

	tglx

