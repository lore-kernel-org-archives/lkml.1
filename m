Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbZL3FlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbZL3FlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 00:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbZL3FlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 00:41:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:26988 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbZL3FlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 00:41:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="227706418"
Date: Wed, 30 Dec 2009 13:41:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Quentin Barnes <qbarnes+nfs@yahoo-inc.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Message-ID: <20091230054119.GB16308@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> 
CC: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [RFC][PATCH] Disabling read-ahead makes I/O of large reads
	small
Reply-To: 
In-Reply-To: <87aax18xms.fsf@basil.nowhere.org>

Hi Quentin,

Quentin Barnes <qbarnes+nfs@yahoo-inc.com> writes:

> Adding the posix_fadvise(..., POSIX_FADV_RANDOM) call sets

Have you tried w/o POSIX_FADV_RANDOM (ie. comment out the fadivse call)?
It should be able to achieve the same good performance. The heuristic
readahead logic should detect that the application is doing random
reads.

> ra_pages=0.  This has a very odd side-effect in the kernel.  Once
> read-ahead is disabled, subsequent calls to read(2) are now done in
> the kernel via ->readpage() callback doing I/O one page at a time!
> 
> Pouring through the code in mm/filemap.c I see that the kernel has
> commingled read-ahead and plain read implementations.  The algorithms
> have much in common, so I can see why it was done, but it left this
> anomaly of severely pimping read(2) calls on file descriptors with
> read-ahead disabled.
> 
> 
> For example, with a read(2) of 98K bytes of a file opened with
> O_DIRECT accessed over NFSv3 with rsize=32768, I see:
> =========
> V3 ACCESS Call (Reply In 249), FH:0xf3a8e519
> V3 ACCESS Reply (Call In 248)
> V3 READ Call (Reply In 321), FH:0xf3a8e519 Offset:0 Len:32768
> V3 READ Call (Reply In 287), FH:0xf3a8e519 Offset:32768 Len:32768
> V3 READ Call (Reply In 356), FH:0xf3a8e519 Offset:65536 Len:32768
> V3 READ Reply (Call In 251) Len:32768
> V3 READ Reply (Call In 250) Len:32768
> V3 READ Reply (Call In 252) Len:32768
> =========
> I would expect three READs issued of size 32K, and that's exactly
> what I see.
> 
> 
> For the same file without O_DIRECT but with read-ahead disabled
> (its ra_pages=0), I see:
> =========
> V3 ACCESS Call (Reply In 167), FH:0xf3a8e519
> V3 ACCESS Reply (Call In 166)
> V3 READ Call (Reply In 172), FH:0xf3a8e519 Offset:0 Len:4096 
> V3 READ Reply (Call In 168) Len:4096
> V3 READ Call (Reply In 177), FH:0xf3a8e519 Offset:4096 Len:4096  
> V3 READ Reply (Call In 173) Len:4096 
> V3 READ Call (Reply In 182), FH:0xf3a8e519 Offset:8192 Len:4096
> V3 READ Reply (Call In 178) Len:4096
> [... READ Call/Reply pairs repeated another 21 times ...]
> =========
> Now I see 24 READ calls of 4K each!

Good catch, Thank you very much!

> A workaround for this kernel problem is to hack the app to do a
> readahead(2) call prior to the read(2), however, I would think a
> better approach would be to fix the kernel.  I came up with the
> included patch that once applied restores the expected read(2)
> behavior.  For the latter test case above of a file with read-ahead
> disabled but now with the patch below applied, I now see:
> =========
> V3 ACCESS Call (Reply In 1350), FH:0xf3a8e519
> V3 ACCESS Reply (Call In 1349)
> V3 READ Call (Reply In 1387), FH:0xf3a8e519 Offset:0 Len:32768
> V3 READ Call (Reply In 1421), FH:0xf3a8e519 Offset:32768 Len:32768
> V3 READ Call (Reply In 1456), FH:0xf3a8e519 Offset:65536 Len:32768
> V3 READ Reply (Call In 1351) Len:32768
> V3 READ Reply (Call In 1352) Len:32768
> V3 READ Reply (Call In 1353) Len:32768
> =========
> Which is what I would expect -- back to just three 32K READs.
> 
> After this change, the overall performance of the application
> increased by 313%!

And awesome improvements!

> 
> I have no idea if my patch is the appropriate fix.  I'm well out of
> my area in this part of the kernel.  It solves this one problem, but
> I have no idea how many boundary cases it doesn't cover or even if
> it is the right way to go about addressing this issue.
> 
> Is this behavior of shorting I/O of read(2) considered a bug?  And
> is this approach for a fix approriate?

The approach is mostly OK for the bug. However one issue is missed --
the ra_pages is somehow overloaded. I try to fix the problems in the
two patches just posted. Will that solve your problem?

Thanks,
Fengguang

> 
> --- linux-2.6.32.2/mm/filemap.c 2009-12-18 16:27:07.000000000 -0600
> +++ linux-2.6.32.2-rapatch/mm/filemap.c 2009-12-24 13:07:07.000000000 -0600
> @@ -1012,9 +1012,13 @@ static void do_generic_file_read(struct 
>  find_page:
>                 page = find_get_page(mapping, index);
>                 if (!page) {
> -                       page_cache_sync_readahead(mapping,
> -                                       ra, filp,
> -                                       index, last_index - index);
> +                       if (ra->ra_pages)
> +                               page_cache_sync_readahead(mapping,
> +                                               ra, filp,
> +                                               index, last_index - index);
> +                       else
> +                               force_page_cache_readahead(mapping, filp,
> +                                               index, last_index - index);
>                         page = find_get_page(mapping, index);
>                         if (unlikely(page == NULL))
>                                 goto no_cached_page;
