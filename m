Return-Path: <linux-kernel-owner+w=401wt.eu-S936849AbXFGVC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936849AbXFGVC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbXFGVCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:02:51 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34702 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbXFGVCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:02:49 -0400
Date: Thu, 7 Jun 2007 14:02:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       RT <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH RT] convert RCU Preempt tasklet into softirq.
Message-ID: <20070607210247.GA9390@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1181180051.18444.31.camel@localhost.localdomain> <20070607041411.GB1783@linux.vnet.ibm.com> <1181226138.18444.54.camel@localhost.localdomain> <20070607161754.GA11941@linux.vnet.ibm.com> <1181240819.10408.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181240819.10408.14.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 02:26:59PM -0400, Steven Rostedt wrote:
> Following Dipankar's lead, I converted the tasklet in rcupreempt.c into
> a softirq.
> 
> I've compiled and booted with this patch, but ran no other tests.

I should be able to run rcutorture on it.

> Paul,  I'm disappointed, this was so trivial I didn't get a chance to
> learn anything ;-)

;-)

Some nits below.

						Thanx, Paul

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Index: linux-2.6.21-rt9/include/linux/rcupreempt.h
> ===================================================================
> --- linux-2.6.21-rt9.orig/include/linux/rcupreempt.h
> +++ linux-2.6.21-rt9/include/linux/rcupreempt.h
> @@ -63,7 +63,9 @@ extern void rcu_check_callbacks(int cpu,
>  extern void rcu_restart_cpu(int cpu);
>  extern long rcu_batches_completed(void);
> 
> -extern void rcu_process_callbacks(unsigned long unused);
> +struct softirq_action;
> +
> +extern void rcu_process_callbacks(struct softirq_action *unused);

I don't understand why the above is needed -- interrupt.h is included,
and the use of rcu_process_callbacks() follows the definition.

>  #endif /* __KERNEL__ */
>  #endif /* __LINUX_RCUPREEMPT_H */
> Index: linux-2.6.21-rt9/kernel/rcupreempt.c
> ===================================================================
> --- linux-2.6.21-rt9.orig/kernel/rcupreempt.c
> +++ linux-2.6.21-rt9/kernel/rcupreempt.c
> @@ -57,7 +57,6 @@
>  struct rcu_data {
>  	raw_spinlock_t	lock;
>  	long		completed;	/* Number of last completed batch. */
> -	struct tasklet_struct rcu_tasklet;
>  	struct rcu_head *nextlist;
>  	struct rcu_head **nexttail;
>  	struct rcu_head *waitlist;
> @@ -255,7 +254,7 @@ void rcu_check_callbacks(int cpu, int us
>  		spin_unlock_irqrestore(&rcu_data.lock, oldirq);
>  	} else {
>  		spin_unlock_irqrestore(&rcu_data.lock, oldirq);
> -		tasklet_schedule(&rcu_data.rcu_tasklet);
> +		raise_softirq(RCU_SOFTIRQ);
>  	}
>  }
> 
> @@ -279,7 +278,7 @@ void rcu_advance_callbacks(int cpu, int 
>  	spin_unlock_irqrestore(&rcu_data.lock, oldirq);
>  }
> 
> -void rcu_process_callbacks(unsigned long unused)
> +void rcu_process_callbacks(struct softirq_action *unused)
>  {
>  	unsigned long flags;
>  	struct rcu_head *next, *list;
> @@ -367,7 +366,7 @@ void __init __rcu_init(void)
>  	rcu_data.waittail = &rcu_data.waitlist;
>  	rcu_data.donelist = NULL;
>  	rcu_data.donetail = &rcu_data.donelist;
> -	tasklet_init(&rcu_data.rcu_tasklet, rcu_process_callbacks, 0UL);
> +	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
>  }
> 
>  /*
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
