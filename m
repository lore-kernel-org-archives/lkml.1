Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYIWGvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYIWGvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 02:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYIWGuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 02:50:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:54823 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbYIWGux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 02:50:53 -0400
Subject: Re: PTE access rules & abstraction
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <48D88904.4030909@goop.org>
References: <1221846139.8077.25.camel@pasglop> <48D739B2.1050202@goop.org>
	 <1222117551.12085.39.camel@pasglop> <20080923031037.GA11907@wotan.suse.de>
	 <1222147886.12085.93.camel@pasglop>  <48D88904.4030909@goop.org>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 16:49:32 +1000
Message-Id: <1222152572.12085.129.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> A good first step might be to define some conventions.  For example,
> define that set_pte*() *always* means setting a non-valid pte to either
> a new non-valid state (like a swap reference) or to a valid state. 
> modify_pte() would modify the flags of a valid
> pte, giving a new valid pte.  etc...

Yup. Or make it clear that ptep_set_access_flags() should only be used
to -relax- access (ie, set dirty, writeable, accessed, ... but not
remove any of them).

> It may be that a given architecture collapses some or all of these down
> to the same underlying functionality, but it would allow the core intent
> to be clearly expressed.
> 
> What is the complete set of primitives we need?  I also noticed that a
> number of the existing pagetable operations are used only once or twice
> in the core code; I wonder if we really need such special cases, or
> whether we can make each arch pte operation carry a bit more weight?

Yes, that was some of my concern. It's getting close to having one API
per call site :-)

> Also, rather than leaving all the rule enforcing to documentation and a
> maintainer, we should also consider having a debug mode which adds
> enough paranoid checks to each operation so that any rule breakage will
> fail obviously on all architectures.

We could do both.

Now, regarding operations, let's first find the major call sites, see
what I miss. I'm omitting free_* in memory.c as those are for freeing
pte pages, not accessing PTEs themselves. I'm also ignoring read-only
call sites and hugetlb for now.

* None-iterative accessors

 - handle_pte_fault in memory.c, on "fixup" faults (pte is present and
it's not a COW), for fixing up DIRTY and ACCESSED (btw, could we make
that also fixup EXEC ? I would like this for some stuff I'm working on
at the moment, ie set it if the vma has VM_EXEC and it was lost from the
PTE as I might want to mask it out of PTEs under some circumstances).
Textbook usage of ptep_set_access_flags(), so that's fine.

 - do_wp_page() in memory.c for COW or fixup of shared writeable mapping
writeable-ness. Doesn't overwrite existing PTE for COW anymore, it uses
clear_flush nowadays and fixup of shared writeable mapping uses
ptep_set_access_flags() as it should, so that's all good.

 - insert_pfn() and insert_page() still in memory.c for fancy page
faults. Just a trivial set_pte_at() of a !present one, no big deal here

  - RMAP ones ? Some ad-hoc stuff due to _notify thingies.

* Iterative accessors (some don't batch, maybe they could/should).

 - zapping a mapping (zap_p*) in memory.c
 - fork (copy_p*) in memory.c could batch better maybe ?
 - setting linear user mappings (remap_p*) in memory.c, trivial
set_pte_at() on a range, pte's should be !present I think.
 - mprotect (change_p*) in memory.c, which has the problem I mentioned
 - moving page tables (move_p*), pretty trivial clear_flush + set_pte_at
 - clear_regs_pte_range via walk_page_range in fs/proc/task_mmu.c, does
a test_and_clear_young, flushes mm afterward, could use some lazy stuff
so we can batch properly on ppc64.
 - vmalloc, that's a bit special and kernel only, doesn't have nasty
races between creating/tearing down mappings vs. using them
 - highmem I leave alone for now, it's mostly trivial set_pte_at &
flushing for normal kmap but kmap_atomic can be nasty, though it's arch
specific.
 - some stuff in fremap I'm not too familiar with and I need to run...

What did I miss ?

Cheers,
Ben.


