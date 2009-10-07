Return-Path: <linux-kernel-owner+w=401wt.eu-S1759108AbZJGOB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108AbZJGOB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758620AbZJGOB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:01:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:59751 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758596AbZJGOB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:01:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,519,1249282800"; 
   d="scan'208";a="196072769"
Date: Wed, 7 Oct 2009 22:00:28 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 29/45] writeback: fix the shmem AOP_WRITEPAGE_ACTIVATE
	case
Message-ID: <20091007140028.GA26280@localhost>
References: <20091007073818.318088777@intel.com> <20091007074904.870825579@intel.com> <Pine.LNX.4.64.0910071246180.28844@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910071246180.28844@sister.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 07:57:00PM +0800, Hugh Dickins wrote:
> On Wed, 7 Oct 2009, Wu Fengguang wrote:
> 
> > When shmem returns AOP_WRITEPAGE_ACTIVATE, the inode pages cannot be
> > synced in the near future. So write_cache_pages shall stop writting this
> > inode, and shmem shall increase pages_skipped to instruct VFS not to
> > busy retry.
> > 
> > CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> Okay, it embarrasses me to see AOP_WRITEPAGE_ACTIVATE (and its horrid
> "in this one case the page is still locked" semantic) still around -
> my patch to remove it vanished from mmotm (probably caused a temporary
> conflict) and I've never chased it up (partly out of guilt that I'd not
> yet kept my promise to contact the openAFS people about their use of it).

Googled this one :) 

        http://markmail.org/thread/fivi4bgylwsy26ws

In fact we could just return from shmem_writepage() with PG_dirty and
!PG_writeback. Then the page will be put back to LRU with PG_reclaim
cleared. It could well happen in other filesystems who has trouble to
writeback the page for the time (those already do pages_skipped++).

> But that's orthogonal to your concern here: for so long as there has
> been a wbc->pages_skipped, I guess shmem_writepage() should have been
> incrementing it there - thanks.  But I don't believe the VFS will ever
> have any interest in pages_skipped from shmem_writepage(): do you have
> evidence that it does?  If so, I need to investigate.

Yes :) Except in this new code.

> And the accompanying change to write_cache_pages() seems irrelevant
> and misguided.  Irrelevant because write_cache_pages() should never be
> dealing with shmem_writepage() (its bdi should keep it well away), and
> should never be dealing with reclaim, which is the only case in which
> shmem_writepage() returns AOP_WRITEPAGE_ACTIVATE - or have your other
> changes, or the bdi work, changed that?

That becomes possible with my another patch (30/45). I've added check
to avoid doing lumpy reclaim for shmem. So now everything returns to
normal :)

> And misguided because in your change to write_cache_pages() you're
> taking AOP_WRITEPAGE_ACTIVATE to say that it should now give up, not
> process more pages.  We just don't know that.  All it means is that
> this one page couldn't be written and should be reactivated (if it
> were under reclaim): it might be the case that every other page tried
> after would get treated in the same way, or it might be the case that
> the next page would get written successfully.  That info is just not
> provided.

Yes, it was over-smart indeed. I'll revert that chunk (or
AOP_WRITEPAGE_ACTIVATE) totally.

Thanks,
Fengguang

> > ---
> >  mm/page-writeback.c |   23 +++++++++++------------
> >  mm/shmem.c          |    1 +
> >  2 files changed, 12 insertions(+), 12 deletions(-)
> > 
> > --- linux.orig/mm/page-writeback.c	2009-10-06 23:39:28.000000000 +0800
> > +++ linux/mm/page-writeback.c	2009-10-06 23:39:29.000000000 +0800
> > @@ -851,19 +851,18 @@ continue_unlock:
> >  				if (ret == AOP_WRITEPAGE_ACTIVATE) {
> >  					unlock_page(page);
> >  					ret = 0;
> > -				} else {
> > -					/*
> > -					 * done_index is set past this page,
> > -					 * so media errors will not choke
> > -					 * background writeout for the entire
> > -					 * file. This has consequences for
> > -					 * range_cyclic semantics (ie. it may
> > -					 * not be suitable for data integrity
> > -					 * writeout).
> > -					 */
> > -					done = 1;
> > -					break;
> >  				}
> > +				/*
> > +				 * done_index is set past this page,
> > +				 * so media errors will not choke
> > +				 * background writeout for the entire
> > +				 * file. This has consequences for
> > +				 * range_cyclic semantics (ie. it may
> > +				 * not be suitable for data integrity
> > +				 * writeout).
> > +				 */
> > +				done = 1;
> > +				break;
> >   			}
> >  
> >  			if (nr_to_write > 0) {
> > --- linux.orig/mm/shmem.c	2009-10-06 23:37:40.000000000 +0800
> > +++ linux/mm/shmem.c	2009-10-06 23:39:29.000000000 +0800
> > @@ -1103,6 +1103,7 @@ unlock:
> >  	 */
> >  	swapcache_free(swap, NULL);
> >  redirty:
> > +	wbc->pages_skipped++;
> >  	set_page_dirty(page);
> >  	if (wbc->for_reclaim)
> >  		return AOP_WRITEPAGE_ACTIVATE;	/* Return with page locked */
