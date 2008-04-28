Return-Path: <linux-kernel-owner+w=401wt.eu-S933812AbYD1MBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812AbYD1MBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765067AbYD1MBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:01:02 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:57608 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933840AbYD1MBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:01:00 -0400
Date: Mon, 28 Apr 2008 17:27:00 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: get_online_cpus() && workqueues
Message-ID: <20080428115700.GC23162@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080422123304.GA777@osiris.boeblingen.de.ibm.com> <1208868236.7115.249.camel@twins> <20080423035802.GA8895@in.ibm.com> <20080424150714.GA8273@osiris.boeblingen.de.ibm.com> <1209052984.7115.369.camel@twins> <20080424155946.GA11160@tv-sign.ru> <20080424194810.GA4821@osiris.boeblingen.de.ibm.com> <20080424192706.GA165@tv-sign.ru> <20080425064044.GA10817@osiris.boeblingen.de.ibm.com> <20080426144330.GA6150@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426144330.GA6150@tv-sign.ru>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 06:43:30PM +0400, Oleg Nesterov wrote:
> Gautham, Srivatsa, seriously, can't we uglify cpu.c a little bit to solve
> the problem. Please see the illustration patch below. It looks complicated,
> but in fact it is quite trivial.
> 
> In short: work_struct can't use get_online_cpus() due to deadlock with the
> CPU_DEAD phase.
> 
> Can't we add another nested lock which is dropped right after __cpu_die()?
> (in fact I think it could be dropped after __stop_machine_run).
> 
> The new read-lock is get_online_map() (just a random name for now). The only
> difference wrt get_online_cpus() is that it doesn't protect against CPU_DEAD,
> but most users of get_online_cpus() doesn't need this, they only need a
> stable cpu_online_map and sometimes they need to be sure that some per-cpu
> object (say, cpu_workqueue_struct->thread) can't be destroyed under this
> lock.
> 
> get_online_map() seem to fit for this, and can be used from work->func().
> (actually, I think most users of use get_online_cpus() could use the new
> helper instead, but this doen't matter).
> 
> Heiko, what do you think? Is it suitable for arch_reinit_sched_domains()?
> 
> Oleg.
> 
> --- 25/kernel/cpu.c~HP_LOCK	2008-02-16 18:36:37.000000000 +0300
> +++ 25/kernel/cpu.c	2008-04-26 18:14:25.000000000 +0400
> @@ -25,7 +25,7 @@ static __cpuinitdata RAW_NOTIFIER_HEAD(c
>   */
>  static int cpu_hotplug_disabled;
> 
> -static struct {
> +static struct cpu_lock {
>  	struct task_struct *active_writer;
>  	struct mutex lock; /* Synchronizes accesses to refcount, */
>  	/*
> @@ -33,41 +33,65 @@ static struct {
>  	 * an ongoing cpu hotplug operation.
>  	 */
>  	int refcount;
> -} cpu_hotplug;
> +} cpu_hotplug, online_map;
> +
> +static inline void __cpu_hotplug_init(struct cpu_lock *cpu_lock)
> +{
> +	cpu_lock->active_writer = NULL;
> +	mutex_init(&cpu_lock->lock);
> +	cpu_lock->refcount = 0;
> +}
> 
>  void __init cpu_hotplug_init(void)
>  {
> -	cpu_hotplug.active_writer = NULL;
> -	mutex_init(&cpu_hotplug.lock);
> -	cpu_hotplug.refcount = 0;
> +	__cpu_hotplug_init(&cpu_hotplug);
> +	__cpu_hotplug_init(&online_map);
>  }
> 
>  #ifdef CONFIG_HOTPLUG_CPU
> 
> -void get_online_cpus(void)
> +void cpu_read_lock(struct cpu_lock *cpu_lock)
>  {
>  	might_sleep();
> -	if (cpu_hotplug.active_writer == current)
> +	if (cpu_lock->active_writer == current)
>  		return;
> -	mutex_lock(&cpu_hotplug.lock);
> -	cpu_hotplug.refcount++;
> -	mutex_unlock(&cpu_hotplug.lock);
> +	mutex_lock(&cpu_lock->lock);
> +	cpu_lock->refcount++;
> +	mutex_unlock(&cpu_lock->lock);
> +}
> 
> +void get_online_cpus(void)
> +{
> +	cpu_read_lock(&cpu_hotplug);
>  }
>  EXPORT_SYMBOL_GPL(get_online_cpus);
> 
> -void put_online_cpus(void)
> +void get_online_map(void)
>  {
> -	if (cpu_hotplug.active_writer == current)
> +	cpu_read_lock(&online_map);
> +}
> +
> +void cpu_read_unlock(struct cpu_lock *cpu_lock)
> +{
> +	if (cpu_lock->active_writer == current)
>  		return;
> -	mutex_lock(&cpu_hotplug.lock);
> -	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
> -		wake_up_process(cpu_hotplug.active_writer);
> -	mutex_unlock(&cpu_hotplug.lock);
> +	mutex_lock(&cpu_lock->lock);
> +	if (!--cpu_lock->refcount && unlikely(cpu_lock->active_writer))
> +		wake_up_process(cpu_lock->active_writer);
> +	mutex_unlock(&cpu_lock->lock);
> +}
> 
> +void put_online_cpus(void)
> +{
> +	cpu_read_unlock(&cpu_hotplug);
>  }
>  EXPORT_SYMBOL_GPL(put_online_cpus);
> 
> +void put_online_map(void)
> +{
> +	cpu_read_unlock(&online_map);
> +}
> +
>  #endif	/* CONFIG_HOTPLUG_CPU */
> 
>  /*
> @@ -91,7 +115,7 @@ void cpu_maps_update_done(void)
>   * Note that during a cpu-hotplug operation, the new readers, if any,
>   * will be blocked by the cpu_hotplug.lock
>   *
> - * Since cpu_hotplug_begin() is always called after invoking
> + * Since cpu_write_lock() is always called after invoking
>   * cpu_maps_update_begin(), we can be sure that only one writer is active.
>   *
>   * Note that theoretically, there is a possibility of a livelock:
> @@ -106,25 +130,26 @@ void cpu_maps_update_done(void)
>   * get_online_cpus() not an api which is called all that often.
>   *
>   */
> -static void cpu_hotplug_begin(void)
> +static void cpu_write_lock(struct cpu_lock *cpu_lock)
>  {
> -	cpu_hotplug.active_writer = current;
> +	cpu_lock->active_writer = current;
> 
>  	for (;;) {
> -		mutex_lock(&cpu_hotplug.lock);
> -		if (likely(!cpu_hotplug.refcount))
> +		mutex_lock(&cpu_lock->lock);
> +		if (likely(!cpu_lock->refcount))
>  			break;
>  		__set_current_state(TASK_UNINTERRUPTIBLE);
> -		mutex_unlock(&cpu_hotplug.lock);
> +		mutex_unlock(&cpu_lock->lock);
>  		schedule();
>  	}
>  }
> 
> -static void cpu_hotplug_done(void)
> +static void cpu_write_unlock(struct cpu_lock *cpu_lock)
>  {
> -	cpu_hotplug.active_writer = NULL;
> -	mutex_unlock(&cpu_hotplug.lock);
> +	cpu_lock->active_writer = NULL;
> +	mutex_unlock(&cpu_lock->lock);
>  }
> +
>  /* Need to know about CPUs going up/down? */
>  int __cpuinit register_cpu_notifier(struct notifier_block *nb)
>  {
> @@ -207,7 +232,8 @@ static int _cpu_down(unsigned int cpu, i
>  	if (!cpu_online(cpu))
>  		return -EINVAL;
> 
> -	cpu_hotplug_begin();
> +	cpu_write_lock(&cpu_hotplug);
> +	cpu_write_lock(&online_map);

IMO, we should acquire the cpu_write_lock(&online_map)
just before __stop_machine_run() and release it once
stop_machine_run() returns.

IIUC, this lock protects only the cpu_online_map.

Ditto in case of cpu_up() where we should acquire the lock
just before calling __cpu_up() and release it immediately thereafter.


>  	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
>  					hcpu, -1, &nr_calls);
>  	if (err == NOTIFY_BAD) {
> @@ -238,6 +264,7 @@ static int _cpu_down(unsigned int cpu, i
>  			err = PTR_ERR(p);
>  			goto out_allowed;
>  		}
> +		err = -EAGAIN;
>  		goto out_thread;
>  	}
> 
> @@ -247,6 +274,7 @@ static int _cpu_down(unsigned int cpu, i
> 
>  	/* This actually kills the CPU. */
>  	__cpu_die(cpu);
> +	cpu_write_unlock(&online_map);
> 
>  	/* CPU is completely dead: tell everyone.  Too late to complain. */
>  	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD | mod,
> @@ -260,7 +288,9 @@ out_thread:
>  out_allowed:
>  	set_cpus_allowed(current, old_allowed);
>  out_release:
> -	cpu_hotplug_done();
> +	if (err)
> +		cpu_write_unlock(&online_map);
> +	cpu_write_unlock(&cpu_hotplug);
>  	return err;
>  }
> 
> @@ -289,7 +319,8 @@ static int __cpuinit _cpu_up(unsigned in
>  	if (cpu_online(cpu) || !cpu_present(cpu))
>  		return -EINVAL;
> 
> -	cpu_hotplug_begin();
> +	cpu_write_lock(&cpu_hotplug);
> +	cpu_write_lock(&online_map);
>  	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, hcpu,
>  							-1, &nr_calls);
>  	if (ret == NOTIFY_BAD) {
> @@ -313,7 +344,8 @@ out_notify:
>  	if (ret != 0)
>  		__raw_notifier_call_chain(&cpu_chain,
>  				CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
> -	cpu_hotplug_done();
> +	cpu_write_unlock(&online_map);
> +	cpu_write_unlock(&cpu_hotplug);
> 
>  	return ret;
>  }

-- 
Thanks and Regards
gautham
