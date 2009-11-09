Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbZKIOtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbZKIOtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 09:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbZKIOtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 09:49:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50863 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZKIOtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 09:49:17 -0500
Subject: Re: utime/stime decreasing on thread exit
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <4AF26176.4080307@jp.fujitsu.com>
References: <4AF0C97F.7000603@bluehost.com> <4AF123F5.50407@jp.fujitsu.com>
	 <4AF26176.4080307@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 15:49:14 +0100
Message-ID: <1257778154.4108.341.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-05 at 14:24 +0900, Hidetoshi Seto wrote:

> Problem [1]:
>   thread_group_cputime() vs exit
> 
> +void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
> +{
> +       struct sighand_struct *sighand;
> +       struct signal_struct *sig;
> +       struct task_struct *t;
> +
> +       *times = INIT_CPUTIME;
> +
> +       rcu_read_lock();
> +       sighand = rcu_dereference(tsk->sighand);
> +       if (!sighand)
> +               goto out;
> +
> +       sig = tsk->signal;
> +
> +       t = tsk;
> +       do {
> +               times->utime = cputime_add(times->utime, t->utime);
> +               times->stime = cputime_add(times->stime, t->stime);
> +               times->sum_exec_runtime += t->se.sum_exec_runtime;
> +
> +               t = next_thread(t);
> +       } while (t != tsk);
> +
> +       times->utime = cputime_add(times->utime, sig->utime);
> +       times->stime = cputime_add(times->stime, sig->stime);
> +       times->sum_exec_runtime += sig->sum_sched_runtime;
> +out:
> +       rcu_read_unlock();
> +}
> 
> If one of (thousands) threads do exit while a thread is doing do-while
> above, the s/utime of exited thread can be accounted twice, at do-while
> (before exit) and at cputime_add() at last (after exit).
> 
> I suppose this is hard to fix: Taking lock on signal would solve this
> problem, but it could block all other threads long and cause serious
> performance issue and so on...

I just checked .22 and there we seem to hold p->sighand->siglock over
the full task iteration. So we might as well revert back to that if
people really mind counting things twice :-)

FWIW getrusage() also takes siglock over the task iteration.

Alternatively, we could try reading the sig->[us]time before doing the
loop, but I guess that's still racy in that we can then miss someone
altogether.

> Problem [2]:
>   use of task_s/utime()
> 
> I modified the test program more, to take times() 6 times and print them
> if utime decreased between 3rd and 4th.
> I noticed that I cannot explain that if the problem [1] was the root cause
> then why results show decreased value continuously, instead of an increased
> value at a point (like (v)(v)(V)(v)(v)(v)) which is expected.
> 
>  :
> times decreased : (104 984) (104 984) (104 984) (105 983) (105 983) (105 983)
> times decreased : (115 981) (116 980) (116 978) (117 977) (117 977) (119 979)
> times decreased : (116 980) (117 980) (117 980) (117 977) (118 979) (118 977)
>  :
> 
> And it seems that the more thread exits the more utime decreases.
> 
> Soon I found:
> 
> [kernel/exit.c]
> +               sig->utime = cputime_add(sig->utime, task_utime(tsk));
> +               sig->stime = cputime_add(sig->stime, task_stime(tsk));
> 
> While the thread_group_cputime() accumulates raw s/utime in do-while loop,
> the signal struct accumulates adjusted s/utime of exited threads.
> 
> I'm not sure how this adjustment works but applying the following patch
> makes the result little bit better:
> 
>  :
> times decreased : (436 741) (436 741) (437 744) (436 742) (436 742) (436 742)
> times decreased : (454 792) (454 792) (455 794) (454 792) (454 792) (454 792)
> times decreased : (503 941) (503 941) (504 943) (503 941) (503 941) (503 941)
>  :
> 
> But still decreasing(or increasing) continues, because there is a problem [1]
> at least.
> 
> I think I couldn't handle this problem any more... Anybody can help?

Stick in a few trace_printk()s and see what happens?

> Subject: [PATCH] thread_group_cputime() should use task_s/utime()
> 
> The signal struct accumulates adjusted cputime of exited threads,
> so thread_group_cputime() should use task_s/utime() instead of raw
> task->s/utime, to accumulate adjusted cputime of live threads.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  kernel/posix-cpu-timers.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index 5c9dc22..e065b8a 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -248,8 +248,8 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
>  
>  	t = tsk;
>  	do {
> -		times->utime = cputime_add(times->utime, t->utime);
> -		times->stime = cputime_add(times->stime, t->stime);
> +		times->utime = cputime_add(times->utime, task_utime(t));
> +		times->stime = cputime_add(times->stime, task_stime(t));
>  		times->sum_exec_runtime += t->se.sum_exec_runtime;
>  
>  		t = next_thread(t);

So what you're trying to say is that because __exit_signal() uses
task_[usg]time() to accumulate sig->[usg]time, we should use it too in
the loop over the live threads?

I'm thinking its the task_[usg]time() usage in __exit_signal() that's
the issue.

I tried running the modified test.c on a current -tip kernel but could
not observe the problem (dual-core opteron).


