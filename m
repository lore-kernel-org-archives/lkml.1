Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab0BDAeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 19:34:16 -0500
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:43150 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933009Ab0BDAeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 19:34:14 -0500
Date: Thu, 4 Feb 2010 11:34:10 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, tytso@mit.edu,
       Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
Message-ID: <20100204003410.GD5332@discord.disaster>
References: <20100129204931.789743493@quilx.com> <20100129205004.405949705@quilx.com> <20100130192623.GE788@thunk.org> <20100131083409.GF29555@one.firstfloor.org> <20100131135933.GM15853@discord.disaster> <alpine.DEB.2.00.1002030920500.5671@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002030920500.5671@router.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 09:31:49AM -0600, Christoph Lameter wrote:
> On Mon, 1 Feb 2010, Dave Chinner wrote:
> 
> > > The standard case is the classic updatedb. Lots of dentries/inodes cached
> > > with no or little corresponding data cache.
> >
> > I don't believe that updatedb has anything to do with causing
> > internal inode/dentry slab fragmentation. In all my testing I rarely
> > see use-once filesystem traversals cause internal slab
> > fragmentation. This appears to be a result of use-once filesystem
> > traversal resulting in slab pages full of objects that have the same
> > locality of access.  Hence each new slab page that traversal
> > allocates will contain objects that will be adjacent in the LRU.
> > Hence LRU-based reclaim is very likely to free all the objects on
> > each page in the same pass and as such no fragmentation will occur.
> 
> updatedb causes lots of partially allocated slab pages. While updatedb
> runs other filesystem activities occur. And updatedb does not work in
> straightforward linear fashion. dentries are cached and slowly expired etc
> etc.

Sure, but my point was that updatedb hits lots of inodes only once,
and for those objects the order of caching and expiration are
exactly the same. Hence after reclaim of the updatedb dentries/inodes
the amount of fragmentation in the slab will be almost exactly the
same as it was before the updatedb run.

> > All the cases of inode/dentry slab fragmentation I have seen are a
> > result of access patterns that result in slab pages containing
> > objects with different temporal localities. It's when the access
> > pattern is sufficiently distributed throughout the working set we
> > get the "need to free 95% of the objects in the entire cache to free
> > a single page" type of reclaim behaviour.
> 
> There are also other factors at play like the different NUMA node,
> concurrent processes.

Yes, those are just more factors in the access patterns being
"sufficiently distributed throughout the working set".

> > AFAICT, the defrag patches as they stand don't really address the
> > fundamental problem of differing temporal locality inside a slab
> > page.  It makes the assumption that "partial page == defrag
> > candidate" but there isn't any further consideration of when any of
> > the remaing objects were last accessed. I think that this really
> > does need to be taken into account, especially considering that the
> > allocator tries to fill partial pages with new objects before
> > allocating new pages and so the page under reclaim might contain
> > very recently allocated objects.
> 
> Reclaim is only run if there is memory pressure. This means that lots of
> reclaimable entities exist and therefore we can assume that many of these
> have had a somewhat long lifetime. The allocator tries to fill partial
> pages with new objects and then retires those pages to the full slab list.
> Those are not subject to reclaim efforts covered here. A page under
> reclaim is likely to contain many recently freed objects.

Not necessarily. It might contain only one recently reclaimed object,
but have several other hot objects in the page....

> The remaining objects may have a long lifetime and a high usage pattern
> but it is worth to relocate them into other slabs if they prevent reclaim
> of the page.

I completely disagree. If you have to trash all the cache hot
information related to the cached object in the process of
relocating it, then you've just screwed up application performance
and in a completely unpredictable manner. Admins will be tearing out
their hair trying to work out why their applications randomly slow
down....

> > Someone in a previous discussion on this patch set (Nick? Hugh,
> > maybe? I can't find the reference right now) mentioned something
> > like this about the design of the force-reclaim operations. IIRC the
> > suggestion was that it may be better to track LRU-ness by per-slab
> > page rather than per-object so that reclaim can target the slab
> > pages that - on aggregate - had the oldest objects in it. I think
> > this has merit - prevention of internal fragmentation seems like a
> > better approach to me than to try to cure it after it is already
> > present....
> 
> LRUness exists in terms of the list of partial slab pages. Frequently
> allocated slabs are in the front of the queue and less used slabs are in
> the rear. Defrag/reclaim occurs from the rear.

You missed my point again. You're still talking about tracking pages
with no regard to the objects remaining in the pages. A page, full
or partial, is a candidate for object reclaim if none of the objects
on it are referenced and have not been referenced for some time.

You are currently relying on the existing LRU reclaim to move a slab
from full to partial to trigger defragmentation, but you ignore the
hotness of the rest of the objects on the page by trying to reclaim
the page that has been partial for the longest period of time.

What it comes down to is that the slab has two states for objects -
allocated and free - but what we really need here is 3 states -
allocated, unused and freed. We currently track unused objects
outside the slab in LRU lists and, IMO, that is the source of our
fragmentation problems because it has no knowledge of the spatial
layout of the slabs and the state of other objects in the page.

What I'm suggesting is that we ditch the external LRUs and track the
"unused" state inside the slab and then use that knowledge to decide
which pages to reclaim.  e.g. slab_object_used() is called when the
first reference on an object is taken. slab_object_unused() is
called when the reference count goes to zero. The slab can then
track unused objects internally and when reclaim is needed can
select pages (full or partial) that only contain unused objects to
reclaim.

>From there the existing reclaim algorithms could be used to reclaim
the objects. i.e. the shrinkers become a slab reclaim callout that
are passed a linked list of objects to reclaim, very similar to the
way __shrink_dcache_sb() and prune_icache() first build a list of
objects to reclaim, then work off that list of objects.

If the goal is to reduce fragmentation, then this seems like a
much better approach to me - it is inherently fragmentation
resistent and much more closely aligned to existing object reclaim
algorithms.

If the goal is random slab page shootdown (e.g. for hwpoison), then
it's a much more complex problem because you can't shoot down
active, referenced objects without revoke(). Hence I think the
two problem spaces should be kept separate as it's not obvious
that they can both be solved with the same mechanism....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
