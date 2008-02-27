Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYB0TFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYB0TFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbYB0TFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:05:23 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:63864 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756721AbYB0TFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:05:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAKhDxUdMQWRV/2dsb2JhbACBVqw5
Date: Wed, 27 Feb 2008 14:05:19 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 1/7] Immediate Values - Architecture Independent Code
Message-ID: <20080227190519.GA14335@Krystal>
References: <20080202210828.840735763@polymtl.ca> <20080202211204.268876860@polymtl.ca> <20080226225242.GA15926@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080226225242.GA15926@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:20:41 up 16 days, 14:21,  4 users,  load average: 0.36, 0.42,
	0.47
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Sat, Feb 02, 2008 at 04:08:29PM -0500, Mathieu Desnoyers wrote:
> > Changelog:
> > 
> > - section __imv is already SHF_ALLOC
> > - Because of the wonders of ELF, section 0 has sh_addr and sh_size 0.  So
> >   the if (immediateindex) is unnecessary here.
> > - Remove module_mutex usage: depend on functions implemented in module.c for
> >   that.
> 
> hi,
> 
> In testing this patch, i've run across a deadlock...apply_imv_update() can get
> called again before, ipi_busy_loop() has had a chance to finsh, and set 
> wait_sync back to its initial value. This causes ipi_busy_loop() to get stuck
> indefinitely and the subsequent apply_imv_update() hangs. I've shown this 
> deadlock below using nmi_watchdog=1 in item 1). 
> 
> After hitting this deadlock i modified apply_imv_update() to wait for 
> ipi_busy_loop(), to finish, however this resulted in a 3 way deadlock. Process
> A held a read lock on tasklist_lock, then process B called apply_imv_update().
> Process A received the IPI and begins executing ipi_busy_loop(). Then process
> C takes a write lock irq on the task list lock, before receiving the IPI. Thus,
> process A holds up process C, and C can't get an IPI b/c interrupts are
> disabled. i believe this is an inherent problem in using smp_call_function, in
> that one can't synchronize the processes on each other...you can reproduce
> these issues using the test module below item 2)
> 
> In order to address these issues, i've modified stop_machine_run() to take an
> new third parameter, RUN_ALL, to allow stop_machine_run() to run a function
> on all cpus, item 3). I then modified kernel/immediate.c to use this new 
> infrastructure item 4). the code in immediate.c simplifies quite a bit. This
> new code has been robust through all testing thus far.
> 

Ok, I see why you did it that way. Comments follow inline.

> thanks,
> 
> -Jason
> 
> 1)
[...]
 
> 2)
> 
[...]
> 
> 3)
> 
> 
> diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
> index 5bfc553..1ab1c5b 100644
> --- a/include/linux/stop_machine.h
> +++ b/include/linux/stop_machine.h
> @@ -8,6 +8,9 @@
>  #include <asm/system.h>
>  
>  #if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
> +
> +#define RUN_ALL ~0U
> +
>  /**
>   * stop_machine_run: freeze the machine on all CPUs and run this function
>   * @fn: the function to run
> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> index 51b5ee5..e6ee46f 100644
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -23,9 +23,17 @@ enum stopmachine_state {
>  	STOPMACHINE_WAIT,
>  	STOPMACHINE_PREPARE,
>  	STOPMACHINE_DISABLE_IRQ,
> +	STOPMACHINE_RUN,
>  	STOPMACHINE_EXIT,
>  };
>  
> +struct stop_machine_data {
> +	int (*fn)(void *);
> +	void *data;
> +	struct completion done;
> +	int run_all;
> +} smdata;
> +

Why do we now have to declare this static ? Can we pass it as a pointer
to stopmachine instead ?

>  static enum stopmachine_state stopmachine_state;
>  static unsigned int stopmachine_num_threads;
>  static atomic_t stopmachine_thread_ack;
> @@ -35,6 +43,7 @@ static int stopmachine(void *cpu)
>  {
>  	int irqs_disabled = 0;
>  	int prepared = 0;
> +	int ran = 0;
>  
>  	set_cpus_allowed(current, cpumask_of_cpu((int)(long)cpu));
>  
> @@ -59,6 +68,11 @@ static int stopmachine(void *cpu)
>  			prepared = 1;
>  			smp_mb(); /* Must read state first. */
>  			atomic_inc(&stopmachine_thread_ack);
> +		} else if (stopmachine_state == STOPMACHINE_RUN && !ran) {
> +			smdata.fn(smdata.data);
> +			ran = 1;
> +			smp_mb(); /* Must read state first. */
> +			atomic_inc(&stopmachine_thread_ack);
>  		}
>  		/* Yield in first stage: migration threads need to
>  		 * help our sisters onto their CPUs. */
> @@ -136,12 +150,10 @@ static void restart_machine(void)
>  	preempt_enable_no_resched();
>  }
>  
> -struct stop_machine_data
> +static void run_other_cpus(void)
>  {
> -	int (*fn)(void *);
> -	void *data;
> -	struct completion done;
> -};
> +	stopmachine_set_state(STOPMACHINE_RUN);

Hrm, the semantic of STOPMACHINE_RUN is a bit weird :
- The CPU where the do_stop thread runs will first execute (alone) the
  callback.
- Then, all the other CPUs will execute the callback concurrently.

Given that you use a "started" boolean in the callback, which is ok as
long as there is no concurrent modification (correct given the current
semantic, but fragile), I would tend to document that the first time the
callback is called, it is ran alone, without concurrency, and then all
the other callbacks are ran concurrently.


