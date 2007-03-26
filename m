Return-Path: <linux-kernel-owner+w=401wt.eu-S1750913AbXCZJdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750913AbXCZJdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbXCZJdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:33:44 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:40791 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbXCZJdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:33:42 -0400
To: akpm@linux-foundation.org
CC: dgc@sgi.com, linux-kernel@vger.kernel.org
In-reply-to: <20070326010124.b4513ce2.akpm@linux-foundation.org> (message from
	Andrew Morton on Mon, 26 Mar 2007 01:01:24 -0800)
Subject: Re: [patch 1/3] fix illogical behavior in balance_dirty_pages()
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu>
	<20070325153508.10922ebd.akpm@linux-foundation.org>
	<E1HVkWw-0000yj-00@dorka.pomaz.szeredi.hu> <20070326010124.b4513ce2.akpm@linux-foundation.org>
Message-Id: <E1HVlZH-00018f-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 26 Mar 2007 11:32:47 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > This is a slightly different take on the fix for the deadlock in fuse
> > > > with dirty balancing.  David Chinner convinced me, that per-bdi
> > > > counters are too expensive, and that it's not worth trying to account
> > > > the number of pages under writeback, as they will be limited by the
> > > > queue anyway.
> > > > 
> > > > ----
> > > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > > 
> > > > Current behavior of balance_dirty_pages() is to try to start writeout
> > > > into the specified queue for at least "write_chunk" number of pages.
> > > > If "write_chunk" pages have been submitted, then return.
> > > > 
> > > > However if there are less than "write_chunk" dirty pages for this
> > > > queue, then it doesn't return, waiting for the global dirty+writeback
> > > > counters to subside, but without doing any actual work.
> > > > 
> > > > This is illogical behavior: it allows more dirtyings while there are
> > > > dirty pages, but stops further dirtying completely if there are no
> > > > more dirty pages.
> > > 
> > > That behaviour is perfectly logical.  It prevents the number of
> > > dirty+writeback pages from exceeding dirty_ratio.
> > 
> > But it does it in an illogical way.  While it's cleaning your pages,
> > it allows more dirtyings, but when it has cleaned ALL the pages
> > destined for this queue, you hit a wall and stand still waiting for
> > other queues to get their act together even if this queue is
> > _completely idle_.
> 
> Memory is a machine-wide resource, not a per-queue resource.
> 
> If we have hit the dirty+writeback limit, it is logical to throttle
> dirtiers until the levels subside.

It is logical to throttle, but it's not logical to stall.

> > I think this accounts for 90% of the problems experienced with copying
> > to slow devices.
> 
> It is related, but this observation doesn't actually strengthen your
> argument.  If memory is full of dirty-or-writeback pages against a USB
> drive, we don't want to go letting writers to other devices go and dirty
> even more memory.  We instead need to clamp down harder on the writer to
> the USB drive.

Yes, if you can notice that the USB drive is really slow, _before_ the
writer fills all the allotted memory, then that's good.  I don't know
how well Peter's patch does that, but I'll have a look.

But even if you don't want to bother with limiting per-bdi dirty
numbers based on device speed, it is more logical to allow unrelated
queues to function at a steady state, than to stop them completely.

Stopping writers which have idle queues is completely unproductive,
and that is basically what the current algorithm does.

Miklos
