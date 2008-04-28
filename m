Return-Path: <linux-kernel-owner+w=401wt.eu-S933118AbYD1Iem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118AbYD1Iem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932121AbYD1Ieb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:34:31 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:43489 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765867AbYD1Iea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:34:30 -0400
Subject: Re: [PATCH] sched: fair-group: fix a Div0 error of the fair group
	scheduler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: miaox@cn.fujitsu.com
Cc: Ingo Molnar <mingo@elte.hu>, Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <481558A0.9020803@cn.fujitsu.com>
References: <481558A0.9020803@cn.fujitsu.com>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 10:34:03 +0200
Message-Id: <1209371643.13978.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-28 at 12:54 +0800, Miao Xie wrote:
> When I echoed 0 into the "cpu.shares" file, a Div0 error occured.
> 
> We found it is caused by the following calling.
> 
>    sched_group_set_shares(tg, shares)
>        set_se_shares(tg->se[i], shares/nr_cpu_ids)
>            __set_se_shares(se, shares)
>                div64_64((1ULL<<32), shares)
> 
> When the echoed value was less than the number of processores, the result of the
> sentence "shares/nr_cpu_ids" was 0, and then the system called div64() to divide
> the result, the Div0 error occured.
> 
> It is unnecessary that the shares value is divided by nr_cpu_ids, I think.
> Because in the function  __update_group_shares_cpu() and init_tg_cfs_entry(),
> the shares value isn't divided by nr_cpu_ids when setting shares of the sched
> entity.
> 
> This patch fixes this bug. And echoing ULONG_MAX value into cpu.shares also
> causes Div0 error, so we set a macro MAX_SHARES to limit the max value of
> shares.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>   kernel/sched.c |   17 +++++++++++------
>   1 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 740fb40..aa1bb81 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -318,7 +318,13 @@ static DEFINE_MUTEX(doms_cur_mutex);
>   # define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
>   #endif
> 
> +/*
> + * A weight of 0, 1 or ULONG_MAX can cause arithmetics problems.
> + * (The default weight is 1024 - so there's no practical
> + *  limitation from this.)
> + */
>   #define MIN_SHARES	2
> +#define MAX_SHARES	(ULONG_MAX - 1)
> 
>   static int init_task_group_load = INIT_TASK_GROUP_LOAD;
>   #endif
> @@ -1748,6 +1754,8 @@ __update_group_shares_cpu(struct task_group *tg, struct sched_domain *sd,
> 
>   	if (shares < MIN_SHARES)
>   		shares = MIN_SHARES;
> +	else if (shares > MAX_SHARES)
> +		shares = MAX_SHARES;
> 
>   	__set_se_shares(tg->se[tcpu], shares);
>   }
> @@ -8722,13 +8730,10 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
>   	if (!tg->se[0])
>   		return -EINVAL;
> 
> -	/*
> -	 * A weight of 0 or 1 can cause arithmetics problems.
> -	 * (The default weight is 1024 - so there's no practical
> -	 *  limitation from this.)
> -	 */
>   	if (shares < MIN_SHARES)
>   		shares = MIN_SHARES;
> +	else if (shares > MAX_SHARES)
> +		shares = MAX_SHARES;
> 
>   	mutex_lock(&shares_mutex);
>   	if (tg->shares == shares)
> @@ -8753,7 +8758,7 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
>   		 * force a rebalance
>   		 */
>   		cfs_rq_set_shares(tg->cfs_rq[i], 0);
> -		set_se_shares(tg->se[i], shares/nr_cpu_ids);
> +		set_se_shares(tg->se[i], shares);
>   	}
> 
>   	/*

