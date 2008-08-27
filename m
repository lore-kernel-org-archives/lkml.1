Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYH0NTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYH0NTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbYH0NT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:19:26 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:53757 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbYH0NTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:19:25 -0400
Subject: Re: [PATCH] sched_rt_rq_enqueue() resched idle
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: John Blackwood <john.blackwood@ccur.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <48B55122.6080807@ccur.com>
References: <48B55122.6080807@ccur.com>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 15:19:03 +0200
Message-Id: <1219843143.6462.86.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please apply.


---
Subject: sched: sched_rt_rq_enqueue() resched idle
From: John Blackwood <john.blackwood@ccur.com>
Date: Tue, 26 Aug 2008 15:09:43 -0400

When sysctl_sched_rt_runtime is set to something other than -1 and the
CONFIG_RT_GROUP_SCHED kernel parameter is NOT enabled, we get into a state
where we see one or more CPUs idling forvever even though there are
real-time
tasks in their rt runqueue that are able to run (no longer throttled).

The sequence is:

- A real-time task is running when the timer sets the rt runqueue
    to throttled, and the rt task is resched_task()ed and switched
    out, and idle is switched in since there are no non-rt tasks to
    run on that cpu.

- Eventually the do_sched_rt_period_timer() runs and un-throttles
    the rt runqueue, but we just exit the timer interrupt and go back
    to executing the idle task in the idle loop forever.

If we change the sched_rt_rq_enqueue() routine to use some of the code
from the CONFIG_RT_GROUP_SCHED enabled version of this same routine and
resched_task() the currently executing task (idle in our case) if it is
a lower priority task than the higher rt task in the now un-throttled
runqueue, the problem is no longer observed.

Signed-off-by: John Blackwood <john.blackwood@ccur.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_rt.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -199,6 +199,8 @@ static inline struct rt_rq *group_rt_rq(
 
 static inline void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
+	if (rt_rq->rt_nr_running)
+		resched_task(rq_of_rt_rq(rt_rq)->curr);
 }
 
 static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)


