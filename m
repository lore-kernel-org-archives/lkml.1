Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbYFLIuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbYFLIuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 04:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbYFLItx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:49:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52336 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbYFLItw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:49:52 -0400
Subject: Re: [PATCH 1/2] sched: fair group: fix overflow(was: fix divide by
	zero)
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: mingo@elte.hu, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4850E192.3080804@cn.fujitsu.com>
References: <484F7AC5.8040206@cn.fujitsu.com>
	 <1213168547.31518.66.camel@twins>  <4850E192.3080804@cn.fujitsu.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 10:49:44 +0200
Message-Id: <1213260584.31518.86.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 16:42 +0800, Lai Jiangshan wrote:
> Peter Zijlstra wrote:
> > 
> > I think the same thing to do is limit the shares value to something
> > smaller instead of using an even more expensive divide.
> > 
> 
> yes, you are right!
> 
> I found another bug about "the shares value is too large":
> 
> pid1 and pid2 are set affinity to cpu#0
> pid1 is attached to cg1 and pid2 is attached to cg2
> 
> if cg1/cpu.shares = 1024 cg2/cpu.shares = 2000000000
> then pid2 got 100% usage of cpu, and pid1 0%
> 
> if cg1/cpu.shares = 1024 cg2/cpu.shares = 20000000000
> then pid2 got 0% usage of cpu, and pid1 100%
> 
> 
> And a weight of a cfs_rq is the sum of weights of which entities
> are queued on this cfs_rq, so the shares value should be limited
> to a smaller value.

Yeah, a lot of stuff will fall apart when weights grow too large, I
think somewhere the load balance code also assumes weight * NICE_0_LOAD
always fits in a long. So that immediately limits us to 32-10=22 bits
(on 32bit systems).

There might be other funnies..

> I think that (1UL << 18) is a good limited value:
> 1)it's not too large, we can create a lot of group before overflow
> 2)it's several times the weight value for nice=-19 (not too small)

Thanks!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/sched.c b/kernel/sched.c
> index bfb8ad8..fe1b6c7 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -312,12 +312,15 @@ static DEFINE_SPINLOCK(task_group_lock);
>  #endif
>  
>  /*
> - * A weight of 0, 1 or ULONG_MAX can cause arithmetics problems.
> + * A weight of 0 or 1 can cause arithmetics problems.
> + * A weight of a cfs_rq is the sum of weights of which entities
> + * are queued on this cfs_rq, so a weight of a entity should not be
> + * too large, so as the shares value of a task group.
>   * (The default weight is 1024 - so there's no practical
>   *  limitation from this.)
>   */
>  #define MIN_SHARES	2
> -#define MAX_SHARES	(ULONG_MAX - 1)
> +#define MAX_SHARES	(1UL << 18)
>  
>  static int init_task_group_load = INIT_TASK_GROUP_LOAD;
>  #endif
> 
> 
> 
> 

