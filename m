Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZIHIgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZIHIgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 04:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZIHIf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 04:35:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55675 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbZIHIf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 04:35:58 -0400
Subject: Re: [PATCH 2/6] tracing/profile: Add filter support
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090908020117.GC6312@nowhere>
References: <4AA4C04D.1050201@cn.fujitsu.com>
	 <4AA4C085.5050006@cn.fujitsu.com>  <20090908020117.GC6312@nowhere>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 08 Sep 2009 10:35:45 +0200
Message-Id: <1252398945.7746.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 04:01 +0200, Frederic Weisbecker wrote:
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

Agreed.

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

How would that work when you have two counters of the same type in one
context with different filter expressions?

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

Not so, you can have as many counters as you want on any one particular
cpu. There is nothing that stops:

  perf record -e timer:hrtimer_start -e timer:hrtimer_start -e
timer:hrtimer_start ...

from working, now add a different filter to each of those counter and
enjoy ;-)



I've been thinking of replacing that linear list with a better lookup,
like maybe an RB-tree or hash table, because we hit that silly O(n) loop
on every software event.


