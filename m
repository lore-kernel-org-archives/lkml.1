Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbXJISvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbXJISvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbXJISu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:50:57 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57429 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbXJISu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:50:56 -0400
Date: Tue, 9 Oct 2007 11:51:08 -0700
From: Mike Kravetz <kravetz@us.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RT] fix rt-task scheduling issue
Message-ID: <20071009185108.GA14419@monkey.ibm.com>
References: <20071006021548.GE4587@monkey.ibm.com> <20071009024621.GA12915@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009024621.GA12915@goodmis.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 10:46:21PM -0400, Steven Rostedt wrote:
> Mike,
> 
> Can you attach your Signed-off-by to this patch, please.
> 
> 
> On Fri, Oct 05, 2007 at 07:15:48PM -0700, Mike Kravetz wrote:
> > Hi Ingo,
> > 
> > After applying the fix to try_to_wake_up() I was still seeing some large
> > latencies for realtime tasks.  Some debug code pointed out two additional
> > causes of these latencies.  I have put fixes into my 'old' kernel and the
> > scheduler related latencies have gone away.  I'm pretty confident that
> > one of these bugs still exist in the latest RT patch set.  Not so sure
> > about the other.  But, I wanted to describe in detail so that you could
> > address in the latest version of the code if applicable.
> > 
> > finish_task_switch() contains the following code:
> > 
> > #if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
> > 	/*
> > 	 * If we pushed an RT task off the runqueue,
> > 	 * then kick other CPUs, they might run it:
> > 	 */
> > 	if (unlikely(rt_task(current) && prev->se.on_rq && rt_task(prev))) {
> > 		schedstat_inc(rq, rto_schedule);
> > 		smp_send_reschedule_allbutself_cpumask(current->cpus_allowed);
> > 	}
> > #endif
> > 
> > My debug code found instances where more than one realtime task got
> > put on the runqueue before the __schedule() was invoked.  So, current
> > would be a realtime task, but prev was not realtime.  And, there was
> > another (lesser priority, or last in) realtime task on the queue.  I
> > believe that in this case we would still want to send the IPIs.  In my
> > kernel I changed the test to be:
> > 
> > 	if (unlikely(rt_task(current) && rq->rt_nr_running > 1)) {
> > 
> > After this change, I definitely saw some long latencies go away.

OK, not really a patch but

Signed-off-by: Mike Kravetz <kravetz@us.ibm.com>

-- 
Mike
