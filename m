Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbZIHCZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbZIHCZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 22:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZIHCY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 22:24:59 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:62368 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbZIHCY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 22:24:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IOJ/gfjbRvlWpKU9FzRCdSnR6p8fxuBPgmK9PYVBEd0DVhb+FlXlNFV5/al7ayy58/
         rxUp1HA/3yrotQw8Mr2Qq9l9aHPLJ+Jx8VpUJ3h/uedux4ftu6p1rGno9aqgEDPBCzfD
         9UMDYMzLS1zFuFtH7bx3T18qbhRykxdZsibso=
Date: Tue, 8 Sep 2009 04:24:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] tracing/profile: Add filter support
Message-ID: <20090908022454.GE6312@nowhere>
References: <4AA4C04D.1050201@cn.fujitsu.com> <4AA4C085.5050006@cn.fujitsu.com> <20090908020117.GC6312@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908020117.GC6312@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 04:01:19AM +0200, Frederic Weisbecker wrote:
> On Mon, Sep 07, 2009 at 04:12:53PM +0800, Li Zefan wrote:
> > - add ftrace_profile_set_filter(), to set filter for a profile event
> > 
> > - filter is enabled when profile probe is registered
> > 
> > - filter is disabled when profile probe is unregistered
> > 
> > - in ftrace_profile_##call(), record events only when
> >   filter_match_preds() returns 1
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> 
> 
> Well, I feel a bit uncomfortable with this approach.
> 
> The events approach taken by perf is different from ftrace.
> 
> ftrace events activation/deactivation, ring buffer captures,
> filters are all globals. And this is nice to perform kernel
> tracing from debugfs files.
> 
> But perf has a per counter instance approach. This means
> that when a tracepoint counter registers a filter, this should
> be private to this tracepoint counter and not propagated to the
> others.
> 
> So this should rely on a kind of per tracepoint counter
> attribute, something that we should probably be stored in
> the struct hw_perf_counter like:
> 
> --- a/include/linux/perf_counter.h
> +++ b/include/linux/perf_counter.h
> @@ -467,6 +467,7 @@ struct hw_perf_counter {
>                 union { /* software */
>                         atomic64_t      count;
>                         struct hrtimer  hrtimer;
> +                       struct event_filter filter;
>                 };
>         };
>         atomic64_t                      prev_count;
> 
> 
> You may need to get the current perf context that can
> be found in current->perf_counter_ctxp and then iterate
> through the counter_list of this ctx to find the current counter
> attached to this tracepoint (using the event id).
> 
> What is not nice is that we need to iterate in O(n), n beeing the
> number of tracepoint counters attached to the current counter
> context.
> 
> So to avoid the following costly sequence in the tracing fastpath:
> 
> - deref ctx->current->perf_counter_ctxp
> - list every ctx->counter_list
> - find the counter that matches
> - deref counter->filter and test...
> 
> You could keep the profile_filter field (and profile_filter_active)
> in struct ftrace_event_call but allocate them per cpu and
> write these fields for a given event each time we enter/exit a
> counter context that has a counter that uses this given event.
> 
> That's something we could do by using a struct pmu specific for
> tracepoints. More precisely with enable/disable callbacks that would do
> specific things and then relay on the perf_ops_generic pmu
> callbacks.
> 
> the struct pmu::enable()/disable() callbacks are functions that are called
> each time we schedule in/out a task group that has a counter that
> uses the given pmu.
> Ie: they are called each time we schedule in/out a counter.
> 
> So you have a struct ftrace_event_call. This event can be used in
> several different counters instance at the same time. But in a given cpu,
> only one of these counters can be currently in use.



I fear I've been confusing here.

Just to be clear:

Say we schedule in a task in cpu 0.
This task has a irq_entry tp counter. It makes no
sense to have two irq_entry counters for a same task and
if it's possible I guess that should be fixed (unless I'm
missing relevant usecases).

Then when we enter the task, if we have an irq_entry counter
that becomes enabled, we can safely write a shortcut from its
ftrace_event_call structure to the counter filter.

But that must be done per cpu, because another task of the same
task group may be using this counter instance on another cpu.
That's why we need this field to be written per cpu.



 
> Now if we build a simple struct pmu tp_pmu that mostly relays
> on the perf_ops_generic pmu but also have a specific enable/disable
> pair that calls perf_swcounter_enable/disable and also does:
> 
> /*
>  * We are scheduling this counter on the smp_processor_id() cpu
>  * (we are in atomic context, ctx->lock acquired) then we
>  * can safely write a local (per cpu) shortcut from the filter_profile
>  * field in the event to the counter filter.
>  */
> static int perf_tpcounter_enable(struct perf_counter *counter)
> {
> 	struct event_filter *filter, **shortcut;
> 	int *enable;
> 	struct ftrace_event_call *call;
> 	int cpu = smp_processor_if();
> 
> 	call = find_event_by_id(counter->attr.config);
> 	filter = &counter->hw.filter;
> 
> 	shortcut = &per_cpu_ptr(call->filter_profile, cpu)
> 	enable = &per_cpu_var(call->filter_profile_enabled, cpu)
> 
> 	if (filter is present) {
> 		*enable = 1;
> 		*shortcut = filter;
> 	}
> 
> 	return perf_swcounter_enable(counter);
> }
> 
> /* We schedule out this counter from this cpu, erase the shortcut */
> static void perf_tpcounter_disable(struct perf_counter *counter)
> {
> 		/* ... */
> 		enable = 0;
> 		shortcut = NULL;
> 
> 		perf_swcounter_disable(counter);
> }
> 
> static const struct pmu perf_ops_tracepoint = {
> 	.enable		= perf_tpcounter_enable,
> 	.disable	= perf_tpcounter_disable,
> 	.read		= perf_swcounter_read,
> 	.unthrottle	= perf_swcounter_unthrottle,
> };
> 	
> 
> See? Then you can have a O(1) retrieval of the current per
> counter filter to apply from ftrace_profile_##call()
> 
> I hope I haven't been too much confusing...
> 

