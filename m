Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab0BDOz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:55:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45651 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143Ab0BDOzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:55:25 -0500
Subject: Re: [PATCH]  perf_events: AMD event scheduling (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <4b674594.0a04d00a.6005.2567@mx.google.com>
References: <4b674594.0a04d00a.6005.2567@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 15:55:02 +0100
Message-ID: <1265295302.24455.2265.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 22:15 +0200, Stephane Eranian wrote:
> 	
> 	This patch adds correct AMD Northbridge event scheduling.
> 	It must be applied on top tip-x86 + hw_perf_enable() fix.
> 
> 	NB events are events measuring L3 cache, Hypertransport
> 	traffic. They are identified by an event code  >= 0xe0.
> 	They measure events on the Northbride which is shared
> 	by all cores on a package. NB events are counted on a
> 	shared set of counters. When a NB event is programmed
> 	in a counter, the data actually comes from a shared
> 	counter. Thus, access to those counters needs to be
> 	synchronized.
> 
> 	We implement the synchronization such that no two cores
> 	can be measuring NB events using the same counters. Thus,
> 	we maintain a per-NB * allocation table. The available slot
> 	is propagated using the event_constraint structure.
>  
> 	This 2nd version takes into account the changes on how
> 	constraints are stored by the scheduling code.
> 
> 	The patch also takes care of hotplug CPU.
> 
> 	Signed-off-by: Stephane Eranian <eranian@google.com>

Please run the patch through checkpatch, there's lots of trivial coding
style errors (spaces instead of tabs, for(i=0; etc..)

> @@ -2250,10 +2261,144 @@ intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event
>  	return &unconstrained;
>  }
>  
> +/*
> + * AMD64 events are detected based on their event codes.
> + */
> +static inline int amd_is_nb_event(struct hw_perf_event *hwc)
> +{
> +	u64 val = hwc->config;

& K7_EVNTSEL_EVENT_MASK ?

> +	/* event code : bits [35-32] | [7-0] */
> +	val = (val >> 24) | ( val & 0xff);
> +	return val >= 0x0e0;
> +}
> +
> +static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
> +				      struct perf_event *event)
> +{
> +	struct hw_perf_event *hwc = &event->hw;
> +	struct perf_event *old;
> +	struct amd_nb *nb;
> +	int i;
> +
> +	/*
> +	 * only care about NB events
> +	 */
> +	if(!amd_is_nb_event(hwc))
> +		return;
> +
> +	/*
> +	 * NB not initialized
> +	 */
> +	nb = cpuc->amd_nb;
> +	if (!nb)
> +		return;
> +
> +	if (hwc->idx == -1)
> +		return;
> +
> +	/*
> +	 * need to scan whole list because event may not have
> +	 * been assigned during scheduling
> +	 */
> +	for(i=0; i < x86_pmu.num_events; i++) {
> +		if (nb->owners[i] == event) {
> +			old = cmpxchg(nb->owners+i, event, NULL);

might want to validate old is indeed event.

> +			return;
> +		}
> +	}
> +}
> +
> + /*
> +  * AMD64 Northbridge events need special treatment because
> +  * counter access needs to be synchronized across all cores
> +  * of a package. Refer to BKDG section 3.12
> +  *
> +  * NB events are events measuring L3 cache, Hypertransport
> +  * traffic. They are identified by an event code  >= 0xe0.
> +  * They measure events on the Northbride which is shared
> +  * by all cores on a package. NB events are counted on a
> +  * shared set of counters. When a NB event is programmed
> +  * in a counter, the data actually comes from a shared
> +  * counter. Thus, access to those counters needs to be
> +  * synchronized.
> +  * We implement the synchronization such that no two cores
> +  * can be measuring NB events using the same counters. Thus,
> +  * we maintain a per-NB * allocation table. The available slot
> +  * is propagated using the event_constraint structure.
> +  *
> +  * We provide only one choice for each NB event based on
> +  * the fact that only NB events have restrictions. Consequently,
> +  * if a counter is available, there is a guarantee the NB event
> +  * will be assigned to it. If no slot is available, an empty
> +  * constraint is returned and scheduling will evnetually fail
> +  * for this event.
> +  *
> +  * Note that all cores attached the same NB compete for the same
> +  * counters to host NB events, this is why we use atomic ops. Some
> +  * multi-chip CPUs may have more than one NB.
> +  *
> +  * Given that resources are allocated (cmpxchg), they must be
> +  * eventually freed for others to use. This is accomplished by
> +  * calling amd_put_event_constraints().
> +  *
> +  * Non NB events are not impacted by this restriction.
> +  */
>  static struct event_constraint *
>  amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
>  {
> -	return &unconstrained;
> +	struct hw_perf_event *hwc = &event->hw;
> +	struct amd_nb *nb = cpuc->amd_nb;
> +	struct perf_event *old = NULL;
> +	int max = x86_pmu.num_events;
> +	int i, j, k = -1;
> +
> +	/*
> +	 * if not NB event or no NB, then no constraints
> +	 */
> +	if (!amd_is_nb_event(hwc) || !nb)
> +		return &unconstrained;
> +
> +	/*
> +	 * detect if already present, if so reuse
> +	 *
> +	 * cannot merge with actual allocation
> +	 * because of possible holes
> +	 *
> +	 * event can already be present yet not assigned (in hwc->idx)
> +	 * because of successive calls to x86_schedule_events() from
> +	 * hw_perf_group_sched_in() without hw_perf_enable()
> +	 */
> +	for(i=0; i < max; i++) {
> +		/*
> +		 * keep track of first free slot
> +		 */
> +		if (k == -1 && !nb->owners[i])
> +			k = i;

break?

> +
> +		/* already present, reuse */
> +		if (nb->owners[i] == event)
> +			goto skip;

s/skip/done/ ?

> +	}
> +	/*
> +	 * not present, so grab a new slot
> +	 *
> +	 * try to alllcate same counter as before if
> +	 * event has already been assigned once. Otherwise,
> +	 * try to use free counter k obtained during the 1st
> +	 * pass above.
> +	 */
> +	i = j = hwc->idx != -1 ? hwc->idx : (k == -1 ? 0 : k);

That's patently unreadable, and I'm not sure what happens if we failed
to find an eligible spot in the above loop, should we not somehow jump
out and return emptyconstraint?

> +	do {
> +		old = cmpxchg(nb->owners+i, NULL, event);
> +		if (!old)
> +			break;
> +		if (++i == x86_pmu.num_events)
> +			i = 0;
> +	} while (i != j);
> +skip:
> +	if (!old)
> +		return &nb->event_constraints[i];
> +	return &emptyconstraint;
>  }
>  
>  static int x86_event_sched_in(struct perf_event *event,

> @@ -2561,6 +2707,96 @@ static __init int intel_pmu_init(void)
>  	return 0;
>  }
>  
> +static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
> +{
> +        struct amd_nb *nb;
> +	int i;
> +
> +        nb= vmalloc_node(sizeof(struct amd_nb), cpu_to_node(cpu));

$ pahole -C amd_nb build/arch/x86/kernel/cpu/perf_event.o
struct amd_nb {
        int                        nb_id;                /*     0     4 */
        int                        refcnt;               /*     4     4 */
        struct perf_event *        owners[64];           /*     8   512 */
        /* --- cacheline 8 boundary (512 bytes) was 8 bytes ago --- */
        struct event_constraint    event_constraints[64]; /*   520  1536 */
        /* --- cacheline 32 boundary (2048 bytes) was 8 bytes ago --- */

        /* size: 2056, cachelines: 33 */
        /* last cacheline: 8 bytes */
};

Surely we can kmalloc that?

> +        if (!nb)
> +                return NULL;
> +
> +        memset(nb, 0, sizeof(*nb));
> +        nb->nb_id = nb_id;
> +
> +	/*
> +	 * initialize all possible NB constraints
> +	 */
> +	for(i=0; i < x86_pmu.num_events; i++) {
> +		set_bit(i, nb->event_constraints[i].idxmsk);
> +		nb->event_constraints[i].weight = 1;
> +	}
> +        return nb;
> +}

