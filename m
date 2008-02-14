Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbYBNQMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbYBNQMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbYBNQMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:12:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41243 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbYBNQMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:12:39 -0500
Date: Thu, 14 Feb 2008 17:12:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@osdl.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       ying.huang@intel.com
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
Message-ID: <20080214161218.GA28152@elte.hu>
References: <20080214131317.GA27769@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214131317.GA27769@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> --- linux.orig/arch/x86/kernel/efi.c
> +++ linux/arch/x86/kernel/efi.c
> @@ -413,17 +413,31 @@ void __init efi_enter_virtual_mode(void)
>  
>  	efi.systab = NULL;
>  	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> +		int cached;
> +		unsigned numpages;
> +
>  		md = p;
>  		if (!(md->attribute & EFI_MEMORY_RUNTIME))
>  			continue;
>  
> +		/*
> +		 * RED-PEN The spec (and ia64) has a lot more memory
> +		 *         attribute flags should we handle those too?
> +		 */
> + 		cached = !!(md->attribute & EFI_MEMORY_WB);
>  		size = md->num_pages << EFI_PAGE_SHIFT;
>  		end = md->phys_addr + size;
> +		numpages = ALIGN(size, PAGE_SIZE) >> PAGE_SHIFT;
>  
> -		if ((end >> PAGE_SHIFT) <= max_pfn_mapped)
> +		/* RED-PEN does not handle overlapping */
> +		if ((end >> PAGE_SHIFT) <= max_pfn_mapped) {
>  			va = __va(md->phys_addr);
> -		else
> -			va = efi_ioremap(md->phys_addr, size);
> +			/* RED-PEN someone else could UCed it. */
> +			if (!cached)
> +				set_memory_uc((unsigned long)va, numpages);
> +		} else {
> +			va = efi_ioremap(md->phys_addr, size, cached);
> +		}
>  
>  		md->virt_addr = (u64) (unsigned long) va;

this is indeed a bug (we change the attributes for a larger area than 
needed), but your fix is unclean. Find below a cleaner solution.

Ying, if you agree with this fix could you please test and ACK it before 
we push it to Linus? (this fix is also in the latest x86.git#mm)

Thanks,

	Ingo

----------------->
Subject: x86: EFI set_memory_x()/set_memory_uc() fixes
From: Ingo Molnar <mingo@elte.hu>
Date: Thu Feb 14 14:21:32 CET 2008

The EFI-runtime mapping code changed a larger memory area than it
should have, due to a pages/bytes parameter mixup.

noticed by Andi Kleen.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/efi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-x86.q/arch/x86/kernel/efi.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/efi.c
+++ linux-x86.q/arch/x86/kernel/efi.c
@@ -391,7 +391,7 @@ static void __init runtime_code_page_mke
 		if (md->type != EFI_RUNTIME_SERVICES_CODE)
 			continue;
 
-		set_memory_x(md->virt_addr, md->num_pages << EFI_PAGE_SHIFT);
+		set_memory_x(md->virt_addr, md->num_pages);
 	}
 }
 
@@ -434,7 +434,7 @@ void __init efi_enter_virtual_mode(void)
 		}
 
 		if (!(md->attribute & EFI_MEMORY_WB))
-			set_memory_uc(md->virt_addr, size);
+			set_memory_uc(md->virt_addr, md->num_pages);
 
 		systab = (u64) (unsigned long) efi_phys.systab;
 		if (md->phys_addr <= systab && systab < end) {
