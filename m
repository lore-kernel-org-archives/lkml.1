Return-Path: <linux-kernel-owner+w=401wt.eu-S934758AbZJJCli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934758AbZJJCli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 22:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934749AbZJJCli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 22:41:38 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20148 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbZJJClh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 22:41:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:subject:message-id:user-agent:mime-version:content-type;
	b=JWZy3obNIWxwx/QhiJjyCIm1amyBKirRvdUHbIyj+JdqeJMlCyAEVCiCMjcqtkx8r
	5t4K9SoLQtX3yVu+UZWHw==
Date: Fri, 9 Oct 2009 19:40:06 -0700 (PDT)
From: Paul Turner <pjt@google.com>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: sched: race between deactivate and switch sched_info accounting?
Message-ID: <alpine.DEB.2.00.0910091849070.22548@kitami.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

While chasing down some performance we found inconsistenies in the 
accounting of run-delay.  Tracking this down I think there exists a race 
condition in which a task can 're-arrive' without updating its queuing 
accounting.  This can lead to incorrect run_delay and rq_cpu_time 
accounting.

Consider a flow such as:

1. task p blocks, enters schedule()
2. we deactivate p
3. there's nothing else so we load balance
4. during load balance we lock balance and a remote cpu succeeds in 
re-activating p
5. we then re-pick next==p
6. we skip the accounting update since prev==next, start running p again
   (last_arrival is left polluted with our prior arrival) 

<time passes>

7. enter schedule() again, switch into new task
   a. if p blocks then we'll go through deactivate which then will 
   charge the last period as run_delay even though we were actually 
   running.
   b. if p doesn't block then we'll leave last_queued at the stale prior 
   value since last_queued != 0 in sched_info_queued.

   [*] in depart our delta will cover the span since our original arrival 
   including some (probably largely inconsequential) extra time that
   wouldn't normally be charged to us.

<time passes>

8. pick p to run again
   if 7b was true then the queue delay we charge here will again include 
   p's prior timeslice that was spent running.

One way to work around this is to charge a switch event which accounts for 
the fact that the task technically did temporarily depart and re-arrive.  
A patch for this approach is below but there are definitely other ways to 
handle it (there may also be additional concerns as further accounting 
continues to be added).

Thanks,

- Paul

 ---


It's possible for our previously de-activated task to be re-activated by a 
remote cpu during lock balancing.  We have to account for this manually 
since prev == next, yet the task just went through dequeue accounting.

 Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ee61f45..6445d9d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5381,7 +5381,7 @@ asmlinkage void __sched schedule(void)
 	struct task_struct *prev, *next;
 	unsigned long *switch_count;
 	struct rq *rq;
-	int cpu;
+	int cpu, deactivated_prev = 0;
 
 need_resched:
 	preempt_disable();
@@ -5406,8 +5406,10 @@ need_resched_nonpreemptible:
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely(signal_pending_state(prev->state, prev)))
 			prev->state = TASK_RUNNING;
-		else
+		else {
 			deactivate_task(rq, prev, 1);
+			deactivated_prev = 1;
+		}
 		switch_count = &prev->nvcsw;
 	}
 
@@ -5434,8 +5436,15 @@ need_resched_nonpreemptible:
 		 */
 		cpu = smp_processor_id();
 		rq = cpu_rq(cpu);
-	} else
+	} else {
+		/*
+		 * account for our previous task being re-activated by a
+		 * remote cpu.
+		 */
+		if (unlikely(deactivated_prev))
+			sched_info_switch(prev, prev);
 		spin_unlock_irq(&rq->lock);
+	}
 
 	post_schedule(rq);
 
-- 
1.5.4.3

