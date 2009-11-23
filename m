Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbZKWKMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbZKWKMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756846AbZKWKMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:12:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756841AbZKWKMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:12:50 -0500
Date: Mon, 23 Nov 2009 11:09:26 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] fix granularity of task_u/stime(), v2
Message-ID: <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com>
References: <4AFB8C21.6080404@jp.fujitsu.com> <4AFB9029.9000208@jp.fujitsu.com> <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com> <1258038038.4039.467.camel@laptop> <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com> <4B01A8DB.6090002@bluehost.com> <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com> <1258464288.7816.305.camel@laptop> <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com> <4B05F835.10401@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B05F835.10401@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 11:00:21AM +0900, Hidetoshi Seto wrote:
> >>> Could you please test this patch, if it solve all utime decrease
> >>> problems for you:
> >>>
> >>> http://patchwork.kernel.org/patch/59795/
> >>>
> >>> If you confirm it work, I think we should apply it. Otherwise
> >>> we need to go to propagate task_{u,s}time everywhere, which is not
> >>> (my) preferred solution.
> >> That patch will create another issue, it will allow a process to hide
> >> from top by arranging to never run when the tick hits.
> > 
> 
> Yes, nowadays there are many threads on high speed hardware,
> such process can exist all around, easier than before.
> 
> E.g. assume that there are 2 tasks:
> 
> Task A: interrupted by timer few times
>    (utime, stime, se.sum_sched_runtime) = (50, 50, 1000000000)
>     => total of runtime is 1 sec, but utime + stime is 100 ms
> 
> Task B: interrupted by timer many times
>    (utime, stime, se.sum_sched_runtime) = (50, 50, 10000000)
>     => total of runtime is 10 ms, but utime + stime is 100 ms

How tis is probable, that task is running very long, but not getting
the ticks ? I know this is possible, otherwise we will not see utime
decreasing after do_sys_times() siglock fix, but how probable?

> You can see task_[su]time() works well for these tasks.
> 
> > What about that?
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 1f8d028..9db1cbc 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -5194,7 +5194,7 @@ cputime_t task_utime(struct task_struct *p)
> >  	}
> >  	utime = (cputime_t)temp;
> >  
> > -	p->prev_utime = max(p->prev_utime, utime);
> > +	p->prev_utime = max(p->prev_utime, max(p->utime, utime));
> >  	return p->prev_utime;
> >  }
> 
> I think this makes things worse.
> 
>  without this patch:
>   Task A prev_utime: 500 ms (= accurate)
>   Task B prev_utime: 5 ms (= accurate)
>  with this patch:
>   Task A prev_utime: 500 ms (= accurate)
>   Task B prev_utime: 50 ms (= not accurate)
> 
> Note that task_stime() calculates prev_stime using this prev_utime:
> 
>  without this patch:
>   Task A prev_stime: 500 ms (= accurate)
>   Task B prev_stime: 5 ms (= not accurate)
>  with this patch:
>   Task A prev_stime: 500 ms (= accurate)
>   Task B prev_stime: 0 ms (= not accurate)
> 
> >  
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index ce17760..8be5b75 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -914,8 +914,8 @@ void do_sys_times(struct tms *tms)
> >  	struct task_cputime cputime;
> >  	cputime_t cutime, cstime;
> >  
> > -	thread_group_cputime(current, &cputime);
> >  	spin_lock_irq(&current->sighand->siglock);
> > +	thread_group_cputime(current, &cputime);
> >  	cutime = current->signal->cutime;
> >  	cstime = current->signal->cstime;
> >  	spin_unlock_irq(&current->sighand->siglock);
> > 
> > It's on top of Hidetoshi patch and fix utime decrease problem 
> > on my system. 
> 
> How about the stime decrease problem which can be caused by same
> logic?

Yes, above patch screw up stime. Below should be a bit better, but
not solve objections you have:

diff --git a/kernel/exit.c b/kernel/exit.c
index f7864ac..17491ad 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -91,6 +91,8 @@ static void __exit_signal(struct task_struct *tsk)
 	if (atomic_dec_and_test(&sig->count))
 		posix_cpu_timers_exit_group(tsk);
 	else {
+		cputime_t utime, stime;
+
 		/*
 		 * If there is any task waiting for the group exit
 		 * then notify it:
@@ -110,8 +112,16 @@ static void __exit_signal(struct task_struct *tsk)
 		 * We won't ever get here for the group leader, since it
 		 * will have been the last reference on the signal_struct.
 		 */
-		sig->utime = cputime_add(sig->utime, task_utime(tsk));
-		sig->stime = cputime_add(sig->stime, task_stime(tsk));
+
+		utime = task_utime(tsk);
+		stime = task_stime(tsk);
+		if (tsk->utime > utime || tsk->stime > stime) {
+			utime = tsk->utime;
+			stime = tsk->stime;
+		}
+
+		sig->utime = cputime_add(sig->utime, utime);
+		sig->stime = cputime_add(sig->stime, stime);
 		sig->gtime = cputime_add(sig->gtime, task_gtime(tsk));
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;

> According to my labeling, there are 2 unresolved problem [1]
> "thread_group_cputime() vs exit" and [2] "use of task_s/utime()".
> 
> Still I believe the real fix for this problem is combination of
> above fix for do_sys_times() (for problem[1]) and (I know it is
> not preferred, but for [2]) the following:
> 
> >> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> >> >> index 5c9dc22..e065b8a 100644
> >> >> --- a/kernel/posix-cpu-timers.c
> >> >> +++ b/kernel/posix-cpu-timers.c
> >> >> @@ -248,8 +248,8 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
> >> >>  
> >> >>  	t = tsk;
> >> >>  	do {
> >> >> -		times->utime = cputime_add(times->utime, t->utime);
> >> >> -		times->stime = cputime_add(times->stime, t->stime);
> >> >> +		times->utime = cputime_add(times->utime, task_utime(t));
> >> >> +		times->stime = cputime_add(times->stime, task_stime(t));
> >> >>  		times->sum_exec_runtime += t->se.sum_exec_runtime;
> >> >>  
> >> >>  		t = next_thread(t);
> 

That works for me and I agree that this is right fix. Peter had concerns
about p->prev_utime races and additional need for further propagation of
task_{s,u}time() to posix-cpu-timers code. However I do not understand
these problems.

Stanislaw
