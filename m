Return-Path: <linux-kernel-owner+w=401wt.eu-S932990AbXGWLQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990AbXGWLQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 07:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760525AbXGWLQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 07:16:29 -0400
Received: from il.qumranet.com ([82.166.9.18]:33997 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759748AbXGWLQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 07:16:28 -0400
Message-ID: <46A48E15.3030200@qumranet.com>
Date: Mon, 23 Jul 2007 14:16:37 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 6/8]KVM: introduce kvm_mmu_zap_pagetbl
References: <1185173503.2645.70.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1185173503.2645.70.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> add a routine to zap all shadow pgtble for a gfn. If kvm supports SMP,
> the API should zap pgtble for all vcpus, but kvm shadow page table
> really should be per-vm, instead of per-vcpu.
>
>   

kvm shadow page tables _are_ per-vm.  Current kvm.git even makes that 
more explicit where functions that remove stuff (like rmap_remove()) 
don't require a vcpu.


> Index: linux/drivers/kvm/kvm.h
> ===================================================================
> --- linux.orig/drivers/kvm/kvm.h	2007-07-20 14:19:15.000000000 +0800
> +++ linux/drivers/kvm/kvm.h	2007-07-20 14:26:10.000000000 +0800
> @@ -621,6 +621,7 @@ int kvm_mmu_unprotect_page_virt(struct k
>  void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
>  int kvm_mmu_load(struct kvm_vcpu *vcpu);
>  void kvm_mmu_unload(struct kvm_vcpu *vcpu);
> +void kvm_mmu_zap_pagetbl(struct kvm_vcpu *vcpu, u64 gfn);
>  
>  int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  
> Index: linux/drivers/kvm/mmu.c
> ===================================================================
> --- linux.orig/drivers/kvm/mmu.c	2007-07-20 14:25:25.000000000 +0800
> +++ linux/drivers/kvm/mmu.c	2007-07-20 14:26:10.000000000 +0800
> @@ -1324,6 +1324,34 @@ void kvm_mmu_zap_all(struct kvm_vcpu *vc
>  	init_kvm_mmu(vcpu);
>  }
>  
> +/* FIXME: this should zap all vcpu's shadow pgtbl for gfn */
> +void kvm_mmu_zap_pagetbl(struct kvm_vcpu *vcpu, u64 gfn)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_rmap_desc *desc;
> +	struct page *page;
> +	u64 *spte;
> +
> +	page = gfn_to_page(kvm, gfn);
> +	BUG_ON(!page);
> +
> +	while (page_private(page)) {
> +		if (!(page_private(page) & 1))
> +			spte = (u64 *)page_private(page);
> +		else {
> +			desc = (struct kvm_rmap_desc *)(page_private(page) & ~1ul);
> +			spte = desc->shadow_ptes[0];
> +		}
> +		BUG_ON(!spte);
> +		BUG_ON((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT
> +			!= page_to_pfn(page));
> +		BUG_ON(!(*spte & PT_PRESENT_MASK));
> +		rmap_remove(vcpu, spte);
> +		*spte = 0;
> +	}
> +	kvm_flush_remote_tlbs(vcpu->kvm);
> +}
> +

Suggest kvm_mmu_unmap_page() as a name for this.


-- 
error compiling committee.c: too many arguments to function

