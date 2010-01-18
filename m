Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805Ab0AROUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab0AROUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626Ab0AROUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:20:12 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:39903 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0AROUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:20:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uyvvO3Yk97i7c5MeBgnNXkmKE69klrUfJtah7HD+zZWxgHDvkIG4/pLt1XKqtBww5L
         zAETo4CGCN18R5NtUognGrrXX71ffzqwOl9PI+7G0Lh02DYqlYKBi3wPCO8kaKenVeJL
         puDJaU/hz/mg1P8IMn0wDpjdbhJNcC+ch58PQ=
Date: Mon, 18 Jan 2010 15:20:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
Message-ID: <20100118142004.GD10364@nowhere>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com> <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263822898.4283.558.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 02:54:58PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 14:43 +0100, Frederic Weisbecker wrote:
> > 
> > Shouldn't we actually use the core based pmu->enable(),disable()
> > model called from kernel/perf_event.c:event_sched_in(),
> > like every other events, where we can fill up the queue of hardware
> > events to be scheduled, and then call a hw_check_constraints()
> > when we finish a group scheduling? 
> 
> Well the thing that makes hw_perf_group_sched_in() useful is that you
> can add a bunch of events and not have to reschedule for each one, but
> instead do a single schedule pass.



Well in appearance, things go through one pass.

But actually not, there is a first iteration that collects
the events (walking trhough the group list, filtering soft events),
a second iteration that check the constraints and schedule (but
not apply) the events.

And thereafter we schedule soft events (and revert the whole if needed).

This is a one pass from group_sched_in() POV but at the cost
of reimplementating what the core does wrt soft events and iterations.
And not only is it reinventing the wheel, it also produces more
iterations than we need.

If we were using the common pmu->enable() from group/event_sched_in(),
that would build the collection, with only one iteration through the
group list (instead of one to collect, and one for the software
events).

And the constraints can be validated in a second explicit iteration
through hw_check_constraint(), like it's currently done explicitly
from hw_perf_group_sched_in() that calls x86_schedule_event().

The fact is we have with this patch a _lot_ of iterations each
time x86 get scheduled. This is really a lot for a fast path.
But considering the dynamic cpu events / task events series
we can have, I don't see other alternatives.

But still there are wasteful iterations that can be avoided
with the above statements.


> 
> That said you do have a point, maybe we can express this particular
> thing differently.. maybe a pre and post group call like:
> 
>  void hw_perf_group_sched_in_begin(struct pmu *pmu)
>  int  hw_perf_group_sched_in_end(struct pmu *pmu)
> 
> That way we know we need to track more state for rollback and can give
> the pmu implementation leeway to delay scheduling/availablility tests.


Do you mean this:

hw_perf_group_sched_in_begin(&x86_pmu);

for_each_event(event, group) {
	event->enable();	//do the collection here
}


if (hw_perf_group_sched_in_end(&x86_pmu)) {
	rollback...
}

That requires to know in advance if we have hardware pmu
in the list though (can be a flag in the group).


> Then there's still the question of having events of multiple hw pmus in
> a single group, I'd be perfectly fine with saying that's not allowed,
> what to others think?


I guess we need that. It can be insteresting to couple
hardware counters with memory accesses...or whatever.
Perf stat combines cache miss counting with page faults,
cpu clock counters.
We shouldn't limit such possibilities for technical/cleanliness
reasons. We should rather adapt.

Hm?