> +}
>  
>  static int do_stop(void *_smdata)
>  {
> @@ -151,6 +163,8 @@ static int do_stop(void *_smdata)
>  	ret = stop_machine();
>  	if (ret == 0) {
>  		ret = smdata->fn(smdata->data);
> +		if (smdata->run_all)
> +			run_other_cpus();
>  		restart_machine();
>  	}
>  
> @@ -170,17 +184,16 @@ static int do_stop(void *_smdata)
>  struct task_struct *__stop_machine_run(int (*fn)(void *), void *data,
>  				       unsigned int cpu)
>  {
> -	struct stop_machine_data smdata;
>  	struct task_struct *p;
>  
> +	down(&stopmachine_mutex);
>  	smdata.fn = fn;
>  	smdata.data = data;
> +	smdata.run_all = (cpu == RUN_ALL) ? 1 : 0;
>  	init_completion(&smdata.done);
> -
> -	down(&stopmachine_mutex);
> -
> +	smp_wmb();
>  	/* If they don't care which CPU fn runs on, bind to any online one. */
> -	if (cpu == NR_CPUS)
> +	if (cpu == NR_CPUS || cpu == RUN_ALL)
>  		cpu = raw_smp_processor_id();
>  
>  	p = kthread_create(do_stop, &smdata, "kstopmachine");
> 
> 
> 4)
> 
> 
> diff --git a/kernel/immediate.c b/kernel/immediate.c
> index 4c36a89..39ec13e 100644
> --- a/kernel/immediate.c
> +++ b/kernel/immediate.c
> @@ -20,6 +20,7 @@
>  #include <linux/immediate.h>
>  #include <linux/memory.h>
>  #include <linux/cpu.h>
> +#include <linux/stop_machine.h>
>  
>  #include <asm/cacheflush.h>
>  
> @@ -30,6 +31,23 @@ static int imv_early_boot_complete;
>  
>  extern const struct __imv __start___imv[];
>  extern const struct __imv __stop___imv[];
> +int started;
> +
> +int stop_machine_imv_update(void *imv_ptr)
> +{
> +	struct __imv *imv = imv_ptr;
> +
> +	if (!started) {
> +		text_poke((void *)imv->imv, (void *)imv->var, imv->size);
> +		started = 1;
> +		smp_wmb();

missing mb() comment here.

> +	} else
> +		sync_core();
> +

Note : we really want the sync_core()s to be executed after the
text_poke. This is ok given the implicit RUN_ALL semantic, but I guess
it should be documented in stop_machine that the first callback is
executed alone before all the others.

Thanks!

Mathieu

> +	flush_icache_range(imv->imv, imv->imv + imv->size);
> +
> +	return 0;
> +}
>  
>  /*
>   * imv_mutex nests inside module_mutex. imv_mutex protects builtin
> @@ -37,38 +55,6 @@ extern const struct __imv __stop___imv[];
>   */
>  static DEFINE_MUTEX(imv_mutex);
>  
> -static atomic_t wait_sync;
> -
> -struct ipi_loop_data {
> -	long value;
> -	const struct __imv *imv;
> -} loop_data;
> -
> -static void ipi_busy_loop(void *arg)
> -{
> -	unsigned long flags;
> -
> -	local_irq_save(flags);
> -	atomic_dec(&wait_sync);
> -	do {
> -		/* Make sure the wait_sync gets re-read */
> -		smp_mb();
> -	} while (atomic_read(&wait_sync) > loop_data.value);
> -	atomic_dec(&wait_sync);
> -	do {
> -		/* Make sure the wait_sync gets re-read */
> -		smp_mb();
> -	} while (atomic_read(&wait_sync) > 0);
> -	/*
> -	 * Issuing a synchronizing instruction must be done on each CPU before
> -	 * reenabling interrupts after modifying an instruction. Required by
> -	 * Intel's errata.
> -	 */
> -	sync_core();
> -	flush_icache_range(loop_data.imv->imv,
> -		loop_data.imv->imv + loop_data.imv->size);
> -	local_irq_restore(flags);
> -}
>  
>  /**
>   * apply_imv_update - update one immediate value
> @@ -82,9 +68,6 @@ static void ipi_busy_loop(void *arg)
>   */
>  static int apply_imv_update(const struct __imv *imv)
>  {
> -	unsigned long flags;
> -	long online_cpus;
> -
>  	/*
>  	 * If the variable and the instruction have the same value, there is
>  	 * nothing to do.
> @@ -111,30 +94,8 @@ static int apply_imv_update(const struct __imv *imv)
>  
>  	if (imv_early_boot_complete) {
>  		kernel_text_lock();
> -		get_online_cpus();
> -		online_cpus = num_online_cpus();
> -		atomic_set(&wait_sync, 2 * online_cpus);
> -		loop_data.value = online_cpus;
> -		loop_data.imv = imv;
> -		smp_call_function(ipi_busy_loop, NULL, 1, 0);
> -		local_irq_save(flags);
> -		atomic_dec(&wait_sync);
> -		do {
> -			/* Make sure the wait_sync gets re-read */
> -			smp_mb();
> -		} while (atomic_read(&wait_sync) > online_cpus);
> -		text_poke((void *)imv->imv, (void *)imv->var,
> -				imv->size);
> -		/*
> -		 * Make sure the modified instruction is seen by all CPUs before
> -		 * we continue (visible to other CPUs and local interrupts).
> -		 */
> -		wmb();
> -		atomic_dec(&wait_sync);
> -		flush_icache_range(imv->imv,
> -				imv->imv + imv->size);
> -		local_irq_restore(flags);
> -		put_online_cpus();
> +		started = 0;
> +		stop_machine_run(stop_machine_imv_update, (void *)imv, RUN_ALL);
>  		kernel_text_unlock();
>  	} else
>  		text_poke_early((void *)imv->imv, (void *)imv->var,

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
