Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbZHYSsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbZHYSsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbZHYSsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:48:00 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:49527 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755347AbZHYSsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:48:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigFABTKk0pMROOX/2dsb2JhbACBU9dGgiqBcAWCQg
Date: Tue, 25 Aug 2009 14:48:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: Re: [PATCH -tip] Create rcutree plugins to handle hotplug CPU for
	multi-level trees
Message-ID: <20090825184800.GD2448@Krystal>
References: <20090825182204.GA26736@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090825182204.GA26736@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:33:53 up 7 days,  5:23,  3 users,  load average: 0.63, 0.53,
	0.37
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> When offlining CPUs from a multi-level tree, there is the possibility
> of offlining the last CPU from a given node when there are preempted
> RCU read-side critical sections that started life on one of the CPUs on
> that node.  In this case, the corresponding tasks will be enqueued via
> the task_struct's rcu_node_entry list_head onto one of the rcu_node's
> blocked_tasks[] lists.  These tasks need to be moved somewhere else
> so that they will prevent the current grace period from ending.
> That somewhere is the root rcu_node.
> 
> With this patch, TREE_PREEMPT_RCU passes moderate rcutorture testing
> with aggressive CPU-hotplugging (no delay between inserting/removing
> randomly selected CPU).
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
[...]
>  /*
> + * Handle tasklist migration for case in which all CPUs covered by the
> + * specified rcu_node have gone offline.  Move them up to the root
> + * rcu_node.  The reason for not just moving them to the immediate
> + * parent is to remove the need for rcu_read_unlock_special() to
> + * make more than two attempts to acquire the target rcu_node's lock.
> + *
> + * The caller must hold rnp->lock with irqs disabled.
> + */
> +static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
> +				      struct rcu_node *rnp)
> +{
> +	int i;
> +	struct list_head *lp;
> +	struct list_head *lp_root;
> +	struct rcu_node *rnp_root = rcu_get_root(rsp);
> +	struct task_struct *tp;
> +
> +	if (rnp == rnp_root)
> +		return;  /* Shouldn't happen: at least one CPU online. */
> +

Hrm, is it "shouldn't happen" or "could be called, but we should not
move anything" ?

If it is really the former, we could put a WARN_ON_ONCE (or, more
aggressively, a BUG_ON) there and see when the caller is going crazy
rather than ignoring the error.

> +	/*
> +	 * Move tasks up to root rcu_node.  Rely on the fact that the
> +	 * root rcu_node can be at most one ahead of the rest of the
> +	 * rcu_nodes in terms of gp_num value.

Do you gather the description of such constraints in a central place
somewhere around the code or design documentation in the kernel tree ?
I just want to point out that every clever assumption like this, which
is based on the constraints imposed by the current design, should be
easy to list in a year from now if we ever decide to move from tree to
hashed RCU (or whichever next step will be necessary then).

I am just worried that migration helpers seems to be added to the design
as an afterthought, and therefore might make future evolution more
difficult.

Thanks,

Mathieu

>  This fact allows us to
> +	 * move the blocked_tasks[] array directly, element by element.
> +	 */
> +	for (i = 0; i < 2; i++) {
> +		lp = &rnp->blocked_tasks[i];
> +		lp_root = &rnp_root->blocked_tasks[i];
> +		while (!list_empty(lp)) {
> +			tp = list_entry(lp->next, typeof(*tp), rcu_node_entry);
> +			spin_lock(&rnp_root->lock); /* irqs already disabled */
> +			list_del(&tp->rcu_node_entry);
> +			tp->rcu_blocked_node = rnp_root;
> +			list_add(&tp->rcu_node_entry, lp_root);
> +			spin_unlock(&rnp_root->lock); /* irqs remain disabled */
> +		}
> +	}
> +}
> +
> +/*
>   * Do CPU-offline processing for preemptable RCU.
>   */
>  static void rcu_preempt_offline_cpu(int cpu)
> @@ -410,6 +460,15 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
>  #ifdef CONFIG_HOTPLUG_CPU
>  
>  /*
> + * Because preemptable RCU does not exist, it never needs to migrate
> + * tasks that were blocked within RCU read-side critical sections.
> + */
> +static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
> +				      struct rcu_node *rnp)
> +{
> +}
> +
> +/*
>   * Because preemptable RCU does not exist, it never needs CPU-offline
>   * processing.
>   */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
