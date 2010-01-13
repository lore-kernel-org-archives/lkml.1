Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091Ab0AMQwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab0AMQwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067Ab0AMQwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:52:36 -0500
Received: from smtp-out.google.com ([216.239.44.51]:8159 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab0AMQwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:52:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Rn/4TtJqKDZJvbXlT5zGdmkU8VhmsnY+CgY+0t6mOQ7Sj/9XVvHxutJXyDLr0JMhN
	qI9QZODokE/rSm5LUSuMg==
MIME-Version: 1.0
In-Reply-To: <1263400193.4244.238.camel@laptop>
References: <4b4c761b.0338560a.1eaa.ffff824d@mx.google.com>
	 <1263312616.4244.153.camel@laptop>
	 <bd4cb8901001130154p732672b6x56e758c1ab33a8e8@mail.gmail.com>
	 <1263400193.4244.238.camel@laptop>
Date: Wed, 13 Jan 2010 17:52:30 +0100
Message-ID: <bd4cb8901001130852y1de007cbqe66d77605c1ec372@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve x86 event scheduling
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, perfmon2-devel@lists.sf.net,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 5:29 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-01-13 at 10:54 +0100, Stephane Eranian wrote:
>
>> > One concern I do have is the loss of error checking on
>> > event_sched_in()'s event->pmu->enable(), that could be another
>> > 'hardware' PMU like breakpoints, in which case it could fail.
>> >
>> Well, x86_pmu_enable() does return an error code, so it is up
>> to the upper layer to handle the error gracefully and in particular
>> in perf_ctx_adjust_freq().
>
>> +static void event_sched_in(struct perf_event *event, int cpu)
>> +{
>> +       event->state = PERF_EVENT_STATE_ACTIVE;
>> +       event->oncpu = cpu;
>> +       event->tstamp_running += event->ctx->time - event->tstamp_stopped;
>> +       if (is_software_event(event))
>> +               event->pmu->enable(event);
>> +}
>> +
>> +/*
>> + * Called to enable a whole group of events.
>> + * Returns 1 if the group was enabled, or -EAGAIN if it could not be.
>> + * Assumes the caller has disabled interrupts and has
>> + * frozen the PMU with hw_perf_save_disable.
>> + *
>> + * called with PMU disabled. If successful and return value 1,
>> + * then guaranteed to call perf_enable() and hw_perf_enable()
>> + */
>> +int hw_perf_group_sched_in(struct perf_event *leader,
>> +              struct perf_cpu_context *cpuctx,
>> +              struct perf_event_context *ctx, int cpu)
>> +{
>> +       struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
>> +       struct perf_event *sub;
>> +       int assign[X86_PMC_IDX_MAX];
>> +       int n, n0, ret;
>> +
>> +       n0 = cpuc->n_events;
>> +
>> +       n = collect_events(cpuc, leader, true);
>> +       if (n < 0)
>> +               return n;
>> +
>> +       ret = x86_schedule_events(cpuc, n, assign);
>> +       if (ret)
>> +               return ret;
>> +
>> +       /*
>> +        * copy new assignment, now we know it is possible
>> +        * will be used by hw_perf_enable()
>> +        */
>> +       memcpy(cpuc->assign, assign, n*sizeof(int));
>> +
>> +       cpuc->n_events = n;
>> +       cpuc->n_added  = n - n0;
>> +
>> +       n = 1;
>> +       event_sched_in(leader, cpu);
>> +       list_for_each_entry(sub, &leader->sibling_list, group_entry) {
>> +               if (sub->state != PERF_EVENT_STATE_OFF) {
>> +                       event_sched_in(sub, cpu);
>> +                       ++n;
>> +               }
>> +       }
>> +       ctx->nr_active += n;
>> +
>> +       /*
>> +        * 1 means successful and events are active
>> +        * This is not quite true because we defer
>> +        * actual activation until hw_perf_enable() but
>> +        * this way we* ensure caller won't try to enable
>> +        * individual events
>> +        */
>> +       return 1;
>> +}
>
> That most certainly looses error codes for all !is_x86_event() events in
> the group.
>
> So you either need to deal with that event_sched_in() failing, or
> guarantee that it always succeeds (forcing software events only for
> example).
>
True, but that one can be fixed because it is only called from
hw_perf_group_sched_in() which returns an error code.

The same code would have to be fixed on PPC as well.

>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
