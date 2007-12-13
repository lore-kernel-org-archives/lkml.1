Return-Path: <linux-kernel-owner+w=401wt.eu-S934178AbXLMW3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934178AbXLMW3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932698AbXLMW3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:29:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:4117 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469AbXLMW3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:29:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="295453266"
Date: Thu, 13 Dec 2007 14:27:16 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Asit Mallick <asit.k.mallick@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, benh@kernel.crashing.org
Subject: Re: What was the problem with quicklists and x86-64?
Message-ID: <20071213222716.GA20208@linux-os.sc.intel.com>
References: <47603321.4030700@goop.org> <Pine.LNX.4.64.0712131131540.13396@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712131131540.13396@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 11:47:29AM -0800, Christoph Lameter wrote:
> On Wed, 12 Dec 2007, Jeremy Fitzhardinge wrote:
> 
> > I'm looking at unifying the various pgalloc+pgd_lists mechanisms between
> > 32-bit (PAE and non-PAE) and 64-bit, so I'm trying to understand why
> > these differences exist in the first place.
> > 
> > Change da8f153e51290e7438ba7da66234a864e5d3e1c1 reverted the use of
> > quicklists for allocating pagetables, because of concerns about ordering
> > with respect to tlb flushes.
> 
> These issues only exist with NUMA because of the freeing of off node pages 
> before the TLB flush was done. There was a discussion about this issue and 
> my fix of simply not freeing the offnode pages early was ignored. Instead 
> the x86_64 implementation (which has no problems that I know of) was 

NUMA  bug might not be the only problem. I think there are more issues
as Linus noticed.

<snip>
Oh, and I see what's wrong: you not only switched "free_page()" to 
"quicklist_free()", you *also* switched "tlb_remove_page()" to 
"quicklist_free()".
</snip>

The above comment is in reference to below portion of code:

-#define __pte_free_tlb(tlb,pte) tlb_remove_page((tlb),(pte))
+#define __pte_free_tlb(tlb,pte) quicklist_free_page(QUICK_PT, NULL,(pte))

tlb_remove_page() was marking tlb->need_flush. Which is later used
by tlb_flush_mmu(). With quicklist_free_page() we loose all that..

Now in a corner case scenario  with a big munmap() which calls unmap_region()
and if it so happens that the region getting unmapped just has page
tables setup but with all PTE's set to NULL, unmap_region() may
potentially free the page table pages
	[ tlb_finish_mmu() calls check_pgt_cache() which trims quicklist ]
with out flushing the TLB's.
	[ (tlb_finish_mmu() calls the tlb_flush_mmu() but it will not do
           much as need_flush is not set ]

Similarly Linus brought pre-emptions issues associated with quicklist usage..

thanks,
suresh
