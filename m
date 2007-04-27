Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbXD0CFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbXD0CFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 22:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbXD0CFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 22:05:25 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753996AbXD0CFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 22:05:23 -0400
Date: Thu, 26 Apr 2007 19:04:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-Id: <20070426190438.3a856220.akpm@linux-foundation.org>
In-Reply-To: <20070424222105.883597089@sgi.com>
References: <20070424222105.883597089@sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 15:21:05 -0700 clameter@sgi.com wrote:

> This patchset modifies the Linux kernel so that larger block sizes than
> page size can be supported. Larger block sizes are handled by using
> compound pages of an arbitrary order for the page cache instead of
> single pages with order 0.

Something I was looking for but couldn't find: suppose an application takes
a pagefault against the third 4k page of an order-2 pagecache "page".  We
need to instantiate a pte against find_get_page(offset/4)+3.  But these
patches don't touch mm/memory.c at all and filemap_nopage() appears to
return the zeroeth 4k page all the time in that case.

So.. what am I missing, and how does that part work?



Also, afaict your important requirements would be met by retaining
PAGE_CACHE_SIZE=4k and simply ensuring that pagecache is populated by
physically contiguous pages - so instead of allocating and adding one 4k
page, we allocate an order-2 page and sprinkle all four page*'s into the
radix tree in one hit.  That should be fairly straightforward to do, and
could be made indistinguishably fast from doing a single 16k page for some
common pagecache operations (gang-insert, gang-lookup).

The BIO and block layers will do-the-right-thing with that pagecache and
you end up with four times more data in the SG lists, worst-case.
