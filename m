Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbZLVBKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbZLVBKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 20:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZLVBK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 20:10:26 -0500
Received: from ozlabs.org ([203.10.76.45]:34965 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbZLVBKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 20:10:23 -0500
Date: Tue, 22 Dec 2009 11:57:39 +1100
From: Paul Mackerras <paulus@samba.org>
To: eranian@gmail.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, perfmon2-devel@lists.sf.net,
       "David S. Miller" <davem@davemloft.net>, eranian@google.com
Subject: Re: [PATCH] perf_events: improve Intel event scheduling
Message-ID: <20091222005739.GA31264@drongo>
References: <1255964630-5878-1-git-send-email-eranian@gmail.com>
 <1258561957.3918.661.camel@laptop>
 <7c86c4470912110300n44650d98ke52ec56cf4d925c1@mail.gmail.com>
 <7c86c4470912110359i5a4416c2t9075eaa47d25865a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470912110359i5a4416c2t9075eaa47d25865a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 12:59:16PM +0100, stephane eranian wrote:

> There is a major difference between PPC and X86 here. PPC has a centralized
> register to control start/stop. This register  uses bitmask  to enable
> or disable counters. Thus, in hw_perf_enable(), if n_added=0, then you
> just need to
> use the pre-computed bitmask. Otherwise, you need to recompute the bitmask to
> include the new registers. The assignment of events and validation is done in
> hw_group_sched_in().

That's not entirely accurate.  Yes there is a global start/stop bit,
but there isn't a bitmask to enable or disable counters.  There is a
selector bitfield for each counter (except the limited-function
counters) and you can set the selector to the 'count nothing' value if
you don't want a particular counter to count.

Validation is done in hw_group_sched_in() but not the assignment of
events to counters.  That's done in hw_perf_enable(), via the
model-specific ppmu->compute_mmcr() call.

> In X86, assignment and validation is done in hw_group_sched_in(). Activation is
> done individually for each counter. There is no centralized register
> used here, thus
> no bitmask to update.
> 
> Disabling a counter does not trigger a complete reschedule of events.
> This happens
> only when hw_group_sched_in() is called.
> 
> The n_events = 0 in hw_perf_disable() is used to signal that something
> is changing.
> It should not be here but here.

The meaning of "It should not be here but here" is quite unclear to me.

> The problem is that
> hw_group_sched_in() needs a way
> to know that it is called for a completely new series of group
> scheduling so it can
> discard any previous assignment. This goes back to the issue I raised
> in my previous
> email. You could add a parameter to hw_group_sched_in() that would
> indicate this is
> the first group. that would cause n_events =0 and the function would
> start accumulating
> events for the new scheduling period.

I don't think hw_group_sched_in is ever called for a completely new
series of group scheduling.  If you have per-cpu counters active, they
don't get scheduled out and in again with each task switch.  So you
will tend to get a hw_pmu_disable call, then a series of disable calls
for the per-task events for the old task, then a series of
hw_group_sched_in calls for the per-task events for the new task, then
a hw_pmu_enable call.

On powerpc we maintain an array with pointers to all the currently
active events.  That makes it easy to know at hw_pmu_enable() time
what events need to be put on the PMU.  Also it means that at
hw_group_sched_in time you can look at the whole set of events,
including the ones just added, to see if it's feasible to put them all
on.  At that point we just check feasibility, which is quite quick and
easy using the bit-vector encoding of constraints.  The bit-vector
encoding lets us represent multiple constraints of various forms in
one pair of 64-bit values per event.  We can express constraints such
as "you can have at most N events in a class X" or "you can't have
events in all of classes A, B, C and D" or "control register bitfield
X must be set to Y", and then check that a set of events satisfies all
the constraints with some simple integer arithmetic.  I don't know
exactly what constraints you have on x86 but I would be surprised if
you couldn't handle them the same way.

Paul.
