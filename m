Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbYEEJXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbYEEJXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbYEEJWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:22:53 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:35031 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276AbYEEJWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:22:51 -0400
Date: Mon, 5 May 2008 14:52:40 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
       akpm@linux-foundation.org, hch@infradead.org, mmlnx@us.ibm.com,
       dipankar@in.ibm.com, dsmith@redhat.com, rostedt@goodmis.org,
       adrian.bunk@movial.fi, a.p.zijlstra@chello.nl, niv@us.ibm.com,
       dvhltc@us.ibm.com, rusty@au1.ibm.com, jkenisto@linux.vnet.ibm.com,
       oleg@tv-sign.ru, jamesclhuang@yahoo.com
Subject: Re: [PATCH 3/5] Add rcu_barrier_sched() and rcu_barrier_bh()
Message-ID: <20080505092240.GB8371@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080422004454.GA3517@linux.vnet.ibm.com> <20080422004743.GC3693@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422004743.GC3693@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 05:47:43PM -0700, Paul E. McKenney wrote:
> Add rcu_barrier_sched() and rcu_barrier_bh().  With these in place,
> rcutorture no longer gives the occasional oops when repeatedly starting
> and stopping torturing rcu_bh.  Also adds the API needed to flush out
> pre-existing call_rcu_sched() callbacks.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
> 
>  include/linux/rcupdate.h |    2 +
>  kernel/rcupdate.c        |   55 +++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 51 insertions(+), 6 deletions(-)
> 
> diff -urpNa -X dontdiff linux-2.6.25-C2-rcuclassic-fixes/include/linux/rcupdate.h linux-2.6.25-C3-rcu_barrier_sched/include/linux/rcupdate.h
> --- linux-2.6.25-C2-rcuclassic-fixes/include/linux/rcupdate.h	2008-04-17 08:10:33.000000000 -0700
> +++ linux-2.6.25-C3-rcu_barrier_sched/include/linux/rcupdate.h	2008-04-21 11:33:07.000000000 -0700
> @@ -260,6 +260,8 @@ extern void call_rcu_bh(struct rcu_head 
>  /* Exported common interfaces */
>  extern void synchronize_rcu(void);
>  extern void rcu_barrier(void);
> +extern void rcu_barrier_bh(void);
> +extern void rcu_barrier_sched(void);
>  extern long rcu_batches_completed(void);
>  extern long rcu_batches_completed_bh(void);
> 
> diff -urpNa -X dontdiff linux-2.6.25-C2-rcuclassic-fixes/kernel/rcupdate.c linux-2.6.25-C3-rcu_barrier_sched/kernel/rcupdate.c
> --- linux-2.6.25-C2-rcuclassic-fixes/kernel/rcupdate.c	2008-04-17 08:10:33.000000000 -0700
> +++ linux-2.6.25-C3-rcu_barrier_sched/kernel/rcupdate.c	2008-04-21 11:33:08.000000000 -0700
> @@ -45,6 +45,12 @@
>  #include <linux/mutex.h>
>  #include <linux/module.h>
> 
> +enum rcu_barrier {
> +	RCU_BARRIER_STD,
STD: Standard, I take it ?

> +	RCU_BARRIER_BH,
> +	RCU_BARRIER_SCHED,
> +};
> +
>  static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
>  static atomic_t rcu_barrier_cpu_count;
>  static DEFINE_MUTEX(rcu_barrier_mutex);
> @@ -83,19 +89,30 @@ static void rcu_barrier_callback(struct 
>  /*
>   * Called with preemption disabled, and from cross-cpu IRQ context.
>   */
> -static void rcu_barrier_func(void *notused)
> +static void rcu_barrier_func(void *type)
>  {
>  	int cpu = smp_processor_id();
>  	struct rcu_head *head = &per_cpu(rcu_barrier_head, cpu);
> 
>  	atomic_inc(&rcu_barrier_cpu_count);
> -	call_rcu(head, rcu_barrier_callback);
> +	switch ((enum rcu_barrier)type) {
> +	case RCU_BARRIER_STD:
> +		call_rcu(head, rcu_barrier_callback);
> +		break;
> +	case RCU_BARRIER_BH:
> +		call_rcu_bh(head, rcu_barrier_callback);
> +		break;
> +	case RCU_BARRIER_SCHED:
> +		call_rcu_sched(head, rcu_barrier_callback);
> +		break;
> +	}
>  }
> 
> -/**
> - * rcu_barrier - Wait until all the in-flight RCUs are complete.
> +/*
> + * Orchestrate the specified type of RCU barrier, waiting for all
> + * RCU callbacks of the specified type to complete.
>   */
> -void rcu_barrier(void)
> +static void _rcu_barrier(enum rcu_barrier type)
>  {
>  	BUG_ON(in_interrupt());
>  	/* Take cpucontrol mutex to protect against CPU hotplug */
> @@ -111,13 +128,39 @@ void rcu_barrier(void)
>  	 * until all the callbacks are queued.
>  	 */
>  	rcu_read_lock();
> -	on_each_cpu(rcu_barrier_func, NULL, 0, 1);
> +	on_each_cpu(rcu_barrier_func, (void *)type, 0, 1);
>  	rcu_read_unlock();
>  	wait_for_completion(&rcu_barrier_completion);
>  	mutex_unlock(&rcu_barrier_mutex);
>  }
> +
> +/**
> + * rcu_barrier - Wait until all in-flight call_rcu() callbacks complete.
> + */
> +void rcu_barrier(void)
> +{
> +	_rcu_barrier(RCU_BARRIER_STD);
> +}
>  EXPORT_SYMBOL_GPL(rcu_barrier);
> 
> +/**
> + * rcu_barrier_bh - Wait until all in-flight call_rcu_bh() callbacks complete.
> + */
> +void rcu_barrier_bh(void)
> +{
> +	_rcu_barrier(RCU_BARRIER_BH);
> +}
> +EXPORT_SYMBOL_GPL(rcu_barrier_bh);
> +
> +/**
> + * rcu_barrier_sched - Wait for in-flight call_rcu_sched() callbacks.
> + */
> +void rcu_barrier_sched(void)
> +{
> +	_rcu_barrier(RCU_BARRIER_SCHED);
> +}
> +EXPORT_SYMBOL_GPL(rcu_barrier_sched);
> +
>  void __init rcu_init(void)
>  {
>  	__rcu_init();

-- 
Thanks and Regards
gautham
