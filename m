Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbXD0Fub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbXD0Fub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXD0Fub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:50:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52998 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755345AbXD0Fty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:49:54 -0400
Date: Thu, 26 Apr 2007 22:49:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <20070426221528.655d79cb.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org>
 <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org>
 <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Andrew Morton wrote:

> > Or make sure that truncate
> > doesn't race on a partial *block* truncate?
> 
> lock four pages

You would only lock a single higher order block. Truncate works on that 
level.

If you have 4 separate pages then you need to take separate locks and you 
may not have contiguous memory which makes the filesystem run through all 
sorts of hoops.

> I'm not saying it's especially simple, nor fast.  But it has the advantage
> that we're not forced to use larger pages with _it's_ attendant performance
> problems.

The patch is not about forcing to use large pages but about the option to 
use larger pages. Its a new flexibility.

> And it doesn't introduce a rather nasty hack of pretending (in some places)
> that pages are larger than they really are.

They are really larger. One page struct controls it all.

> And it has the very significant advantage that it doesn't introduce brand
> new concepts and some complexity into core MM.

The patchset would reduce complexity and making it easy to handle the page 
cache. Gets rid of the hacks to support larger ones right now. Its 
straightforward, no new locking, very much a cleanup patch.

> And make no mistake: the latter disadvantage is huge.  Because if we do the
> PAGE_CACHE_SIZE hack (sorry, but it _is_), we have to do it *for ever*. 
> Maintaining and enhancing core MM and VFS becomes harder and more costly
> and slower and more buggy *for ever*.  The ramp for people to become
> competent on core MM becomes longer.  Our developer pool becomes smaller, and
> proportionally less skilled.

No it becomes easier. Look at the patchset. It cleans up a huge mess.
What is hacky about it? It is consistently using larger pages for the page 
cache and it integrates nicely into the VM.
 
> And hardware gets better.  If Intel & AMD come out with a 16k pagesize
> option in a couple of years we'll look pretty dumb.  If the problems which
> you're presently having with that controller get sorted out in the next
> generation of the hardware, we'll also look pretty dumb.

We are currently looking dumb and unable to deal with the hardware. Yes 
we can pressure the hardware vendors to produce hardware conforming to our 
specifications but I always thought that was how another company operates.

> As always, there are tradeoffs.  We can see the cons, and they are very
> significant.  We don't yet know the pros.  Perhaps they will be similarly
> significant.  But I don't believe that the larger PAGE_CACHE_SIZE hack
> (sorry) is the only way in which they can be realised.

It is the most consistent solution that avoid the proliferation of further 
hacks to address the large blocksize.
