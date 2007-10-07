Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbXJGRnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbXJGRnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 13:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbXJGRnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 13:43:17 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:46107 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbXJGRnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 13:43:16 -0400
Date: Sun, 7 Oct 2007 18:41:48 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: Memory controller merge (was Re: -mm merge plans for 2.6.24)
In-Reply-To: <4705AA79.9080008@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0710071758210.13172@blonde.wat.veritas.com>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
 <4701C737.8070906@linux.vnet.ibm.com> <Pine.LNX.4.64.0710021604260.4916@blonde.wat.veritas.com>
 <47034F12.8020505@linux.vnet.ibm.com> <Pine.LNX.4.64.0710031918470.9414@blonde.wat.veritas.com>
 <47046922.4030709@linux.vnet.ibm.com> <Pine.LNX.4.64.0710041258530.3485@blonde.wat.veritas.com>
 <4705AA79.9080008@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, Balbir Singh wrote:
> Hugh Dickins wrote:
> > 
> > That's where it should happen, yes; but my point is that it very
> > often does not.  Because the swap cache page (read in as part of
> > the readaround cluster of some other cgroup, or in swapoff by some
> > other cgroup) is already assigned to that other cgroup (by the
> > mem_cgroup_cache_charge in __add_to_swap_cache), and so goes "The
> > page_cgroup exists and the page has already been accounted" route
> > when mem_cgroup_charge is called from do_swap_page.  Doesn't it?
> > 
> 
> You are right, at this point I am beginning to wonder if I should
> account for the swap cache at all? We account for the pages in RSS
> and when the page comes back into the page table(s) via do_swap_page.
> If we believe that the swap cache is transitional and the current
> expected working behaviour does not seem right or hard to fix,
> it might be easy to ignore unuse_pte() and add/remove_from_swap_cache()
> for accounting and control.

It would be wrong to ignore the unuse_pte() case: what it's intending
to do is correct, it's just being prevented by the swapcache issue
from doing what it intends at present.

(Though I'm not thrilled with the idea of it causing an admin's
swapoff to fail because of a cgroup reaching mem limit there, I do
agree with your earlier argument that that's the right thing to happen,
and it's up to the admin to fix things up - my original objection came
from not realizing that normally the cgroup will reclaim from itself
to free its mem.  Hmm, would the charge fail or the mm get OOM'ed?)

Ignoring add_to/remove_from swap cache is what I've tried before,
and again today.  It's not enough: if you trying run a memhog
(something that allocates and touches more memory than the cgroup
is allowed, relying on pushing out to swap to complete), then that
works well with the present accounting in add_to/remove_from swap
cache, but it OOMs once I remove the memcontrol mods from
mm/swap_state.c.  I keep going back to investigate why, keep on
thinking I understand it, then later realize I don't.  Please
give it a try, I hope you've got better mental models than I have.

And I don't think it will be enough to handle shmem/tmpfs either;
but won't worry about that until we've properly understood why
exempting swapcache leads to those OOMs, and fixed that up.

> > Are we misunderstanding each other, because I'm assuming
> > MEM_CGROUP_TYPE_ALL and you're assuming MEM_CGROUP_TYPE_MAPPED?
> > though I can't see that _MAPPED and _CACHED are actually supported,
> > there being no reference to them outside the enum that defines them.
> 
> I am also assuming MEM_CGROUP_TYPE_ALL for the purpose of our
> discussion. The accounting is split into mem_cgroup_charge() and
> mem_cgroup_cache_charge(). While charging the caches is when we
> check for the control_type.

It checks MEM_CGROUP_TYPE_ALL there, yes; but I can't find anything
checking for either MEM_CGROUP_TYPE_MAPPED or MEM_CGROUP_TYPE_CACHED.
(Or is it hidden in one of those preprocesor ## things which frustrate
both my greps and me!?)

> > Or are you deceived by that ifdef NUMA code in swapin_readahead,
> > which propagates the fantasy that swap allocation follows vma layout?
> > That nonsense has been around too long, I'll soon be sending a patch
> > to remove it.
> 
> The swapin readahead code under #ifdef NUMA is very confusing.

I sent a patch to linux-mm last night, to remove that confusion.

> I also
> noticed another confusing thing during my test, swap cache does not
> drop to 0, even though I've disabled all swap using swapoff. May be
> those are tmpfs pages. The other interesting thing I tried was running
> swapoff after a cgroup went over it's limit, the swapoff succeeded,
> but I see strange numbers for free swap. I'll start another thread
> after investigating a bit more.

Those indeed are strange behaviours (if the swapoff really has
succeeded, rather than lying), I not seen such and don't have an
explanation.  tmpfs doesn't add any weirdness there: when there's
no swap, there can be no swap cache.  Or is the swapoff still in
progress?  While it's busy, we keep /proc/meminfo looking sensible,
but <Alt><SysRq>m can show negative free swap (IIRC).

I'll be interested to hear what your investigation shows.

Hugh
