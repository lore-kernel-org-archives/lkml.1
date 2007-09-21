Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbXIUJfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbXIUJfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXIUJfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:35:37 -0400
Received: from brick.kernel.dk ([87.55.233.238]:19377 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbXIUJfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:35:36 -0400
Date: Fri, 21 Sep 2007 11:36:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What's in linux-2.6-block.git for 2.6.24
Message-ID: <20070921093624.GI2367@kernel.dk>
References: <20070921085711.GG2367@kernel.dk> <20070921021505.99c37589.akpm@linux-foundation.org> <20070921092423.GH2367@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921092423.GH2367@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21 2007, Jens Axboe wrote:
> On Fri, Sep 21 2007, Andrew Morton wrote:
> > > SG chaining bits:
> > > - This is the bulk of the patchset. It consists of three major
> > >   components:
> > > 
> > >         - sglist-core, which add helpers for iterating sg lists and
> > >           switches the block layer and SCSI to use those. Should not
> > >           have any functional changes.
> > >         - sglist-drivers, which converts drivers to use the sg list
> > >           helpers. Again, should not contain functional changes.
> > >         - sglist-arch, which adds support to most architectures and
> > >           actually enables sg chaining.
> > > 
> > > The goal of sg chaining is to allow support for very large sgtables,
> > > without requiring that they be allocated from one contigious piece of
> > > memory.
> > 
> > Presumably sg chaining means more overhead on the IO submission paths?  If
> > so, has this been quantified?
> 
> Depends on how you look at it. For sizes that are small enough to not
> use sg chaining (like we do now), there are no changes. Just cleanups to
> drivers to use sg_next() and for_each_sg() and so on. Well there is one
> snag and that is sg_last(), since that needs to iterate the list. But
> that should not be used in performance critical sections. And we can get
> rid of that completely as well should we want to, if we define a
> per-arch chain limit so that sg_last() can just index the last segment
> even if ARCH_HAS_SG_CHAIN is set but nents <= ARCH_SG_CHAIN_SIZE (or
> whatever that define would be).
> 
> For actually using the sg chaining, there's some overhead of course. Say
> we support 256 entries without chaining, or 1mb with 4kb pages. A
> request with 1000 entried would require 4 trips to the allocator to
> allocate the chainable lists and 4 trips when freeing that list again.
> We don't loop the sg list on setup of freeing, just jump to the correct
> locations.
> 
> So even for chaining, the cost isn't that big. It enables us to support
> much larger IO commands and potentially speed up some devices quite a
> lot, so CPU cost is less of a concern. And for small sglists, there
> isn't a noticable overhead.

Forgot one more thing... For embedded systems where RAM is precious, sg
chaining also allows us to optimize for that by trading a little CPU to
free up some memory. SCSI currently has slabs and mempools for 8, 16,
32, 64, and 128 entry scatterlists. With chaining we can get away with
supporting just one sg table size, since we can just chain to reach the
desired size. Some care needs to be taken on the mempool side, but it's
doable.

-- 
Jens Axboe

