Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbYDQToh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbYDQToh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 15:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbYDQTo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 15:44:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbYDQToZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 15:44:25 -0400
Date: Thu, 17 Apr 2008 12:43:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417124353.30fe1d06.akpm@linux-foundation.org>
In-Reply-To: <19f34abd0804171147l4403d49aoeab005105a90392b@mail.gmail.com>
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
	<20080417083000.GA4935@elte.hu>
	<20080417014054.ea788f1f.akpm@linux-foundation.org>
	<20080417090626.GA14383@elte.hu>
	<20080417021813.04df7912.akpm@linux-foundation.org>
	<20080417093025.GA17389@elte.hu>
	<20080417023603.672d1032.akpm@linux-foundation.org>
	<19f34abd0804171147l4403d49aoeab005105a90392b@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 20:47:06 +0200
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> On Thu, Apr 17, 2008 at 11:36 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Thu, 17 Apr 2008 11:30:25 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> >  > you mean kmemcheck? Yes, that's planned. We've been working 4 months
> >  > non-stop on kmemcheck to make it mergeable and usable, it's at version 7
> >  > right now, and it caught a handful of real bugs already (such as
> >  > 63a7138671c - unfortunately not credited in the log to kmemcheck). But
> >  > because it touches SLUB (because it has to - and they are acked by
> >  > Pekka) i never had the chance to move it into the for-akpm branch.
> >
> >  Does it really really really need to consume one of our few remaining page
> >  flags?  We'll be in a mess when we run out.
> 
> Actually it doesn't. I attach a patch which gets rid of the page flag,
> and we rely instead on the PTE flag for page-trackedness.
> 
> The reason we didn't do this at once is that the making of kmemcheck
> has been pretty much my first introduction to SLUB, x86, page flags,
> etc., and the actual semantics of the various introduced flags have
> varied since the first version of kmemcheck. At this point, the struct
> page flags weren't actually needed anymore, but they were convenient.
> 
> My apologies for not inlining the patch -- I don't have a mail client
> that won't mess up whitespace. It can also be downloaded at:
> http://folk.uio.no/vegardno/linux/0001-kmemcheck-remove-use-of-tracked-page-flag.patch
> 
> The patch has received minimal amount of testing, but I've
> double-checked the logic. It boots fine on my laptop, boot log at:
> http://folk.uio.no/vegardno/linux/kmemcheck-20080417.txt
> 
> Ingo, will you take this for some additional testing?
> 

If you're OK with doing it this way then it would be preferable.

> diff --git a/arch/x86/kernel/kmemcheck.c b/arch/x86/kernel/kmemcheck.c
> index 16dce10..d82f35d 100644
> --- a/arch/x86/kernel/kmemcheck.c
> +++ b/arch/x86/kernel/kmemcheck.c
> @@ -233,12 +233,27 @@ param_kmemcheck(char *str)
>  	if (!str)
>  		return -EINVAL;
>  
> -	sscanf("%d", str, &kmemcheck_enabled);
> +	sscanf(str, "%d", &kmemcheck_enabled);
>  	return 0;
>  }

whoops.  Note to Ingo: unrelated bugfix in there.

>  early_param("kmemcheck", param_kmemcheck);

kmemcheck= is documented in at least three places, which is nice, but it
isn't mentioned in the place where we document kernel-parameters:
Documentation/kernel-parameters.txt.  A brief section there which directs
the user to the extended docs would be fine.

early_param() is unusual - we normally use __setup().  I assume there's a
reason for using early_param(), but that reason cannot be discerned from
reading the code.  A /*comment*/ is the way to fix that.

> +static pte_t *
> +address_get_pte(unsigned int address)

This is not the preferred way of laying out function declarations but I've
basically given up on this one.

