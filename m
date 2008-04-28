Return-Path: <linux-kernel-owner+w=401wt.eu-S932816AbYD1I1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbYD1I1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765742AbYD1I1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:27:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65383 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1765863AbYD1I1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:27:22 -0400
Message-ID: <48158A78.5010904@cn.fujitsu.com>
Date: Mon, 28 Apr 2008 16:27:36 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fair-group: fix a Div0 error of the fair group
 scheduler
References: <481558A0.9020803@cn.fujitsu.com> <1209361544.6429.4.camel@lappy>
In-Reply-To: <1209361544.6429.4.camel@lappy>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2008-4-28 13:45 Peter Zijlstra wrote:
> On Mon, 2008-04-28 at 12:54 +0800, Miao Xie wrote:
>> When I echoed 0 into the "cpu.shares" file, a Div0 error occured.
>>
>> We found it is caused by the following calling.
>>
>>    sched_group_set_shares(tg, shares)
>>        set_se_shares(tg->se[i], shares/nr_cpu_ids)
>>            __set_se_shares(se, shares)
>>                div64_64((1ULL<<32), shares)
>>
>> When the echoed value was less than the number of processores, the result of the
>> sentence "shares/nr_cpu_ids" was 0, and then the system called div64() to divide
>> the result, the Div0 error occured.
>>
>> It is unnecessary that the shares value is divided by nr_cpu_ids, I think.
>> Because in the function  __update_group_shares_cpu() and init_tg_cfs_entry(),
>> the shares value isn't divided by nr_cpu_ids when setting shares of the sched
>> entity.
>>
>> This patch fixes this bug. And echoing ULONG_MAX value into cpu.shares also
>> causes Div0 error, so we set a macro MAX_SHARES to limit the max value of
>> shares.
> 
> how about:
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 740fb40..b68127a 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8025,7 +8025,7 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
>  
>  	se->my_q = cfs_rq;
>  	se->load.weight = tg->shares;
> -	se->load.inv_weight = div64_64(1ULL<<32, se->load.weight);
> +	se->load.inv_weight = 0;
>  	se->parent = parent;
>  }
>  #endif
> @@ -8692,7 +8692,7 @@ static void __set_se_shares(struct sched_entity *se, unsigned long shares)
>  		dequeue_entity(cfs_rq, se, 0);
>  
>  	se->load.weight = shares;
> -	se->load.inv_weight = div64_64((1ULL<<32), shares);
> +	se->load.inv_weight = 0;
>  
>  	if (on_rq)
>  		enqueue_entity(cfs_rq, se, 0);
> 

I'm sorry, I didn't explained clearly.Though echoing ULONG_MAX value into
cpu.shares causes Div0 error, this error was not caused by the above code.
It is caused by the following code.

    calc_delta_mine()
        ->lw->inv_weight = (WMULT_CONST-lw->weight/2) / (lw->weight+1);

And besides, the Div0 error caused by echoing ULONG_MAX occured on the UP system
or on SMP system with only one cpu.

So this patch fixes the bug caused by echoing a number which was less than the number
of processores into the "cpu.shares" file, but doesn't fix the bug caused by echoing
ULONG_MAX.

