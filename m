Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbXEVBjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbXEVBjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 21:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757344AbXEVBjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 21:39:07 -0400
Received: from holomorphy.com ([66.93.40.71]:52374 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757230AbXEVBjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 21:39:05 -0400
Date: Mon, 21 May 2007 18:39:51 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-ID: <20070522013951.GP19966@holomorphy.com>
References: <20070518040854.GA15654@wotan.suse.de> <Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com> <20070519012530.GB15569@wotan.suse.de> <20070519181501.GC19966@holomorphy.com> <20070520052229.GA9372@wotan.suse.de> <20070520084647.GF19966@holomorphy.com> <20070520092552.GA7318@wotan.suse.de> <20070521080813.GQ31925@holomorphy.com> <20070521092742.GA19642@wotan.suse.de> <20070521224316.GC11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521224316.GC11166@waste.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 11:27:42AM +0200, Nick Piggin wrote:
>> ... yeah, something like that would bypass 

On Mon, May 21, 2007 at 05:43:16PM -0500, Matt Mackall wrote:
> As long as we're throwing out crazy unpopular ideas, try this one:
> Divide struct page in two such that all the most commonly used
> elements are in one piece that's nicely sized and the rest are in
> another. Have two parallel arrays containing these pieces and accessor
> functions around the unpopular bits.
> Whether a sensible divide between popular and unpopular bits isn't
> clear to me. But hey, I said it was crazy.

I have a crazier and even less popular idea. Eliminate struct page
entirely as an accounting structure (and, of course, mem_map with it).
Filesystems can keep the per-page metadata they need in their own
accounting structures, slab mutatis mutandis, etc. The brilliant bit
here is that devolving the accounting structures this way allows the
fs and/or subsystem to arrange for strong cache locality, file offset
adjacency to imply memory adjacency of the page accounting fields,
etc., where grabbing random structures out of some array is a real
cache thrasher.

The page allocation and page replacement algorithms would have to be
adjusted, and things would have to allocate their own refcounts,
supposing they want/need refcounts, but it's not so far out. Refer to
filesystem pages by <mapping, index> pairs, refer to slab pages by
address (virtual and physical are trivially inter-convertible), mock
up something akin to what filesystems do for anonymous pages, etc.

The real objection everyone's going to have is that driver writers
will stain their shorts when faced with the rules for handling such
things. The thing is, I'm not entirely sure who these driver writers
that would have such trouble are, since the driver writers I know
personally are sophisticates rather than walking disaster areas as such
would imply. I suppose they may not be representative of the whole.


-- wli

P.S. This idea is not plucked out of the air; it has precedents. A
number of microkernels do this, and IIRC k42 does so also.
