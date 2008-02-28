Return-Path: <linux-kernel-owner+w=401wt.eu-S1762589AbYB1A00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762589AbYB1A00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759131AbYB1A0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:26:18 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:47325 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbYB1A0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:26:17 -0500
Date: Wed, 27 Feb 2008 16:26:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] using smp_processor_id() in preemptible as suspending
Message-ID: <20080228002606.GE9634@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080226082411.GA2853@darkstar.te-china.tietoenator.com> <20080226194504.GC8395@linux.vnet.ibm.com> <a8e1da0802261704t34eae4b9q758d22ee88fff3a9@mail.gmail.com> <200802280011.49386.fzu@wemgehoertderstaat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802280011.49386.fzu@wemgehoertderstaat.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 12:11:48AM +0100, Karsten Wiese wrote:
> Am Mittwoch, 27. Februar 2008 schrieb Dave Young:
> > On Wed, Feb 27, 2008 at 3:45 AM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> > > On Tue, Feb 26, 2008 at 08:33:54AM -0800, Andrew Morton wrote:
> > >  > On Tue, 26 Feb 2008 16:24:11 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
> > >  >
> > >  > > I don't know whom I should mail to, could you cc the proper guy? Thanks.
> > >
> > >  Hello, Dave,
> > >
> > >  Would you be willing to try out the following (untested, might not even
> > >  compile) patch show at the very end of this message?  This assumes that
> > >  you were running with CONFIG_PREEMPT_RCU, which seems most likely based
> > >  on looking at your oops.
> > 
> > Built ok, but can't even resume now. (dark screen with cursor blinking
> > on top-left of minitor)
> 
> Dave, can you give this untested patch a try?

The second part of the patch is similar to the one I sent to Dave
earlier for testing (it worked for him, so I just now posted to LKML).
The advantage of my approach is that it retains the pair of disabled
sections, rather than merging them as yours does.

That said, as near as I can tell, your patch should work.

							Thanx, Paul

> thanks,
>       Karsten
> 
> ---
> diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
> index c7c5209..5a7f8fc 100644
> --- a/kernel/rcupreempt.c
> +++ b/kernel/rcupreempt.c
> @@ -878,18 +878,20 @@ void rcu_offline_cpu(int cpu)
>  	 * Otherwise rcu_barrier() will fail
>  	 */
> 
> -	spin_lock_irqsave(&rdp->lock, flags);
> +	local_irq_save(flags);
> +
> +	spin_lock(&rdp->lock);
>  	rcu_offline_cpu_enqueue(rdp->donelist, rdp->donetail, list, tail);
>  	for (i = GP_STAGES - 1; i >= 0; i--)
>  		rcu_offline_cpu_enqueue(rdp->waitlist[i], rdp->waittail[i],
>  						list, tail);
>  	rcu_offline_cpu_enqueue(rdp->nextlist, rdp->nexttail, list, tail);
> -	spin_unlock_irqrestore(&rdp->lock, flags);
> +	spin_unlock(&rdp->lock);
>  	rdp->waitlistcount = 0;
> 
>  	/* Disengage the newly dead CPU from the grace-period computation. */
> 
> -	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
> +	spin_lock(&rcu_ctrlblk.fliplock);
>  	rcu_check_mb(cpu);
>  	if (per_cpu(rcu_flip_flag, cpu) == rcu_flipped) {
>  		smp_mb();  /* Subsequent counter accesses must see new value */
> @@ -906,7 +908,7 @@ void rcu_offline_cpu(int cpu)
> 
>  	cpu_clear(cpu, rcu_cpu_online_map);
> 
> -	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
> +	spin_unlock(&rcu_ctrlblk.fliplock);
> 
>  	/*
>  	 * Place the removed callbacks on the current CPU's queue.
> @@ -919,11 +921,13 @@ void rcu_offline_cpu(int cpu)
>  	 */
> 
>  	rdp = RCU_DATA_ME();
> -	spin_lock_irqsave(&rdp->lock, flags);
> +	spin_lock(&rdp->lock);
>  	*rdp->nexttail = list;
>  	if (list)
>  		rdp->nexttail = tail;
> -	spin_unlock_irqrestore(&rdp->lock, flags);
> +	spin_unlock(&rdp->lock);
> +
> +	local_irq_restore(flags);
>  }
> 
>  void __devinit rcu_online_cpu(int cpu)
