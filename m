Return-Path: <linux-kernel-owner+w=401wt.eu-S933928AbXGQRqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928AbXGQRqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757368AbXGQRp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:45:56 -0400
Received: from holomorphy.com ([66.93.40.71]:58830 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759304AbXGQRpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:45:55 -0400
Date: Tue, 17 Jul 2007 10:47:37 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070717174737.GM6909@holomorphy.com>
References: <20070706222651.GG5777@v2.random> <1183764801.10287.233.camel@localhost> <20070706235228.GL5777@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070706235228.GL5777@v2.random>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 01:52:28AM +0200, Andrea Arcangeli wrote:
> BTW, in a parallel thread (the thread where I've been suggested to
> post this), Rik rightfully mentioned Bill once also tried to get this
> working and basically asked for the differences. I don't know exactly
> what Bill did, I only remember well the major reason he did it. Below
> I add some more comment on the Bill, taken from my answer to Rik:

I got it working. It merely bitrotted faster than I could maintain it.


On Sat, Jul 07, 2007 at 01:52:28AM +0200, Andrea Arcangeli wrote:
> Right, I almost forgot he also tried enlarging the PAGE_SIZE at some
> point, back then it was for the 32bit systems with 64G of ram, to
> reduce the mem_map array, something my patch achieves too btw.

It was done for the occasion of the first publicly-announced boot of
Linux on a 64GB x86-32 machine.


On Sat, Jul 07, 2007 at 01:52:28AM +0200, Andrea Arcangeli wrote:
> I thought his approach was of the old type, not backwards compatible,
> the one we also thought for amd64, and I seem to remember he was
> trying to solve the backwards compatibility issue without much
> success.

It was not of the old type. It followed Hugh's strategy, which made
it fully backward-compatible. The only deficits in terms of success
were performance, maintenance, and attracting any sort of audience.
The only tester besides myself was literally Zwane.


On Sat, Jul 07, 2007 at 01:52:28AM +0200, Andrea Arcangeli wrote:
> But really I'm unsure how Bill could achieve anything backwards
> compatible back then without anon-vma... anon-vma is the enabler. I
> remember he worked on enlarging the PAGE_SIZE back then, but I don't
> recall him exposing HARD_PAGE_SIZE to the common code either (actually
> I never seen his code so I can't be sure of this). Even if he had pte
> chains back then, reaching the pte wasn't enough and I doubt he could
> unwalk the pagetable tree from pte up to pmd up to pgd/mm, up to vma
> to read the vm_pgoff that btw was meaningless back then for the anon
> vmas ;).

It was exposed to the common code as MMUPAGE_SIZE. Significant pte
vectoring code in the core was involved, as well as partial page
distribution policies, mmap()/mprotect() et al handling splitting
across physical page boundaries, and the like. When done wrong,
applications such as /sbin/init didn't run. It was all there, though
Hugh's earlier implementation was far superior.

pte_chains didn't make things anywhere near as awkward as highpte.
pte_chains didn't really care so much how large an area a struct
page tracked. highpte OTOH needed more effort, though I don't recall
specifically why anymore.

My long-dead code should be at:

	ftp://ftp.kernel.org/pub/linux/kernel/people/wli/vm/pgcl/

dmesg's from 64GB x86-32 machines are also in that directory, dating
from March 2003.


On Sat, Jul 07, 2007 at 01:52:28AM +0200, Andrea Arcangeli wrote:
> Things are very complex, but I think it's possible by doing proper
> math on vm_pgoff, vm_start/vm_end and address, just with that 4 things
> we should have enough info to know which parts of each page to map in
> which pte, and that's all we need to solve it. At the second mprotect
> of 4k over the same 8k page will get two vmas queued in the same
> anon-vma. So we check both vmas and looking at the vm_pgoff(hardpage
> units)+(((address-vm_start)&~PAGE_MASK)>>HARD_PAGE_SHIFT we should be
> able to tell if the ptes behind the vma need to be updated and if the
> second vma can be merged back.
> The idea to make it work is to synchronously map all the ptes for all
> indexes covered by each page as long as they're in the range
> vm_start>>HARD_PAGE_SHIFT to vm_end >> HARD_PAGE_SHIFT. We should
> threat a page fault like a multiple page fault. Then when you mprotect
> or mremap you already know which ptes are mapped and that you need to
> unmap/update by looking the start/end hard-page-indexes, and you also
> have to always check all vmas that could possibly map that page, if
> the page cross the vm_start/vm_end boundary.

Hugh had this all worked out in 2001. I explored some alternatives in
the design space, but they didn't perform as well as the original.
It's best to refer to his original patch for reference as it's far
cleaner, though in principle one should be able to find machines where
the late 2.5.x patches I did will run. It was never exposed to a very
broad variety of systems, so I can't vouch for much beyond NUMA-Q and
ThinkPad and whatever Zwane booted it on.


On Sat, Jul 07, 2007 at 01:52:28AM +0200, Andrea Arcangeli wrote:
> Easy definitely not, but feasible I hope yes because I couldn't think
> of a case where we can't figure out which part of the page to map in
> which pte. I wish I had it implemented before posting because then I
> would be 100% sure it was feasible ;).
> Now if somebody here can think of a case where we can't know where to
> map which part of the page in which pte, then *that* would be very
> interesting and it could save some wasted development effort. Unless
> this happens, I guess I can keep trying to make it work, hopefully now
> with some help.

You may rest assured that it's technically feasible. It's been done.
The larger obstacles to all this are nontechnical.


-- wli
