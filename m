Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbZEIVia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbZEIVia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 17:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbZEIViQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 17:38:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52463 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863AbZEIViO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 17:38:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Sat, 9 May 2009 23:37:38 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       Linus Torvalds <torvalds@linux-foundation.org>, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905090155.44635.rjw@sisk.pl> <alpine.DEB.2.00.0905091415310.1124@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0905091415310.1124@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905092337.39906.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 May 2009, David Rientjes wrote:
> On Sat, 9 May 2009, Rafael J. Wysocki wrote:
> 
> > > All of your tasks are in D state other than kthreads, right?  That means 
> > > they won't be in the oom killer (thus no zones are oom locked), so you can 
> > > easily do this
> > > 
> > > 	struct zone *z;
> > > 	for_each_populated_zone(z)
> > > 		zone_set_flag(z, ZONE_OOM_LOCKED);
> > > 
> > > and then
> > > 
> > > 	for_each_populated_zone(z)
> > > 		zone_clear_flag(z, ZONE_OOM_LOCKED);
> > > 
> > > The serialization is done with trylocks so this will never invoke the oom 
> > > killer because all zones in the allocator's zonelist will be oom locked.
> > 
> > Well, that might have been a good idea if it actually had worked. :-(
> > 
> > > Why does this not work for you?
> > 
> > If I set image_size to something below "hard core working set" +
> > totalreserve_pages, preallocate_image_memory() hangs the
> > box (please refer to the last patch I sent,
> > http://patchwork.kernel.org/patch/22423/).
> > 
> 
> This has been changed in the latest mmotm with Mel's page alloactor 
> patches (and I think yours should be based on mmotm).  Specifically, 
> page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch.
> 
> Before his patchset, zonelists that had ZONE_OOM_LOCKED set for at least 
> one of their zones would unconditionally goto restart.  Now, if
> order > PAGE_ALLOC_COSTLY_ORDER, it gives up and returns NULL.  Otherwise, 
> it does goto restart.
> 
> So if your allocation has order > PAGE_ALLOC_COSTLY_ORDER,

It doesn't.  All of my allocations are of order 0.

> using the ZONE_OOM_LOCKED approach to locking out the oom killer will work
> just fine in mmotm.

No, it won't, AFAICT.

Best,
Rafael
