Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab0BDEMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 23:12:23 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37379 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab0BDEMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 23:12:22 -0500
Date: Thu, 4 Feb 2010 09:42:12 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: jdike@addtoit.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, aarcange@redhat.com, mtosatti@redhat.com
Subject: Re: [PATCH] emulate accessed bit for EPT
Message-ID: <20100204041212.GI19641@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100203161103.11e2b572@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100203161103.11e2b572@annuminas.surriel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel <riel@redhat.com> [2010-02-03 16:11:03]:

> Currently KVM pretends that pages with EPT mappings never got
> accessed.  This has some side effects in the VM, like swapping
> out actively used guest pages and needlessly breaking up actively
> used hugepages.
> 
> We can avoid those very costly side effects by emulating the
> accessed bit for EPT PTEs, which should only be slightly costly
> because pages pass through page_referenced infrequently.
> 
> TLB flushing is taken care of by kvm_mmu_notifier_clear_flush_young().
> 
> This seems to help prevent KVM guests from being swapped out when
> they should not on my system.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
> Jeff, does this patch fix the issue you saw a few months ago, with
> a 256MB KVM guest in a cgroup limited to 128GB memory?
> 
>  arch/x86/kvm/mmu.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 89a49fb..6101615 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -856,9 +856,15 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
>  	u64 *spte;
>  	int young = 0;
> 
> -	/* always return old for EPT */
> +	/*
> +	 * Emulate the accessed bit for EPT, by checking if this page has
> +	 * an EPT mapping, and clearing it if it does. On the next access,
> +	 * a new EPT mapping will be established.
> +	 * This has some overhead, but not as much as the cost of swapping
> +	 * out actively used pages or breaking up actively used hugepages.
> +	 */
>  	if (!shadow_accessed_mask)
> -		return 0;
> +		return kvm_unmap_rmapp(kvm, rmapp, data);
>

Quite a clever implementation, one side effect is that one would see a
larger number of minor faults with EPT enabled and an increase in
allocation/frees of rmap entries, but that can be easily explained.

-- 
	Balbir
