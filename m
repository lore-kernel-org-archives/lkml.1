Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbXLHTBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbXLHTBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 14:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbXLHTBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 14:01:09 -0500
Received: from waste.org ([66.93.16.53]:58831 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbXLHTBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 14:01:09 -0500
Date: Sat, 8 Dec 2007 13:00:22 -0600
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52, [2.6.24-rc4-git5: Reported regressions from 2.6.23]
Message-ID: <20071208190021.GN19691@waste.org>
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu> <20071208163749.GI19691@waste.org> <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org> <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 09:54:06AM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 8 Dec 2007, Linus Torvalds wrote:
> > 
> > But I'll apply it anyway, because it looks "obviously correct" from the 
> > standpoint that the _other_??slob user already clears the end result 
> > explicitly later on, and we simply should never pass down __GFP_ZERO to 
> > the actual page allocator.
> 
> Actually, I take that back. The other slob users are different. They share 
> pages, this codepath does not.
> 
> So I think a more proper solution would be:
>  (a) Something like this patch (which includes my previous mm/slub.c 
>      change)
>  (b) don't warn about atomic GFP_ZERO's - unless they have GFP_HIGHMEM set 
>      *too*.
> 
> So which warning is it that triggers the bogus error?

While I think the whole GFP_ZERO thing is a bit broken here, this is
an improvement on my original patch, so:

Acked-by: Matt Mackall <mpm@selenic.com>
> ---
>  mm/slob.c |    2 +-
>  mm/slub.c |    3 +++
>  2 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/slob.c b/mm/slob.c
> index ee2ef8a..773a7aa 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -330,7 +330,7 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node)
>  
>  	/* Not enough space: must allocate a new page */
>  	if (!b) {
> -		b = slob_new_page(gfp, 0, node);
> +		b = slob_new_page(gfp & ~__GFP_ZERO, 0, node);
>  		if (!b)
>  			return 0;
>  		sp = (struct slob_page *)virt_to_page(b);
> diff --git a/mm/slub.c b/mm/slub.c
> index b9f37cb..9c1d9f3 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1468,6 +1468,9 @@ static void *__slab_alloc(struct kmem_cache *s,
>  	void **object;
>  	struct page *new;
>  
> +	/* We handle __GFP_ZERO in the caller */
> +	gfpflags &= ~__GFP_ZERO;
> +
>  	if (!c->page)
>  		goto new_slab;

-- 
Mathematics is the supreme nostalgia of our time.
