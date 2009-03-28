Return-Path: <linux-kernel-owner+w=401wt.eu-S1760941AbZC1V3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760941AbZC1V3c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 17:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760879AbZC1V2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 17:28:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42271 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760869AbZC1V2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 17:28:53 -0400
Date: Sat, 28 Mar 2009 18:28:35 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: add support for 1GB pages in shadow paging
	code
Message-ID: <20090328212834.GA4694@amt.cnet>
References: <1238164518-16261-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238164518-16261-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 03:35:18PM +0100, Joerg Roedel wrote:
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

Sorry, I can't spot what is wrong here. Avi?

Perhaps it helps if you provide some info of the hang when guest
allocates hugepages on boot (its probably and endless fault that can't
be corrected?).

Also another point is that the large huge page at 0-1GB will never
be created, because it crosses slot boundary.

> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/mmu.c         |   56 +++++++++++++++++++++++++++++++------------
>  arch/x86/kvm/paging_tmpl.h |   35 +++++++++++++++++++++------
>  arch/x86/kvm/svm.c         |    2 +-
>  3 files changed, 68 insertions(+), 25 deletions(-)
> 
> +	psize = backing_size(vcpu, vcpu->arch.update_pte.gfn);

This can block, and this path holds mmu_lock. Thats why it needs to be
done in guess_page_from_pte_write.

> +	if ((sp->role.level == PT_DIRECTORY_LEVEL) &&
> +	    (psize >= KVM_PAGE_SIZE_2M)) {
> +		psize = KVM_PAGE_SIZE_2M;
> +		vcpu->arch.update_pte.gfn &= ~(KVM_PAGES_PER_2M_PAGE-1);
> +		vcpu->arch.update_pte.pfn &= ~(KVM_PAGES_PER_2M_PAGE-1);
> +	} else if ((sp->role.level == PT_MIDDLE_LEVEL) &&
> +		   (psize == KVM_PAGE_SIZE_1G)) {
> +		vcpu->arch.update_pte.gfn &= ~(KVM_PAGES_PER_1G_PAGE-1);
> +		vcpu->arch.update_pte.pfn &= ~(KVM_PAGES_PER_1G_PAGE-1);
> +	} else
> +		goto out_pde;

Better just zap the entry in case its a 1GB one and let the
fault path handle it.

