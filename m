Return-Path: <linux-kernel-owner+w=401wt.eu-S932603AbXILBuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbXILBuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 21:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbXILBt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 21:49:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49554 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753099AbXILBt5 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 21:49:57 -0400
Date: Wed, 12 Sep 2007 11:49:17 +1000
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@skynet.ie>, Christoph Lameter <clameter@sgi.com>,
       andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070912014917.GJ995458@sgi.com>
References: <20070911060349.993975297@sgi.com> <200709111144.48743.nickpiggin@yahoo.com.au> <20070911205350.GA18127@skynet.ie> <200709111600.18756.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709111600.18756.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 04:00:17PM +1000, Nick Piggin wrote:
> > > OTOH, I'm not sure how much buy-in there was from the filesystems guys.
> > > Particularly Christoph H and XFS (which is strange because they already
> > > do vmapping in places).
> >
> > I think they use vmapping because they have to, not because they want
> > to. They might be a lot happier with fsblock if it used contiguous pages
> > for large blocks whenever possible - I don't know for sure. The metadata
> > accessors they might be unhappy with because it's inconvenient but as
> > Christoph Hellwig pointed out at VM/FS, the filesystems who really care
> > will convert.
> 
> Sure, they would rather not to. But there are also a lot of ways you can
> improve vmap more than what XFS does (or probably what darwin does)
> (more persistence for cached objects, and batched invalidates for example).

XFS already has persistence across the object life time (which can be many
tens of seconds for a frequently used buffer) and it also does batched
unmapping of objects as well.

> There are also a lot of trivial things you can do to make a lot of those
> accesses not require vmaps (and less trivial things, but even such things
> as binary searches over multiple pages should be quite possible with a bit
> of logic).

Yes, we already do the many of these things (via xfs_buf_offset()), but
that is not good enough for something like a memcpy that spans multiple
pages in a large block (think btree block compaction, splits and recombines).

IOWs, we already play these vmap harm-minimisation games in the places
where we can, but still the overhead is high and something we'd prefer
to be able to avoid.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
