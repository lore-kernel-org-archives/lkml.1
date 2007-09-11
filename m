Return-Path: <linux-kernel-owner+w=401wt.eu-S965885AbXIKVf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965885AbXIKVf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbXIKVfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:35:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34413 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751399AbXIKVfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:35:10 -0400
Date: Tue, 11 Sep 2007 14:35:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <20070911205350.GA18127@skynet.ie>
Message-ID: <Pine.LNX.4.64.0709111429580.27023@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au>
 <1189524967.32731.58.camel@localhost> <200709111144.48743.nickpiggin@yahoo.com.au>
 <20070911205350.GA18127@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007, Mel Gorman wrote:

> > Well Christoph seems to still be spinning them as a solution for VM
> > scalability and first class support for making contiguous IOs, large
> > filesystem block sizes etc.
> > 
> 
> Yeah, I can't argue with you there. I was under the impression that we
> would be dealing with this strictly as a second class solution to see
> what it bought to help steer the direction of fsblock.

I think we all have the same impression. But should second class not be 
okay for IO and FS in special situations?

> As you say, a difference is if we fail to allocate a hugepage, the world
> does not end. It's been a well known problem for years and grouping pages
> by mobility is aimed at relaxing some of the more painful points. It has
> other uses as well, but each of them is expected to deal with failures with
> contiguous range allocation.

Note that this patchset is only needing higher order pages up to 64k not 
2M.

> > And I would have kept quiet this time too, except for the worrying idea
> > to use higher order pages to fix the SLUB vs SLAB regression, and if
> > the rationale for this patchset was more realistic.
> > 
> 
> I don't agree with using higher order pages to fix SLUB vs SLAB performance
> issues either. SLUB has to be able to compete with SLAB on it's own terms. If
> SLUB gains x% over SLAB in specialised cases with high orders, then fair
> enough but minimally, SLUB has to perform the same as SLAB at order-0. Like
> you, I think if we depend on SLUB using high orders to match SLAB, we are
> going to get kicked further down the line.

That issue is discussed elsewhere and we have a patch in mm to address the 
issue.

> > In theory (and again for the filesystem guys who don't have to worry about
> > it). In practice after seeing the patch it's not a nice thing for the VM to
> > have to do.
> > 
> 
> That may be a good enough reason on it's own to delay this. It's a
> technical provable point.

It would be good to know what is wrong with the patch? I was surprised how 
easy it was to implement mmap.

> I might regret saying this, but it would be easier to craft an attack
> using pagetable pages. It's woefully difficult to do but it's probably
> doable. I say pagetables because while slub targetted reclaim is on the
> cards and memory compaction exists for page cache pages, pagetables are
> currently pinned with no prototype patch existing to deal with them.

Hmmm... I thought Peter had a patch to move page table pages?

> If we hit this problem at all, it'll be due to gradual natural degredation.
> It used to be a case that jumbo ethernets reported problems after running
> for weeks and we might encounter something similar with large blocks while it
> lacks a fallback. We no longer see jumbo ethernet reports but the fact is we
> don't know if it's because we fixed it or people gave up. Chances are people
> will be more persistent with large blocks than they were with jumbo ethernet.

I have seen a failure recently with jumbo frames and order 2 allocs on 
2.6.22. But then .22 has no lumpy reclaim.
