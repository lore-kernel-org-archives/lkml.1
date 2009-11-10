Return-Path: <linux-kernel-owner+w=401wt.eu-S1751669AbZKJFmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbZKJFmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 00:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbZKJFmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 00:42:42 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46392 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZKJFml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 00:42:41 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AF8FD3C.2090008@jp.fujitsu.com>
Date: Tue, 10 Nov 2009 14:42:20 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       sgruszka@redhat.com
Subject: Re: utime/stime decreasing on thread exit
References: <4AF0C97F.7000603@bluehost.com> <4AF123F5.50407@jp.fujitsu.com>	 <4AF26176.4080307@jp.fujitsu.com> <1257778154.4108.341.camel@laptop>
In-Reply-To: <1257778154.4108.341.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-11-05 at 14:24 +0900, Hidetoshi Seto wrote:
> 
>> Problem [1]:
>>   thread_group_cputime() vs exit
(snip)
> 
> I just checked .22 and there we seem to hold p->sighand->siglock over
> the full task iteration. So we might as well revert back to that if
> people really mind counting things twice :-)
> 
> FWIW getrusage() also takes siglock over the task iteration.
> 
> Alternatively, we could try reading the sig->[us]time before doing the
> loop, but I guess that's still racy in that we can then miss someone
> altogether.

Right.  So "before or after" will not be any help.

As you pointed there are some other functions taking siglock over the
task iteration, so making do_sys_times() do same will be acceptable.
In other words using many threads have risks, which might be solved in
future.  

I agree that the following patch is right fix for this.

 [PATCH 1/2] posix-cpu-timers: avoid do_sys_times() races with __exit_signal()
 http://marc.info/?l=linux-kernel&m=124505545131145



>> Problem [2]:
>>   use of task_s/utime()
>>
(snip)
>> [kernel/exit.c]
>> +               sig->utime = cputime_add(sig->utime, task_utime(tsk));
>> +               sig->stime = cputime_add(sig->stime, task_stime(tsk));
>>
>> While the thread_group_cputime() accumulates raw s/utime in do-while loop,
>> the signal struct accumulates adjusted s/utime of exited threads.
>>
>> I'm not sure how this adjustment works but applying the following patch
>> makes the result little bit better:
>>
>>  :
>> times decreased : (436 741) (436 741) (437 744) (436 742) (436 742) (436 742)
>> times decreased : (454 792) (454 792) (455 794) (454 792) (454 792) (454 792)
>> times decreased : (503 941) (503 941) (504 943) (503 941) (503 941) (503 941)
>>  :
>>
>> But still decreasing(or increasing) continues, because there is a problem [1]
>> at least.
>>
>> I think I couldn't handle this problem any more... Anybody can help?
> 
> Stick in a few trace_printk()s and see what happens?

Nice idea.
I tried it and show the result in later of this mail.

>> Subject: [PATCH] thread_group_cputime() should use task_s/utime()
>>
>> The signal struct accumulates adjusted cputime of exited threads,
>> so thread_group_cputime() should use task_s/utime() instead of raw
>> task->s/utime, to accumulate adjusted cputime of live threads.
>>
>> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>> ---
>>  kernel/posix-cpu-timers.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
>> index 5c9dc22..e065b8a 100644
>> --- a/kernel/posix-cpu-timers.c
>> +++ b/kernel/posix-cpu-timers.c
>> @@ -248,8 +248,8 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
>>  
>>  	t = tsk;
>>  	do {
>> -		times->utime = cputime_add(times->utime, t->utime);
>> -		times->stime = cputime_add(times->stime, t->stime);
>> +		times->utime = cputime_add(times->utime, task_utime(t));
>> +		times->stime = cputime_add(times->stime, task_stime(t));
>>  		times->sum_exec_runtime += t->se.sum_exec_runtime;
>>  
>>  		t = next_thread(t);
> 
> So what you're trying to say is that because __exit_signal() uses
> task_[usg]time() to accumulate sig->[usg]time, we should use it too in
> the loop over the live threads?

Right.  Thank you for trying to understand.

> 
> I'm thinking its the task_[usg]time() usage in __exit_signal() that's
> the issue.

It likely means reverting:

  commit 49048622eae698e5c4ae61f7e71200f265ccc529
  Author: Balbir Singh <balbir@linux.vnet.ibm.com>
  Date:   Fri Sep 5 18:12:23 2008 +0200
    sched: fix process time monotonicity

I'm not sure the reason why the task_[usg]time() have introduced, but
removing them would be one of solutions.

> I tried running the modified test.c on a current -tip kernel but could
> not observe the problem (dual-core opteron).

It might not happen if your box is quite fast (otherwise slow).
Changing loop in test.c (i.e. cycles in user-land) might help the
reproductivity...



Here is the result of additional test: 

I put a trace_printk() in the __exit_signal(), to print tsk->s/utime,
task_s/utime() and tsk->se.sum_exec_rumtime.
(And tsk->prev_s/utime before calling task_s/utime())

           <...>-2857  [006]   112.731732: release_task: (37 22)to(40 20), sxr 57480477, (0 0)
           <...>-5077  [009]   526.272338: release_task: (0 27)to(10 20), sxr 27997019, (0 0)
           <...>-4999  [009]   526.272396: release_task: (1 27)to(10 20), sxr 27967513, (0 0)
           <...>-4992  [006]   526.328591: release_task: (2 34)to(10 30), sxr 35823013, (0 0)
           <...>-5022  [012]   526.329183: release_task: (0 27)to(10 20), sxr 27761854, (0 0)
           <...>-4996  [010]   526.329203: release_task: (3 38)to(10 30), sxr 39200207, (0 0)

... It clearly probes that there is the 3rd problem.

Problem [3]:
   granularity of task_s/utime()

According to the git log, originally task_s/utime() were designed to
return clock_t but later changed to return cputime_t by following
commit:

  commit efe567fc8281661524ffa75477a7c4ca9b466c63
  Author: Christian Borntraeger <borntraeger@de.ibm.com>
  Date:   Thu Aug 23 15:18:02 2007 +0200

It only changes the type of return value, but not the implementation.
As the result the granularity of task_s/utime() is still that of clock_t,
not that of cputime_t. 

So using task_s/utime() in __exit_signal() makes values accumulated to the
signal struct to be rounded and coarse grained. 

After applying a fix (will follow to this mail), return values are changed
to be fine grained:

           <...>-5438  [006]   135.212289: release_task: (0 28)to(0 26), sxr 26648558, (0 0)
           <...>-5402  [015]   135.213193: release_task: (0 27)to(0 26), sxr 26725886, (0 0)
           <...>-5408  [011]   135.214172: release_task: (0 28)to(0 26), sxr 26607882, (0 0)
           <...>-5419  [005]   135.214410: release_task: (1 27)to(1 25), sxr 26612615, (0 0)
           <...>-5350  [009]   135.214937: release_task: (0 28)to(0 27), sxr 27028388, (0 0)
           <...>-5443  [008]   135.216748: release_task: (0 28)to(0 26), sxr 26372691, (0 0)

But it cannot stop adjusted values become smaller than tsk->s/utime.
So some approach to solve problem [2] is required.


Thanks,
H.Seto


