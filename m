Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbZLDMGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbZLDMGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 07:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbZLDMGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 07:06:08 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:54804 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbZLDMGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 07:06:06 -0500
Message-ID: <4B18FB2E.1070200@in.ibm.com>
Date: Fri, 04 Dec 2009 17:36:06 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: ego@in.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Gregory Haskins <ghaskins@novell.com>, maxk <maxk@qualcomm.com>
Subject: Re: -next: Nov 12 - kernel BUG at kernel/sched.c:7359!
References: <20091112195101.63263490.sfr@canb.auug.org.au> <4AFBF73B.5040500@in.ibm.com> <1258027820.4039.129.camel@laptop> <4AFBFE3D.80507@in.ibm.com> <1258028831.4039.152.camel@laptop> <1258045831.4039.736.camel@laptop>  <20091113095801.GA29977@in.ibm.com> <1258107368.4039.1149.camel@laptop> <1258108281.22655.5.camel@laptop> <4B0A5BA7.8020604@in.ibm.com> <1259156575.4027.514.camel@laptop>
In-Reply-To: <1259156575.4027.514.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-11-23 at 15:23 +0530, Sachin Sant wrote:
>   
>> Peter Zijlstra wrote:
>>     
>>> Well, it boots for me, but then, I've not been able to reproduce any
>>> issues anyway :/
>>>
>>> /me goes try a PREEMPT=n kernel, since that is what Mike reports boot
>>> funnies with..
>>>
>>> Full running diff against -tip:
>>>   
>>>       
>> Peter i still can recreate this issue with today's next(20091123).
>> Looks like the following patch haven't been merged yet.
>>     
>
> Correct, Ingo objected to the fastpath overhead.
>
> Could you please try the below patch which tries to address the issue
> differently.
>
>   
Peter,

Ping on this patch. Still missing from linux-next.

thanks
-Sachin

