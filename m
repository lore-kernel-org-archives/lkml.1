Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbZFJRm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbZFJRm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbZFJRmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:42:19 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37549 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbZFJRmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 13:42:19 -0400
Date: Wed, 10 Jun 2009 10:42:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, mingo@elte.hu,
       rusty@rustcorp.com.au, davem@davemloft.net
Subject: Re: [this_cpu_xx 11/11] RCU: Use this_cpu operations
Message-ID: <20090610174218.GP6773@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090605191819.376530498@gentwo.org> <20090605191852.373830111@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605191852.373830111@gentwo.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 03:18:30PM -0400, cl@linux-foundation.org wrote:
> RCU does not do dynamic allocations but it increments per cpu variables
> a lot. These instructions results in a move to a register and then back
> to memory. This patch will make it use the inc/dec instructions on x86
> that do not need a register.

Looks good to me!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> ---
>  kernel/rcupreempt.c |    4 ++--
>  kernel/rcutorture.c |    8 ++++----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6/kernel/rcutorture.c
> ===================================================================
> --- linux-2.6.orig/kernel/rcutorture.c	2009-06-04 14:26:42.000000000 -0500
> +++ linux-2.6/kernel/rcutorture.c	2009-06-04 14:38:05.000000000 -0500
> @@ -709,13 +709,13 @@ static void rcu_torture_timer(unsigned l
>  		/* Should not happen, but... */
>  		pipe_count = RCU_TORTURE_PIPE_LEN;
>  	}
> -	++__get_cpu_var(rcu_torture_count)[pipe_count];
> +	__this_cpu_inc(per_cpu_var(rcu_torture_count)[pipe_count]);
>  	completed = cur_ops->completed() - completed;
>  	if (completed > RCU_TORTURE_PIPE_LEN) {
>  		/* Should not happen, but... */
>  		completed = RCU_TORTURE_PIPE_LEN;
>  	}
> -	++__get_cpu_var(rcu_torture_batch)[completed];
> +	__this_cpu_inc(per_cpu_var(rcu_torture_batch)[completed]);
>  	preempt_enable();
>  	cur_ops->readunlock(idx);
>  }
> @@ -764,13 +764,13 @@ rcu_torture_reader(void *arg)
>  			/* Should not happen, but... */
>  			pipe_count = RCU_TORTURE_PIPE_LEN;
>  		}
> -		++__get_cpu_var(rcu_torture_count)[pipe_count];
> +		__this_cpu_inc(per_cpu_var(rcu_torture_count)[pipe_count]);
>  		completed = cur_ops->completed() - completed;
>  		if (completed > RCU_TORTURE_PIPE_LEN) {
>  			/* Should not happen, but... */
>  			completed = RCU_TORTURE_PIPE_LEN;
>  		}
> -		++__get_cpu_var(rcu_torture_batch)[completed];
> +		__this_cpu_inc(per_cpu_var(rcu_torture_batch)[completed]);
>  		preempt_enable();
>  		cur_ops->readunlock(idx);
>  		schedule();
> Index: linux-2.6/kernel/rcupreempt.c
> ===================================================================
> --- linux-2.6.orig/kernel/rcupreempt.c	2009-06-04 14:28:53.000000000 -0500
> +++ linux-2.6/kernel/rcupreempt.c	2009-06-04 14:39:35.000000000 -0500
> @@ -173,7 +173,7 @@ void rcu_enter_nohz(void)
>  	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
> 
>  	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
> -	__get_cpu_var(rcu_dyntick_sched).dynticks++;
> +	__this_cpu_inc(per_cpu_var(rcu_dyntick_sched).dynticks);
>  	WARN_ON_RATELIMIT(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1, &rs);
>  }
> 
> @@ -181,7 +181,7 @@ void rcu_exit_nohz(void)
>  {
>  	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
> 
> -	__get_cpu_var(rcu_dyntick_sched).dynticks++;
> +	__this_cpu_inc(per_cpu_var(rcu_dyntick_sched).dynticks);
>  	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
>  	WARN_ON_RATELIMIT(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1),
>  				&rs);
> 
> -- 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
