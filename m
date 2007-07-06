Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbXGFXxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbXGFXxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 19:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbXGFXww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 19:52:52 -0400
Received: from ns1.suse.de ([195.135.220.2]:58147 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbXGFXwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 19:52:51 -0400
Date: Sat, 7 Jul 2007 01:52:28 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070706235228.GL5777@v2.random>
References: <20070706222651.GG5777@v2.random> <1183764801.10287.233.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183764801.10287.233.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 04:33:21PM -0700, Dave Hansen wrote:
> The patch looks really interesting, it's just a little hard to parse
> with all of the s/4096/PAGE_SIZE/ bits around.  Those cleanups, along
> with the s/PAGE_SIZE/HARD_PAGE_SIZE/ parts would be great in a
> separated-out patch so that the really juicy bits (like the pte
> handling) where the new logic is stand out better.  

Agreed.

> I think it would help readability to have something like:
> 
> #define PAGES_PER_HARD_PAGE (1<<(PAGE_SHIFT-HARD_PAGE_SHIFT))

Indeed.

> 
> which would look like this:
> 
> -	if (unlikely(!pfn_valid(pfn))) {
> +	if (unlikely(!pfn_valid(pfn * PAGES_PER_HARD_PAGE))) {

I normally prefer to shift left/right than to multiply/divide, so feel
free to suggest another define name with just
PAGE_SHIFT-HARD_PAGE_SHIFT, then you can #define PAGES_PER_HARD_PAGE
(1<<definename).

> Instead of having hardpfn_t, would it be more useful to tag the types
> with sparse?  That's probably something that other interested parties
> could work on.

Ouch, hardpfn_t so far is unused ;). I initially wanted to try to make
things more type safe, but then it didn't work out very well so I
deferred it.

BTW, in a parallel thread (the thread where I've been suggested to
post this), Rik rightfully mentioned Bill once also tried to get this
working and basically asked for the differences. I don't know exactly
what Bill did, I only remember well the major reason he did it. Below
I add some more comment on the Bill, taken from my answer to Rik:

---------------
Right, I almost forgot he also tried enlarging the PAGE_SIZE at some
point, back then it was for the 32bit systems with 64G of ram, to
reduce the mem_map array, something my patch achieves too btw.

I thought his approach was of the old type, not backwards compatible,
the one we also thought for amd64, and I seem to remember he was
trying to solve the backwards compatibility issue without much
success.

But really I'm unsure how Bill could achieve anything backwards
compatible back then without anon-vma... anon-vma is the enabler. I
remember he worked on enlarging the PAGE_SIZE back then, but I don't
recall him exposing HARD_PAGE_SIZE to the common code either (actually
I never seen his code so I can't be sure of this). Even if he had pte
chains back then, reaching the pte wasn't enough and I doubt he could
unwalk the pagetable tree from pte up to pmd up to pgd/mm, up to vma
to read the vm_pgoff that btw was meaningless back then for the anon
vmas ;).

Things are very complex, but I think it's possible by doing proper
math on vm_pgoff, vm_start/vm_end and address, just with that 4 things
we should have enough info to know which parts of each page to map in
which pte, and that's all we need to solve it. At the second mprotect
of 4k over the same 8k page will get two vmas queued in the same
anon-vma. So we check both vmas and looking at the vm_pgoff(hardpage
units)+(((address-vm_start)&~PAGE_MASK)>>HARD_PAGE_SHIFT we should be
able to tell if the ptes behind the vma need to be updated and if the
second vma can be merged back.

The idea to make it work is to synchronously map all the ptes for all
indexes covered by each page as long as they're in the range
vm_start>>HARD_PAGE_SHIFT to vm_end >> HARD_PAGE_SHIFT. We should
threat a page fault like a multiple page fault. Then when you mprotect
or mremap you already know which ptes are mapped and that you need to
unmap/update by looking the start/end hard-page-indexes, and you also
have to always check all vmas that could possibly map that page, if
the page cross the vm_start/vm_end boundary.

Easy definitely not, but feasible I hope yes because I couldn't think
of a case where we can't figure out which part of the page to map in
which pte. I wish I had it implemented before posting because then I
would be 100% sure it was feasible ;).

Now if somebody here can think of a case where we can't know where to
map which part of the page in which pte, then *that* would be very
interesting and it could save some wasted development effort. Unless
this happens, I guess I can keep trying to make it work, hopefully now
with some help.
