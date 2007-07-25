Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbXGYFCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbXGYFCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 01:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbXGYFCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 01:02:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59628 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946AbXGYFCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 01:02:04 -0400
Date: Tue, 24 Jul 2007 22:01:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mel@skynet.ie (Mel Gorman)
Cc: bob.picco@hp.com, apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of memmap on IA64 SPARSEMEM when
 mem_section is not a power of 2
Message-Id: <20070724220116.0d9fb8b5.akpm@linux-foundation.org>
In-Reply-To: <20070313104201.GA16842@skynet.ie>
References: <20070313104201.GA16842@skynet.ie>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007 10:42:02 +0000 mel@skynet.ie (Mel Gorman) wrote:

> There are problems in the use of SPARSEMEM and pageblock flags that causes
> problems on ia64.
> 
> The first part of the problem is that units are incorrect in
> SECTION_BLOCKFLAGS_BITS computation. This results in a map_section's
> section_mem_map being treated as part of a bitmap which isn't good. This
> was evident with an invalid virtual address when mem_init attempted to free
> bootmem pages while relinquishing control from the bootmem allocator.
> 
> The second part of the problem occurs because the pageblock flags bitmap is
> be located with the mem_section. The SECTIONS_PER_ROOT computation using
> sizeof (mem_section) may not be a power of 2 depending on the size of the
> bitmap. This renders masks and other such things not power of 2 base. This
> issue was seen with SPARSEMEM_EXTREME on ia64. This patch moves the bitmap
> outside of mem_section and uses a pointer instead in the mem_section. The
> bitmaps are allocated when the section is being initialised.
> 
> Note that sparse_early_usemap_alloc() does not use alloc_remap() like
> sparse_early_mem_map_alloc(). The allocation required for the bitmap on x86,
> the only architecture that uses alloc_remap is typically smaller than a cache
> line. alloc_remap() pads out allocations to the cache size which would be
> a needless waste.
> 
> Credit to Bob Picco for identifying the original problem and effecting a
> fix for the SECTION_BLOCKFLAGS_BITS calculation. Credit to Andy Whitcroft
> for devising the best way of allocating the bitmaps only when required for
> the section.

SuperH allmodconfig blew up:

mm/sparse.c: In function `sparse_init':
mm/sparse.c:482: error: implicit declaration of function `sparse_early_usemap_alloc'
mm/sparse.c:482: warning: assignment makes pointer from integer without a cast
mm/sparse.c: In function `sparse_add_one_section':
mm/sparse.c:553: error: implicit declaration of function `__kmalloc_section_usemap'
mm/sparse.c:553: warning: assignment makes pointer from integer without a cast
