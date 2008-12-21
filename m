Return-Path: <linux-kernel-owner+w=401wt.eu-S1752012AbYLUSOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbYLUSOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 13:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbYLUSOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 13:14:08 -0500
Received: from www.tglx.de ([62.245.132.106]:54523 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbYLUSOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 13:14:06 -0500
Date: Sun, 21 Dec 2008 19:13:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v5] SGI RTC: add clocksource driver
In-Reply-To: <20081219161101.GB18226@sgi.com>
Message-ID: <alpine.LFD.2.00.0812211753030.3376@localhost.localdomain>
References: <20081219160751.GA18071@sgi.com> <20081219160919.GA18226@sgi.com> <20081219161101.GB18226@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008, Dimitri Sivanich wrote:
> +
> +int cpu_to_pnode(int cpu)
> +{
> +	return uv_apicid_to_pnode(per_cpu(x86_cpu_to_apicid, cpu));
> +}

static please 

> +/*
> + * Hardware interface routines
> + */
> +
> +/* Send IPIs to another node */
> +static void
> +uv_rtc_send_IPI(int cpu, int vector)

One line, except the line exceeds 80 chars. All over the place.

> +{
> +	unsigned long val, apicid, lapicid;
> +	int pnode;
> +
> +	apicid = per_cpu(x86_cpu_to_apicid, cpu);
> +	lapicid = apicid & 0x3f;
> +	pnode = uv_apicid_to_pnode(apicid);
> +
> +	val = (1UL << UVH_IPI_INT_SEND_SHFT) | (lapicid <<
> +						UVH_IPI_INT_APIC_ID_SHFT) |
> +		(vector << UVH_IPI_INT_VECTOR_SHFT);

  This is horrible to read.

+	val = (1UL << UVH_IPI_INT_SEND_SHFT) | 
+ 		(lapicid << UVH_IPI_INT_APIC_ID_SHFT) |
+		(vector << UVH_IPI_INT_VECTOR_SHFT);

Takes the same amount of lines, but is parseable.

> +	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
> +}
> +
> +/* Check for an RTC interrupt pending */
> +static int
> +uv_intr_pending(int pnode)
> +{
> +	if (uv_read_global_mmr64(pnode, UVH_EVENT_OCCURRED0) &
> +			UVH_EVENT_OCCURRED0_RTC1_MASK)
> +		return 1;
> +	else
> +		return 0;

  return uv_read_global_mmr64(pnode, UVH_EVENT_OCCURRED0) &
  	  UVH_EVENT_OCCURRED0_RTC1_MASK;

> +
> +/* Allocate per-node list of cpu timer expiration times. */
> +static int
> +uv_rtc_allocate_timers(void)
> +{
> +	int cpu;
> +	int max = 0;
> +	int pnode = -1;
> +	int i = 0;

Please collapse those ints into one line

> +	struct uv_rtc_timer_head *head = NULL;
> +
> +	/*
> +	 * Determine max possible hyperthreads/pnode for allocation.
> +	 *
> +	 * Allocate for all cpus that could come up, although we don't
> +	 * fully support hotplug (yet).
> +	 */
> +	for_each_possible_cpu(cpu) {
> +		if (pnode != cpu_to_pnode(cpu)) {
> +			i = 0;
> +			pnode = cpu_to_pnode(cpu);
> +		}
> +		if (max < ++i)
> +			max = i;
> +	}

Is this worth the trouble whether we allocate a couple of u64s per
node or not ? 

Also isn't this kind of topology evaluation not done in x86 code
already ?

> +	pnode = -1;
> +	for_each_possible_cpu(cpu) {
> +		if (pnode != cpu_to_pnode(cpu)) {
> +			i = 0;
> +			pnode = cpu_to_pnode(cpu);
> +			head = kmalloc_node(sizeof(struct uv_rtc_timer_head) +
> +					(max * sizeof(u64)),
> +					GFP_KERNEL, pnode);
> +			if (!head)
> +				return -ENOMEM;

  Leaks memory for already allocated nodes

> +			spin_lock_init(&head->lock);
> +			head->fcpu = cpu;
> +			head->cpus = 0;
> +			head->next_cpu = -1;
> +		}
> +		head->cpus++;
> +		head->expires[i++] = ULLONG_MAX;
> +		per_cpu(rtc_timer_head, cpu) = head;
> +	}
> +	return 0;
> +}
> +
> +/* Find and set the next expiring timer.  */
> +static void
> +uv_rtc_find_next_timer(struct uv_rtc_timer_head *head, int pnode)
> +{
> +	u64 exp;
> +	u64 lowest = ULLONG_MAX;
> +	int cpu = -1;
> +	int c;

  	u64 exp, lowest = ULLONG_MAX;
	int c, cpu = -1;

	please

> +	head->next_cpu = -1;
> +	for (c = 0; c < head->cpus; c++) {
> +		exp = head->expires[c];
> +		if (exp < lowest) {
> +			cpu = c;
> +			lowest = exp;
> +		}
> +	}

  How many cpus do we iterate here ? Is this really scaling ?

> +	if (cpu >= 0) {
> +		head->next_cpu = cpu;
> +		c = head->fcpu + cpu;
> +		uv_setup_intr(c, lowest);
> +		/* If we didn't set it up in time, trigger */
> +		if (lowest < uv_read_rtc() && !uv_intr_pending(pnode))
> +			uv_rtc_send_IPI(c, GENERIC_TIMER_VECTOR);

  Please move the expired check into uv_setup_intr() and return the
  expired status. You need the same check in uv_rtc_set_timer() below.

> +/*
> + * Local APIC timer broadcast function
> + */
> +static void
> +uv_rtc_timer_broadcast(cpumask_t mask)
> +{
> +	int cpu;
> +	for_each_cpu_mask(cpu, mask)
> +		uv_rtc_send_IPI(cpu, GENERIC_TIMER_VECTOR);
> +}

No need to implement broadcast. Your clock event device is not
affected from power states or such, so this will never be called.

> +static void
> +uv_rtc_interrupt(void)
> +{
> +	struct clock_event_device *ced = &__get_cpu_var(cpu_ced);
> +	unsigned long flags;
> +	int cpu = smp_processor_id();
> +
> +	local_irq_save(flags);

  called with interrupts disabled already.

> +	if (!ced || !ced->event_handler || !uv_rtc_unset_timer(cpu)) {
> +		local_irq_restore(flags);
> +		printk(KERN_WARNING
> +			"Spurious uv_rtc timer interrupt on cpu %d\n", cpu);
> +		return;
> +	}
> +	local_irq_restore(flags);
> +	ced->event_handler(ced);
> +}
> +
> +static __init void
> +uv_rtc_register_clockevents(void *data)
> +{
> +	struct clock_event_device *ced = &__get_cpu_var(cpu_ced);
> +
> +	*ced = clock_event_device_uv;
> +	cpus_clear(ced->cpumask);
> +	cpu_set(smp_processor_id(), ced->cpumask);
> +	clockevents_register_device(ced);

  clockevents_register_device can not be called from interrupt
  context. You use an SMP call for this. Please test your code with
  lockdep enabled.

> +}
> +
> +static __init int
> +uv_rtc_setup_clock(void)
> +{
> +	int rc;
> +
> +	if (!is_uv_system() ||
> +			register_generic_timer_extension(uv_rtc_interrupt))
> +		return -ENODEV;
> +
> +	clocksource_uv.mult = clocksource_hz2mult(sn_rtc_cycles_per_second,
> +				clocksource_uv.shift);
> +
> +	rc = clocksource_register(&clocksource_uv);
> +	if (rc) {
> +		unregister_generic_timer_extension();
> +		return rc;
> +	}
> +
> +	/* Setup and register clockevents */
> +	rc = uv_rtc_allocate_timers();
> +	if (rc) {

 The clock source is already registered. So now the module is removed
 and the timekeeping code explodes.

      clocksource_unregister(...) perpaps?

> +		unregister_generic_timer_extension();
> +		return rc;
> +	}
> +
> +	clock_event_device_uv.mult = div_sc(sn_rtc_cycles_per_second,
> +				NSEC_PER_SEC, clock_event_device_uv.shift);
> +
> +	clock_event_device_uv.min_delta_ns = NSEC_PER_SEC /
> +						sn_rtc_cycles_per_second;
> +	clock_event_device_uv.max_delta_ns = clocksource_uv.mask *
> +				(NSEC_PER_SEC / sn_rtc_cycles_per_second);
> +
> +	on_each_cpu(uv_rtc_register_clockevents, NULL, 0);
> +	return 0;
> +}
> +module_init(uv_rtc_setup_clock);
> Index: linux/kernel/time/clockevents.c
> ===================================================================
> --- linux.orig/kernel/time/clockevents.c	2008-12-19 10:02:23.000000000 -0600
> +++ linux/kernel/time/clockevents.c	2008-12-19 10:02:36.000000000 -0600
> @@ -185,6 +185,7 @@ void clockevents_register_device(struct 
>  
>  	spin_unlock(&clockevents_lock);
>  }
> +EXPORT_SYMBOL_GPL(clockevents_register_device);

Separate patch please
  
>  /*
>   * Noop handler when we shut down an event device
> Index: linux/kernel/time/clocksource.c
> ===================================================================
> --- linux.orig/kernel/time/clocksource.c	2008-12-19 10:02:23.000000000 -0600
> +++ linux/kernel/time/clocksource.c	2008-12-19 10:02:36.000000000 -0600
> @@ -369,6 +369,7 @@ void clocksource_unregister(struct clock
>  	next_clocksource = select_clocksource();
>  	spin_unlock_irqrestore(&clocksource_lock, flags);
>  }
> +EXPORT_SYMBOL(clocksource_unregister);

EXPORT_SYMBOL_GPL and separate patch please.

Thanks,

	tglx
