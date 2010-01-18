Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246Ab0ARNnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab0ARNnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478Ab0ARNna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:43:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:12734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab0ARNna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:43:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m5+mKdNUy2WqiYAKx1+RG7qFmUhg2pbpLoW+5NxzH++RVXZejRPOdKjyLk2M7SW/Tj
         a33TDR/jphz9zIbS2+0DNazHYEBwnNgUokjZ9TG+8oJv5uKmcKDnMjvHArGt+gefyMJA
         4DIqoQQmTe1iey9a+SSVZ+7I7TkJa6DHPjFbw=
Date: Mon, 18 Jan 2010 14:43:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, perfmon2-devel@lists.sf.net,
       eranian@gmail.com
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
Message-ID: <20100118134324.GB10364@nowhere>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 10:58:01AM +0200, Stephane Eranian wrote:
> +int hw_perf_group_sched_in(struct perf_event *leader,
> +	       struct perf_cpu_context *cpuctx,
> +	       struct perf_event_context *ctx, int cpu)
> +{
> +	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
> +	struct perf_event *sub;
> +	int assign[X86_PMC_IDX_MAX];
> +	int n0, n1, ret;
> +
> +	/* n0 = total number of events */
> +	n0 = collect_events(cpuc, leader, true);
> +	if (n0 < 0)
> +		return n0;
> +
> +	ret = x86_schedule_events(cpuc, n0, assign);
> +	if (ret)
> +		return ret;
> +
> +	ret = x86_event_sched_in(leader, cpuctx, cpu);
> +	if (ret)
> +		return ret;
> +
> +	n1 = 1;
> +	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
> +		if (sub->state != PERF_EVENT_STATE_OFF) {
> +			ret = x86_event_sched_in(sub, cpuctx, cpu);
> +			if (ret)
> +				goto undo;
> +			++n1;
> +		}
> +	}
> +	/*
> +	 * copy new assignment, now we know it is possible
> +	 * will be used by hw_perf_enable()
> +	 */
> +	memcpy(cpuc->assign, assign, n0*sizeof(int));
> +
> +	cpuc->n_events  = n0;
> +	cpuc->n_added   = n1;
> +	ctx->nr_active += n1;
> +
> +	/*
> +	 * 1 means successful and events are active
> +	 * This is not quite true because we defer
> +	 * actual activation until hw_perf_enable() but
> +	 * this way we* ensure caller won't try to enable
> +	 * individual events
> +	 */
> +	return 1;
> +undo:
> +	x86_event_sched_out(leader, cpuctx, cpu);
> +	n0  = 1;
> +	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
> +		if (sub->state == PERF_EVENT_STATE_ACTIVE) {
> +			x86_event_sched_out(sub, cpuctx, cpu);
> +			if (++n0 == n1)
> +				break;
> +		}
> +	}
> +	return ret;



Looking at all these numerous places where this whole constraint
and ad hoc scheduling machine tries to catch up with what the
core can already do (handle non-x86 events, revert in failure,
first handle leader, then handle the rest, etc...), I wonder
if this hw_group_sched_in() based design is a good idea.

Shouldn't we actually use the core based pmu->enable(),disable()
model called from kernel/perf_event.c:event_sched_in(),
like every other events, where we can fill up the queue of hardware
events to be scheduled, and then call a hw_check_constraints()
when we finish a group scheduling?

I guess this would simplify all this code, avoid it to run through
the list of events, handle software events, revert partial enabled
by itself etc...

Hm?

