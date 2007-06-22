Return-Path: <linux-kernel-owner+w=401wt.eu-S1760564AbXFVSkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564AbXFVSkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759446AbXFVSkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:40:20 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:50238 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759377AbXFVSkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:40:18 -0400
Date: Fri, 22 Jun 2007 19:39:33 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
 <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAACmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAY2xhbWV0ZXJAc2dpLmNvbQBhbmRyZXdAc2FucGVvcGxlLmNvbQBuaWNvbGFzLmZlcnJlQHJmby5hdG1lbC5jb20AbGludXgtYXJtLWtlcm5lbEBsaXN0cy5hcm0ubGludXgub3JnLnVrAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAdG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmcAbWFyYy5waWduYXRAaGV2cy5jaABkcnpldXNAZHJ6ZXVzLmN4AHJta0Bhcm0ubGludXgub3JnLnVrAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Christoph Lameter wrote:
> 
> Add VM_BUG_ON in case someone uses page_mapping on a slab page
> 
> Detect slab objects being passed to the page oriented functions of the VM.
> 
> It is not sufficient to simply return NULL because the functions calling
> page_mapping may depend on other items of the page_struct also to be setup
> properly. Moreover the slab object may not be properly aligned. The page 
> orientedfunctions of the VM expect to operate on page aligned, page sized 
> objects. operations on objects straddling page boundaries may only affect 
> the objects partially which may lead to surprising results.
> 
> It is better to detect eventually remaining uses and eliminate them.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>

I'm quite happy with this approach for 2.6.23-rc, along with your ARM
dma_map patch which (if I understood aright) rmk approved.  Except,
haven't you misplaced that VM_BUG_ON between an if and its else?
And I'd much prefer you to make it an outright BUG_ON, because
many testers have those VM_BUG_ONs configured out.

Hugh

> 
> ---
>  include/linux/mm.h |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> Index: linux-2.6/include/linux/mm.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mm.h	2007-06-22 10:33:27.000000000 -0700
> +++ linux-2.6/include/linux/mm.h	2007-06-22 10:34:09.000000000 -0700
> @@ -603,10 +603,7 @@ static inline struct address_space *page
>  
>  	if (unlikely(PageSwapCache(page)))
>  		mapping = &swapper_space;
> -#ifdef CONFIG_SLUB
> -	else if (unlikely(PageSlab(page)))
> -		mapping = NULL;
> -#endif
> +	VM_BUG_ON(PageSlab(page));
>  	else if (unlikely((unsigned long)mapping & PAGE_MAPPING_ANON))
>  		mapping = NULL;
>  	return mapping;
> 
