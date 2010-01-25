Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313Ab0AYOUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab0AYOUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227Ab0AYOUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:20:37 -0500
Received: from smtp-out.google.com ([216.239.44.51]:12470 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab0AYOUf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:20:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=OYhMVRHJTbdLM51eXsKCCn8ARXVNW8nnVuz3c7Bi1KdPmGCNtMhkxW8Vw+ACzGFzv
	f9y3cK0/AUxVTVEjFryRg==
MIME-Version: 1.0
In-Reply-To: <CF3466DD76A94945B5723C073FE74B0A69E64117E6@MAIL02.austin.utexas.edu>
References: <4b5991c4.0c58560a.44d3.ffffeedc@mx.google.com>
	 <05F95E05F0394ED3B66F16ACA8ED4650@terpstrat60p>
	 <CF3466DD76A94945B5723C073FE74B0A69E64117E6@MAIL02.austin.utexas.edu>
Date: Mon, 25 Jan 2010 15:20:31 +0100
Message-ID: <bd4cb8901001250620k69dabcd8k8d1b4ed3061c0595@mail.gmail.com>
Subject: Re: [Ptools-perfapi] [perfmon2] [PATCH] perf_events: AMD event 
	scheduling (v1)
From: Stephane Eranian <eranian@google.com>
To: John McCalpin <mccalpin@tacc.utexas.edu>
Cc: Dan Terpstra <terpstra@eecs.utk.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ptools-perfapi@eecs.utk.edu" <ptools-perfapi@eecs.utk.edu>,
       "perfmon2-devel@lists.sf.net" <perfmon2-devel@lists.sf.net>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "fweisbec@gmail.com" <fweisbec@gmail.com>,
       "paulus@samba.org" <paulus@samba.org>, "mingo@elte.hu" <mingo@elte.hu>,
       "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

On Fri, Jan 22, 2010 at 6:33 PM, John  McCalpin
<mccalpin@tacc.utexas.edu> wrote:
> Glad to see this improvement in functionality showing up!
>
Thanks. This was a long standing correctness issue with the AMD
support in perf_event.

> One piece of terminology that might be helpful is to avoid using the phrase
>        "No two cores can use the same counter to measure NB events."
>
I phrased it this way to describe the consequences of the hardware
implementation
and the way the restriction is enforced by the kernel patch.

I wanted something as simple and compact as possible. I did not want
to go into a
lot of details. People have to refer to BKDG for this.

But I am happy to change this and everybody thinks it is too confusing.

There is also another issue related to NB events. As you are measuring, you
must ensure that there is at least one core out of the halted state. In other
words you must never have all cores idle, otherwise I believe you get blind
spots.

Two ways to prevent this, boot the kernel with idle=poll, or implement
this at the user
level by having the tool create a simple nop-loop loop program pinned
on each CPU.
That program must run at scheduling priority SCHED_IDLE, i.e., only
when there is
nothing else to run.


> This wording has confused a lot of people, when the actual issue is not mysterious.
>
> Long Explanation:
> * Think of the system as having four performance monitors per core *plus* four performance monitors for the "shared" structures on the chip (L3, crossbar, HyperTransport links, memory controllers).
> * When a core programs one of its performance monitor registers to count a "shared" event, it is actually programming the "shared" counter with the same counter number in the shared structure.
>
> * If two or more cores program the same counter number in the shared part of the chip, the shared counter will simply be programmed multiple times.  Each time that it is set it will count according to its current programming -- until the next thread changes the setting to measure something different.
> ** If the threads are unsynchronized, the counts read from the performance monitor will not make any sense (because the threads don't know which event the counter is counting, or how long it has been counting it).
>
> * If the threads are synchronized and "aware" of how other threads are programming the shared counters, then it is possible to obtain useful information from the counters.
> ** A common paradigm is for all cores to measure the same event during a parallel section.  In this case all the cores will program the shared counter to count the same event (so the order in which they perform the performance monitor programming does not matter), and if the threads are synchronized, then they will all obtain approximately the same result from reading the counter.
>
> Comment:
> How one chooses to implement performance monitoring software depends a great deal on the system usage model (shared or private) and on the decisions made by the developer of the performance monitoring software concerning user programming errors:
> * prevent the possibility of race conditions?
> * make race conditions possible only if the user explicitly overrides protection?
> * allow the user to configure code with race conditions but attempt to detect them?
> * leave the user on her own to understand and avoid race conditions?
>
>
> So instead of saying "no two cores can use the same counter to measure shared events", I prefer to say something like:
>        "There is only one set of "shared" counters per chip, which can be accessed by any of the cores.  If multiple cores program the same performance counter register number to measure "shared" events, the corresponding shared counter will be programmed multiple times and the resulting measurements will depend on the exact ordering of the performance monitor register programming events and performance monitor register reading events.  The results are therefore unlikely to be useful."
>
> There is an additional hazard when working with early K8 processors -- a hardware bug causes the counts of all shared counters to be reset to zero any time any shared register is programmed.  This makes "protecting" users somewhat more difficult....
>
>
> john
>
>
>
> -----Original Message-----
> From: ptools-perfapi-bounces@eecs.utk.edu [mailto:ptools-perfapi-bounces@eecs.utk.edu] On Behalf Of Dan Terpstra
> Sent: Friday, January 22, 2010 9:22 AM
> To: eranian@google.com; linux-kernel@vger.kernel.org; ptools-perfapi@eecs.utk.edu
> Cc: perfmon2-devel@lists.sf.net; peterz@infradead.org; fweisbec@gmail.com; paulus@samba.org; mingo@elte.hu; davem@davemloft.net
> Subject: Re: [Ptools-perfapi] [perfmon2] [PATCH] perf_events: AMD event scheduling (v1)
>
> Excellent!
> Now I'd love to see equivalent functionality on Nehalem!
> - dan
>
>> -----Original Message-----
>> From: Stephane Eranian [mailto:eranian@google.com]
>> Sent: Friday, January 22, 2010 5:43 AM
>> To: linux-kernel@vger.kernel.org
>> Cc: perfmon2-devel@lists.sf.net; eranian@gmail.com; peterz@infradead.org;
>> fweisbec@gmail.com; eranian@google.com; paulus@samba.org; mingo@elte.hu;
>> davem@davemloft.net
>> Subject: [perfmon2] [PATCH] perf_events: AMD event scheduling (v1)
>>
>>
>>       This patch adds correct AMD Northbridge event scheduling.
>>       It must be applied on top of my v5 + v6 incremental event
>>       scheduling patch.
>>
>>       AMD Northbridge (NB) events measure L3 and Hypertransport
>>       activities.  There is a documented restriction on how NB
>>       events can be programmed (refer to BKDG section 3.12).
>>
>>       No two cores can use the same counter to measure NB events.
>>       This patch implements this restriction by maintaining a per
>>       Northbridge counter allocation table. All cores attached to
>>       the same NB compete to allocate NB events. Given that you have
>>       4 counters, this means that at most 1 NB event can be measured by
>>       all cores. The better alternative is to measure all NB events
>>       from a single core. Both approaches are possible using this patch.
>>       If there is more NB events than there are counters, some NB events
>>       will not be scheduled, e.g., 2 NB events on each core on a 4-core
>>       package.
>>
>>       The patch also takes care of hotplug CPU.
>>
>>       Signed-off-by: Stephane Eranian <eranian@google.com>
>>
>> --
>>  arch/x86/kernel/cpu/perf_event.c |  252
>> ++++++++++++++++++++++++++++++++++++++-
>>  kernel/perf_event.c              |    5
>>  2 files changed, 254 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event.c
>> b/arch/x86/kernel/cpu/perf_event.c
>> index a961b1f..a97a744 100644
>> --- a/arch/x86/kernel/cpu/perf_event.c
>> +++ b/arch/x86/kernel/cpu/perf_event.c
>> @@ -69,6 +69,12 @@ struct debug_store {
>>       u64     pebs_event_reset[MAX_PEBS_EVENTS];
>>  };
>>
>> +struct amd_nb {
>> +        int nb_id; /* Northbridge id */
>> +     int refcnt; /* refernce count */
>> +     struct perf_event *owners[X86_PMC_IDX_MAX];
>> +};
>> +
>>  #define BITS_TO_U64(nr) DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
>>
>>  struct event_constraint {
>> @@ -89,6 +95,7 @@ struct cpu_hw_events {
>>       int                     assign[X86_PMC_IDX_MAX]; /* event to counter
>> assignment */
>>       u64                     tags[X86_PMC_IDX_MAX];
>>       struct perf_event       *event_list[X86_PMC_IDX_MAX]; /* in enabled
> order
>> */
>> +     struct amd_nb           *amd_nb;
>>  };
>>
>>  #define EVENT_CONSTRAINT(c, n, m) { \
>> @@ -134,6 +141,8 @@ struct x86_pmu {
>>
>>  static struct x86_pmu x86_pmu __read_mostly;
>>
>> +static raw_spinlock_t amd_nb_lock;
>> +
>>  static DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
>>       .enabled = 1,
>>  };
>> @@ -2199,12 +2208,144 @@ static void intel_get_event_constraints(struct
>> cpu_hw_events *cpuc,
>>       bitmap_fill((unsigned long *)idxmsk, x86_pmu.num_events);
>>  }
>>
>> +/*
>> + * AMD64 events are detected based on their event codes.
>> + */
>> +static inline int amd_is_nb_event(struct hw_perf_event *hwc)
>> +{
>> +     u64 val = hwc->config;
>> +        /* event code : bits [35-32] | [7-0] */
>> +        val = (val >> 24) | ( val & 0xff);
>> +        return val >= 0x0e0;
>> +}
>> +
>> +static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
>> +                            struct perf_event *event)
>> +{
>> +     struct hw_perf_event *hwc = &event->hw;
>> +     struct perf_event *old;
>> +     struct amd_nb *nb;
>> +     int i;
>> +
>> +     /*
>> +      * only care about NB events
>> +      */
>> +     if(!amd_is_nb_event(hwc))
>> +             return;
>> +
>> +     /*
>> +      * NB not initialized
>> +      */
>> +     nb = cpuc->amd_nb;
>> +     if (!nb)
>> +             return;
>> +
>> +     if (hwc->idx == -1)
>> +             return;
>> +
>> +     /*
>> +      * need to scan whole list because event may not have
>> +      * been assigned during scheduling
>> +      */
>> +     for(i=0; i < x86_pmu.num_events; i++) {
>> +             if (nb->owners[i] == event) {
>> +                     old = cmpxchg(nb->owners+i, event, NULL);
>> +                     WARN_ON(old != event);
>> +                     return;
>> +             }
>> +     }
>> +}
>> +
>> +/*
>> + * AMD64 Northbridge events need special treatment because
>> + * counter access needs to be synchronized across all cores
>> + * of a package. Refer to BKDG section 3.12
>> + *
>> + * NB events are events measuring L3 cache, Hypertransport
>> + * traffic. They are identified by an event code  >= 0xe0.
>> + *
>> + * No two cores can be measuring NB events using the same
>> + * counter. In other words, for NB events, it is as if there
>> + * was only one set of counters per package (or cores sharing
>> + * the same NB). Thus, we need to maintain a per-NB * allocation
>> + * table. The available slot is propagated using the bitmask.
>> + * We provide only one choice for each NB events based on
>> + * the fact that only NB events have restrictions. Consequently,
>> + * if a counter is available, there is a guarantee the NB event
>> + * will be assigned to it. If no slot is available, an empty
>> + * bitmask is returned and scheduling fails.
>> + *
>> + * Note that all cores attached the same NB compete for the same
>> + * counters to host NB events, this is why we use atomic ops.
>> + *
>> + * Given that resources are allocated (cmpxchg), they must be
>> + * eventually freed for others to use. This is accomplished by
>> + * calling amd_put_event_constraints().
>> + *
>> + * Non NB events are not impacted by this restriction.
>> + */
>>  static void amd_get_event_constraints(struct cpu_hw_events *cpuc,
>>                                     struct perf_event *event,
>>                                     u64 *idxmsk)
>>  {
>> -     /* no constraints, means supports all generic counters */
>> -     bitmap_fill((unsigned long *)idxmsk, x86_pmu.num_events);
>> +     struct hw_perf_event *hwc = &event->hw;
>> +     struct amd_nb *nb = cpuc->amd_nb;
>> +     struct perf_event *old = NULL;
>> +     int max = x86_pmu.num_events;
>> +     int i, j, k = -1;
>> +
>> +     /*
>> +      * clean up vector
>> +      */
>> +     bitmap_zero((unsigned long *)idxmsk, X86_PMC_IDX_MAX);
>> +
>> +     /*
>> +      * if not NB event or no NB, then no constraints
>> +      */
>> +     if (!amd_is_nb_event(hwc) || !nb) {
>> +             bitmap_fill((unsigned long *)idxmsk, x86_pmu.num_events);
>> +             return;
>> +     }
>> +     /*
>> +      * detect if already present, if so reuse
>> +      *
>> +      * cannot merge with actual allocation
>> +      * because of possible holes
>> +      *
>> +      * event can already be present yet not assigned (in hwc->idx)
>> +      * because of successive calls to x86_schedule_events() from
>> +      * hw_perf_group_sched_in() without hw_perf_enable()
>> +      */
>> +     for(i=0; i < max; i++) {
>> +             /*
>> +              * keep track of first free slot
>> +              */
>> +             if (k == -1 && !nb->owners[i])
>> +                     k = i;
>> +
>> +             /* already present, reuse */
>> +             if (nb->owners[i] == event)
>> +                     goto skip;
>> +     }
>> +     /*
>> +      * not present, so grab a new slot
>> +      *
>> +      * try to alllcate same counter as before if
>> +      * event has already been assigned once. Otherwise,
>> +      * try to use free counter k obtained during the 1st
>> +      * pass above.
>> +      */
>> +     i = j = hwc->idx != -1 ? hwc->idx : (k == -1 ? 0 : k);
>> +     do {
>> +             old = cmpxchg(nb->owners+i, NULL, event);
>> +             if (!old)
>> +                     break;
>> +             if (++i == x86_pmu.num_events)
>> +                     i = 0;
>> +     } while (i != j);
>> +skip:
>> +     if (!old)
>> +             set_bit(i, (unsigned long *)idxmsk);
>>  }
>>
>>  static int x86_event_sched_in(struct perf_event *event,
>> @@ -2394,7 +2535,8 @@ static __initconst struct x86_pmu amd_pmu = {
>>       .apic                   = 1,
>>       /* use highest bit to detect overflow */
>>       .max_period             = (1ULL << 47) - 1,
>> -     .get_event_constraints  = amd_get_event_constraints
>> +     .get_event_constraints  = amd_get_event_constraints,
>> +     .put_event_constraints  = amd_put_event_constraints
>>  };
>>
>>  static __init int p6_pmu_init(void)
>> @@ -2501,6 +2643,87 @@ static __init int intel_pmu_init(void)
>>       return 0;
>>  }
>>
>> +static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
>> +{
>> +        struct amd_nb *nb;
>> +
>> +        nb= vmalloc_node(sizeof(struct amd_nb), cpu_to_node(cpu));
>> +        if (!nb)
>> +                return NULL;
>> +
>> +        memset(nb, 0, sizeof(*nb));
>> +        nb->nb_id = nb_id;
>> +        return nb;
>> +}
>> +
>> +static void amd_pmu_cpu_online(int cpu)
>> +{
>> +     struct cpu_hw_events *cpu1, *cpu2;
>> +     struct amd_nb *nb = NULL;
>> +     int i, nb_id;
>> +
>> +     if (boot_cpu_data.x86_max_cores < 2)
>> +             return;
>> +
>> +     /*
>> +      * function may be called too early in the
>> +      * boot process, in which case nb_id is bogus
>> +      *
>> +      * for BSP, there is an explicit call from
>> +      * amd_pmu_init()
>> +      */
>> +     nb_id = amd_get_nb_id(cpu);
>> +     if (nb_id == BAD_APICID)
>> +             return;
>> +
>> +     cpu1 = &per_cpu(cpu_hw_events, cpu);
>> +     cpu1->amd_nb = NULL;
>> +
>> +     raw_spin_lock(&amd_nb_lock);
>> +
>> +     for_each_online_cpu(i) {
>> +             cpu2 = &per_cpu(cpu_hw_events, i);
>> +             nb = cpu2->amd_nb;
>> +             if (!nb)
>> +                     continue;
>> +             if (nb->nb_id == nb_id)
>> +                     goto found;
>> +     }
>> +
>> +     nb = amd_alloc_nb(cpu, nb_id);
>> +     if (!nb) {
>> +             pr_err("perf_events: failed to allocate NB storage for
>> CPU%d\n", cpu);
>> +             raw_spin_unlock(&amd_nb_lock);
>> +             return;
>> +     }
>> +found:
>> +     nb->refcnt++;
>> +     cpu1->amd_nb = nb;
>> +
>> +     raw_spin_unlock(&amd_nb_lock);
>> +
>> +     pr_info("CPU%d NB%d ref=%d\n", cpu, nb_id, nb->refcnt);
>> +}
>> +
>> +static void amd_pmu_cpu_offline(int cpu)
>> +{
>> +     struct cpu_hw_events *cpuhw;
>> +
>> +     if (boot_cpu_data.x86_max_cores < 2)
>> +             return;
>> +
>> +     cpuhw = &per_cpu(cpu_hw_events, cpu);
>> +
>> +     raw_spin_lock(&amd_nb_lock);
>> +
>> +     if (--cpuhw->amd_nb->refcnt == 0)
>> +             vfree(cpuhw->amd_nb);
>> +
>> +     cpuhw->amd_nb = NULL;
>> +
>> +     raw_spin_unlock(&amd_nb_lock);
>> +}
>> +
>>  static __init int amd_pmu_init(void)
>>  {
>>       /* Performance-monitoring supported from K7 and later: */
>> @@ -2513,6 +2736,8 @@ static __init int amd_pmu_init(void)
>>       memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
>>              sizeof(hw_cache_event_ids));
>>
>> +     /* initialize BSP */
>> +     amd_pmu_cpu_online(smp_processor_id());
>>       return 0;
>>  }
>>
>> @@ -2842,4 +3067,25 @@ struct perf_callchain_entry *perf_callchain(struct
>> pt_regs *regs)
>>  void hw_perf_event_setup_online(int cpu)
>>  {
>>       init_debug_store_on_cpu(cpu);
>> +
>> +     switch (boot_cpu_data.x86_vendor) {
>> +     case X86_VENDOR_AMD:
>> +             amd_pmu_cpu_online(cpu);
>> +             break;
>> +     default:
>> +             return;
>> +     }
>> +}
>> +
>> +void hw_perf_event_setup_offline(int cpu)
>> +{
>> +     init_debug_store_on_cpu(cpu);
>> +
>> +     switch (boot_cpu_data.x86_vendor) {
>> +     case X86_VENDOR_AMD:
>> +             amd_pmu_cpu_offline(cpu);
>> +             break;
>> +     default:
>> +             return;
>> +     }
>>  }
>> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
>> index 27f69a0..20f212e 100644
>> --- a/kernel/perf_event.c
>> +++ b/kernel/perf_event.c
>> @@ -98,6 +98,7 @@ void __weak hw_perf_enable(void)            { barrier();
> }
>>
>>  void __weak hw_perf_event_setup(int cpu)     { barrier(); }
>>  void __weak hw_perf_event_setup_online(int cpu)      { barrier(); }
>> +void __weak hw_perf_event_setup_offline(int cpu){ barrier(); }
>>
>>  int __weak
>>  hw_perf_group_sched_in(struct perf_event *group_leader,
>> @@ -5251,6 +5252,10 @@ perf_cpu_notify(struct notifier_block *self,
>> unsigned long action, void *hcpu)
>>               perf_event_exit_cpu(cpu);
>>               break;
>>
>> +        case CPU_DEAD:
>> +                hw_perf_event_setup_offline(cpu);
>> +                break;
>> +
>>       default:
>>               break;
>>       }
>>
>> --------------------------------------------------------------------------
>> ----
>> Throughout its 18-year history, RSA Conference consistently attracts the
>> world's best and brightest in the field, creating opportunities for
>> Conference
>> attendees to learn about information security's most important issues
>> through
>> interactions with peers, luminaries and emerging and established
>> companies.
>> http://p.sf.net/sfu/rsaconf-dev2dev
>> _______________________________________________
>> perfmon2-devel mailing list
>> perfmon2-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/perfmon2-devel
>
> _______________________________________________
> Ptools-perfapi mailing list
> Ptools-perfapi@eecs.utk.edu
> http://lists.eecs.utk.edu/mailman/listinfo/ptools-perfapi
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
