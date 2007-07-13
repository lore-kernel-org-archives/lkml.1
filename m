Return-Path: <linux-kernel-owner+w=401wt.eu-S932740AbXGMObZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbXGMObZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 10:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759744AbXGMObQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 10:31:16 -0400
Received: from ns1.suse.de ([195.135.220.2]:54121 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452AbXGMObQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 10:31:16 -0400
Date: Fri, 13 Jul 2007 16:31:09 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: David Chinner <dgc@sgi.com>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       David Kleikamp <shaggy@us.ibm.com>
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070713143109.GC2571@v2.random>
References: <20070706222651.GG5777@v2.random> <20070708232031.GF12413810@sgi.com> <20070710101148.GJ1482@v2.random> <20070712001256.GI31489@sgi.com> <20070712111436.GG28613@v2.random> <20070712144449.GZ31489@sgi.com> <20070712163123.GL28613@v2.random> <1184258097.26210.75.camel@localhost> <20070713071308.GL31489@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713071308.GL31489@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 05:13:08PM +1000, David Chinner wrote:
> Sure. Fundamentally, though, I think it is the wrong approach to
> take - it's a workaround for a big negative side effect of
> increasing page size. It introduces lots of complexity and
> difficult-to-test corner cases; judging by the tail packing problems
> reiser3 has had over the years, it has the potential to be a
> never-ending source of data corruption bugs.
> 
> I think that fine granularity and aggregation for efficiency of
> scale is a better model to use than increasing the base page size.
> With PPC, you can handle different page sizes in the hardware (like
> MIPS) and the use of 64k base page size is an obvious workaround to
> the problem of not being able to use multiple page sizes within the
> OS.

I think you're being too fs centric. Moving only the pagecache to a
large order is enough to you but it isn't enough to me, I'd like all
allocations to be faster, and I'd like to reduce the page fault
rate. The CONFIG_PAGE_SHIFT isn't just about I/O. It's just that
CONFIG_PAGE_SHIFT will give you the I/O side for free too.

Also keep in mind mixing multiple page sizes for different inodes has
the potential to screw the aging algorithms in the reclaim code. Just
to make an example during real random I/O over all bits of hot cache
in pagecache, a 64k page has 16 times more probability of being marked
young than a 4k page.

The tail packing of pagecache could very well be worth it. It should
cost nothing for the large files.

> Adding a workaround (tail packing) to address the negative side
> effects of another workaround (64k base page size) ignores the basic
> problem that has led to both these things being done: Linux does not
> support multiple page sizes natively.....

I understand you mean multiple page size in pagecache, but I see it as
a feature to keep the fast paths as fast as they can be.
