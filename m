Return-Path: <linux-kernel-owner+w=401wt.eu-S1764791AbXJFCPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764791AbXJFCPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 22:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbXJFCPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 22:15:24 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42448 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbXJFCPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 22:15:23 -0400
Date: Fri, 5 Oct 2007 19:15:48 -0700
From: Mike Kravetz <kravetz@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: -rt more realtime scheduling issues
Message-ID: <20071006021548.GE4587@monkey.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

After applying the fix to try_to_wake_up() I was still seeing some large
latencies for realtime tasks.  Some debug code pointed out two additional
causes of these latencies.  I have put fixes into my 'old' kernel and the
scheduler related latencies have gone away.  I'm pretty confident that
one of these bugs still exist in the latest RT patch set.  Not so sure
about the other.  But, I wanted to describe in detail so that you could
address in the latest version of the code if applicable.

finish_task_switch() contains the following code:

#if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
	/*
	 * If we pushed an RT task off the runqueue,
	 * then kick other CPUs, they might run it:
	 */
	if (unlikely(rt_task(current) && prev->se.on_rq && rt_task(prev))) {
		schedstat_inc(rq, rto_schedule);
		smp_send_reschedule_allbutself_cpumask(current->cpus_allowed);
	}
#endif

My debug code found instances where more than one realtime task got
put on the runqueue before the __schedule() was invoked.  So, current
would be a realtime task, but prev was not realtime.  And, there was
another (lesser priority, or last in) realtime task on the queue.  I
believe that in this case we would still want to send the IPIs.  In my
kernel I changed the test to be:

	if (unlikely(rt_task(current) && rq->rt_nr_running > 1)) {

After this change, I definitely saw some long latencies go away.

The other place of concern is in the routine pull_task().  I was a
little surprised to see realtime tasks moved around via normal load
balancing.  But, my debug code did point this out.  In the code for
my old kernel, the routines end with:

        /*
         * Note that idle threads have a prio of MAX_PRIO, for this test
         * to be always true for them.
         */
        if (TASK_PREEMPTS_CURR(p, this_rq))
                resched_task(this_rq->curr);

This reminded me very much of the situation/code in try_to_wake_up().
If pull_tasks() pulled in a realtime task, then I think it should also
deal with the case where (TASK_PREEMPTS_CURR(p, this_rq) is false.  So
I changed the code in my kernel to be:

	/*
	 * Note that idle threads have a prio of MAX_PRIO, for this test
	 * to be always true for them.
	 */
	if (TASK_PREEMPTS_CURR(p, this_rq)) {
		resched_task(this_rq->curr);

	} else if (unlikely(rt_task(p))) {
		/* no appropriate rt_overload counter goes here */
		smp_send_reschedule_allbutself();
	}

To be perfectly honest, I don't know if this change helped eliminate
any of the large latencies I was seeing.  I made this changes first,
and was still seeing some large latencies.  I then made the modification
to finish_task_switch() and all my scheduler related latencies went
away.  Entirely possible this change had no impact.  Also, the above
code is replaced in the latest kernels with:

	check_preempt_curr(this_rq, p);

What check_preempt_curr() does is not immediately obvious to me. So,
this may not apply at all.  Just something to think about.

-- 
Mike
