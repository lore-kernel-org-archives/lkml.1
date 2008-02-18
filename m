Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbYBRSye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbYBRSye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 13:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYBRSyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 13:54:24 -0500
Received: from www.tglx.de ([62.245.132.106]:33937 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbYBRSyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 13:54:23 -0500
Date: Mon, 18 Feb 2008 19:53:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
cc: mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix pmd_bad and pud_bad to support huge pages
In-Reply-To: <20080218171047.GA4091@escobedo.amd.com>
Message-ID: <alpine.LFD.1.00.0802181928270.7583@apollo.tec.linutronix.de>
References: <20080218171047.GA4091@escobedo.amd.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008, Hans Rosenfeld wrote:
> I recently stumbled upon a problem in the support for huge pages. If a
> program using huge pages does not explicitly unmap them, they remain
> mapped (and therefore, are lost) after the program exits.
> 
> I observed that the free huge page count in /proc/meminfo decreased when
> running my program, and it did not increase after the program exited.
> After running the program a few times, no more huge pages could be
> allocated.
> 
> The reason for this seems to be that the x86 pmd_bad and pud_bad
> consider pmd/pud entries having the PSE bit set invalid. I think there
> is nothing wrong with this bit being set, it just indicates that the
> lowest level of translation has been reached. This bit has to be (and
> is) checked after the basic validity of the entry has been checked, like
> in this fragment from follow_page() in mm/memory.c:
> 
>   if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
>           goto no_page_table;
> 
>   if (pmd_huge(*pmd)) {
>           BUG_ON(flags & FOLL_GET);
>           page = follow_huge_pmd(mm, address, pmd, flags & FOLL_WRITE);
>           goto out;
>   }
> 
> Note that this code currently doesn't work as intended if the pmd refers
> to a huge page, the pmd_huge() check can not be reached if the page is
> huge.
> 
> Extending pmd_bad() (and, for future 1GB page support, pud_bad()) to
> allow for the PSE bit being set fixes this. For similar reasons,
> allowing the NX bit being set is necessary, too. I have seen huge pages
> having the NX bit set in their pmd entry, which would cause the same
> problem.
 
Correct. Seems to be broken since ages. I applied your patch to fix
the primary problem, but ...

> --- a/include/asm-x86/pgtable_32.h
> +++ b/include/asm-x86/pgtable_32.h
> @@ -91,7 +91,9 @@ extern unsigned long pg0[];
>  /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
>  #define pmd_none(x)	(!(unsigned long)pmd_val(x))
>  #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
> -#define	pmd_bad(x)	((pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
> +#define	pmd_bad(x)	((pmd_val(x) \
> +			  & ~(PAGE_MASK | _PAGE_USER | _PAGE_PSE | _PAGE_NX)) \
> +			 != _KERNPG_TABLE)

So here we check for == _KERNPG_TABLE which includes the present bit as
well, so we mark it bad if its not present.
  
>  #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
> diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
> index bd4740a..02bd4aa 100644
> --- a/include/asm-x86/pgtable_64.h
> +++ b/include/asm-x86/pgtable_64.h
> @@ -153,12 +153,14 @@ static inline unsigned long pgd_bad(pgd_t pgd)
>  
>  static inline unsigned long pud_bad(pud_t pud)
>  {
> -	return pud_val(pud) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
> +	return pud_val(pud) &
> +		~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER | _PAGE_PSE | _PAGE_NX);
>  }

We return 0, when the present bit is 0, but the code which follows
does not check the present bit neither in mm/memory.c nor in
x86/mm/hugetlbpage.c. 

I think the correct solution is to not check the present bit in
pmd/pud_bad for both, but we need to check all the use cases in 32bit
thorougly.
  
Thanks,

	tglx
