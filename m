Return-Path: <linux-kernel-owner+w=401wt.eu-S1161601AbXD1IGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161601AbXD1IGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 04:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161595AbXD1IGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 04:06:49 -0400
Received: from amsfep17-int.chello.nl ([62.179.120.12]:19283 "EHLO
	amsfep17-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965536AbXD1IEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 04:04:11 -0400
Subject: Re: [00/17] Large Blocksize Support V3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <4632A6DF.7080301@yahoo.com.au>
References: <20070426190438.3a856220.akpm@linux-foundation.org>
	 <20070427022731.GF65285596@melbourne.sgi.com>
	 <20070426195357.597ffd7e.akpm@linux-foundation.org>
	 <20070427042046.GI65285596@melbourne.sgi.com>
	 <20070426221528.655d79cb.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
	 <20070426235542.bad7035a.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>
	 <20070427002640.22a71d06.akpm@linux-foundation.org>
	 <20070427163620.GI32602149@melbourne.sgi.com>
	 <20070427173432.GJ32602149@melbourne.sgi.com>
	 <20070427121108.9ee05710.akpm@linux-foundation.org>
	 <4632A6DF.7080301@yahoo.com.au>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 10:04:08 +0200
Message-Id: <1177747448.28223.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 11:43 +1000, Nick Piggin wrote:
> Andrew Morton wrote:

> > For example, see __do_page_cache_readahead().  It does a read_lock() and a
> > page allocation and a radix-tree lookup for each page.  We can vastly
> > improve that.
> > 
> > Step 1:
> > 
> > - do a read-lock
> > 
> > - do a radix-tree walk to work out how many pages are missing
> > 
> > - read-unlock
> > 
> > - allocate that many pages
> > 
> > - read_lock()
> > 
> > - populate all the pages.
> > 
> > - read_unlock
> > 
> > - if any pages are left over, free them
> > 
> > - if we ended up not having enough pages, redo the whole thing.
> > 
> > that will reduce the number of read_lock()s, read_unlock()s and radix-tree
> > descents by a factor of 32 or so in this testcase.  That's a lot, and it's
> > something we (Nick ;)) should have done ages ago.
> 
> We can do pretty well with the lockless radix tree (that is already upstream)
> there. I split that stuff out of my most recent lockless pagecache patchset,
> because it doesn't require the "scary" speculative refcount stuff of the
> lockless pagecache proper. Subject: [patch 5/9] mm: lockless probe.
> 
> So that is something we could merge pretty soon.
> 
> The other thing is that we can batch up pagecache page insertions for bulk
> writes as well (that is. write(2) with buffer size > page size). I should
> have a patch somewhere for that as well if anyone interested.

Together with the optimistic locking from my concurrent pagecache that
should bring most of the gains:

sequential insert of 8388608 items:

CONFIG_RADIX_TREE_CONCURRENT=n

[ffff81007d7f60c0] insert 0 done in 15286 ms

CONFIG_RADIX_TREE_OPTIMISTIC=y

[ffff81006b36e040] insert 0 done in 3443 ms

only 4.4 times faster, and more scalable, since we don't bounce the
upper level locks around.

