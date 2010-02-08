Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab0BHNnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 08:43:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:50207 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab0BHNnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 08:43:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,429,1262592000"; 
   d="scan'208";a="771038621"
Date: Mon, 8 Feb 2010 21:43:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Clemens Ladisch <clemens@ladisch.de>,
       Olivier Galibert <galibert@pobox.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/11] readahead: replace ra->mmap_miss with
	ra->ra_flags
Message-ID: <20100208134308.GA19019@localhost>
References: <20100207041013.891441102@intel.com> <20100207041043.429863034@intel.com> <20100208081918.GD9781@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208081918.GD9781@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 04:19:18PM +0800, Nick Piggin wrote:
> On Sun, Feb 07, 2010 at 12:10:18PM +0800, Wu Fengguang wrote:
> > Introduce a readahead flags field and embed the existing mmap_miss in it
> > (to save space).
> 
> Is that the only reason? 

Several readahead flags/states will be introduced in the next patches.

> > It will be possible to lose the flags in race conditions, however the
> > impact should be limited.
> 
> Is this really a good tradeoff? Randomly readahead behaviour can
> change.

It's OK. The readahead behavior won't change in "big" way.

For the race to happen, there must be two threads sharing the same
file descriptor to be in page fault or readahead at the same time.

Note that it has always been racy for "page faults" at the same time.

And if ever the race happen, we'll lose one mmap_miss++ or
mmap_miss--. Which may change some concrete readahead behavior, but
won't really impact overall I/O performance.

> I never liked this mmap_miss counter, though. It doesn't seem like
> it can adapt properly for changing mmap access patterns.

The mmap_miss aims to avoid excessive pointless read-around for sparse
random reads. As long as mmap_miss does not exceed MMAP_LOTSAMISS=100,
the read-around is expected to help the common clustered random reads
(aka. strong locality of references).

> Is there any reason why the normal readahead algorithms can't
> detect this kind of behaviour (in much fewer than 100 misses) and
> also adapt much faster if the access changes?

Assuming there's only two page fault patterns:
- those with strong locality of references
- those sparse random reads

Then:

1) MMAP_LOTSAMISS may be reduced to 10 when we increase the default
   readahead size to 512K. The "10" is big enough to not hurt the
   typical executable/lib page faults.

2) the mmap_miss ceiling value (reduced to 0xffff in this patch) may be
   further reduced to 0xff to adapt faster to access changes?  I'm not
   sure though - I don't have any real world workload in mind.. Nor
   have we heard of complaints on the mmap_miss magic.

For a better (2), it's possible to have a page cache context based
heuristic to determine if we need to do read-around immediately
(instead of slowly counting down mmap_miss):

        when page fault at @index:
                if (mmap_miss > MMAP_LOTSAMISS) {
     -             don't do read-around;
     +             struct radix_tree_node *node = radix_tree_lookup_node(index);
     +             if (node && node->count) /* any nearby page cached? */
     +                     do read-around;
                }

Thanks,
Fengguang

> > 
> > CC: Nick Piggin <npiggin@suse.de>
> > CC: Andi Kleen <andi@firstfloor.org>
> > CC: Steven Whitehouse <swhiteho@redhat.com>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  include/linux/fs.h |   30 +++++++++++++++++++++++++++++-
> >  mm/filemap.c       |    7 ++-----
> >  2 files changed, 31 insertions(+), 6 deletions(-)
> > 
> > --- linux.orig/include/linux/fs.h	2010-02-07 11:46:35.000000000 +0800
> > +++ linux/include/linux/fs.h	2010-02-07 11:46:37.000000000 +0800
> > @@ -892,10 +892,38 @@ struct file_ra_state {
> >  					   there are only # of pages ahead */
> >  
> >  	unsigned int ra_pages;		/* Maximum readahead window */
> > -	unsigned int mmap_miss;		/* Cache miss stat for mmap accesses */
> > +	unsigned int ra_flags;
> >  	loff_t prev_pos;		/* Cache last read() position */
> >  };
> >  
> > +/* ra_flags bits */
> > +#define	READAHEAD_MMAP_MISS	0x0000ffff /* cache misses for mmap access */
> > +
> > +/*
> > + * Don't do ra_flags++ directly to avoid possible overflow:
> > + * the ra fields can be accessed concurrently in a racy way.
> > + */
> > +static inline unsigned int ra_mmap_miss_inc(struct file_ra_state *ra)
> > +{
> > +	unsigned int miss = ra->ra_flags & READAHEAD_MMAP_MISS;
> > +
> > +	if (miss < READAHEAD_MMAP_MISS) {
> > +		miss++;
> > +		ra->ra_flags = miss | (ra->ra_flags &~ READAHEAD_MMAP_MISS);
> > +	}
> > +	return miss;
> > +}
> > +
> > +static inline void ra_mmap_miss_dec(struct file_ra_state *ra)
> > +{
> > +	unsigned int miss = ra->ra_flags & READAHEAD_MMAP_MISS;
> > +
> > +	if (miss) {
> > +		miss--;
> > +		ra->ra_flags = miss | (ra->ra_flags &~ READAHEAD_MMAP_MISS);
> > +	}
> > +}
> > +
> >  /*
> >   * Check if @index falls in the readahead windows.
> >   */
> > --- linux.orig/mm/filemap.c	2010-02-07 11:46:35.000000000 +0800
> > +++ linux/mm/filemap.c	2010-02-07 11:46:37.000000000 +0800
> > @@ -1418,14 +1418,12 @@ static void do_sync_mmap_readahead(struc
> >  		return;
> >  	}
> >  
> > -	if (ra->mmap_miss < INT_MAX)
> > -		ra->mmap_miss++;
> >  
> >  	/*
> >  	 * Do we miss much more than hit in this file? If so,
> >  	 * stop bothering with read-ahead. It will only hurt.
> >  	 */
> > -	if (ra->mmap_miss > MMAP_LOTSAMISS)
> > +	if (ra_mmap_miss_inc(ra) > MMAP_LOTSAMISS)
> >  		return;
> >  
> >  	/*
> > @@ -1455,8 +1453,7 @@ static void do_async_mmap_readahead(stru
> >  	/* If we don't want any read-ahead, don't bother */
> >  	if (VM_RandomReadHint(vma))
> >  		return;
> > -	if (ra->mmap_miss > 0)
> > -		ra->mmap_miss--;
> > +	ra_mmap_miss_dec(ra);
> >  	if (PageReadahead(page))
> >  		page_cache_async_readahead(mapping, ra, file,
> >  					   page, offset, ra->ra_pages);
> > 
