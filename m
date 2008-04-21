Return-Path: <linux-kernel-owner+w=401wt.eu-S1763265AbYDUQZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763265AbYDUQZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758134AbYDUQZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:25:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38333 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbYDUQZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:25:20 -0400
Date: Mon, 21 Apr 2008 12:25:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Gregory Haskins <ghaskins@novell.com>, suresh.b.siddha@intel.com,
       chinang.ma@intel.com, arjan@linux.intel.com, willy@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH v2] sched: push rt tasks only if newly activated tasks
 have been added
In-Reply-To: <20080421162032.GA12645@elte.hu>
Message-ID: <Pine.LNX.4.58.0804211224380.18530@gandalf.stny.rr.com>
References: <20080421153438.9212.79406.stgit@novell1.haskins.net>
 <20080421161744.GB10121@elte.hu> <20080421162032.GA12645@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 21 Apr 2008, Ingo Molnar wrote:

>
> got a build failure:
>
>  In file included from kernel/sched.c:1972:
>  kernel/sched_rt.c: In function 'enqueue_task_rt':
>  kernel/sched_rt.c:522: error: 'struct rt_rq' has no member named 'pushed'
>
> with this config:
>
>  http://redhat.com/~mingo/misc/config-Mon_Apr_21_18_02_45_CEST_2008.bad
>
> with the patch below against sched-devel/latest.
>


> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/sched.c    |    2 ++
>  kernel/sched_rt.c |   22 ++++++++++++++++++++--
>  2 files changed, 22 insertions(+), 2 deletions(-)
>
> Index: linux/kernel/sched.c
> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -462,6 +462,7 @@ struct rt_rq {
>  #ifdef CONFIG_SMP
>  	unsigned long rt_nr_migratory;
>  	int overloaded;
> +	int pushed;
>  #endif
>  	int rt_throttled;
>  	u64 rt_time;
> @@ -8073,6 +8074,7 @@ static void init_rt_rq(struct rt_rq *rt_
>  #ifdef CONFIG_SMP
>  	rt_rq->rt_nr_migratory = 0;
>  	rt_rq->overloaded = 0;
> +	rt_rq->pushed = 0;
>  #endif
>
>  	rt_rq->rt_time = 0;
> Index: linux/kernel/sched_rt.c
> ===================================================================
> --- linux.orig/kernel/sched_rt.c
> +++ linux/kernel/sched_rt.c
> @@ -514,6 +514,13 @@ static void enqueue_task_rt(struct rq *r
>  	for_each_sched_rt_entity(rt_se)
>  		enqueue_rt_entity(rt_se);
>
> +	/*
> +	 * Clear the "pushed" state since we have changed the run-queue and
> +	 * may need to migrate some of these tasks (see push_rt_tasks() for
> +	 * details)
> +	 */
> +	rq->rt.pushed = 0;
> +

I'm betting that this needs a CONFIG_SMP around it.

-- Steve

>  	inc_cpu_load(rq, p->se.load.weight);
>  }
>
> @@ -913,7 +920,7 @@ static int push_rt_task(struct rq *rq)
>  	int ret = 0;
>  	int paranoid = RT_MAX_TRIES;
>
> -	if (!rq->rt.overloaded)
> +	if (!rq->rt.overloaded || rq->rt.pushed)
>  		return 0;
>
>  	next_task = pick_next_highest_task_rt(rq, -1);
> @@ -973,6 +980,15 @@ out:
>  }
>
>  /*
