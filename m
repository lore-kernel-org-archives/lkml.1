Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241Ab0AGENx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0AGENx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 23:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989Ab0AGENw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 23:13:52 -0500
Received: from ozlabs.org ([203.10.76.45]:43744 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab0AGENv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 23:13:51 -0500
Date: Thu, 7 Jan 2010 15:13:41 +1100
From: Paul Mackerras <paulus@samba.org>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, eranian@gmail.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       perfmon2-devel@lists.sf.net, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] perf_events: improve Intel event scheduling
Message-ID: <20100107041340.GA30718@drongo>
References: <1255964630-5878-1-git-send-email-eranian@gmail.com>
 <1258561957.3918.661.camel@laptop>
 <7c86c4470912110300n44650d98ke52ec56cf4d925c1@mail.gmail.com>
 <7c86c4470912110359i5a4416c2t9075eaa47d25865a@mail.gmail.com>
 <1261410040.4314.178.camel@laptop>
 <20091222010238.GB31264@drongo>
 <bd4cb8900912290647wa79615bs3ac8618ca36808c3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4cb8900912290647wa79615bs3ac8618ca36808c3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane,

> So if I understand what both of you are saying, it seems that
> event scheduling has to take place in the pmu->enable() callback
> which is per-event.

How much you have to do in the pmu->enable() function depends on
whether the PMU is already stopped (via a call hw_perf_disable()) or
not.  If it is already stopped you don't have to do the full event
scheduling computation, you only have to do enough to work out if the
current set of events plus the event being enabled is feasible, and
record the event for later.  In other words, you can defer the actual
scheduling until hw_perf_enable() time.  Most calls to the
pmu->enable() function are with the PMU already stopped, so it's a
worthwhile optimization.

> In the case of X86, you can chose to do a best-effort scheduling,
> i.e., only assign
> the new event if there is a compatible free counter. That would be incremental.
> 
> But the better solution would be to re-examine the whole situation and
> potentially
> move existing enabled events around to free a counter if the new event is more
> constrained. That would require stopping the PMU, rewriting config and
> data registers
> and re-enabling the PMU. This latter solution is the only possibility
> to avoid ordering
> side effects, i.e., the assignment of events to counters depends on
> the order in which
> events are created (or enabled).

On powerpc, the pmu->enable() function always stops the PMU if it
wasn't already stopped.  That simplifies the code a lot because it
means that I can do all the actual event scheduling (i.e. deciding on
which event goes on which counter and working out PMU control register
values) in hw_perf_enable().

> The register can be considered freed by pmu->disable() if scheduling takes place
> in pmu->enable().
> 
> >From what Paul was saying about hw_perf_group_sched_in(), it seems like this
> function can be used to check if a new group is compatible with the existing
> enabled events. Compatible means that there is a possible assignment of
> events to counters.

The hw_perf_group_sched_in() function is an optimization so I can add
all the counters in the group to the set under consideration and then
do just one feasibility check, rather than adding each counter in
the group in turn and doing the feasibility check for each one.

> As for the n_added logic, it seems like perf_disable() resets n_added to zero.
> N_added is incremented in pmu->enable(), i.e., add one event, or the
> hw_perf_group_sched_in(), i.e., add a whole group. Scheduling is based on
> n_events. The point of n_added is to verify whether something needs to be
> done, i.e., event scheduling, if an event or group was added between
> perf_disable()
> and perf_enable(). In pmu->disable(), the list of enabled events is
> compacted and
> n_events is decremented.
> 
> Did I get this right?

The main point of n_added was so that hw_perf_enable() could know
whether the current set of events is a subset of the last set.  If it
is a subset, the scheduling decisions are much simpler.

> All the enable and disable calls can be called from NMI interrupt context
> and thus must be very careful with locks.

I didn't think the pmu->enable() and pmu->disable() functions could be
called from NMI context.  Also, I would expect that if hw_perf_enable
and hw_perf_disable are called from NMI context, that the calls would
be balanced.  That simplifies things a lot.

Paul.
