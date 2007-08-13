Return-Path: <linux-kernel-owner+w=401wt.eu-S934707AbXHMV4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934707AbXHMV4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbXHMV4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:56:13 -0400
Received: from ns1.suse.de ([195.135.220.2]:44253 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbXHMV4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:56:12 -0400
Date: Tue, 14 Aug 2007 00:50:20 +0200
From: Andi Kleen <ak@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>, Mel Gorman <mel@skynet.ie>,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones pointer
Message-ID: <20070813225020.GE3406@bingen.suse.de>
References: <20070809210616.14702.73376.sendpatchset@skynet.skynet.ie> <200708102013.49170.ak@suse.de> <Pine.LNX.4.64.0708101201240.17549@schroedinger.engr.sgi.com> <200708110304.55433.ak@suse.de> <Pine.LNX.4.64.0708131423050.28026@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708131423050.28026@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 02:25:36PM -0700, Christoph Lameter wrote:
> On Sat, 11 Aug 2007, Andi Kleen wrote:
> 
> > > Hallelujah. You are my hero! x86_64 will switch off CONFIG_ZONE_DMA?
> > 
> > Yes. i386 too actually.
> > 
> > The DMA zone will be still there, but only reachable with special functions.
> 
> Not too happy with that one but this is going the right direcrtion.
> 
> On NUMA this would still mean allocating space for the DMA zone on all 
> nodes although we only need this on node 0.

The DMA allocator is NUMA unaware. This means it doesn't require multiple
dma zones per node, but is happy with a global one that can live somewhere
else outside the pgdat. I also removed PCP and other fanciness so it's
really quite independent and much simpler than the normal one.  It also
doesn't need try_to_free_pages() because in a isolated zone there
shouldn't be any freeable pages.

The big difference is that it can go into a slower than O(1) mode that tries
to find pages based on the DMA mask

> > This also means the DMA support in sl[a-z]b is not needed anymore.
> 
> Tell me when. SLUB has an #ifdef CONFIG_ZONE_DMA. We can just drop that 
> code in the #ifdef's if you are ready.

There are still other architectures that use it. Biggest offender
is s390. I'll leave them to their respective maintainers.

It's not clear s390 really needs the mask allocator anyways.
e.g. I suspect they just need to put data into a specific 
range, but if there are no subranges then it might be
overkill.

-Andi

