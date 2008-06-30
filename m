Return-Path: <linux-kernel-owner+w=401wt.eu-S1764148AbYF3Uzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764148AbYF3Uzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbYF3Uz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:55:29 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:38946 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYF3Uz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:55:28 -0400
Date: Mon, 30 Jun 2008 21:55:13 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Rik van Riel <riel@redhat.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splitlru: BDI_CAP_SWAP_BACKED
In-Reply-To: <20080630154912.15f03b97@bree.surriel.com>
Message-ID: <Pine.LNX.4.64.0806302103240.3064@blonde.site>
References: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
 <Pine.LNX.4.64.0806290122330.21758@blonde.site> <20080629173841.37CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <20080630115354.3a75edd3.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0806302020260.27080@blonde.site> <20080630154912.15f03b97@bree.surriel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, Rik van Riel wrote:
> 
> Tmpfs is often in the same boat as anonymous memory.
> Used for shared memory segments, or for files that
> are temporary and will be gone soon.

Anonymous memory, and temporary files, are often soon gone,
okay.  But I don't find that generalization compelling; and
if they're soon gone, does it matter which lru they go on?

> If swap space runs out, tmpfs pages should not be
> scanned.

That point I like.  But I hope they'd go to the Unevictable
on systems with no swap at all (of course, as with mlocking,
that can change soon after).

> To me, this suggests they should probably continue
> to live on the *_ANON LRUs.  Worst case we make
> tmpfs pages in files that are not mmaped (/tmp use)
> start out on the inactive list, so they get evicted
> first.

Tweaking in/active I'll gladly leave to you!  Whatever
proves best.  What's worrying me is that we have always treated
shmem/tmpfs pages as file pages (e.g. in /proc/meminfo as Cached
not as SwapCached), up until the point that we retire them to
swap; but in splitlru you're sending them down another path;
then mem cgroups seem to want them as something else again.

Your SwapBacked may indeed turn out to be the only implementable
distinction, but it does worry me.  A more useful distinction,
my gut tells me, would be separate LRUs for page_mapped() and
!page_mapped(), which reflects the existing swappiness notion.

But that immediately hits the difficulty we have in switching LRU
midstream, which your SwapBacked-throughout tmpfs neatly sidesteps.

I'd really like to be able to try page_mapped/!page_mapped versus
swap-backed/file-backed, but it would need some LRU-switching
infrastructure (which might come at a prohibitive performance
cost, since it's the batching that poses the problem).

Hugh
