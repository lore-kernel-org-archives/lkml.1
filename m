Return-Path: <linux-kernel-owner+w=401wt.eu-S1752090AbZCHMcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbZCHMcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 08:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbZCHMcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 08:32:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42108 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbZCHMcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 08:32:41 -0400
Message-ID: <49B3BAE3.1070903@redhat.com>
Date: Sun, 08 Mar 2009 14:32:35 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] kvm/x86/mmu: include PT_PAGE_SIZE_MASK in PT64_PERM_MASK
References: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com> <1236255153-4432-7-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1236255153-4432-7-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> We also need to do a remote tlb flush if the PSE bit changes. The
> pte_pfn should also change if this bit changes but we can't rely on
> that. So check this bit too to be on the save side.
>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/mmu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 2a36f7f..055b181 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -121,7 +121,7 @@ module_param(oos_shadow, bool, 0644);
>  	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
>  
>  #define PT64_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK \
> -			| PT64_NX_MASK)
> +			| PT64_NX_MASK | PT_PAGE_SIZE_MASK)
>  
>   

PT64_PERM_MASK is used in this way:

static bool need_remote_flush(u64 old, u64 new)
{
    if (!is_shadow_present_pte(old))
        return false;
    if (!is_shadow_present_pte(new))
        return true;
    if ((old ^ new) & PT64_BASE_ADDR_MASK)
        return true;
    old ^= PT64_NX_MASK;
    new ^= PT64_NX_MASK;
    return (old & ~new & PT64_PERM_MASK) != 0;
}

We don't check whether a bit changes, rather we check if a bit is turned 
off (or on in the case of nx).  But I think we need a tlb flush even if 
we change PSE from 0 to 1.

Thinking a bit more, this will never trigger, since an spte at a 
particular level cannot have its pse bit changed (at least in 
kvm_mmu_pte_write).

-- 
error compiling committee.c: too many arguments to function

