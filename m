Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab0BDQF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:05:28 -0500
Received: from smtp-out.google.com ([216.239.33.17]:62527 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935Ab0BDQFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:05:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=kQglMNeeJ72iSHki4Oiy1bFZiNoupYl1h/ViG9++8yEs6eQR0s2SmB56DT1NTzw8t
	RMH6HTgL/QghROssjJtHg==
MIME-Version: 1.0
In-Reply-To: <1265295302.24455.2265.camel@laptop>
References: <4b674594.0a04d00a.6005.2567@mx.google.com>
	 <1265295302.24455.2265.camel@laptop>
Date: Thu, 4 Feb 2010 17:05:15 +0100
Message-ID: <bd4cb8901002040805k759ae239q80e42f8ac4cc0e0e@mail.gmail.com>
Subject: Re: [PATCH] perf_events: AMD event scheduling (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 4, 2010 at 3:55 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-02-01 at 22:15 +0200, Stephane Eranian wrote:
>>
>>       This patch adds correct AMD Northbridge event scheduling.
>>       It must be applied on top tip-x86 + hw_perf_enable() fix.
>>
>>       NB events are events measuring L3 cache, Hypertransport
>>       traffic. They are identified by an event code  >= 0xe0.
>>       They measure events on the Northbride which is shared
>>       by all cores on a package. NB events are counted on a
>>       shared set of counters. When a NB event is programmed
>>       in a counter, the data actually comes from a shared
>>       counter. Thus, access to those counters needs to be
>>       synchronized.
>>
>>       We implement the synchronization such that no two cores
>>       can be measuring NB events using the same counters. Thus,
>>       we maintain a per-NB * allocation table. The available slot
>>       is propagated using the event_constraint structure.
>>
>>       This 2nd version takes into account the changes on how
>>       constraints are stored by the scheduling code.
>>
>>       The patch also takes care of hotplug CPU.
>>
>>       Signed-off-by: Stephane Eranian <eranian@google.com>
>
> Please run the patch through checkpatch, there's lots of trivial coding
> style errors (spaces instead of tabs, for(i=0; etc..)
>
Sorry about that.

>> @@ -2250,10 +2261,144 @@ intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event
>>       return &unconstrained;
>>  }
>>
>> +/*
>> + * AMD64 events are detected based on their event codes.
>> + */
>> +static inline int amd_is_nb_event(struct hw_perf_event *hwc)
>> +{
>> +     u64 val = hwc->config;
>
> & K7_EVNTSEL_EVENT_MASK ?

Yes, except that:
-#define K7_EVNTSEL_EVENT_MASK  0x7000000FFULL
+#define K7_EVNTSEL_EVENT_MASK  0xF000000FFULL

>
>> +     /* event code : bits [35-32] | [7-0] */
>> +     val = (val >> 24) | ( val & 0xff);
>> +     return val >= 0x0e0;
>> +}
>> +
>> +static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
>> +                                   struct perf_event *event)
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
>
> might want to validate old is indeed event.
>
It was in there during debugging ;->

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
>
> break?
>
No, we need to look for event, that's the main purpose
of the loop. We simply overlap this with looking for an
empty slot (before the event).

>> +      *
>> +      * try to alllcate same counter as before if
>> +      * event has already been assigned once. Otherwise,
>> +      * try to use free counter k obtained during the 1st
>> +      * pass above.
>> +      */
>> +     i = j = hwc->idx != -1 ? hwc->idx : (k == -1 ? 0 : k);
>
> That's patently unreadable, and I'm not sure what happens if we failed
> to find an eligible spot in the above loop, should we not somehow jump
> out and return emptyconstraint?
>
I have clarified the nested if. The goal of the first loop is to check
if the event is already present (explained why this is possible in the
comment). We may not have scanned all the slots. Furthermore, there
may be concurrent scans going on on other CPUs. The first pass tries
to find an empty slot, it does not reserve it. The second loop is the actual
allocation. We speculate the slot we found in the first pass is still available.
If the second loops fails, then we return emptyconstraints.

>> +     do {
>> +             old = cmpxchg(nb->owners+i, NULL, event);
>> +             if (!old)
>> +                     break;
>> +             if (++i == x86_pmu.num_events)
>> +                     i = 0;
>> +     } while (i != j);
>> +skip:
>> +     if (!old)
>> +             return &nb->event_constraints[i];
>> +     return &emptyconstraint;
>>  }
>>
>>  static int x86_event_sched_in(struct perf_event *event,
>
>> @@ -2561,6 +2707,96 @@ static __init int intel_pmu_init(void)
>>       return 0;
>>  }
>>
>> +static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
>> +{
>> +        struct amd_nb *nb;
>> +     int i;
>> +
>> +        nb= vmalloc_node(sizeof(struct amd_nb), cpu_to_node(cpu));
>
> $ pahole -C amd_nb build/arch/x86/kernel/cpu/perf_event.o
> struct amd_nb {
>        int                        nb_id;                /*     0     4 */
>        int                        refcnt;               /*     4     4 */
>        struct perf_event *        owners[64];           /*     8   512 */
>        /* --- cacheline 8 boundary (512 bytes) was 8 bytes ago --- */
>        struct event_constraint    event_constraints[64]; /*   520  1536 */
>        /* --- cacheline 32 boundary (2048 bytes) was 8 bytes ago --- */
>
>        /* size: 2056, cachelines: 33 */
>        /* last cacheline: 8 bytes */
> };
>
> Surely we can kmalloc that?
>
Ok, I can switch that.

>> +
>> +     /*
>> +      * function may be called too early in the
>> +      * boot process, in which case nb_id is bogus
>> +      *
>> +      * for BSP, there is an explicit call from
>> +      * amd_pmu_init()
>> +      */
>
> I keep getting flash-backs to doom's graphics engine every time I see
> BSP..
>
So how do you call the initial boot processor?


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
>> +             pr_err("perf_events: failed to allocate NB storage for CPU%d\n", cpu);
>> +             raw_spin_unlock(&amd_nb_lock);
>> +             return;
>> +     }
>> +found:
>> +     nb->refcnt++;
>> +     cpu1->amd_nb = nb;
>> +
>> +     raw_spin_unlock(&amd_nb_lock);
>
> Can't this be simplified by using the cpu to node mask?

You mean to find the NB that corresponds to a CPU?

> Also, I think this is buggy in that:
>
>  perf_disable();
>  event->pmu->disable(event);
>  ...
>  event->pmu->enable(event);
>  perf_enable();
>
> can now fail, I think we need to move the put_event_constraint() from
> x86_pmu_disable() into x86_perf_enable() or something.

Constraints are reserved during x86_scheduling(), not during enable().
So if you had a conflict it was detected earlier than that.


-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
