Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbZAEHyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbZAEHyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 02:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZAEHy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 02:54:28 -0500
Received: from viefep13-int.chello.at ([62.179.121.33]:45611 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750836AbZAEHy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 02:54:27 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] Re: problem with "sched: revert back to per-rq
 vruntime"?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Jayson King <dev@jaysonking.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <1230895002.5747.46.camel@marge.simson.net>
References: <495948E0.8040502@jaysonking.com>
	 <495A788B.3010001@jaysonking.com>
	 <1230740773.6412.21.camel@marge.simson.net>
	 <495BD346.9040408@jaysonking.com>
	 <1230795963.5892.14.camel@marge.simson.net>
	 <495D5C70.4090804@jaysonking.com>
	 <1230895002.5747.46.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 08:54:04 +0100
Message-Id: <1231142044.30237.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-02 at 12:16 +0100, Mike Galbraith wrote:
> On Thu, 2009-01-01 at 18:14 -0600, Jayson King wrote:
> 
> > Still works OK for me. You may add, if you like:
> > 
> > Tested-By: Jayson King <dev@jaysonking.com>
> 
> Actually, I prefer the below.  Everything in one spot and obvious.
> 
> Impact: bug fixlet.
> 
> Fix sched_slice() to emit a sane result whether a task is currently enqueued or not.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>

Looks good, thanks Mike!!

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
> 

