Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006Ab0AMQaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab0AMQaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224Ab0AMQaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:30:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:48295 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab0AMQaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:30:13 -0500
Subject: Re: [PATCH] perf_events: improve x86 event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, perfmon2-devel@lists.sf.net,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <bd4cb8901001130154p732672b6x56e758c1ab33a8e8@mail.gmail.com>
References: <4b4c761b.0338560a.1eaa.ffff824d@mx.google.com>
	 <1263312616.4244.153.camel@laptop>
	 <bd4cb8901001130154p732672b6x56e758c1ab33a8e8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 17:29:53 +0100
Message-ID: <1263400193.4244.238.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 10:54 +0100, Stephane Eranian wrote:

> > One concern I do have is the loss of error checking on
> > event_sched_in()'s event->pmu->enable(), that could be another
> > 'hardware' PMU like breakpoints, in which case it could fail.
> >
> Well, x86_pmu_enable() does return an error code, so it is up
> to the upper layer to handle the error gracefully and in particular
> in perf_ctx_adjust_freq().

> +static void event_sched_in(struct perf_event *event, int cpu)
> +{
> +       event->state = PERF_EVENT_STATE_ACTIVE;
> +       event->oncpu = cpu;
> +       event->tstamp_running += event->ctx->time - event->tstamp_stopped;
> +       if (is_software_event(event))
> +               event->pmu->enable(event);
> +}
> +
> +/*
> + * Called to enable a whole group of events.
> + * Returns 1 if the group was enabled, or -EAGAIN if it could not be.
> + * Assumes the caller has disabled interrupts and has
> + * frozen the PMU with hw_perf_save_disable.
> + *
> + * called with PMU disabled. If successful and return value 1,
> + * then guaranteed to call perf_enable() and hw_perf_enable()
> + */
> +int hw_perf_group_sched_in(struct perf_event *leader,
> +              struct perf_cpu_context *cpuctx,
> +              struct perf_event_context *ctx, int cpu)
> +{
> +       struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
> +       struct perf_event *sub;
> +       int assign[X86_PMC_IDX_MAX];
> +       int n, n0, ret;
> +
> +       n0 = cpuc->n_events;
> +
> +       n = collect_events(cpuc, leader, true);
> +       if (n < 0)
> +               return n;
> +
> +       ret = x86_schedule_events(cpuc, n, assign);
> +       if (ret)
> +               return ret;
> +
> +       /*
> +        * copy new assignment, now we know it is possible
> +        * will be used by hw_perf_enable()
> +        */
> +       memcpy(cpuc->assign, assign, n*sizeof(int));
> +
> +       cpuc->n_events = n;
> +       cpuc->n_added  = n - n0;
> +
> +       n = 1;
> +       event_sched_in(leader, cpu);
> +       list_for_each_entry(sub, &leader->sibling_list, group_entry) {
> +               if (sub->state != PERF_EVENT_STATE_OFF) {
> +                       event_sched_in(sub, cpu);
> +                       ++n;
> +               }
> +       }
> +       ctx->nr_active += n;
> +
> +       /*
> +        * 1 means successful and events are active
> +        * This is not quite true because we defer
> +        * actual activation until hw_perf_enable() but
> +        * this way we* ensure caller won't try to enable
> +        * individual events
> +        */
> +       return 1;
> +}

That most certainly looses error codes for all !is_x86_event() events in
the group.

So you either need to deal with that event_sched_in() failing, or
guarantee that it always succeeds (forcing software events only for
example).

