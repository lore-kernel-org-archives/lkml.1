Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbZC2LqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbZC2LqB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 07:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZC2Lpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 07:45:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55778 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbZC2Lps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 07:45:48 -0400
Message-ID: <49CF5F68.1020507@redhat.com>
Date: Sun, 29 Mar 2009 14:45:44 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] kvm mmu: implement necessary data structures for
 second huge page accounting
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com> <1238164319-16092-5-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1238164319-16092-5-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> This patch adds the necessary data structures to take care of write
> protections in place within a second huge page sized page.
>
>  
>  struct kvm_vcpu_arch {
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 9936b45..7d4162d 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -390,6 +390,15 @@ static int *slot_largepage_idx(gfn_t gfn, struct kvm_memory_slot *slot)
>  	return &slot->lpage_info[idx].write_count;
>  }
>  
> +static int *slot_hugepage_idx(gfn_t gfn, struct kvm_memory_slot *slot)
> +{
> +	unsigned long idx;
> +
> +	idx = (gfn / KVM_PAGES_PER_1G_PAGE) -
> +	      (slot->base_gfn / KVM_PAGES_PER_1G_PAGE);
> +	return &slot->hpage_info[idx].write_count;
> +}
>   

A page level argument would remove the need for this duplication, as 
well as all the constants.

>  
> +static int has_wrprotected_largepage(struct kvm *kvm, gfn_t gfn)
> +{
> +	struct kvm_memory_slot *slot;
> +	int *hugepage_idx;
> +
> +	gfn = unalias_gfn(kvm, gfn);
> +	slot = gfn_to_memslot_unaliased(kvm, gfn);
> +	if (slot) {
> +		hugepage_idx = slot_hugepage_idx(gfn, slot);
>   

slot_largepage_idx() here?

I don't think we ever write protect large pages, so why is this needed?

> +		return *hugepage_idx;
> +	}
> +
> +	return 1;
> +}
>   


> +
>  static enum kvm_page_size host_page_size(struct kvm *kvm, gfn_t gfn)
>  {
>  	struct vm_area_struct *vma;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 095ebb6..2f05d48 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -103,7 +103,7 @@ struct kvm_memory_slot {
>  	struct {
>  		unsigned long rmap_pde;
>  		int write_count;
> -	} *lpage_info;
> +	} *lpage_info, *hpage_info;
>   

} * lpage_info[KVM_NR_PAGE_LEVELS];

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 8aa3b95..c4842f4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1001,10 +1001,14 @@ static void kvm_free_physmem_slot(struct kvm_memory_slot *free,
>  	if (!dont || free->lpage_info != dont->lpage_info)
>  		vfree(free->lpage_info);
>  
> +	if (!dont || free->hpage_info != dont->hpage_info)
> +		vfree(free->hpage_info);
>   

loop

>  void kvm_free_physmem(struct kvm *kvm)
> @@ -1170,6 +1174,28 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  			new.lpage_info[largepages-1].write_count = 1;
>  	}
>  
> +#ifdef KVM_PAGES_PER_LHPAGE
> +	if (npages && !new.hpage_info) {
> +		int hugepages = npages / KVM_PAGES_PER_LHPAGE;
> +		if (npages % KVM_PAGES_PER_LHPAGE)
> +			hugepages++;
> +		if (base_gfn % KVM_PAGES_PER_LHPAGE)
> +			hugepages++;
> +
> +		new.hpage_info = vmalloc(hugepages * sizeof(*new.hpage_info));
> +
> +		if (!new.hpage_info)
> +			goto out_free;
> +
> +		memset(new.hpage_info, 0, hugepages * sizeof(*new.hpage_info));
> +
> +		if (base_gfn % KVM_PAGES_PER_LHPAGE)
> +			new.hpage_info[0].write_count = 1;
> +		if ((base_gfn+npages) % KVM_PAGES_PER_LHPAGE)
> +			new.hpage_info[hugepages-1].write_count = 1;
> +	}
> +#endif
>   

Loop, KVM_NR_PAGE_LEVELS defined per arch.


-- 
error compiling committee.c: too many arguments to function

