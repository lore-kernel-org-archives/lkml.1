Return-Path: <linux-kernel-owner+w=401wt.eu-S1759642AbXEKAGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642AbXEKAGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 20:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbXEKAGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 20:06:24 -0400
Received: from holomorphy.com ([66.93.40.71]:51220 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbXEKAGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 20:06:23 -0400
Date: Thu, 10 May 2007 17:07:02 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
Message-ID: <20070511000702.GI31925@holomorphy.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com> <20070510203102.GO19966@holomorphy.com> <Pine.LNX.4.64.0705102349150.24200@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705102349150.24200@blonde.wat.veritas.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, William Lee Irwin III wrote:
>> So now quicklist semantics vs. TLB flushing are the motive behind the
>> odd flush_tlb_mm() affair. The real trick with it is that flushing
>> must never occur until the TLB flush. Any change to the core quicklist
>> code that retires pages back to the page allocator earlier (e.g. based
>> on some limit) will break things badly.

On Fri, May 11, 2007 at 12:14:14AM +0100, Hugh Dickins wrote:
> I don't think that's right.  It's vital that TLB (of an active mm)
> be flushed before freeing its page back to the quicklist, before it's
> recycled to another mm (or elsewhere in this mm); but having done that,
> it really doesn't matter much when quicklist_trim() (check_pgt_cache)
> is called to free surplus pages from quicklist back to page_alloc.c.

What I was really going on about was that quicklist freeing can't
enforce any high watermarks in the future because it must wait until
the TLB flush unless it's guaranteed that TLB flushes are done prior
to quicklist freeing (which is furthermore required for other reasons,
to be described in the sequel).


On Fri, May 11, 2007 at 12:14:14AM +0100, Hugh Dickins wrote:
> tlb_finish_mmu() happens to be the traditional place it's done, and
> that's where we expect it.  flush_tlb_mm() avoids flushing TLB unless
> it's actually required for the mm in question: so wouldn't be a good
> place to rely on flushing TLB for pages freed earlier from other mms
> (but we'd already be in trouble to be leaving them that late).
> I'm guessing (haven't rechecked source) that the cpu_idle() call comes
> about because the top level pgd of a process gets freed very late in
> its exit, and after a great flurry of processes have just exited,
> perhaps there was nothing to free up the accumulation.  Though
> it still strikes me as an odd place to do it.

I described it as motivated by such, not really correctly handling it.
I didn't bother analyzing it for correctness. I'm not surprised at all
that the TLB flush can be missed where it now stands in the patch. I
wanted to move it to tlb_finish_mmu() all along, along with quicklist
management of lower levels of hierarchy.

quicklist_free() with unflushed TLB entries admits speculation through
the pagetable entries corresponding to the list links. So tlb_finish_mmu()
is the place to call quicklist_free() on pagetables. This requires
distinguishing preconstructed pagetables from freed user pages, which
is not done in include/asm-generic/tlb.h (and core callers may need
to be adjusted, pending the results of audits).

To clarify, upper levels of pagetables are indeed cached by x86 TLB's.
The same kind of deferral of freeing until the TLB is flushed required
for leaf pagetables is required for the upper levels as well.


-- wli
