Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbZCQVtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbZCQVtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZCQVtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:49:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:15130 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZCQVtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:49:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cSb6IDfiisLVn8TR5qL53SILfcgIlaWOOu6zPySDGp2SSvYPlhuwtIixP3nuDrwXsE
         tff5RCRaWxYW9P4wTVI/mpyhDJkU2V+iXd9DeOVvbhZuBSSV1m9IpPk66rCztj9XrPJQ
         4pirD2LoICwzEZq9so7vNlPpuZ28uNcSi77FE=
Date: Tue, 17 Mar 2009 22:49:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: stop {irqs,preempt}soff tracers when
	tracing is stopped
Message-ID: <20090317214926.GA5137@nowhere>
References: <1237325938-5240-1-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0903171745440.9036@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903171745440.9036@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 05:46:14PM -0400, Steven Rostedt wrote:
> 
> 
> 
> On Tue, 17 Mar 2009, Frederic Weisbecker wrote:
> 
> > Impact: fix a selftest warning
> > 
> > In some cases, it's possible to see the following warning on irqsoff
> > tracer selftest:
> > 
> > [    4.640003] Testing tracer irqsoff: <4>------------[ cut here ]------------
> > [    4.653562] WARNING: at kernel/trace/trace.c:458 update_max_tr_single+0x9a/0xc4()
> > [    4.660000] Hardware name: System Product Name
> > [    4.660000] Modules linked in:
> > [    4.660000] Pid: 301, comm: kstop/1 Not tainted 2.6.29-rc8-tip #35837
> > [    4.660000] Call Trace:
> > [    4.660000]  [<4014b588>] warn_slowpath+0x79/0x8f
> > [    4.660000]  [<402d6949>] ? put_dec+0x64/0x6b
> > [    4.660000]  [<40162b56>] ? getnstimeofday+0x58/0xdd
> > [    4.660000]  [<40162210>] ? clocksource_read+0x3/0xf
> > [    4.660000]  [<4015eb44>] ? ktime_set+0x8/0x34
> > [    4.660000]  [<4014101a>] ? balance_runtime+0x8/0x56
> > [    4.660000]  [<405f6f11>] ? _spin_lock+0x3/0x10
> > [    4.660000]  [<4011f643>] ? ftrace_call+0x5/0x8
> > [    4.660000]  [<4015d0f1>] ? task_cputime_zero+0x3/0x27
> > [    4.660000]  [<40190ee7>] ? cpupri_set+0x90/0xcb
> > [    4.660000]  [<405f7208>] ? _spin_lock_irqsave+0x22/0x34
> > [    4.660000]  [<40190f12>] ? cpupri_set+0xbb/0xcb
> > [    4.660000]  [<405f7151>] ? _spin_unlock_irqrestore+0x23/0x35
> > [    4.660000]  [<4018493f>] ? ring_buffer_reset_cpu+0x27/0x51
> > [    4.660000]  [<405f7208>] ? _spin_lock_irqsave+0x22/0x34
> > [    4.660000]  [<40184962>] ? ring_buffer_reset_cpu+0x4a/0x51
> > [    4.660000]  [<405f7151>] ? _spin_unlock_irqrestore+0x23/0x35
> > [    4.660000]  [<4018cc29>] ? trace_hardirqs_off+0x1a/0x1c
> > [    4.660000]  [<405f7151>] ? _spin_unlock_irqrestore+0x23/0x35
> > [    4.660000]  [<40184962>] ? ring_buffer_reset_cpu+0x4a/0x51
> > [    4.660000]  [<401850f3>] ? cpumask_next+0x15/0x18
> > [    4.660000]  [<4018a41f>] update_max_tr_single+0x9a/0xc4
> > [    4.660000]  [<4014e5fe>] ? exit_notify+0x16/0xf2
> > [    4.660000]  [<4018cd13>] check_critical_timing+0xcc/0x11e
> > [    4.660000]  [<4014e5fe>] ? exit_notify+0x16/0xf2
> > [    4.660000]  [<4014e5fe>] ? exit_notify+0x16/0xf2
> > [    4.660000]  [<4018cdf1>] stop_critical_timing+0x8c/0x9f
> > [    4.660000]  [<4014e5c4>] ? forget_original_parent+0xac/0xd0
> > [    4.660000]  [<4018ce3a>] trace_hardirqs_on+0x1a/0x1c
> > [    4.660000]  [<4014e5c4>] forget_original_parent+0xac/0xd0
> > [    4.660000]  [<4014e5fe>] exit_notify+0x16/0xf2
> > [    4.660000]  [<4014e8a5>] do_exit+0x1cb/0x225
> > [    4.660000]  [<4015c72b>] ? kthread+0x0/0x69
> > [    4.660000]  [<4011f61d>] kernel_thread_helper+0xd/0x10
> > [    4.660000] ---[ end trace a7919e7f17c0a725 ]---
> > [    4.660164] .. no entries found ..FAILED!
> > 
> > During the selftest of irqsoff tracer, we do that:
> > 
> > 	/* disable interrupts for a bit */
> > 	local_irq_disable();
> > 	udelay(100);
> > 	local_irq_enable();
> > 	/* stop the tracing. */
> > 	tracing_stop();
> > 	/* check both trace buffers */
> > 	ret = trace_test_buffer(tr, NULL);
> > 
> > If a callsite performs a new max delay with irqs off just after
> > tracing_stop, update_max_tr_single() -> ring_buffer_swap_cpu()
> > will be called with the buffers disabled by tracing_stop(), hence
> > the warning, then ring_buffer_swap_cpu() return -EAGAIN and
> > update_max_tr_single() complains.
> > 
> > Fix it by also stopping the tracer before stopping the tracing globally.
> > A similar situation can happen with preemptoff and preemptirqsoff tracers
> > where we apply the same fix.
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/trace/trace_selftest.c |   26 ++++++++++++++++++++++++++
> >  1 files changed, 26 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> > index a2ca6f0..38856ba 100644
> > --- a/kernel/trace/trace_selftest.c
> > +++ b/kernel/trace/trace_selftest.c
> > @@ -315,6 +315,14 @@ trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
> >  	local_irq_disable();
> >  	udelay(100);
> >  	local_irq_enable();
> > +
> > +	/*
> > +	 * Stop the tracer to avoid a warning subsequent
> > +	 * to buffer flipping failure because tracing_stop()
> > +	 * disables the tr and max buffers, making flipping impossible
> > +	 * in case of parallels max irqs off latencies.
> > +	 */
> > +	trace->stop(tr);
> >  	/* stop the tracing. */
> >  	tracing_stop();
> >  	/* check both trace buffers */
> > @@ -369,6 +377,14 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
> >  	preempt_disable();
> >  	udelay(100);
> >  	preempt_enable();
> > +
> > +	/*
> > +	 * Stop the tracer to avoid a warning subsequent
> > +	 * to buffer flipping failure because tracing_stop()
> > +	 * disables the tr and max buffers, making flipping impossible
> > +	 * in case of parallels max preempt off latencies.
> > +	 */
> > +	trace->stop(tr);
> >  	/* stop the tracing. */
> >  	tracing_stop();
> 
> I'm actually thinking that tracing_stop() should call the current tracer
> "stop" function.
> 
> -- Steve


