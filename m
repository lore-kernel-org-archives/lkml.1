Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbXI1VO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbXI1VO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbXI1VOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:14:48 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41153 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbXI1VOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:14:46 -0400
Date: Fri, 28 Sep 2007 22:14:44 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
Message-ID: <20070928211444.GC30404@skynet.ie>
References: <20070919033605.785839297@sgi.com> <20070919033643.763818012@sgi.com> <200709280742.38262.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com> <1191002119.18147.80.camel@lappy> <Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com> <1191003950.18147.85.camel@lappy> <Pine.LNX.4.64.0709281133570.5397@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709281133570.5397@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (28/09/07 11:41), Christoph Lameter didst pronounce:
> On Fri, 28 Sep 2007, Peter Zijlstra wrote:
> 
> > memory got massively fragemented, as anti-frag gets easily defeated.
> > setting min_free_kbytes to 12M does seem to solve it - it forces 2 max
> > order blocks to stay available, so we don't mix types. however 12M on
> > 128M is rather a lot.
> 
> Yes, strict ordering would be much better. On NUMA it may be possible to 
> completely forbid merging.

The forbidding of merging is trivial and the code is isolated to one function
__rmqueue_fallback(). We don't do it because the decision at development
time was that it was better to allow fragmentation than take a reclaim step
for example[1] and slow things up. This is based on my initial assumption
of anti-frag being mainly of interest to hugepages which are happy to wait
long periods during startup or fail.

> We can fall back to other nodes if necessary. 
> 12M is not much on a NUMA system.
> 
> But this shows that (unsurprisingly) we may have issues on systems with a 
> small amounts of memory and we may not want to use higher orders on such 
> systems.
> 

This is another option if you want to use a higher order for SLUB by
default. Use order-0 unless you are sure there is enough memory. At boot
if there is loads of memory, set the higher order and up min_free_kbytes on
each node to reduce mixing[2]. We can test with Peters uber-hostile
case to see if it works[3].

> The case you got may be good to use as a testcase for the virtual 
> fallback. Hmmmm...

For sure.

> Maybe it is possible to allocate the stack as a virtual 
> compound page. Got some script/code to produce that problem?
> 

[1] It might be tunnel vision but I still keep hugepages in mind as the
    principal user of anti-frag. Andy used to have patches that force evicted
    pages of the "foreign" type when mixing occured so the end result was
    no mixing. We never fully completed them because it was too costly
    for hugepages.

[2] This would require the identification of mixed blocks to be a
    statistic available in mainline. Right now, it's only available in -mm
    when PAGE_OWNER is set

[3] The definition of working in this case being that order-0
    allocations fail which he has produced

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
