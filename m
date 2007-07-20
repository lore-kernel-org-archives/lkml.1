Return-Path: <linux-kernel-owner+w=401wt.eu-S1764233AbXGTOBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764233AbXGTOBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 10:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbXGTOBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 10:01:04 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:49125 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbXGTOBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 10:01:01 -0400
Date: Fri, 20 Jul 2007 15:00:59 +0100
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Mundt <lethal@linux-sh.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix memory hotplug oops from ZONE_MOVABLE changes.
Message-ID: <20070720140058.GA3079@skynet.ie>
References: <20070720060342.GA24765@linux-sh.org> <20070720112025.GA14495@skynet.ie> <20070720114246.GA27391@linux-sh.org> <20070720223909.d4c1e848.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070720223909.d4c1e848.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (20/07/07 22:39), KAMEZAWA Hiroyuki didst pronounce:
> On Fri, 20 Jul 2007 20:42:46 +0900
> Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > > I expect that the memory gets added to the same zone as historically but
> > > when ZONE_MOVABLE is set, you'll see a situation where zones are overlapping
> > > after memory hot-add.  i.e. Before memory hot-add, you'd see
> > > 
> > > DDDDMM
> > > 
> > > for ZONE_DMA and ZONE_MOVABLE and after hotadd, you'd see something like
> > > 
> > > DDDDMMDDDD
> > > 
> 
> As similar case, I hear powerpc has followig memory layout
> 
> (1)(1)(0)(0)(0)(1)(1)(1)  # (0) is node 0, (1) is node 1. all zones are ZONE_DMA.
> 

Not always, but it happens. We used to have two test machines available
that exhibited this behaviour although they went missing at some point
which is unfortunate.

> So zone is overlapped without memory hotplug.

Zones overlapping have some subtle differences to nodes but the place this is
really noticeable is during memory init when a range of PFNs are initialised
by memmap_init_zone(). If zones overlap there, they can initialise the
struct page fields twice but that is not an issue with memory hot-add. The
potential issue I am thinking of is users that manually walk the memmap but
no functionality outside of debugging should be doing anything like that.

> But I agree we have to take care of this kind of corner cases.
> 

Indeed. I think we're ok, but it should be checked out anyway.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