Indeed, it could be better.
But I think of a combination of stop() callback call plus
ring buffer disabled because I'm not sure all tracers implement
the stop callback.

Should I send a v2 based on the above?
 
> >  	/* check both trace buffers */
> > @@ -428,6 +444,13 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
> >  	/* reverse the order of preempt vs irqs */
> >  	local_irq_enable();
> >  
> > +	/*
> > +	 * Stop the tracer to avoid a warning subsequent
> > +	 * to buffer flipping failure because tracing_stop()
> > +	 * disables the tr and max buffers, making flipping impossible
> > +	 * in case of parallels max irqs/preempt off latencies.
> > +	 */
> > +	trace->stop(tr);
> >  	/* stop the tracing. */
> >  	tracing_stop();
> >  	/* check both trace buffers */
> > @@ -448,6 +471,8 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
> >  	/* do the test by disabling interrupts first this time */
> >  	tracing_max_latency = 0;
> >  	tracing_start();
> > +	trace->start(tr);
> > +
> >  	preempt_disable();
> >  	local_irq_disable();
> >  	udelay(100);
> > @@ -455,6 +480,7 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
> >  	/* reverse the order of preempt vs irqs */
> >  	local_irq_enable();
> >  
> > +	trace->stop(tr);
> >  	/* stop the tracing. */
> >  	tracing_stop();
> >  	/* check both trace buffers */
> > -- 
> > 1.6.1
> > 
> > 

