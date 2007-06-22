Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbXFVE6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbXFVE6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 00:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbXFVE6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 00:58:05 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:41271 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbXFVE6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 00:58:03 -0400
Date: Fri, 22 Jun 2007 05:40:01 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAACmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAY2xhbWV0ZXJAc2dpLmNvbQBhbmRyZXdAc2FucGVvcGxlLmNvbQBuaWNvbGFzLmZlcnJlQHJmby5hdG1lbC5jb20AbGludXgtYXJtLWtlcm5lbEBsaXN0cy5hcm0ubGludXgub3JnLnVrAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAdG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmcAbWFyYy5waWduYXRAaGV2cy5jaABkcnpldXNAZHJ6ZXVzLmN4AHJta0Bhcm0ubGludXgub3JnLnVrAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Christoph Lameter wrote:

> Maybe this will address the issue on ARM?

Looks like it would indeed address the immediate issue on ARM -
IF they've no particular reason to be using kmalloc there.

However... what gives you confidence that flush_dcache_page is
never applied to other slab pages?

This looks to me like a clean way forward to try in -mm; but that
2.6.22 should go with the safety PageSlab test in page_mapping.

Hugh

> 
> 
> ARM: Allocate dma pages via the page allocator and not via the slab allocator
> 
> Slab allocations are not guaranteed to be page aligned and slab allocators
> may use the page structs for their own purposes. Using the page allocator
> yields a properly aligned page and also makes the page flushing logic work right.
> 
> Passing a kmalloced "page" to a flushing function will not work reliably.
> 
> This will hopefully address the issue with SLUB on ARM. SLUB uses the
> page->mapping field which is also checked by the flushing logic. The
> flushing logic expects a normal page and not a slab page.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  arch/arm/mm/consistent.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/arm/mm/consistent.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/mm/consistent.c	2007-06-21 18:18:15.000000000 -0700
> +++ linux-2.6/arch/arm/mm/consistent.c	2007-06-21 18:29:16.000000000 -0700
> @@ -277,7 +277,7 @@ dma_alloc_coherent(struct device *dev, s
>  	if (arch_is_coherent()) {
>  		void *virt;
>  
> -		virt = kmalloc(size, gfp);
> +		virt = get_free_pages(gfp, get_order(size));
>  		if (!virt)
>  			return NULL;
>  		*handle =  virt_to_dma(dev, virt);
> @@ -364,7 +364,7 @@ void dma_free_coherent(struct device *de
>  	WARN_ON(irqs_disabled());
>  
>  	if (arch_is_coherent()) {
> -		kfree(cpu_addr);
> +		free_pages((unsigned long)cpu_addr, get_order(size));
>  		return;
>  	}
>  
> 
