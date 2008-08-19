Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbYHSSeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbYHSSeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbYHSSdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:33:54 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4744 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbYHSSdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:33:53 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5364"; a="5834134"
Message-ID: <48AB120D.5000600@qualcomm.com>
Date: Tue, 19 Aug 2008 11:33:49 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/6] sched: rt-bandwidth accounting fix
References: <20080819103301.787700742@chello.nl> <20080819103844.141902612@chello.nl>
In-Reply-To: <20080819103844.141902612@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> It fixes an accounting bug where we would continue accumulating runtime
> even though the bandwidth control is disabled. This would lead to very long
> throttle periods once bandwidth control gets turned on again.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched_rt.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6/kernel/sched_rt.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_rt.c
> +++ linux-2.6/kernel/sched_rt.c
> @@ -438,9 +438,6 @@ static int sched_rt_runtime_exceeded(str
>  {
>  	u64 runtime = sched_rt_runtime(rt_rq);
>  
> -	if (runtime == RUNTIME_INF)
> -		return 0;
> -
>  	if (rt_rq->rt_throttled)
>  		return rt_rq_throttled(rt_rq);
>  
> @@ -491,9 +488,11 @@ static void update_curr_rt(struct rq *rq
>  		rt_rq = rt_rq_of_se(rt_se);
>  
>  		spin_lock(&rt_rq->rt_runtime_lock);
> -		rt_rq->rt_time += delta_exec;
> -		if (sched_rt_runtime_exceeded(rt_rq))
> -			resched_task(curr);
> +		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
> +			rt_rq->rt_time += delta_exec;
> +			if (sched_rt_runtime_exceeded(rt_rq))
> +				resched_task(curr);
> +		}
>  		spin_unlock(&rt_rq->rt_runtime_lock);
>  	}
>  }

This will make 'disabled' case more expensive, will it not ?
I mean now we'll have to run balance_runtime() even if throttling is 
disabled.

Do you guys mind if I make this stuff configurable ? ie Just like 
CONFIG_RT_GROUP_SCHED we could add CONFIG_RT_BANDWIDTH_THROTTLE.

Max
