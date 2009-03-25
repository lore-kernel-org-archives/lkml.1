Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbZCYMZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbZCYMZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758167AbZCYMZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:25:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34198 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756458AbZCYMZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:25:36 -0400
Date: Wed, 25 Mar 2009 13:25:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] perfcounters: record time running and time enabled
	for each counter
Message-ID: <20090325122518.GF11571@elte.hu>
References: <18890.6578.728637.139402@cargo.ozlabs.ibm.com> <1237983668.7972.847.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237983668.7972.847.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2009-03-25 at 22:46 +1100, Paul Mackerras wrote:
> > Impact: new functionality
> > 
> > Currently, if there are more counters enabled than can fit on the CPU,
> > the kernel will multiplex the counters on to the hardware using
> > round-robin scheduling.  That isn't too bad for sampling counters, but
> > for counting counters it means that the value read from a counter
> > represents some unknown fraction of the true count of events that
> > occurred while the counter was enabled.
> > 
> > This remedies the situation by keeping track of how long each counter
> > is enabled for, and how long it is actually on the cpu and counting
> > events.  These times are recorded in nanoseconds using the task clock
> > for per-task counters and the cpu clock for per-cpu counters.
> > 
> > These values can be supplied to userspace on a read from the counter.
> > Userspace requests that they be supplied after the counter value by
> > setting the PERF_FORMAT_TOTAL_TIME_ENABLED and/or
> > PERF_FORMAT_TOTAL_TIME_RUNNING bits in the hw_event.read_format field
> > when creating the counter.  (There is no way to change the read format
> > after the counter is created, though it would be possible to add some
> > way to do that.)
> > 
> > Using this information it is possible for userspace to scale the count
> > it reads from the counter to get an estimate of the true count:
> > 
> > true_count_estimate = count * total_time_enabled / total_time_running
> > 
> > This also lets userspace detect the situation where the counter never
> > got to go on the cpu: total_time_running == 0.
> > 
> > This functionality has been requested by the PAPI developers, and will
> > be generally needed for interpreting the count values from counting
> > counters correctly.
> > 
> > In the implementation, this keeps 5 time values (in nanoseconds) for
> > each counter: total_time_enabled and total_time_running are used when
> > the counter is in state OFF or ERROR and for reporting back to
> > userspace.  When the counter is in state INACTIVE or ACTIVE, it is the
> > tstamp_enabled, tstamp_running and tstamp_stopped values that are
> > relevant, and total_time_enabled and total_time_running are determined
> > from them.  (tstamp_stopped is only used in INACTIVE state.)  The
> > reason for doing it like this is that it means that only counters
> > being enabled or disabled at sched-in and sched-out time need to be
> > updated.  There are no new loops that iterate over all counters to
> > update total_time_enabled or total_time_running.
> > 
> > This also keeps separate child_total_time_running and
> > child_total_time_enabled fields that get added in when reporting the
> > totals to userspace.  They are separate fields so that they can be
> > atomic.  We don't want to use atomics for total_time_running,
> > total_time_enabled etc., because then we would have to use atomic
> > sequences to update them, which are slower than regular arithmetic and
> > memory accesses.
> > 
> > It is possible to measure total_time_running by adding a task_clock
> > counter to each group of counters, and total_time_enabled can be
> > measured approximately with a top-level task_clock counter (though
> > inaccuracies will creep in if you need to disable and enable groups
> > since it is not possible in general to disable/enable the top-level
> > task_clock counter simultaneously with another group).  However, that
> > adds extra overhead - I measured around 15% increase in the context
> > switch latency reported by lat_ctx (from lmbench) when a task_clock
> > counter was added to each of 2 groups, and around 25% increase when a
> > task_clock counter was added to each of 4 groups.  (In both cases a
> > top-level task-clock counter was also added.)
> > 
> > In contrast, the code added in this commit gives better information
> > with no overhead that I could measure (in fact in some cases I
> > measured lower times with this code, but the differences were all less
> > than one standard deviation).
> > 
> > Signed-off-by: Paul Mackerras <paulus@samba.org>
> 
> Looks good,
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

thanks - it even applied cleanly on top of your mmap changed :-)

> Paul, should we perhaps also put a format header in the sys_read() 
> output?

Yeah - we should standardize on a common perf_event_type binary 
record structure for all transports.

	Ingo
