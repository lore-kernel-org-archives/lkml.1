Return-Path: <linux-kernel-owner+w=401wt.eu-S1752183AbXIQEIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbXIQEIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 00:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbXIQEH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 00:07:56 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43091 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750995AbXIQEHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 00:07:55 -0400
Date: Mon, 17 Sep 2007 14:07:10 +1000
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Chinner <dgc@sgi.com>, Mel Gorman <mel@skynet.ie>,
       Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070917040710.GA23367404@sgi.com>
References: <20070911060349.993975297@sgi.com> <20070913130342.GT734179@sgi.com> <200709131201.46720.nickpiggin@yahoo.com.au> <200709140648.56184.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709140648.56184.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 06:48:55AM +1000, Nick Piggin wrote:
> On Thursday 13 September 2007 12:01, Nick Piggin wrote:
> > On Thursday 13 September 2007 23:03, David Chinner wrote:
> > > Then just do operations on directories with lots of files in them
> > > (tens of thousands). Every directory operation will require at
> > > least one vmap in this situation - e.g. a traversal will result in
> > > lots and lots of blocks being read that will require vmap() for every
> > > directory block read from disk and an unmap almost immediately
> > > afterwards when the reference is dropped....
> >
> > Ah, wow, thanks: I can reproduce it.
> 
> OK, the vunmap batching code wipes your TLB flushing and IPIs off
> the table. Diffstat below, but the TLB portions are here (besides that
> _everything_ is probably lower due to less TLB misses caused by the
> TLB flushing):
> 
>       -170   -99.4% sn2_send_IPI
>       -343  -100.0% sn_send_IPI_phys
>     -17911   -99.9% smp_call_function
>
> Total performance went up by 30% on a 64-way system (248 seconds to
> 172 seconds to run parallel finds over different huge directories).

Good start, Nick ;)

> 
>      23012  54790.5% _read_lock
>       9427   329.0% __get_vm_area_node
>       5792     0.0% __find_vm_area
>       1590  53000.0% __vunmap
....

_read_lock? I though vmap() and vunmap() only took the vmlist_lock in
write mode.....

> Next I have some patches to scale the vmap locks and data
> structures better, but they're not quite ready yet. This looks like it
> should result in a further speedup of several times when combined
> with the TLB flushing reductions here...

Sounds promising - when you have patches that work, send them my
way and I'll run some tests on them.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
