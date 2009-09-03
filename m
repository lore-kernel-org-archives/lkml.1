Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbZICJB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbZICJB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 05:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbZICJB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 05:01:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:50292 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbZICJB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 05:01:26 -0400
Date: Thu, 3 Sep 2009 11:01:26 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tree rcu: call_rcu scalability problem?
Message-ID: <20090903090126.GG979@wotan.suse.de>
References: <20090902094835.GB12251@wotan.suse.de> <20090902122756.GC12251@wotan.suse.de> <1251919064.10394.25.camel@laptop> <20090903051427.GD7138@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903051427.GD7138@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 10:14:27PM -0700, Paul E. McKenney wrote:
> >From 0544d2da54bad95556a320e57658e244cb2ae8c6 Mon Sep 17 00:00:00 2001
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date: Wed, 2 Sep 2009 22:01:50 -0700
> Subject: [PATCH] Remove grace-period machinery from rcutree __call_rcu()
> 
> The grace-period machinery in __call_rcu() was a failed attempt to avoid
> implementing synchronize_rcu_expedited().  But now that this attempt has
> failed, try removing the machinery.

OK, the workload is parallel processes performing a close(open()) loop
in a tmpfs filesystem within different cwds (to avoid contention on the
cwd dentry). The kernel is first patched with my vfs scalability patches,
so the comparison is with/without Paul's rcu patch.

System is 2s8c opteron, with processes bound to CPUs (first within the
same socket, then over both sockets as count increases).

procs  tput-base          tput-rcu
1         595238 (x1.00)    645161 (x1.00)
2        1041666 (x1.75)   1136363 (x1.76)
4        1960784 (x3.29)   2298850 (x3.56)
8        3636363 (x6.11)   4545454 (x7.05)

Scalability is improved (from 2-8 way it is now actually linear), and
single thread performance is significantly improved too.

oprofile results collecting clk unhalted samples shows the following
results for __call_rcu symbol:

procs  samples  %        app name                 symbol name
tput-base
1      12153     3.8122  vmlinux                  __call_rcu
2      29253     3.9899  vmlinux                  __call_rcu
4      84503     5.4667  vmlinux                  __call_rcu
8      312816    9.5287  vmlinux                  __call_rcu

tput-rcu
1      8722      2.8770  vmlinux                  __call_rcu
2      17275     2.5804  vmlinux                  __call_rcu
4      33848     2.6015  vmlinux                  __call_rcu
8      67158     2.5561  vmlinux                  __call_rcu

Scaling is cearly much better (it is more important to look at absolute
samples because %age is dependent on other parts of the kernel too).

Feel free to add any of this to your changelog if you think it's important.

Thanks,
Nick

> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree.c |   12 ------------
>  1 files changed, 0 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index d2a372f..104de9e 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1201,26 +1201,14 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
>  	 */
>  	local_irq_save(flags);
>  	rdp = rsp->rda[smp_processor_id()];
> -	rcu_process_gp_end(rsp, rdp);
> -	check_for_new_grace_period(rsp, rdp);
>  
>  	/* Add the callback to our list. */
>  	*rdp->nxttail[RCU_NEXT_TAIL] = head;
>  	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
>  
> -	/* Start a new grace period if one not already started. */
> -	if (ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum)) {
> -		unsigned long nestflag;
> -		struct rcu_node *rnp_root = rcu_get_root(rsp);
> -
> -		spin_lock_irqsave(&rnp_root->lock, nestflag);
> -		rcu_start_gp(rsp, nestflag);  /* releases rnp_root->lock. */
> -	}
> -
>  	/* Force the grace period if too many callbacks or too long waiting. */
>  	if (unlikely(++rdp->qlen > qhimark)) {
>  		rdp->blimit = LONG_MAX;
> -		force_quiescent_state(rsp, 0);
>  	} else if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)
>  		force_quiescent_state(rsp, 1);
>  	local_irq_restore(flags);
> -- 
> 1.5.2.5
