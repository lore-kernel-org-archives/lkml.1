Return-Path: <linux-kernel-owner+w=401wt.eu-S1756994AbYHSSj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994AbYHSSj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbYHSSiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:38:20 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:36032 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbYHSSiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:38:19 -0400
Subject: Re: [PATCH 2/6] sched: rt-bandwidth accounting fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: linux-kernel@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <48AB120D.5000600@qualcomm.com>
References: <20080819103301.787700742@chello.nl>
	 <20080819103844.141902612@chello.nl>  <48AB120D.5000600@qualcomm.com>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 20:38:24 +0200
Message-Id: <1219171104.10800.390.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-19 at 11:33 -0700, Max Krasnyansky wrote:
> Peter Zijlstra wrote:
> > It fixes an accounting bug where we would continue accumulating runtime
> > even though the bandwidth control is disabled. This would lead to very long
> > throttle periods once bandwidth control gets turned on again.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  kernel/sched_rt.c |   11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> > 
> > Index: linux-2.6/kernel/sched_rt.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched_rt.c
> > +++ linux-2.6/kernel/sched_rt.c
> > @@ -438,9 +438,6 @@ static int sched_rt_runtime_exceeded(str
> >  {
> >  	u64 runtime = sched_rt_runtime(rt_rq);
> >  
> > -	if (runtime == RUNTIME_INF)
> > -		return 0;
> > -
> >  	if (rt_rq->rt_throttled)
> >  		return rt_rq_throttled(rt_rq);
> >  
> > @@ -491,9 +488,11 @@ static void update_curr_rt(struct rq *rq
> >  		rt_rq = rt_rq_of_se(rt_se);
> >  
> >  		spin_lock(&rt_rq->rt_runtime_lock);
> > -		rt_rq->rt_time += delta_exec;
> > -		if (sched_rt_runtime_exceeded(rt_rq))
> > -			resched_task(curr);
> > +		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
> > +			rt_rq->rt_time += delta_exec;
> > +			if (sched_rt_runtime_exceeded(rt_rq))
> > +				resched_task(curr);
> > +		}
> >  		spin_unlock(&rt_rq->rt_runtime_lock);
> >  	}
> >  }
> 
> This will make 'disabled' case more expensive, will it not ?
> I mean now we'll have to run balance_runtime() even if throttling is 
> disabled.

It should not, its cheaper now. We should never end up in
balance_runtime as we'll never exceed and hit the throttle path.

> Do you guys mind if I make this stuff configurable ? ie Just like 
> CONFIG_RT_GROUP_SCHED we could add CONFIG_RT_BANDWIDTH_THROTTLE.

Yeah - please don't do that, its ifdef fest in there - we really should
reduce the clutter, not add to it.

