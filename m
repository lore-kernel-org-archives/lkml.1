Return-Path: <linux-kernel-owner+w=401wt.eu-S933344AbXCMWM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344AbXCMWM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 18:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933342AbXCMWM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 18:12:56 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48382 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933344AbXCMWMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 18:12:55 -0400
Date: Wed, 14 Mar 2007 09:12:36 +1100
From: David Chinner <dgc@sgi.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dgc@sgi.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 3/8] per backing_dev dirty and writeback page accounting
Message-ID: <20070313221236.GY6095633@melbourne.sgi.com>
References: <20070306180443.669036741@szeredi.hu> <20070306180550.793803735@szeredi.hu> <20070312062349.GN6095633@melbourne.sgi.com> <E1HQitT-0002wP-00@dorka.pomaz.szeredi.hu> <20070312214405.GQ6095633@melbourne.sgi.com> <E1HQt7o-00042r-00@dorka.pomaz.szeredi.hu> <20070312231256.GT6095633@melbourne.sgi.com> <E1HR2Gd-0004oR-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HR2Gd-0004oR-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 09:21:59AM +0100, Miklos Szeredi wrote:
> > > read request
> > > sys_write
> > >   mutex_lock(i_mutex)
> > >   ...
> > >      balance_dirty_pages
> > >         submit write requests
> > >         loop ... write requests completed ... dirty still over limit ... 
> > > 	... loop forever
> > 
> > Hmmm - the situation in balance_dirty_pages() after an attempt
> > to writeback_inodes(&wbc) that has written nothing because there
> > is nothing to write would be:
> > 
> > 	wbc->nr_write == write_chunk &&
> > 	wbc->pages_skipped == 0 &&
> > 	wbc->encountered_congestion == 0 &&
> > 	!bdi_congested(wbc->bdi)
> > 
> > What happens if you make that an exit condition to the loop?
> 
> That's almost right.  The only problem is that even if there's no
> congestion, the device queue can be holding a great amount of yet
> unwritten pages.  So exiting on this condition would mean, that
> dirty+writeback could go way over the threshold.

Only if the queue depth is not bound. Queue depths are bound and so
the distance we can go over the threshold is limited.  This is the
fundamental principle on which the throttling is based.....

Hence, if the queue is not full, then we will have either written
dirty pages to it (i.e wbc->nr_write != write_chunk so we will throttle
or continue normally if write_chunk was written) or we have no more
dirty pages left.

Having no dirty pages left on the bdi and it not being congested
means we effectively have a clean, idle bdi. We should not be trying
to throttle writeback here - we can't do anything to improve the
situation by continuing to try to do writeback on this bdi, so we
may as well give up and let the writer continue. Once we have dirty
pages on the bdi, we'll get throttled appropriately.

The point I'm making here is that if the bdi is not congested, any
pages dirtied on that bdi can be cleaned _quickly_ and so writing
more pages to it isn't a big deal even if we are over the global
dirty threshold.

Remember, the global dirty threshold is not really a hard limit -
it's a threshold at which we change behaviour. Throttling idle bdi's
does not contribute usefully to reducing the number of dirty pages
in the system; all it really does is deny service to devices that could
otherwise be doing useful work.

> How much this would be a problem?  I don't know, I guess it depends on
> many things: how many queues, how many requests per queue, how many
> bytes per request.

Right, and most ppl don't have enough devices in their system for
this to be a problem. Even those of us that do have enough devices
for this to potentially be a problem usually have enough RAM in
the machine so that it is not a problem....

> > Or alternatively, adding another bit to the wbc structure to
> > say "there was nothing to do" and setting that if we find
> > list_empty(&sb->s_dirty) when trying to flush dirty inodes."
> > 
> > [ FWIW, this may also solve another problem of fast block devices
> > being throttled incorrectly when a slow block dev is consuming
> > all the dirty pages... ]
> 
> There may be a patch floating around, which I think basically does
> this, but only as long as the dirty+writeback are over a soft limit,
> but under the hard limit.
> 
> When over the the hard limit, balance_dirty_pages still loops until
> dirty+writeback go below the threshold.

The difference between the two methods is that if there is any hard
limit that results in balance_dirty_pages looping then you have a
potential deadlock.  Hence the soft+hard limits will reduce the
occurrence but not remove the deadlock. Breaking out of the loop
when there is nothing to do simply means we'll reenter again
with something to do very shortly (and *then* throttle) if the
process continues to write.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
