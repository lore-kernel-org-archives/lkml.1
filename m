Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbZEDTX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbZEDTX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZEDTXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:23:47 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48522 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbZEDTXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:23:47 -0400
Date: Mon, 4 May 2009 20:23:43 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH -tip] mm: introduce __GFP_PANIC modifier
Message-ID: <20090504192342.GA19481@csn.ul.ie>
References: <20090504122740.GH4173@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090504122740.GH4173@lenovo>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 04:27:40PM +0400, Cyrill Gorcunov wrote:
> Hi,
> 
> here is an attempt to bring in __GFP_PANIC modifier.
> The patch is made on top of -tip repo. I've been
> trying to apply it in top of -mm tree but it
> seems -tip is a bit newer, at least it already
> has __GFP_BITS_SHIFT = 22 defined.
> 
> Mel, could you take a look?
> 

I'm not seeing any users of the new flag so I'm not sure what your intended
use for the flag is.  Maybe it would have a small saving on call-sites that
panic but as they are boot-time functions, I would expect the memory is
getting freed anyway.

If this is about should_failslab(), can it be determined that we should not
fail another way? For example, never randomly fail the allocation if the
system is booting and __GFP_NOFAIL is specified.

> For easier review -- here is what is done:
> 1) __GFP_PANIC introduced
> 2) __alloc_pages_internal now checks for this flag
>    and panic if needed.
> 
> 	-- Cyrill
> ---
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: [PATCH -tip] mm: introduce __GFP_PANIC modifier
> 
> Sometime we need that memory obtained via kmalloc
> is always granted cause if there is not enough memory
> we just can't go further.
> 
> For such a case we introduce __GFP_PANIC modificator
> If memory can't be granted -- we just panic and halt.
> 
> Note 1: it trigger panic only if we reach out-of-memory
> situation. MAX_ORDER and SLAB built-in constants are
> not covered by intent.
> 
> Note 2: __GFP_PANIC implicitly turn off failslab
> facility on such kind of calls.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  include/linux/gfp.h |    4 +++-
>  mm/failslab.c       |    3 +++
>  mm/page_alloc.c     |   10 ++++++++--
>  3 files changed, 14 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.git/include/linux/gfp.h
> =====================================================================
> --- linux-2.6.git.orig/include/linux/gfp.h
> +++ linux-2.6.git/include/linux/gfp.h
> @@ -58,7 +58,9 @@ struct vm_area_struct;
>  #define __GFP_NOTRACK	((__force gfp_t)0)
>  #endif
>  
> -#define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */
> +#define __GFP_PANIC	((__force gfp_t)0x400000u) /* Panic on page alloction failure */
> +
> +#define __GFP_BITS_SHIFT 23	/* Room for 23 __GFP_FOO bits */
>  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
>  
>  /* This equals 0, but use constants in case they ever change */
> Index: linux-2.6.git/mm/failslab.c
> =====================================================================
> --- linux-2.6.git.orig/mm/failslab.c
> +++ linux-2.6.git/mm/failslab.c
> @@ -17,6 +17,9 @@ bool should_failslab(size_t size, gfp_t 
>  	if (gfpflags & __GFP_NOFAIL)
>  		return false;
>  
> +	if (gfpflags & __GFP_PANIC)
> +		return false;
> +
>          if (failslab.ignore_gfp_wait && (gfpflags & __GFP_WAIT))
>  		return false;
>  
> Index: linux-2.6.git/mm/page_alloc.c
> =====================================================================
> --- linux-2.6.git.orig/mm/page_alloc.c
> +++ linux-2.6.git/mm/page_alloc.c
> @@ -1185,6 +1185,8 @@ static int should_fail_alloc_page(gfp_t 
>  		return 0;
>  	if (gfp_mask & __GFP_NOFAIL)
>  		return 0;
> +	if (gfp_mask & __GFP_PANIC)
> +		return 0;
>  	if (fail_page_alloc.ignore_gfp_highmem && (gfp_mask & __GFP_HIGHMEM))
>  		return 0;
>  	if (fail_page_alloc.ignore_gfp_wait && (gfp_mask & __GFP_WAIT))
> @@ -1506,7 +1508,7 @@ restart:
>  		 * Happens if we have an empty zonelist as a result of
>  		 * GFP_THISNODE being used on a memoryless node
>  		 */
> -		return NULL;
> +		goto nopage;
>  	}
>  
>  	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
> @@ -1685,7 +1687,11 @@ nopage:
>  		dump_stack();
>  		show_mem();
>  	}
> -	return page;
> +	if (unlikely(gfp_mask & __GFP_PANIC))
> +		panic("Out of memory: panic due to __GFP_PANIC."
> +			" %s order:%d, gfp_mask:0x%x\n", p->comm,
> +			order, gfp_mask);
> +	return NULL;
>  got_pg:
>  	if (kmemcheck_enabled)
>  		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
