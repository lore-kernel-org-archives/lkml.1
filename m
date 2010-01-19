Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861Ab0ASPkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab0ASPkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 10:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806Ab0ASPkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 10:40:21 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:32867 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab0ASPkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 10:40:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DqASD5JEW4fsFZmgBTLOGaguig7bSpebb3mt9WmPIAiVvq5sE/AgxQzXOt0/mZOpWN
         OQwRJvGI8r8gwyIhqVCioGdcjCrDl1zn2Ixxo3qdaHb4kpjJJZI7IlcbQKPj9OfOcWVy
         E0lvvTzn/sa/Ae9SW9T9ivUmdX2XapuCX1pzU=
Date: Tue, 19 Jan 2010 16:40:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
Message-ID: <20100119154012.GD8061@nowhere>
References: <20100118142004.GD10364@nowhere> <1263825158.4283.590.camel@laptop> <20100118144556.GE10364@nowhere> <1263826601.4283.603.camel@laptop> <20100118161836.GG10364@nowhere> <1263831973.4283.622.camel@laptop> <20100118165114.GJ10364@nowhere> <1263834806.4283.625.camel@laptop> <20100118172935.GM10364@nowhere> <1263903773.4283.657.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263903773.4283.657.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 01:22:53PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 18:29 +0100, Frederic Weisbecker wrote:
> 
> > It has constraints that only need to be checked when we register
> > the event. It has also constraint on enable time but nothing
> > tricky that requires an overwritten group scheduling.
> 
> The fact that ->enable() can fail makes it a hardware counter. Software
> counters cannot fail enable.
> 
> Having multiple groups of failable events (multiple hardware pmus) can
> go wrong with the current core in interesting ways, look for example at
> __perf_event_sched_in():
> 
> It does:
> 
> 	int can_add_hw = 1;
> 
> 	...
> 
> 	list_for_each_entry(event, &ctx->flexible_groups, group_entry) {
> 		/* Ignore events in OFF or ERROR state */
> 		if (event->state <= PERF_EVENT_STATE_OFF)
> 			continue;
> 		/*
> 		 * Listen to the 'cpu' scheduling filter constraint
> 		 * of events:
> 		 */
> 		if (event->cpu != -1 && event->cpu != cpu)
> 			continue;
> 
> 		if (group_can_go_on(event, cpuctx, can_add_hw))
> 			if (group_sched_in(event, cpuctx, ctx, cpu))
> 				can_add_hw = 0;
> 	}
> 
> Now, if you look at that logic you'll see that it assumes there's one hw
> device since it only has one can_add_hw state. So if your hw_breakpoint
> pmu starts to fail we'll also stop adding counters to the cpu pmu (for
> lack of a better name) and vs.


Indeed.


> 
> This might be fixable by using per-cpu struct pmu variables. 


Yeah or just a mask instead of can_add_hw that can testify
a given pmu type couldn't be scheduled anymore?

We can extend struct perf_event:group_flags:

enum perf_group_flag {
	PERF_GROUP_NO_HARDWARE = 0x1,
	PERF_GROUP_NO_BREAKPOINT = 0x2
	PERF_GROUP_SOFTWARE = PERF_GROUP_NO_HARDWARE | PERF_GROUP_NO_BREAKPOINT;
};


Looks easy to maintain and to use for quick bitwise check
on flexible groups scheduling.


> However I'm afraid its far to late to push any of that into .33, which
> means .33 will have rather funny behaviour once the breakpoints start
> getting used.


No. Because for now it is not supposed to happen that a breakpoint
can't be scheduled.

We have constraints that check whether a pinned breakpoint will
always be able to go in, on registration. Similarly we have
constraints for flexible ones, to ensure it's possible for these
to be scheduled. But these are broken because of the non-strict
ordering between pinned and non-pinned events.

Anyway, the point is that for now we treat flexible breakpoints
as if these were pinned, so a breakpoint is not supposed to
be unschedulable, ever. So .33 is not broken.

But we need to fix what you described for .34, because once we
get a strict ordering between pinned and flexible, I'm going
to reactivate the breakpoint constraints for flexibles.

