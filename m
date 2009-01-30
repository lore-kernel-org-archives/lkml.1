Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbZA3SvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbZA3SvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 13:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZA3SvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 13:51:03 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:24584 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbZA3SvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 13:51:00 -0500
X-IronPort-AV: E=Sophos;i="4.37,352,1231131600"; 
   d="scan'208";a="37869409"
Subject: Re: [PATCH] xen: do not set NX bit when making initial pagetables
	readonly
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mark McLoughlin <markmc@redhat.com>
Cc: Jon Swanson <jswanson@valuecommerce.co.jp>, fedora-virt@redhat.com,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <1233339562-24011-1-git-send-email-Ian.Campbell@citrix.com>
References: <1233339562-24011-1-git-send-email-Ian.Campbell@citrix.com>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 30 Jan 2009 18:50:49 +0000
Message-Id: <1233341449.7436.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jan 2009 18:50:58.0841 (UTC) FILETIME=[B0A76890:01C9830B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I meant to CC lkml and stable@ (some of the original reports are against
2.6.27) and fat-fingered the to: line.

A few previous threads on the subject:
http://lists.xensource.com/archives/html/xen-devel/2009-01/msg00176.html
http://www.redhat.com/archives/fedora-xen/2009-January/msg00022.html
http://www.redhat.com/archives/fedora-virt/2009-January/msg00013.html

Ian.

On Fri, 2009-01-30 at 18:19 +0000, Ian Campbell wrote:
> __supported_pte_mask has not been correctly configured at this point
> and Xen prevents us from using the NX bit if the hardware does not
> support it. Some BIOSes seem to offer the option to disable NX.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Mark McLoughlin <markmc@redhat.com>
> Cc: Jon Swanson <jswanson@valuecommerce.co.jp>
> Cc: fedora-virt@redhat.com
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/xen/enlighten.c |   24 +++++++++++++-----------
>  1 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index bea2152..e705bdf 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -53,6 +53,8 @@
>  #include "mmu.h"
>  #include "multicalls.h"
>  
> +#define _KERNPG_TABLE_RO __pgprot(_KERNPG_TABLE & ~_PAGE_RW)
> +
>  EXPORT_SYMBOL_GPL(hypercall_page);
>  
>  DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
> @@ -1487,9 +1489,9 @@ static __init void xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
>  	}
>  
>  	for (pteidx = 0; pteidx < ident_pte; pteidx += PTRS_PER_PTE)
> -		set_page_prot(&level1_ident_pgt[pteidx], PAGE_KERNEL_RO);
> +		set_page_prot(&level1_ident_pgt[pteidx], _KERNPG_TABLE_RO);
>  
> -	set_page_prot(pmd, PAGE_KERNEL_RO);
> +	set_page_prot(pmd, _KERNPG_TABLE_RO);
>  }
>  
>  #ifdef CONFIG_X86_64
> @@ -1543,12 +1545,12 @@ static __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
>  	xen_map_identity_early(level2_ident_pgt, max_pfn);
>  
>  	/* Make pagetable pieces RO */
> -	set_page_prot(init_level4_pgt, PAGE_KERNEL_RO);
> -	set_page_prot(level3_ident_pgt, PAGE_KERNEL_RO);
> -	set_page_prot(level3_kernel_pgt, PAGE_KERNEL_RO);
> -	set_page_prot(level3_user_vsyscall, PAGE_KERNEL_RO);
> -	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
> -	set_page_prot(level2_fixmap_pgt, PAGE_KERNEL_RO);
> +	set_page_prot(init_level4_pgt, _KERNPG_TABLE_RO);
> +	set_page_prot(level3_ident_pgt, _KERNPG_TABLE_RO);
> +	set_page_prot(level3_kernel_pgt, _KERNPG_TABLE_RO);
> +	set_page_prot(level3_user_vsyscall, _KERNPG_TABLE_RO);
> +	set_page_prot(level2_kernel_pgt, _KERNPG_TABLE_RO);
> +	set_page_prot(level2_fixmap_pgt, _KERNPG_TABLE_RO);
>  
>  	/* Pin down new L4 */
>  	pin_pagetable_pfn(MMUEXT_PIN_L4_TABLE,
> @@ -1597,9 +1599,9 @@ static __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
>  	set_pgd(&swapper_pg_dir[KERNEL_PGD_BOUNDARY],
>  			__pgd(__pa(level2_kernel_pgt) | _PAGE_PRESENT));
>  
> -	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
> -	set_page_prot(swapper_pg_dir, PAGE_KERNEL_RO);
> -	set_page_prot(empty_zero_page, PAGE_KERNEL_RO);
> +	set_page_prot(level2_kernel_pgt, _KERNPG_TABLE_RO);
> +	set_page_prot(swapper_pg_dir, _KERNPG_TABLE_RO);
> +	set_page_prot(empty_zero_page, _KERNPG_TABLE_RO);
>  
>  	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
>  

