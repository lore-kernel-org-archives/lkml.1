Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbZKEFYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbZKEFYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 00:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbZKEFYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 00:24:46 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38073 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbZKEFYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 00:24:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AF26176.4080307@jp.fujitsu.com>
Date: Thu, 05 Nov 2009 14:24:06 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Spencer Candland <spencer@bluehost.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: utime/stime decreasing on thread exit
References: <4AF0C97F.7000603@bluehost.com> <4AF123F5.50407@jp.fujitsu.com>
In-Reply-To: <4AF123F5.50407@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> Spencer Candland wrote:
>> I am seeing a problem with utime/stime decreasing on thread exit in a
>> multi-threaded process.  I have been able to track this regression down
>> to the "process wide cpu clocks/timers" changes introduces in
>> 2.6.29-rc5, specifically when I revert the following commits I know
>> longer see decreasing utime/stime values:
>>
>> 4da94d49b2ecb0a26e716a8811c3ecc542c2a65d
>> 3fccfd67df79c6351a156eb25a7a514e5f39c4d9
>> 7d8e23df69820e6be42bcc41d441f4860e8c76f7
>> 4cd4c1b40d40447fb5e7ba80746c6d7ba91d7a53
>> 32bd671d6cbeda60dc73be77fa2b9037d9a9bfa0
(snip)
> 
> I'll check commits you pointed/reverted.

These are likely series of:

> commit 4cd4c1b40d40447fb5e7ba80746c6d7ba91d7a53
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Thu Feb 5 12:24:16 2009 +0100
> 
>     timers: split process wide cpu clocks/timers

This results in making sys_times() to use "clocks" instead of
"timers".  Please refer the description of the above commit.

I found 2 problems through my review.


Problem [1]:
  thread_group_cputime() vs exit

+void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
+{
+       struct sighand_struct *sighand;
+       struct signal_struct *sig;
+       struct task_struct *t;
+
+       *times = INIT_CPUTIME;
+
+       rcu_read_lock();
+       sighand = rcu_dereference(tsk->sighand);
+       if (!sighand)
+               goto out;
+
+       sig = tsk->signal;
+
+       t = tsk;
+       do {
+               times->utime = cputime_add(times->utime, t->utime);
+               times->stime = cputime_add(times->stime, t->stime);
+               times->sum_exec_runtime += t->se.sum_exec_runtime;
+
+               t = next_thread(t);
+       } while (t != tsk);
+
+       times->utime = cputime_add(times->utime, sig->utime);
+       times->stime = cputime_add(times->stime, sig->stime);
+       times->sum_exec_runtime += sig->sum_sched_runtime;
+out:
+       rcu_read_unlock();
+}

If one of (thousands) threads do exit while a thread is doing do-while
above, the s/utime of exited thread can be accounted twice, at do-while
(before exit) and at cputime_add() at last (after exit).

I suppose this is hard to fix: Taking lock on signal would solve this
problem, but it could block all other threads long and cause serious
performance issue and so on...


Problem [2]:
  use of task_s/utime()

I modified the test program more, to take times() 6 times and print them
if utime decreased between 3rd and 4th.
I noticed that I cannot explain that if the problem [1] was the root cause
then why results show decreased value continuously, instead of an increased
value at a point (like (v)(v)(V)(v)(v)(v)) which is expected.

 :
times decreased : (104 984) (104 984) (104 984) (105 983) (105 983) (105 983)
times decreased : (115 981) (116 980) (116 978) (117 977) (117 977) (119 979)
times decreased : (116 980) (117 980) (117 980) (117 977) (118 979) (118 977)
 :

And it seems that the more thread exits the more utime decreases.

Soon I found:

[kernel/exit.c]
+               sig->utime = cputime_add(sig->utime, task_utime(tsk));
+               sig->stime = cputime_add(sig->stime, task_stime(tsk));

While the thread_group_cputime() accumulates raw s/utime in do-while loop,
the signal struct accumulates adjusted s/utime of exited threads.

I'm not sure how this adjustment works but applying the following patch
makes the result little bit better:

 :
times decreased : (436 741) (436 741) (437 744) (436 742) (436 742) (436 742)
times decreased : (454 792) (454 792) (455 794) (454 792) (454 792) (454 792)
times decreased : (503 941) (503 941) (504 943) (503 941) (503 941) (503 941)
 :

But still decreasing(or increasing) continues, because there is a problem [1]
at least.

I think I couldn't handle this problem any more... Anybody can help?


Thanks,
H.Seto

===

Subject: [PATCH] thread_group_cputime() should use task_s/utime()

The signal struct accumulates adjusted cputime of exited threads,
so thread_group_cputime() should use task_s/utime() instead of raw
task->s/utime, to accumulate adjusted cputime of live threads.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 kernel/posix-cpu-timers.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 5c9dc22..e065b8a 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -248,8 +248,8 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 
 	t = tsk;
 	do {
-		times->utime = cputime_add(times->utime, t->utime);
-		times->stime = cputime_add(times->stime, t->stime);
+		times->utime = cputime_add(times->utime, task_utime(t));
+		times->stime = cputime_add(times->stime, task_stime(t));
 		times->sum_exec_runtime += t->se.sum_exec_runtime;
 
 		t = next_thread(t);
-- 
1.6.5.2

