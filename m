Return-Path: <linux-kernel-owner+w=401wt.eu-S1759496AbXIVFca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbXIVFca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 01:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbXIVFcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 01:32:23 -0400
Received: from barikada.upol.cz ([158.194.242.200]:57787 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbXIVFcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 01:32:22 -0400
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [13/50] x86: Fix and reenable CLFLUSH support in change_page_attr()
In-Reply-To: <20070921223211.BB50413DCD@wotan.suse.de>
References: <200709221231.836138000@suse.de> <20070921223211.BB50413DCD@wotan.suse.de>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Sat, 22 Sep 2007 07:47:59 +0200
Message-Id: <E1IYxqR-0004uA-EA@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Sat, 22 Sep 2007 00:32:11 +0200 (CEST)
[]
> -	flush_map(&l);
> +	flush_map(&arg);

  +	flush_map(&arg.l);

  CC      arch/x86_64/mm/pageattr.o
arch/x86_64/mm/pageattr.c: In function 'global_flush_tlb':
arch/x86_64/mm/pageattr.c:274: warning: passing argument 1 of 'flush_map' from incompatible pointer type

(for i386 seems too)

[]  
> +#define PageFlush(p) test_bit(PG_owner_priv_1, &(p)->flags)
> +#define SetPageFlush(p) set_bit(PG_owner_priv_1, &(p)->flags)
> +#define TestClearPageFlush(p) test_and_clear_bit(PG_owner_priv_1, &(p)->flags)

Is it worth introducing more of that Pascal style? Yes, page stuff is
all about it, but still.

[]
> +static struct page *flush_page(unsigned long address)
>  {
> -	if (!test_and_set_bit(PG_arch_1, &kpte_page->flags))
> -		list_add(&kpte_page->lru, &df_list);
> +	struct page *p;
> +	if (!(pfn_valid(__pa(address) >> PAGE_SHIFT)))
> +		return NULL;
> +	p = virt_to_page(address);
> +	if ((PageFlush(p) || PageLRU(p)) && !test_bit(PG_arch_1, &p->flags))
> +		return NULL;
> +	return p;
>  }

Saves 16 bytes in non optimized compile (if tcc will ever do this :)

static struct page *flush_page(unsigned long address)
{
	struct page *p = NULL;

	if (pfn_valid(__pa(address) >> PAGE_SHIFT)) {
		p = virt_to_page(address);
		if (PageFlush(p) || PageLRU(p))
			if (!test_bit(PG_arch_1, &p->flags))
				p = NULL;
	}
	return p;
}

>  static int
> @@ -158,6 +185,18 @@ __change_page_attr(struct page *page, pg
>  	kpte_page = virt_to_page(kpte);
>  	BUG_ON(PageLRU(kpte_page));
>  	BUG_ON(PageCompound(kpte_page));
> +	BUG_ON(PageLRU(kpte_page));
> +
> +	/* Do caching attributes change?
> +	   Note: this will need changes if the PAT bit is used (it isn't
> +   	   currently) because that one varies between 2MB and 4K pages. */
> +	if ((pte_val(*kpte)&_PAGE_CACHE) != (pgprot_val(prot)&_PAGE_CACHE)) {
> +		struct page *p = flush_page(address);
> +		if (!p)
> +			full_flush = 1;
> +		else
> +			save_page(p, 1);
> +	}
>  
>  	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) { 
>  		if (!pte_huge(*kpte)) {
> @@ -189,7 +228,7 @@ __change_page_attr(struct page *page, pg
>  	 * replace it with a largepage.
>  	 */
>  
> -	save_page(kpte_page);
> +	save_page(kpte_page, 0);
>  	if (!PageReserved(kpte_page)) {
>  		if (cpu_has_pse && (page_private(kpte_page) == 0)) {
>  			paravirt_release_pt(page_to_pfn(kpte_page));
> @@ -235,18 +274,22 @@ int change_page_attr(struct page *page, 
>  
>  void global_flush_tlb(void)
>  {
> -	struct list_head l;
> +	struct flush_arg arg;
>  	struct page *pg, *next;
>  
>  	BUG_ON(irqs_disabled());
>  
>  	spin_lock_irq(&cpa_lock);
> -	list_replace_init(&df_list, &l);
> +	arg.full_flush = full_flush;
> +	full_flush = 0;
> +	list_replace_init(&df_list, &arg.l);
>  	spin_unlock_irq(&cpa_lock);
> -	flush_map(&l);
> -	list_for_each_entry_safe(pg, next, &l, lru) {
> +	flush_map(&arg);

i386 case here.
____
