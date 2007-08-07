Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbXHGNMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbXHGNMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759532AbXHGNMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:12:12 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47698 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759320AbXHGNML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:12:11 -0400
Date: Tue, 7 Aug 2007 18:42:16 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
       Paul E McKenney <paulmck@us.ibm.com>
Subject: Cpu-Hotplug and Real-Time
Message-ID: <20070807131216.GA20424@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

While running a cpu-hotplug test involving a high priority
process (SCHED_RR, prio=94) trying to periodically offline and
online cpu1 on a 2-processor machine, I noticed that the system was
becoming unresponsive after a few iterations.

However, when the same test was repeated with processors
greater than 2, it worked fine. 
Also, if the hotplugging process, was not of rt-prio, it
worked fine on a 2-processor machine.

After some debugging, I saw that the hang occured because
the high prio process was stuck in a loop doing yield() inside
wait_task_inactive(). Description follows:

Say a high-prio task (A) does a kthread_create(B),
followed by a kthread_bind(B, cpu1). At this moment, 
only cpu0 is online.

Now, immediately after being created, B would
do a 
complete(&create->started) [kernel/kthread.c: kthread()], 
before scheduling itself out.

This complete() will wake up kthreadd, which had spawned B.
It is possible that during the wakeup, kthreadd might preempt B.
Thus, B is still on the runqueue, and not yet called schedule().

kthreadd, will inturn do a 
complete(&create->done); [kernel/kthread.c: create_kthread()]
which will wake up the thread which had called kthread_create().
In our case it's task A, which will run immediately, since its priority
is higher.

A will now call kthread_bind(B, cpu1).
kthread_bind(), calls wait_task_inactive(B), to ensures that 
B has scheduled itself out.

B is still on the runqueue, so A calls yield() in wait_task_inactive().
But since A is the task with the highest prio, scheduler schedules it
back again.

Thus B never gets to run to schedule itself out.
A loops waiting for B to schedule out leading  to system hang.

In my case,
A was the high priority process trying to bring up cpu1, and
thus doing a kthread_create/kthread_bind in 
migration_call(): CPU_UP_PREPARE.

B was the migration thread for cpu1.

And the above problem occurs when only one cpu is online.

Possible solutions to this problem:
a) Let the newly spawned kernel threads inherit
   their parent's prio and policy. 

b) Instead of using yield() in wait_task_inactive(), we could use
   something like a yield_to(p):

    yield_to(struct task_struct p)
    {
    	int old_prio = p->prio;
	/* Temporarily boost p's priority atleast to that of current task */
    	if (current->prio > old_prio)
		set_prio(p, current->prio);
	yield();
	/* Reset priority back to the original value */
	set_prio(p, old_prio);
    }


Thoughts?

Thanks and Regards
gautham.

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
