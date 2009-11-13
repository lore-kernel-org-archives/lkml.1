Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZKMOMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZKMOMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 09:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZKMOMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 09:12:03 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:42572 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbZKMOMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 09:12:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gSn1YwqCeOSpKq4HKVUjG9Kd9IAqTlgvHfPZ9ZM/1EqDn4/QYM3wwz0iHd4O7MliqL
         hQVarKWm86UgfjyUFYe2vG071+2X4kf9M1NzU5xnT/GOB4O8mbbTOPV0XygOn4yhMl+4
         5B26lz1byZpimsIZxvS92kyDQp4/khVXLYzUM=
MIME-Version: 1.0
Reply-To: balbir@in.ibm.com
In-Reply-To: <1258118219.22655.203.camel@laptop>
References: <4AF8FE76.406@jp.fujitsu.com> <4AFB77C2.8080705@jp.fujitsu.com>
	 <2375c9f90911111855w20491a1er8d3400cf4e027855@mail.gmail.com>
	 <4AFB8C21.6080404@jp.fujitsu.com> <4AFB9029.9000208@jp.fujitsu.com>
	 <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com>
	 <1258038038.4039.467.camel@laptop>
	 <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com>
	 <20091113124235.GA26815@dhcp-lab-161.englab.brq.redhat.com>
	 <1258118219.22655.203.camel@laptop>
Date: Fri, 13 Nov 2009 19:42:07 +0530
X-Google-Sender-Auth: d89f745bba8b15be
Message-ID: <661de9470911130612s2a352663g53c629cd4720170c@mail.gmail.com>
Subject: Re: [PATCH] sys_times: fix utime/stime decreasing on thread exit
From: Balbir Singh <balbir@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Spencer Candland <spencer@bluehost.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 6:46 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2009-11-13 at 13:42 +0100, Stanislaw Gruszka wrote:
>> When we have lots of exiting thread, two consecutive calls to sys_times()
>> can show utime/stime values decrease. This can be showed by program
>> provided in this thread:
>>
>> http://lkml.org/lkml/2009/11/3/522
>>
>> We have two bugs related with this problem, both need to be fixed to make
>> issue gone.
>>
>> Problem 1) Races between thread_group_cputime() and __exit_signal()
>>
>> When process exit in the middle of thread_group_cputime() loop, {u,s}time
>> values will be accounted twice. One time - in all threads loop, second - in
>> __exit_signal(). This make sys_times() return values bigger then they
>> are in real. Next consecutive call to sys_times() return correct values,
>> so we have {u,s}time decrease.
>>
>> To fix use sighand->siglock in do_sys_times().
>>
>> Problem 2) Using adjusted stime/utime values in __exit_signal()
>>
>> Adjusted task_{u,s}time() functions can return smaller values then
>> corresponding tsk->{s,u}time. So when thread exit, thread {u/s}times
>> values accumulated in signal->{s,u}time can be smaller then
>> tsk->{u,s}times previous accounted in thread_group_cputime() loop.
>> Hence two consecutive sys_times() calls can show decrease.
>>
>> To fix we use pure tsk->{u,s}time values in __exit_signal(). This mean
>> reverting:
>>
>> commit 49048622eae698e5c4ae61f7e71200f265ccc529
>> Author: Balbir Singh <balbir@linux.vnet.ibm.com>
>> Date:   Fri Sep 5 18:12:23 2008 +0200
>>
>>     sched: fix process time monotonicity
>>
>> which is also fix for some utime/stime decreasing issues. However
>> I _believe_ issues which want to be fixed in this commit, was caused
>> by Problem 1) and this patch not make them happen again.
>
> It would be very good to verify that believe and make it a certainty.
>
> Otherwise we need to do the opposite and propagate task_[usg]time() to
> all other places... :/
>
> /me quickly stares at fs/proc/array.c:do_task_stat(), which is what top
> uses to get the times..
>
> That simply uses thread_group_cputime() properly under siglock and would
> thus indeed require the use of task_[usg]time() in order to avoid the
> stupid hiding 'exploit'..
>
> Oh bugger,..
>
> I think we do indeed need something like the below, not sure if all
> task_[usg]time() calls are now under siglock, if not they ought to be,
> otherwise there's a race with them updating p->prev_[us]time.
>
>
> ---
>
> ---diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index 5c9dc22..9b1d715 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -170,11 +170,11 @@ static void bump_cpu_timer(struct k_itimer *timer,
>
>  static inline cputime_t prof_ticks(struct task_struct *p)
>  {
> -       return cputime_add(p->utime, p->stime);
> +       return cputime_add(task_utime(p), task_stime(p));
>  }
>  static inline cputime_t virt_ticks(struct task_struct *p)
>  {
> -       return p->utime;
> +       return task_utime(p);
>  }
>
>  int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec
> *tp)
> @@ -248,8 +248,8 @@ void thread_group_cputime(struct task_struct *tsk,
> struct task_cputime *times)
>
>        t = tsk;
>        do {
> -               times->utime = cputime_add(times->utime, t->utime);
> -               times->stime = cputime_add(times->stime, t->stime);
> +               times->utime = cputime_add(times->utime, task_utime(t));
> +               times->stime = cputime_add(times->stime, task_stime(t));
>                times->sum_exec_runtime += t->se.sum_exec_runtime;
>
>                t = next_thread(t);
> @@ -517,7 +517,8 @@ static void cleanup_timers(struct list_head *head,
>  void posix_cpu_timers_exit(struct task_struct *tsk)
>  {
>        cleanup_timers(tsk->cpu_timers,
> -                      tsk->utime, tsk->stime, tsk->se.sum_exec_runtime);
> +                      task_utime(tsk), task_stime(tsk),
> +                      tsk->se.sum_exec_runtime);
>
>  }
>  void posix_cpu_timers_exit_group(struct task_struct *tsk)
> @@ -525,8 +526,8 @@ void posix_cpu_timers_exit_group(struct task_struct
> *tsk)
>        struct signal_struct *const sig = tsk->signal;
>
>        cleanup_timers(tsk->signal->cpu_timers,
> -                      cputime_add(tsk->utime, sig->utime),
> -                      cputime_add(tsk->stime, sig->stime),
> +                      cputime_add(task_utime(tsk), sig->utime),
> +                      cputime_add(task_stime(tsk), sig->stime),
>                       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
>  }
>
> @@ -1365,8 +1366,8 @@ static inline int fastpath_timer_check(struct
> task_struct *tsk)
>
>        if (!task_cputime_zero(&tsk->cputime_expires)) {
>                struct task_cputime task_sample = {
> -                       .utime = tsk->utime,
> -                       .stime = tsk->stime,
> +                       .utime = task_utime(tsk),
> +                       .stime = tsak_stime(tsk),
>                        .sum_exec_runtime = tsk->se.sum_exec_runtime
>                };

The patch looks correct upon first notice. My fault for missing these
call sites, thanks for catching them Peter. I wonder if we should
change utime and stime to __utime and __stime and force everyone to
use the accessor functions.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Balbir
