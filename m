Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334Ab0ASNZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0ASNZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 08:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191Ab0ASNZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 08:25:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59840 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab0ASNZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 08:25:23 -0500
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <1263903773.4283.657.camel@laptop>
References: <20100118134324.GB10364@nowhere>
	 <1263822898.4283.558.camel@laptop> <20100118142004.GD10364@nowhere>
	 <1263825158.4283.590.camel@laptop> <20100118144556.GE10364@nowhere>
	 <1263826601.4283.603.camel@laptop> <20100118161836.GG10364@nowhere>
	 <1263831973.4283.622.camel@laptop> <20100118165114.GJ10364@nowhere>
	 <1263834806.4283.625.camel@laptop>  <20100118172935.GM10364@nowhere>
	 <1263903773.4283.657.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 14:24:49 +0100
Message-ID: <1263907489.4283.663.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 13:22 +0100, Peter Zijlstra wrote:
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
> 
> This might be fixable by using per-cpu struct pmu variables. 
> 
> I'm going to try and move all the weak hw_perf_* functions into struct
> pmu and create a notifier like callchain for them so we can have proper
> per pmu state, and then use that to fix these things up.
> 
> However I'm afraid its far to late to push any of that into .33, which
> means .33 will have rather funny behaviour once the breakpoints start
> getting used.

Hrmph, so I read some of that hw_breakpoint stuff, and now I'm sorta
confused, it looks like ->enable should never fail, but that means you
cannot overcommit breakpoints, which doesn't fit the perf model nicely.

Also, I see you set an ->unthrottle, but then don't implement it, but
comment it as todo, which is strange because that implies its broken. If
there's an ->unthrottle method it will throttle, so if its todo, the
safest thing is to not set it.

/me mutters something and goes look at something else for a while.

