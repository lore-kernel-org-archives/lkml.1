Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZJ0Oaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZJ0Oaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbZJ0Oaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:30:52 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37925 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbZJ0Oav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:30:51 -0400
Date: Tue, 27 Oct 2009 07:30:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sofirq: make rcu_irq_enter()/rcu_irq_exit() called in
	pairs
Message-ID: <20091027143043.GI6645@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4AE6A88B.8000004@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE6A88B.8000004@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 04:00:11PM +0800, Lai Jiangshan wrote:
> 
> irq_enter() calls rcu_irq_enter() unconditionally,
> the same as irq_exit() calls rcu_irq_exit().
> 
> It does not change the binary because rcu_irq_enter()
> is dummy when !CONFIG_NO_HZ.
> 
> It's just a cleanup.

This does look like a nice cleanup!  I will pull it in and test it.

Yes, it should be provably the same, but RCU has taught me to be quite
paranoid.  ;-)

						Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index f8749e5..21939d9 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -302,9 +302,9 @@ void irq_exit(void)
>  	if (!in_interrupt() && local_softirq_pending())
>  		invoke_softirq();
> 
> +	rcu_irq_exit();
>  #ifdef CONFIG_NO_HZ
>  	/* Make sure that timer wheel updates are propagated */
> -	rcu_irq_exit();
>  	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
>  		tick_nohz_stop_sched_tick(0);
>  #endif
> 
