Return-Path: <linux-kernel-owner+w=401wt.eu-S1162090AbXECPCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162090AbXECPCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162112AbXECPCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:02:20 -0400
Received: from dodo.cs.umass.edu ([128.119.242.12]:63043 "EHLO
	dodo.cs.umass.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162090AbXECPCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:02:18 -0400
Message-ID: <4639F970.5080701@cs.umass.edu>
Date: Thu, 03 May 2007 11:02:08 -0400
From: Ting Yang <tingy@cs.umass.edu>
Reply-To: tingy@cs.umass.edu
Organization: ALI Lab, CS Dept, UMASS
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v7
References: <200704300820.49078.a1426z@gawab.com> <20070503074552.GA14960@elte.hu>
In-Reply-To: <20070503074552.GA14960@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo

    This is the test case that I think worth discuss and it leads me to 
find 2 things.

>> [...] but there are still some nice issues.
>>
>> Try running 3 chew.c's, then renicing one to -10, starves others for 
>> some seconds while switching prio-level.  Now renice it back to 10, it 
>> starves for up to 45sec.
>>     
>
> ok - to make sure i understood you correctly: does this starvation only 
> occur right when you renice it (when switching prio levels), and it gets 
> rectified quickly once they get over a few reschedules?
The main problem of what Al Boldi saw might come from this piece of code 
in sched_fair.c, which scales of fair_key difference needed to preempt 
the current task:

+rescale_load(struct task_struct *p, u64 value)
+{
+    int load_shift = p->load_shift;
+
+    if (load_shift == SCHED_LOAD_SHIFT)
+        return value;
+
+    return (value << load_shift) >> SCHED_LOAD_SHIFT;
+}
+
+static u64
+niced_granularity(struct rq *rq, struct task_struct *curr,
+          unsigned long granularity)
+{
+    return rescale_load(curr, granularity);
+}

Here is the checking for pre-emption:

+static inline void
+__check_preempt_curr_fair(struct rq *rq, struct task_struct *p,
+              struct task_struct *curr, unsigned long granularity)
+{
+    s64 __delta = curr->fair_key - p->fair_key;
+
+    /*
+     * Take scheduling granularity into account - do not
+     * preempt the current task unless the best task has
+     * a larger than sched_granularity fairness advantage:
+     */
+    if (__delta > niced_granularity(rq, curr, granularity))
+        resched_task(curr);
+}

This code actually now says, the difference of fair_key needed to 
preempt the current task is amplified by a facto of its weigh (in Al 
Boldi's example 32). However, the weighted task already advance its 
p->fair_key by its weight, (also 32 here). The combination of them 
becomes quadratic!

Let's starting from three nice 0 tasks p1, p2, p3, at time t=0, with 
niced_granularity set to be 5ms:
     Originally each task executes 5 ms in turn:
                  5ms for p1, 5ms for p2, 5ms p3, 5ms for p1, 5ms for 
p2, 5ms for p3 ...
     If somehow p3 is re-niced to -10 _right before_ the 16th ms, we run 
into the worst case after p3 gets the cpu:
        p1->fair_key = p2 ->fair_key = 10,   p3->fair_key = 5.
    
     Now, in order for p3 to be preempted, it has to make its fair_key 5 
* 32 larger than p1 and p2's fair_key. Furthermore, p3 now is higher 
weight, push its fair_key to increase by 1 now needs 32ms,
thus p3 will stay one cpu for 5 * 32 *32ms, which is about 5 second!
    
     Besides this quadratic effect, another minor issue amplified this a 
little bit further: p->wait_runtime accumulated before. During renice it 
is not adjusted to match the new nice value. The p->wait_runtime earned 
using previous weight has to be paid off using the current weight. If 
renice to larger weight you pay more than you need, otherwise you paid 
less, which introduces unfairness.

     Ingo, now, partially solved this problem by clearing 
p->wait_runtime when a task is reniced, but the quadratic effect of 
scaling is still there.

Thanks

Ting

