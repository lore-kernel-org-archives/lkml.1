Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab0BJKiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 05:38:14 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:48553 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab0BJKiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 05:38:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xUG9PfHmK2MKYjzc7svqIOlzUVZ0OzZc424lCm09+bPVhL1JACQg7tyN6m+CN6rMwh
         MLZFizB4GwD+05s26GChnhHgCneAKqcUbv6Q6/nRxMmIHwt8priCbPT/Wx7B0G9Z2hJE
         PfXP0rlcxE8rkIvS0ZDTfE9/ueCHsZibk1suI=
MIME-Version: 1.0
In-Reply-To: <1265796732.11509.260.camel@laptop>
References: <20100208184504.GB5130@lenovo> <20100209041739.GA11280@elte.hu>
	 <20100209223909.GE5068@lenovo> <1265796732.11509.260.camel@laptop>
Date: Wed, 10 Feb 2010 13:38:10 +0300
Message-ID: <aa79d98a1002100238v256ca6daw5e00c8b6d8dc4bb6@mail.gmail.com>
Subject: Re: [RFC perf,x86] P4 PMU early draft
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/10/10, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-02-10 at 01:39 +0300, Cyrill Gorcunov wrote:
>
>
>> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
>> =====================================================================
>> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
>> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
>> @@ -26,6 +26,7 @@
>>  #include <linux/bitops.h>
>>
>>  #include <asm/apic.h>
>> +#include <asm/perf_p4.h>
>>  #include <asm/stacktrace.h>
>>  #include <asm/nmi.h>
>>
>> @@ -140,6 +141,7 @@ struct x86_pmu {
>>  	u64		max_period;
>>  	u64		intel_ctrl;
>>  	int		(*hw_config)(struct perf_event_attr *attr, struct hw_perf_event
>> *hwc);
>> +	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign,
>> int cpu);
>>  	void		(*enable_bts)(u64 config);
>>  	void		(*disable_bts)(void);
>>
>
>> +/*
>> + * This is the most important routine of Netburst PMU actually
>> + * and need a huge speedup!
>> + */
>> +static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int
>> *assign, int cpu)
>> +{
>
>> +}
>
>
>> -static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int
>> *assign)
>> +/* we don't use cpu argument here at all */
>> +static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int
>> *assign, int cpu)
>>  {
>>  	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
>>  	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
>
>
>> @@ -1796,7 +2305,7 @@ static int x86_pmu_enable(struct perf_ev
>>  	if (n < 0)
>>  		return n;
>>
>> -	ret = x86_schedule_events(cpuc, n, assign);
>> +	ret = x86_pmu.schedule_events(cpuc, n, assign, 0);
>>  	if (ret)
>>  		return ret;
>>  	/*
>
> This look like a bug, surely we can run on !cpu0.

Definitely! Thanks! It should be smp_processor_id()

>
>> @@ -2313,7 +2822,7 @@ int hw_perf_group_sched_in(struct perf_e
>>  	if (n0 < 0)
>>  		return n0;
>>
>> -	ret = x86_schedule_events(cpuc, n0, assign);
>> +	ret = x86_pmu.schedule_events(cpuc, n0, assign, cpu);
>>  	if (ret)
>>  		return ret;
>>
>
> I'd try BUG_ON(cpu != smp_processor_id()) and scrap passing that cpu
> thing around.
>

no, i need cpu to find out if event has migrated from other thread and
then i switch
some thread dependant flags in hw::config (ie escr and cccr), or i
miss something and events in one cpu just can't migrate to another
cpu?

>> @@ -2700,6 +3232,7 @@ static int validate_group(struct perf_ev
>>  {
>>  	struct perf_event *leader = event->group_leader;
>>  	struct cpu_hw_events *fake_cpuc;
>> +	int cpu = smp_processor_id();
>>  	int ret, n;
>>
>>  	ret = -ENOMEM;
>> @@ -2725,7 +3258,7 @@ static int validate_group(struct perf_ev
>>
>>  	fake_cpuc->n_events = n;
>>
>> -	ret = x86_schedule_events(fake_cpuc, n, NULL);
>> +	ret = x86_pmu.schedule_events(fake_cpuc, n, NULL, cpu);
>>
>>  out_free:
>>  	kfree(fake_cpuc);
>
>
>
