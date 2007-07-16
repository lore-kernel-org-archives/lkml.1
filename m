Return-Path: <linux-kernel-owner+w=401wt.eu-S1760934AbXGPUNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760934AbXGPUNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXGPUM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:12:57 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55957 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752820AbXGPUM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:12:56 -0400
Date: Mon, 16 Jul 2007 13:12:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       Jonathan Corbet <corbet@lwn.net>,
       Arjan van de Ven <arjan@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH 1/8] Convert the RCU tasklet into a softirq
Message-ID: <20070716201251.GB12458@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070627193633.025544061@goodmis.org> <20070627194327.241131609@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627194327.241131609@goodmis.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 03:36:34PM -0400, Steven Rostedt wrote:
> I believe this was originally done by Dipankar Sarma. I pulled these
> changes from the -rt kernel.
> 
> For better preformance, RCU should use a softirq instead of a
> tasklet.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Tested with both kernbench and rcutorture on i386, x86_64, and ppc64.

						Thanx, Paul

> From: Dipankar Sarma <dipankar@in.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Index: linux-2.6-test/include/linux/interrupt.h
> ===================================================================
> --- linux-2.6-test.orig/include/linux/interrupt.h
> +++ linux-2.6-test/include/linux/interrupt.h
> @@ -245,6 +245,9 @@ enum
>  #ifdef CONFIG_HIGH_RES_TIMERS
>  	HRTIMER_SOFTIRQ,
>  #endif
> +	RCU_SOFTIRQ,	/* Preferable RCU should always be the last softirq */
> +	/* Entries after this are ignored in split softirq mode */
> +	MAX_SOFTIRQ,
>  };
> 
>  /* softirq mask and active fields moved to irq_cpustat_t in
> Index: linux-2.6-test/kernel/rcupdate.c
> ===================================================================
> --- linux-2.6-test.orig/kernel/rcupdate.c
> +++ linux-2.6-test/kernel/rcupdate.c
> @@ -67,7 +67,6 @@ DEFINE_PER_CPU(struct rcu_data, rcu_data
>  DEFINE_PER_CPU(struct rcu_data, rcu_bh_data) = { 0L };
> 
>  /* Fake initialization required by compiler */
> -static DEFINE_PER_CPU(struct tasklet_struct, rcu_tasklet) = {NULL};
>  static int blimit = 10;
>  static int qhimark = 10000;
>  static int qlowmark = 100;
> @@ -253,7 +252,7 @@ static void rcu_do_batch(struct rcu_data
>  	if (!rdp->donelist)
>  		rdp->donetail = &rdp->donelist;
>  	else
> -		tasklet_schedule(&per_cpu(rcu_tasklet, rdp->cpu));
> +		raise_softirq(RCU_SOFTIRQ);
>  }
> 
>  /*
> @@ -405,7 +404,6 @@ static void rcu_offline_cpu(int cpu)
>  					&per_cpu(rcu_bh_data, cpu));
>  	put_cpu_var(rcu_data);
>  	put_cpu_var(rcu_bh_data);
> -	tasklet_kill_immediate(&per_cpu(rcu_tasklet, cpu), cpu);
>  }
> 
>  #else
> @@ -417,7 +415,7 @@ static void rcu_offline_cpu(int cpu)
>  #endif
> 
>  /*
> - * This does the RCU processing work from tasklet context. 
> + * This does the RCU processing work from softirq context.
>   */
>  static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
>  					struct rcu_data *rdp)
> @@ -462,7 +460,7 @@ static void __rcu_process_callbacks(stru
>  		rcu_do_batch(rdp);
>  }
> 
> -static void rcu_process_callbacks(unsigned long unused)
> +static void rcu_process_callbacks(struct softirq_action *unused)
>  {
>  	__rcu_process_callbacks(&rcu_ctrlblk, &__get_cpu_var(rcu_data));
>  	__rcu_process_callbacks(&rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
> @@ -526,7 +524,7 @@ void rcu_check_callbacks(int cpu, int us
>  		rcu_bh_qsctr_inc(cpu);
>  	} else if (!in_softirq())
>  		rcu_bh_qsctr_inc(cpu);
> -	tasklet_schedule(&per_cpu(rcu_tasklet, cpu));
> +	raise_softirq(RCU_SOFTIRQ);
>  }
> 
>  static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
> @@ -549,7 +547,7 @@ static void __devinit rcu_online_cpu(int
> 
>  	rcu_init_percpu_data(cpu, &rcu_ctrlblk, rdp);
>  	rcu_init_percpu_data(cpu, &rcu_bh_ctrlblk, bh_rdp);
> -	tasklet_init(&per_cpu(rcu_tasklet, cpu), rcu_process_callbacks, 0UL);
> +	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
>  }
> 
>  static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
> 
> -- 
