Return-Path: <linux-kernel-owner+w=401wt.eu-S1752272AbZIHMdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbZIHMdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 08:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbZIHMdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 08:33:49 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:54146 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZIHMds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 08:33:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Iwb2CV071lmHV1N6Ew4HP8Ne3FVxvkWFqYRncuoPYTruQ90pf8GUVyhkQjdZUvk012
         h3/2MHJTBRo01yhImQL5bnzfYpbhpUZT8suR4UafJQDg8t/7rQ7UsQO08o0c+NS6OxS8
         r+NCp+hFPEem5RZPKSPp7BKtKXWSeuoAbL4ZI=
Date: Tue, 8 Sep 2009 14:33:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] tracing/profile: Add filter support
Message-ID: <20090908123340.GA6218@nowhere>
References: <4AA4C04D.1050201@cn.fujitsu.com> <4AA4C085.5050006@cn.fujitsu.com> <20090908020117.GC6312@nowhere> <1252398945.7746.14.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252398945.7746.14.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 10:35:45AM +0200, Peter Zijlstra wrote:
> On Tue, 2009-09-08 at 04:01 +0200, Frederic Weisbecker wrote:
> > You may need to get the current perf context that can
> > be found in current->perf_counter_ctxp and then iterate
> > through the counter_list of this ctx to find the current counter
> > attached to this tracepoint (using the event id).
> > 
> > What is not nice is that we need to iterate in O(n), n beeing the
> > number of tracepoint counters attached to the current counter
> > context.
> > 
> > So to avoid the following costly sequence in the tracing fastpath:
> > 
> > - deref ctx->current->perf_counter_ctxp
> > - list every ctx->counter_list
> > - find the counter that matches
> > - deref counter->filter and test...
> > 
> > You could keep the profile_filter field (and profile_filter_active)
> > in struct ftrace_event_call but allocate them per cpu and
> > write these fields for a given event each time we enter/exit a
> > counter context that has a counter that uses this given event.
> 
> How would that work when you have two counters of the same type in one
> context with different filter expressions?


Oh so we can do that? That's what I wondered about.


 
> > That's something we could do by using a struct pmu specific for
> > tracepoints. More precisely with enable/disable callbacks that would do
> > specific things and then relay on the perf_ops_generic pmu
> > callbacks.
> > 
> > the struct pmu::enable()/disable() callbacks are functions that are called
> > each time we schedule in/out a task group that has a counter that
> > uses the given pmu.
> > Ie: they are called each time we schedule in/out a counter.
> > 
> > So you have a struct ftrace_event_call. This event can be used in
> > several different counters instance at the same time. But in a given cpu,
> > only one of these counters can be currently in use.
> 
> Not so, you can have as many counters as you want on any one particular
> cpu. There is nothing that stops:
> 
>   perf record -e timer:hrtimer_start -e timer:hrtimer_start -e
> timer:hrtimer_start ...
>
> from working, now add a different filter to each of those counter and
> enjoy ;-)
> 


Then may be we can do that here:

static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
				     enum perf_type_id type,
				     u32 event, u64 nr, int nmi,
				     struct perf_sample_data *data)
{
	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
		if (perf_swcounter_match(counter, type, event, data->regs))
			perf_swcounter_add(counter, nr, nmi, data);
	}
}


If we have two instances of a same counter id in the ctx, the sample
event will be added twice there.

What we need is to apply the filter there because we are "counter instance"
aware at this stage.

We can do our filter check inside perf_swcounter_match(). We just
need to have the filter and the ftrace event call as
struct hw_perf_counter fields and call filter_match_preds() from
perf_swcounter_match() (if the previous match tests have successed).


> I've been thinking of replacing that linear list with a better lookup,
> like maybe an RB-tree or hash table, because we hit that silly O(n) loop
> on every software event.


Yeah that indeed is also a problem :)

