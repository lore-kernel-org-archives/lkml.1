Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbZEECZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbZEECZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 22:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbZEECZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 22:25:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:64411 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbZEECZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 22:25:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,294,1239001200"; 
   d="scan'208";a="139169708"
Date: Tue, 5 May 2009 10:24:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "alan-jenkins@tuffmail.co.uk" <alan-jenkins@tuffmail.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH 5/5] PM/Hibernate: Do not release preallocated memory
	unnecessarily (rev. 2)
Message-ID: <20090505022427.GA10880@localhost>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905031830.49690.rjw@sisk.pl> <200905040208.43040.rjw@sisk.pl> <200905040222.39062.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905040222.39062.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 08:22:38AM +0800, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Since the hibernation code is now going to use allocations of memory
> to create enough room for the image, it can also use the page frames
> allocated at this stage as image page frames.  The low-level
> hibernation code needs to be rearranged for this purpose, but it
> allows us to avoid freeing a great number of pages and allocating
> these same pages once again later, so it generally is worth doing.
> 
> [rev. 2: Change the strategy of preallocating memory to allocate as
>  many pages as needed to get the right image size in one shot (the
>  excessive allocated pages are released afterwards).]

Rafael, I tried out your patches and found doubled memory shrink speed!

[  579.641781] PM: Preallocating image memory ... done (allocated 383900 pages, 128000 image pages kept)
[  583.087875] PM: Allocated 1535600 kbytes in 3.43 seconds (447.69 MB/s)

For you reference, here is the free memory before/after
hibernate_preallocate_memory():

        # free
                     total       used       free     shared    buffers     cached
        Mem:          1933       1917         15          0          0       1845
        -/+ buffers/cache:         72       1861
        Swap:            0          0          0

        # free
                     total       used       free     shared    buffers     cached
        Mem:          1933        920       1012          0          0        356
        -/+ buffers/cache:        563       1369
        Swap:            0          0          0

It seems that the preallocated memory is not freed on -ENOMEM.

+       error = memory_bm_create(&orig_bm, GFP_IMAGE, PG_ANY);
+       if (error)
+               goto err_out;
+
+       error = memory_bm_create(&copy_bm, GFP_IMAGE, PG_ANY);
+       if (error)
+               goto err_out;

memory_bm_create() is called a number of times, each time it will
call create_mem_extents()/memory_bm_free(). Can they be optimized to
be called only once?

A side note: there are somehow duplicated *_extent_*() logics in the
filesystems, is it possible that we abstract out some of the common code?

+       for_each_populated_zone(zone) {
+               size += snapshot_additional_pages(zone);
+               count += zone_page_state(zone, NR_FREE_PAGES);
+               if (!is_highmem(zone))
+                       count -= zone->lowmem_reserve[ZONE_NORMAL];
+       }

Why [ZONE_NORMAL] instead of [zone]? ZONE_NORMAL may not always be the largest zone,
for example, My 4GB laptop has a tiny ZONE_NORMAL and a large ZONE_DMA32.

+       /* If size < max_size, preallocating enough memory may be impossible. */
+       if (count > 0 && size == max_size)
+               error = -ENOMEM;
+       if (error)
+               goto err_out;

The two if()s can be merged.

At last, I'd express my major concern about the transition to preallocate
based memory shrinking: will it lead to more random swapping IOs?

Thanks,
Fengguang

