Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZKXFeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZKXFeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 00:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZKXFeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 00:34:17 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35106 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbZKXFeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 00:34:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B0B7036.3080803@jp.fujitsu.com>
Date: Tue, 24 Nov 2009 14:33:42 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] fix granularity of task_u/stime(), v2
References: <4AFB8C21.6080404@jp.fujitsu.com> <4AFB9029.9000208@jp.fujitsu.com> <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com> <1258038038.4039.467.camel@laptop> <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com> <4B01A8DB.6090002@bluehost.com> <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com> <1258464288.7816.305.camel@laptop> <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com> <4B05F835.10401@jp.fujitsu.com> <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com>
In-Reply-To: <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislaw Gruszka wrote:
> On Fri, Nov 20, 2009 at 11:00:21AM +0900, Hidetoshi Seto wrote:
>> E.g. assume that there are 2 tasks:
>>
>> Task A: interrupted by timer few times
>>    (utime, stime, se.sum_sched_runtime) = (50, 50, 1000000000)
>>     => total of runtime is 1 sec, but utime + stime is 100 ms
>>
>> Task B: interrupted by timer many times
>>    (utime, stime, se.sum_sched_runtime) = (50, 50, 10000000)
>>     => total of runtime is 10 ms, but utime + stime is 100 ms
> 
> How tis is probable, that task is running very long, but not getting
> the ticks ? I know this is possible, otherwise we will not see utime
> decreasing after do_sys_times() siglock fix, but how probable?

For example, assume a task like watchdog that calls sleep soon after
its work.  Such task will be woken up by a timer interrupt on other
task and queued to run queue.  Once it get a cpu it can finish its
work before next tick.  So it can run long without getting any ticks
on it.  I suppose you can find such tasks in monitoring tool which
contains sampling threads that behaves like watchdog.

As the side effect, since such tasks tend to use cpu between tick
period, they make other tasks to more likely be interrupted by ticks.

>>>> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
>>>>>> index 5c9dc22..e065b8a 100644
>>>>>> --- a/kernel/posix-cpu-timers.c
>>>>>> +++ b/kernel/posix-cpu-timers.c
>>>>>> @@ -248,8 +248,8 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
>>>>>>  
>>>>>>  	t = tsk;
>>>>>>  	do {
>>>>>> -		times->utime = cputime_add(times->utime, t->utime);
>>>>>> -		times->stime = cputime_add(times->stime, t->stime);
>>>>>> +		times->utime = cputime_add(times->utime, task_utime(t));
>>>>>> +		times->stime = cputime_add(times->stime, task_stime(t));
>>>>>>  		times->sum_exec_runtime += t->se.sum_exec_runtime;
>>>>>>  
>>>>>>  		t = next_thread(t);
> 
> That works for me and I agree that this is right fix. Peter had concerns
> about p->prev_utime races and additional need for further propagation of
> task_{s,u}time() to posix-cpu-timers code. However I do not understand
> these problems.

I think that one of our concerns is the cost of task_{s,u}time(), which
might bring other problem if they are propagated.  But I found we can reduce
the cost (about the half, or more), that is why I posted task_times() patch
in other thread in LKML.


Thanks,
H.Seto

