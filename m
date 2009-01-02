Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbZABUgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbZABUgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 15:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbZABUgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 15:36:40 -0500
Received: from mx04.mailboxcop.com ([206.125.223.74]:40564 "EHLO
	mx04.mailboxcop.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZABUgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 15:36:39 -0500
Message-ID: <495E7B5F.9080609@jaysonking.com>
Date: Fri, 02 Jan 2009 14:38:55 -0600
From: Jayson King <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [patch] Re: problem with "sched: revert back to per-rq	vruntime"?
References: <495948E0.8040502@jaysonking.com>	 <495A788B.3010001@jaysonking.com>	 <1230740773.6412.21.camel@marge.simson.net>	 <495BD346.9040408@jaysonking.com>	 <1230795963.5892.14.camel@marge.simson.net>	 <495D5C70.4090804@jaysonking.com> <1230895002.5747.46.camel@marge.simson.net>
In-Reply-To: <1230895002.5747.46.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Canit-CHI2: 0.16
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, outgoing)
X-Spam-Score: 0.10 () [Hold at 5.20] RDNS_NONE,2(1.2),6947(-1.2)
X-CanItPRO-Stream: outgoing (inherits from default)
X-Canit-Stats-ID: 334223950 - 653fffd80b13
X-Antispam-Training-Forget: http://mailboxcop.com/canit/b.php?i=334223950&m=653fffd80b13&c=f
X-Antispam-Training-Nonspam: http://mailboxcop.com/canit/b.php?i=334223950&m=653fffd80b13&c=n
X-Antispam-Training-Spam: http://mailboxcop.com/canit/b.php?i=334223950&m=653fffd80b13&c=s
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Thu, 2009-01-01 at 18:14 -0600, Jayson King wrote:
>
>   
>> Still works OK for me. You may add, if you like:
>>
>> Tested-By: Jayson King <dev@jaysonking.com>
>>     
>
> Actually, I prefer the below.  Everything in one spot and obvious.
>
> Impact: bug fixlet.
>
> Fix sched_slice() to emit a sane result whether a task is currently enqueued or not.
>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
>
>  kernel/sched_fair.c |   30 ++++++++++++------------------
>  1 files changed, 12 insertions(+), 18 deletions(-)
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 5ad4440..1a35bad 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -386,20 +386,6 @@ int sched_nr_latency_handler(struct ctl_table *table, int write,
>  #endif
>  
>  /*
> - * delta *= P[w / rw]
> - */
> -static inline unsigned long
> -calc_delta_weight(unsigned long delta, struct sched_entity *se)
> -{
> -	for_each_sched_entity(se) {
> -		delta = calc_delta_mine(delta,
> -				se->load.weight, &cfs_rq_of(se)->load);
> -	}
> -
> -	return delta;
> -}
> -
> -/*
>   * delta /= w
>   */
>  static inline unsigned long
> @@ -440,12 +426,20 @@ static u64 __sched_period(unsigned long nr_running)
>   */
>  static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  {
> -	unsigned long nr_running = cfs_rq->nr_running;
> +	u64 slice = __sched_period(cfs_rq->nr_running + !se->on_rq);
> +	
> +	for_each_sched_entity(se) {
> +		struct load_weight *load = &cfs_rq->load;
>  
> -	if (unlikely(!se->on_rq))
> -		nr_running++;
> +		if (unlikely(!se->on_rq)) {
> +			struct load_weight lw = cfs_rq->load;
>  
> -	return calc_delta_weight(__sched_period(nr_running), se);
> +			update_load_add(&lw, se->load.weight);
> +			load = &lw;
> +		}
> +		slice = calc_delta_mine(slice, se->load.weight, load);
> +	}
> +	return slice;
>  }
>  
>  /*
>   


Still good. Thanks.

Jayson

