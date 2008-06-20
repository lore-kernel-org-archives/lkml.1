Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYFTLak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYFTLak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 07:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYFTLaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 07:30:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43014 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbYFTLa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:30:29 -0400
Subject: Re: wait_for_completion_timeout() spurious failure under heavy
	load?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Slaby <jirislaby@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org, Eli Cohen <eli@dev.mellanox.co.il>,
       general@lists.openfabrics.org, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20080620112042.GE7439@elte.hu>
References: <ada63s5w088.fsf@cisco.com> <485B50F1.2020802@gmail.com>
	 <20080620112042.GE7439@elte.hu>
Content-Type: text/plain
Date: Fri, 20 Jun 2008 13:30:02 +0200
Message-Id: <1213961403.3223.142.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-20 at 13:20 +0200, Ingo Molnar wrote:
> * Jiri Slaby <jirislaby@gmail.com> wrote:
> 
> >> 		do {
> >> 			timeout = schedule_timeout(timeout);
> >> 	
> >> 			if (!timeout)
> >> 				return timeout;
> >> 	
> >> 		} while (!x->done);
> >> 	
> >> 		return timeout;
> >> 	}
> >>
> >> so if the system is very busy and x->done is not set when
> >> do_wait_for_common() is entered, it is possible that the first call to
> >> schedule_timeout() returns 0 because the task doing wait_for_completion
> >
> > Sorry, but how can schedule_timeout return 0 before the timeout 
> > expiration?
> 
> the point would be that due to high load, the completion wakeup happens 
> first, but then due to scheduling delays the timeout also occurs 
> (later), before the wakeup related to x->done has managed to do its 
> task.
> 
> I.e. due to scheduling delays we report a spurious "timeout" failure, 
> despite the completion occuring before the timeout. The timeout is 
> really intended to be related to the delay of the completion event, not 
> the delay of scheduling after that event happened.
> 
> seems like a well-spotted race to me, i agree it's more robust to ignore 
> the timeout if we can make progress on x->done, and return a 1 jiffy 
> 'timeout remaining' value. Oleg, do you concur?
> 
> but i'd do it not like this:
> 
> >                       if (!timeout) {
> >                               __remove_wait_queue(&x->wait, &wait);
> > -                             return timeout;
> > +                             if (x->done) {
> > +                                     x->done--;
> > +                                     return 1;
> > +                             } else {
> > +                                     return 0;
> > +                             }
> 
> but like in the commit below. Agreed?
> 
> 	Ingo
> 
> -------------------->
> commit bb10ed0994927d433f6dbdf274fdb26cfcf516b7
> Author: Roland Dreier <rdreier@cisco.com>
> Date:   Thu Jun 19 15:04:07 2008 -0700
> 
>     sched: fix wait_for_completion_timeout() spurious failure under heavy load
>     
>     It seems that the current implementaton of wait_for_completion_timeout()
>     has a small problem under very high load for the common pattern:
>     
>     	if (!wait_for_completion_timeout(&done, timeout))
>     		/* handle failure */
>     
>     because the implementation very roughly does (lots of code deleted to
>     show the basic flow):
>     
>     	static inline long __sched
>     	do_wait_for_common(struct completion *x, long timeout, int state)
>     	{
>     		if (x->done)
>     			return timeout;
>     
>     		do {
>     			timeout = schedule_timeout(timeout);
>     
>     			if (!timeout)
>     				return timeout;
>     
>     		} while (!x->done);
>     
>     		return timeout;
>     	}
>     
>     so if the system is very busy and x->done is not set when
>     do_wait_for_common() is entered, it is possible that the first call to
>     schedule_timeout() returns 0 because the task doing wait_for_completion
>     doesn't get rescheduled for a long time, even if it is woken up early
>     enough.
>     
>     In this case, wait_for_completion_timeout() returns 0 without even
>     checking x->done again, and the code above falls into its failure case
>     purely for scheduler reasons, even if the hardware event or whatever was
>     being waited for happened early enough.
>     
>     It would make sense to add an extra test to do_wait_for() in the timeout
>     case and return 1 if x->done is actually set.
>     
>     A quick audit (not exhaustive) of wait_for_completion_timeout() callers
>     seems to indicate that no one actually cares about the return value in
>     the success case -- they just test for 0 (timed out) versus non-zero
>     (wait succeeded).
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>

Good catch,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> diff --git a/kernel/sched.c b/kernel/sched.c
> index 4a3cb06..577f160 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4405,6 +4405,16 @@ do_wait_for_common(struct completion *x, long timeout, int state)
>  			spin_unlock_irq(&x->wait.lock);
>  			timeout = schedule_timeout(timeout);
>  			spin_lock_irq(&x->wait.lock);
> +
> +			/*
> +			 * If the completion has arrived meanwhile
> +			 * then return 1 jiffy time left:
> +			 */
> +			if (x->done && !timeout) {
> +				timeout = 1;
> +				break;
> +			}
> +
>  			if (!timeout) {
>  				__remove_wait_queue(&x->wait, &wait);
>  				return timeout;

