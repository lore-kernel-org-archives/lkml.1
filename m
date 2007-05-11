Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbXEKBIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbXEKBIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbXEKBIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:08:05 -0400
Received: from holomorphy.com ([66.93.40.71]:37394 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbXEKBIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:08:04 -0400
Date: Thu, 10 May 2007 18:08:42 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
Message-ID: <20070511010842.GJ31925@holomorphy.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com> <20070510203102.GO19966@holomorphy.com> <Pine.LNX.4.64.0705102349150.24200@blonde.wat.veritas.com> <20070511000702.GI31925@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511000702.GI31925@holomorphy.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 05:07:02PM -0700, William Lee Irwin III wrote:
> quicklist_free() with unflushed TLB entries admits speculation through
> the pagetable entries corresponding to the list links. So tlb_finish_mmu()
> is the place to call quicklist_free() on pagetables. This requires
> distinguishing preconstructed pagetables from freed user pages, which
> is not done in include/asm-generic/tlb.h (and core callers may need
> to be adjusted, pending the results of audits).
> To clarify, upper levels of pagetables are indeed cached by x86 TLB's.
> The same kind of deferral of freeing until the TLB is flushed required
> for leaf pagetables is required for the upper levels as well.

Looking more closely at it, the entire attempt to avoid struct page
pointers is far beyond pointless. The freeing functions unconditionally
require struct page pointers to either be passed or computed and the
allocation function's virtual address it returns as a result is not
directly usable. The callers all have to do arithmetic on the result.
One might as well stash precomputed pfn's (if not paddrs) and vaddrs in
page->private and page->mapping, chain them with ->lru (use only .next
if you care to stay singly-linked), and handle struct page pointers
throughout. At that point quicklists not only become directly callable
for pagetable freeing (including upper levels) instead of needing calls
to quicklist freeing staged to occur at the time of tlb_finish_mmu(),
but also become usable for the highpte case.

The computations this is trying to save on are computing the virtual
and physical addresses (pfn's modulo a cheap shift; besides, all the
API's work on pfn's) of a page from the pointer to the struct page.
Chaining through the memory for the page incurs the cost of having to
stage freeing through tlb_finish_mmu() instead of using the quicklist
as a staging arena directly. So the translation from a struct page
pointer is not saving work. It's not saving cache, either. The page's
memory is no more likely to be hot than its struct page.

In the course of freeing the pointer to the struct page is computed
whether by the caller or the API function. So the translation to a
struct page pointer is done during freeing regardless.

A better solution would be to precompute those results and store
them in various fields of the struct page. i386 can move to using
generation numbers (->_mapcount and ->index are still available
for 64 bits there even after quicklists use ->lru, ->mapping, and
->private, and quicklists really only need half of ->lru) to handle
change_page_attr() and vmalloc_sync().


-- wli
