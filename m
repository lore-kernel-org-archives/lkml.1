Return-Path: <linux-kernel-owner+w=401wt.eu-S1760926AbZLJPjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926AbZLJPjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 10:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZLJPjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 10:39:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34919 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbZLJPjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 10:39:15 -0500
Date: Thu, 10 Dec 2009 16:38:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
Message-ID: <20091210153845.GA28230@elte.hu>
References: <4B202778.4030801@am.sony.com>
 <20091210070800.GB16874@elte.hu>
 <20091210120332.GA5042@nowhere>
 <20091210141121.GB1436@elte.hu>
 <1260456803.2146.167.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260456803.2146.167.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2009-12-10 at 15:11 +0100, Ingo Molnar wrote:
> 
> > > > ftrace plugins were a nice idea originally and a clear 
> > > > improvement over existing alternatives, but now that we've got a 
> > > > technicaly superior, unified event framework that can do what 
> > > > the old plugins did and much more, we want to improve that and 
> > > > not look back ...
> 
> Well to me the ftrace plugins still serve a purpose. The event 
> structures are very powerful for showing events. The plugins purpose 
> is to show functionality.
> 
> The latency tracers are a perfect example. Because they do not 
> concentrate on just events. But we must hit a maximum to save off the 
> trace. Just watching the events is not good enough. A separate buffer 
> to keep trace of the biggest latency is still needed.

The correctly designed way to express latency tracing is via a new 
generic event primitive: connecting two events to a maximum value.

That can be done without forcibly tying it and limiting it to a specific 
'latency tracing' variant as the /debug/tracing/ bits of ftrace do it 
right now.

Just off the top of my head we want to be able to trace:

 - max irq service latencies for a given IRQ
 - max block IO completion latencies for a app
 - max TLB flush latencies in the system
 - max sys_open() latencies in a task
 - max fork()/exit() latencies in a workload
 - max scheduling latencies on a given CPU
 - max page fault latencies
 - max wakeup latencies for a given task
 - max memory allocation latencies

 - ... and dozens and dozens of other things where there's a "start"
   and a "stop" event and where we want to measure the time between
   them.

Your design of tying latency tracing to some hardcoded 'ftrace plugin' 
abstraction is shortsighted and just does not scale to many of the items 
above.

> > > I agree. If we can abstract it out in a struct trace_event rather 
> > > than a struct tracer, then please try. I doubt we can't.
> > > 
> > > The trace events are more unified.
> 
> Yes because the trace events all pretty much do the same thing.
> 
> > > 
> > > This makes me feel I'm going to try converting the function graph 
> > > tracer into an event during the next cycle. [...]
> > 
> > Great!
> > 
> > > [...] It does not mean I could make it usable as a perf event right 
> > > away in the same shot that said, as you can guess this is not a 
> > > trivial plug. The current perf fast path is not yet adapted for that.
> > 
> > Yeah, definitely so. I'd guess it would be slower out of box - it hasnt 
> > gone through nearly as many refinements yet.
> > 
> > > But at least this will be a good step forward.
> > 
> > Yeah.
> > 
> > Also, i'd suggest we call unified events 'ftrace events', as that is 
> > what they really are: the whole TRACE_EVENT() infrastructure is the 
> > crown jewel of ftrace and IMO it worked out pretty well.
> 
> For recording events, yes I totally agree. But for logic that needs to 
> pass data from one event to another, it is still a bit lacking.

Expressing latency tracing in form of an 'ftrace plugin' is a pretty 
inefficient way of doing it: it's very limiting and its utility is much 
lower than what it could be.

> > I hope there wont be any significant culture clash between ftrace 
> > and perf - we want a single, unified piece of instrumentation 
> > infrastructure, we want to keep the best of both worlds, and want to 
> > eliminate any weaknesses and duplications. As long as we keep all 
> > that in mind it will be all fine.
> 
> I'm just not from the mind set that one product fits all needs. I 
> never was and that was the reason that I joined the Linux community in 
> the first place. I liked the old Unix philosophy of "Do one thing, and 
> do it well, and let all others interact, and interact with all 
> others". Ftrace itself never was one product. It just seemed that 
> anything to do with tracing was called ftrace. It started as just the 
> function tracer. Then it had plugins, then it got events, but these 
> are separate entities all together.
> 
> I designed the ftrace plugins as a way to plug in new features that I 
> could never dream of.
> 
> I wrote the ring buffer not for ftrace, but as a separate entity, that 
> is also used by the hard ware latency detector.
> 
> I designed the ftrace function tracer to not just work with ftrace but 
> to allow all others to hook to functions. This created the function 
> graph tracer, the stack tracer, and even LTTng hooks into it (not to 
> mention my own logdev).
> 
> I see that perf at the user level has ways to interact with it nicely, 
> although I don't know how well it interacts with other utilites. But 
> the perf kernel code seems to be a one way street. You can add 
> features to perf, but it is hard to use the perf infrastructure for 
> something other than perf (with the exception of the hardware perf 
> events, that part has a nice interface).

I see ftrace plugins as a step of evolution. If you see it as some 
ground to 'protect' then that's going to cause significant disagreement 
between us. I prefer to reimplement functionality in a better way and 
throw away the old version, and the whole premise of /debug is that we 
can throw away old versions of code.

If you want to keep inferior concepts under the guise of 'choice' then 
i'm very much against that. In the kernel we make up our minds about 
what the best technical solution is for a given range of problems, and 
then we go for it. Having a zillion mediocre xterms (and not a single 
good one) is not a development model i find too convincing.

	Ingo
