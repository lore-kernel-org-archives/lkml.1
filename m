Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbXD1Fgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbXD1Fgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 01:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbXD1Fgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 01:36:46 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754688AbXD1Fgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 01:36:44 -0400
Date: Fri, 27 Apr 2007 22:36:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [00/17] Large Blocksize Support V3
Message-Id: <20070427223632.52def99e.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704272158360.7342@schroedinger.engr.sgi.com>
References: <20070426195357.597ffd7e.akpm@linux-foundation.org>
	<20070427042046.GI65285596@melbourne.sgi.com>
	<20070426221528.655d79cb.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
	<20070426235542.bad7035a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>
	<20070427002640.22a71d06.akpm@linux-foundation.org>
	<20070427163620.GI32602149@melbourne.sgi.com>
	<20070427173432.GJ32602149@melbourne.sgi.com>
	<20070427121108.9ee05710.akpm@linux-foundation.org>
	<20070428031739.GK32602149@melbourne.sgi.com>
	<20070427215634.325606a9.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704272158360.7342@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 22:08:17 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 27 Apr 2007, Andrew Morton wrote:
> 
> > My (repeated) point is that if we populate pagecache with physically-contiguous 4k
> > pages in this manner then bio+block will be able to create much larger SG lists.
> 
> True but the "if" becomes exceedingly rare the longer the system was in 
> operation. 64k implies 16 pages in sequence. This is going to be a bit 
> difficult to get.

Nonsense.  We need higher-order allocations whichever scheme is used.

And lumpy reclaim in the moveable zone should be extremely reliable.  It
_should_ be the case that it can only be defeated by excessive use of
mlock.  But we've seen no testing to either confirm or refute that.

> Then there is the overhead of handling these pages. 
> Which may be not significant given growing processor capabilities in some 
> usage cases. In others like a synchronized application running on a large 
> number of nodes this is likely introduce random delays between processor 
> to processor communication that will significantly impair performance.

Well, who knows.

> And then there is the long list of features that cannot be accomplished 
> with such an approach like mounting a volume with large block size, 
> handling CD/DVDs, getting rid of various shim layers etc.

There are disadvantages against which this must be traded off.

And if the volume which is mounted with the large page option also has a
lot of small files on it, we've gone and dramatically deoptimised the
user's machine.  It would have been better to make the 4k-page
implementation faster, rather than working around existing inefficiencies.

> I'd also like to have much higher orders of allocations for scientific 
> applications that require an extremely large I/O rate. For those we 
> could f.e. dedicate memory nodes that will only use a very high page 
> order to prevent fragmentation. E.g. 1G pages is certainly something that 
> lots of our customers would find beneficial (and they are actually 
> already using those types of pages in the form of huge pages but with 
> limited capabilities).
> 
> But then we are sadly again trying to find another workaround that 
> will not get us there and will not allow the flexibility in the 
> VM that would make things much easier for lots of usage scenarios.

Your patch *is* a workaround.  It's a workaround for small CPU pagesize. 
It's a workaround for suboptimal VFS anf filesystem implementations.  It's
a workaround for a disk adapter which has suboptimal readahead and
writeback caching implementations.

See?  I can spin too.

Fact is, this change has *costs*.  And you're completely ignoring them,
trying to spin them away.  It ain't working and it never will.  I'm seeing
no serious attempt to think about how we can reduce those costs while
retaining most of the benefits.
