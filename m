Return-Path: <linux-kernel-owner+w=401wt.eu-S1030278AbXDMVCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030278AbXDMVCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030297AbXDMVCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:02:06 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45545 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030278AbXDMVCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:02:03 -0400
Message-ID: <461FEF1C.5010806@vmware.com>
Date: Fri, 13 Apr 2007 13:59:08 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] i386: use pte_update_defer in ptep_test_and_clear_{dirty,young}
References: <Pine.LNX.4.64.0703252335560.4535@chino.kir.corp.google.com> <46082BE6.30402@vmware.com> <Pine.LNX.4.64.0704131838310.8399@blonde.wat.veritas.com> <461FD9BF.90609@vmware.com> <Pine.LNX.4.64.0704132108430.14740@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0704132108430.14740@blonde.wat.veritas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> David (clear_refs_pte_range) is only using ptep_test_and_clear_young,
> though he did change the ptep_test_and_clear_dirty definition to be
> consistent with it.  old/young is never so serious as clean/dirty, so
> it may be that there's very little problem with what's in there now;
> it just becomes a shame if the wrong decision gets made too often e.g.
> if the misflushing is such that his clear_youngs never really take
> effect.  I simply cannot tell whether or not that's the case myself.
>   

If the logic is too difficult to reason about without entering ganda 
bherundasana, then it is simpler to just drop the _defer suffix.  Old / 
young actually is just as serious, not because A-bit is critical 
(although misvirtualizing it will do strange things to the page 
clocking), but because the entire PTE update is delayed - and thus an 
intervening PTE update which remaps the physical page can come in before 
the A-bit update is flushed.  The A-bit update carries the PPN of the 
original physical page, destroying the remap.

> But once the pte_update_defers get moved away from their flush_tlb_pages,
> as is the case now, it feels like we're on thin ice.
>   

Yes, that is why I think I did the original hack of having #defines 
without implementations - to ensure the flush stayed coupled with the 
use of pte_update_defer.

> Actually, I don't really get pte_update_defer at all: I can understand
> wanting to defer a call down, but it appears to be a call down to say
> we're deferring the shadow update?  Why not just do it with pte_update?
> I'd be happier without it until this could be restructured more safely
> (but my incomprehension is not necessarily the best guiding principle).
>   

So pte_update does the update immediately; it is always safe.  For 
select cases, where there is an immediate pte_update + flush 
combination, it is beneficial to combine the two into one hypercall, 
saving the several thousand cycle round trip into the hypervisor from 
happening twice.  This is why pte_update_defer was used close to the 
flushes.  I thought David was just defining the ptep_test_and_clear_xxx 
functions properly; I didn't realize he was actually using them to 
decouple the flush across a spinlock or logically complex code region.  
If that is the case, I agree pte_update instead of defer is absolutely 
the right thing to do.

I'm a little worried about the TLB consistency here, on real hardware.  
If you drop the spinlock, you could end up preempted.  If the preemption 
runs a kernel thread, which accesses the same memory for which you just 
modified the page table mappings, the TLB could still have a stale 
entry.  So, a clear of a dirty bit might happen in a writeback thread, 
but get preempted before the flush, then the hardware TLB still has a 
dirty entry.  This means writes through the same virtual address will 
skip the A/D bit update in the pte.  Now, for regular user memory 
access, that might not be a problem, but if it is the kernel touching 
user memory through kmap, the kernel virtual address might well ..  I'm 
off in the weeds.  But still slightly concerned about leaving that TLB 
entry stale across a possible preemption.

As an aside, in the tree I'm looking at, I don't see any users of 
ptep_clear_flush_dirty at all.. doesn't that mean writeback which 
undirties pages will leave the PTEs with latent dirty bits, causing them 
to get written back again when the process exits?  Or does rmap take 
care of this.  Ahh, I just discovered page_mkclean_one.  Never mind.  
But still no users of ptep_clear_flush_dirty.

Zach
