Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbZJLVTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbZJLVTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758200AbZJLVTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:19:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807AbZJLVTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:19:16 -0400
Date: Mon, 12 Oct 2009 23:18:38 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/45] writeback: reduce calls to global_page_state in
	balance_dirty_pages()
Message-ID: <20091012211838.GA3965@duck.suse.cz>
References: <20091007073818.318088777@intel.com> <20091007074901.251116016@intel.com> <20091009151230.GF7654@duck.suse.cz> <20091010213339.GA8644@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091010213339.GA8644@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 11-10-09 05:33:39, Wu Fengguang wrote:
> On Fri, Oct 09, 2009 at 11:12:31PM +0800, Jan Kara wrote:
> > > +			/* don't wait if we've done enough */
> > > +			if (pages_written >= write_chunk)
> > > +				break;
> > >  		}
> > > -
> > > -		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
> > > -			break;
> > > -		if (pages_written >= write_chunk)
> > > -			break;		/* We've done our duty */
> > > -
> >   Here, we had an opportunity to break from the loop even if we didn't
> > manage to write everything (for example because per-bdi thread managed to
> > write enough or because enough IO has completed while we were trying to
> > write). After the patch, we will sleep. IMHO that's not good...
> 
> Note that the pages_written check is moved several lines up in the patch :)
> 
> >   I'd think that if we did all that work in writeback_inodes_wbc we could
> > spend the effort on regetting and rechecking the stats...
> 
> Yes maybe. I didn't care it because the later throttle queue patch totally
> removed the loop and hence to need to reget the stats :)
  Yes, since the loop gets removed in the end, this does not matter. You
are right.

> > >  		schedule_timeout_interruptible(pause);
> > >
> > >  		/*
> > > @@ -577,8 +547,7 @@ static void balance_dirty_pages(struct a
> > >  			pause = HZ / 10;
> > >  	}
> > >
> > > -	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&
> > > -			bdi->dirty_exceeded)
> > > +	if (!dirty_exceeded && bdi->dirty_exceeded)
> > >  		bdi->dirty_exceeded = 0;
> >   Here we fail to clear dirty_exceeded if we are over global dirty limit
> > but not over per-bdi dirty limit...
> 
> You must be mistaken: dirty_exceeded = (over bdi limit || over global limit),
> so !dirty_exceeded = (!over bdi limit && !over global limit).
  Exactly. Previously, the check was:
if (!over bdi limit)
  bdi->dirty_exceeded = 0;

  Now it is
if (!over bdi limit && !over global limit)
  bdi->dirty_exceeded = 0;

  That's clearly not equivalent which is what I was trying to point out.
But looking at where dirty_exceeded is used, your new way is probably more
useful. It's just a bit counterintuitive that bdi->dirty_exceeded is set
even if the per-bdi limit is not exceeded...

									Honza

--
Jan Kara <jack@suse.cz>
SUSE Labs, CR
