Return-Path: <linux-kernel-owner+w=401wt.eu-S1758422AbZJGK1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422AbZJGK1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757418AbZJGK1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:27:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322AbZJGK1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:27:03 -0400
Message-ID: <4ACC6C9C.7080707@redhat.com>
Date: Wed, 07 Oct 2009 12:25:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
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
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com> <4ACB0833.2050203@redhat.com> <4ACB9074.1000804@goop.org>
In-Reply-To: <4ACB9074.1000804@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2009 08:46 PM, Jeremy Fitzhardinge wrote:
>
>> Instead of using vgetcpu() and rdtsc() independently, you can use
>> rdtscp to read both atomically.  This removes the need for the preempt
>> notifier.
>>      
> rdtscp first appeared on Intel with Nehalem, so we need to support older
> Intel chips.
>    

We can support them by falling back to the kernel.  I'm a bit worried 
about the kernel playing with the hypervisor's version field.  It's 
better to introduce yet a new version for the kernel, and check both.

> You could use rdscp to get (tsc,cpu) atomically, but that's not
> sufficient to be able to get a consistent snapshot of (tsc, time_info)
> because it doesn't give you the pvclock_vcpu_time_info version number.
> If TSC_AUX contained that too, it might be possible.  Alternatively you
> could compare the tsc with pvclock.tsc_timestamp, but unfortunately the
> ABI doesn't specify that tsc_timestamp is updated in any particular
> order compared to the rest of the fields, so you still can't use that to
> get a consistent snapshot (we can revise the ABI, of course).
>
> So either way it doesn't avoid the need to iterate.  vgetcpu will use
> rdtscp if available, but I agree it is unfortunate we need to do a
> redundant rdtsc in that case.
>
>    

def try_pvclock_vtime():
   tsc, p0 = rdtscp()
   v0 = pvclock[p0].version
   tsc, p = rdtscp()
   t = pvclock_time(pvclock[p], tsc)
   if p != p0 or pvclock[p].version != v0:
      raise Exception("Processor or timebased change under our feet")
   return t

def pvclock_time():
   while True:
     try:
        return try_pvlock_time()
     except:
        pass

So, two rdtscps and two compares.

>>> +    for (cpu = 0; cpu<   nr_cpu_ids; cpu++)
>>> +        pvclock_vsyscall_time_info[cpu].version = ~0;
>>> +
>>> +    __set_fixmap(FIX_PVCLOCK_TIME_INFO,
>>> __pa(pvclock_vsyscall_time_info),
>>> +             PAGE_KERNEL_VSYSCALL);
>>> +
>>> +    preempt_notifier_init(&pvclock_vsyscall_notifier,
>>> +&pvclock_vsyscall_preempt_ops);
>>> +    preempt_notifier_register(&pvclock_vsyscall_notifier);
>>> +
>>>        
>> preempt notifiers are per-thread, not global, and will upset the cycle
>> counters.
>>      
> Ah, so I need to register it on every new thread?  That's a bit awkward.
>    

It's used to manage processor registers, much like the fpu.  If a thread 
uses a register that's not saved and restored by the normal context 
switch code, it can register a preempt notifier to do that instead.

> This is intended to satisfy the cycle-counters who want to do
> gettimeofday a million times a second, where I guess the tradeoff of
> avoiding a pile of syscalls is worth a bit of context-switch overhead.
>    

It's sufficient to increment a version counter on thread migration, no 
need to do it on context switch.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

