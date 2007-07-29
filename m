Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbXG2GF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbXG2GF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 02:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755311AbXG2GFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 02:05:14 -0400
Received: from gw.goop.org ([64.81.55.164]:58173 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbXG2GFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 02:05:12 -0400
Message-ID: <46AC2D9C.3080307@goop.org>
Date: Sat, 28 Jul 2007 23:03:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: make cpu_clock() not use the rq clock
References: <20070726090012.GA5287@elte.hu>
In-Reply-To: <20070726090012.GA5287@elte.hu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Subject: sched: make cpu_clock() not use the rq clock
>   

This subject doesn't make much sense to me.  All this patch does is get
the rq's current time under irq_disable rather than spinlock, right?

    J

> From: Ingo Molnar <mingo@elte.hu>
>
> it is enough to disable interrupts to get the precise rq-clock
> of the local CPU.
>
> this also solves an NMI watchdog regression: the NMI watchdog
> calls touch_softlockup_watchdog(), which might deadlock on
> rq->lock if the NMI hits an rq-locked critical section.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/sched.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> Index: linux-rt-rebase.q/kernel/sched.c
> ===================================================================
> --- linux-rt-rebase.q.orig/kernel/sched.c
> +++ linux-rt-rebase.q/kernel/sched.c
> @@ -446,13 +446,12 @@ static inline unsigned long long rq_cloc
>   */
>  unsigned long long cpu_clock(int cpu)
>  {
> -	struct rq *rq = cpu_rq(cpu);
>  	unsigned long long now;
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&rq->lock, flags);
> -	now = rq_clock(rq);
> -	spin_unlock_irqrestore(&rq->lock, flags);
> +	local_irq_save(flags);
> +	now = rq_clock(cpu_rq(cpu));
> +	local_irq_restore(flags);
>  
>  	return now;
>  }
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

