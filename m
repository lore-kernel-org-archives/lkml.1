Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760101AbYLQIG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbYLQIG3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 03:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYLQIGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 03:06:20 -0500
Received: from viefep19-int.chello.at ([62.179.121.39]:43458 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751463AbYLQIGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 03:06:19 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] cpuacct: add per cgroup run-delay accounting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ken Chen <kenchen@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Menage <menage@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <b040c32a0812162351u4876096aq7aa538873b4935d3@mail.gmail.com>
References: <b040c32a0812162351u4876096aq7aa538873b4935d3@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 09:06:14 +0100
Message-Id: <1229501174.9487.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 23:51 -0800, Ken Chen wrote:
> This patch adds per cpuacct cgroup scheduler run-delay accounting.  we
> intent to use this stats to track group of tasks' wait time on CPU run
> queue for monitoring purpose.
> 
> Due to lack of atomic64_t support on 32-bit arch, this functionality is
> limited to 64-bit arch.
> 
> Signed-off-by: Ken Chen <kenchen@google.com>

You could add a seqcount instead?

> diff --git a/kernel/sched.c b/kernel/sched.c
> index e4bb1dd..4d1920d 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1390,6 +1390,15 @@ static void cpuacct_charge(
>  static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
>  #endif
> 
> +#if defined(CONFIG_CGROUP_CPUACCT) && defined(CONFIG_SCHEDSTATS) &&	\
> +    defined(CONFIG_64BIT)
> +static void
> +cpuacct_accumulate_run_delay(struct task_struct *task, u64 delta);
> +#else
> +static inline void
> +cpuacct_accumulate_run_delay(struct task_struct *t, u64 delta) {}
> +#endif
> +
>  static inline void inc_cpu_load(struct rq *rq, unsigned long load)
>  {
>  	update_load_add(&rq->load, load);
> @@ -9256,6 +9265,11 @@ struct cpuacct {
>  	struct cgroup_subsys_state css;
>  	/* cpuusage holds pointer to a u64-type object on every cpu */
>  	u64 *cpuusage;
> +
> +#if defined(CONFIG_SCHEDSTATS) && defined(CONFIG_64BIT)
> +	/* accumulative schedule rq wait time for tasks in this cgroup */
> +	atomic64_t run_delay;
> +#endif
>  };
> 
>  struct cgroup_subsys cpuacct_subsys;
> @@ -9347,12 +9361,33 @@ out:
>  	return err;
>  }
> 
> +#if defined(CONFIG_SCHEDSTATS) && defined(CONFIG_64BIT)
> +static u64 cpuacct_run_delay_read(struct cgroup *cgrp, struct cftype *cft)
> +{
> +	struct cpuacct *ca = cgroup_ca(cgrp);
> +	return atomic64_read(&ca->run_delay);
> +}
> +
> +static void cpuacct_accumulate_run_delay(struct task_struct *task, u64 delta)
> +{
> +	struct cpuacct *ca = task_ca(task);
> +	if (ca)
> +		atomic64_add(delta, &ca->run_delay);
> +}
> +#endif
> +
>  static struct cftype files[] = {
>  	{
>  		.name = "usage",
>  		.read_u64 = cpuusage_read,
>  		.write_u64 = cpuusage_write,
>  	},
> +#if defined(CONFIG_SCHEDSTATS) && defined(CONFIG_64BIT)
> +	{
> +		.name = "run_delay",
> +		.read_u64 = cpuacct_run_delay_read,
> +	},
> +#endif
>  };
> 
>  static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
> diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
> index 7dbf72a..4272594 100644
> --- a/kernel/sched_stats.h
> +++ b/kernel/sched_stats.h
> @@ -180,6 +180,7 @@ static inline void sched_info_dequeued(
>  	sched_info_reset_dequeued(t);
>  	t->sched_info.run_delay += delta;
> 
> +	cpuacct_accumulate_run_delay(t, delta);
>  	rq_sched_info_dequeued(task_rq(t), delta);
>  }
> 
> @@ -199,6 +200,7 @@ static void sched_info_arrive(
>  	t->sched_info.last_arrival = now;
>  	t->sched_info.pcount++;
> 
> +	cpuacct_accumulate_run_delay(t, delta);
>  	rq_sched_info_arrive(task_rq(t), delta);
>  }

