Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbXD0OTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbXD0OTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbXD0OTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:19:21 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:46567 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917AbXD0OTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:19:12 -0400
Date: Fri, 27 Apr 2007 15:18:56 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Mike Stroyan <mike.stroyan@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rohit Seth <rohitseth@google.com>, "Luck, Tony" <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
In-Reply-To: <4631E49C.2030501@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0704271437570.14794@blonde.wat.veritas.com>
References: <20070425205548.fd51b301.akpm@linux-foundation.org>
 <46305A8D.2080003@yahoo.com.au> <20070426173544.GA30744@ldl.fc.hp.com>
 <4631E49C.2030501@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 27 Apr 2007 14:19:10.0014 (UTC) FILETIME=[05CEE5E0:01C788D7]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAB2luYm94AG1pa2Uuc3Ryb3lhbkBocC5jb20AbGludXgtaWE2NEB2Z2VyLmtlcm5lbC5vcmcAbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnAHRvbnkubHVja0BpbnRlbC5jb20Abmlja3BpZ2dpbkB5YWhvby5jb20uYXUAcm9oaXRzZXRoQGdvb2dsZS5jb20A
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Nick Piggin wrote:
> 
> But that's because of ia64's cache coherency implementation. I don't really
> follow the documentation to know whether it should be one way or the other,
> but surely it should be done either before or after the set_pte_at, not both.
> 
> Anyway, how about fremap or mprotect, for example?
> ... 
> 
> OK, I'm still not sure that I understand why lazy_mmu_prot_update should be
> used rather than flush_icache_page (in concept, not ia64 implementation).
> Sure, flush_icache_page isn't given the pte, but let's assume we can change
> that.

You're asking lots of good questions.  I wish the ia64 people would
know the answers, but from the length of time the "lazy_mmu_prot_update"
stuff took to get into the tree, and the length of time it's taken to be
found defective, I suspect they don't, and we'll have to guess for them.

Some guesses I'm working with...

I presume Mike and Anil are correct, that it needs to be done before
putting pte into page table, not left until after: but as you've
guessed, that needs to be done everywhere, not just in the two
places so far identified.

When it was discussed last year (in connection with Peter's page
cleaning patches) it was thought to be a variant of update_mmu_cache()
(after setting pte), and we added the fremap one to accompany it;
but now it looks to be a variant of flush_icache_page() (before
setting pte).

I believe lazy_mmu_prot_update(pteval) came into existence primarily
for mprotect's change_pte_range() case.  If ia64 filled in its
flush_icache_page(vma, page), that could have been used there
(checking 'vm_flags & VM_EXEC' instead of pte_exec): but that would
involve a relatively expensive(?) pte_page() in a place which doesn't
need to know the struct page for other cases.

Well, not pte_page(), it needs to be vm_normal_page() doesn't it?
and ia64's current lazy_mmu_prot_update is unsafe when !pfn_valid.

Some flush_icache_pages are already in place, others are not: do
we need to add some?  But those architectures which have a non-empty
flush_icache_page seem to have survived without the additional calls
- so they might be unnecessarily slowed down by additional calls.

I believe that was the secondary reason for lazy_mmu_prot_update(),
perhaps better called ia64_flush_icache_page(): to allow calls to
be added where ia64 was (mistakenly) thought to want them, without
needing a protracted audit of how other architectures might be
impacted.

But I'm still trying to make sense of it.

Hugh
