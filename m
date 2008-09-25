Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbYIYU5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbYIYU5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbYIYU4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:56:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34665 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982AbYIYU4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:56:50 -0400
Date: Thu, 25 Sep 2008 22:52:18 +0200
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
Message-ID: <20080925205218.GA8997@elte.hu>
References: <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com> <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org> <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu> <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org>
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

> On Thu, 25 Sep 2008, Ingo Molnar wrote:
> > 
> > You seem to dismiss that angle by calling my arguments bullshit, but 
> > i dont know on what basis you dismiss it. Sure, a feature and extra 
> > complexity _always_ has a robustness cost. If your argument is that 
> > we should move cpu_clock() to assembly to make it more dependable - 
> > i'm all for it.
> 
> Umm. cpu_clock() isn't even cross-cpu synchronized, and has actually 
> thrown away all the information that can make it so, afaik. At least 
> the comments say "never more than 2 jiffies difference"). You do 
> realize that if you want to order events across CPU's, we're not 
> talking about "jiffies" here, we're talking about 50-100 CPU _cycles_.

Steve got the _worst-case_ cpu_clock() difference down to 60 usecs not 
so long ago. It might have regressed since then, it's really hard to do 
it without cross-CPU synchronization.

( But it's not impossible, as Steve has proven it, because physical time
  goes on linearly on each CPU so we have a chance to do it: by
  accurately correlating the GTOD timestamps we get at to-idle/from-idle
  times to the TSC. )

And note that i'm not only talking about cross-CPU synchronization, i'm 
also talking about _single CPU_ timestamps. How do you get it right with 
TSCs via a pure postprocessing method? A very large body of modern CPUs 
will halt the TSC when they go into idle. (about 70% of the installed 
base or so)

Note, we absolutely cannot do accurate timings in a pure 
TSC-post-processing environment: unless you want to trace _every_ 
to-idle and from-idle event, which can easily be tens of thousands of 
extra events per seconds.

What we could do perhaps is a hybrid method:

 - save a GTOD+TSC pair at important events, such as to-idle and
   from-idle, and in the periodic sched_tick(). [ perhaps also save it 
   when we change cpufreq. ]

 - save the (last_GTOD, _relative_-TSC) pair in the trace entry

with that we have a chance to do good post-processed correlation - at 
the cost of having 12-16 bytes of timestamp, per trace entry.

Or we could upscale the GTOD to 'TSC time', at go-idle and from-idle. 
Which is rather complicated with cpufreq - which frequency do we want to 
upscale to if we have a box with three available frequencies? We could 
ignore cpufreq altogether - but then there goes dependable tracing on 
another range of boxes.

> You also ignore the early trace issues, and have apparently not used 
> it for FTRACE. [...]

i very much used early code tracing with ftrace in the past. In fact 
once i debugged and early boot hang that happened so early before 
_PRINTK_ was not functional yet (!).

So, to solve this bug, i hacked ftrace to use early_printk(), to print 
out the last 10,000 functions executed before the hang - and that's how 
i found the reason for the hang - i captured a huge trace via a serial 
console. It was dead slow to capture, but it worked and sched_clock() 
worked just fine in that kind of usecase as well.

[ Note that we added tracing/fastboot recently (for v2.6.28), to enable 
  the tracing of early boot code timings. Havent had a problem with it 
  yet on x86. ]

> [...] You also ignore the fact that without TSC, it goes into the same 
> "crap mode" that is appropriate for the scheduler, but totally useless 
> for tracing.

i havent used a TSC-less CPU in 10 years, i'm not sure i get this point 
of yours. (and IIRC the division by zero was exactly on such CPUs where 
we divided by cpu_khz - that's why it could even regress.)

note that sched_clock() will use the TSC whenever it is there physically 
- even if GTOD does not use it anymore.

> IOW, you say that I call your arguments BS without telling you why, 
> but that's just because you apparently cut out all the things I _did_ 
> tell you why about!
> 
> The fact is, people who do tracing will want better clocks - and have 
> gotten with other infrastructure - than you have apparently cared 
> about. You've worried about scheduler tracing, and you seem to want to 
> just have everybody use a simple but known-bad approach that was good 
> enough for you.

i wrote my first -pg/mcount based tracer about 11 years ago, to learn 
more about the kernel. I traced everything with it. I then used it to 
find performance bottlenecks in the kernel, and i used it to learn 
kernel internals - when i saw a function in the trace that i did not 
recognize, i read the source code.

Scheduler tracing came much later into the picture - the -pg tracer was 
written well _before_ it was used for latency tracing purposes. But it 
is indeed a pretty popular use of it. (but by no means the only one)

	Ingo
