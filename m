Return-Path: <linux-kernel-owner+w=401wt.eu-S1762065AbXGPA1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762065AbXGPA1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbXGPA1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:27:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57833 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755439AbXGPA1Z (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:27:25 -0400
Date: Mon, 16 Jul 2007 10:27:07 +1000
From: David Chinner <dgc@sgi.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: David Chinner <dgc@sgi.com>, Dave Hansen <haveblue@us.ibm.com>,
       linux-kernel@vger.kernel.org, David Kleikamp <shaggy@us.ibm.com>
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070716002707.GR31489@sgi.com>
References: <20070706222651.GG5777@v2.random> <20070708232031.GF12413810@sgi.com> <20070710101148.GJ1482@v2.random> <20070712001256.GI31489@sgi.com> <20070712111436.GG28613@v2.random> <20070712144449.GZ31489@sgi.com> <20070712163123.GL28613@v2.random> <1184258097.26210.75.camel@localhost> <20070713071308.GL31489@sgi.com> <20070713143109.GC2571@v2.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713143109.GC2571@v2.random>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 04:31:09PM +0200, Andrea Arcangeli wrote:
> On Fri, Jul 13, 2007 at 05:13:08PM +1000, David Chinner wrote:
> > Sure. Fundamentally, though, I think it is the wrong approach to
> > take - it's a workaround for a big negative side effect of
> > increasing page size. It introduces lots of complexity and
> > difficult-to-test corner cases; judging by the tail packing problems
> > reiser3 has had over the years, it has the potential to be a
> > never-ending source of data corruption bugs.
> > 
> > I think that fine granularity and aggregation for efficiency of
> > scale is a better model to use than increasing the base page size.
> > With PPC, you can handle different page sizes in the hardware (like
> > MIPS) and the use of 64k base page size is an obvious workaround to
> > the problem of not being able to use multiple page sizes within the
> > OS.
> 
> I think you're being too fs centric. Moving only the pagecache to a
> large order is enough to you but it isn't enough to me, I'd like all
> allocations to be faster, and I'd like to reduce the page fault
> rate.

Right, and that is done on other operating systems by supporting
multiple hardware page sizes and telling the relevant applications to
use larger pages (e.g. via cpuset configuration).

> The CONFIG_PAGE_SHIFT isn't just about I/O. It's just that
> CONFIG_PAGE_SHIFT will give you the I/O side for free too.

It's not for free, and that's one of the points I've been trying
to make.

> Also keep in mind mixing multiple page sizes for different inodes has
> the potential to screw the aging algorithms in the reclaim code. Just
> to make an example during real random I/O over all bits of hot cache
> in pagecache, a 64k page has 16 times more probability of being marked
> young than a 4k page.

Sure, but if a page is being hit repeatedly - regardless of it's
size - then you want to keep it around....

> The tail packing of pagecache could very well be worth it. It should
> cost nothing for the large files.

As I've said before - I'm not just concerned with large files - I'm
also concerned about large numbers of files (hundreds of millions to
billions in a filesystem) and the scalability issues involved with
them. IOWs, I'm looking at metadata scalability as much as data
scalability.

It's flexibility that I need from the VM, not pure VM efficiency.
Shifting the base page size is not an efficient solution to the
different aspects of filesystem scalability. We've got to deal with
both ends of the spectrum simultaneously on the one machine in the
same filesystem and it's only going to get worse in the future.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
