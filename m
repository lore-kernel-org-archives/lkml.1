Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab0BDQTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:19:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58893 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758266Ab0BDQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:19:51 -0500
Subject: Re: [PATCH] perf_events: AMD event scheduling (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <bd4cb8901002040805k759ae239q80e42f8ac4cc0e0e@mail.gmail.com>
References: <4b674594.0a04d00a.6005.2567@mx.google.com>
	 <1265295302.24455.2265.camel@laptop>
	 <bd4cb8901002040805k759ae239q80e42f8ac4cc0e0e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 17:19:35 +0100
Message-ID: <1265300375.22001.102.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 17:05 +0100, Stephane Eranian wrote:

> >> @@ -2250,10 +2261,144 @@ intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event
> >>       return &unconstrained;
> >>  }
> >>
> >> +/*
> >> + * AMD64 events are detected based on their event codes.
> >> + */
> >> +static inline int amd_is_nb_event(struct hw_perf_event *hwc)
> >> +{
> >> +     u64 val = hwc->config;
> >
> > & K7_EVNTSEL_EVENT_MASK ?
> 
> Yes, except that:
> -#define K7_EVNTSEL_EVENT_MASK  0x7000000FFULL
> +#define K7_EVNTSEL_EVENT_MASK  0xF000000FFULL

Ah, indeed.

> >> +      *
> >> +      * try to alllcate same counter as before if
> >> +      * event has already been assigned once. Otherwise,
> >> +      * try to use free counter k obtained during the 1st
> >> +      * pass above.
> >> +      */
> >> +     i = j = hwc->idx != -1 ? hwc->idx : (k == -1 ? 0 : k);
> >
> > That's patently unreadable, and I'm not sure what happens if we failed
> > to find an eligible spot in the above loop, should we not somehow jump
> > out and return emptyconstraint?
> >
> I have clarified the nested if. The goal of the first loop is to check
> if the event is already present (explained why this is possible in the
> comment). We may not have scanned all the slots. Furthermore, there
> may be concurrent scans going on on other CPUs. The first pass tries
> to find an empty slot, it does not reserve it. The second loop is the actual
> allocation. We speculate the slot we found in the first pass is still available.
> If the second loops fails, then we return emptyconstraints.

Ah, now I see, yes indeed.

> >> +     do {
> >> +             old = cmpxchg(nb->owners+i, NULL, event);
> >> +             if (!old)
> >> +                     break;
> >> +             if (++i == x86_pmu.num_events)
> >> +                     i = 0;
> >> +     } while (i != j);
> >> +skip:
> >> +     if (!old)
> >> +             return &nb->event_constraints[i];
> >> +     return &emptyconstraint;
> >>  }

> >> +
> >> +     /*
> >> +      * function may be called too early in the
> >> +      * boot process, in which case nb_id is bogus
> >> +      *
> >> +      * for BSP, there is an explicit call from
> >> +      * amd_pmu_init()
> >> +      */
> >
> > I keep getting flash-backs to doom's graphics engine every time I see
> > BSP..
> >
> So how do you call the initial boot processor?

boot cpu, or x86 specific, cpu0.

> 
> >> +     nb_id = amd_get_nb_id(cpu);
> >> +     if (nb_id == BAD_APICID)
> >> +             return;
> >> +
> >> +     cpu1 = &per_cpu(cpu_hw_events, cpu);
> >> +     cpu1->amd_nb = NULL;
> >> +
> >> +     raw_spin_lock(&amd_nb_lock);
> >> +
> >> +     for_each_online_cpu(i) {
> >> +             cpu2 = &per_cpu(cpu_hw_events, i);
> >> +             nb = cpu2->amd_nb;
> >> +             if (!nb)
> >> +                     continue;
> >> +             if (nb->nb_id == nb_id)
> >> +                     goto found;
> >> +     }
> >> +
> >> +     nb = amd_alloc_nb(cpu, nb_id);
> >> +     if (!nb) {
> >> +             pr_err("perf_events: failed to allocate NB storage for CPU%d\n", cpu);
> >> +             raw_spin_unlock(&amd_nb_lock);
> >> +             return;
> >> +     }
> >> +found:
> >> +     nb->refcnt++;
> >> +     cpu1->amd_nb = nb;
> >> +
> >> +     raw_spin_unlock(&amd_nb_lock);
> >
> > Can't this be simplified by using the cpu to node mask?
> 
> You mean to find the NB that corresponds to a CPU?

Yep, saves having to poke at all cpus.

> > Also, I think this is buggy in that:
> >
> >  perf_disable();
> >  event->pmu->disable(event);
> >  ...
> >  event->pmu->enable(event);
> >  perf_enable();
> >
> > can now fail, I think we need to move the put_event_constraint() from
> > x86_pmu_disable() into x86_perf_enable() or something.
> 
> Constraints are reserved during x86_scheduling(), not during enable().
> So if you had a conflict it was detected earlier than that.

What I'm worried about is:

CPU A and B are of the same NorthBridge and all node counters are taken.

CPU-A			CPU-B

perf_disable();
event->pmu->disable(event)
  x86_pmu.put_event_constraint() /* free slot n */

			event->pmu->enable(event);
			  x86_schedule_events();
			    x86_pmu.get_event_constraint() /* grab slot n */

event->pmu->enable(event)
  x86_schedule_events()
    x86_pmu.get_event_constraint() /* FAIL */
perf_enable();

That means you cannot disable/enable the same event within a
perf_disable/enable section.

