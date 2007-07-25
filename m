Return-Path: <linux-kernel-owner+w=401wt.eu-S1765462AbXGYMzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765462AbXGYMzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759752AbXGYMzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:55:06 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:39541 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759695AbXGYMzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:55:04 -0400
Date: Wed, 25 Jul 2007 13:55:02 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bob.picco@hp.com, apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of memmap on IA64 SPARSEMEM when mem_section is not a power of 2
Message-ID: <20070725125501.GA32445@skynet.ie>
References: <20070313104201.GA16842@skynet.ie> <20070724220116.0d9fb8b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070724220116.0d9fb8b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (24/07/07 22:01), Andrew Morton didst pronounce:
> On Tue, 13 Mar 2007 10:42:02 +0000 mel@skynet.ie (Mel Gorman) wrote:
> 
> > There are problems in the use of SPARSEMEM and pageblock flags that causes
> > problems on ia64.
> > 
> > The first part of the problem is that units are incorrect in
> > SECTION_BLOCKFLAGS_BITS computation. This results in a map_section's
> > section_mem_map being treated as part of a bitmap which isn't good. This
> > was evident with an invalid virtual address when mem_init attempted to free
> > bootmem pages while relinquishing control from the bootmem allocator.
> > 
> > The second part of the problem occurs because the pageblock flags bitmap is
> > be located with the mem_section. The SECTIONS_PER_ROOT computation using
> > sizeof (mem_section) may not be a power of 2 depending on the size of the
> > bitmap. This renders masks and other such things not power of 2 base. This
> > issue was seen with SPARSEMEM_EXTREME on ia64. This patch moves the bitmap
> > outside of mem_section and uses a pointer instead in the mem_section. The
> > bitmaps are allocated when the section is being initialised.
> > 
> > Note that sparse_early_usemap_alloc() does not use alloc_remap() like
> > sparse_early_mem_map_alloc(). The allocation required for the bitmap on x86,
> > the only architecture that uses alloc_remap is typically smaller than a cache
> > line. alloc_remap() pads out allocations to the cache size which would be
> > a needless waste.
> > 
> > Credit to Bob Picco for identifying the original problem and effecting a
> > fix for the SECTION_BLOCKFLAGS_BITS calculation. Credit to Andy Whitcroft
> > for devising the best way of allocating the bitmaps only when required for
> > the section.
> 
> SuperH allmodconfig blew up:
> 
> mm/sparse.c: In function `sparse_init':
> mm/sparse.c:482: error: implicit declaration of function `sparse_early_usemap_alloc'
> mm/sparse.c:482: warning: assignment makes pointer from integer without a cast
> mm/sparse.c: In function `sparse_add_one_section':
> mm/sparse.c:553: error: implicit declaration of function `__kmalloc_section_usemap'
> mm/sparse.c:553: warning: assignment makes pointer from integer without a cast

I'm looking at this now and getting a superh cross-compiler built to
build-test any fix. My first impression is that
sparse_early_usemap_alloc() needs to be defined whether
CONFIG_SPARSEMEM_VMEMMAP is set or not. Right now,
sparse_early_usemap_alloc() is only defined when it is set and it's not
clear why although "by accident" is the most likely explanation.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
