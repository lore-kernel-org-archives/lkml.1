Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXDMTIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXDMTIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 15:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932112AbXDMTIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 15:08:53 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:34127 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932097AbXDMTIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 15:08:52 -0400
Message-ID: <461FD496.5080506@vmware.com>
Date: Fri, 13 Apr 2007 12:05:58 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] i386: use pte_update_defer in ptep_test_and_clear_{dirty,young}
References: <Pine.LNX.4.64.0703252335560.4535@chino.kir.corp.google.com> <46082BE6.30402@vmware.com> <Pine.LNX.4.64.0704131838310.8399@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0704131838310.8399@blonde.wat.veritas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Zach, while looking at your recent patches, I ran across the comment
> on pte_update_defer, and where it was being used, and now think that
> David's patch is actually incorrect.  Previously pte_update_defer
> was being used where a flush_tlb_page followed immediately after
> within the same macro; with David's patch, mm's clear_refs_pte_range
> is calling ptep_test_and_clear_young (including pte_update_defer) on
> several ptes, then unlocking the page table, and later flushing TLB.
> That's exactly wrong for pte_update_defer, isn't it?
>   

Yes, that is correct.  But in the context of kernel usage, it is not a 
problem.  Note that ptep_test_and_clear_xxx are purely optimizing 
definitions for specific architectures; they are never called outside of 
asm-generic pgtable code, and when they are, they are called from 
ptep_clear_flush_xxx.  So the requisite flush still dominates the lazy / 
deferred / what have you pte update.  I think this is actually the major 
reason I had done the hack to begin with - defining 
__HAVE_ARCH_PTEP_TEST_AND_CLEAR_XXX without actually defining the 
functions prevented any accidental usage of pte_update_defer where the 
flush was omitted.

In correct uses which actually change PTE bits that matter to hardware, 
a flush will (almost*) always be required for hardware correctness.  
This property minimizes the potential damage that can be caused by 
misusing the pte_update_defer or decoupling it from the flush.  It does 
nothing to stop SMP races, however, as in cases where the flush happens 
outside of the page table spinlock, an SMP race is possible on the 
shadow page tables.  So it is better to keep the flush as close as 
possible to the deferred update.

(* RW -> RO,  OLD -> YOUNG, DIRTY -> CLEAN, USER -> SUPERVISOR, EXEC -> 
NX, CACHEABLE -> PCD all require a TLB flush.  Linux never makes 
transitions in the opposite direction by using live page table bit 
manipulation - which might change the PTE without requiring a flush.  It 
turns out, a flush is still a good idea, as transitions in the opposite 
direction represent a permission upgrade, and leaving a more restrictive 
TLB entry around could cause a spurious fault, which might be suppressed 
depending on the architecture, but still good to avoid.)

> I do find the name confusing (pte_update_defer is for use only when
> the TLB update is not deferred, right?): indeed, its distinction from
> pte_update very prone to errors of this kind.  I'm all for deferring
> work, but is there some way the right thing could be done automatically?
> Or, how much would be lost if we just replaced all the pte_update_defers
> by pte_updates?
>   

I agree the name is confusing; I struggled to find a better name (as 
lazy is already overridden in several ways in mm code).  What would be a 
good way to say pte update which is delayed until subsumed by an 
immediate pte operation (explicit non-delayed update or flush)?

In light of the property above (flush required for correctness), what 
about a name like mark_tlb_pte_async - to indicate that the TLB and PTE 
are now out of sync - and require a flush to be brought in sync.  Some 
architectures simply don't need to care to implement them - and some 
generic code can be written to verify that unsynchronized tlbs are 
always flushed before returning from fault handlers or to userspace.

> I'm not proposing any patch myself: just bringing to your attention.
>   

Thanks!  I'm pretty sure we're still correct, for now, but without care, 
it is easy to diverge from that.  I'll keep a watchful eye on the 
pagetable and mm code (as always) and try to come up with a more 
comprehensive solution.

Zach
