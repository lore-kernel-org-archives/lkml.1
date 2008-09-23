Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbYIWEnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbYIWEnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 00:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbYIWEnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 00:43:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:45472 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbYIWEm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 00:42:59 -0400
Date: Tue, 23 Sep 2008 06:42:57 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jan Beulich <jbeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make mm/gup.c more virtualization friendly
Message-ID: <20080923044257.GC11907@wotan.suse.de>
References: <48D142E1.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D142E1.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No objections from me.

On Wed, Sep 17, 2008 at 04:48:17PM +0100, Jan Beulich wrote:
> Since pte_flags() is much cheaper than pte_val() in some virtualized
> environments (namely, Xen), use the former whereever possible.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Nick Piggin <npiggin@suse.de>
> 
> ---
>  arch/x86/mm/gup.c         |   10 +++++-----
>  include/asm-x86/pgtable.h |    2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> --- linux-2.6.27-rc6/arch/x86/mm/gup.c	2008-08-21 14:37:29.000000000 +0200
> +++ 2.6.27-rc6-x86-gup-virt/arch/x86/mm/gup.c	2008-09-02 13:33:42.000000000 +0200
> @@ -82,7 +82,7 @@ static noinline int gup_pte_range(pmd_t 
>  		pte_t pte = gup_get_pte(ptep);
>  		struct page *page;
>  
> -		if ((pte_val(pte) & (mask | _PAGE_SPECIAL)) != mask) {
> +		if ((pte_flags(pte) & (mask | _PAGE_SPECIAL)) != mask) {
>  			pte_unmap(ptep);
>  			return 0;
>  		}
> @@ -116,10 +116,10 @@ static noinline int gup_huge_pmd(pmd_t p
>  	mask = _PAGE_PRESENT|_PAGE_USER;
>  	if (write)
>  		mask |= _PAGE_RW;
> -	if ((pte_val(pte) & mask) != mask)
> +	if ((pte_flags(pte) & mask) != mask)
>  		return 0;
>  	/* hugepages are never "special" */
> -	VM_BUG_ON(pte_val(pte) & _PAGE_SPECIAL);
> +	VM_BUG_ON(pte_flags(pte) & _PAGE_SPECIAL);
>  	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
>  
>  	refs = 0;
> @@ -173,10 +173,10 @@ static noinline int gup_huge_pud(pud_t p
>  	mask = _PAGE_PRESENT|_PAGE_USER;
>  	if (write)
>  		mask |= _PAGE_RW;
> -	if ((pte_val(pte) & mask) != mask)
> +	if ((pte_flags(pte) & mask) != mask)
>  		return 0;
>  	/* hugepages are never "special" */
> -	VM_BUG_ON(pte_val(pte) & _PAGE_SPECIAL);
> +	VM_BUG_ON(pte_flags(pte) & _PAGE_SPECIAL);
>  	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
>  
>  	refs = 0;
> --- linux-2.6.27-rc6/include/asm-x86/pgtable.h	2008-08-21 14:37:34.000000000 +0200
> +++ 2.6.27-rc6-x86-gup-virt/include/asm-x86/pgtable.h	2008-09-02 13:31:50.000000000 +0200
> @@ -183,7 +183,7 @@ static inline int pte_exec(pte_t pte)
>  
>  static inline int pte_special(pte_t pte)
>  {
> -	return pte_val(pte) & _PAGE_SPECIAL;
> +	return pte_flags(pte) & _PAGE_SPECIAL;
>  }
>  
>  static inline int pmd_large(pmd_t pte)
> 
> 
