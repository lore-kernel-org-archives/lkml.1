Return-Path: <linux-kernel-owner+w=401wt.eu-S935991AbYEBSqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935991AbYEBSqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763032AbYEBSqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:46:25 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49656 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762818AbYEBSqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:46:24 -0400
Message-ID: <481B6175.6070207@austin.ibm.com>
Date: Fri, 02 May 2008 13:46:13 -0500
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anton Blanchard <anton@au1.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: questions on calc_delta_mine() in sched.c
References: <481A2BF6.2070406@austin.ibm.com>	 <1209730442.6508.3.camel@lappy>  <1209731455.6508.8.camel@lappy> <1209733807.6929.0.camel@lappy>
In-Reply-To: <1209733807.6929.0.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This one builds and... boots

I'll try to test in on my end.

> +	struct load_weight lw_cache[4];
> +	int lw_cache_idx;
> +
>  	struct cfs_rq cfs;
>  	struct rt_rq rt;
>  
> @@ -1438,8 +1441,24 @@ calc_delta_mine(unsigned long delta_exec
>  {
>  	u64 tmp;
>  
> -	if (unlikely(!lw->inv_weight))
> -		lw->inv_weight = (WMULT_CONST-lw->weight/2) / (lw->weight+1);
> +	if (!lw->inv_weight) {

Yep, got to get rid of unlikely.

> +		struct rq *rq = cpu_rq(smp_processor_id());
> +		unsigned long weight = lw->weight;
> +		int i;
> +
> +		for (i = 0; i < ARRAY_SIZE(rq->lw_cache); i++) {
> +			if (rq->lw_cache[i].weight == weight)
> +				lw->inv_weight = rq->lw_cache[i].inv_weight;
> +			goto got_inv;
> +		}
> +		if (unlikely(!weight))
> +			weight++;
> +		lw->inv_weight = 1 + (WMULT_CONST - weight/2) / weight;

I bet just dividing by weight + 1 unconditionally would be cheaper than 
doing the test and shouldn't skew results too badly.

> +		rq->lw_cache[rq->lw_cache_idx] = *lw;
> +		rq->lw_cache_idx++;
> +		rq->lw_cache_idx %= ARRAY_SIZE(rq->lw_cache);
> +	}
> + got_inv:

Doctor, I think the cure is worse than the disease.   I'd expect that even 
if all these extra loads hit cache they should together be more expensive 
than the divide they save.   Not that I have any better solutions myself.

>  
>  	tmp = (u64)delta_exec * weight;
>  	/*
> @@ -8025,7 +8044,7 @@ static void init_tg_cfs_entry(struct tas
>  
>  	se->my_q = cfs_rq;
>  	se->load.weight = tg->shares;
> -	se->load.inv_weight = div64_64(1ULL<<32, se->load.weight);
> +	se->load.inv_weight = 0;
>  	se->parent = parent;
>  }
>  #endif
> @@ -8692,7 +8711,7 @@ static void __set_se_shares(struct sched
>  		dequeue_entity(cfs_rq, se, 0);
>  
>  	se->load.weight = shares;
> -	se->load.inv_weight = div64_64((1ULL<<32), shares);
> +	se->load.inv_weight = 0;
>  
>  	if (on_rq)
>  		enqueue_entity(cfs_rq, se, 0);
> 
> 

I think a patch to get rid of unlikely and to change these two div64_64 to 
0s should be pushed up.  Not sure what we do about the divide.


