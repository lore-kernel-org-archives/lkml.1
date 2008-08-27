Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYH0IWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYH0IWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 04:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYH0IVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 04:21:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50920 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbYH0IVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 04:21:50 -0400
Subject: Re: [PATCH v2 3/6] sched: make double-lock-balance fair
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, srostedt@redhat.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, npiggin@suse.de,
       gregory.haskins@gmail.com
In-Reply-To: <20080826173500.16413.40514.stgit@dev.haskins.net>
References: <20080826173131.16413.17862.stgit@dev.haskins.net>
	 <20080826173500.16413.40514.stgit@dev.haskins.net>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 10:21:35 +0200
Message-Id: <1219825295.6462.54.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 13:35 -0400, Gregory Haskins wrote:
> double_lock balance() currently favors logically lower cpus since they
> often do not have to release their own lock to acquire a second lock.
> The result is that logically higher cpus can get starved when there is
> a lot of pressure on the RQs.  This can result in higher latencies on
> higher cpu-ids.
> 
> This patch makes the algorithm more fair by forcing all paths to have
> to release both locks before acquiring them again.  Since callsites to
> double_lock_balance already consider it a potential preemption/reschedule
> point, they have the proper logic to recheck for atomicity violations.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  kernel/sched.c |   52 +++++++++++++++++++++++++++++++++++++++++++++-------
>  1 files changed, 45 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index df6b447..850b454 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2782,21 +2782,43 @@ static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
>  		__release(rq2->lock);
>  }
>  
> +#ifdef CONFIG_PREEMPT
> +
>  /*
> - * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
> + * fair double_lock_balance: Safely acquires both rq->locks in a fair
> + * way at the expense of forcing extra atomic operations in all
> + * invocations.  This assures that the double_lock is acquired using the
> + * same underlying policy as the spinlock_t on this architecture, which
> + * reduces latency compared to the unfair variant below.  However, it
> + * also adds more overhead and therefore may reduce throughput.
>   */
> -static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
> +static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
> +	__releases(this_rq->lock)
> +	__acquires(busiest->lock)
> +	__acquires(this_rq->lock)
> +{
> +	spin_unlock(&this_rq->lock);
> +	double_rq_lock(this_rq, busiest);
> +
> +	return 1;
> +}

Right - so to belabour Nick's point:

  if (!spin_trylock(&busiest->lock)) {
    spin_unlock(&this_rq->lock);
    double_rq_lock(this_rq, busiest);
  }

might unfairly treat someone who is waiting on this_rq if I understand
it right?

I suppose one could then write it like:

  if (spin_is_contended(&this_rq->lock) || !spin_trylock(&busiest->lock)) {
    spin_unlock(&this_rq->lock);
    double_rq_lock(this_rq, busiest);
  }

But, I'm not sure that's worth the effort at that point..

Anyway - I think all this is utterly defeated on CONFIG_PREEMPT by the
spin with IRQs enabled logic in kernel/spinlock.c.

Making this an -rt only patch...

