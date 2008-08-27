Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYH0ID6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYH0ID6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 04:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbYH0IDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 04:03:41 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:40375 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYH0IDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 04:03:39 -0400
Subject: Re: [PATCH] sched_rt_rq_enqueue() resched idle
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: John Blackwood <john.blackwood@ccur.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <48B454F7.5060106@ccur.com>
References: <48B454F7.5060106@ccur.com>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 10:03:37 +0200
Message-Id: <1219824217.6462.44.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 15:09 -0400, John Blackwood wrote:
> Hi Peter,
> 
> When sysctl_sched_rt_runtime is set to something other than -1 and the
> CONFIG_RT_GROUP_SCHED kernel parameter is NOT enabled, we get into a state
> where we see one or more CPUs idling forvever even though there are
> real-time
> tasks in their rt runqueue that are able to run (no longer throttled).
> 
> The sequence is:
> 
> - A real-time task is running when the timer sets the rt runqueue
>     to throttled, and the rt task is resched_task()ed and switched
>     out, and idle is switched in since there are no non-rt tasks to
>     run on that cpu.
> 
> - Eventually the do_sched_rt_period_timer() runs and un-throttles
>     the rt runqueue, but we just exit the timer interrupt and go back
>     to executing the idle task in the idle loop forever.
> 
> If we change the sched_rt_rq_enqueue() routine to use some of the code
> from the CONFIG_RT_GROUP_SCHED enabled version of this same routine and
> resched_task() the currently executing task (idle in our case) if it is
> a lower priority task than the higher rt task in the now un-throttled
> runqueue, the problem is no longer observed.

Very good spotting, Thanks!

However I think the patch isn't quite good, as highest_prio is only
available on SMP || RT_GROUP_SCHED.

Furthermore, on !RT_GROUP_SCHED any RT task will be higher than current,
so we can do the below, do you agree?

---
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 94daace..f672aee 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -199,6 +199,8 @@ static inline struct rt_rq *group_rt_rq(struct sched_rt_entity *rt_se)
 
 static inline void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
+	if (rt_rq->rt_nr_running)
+		resched_task(rq_of_rt_rq(rt_rq)->curr);
 }
 
 static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)


