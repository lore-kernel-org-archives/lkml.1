Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbZFWQvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbZFWQvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbZFWQum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:50:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37519 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbZFWQui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:50:38 -0400
Date: Tue, 23 Jun 2009 13:47:28 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] kvm/mmu: make direct mapping paths aware of
	mapping levels
Message-ID: <20090623164728.GB3651@amt.cnet>
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com> <1245417389-5527-6-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245417389-5527-6-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 03:16:26PM +0200, Joerg Roedel wrote:
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    2 +-
>  arch/x86/kvm/mmu.c              |   60 ++++++++++++++++++++++-----------------
>  arch/x86/kvm/paging_tmpl.h      |    6 ++--
>  3 files changed, 38 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 930bac2..397f992 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -314,7 +314,7 @@ struct kvm_vcpu_arch {
>  	struct {
>  		gfn_t gfn;	/* presumed gfn during guest pte update */
>  		pfn_t pfn;	/* pfn corresponding to that gfn */
> -		int largepage;
> +		int level;
>  		unsigned long mmu_seq;
>  	} update_pte;
>  
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 0ef947d..ef2396d 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -254,7 +254,7 @@ static int is_last_spte(u64 pte, int level)
>  {
>  	if (level == PT_PAGE_TABLE_LEVEL)
>  		return 1;
> -	if (level == PT_DIRECTORY_LEVEL && is_large_pte(pte))
> +	if (is_large_pte(pte))
>  		return 1;

Wouldnt it be safer to check for bit 7 only on the levels
we're sure it means large page?

>  	return 0;
>  }
> @@ -1708,7 +1708,7 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
>  
>  static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  		    unsigned pte_access, int user_fault,
> -		    int write_fault, int dirty, int largepage,
> +		    int write_fault, int dirty, int level,
>  		    gfn_t gfn, pfn_t pfn, bool speculative,
>  		    bool can_unsync)
>  {
> @@ -1731,7 +1731,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  		spte |= shadow_nx_mask;
>  	if (pte_access & ACC_USER_MASK)
>  		spte |= shadow_user_mask;
> -	if (largepage)
> +	if (level > PT_PAGE_TABLE_LEVEL)
>  		spte |= PT_PAGE_SIZE_MASK;
>  	if (tdp_enabled)
>  		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
> @@ -1742,7 +1742,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  	if ((pte_access & ACC_WRITE_MASK)
>  	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
>  
> -		if (largepage && has_wrprotected_page(vcpu->kvm, gfn, 1)) {
> +		if (level > PT_PAGE_TABLE_LEVEL &&
> +		    has_wrprotected_page(vcpu->kvm, gfn, level)) {
>  			ret = 1;
>  			spte = shadow_trap_nonpresent_pte;
>  			goto set_pte;
> @@ -1780,7 +1781,7 @@ set_pte:
>  static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  			 unsigned pt_access, unsigned pte_access,
>  			 int user_fault, int write_fault, int dirty,
> -			 int *ptwrite, int largepage, gfn_t gfn,
> +			 int *ptwrite, int level, gfn_t gfn,
>  			 pfn_t pfn, bool speculative)
>  {
>  	int was_rmapped = 0;
> @@ -1796,7 +1797,8 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
>  		 * the parent of the now unreachable PTE.
>  		 */
> -		if (largepage && !is_large_pte(*sptep)) {
> +		if (level > PT_PAGE_TABLE_LEVEL &&
> +		    !is_large_pte(*sptep)) {

Should probably get rid of this entirely (or BUG_ON), since a better
place to handle this is at fetch / direct_map as mentioned in the other
email.

But we can do that later, incrementally.

>  			struct kvm_mmu_page *child;
>  			u64 pte = *sptep;
>  
> @@ -1809,8 +1811,9 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  		} else
>  			was_rmapped = 1;
>  	}
> +
>  	if (set_spte(vcpu, sptep, pte_access, user_fault, write_fault,
> -		      dirty, largepage, gfn, pfn, speculative, true)) {
> +		      dirty, level, gfn, pfn, speculative, true)) {
>  		if (write_fault)
>  			*ptwrite = 1;
>  		kvm_x86_ops->tlb_flush(vcpu);
> @@ -1846,7 +1849,7 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
>  }
>  
>  static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
> -			int largepage, gfn_t gfn, pfn_t pfn)
> +			int level, gfn_t gfn, pfn_t pfn)
>  {
>  	struct kvm_shadow_walk_iterator iterator;
>  	struct kvm_mmu_page *sp;
> @@ -1854,11 +1857,10 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
>  	gfn_t pseudo_gfn;
>  
>  	for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
> -		if (iterator.level == PT_PAGE_TABLE_LEVEL
> -		    || (largepage && iterator.level == PT_DIRECTORY_LEVEL)) {
> +		if (iterator.level == level) {
>  			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, ACC_ALL,
>  				     0, write, 1, &pt_write,
> -				     largepage, gfn, pfn, false);
> +				     level, gfn, pfn, false);
>  			++vcpu->stat.pf_fixed;
>  			break;
>  		}
> @@ -1886,14 +1888,20 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
>  static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
>  {
>  	int r;
> -	int largepage = 0;
> +	int level;
>  	pfn_t pfn;
>  	unsigned long mmu_seq;
>  
> -	if (mapping_level(vcpu, gfn) == PT_DIRECTORY_LEVEL) {
> -		gfn &= ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
> -		largepage = 1;
> -	}
> +	level = mapping_level(vcpu, gfn);
> +
> +	/*
> +	 * This path builds a PAE pagetable - so we can map 2mb pages at
> +	 * maximum. Therefore check if the level is larger than that.
> +	 */
> +	if (level > PT_DIRECTORY_LEVEL)
> +		level = PT_DIRECTORY_LEVEL;
> +
> +	gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
>  
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
> @@ -1909,7 +1917,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
>  	if (mmu_notifier_retry(vcpu, mmu_seq))
>  		goto out_unlock;
>  	kvm_mmu_free_some_pages(vcpu);
> -	r = __direct_map(vcpu, v, write, largepage, gfn, pfn);
> +	r = __direct_map(vcpu, v, write, level, gfn, pfn);
>  	spin_unlock(&vcpu->kvm->mmu_lock);
>  
>  
> @@ -2085,7 +2093,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
>  {
>  	pfn_t pfn;
>  	int r;
> -	int largepage = 0;
> +	int level;
>  	gfn_t gfn = gpa >> PAGE_SHIFT;
>  	unsigned long mmu_seq;
>  
> @@ -2096,10 +2104,10 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
>  	if (r)
>  		return r;
>  
> -	if (mapping_level(vcpu, gfn) == PT_DIRECTORY_LEVEL) {
> -		gfn &= ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
> -		largepage = 1;
> -	}
> +	level = mapping_level(vcpu, gfn);
> +
> +	gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
> +
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
>  	pfn = gfn_to_pfn(vcpu->kvm, gfn);
> @@ -2112,7 +2120,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
>  		goto out_unlock;
>  	kvm_mmu_free_some_pages(vcpu);
>  	r = __direct_map(vcpu, gpa, error_code & PFERR_WRITE_MASK,
> -			 largepage, gfn, pfn);
> +			 level, gfn, pfn);
>  	spin_unlock(&vcpu->kvm->mmu_lock);
>  
>  	return r;
> @@ -2419,7 +2427,7 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
>  				  const void *new)
>  {
>  	if (sp->role.level != PT_PAGE_TABLE_LEVEL) {
> -		if (!vcpu->arch.update_pte.largepage ||
> +		if (vcpu->arch.update_pte.level == PT_PAGE_TABLE_LEVEL ||
>  		    sp->role.glevels == PT32_ROOT_LEVEL) {
>  			++vcpu->kvm->stat.mmu_pde_zapped;
>  			return;
> @@ -2469,7 +2477,7 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>  	u64 gpte = 0;
>  	pfn_t pfn;
>  
> -	vcpu->arch.update_pte.largepage = 0;
> +	vcpu->arch.update_pte.level = PT_PAGE_TABLE_LEVEL;
>  
>  	if (bytes != 4 && bytes != 8)
>  		return;
> @@ -2501,7 +2509,7 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>  	if (is_large_pte(gpte) &&
>  	    (mapping_level(vcpu, gfn) == PT_DIRECTORY_LEVEL)) {
>  		gfn &= ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
> -		vcpu->arch.update_pte.largepage = 1;
> +		vcpu->arch.update_pte.level = PT_DIRECTORY_LEVEL;
>  	}
>  	vcpu->arch.update_pte.mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 25a4437..8fbf4e7 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -248,7 +248,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
>  	pt_element_t gpte;
>  	unsigned pte_access;
>  	pfn_t pfn;
> -	int largepage = vcpu->arch.update_pte.largepage;
> +	int level = vcpu->arch.update_pte.level;
>  
>  	gpte = *(const pt_element_t *)pte;
>  	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
> @@ -267,7 +267,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
>  		return;
>  	kvm_get_pfn(pfn);
>  	mmu_set_spte(vcpu, spte, page->role.access, pte_access, 0, 0,
> -		     gpte & PT_DIRTY_MASK, NULL, largepage,
> +		     gpte & PT_DIRTY_MASK, NULL, level,
>  		     gpte_to_gfn(gpte), pfn, true);

It would be better to just turn off updates to large sptes via          
update_pte path, so just nuke them and let the pagefault path
handle.

>  }
>  
> @@ -301,7 +301,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>  				     gw->pte_access & access,
>  				     user_fault, write_fault,
>  				     gw->ptes[gw->level-1] & PT_DIRTY_MASK,
> -				     ptwrite, largepage,
> +				     ptwrite, level,
>  				     gw->gfn, pfn, false);
>  			break;
>  		}
> -- 
> 1.6.3.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
