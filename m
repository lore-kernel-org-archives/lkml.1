Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbZE1KdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbZE1KdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 06:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbZE1KdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 06:33:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:17013 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbZE1KdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 06:33:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,264,1241420400"; 
   d="scan'208";a="147860818"
Date: Thu, 28 May 2009 18:33:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@suse.de>, "hugh@veritas.com" <hugh@veritas.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler
	in the VM v3
Message-ID: <20090528103300.GA15133@localhost>
References: <200905271012.668777061@firstfloor.org> <20090527201239.C2C9C1D0294@basil.firstfloor.org> <20090528082616.GG6920@wotan.suse.de> <20090528095934.GA10678@localhost> <20090528101111.GE1065@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528101111.GE1065@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 06:11:11PM +0800, Andi Kleen wrote:
> On Thu, May 28, 2009 at 05:59:34PM +0800, Wu Fengguang wrote:
> > Dirty swap cache page is tricky to handle. The page could live both in page
> > cache and swap cache(ie. page is freshly swapped in). So it could be referenced
> > concurrently by 2 types of PTEs: one normal PTE and another swap PTE. We try to
> > handle them consistently by calling try_to_unmap(TTU_IGNORE_HWPOISON) to convert
> > the normal PTEs to swap PTEs, and then
> >         - clear dirty bit to prevent IO
> >         - remove from LRU
> >         - but keep in the swap cache, so that when we return to it on
> >           a later page fault, we know the application is accessing
> >           corrupted data and shall be killed (we installed simple
> >           interception code in do_swap_page to catch it).
> 
> That's a good description. I'll add it as a comment to the code.

OK, thanks.

> > > You haven't waited on writeback here AFAIKS, and have you
> > > *really* verified it is safe to call delete_from_swap_cache?
> > 
> > Good catch. I'll soon submit patches for handling the under
> > read/write IO pages. In this patchset they are simply ignored.
> 
> Yes, we assume the IO device does something sensible with the poisoned
> cache lines and aborts. Later we can likely abort IO requests in a early
> stage on the Linux, but that's more advanced.
> 
> The question is if we need to wait on writeback for correctness? 

Not necessary. Because I'm going to add a me_writeback() handler.

Then the writeback pages simply won't reach here. And it won't
magically go into writeback state, since the page has been locked.

Thanks,
Fengguang

> We still don't want to crash if we take a page away that is currently
> writebacked.
> 
> My original assumption was that taking the page lock would take
> care of that. Is that not true?
> 
> -Andi
> -- 
> ak@linux.intel.com -- Speaking for myself only.
