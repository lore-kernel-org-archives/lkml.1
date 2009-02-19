Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbZBSNVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbZBSNVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbZBSNVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:21:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43553 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbZBSNVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:21:10 -0500
Date: Thu, 19 Feb 2009 10:20:25 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: fix another largepage memory leak
Message-ID: <20090219132025.GA29085@amt.cnet>
References: <1235042336-20101-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235042336-20101-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Feb 19, 2009 at 12:18:56PM +0100, Joerg Roedel wrote:
> In the paging_fetch function rmap_remove is called after setting a large
> pte to non-present. This causes rmap_remove to not drop the reference to
> the large page. The result is a memory leak of that page.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/paging_tmpl.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 7314c09..0f11792 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -306,9 +306,9 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>  			continue;
>  
>  		if (is_large_pte(*sptep)) {
> +			rmap_remove(vcpu->kvm, sptep);
>  			set_shadow_pte(sptep, shadow_trap_nonpresent_pte);
>  			kvm_flush_remote_tlbs(vcpu->kvm);
> -			rmap_remove(vcpu->kvm, sptep);
>  		}
>  
>  		if (level == PT_DIRECTORY_LEVEL
> -- 

ACK

