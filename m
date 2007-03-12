Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbXCLXNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbXCLXNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbXCLXNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:13:13 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49726 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752210AbXCLXNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:13:11 -0400
Date: Tue, 13 Mar 2007 10:12:56 +1100
From: David Chinner <dgc@sgi.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dgc@sgi.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 3/8] per backing_dev dirty and writeback page accounting
Message-ID: <20070312231256.GT6095633@melbourne.sgi.com>
References: <20070306180443.669036741@szeredi.hu> <20070306180550.793803735@szeredi.hu> <20070312062349.GN6095633@melbourne.sgi.com> <E1HQitT-0002wP-00@dorka.pomaz.szeredi.hu> <20070312214405.GQ6095633@melbourne.sgi.com> <E1HQt7o-00042r-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HQt7o-00042r-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 11:36:16PM +0100, Miklos Szeredi wrote:
> I'll try to explain the reason for the deadlock first.

Ah, thanks for that.

> > IIUC, your problem is that there's another bdi that holds all the
> > dirty pages, and this throttle loop never flushes pages from that
> > other bdi and we sleep instead. It seems to me that the fundamental
> > problem is that to clean the pages we need to flush both bdi's, not
> > just the bdi we are directly dirtying.
> 
> This is what happens:
> 
> write fault on upper filesystem
>   balance_dirty_pages
>     submit write requests
>   loop ...

Isn't this loop transferring the dirty state from the upper
filesystem to the lower filesystem? What I don't see here is
how the pages on this filesystem are not getting cleaned if
the lower filesystem is being flushed properly.

I'm probably missing something big and obvious, but I'm not
familiar with the exact workings of FUSE so please excuse my
ignorance....

> ------- fuse IPC ---------------
> [fuse loopback fs thread 1]

This is the lower filesystem? Or a callback thread for
doing the write requests to the lower filesystem?

> read request
> sys_write
>   mutex_lock(i_mutex)
>   ...
>      balance_dirty_pages
>         submit write requests
>         loop ... write requests completed ... dirty still over limit ... 
> 	... loop forever

Hmmm - the situation in balance_dirty_pages() after an attempt
to writeback_inodes(&wbc) that has written nothing because there
is nothing to write would be:

	wbc->nr_write == write_chunk &&
	wbc->pages_skipped == 0 &&
	wbc->encountered_congestion == 0 &&
	!bdi_congested(wbc->bdi)

What happens if you make that an exit condition to the loop?
Or alternatively, adding another bit to the wbc structure to
say "there was nothing to do" and setting that if we find
list_empty(&sb->s_dirty) when trying to flush dirty inodes."

[ FWIW, this may also solve another problem of fast block devices
being throttled incorrectly when a slow block dev is consuming
all the dirty pages... ]

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
