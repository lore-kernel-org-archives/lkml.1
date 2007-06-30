Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbXF3OnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbXF3OnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 10:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbXF3OnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 10:43:18 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:60479 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523AbXF3OnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 10:43:17 -0400
Date: Sat, 30 Jun 2007 15:04:22 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch 5/5] Optimize page_mkclean_one
In-Reply-To: <20070629141528.511942868@de.ibm.com>
Message-ID: <Pine.LNX.4.64.0706301448450.13752@blonde.wat.veritas.com>
References: <20070629135530.912094590@de.ibm.com> <20070629141528.511942868@de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAbGludXgtbW1Aa3ZhY2sub3JnAHBldGVyekBpbmZyYWRlYWQub3JnAHNjaHdpZGVmc2t5QGRlLmlibS5jb20A
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007, Martin Schwidefsky wrote:
> On Fri, 2007-06-29 at 19:56 +0100, Hugh Dickins wrote:
> > I don't dare comment on your page_mkclean_one patch (5/5),
> > that dirty page business has grown too subtle for me.
> 
> Oh yes, the dirty handling is tricky. I had to fix a really nasty bug
> with it lately. As for page_mkclean_one the difference is that it
> doesn't claim a page is dirty if only the write protect bit has not been
> set. If we manage to lose dirty bits from ptes and have to rely on the
> write protect bit to take over the job, then we have a different problem
> altogether, no ?

[Moving that over from 1/5 discussion].

Expect you're right, but I _really_ don't want to comment, when I don't
understand that "|| pte_write" in the first place, and don't know the
consequence of pte_dirty && !pte_write or !pte_dirty && pte_write there.
Peter?

My suspicion is that the "|| pte_write" is precisely to cover your
s390 case where pte is never dirty (it may even have been me who got
Peter to put it in for that reason).  In which case your patch would
be fine - though I think it'd be improved a lot by a comment or
rearrangement or new macro in place of the pte_dirty || pte_write
line (perhaps adjust my pte_maybe_dirty in asm-generic/pgtable.h,
and use that - its former use in msync has gone away now).

Hugh

On Fri, 29 Jun 2007, Martin Schwidefsky wrote:

> page_mkclean_one is used to clear the dirty bit and to set the write
> protect bit of a pte. In additions it returns true if the pte either
> has been dirty or if it has been writable. As far as I can see the
> function should return true only if the pte has been dirty, or page
> writeback will needlessly write a clean page.
> 
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
> 
>  mm/rmap.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff -urpN linux-2.6/mm/rmap.c linux-2.6-patched/mm/rmap.c
> --- linux-2.6/mm/rmap.c	2007-06-29 09:58:33.000000000 +0200
> +++ linux-2.6-patched/mm/rmap.c	2007-06-29 15:44:58.000000000 +0200
> @@ -433,11 +433,12 @@ static int page_mkclean_one(struct page 
>  
>  		flush_cache_page(vma, address, pte_pfn(*pte));
>  		entry = ptep_clear_flush(vma, address, pte);
> +		if (pte_dirty(entry))
> +			ret = 1;
>  		entry = pte_wrprotect(entry);
>  		entry = pte_mkclean(entry);
>  		set_pte_at(mm, address, pte, entry);
>  		lazy_mmu_prot_update(entry);
> -		ret = 1;
>  	}
>  
>  	pte_unmap_unlock(pte, ptl);
