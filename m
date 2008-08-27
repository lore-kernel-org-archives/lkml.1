Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYH0NFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYH0NFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYH0NFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:05:39 -0400
Received: from mail.ccur.com ([12.192.68.12]:8778 "EHLO mail.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217AbYH0NFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:05:38 -0400
Message-ID: <48B55122.6080807@ccur.com>
Date: Wed, 27 Aug 2008 09:05:38 -0400
From: John Blackwood <john.blackwood@ccur.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched_rt_rq_enqueue() resched idle
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > On Tue, 2008-08-26 at 15:09 -0400, John Blackwood wrote:
 > > > Hi Peter,
 > > >
 > > > When sysctl_sched_rt_runtime is set to something other than -1 
and the
 > > > CONFIG_RT_GROUP_SCHED kernel parameter is NOT enabled, we get 
into a state
 > > > where we see one or more CPUs idling forvever even though there are
 > > > real-time
 > > > tasks in their rt runqueue that are able to run (no longer 
throttled).
 > > >
 > > > The sequence is:
 > > >
 > > > - A real-time task is running when the timer sets the rt runqueue
 > > >     to throttled, and the rt task is resched_task()ed and switched
 > > >     out, and idle is switched in since there are no non-rt tasks to
 > > >     run on that cpu.
 > > >
 > > > - Eventually the do_sched_rt_period_timer() runs and un-throttles
 > > >     the rt runqueue, but we just exit the timer interrupt and go back
 > > >     to executing the idle task in the idle loop forever.
 > > >
 > > > If we change the sched_rt_rq_enqueue() routine to use some of the 
code
 > > > from the CONFIG_RT_GROUP_SCHED enabled version of this same 
routine and
 > > > resched_task() the currently executing task (idle in our case) if 
it is
 > > > a lower priority task than the higher rt task in the now un-throttled
 > > > runqueue, the problem is no longer observed.
 >
 > Very good spotting, Thanks!

You're welcome.

 > However I think the patch isn't quite good, as highest_prio is only
 > available on SMP || RT_GROUP_SCHED.
 >
 > Furthermore, on !RT_GROUP_SCHED any RT task will be higher than current,
 > so we can do the below, do you agree?

Yes, I see what you are saying.
The patch version below looks good.
I re-tested with it and it works fine.

Thanks!

 > diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
 > index 94daace..f672aee 100644
 > --- a/kernel/sched_rt.c
 > +++ b/kernel/sched_rt.c
 > @@ -199,6 +199,8 @@ static inline struct rt_rq *group_rt_rq(struct 
sched_rt_entity *rt_se)
 >
 >  static inline void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 >  {
 > +       if (rt_rq->rt_nr_running)
 > +               resched_task(rq_of_rt_rq(rt_rq)->curr);
 >  }
 >
 >  static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 >
 >
