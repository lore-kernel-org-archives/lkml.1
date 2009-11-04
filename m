Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbZKDMlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbZKDMlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755782AbZKDMlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:41:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53700 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690AbZKDMlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:41:44 -0500
Date: Wed, 4 Nov 2009 13:41:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Clark Williams <williams@redhat.com>
Cc: Jon Masters <jcm@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] perf latency builtin command
Message-ID: <20091104124118.GC11968@elte.hu>
References: <20091101155500.7dd22f19@torg> <20091101155809.191a7ed6@torg> <20091103192839.GB21023@elte.hu> <20091103160053.0f0dd357@torg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103160053.0f0dd357@torg>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Clark Williams <williams@redhat.com> wrote:

> > Basically hwlat_detector is using stop_machine_run() plus a tight 
> > rdtsc based loop to sample what is happening in the system. Much of 
> > hwlat_detector.c deals with getting that information (and 
> > parameters) back and forth between user space and kernel space.
> > 
> > Couldnt we move that functionality a bit closer to perf by creating 
> > special events in a tight loop that generate a stream of perf 
> > events, and let the rest of perf events take over the details, and 
> > do the analysis in the user-space builtin-latency.c code?
> >  
> > Also, do we need stop_machine_run() - couldnt we do the measurement 
> > on a specific CPU with irqs (and NMIs) disabled [but other CPUs 
> > still running]?
> 
> So what would the source of the event's be and how confident would we 
> be that they're accurate? Jon used stop_machine() so that *nothing* 
> under the control of Linux is going to happen during the test; no 
> C-state changes, no interrupts, nada. The intent is that if there's a 
> gap seen in the TSC values, it's because something happened that's out 
> of our control.

Yes - that goal is sensible. It could be achieved by running a long 
sampling period on all online CPUs, using SCHED_FIFO:99 priority, right?

What we need to enable this is a way to start a measurement period, 
which outputs its result(s) to a perf event channel.

A first hack could be an ioctl extension in 
kernel/perf_event.c:perf_ioctl(), PERF_EVENT_IOC_INJECT or so.

PERF_EVENT_IOC_INJECT would inject an artificial trace event into the 
kernel, with its parameters defined by user-space.

Initially (for a prototype) you could hardcode it to be purely hwlat 
specific - i.e. the parameters would directly turn into 'disable irqs, 
run a tight TSC loop, report results'.

See commit 8968f9d how to define a new event via TRACE_EVENT(). Once a 
hwlat tracepoint is defined, it could be triggered via:

  trace_hwlat_result(loops, max_delay, min_delay, sum_delay)

I.e. it would look like this (in the prototype), in 
kernel/perf_event.c:perf_ioctl():

	case PERF_EVENT_IOC_INJECT: {

		unigned long hwlat_loops = arg;

		local_irq_disable();
		t0 = get_cycles();
		for (i = 0; i < hwlat_loops; i++) {
			t1 = get_cycles();
			hwlat_delay = t1 - t0;
			hwlat_delay_max = max(hwlat_delay_max, hwlat_delay);
			...
		}

		local_irq_enable();

		trace_hwlat_report(hwlat_loops, hwlat_delay_max);
	}

Note how simple the structure is - one event, one callback that does the 
hwlat measurement loop - and a line to report the resuls. All the rest 
(buffering, enumeration, post-processing, etc.) can be done via using 
'perf latency' and existing perf facilities.

Note at the advantages: we'd have hwlat _and_ the tooling in the kernel 
as one package in essence. Makes for an easy pull request: it fits 
nicely into the existing scheme of things and anyone can run 'perf 
latency' to see what it is good for.

Can you see any fundamental problems with such an approach?

	Ingo
