Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbZAMBoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbZAMBoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbZAMBnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:43:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59259 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbZAMBnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:43:50 -0500
Date: Tue, 13 Jan 2009 02:43:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: rostedt@home.goodmis.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] fixes for tip/sched/rt
Message-ID: <20090113014333.GA23448@elte.hu>
References: <20090112144548.GA14016@elte.hu> <20090112192200.4511.6357.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112192200.4511.6357.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <ghaskins@novell.com> wrote:

> +#ifdef CONFIG_SMP
> +	if (prio < prev_prio) {
> +		struct rq *rq = rq_of_rt_rq(rt_rq);
>  
>  		/*
>  		 * If the new task is higher in priority than anything on the
> -		 * run-queue, we have a new high that must be published to
> -		 * the world.  We also know that the previous high becomes
> -		 * our next-highest.
> +		 * run-queue, we know that the previous high becomes our
> +		 * next-highest.
>  		 */
> +		rt_rq->highest_prio.next = prev_prio;
> +
>  		if (rq->online)
>  			cpupri_set(&rq->rd->cpupri, rq->cpu, prio);

nice cleanups.

couldnt this portion too be moved into a helper function?

>  #ifdef CONFIG_SMP
> +	if (rt_rq->rt_nr_running && (prio <= rt_rq->highest_prio.next))
> +		rt_rq->highest_prio.next = next_prio(rq);
>  
> +	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
>  		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
> +#endif

ditto.

> +static inline
> +void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
> +{
> +	int prio = rt_se_prio(rt_se);
> +
> +	WARN_ON(!rt_prio(prio));
> +	rt_rq->rt_nr_running++;
> +
> +	inc_rt_prio(rt_rq, prio);
> +	inc_rt_migration(rt_se, rt_rq);
> +
> +#ifdef CONFIG_RT_GROUP_SCHED
> +	if (rt_se_boosted(rt_se))
> +		rt_rq->rt_nr_boosted++;
> +
> +	if (rt_rq->tg)
> +		start_rt_bandwidth(&rt_rq->tg->rt_bandwidth);
> +#else
> +	start_rt_bandwidth(&def_rt_bandwidth);
> +#endif

ditto.

	Ingo