Terrible whilespace damage.

> +
> +static void amd_pmu_cpu_online(int cpu)
> +{
> +	struct cpu_hw_events *cpu1, *cpu2;
> +	struct amd_nb *nb = NULL;
> +	int i, nb_id;
> +
> +	if (boot_cpu_data.x86_max_cores < 2)
> +		return;

So there are no single core AMD chips that have a NorthBridge PMU? What
about the recent 64bit single core laptop chips?

> +
> +	/*
> +	 * function may be called too early in the
> +	 * boot process, in which case nb_id is bogus
> +	 *
> +	 * for BSP, there is an explicit call from
> +	 * amd_pmu_init()
> +	 */

I keep getting flash-backs to doom's graphics engine every time I see
BSP..

> +	nb_id = amd_get_nb_id(cpu);
> +	if (nb_id == BAD_APICID)
> +		return;
> +
> +	cpu1 = &per_cpu(cpu_hw_events, cpu);
> +	cpu1->amd_nb = NULL;
> +
> +	raw_spin_lock(&amd_nb_lock);
> +
> +	for_each_online_cpu(i) {
> +		cpu2 = &per_cpu(cpu_hw_events, i);
> +		nb = cpu2->amd_nb;
> +		if (!nb)
> +			continue;
> +		if (nb->nb_id == nb_id)
> +			goto found;
> +	}
> +
> +	nb = amd_alloc_nb(cpu, nb_id);
> +	if (!nb) {
> +		pr_err("perf_events: failed to allocate NB storage for CPU%d\n", cpu);
> +		raw_spin_unlock(&amd_nb_lock);
> +		return;
> +	}
> +found:
> +	nb->refcnt++;
> +	cpu1->amd_nb = nb;
> +
> +	raw_spin_unlock(&amd_nb_lock);

Can't this be simplified by using the cpu to node mask?

> +	pr_info("CPU%d NB%d ref=%d\n", cpu, nb_id, nb->refcnt);

stray debug stuff?

> +}
> +
> +static void amd_pmu_cpu_offline(int cpu)
> +{
> +	struct cpu_hw_events *cpuhw;
> +
> +	if (boot_cpu_data.x86_max_cores < 2)
> +		return;
> +
> +	cpuhw = &per_cpu(cpu_hw_events, cpu);
> +
> +	raw_spin_lock(&amd_nb_lock);
> +
> +	if (--cpuhw->amd_nb->refcnt == 0)
> +		vfree(cpuhw->amd_nb);
> +
> +	cpuhw->amd_nb = NULL;
> +
> +	raw_spin_unlock(&amd_nb_lock);
> +}
> +
>  static __init int amd_pmu_init(void)
>  {
>  	/* Performance-monitoring supported from K7 and later: */
> @@ -2573,6 +2809,8 @@ static __init int amd_pmu_init(void)
>  	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
>  	       sizeof(hw_cache_event_ids));
>  
> +	/* initialize BSP */

Binary Space Partitioning again?

> +	amd_pmu_cpu_online(smp_processor_id());
>  	return 0;
>  }


Also, I think this is buggy in that:

  perf_disable();
  event->pmu->disable(event);
  ...
  event->pmu->enable(event);
  perf_enable();

can now fail, I think we need to move the put_event_constraint() from
x86_pmu_disable() into x86_perf_enable() or something.

