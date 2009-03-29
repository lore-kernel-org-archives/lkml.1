Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZC2LuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZC2LuB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 07:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZC2Ltt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 07:49:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55857 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbZC2Lts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 07:49:48 -0400
Message-ID: <49CF6058.9030303@redhat.com>
Date: Sun, 29 Mar 2009 14:49:44 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] kvm mmu: add support for 1GB pages to direct mapping
 paths
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com> <1238164319-16092-6-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1238164319-16092-6-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> This patch makes the MMU path for TDP aware of 1GB pages.
>
>  
> +#define PT64_MID_BASE_ADDR_MASK (PT64_BASE_ADDR_MASK & \
> +		~((1ULL << (PAGE_SHIFT + (2 * PT64_LEVEL_BITS))) - 1))
> +#define PT64_MID_GFN_DELTA_MASK (PT64_BASE_ADDR_MASK & (((1ULL << \
> +				(2 * PT64_LEVEL_BITS)) - 1) << PAGE_SHIFT))
> +
>  #define PT32_BASE_ADDR_MASK PAGE_MASK
>  #define PT32_DIR_BASE_ADDR_MASK \
>  	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
> @@ -128,6 +133,7 @@ module_param(oos_shadow, bool, 0644);
>  #define PFERR_USER_MASK (1U << 2)
>  #define PFERR_FETCH_MASK (1U << 4)
>  
> +#define PT_MIDDLE_LEVEL 3
>   

I prefer the architectural names to the Linux names (since we're talking 
about the guest), so PDPT here (even though the Linux names make a bit 
more sense).

>  #define PT_DIRECTORY_LEVEL 2
>  #define PT_PAGE_TABLE_LEVEL 1
>  
> @@ -507,16 +513,29 @@ static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn,
>  				  enum kvm_page_size psize)
>  {
>  	struct kvm_memory_slot *slot;
> -	unsigned long idx;
> +	unsigned long idx, *ret;
>  
>  	slot = gfn_to_memslot(kvm, gfn);
> -	if (psize == KVM_PAGE_SIZE_4k)
> -		return &slot->rmap[gfn - slot->base_gfn];
>  
> -	idx = (gfn / KVM_PAGES_PER_2M_PAGE) -
> -	      (slot->base_gfn / KVM_PAGES_PER_2M_PAGE);
> +	switch (psize) {
> +	case KVM_PAGE_SIZE_4k:
> +		ret = &slot->rmap[gfn - slot->base_gfn];
> +		break;
> +	case KVM_PAGE_SIZE_2M:
> +		idx = (gfn / KVM_PAGES_PER_2M_PAGE) -
> +		      (slot->base_gfn / KVM_PAGES_PER_2M_PAGE);
> +		ret = &slot->lpage_info[idx].rmap_pde;
> +		break;
> +	case KVM_PAGE_SIZE_1G:
> +		idx = (gfn / KVM_PAGES_PER_1G_PAGE) -
> +		      (slot->base_gfn / KVM_PAGES_PER_1G_PAGE);
> +		ret = &slot->hpage_info[idx].rmap_pde;
> +		break;
> +	default:
> +		BUG();
> +	}
>   

Ah, page_level would really make sense here.

>  
> -	return &slot->lpage_info[idx].rmap_pde;
> +	return ret;
>  }
>  
>  /*
> @@ -1363,7 +1382,10 @@ static void kvm_mmu_page_unlink_children(struct kvm *kvm,
>  							   &pt[i]);
>  			} else {
>  				--kvm->stat.lpages;
> -				rmap_remove(kvm, &pt[i], KVM_PAGE_SIZE_2M);
> +				if (sp->role.level == PT_DIRECTORY_LEVEL)
> +					rmap_remove(kvm, &pt[i], KVM_PAGE_SIZE_2M);
> +				else
> +					rmap_remove(kvm, &pt[i], KVM_PAGE_SIZE_1G);
>  			}
>   

And here.

>  		}
>  		pt[i] = shadow_trap_nonpresent_pte;
> @@ -1769,8 +1791,10 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
>  	if ((pte_access & ACC_WRITE_MASK)
>  	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
>  
> -		if (psize > KVM_PAGE_SIZE_4k &&
> -		    has_wrprotected_page(vcpu->kvm, gfn)) {
> +		if ((psize == KVM_PAGE_SIZE_2M &&
> +		     has_wrprotected_page(vcpu->kvm, gfn)) ||
> +		    (psize == KVM_PAGE_SIZE_1G &&
> +		     has_wrprotected_largepage(vcpu->kvm, gfn))) {
>  			ret = 1;
>   

And here.  I'm in complete agreement with myself here.

>  			spte = shadow_trap_nonpresent_pte;
>  			goto set_pte;
> @@ -1884,7 +1908,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
>  	for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
>  		if (iterator.level == PT_PAGE_TABLE_LEVEL
>  		    || (psize == KVM_PAGE_SIZE_2M &&
> -			iterator.level == PT_DIRECTORY_LEVEL)) {
> +			iterator.level == PT_DIRECTORY_LEVEL)
> +		    || (psize == KVM_PAGE_SIZE_1G &&
> +			iterator.level == PT_MIDDLE_LEVEL)) {
>  			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, ACC_ALL,
>  				     0, write, 1, &pt_write,
>  				     psize, 0, gfn, pfn, false);
> @@ -1919,8 +1945,14 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
>  	unsigned long mmu_seq;
>  	enum kvm_page_size psize = backing_size(vcpu, gfn);
>  
> -	if (psize == KVM_PAGE_SIZE_2M)
> +	if (psize >= KVM_PAGE_SIZE_2M) {
> +		/*
> +		 * nonpaging mode uses pae page tables - so we
> +		 * can't use gbpages here - take care of this
> +		 */
>  		gfn &= ~(KVM_PAGES_PER_2M_PAGE-1);
> +		psize = KVM_PAGE_SIZE_2M;
> +	}
>  
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
> @@ -2123,6 +2155,8 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
>  	psize = backing_size(vcpu, gfn);
>  	if (psize == KVM_PAGE_SIZE_2M)
>  		gfn &= ~(KVM_PAGES_PER_2M_PAGE-1);
> +	else if (psize == KVM_PAGE_SIZE_1G)
> +		gfn &= ~(KVM_PAGES_PER_1G_PAGE-1);
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
>  	pfn = gfn_to_pfn(vcpu->kvm, gfn);
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 6704ec7..67d6bfb 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -55,6 +55,7 @@
>  
>  #define gpte_to_gfn FNAME(gpte_to_gfn)
>  #define gpte_to_gfn_pde FNAME(gpte_to_gfn_pde)
> +#define gpte_to_gfn_pmd FNAME(gpte_to_gfn_pmd)
>   

gpte_to_gfn(gpte, level)?


-- 
error compiling committee.c: too many arguments to function

