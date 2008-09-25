Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbYIYT4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbYIYT4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYIYTzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:55:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51375 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbYIYTzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:55:53 -0400
Date: Thu, 25 Sep 2008 21:55:22 +0200
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
Message-ID: <20080925195522.GA22248@elte.hu>
References: <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com> <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com> <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org>
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

> > Slight correction. You can annotate the function with "notrace" and 
> > that function will not be traced. So the "only be disabled on a 
> > per-file basis" statement is false.
> 
> Ok. It's still true that we absolutely don't want to add random 
> notrace markers to code just because it's shared with the scheduler. 

firstly, for the sake of full disclosure, the very first versions of the 
latency tracer (which, through hundreds of revisions, morphed into 
ftrace), used raw TSC timestamps.

I stuck to that simple design for a _long_ time because i shared your 
exact views about robustness and simplicity. But it was pure utter 
nightmare to get the timings right after the fact, and i got a _lot_ of 
complaints about the quality of timings, and i could never _trust_ the 
timings myself for certain types of analysis.

So i eventually went to the scheduler clock and never looked back.

So i've been there, i've done that. In fact i briefly tried to use the 
_GTOD_ clock for tracing - that was utter nightmare as well, because the 
scale and breath of the GTOD code is staggering.

cpu_clock() proved to be a good middle ground. I'm not a believer in any 
of this stuff, i just react to how things behave in practice, as none of 
this is really easy to get right from the theoretical angle.

... so we can certainly go back to the TSC again, i'll be the last one 
to complain about extra tracing performance and it will certainly make 
it less fragile. Maybe i was wrong in declaring that a dead end and it 
will work out fine. [ Worst-case we'll go back to the sched_clock() 
again, that will always be an easy option. ]

... and regarding sched.o's notrace marking, we have had functional -pg 
tracing of sched.o for ages, and we could enable it right now. We can 
trace inside the runqueue lock just fine. Note: we indeed have commit 
c349e0a0 that proves that this stuff can lock up.

But most notrace markings are not for robustness reasons at all. They 
have two purposes:

1) correctness. sched_clock() itself should be recursion free. (Even
   _that_ has a recursion check btw., so normally it shouldnt lock up - 
   it just wont produce very nice traces.)

2) we use notrace and -no-pg to filter out very high-frequency and
   mostly uninteresting debug function calls. lockdep.o is an example, 
   but sched.o was done due to that too. (and because sched.o had 
   sched_clock() bits - but that's now all in a separate file.)

They are marked notrace globally for performance and information density 
reasons - if you've ever seen lockdep graph walking in traces you'll 
know what i mean. But ftrace is robust enough to trace inside those 
places. We just dont want to by default.

> And "sched_clock()" is not a single function with just a few 
> well-defined places, nor are all versions of it at all appropriate for 
> tracing (the non-TSC ones are a total joke - it works for scheduling, 
> but not tracing. Same goes for the virtualized versions).

that's true. I'd not mind (at all) having an assembly version of 
cpu_clock() or so. Because, believe me, people absolutely depend on 
accurate and dependable timestamps, and i depend on them quite often 
when i use traces.

There are two reasons for that:

1) they want to understand the exact timings on a single CPU, often
   across multiple idle points. How do you propose we solve the
   TSC-stops-in-idle problem?

2) they want to understand timings and ordering of events on
   multiple CPUs. For example there's a suspected race condition and i'd
   like to see the order of events. With TSC post-processing i can tell
   you that it's almost impossible to reach the current ~1-10 usec
   cross-CPU timing accuracy.

Note that these usecases have proven to be _FAR_ more important in 
practice than 'to stream gobs of data to user-space', so we have to give 
a design answer to them.

If sched_clock() is broken then the kernel wont work anyway. And i never 
wanted to trace inside sched_clock() itself. If you want to, we can 
track TSCs and approximate time after the fact, but i can predict it to 
you right now that it's pretty stupid to do and we'll eventually have to 
fix it. Chances are that we'll end up with a parallel tracer clock 
implementation that will resemble sched_clock() in essence.

So i think the better approach is to introduce a trace_clock() that is 
based on the TSC and gives nanosec timestamps, and to make sched_clock() 
use _that_. I really think it's wrong to have two kinds of clocks in the 
system that share so many goals.

anyway ... we can do TSC based timestamps too, it will just be far less 
useful for the things _i_ used the tracer for in the past.

So ... i think that i understand 100% of your arguments (i've been 
there, i've done that), but i think that you understand only about 50% 
of my arguments. So we definitely need to talk more ;)

	Ingo
