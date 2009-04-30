Return-Path: <linux-kernel-owner+w=401wt.eu-S1762719AbZD3VXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762719AbZD3VXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 17:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbZD3VXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 17:23:05 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:47826 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332AbZD3VXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 17:23:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlkGALet+UlMQW1W/2dsb2JhbACBUM8wg38F
Date: Thu, 30 Apr 2009 17:17:50 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Christoph Lameter <cl@linux.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090430211750.GA19933@Krystal>
References: <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <20090430062140.GA9559@elte.hu> <20090430063306.GA27431@Krystal> <20090430065055.GA16277@elte.hu> <alpine.DEB.1.10.0904300926530.22262@qirst.com> <20090430141211.GB5922@Krystal> <alpine.DEB.1.10.0904301009530.14178@qirst.com> <20090430194158.GB12926@Krystal> <alpine.DEB.1.10.0904301559500.11923@qirst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904301559500.11923@qirst.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:34:00 up 61 days, 17:00,  4 users,  load average: 0.04, 0.32,
	0.42
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> On Thu, 30 Apr 2009, Mathieu Desnoyers wrote:
> 
> > On architectures with irq-safe percpu_add :
> > - No need to disable interrupts at all
> 
> They may have other options like fall back to classic atomic ops.
> 
> > Let's assume we change the stat_threshold values in mm/vmstat.c so they
> > become power of 2 (so we don't care when the u8 overflow occurs so it
> > becomes a free running counter). This model does not support
> > "overstep" (yet).
> 
> The problem with such an approach is that the counters may wrap if
> sufficiently many processors are in a ZVC update.

By ZVC update, you mean Zone ... Counter update ? (which code exactly ?)

>  Lets say a new interrupt
> is occuring while irq is held off that increments the same counter. When
> interrupts are reenabled, we increment again from the new interrupt.
> We then check for overflow only after the new interrupt that modified the
> counter has completed. The differentials must be constant while the ZVC
> update functions are running and with your modifications that is no longer
> guaranteed.
> 

Hrm, I must admit I'm not sure I follow how your reasoning applies to my
code. I am using a percpu_add_return_irq() exactly for this reason : it
only ever touches the percpu variable once and atomically. The test for
overflow is done on the value returned by percpu_add_return_irq().

Therefore, an interrupt scenario that would be close to what I
understand from your concerns would be :

* Thread A

inc_zone_page_state()
  p_ret = percpu_add_return(p, 1); (let's suppose this increment
                                    overflows the threshold, therefore
                                    (p_ret & mask) == 0)

----> interrupt comes in, preempts the current thread, execution in a
      different thread context (* Thread B) :

     inc_zone_page_state()
       p_ret = percpu_add_return(p, 1);  ((p_ret & mask) == 1)
       if (!(p_ret & mask))
         increment global zone count. (not executed)

----> interrupt comes in, preempts the current thread, execution back to
      the original thread context (Thread A), on the same or on a
      different CPU :

  if (!(p_ret & mask))
    increment global zone count.   -----> will therefore increment the
                                          global zone count only after
                                          scheduling back the original
                                          thread.

So I guess what you say here is that if Thread B is preempted for too
long, we will have to wait until it gets scheduled back before the
global count is incremented. Do we really need such degree of precision
for those counters ?

(I fear I'm not understanding your concern fully though)

> > Note that all the fast-path would execute with preemption enabled if the
> > architecture supports irqsave percpu atomic ops.
> 
> What would work is to use a percpu cmpxchg for the ZVC updates.
> I wrote a patch like that over a year ago. There is no percpu_cmpxchg
> coming with the percpu ops as of today so we'd need to add that first.
> 
> Not sure if this is a performance win though. Complexity increases
> somewhat.
> 

hrm, yes, the patch below clearly does not win the low-complexity
contest. :)

Mathieu

