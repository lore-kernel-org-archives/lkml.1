Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZCEVSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZCEVSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 16:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbZCEVSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 16:18:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55532 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbZCEVSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 16:18:03 -0500
Date: Thu, 5 Mar 2009 18:11:22 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] kvm/x86/mmu: handle invlpg on large pages
Message-ID: <20090305211122.GA5660@amt.cnet>
References: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com> <1236255153-4432-5-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236255153-4432-5-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 01:12:31PM +0100, Joerg Roedel wrote:
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/paging_tmpl.h |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 79668ba..aa79396 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -441,6 +441,7 @@ out_unlock:
>  static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
>  {
>  	struct kvm_shadow_walk_iterator iterator;
> +	struct kvm_mmu_page *sp;
>  	pt_element_t gpte;
>  	gpa_t pte_gpa = -1;
>  	int level;
> @@ -451,12 +452,17 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
>  	for_each_shadow_entry(vcpu, gva, iterator) {
>  		level = iterator.level;
>  		sptep = iterator.sptep;
> +		sp = page_header(__pa(sptep));
> +
> +		if (sp->role.direct) {
> +			/* mapped from a guest's large_pte */
> +			kvm_mmu_zap_page(vcpu->kvm, sp);
> +			kvm_flush_remote_tlbs(vcpu->kvm);
> +			return;
> +		}

If the guest has 32-bit pte's there might be:

- two large shadow entries to cover 4MB
- one large shadow entry and one shadow page with 512 4k entries
- two shadow pages with 512 4k entries each

So need to cover all this cases. 

