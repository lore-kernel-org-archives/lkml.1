Return-Path: <linux-kernel-owner+w=401wt.eu-S1764011AbYF3VSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764011AbYF3VSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbYF3VSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:18:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470AbYF3VSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:18:32 -0400
Date: Mon, 30 Jun 2008 17:17:21 -0400
From: Rik van Riel <riel@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splitlru: BDI_CAP_SWAP_BACKED
Message-ID: <20080630171721.51d0acc6@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.64.0806302103240.3064@blonde.site>
References: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
	<Pine.LNX.4.64.0806290122330.21758@blonde.site>
	<20080629173841.37CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080630115354.3a75edd3.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0806302020260.27080@blonde.site>
	<20080630154912.15f03b97@bree.surriel.com>
	<Pine.LNX.4.64.0806302103240.3064@blonde.site>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008 21:55:13 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:
> On Mon, 30 Jun 2008, Rik van Riel wrote:
> > 
> > Tmpfs is often in the same boat as anonymous memory.
> > Used for shared memory segments, or for files that
> > are temporary and will be gone soon.
> 
> Anonymous memory, and temporary files, are often soon gone,
> okay.  But I don't find that generalization compelling; and
> if they're soon gone, does it matter which lru they go on?

Temporary files are often soon gone.

Anonymous memory and shmem segments tend to stick around
for longer.
 
> > If swap space runs out, tmpfs pages should not be
> > scanned.
> 
> That point I like.  But I hope they'd go to the Unevictable
> on systems with no swap at all (of course, as with mlocking,
> that can change soon after).

If we have them on the *_ANON LRUs, we will automatically
not scan them when swap space runs out.  Just like we do
not scan anonymous pages when there is no swap space left.

> > To me, this suggests they should probably continue
> > to live on the *_ANON LRUs.  Worst case we make
> > tmpfs pages in files that are not mmaped (/tmp use)
> > start out on the inactive list, so they get evicted
> > first.
> 
> Tweaking in/active I'll gladly leave to you!  Whatever
> proves best.  What's worrying me is that we have always treated
> shmem/tmpfs pages as file pages

This is a performance problem for database systems,
where the system ends up swapping out the shared
memory segment.

> (e.g. in /proc/meminfo as Cached
> not as SwapCached), up until the point that we retire them to
> swap; but in splitlru you're sending them down another path;
> then mem cgroups seem to want them as something else again.

Having the mem cgroups consistent with the global LRU
implementation would be good, indeed.  That will make
balancing a bit easier.
 
> Your SwapBacked may indeed turn out to be the only implementable
> distinction, but it does worry me.  A more useful distinction,
> my gut tells me, would be separate LRUs for page_mapped() and
> !page_mapped(), which reflects the existing swappiness notion.
> 
> But that immediately hits the difficulty we have in switching LRU
> midstream, which your SwapBacked-throughout tmpfs neatly sidesteps.
>
> I'd really like to be able to try page_mapped/!page_mapped versus
> swap-backed/file-backed, but it would need some LRU-switching
> infrastructure (which might come at a prohibitive performance
> cost, since it's the batching that poses the problem).

Agreed, we understand the page_mapped/!page_mapped distinction
quite well.  On the other hand, we do not understand LRU
acrobatics (moving pages between lists on mmap/munmap) and the
consequences of that...

I suspect we'll just have to tweak the swap-backed/file-backed
code until it works right.  Once Andrew comes out with a new
-mm (with all the stability fixes), I will create a kernel RPM
with the latest split LRU code for Fedora 9, so we can get some
wider testing.

I have some performance tweaks in mind already, but not enough
data yet to justify them.  I will continue working on that.

-- 
All rights reversed.
