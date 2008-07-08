Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYGHO1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYGHO1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 10:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYGHO1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 10:27:08 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:65508 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbYGHO1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 10:27:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkQFAHQQc0hMQWVt/2dsb2JhbACBXK5t
Date: Tue, 8 Jul 2008 10:27:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] stop_machine: simplify
Message-ID: <20080708142703.GB8278@Krystal>
References: <200807081750.55536.rusty@rustcorp.com.au> <200807081756.02838.rusty@rustcorp.com.au> <200807081756.47140.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200807081756.47140.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:21:58 up 33 days, 19:02,  5 users,  load average: 0.86, 1.43,
	1.69
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> stop_machine creates a kthread which creates kernel threads.  We can
> create those threads directly and simplify things a little.  Some care
> must be taken with CPU hotunplug, which has special needs, but that code
> seems more robust than it was in the past.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  include/linux/stop_machine.h |   12 -
>  kernel/cpu.c                 |   13 -
>  kernel/stop_machine.c        |  299 ++++++++++++++++++-------------------------
>  3 files changed, 135 insertions(+), 189 deletions(-)
> 
> diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
> --- a/include/linux/stop_machine.h
> +++ b/include/linux/stop_machine.h
> @@ -17,13 +17,12 @@
>   * @data: the data ptr for the @fn()
>   * @cpu: if @cpu == n, run @fn() on cpu n
>   *       if @cpu == NR_CPUS, run @fn() on any cpu
> - *       if @cpu == ALL_CPUS, run @fn() first on the calling cpu, and then
> - *       concurrently on all the other cpus
> + *       if @cpu == ALL_CPUS, run @fn() on every online CPU.
>   *

I agree with this change if it makes things simpler. However, callers
must be aware of this important change :

"run @fn() first on the calling cpu, and then concurrently on all the
other cpus" becomes "run @fn() on every online CPU".

There were assumptions done in @fn() where a simple non atomic increment
was used on a static variable to detect that it was the first thread to
execute. It will have to be changed into an atomic inc/dec and test.
Given that the other threads have tasks to perform _after_ the first
thread has executed, they will have to busy-wait (spin) there waiting
for the first thread to finish its execution.

Mathieu

