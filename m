Return-Path: <linux-kernel-owner+w=401wt.eu-S1751703AbYKMJYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbYKMJYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 04:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbYKMJXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 04:23:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46884 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbYKMJXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 04:23:47 -0500
Date: Thu, 13 Nov 2008 10:23:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function
	return tracer lockless
Message-ID: <20081113092340.GJ25479@elte.hu>
References: <491B4F0A.3080901@gmail.com> <20081112221552.GA6125@elte.hu> <c62985530811130050q58be3f58rcef08a61b5a584a3@mail.gmail.com> <20081113085551.GF25479@elte.hu> <c62985530811130116v60d46c85j7f74230e1545eaaf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811130116v60d46c85j7f74230e1545eaaf@mail.gmail.com>
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
> >
> > * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
> >
> >> BTW I'm wondering about consistency in time capturing. When I look
> >> into kernel/sched_clock.c I see this in introduction:
> >>
> >> "The clock: sched_clock_cpu() is monotonic per cpu, and should be
> >> somewhat consistent between cpus (never more than 2 jiffies
> >> difference)."
> >>
> >> Two Jiffies, that could result in a lot of inconsistency in the way
> >> of nanosec capturing. The current task can be preempted between the
> >> call time and the return time and I'm doing a
> >> cpu_clock(raw_smp_processor_id) on these two times. Should I keep
> >> the same processor_id for these two captures? But what would happen
> >> if this cpu is shut down between these two times? One other solution
> >> would be to plan time capture in usec but I would mostly lose the
> >> interest of function cost measuring....
> >>
> >> What do you think?
> >
> > in practice the jitter is much lower - a couple of microseconds - up
> > to a few dozen at most.
> >
> > But it's a possibility, and i think the best solution is something
> > that Steve suggested yesterday: a /debug/tracing/trace_options flag
> > that turns on global ordering for tracing timestamps. Something like:
> >
> >  echo global_timestamps > /debug/tracing/trace_options
> >
> > tracers could also change the default of this flag. The function-cost
> > tracer will probably want to default to globally synchronous
> > timestamps, while the preempt and irqsoff tracers want to default to
> > local timestamps only.
> >
> > Would something like this work for you?
> >
> >        Ingo
> >
> 
> 
> But I guess this flag would apply on the timestamp inserted by the 
> ring-buffer. Unfortunately I can't use it since I have to capture 
> the clock for two times and not only during insertion in the 
> ring-buffer.

i think the clock should be a property of the tracer, not of the ring 
buffer. Hence if a tracer has the option set, it will get coherent 
timestamps - including ringbuffer insertion timestamps.

	Ingo
