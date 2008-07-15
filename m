Return-Path: <linux-kernel-owner+w=401wt.eu-S932321AbYGOBMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbYGOBMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 21:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbYGOBMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 21:12:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39562 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbYGOBMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 21:12:12 -0400
Message-ID: <487BF946.1050006@jp.fujitsu.com>
Date: Tue, 15 Jul 2008 10:11:34 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout
References: <487B05CE.1050508@jp.fujitsu.com> <200807142043.56968.rusty@rustcorp.com.au>
In-Reply-To: <200807142043.56968.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Rusty Russell wrote:
> I took your version and modified it slightly.  What do you think?

I have some comments, inlined.

> (BTW, the "warning: passing argument 1 of 'kthread_create' from incompatible
> pointer type" is caused by a kernel without the typesafe patches: this will
> be fixed soon, do I've removed your fix for that).
> 
> Thanks,
> Rusty.
> 
> ===
> stopmachine: add stopmachine_timeout
> 
> This patch is based on Hidetoshi Seto's patch to make stop_machine()
> more robust in the face of wedged CPUs.
> 
> This version does not fail unless the stuck CPU is one we wanted to do
> something on, and does not fail all future stop_machines.

We must protect next stop_machine from threads spawned by previous one.
I like your idea that if we did not want to do something on the stuck CPU
then treat the CPU as stopped.  However we need to be careful that the
stuck CPU can restart unexpectedly.

> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  kernel/stop_machine.c |   52 +++++++++++++++++++++++++++++++++++++++++++++---
>  kernel/sysctl.c       |   15 ++++++++++++++
>  2 files changed, 63 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -35,10 +35,14 @@ struct stop_machine_data {
>  };
>  
>  /* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
> -static unsigned int num_threads;
> +static unsigned num_threads;
>  static atomic_t thread_ack;
> +static cpumask_t prepared_cpus;
>  static struct completion finished;
>  static DEFINE_MUTEX(lock);
> +
> +static unsigned long limit;
> +unsigned long stopmachine_timeout = 5; /* secs, arbitrary */
>  
>  static void set_state(enum stopmachine_state newstate)
>  {
> @@ -66,6 +70,10 @@ static int stop_cpu(struct stop_machine_
>  {
>  	enum stopmachine_state curstate = STOPMACHINE_NONE;
>  	int uninitialized_var(ret);
> +
> +	/* If we've been shoved off the normal CPU, abort. */
> +	if (cpu_test_and_set(smp_processor_id(), prepared_cpus))
> +		do_exit(0);
>  
>  	/* Simple state machine */
>  	do {
> @@ -100,6 +108,44 @@ static int chill(void *unused)
>  	return 0;
>  }
>  
> +static bool fixup_timeout(struct task_struct **threads, const cpumask_t *cpus)
> +{
> +	unsigned int i;
> +	bool stagger_onwards = true;
> +
> +	printk(KERN_CRIT "stopmachine: Failed to stop machine in time(%lds).\n",
> +			stopmachine_timeout);
> +
> +	for_each_online_cpu(i) {
> +		if (!cpu_isset(i, prepared_cpus) && i != smp_processor_id()) {
> +			bool ignore;
> +

Note that here is a window that a not-prepared frozen cpu can be thawed and
become be prepared.

> +			/* If we wanted to run on a particular CPU, and that's
> +			 * the one which is stuck, it's a real failure. */
> +			ignore = !cpus || !cpu_isset(i, *cpus);
> +			printk(KERN_CRIT "stopmachine: cpu#%d seems to be "
> +			       "stuck, %s.\n",
> +			       i, ignore ? "ignoring" : "FAILING");
> +			/* Unbind thread: it will exit when it sees
> +			 * that prepared_cpus bit set. */
> +			set_cpus_allowed(threads[i], cpu_online_map);

Unbinded threads still can wake up on a cpu where they originally targeted.

> +			if (!ignore)
> +				stagger_onwards = false;
> +
> +			/* Pretend this one doesn't exist. */
> +			num_threads--;
> +		}
> +	}
> +
> +	if (stagger_onwards) {
> +		/* Force progress. */
> +		set_state(state + 1);

So num_threads have decremented, but it can happen that there are more threads.

> +	}
> +
> +	return stagger_onwards;
> +}
> +
>  int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
>  {
>  	int i, err;
> @@ -121,6 +167,7 @@ int __stop_machine(int (*fn)(void *), vo
>  	mutex_lock(&lock);
>  	init_completion(&finished);
>  	num_threads = num_online_cpus();
> +	limit = jiffies + msecs_to_jiffies(stopmachine_timeout * MSEC_PER_SEC);
>  	set_state(STOPMACHINE_PREPARE);
>  
>  	for_each_online_cpu(i) {
> @@ -152,9 +199,23 @@ int __stop_machine(int (*fn)(void *), vo
>  
>  	/* We've created all the threads.  Wake them all: hold this CPU so one
>  	 * doesn't hit this CPU until we're ready. */
> +	cpus_clear(prepared_cpus);
>  	get_cpu();
>  	for_each_online_cpu(i)
>  		wake_up_process(threads[i]);
> +
> +	/* Wait all others come to life */
> +	while (cpus_weight(prepared_cpus) != num_online_cpus() - 1) {
> +		if (time_is_before_jiffies(limit)) {
> +			if (!fixup_timeout(threads, cpus)) {
> +				/* Tell them all to exit. */
> +				set_state(STOPMACHINE_EXIT);
> +				active.fnret = -EIO;
> +			}
> +			break;
> +		}
> +		cpu_relax();
> +	}
>  
>  	/* This will release the thread on our CPU. */
>  	put_cpu();
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -144,6 +144,10 @@ extern int no_unaligned_warning;
>  
>  #ifdef CONFIG_RT_MUTEXES
>  extern int max_lock_depth;
> +#endif
> +
> +#ifdef CONFIG_STOP_MACHINE
> +extern unsigned long stopmachine_timeout;
>  #endif
>  
>  #ifdef CONFIG_PROC_SYSCTL
> @@ -811,6 +815,17 @@ static struct ctl_table kern_table[] = {
>  		.procname	= "keys",
>  		.mode		= 0555,
>  		.child		= key_sysctls,
> +	},
> +#endif
> +#ifdef CONFIG_STOP_MACHINE
> +	{
> +		.ctl_name       = CTL_UNNUMBERED,
> +		.procname       = "stopmachine_timeout",
> +		.data           = &stopmachine_timeout,
> +		.maxlen         = sizeof(unsigned long),
> +		.mode           = 0644,
> +		.proc_handler   = &proc_doulongvec_minmax,
> +		.strategy       = &sysctl_intvec,
>  	},
>  #endif
>  /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
