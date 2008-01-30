Return-Path: <linux-kernel-owner+w=401wt.eu-S1763638AbYA3Ra0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763638AbYA3Ra0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758186AbYA3RaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:30:13 -0500
Received: from relay2.sgi.com ([192.48.171.30]:51356 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757041AbYA3RaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:30:11 -0500
Date: Wed, 30 Jan 2008 11:30:09 -0600
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080130173009.GT26420@sgi.com>
References: <20080128202923.849058104@sgi.com> <20080129162004.GL7233@v2.random> <Pine.LNX.4.64.0801291153520.25300@schroedinger.engr.sgi.com> <20080129211759.GV7233@v2.random> <Pine.LNX.4.64.0801291327330.26649@schroedinger.engr.sgi.com> <20080129220212.GX7233@v2.random> <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com> <20080130000039.GA7233@v2.random> <20080130161123.GS26420@sgi.com> <20080130170451.GP7233@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130170451.GP7233@v2.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 06:04:52PM +0100, Andrea Arcangeli wrote:
> On Wed, Jan 30, 2008 at 10:11:24AM -0600, Robin Holt wrote:
...
> > The three issues we need to simultaneously solve is revoking the remote
> > page table/tlb information while still in a sleepable context and not
> > having the remote faulters become out of sync with the granting process.
...
> > Could we consider doing a range-based recall and lock callout before
> > clearing the processes page tables/TLBs, then use the _page or _range
> > callouts from Andrea's patch to clear the mappings,  finally make a
> > range-based unlock callout.  The mmu_notifier user would usually use ops
> > for either the recall+lock/unlock family of callouts or the _page/_range
> > family of callouts.
> 
> invalidate_page/age_page can return inside ptep_clear_flush/young and
> Jack will need that too. Infact Jack will need an invalidate_page also
> inside ptep_get_and_clear. And the range callout will be done always
> in a sleeping context and it'll relay on the page-pin to be safe (when
> details->i_mmap_lock != NULL invalidate_range it shouldn't be called
> inside zap_page_range but before returning from
> unmap_mapping_range_vma before cond_resched). This will make
> everything a bit simpler and less prone to breakage IMHO, plus it'll
> have a chance to work for Jack w/o page-pin without additional
> cluttering of mm/*.c.

I don't think I saw the answer to my original question.  I assume your
original patch, extended in a way similar to what Christoph has done,
can be made to work to cover both the KVM and GRU (Jack's) case.

XPMEM, however, does not look to be solvable due to the three simultaneous
issues above.  To address that, I think I am coming to the conclusion
that we need an accompanying but seperate pair of callouts.  The first
will ensure the remote page tables and TLBs are cleared and all page
information is returned back to the process that is granting access to
its address space.  That will include an implicit block on the address
range so no further faults will be satisfied by the remote accessor
(forgot the KVM name for this, sorry).  Any faults will be held off
and only the processes page tables/TLBs are in play.  Once the normal
processing of the kernel is complete, an unlock callout would be made
for the range and then faulting may occur on behalf of the process again.

Currently, this is the only direct solution that I can see as a
possibility.  My question is two fold.  Does this seem like a reasonable
means to solve the three simultaneous issues above and if so, does it
seem like the most reasonable means?

Thanks,
Robin
