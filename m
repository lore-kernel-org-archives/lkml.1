Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYESFqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYESFqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 01:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYESFq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 01:46:28 -0400
Received: from relay2.sgi.com ([192.48.171.30]:35124 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752584AbYESFq0 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 01:46:26 -0400
Date: Mon, 19 May 2008 15:45:54 +1000
From: David Chinner <dgc@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: David Chinner <dgc@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
Message-ID: <20080519054554.GY103491721@sgi.com>
References: <20080510030831.796641881@sgi.com> <20080510030916.935905242@sgi.com> <20080512002403.GP103491721@sgi.com> <Pine.LNX.4.64.0805151041230.18708@schroedinger.engr.sgi.com> <20080515231045.GY155679365@sgi.com> <Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 10:01:38AM -0700, Christoph Lameter wrote:
> On Fri, 16 May 2008, David Chinner wrote:
> 
> > On Thu, May 15, 2008 at 10:42:15AM -0700, Christoph Lameter wrote:
> > > On Mon, 12 May 2008, David Chinner wrote:
> > > 
> > > > If you are going to clean bufferheads (or pages), please clean entire
> > > > mappings via ->writepages as it leads to far superior I/O patterns
> > > > and a far higher aggregate rate of page cleaning.....
> > > 
> > > That brings up another issue: Lets say I use writepages on a large file 
> > > (couple of gig). How much do you want to write back?
> > 
> > We're out of memory. I'd suggest write backing as much as you can
> > without blocking.  e.g. treat it like pdflush and say 1024 pages, or
> > like balance_dirty_pages() and write a 'write_chunk' back from the
> > mapping (i.e.  sync_writeback_pages()).
> 
> Why are we out of memory?

Defragmentation is triggered as part of the usual memory reclaim
process. Which implies we've run out of free memory, correct?

> How do you trigger such a special writeout?

filemap_fdatawrite_range() perhaps?

> > Any of these are better from an I/O perspective than single page
> > writeback....
> 
> But then filesystem can do tricks like writing out the surrounding areas 
> as needed. The filesystem likely can estimate better how much writeout 
> makes sense.

Pushing write-around into a method that is only supposed to write
the single page that is passed to it is a pretty bad abuse of the
API. Especially as we have many simple, ranged writeback methods
you could call. filemap_fdatawrite_range(), do_writepages(),
->writepages, etc.

FWIW, look at the mess of layering violations that write clustering
causes in XFS because we have to do this to keep allocation overhead
and fragmentation down to a minimum. It's a nasty hack to mitigate
the impact of the awful I/O patterns we see from the VM - suggesting
that all filesystems do this just so you don't have to call a
slightly smarter writeback primitive is insane....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
