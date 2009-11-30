Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbZK3O5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbZK3O5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 09:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZK3O5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 09:57:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbZK3O5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 09:57:33 -0500
Date: Mon, 30 Nov 2009 15:54:43 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 2/2] cputime: introduce thread_group_times()
Message-ID: <20091130145442.GA2326@dhcp-lab-161.englab.brq.redhat.com>
References: <1258038038.4039.467.camel@laptop> <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com> <4B01A8DB.6090002@bluehost.com> <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com> <1258464288.7816.305.camel@laptop> <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com> <4B05F835.10401@jp.fujitsu.com> <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com> <20091123101612.GC25978@dhcp-lab-161.englab.brq.redhat.com> <4B138EA0.90007@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B138EA0.90007@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 06:21:36PM +0900, Hidetoshi Seto wrote:
> This patch fixes the above problem in the following way:
> 
>  - Modify thread's exit (= __exit_signal()) not to use task_times().
>    It means {u,s}time in signal struct accumulates raw values instead
>    of adjusted values.  As the result it makes thread_group_cputime()
>    to return pure sum of "raw" values.
> 
>  - Introduce a new function thread_group_times(*task, *utime, *stime)
>    that converts "raw" values of thread_group_cputime() to "adjusted"
>    values, in same calculation procedure as task_times().
> 
>  - Modify group's exit (= wait_task_zombie()) to use this introduced
>    thread_group_times().  It make c{u,s}time in signal struct to
>    have adjusted values like before this patch.
> 
>  - Replace some thread_group_cputime() by thread_group_times().
>    This replacements are only applied where conveys the "adjusted"
>    cputime to users, and where already uses task_times() near by it.
>    (i.e. sys_times(), getrusage(), and /proc/<PID>/stat.)
> 
> This patch have a positive side effect:
> 
>  - Before this patch, if a group contains many short-life threads
>    (e.g. runs 0.9ms and not interrupted by ticks), the group's
>    cputime could be invisible since thread's cputime was accumulated
>    after adjusted: imagine adjustment function as adj(ticks, runtime),
>      {adj(0, 0.9) + adj(0, 0.9) + ....} = {0 + 0 + ....} = 0.
>    After this patch it will not happen because the adjustment is
>    applied after accumulated.

Idea is very good IMHO.

> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  fs/proc/array.c       |    5 +---
>  include/linux/sched.h |    3 +-
>  kernel/exit.c         |   23 +++++++++++----------
>  kernel/fork.c         |    2 +
>  kernel/sched.c        |   52 +++++++++++++++++++++++++++++++++++++++++++++++-
>  kernel/sys.c          |   18 +++++++---------
>  6 files changed, 75 insertions(+), 28 deletions(-)

[snip]

>  #ifndef CONFIG_VIRT_CPU_ACCOUNTING
> -	cputime_t prev_utime, prev_stime;
> +	cputime_t prev_utime, prev_stime, prev_tgutime, prev_tgstime;
>  #endif

I think the new values should be part of struct_signal (see below)

> +static void __thread_group_times(struct task_struct *p,
> +				 struct task_cputime *cputime)
> +{
> +	cputime_t rtime, utime, total;
> +
> +	thread_group_cputime(p, cputime);
> +
> +	total = cputime_add(cputime->utime, cputime->stime);
> +	rtime = nsecs_to_cputime(cputime->sum_exec_runtime);
> +
> +	if (total) {
> +		u64 temp;
> +
> +		temp = (u64)(rtime * cputime->utime);
> +		do_div(temp, total);
> +		utime = (cputime_t)temp;
> +	} else
> +		utime = rtime;
> +
> +	p->prev_tgutime = max(p->prev_tgutime, utime);
> +	p->prev_tgstime = max(p->prev_tgstime,
> +			      cputime_sub(rtime, p->prev_tgutime));

p->sig->prev_utime = max(p->sig->prev_utime, utime);
p->sig->prev_stime = max(p->sig->prev_stime,
   		     	cputime_sub(rtime, p->sig->prev_utime));

>  /*
> + * Must be called with siglock held.
> + */
> +void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
> +{
> +	struct task_cputime cputime;
> +
> +	__thread_group_times(p, &cputime);
> +
> +	if (ut)
> +		*ut = cputime.utime;
> +	if (st)
> +		*st = cputime.stime;

No thread_group_times() nor task_times() is called with NULL arguments, we
can get rid of "if ({u,s}t)" checks. Perhaps thread_group_times() should
have "struct task_cputime" argument as it is wrapper for
thread_group_cputime();

Thanks
Stanislaw
