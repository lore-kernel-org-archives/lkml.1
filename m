Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYFWAyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYFWAyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 20:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYFWAyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 20:54:07 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:50439 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805AbYFWAyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 20:54:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAACOXkh5LG+u/2dsb2JhbACuAA
X-IronPort-AV: E=Sophos;i="4.27,686,1204464600"; 
   d="scan'208";a="132610942"
Date: Mon, 23 Jun 2008 10:53:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: [2.6.26-rc7] shrink_icache from pagefault locking (nee: nfsd
	hangs for a few sec)...
Message-ID: <20080623005359.GC29319@disturbed>
Mail-Followup-To: Mel Gorman <mel@csn.ul.ie>,
	Daniel J Blueman <daniel.blueman@gmail.com>,
	Christoph Lameter <clameter@sgi.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
References: <6278d2220806220256g674304ectb945c14e7e09fede@mail.gmail.com> <6278d2220806220258p28de00c1x615ad7b2f708e3f8@mail.gmail.com> <20080622221930.GA11558@disturbed> <20080623002415.GB21597@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623002415.GB21597@csn.ul.ie>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 01:24:15AM +0100, Mel Gorman wrote:
> On (23/06/08 08:19), Dave Chinner didst pronounce:
> > [added xfs@oss.sgi.com to cc]
> > 
> > On Sun, Jun 22, 2008 at 10:58:56AM +0100, Daniel J Blueman wrote:
> > > I'm seeing a similar issue [2] to what was recently reported [1] by
> > > Alexander, but with another workload involving XFS and memory
> > > pressure.

[....]

> > You may as well ignore anything invlving this path in XFS until
> > lockdep gets fixed. The kswapd reclaim path is inverted over the
> > synchronous reclaim path that is xfs_ilock -> run out of memory ->
> > prune_icache and then potentially another -> xfs_ilock.
> > 
> 
> In that case, have you any theory as to why this circular dependency is
> being reported now but wasn't before 2.6.26-rc1? I'm beginning to wonder
> if the bisecting fingering the zonelist modifiation is just a
> co-incidence.

Probably co-incidence. Perhaps it's simply changed the way reclaim
is behaving and we are more likely to be trimming slab caches
instead of getting free pages from the page lists?

> Also, do you think the stalls were happening before but just not
> being noticed?

Entirely possible, I think,  but I know of no evidence one way or
another.

[....]

> > FWIW, should page allocation in a page fault be allowed to recurse
> > into the filesystem? If I follow the spaghetti of inline and
> > compiler inlined functions correctly, this is a GFP_HIGHUSER_MOVABLE
> > allocation, right? Should we be allowing shrink_icache_memory()
> > to be called at all in the page fault path?
> 
> Well, the page fault path is able to go to sleep and can enter direct
> reclaim under low memory situations. Right now, I'm failing to see why a
> page fault should not be allowed to reclaim pages in use by a
> filesystem.  It was allowed before so the question still is why the
> circular lock warning appears now but didn't before.

Yeah, it's the fact that this is the first time that this lockdep
warning has come up that prompted me to ask the question. I know
that we are not allowed to lock an inode in the fault path as that
can lead to deadlocks in the read and write paths, so what I was
really wondering is if we can deadlock in a more convoluted manner
by taking locks on *other inodes* in the page fault path....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
