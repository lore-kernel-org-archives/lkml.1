Return-Path: <linux-kernel-owner+w=401wt.eu-S965211AbXCMIW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211AbXCMIW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 04:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965446AbXCMIW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 04:22:27 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:52568 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965211AbXCMIWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 04:22:25 -0400
To: dgc@sgi.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20070312231256.GT6095633@melbourne.sgi.com> (message from David
	Chinner on Tue, 13 Mar 2007 10:12:56 +1100)
Subject: Re: [patch 3/8] per backing_dev dirty and writeback page accounting
References: <20070306180443.669036741@szeredi.hu> <20070306180550.793803735@szeredi.hu> <20070312062349.GN6095633@melbourne.sgi.com> <E1HQitT-0002wP-00@dorka.pomaz.szeredi.hu> <20070312214405.GQ6095633@melbourne.sgi.com> <E1HQt7o-00042r-00@dorka.pomaz.szeredi.hu> <20070312231256.GT6095633@melbourne.sgi.com>
Message-Id: <E1HR2Gd-0004oR-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 13 Mar 2007 09:21:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > IIUC, your problem is that there's another bdi that holds all the
> > > dirty pages, and this throttle loop never flushes pages from that
> > > other bdi and we sleep instead. It seems to me that the fundamental
> > > problem is that to clean the pages we need to flush both bdi's, not
> > > just the bdi we are directly dirtying.
> > 
> > This is what happens:
> > 
> > write fault on upper filesystem
> >   balance_dirty_pages
> >     submit write requests
> >   loop ...
> 
> Isn't this loop transferring the dirty state from the upper
> filesystem to the lower filesystem?

What this loop is doing is putting write requests in the request
queue, and in so doing transforming page state from dirty to
writeback.

> What I don't see here is how the pages on this filesystem are not
> getting cleaned if the lower filesystem is being flushed properly.

Because the lower filesystem writes back one request, but then gets
stuck in balance_dirty_pages before returning.  So the write request
is never completed.

The problem is that balance_dirty_pages is waiting for the condition
that the global number of dirty+writeback pages goes below the
threshold.  But this condition can only be satisfied if
balance_dirty_pages() returns.

> I'm probably missing something big and obvious, but I'm not
> familiar with the exact workings of FUSE so please excuse my
> ignorance....
> 
> > ------- fuse IPC ---------------
> > [fuse loopback fs thread 1]
> 
> This is the lower filesystem? Or a callback thread for
> doing the write requests to the lower filesystem?

This is the fuse daemon.  It's a normal process that reads requests
from /dev/fuse, serves these requests then writes the reply back onto
/dev/fuse.  It is usually multithreaded, so it can serve many requests
in parallel.

The loopback filesystem serves the requests by issuing the relevant
filesystem syscalls on the underlying fs.

> > read request
> > sys_write
> >   mutex_lock(i_mutex)
> >   ...
> >      balance_dirty_pages
> >         submit write requests
> >         loop ... write requests completed ... dirty still over limit ... 
> > 	... loop forever
> 
> Hmmm - the situation in balance_dirty_pages() after an attempt
> to writeback_inodes(&wbc) that has written nothing because there
> is nothing to write would be:
> 
> 	wbc->nr_write == write_chunk &&
> 	wbc->pages_skipped == 0 &&
> 	wbc->encountered_congestion == 0 &&
> 	!bdi_congested(wbc->bdi)
> 
> What happens if you make that an exit condition to the loop?

That's almost right.  The only problem is that even if there's no
congestion, the device queue can be holding a great amount of yet
unwritten pages.  So exiting on this condition would mean, that
dirty+writeback could go way over the threshold.

How much this would be a problem?  I don't know, I guess it depends on
many things: how many queues, how many requests per queue, how many
bytes per request.

> Or alternatively, adding another bit to the wbc structure to
> say "there was nothing to do" and setting that if we find
> list_empty(&sb->s_dirty) when trying to flush dirty inodes."
> 
> [ FWIW, this may also solve another problem of fast block devices
> being throttled incorrectly when a slow block dev is consuming
> all the dirty pages... ]

There may be a patch floating around, which I think basically does
this, but only as long as the dirty+writeback are over a soft limit,
but under the hard limit.

When over the the hard limit, balance_dirty_pages still loops until
dirty+writeback go below the threshold.

Thanks,
Miklos