> +{
> +	pte_t *pte;
> +	int level;
> +
> +	pte = lookup_address(address, &level);
> +	if (!pte)
> +		return NULL;
> +	if (!pte_hidden(*pte))
> +		return NULL;
> +
> +	return pte;
> +}
> +
>  /*
>   * Return the shadow address for the given address. Returns NULL if the
>   * address is not tracked.
> @@ -249,88 +264,53 @@ early_param("kmemcheck", param_kmemcheck);
>  static void *
>  address_get_shadow(unsigned long address)
>  {
> +	pte_t *pte;
>  	struct page *page;
>  	struct page *head;
>  
>  	if (!virt_addr_valid(address))
>  		return NULL;
>  
> +	pte = address_get_pte(address);
> +	if (!pte)
> +		return NULL;
> +
>  	/* The accessed page */
>  	page = virt_to_page(address);
> -	if (!PageCompound(page))
> -		return NULL;
> +	BUG_ON(!PageCompound(page));
>  
>  	/* The head page */
>  	head = compound_head(page);
> -	if (!PageTracked(head))
> -		return NULL;
> +	BUG_ON(compound_order(head) == 0);
>  
>  	return (void *) address + (PAGE_SIZE << (compound_order(head) - 1));
>  }

	(void *)address

is more common, but I'm close to giving up on that too.

>  static int
> -show_addr(uint32_t addr)
> +show_addr(uint32_t address)

u32 is preferred, but ditto.

>  {
>  	pte_t *pte;
> -	int level;
> -
> -	if (!address_get_shadow(addr))
> -		return 0;
> -
> -	pte = lookup_address(addr, &level);
> -	BUG_ON(!pte);
> -
> -	if (level != PG_LEVEL_4K)
> -		return 0;
> -
> -	set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
> -	__flush_tlb_one(addr);
> -	return 1;
> -}
>
> ...
>
> --- a/include/linux/kmemcheck.h
> +++ b/include/linux/kmemcheck.h
> @@ -9,6 +9,8 @@ void kmemcheck_init(void);
>  void kmemcheck_show_pages(struct page *p, unsigned int n);
>  void kmemcheck_hide_pages(struct page *p, unsigned int n);
>  
> +bool kmemcheck_page_is_tracked(struct page *p);
> +
>  void kmemcheck_mark_unallocated(void *address, unsigned int n);
>  void kmemcheck_mark_uninitialized(void *address, unsigned int n);
>  void kmemcheck_mark_initialized(void *address, unsigned int n);
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 63f5fd8..3696889 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -89,7 +89,6 @@
>  #define PG_mappedtodisk		16	/* Has blocks allocated on-disk */
>  #define PG_reclaim		17	/* To be reclaimed asap */
>  #define PG_buddy		19	/* Page is free, on buddy lists */
> -#define PG_tracked		20	/* Tracked by kmemcheck */
>  
>  /* PG_readahead is only used for file reads; PG_reclaim is only for writes */
>  #define PG_readahead		PG_reclaim /* Reminder to do async read-ahead */
> @@ -297,10 +296,6 @@ static inline void __ClearPageTail(struct page *page)
>  #define SetPageUncached(page)	set_bit(PG_uncached, &(page)->flags)
>  #define ClearPageUncached(page)	clear_bit(PG_uncached, &(page)->flags)
>  
> -#define PageTracked(page)	test_bit(PG_tracked, &(page)->flags)
> -#define SetPageTracked(page)	set_bit(PG_tracked, &(page)->flags)
> -#define ClearPageTracked(page)	clear_bit(PG_tracked, &(page)->flags)
> -

That's about 15 less rejects I have to fix ;)
 
>  struct page;	/* forward declaration */
>  
> diff --git a/mm/slub.c b/mm/slub.c
> index 9b58979..7a544e6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1125,7 +1125,7 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
>  		ClearSlabDebug(page);
>  	}
>  
> -	if (PageTracked(page) && !(s->flags & SLAB_NOTRACK)) {
> +	if (kmemcheck_page_is_tracked(page) && !(s->flags & SLAB_NOTRACK)) {
>  		kmemcheck_free_slab(s, page, pages);
>  		return;
>  	}

Perhaps we should get all this code onto the list(s) for re-review.  It's
been a while..

