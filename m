Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbZBMLX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbZBMLX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 06:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbZBMLXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 06:23:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbZBMLXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 06:23:49 -0500
Date: Fri, 13 Feb 2009 12:23:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] Make context switch and migration software counters
	work again
Message-ID: <20090213112333.GE15679@elte.hu>
References: <18837.21802.429822.796289@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18837.21802.429822.796289@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Jaswinder Singh Rajput reported that commit 23a185ca8abbeef caused the
> context switch and migration software counters to report zero always.
> With that commit, the software counters only count events that occur
> between sched-in and sched-out for a task.  This is necessary for the
> counter enable/disable prctls and ioctls to work.  However, the
> context switch and migration counts are incremented after sched-out
> for one task and before sched-in for the next.  Since the increment
> doesn't occur while a task is scheduled in (as far as the software
> counters are concerned) it doesn't count towards any counter.
> 
> Thus the context switch and migration counters need to count events
> that occur at any time, provided the counter is enabled, not just
> those that occur while the task is scheduled in (from the perf_counter
> subsystem's point of view).  The problem though is that the software
> counter code can't tell the difference between being enabled and being
> scheduled in, and between being disabled and being scheduled out,
> since we use the one pair of enable/disable entry points for both.
> That is, the high-level disable operation simply arranges for the
> counter to not be scheduled in any more, and the high-level enable
> operation arranges for it to be scheduled in again.
> 
> One way to solve this would be to have sched_in/out operations in the
> hw_perf_counter_ops struct as well as enable/disable.  However, this
> takes a simpler approach: it adds a 'prev_state' field to the
> perf_counter struct that allows a counter's enable method to know
> whether the counter was previously disabled or just inactive
> (scheduled out), and therefore whether the enable method is being
> called as a result of a high-level enable or a schedule-in operation.
> 
> This then allows the context switch, migration and page fault counters
> to reset their hw.prev_count value in their enable functions only if
> they are called as a result of a high-level enable operation.
> Although page faults would normally only occur while the counter is
> scheduled in, this changes the page fault counter code too in case
> there are ever circumstances where page faults get counted against a
> task while its counters are not scheduled in.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>

Applied to tip:perfcounters/core, thanks Paul!

> This was the simplest fix I could come up with that allowed enable/
> disable to work properly.  In some ways having separate sched_in/out
> and enable/disable operations would be nicer but it started to get
> rather invasive.  In future it might be useful to have sched-in/out
> separate from enable/disable so that we can optimize sched-in/out.
> For example, on the POWER processors we could use the PM mark bit to
> turn counting on and off quickly in the case where only one task is
> currently using the PMU on a given cpu and there are no per-cpu
> counters.

Agreed. Right now we do have some context-switching overhead for
inherited counters, clearly visible in context-switch intense
workloads if they are run via perfstat, so it would be very nice
to optimize this some more.

	Ingo
