Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZCIKQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZCIKQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 06:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZCIKQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 06:16:39 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:41931 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbZCIKQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 06:16:38 -0400
Message-ID: <49B4EC7B.4080504@davidnewall.com>
Date: Mon, 09 Mar 2009 20:46:27 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Galbraith <efault@gmx.de>, Balazs Scheidler <bazsi@balabit.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Willy Tarreau <w@1wt.eu>
Subject: Re: [patch] Re: scheduler oddity [bug?]
References: <1236448069.16726.21.camel@bzorp.balabit> <1236505323.6281.57.camel@marge.simson.net> <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu> <1236529200.7110.16.camel@marge.simson.net> <20090308175255.GA22802@elte.hu> <1236585731.6118.24.camel@marge.simson.net> <20090309080714.GB24904@elte.hu>
In-Reply-To: <20090309080714.GB24904@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
>   


...
>> OK, I've not seen any problem indications yet, so find patchlet below.
>>
>> However! Balazs has stated that this problem is _not_ present in .git,
>> and that..
>>
>> 	commit 38736f475071b80b66be28af7b44c854073699cc
>> 	Author: Gautham R Shenoy <ego@in.ibm.com>
>> 	Date:   Sat Sep 6 14:50:23 2008 +0530
>>
>> ..is what fixed it.  Willy Tarreau verified this as being the case on
>> his HW as well.  It is present in .git with my HW.
>>
>> I see it as a problem, but it's your call.  Dunno if I'd apply it or
>> hold back, given these conflicting reports.
>>     
>
> I think we still want it - as the purpose of the overlap metric 
> is to measure reality. If preemption causes overlap in execution 
> we should not ignore that.
>   

I'm sure it's wrong. The only call to dequeue with a non-zero sleep
value is in deactivate_task. All the rest have zero sleep. The section
of code identified by Mike in his patchlet should be moved for purpose
of clarity. It also hilights the symmetry between queue_task and
dequeue_task:

--- sched.c     2009-02-21 09:09:34.000000000 +1030
+++ sched.c.dn  2009-03-09 20:13:51.000000000 +1030
@@ -1647,12 +1647,6 @@
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
-       if (sleep && p->se.last_wakeup) {
-               update_avg(&p->se.avg_overlap,
-                          p->se.sum_exec_runtime - p->se.last_wakeup);
-               p->se.last_wakeup = 0;
-       }
-
        sched_info_dequeued(p);
        p->sched_class->dequeue_task(rq, p, sleep);
        p->se.on_rq = 0;
@@ -1724,6 +1718,12 @@
        if (task_contributes_to_load(p))
                rq->nr_uninterruptible++;
 
+       if (sleep && p->se.last_wakeup) {
+               update_avg(&p->se.avg_overlap,
+                          p->se.sum_exec_runtime - p->se.last_wakeup);
+               p->se.last_wakeup = 0;
+       }
+
        dequeue_task(rq, p, sleep);
        dec_nr_running(rq);
 }



Having done that, it makes sense to entirely remove dequeue_task 's
sleep parameter, and replicate all three lines in deactivate_task:

--- sched.c.dn  2009-03-09 20:41:13.000000000 +1030
+++ sched.c.dn2 2009-03-09 20:41:30.000000000 +1030
@@ -1645,10 +1645,10 @@
        p->se.on_rq = 1;
 }
 
-static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
+static void dequeue_task(struct rq *rq, struct task_struct *p)
 {
        sched_info_dequeued(p);
-       p->sched_class->dequeue_task(rq, p, sleep);
+       p->sched_class->dequeue_task(rq, p, 0);
        p->se.on_rq = 0;
 }
 
@@ -1724,7 +1724,11 @@
                p->se.last_wakeup = 0;
        }
 
-       dequeue_task(rq, p, sleep);
+       /*dequeue_task(rq, p, sleep);*/
+       sched_info_dequeued(p);
+       p->sched_class->dequeue_task(rq, p, sleep);
+       p->se.on_rq = 0;
+
        dec_nr_running(rq);
 }
 
@@ -4848,7 +4852,7 @@
        on_rq = p->se.on_rq;
        running = task_current(rq, p);
        if (on_rq)
-               dequeue_task(rq, p, 0);
+               dequeue_task(rq, p);
        if (running)
                p->sched_class->put_prev_task(rq, p);
 
@@ -4897,7 +4901,7 @@
        }
        on_rq = p->se.on_rq;
        if (on_rq)
-               dequeue_task(rq, p, 0);
+               dequeue_task(rq, p);
 
        p->static_prio = NICE_TO_PRIO(nice);
        set_load_weight(p);
@@ -8637,7 +8641,7 @@
        on_rq = tsk->se.on_rq;
 
        if (on_rq)
-               dequeue_task(rq, tsk, 0);
+               dequeue_task(rq, tsk);
        if (unlikely(running))
                tsk->sched_class->put_prev_task(rq, tsk);
 


