Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbZLNXDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbZLNXDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbZLNXDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:03:47 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52863 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758028AbZLNXDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:03:46 -0500
Date: Mon, 14 Dec 2009 15:03:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: Teach might_sleep about preemptable rcu
Message-ID: <20091214230344.GG6679@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1260830672-7166-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260830672-7166-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 11:44:32PM +0100, Frederic Weisbecker wrote:
> In practice, it is harmless to voluntarily sleep in a rcu_read_lock()
> section if we are running under preempt rcu, but it is illegal because
> if we build a kernel running non-preemptable rcu.
> 
> Currently, might_sleep() doesn't notice sleepable operations under
> rcu_read_lock() sections if we are running under preemptable rcu
> because preempt_count() is left untouched after rcu_read_lock() in
> this case. But we want developers who test their changes under such
> config to notice the "sleeping while atomic" issues.
> 
> Then we add rcu_read_lock_nesting to prempt_count() in might_sleep()
> checks.

Cute!!!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  include/linux/rcutree.h |   11 +++++++++++
>  kernel/sched.c          |    2 +-
>  2 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index c93eee5..8044b1b 100644
> --- a/include/linux/rcutree.h
> +++ b/include/linux/rcutree.h
> @@ -45,6 +45,12 @@ extern void __rcu_read_unlock(void);
>  extern void synchronize_rcu(void);
>  extern void exit_rcu(void);
> 
> +/*
> + * Defined as macro as it is a very low level header
> + * included from areas that don't even know about current
> + */
> +#define rcu_preempt_depth() (current->rcu_read_lock_nesting)
> +
>  #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> 
>  static inline void __rcu_read_lock(void)
> @@ -63,6 +69,11 @@ static inline void exit_rcu(void)
>  {
>  }
> 
> +static inline int rcu_preempt_depth(void)
> +{
> +	return 0;
> +}
> +
>  #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
> 
>  static inline void __rcu_read_lock_bh(void)
> diff --git a/kernel/sched.c b/kernel/sched.c
> index ab42754..586c82c 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9658,7 +9658,7 @@ void __init sched_init(void)
>  #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
>  static inline int preempt_count_equals(int preempt_offset)
>  {
> -	int nested = preempt_count() & ~PREEMPT_ACTIVE;
> +	int nested = (preempt_count() & ~PREEMPT_ACTIVE) + rcu_preempt_depth();
> 
>  	return (nested == PREEMPT_INATOMIC_BASE + preempt_offset);
>  }
> -- 
> 1.6.2.3
> 
