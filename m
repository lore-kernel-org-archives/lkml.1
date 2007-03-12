Return-Path: <linux-kernel-owner+w=401wt.eu-S1751544AbXCLWgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbXCLWgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbXCLWgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:36:41 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:44223 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbXCLWgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:36:40 -0400
To: dgc@sgi.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20070312214405.GQ6095633@melbourne.sgi.com> (message from David
	Chinner on Tue, 13 Mar 2007 08:44:05 +1100)
Subject: Re: [patch 3/8] per backing_dev dirty and writeback page accounting
References: <20070306180443.669036741@szeredi.hu> <20070306180550.793803735@szeredi.hu> <20070312062349.GN6095633@melbourne.sgi.com> <E1HQitT-0002wP-00@dorka.pomaz.szeredi.hu> <20070312214405.GQ6095633@melbourne.sgi.com>
Message-Id: <E1HQt7o-00042r-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Mar 2007 23:36:16 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'll try to explain the reason for the deadlock first.

> IIUC, your problem is that there's another bdi that holds all the
> dirty pages, and this throttle loop never flushes pages from that
> other bdi and we sleep instead. It seems to me that the fundamental
> problem is that to clean the pages we need to flush both bdi's, not
> just the bdi we are directly dirtying.

This is what happens:

write fault on upper filesystem
  balance_dirty_pages
    submit write requests
  loop ...
------- fuse IPC ---------------
[fuse loopback fs thread 1]
read request
sys_write
  mutex_lock(i_mutex)
  ...
     balance_dirty_pages
        submit write requests
        loop ... write requests completed ... dirty still over limit ... 
	... loop forever

[fuse loopback fs thread 1]
read request
sys_write
  mute_lock(i_mutex) blocks

So the queue for the upper filesystem is full.  The queue for the
lower filesystem is empty.  There are no dirty pages in the lower
filesystem.

So kicking pdflush for the lower filesystem doesn't help, there's
nothing to do.  balance_dirty_pages() for the lower filesystem should
just realize that there's nothing to do and return, and then there
would be progress.

So there's there's really no need to do any accounting, just some
logic to determine that a backing dev is nearly or completely
quiescent.

And getting out of this tight situation doesn't have to be efficient.
This is probably a very rare corner case, that almost never happens in
real life, only with aggressive test tools like bash_shared_mapping.

> > OK.  How about just accounting writeback pages?  That should be much
> > less of a problem, since normally writeback is started from
> > pdflush/kupdate in large batches without any concurrency.
> 
> Except when you are throttling you bounce the cacheline around
> each cpu as it triggers foreground writeback.....

Yeah, we'd loose a bit of CPU, but not any write performance, since it
is being throttled back anyway.

> > Or is it possible to export the state of the device queue to mm?
> > E.g. could balance_dirty_pages() query the backing dev if there are
> > any outstanding write requests?
> 
> Not directly - writeback_in_progress(bdi) is a coarse measure
> indicating pdflush is active on this bdi, which implies outstanding
> write requests).

Hmm, not quite what I need.

> > > I'd call this a showstopper right now - maybe you need to look at
> > > something like the ZVC code that Christoph Lameter wrote, perhaps?
> > 
> > That's rather a heavyweight approach for this I think.
> 
> But if you want to use per-page accounting, you are going to
> need a per-cpu or per-zone set of counters on each bdi to do
> this without introducing regressions.

Yes, this is an option, but I hope for a simpler solution.

Thanks,
Miklos
