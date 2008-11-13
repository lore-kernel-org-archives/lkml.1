Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbYKMS5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbYKMS5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 13:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYKMS5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 13:57:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53344 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYKMS5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 13:57:30 -0500
Date: Thu, 13 Nov 2008 19:57:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function
	return tracer lockless
Message-ID: <20081113185723.GC17851@elte.hu>
References: <20081112221552.GA6125@elte.hu> <c62985530811130050q58be3f58rcef08a61b5a584a3@mail.gmail.com> <20081113085551.GF25479@elte.hu> <c62985530811130116v60d46c85j7f74230e1545eaaf@mail.gmail.com> <20081113092340.GJ25479@elte.hu> <c62985530811130127u307c359fj4c4a9a778676ba4e@mail.gmail.com> <20081113094027.GK25479@elte.hu> <c62985530811130436s160e3983nd7debbb96cc971ae@mail.gmail.com> <20081113125419.GA32574@elte.hu> <c62985530811130926y656f8f4ancd592f26cdbbee6b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811130926y656f8f4ancd592f26cdbbee6b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/11/13 Ingo Molnar <mingo@elte.hu>:
> > "prev_global_time" also acts as a global serializer: it ensures that
> > events are timestamped in a monotonic and ordered way.
> >
> > i.e. something like this (pseudocode, without the cmpxchg):
> >
> >  u64 prev_global_time;
> >
> >  DEFINE_PER_CPU(prev_local_time);
> >
> >  u64 global_time()
> >  {
> >        u64 now, delta, now_global;
> >
> >        prev_global = prev_global_time;
> >        now = sched_clock();
> >        delta = now - per_cpu(prev_local_time, this_cpu);
> >        per_cpu(prev_local_time, this_cpu) = now;
> >
> >        now_global = prev_global + delta;
> >        prev_global = now_global;
> >
> >        return now_global;
> >  }
> >
> > note how we build "global time" out of "local time".
> >
> > The cmpxchg would be used to put the above one into a loop, and
> > instead of updating the global time in a racy way:
> >
> >        prev_global = now_global;
> >
> > We'd update it via the cmpxchg:
> >
> >        atomic64_t prev_global_time;
> >
> >        ...
> >
> >        while (atomic64_cmpxchg(&prev_global_time,
> >                                 prev_global, now_global) != prev_global) {
> >                [...]
> >        }
> >
> > To make sure the global time goes monotonic. (this way we also avoid a
> > spinlock - locks are fragile for instrumentation)
> 
> Ok, I understand better.
> But consider the following:
> 
>  u64 global_time()
>  {
>        u64 now, delta, now_global;
>        prev_global = prev_global_time;
> 
>        while (atomic64_cmpxchg(&prev_global_time,
>                                  prev_global, now_global) != prev_global) {
> 
>            now = sched_clock();
>            delta = now - per_cpu(prev_local_time, this_cpu);
>            per_cpu(prev_local_time, this_cpu) = now;
>            now_global = prev_global + delta;
>            prev_global = now_global;
>        }
>        return now_global;
>  }
> 
> Sarting with prev_global_time = 0 If we have two cpu and the above 
> function is executed 5 times on the first cpu. We couldl have 
> per_cpu(prev_local_time) = 50 for example. And so prev_global_time 
> will be equal to 50.
> 
> Just after that, almost at the same time, cpu2 calls global_time()
> 
> delta will be equal to 50 (sched_clock() - per_cpu(prev_local_time) 
> which is 0) and prev_global_time will be 50 + 50 = 100. This is not 
> consistent. I don't know where but I'm pretty sure I missed 
> something....

you are right - it needs a bit more logic.

I think the simplest would be something like this:

 atomic64_t global_clock = INIT_ATOMIC64(0);

 u64 global_time()
 {
	u64 now, delta, now_global, prev_global;

	do {
		prev_global = atomic64_read(&global_clock);
		now = cpu_clock(raw_smp_processor_id());

		if ((s64)(now - prev_global) < 0) {
			now = prev_global;
			break;
		}
	} while (atomic64_cmpxchg(&global_clock,
				   prev_global, now) != prev_global);
 
	return now;
 }

This is the simplest way of implementing monotonic time: we only allow 
global_clock to go forwards. If all cpu_clock()s are perfectly in 
sync, we've got no problem: then "now - prev_global" will never be 
negative and we can return the local clock as the latest global time.

But if one of the CPU clocks is "behind", the function returns the 
latest global time up until the local clock catches up. Time wont be 
allowed to jump around by going back. If the clock is behind for a 
long time, then we get a lot of timestamps with the same value - that 
will be very visible in the trace and we'll then work in improving the 
cpu_clock() implementation.

So i think we could start with this simplest approach, and see how 
often we get the same timestamp for a long time (indication of the 
clocks being not perfectly in sync).

	Ingo
