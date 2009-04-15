Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbZDOIXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbZDOIXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbZDOIWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:22:43 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:45936 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752218AbZDOIWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:22:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HLE8xHTrq4boCv8vIp7nhr0GkOzDJxXGxw+CZ0+JtQbMTe8SkrS91VfJAgDPCa/x0TSB+eh6i48sdzDazvAfEDv+Av4atgMTCN+QymzEV4KRK7leMGsBdcojsYOGekvXB12aTEoNVzV5l/qwbkU6Z65sNJ1e7rKzV9KmFasSASg=  ;
X-YMail-OSG: Lu_1LkUVM1mC3gq0BVD3Ff3ZXO_N7NqM74MO656IR0vVAzjqwbEeVJZT8e8dHXgQl5LlImMnXI7Z9mD2IunDCoU7OSbn9zsb_B_IsKWThYLth6AJpsDGcqIMAsfyUR8VJlMW7A5OUfeiRGQvBM4LSMLar.LCTWRRQE3APWxmZpMz8tZ9xCHanHPM9eOeywvM0xOP33j6SN3izXIgchuF0ZlqLE2Qk0DhY0wMmmUxbN2SSQL5IEhmezfJGvSICmrDGB4zUKTRxKoSTyMYDDdFJyMfmX.1.m5KERPmPNv.yI4FS4iJoaEm
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH v3 1/6] mm: Don't unmap gup()ed page
Date: Wed, 15 Apr 2009 18:22:32 +1000
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Jeff Moyer <jmoyer@redhat.com>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>
References: <20090414143252.GE28265@random.random> <200904150042.15653.nickpiggin@yahoo.com.au> <20090415165431.AC4C.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090415165431.AC4C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904151822.33478.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 April 2009 18:05:54 KOSAKI Motohiro wrote:
> Hi
> 
> > On Wednesday 15 April 2009 00:32:52 Andrea Arcangeli wrote:
> > > On Wed, Apr 15, 2009 at 12:26:34AM +1000, Nick Piggin wrote:
> > > > Andrea: I didn't veto that set_bit change of yours as such. I just
> > > 
> > > I know you didn't ;)
> > > 
> > > > noted there could be more atomic operations. Actually I would
> > > > welcome more comparison between our two approaches, but they seem
> > > 
> > > Agree about the welcome of comparison, it'd be nice to measure it the
> > > enterprise workloads that showed the gup_fast gain in the first place.
> > 
> > I think we should be able to ask IBM to run some tests, provided
> > they still have machines available to do so. Although I don't want
> > to waste their time so we need to have something that has got past
> > initial code review and has a chance of being merged.
> > 
> > If we get that far, then I can ask them to run tests definitely.
> 
> Oh, it seem very charming idea.
> Nick, I hope to help your patch's rollup. It makes good comparision, I think.
> Is there my doable thing?

Well, I guess review and testing. There are few possibilities for
reducing the cases where we have to de-cow (or increasing the
cases where we can WP-on-fork), which I'd like to experiment with,
but I don't know how much it will help...


> And, I changed my patch.
> How about this? I added simple twice check.
> 
> because, both do_wp_page and try_to_unmap_one grab ptl. then,
> page-fault routine can't change pte while try_to_unmap nuke pte.

Hmm,

> @@ -790,7 +796,19 @@ static int try_to_unmap_one(struct page 
>  
>  	/* Nuke the page table entry. */
>  	flush_cache_page(vma, address, page_to_pfn(page));
> -	pteval = ptep_clear_flush_notify(vma, address, pte);
> +	pteval = ptep_clear_flush(vma, address, pte);
> +
> +	if (!migration) {
> +		/* re-check */
> +		if (PageSwapCache(page) &&
> +		    page_count(page) != page_mapcount(page) + 2) {
> +			/* We lose race against get_user_pages_fast() */
> +			set_pte_at(mm, address, pte, pteval);
> +			ret = SWAP_FAIL;
> +			goto out_unmap;
> +		}
> +	}
> +	mmu_notifier_invalidate_page(vma->vm_mm, address);

Hmm, in the case of powerpc-style gup_fast where the arch
does not send IPIs to flush TLBs, either the speculative
reference there should find the pte cleared, or the page_count
check here should find the speculative reference.

In the case of CPUs that do send IPIs and have x86-style
gup_fast, the TLB flush should ensure all gup_fast()s that
could have seen the pte will complete before we check
page_count.

Yes I think it might work.
