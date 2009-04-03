Return-Path: <linux-kernel-owner+w=401wt.eu-S935458AbZDCVyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935458AbZDCVyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 17:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbZDCVyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 17:54:45 -0400
Received: from www.tglx.de ([62.245.132.106]:54134 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbZDCVyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:54:45 -0400
Date: Fri, 3 Apr 2009 23:52:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v4 RFC PATCH 4/4] timers: logic to move non pinned timers
In-Reply-To: <20090401113738.GE22478@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.0904032142460.12916@localhost.localdomain>
References: <20090401113128.GA22478@linux.vnet.ibm.com> <20090401113738.GE22478@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun,

On Wed, 1 Apr 2009, Arun R Bharadwaj wrote:
> @@ -627,6 +628,12 @@ __mod_timer(struct timer_list *timer, un
>  
>  	new_base = __get_cpu_var(tvec_bases);
>  
> +	current_cpu = smp_processor_id();
> +	preferred_cpu = get_nohz_load_balancer();
> +	if (get_sysctl_timer_migration() && idle_cpu(current_cpu)
> +			&& !pinned && preferred_cpu != -1)

Can we please check the preliminaries first to avoid the atomic_read ?

    cpu = smp_processor_id();
    if (!pinned && idle_cpu() && get_sysctl_timer_migration()) {
       newcpu = get_nohz_load_balancer();
       if (newcpu >= 0)
       	  cpu = newcpu;   
    }

    new_base = per_cpu(tvec_bases, cpu);

> +		new_base = per_cpu(tvec_bases, preferred_cpu);
> +
>  	if (base != new_base) {
>  		/*
>  		 * We are trying to schedule the timer on the local CPU.
> @@ -635,7 +642,8 @@ __mod_timer(struct timer_list *timer, un
>  		 * handler yet has not finished. This also guarantees that
>  		 * the timer is serialized wrt itself.
>  		 */
> -		if (likely(base->running_timer != timer)) {
> +		if (likely(base->running_timer != timer) ||
> +				get_sysctl_timer_migration()) {

  No, that's wrong. We can not migrate a running timer ever.

>  			/* See the comment in lock_timer_base() */
>  			timer_set_base(timer, NULL);
>  			spin_unlock(&base->lock);
> @@ -1063,10 +1071,9 @@ cascade:
>   * Check, if the next hrtimer event is before the next timer wheel
>   * event:
>   */
> -static unsigned long cmp_next_hrtimer_event(unsigned long now,
> -					    unsigned long expires)
> +static unsigned long __cmp_next_hrtimer_event(unsigned long now,
> +			unsigned long expires, ktime_t hr_delta)
>  {
> -	ktime_t hr_delta = hrtimer_get_next_event();
>  	struct timespec tsdelta;
>  	unsigned long delta;
>  
> @@ -1103,24 +1110,59 @@ static unsigned long cmp_next_hrtimer_ev
>  	return expires;
>  }
>  
> +static unsigned long cmp_next_hrtimer_event(unsigned long now,
> +					unsigned long expires)
> +{
> +	 ktime_t hr_delta = hrtimer_get_next_event();
> +	 return __cmp_next_hrtimer_event(now, expires, hr_delta);
> +}
> +
> +static unsigned long cmp_next_hrtimer_event_on(unsigned long now,
> +					unsigned long expires, int cpu)
> +{
> +	 ktime_t hr_delta = hrtimer_get_next_event_on(cpu);
> +	 return __cmp_next_hrtimer_event(now, expires, hr_delta);
> +}
> +
> +unsigned long __get_next_timer_interrupt(unsigned long now, int cpu)
> +{
> +	struct tvec_base *base = per_cpu(tvec_bases, cpu);
> +	unsigned long expires;
> +
> +	spin_lock(&base->lock);
> +	expires = __next_timer_interrupt(base);
> +	spin_unlock(&base->lock);
> +	return expires;
> +}
> +
>  /**
>   * get_next_timer_interrupt - return the jiffy of the next pending timer
>   * @now: current time (in jiffies)
>   */
>  unsigned long get_next_timer_interrupt(unsigned long now)
>  {
> -	struct tvec_base *base = __get_cpu_var(tvec_bases);
>  	unsigned long expires;
> +	int cpu = smp_processor_id();
>  
> -	spin_lock(&base->lock);
> -	expires = __next_timer_interrupt(base);
> -	spin_unlock(&base->lock);
> +	expires = __get_next_timer_interrupt(now, cpu);
>  
>  	if (time_before_eq(expires, now))
>  		return now;
>  
>  	return cmp_next_hrtimer_event(now, expires);
>  }
> +
> +unsigned long get_next_timer_interrupt_on(unsigned long now, int cpu)
> +{
> +	unsigned long expires;
> +
> +	expires = __get_next_timer_interrupt(now, cpu);
> +
> +	if (time_before_eq(expires, now))
> +		return now;
> +
> +	return cmp_next_hrtimer_event_on(now, expires, cpu);
> +}
>  #endif

   What's the purpose of all those changes ? Just for the latency check ?
   See below.
  
>  /*
> Index: linux.trees.git/kernel/hrtimer.c
> ===================================================================
> --- linux.trees.git.orig/kernel/hrtimer.c
> +++ linux.trees.git/kernel/hrtimer.c
> @@ -43,6 +43,8 @@
>  #include <linux/seq_file.h>
>  #include <linux/err.h>
>  #include <linux/debugobjects.h>
> +#include <linux/sched.h>
> +#include <linux/timer.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -198,8 +200,16 @@ switch_hrtimer_base(struct hrtimer *time
>  {
>  	struct hrtimer_clock_base *new_base;
>  	struct hrtimer_cpu_base *new_cpu_base;
> +	int current_cpu, preferred_cpu;
> +
> +	current_cpu = smp_processor_id();
> +	preferred_cpu = get_nohz_load_balancer();
> +	if (get_sysctl_timer_migration() && !pinned && preferred_cpu != -1 &&
> +			check_hrtimer_latency(timer, preferred_cpu))

  Comments from timer.c __mod_timer() apply here as well.

  You have a cpu_idle check in timer.c, why not here ?

  This check_hrtimer_latency business is ugly and I think we should
  try to solve this different.

...
  int cpu, tocpu = -1;

  cpu = smp_processor_id();
  if (preliminaries_for_migration) {
     tocpu = get_nohz_load_balancer();
     if (tocpu >= 0)
     	cpu = tocpu;
  }

again:
  new_cpu_base = &per_cpu(hrtimer_bases, cpu);
  new_base = &new_cpu_base->clock_base[base->index];

  if (base != new_base) {

     if (unlikely(hrtimer_callback_running(timer)))
     	return base;

     timer->base = NULL;
     spin_unlock(&base->cpu_base->lock);
     spin_lock(&new_base->cpu_base->lock);
     timer->base = new_base;

     if (cpu == tocpu) {
     	/* Calc clock monotonic expiry time */  	
        ktime_t expires = ktime_sub(hrtimer_get_expires(timer), new_base->offset);

	/*
	 * Get the next event on the target cpu from the clock events layer. This
	 * covers the highres=off nohz=on case as well.
	 */
	ktime_t next = clockevents_get_next_event(cpu);

	ktime_t delta = ktime_sub(expires, next);

	/*
	 * We do not migrate the timer when it is expiring before the next
	 * event on the target cpu because we can not reprogram the target
	 * cpu timer hardware and we would cause it to fire late.
	 */
	if (delta.tv64 < 0) {
	   cpu = smp_processor_id();
	   goto again;
     	}
	
	/*
	 * We might add a check here which does not migrate the timer
     	 * when it's expiry is very close, but that needs to be evaluated
	 * if it's really a problem. Again we can ask the clock events layer
         * here when the next tick timer is due and compare against it to
         * avoid an extra ktime_get() call.
	 * Probably it's not a problem as a possible wakeup of some task will
	 * push that task anyway to the preferred cpu, but we'll see.
         */
     } 
   }

That way we avoid the whole poking in the timer wheel and adding /
modifying functions all over the place for no real value.

The information we are looking for is already there.

Thanks,

	tglx
