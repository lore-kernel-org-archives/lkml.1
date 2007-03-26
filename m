Return-Path: <linux-kernel-owner+w=401wt.eu-S1750714AbXCZJBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750714AbXCZJBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbXCZJBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:01:32 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50010 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbXCZJBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:01:30 -0400
Date: Mon, 26 Mar 2007 01:01:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] fix illogical behavior in balance_dirty_pages()
Message-Id: <20070326010124.b4513ce2.akpm@linux-foundation.org>
In-Reply-To: <E1HVkWw-0000yj-00@dorka.pomaz.szeredi.hu>
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu>
	<20070325153508.10922ebd.akpm@linux-foundation.org>
	<E1HVkWw-0000yj-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 10:26:18 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> > > This is a slightly different take on the fix for the deadlock in fuse
> > > with dirty balancing.  David Chinner convinced me, that per-bdi
> > > counters are too expensive, and that it's not worth trying to account
> > > the number of pages under writeback, as they will be limited by the
> > > queue anyway.
> > > 
> > > ----
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > 
> > > Current behavior of balance_dirty_pages() is to try to start writeout
> > > into the specified queue for at least "write_chunk" number of pages.
> > > If "write_chunk" pages have been submitted, then return.
> > > 
> > > However if there are less than "write_chunk" dirty pages for this
> > > queue, then it doesn't return, waiting for the global dirty+writeback
> > > counters to subside, but without doing any actual work.
> > > 
> > > This is illogical behavior: it allows more dirtyings while there are
> > > dirty pages, but stops further dirtying completely if there are no
> > > more dirty pages.
> > 
> > That behaviour is perfectly logical.  It prevents the number of
> > dirty+writeback pages from exceeding dirty_ratio.
> 
> But it does it in an illogical way.  While it's cleaning your pages,
> it allows more dirtyings, but when it has cleaned ALL the pages
> destined for this queue, you hit a wall and stand still waiting for
> other queues to get their act together even if this queue is
> _completely idle_.

Memory is a machine-wide resource, not a per-queue resource.

If we have hit the dirty+writeback limit, it is logical to throttle
dirtiers until the levels subside.

> I think this accounts for 90% of the problems experienced with copying
> to slow devices.

It is related, but this observation doesn't actually strengthen your
argument.  If memory is full of dirty-or-writeback pages against a USB
drive, we don't want to go letting writers to other devices go and dirty
even more memory.  We instead need to clamp down harder on the writer to
the USB drive.

> > > It also makes a deadlock possible when one filesystem is writing data
> > > through another, and the balance_dirty_pages() for the lower
> > > filesystem is stalling the writeback for the upper filesystem's
> > > data (*).
> > 
> > I still don't understand this one.  I got lost when belatedly told that
> > i_mutex had something to do with it.
> 
> This deadlock only happens, if there's some bottleneck for writing
> data to the lower filesystem.   This bottleneck could be 
> 
>   - i_mutex, preventing parallel writes to the same inode
>   - limited number of filesystem threads
>   - limited request queue length in the upper filesystem
> 
> Imagine it this way: balance_dirty_pages() for the lower filesystem is
> stalling a write() because dirty pages in the upper filesystem are
> over the limit.  Because there's a bottleneck for writing to the lower
> filesystem, this is stalling _other_ writes from completing.  So
> there's no progress in writing back pages from the upper filesystem.

You mean that someone is stuck in balance_dirty_pages() against the lower
fs while holding locks which prevent writes into the upper fs from
succeeding?

Draw us a picture ;)

> The problem is not that dirty pages are not being submitted for
> writeback, rather that the writeback itself is stalling.
> 
> Hmm?
> 
> > > Index: linux/mm/page-writeback.c
> > > ===================================================================
> > > --- linux.orig/mm/page-writeback.c	2007-03-24 22:06:56.000000000 +0100
> > > +++ linux/mm/page-writeback.c	2007-03-24 22:29:02.000000000 +0100
> > > @@ -207,7 +207,15 @@ static void balance_dirty_pages(struct a
> > >  		 * written to the server's write cache, but has not yet
> > >  		 * been flushed to permanent storage.
> > >  		 */
> > > -		if (nr_reclaimable) {
> > > +		if (!nr_reclaimable) {
> > > +			/*
> > > +			 * If there's nothing more to write back and this queue
> > > +			 * is uncongested,  then it is possible to quickly
> > > +			 * write out some more data, so let's not wait
> > > +			 */
> > > +			if (!bdi_write_congested(bdi))
> > > +				break;
> > > +		} else {
> > 
> > This says "if there are no dirty pages in the machine at all, then go back
> > and dirty some more pages, regardless of the present number of
> > under-writeback pages".
> 
> No, this says, that "there are no dirty pages in the machine at all,
> and this queue is uncongested, so you can safely go back and dirty
> some more data, because we are sure it can be written back quickly".

The queue congestion thing is meaningless, and I ignored it.

> Ditto for the case, when there are no more dirty pages destined for
> this queue.
> 
> I understand, that this can fill up the memory with under writeback
> pages, but only if the data sitting in all the device queues is
> comparable to the total memory.  I don't know what the realistic
> chance of that is but David Chinner convinced me, that it's not
> something that happens in real life.  Quoting him from an earlier
> mail:
> 
> | Right, and most ppl don't have enough devices in their system for
> | this to be a problem. Even those of us that do have enough devices
> | for this to potentially be a problem usually have enough RAM in
> | the machine so that it is not a problem....
> 

David is overoptimistic ;)

Two scsi disks on a 256MB machine will put us over the edge, and that's
even before the user has gone and fiddled with the knobs.

Then there's NFS which for a long time had basically unbounded queue
lengths.  That's allegedly been fixed, but I haven't seen testing results
which convince me of that.

Then there's CIFS, SMBFS, v9fs, DM, MD, whatever.  Plenty of things in
there which can screw things up.

<ponders scsi_tgt_alloc_queue()>

