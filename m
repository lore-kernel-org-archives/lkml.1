Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbZKTCAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbZKTCAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 21:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757230AbZKTCAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 21:00:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44885 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbZKTCAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 21:00:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B05F835.10401@jp.fujitsu.com>
Date: Fri, 20 Nov 2009 11:00:21 +0900
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
References: <4AFB77C2.8080705@jp.fujitsu.com> <2375c9f90911111855w20491a1er8d3400cf4e027855@mail.gmail.com> <4AFB8C21.6080404@jp.fujitsu.com> <4AFB9029.9000208@jp.fujitsu.com> <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com> <1258038038.4039.467.camel@laptop> <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com> <4B01A8DB.6090002@bluehost.com> <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com> <1258464288.7816.305.camel@laptop> <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com>
In-Reply-To: <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislaw Gruszka wrote:
> On Tue, Nov 17, 2009 at 02:24:48PM +0100, Peter Zijlstra wrote:
>>> Seems issue reported then was exactly the same as reported now by
>>> you. Looks like commit 49048622eae698e5c4ae61f7e71200f265ccc529 just
>>> make probability of bug smaller and you did not note it until now.  
>>>
>>> Could you please test this patch, if it solve all utime decrease
>>> problems for you:
>>>
>>> http://patchwork.kernel.org/patch/59795/
>>>
>>> If you confirm it work, I think we should apply it. Otherwise
>>> we need to go to propagate task_{u,s}time everywhere, which is not
>>> (my) preferred solution.
>> That patch will create another issue, it will allow a process to hide
>> from top by arranging to never run when the tick hits.
> 

Yes, nowadays there are many threads on high speed hardware,
such process can exist all around, easier than before.

E.g. assume that there are 2 tasks:

Task A: interrupted by timer few times
   (utime, stime, se.sum_sched_runtime) = (50, 50, 1000000000)
    => total of runtime is 1 sec, but utime + stime is 100 ms

Task B: interrupted by timer many times
   (utime, stime, se.sum_sched_runtime) = (50, 50, 10000000)
    => total of runtime is 10 ms, but utime + stime is 100 ms

You can see task_[su]time() works well for these tasks.

> What about that?
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 1f8d028..9db1cbc 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5194,7 +5194,7 @@ cputime_t task_utime(struct task_struct *p)
>  	}
>  	utime = (cputime_t)temp;
>  
> -	p->prev_utime = max(p->prev_utime, utime);
> +	p->prev_utime = max(p->prev_utime, max(p->utime, utime));
>  	return p->prev_utime;
>  }

I think this makes things worse.

 without this patch:
  Task A prev_utime: 500 ms (= accurate)
  Task B prev_utime: 5 ms (= accurate)
 with this patch:
  Task A prev_utime: 500 ms (= accurate)
  Task B prev_utime: 50 ms (= not accurate)

Note that task_stime() calculates prev_stime using this prev_utime:

 without this patch:
  Task A prev_stime: 500 ms (= accurate)
  Task B prev_stime: 5 ms (= not accurate)
 with this patch:
  Task A prev_stime: 500 ms (= accurate)
  Task B prev_stime: 0 ms (= not accurate)

>  
> diff --git a/kernel/sys.c b/kernel/sys.c
> index ce17760..8be5b75 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -914,8 +914,8 @@ void do_sys_times(struct tms *tms)
>  	struct task_cputime cputime;
>  	cputime_t cutime, cstime;
>  
> -	thread_group_cputime(current, &cputime);
>  	spin_lock_irq(&current->sighand->siglock);
> +	thread_group_cputime(current, &cputime);
>  	cutime = current->signal->cutime;
>  	cstime = current->signal->cstime;
>  	spin_unlock_irq(&current->sighand->siglock);
> 
> It's on top of Hidetoshi patch and fix utime decrease problem 
> on my system. 

How about the stime decrease problem which can be caused by same
logic?

According to my labeling, there are 2 unresolved problem [1]
"thread_group_cputime() vs exit" and [2] "use of task_s/utime()".

Still I believe the real fix for this problem is combination of
above fix for do_sys_times() (for problem[1]) and (I know it is
not preferred, but for [2]) the following:

>> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
>> >> index 5c9dc22..e065b8a 100644
>> >> --- a/kernel/posix-cpu-timers.c
>> >> +++ b/kernel/posix-cpu-timers.c
>> >> @@ -248,8 +248,8 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
>> >>  
>> >>  	t = tsk;
>> >>  	do {
>> >> -		times->utime = cputime_add(times->utime, t->utime);
>> >> -		times->stime = cputime_add(times->stime, t->stime);
>> >> +		times->utime = cputime_add(times->utime, task_utime(t));
>> >> +		times->stime = cputime_add(times->stime, task_stime(t));
>> >>  		times->sum_exec_runtime += t->se.sum_exec_runtime;
>> >>  
>> >>  		t = next_thread(t);

Think about this diff, assuming task C is in same group of task A and B:

 sys_times() on C while A and B are living returns:
  (utime, stime)
   = task_[su]time(C) + ([su]time(A)+[su]time(B)+...) + in_signal(exited)
   = task_[su]time(C) + ( (50,50)   +  (50,50)  +...) + in_signal(exited)
 If A exited, it increases:
  (utime, stime)
   = task_[su]time(C) + ([su]time(B)+...) + in_signal(exited)+task_[su]time(A)
   = task_[su]time(C) + (  (50,50)  +...) + in_signal(exited)+(500,500)
 Otherwise if B exited, it decreases:
  (utime, stime)
   = task_[su]time(C) + ([su]time(A)+...) + in_signal(exited)+task_[su]time(B)
   = task_[su]time(C) + (  (50,50)  +...) + in_signal(exited)+(5,5)

 With this fix, sys_times() returns:
  (utime, stime)
   = task_[su]time(C) + (task_[su]time(A)+task_[su]time(B)+...) + in_signal(exited)
   = task_[su]time(C) + (   (500,500)    +       (5,5)    +...) + in_signal(exited)
 
> Are we not doing something nasty here?
> 
>         cputime_t utime = p->utime, total = utime + p->stime;
>         u64 temp;
> 
>         /*
>          * Use CFS's precise accounting:
>          */
>         temp = (u64)nsecs_to_cputime(p->se.sum_exec_runtime);
> 
>         if (total) {
>                 temp *= utime;
>                 do_div(temp, total);
>         }
> 	utime = (cputime_t)temp;

Not here, but doing do_div() for each thread could be said nasty.
I mean
  __task_[su]time(sum(A, B, ...))
would be better than:
  sum(task_[su]time(A)+task_[su]time(B)+...)

However it would bring another issue, because
  __task_[su]time(sum(A, B, ...))
might not equal to
  __task_[su]time(sum(B, ...)) + task_[su]time(A)


Thanks,
H.Seto