> ---
>  include/linux/vmstat.h |   17 ++++--
>  mm/vmstat.c            |  122 ++++++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 127 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/include/linux/vmstat.h
> ===================================================================
> --- linux-2.6.orig/include/linux/vmstat.h	2007-11-07 18:36:03.000000000 -0800
> +++ linux-2.6/include/linux/vmstat.h	2007-11-07 18:38:27.000000000 -0800
> @@ -202,15 +202,22 @@ extern void inc_zone_state(struct zone *
>  void __mod_zone_page_state(struct zone *, enum zone_stat_item item, int);
>  void __inc_zone_page_state(struct page *, enum zone_stat_item);
>  void __dec_zone_page_state(struct page *, enum zone_stat_item);
> +void __inc_zone_state(struct zone *, enum zone_stat_item);
> +void __dec_zone_state(struct zone *, enum zone_stat_item);
> 
> +#ifdef CONFIG_FAST_CMPXCHG_LOCAL
> +#define inc_zone_page_state __inc_zone_page_state
> +#define dec_zone_page_state __dec_zone_page_state
> +#define mod_zone_page_state __mod_zone_page_state
> +#define inc_zone_state __inc_zone_state
> +#define dec_zone_state __dec_zone_state
> +#else
>  void mod_zone_page_state(struct zone *, enum zone_stat_item, int);
>  void inc_zone_page_state(struct page *, enum zone_stat_item);
>  void dec_zone_page_state(struct page *, enum zone_stat_item);
> -
> -extern void inc_zone_state(struct zone *, enum zone_stat_item);
> -extern void __inc_zone_state(struct zone *, enum zone_stat_item);
> -extern void dec_zone_state(struct zone *, enum zone_stat_item);
> -extern void __dec_zone_state(struct zone *, enum zone_stat_item);
> +void inc_zone_state(struct zone *, enum zone_stat_item);
> +void dec_zone_state(struct zone *, enum zone_stat_item);
> +#endif
> 
>  void refresh_cpu_vm_stats(int);
>  #else /* CONFIG_SMP */
> Index: linux-2.6/mm/vmstat.c
> ===================================================================
> --- linux-2.6.orig/mm/vmstat.c	2007-11-07 17:20:16.000000000 -0800
> +++ linux-2.6/mm/vmstat.c	2007-11-07 18:55:57.000000000 -0800
> @@ -151,8 +151,109 @@ static void refresh_zone_stat_thresholds
>  	}
>  }
> 
> +#ifdef CONFIG_FAST_CMPXCHG_LOCAL
> +void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
> +				int delta)
> +{
> +	struct per_cpu_pageset *pcp = zone_pcp(zone, smp_processor_id());
> +	s8 *p = pcp->vm_stat_diff + item;
> +	s8 old;
> +	unsigned long new;
> +	unsigned long add;
> +
> +	do {
> +		add = 0;
> +		old = *p;
> +		new = old + delta;
> +
> +		if (unlikely(new > pcp->stat_threshold ||
> +				new < -pcp->stat_threshold)) {
> +			add = new;
> +			new = 0;
> +		}
> +
> +	} while (cmpxchg_local(p, old, new) != old);
> +
> +	if (add)
> +		zone_page_state_add(add, zone, item);
> +}
> +EXPORT_SYMBOL(__mod_zone_page_state);
> +
> +/*
> + * Optimized increment and decrement functions implemented using
> + * cmpxchg_local. These do not require interrupts to be disabled
> + * and enabled.
> + */
> +void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
> +{
> +	struct per_cpu_pageset *pcp = zone_pcp(zone, smp_processor_id());
> +	s8 *p = pcp->vm_stat_diff + item;
> +	int add;
> +	unsigned long old;
> +	unsigned long new;
> +
> +	do {
> +		add = 0;
> +		old = *p;
> +		new = old + 1;
> +
> +		if (unlikely(new > pcp->stat_threshold)) {
> +			add = new + pcp->stat_threshold / 2;
> +			new = -(pcp->stat_threshold / 2);
> +		}
> +	} while (cmpxchg_local(p, old, new) != old);
> +
> +	if (add)
> +		zone_page_state_add(add, zone, item);
> +}
> +
> +void __inc_zone_page_state(struct page *page, enum zone_stat_item item)
> +{
> +	__inc_zone_state(page_zone(page), item);
> +}
> +EXPORT_SYMBOL(__inc_zone_page_state);
> +
> +void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
> +{
> +	struct per_cpu_pageset *pcp = zone_pcp(zone, smp_processor_id());
> +	s8 *p = pcp->vm_stat_diff + item;
> +	int sub;
> +	unsigned long old;
> +	unsigned long new;
> +
> +	do {
> +		sub = 0;
> +		old = *p;
> +		new = old - 1;
> +
> +		if (unlikely(new < - pcp->stat_threshold)) {
> +			sub = new - pcp->stat_threshold / 2;
> +			new = pcp->stat_threshold / 2;
> +		}
> +	} while (cmpxchg_local(p, old, new) != old);
> +
> +	if (sub)
> +		zone_page_state_add(sub, zone, item);
> +}
> +
> +void __dec_zone_page_state(struct page *page, enum zone_stat_item item)
> +{
> +	__dec_zone_state(page_zone(page), item);
> +}
> +EXPORT_SYMBOL(__dec_zone_page_state);
> +
> +static inline void sync_diff(struct zone *zone, struct per_cpu_pageset *p, int i)
> +{
> +	/*
> +	 * xchg_local() would be useful here but that does not exist.
> +	 */
> +	zone_page_state_add(xchg(&p->vm_stat_diff[i], 0), zone, i);
> +}
> +
> +#else /* CONFIG_FAST_CMPXCHG_LOCAL */
> +
>  /*
> - * For use when we know that interrupts are disabled.
> + * Functions that do not rely on cmpxchg_local
>   */
>  void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
>  				int delta)
> @@ -281,6 +382,17 @@ void dec_zone_page_state(struct page *pa
>  }
>  EXPORT_SYMBOL(dec_zone_page_state);
> 
> +static inline void sync_diff(struct zone *zone, struct per_cpu_pageset *p, int i)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	zone_page_state_add(p->vm_stat_diff[i], zone, i);
> +	p->vm_stat_diff[i] = 0;
> +	local_irq_restore(flags);
> +}
> +#endif /* !CONFIG_FAST_CMPXCHG_LOCAL */
> +
>  /*
>   * Update the zone counters for one cpu.
>   *
> @@ -299,7 +411,6 @@ void refresh_cpu_vm_stats(int cpu)
>  {
>  	struct zone *zone;
>  	int i;
> -	unsigned long flags;
> 
>  	for_each_zone(zone) {
>  		struct per_cpu_pageset *p;
> @@ -311,15 +422,12 @@ void refresh_cpu_vm_stats(int cpu)
> 
>  		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
>  			if (p->vm_stat_diff[i]) {
> -				local_irq_save(flags);
> -				zone_page_state_add(p->vm_stat_diff[i],
> -					zone, i);
> -				p->vm_stat_diff[i] = 0;
> +				sync_diff(zone, p, i);
> +
>  #ifdef CONFIG_NUMA
>  				/* 3 seconds idle till flush */
>  				p->expire = 3;
>  #endif
> -				local_irq_restore(flags);
>  			}
>  #ifdef CONFIG_NUMA
>  		/*
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
