Return-Path: <linux-kernel-owner+w=401wt.eu-S1760580AbYHZTP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580AbYHZTP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758956AbYHZTPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:15:12 -0400
Received: from mail.ccur.com ([12.192.68.12]:52817 "EHLO mail.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759055AbYHZTPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:15:11 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Aug 2008 15:15:11 EDT
Message-ID: <48B454F7.5060106@ccur.com>
Date: Tue, 26 Aug 2008 15:09:43 -0400
From: John Blackwood <john.blackwood@ccur.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched_rt_rq_enqueue() resched idle
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

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

Thank you for your time and consideration.

Signed-off-by: John Blackwood <john.blackwood@ccur.com>

Index: a/kernel/sched_rt.c
===================================================================
--- a.orig/kernel/sched_rt.c    2008-08-22 15:11:31.000000000 -0400
+++ a/kernel/sched_rt.c 2008-08-22 15:12:36.000000000 -0400
@@ -193,6 +193,12 @@

   static inline void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
   {
+       if (rt_rq->rt_nr_running) {
+               struct task_struct *curr = rq_of_rt_rq(rt_rq)->curr;
+
+               if (rt_rq->highest_prio < curr->prio)
+                       resched_task(curr);
+       }
   }

   static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)

