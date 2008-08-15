Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbYHOKGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbYHOKGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 06:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYHOKF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 06:05:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47767 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbYHOKF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 06:05:56 -0400
Date: Fri, 15 Aug 2008 11:05:53 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, pj@sgi.com
Subject: Re: [regression?] [resend] Memory zone info seems incomplete in boottime dmesg output
Message-ID: <20080815100552.GA27547@csn.ul.ie>
References: <200808142042.24606.elendil@planet.nl> <20080814121349.b77e0116.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080814121349.b77e0116.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (14/08/08 12:13), Andrew Morton didst pronounce:
> On Thu, 14 Aug 2008 20:42:23 +0200
> Frans Pop <elendil@planet.nl> wrote:
> 
> > With 2.6.26 I get:
> > <snip>
> > Zone PFN ranges:
> >   DMA             0 ->     4096
> >   DMA32        4096 ->  1048576
> >   Normal    1048576 ->  1048576
> > Movable zone start PFN for each node
> > early_node_map[4] active PFN ranges
> >     0:        0 ->      159
> >     0:      256 ->   521844
> >     0:   521961 ->   521964
> >     0:   521983 ->   521984
> > On node 0 totalpages: 521751
> >   DMA zone: 56 pages used for memmap
> >   DMA zone: 1271 pages reserved
> >   DMA zone: 2672 pages, LIFO batch:0
> >   DMA32 zone: 7081 pages used for memmap
> >   DMA32 zone: 510671 pages, LIFO batch:31
> >   Normal zone: 0 pages used for memmap
> >   Movable zone: 0 pages used for memmap
> > </snip>
> > 
> > With 2.6.27-rc1 I only get pages listed for 2 zones (bottom part):
> > <snip>
> > Zone PFN ranges:
> >   DMA      0x00000000 -> 0x00001000
> >   DMA32    0x00001000 -> 0x00100000
> >   Normal   0x00100000 -> 0x00100000
> > Movable zone start PFN for each node
> 
> I'd have expected something to be printed here?
> 
> > early_node_map[4] active PFN ranges
> >     0: 0x00000000 -> 0x0000009f
> >     0: 0x00000100 -> 0x0007f674
> >     0: 0x0007f6e9 -> 0x0007f6ec
> >     0: 0x0007f6ff -> 0x0007f700
> > On node 0 totalpages: 521751
> >   DMA zone: 2072 pages, LIFO batch:0
> >   DMA32 zone: 506625 pages, LIFO batch:31
> > </snip>
> 
> It could be deliberate, I forget.  Maybe we trimmed nr_nodemap_entries
> to not include empty zones.  Hopefully Mel will recall.
> 

Assuming you mean the "used for memmap" message, it is being surpressed
by the mminit debugging framework which converted a number of printks to
mminit_dprintk. The expectation was that they were not generally useful
messages except when debugging memory init problems. They would show up
again if mminit_loglevel=4 was specified on the kernel command line.

> > Note that totalpages is the same and that for 2.6.26 the sum of pages for 
> > all listed zones is equal to totalpages. Seems we've lost useful info 
> > here.
> > 
> > I also seem to have "lost" 600 LIFO batch pages for DMA and 4000 for DMA32 
> > between the kernel versions although that could be due to config changes 
> > (I enabled some extra debugging options). Harder to tell though without 
> > the info where they've gone...
> 
> I can't see that from the above information?
> 

The decrease in pages could be accounted for by either a larger memmap
(unlikely unless the size of struct page has changed) or a larger reserve
needed for the kernel image which is possible if more debugging options are
enabled. Setting mminit_loglevel=4 should show up the values.

> > Cheers,
> > FJP
> > 
> > P.S. As a user I really don't find the hex values easier to read/use than 
> > the decimal values. Except maybe for the "Zone PFN ranges" where things 
> > seem to be nicely aligned.
> 

That change was from Paul Jackson (commit
5dab8ec139be215fbaba216fb4aea914d0f4dac5) who appeared to be trying to
make boot messages more consistent. He's cc'd for comment.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
