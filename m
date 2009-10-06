Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbZJFSqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbZJFSqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756957AbZJFSqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:46:52 -0400
Received: from claw.goop.org ([74.207.240.146]:59779 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639AbZJFSqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:46:51 -0400
Message-ID: <4ACB9074.1000804@goop.org>
Date: Tue, 06 Oct 2009 11:46:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Zach Brown <zach.brown@oracle.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall implementation
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com> <4ACB0833.2050203@redhat.com>
In-Reply-To: <4ACB0833.2050203@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/09 02:04, Avi Kivity wrote:
> On 10/06/2009 02:50 AM, Jeremy Fitzhardinge wrote:
>> This patch allows the pvclock mechanism to be used in usermode.  To
>> do this, we map an extra page into usermode containing an array of
>> pvclock_vcpu_time_info structures which give the information required
>> to compute a global system clock from the tsc.  With this, we can
>> implement pvclock_clocksource_vread().
>>
>> One complication is that usermode is subject to two levels of
>> scheduling:
>> kernel scheduling of tasks onto vcpus, and hypervisor scheduling of
>> vcpus onto pcpus.  In either case the underlying pcpu changed, and with
>> it, the correct set of parameters to compute tsc->system clock.  To
>> address this we install a preempt notifier on sched_out to increment
>> that vcpu's version number.  Usermode can then check the version number
>> is unchanged while computing the time and retry if it has (the only
>> difference from the kernel's version of the algorithm is that the vcpu
>> may have changed, so we may need to switch pvclock_vcpu_time_info
>> structures.
>>
>> To use this feature, hypervisor-specific code is required
>> to call pvclock_init_vsyscall(), and if successful:
>>   - cause the pvclock_vcpu_time_info structure at
>>     pvclock_get_vsyscall_time_info(cpu) to be updated appropriately for
>>     each vcpu.
>>   - use pvclock_clocksource_vread as the implementation of clocksource
>>     .vread.
>>
>> +
>> +cycle_t __vsyscall_fn pvclock_clocksource_vread(void)
>> +{
>> +    const struct pvclock_vcpu_time_info *pvti_base;
>> +    const struct pvclock_vcpu_time_info *pvti;
>> +    cycle_t ret;
>> +    u32 version;
>> +
>> +    pvti_base = (struct pvclock_vcpu_time_info
>> *)fix_to_virt(FIX_PVCLOCK_TIME_INFO);
>> +
>> +    /*
>> +     * When looping to get a consistent (time-info, tsc) pair, we
>> +     * also need to deal with the possibility we can switch vcpus,
>> +     * so make sure we always re-fetch time-info for the current vcpu.
>> +     */
>> +    do {
>> +        unsigned cpu;
>> +
>> +        vgetcpu(&cpu, NULL, NULL);
>> +        pvti =&pvti_base[cpu];
>> +
>> +        version = __pvclock_read_cycles(pvti,&ret);
>> +    } while (unlikely(pvti->version != version));
>> +
>> +    return ret;
>> +}
>>    
>
> Instead of using vgetcpu() and rdtsc() independently, you can use
> rdtscp to read both atomically.  This removes the need for the preempt
> notifier.

rdtscp first appeared on Intel with Nehalem, so we need to support older
Intel chips.

You could use rdscp to get (tsc,cpu) atomically, but that's not
sufficient to be able to get a consistent snapshot of (tsc, time_info)
because it doesn't give you the pvclock_vcpu_time_info version number. 
If TSC_AUX contained that too, it might be possible.  Alternatively you
could compare the tsc with pvclock.tsc_timestamp, but unfortunately the
ABI doesn't specify that tsc_timestamp is updated in any particular
order compared to the rest of the fields, so you still can't use that to
get a consistent snapshot (we can revise the ABI, of course).

So either way it doesn't avoid the need to iterate.  vgetcpu will use
rdtscp if available, but I agree it is unfortunate we need to do a
redundant rdtsc in that case.

Avoiding the preempt notifier would be nice.  Definitely worth a
followup-patch.

>> +
>> +/*
>> + * Initialize the generic pvclock vsyscall state.  This will allocate
>> + * a/some page(s) for the per-vcpu pvclock information, set up a
>> + * fixmap mapping for the page(s)
>> + */
>> +int __init pvclock_init_vsyscall(void)
>> +{
>> +    int cpu;
>> +
>> +    /* Just one page for now */
>> +    if (nr_cpu_ids * sizeof(struct vcpu_time_info)>  PAGE_SIZE) {
>> +        printk(KERN_WARNING "pvclock_vsyscall: too many CPUs to fit
>> time_info into a single page\n");
>> +        return -ENOSPC;
>> +    }
>> +
>> +    pvclock_vsyscall_time_info =
>> +        (struct pvclock_vcpu_time_info *)get_zeroed_page(GFP_KERNEL);
>> +    if (pvclock_vsyscall_time_info == NULL)
>> +        return -ENOMEM;
>> +
>>    
>
> Need to align the vcpu_time_infos on a cacheline boundary.

OK.

>> +    for (cpu = 0; cpu<  nr_cpu_ids; cpu++)
>> +        pvclock_vsyscall_time_info[cpu].version = ~0;
>> +
>> +    __set_fixmap(FIX_PVCLOCK_TIME_INFO,
>> __pa(pvclock_vsyscall_time_info),
>> +             PAGE_KERNEL_VSYSCALL);
>> +
>> +    preempt_notifier_init(&pvclock_vsyscall_notifier,
>> +            &pvclock_vsyscall_preempt_ops);
>> +    preempt_notifier_register(&pvclock_vsyscall_notifier);
>> +
>>    
>
> preempt notifiers are per-thread, not global, and will upset the cycle
> counters.

Ah, so I need to register it on every new thread?  That's a bit awkward.

This is intended to satisfy the cycle-counters who want to do
gettimeofday a million times a second, where I guess the tradeoff of
avoiding a pile of syscalls is worth a bit of context-switch overhead.

>   I'd drop them and use rdtscp instead (and give up if the processor
> doesn't support it).
>

None of my test machines have rdtscp, so that won't do ;)

    J
