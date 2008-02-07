Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbYBGN1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbYBGN1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 08:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbYBGN1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 08:27:25 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:57897
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbYBGN1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 08:27:24 -0500
Message-ID: <47AB0737.2000206@qumranet.com>
Date: Thu, 07 Feb 2008 15:27:19 +0200
From: Izik Eidus <izike@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 7/8] MMU: add TDP support to the KVM MMU
References: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com> <1202388465-8657-8-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1202388465-8657-8-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> This patch contains the changes to the KVM MMU necessary for support of the
> Nested Paging feature in AMD Barcelona and Phenom Processors.
>   

good patch, it look like things will be very fixable with it

> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/mmu.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/mmu.h |    6 ++++
>  2 files changed, 82 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 5e76963..5304d55 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1081,6 +1081,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
>  	int i;
>  	gfn_t root_gfn;
>  	struct kvm_mmu_page *sp;
> +	int metaphysical = 0;
>  
>  	root_gfn = vcpu->arch.cr3 >> PAGE_SHIFT;
>  
> @@ -1089,14 +1090,20 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
>  		hpa_t root = vcpu->arch.mmu.root_hpa;
>  
>  		ASSERT(!VALID_PAGE(root));
> +		if (tdp_enabled)
> +			metaphysical = 1;
>  		sp = kvm_mmu_get_page(vcpu, root_gfn, 0,
> -				      PT64_ROOT_LEVEL, 0, ACC_ALL, NULL, NULL);
> +				      PT64_ROOT_LEVEL, metaphysical,
> +				      ACC_ALL, NULL, NULL);
>  		root = __pa(sp->spt);
>  		++sp->root_count;
>  		vcpu->arch.mmu.root_hpa = root;
>  		return;
>  	}
>  #endif
> +	metaphysical = !is_paging(vcpu);
> +	if (tdp_enabled)
> +		metaphysical = 1;
>  	for (i = 0; i < 4; ++i) {
>  		hpa_t root = vcpu->arch.mmu.pae_root[i];
>  
> @@ -1110,7 +1117,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
>  		} else if (vcpu->arch.mmu.root_level == 0)
>  			root_gfn = 0;
>  		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
> -				      PT32_ROOT_LEVEL, !is_paging(vcpu),
> +				      PT32_ROOT_LEVEL, metaphysical,
>  				      ACC_ALL, NULL, NULL);
>  		root = __pa(sp->spt);
>  		++sp->root_count;
> @@ -1144,6 +1151,36 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
>  			     error_code & PFERR_WRITE_MASK, gfn);
>  }
>  
> +static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
> +				u32 error_code)
>   

you probably mean gpa_t ?

> +{
> +	struct page *page;
> +	int r;
> +
> +	ASSERT(vcpu);
> +	ASSERT(VALID_PAGE(vcpu->arch.mmu.root_hpa));
> +
> +	r = mmu_topup_memory_caches(vcpu);
> +	if (r)
> +		return r;
> +
> +	down_read(&current->mm->mmap_sem);
> +	page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
> +	if (is_error_page(page)) {
> +		kvm_release_page_clean(page);
> +		up_read(&current->mm->mmap_sem);
> +		return 1;
> +	}
>   

i dont know if it worth checking it here,
in the worth case we will map the error page and the host will be safe

> +	spin_lock(&vcpu->kvm->mmu_lock);
> +	kvm_mmu_free_some_pages(vcpu);
> +	r = __direct_map(vcpu, gpa, error_code & PFERR_WRITE_MASK,
> +			 gpa >> PAGE_SHIFT, page, TDP_ROOT_LEVEL);
> +	spin_unlock(&vcpu->kvm->mmu_lock);
> +	up_read(&current->mm->mmap_sem);
> +
> +	return r;
> +}
> +
>  static void nonpaging_free(struct kvm_vcpu *vcpu)
>  {
>  	mmu_free_roots(vcpu);
> @@ -1237,7 +1274,35 @@ static int paging32E_init_context(struct kvm_vcpu *vcpu)
>  	return paging64_init_context_common(vcpu, PT32E_ROOT_LEVEL);
>  }
>  
> -static int init_kvm_mmu(struct kvm_vcpu *vcpu)
> tdp_page_fault(struct
> +static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_mmu *context = &vcpu->arch.mmu;
> +
> +	context->new_cr3 = nonpaging_new_cr3;
> +	context->page_fault = tdp_page_fault;
> +	context->free = nonpaging_free;
> +	context->prefetch_page = nonpaging_prefetch_page;
> +	context->shadow_root_level = TDP_ROOT_LEVEL;
> +	context->root_hpa = INVALID_PAGE;
> +
> +	if (!is_paging(vcpu)) {
> +		context->gva_to_gpa = nonpaging_gva_to_gpa;
> +		context->root_level = 0;
> +	} else if (is_long_mode(vcpu)) {
> +		context->gva_to_gpa = paging64_gva_to_gpa;
> +		context->root_level = PT64_ROOT_LEVEL;
> +	} else if (is_pae(vcpu)) {
> +		context->gva_to_gpa = paging64_gva_to_gpa;
> +		context->root_level = PT32E_ROOT_LEVEL;
> +	} else {
> +		context->gva_to_gpa = paging32_gva_to_gpa;
> +		context->root_level = PT32_ROOT_LEVEL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
>  {
>  	ASSERT(vcpu);
>  	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
> @@ -1252,6 +1317,14 @@ static int init_kvm_mmu(struct kvm_vcpu *vcpu)
>  		return paging32_init_context(vcpu);
>  }
>  
> +static int init_kvm_mmu(struct kvm_vcpu *vcpu)
> +{
> +	if (tdp_enabled)
> +		return init_kvm_tdp_mmu(vcpu);
> +	else
> +		return init_kvm_softmmu(vcpu);
> +}
> +
>  static void destroy_kvm_mmu(struct kvm_vcpu *vcpu)
>  {
>  	ASSERT(vcpu);
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 1fce19e..e64e9f5 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -3,6 +3,12 @@
>  
>  #include <linux/kvm_host.h>
>  
> +#ifdef CONFIG_X86_64
> +#define TDP_ROOT_LEVEL PT64_ROOT_LEVEL
> +#else
> +#define TDP_ROOT_LEVEL PT32E_ROOT_LEVEL
> +#endif
> +
>  static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
>  {
>  	if (unlikely(vcpu->kvm->arch.n_free_mmu_pages < KVM_MIN_FREE_MMU_PAGES))
>   


-- 
woof.

