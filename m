Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbZHCBPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbZHCBPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 21:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZHCBO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 21:14:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34745 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbZHCBO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 21:14:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 3 Aug 2009 10:13:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFI] Help Resource Counters scale better
Message-Id: <20090803101306.0d62fc82.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090802172517.GG8514@balbir.in.ibm.com>
References: <20090802172517.GG8514@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Aug 2009 22:55:17 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> Enhancement: For scalability move the resource counter to a percpu counter
> 
> From: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> This patch changes the usage field of a resource counter to a percpu
> counter. The counter is incremented with local irq disabled. The other
> fields are still protected by the spin lock for write.
> 
thanks, will have to go this way.


> This patch adds a fuzziness factor to hard limit, since the value we read
> could be off the original value (by batch value), this can be fixed
> by adding a strict/non-strict functionality check. The intention is
> to turn of strict checking for root (since we can't set limits on
     turn off ?
> it anyway).
> 

Hmm, this is the first problem of per-cpu counter, always.
I wonder if there are systems with thousands of cpus, it has
tons of memory.  Then, if jitter per cpu is enough small,
it will not be big problem anyway.
But... root only ?

> I tested this patch on my x86_64 box with a regular test for hard
> limits and a page fault program.
> 
> This is an early RFI on the design and changes for resource counter
> functionality to help it scale better.
> 
> Direct uses of mem->res.usage in memcontrol.c have been converted
> to the standard resource counters interface.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
>  include/linux/res_counter.h |   41 ++++++++++++++++++++++++-----------------
>  kernel/res_counter.c        |   31 +++++++++++++++++--------------
>  mm/memcontrol.c             |    6 +++---
>  3 files changed, 44 insertions(+), 34 deletions(-)
> 
> 
> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
> index 731af71..0f9ee03 100644
> --- a/include/linux/res_counter.h
> +++ b/include/linux/res_counter.h
> @@ -14,6 +14,7 @@
>   */
>  
>  #include <linux/cgroup.h>
> +#include <linux/percpu_counter.h>
>  
>  /*
>   * The core object. the cgroup that wishes to account for some
> @@ -23,10 +24,6 @@
>  
>  struct res_counter {
>  	/*
> -	 * the current resource consumption level
> -	 */
> -	unsigned long long usage;
> -	/*
>  	 * the maximal value of the usage from the counter creation
>  	 */
>  	unsigned long long max_usage;
> @@ -48,6 +45,11 @@ struct res_counter {
>  	 */
>  	spinlock_t lock;
>  	/*
> +	 * the current resource consumption level
> +	 */
> +	struct percpu_counter usage;
> +	unsigned long long tmp_usage;	/* Used by res_counter_member */
> +	/*


 - We should condier take following policy or not..
   * res_counter->usage is very strict now and it can exceeds res->limit.
     Then, we don't take a lock for res->limit at charge/uncharge.
   Maybe your code is on this policy. If so, plz write this somewhere.

 - We should take care that usage is now s64, not u64.


>  	 * Parent counter, used for hierarchial resource accounting
>  	 */
>  	struct res_counter *parent;
> @@ -133,7 +135,8 @@ void res_counter_uncharge(struct res_counter *counter, unsigned long val,
>  
>  static inline bool res_counter_limit_check_locked(struct res_counter *cnt)
>  {
> -	if (cnt->usage < cnt->limit)
> +	unsigned long long usage = percpu_counter_read_positive(&cnt->usage);
> +	if (usage < cnt->limit)
>  		return true;
>  
>  	return false;
> @@ -141,7 +144,8 @@ static inline bool res_counter_limit_check_locked(struct res_counter *cnt)
>  
>  static inline bool res_counter_soft_limit_check_locked(struct res_counter *cnt)
>  {
> -	if (cnt->usage < cnt->soft_limit)
> +	unsigned long long usage = percpu_counter_read_positive(&cnt->usage);
> +	if (usage < cnt->soft_limit)
>  		return true;
>  
>  	return false;
> @@ -157,15 +161,16 @@ static inline bool res_counter_soft_limit_check_locked(struct res_counter *cnt)
>  static inline unsigned long long
>  res_counter_soft_limit_excess(struct res_counter *cnt)
>  {
> -	unsigned long long excess;
> +	unsigned long long excess, usage;
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&cnt->lock, flags);
> -	if (cnt->usage <= cnt->soft_limit)
> +	local_irq_save(flags);
> +	usage = percpu_counter_read_positive(&cnt->usage);
> +	if (usage <= cnt->soft_limit)
>  		excess = 0;
>  	else
> -		excess = cnt->usage - cnt->soft_limit;
> -	spin_unlock_irqrestore(&cnt->lock, flags);
> +		excess = usage - cnt->soft_limit;
> +	local_irq_restore(flags);
>  	return excess;
>  }
I'm not sure why local_irq_save()/restore() is required.
Will this be called from interrupt context ?

>  
> @@ -178,9 +183,9 @@ static inline bool res_counter_check_under_limit(struct res_counter *cnt)
>  	bool ret;
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&cnt->lock, flags);
> +	local_irq_save(flags);
>  	ret = res_counter_limit_check_locked(cnt);
> -	spin_unlock_irqrestore(&cnt->lock, flags);
> +	local_irq_restore(flags);
>  	return ret;
>  }
>  
> @@ -189,18 +194,19 @@ static inline bool res_counter_check_under_soft_limit(struct res_counter *cnt)
>  	bool ret;
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&cnt->lock, flags);
> +	local_irq_save(flags);
>  	ret = res_counter_soft_limit_check_locked(cnt);
> -	spin_unlock_irqrestore(&cnt->lock, flags);
> +	local_irq_restore(flags);
>  	return ret;
>  }
>  
>  static inline void res_counter_reset_max(struct res_counter *cnt)
>  {
>  	unsigned long flags;
> +	unsigned long long usage = percpu_counter_read_positive(&cnt->usage);
>  
>  	spin_lock_irqsave(&cnt->lock, flags);
> -	cnt->max_usage = cnt->usage;
> +	cnt->max_usage = usage;
>  	spin_unlock_irqrestore(&cnt->lock, flags);
>  }
>  
> @@ -217,10 +223,11 @@ static inline int res_counter_set_limit(struct res_counter *cnt,
>  		unsigned long long limit)
>  {
>  	unsigned long flags;
> +	unsigned long long usage = percpu_counter_read_positive(&cnt->usage);
>  	int ret = -EBUSY;
>  
>  	spin_lock_irqsave(&cnt->lock, flags);
> -	if (cnt->usage <= limit) {
> +	if (usage <= limit) {
>  		cnt->limit = limit;
>  		ret = 0;
>  	}
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index 88faec2..730a60d 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -18,6 +18,7 @@
>  void res_counter_init(struct res_counter *counter, struct res_counter *parent)
>  {
>  	spin_lock_init(&counter->lock);
> +	percpu_counter_init(&counter->usage, 0);
>  	counter->limit = RESOURCE_MAX;
>  	counter->soft_limit = RESOURCE_MAX;
>  	counter->parent = parent;
> @@ -25,14 +26,17 @@ void res_counter_init(struct res_counter *counter, struct res_counter *parent)
>  
>  int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
>  {
> -	if (counter->usage + val > counter->limit) {
> +	unsigned long long usage;
> +
> +	usage = percpu_counter_read_positive(&counter->usage);
> +	if (usage + val > counter->limit) {
>  		counter->failcnt++;
>  		return -ENOMEM;
>  	}
>  
> -	counter->usage += val;
> -	if (counter->usage > counter->max_usage)
> -		counter->max_usage = counter->usage;
> +	__percpu_counter_add(&counter->usage, val, nr_cpu_ids * PAGE_SIZE);

At first, this is res_counter and not only for memcg.
you shouldn't use PAGE_SIZE here ;)

And, this "batch" value seems wrong. Should not be multiple of # of cpus.

How about this ?

/*
 * This is per-cpu error tolerance for res_counter's usage for memcg.
 * By this, max error in res_counter's usage will be
 * _RES_USAGE_ERROR_TOLERANCE_MEMCG * # of cpus.
 * This can be coufigure via boot opttion (or some...)
 *
 */

/* 256k bytes per 8cpus. 1M per 32cpus. */
#define __RES_USAGE_ERROR_TOLERANCE_MEMCG	(8 * 4096)

or some. (Above means 32M error in 1024 cpu system. But, I think admin of 1024 cpu system
will not take care of Megabytes of memory.)



> +	if (usage + val > counter->max_usage)
> +		counter->max_usage = (usage + val);

Hmm, this part should be

	if (usage + val > counter->max_usage) {
		spin_lock()
		if (usage + val > counter->max_usage)
			counter->max_usage = usage +val;
		spin_unlock()
	}

?


>  	return 0;
>  }
>  
> @@ -49,7 +53,6 @@ int res_counter_charge(struct res_counter *counter, unsigned long val,
>  		*soft_limit_fail_at = NULL;
>  	local_irq_save(flags);
>  	for (c = counter; c != NULL; c = c->parent) {
> -		spin_lock(&c->lock);
>  		ret = res_counter_charge_locked(c, val);
>  		/*
>  		 * With soft limits, we return the highest ancestor
> @@ -58,7 +61,6 @@ int res_counter_charge(struct res_counter *counter, unsigned long val,
>  		if (soft_limit_fail_at &&
>  			!res_counter_soft_limit_check_locked(c))
>  			*soft_limit_fail_at = c;
> -		spin_unlock(&c->lock);
>  		if (ret < 0) {
>  			*limit_fail_at = c;
>  			goto undo;
> @@ -68,9 +70,7 @@ int res_counter_charge(struct res_counter *counter, unsigned long val,
>  	goto done;
>  undo:
>  	for (u = counter; u != c; u = u->parent) {
> -		spin_lock(&u->lock);
>  		res_counter_uncharge_locked(u, val);
> -		spin_unlock(&u->lock);
>  	}
>  done:
>  	local_irq_restore(flags);
> @@ -79,10 +79,13 @@ done:
>  
>  void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
>  {
> -	if (WARN_ON(counter->usage < val))
> -		val = counter->usage;
> +	unsigned long long usage;
> +
> +	usage = percpu_counter_read_positive(&counter->usage);
> +	if (WARN_ON((usage + nr_cpu_ids * PAGE_SIZE) < val))
> +		val = usage;
>  
> -	counter->usage -= val;
> +	percpu_counter_sub(&counter->usage, val);
>  }
>  
>  void res_counter_uncharge(struct res_counter *counter, unsigned long val,
> @@ -93,12 +96,10 @@ void res_counter_uncharge(struct res_counter *counter, unsigned long val,
>  
>  	local_irq_save(flags);
>  	for (c = counter; c != NULL; c = c->parent) {
> -		spin_lock(&c->lock);
>  		if (was_soft_limit_excess)
>  			*was_soft_limit_excess =
>  				!res_counter_soft_limit_check_locked(c);
>  		res_counter_uncharge_locked(c, val);
> -		spin_unlock(&c->lock);
>  	}
>  	local_irq_restore(flags);

For this part, I wonder local_irq_save() can be replaced wiht preempt_disable()...


>  }
> @@ -109,7 +110,9 @@ res_counter_member(struct res_counter *counter, int member)
>  {
>  	switch (member) {
>  	case RES_USAGE:
> -		return &counter->usage;
> +		counter->tmp_usage =
> +			percpu_counter_read_positive(&counter->usage);
> +		return &counter->tmp_usage;

I don't like to have tmp_usage in res_counter just for this purpose.
Shouldn't we add
	s64	res_counter_usage(res);
?

Cheers,
-Kame

>  	case RES_MAX_USAGE:
>  		return &counter->max_usage;
>  	case RES_LIMIT:
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 362b711..f138b6c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2342,7 +2342,7 @@ static int mem_cgroup_force_empty(struct mem_cgroup *mem, bool free_all)
>  	if (free_all)
>  		goto try_to_free;
>  move_account:
> -	while (mem->res.usage > 0) {
> +	while (res_counter_read_u64(&mem->res, RES_USAGE) > 0) {
>  		ret = -EBUSY;
>  		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
>  			goto out;
> @@ -2385,7 +2385,7 @@ try_to_free:
>  	lru_add_drain_all();
>  	/* try to free all pages in this cgroup */
>  	shrink = 1;
> -	while (nr_retries && mem->res.usage > 0) {
> +	while (nr_retries && res_counter_read_u64(&mem->res, RES_USAGE) > 0) {
>  		int progress;
>  
>  		if (signal_pending(current)) {
> @@ -2403,7 +2403,7 @@ try_to_free:
>  	}
>  	lru_add_drain();
>  	/* try move_account...there may be some *locked* pages. */
> -	if (mem->res.usage)
> +	if (res_counter_read_u64(&mem->res, RES_USAGE))
>  		goto move_account;
>  	ret = 0;
>  	goto out;
> 
> -- 
> 	Balbir
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

