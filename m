Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbXIPSN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbXIPSN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 14:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbXIPSNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 14:13:17 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43752 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbXIPSNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 14:13:16 -0400
Date: Sun, 16 Sep 2007 19:13:13 +0100
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joern Engel <joern@logfs.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070916181313.GA16406@skynet.ie>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ir6c3z2l.fsf@informatik.uni-tuebingen.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (15/09/07 14:14), Goswin von Brederlow didst pronounce:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Tue, 11 Sep 2007 14:12:26 +0200 Jörn Engel <joern@logfs.org> wrote:
> >
> >> While I agree with your concern, those numbers are quite silly.  The
> >> chances of 99.8% of pages being free and the remaining 0.2% being
> >> perfectly spread across all 2MB large_pages are lower than those of SHA1
> >> creating a collision.
> >
> > Actually it'd be pretty easy to craft an application which allocates seven
> > pages for pagecache, then one for <something>, then seven for pagecache, then
> > one for <something>, etc.
> >
> > I've had test apps which do that sort of thing accidentally.  The result
> > wasn't pretty.
> 
> Except that the applications 7 pages are movable and the <something>
> would have to be unmovable. And then they should not share the same
> memory region. At least they should never be allowed to interleave in
> such a pattern on a larger scale.
> 

It is actually really easy to force regions to never share. At the
moment, there is a fallback list that determines a preference for what
block to mix.

The reason why this isn't enforced is the cost of moving. On x86 and
x86_64, a block of interest is usually 2MB or 4MB. Clearing out one of
those pages to prevent any mixing would be bad enough. On PowerPC, it's
potentially 16MB. On IA64, it's 1GB.

As this was fragmentation avoidance, not guarantees, the decision was
made to not strictly enforce the types of pages within a block as the
cost cannot be made back unless the system was making agressive use of
large pages. This is not the case with Linux.

> The only way a fragmentation catastroph can be (proovable) avoided is
> by having so few unmovable objects that size + max waste << ram
> size. The smaller the better. Allowing movable and unmovable objects
> to mix means that max waste goes way up. In your example waste would
> be 7*size. With 2MB uper order limit it would be 511*size.
> 
> I keep coming back to the fact that movable objects should be moved
> out of the way for unmovable ones. Anything else just allows
> fragmentation to build up.
> 

This is easily achieved, just really really expensive because of the
amount of copying that would have to take place. It would also compel
that min_free_kbytes be at least one free PAGEBLOCK_NR_PAGES and likely
MIGRATE_TYPES * PAGEBLOCK_NR_PAGES to reduce excessive copying. That is
a lot of free memory to keep around which is why fragmentation avoidance
doesn't do it.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
