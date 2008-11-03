Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYKCKVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYKCKVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 05:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYKCKVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 05:21:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:43571 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbYKCKVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 05:21:42 -0500
Subject: Re: [PATCH] small optimization to update_curr_rt
From: Peter Zijlstra <peterz@infradead.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20081031130341.GA12018@sgi.com>
References: <20081031130341.GA12018@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 03 Nov 2008 11:22:04 +0100
Message-Id: <1225707724.7803.1612.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-31 at 08:03 -0500, Dimitri Sivanich wrote:
> A very minor improvement, but might it be better to check sched_rt_runtime(rt_rq)
> before taking the rt_runtime_lock?

Yes, I think its ok to do so.

Like pointed out in the other thread, there are two races:

 - sched_rt_runtime() going to RUNTIME_INF, and that will be handled
   properly by sched_rt_runtime_exceeded()

 - sched_rt_runtime() going to !RUNTIME_INF, and here we can miss an
   accounting cycle, but I don't think that is something to worry too
   much about.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> 
> --
> 
>  kernel/sched_rt.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux/kernel/sched_rt.c
> ===================================================================
> --- linux.orig/kernel/sched_rt.c	2008-10-22 16:10:03.000000000 -0500
> +++ linux/kernel/sched_rt.c	2008-10-31 07:57:19.000000000 -0500
> @@ -537,13 +537,13 @@ static void update_curr_rt(struct rq *rq
>  	for_each_sched_rt_entity(rt_se) {
>  		rt_rq = rt_rq_of_se(rt_se);
>  
> -		spin_lock(&rt_rq->rt_runtime_lock);
>  		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
> +			spin_lock(&rt_rq->rt_runtime_lock);
>  			rt_rq->rt_time += delta_exec;
>  			if (sched_rt_runtime_exceeded(rt_rq))
>  				resched_task(curr);
> +			spin_unlock(&rt_rq->rt_runtime_lock);
>  		}
> -		spin_unlock(&rt_rq->rt_runtime_lock);
>  	}
>  }
>  
