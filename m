Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbZFOJmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbZFOJmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZFOJmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:42:39 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49255 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZFOJmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:42:37 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/3] Fix malloc() stall in zone_reclaim() and bring behaviour more in line with expectations V3
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       riel@redhat.com, cl@linux-foundation.org, fengguang.wu@intel.com,
       linuxram@us.ibm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <20090612110424.GD14498@csn.ul.ie>
References: <20090611163006.e985639f.akpm@linux-foundation.org> <20090612110424.GD14498@csn.ul.ie>
Message-Id: <20090615163018.B43A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Jun 2009 18:42:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Thu, Jun 11, 2009 at 04:30:06PM -0700, Andrew Morton wrote:
> > On Thu, 11 Jun 2009 11:47:50 +0100
> > Mel Gorman <mel@csn.ul.ie> wrote:
> > 
> > > The big change with this release is that the patch reintroducing
> > > zone_reclaim_interval has been dropped as Ram reports the malloc() stalls
> > > have been resolved. If this bug occurs again, the counter will be there to
> > > help us identify the situation.
> > 
> > What is the exact relationship between this work and the somewhat
> > mangled "[PATCH for mmotm 0/5] introduce swap-backed-file-mapped count
> > and fix
> > vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch"
> > series?
> > 
> 
> The patch series "Fix malloc() stall in zone_reclaim() and bring
> behaviour more in line with expectations V3" replaces
> vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch.
> 
> Portions of the patch series "Introduce swap-backed-file-mapped count" are
> potentially follow-on work if a failure case can be identified. The series
> brings the kernel behaviour more in line with documentation, but it's easier
> to fix the documentation.

Agreed.


> > That five-patch series had me thinking that it was time to drop 
> > 
> > vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
> 
> This patch gets replaced. All the lessons in the new patch are included.
> They could be merged together.

Sure.


> > vmscan-drop-pf_swapwrite-from-zone_reclaim.patch
> 
> This patch is wrong, but only sortof. It should be dropped or replaced with
> another version. Kosaki, could you resubmit this patch except that you check
> if RECLAIM_SWAP is set in zone_reclaim_mode when deciding whether to set
> PF_SWAPWRITE or not please?

OK. I'll test it again with your patch.

> Your patch is correct if zone_reclaim_mode 1, but incorrect if it's 7 for
> example.

May I ask your worry?

Parhaps, my patch description was wrong. I should wrote patch effective
to separate small and large server.

First, our dirty page limitation is sane. Thus we don't need to care
all pages of system are dirty.

Thus, on large server, turning off PF_SWAPWRITE don't cause off-node allocation.
There are always clean and droppable page in system.

In the other hand, on small server, we need to concern write-back race because
system memory are relatively small.
Thus, turning off PF_SWAPWRITE might cause off-node allocation.

  - typically, small servers are latency aware than larger one.
  - zone reclaim is not the feature of gurantee no off-node allocation.
  - on small server, off-node allocation penalty is not much rather larger
    one in many case.

I sitll think this patch is valueable.


> > vmscan-zone_reclaim-use-may_swap.patch
> > 
> 
> This is a tricky one. Kosaki, I think this patch is a little dangerous. With
> this applied, pages get unmapped whether RECLAIM_SWAP is set or not. This
> means that zone_reclaim() now has more work to do when it's enabled and it
> incurs a number of minor faults for no reason as a result of trying to avoid
> going off-node. I don't believe that is desirable because it would manifest
> as high minor fault counts on NUMA and would be difficult to pin down why
> that was happening.

(cc to hanns)

First, if this patch should be dropped, commit bd2f6199 
(vmscan: respect higher order in zone_reclaim()) should be too. I think.

the combination of lumply reclaim and !may_unmap is really ineffective.
it might cause isolate neighbor pages and give up unmapping and pages put
back tail of lru.
it mean to shuffle lru list.

I don't think it is desirable.


Second, we did learned that "mapped or not mapped" is not appropriate
reclaim boosting between split-lru discussion.
So, I think to make consistent is better. if no considerness of may_unmap
makes serious performance issue, we need to fix try_to_free_pages() path too.


Third, if we consider MPI program on NUMA, each process only access
a part of array data frequently and never touch rest part of array.
So, AFAIK "rarely, but access" is rarely, no freqent access is not major performance source.


I have one question. your "difficultness of pinning down" is major issue?


> 
> I think the code makes more sense than the documentation and it's the
> documentation that should be fixed. Our current behaviour is to discard
> clean, swap-backed, unmapped pages that require no further IO. This is
> reasonable behaviour for zone_reclaim_mode == 1 so maybe the patch
> should change the documentation to
> 
>         1       = Zone reclaim discards clean unmapped disk-backed pages
>         2       = Zone reclaim writes dirty pages out
>         4       = Zone reclaim unmaps and swaps pages
> 
> If you really wanted to strict about the meaning of RECLAIM_SWAP, then
> something like the following would be reasonable;
> 
> 	.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
> 	.may_swap = !!(zone_reclaim_mode & RECLAIM_SWAP),
> 
> because a system administrator is not going to distinguish between
> unmapping and swap. I would assume at least that RECLAIM_SWAP implies
> unmapping pages for swapping but an updated documentation wouldn't hurt
> with
> 
> 	4       = Zone reclaim unmaps and swaps pages
> 
> > (they can be removed cleanly, but I haven't tried compiling the result)
> > 
> > but your series is based on those.
> > 
> 
> The patchset only depends on
> vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
> and then only because of merge conflicts. All the lessons in
> vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch are
> incorporated.
> 
> > We have 142 MM patches queued, and we need to merge next week.
> > 
> 
> I'm sorry my timing for coming out with the zone_reclaim() patches sucks
> and that I failed to spot these patches earlier. Despite the abundance
> of evidence, I'm not trying to be deliberatly awkward :/
> 
> -- 
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab



