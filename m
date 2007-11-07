Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbXKGFun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbXKGFun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 00:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXKGFuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 00:50:35 -0500
Received: from il.qumranet.com ([82.166.9.18]:42842 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbXKGFue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 00:50:34 -0500
Message-ID: <47315229.1010502@qumranet.com>
Date: Wed, 07 Nov 2007 07:50:33 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, jeremy@goop.org, aliguori@us.ibm.com,
       kvm-devel@lists.sourceforge.net, hollisb@us.ibm.com
Subject: Re: kvmclock - the host part.
References: <11943875362987-git-send-email-gcosta@redhat.com> <11943875433821-git-send-email-gcosta@redhat.com> <11943875471622-git-send-email-gcosta@redhat.com>
In-Reply-To: <11943875471622-git-send-email-gcosta@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 07 Nov 2007 07:50:33 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> This is the host part of kvm clocksource implementation. As it does
> not include clockevents, it is a fairly simple implementation. We
> only have to register a per-vcpu area, and start writting to it periodically.
>
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> ---
>  drivers/kvm/irq.c      |    1 +
>  drivers/kvm/kvm_main.c |    2 +
>  drivers/kvm/svm.c      |    1 +
>  drivers/kvm/vmx.c      |    1 +
>  drivers/kvm/x86.c      |   59 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/kvm/x86.h      |   13 ++++++++++
>  6 files changed, 77 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/kvm/irq.c b/drivers/kvm/irq.c
> index 22bfeee..0344879 100644
> --- a/drivers/kvm/irq.c
> +++ b/drivers/kvm/irq.c
> @@ -92,6 +92,7 @@ void kvm_vcpu_kick_request(struct kvm_vcpu *vcpu, int request)
>  
>  void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu)
>  {
> +	vcpu->time_needs_update = 1;
>   

Why here and not in __vcpu_run()?  It isn't timer irq related.

> @@ -1242,6 +1243,7 @@ static long kvm_dev_ioctl(struct file *filp,
>  		case KVM_CAP_MMU_SHADOW_CACHE_CONTROL:
>  		case KVM_CAP_USER_MEMORY:
>  		case KVM_CAP_SET_TSS_ADDR:
> +		case KVM_CAP_CLK:
>   

It's just a clock source now, right?  so _CLOCK_SOURCE.

>  
> +static void kvm_write_guest_time(struct kvm_vcpu *vcpu)
> +{
> +	struct timespec ts;
> +	void *clock_addr;
> +
> +
> +	if (!vcpu->clock_page)
> +		return;
> +
> +	/* Updates version to the next odd number, indicating we're writing */
> +	vcpu->hv_clock.version++;
>   

No one can actually see this as you're updating a private structure. 
You need to copy it to guestspace.

> +	/* Updating the tsc count is the first thing we do */
> +	kvm_get_msr(vcpu, MSR_IA32_TIME_STAMP_COUNTER, &vcpu->hv_clock.last_tsc);
> +	ktime_get_ts(&ts);
> +	vcpu->hv_clock.now_ns = ts.tv_nsec + (NSEC_PER_SEC * (u64)ts.tv_sec);
> +	vcpu->hv_clock.wc_sec = get_seconds();
> +	vcpu->hv_clock.version++;
> +
> +	clock_addr = vcpu->clock_addr;
> +	memcpy(clock_addr, &vcpu->hv_clock, sizeof(vcpu->hv_clock));
> +	mark_page_dirty(vcpu->kvm, vcpu->clock_gfn);
>   

Just use kvm_write_guest().

> +
> +	vcpu->time_needs_update = 0;
> +}
> +
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long nr, a0, a1, a2, a3, ret;
> @@ -1648,7 +1674,33 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  		a3 &= 0xFFFFFFFF;
>  	}
>  
> +	ret = 0;
>  	switch (nr) {
> +	case  KVM_HCALL_REGISTER_CLOCK: {
> +		struct kvm_vcpu *dst_vcpu;
> +
> +		if (!((a1 < KVM_MAX_VCPUS) && (vcpu->kvm->vcpus[a1]))) {
> +			ret = -KVM_EINVAL;
> +			break;
> +		}
> +
> +		dst_vcpu = vcpu->kvm->vcpus[a1];
>   

What if !dst_vcpu?  What about locking?

Suggest simply using vcpu.  Every guest cpu can register its own
clocksource.

> +		dst_vcpu->clock_page = gfn_to_page(vcpu->kvm, a0 >> PAGE_SHIFT);
>   

Shift right?  Why?

> +
> +		if (!dst_vcpu->clock_page) {
>   

IIRC gfn_to_page() never returns NULL, need a different check.

> +			ret = -KVM_EINVAL;
> +			break;
> +		}
> +		dst_vcpu->clock_gfn = a0 >> PAGE_SHIFT;
> +
> +		dst_vcpu->hv_clock.tsc_mult = clocksource_khz2mult(tsc_khz, 22);
> +		dst_vcpu->clock_addr = kmap(dst_vcpu->clock_page);
>   

kmap() is bad since the page can move due to swapping. 
kvm_write_guest() is your friend.

> +static inline void release_clock(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu->clock_page)
> +		kunmap(vcpu->clock_page);
> +}
>   


While it's a static inline, please prefix with kvm_ in case one day it
isn't.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

