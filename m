Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZKMPiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZKMPiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZKMPiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:38:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZKMPiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:38:50 -0500
Date: Fri, 13 Nov 2009 16:36:54 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Spencer Candland <spencer@bluehost.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] sys_times: fix utime/stime decreasing on thread exit
Message-ID: <20091113153653.GA4403@dhcp-lab-161.englab.brq.redhat.com>
References: <4AFB5019.7030901@jp.fujitsu.com> <4AFB77C2.8080705@jp.fujitsu.com> <2375c9f90911111855w20491a1er8d3400cf4e027855@mail.gmail.com> <4AFB8C21.6080404@jp.fujitsu.com> <4AFB9029.9000208@jp.fujitsu.com> <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com> <1258038038.4039.467.camel@laptop> <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com> <20091113124235.GA26815@dhcp-lab-161.englab.brq.redhat.com> <1258118219.22655.203.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258118219.22655.203.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 02:16:59PM +0100, Peter Zijlstra wrote:
> > To fix we use pure tsk->{u,s}time values in __exit_signal(). This mean
> > reverting:
> > 
> > commit 49048622eae698e5c4ae61f7e71200f265ccc529
> > Author: Balbir Singh <balbir@linux.vnet.ibm.com>
> > Date:   Fri Sep 5 18:12:23 2008 +0200
> > 
> >     sched: fix process time monotonicity
> > 
> > which is also fix for some utime/stime decreasing issues. However
> > I _believe_ issues which want to be fixed in this commit, was caused
> > by Problem 1) and this patch not make them happen again.
> 
> It would be very good to verify that believe and make it a certainty.

Balbir, are some chance to avoid task_[usg]time() usage here? Could
you be so kind and give me point to reproducer program/script you used
when worked on "sched: fix process time monotonicity" commit?

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
> ---
> 
> ---diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index 5c9dc22..9b1d715 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -170,11 +170,11 @@ static void bump_cpu_timer(struct k_itimer *timer,
>  
>  static inline cputime_t prof_ticks(struct task_struct *p)
>  {
> -	return cputime_add(p->utime, p->stime);
> +	return cputime_add(task_utime(p), task_stime(p));
>  }
>  static inline cputime_t virt_ticks(struct task_struct *p)
>  {
> -	return p->utime;
> +	return task_utime(p);
>  }
>  
>  int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec
> *tp)

Something wrong with formatting.

> @@ -248,8 +248,8 @@ void thread_group_cputime(struct task_struct *tsk,
> struct task_cputime *times)
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
[snip]

Confirmed patch fix problem using reproducer from this thread.

But I don't like it much. Sad we can not do transition to opposite
direction and remove task_{u,s}time.

A few month ago I was thinking about removing cputime_t and using
long long instead, now see much more reasons of doing this, but still
lack of skills/time for that - oh dear.

Stanislaw
