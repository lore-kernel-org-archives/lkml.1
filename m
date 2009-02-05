Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbZBEX7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbZBEX7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZBEX7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:59:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:47278 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbZBEX7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:59:10 -0500
Subject: Re: [PATCH 2/2] sched_rt: protect rt_rq->rt_time by rt_runtime_lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <498B7862.2040004@ct.jp.nec.com>
References: <498B77F6.4020702@ct.jp.nec.com>
	 <498B7862.2040004@ct.jp.nec.com>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 00:59:03 +0100
Message-Id: <1233878343.4620.44.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-05 at 15:38 -0800, Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Impact: fix possible race condition
> 
> rt_rq->rt_time should be protected.

Don't think so, all we do is check the value for non-zero outside the
lock, that should be ok.

If there's still a race, your changelog utterly fails to mention the
race scenario.

> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  kernel/sched_rt.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 299d012..d7654a3 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -496,10 +496,10 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
>  		struct rq *rq = rq_of_rt_rq(rt_rq);
>  
>  		spin_lock(&rq->lock);
> +		spin_lock(&rt_rq->rt_runtime_lock);
>  		if (rt_rq->rt_time) {
>  			u64 runtime;
>  
> -			spin_lock(&rt_rq->rt_runtime_lock);
>  			if (rt_rq->rt_throttled)
>  				balance_runtime(rt_rq);
>  			runtime = rt_rq->rt_runtime;
> @@ -510,9 +510,9 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
>  			}
>  			if (rt_rq->rt_time || rt_rq->rt_nr_running)
>  				idle = 0;
> -			spin_unlock(&rt_rq->rt_runtime_lock);
>  		} else if (rt_rq->rt_nr_running)
>  			idle = 0;
> +		spin_unlock(&rt_rq->rt_runtime_lock);
>  
>  		if (enqueue)
>  			sched_rt_rq_enqueue(rt_rq);

