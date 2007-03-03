Return-Path: <linux-kernel-owner+w=401wt.eu-S2992950AbXCCE4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992950AbXCCE4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 23:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992965AbXCCE4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 23:56:20 -0500
Received: from fgwmail2.fujitsu.co.jp ([164.71.1.135]:38193 "EHLO
	fgwmail2.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992950AbXCCE4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 23:56:19 -0500
Date: Sat, 3 Mar 2007 13:54:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: mel@skynet.ie (Mel Gorman)
Cc: akpm@linux-foundation.org, npiggin@suse.de, clameter@engr.sgi.com,
       mingo@elte.hu, jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org,
       linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
Message-Id: <20070303135445.e2140ce2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070302163206.GA1555@skynet.ie>
References: <20070301101249.GA29351@skynet.ie>
	<20070301160915.6da876c5.akpm@linux-foundation.org>
	<20070302163206.GA1555@skynet.ie>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 16:32:07 +0000
mel@skynet.ie (Mel Gorman) wrote:

> The zone-based patches for memory partitioning should be providing what is
> required for memory hot-remove of an entire DIMM or bank of memory (PPC64
> also cares about removing smaller blocks of memory but zones are overkill
> there and anti-fragmentation on its own is good enough).  Pages hot-added
> to ZONE_MOVABLE will always be reclaimable or migratable in the case of
> mlock(). Kamezawa Hiroyuki has indicated that his hot-remove patches also
> do something like ZONE_MOVABLE. I would hope that his patches could be
> easily based on top of my memory partitioning set of patches. The markup
> of pages has been tested and the zone definitely works. I've added the
> kamezawa.hiroyu@jp.fujitsu.com to the cc list so he can comment :)

Thanks. As you wrote, I'm planning to write patch based on ZONE_MOVABLE.
I'm now using my own one just because I can't handle too many patches.
My version has a few just-for-cleanup patches. And it may be a bit different
from yours. I'll add cc to you when I post.
It's not ready to send yet...(found some panic at offlining memory ;)

> What I do not do in my patchset is hot-add to ZONE_MOVABLE because I couldn't
> be certain it's what the hotplug people wanted. They will of course need to
> hot-add to that zone if they want to be able to remove it later.
> 
I'm planing to make hot-added memory as ZONE_MOVABLE. I believe we can find and 
move movable pages in ZONE_NOT_MOVABLE to ZONE_MOVABLE.(or kswapd/pageout will
do this in slow way.) The reason is that my first purpose is removing hot-added-memory.

I think I can add knob to choose a zone for hot-added-memory but I won't do it
until someone wants it.

> For node-based memory hot-add and hot-remove, the node would consist of just
> one populated zone - ZONE_MOVABLE.
> 
yes.

Note:
We are considering to allocate well-known-structures like mem_map and pgdat
from hot-added memory. We can remove it when a node is unplugged.
But no plan/patches yet.


> For the removal of DIMMs, anti-fragmentation has something additional
> to offer. The later patches in the anti-fragmentation patchset bias the
> placement of unmovable pages towards the lower PFNs. It's not very strict
> about this because being strict would cost. A mechanism could be put in place
> that enforced the placement of unmovables pages at low PFNS. Due to the cost,
> it would need to be disabled by default and enabled on request. On the plus
> side, the cost would only be incurred when splitting a MAX_ORDER block of
> pages which is a rare event.

And kernel on VM, IBM's uses 16MB sparsemem for memory-hotplug, can get
enough benefit. While Xen's baloon driver can do memory-unplug, I heard
it causes memory fragmentation. anti-frag patch will help this.

-Kame

