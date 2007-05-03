Return-Path: <linux-kernel-owner+w=401wt.eu-S1767434AbXECQCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767434AbXECQCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767446AbXECQCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:02:08 -0400
Received: from loki.cs.umass.edu ([128.119.243.168]:54601 "EHLO
	mail.cs.umass.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767434AbXECQCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:02:06 -0400
X-Greylist: delayed 3572 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2007 11:59:46 EDT
Date: Thu, 3 May 2007 10:58:59 -0400 (EDT)
From: Ting Yang <tingy@cs.umass.edu>
To: mingo@elte.h
cc: a1426z@gawab.com, linux-kernel@vger.kernel.org
Subject: Re:[patch] CFS scheduler, -v7
Message-ID: <Pine.LNX.4.64.0705031054480.19236@loki.cs.umass.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Net-Tests: NO (loki, relay 127.0.0.1 auth=site-local)
X-Spam-Checked: This message probably not SPAM
X-Spam-Score: -1.36, Required: 5
X-Spam-Tests: ALL_TRUSTED
X-Spam-Report-loki: ---- Start SpamAssassin (v2.6xx-cscf) results
	-1.4 ALL_TRUSTED            Passed through trusted hosts only via SMTP
X-MIMEDefang-Relay-33c5d18245d74f8db69e921226cffa485c3189e5: 127.0.0.1
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
>
> ok - to make sure i understood you correctly: does this starvation only
> occur right when you renice it (when switching prio levels), and it gets
> rectified quickly once they get over a few reschedules?

The main problem of what Al Boldi saw might come from this piece of code 
in sched_fair.c, which scales of fair_key difference needed to preempt the 
current task:

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

This code actually now says, the difference of fair_key needed to preempt 
the current task is amplified by a facto of its weigh (in Al Boldi's 
example 32). However, the weighted task already advance its p->fair_key by 
its weight, (also 32 here). The combination of them becomes quadratic!

Let's starting from three nice 0 tasks p1, p2, p3, at time t=0, with 
niced_granularity set to be 5ms:
      Originally each task executes 5 ms in turn:
      5ms for p1, 5ms for p2, 5ms p3, 5ms for p1, 5ms for p2, 5ms for p3 ...
      If somehow p3 is re-niced to -10 _right before_ the 16th ms, we run 
into the worst case after p3 gets the cpu:
         p1->fair_key = p2 ->fair_key = 10,   p3->fair_key = 5.

      Now, in order for p3 to be preempted, it has to make its fair_key 5 * 
32 larger than p1 and p2's fair_key. Furthermore, p3 now is higher weight, 
push its fair_key to increase by 1 now needs 32ms,
thus p3 will stay one cpu for 5 * 32 *32ms, which is about 5 second!

      Besides this quadratic effect, another minor issue amplified this a 
little bit further: p->wait_runtime accumulated before. During renice it 
is not adjusted to match the new nice value. The p->wait_runtime earned 
using previous weight has to be paid off using the current weight. If 
renice to larger weight you pay more than you need, otherwise you paid 
less, which introduces unfairness.

      Ingo, now, partially solved this problem by clearing p->wait_runtime 
when a task is reniced, but the quadratic effect of scaling is still 
there.

Thanks

Ting


