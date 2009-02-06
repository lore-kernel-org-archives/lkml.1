Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbZBFAG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbZBFAG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbZBFAGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:06:45 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:49391 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbZBFAGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:06:44 -0500
Message-ID: <498B7F13.7040104@ct.jp.nec.com>
Date: Thu, 05 Feb 2009 16:06:43 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] sched_rt: protect rt_rq->rt_time by rt_runtime_lock
References: <498B77F6.4020702@ct.jp.nec.com>	 <498B7862.2040004@ct.jp.nec.com> <1233878343.4620.44.camel@laptop>
In-Reply-To: <1233878343.4620.44.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-02-05 at 15:38 -0800, Hiroshi Shimamoto wrote:
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> Impact: fix possible race condition
>>
>> rt_rq->rt_time should be protected.
> 
> Don't think so, all we do is check the value for non-zero outside the
> lock, that should be ok.
> 
> If there's still a race, your changelog utterly fails to mention the
> race scenario.

OK. I just noticed rt_time is accessed with rt_runtime_lock held except
this point. Will look at this again.

Thanks,
Hiroshi

> 
>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> ---
>>  kernel/sched_rt.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
>> index 299d012..d7654a3 100644
>> --- a/kernel/sched_rt.c
>> +++ b/kernel/sched_rt.c
>> @@ -496,10 +496,10 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
>>  		struct rq *rq = rq_of_rt_rq(rt_rq);
>>  
>>  		spin_lock(&rq->lock);
>> +		spin_lock(&rt_rq->rt_runtime_lock);
>>  		if (rt_rq->rt_time) {
>>  			u64 runtime;
>>  
>> -			spin_lock(&rt_rq->rt_runtime_lock);
>>  			if (rt_rq->rt_throttled)
>>  				balance_runtime(rt_rq);
>>  			runtime = rt_rq->rt_runtime;
>> @@ -510,9 +510,9 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
>>  			}
>>  			if (rt_rq->rt_time || rt_rq->rt_nr_running)
>>  				idle = 0;
>> -			spin_unlock(&rt_rq->rt_runtime_lock);
>>  		} else if (rt_rq->rt_nr_running)
>>  			idle = 0;
>> +		spin_unlock(&rt_rq->rt_runtime_lock);
>>  
>>  		if (enqueue)
>>  			sched_rt_rq_enqueue(rt_rq);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

