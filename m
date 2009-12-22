Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbZLVObz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbZLVObz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 09:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZLVObx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 09:31:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbZLVObw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 09:31:52 -0500
Subject: Re: 2.6.33-rc1 unusable due to scheduler issues, circular locking,
 WARNs and BUGs
From: Eric Paris <eparis@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, efault@gmx.de
In-Reply-To: <1261471720.4937.9.camel@laptop>
References: <1261441037.3273.254.camel@localhost>
	 <1261471720.4937.9.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 01:29:42 -0500
Message-ID: <1261463382.2923.1.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-22 at 09:48 +0100, Peter Zijlstra wrote:
> On Mon, 2009-12-21 at 19:17 -0500, Eric Paris wrote:
> > Trying to build a kernel on a 48 core x86_64 box using make -j 64 and
> > I'm exploding in the scheduler.  I'm running (and building) kernel
> > f7b84a6ba7eaeba4e1df8feddca1473a7db369a5  There are three distinct
> > signatures of problems.  Some boots I'll see all 3 of these failures
> > sometimes only 1 or 2 of them.  That's the reason they are kinda split
> > up in dmesg.

Appears the kernel built with no oops, circular locking, or bugs.  Only
thing in dmesg during the build was:

DMA-API: debugging out of memory - disabling

I'm going to do it a number more times to be sure, but I had 100%
failure rate before.  Sounds like this patch has got to go.

-Eric

> > 
> > 1) gcc/3141 is trying to acquire lock:
> >  (&(&sem->wait_lock)->rlock){......}, at: [<ffffffff81223234>] __down_read_trylock+0x13/0x46
> > 
> > but task is already holding lock:
> >  (&rq->lock){-.-.-.}, at: [<ffffffff8103dd2d>] task_rq_lock+0x51/0x83
> 
> This is due to the pagefalut happening while holding the rq->lock, so
> its an artefact of 3).
> 
> > 2) WARN() in kernel/sched_fair.c:1001 hrtick_start_fair()
> 
> Worrying, but probably due to the same problem as 3)
> 
> > 3) NULL pointer dereference at 0000000000000168 in check_preempt_wakeup
> >       kernel/sched_fair.c
> 
> Right, hard to tell where exactly it goes bang, but could you please try
> reverting the below patch.
> 
> What I suspect happens is that we his the task_cpu(p)==cpu case, we then
> don't do __set_task_cpu()->set_task_rq(), which sets the group
> scheduling pointers (you seem to have cgroup scheduling enabled).
> 
> If those pointers are wild all kinds of interesting bits can happen,
> including 3) and possibly 2).
> 
> If this revert doesn't help, could you please also provide the output of
> addr2line -e vmlinux <FAULT_IP> ?
> 
> ---
> commit 738d2be4301007f054541c5c4bf7fb6a361c9b3a
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Wed Dec 16 18:04:42 2009 +0100
> 
>     sched: Simplify set_task_cpu()
>     
>     Rearrange code a bit now that its a simpler function.
>     
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Cc: Mike Galbraith <efault@gmx.de>
>     LKML-Reference: <20091216170518.269101883@chello.nl>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index f92ce63..8a2bfd3 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2034,11 +2034,8 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
>  	return delta < (s64)sysctl_sched_migration_cost;
>  }
>  
> -
>  void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
>  {
> -	int old_cpu = task_cpu(p);
> -
>  #ifdef CONFIG_SCHED_DEBUG
>  	/*
>  	 * We should never call set_task_cpu() on a blocked task,
> @@ -2049,11 +2046,11 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
>  
>  	trace_sched_migrate_task(p, new_cpu);
>  
> -	if (old_cpu != new_cpu) {
> -		p->se.nr_migrations++;
> -		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS,
> -				     1, 1, NULL, 0);
> -	}
> +	if (task_cpu(p) == new_cpu)
> +		return;
> +
> +	p->se.nr_migrations++;
> +	perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
>  
>  	__set_task_cpu(p, new_cpu);
>  }
> 
> 


