Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbXKHEij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbXKHEij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 23:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbXKHEib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 23:38:31 -0500
Received: from wx-out-0506.google.com ([66.249.82.235]:55833 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbXKHEia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 23:38:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=EVqF+uS/qEkBLhharDjdGRsd/YEuEBrl1fVoSIV2o+pCeng3KnndgQbpYcmVDjXtFf6nhWs3yiFp+gQmvFUpThqAlQ/2GayyyKxzVFl9CEr/B1QRzJ9APw+or8g56XHWki13T98tRlTzTDlXI2U/MY3/IYJSiWfG9cDtV/TOyWU=
Message-ID: <4732929D.604@gmail.com>
Date: Wed, 07 Nov 2007 23:37:49 -0500
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Williams <pwil3058@bigpond.net.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: avoid large irq-latencies in smp-balancing
References: <1194434956.6289.111.camel@twins> <1194437820.6289.114.camel@twins>
In-Reply-To: <1194437820.6289.114.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Bah, missed a hunk
> 
> ---
> Subject: sched: avoid large irq-latencies in smp-balancing
> 
> SMP balancing is done with IRQs disabled and can iterate the full rq. When rqs
> are large this can cause large irq-latencies. Limit the nr of iterations on
> each run.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Peter Williams <pwil3058@bigpond.net.au>

Tested-by: Gregory Haskins <ghaskins@novell.com> (as part of 23.1-rt11)

> ---
>  include/linux/sched.h |    1 +
>  kernel/sched.c        |   15 ++++++++++-----
>  kernel/sysctl.c       |    8 ++++++++
>  3 files changed, 19 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6-2/kernel/sched.c
> ===================================================================
> --- linux-2.6-2.orig/kernel/sched.c
> +++ linux-2.6-2/kernel/sched.c
> @@ -474,6 +474,12 @@ const_debug unsigned int sysctl_sched_fe
>  #define sched_feat(x) (sysctl_sched_features & SCHED_FEAT_##x)
>  
>  /*
> + * Number of tasks to iterate in a single balance run.
> + * Limited because this is done with IRQs disabled.
> + */
> +const_debug unsigned int sysctl_sched_nr_migrate = 32;
> +
> +/*
>   * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
>   * clock constructed from sched_clock():
>   */
> @@ -2237,7 +2243,7 @@ balance_tasks(struct rq *this_rq, int th
>  	      enum cpu_idle_type idle, int *all_pinned,
>  	      int *this_best_prio, struct rq_iterator *iterator)
>  {
> -	int pulled = 0, pinned = 0, skip_for_load;
> +	int loops = 0, pulled = 0, pinned = 0, skip_for_load;
>  	struct task_struct *p;
>  	long rem_load_move = max_load_move;
>  
> @@ -2251,10 +2257,10 @@ balance_tasks(struct rq *this_rq, int th
>  	 */
>  	p = iterator->start(iterator->arg);
>  next:
> -	if (!p)
> +	if (!p || loops++ > sysctl_sched_nr_migrate)
>  		goto out;
>  	/*
> -	 * To help distribute high priority tasks accross CPUs we don't
> +	 * To help distribute high priority tasks across CPUs we don't
>  	 * skip a task if it will be the highest priority task (i.e. smallest
>  	 * prio value) on its new queue regardless of its load weight
>  	 */
> @@ -2271,8 +2277,7 @@ next:
>  	rem_load_move -= p->se.load.weight;
>  
>  	/*
> -	 * We only want to steal up to the prescribed number of tasks
> -	 * and the prescribed amount of weighted load.
> +	 * We only want to steal up to the prescribed amount of weighted load.
>  	 */
>  	if (rem_load_move > 0) {
>  		if (p->prio < *this_best_prio)
> Index: linux-2.6-2/kernel/sysctl.c
> ===================================================================
> --- linux-2.6-2.orig/kernel/sysctl.c
> +++ linux-2.6-2/kernel/sysctl.c
> @@ -298,6 +298,14 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= &proc_dointvec,
>  	},
> +	{
> +		.ctl_name	= CTL_UNNUMBERED,
> +		.procname	= "sched_nr_migrate",
> +		.data		= &sysctl_sched_nr_migrate,
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 644,
> +		.proc_handler	= &proc_dointvec,
> +	},
>  #endif
>  	{
>  		.ctl_name	= CTL_UNNUMBERED,
> Index: linux-2.6-2/include/linux/sched.h
> ===================================================================
> --- linux-2.6-2.orig/include/linux/sched.h
> +++ linux-2.6-2/include/linux/sched.h
> @@ -1466,6 +1466,7 @@ extern unsigned int sysctl_sched_batch_w
>  extern unsigned int sysctl_sched_child_runs_first;
>  extern unsigned int sysctl_sched_features;
>  extern unsigned int sysctl_sched_migration_cost;
> +extern unsigned int sysctl_sched_nr_migrate;
>  #endif
>  
>  extern unsigned int sysctl_sched_compat_yield;
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