> - * Description: This causes a thread to be scheduled on every other cpu,
> - * each of which disables interrupts, and finally interrupts are disabled
> - * on the current CPU.  The result is that noone is holding a spinlock
> - * or inside any other preempt-disabled region when @fn() runs.
> + * Description: This causes a thread to be scheduled on every cpu,
> + * each of which disables interrupts.  The result is that noone is
> + * holding a spinlock or inside any other preempt-disabled region when
> + * @fn() runs.
>   *
>   * This can be thought of as a very heavy write lock, equivalent to
>   * grabbing every spinlock in the kernel. */
> @@ -35,13 +34,10 @@ int stop_machine_run(int (*fn)(void *), 
>   * @data: the data ptr for the @fn
>   * @cpu: the cpu to run @fn on (or any, if @cpu == NR_CPUS.
>   *
> - * Description: This is a special version of the above, which returns the
> - * thread which has run @fn(): kthread_stop will return the return value
> - * of @fn().  Used by hotplug cpu.
> + * Description: This is a special version of the above, which assumes cpus
> + * won't come or go while it's being called.  Used by hotplug cpu.
>   */
> -struct task_struct *__stop_machine_run(int (*fn)(void *), void *data,
> -				       unsigned int cpu);
> -
> +int __stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu);
>  #else
>  
>  static inline int stop_machine_run(int (*fn)(void *), void *data,
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -192,7 +192,6 @@ static int __ref _cpu_down(unsigned int 
>  static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
>  {
>  	int err, nr_calls = 0;
> -	struct task_struct *p;
>  	cpumask_t old_allowed, tmp;
>  	void *hcpu = (void *)(long)cpu;
>  	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
> @@ -226,19 +225,15 @@ static int __ref _cpu_down(unsigned int 
>  	cpu_clear(cpu, tmp);
>  	set_cpus_allowed_ptr(current, &tmp);
>  
> -	p = __stop_machine_run(take_cpu_down, &tcd_param, cpu);
> +	err = __stop_machine_run(take_cpu_down, &tcd_param, cpu);
>  
> -	if (IS_ERR(p) || cpu_online(cpu)) {
> +	if (err || cpu_online(cpu)) {
>  		/* CPU didn't die: tell everyone.  Can't complain. */
>  		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
>  					    hcpu) == NOTIFY_BAD)
>  			BUG();
>  
> -		if (IS_ERR(p)) {
> -			err = PTR_ERR(p);
> -			goto out_allowed;
> -		}
> -		goto out_thread;
> +		goto out_allowed;
>  	}
>  
>  	/* Wait for it to sleep (leaving idle task). */
> @@ -255,8 +250,6 @@ static int __ref _cpu_down(unsigned int 
>  
>  	check_for_tasks(cpu);
>  
> -out_thread:
> -	err = kthread_stop(p);
>  out_allowed:
>  	set_cpus_allowed_ptr(current, &old_allowed);
>  out_release:
> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -1,4 +1,4 @@
> -/* Copyright 2005 Rusty Russell rusty@rustcorp.com.au IBM Corporation.
> +/* Copyright 2008, 2005 Rusty Russell rusty@rustcorp.com.au IBM Corporation.
>   * GPL v2 and any later version.
>   */
>  #include <linux/cpu.h>
> @@ -13,219 +13,176 @@
>  #include <asm/atomic.h>
>  #include <asm/uaccess.h>
>  
> -/* Since we effect priority and affinity (both of which are visible
> - * to, and settable by outside processes) we do indirection via a
> - * kthread. */
> -
> -/* Thread to stop each CPU in user context. */
> +/* This controls the threads on each CPU. */
>  enum stopmachine_state {
> -	STOPMACHINE_WAIT,
> +	/* Dummy starting state for thread. */
> +	STOPMACHINE_NONE,
> +	/* Awaiting everyone to be scheduled. */
>  	STOPMACHINE_PREPARE,
> +	/* Disable interrupts. */
>  	STOPMACHINE_DISABLE_IRQ,
> +	/* Run the function */
>  	STOPMACHINE_RUN,
> +	/* Exit */
>  	STOPMACHINE_EXIT,
>  };
> +static enum stopmachine_state state;
>  
>  struct stop_machine_data {
>  	int (*fn)(void *);
>  	void *data;
> -	struct completion done;
> -	int run_all;
> -} smdata;
> +	int fnret;
> +};
>  
> -static enum stopmachine_state stopmachine_state;
> -static unsigned int stopmachine_num_threads;
> -static atomic_t stopmachine_thread_ack;
> +/* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
> +static unsigned int num_threads;
> +static atomic_t thread_ack;
> +static struct completion finished;
> +static DEFINE_MUTEX(lock);
>  
> -static int stopmachine(void *cpu)
> +static void set_state(enum stopmachine_state newstate)
>  {
> -	int irqs_disabled = 0;
> -	int prepared = 0;
> -	int ran = 0;
> +	/* Reset ack counter. */
> +	atomic_set(&thread_ack, num_threads);
> +	smp_wmb();
> +	state = newstate;
> +}
>  
> -	set_cpus_allowed_ptr(current, &cpumask_of_cpu((int)(long)cpu));
> +/* Last one to ack a state moves to the next state. */
> +static void ack_state(void)
> +{
> +	if (atomic_dec_and_test(&thread_ack)) {
> +		/* If we're the last one to ack the EXIT, we're finished. */
> +		if (state == STOPMACHINE_EXIT)
> +			complete(&finished);
> +		else
> +			set_state(state + 1);
> +	}
> +}
>  
> -	/* Ack: we are alive */
> -	smp_mb(); /* Theoretically the ack = 0 might not be on this CPU yet. */
> -	atomic_inc(&stopmachine_thread_ack);
> +/* This is the actual thread which stops the CPU.  It exits by itself rather
> + * than waiting for kthread_stop(), because it's easier for hotplug CPU. */
> +static int stop_cpu(struct stop_machine_data *smdata)
> +{
> +	enum stopmachine_state curstate = STOPMACHINE_NONE;
> +	int uninitialized_var(ret);
>  
>  	/* Simple state machine */
> -	while (stopmachine_state != STOPMACHINE_EXIT) {
> -		if (stopmachine_state == STOPMACHINE_DISABLE_IRQ 
> -		    && !irqs_disabled) {
> -			local_irq_disable();
> -			hard_irq_disable();
> -			irqs_disabled = 1;
> -			/* Ack: irqs disabled. */
> -			smp_mb(); /* Must read state first. */
> -			atomic_inc(&stopmachine_thread_ack);
> -		} else if (stopmachine_state == STOPMACHINE_PREPARE
> -			   && !prepared) {
> -			/* Everyone is in place, hold CPU. */
> -			preempt_disable();
> -			prepared = 1;
> -			smp_mb(); /* Must read state first. */
> -			atomic_inc(&stopmachine_thread_ack);
> -		} else if (stopmachine_state == STOPMACHINE_RUN && !ran) {
> -			smdata.fn(smdata.data);
> -			ran = 1;
> -			smp_mb(); /* Must read state first. */
> -			atomic_inc(&stopmachine_thread_ack);
> +	do {
> +		/* Chill out and ensure we re-read stopmachine_state. */
> +		cpu_relax();
> +		if (state != curstate) {
> +			curstate = state;
> +			switch (curstate) {
> +			case STOPMACHINE_DISABLE_IRQ:
> +				local_irq_disable();
> +				hard_irq_disable();
> +				break;
> +			case STOPMACHINE_RUN:
> +				/* |= allows error detection if functions on
> +				 * multiple CPUs. */
> +				smdata->fnret |= smdata->fn(smdata->data);
> +				break;
> +			default:
> +				break;
> +			}
> +			ack_state();
>  		}
> -		/* Yield in first stage: migration threads need to
> -		 * help our sisters onto their CPUs. */
> -		if (!prepared && !irqs_disabled)
> -			yield();
> -		cpu_relax();
> -	}
> +	} while (curstate != STOPMACHINE_EXIT);
>  
> -	/* Ack: we are exiting. */
> -	smp_mb(); /* Must read state first. */
> -	atomic_inc(&stopmachine_thread_ack);
> +	local_irq_enable();
> +	do_exit(0);
> +}
>  
> -	if (irqs_disabled)
> -		local_irq_enable();
> -	if (prepared)
> -		preempt_enable();
> -
> +/* Callback for CPUs which aren't supposed to do anything. */
> +static int chill(void *unused)
> +{
>  	return 0;
>  }
>  
> -/* Change the thread state */
> -static void stopmachine_set_state(enum stopmachine_state state)
> +int __stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu)
>  {
> -	atomic_set(&stopmachine_thread_ack, 0);
> -	smp_wmb();
> -	stopmachine_state = state;
> -	while (atomic_read(&stopmachine_thread_ack) != stopmachine_num_threads)
> -		cpu_relax();
> -}
> +	int i, err;
> +	struct stop_machine_data active, idle;
> +	struct task_struct **threads;
>  
> -static int stop_machine(void)
> -{
> -	int i, ret = 0;
> +	active.fn = fn;
> +	active.data = data;
> +	active.fnret = 0;
> +	idle.fn = chill;
> +	idle.data = NULL;
>  
> -	atomic_set(&stopmachine_thread_ack, 0);
> -	stopmachine_num_threads = 0;
> -	stopmachine_state = STOPMACHINE_WAIT;
> +	/* If they don't care which cpu fn runs on, just pick one. */
> +	if (cpu == NR_CPUS)
> +		cpu = any_online_cpu(cpu_online_map);
> +
> +	/* This could be too big for stack on large machines. */
> +	threads = kcalloc(NR_CPUS, sizeof(threads[0]), GFP_KERNEL);
> +	if (!threads)
> +		return -ENOMEM;
> +
> +	/* Set up initial state. */
> +	mutex_lock(&lock);
> +	init_completion(&finished);
> +	num_threads = num_online_cpus();
> +	set_state(STOPMACHINE_PREPARE);
>  
>  	for_each_online_cpu(i) {
> -		if (i == raw_smp_processor_id())
> -			continue;
> -		ret = kernel_thread(stopmachine, (void *)(long)i,CLONE_KERNEL);
> -		if (ret < 0)
> -			break;
> -		stopmachine_num_threads++;
> +		struct stop_machine_data *smdata;
> +		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
> +
> +		if (cpu == ALL_CPUS || i == cpu)
> +			smdata = &active;
> +		else
> +			smdata = &idle;
> +
> +		threads[i] = kthread_create(stop_cpu, smdata, "kstop%u", i);
> +		if (IS_ERR(threads[i])) {
> +			err = PTR_ERR(threads[i]);
> +			threads[i] = NULL;
> +			goto kill_threads;
> +		}
> +
> +		/* Place it onto correct cpu. */
> +		kthread_bind(threads[i], i);
> +
> +		/* Make it highest prio. */
> +		if (sched_setscheduler_nocheck(threads[i], SCHED_FIFO, &param))
> +			BUG();
>  	}
>  
> -	/* Wait for them all to come to life. */
> -	while (atomic_read(&stopmachine_thread_ack) != stopmachine_num_threads) {
> -		yield();
> -		cpu_relax();
> -	}
> +	/* We've created all the threads.  Wake them all: hold this CPU so one
> +	 * doesn't hit this CPU until we're ready. */
> +	cpu = get_cpu();
> +	for_each_online_cpu(i)
> +		wake_up_process(threads[i]);
>  
> -	/* If some failed, kill them all. */
> -	if (ret < 0) {
> -		stopmachine_set_state(STOPMACHINE_EXIT);
> -		return ret;
> -	}
> +	/* This will release the thread on our CPU. */
> +	put_cpu();
> +	wait_for_completion(&finished);
> +	mutex_unlock(&lock);
>  
> -	/* Now they are all started, make them hold the CPUs, ready. */
> -	preempt_disable();
> -	stopmachine_set_state(STOPMACHINE_PREPARE);
> +	kfree(threads);
>  
> -	/* Make them disable irqs. */
> -	local_irq_disable();
> -	hard_irq_disable();
> -	stopmachine_set_state(STOPMACHINE_DISABLE_IRQ);
> +	return active.fnret;
>  
> -	return 0;
> -}
> +kill_threads:
> +	for_each_online_cpu(i)
> +		if (threads[i])
> +			kthread_stop(threads[i]);
> +	mutex_unlock(&lock);
>  
> -static void restart_machine(void)
> -{
> -	stopmachine_set_state(STOPMACHINE_EXIT);
> -	local_irq_enable();
> -	preempt_enable_no_resched();
> -}
> -
> -static void run_other_cpus(void)
> -{
> -	stopmachine_set_state(STOPMACHINE_RUN);
> -}
> -
> -static int do_stop(void *_smdata)
> -{
> -	struct stop_machine_data *smdata = _smdata;
> -	int ret;
> -
> -	ret = stop_machine();
> -	if (ret == 0) {
> -		ret = smdata->fn(smdata->data);
> -		if (smdata->run_all)
> -			run_other_cpus();
> -		restart_machine();
> -	}
> -
> -	/* We're done: you can kthread_stop us now */
> -	complete(&smdata->done);
> -
> -	/* Wait for kthread_stop */
> -	set_current_state(TASK_INTERRUPTIBLE);
> -	while (!kthread_should_stop()) {
> -		schedule();
> -		set_current_state(TASK_INTERRUPTIBLE);
> -	}
> -	__set_current_state(TASK_RUNNING);
> -	return ret;
> -}
> -
> -struct task_struct *__stop_machine_run(int (*fn)(void *), void *data,
> -				       unsigned int cpu)
> -{
> -	static DEFINE_MUTEX(stopmachine_mutex);
> -	struct stop_machine_data smdata;
> -	struct task_struct *p;
> -
> -	mutex_lock(&stopmachine_mutex);
> -
> -	smdata.fn = fn;
> -	smdata.data = data;
> -	smdata.run_all = (cpu == ALL_CPUS) ? 1 : 0;
> -	init_completion(&smdata.done);
> -
> -	smp_wmb(); /* make sure other cpus see smdata updates */
> -
> -	/* If they don't care which CPU fn runs on, bind to any online one. */
> -	if (cpu == NR_CPUS || cpu == ALL_CPUS)
> -		cpu = raw_smp_processor_id();
> -
> -	p = kthread_create(do_stop, &smdata, "kstopmachine");
> -	if (!IS_ERR(p)) {
> -		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
> -
> -		/* One high-prio thread per cpu.  We'll do this one. */
> -		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
> -		kthread_bind(p, cpu);
> -		wake_up_process(p);
> -		wait_for_completion(&smdata.done);
> -	}
> -	mutex_unlock(&stopmachine_mutex);
> -	return p;
> +	kfree(threads);
> +	return err;
>  }
>  
>  int stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu)
>  {
> -	struct task_struct *p;
>  	int ret;
>  
>  	/* No CPUs can come up or down during this. */
>  	get_online_cpus();
> -	p = __stop_machine_run(fn, data, cpu);
> -	if (!IS_ERR(p))
> -		ret = kthread_stop(p);
> -	else
> -		ret = PTR_ERR(p);
> +	ret = __stop_machine_run(fn, data, cpu);
>  	put_online_cpus();
>  
>  	return ret;

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
