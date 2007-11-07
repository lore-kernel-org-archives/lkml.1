Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbXKGOAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbXKGOAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbXKGOAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:00:46 -0500
Received: from il.qumranet.com ([82.166.9.18]:34916 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbXKGOAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:00:45 -0500
Message-ID: <4731C4D1.7040101@qumranet.com>
Date: Wed, 07 Nov 2007 15:59:45 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, jeremy@goop.org, aliguori@us.ibm.com,
       kvm-devel@lists.sourceforge.net, hollisb@us.ibm.com
Subject: Re: kvmclock - the host part.
References: <11943875362987-git-send-email-gcosta@redhat.com> <11943875433821-git-send-email-gcosta@redhat.com> <11943875471622-git-send-email-gcosta@redhat.com> <47315229.1010502@qumranet.com> <4731B8C3.6090409@redhat.com>
In-Reply-To: <4731B8C3.6090409@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
>>>  void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu)
>>>  {
>>> +	vcpu->time_needs_update = 1;
>>>   
>>>       
>> Why here and not in __vcpu_run()?  It isn't timer irq related.
>>     
> Because my plan was exactly, updating it at each timer interrupt.
>   

I think kvm_inject_pending_timer_irqs() is called every __vcpu_run(), so 
your cunning plan has been foiled.

Did you mean each guest interrupt of host interrupt?

> There's a trade off between
> updating every run (hopefully more precision, but more overhead), versus
> updating at timer irqs, or other events.
>
> What would you prefer?
>   

I think that we should update it every time a heavyweight exit has been 
taken.  That takes care of the tradeoff quite nicely -- heavyweight 
exits are already dog slow.

>   
>
>>> +	/* Updating the tsc count is the first thing we do */
>>> +	kvm_get_msr(vcpu, MSR_IA32_TIME_STAMP_COUNTER, &vcpu->hv_clock.last_tsc);
>>> +	ktime_get_ts(&ts);
>>> +	vcpu->hv_clock.now_ns = ts.tv_nsec + (NSEC_PER_SEC * (u64)ts.tv_sec);
>>> +	vcpu->hv_clock.wc_sec = get_seconds();
>>> +	vcpu->hv_clock.version++;
>>> +
>>> +	clock_addr = vcpu->clock_addr;
>>> +	memcpy(clock_addr, &vcpu->hv_clock, sizeof(vcpu->hv_clock));
>>> +	mark_page_dirty(vcpu->kvm, vcpu->clock_gfn);
>>>   
>>>       
>> Just use kvm_write_guest().
>>     
> Too slow. Updating guest time, even only in timer interrupts, was a too
> frequent operation, and the kmap / kunmap (atomic) at every iteration
> deemed the whole thing
> unusable.
>   

kvm_write_guest() will eventually be a copy_to_user(), so you need not 
fear the overhead.


>>>  
>>> +	ret = 0;
>>>  	switch (nr) {
>>> +	case  KVM_HCALL_REGISTER_CLOCK: {
>>> +		struct kvm_vcpu *dst_vcpu;
>>> +
>>> +		if (!((a1 < KVM_MAX_VCPUS) && (vcpu->kvm->vcpus[a1]))) {
>>> +			ret = -KVM_EINVAL;
>>> +			break;
>>> +		}
>>> +
>>> +		dst_vcpu = vcpu->kvm->vcpus[a1];
>>>   
>>>       
>> What if !dst_vcpu?  What about locking?
>>
>> Suggest simply using vcpu.  Every guest cpu can register its own
>>     
> Earlier version had a check for !dst_vcpu, you are absolutely right.
>
> Locking was not a problem in practice, because these operations are done
>  serialized, by the same cpu.
>   

Think evil guest that cares not for the well-being of the host.

> This hypercall is called by cpu_up, which, at least in the beginning,
> it's called by cpu0. And that's why each vcpu cannot register its own.
> (And why we don't need locking).
>
> Well, theorectically each vcpu do can register its own clocksource, it
> will just be a little bit more complicated, we have to fire out an IPI,
> and have the other cpu to catch it, and call the hypercall.
>
>   

Can it not be done via the processor startup sequence?  Then there's no 
need for ipis and locking.

I imagine a normal guest initializes the apic in the same way.

> But I honestly don't like it.
> Usually, the cpu leaves start_secondary with a clock already registered,
> so the kernel relies on it.
>
>   
>>> +		dst_vcpu->clock_page = gfn_to_page(vcpu->kvm, a0 >> PAGE_SHIFT);
>>>   
>>>       
>> Shift right?  Why?
>>     
> a0 is not a gfn, but a physical address.
>   

What if the guest wants to place it in address 5GB?  That's unlikely for 
Linux and Windows, but let's do it right anyway.

-- 
error compiling committee.c: too many arguments to function

