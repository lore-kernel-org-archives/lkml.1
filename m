Return-Path: <linux-kernel-owner+w=401wt.eu-S935549AbXGMSZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935549AbXGMSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbXGMSZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:25:16 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:26605 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbXGMSZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:25:14 -0400
Date: Fri, 13 Jul 2007 11:27:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [rfc][patch] slob: improvements
Message-Id: <20070713112725.d75acf1d.randy.dunlap@oracle.com>
In-Reply-To: <20070515233347.GA20468@wotan.suse.de>
References: <20070515084305.GA28631@wotan.suse.de>
	<20070515151731.GO11115@waste.org>
	<20070515233347.GA20468@wotan.suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 01:33:47 +0200 Nick Piggin wrote:

> On Tue, May 15, 2007 at 10:17:31AM -0500, Matt Mackall wrote:
> > On Tue, May 15, 2007 at 10:43:05AM +0200, Nick Piggin wrote:
> > > This patch goes on top of my previous RCU patch, and has various
> > > improvements for slob I noticed while implementing said patch ;)
> > > 
> > > Comments?
> > 
> > I'm warming to this. Please check that the comment block at the top is
> > still accurate.
> 
> It wasn't, fixed.
> 
> 
...
> 
> Here is an updated version.
> ---
> 
> Improve slob by turning the freelist into a list of pages using struct page
> fields, then each page has a singly linked freelist of slob blocks via a
> pointer in the struct page.
> 
> - The first benefit is that the slob freelists can be indexed by a smaller
>   type (2 bytes, if the PAGE_SIZE is reasonable).
> 
> - Next is that freeing is much quicker because it does not have to traverse
>   the entire freelist. Allocation can be slightly faster too, because we can
>   skip almost-full freelist pages completely.
> 
> - Slob pages are then freed immediately when they become empty, rather than
>   having a periodic timer try to free them. This gives efficiency and memory
>   consumption improvement.
> 
> 
> Then, we don't encode seperate size and next fields into each slob block,
> rather we use the sign bit to distinguish between "size" or "next". Then
> size 1 blocks contain a "next" offset, and others contain the "size" in
> the first unit and "next" in the second unit.
> 
> - This allows minimum slob allocation alignment to go from 8 bytes to 2
>   bytes on 32-bit and 12 bytes to 2 bytes on 64-bit. In practice, it is
>   best to align them to word size, however some architectures (eg. cris)
>   could gain space savings from turning off this extra alignment.
> 
> 
> Then, make kmalloc use its own slob_block at the front of the allocation
> in order to encode allocation size, rather than rely on not overwriting
> slob's existing header block.
> 
> - This reduces kmalloc allocation overhead similarly to alignment reductions.
> 
> - Decouples kmalloc layer from the slob allocator.
> 
> 
> Then, add a page flag specific to slob pages.
> 
> - This means kfree of a page aligned slob block doesn't have to traverse
>   the bigblock list.
> 
> 
> I would get benchmarks, but my test box's network doesn't come up with
> slob before this patch. I think something is timing out. Anyway, things
> are faster after the patch.
> 
> Code size goes up about 1K, however dynamic memory usage _should_ be
> lower even on relatively small memory systems.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> 
> ---
> Index: linux-2.6/init/Kconfig
> ===================================================================
> --- linux-2.6.orig/init/Kconfig
> +++ linux-2.6/init/Kconfig
> @@ -529,7 +529,7 @@ config SLUB
>  	   way and has enhanced diagnostics.
>  
>  config SLOB
> -	depends on EMBEDDED && !SPARSEMEM
> +	depends on EMBEDDED && !SPARSEMEM && !ARCH_USES_SLAB_PAGE_STRUCT
>  	bool "SLOB (Simple Allocator)"
>  	help
>  	   SLOB replaces the SLAB allocator with a drastically simpler

Is this patch going in?  I have a randconfig (2.6.22) with
CONFIG_SLOB=y
CONFIG_NUMA=y
CONFIG_SMP=y
The kernel build fails with these config symbols set like that.
It looks like SLOB needs that additional
	&& !ARCH_USES_SLAB_PAGE_STRUCT
(or 	&& !SMP)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
