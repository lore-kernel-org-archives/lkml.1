Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbZKBM4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbZKBM4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 07:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZKBM4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 07:56:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbZKBM4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 07:56:44 -0500
Message-ID: <4AEED70E.4050007@redhat.com>
Date: Mon, 02 Nov 2009 14:56:46 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] Inject asynchronous page fault into a guest if
 page is swapped out.
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-7-git-send-email-gleb@redhat.com>
In-Reply-To: <1257076590-29559-7-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2009 01:56 PM, Gleb Natapov wrote:
> If guest access swapped out memory do not swap it in from vcpu thread
> context. Setup slow work to do swapping and send async page fault to
> a guest.
>
> Allow async page fault injection only when guest is in user mode since
> otherwise guest may be in non-sleepable context and will not be able to
> reschedule.
>    

That loses us page cache accesses, which may be the majority of accesses 
in some workloads.

If we allow the guest to ignore a fault, and ensure that a second access 
to an apf page from the same vcpu doesn't trigger another apf, we can 
simply ignore the apf in a guest when we can't schedule.

Probably best done with an enable bit for kernel-mode apfs.

> Signed-off-by: Gleb Natapov<gleb@redhat.com>
> ---
>   arch/x86/include/asm/kvm_host.h |   20 +++
>   arch/x86/kvm/mmu.c              |  243 ++++++++++++++++++++++++++++++++++++++-
>   arch/x86/kvm/mmutrace.h         |   60 ++++++++++
>   arch/x86/kvm/paging_tmpl.h      |   16 +++-
>   arch/x86/kvm/x86.c              |   22 +++-
>    

Much of the code is generic, please move it to virt/kvm.

> +static void async_pf_execute(struct slow_work *work)
> +{
> +	struct page *page[1];
>    

No need to make it an array, just pass its address.

> +	struct kvm_mmu_async_pf *apf =
> +		container_of(work, struct kvm_mmu_async_pf, work);
> +	wait_queue_head_t *q =&apf->vcpu->wq;
> +
> +	might_sleep();
> +
> +	down_read(&apf->mm->mmap_sem);
> +	get_user_pages(current, apf->mm, apf->addr, 1, 1, 0, page, NULL);
> +	up_read(&apf->mm->mmap_sem);
> +
> +	spin_lock(&apf->vcpu->arch.mmu_async_pf_lock);
> +	list_add_tail(&apf->link,&apf->vcpu->arch.mmu_async_pf_done);
> +	apf->page = page[0];
> +	spin_unlock(&apf->vcpu->arch.mmu_async_pf_lock);
> +
> +	trace_kvm_mmu_async_pf_executed(apf->addr, apf->page, apf->token,
> +					apf->gva);
>    

_completed, but maybe better placed in vcpu context.

> +
> +static bool can_do_async_pf(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_segment kvm_seg;
> +
> +	if (!vcpu->arch.pv_shm ||
> +	    !(vcpu->arch.pv_shm->features&  KVM_PV_SHM_FEATURES_ASYNC_PF) ||
> +	    kvm_event_needs_reinjection(vcpu))
> +		return false;
> +
> +	kvm_get_segment(vcpu,&kvm_seg, VCPU_SREG_CS);
> +
> +	/* is userspace code? TODO check VM86 mode */
> +	return !!(kvm_seg.selector&  3);
>    

There's a ->get_cpl() which is slightly faster.  Note vm86 is perfectly 
fine for async pf.

> +static int setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
> +{
> +	struct kvm_mmu_async_pf *work;
> +
> +	/* setup slow work */
> +
> +	/* do alloc atomic since if we are going to sleep anyway we
> +	   may as well sleep faulting in page */
> +	work = kmem_cache_zalloc(mmu_async_pf_cache, GFP_ATOMIC);
> +	if (!work)
> +		return 0;
> +
> +	atomic_set(&work->used, 1);
> +	work->page = NULL;
> +	work->vcpu = vcpu;
> +	work->gva = gva;
> +	work->addr = gfn_to_hva(vcpu->kvm, gfn);
> +	work->token = (vcpu->arch.async_pf_id++<<  12) | vcpu->vcpu_id;
>    

The shift truncates async_pf_id.

-- 
error compiling committee.c: too many arguments to function

