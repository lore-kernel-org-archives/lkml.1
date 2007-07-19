Return-Path: <linux-kernel-owner+w=401wt.eu-S937921AbXGSQMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937921AbXGSQMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763372AbXGSQMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:12:18 -0400
Received: from gw.goop.org ([64.81.55.164]:53483 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761540AbXGSQMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:12:15 -0400
Message-ID: <469F8D28.1010304@goop.org>
Date: Thu, 19 Jul 2007 09:11:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>, Andi Kleen <ak@suse.de>
Subject: Re: [patch] sched: implement cpu_clock(cpu) high-speed time source,
 take #2
References: <20070719002231.069ebbdd.akpm@linux-foundation.org> <20070719075152.GB12760@elte.hu> <469F75AF.5080000@goop.org> <20070719143528.GA8278@elte.hu> <469F793E.6030006@goop.org> <20070719145058.GA11971@elte.hu> <469F7D7A.204@goop.org> <20070719150955.GA19373@elte.hu> <469F8179.2060802@goop.org> <20070719154254.GA24225@elte.hu> <20070719154449.GA28998@elte.hu>
In-Reply-To: <20070719154449.GA28998@elte.hu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>>> Hm, that doesn't look quite right.  Doesn't rq_clock measure time 
>>> spent running?  Unstolen time includes idle time too (it just 
>>> excludes time in which a VCPU is runnable but not actually running).
>>>       
>> generally rq_clock() also includes idle time, so it should work fine 
>> for this purpose. So, what do you think about the patch below - does 
>> it suit Xen's purposes?
>>     
>
> how about the patch below instead? (which, unlike the first one, happens 
> to build and boot ;-)
>   

Yes, that should be fine if its just based on sched_clock.  Presumably
that means that any  architecture (eg, s390) which chooses to implement
sched_clock as unstolen time will get good behaviour from softlockup as
well as the scheduler.

How does this interact with the sched_clock changes Andi just posted?

(Couple of comments below.)

> 	Ingo
>
> -------------->
> Subject: sched: implement cpu_clock(cpu) high-speed time source
> From: Ingo Molnar <mingo@elte.hu>
>
> Implement the cpu_clock(cpu) interface for kernel-internal use:
> high-speed (but slightly incorrect) per-cpu clock constructed from
> sched_clock().
>
> update blktrace and the softlockup-watchdog to use this new interface.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>   
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

> ---
>  block/blktrace.c      |   20 ++++++++++----------
>  include/linux/sched.h |    7 +++++++
>  kernel/sched.c        |   17 +++++++++++++++++
>  kernel/softlockup.c   |   10 ++++++----
>  4 files changed, 40 insertions(+), 14 deletions(-)
>
> Index: linux/block/blktrace.c
> ===================================================================
> --- linux.orig/block/blktrace.c
> +++ linux/block/blktrace.c
> @@ -41,7 +41,7 @@ static void trace_note(struct blk_trace 
>  		const int cpu = smp_processor_id();
>  
>  		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
> -		t->time = sched_clock() - per_cpu(blk_trace_cpu_offset, cpu);
> +		t->time = cpu_clock(cpu) - per_cpu(blk_trace_cpu_offset, cpu);
>  		t->device = bt->dev;
>  		t->action = action;
>  		t->pid = pid;
> @@ -159,7 +159,7 @@ void __blk_add_trace(struct blk_trace *b
>  
>  		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
>  		t->sequence = ++(*sequence);
> -		t->time = sched_clock() - per_cpu(blk_trace_cpu_offset, cpu);
> +		t->time = cpu_clock(cpu) - per_cpu(blk_trace_cpu_offset, cpu);
>   

What's this measuring here?  Time spend in IO?  Wouldn't it be better
off with a measurement of real monotonic time?

>  		t->sector = sector;
>  		t->bytes = bytes;
>  		t->action = what;
> @@ -488,17 +488,17 @@ void blk_trace_shutdown(request_queue_t 
>  }
>  
>  /*
> - * Average offset over two calls to sched_clock() with a gettimeofday()
> + * Average offset over two calls to cpu_clock() with a gettimeofday()
>   * in the middle
>   */
> -static void blk_check_time(unsigned long long *t)
> +static void blk_check_time(unsigned long long *t, int this_cpu)
>  {
>  	unsigned long long a, b;
>  	struct timeval tv;
>  
> -	a = sched_clock();
> +	a = cpu_clock(this_cpu);
>  	do_gettimeofday(&tv);
> -	b = sched_clock();
> +	b = cpu_clock(this_cpu);
>   

Is this measuring what it thinks its measuring?

>  	*t = tv.tv_sec * 1000000000 + tv.tv_usec * 1000;
>  	*t -= (a + b) / 2;
> @@ -510,16 +510,16 @@ static void blk_check_time(unsigned long
>  static void blk_trace_check_cpu_time(void *data)
>  {
>  	unsigned long long *t;
> -	int cpu = get_cpu();
> +	int this_cpu = get_cpu();
>  
> -	t = &per_cpu(blk_trace_cpu_offset, cpu);
> +	t = &per_cpu(blk_trace_cpu_offset, this_cpu);
>  
>  	/*
>  	 * Just call it twice, hopefully the second call will be cache hot
>  	 * and a little more precise
>  	 */
> -	blk_check_time(t);
> -	blk_check_time(t);
> +	blk_check_time(t, this_cpu);
> +	blk_check_time(t, this_cpu);
>  
>  	put_cpu();
>  }
> Index: linux/include/linux/sched.h
> ===================================================================
> --- linux.orig/include/linux/sched.h
> +++ linux/include/linux/sched.h
> @@ -1327,6 +1327,13 @@ static inline int set_cpus_allowed(struc
>  #endif
>  
>  extern unsigned long long sched_clock(void);
> +
> +/*
> + * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
> + * clock constructed from sched_clock():
> + */
> +extern unsigned long long cpu_clock(int cpu);
> +
>  extern unsigned long long
>  task_sched_runtime(struct task_struct *task);
>  
> Index: linux/kernel/sched.c
> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -379,6 +379,23 @@ static inline unsigned long long rq_cloc
>  #define task_rq(p)		cpu_rq(task_cpu(p))
>  #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
>  
> +/*
> + * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
> + * clock constructed from sched_clock():
> + */
> +unsigned long long cpu_clock(int cpu)
> +{
> +	struct rq *rq = cpu_rq(cpu);
> +	unsigned long long now;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&rq->lock, flags);
> +	now = rq_clock(rq);
> +	spin_unlock_irqrestore(&rq->lock, flags);
> +
> +	return now;
> +}
> +
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  /* Change a task's ->cfs_rq if it moves across CPUs */
>  static inline void set_task_cfs_rq(struct task_struct *p)
> Index: linux/kernel/softlockup.c
> ===================================================================
> --- linux.orig/kernel/softlockup.c
> +++ linux/kernel/softlockup.c
> @@ -41,14 +41,16 @@ static struct notifier_block panic_block
>   * resolution, and we don't need to waste time with a big divide when
>   * 2^30ns == 1.074s.
>   */
> -static unsigned long get_timestamp(void)
> +static unsigned long get_timestamp(int this_cpu)
>  {
> -	return sched_clock() >> 30;  /* 2^30 ~= 10^9 */
> +	return cpu_clock(this_cpu) >> 30;  /* 2^30 ~= 10^9 */
>  }
>  
>  void touch_softlockup_watchdog(void)
>  {
> -	__raw_get_cpu_var(touch_timestamp) = get_timestamp();
> +	int this_cpu = raw_smp_processor_id();
> +
> +	per_cpu(touch_timestamp, this_cpu) = get_timestamp(this_cpu);
>  }
>  EXPORT_SYMBOL(touch_softlockup_watchdog);
>  
> @@ -94,7 +96,7 @@ void softlockup_tick(void)
>  		return;
>  	}
>  
> -	now = get_timestamp();
> +	now = get_timestamp(this_cpu);
>  
>  	/* Wake up the high-prio watchdog task every second: */
>  	if (now > (touch_timestamp + 1))
>   

    J
