Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbYFLIur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbYFLIur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 04:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbYFLIuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:50:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52442 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbYFLIui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:50:38 -0400
Subject: Re: [PATCH 2/2] sched: 64bit: fix overflow(was: fix divide by zero)
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: mingo@elte.hu, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4850E19B.1050202@cn.fujitsu.com>
References: <4850E19B.1050202@cn.fujitsu.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 10:50:34 +0200
Message-Id: <1213260634.31518.88.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 16:43 +0800, Lai Jiangshan wrote:
> (overflow means weight >= 2^32 here, because inv_weigh = 2^32/weight)
> 
> A weight of a cfs_rq is the sum of weights of which entities
> are queued on this cfs_rq, so it will be overflow when entities
> are too many. 
> 
> Although, overflow is very hardly occurred, but it break fairness when
> it is occurred. And 64bits system have more memory than 32bits system
> and 64bits system can create more process usually, so overflow many be
> occurred more.
> 
> This patch guarantee fairness when overflow in 64bits system.
> Thanks to the optimization of compiler, it change nothing in 32bits system.

Yeah,. bit sad for that one branch extra on 64-bit, but I get the
unlikely is as good as we can get it.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/sched.c b/kernel/sched.c
> index bfb8ad8..e277533 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1337,8 +1337,13 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
>  {
>  	u64 tmp;
>  
> -	if (!lw->inv_weight)
> -		lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)/(lw->weight+1);
> +	if (!lw->inv_weight) {
> +		if (BITS_PER_LONG > 32 && unlikely(lw->weight >= WMULT_CONST))
> +			lw->inv_weight = 1;
> +		else
> +			lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)
> +				/ (lw->weight+1);
> +	}
>  
>  	tmp = (u64)delta_exec * weight;
>  	/*
> 
> 
> 
> 

