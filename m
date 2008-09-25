Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYIYVOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYIYVOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbYIYVOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:14:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39456 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbYIYVOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:14:44 -0400
Date: Thu, 25 Sep 2008 23:10:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080925211017.GA12689@elte.hu>
References: <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com> <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org> <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu> <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809251325450.3265@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809251325450.3265@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 25 Sep 2008, Linus Torvalds wrote:
> > 
> > You also ignore the early trace issues, and have apparently not used 
> > it for FTRACE. You also ignore the fact that without TSC, it goes 
> > into the same "crap mode" that is appropriate for the scheduler, but 
> > totally useless for tracing.
> 
> Oh, and I didn't notice (because Steven pointed out "notrace" and I 
> didn't see any of them), that in order to get things to work you had 
> just added
> 
> CFLAGS_REMOVE_lockdep.o = -pg
> CFLAGS_REMOVE_lockdep_proc.o = -pg
> CFLAGS_REMOVE_mutex-debug.o = -pg
> CFLAGS_REMOVE_rtmutex-debug.o = -pg
> CFLAGS_REMOVE_cgroup-debug.o = -pg
> CFLAGS_REMOVE_sched_clock.o = -pg
> CFLAGS_REMOVE_sched.o = -mno-spe -pg
> 
> all ovr the place, which was part of my argument against this crap in 
> the first place.

Really, we traced all these files for ages. I can restore it if it's 
worthwile - but lockdep totally kills the usability of function traces, 
it inserts thousands of uninteresting events over and over again.

Note commit c349e0a0, there i added -no-pg for robustness reasons (we 
locked up) - back then the scheduler clock was within sched.c. Now it is 
all separated out cleanly in kernel/sched_clock.o and i think we can add 
-pg to sched.o again and trace it.

> Yes, by using all that common infrastructure, you can share some code, 
> but you will always hit that case that now you have serious issues 
> with actually marking it. Now the tracer has to have recursion 
> detection if you ever want to trace any function that might be used 
> for the clock - and quite frankly, especially with virtualization, 
> it's not AT ALL obvious what those are all the time..

yes, that's true. And that's why we absolutely want to have recursion 
detection anyway - even given ftrace's _totally_ conservative design 
it's _very_ easy to accidentally recurse somewhere.

ftrace has the same robustness design as lockdep has: as little external 
infrastructure dependencies as possible. And lockdep has recursion 
checks too, and excessive amounts of paranoia all around the place.

Ftrace has the same robustness philosophy too, and yes, despite that we 
judged cpu_clock() to be worth the risk, because accurate and fast 
timestamps are a feature and we didnt want to duplicate.

If then i'd rather move towards simplifying sched_clock() even more - 
that's important for the scheduler too. The scheduler clock has _very_ 
similar requirements to the tracer clock.

> That is exactly one of the examples I gave for _not_ doing this. Go 
> back and read my previous emails. Rather than talking about how I call 
> your arguments BS without saying why.

we lived with these kinds of complications for years literally, and i'm 
not that stupid to not simplify a debugging framework when i can do it - 
and i'd not mind risk reduction. Paravirt is hugely misdesigned piece of 
PITA, for basically every piece of infrastructure that we have: locking, 
GTOD, lockdep, and yes, the tracer too.

So ... if you could suggest a method of how we could get good timestamps 
in a post-processed method with TSC timestamps, that would be great. 
That would solve all this discussion and i'm not going to argue against 
saving raw TSC timestamps, as they _are_ simpler and more robust.

	Ingo
