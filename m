Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZC1Mqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZC1Mqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 08:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZC1MqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 08:46:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:59302 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbZC1MqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 08:46:21 -0400
Subject: Re: [RFC] x86: gup_fast() batch limit (was: DRM lock ordering fix
 series)
From: Peter Zijlstra <peterz@infradead.org>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Eric Anholt <eric@anholt.net>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <1238242929.4039.706.camel@laptop>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	 <87ocvnmhqx.fsf@basil.nowhere.org>
	 <1238170767.8275.2397.camel@gaiman.anholt.net>
	 <1238171805.8275.2434.camel@gaiman.anholt.net>
	 <20090327181018.GC11935@one.firstfloor.org>
	 <1238184629.625.44.camel@gaiman.anholt.net>
	 <1238201922.4039.403.camel@laptop>  <49CDE401.2020502@inria.fr>
	 <1238237283.4039.605.camel@laptop>  <1238242929.4039.706.camel@laptop>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 13:46:14 +0100
Message-Id: <1238244374.4039.743.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-28 at 13:22 +0100, Peter Zijlstra wrote:

> I'm not really trusting my brain today, but something like the below
> should work I think.
> 
> Nick, any thoughts?
> 
> Not-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/mm/gup.c |   24 +++++++++++++++++++++---
>  1 files changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
> index be54176..4ded5c3 100644
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -11,6 +11,8 @@
>  
>  #include <asm/pgtable.h>
>  
> +#define GUP_BATCH	32
> +
>  static inline pte_t gup_get_pte(pte_t *ptep)
>  {
>  #ifndef CONFIG_X86_PAE
> @@ -91,7 +93,8 @@ static noinline int gup_pte_range(pmd_t pmd, unsigned long addr,
>  		get_page(page);
>  		pages[*nr] = page;
>  		(*nr)++;
> -
> +		if (*nr > GUP_BATCH)
> +			break;
>  	} while (ptep++, addr += PAGE_SIZE, addr != end);
>  	pte_unmap(ptep - 1);
>  
> @@ -157,6 +160,8 @@ static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
>  			if (!gup_pte_range(pmd, addr, next, write, pages, nr))
>  				return 0;
>  		}
> +		if (*nr > GUP_BATCH)
> +			break;
>  	} while (pmdp++, addr = next, addr != end);
>  
>  	return 1;
> @@ -214,6 +219,8 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
>  			if (!gup_pmd_range(pud, addr, next, write, pages, nr))
>  				return 0;
>  		}
> +		if (*nr > GUP_BATCH)
> +			break;
>  	} while (pudp++, addr = next, addr != end);
>  
>  	return 1;
> @@ -226,7 +233,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  	unsigned long addr, len, end;
>  	unsigned long next;
>  	pgd_t *pgdp;
> -	int nr = 0;
> +	int batch = 0, nr = 0;
>  
>  	start &= PAGE_MASK;
>  	addr = start;
> @@ -254,6 +261,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  	 * (which we do on x86, with the above PAE exception), we can follow the
>  	 * address down to the the page and take a ref on it.
>  	 */
> +again:
>  	local_irq_disable();
>  	pgdp = pgd_offset(mm, addr);
>  	do {
> @@ -262,11 +270,21 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  		next = pgd_addr_end(addr, end);
>  		if (pgd_none(pgd))
>  			goto slow;
> -		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
> +		if (!gup_pud_range(pgd, addr, next, write, pages, &batch))
>  			goto slow;
> +		if (batch > GUP_BATCH) {
> +			local_irq_enable();
> +			addr += batch << PAGE_SHIFT;
> +			nr += batch;
> +			batch = 0;
> +			if (addr != end)
> +				goto again;
> +		}
>  	} while (pgdp++, addr = next, addr != end);
>  	local_irq_enable();
>  
> +	nr += batch;
> +
>  	VM_BUG_ON(nr != (end - start) >> PAGE_SHIFT);
>  	return nr;
>  

Would also need the following bit:
 
@@ -274,6 +292,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 		int ret;
 
 slow:
+		nr += batch;
 		local_irq_enable();
 slow_irqon:
 		/* Try to get the remaining pages with get_user_pages */


