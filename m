Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbYCVSC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbYCVSC0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 14:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbYCVSCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 14:02:17 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:8164 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbYCVSCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 14:02:15 -0400
Message-Id: <47E511D4.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Sat, 22 Mar 2008 12:04:04 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Ankita Garg" <ankita@in.ibm.com>,
       "linux-rt-users" <linux-rt-users@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [RT] [PATCH] Make scheduler root_domain modular
	(sched_classspecific)
References: <20080322142915.GA9478@in.ibm.com>
In-Reply-To: <20080322142915.GA9478@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Sat, Mar 22, 2008 at 10:29 AM, in message
<20080322142915.GA9478@in.ibm.com>, Ankita Garg <ankita@in.ibm.com> wrote: 
> Hello,
> 
> Thanks Gregory for clarifying my question on root_domains infrastructure. 
> What
> I was effectively mentioning on irc the other day was to make the 
> root_domain
> infrastructure modular, ie sched_class specific. Currently, only rt is 
> making
> use of this infrasture. Making it modular would enable ease of extension to
> other sched_classes if required. Trivial patch to that effect.
> 
> Patch compile and boot tested.

Hi Ankita,
  Very nice, thanks!  Couple of minor nits and further cleanup opportunities inline, but otherwise:

Acked-by: Gregory Haskins <ghaskins@novell.com>

> 
> 
> Signed-off-by: Ankita Garg <ankita@in.ibm.com> 
> 
> Index: linux-2.6.24.3-rt3/kernel/sched.c
> ===================================================================
> --- linux-2.6.24.3-rt3.orig/kernel/sched.c	2008-03-21 22:57:04.000000000 +0530
> +++ linux-2.6.24.3-rt3/kernel/sched.c	2008-03-21 23:04:56.000000000 +0530
> @@ -337,11 +337,8 @@
>   * object.
>   *
>   */
> -struct root_domain {
> -	atomic_t refcount;
> -	cpumask_t span;
> -	cpumask_t online;
>  
> +struct rt_root_domain {
>  	/*
>  	 * The "RT overload" flag: it gets set if a CPU has more than
>  	 * one runnable RT task.
> @@ -353,6 +350,14 @@
>  #endif
>  };
>  
> +struct root_domain {
> +	atomic_t refcount;
> +	cpumask_t span;
> +	cpumask_t online;
> +
> +	struct rt_root_domain rt_dom;

Perhaps this should just be s/rt_dom/rt since it is already implicitly a domain just by being a subordinate member of a domain structure.


> +};
> +
>  /*
>   * By default the system creates a single root-domain with all cpus as
>   * members (mimicking the global state we have today).
> @@ -6332,7 +6337,7 @@
>  	cpus_clear(rd->span);
>  	cpus_clear(rd->online);
>  
> -	cpupri_init(&rd->cpupri);
> +	cpupri_init(&rd->rt_dom.cpupri);
>  
>  }
>  
> Index: linux-2.6.24.3-rt3/kernel/sched_rt.c
> ===================================================================
> --- linux-2.6.24.3-rt3.orig/kernel/sched_rt.c	2008-03-21 22:57:04.000000000 +0530
> +++ linux-2.6.24.3-rt3/kernel/sched_rt.c	2008-03-21 23:04:39.000000000 +0530
> @@ -7,12 +7,12 @@
>  
>  static inline int rt_overloaded(struct rq *rq)
>  {
> -	return atomic_read(&rq->rd->rto_count);
> +	return atomic_read(&rq->rd->rt_dom.rto_count);

Perhaps we should change s/rto_count/overload_count and s/rto_mask/overload_mask, since "rt" is now implicit with the association with rt_root_domain?


>  }
>  
>  static inline void rt_set_overload(struct rq *rq)
>  {
> -	cpu_set(rq->cpu, rq->rd->rto_mask);
> +	cpu_set(rq->cpu, rq->rd->rt_dom.rto_mask);
>  	/*
>  	 * Make sure the mask is visible before we set
>  	 * the overload count. That is checked to determine
> @@ -21,14 +21,14 @@
>  	 * updated yet.
>  	 */
>  	wmb();
> -	atomic_inc(&rq->rd->rto_count);
> +	atomic_inc(&rq->rd->rt_dom.rto_count);
>  }
>  
>  static inline void rt_clear_overload(struct rq *rq)
>  {
>  	/* the order here really doesn't matter */
> -	atomic_dec(&rq->rd->rto_count);
> -	cpu_clear(rq->cpu, rq->rd->rto_mask);
> +	atomic_dec(&rq->rd->rt_dom.rto_count);
> +	cpu_clear(rq->cpu, rq->rd->rt_dom.rto_mask);
>  }
>  
>  static void update_rt_migration(struct rq *rq)
> @@ -78,7 +78,7 @@
>  #ifdef CONFIG_SMP
>  	if (p->prio < rq->rt.highest_prio) {
>  		rq->rt.highest_prio = p->prio;
> -		cpupri_set(&rq->rd->cpupri, rq->cpu, p->prio);
> +		cpupri_set(&rq->rd->rt_dom.cpupri, rq->cpu, p->prio);
>  	}
>  	if (p->nr_cpus_allowed > 1)
>  		rq->rt.rt_nr_migratory++;
> @@ -114,7 +114,7 @@
>  	}
>  
>  	if (rq->rt.highest_prio != highest_prio)
> -		cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio);
> +		cpupri_set(&rq->rd->rt_dom.cpupri, rq->cpu, rq->rt.highest_prio);
>  
>  	update_rt_migration(rq);
>  #endif /* CONFIG_SMP */
> @@ -363,7 +363,7 @@
>  {
>  	int count;
>  
> -	count = cpupri_find(&task_rq(task)->rd->cpupri, task, lowest_mask);
> +	count = cpupri_find(&task_rq(task)->rd->rt_dom.cpupri, task, lowest_mask);
>  
>  	/*
>  	 * cpupri cannot efficiently tell us how many bits are set, so it only
> @@ -599,7 +599,7 @@
>  
>  	next = pick_next_task_rt(this_rq);
>  
> -	for_each_cpu_mask(cpu, this_rq->rd->rto_mask) {
> +	for_each_cpu_mask(cpu, this_rq->rd->rt_dom.rto_mask) {
>  		if (this_cpu == cpu)
>  			continue;
>  
> @@ -763,7 +763,7 @@
>  	if (rq->rt.overloaded)
>  		rt_set_overload(rq);
>  
> -	cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio);
> +	cpupri_set(&rq->rd->rt_dom.cpupri, rq->cpu, rq->rt.highest_prio);
>  }
>  
>  /* Assumes rq->lock is held */
> @@ -772,7 +772,7 @@
>  	if (rq->rt.overloaded)
>  		rt_clear_overload(rq);
>  
> -	cpupri_set(&rq->rd->cpupri, rq->cpu, CPUPRI_INVALID);
> +	cpupri_set(&rq->rd->rt_dom.cpupri, rq->cpu, CPUPRI_INVALID);
>  }
>  
>  /*



