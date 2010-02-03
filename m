Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab0BCPdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:33:46 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:33044 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab0BCPdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:33:43 -0500
Date: Wed, 3 Feb 2010 09:31:49 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Dave Chinner <david@fromorbit.com>
cc: Andi Kleen <andi@firstfloor.org>, tytso@mit.edu,
       Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
In-Reply-To: <20100131135933.GM15853@discord.disaster>
Message-ID: <alpine.DEB.2.00.1002030920500.5671@router.home>
References: <20100129204931.789743493@quilx.com> <20100129205004.405949705@quilx.com> <20100130192623.GE788@thunk.org> <20100131083409.GF29555@one.firstfloor.org> <20100131135933.GM15853@discord.disaster>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Feb 2010, Dave Chinner wrote:

> > The standard case is the classic updatedb. Lots of dentries/inodes cached
> > with no or little corresponding data cache.
>
> I don't believe that updatedb has anything to do with causing
> internal inode/dentry slab fragmentation. In all my testing I rarely
> see use-once filesystem traversals cause internal slab
> fragmentation. This appears to be a result of use-once filesystem
> traversal resulting in slab pages full of objects that have the same
> locality of access.  Hence each new slab page that traversal
> allocates will contain objects that will be adjacent in the LRU.
> Hence LRU-based reclaim is very likely to free all the objects on
> each page in the same pass and as such no fragmentation will occur.

updatedb causes lots of partially allocated slab pages. While updatedb
runs other filesystem activities occur. And updatedb does not work in
straightforward linear fashion. dentries are cached and slowly expired etc
etc. Updatedb may not cause the fragmentation on a level that you observed
with some of the filesystem loads on large systems.

> All the cases of inode/dentry slab fragmentation I have seen are a
> result of access patterns that result in slab pages containing
> objects with different temporal localities. It's when the access
> pattern is sufficiently distributed throughout the working set we
> get the "need to free 95% of the objects in the entire cache to free
> a single page" type of reclaim behaviour.

There are also other factors at play like the different NUMA node,
concurrent processes. A strict optimized HPC workload may be able to
eliminate other factors but that is not the case for typical workloads.
Access patterns are typically somewhat distribyted.

> AFAICT, the defrag patches as they stand don't really address the
> fundamental problem of differing temporal locality inside a slab
> page.  It makes the assumption that "partial page == defrag
> candidate" but there isn't any further consideration of when any of
> the remaing objects were last accessed. I think that this really
> does need to be taken into account, especially considering that the
> allocator tries to fill partial pages with new objects before
> allocating new pages and so the page under reclaim might contain
> very recently allocated objects.

Reclaim is only run if there is memory pressure. This means that lots of
reclaimable entities exist and therefore we can assume that many of these
have had a somewhat long lifetime. The allocator tries to fill partial
pages with new objects and then retires those pages to the full slab list.
Those are not subject to reclaim efforts covered here. A page under
reclaim is likely to contain many recently freed objects.

The remaining objects may have a long lifetime and a high usage pattern
but it is worth to relocate them into other slabs if they prevent reclaim
of the page. Relocation occurs in this patchset by reclaim and then the
next use likely causes the reallocation in a partially allocated slab.
This means that objects with a high usage count will tend to be aggregated
in full slabs that are no longer subject to targeted reclaim.

We could improve the situation by allowing the moving of objects (which
would avoid the reclaim and realloc) but that is complex and so needs to
be deferred to a second stage (same approach we went through with page
migration).

> Someone in a previous discussion on this patch set (Nick? Hugh,
> maybe? I can't find the reference right now) mentioned something
> like this about the design of the force-reclaim operations. IIRC the
> suggestion was that it may be better to track LRU-ness by per-slab
> page rather than per-object so that reclaim can target the slab
> pages that - on aggregate - had the oldest objects in it. I think
> this has merit - prevention of internal fragmentation seems like a
> better approach to me than to try to cure it after it is already
> present....

LRUness exists in terms of the list of partial slab pages. Frequently
allocated slabs are in the front of the queue and less used slabs are in
the rear. Defrag/reclaim occurs from the rear.

