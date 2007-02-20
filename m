Return-Path: <linux-kernel-owner+w=401wt.eu-S1750945AbXBTIsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945AbXBTIsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 03:48:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbXBTIsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 03:48:04 -0500
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:46247 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbXBTIsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 03:48:03 -0500
To: chris.mason@oracle.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-reply-to: <20070220001351.GJ6133@think.oraclecorp.com> (message from Chris
	Mason on Mon, 19 Feb 2007 19:13:51 -0500)
Subject: Re: dirty balancing deadlock
References: <E1HIqlm-0004iZ-00@dorka.pomaz.szeredi.hu> <20070218125307.4103c04a.akpm@linux-foundation.org> <E1HIurG-0005Bw-00@dorka.pomaz.szeredi.hu> <20070218145929.547c21c7.akpm@linux-foundation.org> <E1HIvMB-0005Fd-00@dorka.pomaz.szeredi.hu> <20070218155916.0d3c73a9.akpm@linux-foundation.org> <E1HJC3P-0006tz-00@dorka.pomaz.szeredi.hu> <20070220001351.GJ6133@think.oraclecorp.com>
Message-Id: <E1HJQeV-0008Kq-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 20 Feb 2007 09:47:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > How about this?
> > 
> > Solves the FUSE deadlock, but not the throttle_vm_writeout() one.
> > I'll try to tackle that one as well.
> > 
> > If the per-bdi dirty counter goes below 16, balance_dirty_pages()
> > returns.
> > 
> > Does the constant need to tunable?  If it's too large, then the global
> > threshold is more easily exceeded.  If it's too small, then in a tight
> > situation progress will be slower.
> 
> Ok, what is supposed to happen here is that filesystems are supposed to
> be throttled from making more dirty pages when the system is over the
> threshold.  Even if filesystem A doesn't have much to contribute, and
> filesystem B is the cause of 99% of the dirty pages, the goal of the
> threshold is to prevent more dirty data from happening, and filesystem A
> should block.

Which is the cause of the current deadlock.  But if we allow
filesystem A to go into the red just a little, the deadlock is
avoided, because it can continue to make progress with cleaning the
dirtyness produced by B.

The maximum that filesystems can go over the limit will be

  (16 + epsilon) * number-of-queues

This is usually insignificant compared to the limit itself (~2000
pages on a machine with 32MB)

However with thousands of fuse mounts this may become a problem, as
each filesystem gets a separate queue.  In theory, just 2 pages are
enough to always make progress, but current dirty balancing can't
enforce this, as the ratelimit is at least 8 pages.

So there may have to be some more strict page accounting within fuse
itself, but that doesn't change the overall concept I think.

Miklos
