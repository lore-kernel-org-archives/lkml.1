Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbXJAWO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbXJAWO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbXJAWOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:14:51 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39596 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbXJAWOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:14:50 -0400
Date: Mon, 1 Oct 2007 15:15:19 -0700
From: Mike Kravetz <kravetz@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RT scheduling: wakeup bug?
Message-ID: <20071001221519.GA20671@monkey.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been trying to track down some unexpected realtime latencies and
believe one source is a bug in the wakeup code.  Specifically, this is
within the try_to_wake_up() routine.  Within this routine there is the
following code segment:

	/*
	 * If a newly woken up RT task cannot preempt the
	 * current (RT) task (on a target runqueue) then try
	 * to find another CPU it can preempt:
	 */
	if (rt_task(p) && !TASK_PREEMPTS_CURR(p, rq)) {
		struct rq *this_rq = cpu_rq(this_cpu);
		/*
		 * Special-case: the task on this CPU can be
		 * preempted. In that case there's no need to
		 * trigger reschedules on other CPUs, we can
		 * mark the current task for reschedule.
		 *
		 * (Note that it's safe to access this_rq without
		 * extra locking in this particular case, because
		 * we are on the current CPU.)
		 */
		if (TASK_PREEMPTS_CURR(p, this_rq))
			set_tsk_need_resched(this_rq->curr);
		else
			/*
			 * Neither the intended target runqueue
			 * nor the current CPU can take this task.
			 * Trigger a reschedule on all other CPUs
			 * nevertheless, maybe one of them can take
			 * this task:
			 */
			smp_send_reschedule_allbutself_cpumask(p->cpus_allowed);

		schedstat_inc(this_rq, rto_wakeup);
	}

This logic seems appropriate.  But, the task 'p' is most likely not on
the runqueue when sending the IPI.  It gets added to the runqueue a
little later in the routine.  As a result, the 'rt_overload' global may
not be set (based on the count of RT tasks on the runqueue) and other
CPUs may 'pass over' the runqueue when doing RT load balancing.

My observations/debugging/conclusions are based on an earlier version
of the code.  It appears the same code/issue still exists in the most
version.  But, I have not not done any work with the latest version.

-- 
Mike
