Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbZJIHKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbZJIHKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 03:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZJIHKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 03:10:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:44726 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbZJIHKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 03:10:33 -0400
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Frans Pop <elendil@planet.nl>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-wireless@vger.kernel.org
In-Reply-To: <1255070103.7639.30.camel@marge.simson.net>
References: <200910051500.55875.elendil@planet.nl>
	 <200910081655.37485.elendil@planet.nl>
	 <1255026217.6643.12.camel@marge.simson.net>
	 <200910082259.35204.elendil@planet.nl>
	 <1255070103.7639.30.camel@marge.simson.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Oct 2009 09:13:53 +0200
Message-Id: <1255072433.26976.351.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 08:35 +0200, Mike Galbraith wrote:
> 
> sched: update the clock of runqueue select_task_rq() selected.
> 
> In try_to_wake_up(), we update the runqueue clock, but select_task_rq()
> may select a different runqueue than the one we updated, leaving the new
> runqueue's clock stale for a bit.
> 
> This patch cures occasional huge latencies reported by latencytop when
> coming out of idle on a mostly idle NO_HZ box.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>


Awesome catch Mike, seems I goofed up in my recent ttwu changes.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> 
> ---
>  kernel/sched.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2311,7 +2311,7 @@ static int try_to_wake_up(struct task_st
>  {
>         int cpu, orig_cpu, this_cpu, success = 0;
>         unsigned long flags;
> -       struct rq *rq;
> +       struct rq *rq, *orig_rq;
>  
>         if (!sched_feat(SYNC_WAKEUPS))
>                 wake_flags &= ~WF_SYNC;
> @@ -2319,7 +2319,7 @@ static int try_to_wake_up(struct task_st
>         this_cpu = get_cpu();
>  
>         smp_wmb();
> -       rq = task_rq_lock(p, &flags);
> +       rq = orig_rq = task_rq_lock(p, &flags);
>         update_rq_clock(rq);
>         if (!(p->state & state))
>                 goto out;
> @@ -2350,6 +2350,10 @@ static int try_to_wake_up(struct task_st
>                 set_task_cpu(p, cpu);
>  
>         rq = task_rq_lock(p, &flags);
> +
> +       if (rq != orig_rq)
> +               update_rq_clock(rq);
> +
>         WARN_ON(p->state != TASK_WAKING);
>         cpu = task_cpu(p);
>  
> 
> 
> 
