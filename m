Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbXHKErX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbXHKErX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 00:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbXHKErR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 00:47:17 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56498 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbXHKErQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 00:47:16 -0400
Date: Fri, 10 Aug 2007 21:47:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Josh Triplett <josh@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm1: rcutorture xtime usage
Message-ID: <20070811044714.GA31009@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org> <20070810013146.GD18938@stusta.de> <20070810020040.GK8424@linux.vnet.ibm.com> <20070809190623.f60dcf70.akpm@linux-foundation.org> <20070810151208.GC8511@linux.vnet.ibm.com> <20070810101212.d59ce24a.akpm@linux-foundation.org> <20070810203055.GE8511@linux.vnet.ibm.com> <20070811002949.GA7918@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070811002949.GA7918@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 05:29:49PM -0700, Paul E. McKenney wrote:
> 
> Errmmm...  No joy.
> 
> 	ERROR: "cpu_clock" [kernel/rcutorture.ko] undefined!
> 
> Turns out that cpu_clock also ain't exported, and rcutorture.c is
> a module.  Would adding an EXPORT_SYMBOL_GPL() as in the patch below
> be acceptable?

Except that the old xtime symbol was EXPORT_SYMBOL() rather than my
proposed EXPORT_SYMBOL_GPL() for the equivalent new cpu_clock().

Sigh!!!  I will leave this one for others to sort out.

Andrew, please consider this patch withdrawn and apply the version that
does not rely on time for entropy.  Please let me know if you would like
me to resend it.

							Thanx, Paul

> If not, I have a tested patch to rcutorture.c that leverages statistical
> counters.  Your choice.
> 
> 						Thanx, Paul
> 
> Add an EXPORT_SYMBOL_GPL() for cpu_clock() and make rcutorture.c use it.
> Compiles, but not yet tested.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  rcutorture.c |    8 ++------
>  sched.c      |    2 ++
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff -urpNa -X dontdiff linux-2.6.23-rc2/kernel/rcutorture.c linux-2.6.23-rc2-rcutorturesched/kernel/rcutorture.c
> --- linux-2.6.23-rc2/kernel/rcutorture.c	2007-08-03 19:49:55.000000000 -0700
> +++ linux-2.6.23-rc2-rcutorturesched/kernel/rcutorture.c	2007-08-10 17:15:22.000000000 -0700
> @@ -42,7 +42,6 @@
>  #include <linux/notifier.h>
>  #include <linux/freezer.h>
>  #include <linux/cpu.h>
> -#include <linux/random.h>
>  #include <linux/delay.h>
>  #include <linux/byteorder/swabb.h>
>  #include <linux/stat.h>
> @@ -166,16 +165,13 @@ struct rcu_random_state {
>  
>  /*
>   * Crude but fast random-number generator.  Uses a linear congruential
> - * generator, with occasional help from get_random_bytes().
> + * generator, with occasional help from cpu_clock().
>   */
>  static unsigned long
>  rcu_random(struct rcu_random_state *rrsp)
>  {
> -	long refresh;
> -
>  	if (--rrsp->rrs_count < 0) {
> -		get_random_bytes(&refresh, sizeof(refresh));
> -		rrsp->rrs_state += refresh;
> +		rrsp->rrs_state += (unsigned long)cpu_clock(smp_processor_id());
>  		rrsp->rrs_count = RCU_RANDOM_REFRESH;
>  	}
>  	rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
> diff -urpNa -X dontdiff linux-2.6.23-rc2/kernel/sched.c linux-2.6.23-rc2-rcutorturesched/kernel/sched.c
> --- linux-2.6.23-rc2/kernel/sched.c	2007-08-03 19:49:55.000000000 -0700
> +++ linux-2.6.23-rc2-rcutorturesched/kernel/sched.c	2007-08-10 17:22:57.000000000 -0700
> @@ -394,6 +394,8 @@ unsigned long long cpu_clock(int cpu)
>  	return now;
>  }
>  
> +EXPORT_SYMBOL_GPL(cpu_clock);
> +
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  /* Change a task's ->cfs_rq if it moves across CPUs */
>  static inline void set_task_cfs_rq(struct task_struct *p)