> ---
> Subject: sched: Fix balance vs hotplug race
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed Nov 25 13:31:39 CET 2009
>
> Since (e761b77: cpu hotplug, sched: Introduce cpu_active_map and redo
> sched domain managment) we have cpu_active_mask which is suppose to
> rule scheduler migration and load-balancing, except it never did.
>
> The particular problem being solved here is a crash in
> try_to_wake_up() where select_task_rq() ends up selecting an offline
> cpu because select_task_rq_fair() trusts the sched_domain tree to reflect
> the current state of affairs, similarly select_task_rq_rt() trusts the
> root_domain.
>
> However, the sched_domains are updated from CPU_DEAD, which is after
> the cpu is taken offline and after stop_machine is done. Therefore it
> can race perfectly well with code assuming the domains are right.
>
> Cure this by building the domains from cpu_active_mask on
> CPU_DOWN_PREPARE.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/cpumask.h |    2 ++
>  kernel/cpu.c            |   18 +++++++++++++-----
>  kernel/cpuset.c         |   16 +++++++++-------
>  kernel/sched.c          |   44 ++++++++++++++++++++++++++------------------
>  4 files changed, 50 insertions(+), 30 deletions(-)
>
> Index: linux-2.6/include/linux/cpumask.h
> ===================================================================
> --- linux-2.6.orig/include/linux/cpumask.h
> +++ linux-2.6/include/linux/cpumask.h
> @@ -84,6 +84,7 @@ extern const struct cpumask *const cpu_a
>  #define num_online_cpus()	cpumask_weight(cpu_online_mask)
>  #define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
>  #define num_present_cpus()	cpumask_weight(cpu_present_mask)
> +#define num_active_cpus()	cpumask_weight(cpu_active_mask)
>  #define cpu_online(cpu)		cpumask_test_cpu((cpu), cpu_online_mask)
>  #define cpu_possible(cpu)	cpumask_test_cpu((cpu), cpu_possible_mask)
>  #define cpu_present(cpu)	cpumask_test_cpu((cpu), cpu_present_mask)
> @@ -92,6 +93,7 @@ extern const struct cpumask *const cpu_a
>  #define num_online_cpus()	1
>  #define num_possible_cpus()	1
>  #define num_present_cpus()	1
> +#define num_active_cpus()	1
>  #define cpu_online(cpu)		((cpu) == 0)
>  #define cpu_possible(cpu)	((cpu) == 0)
>  #define cpu_present(cpu)	((cpu) == 0)
> Index: linux-2.6/kernel/cpuset.c
> ===================================================================
> --- linux-2.6.orig/kernel/cpuset.c
> +++ linux-2.6/kernel/cpuset.c
> @@ -872,7 +872,7 @@ static int update_cpumask(struct cpuset 
>  		if (retval < 0)
>  			return retval;
>
> -		if (!cpumask_subset(trialcs->cpus_allowed, cpu_online_mask))
> +		if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
>  			return -EINVAL;
>  	}
>  	retval = validate_change(cs, trialcs);
> @@ -2010,7 +2010,7 @@ static void scan_for_empty_cpusets(struc
>  		}
>
>  		/* Continue past cpusets with all cpus, mems online */
> -		if (cpumask_subset(cp->cpus_allowed, cpu_online_mask) &&
> +		if (cpumask_subset(cp->cpus_allowed, cpu_active_mask) &&
>  		    nodes_subset(cp->mems_allowed, node_states[N_HIGH_MEMORY]))
>  			continue;
>
> @@ -2019,7 +2019,7 @@ static void scan_for_empty_cpusets(struc
>  		/* Remove offline cpus and mems from this cpuset. */
>  		mutex_lock(&callback_mutex);
>  		cpumask_and(cp->cpus_allowed, cp->cpus_allowed,
> -			    cpu_online_mask);
> +			    cpu_active_mask);
>  		nodes_and(cp->mems_allowed, cp->mems_allowed,
>  						node_states[N_HIGH_MEMORY]);
>  		mutex_unlock(&callback_mutex);
> @@ -2057,8 +2057,10 @@ static int cpuset_track_online_cpus(stru
>  	switch (phase) {
>  	case CPU_ONLINE:
>  	case CPU_ONLINE_FROZEN:
> -	case CPU_DEAD:
> -	case CPU_DEAD_FROZEN:
> +	case CPU_DOWN_PREPARE:
> +	case CPU_DOWN_PREPARE_FROZEN:
> +	case CPU_DOWN_FAILED:
> +	case CPU_DOWN_FAILED_FROZEN:
>  		break;
>
>  	default:
> @@ -2067,7 +2069,7 @@ static int cpuset_track_online_cpus(stru
>
>  	cgroup_lock();
>  	mutex_lock(&callback_mutex);
> -	cpumask_copy(top_cpuset.cpus_allowed, cpu_online_mask);
> +	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
>  	mutex_unlock(&callback_mutex);
>  	scan_for_empty_cpusets(&top_cpuset);
>  	ndoms = generate_sched_domains(&doms, &attr);
> @@ -2114,7 +2116,7 @@ static int cpuset_track_online_nodes(str
>
>  void __init cpuset_init_smp(void)
>  {
> -	cpumask_copy(top_cpuset.cpus_allowed, cpu_online_mask);
> +	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
>  	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
>
>  	hotcpu_notifier(cpuset_track_online_cpus, 0);
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2323,6 +2323,12 @@ void task_oncpu_function_call(struct tas
>  	preempt_enable();
>  }
>
> +static inline
> +int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
> +{
> +	return p->sched_class->select_task_rq(p, sd_flags, wake_flags);
> +}
> +
>  /***
>   * try_to_wake_up - wake up a thread
>   * @p: the to-be-woken-up thread
> @@ -2376,7 +2382,7 @@ static int try_to_wake_up(struct task_st
>  	p->state = TASK_WAKING;
>  	task_rq_unlock(rq, &flags);
>
> -	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
> +	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
>  	if (cpu != orig_cpu) {
>  		local_irq_save(flags);
>  		rq = cpu_rq(cpu);
> @@ -2593,7 +2599,7 @@ void sched_fork(struct task_struct *p, i
>  		p->sched_class = &fair_sched_class;
>
>  #ifdef CONFIG_SMP
> -	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
> +	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
>  #endif
>  	local_irq_save(flags);
>  	update_rq_clock(cpu_rq(cpu));
> @@ -3156,7 +3162,7 @@ out:
>  void sched_exec(void)
>  {
>  	int new_cpu, this_cpu = get_cpu();
> -	new_cpu = current->sched_class->select_task_rq(current, SD_BALANCE_EXEC, 0);
> +	new_cpu = select_task_rq(current, SD_BALANCE_EXEC, 0);
>  	put_cpu();
>  	if (new_cpu != this_cpu)
>  		sched_migrate_task(current, new_cpu);
> @@ -4134,7 +4140,7 @@ static int load_balance(int this_cpu, st
>  	unsigned long flags;
>  	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
>
> -	cpumask_copy(cpus, cpu_online_mask);
> +	cpumask_copy(cpus, cpu_active_mask);
>
>  	/*
>  	 * When power savings policy is enabled for the parent domain, idle
> @@ -4297,7 +4303,7 @@ load_balance_newidle(int this_cpu, struc
>  	int all_pinned = 0;
>  	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
>
> -	cpumask_copy(cpus, cpu_online_mask);
> +	cpumask_copy(cpus, cpu_active_mask);
>
>  	/*
>  	 * When power savings policy is enabled for the parent domain, idle
> @@ -4694,7 +4700,7 @@ int select_nohz_load_balancer(int stop_t
>  		cpumask_set_cpu(cpu, nohz.cpu_mask);
>
>  		/* time for ilb owner also to sleep */
> -		if (cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
> +		if (cpumask_weight(nohz.cpu_mask) == num_active_cpus()) {
>  			if (atomic_read(&nohz.load_balancer) == cpu)
>  				atomic_set(&nohz.load_balancer, -1);
>  			return 0;
> @@ -7071,7 +7077,7 @@ int set_cpus_allowed_ptr(struct task_str
>  	int ret = 0;
>
>  	rq = task_rq_lock(p, &flags);
> -	if (!cpumask_intersects(new_mask, cpu_online_mask)) {
> +	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
>  		ret = -EINVAL;
>  		goto out;
>  	}
> @@ -7093,7 +7099,7 @@ int set_cpus_allowed_ptr(struct task_str
>  	if (cpumask_test_cpu(task_cpu(p), new_mask))
>  		goto out;
>
> -	if (migrate_task(p, cpumask_any_and(cpu_online_mask, new_mask), &req)) {
> +	if (migrate_task(p, cpumask_any_and(cpu_active_mask, new_mask), &req)) {
>  		/* Need help from migration thread: drop lock and wait. */
>  		struct task_struct *mt = rq->migration_thread;
>
> @@ -7247,19 +7253,19 @@ static void move_task_off_dead_cpu(int d
>
>  again:
>  	/* Look for allowed, online CPU in same node. */
> -	for_each_cpu_and(dest_cpu, nodemask, cpu_online_mask)
> +	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
>  		if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
>  			goto move;
>
>  	/* Any allowed, online CPU? */
> -	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_online_mask);
> +	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
>  	if (dest_cpu < nr_cpu_ids)
>  		goto move;
>
>  	/* No more Mr. Nice Guy. */
>  	if (dest_cpu >= nr_cpu_ids) {
>  		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
> -		dest_cpu = cpumask_any_and(cpu_online_mask, &p->cpus_allowed);
> +		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
>
>  		/*
>  		 * Don't tell them about moving exiting tasks or
> @@ -7288,7 +7294,7 @@ move:
>   */
>  static void migrate_nr_uninterruptible(struct rq *rq_src)
>  {
> -	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_online_mask));
> +	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
>  	unsigned long flags;
>
>  	local_irq_save(flags);
> @@ -7542,7 +7548,7 @@ static ctl_table *sd_alloc_ctl_cpu_table
>  static struct ctl_table_header *sd_sysctl_header;
>  static void register_sched_domain_sysctl(void)
>  {
> -	int i, cpu_num = num_online_cpus();
> +	int i, cpu_num = num_possible_cpus();
>  	struct ctl_table *entry = sd_alloc_ctl_entry(cpu_num + 1);
>  	char buf[32];
>
> @@ -7552,7 +7558,7 @@ static void register_sched_domain_sysctl
>  	if (entry == NULL)
>  		return;
>
> -	for_each_online_cpu(i) {
> +	for_each_possible_cpu(i) {
>  		snprintf(buf, 32, "cpu%d", i);
>  		entry->procname = kstrdup(buf, GFP_KERNEL);
>  		entry->mode = 0555;
> @@ -9064,7 +9070,7 @@ match1:
>  	if (doms_new == NULL) {
>  		ndoms_cur = 0;
>  		doms_new = &fallback_doms;
> -		cpumask_andnot(doms_new[0], cpu_online_mask, cpu_isolated_map);
> +		cpumask_andnot(doms_new[0], cpu_active_mask, cpu_isolated_map);
>  		WARN_ON_ONCE(dattr_new);
>  	}
>
> @@ -9195,8 +9201,10 @@ static int update_sched_domains(struct n
>  	switch (action) {
>  	case CPU_ONLINE:
>  	case CPU_ONLINE_FROZEN:
> -	case CPU_DEAD:
> -	case CPU_DEAD_FROZEN:
> +	case CPU_DOWN_PREPARE:
> +	case CPU_DOWN_PREPARE_FROZEN:
> +	case CPU_DOWN_FAILED:
> +	case CPU_DOWN_FAILED_FROZEN:
>  		partition_sched_domains(1, NULL, NULL);
>  		return NOTIFY_OK;
>
> @@ -9243,7 +9251,7 @@ void __init sched_init_smp(void)
>  #endif
>  	get_online_cpus();
>  	mutex_lock(&sched_domains_mutex);
> -	arch_init_sched_domains(cpu_online_mask);
> +	arch_init_sched_domains(cpu_active_mask);
>  	cpumask_andnot(non_isolated_cpus, cpu_possible_mask, cpu_isolated_map);
>  	if (cpumask_empty(non_isolated_cpus))
>  		cpumask_set_cpu(smp_processor_id(), non_isolated_cpus);
> Index: linux-2.6/kernel/cpu.c
> ===================================================================
> --- linux-2.6.orig/kernel/cpu.c
> +++ linux-2.6/kernel/cpu.c
> @@ -212,6 +212,8 @@ static int __ref _cpu_down(unsigned int 
>  	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
>  					hcpu, -1, &nr_calls);
>  	if (err == NOTIFY_BAD) {
> +		set_cpu_active(cpu, true);
> +
>  		nr_calls--;
>  		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
>  					  hcpu, nr_calls, NULL);
> @@ -223,11 +225,11 @@ static int __ref _cpu_down(unsigned int 
>
>  	/* Ensure that we are not runnable on dying cpu */
>  	cpumask_copy(old_allowed, &current->cpus_allowed);
> -	set_cpus_allowed_ptr(current,
> -			     cpumask_of(cpumask_any_but(cpu_online_mask, cpu)));
> +	set_cpus_allowed_ptr(current, cpu_active_mask);
>
>  	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
>  	if (err) {
> +		set_cpu_active(cpu, true);
>  		/* CPU didn't die: tell everyone.  Can't complain. */
>  		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
>  					    hcpu) == NOTIFY_BAD)
> @@ -292,9 +294,6 @@ int __ref cpu_down(unsigned int cpu)
>
>  	err = _cpu_down(cpu, 0);
>
> -	if (cpu_online(cpu))
> -		set_cpu_active(cpu, true);
> -
>  out:
>  	cpu_maps_update_done();
>  	stop_machine_destroy();
> @@ -387,6 +386,15 @@ int disable_nonboot_cpus(void)
>  	 * with the userspace trying to use the CPU hotplug at the same time
>  	 */
>  	cpumask_clear(frozen_cpus);
> +
> +	for_each_online_cpu(cpu) {
> +		if (cpu == first_cpu)
> +			continue;
> +		set_cpu_active(cpu, false);
> +	}
> +
> +	synchronize_sched();
> +
>  	printk("Disabling non-boot CPUs ...\n");
>  	for_each_online_cpu(cpu) {
>  		if (cpu == first_cpu)
>
>
>   


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

