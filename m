Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbYCVRoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbYCVRoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 13:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbYCVRoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 13:44:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36549 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbYCVRoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 13:44:14 -0400
Subject: Re: [PATCH] fix rcu_try_flip_waitack_needed() to prevent
	grace-period stall
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080321203821.GA16316@linux.vnet.ibm.com>
References: <20080321203821.GA16316@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Sat, 22 Mar 2008 18:43:48 +0100
Message-Id: <1206207828.6437.84.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-21 at 13:38 -0700, Paul E. McKenney wrote:
> The comment was correct -- need to make the code match the comment.
> Without this patch, if a CPU goes dynticks idle (and stays there forever)
> in just the right phase of preemptible-RCU grace-period processing,
> grace periods stall.  The offending sequence of events (courtesy
> of Promela/spin, at least after I got the liveness criterion coded
> correctly...) is as follows:
> 
> o	CPU 0 is in dynticks-idle mode.  Its dynticks_progress_counter
> 	is (say) 10.
> 
> o	CPU 0 takes an interrupt, so rcu_irq_enter() increments CPU 0's
> 	dynticks_progress_counter to 11.
> 
> o	CPU 1 is doing RCU grace-period processing in rcu_try_flip_idle(),
> 	sees rcu_pending(), so invokes dyntick_save_progress_counter(),
> 	which in turn takes a snapshot of CPU 0's dynticks_progress_counter
> 	into CPU 0's rcu_dyntick_snapshot -- now set to 11.  CPU 1 then
> 	updates the RCU grace-period state to rcu_try_flip_waitack().
> 
> o	CPU 0 returns from its interrupt, so rcu_irq_exit() increments
> 	CPU 0's dynticks_progress_counter to 12.
> 
> o	CPU 1 later invokes rcu_try_flip_waitack(), which notices that
> 	CPU 0 has not yet responded, and hence in turn invokes
> 	rcu_try_flip_waitack_needed().  This function examines the
> 	state of CPU 0's dynticks_progress_counter and rcu_dyntick_snapshot
> 	variables, which it copies to curr (== 12) and snap (== 11),
> 	respectively.
> 
> 	Because curr!=snap, the first condition fails.
> 
> 	Because curr-snap is only 1 and snap is odd, the second
> 	condition fails.
> 
> 	rcu_try_flip_waitack_needed() therefore incorrectly concludes
> 	that it must wait for CPU 0 to explicitly acknowledge the
> 	counter flip.
> 
> o	CPU 0 remains forever in dynticks-idle mode, never taking
> 	any more hardware interrupts or any NMIs, and never running
> 	any more tasks.  (Of course, -something- will usually eventually
> 	happen, which might be why we haven't seen this one in the
> 	wild.  Still should be fixed!)
> 
> Therefore the grace period never ends.  Fix is to make the code match
> the comment, as shown below.  With this fix, the above scenario
> would be satisfied with curr being even, and allow the grace period
> to proceed.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Paul, should this go upstream ASAP?

> ---
> 
>  rcupreempt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -urpNa -X dontdiff linux-2.6.25-rc6/kernel/rcupreempt.c linux-2.6.25-rc6-rcunohz-if/kernel/rcupreempt.c
> --- linux-2.6.25-rc6/kernel/rcupreempt.c	2008-03-16 17:45:17.000000000 -0700
> +++ linux-2.6.25-rc6-rcunohz-if/kernel/rcupreempt.c	2008-03-18 20:27:47.000000000 -0700
> @@ -569,7 +569,7 @@ rcu_try_flip_waitack_needed(int cpu)
>  	 * that this CPU already acknowledged the counter.
>  	 */
>  
> -	if ((curr - snap) > 2 || (snap & 0x1) == 0)
> +	if ((curr - snap) > 2 || (curr & 0x1) == 0)
>  		return 0;
>  
>  	/* We need this CPU to explicitly acknowledge the counter flip. */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

