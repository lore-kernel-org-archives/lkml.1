Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966869Ab0B0Bnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 20:43:43 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:41287 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966773Ab0B0Bnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 20:43:41 -0500
Subject: Re: [PATCH 2/3] vmi: disable highmem PTE allocation even when
	CONFIG_HIGHPTE=y
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ian Campbell <ian.campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <1267204562-11844-2-git-send-email-ian.campbell@citrix.com>
References: <1267204547.11737.12659.camel@zakaz.uk.xensource.com>
	 <1267204562-11844-2-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 26 Feb 2010 17:43:41 -0800
Message-Id: <1267235021.24798.36.camel@ank32>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2010-02-26 at 09:16 -0800, Ian Campbell wrote:
> Preventing HIGHPTE allocations under VMI will allow us to remove the
> kmap_atomic_pte paravirt op.

Acked-by: Alok N Kataria <akataria@vmware.com>

Thanks,
Alok
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Alok Kataria <akataria@vmware.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> ---
>  arch/x86/kernel/vmi_32.c |   23 +++++++++++------------
>  1 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
> index d430e4c..58aca86 100644
> --- a/arch/x86/kernel/vmi_32.c
> +++ b/arch/x86/kernel/vmi_32.c
> @@ -33,6 +33,7 @@
>  #include <asm/fixmap.h>
>  #include <asm/apicdef.h>
>  #include <asm/apic.h>
> +#include <asm/pgalloc.h>
>  #include <asm/processor.h>
>  #include <asm/timer.h>
>  #include <asm/vmi_time.h>
> @@ -272,19 +273,11 @@ static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)
>  	void *va = kmap_atomic(page, type);
>  
>  	/*
> -	 * Internally, the VMI ROM must map virtual addresses to physical
> -	 * addresses for processing MMU updates.  By the time MMU updates
> -	 * are issued, this information is typically already lost.
> -	 * Fortunately, the VMI provides a cache of mapping slots for active
> -	 * page tables.
> -	 *
> -	 * We use slot zero for the linear mapping of physical memory, and
> -	 * in HIGHPTE kernels, slot 1 and 2 for KM_PTE0 and KM_PTE1.
> -	 *
> -	 *  args:                 SLOT                 VA    COUNT PFN
> +	 * We disable highmem allocations for page tables so we should never
> +	 * see any calls to kmap_atomic_pte on a highmem page.
>  	 */
> -	BUG_ON(type != KM_PTE0 && type != KM_PTE1);
> -	vmi_ops.set_linear_mapping((type - KM_PTE0)+1, va, 1, page_to_pfn(page));
> +
> +	BUG_ON(PageHighmem(page));
>  
>  	return va;
>  }
> @@ -640,6 +633,12 @@ static inline int __init activate_vmi(void)
>  	u64 reloc;
>  	const struct vmi_relocation_info *rel = (struct vmi_relocation_info *)&reloc;
>  
> +	/*
> +	 * Prevent page tables from being allocated in highmem, even if
> +	 * CONFIG_HIGHPTE is enabled.
> +	 */
> +	__userpte_alloc_gfp &= ~__GFP_HIGHMEM;
> +
>  	if (call_vrom_func(vmi_rom, vmi_init) != 0) {
>  		printk(KERN_ERR "VMI ROM failed to initialize!");
>  		return 0;

