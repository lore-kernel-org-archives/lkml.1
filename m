Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZAWLCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZAWLCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 06:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761876AbZAWLAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 06:00:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34876 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761798AbZAWLAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 06:00:47 -0500
Date: Fri, 23 Jan 2009 12:00:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] tracing/function-graph-tracer: various fixes
	and features
Message-ID: <20090123110037.GI15188@elte.hu>
References: <497917b5.09cc660a.5f4c.ffffc568@mx.google.com> <20090123101949.GD15188@elte.hu> <c62985530901230236v4a8f5d6od80924cb6542d994@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530901230236v4a8f5d6od80924cb6542d994@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> > Still needs a solution - if we do cross-CPU traces we want to have a 
> > global trace clock with 'seemless' transition between CPUs.
> 
> So it doesn't only need a monotonic clock. It needs a global consistent 
> clock like ktime for example? Unfortunately this one uses seq_locks and 
> would add some drawbacks like verifying if the traced function doesn't 
> hold the write seq_lock and it will bring some more ftrace recursion...

using ktime_get() is indeed out of question - GTOD callpaths are too 
complex (and also too slow).

I'd not change anything in the current logic, but i was thinking of a new 
trace_option, which can be set optionally. If that trace option is set 
then this bit of ring_buffer_time_stamp():

        time = sched_clock() << DEBUG_SHIFT;

gets turned into:

        time = cpu_clock(cpu) << DEBUG_SHIFT;

This way we default to sched_clock(), but also gain some 'global' 
properties if the trace_option is set.

Furthermore, another trace_option could introduce a third 'strongly 
ordered' trace-clock variant, which would use cmpxchg and per cpu 
timestamps, something like this:

atomic64_t curr_time;

DEFINE_PER_CPU(u64, prev_cpu_time);
...

retry:
	prev_cpu_time = per_cpu(prev_cpu_time, cpu);
	cpu_time = sched_clock();
	old_time = atomic64_read(&curr_time);

	delta = cpu_time - prev_cpu_time;
	if (unlikely((s64)delta <= 0))
		delta = 1;

	new_time = old_time + delta;

	if (atomic64_cmpxchg(&curr_time, old_time, new_time) != new_time)
		goto repeat;

        time = new_time << DEBUG_SHIFT;

This would be a monotonic, global clock wrapped around sched_clock(). It 
uses a cmpxchg to achieve it, but we have to use global ordering anyway. 

It would still be _much_ faster than any GTOD clocksource we have.

Hm?

	Ingo
