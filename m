Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbZBFCar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbZBFCar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 21:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZBFCaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 21:30:39 -0500
Received: from gw.goop.org ([64.81.55.164]:50322 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbZBFCai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 21:30:38 -0500
Message-ID: <498BA0CA.2040603@goop.org>
Date: Thu, 05 Feb 2009 18:30:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Rohit Jain <rjain@vmware.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PARAVIRT/x86] BUGFIX: Put a missing paravirt_release_pmd in
 pgd_dtor
References: <1233885731.29693.26.camel@alok-dev1>
In-Reply-To: <1233885731.29693.26.camel@alok-dev1>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> [PARAVIRT/x86] Put a missing paravirt_release_pmd in pgd_dtor.
>
> From: Alok N Kataria <akataria@vmware.com>
>
> The commit...
> -----------------------------
> commit 6194ba6ff6ccf8d5c54c857600843c67aa82c407
> Author: Jeremy Fitzhardinge <jeremy@goop.org>
> Date:   Wed Jan 30 13:34:11 2008 +0100
>
>     x86: don't special-case pmd allocations as much
> ------------------------------
> ...made changes to the way we handle pmd allocations, and while doing that
> it (accidently ?) dropped a call to  paravirt_release_pd from the pgd_dtor
> code path.
>   

Well, any fallout to VMI was accidental - but I'm surprised it took you 
over a year to notice a problem here...

> As a result of this missing release, the hypervisor is now unaware of the
> pgd page being freed, and as a result it ends up tracking this page as a
> page table page.
> After this the guest may start using the same page for other purposes, and
> depending on what use the page is put to, it may result in various performance
> and/or functional issues ( hangs, reboots).
>   

In Xen we're critically dependent on getting calls to 
paravirt_release_pmd right, with rather immediate and bad results if its 
wrong.  So I suspect something else is up here.

(I assume we're talking 32-bit PAE here, since VMI is 32-bit only and 
the pmd only comes into play with PAE.)

Right now, paravirt_release_pmd is being called from __pmd_free_tlb and 
pgd_mop_up_pmds.

__pmd_free_tlb is called on all the free paths of mappings being removed 
via munmap or exit.
pgd_mop_up_pmds is called to clear out any opportunistically allocated 
pmds which were never used for process-created mappings.

In either case, it will be called before the page is freed back to the 
kernel's heap and reused.

> The patch below adds a paravirt_release_pmd call for the PGD page.
> Patch on top of 2.6.29-rc3 (mainline-git).
>
> Signed-off-by: Alok N Kataria <akataria@vmware.com>
> Signed-off-by: Rohit Jain <rjain@vmware.com>
> Cc: Zachary Amsden <zach@vmware.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: stable@kernel.org
> ---
>
>  arch/x86/mm/pgtable.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
>
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index 86f2ffc..c23cd7e 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -89,6 +89,12 @@ static void pgd_dtor(pgd_t *pgd)
>  {
>  	unsigned long flags; /* can be called from interrupt context */
>  
> +	if (PAGETABLE_LEVELS == 2 ||
> +            (PAGETABLE_LEVELS == 3 && SHARED_KERNEL_PMD) ||
> +            PAGETABLE_LEVELS == 4) {
> +		paravirt_release_pmd(__pa(pgd) >> PAGE_SHIFT);
> +	}
>   

Ah, you want release_pmd to be called on pgds as well...  Why?  Do you 
track the page type for pgds?  Why not just make a copy of the entries 
on cr3 reload like the real hardware does?

Alternatively you could hook pv_mmu_ops.exit_mmap to get a call when the 
last reference to the pagetable has been dropped.

Or, if you really must, introduce paravirt_release_pgd and hook that.

But either way, calling release_pmd here is wrong, since its only meant 
to be applied to pmds, and it would break the Xen code.

    J
