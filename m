Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYG3Fah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYG3Fah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 01:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYG3Fa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 01:30:28 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:23997 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751403AbYG3Fa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 01:30:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=k8I4ao1fjAbNPxbU6xBEfey9y07gMoz/xT//Cga0HpNGAgPvkCCfbqBMUdUcFfoS5yRO0LhUpQ+irHwjtAKGFH2oMqTt3tYKBkOodrGH6dydASL9IzG+XIeKw0zUIbCnnIfO52oce7fs8SUzlqbG6Wi65jAeDwmx3rafzUe7kQ4=  ;
X-YMail-OSG: IxkZ73AVM1l1RP6kpB2gEa3.MS432ggQYmD264hr5X6FMdEI9G_tNmN.zpio0S65iMT9kvz1W_miL0fYdvCl5LFi8R6eoz8c7qdigmFPfL4oP6U7gXZOgKsB10lnfc8v0Ak-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/2] lguest: use get_user_pages_fast() instead of get_user_pages()
Date: Wed, 30 Jul 2008 15:30:10 +1000
User-Agent: KMail/1.9.5
Cc: lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org
References: <200807301438.55941.rusty@rustcorp.com.au> <200807301439.47856.rusty@rustcorp.com.au>
In-Reply-To: <200807301439.47856.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807301530.10205.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008 14:39, Rusty Russell wrote:
> Using a simple page table thrashing program I measure a slight
> improvement.  The program creates five processes.  Each touches 1000
> pages then schedules the next process.  We repeat this 1000 times.  As
> lguest only caches 4 cr3 values, this rebuilds a lot of shadow page
> tables requiring virt->phys mappings.
>
> 	Before: 5.93 seconds
> 	After: 5.40 seconds
>
> (Counts of slow vs fastpath in this usage are 6092 and 2852462
> respectively.)
>
> And more importantly for lguest, the code is simpler.

Cool. That's actually a fairly significant straight-line performance
improvement, given that the lguest processes are running one-at-a-time
right? (and not contending on the locks or bouncing cachelines too much)

Nice.

>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/lguest/page_tables.c |   25 +++++++++----------------
>  1 file changed, 9 insertions(+), 16 deletions(-)
>
> diff -r cb465381f6d5 drivers/lguest/page_tables.c
> --- a/drivers/lguest/page_tables.c	Wed Jul 30 10:18:44 2008 +1000
> +++ b/drivers/lguest/page_tables.c	Wed Jul 30 12:11:42 2008 +1000
> @@ -108,9 +108,8 @@ static unsigned long gpte_addr(pgd_t gpg
>  }
>  /*:*/
>
> -/*M:014 get_pfn is slow; it takes the mmap sem and calls get_user_pages. 
> We - * could probably try to grab batches of pages here as an optimization
> - * (ie. pre-faulting). :*/
> +/*M:014 get_pfn is slow: we could probably try to grab batches of pages
> here as + * an optimization (ie. pre-faulting). :*/
>
>  /*H:350 This routine takes a page number given by the Guest and converts
> it to * an actual, physical page number.  It can fail for several reasons:
> the @@ -123,19 +122,13 @@ static unsigned long get_pfn(unsigned lo
>  static unsigned long get_pfn(unsigned long virtpfn, int write)
>  {
>  	struct page *page;
> +
> +	/* gup me one page at this address please! */
> +	if (get_user_pages_fast(virtpfn << PAGE_SHIFT, 1, write, &page) == 1)
> +		return page_to_pfn(page);
> +
>  	/* This value indicates failure. */
> -	unsigned long ret = -1UL;
> -
> -	/* get_user_pages() is a complex interface: it gets the "struct
> -	 * vm_area_struct" and "struct page" assocated with a range of pages.
> -	 * It also needs the task's mmap_sem held, and is not very quick.
> -	 * It returns the number of pages it got. */
> -	down_read(&current->mm->mmap_sem);
> -	if (get_user_pages(current, current->mm, virtpfn << PAGE_SHIFT,
> -			   1, write, 1, &page, NULL) == 1)
> -		ret = page_to_pfn(page);
> -	up_read(&current->mm->mmap_sem);
> -	return ret;
> +	return -1UL;
>  }
>
>  /*H:340 Converting a Guest page table entry to a shadow (ie. real) page
> table @@ -174,7 +167,7 @@ static pte_t gpte_to_spte(struct lg_cpu
>  /*H:460 And to complete the chain, release_pte() looks like this: */
>  static void release_pte(pte_t pte)
>  {
> -	/* Remember that get_user_pages() took a reference to the page, in
> +	/* Remember that get_user_pages_fast() took a reference to the page, in
>  	 * get_pfn()?  We have to put it back now. */
>  	if (pte_flags(pte) & _PAGE_PRESENT)
>  		put_page(pfn_to_page(pte_pfn(pte)));
