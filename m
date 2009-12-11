Return-Path: <linux-kernel-owner+w=401wt.eu-S934886AbZLKHZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934886AbZLKHZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 02:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934827AbZLKHZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 02:25:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:56169 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934824AbZLKHZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 02:25:23 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/uwP4WMj7uTAwiL63BeGRqH3wEs87rfErbvztyVm
	t4XNkSbsHq1SsZ
Subject: Re: check_preempt_tick() check vruntime mistake?
From: Mike Galbraith <efault@gmx.de>
To: XingChao Wang <wxc200@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <fd6b62c10912102017g56b8651aj2b8cbe569b0f90a6@mail.gmail.com>
References: <fd6b62c10912102017g56b8651aj2b8cbe569b0f90a6@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 11 Dec 2009 08:25:26 +0100
Message-Id: <1260516326.6090.61.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 12:17 +0800, XingChao Wang wrote:
> Hi Ingo,peter,
> 
> When check_preempt_tick() selects next leftmost sched_entity,it
> calculates delta vruntime of curr and leftmost entity, then compares
> it with ideal_runtime. But ideal_runtime is real-time type, need
> convert it to virtual-time ,right?

Why?  The scheduler converges vruntimes to within min_granularity,
that's it's mission.  What this test is trying to say is that if the
awakened task's lag has grown to be more than your quantum while we
waited for the tick to come along, you need to get out of it's way so it
can catch up.

Now, there are a couple ~problems in that in it's current form, it
offers protection to SCHED_BATCH and SCHED_IDLE tasks, and the test..

if (delta_exec < sysctl_sched_min_granularity)
	return;

..is... not exactly optimal for light weight tasks, but the lighter you
get, the more likely you'd already have been preempted...

I have a patch which excludes these, and computes min runtime based on
differential in task weights.  These are the only things I see ~wrong.
ideal_runtime is weighted, and is our "fair unit of measure", so using
it to measure acceptable lag distance is correct AFAIKS.

> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 37087a7..9b903d4 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -840,7 +840,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct
> sched_entity *curr)
>                 struct sched_entity *se = __pick_next_entity(cfs_rq);
>                 s64 delta = curr->vruntime - se->vruntime;
> 
> -               if (delta > ideal_runtime)
> +               if (delta > calc_delta_fair(ideal_runtime, curr))
>                         resched_task(rq_of(cfs_rq)->curr);
>         }
>  }
> 
> thanks
> --wang xingchao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

