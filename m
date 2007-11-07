Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbXKGNHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbXKGNHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbXKGNHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:07:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbXKGNHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:07:21 -0500
Message-ID: <4731B8C3.6090409@redhat.com>
Date: Wed, 07 Nov 2007 11:08:19 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: linux-kernel@vger.kernel.org, jeremy@goop.org, aliguori@us.ibm.com,
       kvm-devel@lists.sourceforge.net, hollisb@us.ibm.com
Subject: Re: kvmclock - the host part.
References: <11943875362987-git-send-email-gcosta@redhat.com> <11943875433821-git-send-email-gcosta@redhat.com> <11943875471622-git-send-email-gcosta@redhat.com> <47315229.1010502@qumranet.com>
In-Reply-To: <47315229.1010502@qumranet.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Avi Kivity escreveu:
> Glauber de Oliveira Costa wrote:
>> This is the host part of kvm clocksource implementation. As it does
>> not include clockevents, it is a fairly simple implementation. We
>> only have to register a per-vcpu area, and start writting to it periodically.
>>
>> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
>> ---
>>  drivers/kvm/irq.c      |    1 +
>>  drivers/kvm/kvm_main.c |    2 +
>>  drivers/kvm/svm.c      |    1 +
>>  drivers/kvm/vmx.c      |    1 +
>>  drivers/kvm/x86.c      |   59 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/kvm/x86.h      |   13 ++++++++++
>>  6 files changed, 77 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/kvm/irq.c b/drivers/kvm/irq.c
>> index 22bfeee..0344879 100644
>> --- a/drivers/kvm/irq.c
>> +++ b/drivers/kvm/irq.c
>> @@ -92,6 +92,7 @@ void kvm_vcpu_kick_request(struct kvm_vcpu *vcpu, int request)
>>  
>>  void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu)
>>  {
>> +	vcpu->time_needs_update = 1;
>>   
> 
> Why here and not in __vcpu_run()?  It isn't timer irq related.
Because my plan was exactly, updating it at each timer interrupt.
There's a trade off between
updating every run (hopefully more precision, but more overhead), versus
updating at timer irqs, or other events.

What would you prefer?

>> @@ -1242,6 +1243,7 @@ static long kvm_dev_ioctl(struct file *filp,
>>  		case KVM_CAP_MMU_SHADOW_CACHE_CONTROL:
>>  		case KVM_CAP_USER_MEMORY:
>>  		case KVM_CAP_SET_TSS_ADDR:
>> +		case KVM_CAP_CLK:
>>   
> 
> It's just a clock source now, right?  so _CLOCK_SOURCE.
Right.

>> +static void kvm_write_guest_time(struct kvm_vcpu *vcpu)
>> +{
>> +	struct timespec ts;
>> +	void *clock_addr;
>> +
>> +
>> +	if (!vcpu->clock_page)
>> +		return;
>> +
>> +	/* Updates version to the next odd number, indicating we're writing */
>> +	vcpu->hv_clock.version++;
>>   
> 
> No one can actually see this as you're updating a private structure. 
> You need to copy it to guestspace.
That's true, I'm just copying it at the end, the whole thing. thanks.

>> +	/* Updating the tsc count is the first thing we do */
>> +	kvm_get_msr(vcpu, MSR_IA32_TIME_STAMP_COUNTER, &vcpu->hv_clock.last_tsc);
>> +	ktime_get_ts(&ts);
>> +	vcpu->hv_clock.now_ns = ts.tv_nsec + (NSEC_PER_SEC * (u64)ts.tv_sec);
>> +	vcpu->hv_clock.wc_sec = get_seconds();
>> +	vcpu->hv_clock.version++;
>> +
>> +	clock_addr = vcpu->clock_addr;
>> +	memcpy(clock_addr, &vcpu->hv_clock, sizeof(vcpu->hv_clock));
>> +	mark_page_dirty(vcpu->kvm, vcpu->clock_gfn);
>>   
> 
> Just use kvm_write_guest().
Too slow. Updating guest time, even only in timer interrupts, was a too
frequent operation, and the kmap / kunmap (atomic) at every iteration
deemed the whole thing
unusable.

>> +
>> +	vcpu->time_needs_update = 0;
>> +}
>> +
>>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>  {
>>  	unsigned long nr, a0, a1, a2, a3, ret;
>> @@ -1648,7 +1674,33 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>  		a3 &= 0xFFFFFFFF;
>>  	}
>>  
>> +	ret = 0;
>>  	switch (nr) {
>> +	case  KVM_HCALL_REGISTER_CLOCK: {
>> +		struct kvm_vcpu *dst_vcpu;
>> +
>> +		if (!((a1 < KVM_MAX_VCPUS) && (vcpu->kvm->vcpus[a1]))) {
>> +			ret = -KVM_EINVAL;
>> +			break;
>> +		}
>> +
>> +		dst_vcpu = vcpu->kvm->vcpus[a1];
>>   
> 
> What if !dst_vcpu?  What about locking?
> 
> Suggest simply using vcpu.  Every guest cpu can register its own
Earlier version had a check for !dst_vcpu, you are absolutely right.

Locking was not a problem in practice, because these operations are done
 serialized, by the same cpu.

This hypercall is called by cpu_up, which, at least in the beginning,
it's called by cpu0. And that's why each vcpu cannot register its own.
(And why we don't need locking).

Well, theorectically each vcpu do can register its own clocksource, it
will just be a little bit more complicated, we have to fire out an IPI,
and have the other cpu to catch it, and call the hypercall.

But I honestly don't like it.
Usually, the cpu leaves start_secondary with a clock already registered,
so the kernel relies on it.

> 
>> +		dst_vcpu->clock_page = gfn_to_page(vcpu->kvm, a0 >> PAGE_SHIFT);
>>   
> 
> Shift right?  Why?
a0 is not a gfn, but a physical address.

>> +
>> +		if (!dst_vcpu->clock_page) {
>>   
> 
> IIRC gfn_to_page() never returns NULL, need a different check.
You are right. I developed part of it in an older version of kvm, where
reality was:

struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
{
        struct kvm_memory_slot *slot;

        gfn = unalias_gfn(kvm, gfn);
        slot = __gfn_to_memslot(kvm, gfn);
        if (!slot)
                return NULL;
        return slot->phys_mem[gfn - slot->base_gfn];
}

Will update.

>> +			ret = -KVM_EINVAL;
>> +			break;
>> +		}
>> +		dst_vcpu->clock_gfn = a0 >> PAGE_SHIFT;
>> +
>> +		dst_vcpu->hv_clock.tsc_mult = clocksource_khz2mult(tsc_khz, 22);
>> +		dst_vcpu->clock_addr = kmap(dst_vcpu->clock_page);
>>   
> 
> kmap() is bad since the page can move due to swapping. 
> kvm_write_guest() is your friend.
Yeah , right, but again: It will be slow to the point of making the
whole thing not worthy. So what alternatives do we get?

>> +static inline void release_clock(struct kvm_vcpu *vcpu)
>> +{
>> +	if (vcpu->clock_page)
>> +		kunmap(vcpu->clock_page);
>> +}
>>   
> 
> 
> While it's a static inline, please prefix with kvm_ in case one day it
> isn't.
> 

Okay, will do.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHMbjDjYI8LaFUWXMRAvcnAKCZOtPqHAxvcUkAfSaOezPWq1ib2wCg1TNz
fT1rt86/j25K/6lmFsRmbI0=
=nSkW
-----END PGP SIGNATURE-----
