Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbYKVKWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbYKVKWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 05:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYKVKWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 05:22:11 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59746 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbYKVKWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 05:22:10 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH -mm] vmscan: bail out of page reclaim after swap_cluster_max pages
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20081115235410.2d2c76de.akpm@linux-foundation.org>
References: <20081116163915.F208.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081115235410.2d2c76de.akpm@linux-foundation.org>
Message-Id: <20081122191258.26B0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sat, 22 Nov 2008 19:22:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I digged many git-log today.


> > > > Of course, one thing we could do is exempt kswapd from this check.
> > > > During light reclaim, kswapd does most of the eviction so scanning
> > > > should remain balanced.  Having one process fall down to a lower
> > > > priority level is also not a big problem.
> > > > 
> > > > As long as the direct reclaim processes do not also fall into the
> > > > same trap, the situation should be manageable.
> > > > 
> > > > Does that sound reasonable to you?
> > > 
> > > I'll need to find some time to go dig through the changelogs.  
> > 
> > as far as I tried, git database doesn't have that changelogs.
> > FWIW, I guess it is more old.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/old-2.6-bkcvs.git
> goes back to 2.5.20 (iirc).

sorry, I was wrong.
following patch revertion was happend at 2006.

And, thank you andrew.
your comment is very nice.

So, desiable behavior is

	direct reclaim:
		should be bailed out if enough page reclaimed

	kswapd:
		don't bailed.


Actually, my prepared another bailed out patch has sc->may_cut_off member.
shrink_zone can do shorcut exiting if only sc->may_cut_off==1.


Rik, sorry, I nak current your patch. 
because it don't fix old akpm issue.

Very sorry. 


------------------------------------------------------------------------
From: Andrew Morton <akpm@osdl.org>
Date: Fri, 6 Jan 2006 08:11:14 +0000 (-0800)
Subject: [PATCH] vmscan: balancing fix
X-Git-Tag: v2.6.16-rc1~936^2~246


Revert a patch which went into 2.6.8-rc1.  The changelog for that patch was:

  The shrink_zone() logic can, under some circumstances, cause far too many
  pages to be reclaimed.  Say, we're scanning at high priority and suddenly
  hit a large number of reclaimable pages on the LRU.

  Change things so we bale out when SWAP_CLUSTER_MAX pages have been
  reclaimed.

Problem is, this change caused significant imbalance in inter-zone scan
balancing by truncating scans of larger zones.

Suppose, for example, ZONE_HIGHMEM is 10x the size of ZONE_NORMAL.  The zone
balancing algorithm would require that if we're scanning 100 pages of
ZONE_HIGHMEM, we should scan 10 pages of ZONE_NORMAL.  But this logic will
cause the scanning of ZONE_HIGHMEM to bale out after only 32 pages are
reclaimed.  Thus effectively causing smaller zones to be scanned relatively
harder than large ones.

Now I need to remember what the workload was which caused me to write this
patch originally, then fix it up in a different way...
----------------------------------------------------------------------------




