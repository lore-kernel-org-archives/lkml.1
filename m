Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbXJBPrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbXJBPrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbXJBPrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:47:15 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:17885 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbXJBPrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:47:14 -0400
Date: Tue, 2 Oct 2007 16:46:04 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: Memory controller merge (was Re: -mm merge plans for 2.6.24)
In-Reply-To: <4701C737.8070906@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0710021604260.4916@blonde.wat.veritas.com>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
 <4701C737.8070906@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Balbir Singh wrote:
> Andrew Morton wrote:
> > memory-controller-add-documentation.patch
> > ...
> > kswapd-should-only-wait-on-io-if-there-is-io.patch
> > 
> >   Hold.  This needs a serious going-over by page reclaim people.
> 
> I mostly agree with your decision. I am a little concerned however
> that as we develop and add more features (a.k.a better statistics/
> forced reclaim), which are very important; the code base gets larger,
> the review takes longer :)

I agree with putting the memory controller stuff on hold from 2.6.24.

Sorry, Balbir, I've failed to get back to you, still attending to
priorities.  Let me briefly summarize my issue with the mem controller:
you've not yet given enough attention to swap.

I accept that full swap control is something you're intending to add
incrementally later; but the current state doesn't make sense to me.

The problems are swapoff and swapin readahead.  These pull pages into
the swap cache, which are assigned to the cgroup (or the whatever-we-
call-the-remainder-outside-all-the-cgroups) which is running swapoff
or faulting in its own page; yet they very clearly don't (in general)
belong to that cgroup, but to other cgroups which will be discovered
later.

I did try removing the cgroup mods to mm/swap_state.c, so swap pages
get assigned to a cgroup only once it's really known; but that's not
enough by itself, because cgroup RSS reclaim doesn't touch those
pages, so the cgroup can easily OOM much too soon.  I was thinking
that you need a "limbo" cgroup for these pages, which can be attacked
for reclaim along with any cgroup being reclaimed, but from which
pages are readily migrated to their real cgroup once that's known.

But I had to switch over to other work before trying that out:
perhaps the idea doesn't really fly at all.  And it might well
be no longer needed once full mem+swap control is there.

So in the current memory controller, that unuse_pte mem charge I was
originally worried about failing (I hadn't at that point delved in
to see how it tries to reclaim) actually never fails (and never
does anything): the page is already assigned to some cgroup-or-
whatever and is never charged to vma->vm_mm at that point.

And small point: once that is sorted out and the page is properly
assigned in unuse_pte, you'll be needing to pte_unmap_unlock and
pte_offset_map_lock around the mem_cgroup_charge call there -
you're right to call it with GFP_KERNEL, but cannot do so while
holding the page table locked and mapped.  (But because the page
lock is held, there shouldn't be any raciness to dropping and
retaking the ptl.)

Hugh
