Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab0BDQch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:32:37 -0500
Received: from smtp-out.google.com ([216.239.44.51]:13840 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab0BDQcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:32:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=py0fA5fDEuRlJzjW3kVa2A7T0J/BEkjSiytz+eeB7hv1sO4TuL2bBsaYOjvuO9IA9
	92qH62JG3voImYDCYB0nQ==
MIME-Version: 1.0
In-Reply-To: <1265300375.22001.102.camel@laptop>
References: <4b674594.0a04d00a.6005.2567@mx.google.com>
	 <1265295302.24455.2265.camel@laptop>
	 <bd4cb8901002040805k759ae239q80e42f8ac4cc0e0e@mail.gmail.com>
	 <1265300375.22001.102.camel@laptop>
Date: Thu, 4 Feb 2010 17:32:31 +0100
Message-ID: <bd4cb8901002040832h15bbabfctd216fa07a94a78e6@mail.gmail.com>
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

>> >> +     nb_id = amd_get_nb_id(cpu);
>> >> +     if (nb_id == BAD_APICID)
>> >> +             return;
>> >> +
>> >> +     cpu1 = &per_cpu(cpu_hw_events, cpu);
>> >> +     cpu1->amd_nb = NULL;
>> >> +
>> >> +     raw_spin_lock(&amd_nb_lock);
>> >> +
>> >> +     for_each_online_cpu(i) {
>> >> +             cpu2 = &per_cpu(cpu_hw_events, i);
>> >> +             nb = cpu2->amd_nb;
>> >> +             if (!nb)
>> >> +                     continue;
>> >> +             if (nb->nb_id == nb_id)
>> >> +                     goto found;
>> >> +     }
>> >> +
>> >> +     nb = amd_alloc_nb(cpu, nb_id);
>> >> +     if (!nb) {
>> >> +             pr_err("perf_events: failed to allocate NB storage for CPU%d\n", cpu);
>> >> +             raw_spin_unlock(&amd_nb_lock);
>> >> +             return;
>> >> +     }
>> >> +found:
>> >> +     nb->refcnt++;
>> >> +     cpu1->amd_nb = nb;
>> >> +
>> >> +     raw_spin_unlock(&amd_nb_lock);
>> >
>> > Can't this be simplified by using the cpu to node mask?
>>
>> You mean to find the NB that corresponds to a CPU?
>
> Yep, saves having to poke at all cpus.

That's not what the loop is about.

amd_get_nb_id() is the function which returns the id
of the NB based on cpu. It is not clear to me whether
NB and NUMA node always perfectly overlap. What
matter here is the HW config, not how NUMA nodes
were setup.

We allocate one amd_nb struct per NB. Once we get
our NB, we need to find if it has already been allocated
and refcnt++, otherwise we must allocate it.

>> > Also, I think this is buggy in that:
>> >
>> >  perf_disable();
>> >  event->pmu->disable(event);
>> >  ...
>> >  event->pmu->enable(event);
>> >  perf_enable();
>> >
>> > can now fail, I think we need to move the put_event_constraint() from
>> > x86_pmu_disable() into x86_perf_enable() or something.
>>
>> Constraints are reserved during x86_scheduling(), not during enable().
>> So if you had a conflict it was detected earlier than that.
>
> What I'm worried about is:
>
> CPU A and B are of the same NorthBridge and all node counters are taken.
>
> CPU-A                   CPU-B
>
> perf_disable();
> event->pmu->disable(event)
>  x86_pmu.put_event_constraint() /* free slot n */
>
>                        event->pmu->enable(event);
>                          x86_schedule_events();
>                            x86_pmu.get_event_constraint() /* grab slot n */
>
> event->pmu->enable(event)
>  x86_schedule_events()
>    x86_pmu.get_event_constraint() /* FAIL */
> perf_enable();
>
> That means you cannot disable/enable the same event within a
> perf_disable/enable section.
>
Yes but I would say that is because of the logic behind the enable/disable
interface. Here you are disabling "for a short period", you know you're going
to re-enable. Yet you are using an API that is a generic enable/disable.
You would need to pass some argument to disable() to say "temporary"
or "stop but don't release the resource".
