Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbZJIUt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbZJIUt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 16:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758971AbZJIUt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 16:49:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758804AbZJIUt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 16:49:56 -0400
Message-ID: <4ACFA14E.9040005@redhat.com>
Date: Fri, 09 Oct 2009 10:47:10 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4: kvm 2/4] Kill the confusing tsc_ref_khz and ref_freq
 variables.
References: <4AC1C59F.6010703@redhat.com> <1254260317-3490-1-git-send-email-zamsden@redhat.com> <1254260317-3490-2-git-send-email-zamsden@redhat.com> <4ACE734D.10600@web.de> <4ACF9C9B.2040006@redhat.com> <4ACF9EC3.2050901@web.de> <4ACF9EDF.5000808@redhat.com> <4ACFA178.2040203@web.de>
In-Reply-To: <4ACFA178.2040203@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2009 10:47 AM, Jan Kiszka wrote:
> Zachary Amsden wrote:
>    
>> On 10/09/2009 10:36 AM, Jan Kiszka wrote:
>>      
>>> Zachary Amsden wrote:
>>>
>>>        
>>>> On 10/08/2009 01:18 PM, Jan Kiszka wrote:
>>>>
>>>>          
>>>>> Zachary Amsden wrote:
>>>>>
>>>>>
>>>>>            
>>>>>> They are globals, not clearly protected by any ordering or locking,
>>>>>> and
>>>>>> vulnerable to various startup races.
>>>>>>
>>>>>> Instead, for variable TSC machines, register the cpufreq notifier and
>>>>>> get
>>>>>> the TSC frequency directly from the cpufreq machinery.  Not only is it
>>>>>> always right, it is also perfectly accurate, as no error prone
>>>>>> measurement
>>>>>> is required.
>>>>>>
>>>>>> On such machines, when a new CPU online is brought online, it isn't
>>>>>> clear what
>>>>>> frequency it will start with, and it may not correspond to the
>>>>>> reference, thus
>>>>>> in hardware_enable we clear the cpu_tsc_khz variable to zero and make
>>>>>> sure
>>>>>> it is set before running on a VCPU.
>>>>>>
>>>>>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>>>>>> ---
>>>>>>     arch/x86/kvm/x86.c |   26 ++++++++++++++++----------
>>>>>>     1 files changed, 16 insertions(+), 10 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>>>> index 15d2ace..de4ce8f 100644
>>>>>> --- a/arch/x86/kvm/x86.c
>>>>>> +++ b/arch/x86/kvm/x86.c
>>>>>> @@ -1326,6 +1326,8 @@ out:
>>>>>>     void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>>>>>     {
>>>>>>         kvm_x86_ops->vcpu_load(vcpu, cpu);
>>>>>> +    if (unlikely(per_cpu(cpu_tsc_khz, cpu) == 0))
>>>>>> +        per_cpu(cpu_tsc_khz, cpu) = cpufreq_quick_get(cpu);
>>>>>>         kvm_request_guest_time_update(vcpu);
>>>>>>     }
>>>>>>
>>>>>> @@ -3061,9 +3063,6 @@ static void bounce_off(void *info)
>>>>>>         /* nothing */
>>>>>>     }
>>>>>>
>>>>>> -static unsigned int  ref_freq;
>>>>>> -static unsigned long tsc_khz_ref;
>>>>>> -
>>>>>>     static int kvmclock_cpufreq_notifier(struct notifier_block *nb,
>>>>>> unsigned long val,
>>>>>>                          void *data)
>>>>>>     {
>>>>>> @@ -3072,14 +3071,11 @@ static int kvmclock_cpufreq_notifier(struct
>>>>>> notifier_block *nb, unsigned long va
>>>>>>         struct kvm_vcpu *vcpu;
>>>>>>         int i, send_ipi = 0;
>>>>>>
>>>>>> -    if (!ref_freq)
>>>>>> -        ref_freq = freq->old;
>>>>>> -
>>>>>>         if (val == CPUFREQ_PRECHANGE&&    freq->old>    freq->new)
>>>>>>             return 0;
>>>>>>         if (val == CPUFREQ_POSTCHANGE&&    freq->old<    freq->new)
>>>>>>             return 0;
>>>>>> -    per_cpu(cpu_tsc_khz, freq->cpu) = cpufreq_scale(tsc_khz_ref,
>>>>>> ref_freq, freq->new);
>>>>>> +    per_cpu(cpu_tsc_khz, freq->cpu) = freq->new;
>>>>>>
>>>>>>         spin_lock(&kvm_lock);
>>>>>>         list_for_each_entry(kvm,&vm_list, vm_list) {
>>>>>> @@ -3120,12 +3116,14 @@ static void kvm_timer_init(void)
>>>>>>     {
>>>>>>         int cpu;
>>>>>>
>>>>>> -    for_each_possible_cpu(cpu)
>>>>>> -        per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
>>>>>>         if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
>>>>>> -        tsc_khz_ref = tsc_khz;
>>>>>>             cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
>>>>>>                           CPUFREQ_TRANSITION_NOTIFIER);
>>>>>> +        for_each_online_cpu(cpu)
>>>>>> +            per_cpu(cpu_tsc_khz, cpu) = cpufreq_get(cpu);
>>>>>>
>>>>>>
>>>>>>              
>>>>> This doesn't build for !CONFIG_CPU_FREQ.
>>>>>
>>>>>
>>>>>            
>>>> And did it before?
>>>>
>>>>          
>>> Yes, because cpufreq_get, which is undefined without CONFIG_CPU_FREQ,
>>> did not exist so far. One may argue that this is a deficit of the
>>> cpufreq API. However, it needs fixing.
>>>
>>>        
>> I'll send a patch today.  I'm going with API deficient and will fix
>> that, but this means I will also require a fix for kvm-kmod :(
>>      
> That won't be tricky, I will queue up a fix.
>
> BTW, is the KVM prepared for cpufreq_get returning 0?
>    

That will be part of the fix, I think.

