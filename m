Return-Path: <linux-kernel-owner+w=401wt.eu-S1161137AbXAZT6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161137AbXAZT6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161251AbXAZT6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:58:31 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:37325 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161137AbXAZT6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:58:30 -0500
Date: Fri, 26 Jan 2007 11:58:18 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@osdl.org>
cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [PATCH 0/8] Create ZONE_MOVABLE to partition memory between
 movable and non-movable pages
In-Reply-To: <20070126114615.5aa9e213.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0701261147300.15394@schroedinger.engr.sgi.com>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070126030753.03529e7a.akpm@osdl.org> <Pine.LNX.4.64.0701260751230.6141@schroedinger.engr.sgi.com>
 <20070126114615.5aa9e213.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Andrew Morton wrote:

> As Mel points out, distros will ship with CONFIG_ZONE_DMA=y, so the number
> of machines which will actually benefit from this change is really small. 
> And the benefit to those few machines will also, I suspect, be small.
> 
> > > - We kicked around some quite different ways of implementing the same
> > >   things, but nothing came of it.  iirc, one was to remove the hard-coded
> > >   zones altogether and rework all the MM to operate in terms of
> > > 
> > > 	for (idx = 0; idx < NUMBER_OF_ZONES; idx++)
> > > 		...
> > 
> > Hmmm.. How would that be simpler?
> 
> Replace a sprinkle of open-coded ifdefs with a regular code sequence which
> everyone uses.  Pretty obvious, I'd thought.

We do use such loops in many places. However, stuff like array 
initialization and special casing cannot use a loop. I am not sure what we 
could change there. The hard coding is necessary because each zone 
currently has these invariant characteristics that we need to consider. 
Reducing the number of zones reduces the amount of special casing in the 
VM that needs to be considered at run time and that is a potential issue
for trouble.

> Plus it becoems straightforward to extend this from the present four zones
> to a complete 12 zones, which gives use the full set of
> ZONE_DMA20,ZONE_DMA21,...,ZONE_DMA32 for those funny devices.

I just hope we can handle the VM complexity of load balancing etc etc that 
this will introduce. Also each zone has management overhead and will cause 
the touching of additional cachelines on many VM operations. Much of that 
management overhead becomes unnecessary if we reduce zones.

> If the only demonstrable benefit is a saving of a few k of text on a small
> number of machines then things are looking very grim, IMO.

The main benefit is a significant simplification of the VM, leading to 
robust and reliable operations and a reduction of the maintenance 
headaches coming with the additional zones.

If we would introduce the ability of allocating from a range of 
physical addresses then the need for DMA zones would go away allowing 
flexibility for device driver DMA allocations and at the same time we get 
rid of special casing in the VM.
