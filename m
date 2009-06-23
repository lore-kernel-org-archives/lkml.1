Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZFWQut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZFWQut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZFWQuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:50:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37515 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbZFWQug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:50:36 -0400
Date: Tue, 23 Jun 2009 12:59:33 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] kvm/mmu: rename is_largepage_backed to
	mapping_level
Message-ID: <20090623155933.GA3651@amt.cnet>
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com> <1245417389-5527-4-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245417389-5527-4-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Fri, Jun 19, 2009 at 03:16:24PM +0200, Joerg Roedel wrote:
> With the new name and the corresponding backend changes this function
> can now support multiple hugepage sizes.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/mmu.c         |  100 +++++++++++++++++++++++++++++--------------
>  arch/x86/kvm/paging_tmpl.h |    4 +-
>  2 files changed, 69 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 1f24d88..3fa6009 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -390,37 +390,52 @@ static void mmu_free_rmap_desc(struct kvm_rmap_desc *rd)
>   * Return the pointer to the largepage write count for a given
>   * gfn, handling slots that are not large page aligned.
>   */
> -static int *slot_largepage_idx(gfn_t gfn, struct kvm_memory_slot *slot)
> +static int *slot_largepage_idx(gfn_t gfn,
> +			       struct kvm_memory_slot *slot,
> +			       int level)
>  {
>  	unsigned long idx;
>  
> -	idx = (gfn / KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL)) -
> -	      (slot->base_gfn / KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL));
> -	return &slot->lpage_info[0][idx].write_count;
> +	idx = (gfn / KVM_PAGES_PER_HPAGE(level)) -
> +	      (slot->base_gfn / KVM_PAGES_PER_HPAGE(level));
> +	return &slot->lpage_info[level - 2][idx].write_count;
>  }
>  
>  static void account_shadowed(struct kvm *kvm, gfn_t gfn)
>  {
> +	struct kvm_memory_slot *slot;
>  	int *write_count;
> +	int i;
>  
>  	gfn = unalias_gfn(kvm, gfn);
> -	write_count = slot_largepage_idx(gfn,
> -					 gfn_to_memslot_unaliased(kvm, gfn));
> -	*write_count += 1;
> +
> +	for (i = PT_DIRECTORY_LEVEL;
> +	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
> +		slot          = gfn_to_memslot_unaliased(kvm, gfn);

Can't you move this call out of the loop?

> +		write_count   = slot_largepage_idx(gfn, slot, i);
> +		*write_count += 1;
> +	}
>  }
>  
>  static void unaccount_shadowed(struct kvm *kvm, gfn_t gfn)
>  {
> +	struct kvm_memory_slot *slot;
>  	int *write_count;
> +	int i;
>  
>  	gfn = unalias_gfn(kvm, gfn);
> -	write_count = slot_largepage_idx(gfn,
> -					 gfn_to_memslot_unaliased(kvm, gfn));
> -	*write_count -= 1;
> -	WARN_ON(*write_count < 0);
> +	for (i = PT_DIRECTORY_LEVEL;
> +	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
> +		slot          = gfn_to_memslot_unaliased(kvm, gfn);
> +		write_count   = slot_largepage_idx(gfn, slot, i);
> +		*write_count -= 1;
> +		WARN_ON(*write_count < 0);
> +	}
>  }
>  
> -static int has_wrprotected_page(struct kvm *kvm, gfn_t gfn)
> +static int has_wrprotected_page(struct kvm *kvm,
> +				gfn_t gfn,
> +				int level)
>  {
>  	struct kvm_memory_slot *slot;
>  	int *largepage_idx;
> @@ -428,47 +443,67 @@ static int has_wrprotected_page(struct kvm *kvm, gfn_t gfn)
>  	gfn = unalias_gfn(kvm, gfn);
>  	slot = gfn_to_memslot_unaliased(kvm, gfn);
>  	if (slot) {
> -		largepage_idx = slot_largepage_idx(gfn, slot);
> +		largepage_idx = slot_largepage_idx(gfn, slot, level);
>  		return *largepage_idx;
>  	}
>  
>  	return 1;
>  }
>  
> -static int host_largepage_backed(struct kvm *kvm, gfn_t gfn)
> +static int host_mapping_level(struct kvm *kvm, gfn_t gfn)
>  {
> +	unsigned long page_size = PAGE_SIZE;
>  	struct vm_area_struct *vma;
>  	unsigned long addr;
> -	int ret = 0;
> +	int i, ret = 0;
>  
>  	addr = gfn_to_hva(kvm, gfn);
>  	if (kvm_is_error_hva(addr))
> -		return ret;
> +		return page_size;
>  
>  	down_read(&current->mm->mmap_sem);
>  	vma = find_vma(current->mm, addr);
> -	if (vma && is_vm_hugetlb_page(vma))
> -		ret = 1;
> +	if (!vma)
> +		goto out;
> +
> +	page_size = vma_kernel_pagesize(vma);
> +
> +out:
>  	up_read(&current->mm->mmap_sem);
>  
> +	for (i = PT_PAGE_TABLE_LEVEL;
> +	     i < (PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES); ++i) {
> +		if (page_size >= KVM_HPAGE_SIZE(i))
> +			ret = i;
> +		else
> +			break;
> +	}
> +
>  	return ret;
>  }
>  
> -static int is_largepage_backed(struct kvm_vcpu *vcpu, gfn_t large_gfn)
> +static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
>  {
>  	struct kvm_memory_slot *slot;
> -
> -	if (has_wrprotected_page(vcpu->kvm, large_gfn))
> -		return 0;
> -
> -	if (!host_largepage_backed(vcpu->kvm, large_gfn))
> -		return 0;
> +	int host_level;
> +	int level = PT_PAGE_TABLE_LEVEL;
>  
>  	slot = gfn_to_memslot(vcpu->kvm, large_gfn);
>  	if (slot && slot->dirty_bitmap)
> -		return 0;
> +		return PT_PAGE_TABLE_LEVEL;
>  
> -	return 1;
> +	host_level = host_mapping_level(vcpu->kvm, large_gfn);
> +
> +	if (host_level == PT_PAGE_TABLE_LEVEL)
> +		return host_level;
> +
> +	for (level = PT_DIRECTORY_LEVEL; level <= host_level; ++level) {
> +
> +		if (has_wrprotected_page(vcpu->kvm, large_gfn, level))
> +			break;
> +	}
> +
> +	return level - 1;
>  }
>  
>  /*
> @@ -1704,7 +1739,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  	if ((pte_access & ACC_WRITE_MASK)
>  	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
>  
> -		if (largepage && has_wrprotected_page(vcpu->kvm, gfn)) {
> +		if (largepage && has_wrprotected_page(vcpu->kvm, gfn, 1)) {

It seems direct_map is missing the large pte overwrite check that
fetch() contains:

                if (is_large_pte(*sptep)) {
                        rmap_remove(vcpu->kvm, sptep);
                        __set_spte(sptep, shadow_trap_nonpresent_pte);
                        kvm_flush_remote_tlbs(vcpu->kvm);
                }

(perhaps its not a possible scenario at the moment, but...).


