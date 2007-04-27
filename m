Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbXD0Cya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbXD0Cya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 22:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbXD0Cya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 22:54:30 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989AbXD0Cy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 22:54:28 -0400
Date: Thu, 26 Apr 2007 19:53:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Chinner <dgc@sgi.com>
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-Id: <20070426195357.597ffd7e.akpm@linux-foundation.org>
In-Reply-To: <20070427022731.GF65285596@melbourne.sgi.com>
References: <20070424222105.883597089@sgi.com>
	<20070426190438.3a856220.akpm@linux-foundation.org>
	<20070427022731.GF65285596@melbourne.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 12:27:31 +1000 David Chinner <dgc@sgi.com> wrote:

> On Thu, Apr 26, 2007 at 07:04:38PM -0700, Andrew Morton wrote:
> > On Tue, 24 Apr 2007 15:21:05 -0700 clameter@sgi.com wrote:
> > 
> > > This patchset modifies the Linux kernel so that larger block sizes than
> > > page size can be supported. Larger block sizes are handled by using
> > > compound pages of an arbitrary order for the page cache instead of
> > > single pages with order 0.
> > 
> > Something I was looking for but couldn't find: suppose an application takes
> > a pagefault against the third 4k page of an order-2 pagecache "page".  We
> > need to instantiate a pte against find_get_page(offset/4)+3.  But these
> > patches don't touch mm/memory.c at all and filemap_nopage() appears to
> > return the zeroeth 4k page all the time in that case.
> > 
> > So.. what am I missing, and how does that part work?
> 
> "mmap not supported yet" ;)

erk.  I suspect this will have its sticky paws all over core mm.


> > Also, afaict your important requirements would be met by retaining
> > PAGE_CACHE_SIZE=4k and simply ensuring that pagecache is populated by
> > physically contiguous pages
> 
> Sure, that addresses the larger I/O side of things, but it doesn't address
> the large filesystem blocksize issues that can only be solved with some kind
> of page aggregation abstraction.

a) That wasn't a part of Christoph's original rationale list, so forgive
   me for thinking it is not so important and got snuck in post-facto when
   things got tough.

b) I don't immediately see why a filesystam cannot implement larger
   blocksizes via this scheme - instantiate and lock four pages and go for
   it.

> Compound pages and high order page cache
> indexing solves this extremely neatly, regardless of whether the compound
> page is contiguous or not.....

We cannot say anything about neatness until we've seen mmap.
