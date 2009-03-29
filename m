Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbZC2L7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbZC2L7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 07:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZC2L7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 07:59:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56791 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbZC2L7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 07:59:30 -0400
Message-ID: <49CF629E.9080403@redhat.com>
Date: Sun, 29 Mar 2009 14:59:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: add support for 1GB pages in shadow paging code
References: <1238164518-16261-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1238164518-16261-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> This patch adds support for 1GB pages in the shadow paging code. The
> guest can map 1GB pages in his page tables and KVM will map the page
> frame with a 1GB, a 2MB or even a 4kb page size, according to backing
> host page size and the write protections in place.
> This is the theory. In practice there are conditions which turn the
> guest unstable when running with this patch and GB pages enabled. The
> failing conditions are:
>
> 	* KVM is loaded using shadow paging
> 	* The Linux guest uses GB pages for the kernel direct mapping
> 	* The guest memory is backed with 4kb pages on the host side
>
> With the above configuration there are random application or kernel
> crashed when the guest runs under load. When GB pages for HugeTLBfs in
> the guest are allocated at boot time in the guest the guest kernel
> crashes or stucks at boot depending on the amount of RAM in the guest.
> The following parameters have no impact:
>
> 	* It bug occurs also without guest SMP (so likely no race
> 	  condition)
> 	* Use PV-MMU makes no difference
>
> I have searched this bug for quite some time with no real luck. Maybe
> some other reviewers have more luck than I had by now.
>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> @@ -729,7 +730,9 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
>  	}
>  
>  	/* check for huge page mappings */
> -	rmapp = gfn_to_rmap(kvm, gfn, KVM_PAGE_SIZE_2M);
> +	psize = KVM_PAGE_SIZE_2M;
> +again:
> +	rmapp = gfn_to_rmap(kvm, gfn, psize);
>  	spte = rmap_next(kvm, rmapp, NULL);
>  	while (spte) {
>  		BUG_ON(!spte);
> @@ -737,7 +740,7 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
>  		BUG_ON((*spte & (PT_PAGE_SIZE_MASK|PT_PRESENT_MASK)) != (PT_PAGE_SIZE_MASK|PT_PRESENT_MASK));
>  		pgprintk("rmap_write_protect(large): spte %p %llx %lld\n", spte, *spte, gfn);
>  		if (is_writeble_pte(*spte)) {
> -			rmap_remove(kvm, spte, KVM_PAGE_SIZE_2M);
> +			rmap_remove(kvm, spte, psize);
>  			--kvm->stat.lpages;
>  			set_shadow_pte(spte, shadow_trap_nonpresent_pte);
>  			spte = NULL;
> @@ -746,6 +749,11 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
>  		spte = rmap_next(kvm, rmapp, spte);
>  	}
>  
> +	if (psize == KVM_PAGE_SIZE_2M) {
> +		psize = KVM_PAGE_SIZE_1G;
> +		goto again;
> +	}
> +
>   

Ugh, use a real loop.

>  	return write_protected;
>  }
>  
> @@ -789,11 +797,14 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
>  		if (hva >= start && hva < end) {
>  			gfn_t gfn_offset = (hva - start) >> PAGE_SHIFT;
>  			unsigned long lidx = gfn_offset / KVM_PAGES_PER_2M_PAGE;
> +			unsigned long hidx = gfn_offset / KVM_PAGES_PER_1G_PAGE;
>  			retval |= handler(kvm, &memslot->rmap[gfn_offset],
>  					  KVM_PAGE_SIZE_4k);
>  			retval |= handler(kvm,
>  					  &memslot->lpage_info[lidx].rmap_pde,
>  					  KVM_PAGE_SIZE_2M);
> +			retval |= handler(kvm, &memslot->hpage_info[hidx].rmap_pde,
> +					  KVM_PAGE_SIZE_1G);
>  		}
>  	}
>   

Isn't this needed for tdp as well?

 



-- 
error compiling committee.c: too many arguments to function

