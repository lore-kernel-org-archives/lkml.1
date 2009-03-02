Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZCBO4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZCBO4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 09:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbZCBO43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 09:56:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46145 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZCBO42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 09:56:28 -0500
Subject: Re: [RFC][PATCH] remove rq->lock from cpuacct cgroup (Was Re:
 [PATCH] cpuacct: add a branch prediction
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, Bharata B Rao <bharata.rao@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090227122239.875a3f56.kamezawa.hiroyu@jp.fujitsu.com>
References: <49A65455.4030204@cn.fujitsu.com>
	 <20090226174033.094e4834.kamezawa.hiroyu@jp.fujitsu.com>
	 <344eb09a0902260210y44c0684by9b22f041116d3f7c@mail.gmail.com>
	 <18f6db017e5d44596e828e0753f28e75.squirrel@webmail-b.css.fujitsu.com>
	 <1235645076.4645.4781.camel@laptop>
	 <934198669efa83e838a52284e2c4f8b5.squirrel@webmail-b.css.fujitsu.com>
	 <1235647682.4948.15.camel@laptop>
	 <145d0010d65060bb089d5a87e06cbd0d.squirrel@webmail-b.css.fujitsu.com>
	 <20090226164509.GB6634@linux.vnet.ibm.com>
	 <20090227095856.ef8c1c05.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090227012915.GF6634@linux.vnet.ibm.com>
	 <20090227122239.875a3f56.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 15:56:10 +0100
Message-Id: <1236005770.5330.583.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 12:22 +0900, KAMEZAWA Hiroyuki wrote:

Comments below..

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> cgroup/cpuacct subsystem counts cpu usage by 64bit coutnter in
> per-cpu object. In read-side (via cpuacct.usage file), for reading 64bit
> value in safe manner, it takes rq->lock of (other) cpus.
> 
> In general, taking rq->lock of other cpus from codes not for scheduler
> is not good. This patch tries to remove rq->lock used in read-side.
> 
> To read 64bit value in safe, this patch uses seqcounter.
> 
> Pros.
>   - rq->lock is not necessary.
> Cons.
>   - When updating counter, sequence number must be updated.
>     (I hope this per-cpu sequence number is on cache...)
>   - not simple.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  kernel/sched.c |  141 ++++++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 105 insertions(+), 36 deletions(-)
> 
> Index: mmotm-2.6.29-Feb24/kernel/sched.c
> ===================================================================
> --- mmotm-2.6.29-Feb24.orig/kernel/sched.c
> +++ mmotm-2.6.29-Feb24/kernel/sched.c
> @@ -9581,6 +9581,67 @@ struct cgroup_subsys cpu_cgroup_subsys =
>  
>  #ifdef CONFIG_CGROUP_CPUACCT
>  
> +#ifndef CONFIG_64BIT
> +DEFINE_PER_CPU(struct seqcount, cpuacct_cgroup_seq);
> +
> +static inline void cpuacct_start_counter_update(void)
> +{
> +	/* This is called under rq->lock and IRQ is off */
> +	struct seqcount *s = &get_cpu_var(cpuacct_cgroup_seq);
> +
> +	write_seqcount_begin(s);
> +	put_cpu_var(cpuacct_cgroup_seq);
> +}
> +
> +static inline void cpuacct_end_counter_update(void)
> +{
> +	struct seqcount *s = &get_cpu_var(cpuacct_cgroup_seq);
> +
> +	write_seqcount_end(s);
> +	put_cpu_var(cpuacct_cgroup_seq);
> +}

It seems odd we disable/enable preemption in both, I would expect for
start to disable preemption, and have end enable it again, or use
__get_cpu_var() and assume preemption is already disabled (callsites are
under rq->lock, right?)

> +static inline u64
> +cpuacct_read_counter(u64 *val, int cpu)
> +{
> +	struct seqcount *s = &per_cpu(cpuacct_cgroup_seq, cpu);
> +	unsigned int seq;
> +	u64 data;
> +
> +	do {
> +		seq = read_seqcount_begin(s);
> +		data = *val;
> +	} while (read_seqcount_retry(s, seq));
> +	return data;
> +}
> +/* This is a special funtion called against "offline" cpus. */
> +static inline void cpuacct_reset_offline_counter(u64 *val, int cpu)
> +{
> +	struct seqcount *s = &per_cpu(cpuacct_cgroup_seq, cpu);
> +
> +	preempt_disable();
> +	write_seqcount_begin(s);
> +	*val = 0;
> +	write_seqcount_end(s);
> +	preempt_enable();
> +}

And here you double disable preemption, quite useless if you take a
remote cpu's per-cpu data.

> +#else
> +static inline void cpuacct_start_counter_update(void)
> +{
> +}
> +static inline void cpuacct_end_counter_update(void)
> +{
> +}
> +static inline u64 cpuacct_read_counter(u64 *val, int cpu)
> +{
> +	return *val;
> +}
> +static inline void cpuacct_reset_offline_counter(u64 *val, int cpu)
> +{
> +	*val = 0;
> +}
> +#endif
> +
>  /*
>   * CPU accounting code for task groups.
>   *
> @@ -9596,6 +9657,11 @@ struct cpuacct {
>  	struct cpuacct *parent;
>  };
>  
> +struct cpuacct_work {
> +	struct work_struct work;
> +	struct cpuacct *cpuacct;
> +};
> +
>  struct cgroup_subsys cpuacct_subsys;
>  
>  /* return cpu accounting group corresponding to this container */
> @@ -9643,39 +9709,29 @@ cpuacct_destroy(struct cgroup_subsys *ss
>  	kfree(ca);
>  }
>  
> +/* In 32bit enviroment, seqcounter is used for reading 64bit in safe way */
>  static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
>  {
>  	u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
>  	u64 data;
>  
> -#ifndef CONFIG_64BIT
> -	/*
> -	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
> -	 */
> -	spin_lock_irq(&cpu_rq(cpu)->lock);
> -	data = *cpuusage;
> -	spin_unlock_irq(&cpu_rq(cpu)->lock);
> -#else
> -	data = *cpuusage;
> -#endif
> +	data = cpuacct_read_counter(cpuusage, cpu);
>  
>  	return data;
>  }
>  
> -static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
> +/* called by per-cpu workqueue */
> +static void cpuacct_cpuusage_reset_cpu(struct work_struct *work)
>  {
> +	struct cpuacct_work *cw = container_of(work, struct cpuacct_work, work);
> +	struct cpuacct *ca = cw->cpuacct;
> +	int cpu = get_cpu();
>  	u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
>  
> -#ifndef CONFIG_64BIT
> -	/*
> -	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
> -	 */
> -	spin_lock_irq(&cpu_rq(cpu)->lock);
> -	*cpuusage = val;
> -	spin_unlock_irq(&cpu_rq(cpu)->lock);
> -#else
> -	*cpuusage = val;
> -#endif
> +	cpuacct_start_counter_update();
> +	*cpuusage = 0;
> +	cpuacct_end_counter_update();
> +	put_cpu();
>  }
>  
>  /* return total cpu usage (in nanoseconds) of a group */
> @@ -9691,23 +9747,34 @@ static u64 cpuusage_read(struct cgroup *
>  	return totalcpuusage;
>  }
>  
> -static int cpuusage_write(struct cgroup *cgrp, struct cftype *cftype,
> -								u64 reset)
> +static int cpuacct_cpuusage_reset(struct cgroup *cgrp, unsigned int event)
>  {
>  	struct cpuacct *ca = cgroup_ca(cgrp);
> -	int err = 0;
> -	int i;
> -
> -	if (reset) {
> -		err = -EINVAL;
> -		goto out;
> +	int cpu;
> +	/*
> +	 * Reset All counters....doesn't need to be fast.
> +	 * "ca" will be stable while doing this. We are in write() syscall.
> +	 */
> +	get_online_cpus();
> +	/*
> +	 * Because we use alloc_percpu() for allocating counter, we have
> +	 * a counter per a possible cpu. Reset all online's by workqueue and
> +	 * reset offline cpu's directly.
> +	 */
> +	for_each_possible_cpu(cpu) {
> +		if (cpu_online(cpu)) {
> +			struct cpuacct_work cw;
> +			INIT_WORK(&cw.work, cpuacct_cpuusage_reset_cpu);
> +			cw.cpuacct = ca;
> +			schedule_work_on(cpu, &cw.work);
> +			flush_work(&cw.work);
> +		} else {
> +			u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
> +			cpuacct_reset_offline_counter(cpuusage, cpu);
> +		}

I'm not particularly convinced this is the right way, schedule_work_on()
sounds way expensive for setting a variable to 0.

Furthermore, if you want something like schedule_work_on() for each cpu,
there's schedule_on_each_cpu().

>  	}
> -
> -	for_each_present_cpu(i)
> -		cpuacct_cpuusage_write(ca, i, 0);
> -
> -out:
> -	return err;
> +	put_online_cpus();
> +	return 0;
>  }
>  
>  static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
> @@ -9729,7 +9796,7 @@ static struct cftype files[] = {
>  	{
>  		.name = "usage",
>  		.read_u64 = cpuusage_read,
> -		.write_u64 = cpuusage_write,
> +		.trigger = cpuacct_cpuusage_reset,
>  	},
>  	{
>  		.name = "usage_percpu",
> @@ -9756,10 +9823,12 @@ static void cpuacct_charge(struct task_s
>  	cpu = task_cpu(tsk);
>  	ca = task_ca(tsk);
>  
> +	cpuacct_start_counter_update();
>  	for (; ca; ca = ca->parent) {
>  		u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
>  		*cpuusage += cputime;
>  	}
> +	cpuacct_end_counter_update();
>  }
>  
>  struct cgroup_subsys cpuacct_subsys = {
> 

